-- Oxireun UI Library - Slow RGB Border, Purple Theme
-- Kompakt versiyon - Remote Logger Detection (Buttons Fixed & Notifications Working)

local OxireunUI = {}
OxireunUI.__index = OxireunUI

-- Mor temalı renk paleti
local Colors = {
    Background = Color3.fromRGB(30, 20, 50),
    SecondaryBg = Color3.fromRGB(40, 30, 70),
    SectionBg = Color3.fromRGB(35, 25, 65),
    Border = Color3.fromRGB(150, 50, 200),
    Accent = Color3.fromRGB(180, 70, 220),
    Text = Color3.fromRGB(255, 255, 255),
    Disabled = Color3.fromRGB(120, 100, 160),
    Hover = Color3.fromRGB(150, 50, 200, 0.3),
    Button = Color3.fromRGB(60, 40, 100),
    Slider = Color3.fromRGB(150, 50, 200),
    ToggleOn = Color3.fromRGB(150, 50, 200),
    ToggleOff = Color3.fromRGB(80, 60, 120),
    TabActive = Color3.fromRGB(150, 50, 200),
    TabInactive = Color3.fromRGB(60, 40, 100),
    ControlButton = Color3.fromRGB(70, 50, 110),
    CloseButton = Color3.fromRGB(180, 60, 60)
}

-- RGB renkleri (YAVAŞ animasyon için)
local RGBColors = {
    Color3.fromRGB(180, 50, 220),
    Color3.fromRGB(150, 50, 200),
    Color3.fromRGB(200, 60, 230),
    Color3.fromRGB(170, 40, 210),
    Color3.fromRGB(190, 70, 240),
    Color3.fromRGB(160, 30, 190)
}

-- Font ayarları
local Fonts = {
    Title = Enum.Font.SciFi,
    Normal = Enum.Font.Gotham,
    Tab = Enum.Font.Gotham,
    Button = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold
}

-- KOMPAKT UI BOYUTLARI
local UI_SIZE = {
    Width = 260,
    Height = 280
}

-- Element boyutları
local ELEMENT_SIZES = {
    TitleBar = 30,
    TabHeight = 25,
    ButtonHeight = 32,
    SliderHeight = 45,
    ToggleHeight = 32,
    TextboxHeight = 32,
    DropdownHeight = 32,
    SectionSpacing = 6
}

-- NOTIFICATION SİSTEMİ (GÜVENLI)
function OxireunUI:SendNotification(title, text, duration)
    local success, err = pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = title or "Oxireun UI";
            Text = text or "Notification";
            Duration = duration or 3;
        })
    end)
    if not success then
        print("Notification hatası:", err)
    end
end

-- Ana Library fonksiyonu
function OxireunUI.new()
    local self = setmetatable({}, OxireunUI)
    self.Windows = {}
    return self
end

-- Yeni pencere oluşturma
function OxireunUI:NewWindow(title)
    -- Önce eski UI'ı temizle
    if game.CoreGui:FindFirstChild("OxireunUI") then
        game.CoreGui:FindFirstChild("OxireunUI"):Destroy()
    end

    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("OxireunUI") then  
        game.Players.LocalPlayer.PlayerGui:FindFirstChild("OxireunUI"):Destroy()  
    end  
  
    local Window = {}  
    Window.Title = title or "Oxireun UI"  
    Window.Sections = {}  
    Window.CurrentSection = nil
    Window.ActiveConnections = {} 
    Window.AllToggles = {} 
  
    -- Ana ekran  
    local ScreenGui = Instance.new("ScreenGui")  
    ScreenGui.Name = "OxireunUI"  
    ScreenGui.ResetOnSpawn = false  
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling  
  
    -- Ana pencere  
    local MainFrame = Instance.new("Frame")  
    MainFrame.Name = "MainWindow"  
    MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)  
    MainFrame.Position = UDim2.new(0, 10, 0.5, -UI_SIZE.Height/2)  
    MainFrame.BackgroundColor3 = Colors.Background  
    MainFrame.BorderSizePixel = 0  
    MainFrame.ClipsDescendants = true  
    MainFrame.Active = true  
    MainFrame.Parent = ScreenGui  
  
    local corner = Instance.new("UICorner")  
    corner.CornerRadius = UDim.new(0, 8)  
    corner.Parent = MainFrame  
  
    -- YAVAŞ ANİMASYONLU RGB BORDER  
    local rgbBorder = Instance.new("UIStroke")  
    rgbBorder.Name = "RGBBorder"  
    rgbBorder.Color = RGBColors[1]  
    rgbBorder.Thickness = 2  
    rgbBorder.Transparency = 0  
    rgbBorder.Parent = MainFrame  
  
    -- YAVAŞ RGB animasyonu  
    local colorIndex = 1  
    local rgbConnection  
    rgbConnection = game:GetService("RunService").Heartbeat:Connect(function()  
        if not MainFrame.Parent then return end
        colorIndex = colorIndex + 0.008  
        if colorIndex > #RGBColors then  
            colorIndex = 1  
        end  
        local currentColor = RGBColors[math.floor(colorIndex)]  
        local nextColor = RGBColors[math.floor(colorIndex) % #RGBColors + 1]  
        local lerpFactor = colorIndex - math.floor(colorIndex)  
        rgbBorder.Color = currentColor:Lerp(nextColor, lerpFactor)  
    end)
    table.insert(Window.ActiveConnections, rgbConnection)
  
    -- Başlık çubuğu  
    local TitleBar = Instance.new("Frame")  
    TitleBar.Name = "TitleBar"  
    TitleBar.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.TitleBar)  
    TitleBar.BackgroundColor3 = Colors.SecondaryBg  
    TitleBar.BorderSizePixel = 0  
    TitleBar.Parent = MainFrame  
  
    local titleCorner = Instance.new("UICorner")  
    titleCorner.CornerRadius = UDim.new(0, 8, 0, 0)  
    titleCorner.Parent = TitleBar  
  
    -- Başlık  
    local TitleLabel = Instance.new("TextLabel")  
    TitleLabel.Name = "Title"  
    TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)  
    TitleLabel.Position = UDim2.new(0, 8, 0, 0)  
    TitleLabel.BackgroundTransparency = 1  
    TitleLabel.Text = Window.Title  
    TitleLabel.TextColor3 = Colors.Text  
    TitleLabel.TextSize = 14  
    TitleLabel.Font = Fonts.Bold  
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left  
    TitleLabel.Parent = TitleBar  
  
    -- Kontrol butonları  
    local Controls = Instance.new("Frame")  
    Controls.Name = "Controls"  
    Controls.Size = UDim2.new(0, 40, 1, 0)  
    Controls.Position = UDim2.new(1, -45, 0, 0)  
    Controls.BackgroundTransparency = 1  
    Controls.Parent = TitleBar  
  
    -- Küçültme butonu  
    local MinimizeButton = Instance.new("TextButton")  
    MinimizeButton.Name = "Minimize"  
    MinimizeButton.Size = UDim2.new(0, 18, 0, 18)  
    MinimizeButton.Position = UDim2.new(0, 0, 0.5, -9)  
    MinimizeButton.BackgroundColor3 = Colors.ControlButton  
    MinimizeButton.Text = "-"  
    MinimizeButton.TextColor3 = Colors.Text  
    MinimizeButton.TextSize = 16  
    MinimizeButton.Font = Fonts.Bold  
    MinimizeButton.AutoButtonColor = false  
    MinimizeButton.ZIndex = 10
    MinimizeButton.Parent = Controls  
  
    local minimizeCorner = Instance.new("UICorner")  
    minimizeCorner.CornerRadius = UDim.new(1, 0)  
    minimizeCorner.Parent = MinimizeButton  
  
    -- Kapatma butonu  
    local CloseButton = Instance.new("TextButton")  
    CloseButton.Name = "Close"  
    CloseButton.Size = UDim2.new(0, 18, 0, 18)  
    CloseButton.Position = UDim2.new(0, 22, 0.5, -9)  
    CloseButton.BackgroundColor3 = Colors.CloseButton  
    CloseButton.Text = ">"  
    CloseButton.TextColor3 = Colors.Text  
    CloseButton.TextSize = 14  
    CloseButton.Font = Fonts.Bold  
    CloseButton.AutoButtonColor = false  
    CloseButton.ZIndex = 10
    CloseButton.Parent = Controls  
  
    local closeCorner = Instance.new("UICorner")  
    closeCorner.CornerRadius = UDim.new(1, 0)  
    closeCorner.Parent = CloseButton  
  
    -- Tab'ler  
    local TabsScrollFrame = Instance.new("ScrollingFrame")  
    TabsScrollFrame.Name = "TabsScroll"  
    TabsScrollFrame.Size = UDim2.new(1, -16, 0, ELEMENT_SIZES.TabHeight)  
    TabsScrollFrame.Position = UDim2.new(0, 8, 0, ELEMENT_SIZES.TitleBar + 5)  
    TabsScrollFrame.BackgroundTransparency = 1  
    TabsScrollFrame.BorderSizePixel = 0  
    TabsScrollFrame.ScrollBarThickness = 3  
    TabsScrollFrame.ScrollBarImageColor3 = Colors.Border  
    TabsScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.X  
    TabsScrollFrame.ScrollingDirection = Enum.ScrollingDirection.X  
    TabsScrollFrame.Parent = MainFrame  
  
    local TabsContainer = Instance.new("Frame")  
    TabsContainer.Name = "TabsContainer"  
    TabsContainer.Size = UDim2.new(0, 0, 1, 0)  
    TabsContainer.BackgroundTransparency = 1  
    TabsContainer.Parent = TabsScrollFrame  
  
    local TabsList = Instance.new("UIListLayout")  
    TabsList.FillDirection = Enum.FillDirection.Horizontal  
    TabsList.Padding = UDim.new(0, 4)  
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder  
    TabsList.Parent = TabsContainer  
  
    -- İçerik alanı  
    local ContentArea = Instance.new("Frame")  
    ContentArea.Name = "ContentArea"  
    ContentArea.Size = UDim2.new(1, -16, 1, - (ELEMENT_SIZES.TitleBar + ELEMENT_SIZES.TabHeight + 15))  
    ContentArea.Position = UDim2.new(0, 8, 0, ELEMENT_SIZES.TitleBar + ELEMENT_SIZES.TabHeight + 10)  
    ContentArea.BackgroundTransparency = 1  
    ContentArea.ClipsDescendants = true  
    ContentArea.Parent = MainFrame  
  
    -- EFEKTLER  
    local function CreateClickEffect(button)  
        if not button or not button.Parent then return end
        local effect = Instance.new("Frame")  
        effect.Name = "ClickEffect"  
        effect.Size = UDim2.new(1, 0, 1, 0)  
        effect.BackgroundColor3 = Colors.Accent  
        effect.BackgroundTransparency = 0.7  
        effect.ZIndex = 5
        effect.Parent = button  
        
        local effectCorner = Instance.new("UICorner")  
        effectCorner.CornerRadius = button:FindFirstChildWhichIsA("UICorner") and button:FindFirstChildWhichIsA("UICorner").CornerRadius or UDim.new(0, 6)  
        effectCorner.Parent = effect  
        
        game:GetService("TweenService"):Create(effect, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()  
        delay(0.3, function() if effect and effect.Parent then effect:Destroy() end end)  
    end  
  
    local function SetupButtonHover(button, isControlButton)  
        if not button or not button.Parent then return end
        
        if isControlButton then  
            button.MouseEnter:Connect(function()  
                if button and button.Parent then
                    if button.Name == "Close" then  
                        button.BackgroundColor3 = Color3.fromRGB(200, 80, 80)  
                    else  
                        button.BackgroundColor3 = Color3.fromRGB(90, 70, 130)  
                    end
                end
            end)  
            button.MouseLeave:Connect(function()  
                if button and button.Parent then
                    if button.Name == "Close" then  
                        button.BackgroundColor3 = Colors.CloseButton  
                    else  
                        button.BackgroundColor3 = Colors.ControlButton  
                    end
                end
            end)  
            return  
        end  
        
        button.MouseEnter:Connect(function()  
            if button and button.Parent then
                game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Colors.Border }):Play()
            end
        end)  
        
        button.MouseLeave:Connect(function()  
            if button and button.Parent then
                game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Colors.Button }):Play()
            end
        end)  
    end  
  
    SetupButtonHover(CloseButton, true)  
    SetupButtonHover(MinimizeButton, true)  
  
    -- DRAGGABLE  
    local UserInputService = game:GetService("UserInputService")  
    local RunService = game:GetService("RunService")  
    local dragging = false  
    local dragStart, startPos  
    local activeDropdowns = {}
    
    local function update(input)  
        if not dragging then return end  
        if not MainFrame or not MainFrame.Parent then return end
        local delta = input.Position - dragStart  
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)  
        
        for dropdownFrame, _ in pairs(activeDropdowns) do  
            if dropdownFrame and dropdownFrame.Parent then  
                local dropdownButton = dropdownFrame.Parent:FindFirstChild("DropdownButton")  
                if dropdownButton then  
                    local buttonPos = dropdownButton.AbsolutePosition  
                    local buttonSize = dropdownButton.AbsoluteSize  
                    dropdownFrame.Position = UDim2.new(0, buttonPos.X, 0, buttonPos.Y + buttonSize.Y + 5)  
                end  
            end  
        end  
    end  
  
    TitleBar.InputBegan:Connect(function(input)  
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
            dragging = true  
            dragStart = input.Position  
            startPos = MainFrame.Position  
            
            local dragConnection  
            dragConnection = RunService.Heartbeat:Connect(function() 
                if not MainFrame or not MainFrame.Parent then
                    if dragConnection then dragConnection:Disconnect() end
                    return
                end
                update(input) 
            end)  
            
            local function onInputEnded(inputEnded)  
                if inputEnded.UserInputType == Enum.UserInputType.MouseButton1 or inputEnded.UserInputType == Enum.UserInputType.Touch then  
                    dragging = false  
                    if dragConnection then dragConnection:Disconnect() end  
                end  
            end  
            UserInputService.InputEnded:Connect(onInputEnded)  
        end  
    end)  
  
    -- =========================================================================
    -- TAM TEMİZLİK FONKSİYONU
    -- =========================================================================
    local function FullCleanup()
        for _, conn in pairs(Window.ActiveConnections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        Window.ActiveConnections = {}

        for _, toggleData in pairs(Window.AllToggles) do
            if toggleData and toggleData.State == true then
                toggleData.State = false
                if toggleData.Callback then
                    task.spawn(function()
                        pcall(function() toggleData.Callback(false) end)
                    end)
                end
            end
        end
        Window.AllToggles = {}
        
        for dropdownFrame, _ in pairs(activeDropdowns) do
            if dropdownFrame then pcall(function() dropdownFrame:Destroy() end) end
        end
    end

    -- Close Button Logic
    CloseButton.MouseButton1Click:Connect(function()  
        CreateClickEffect(CloseButton)  
        pcall(function() ScreenGui:Destroy() end)
    end)  
    
    -- UI Silindiğinde Temizlik Yap
    ScreenGui.AncestryChanged:Connect(function()
        if not ScreenGui.Parent then
            FullCleanup()
        end
    end)
  
    local minimized = false  
    MinimizeButton.MouseButton1Click:Connect(function()  
        CreateClickEffect(MinimizeButton)  
        if not minimized then  
            MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, ELEMENT_SIZES.TitleBar)  
            TabsScrollFrame.Visible = false  
            ContentArea.Visible = false  
            minimized = true  
            for dropdownFrame, _ in pairs(activeDropdowns) do  
                if dropdownFrame then pcall(function() dropdownFrame:Destroy() end) activeDropdowns[dropdownFrame] = nil end  
            end  
        else  
            MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)  
            TabsScrollFrame.Visible = true  
            ContentArea.Visible = true  
            minimized = false  
        end  
    end)  
  
    function Window:NewSection(name)  
        local Section = {}  
        Section.Name = name  
        
        local TabButton = Instance.new("TextButton")  
        TabButton.Name = name .. "_Tab"  
        TabButton.Size = UDim2.new(0, 65, 0, 22)  
        TabButton.BackgroundColor3 = Colors.TabInactive  
        TabButton.Text = name  
        TabButton.TextColor3 = Colors.Text  
        TabButton.TextSize = 11  
        TabButton.Font = Fonts.Bold  
        TabButton.AutoButtonColor = false  
        TabButton.LayoutOrder = #Window.Sections + 1  
        TabButton.ZIndex = 5
        TabButton.Parent = TabsContainer  
        
        local tabCorner = Instance.new("UICorner")  
        tabCorner.CornerRadius = UDim.new(0, 5)  
        tabCorner.Parent = TabButton  
        SetupButtonHover(TabButton, false)  
        
        local SectionFrame = Instance.new("ScrollingFrame")  
        SectionFrame.Name = name .. "_Content"  
        SectionFrame.Size = UDim2.new(1, 0, 1, 0)  
        SectionFrame.BackgroundColor3 = Colors.SectionBg  
        SectionFrame.BackgroundTransparency = 0  
        SectionFrame.BorderSizePixel = 0  
        SectionFrame.ScrollBarThickness = 3  
        SectionFrame.ScrollBarImageColor3 = Colors.Border  
        SectionFrame.Visible = false  
        SectionFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y  
        SectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)  
        SectionFrame.Parent = ContentArea  
        
        local sectionCorner = Instance.new("UICorner")  
        sectionCorner.CornerRadius = UDim.new(0, 6)  
        sectionCorner.Parent = SectionFrame  
        
        local sectionList = Instance.new("UIListLayout")  
        sectionList.Padding = UDim.new(0, ELEMENT_SIZES.SectionSpacing)  
        sectionList.SortOrder = Enum.SortOrder.LayoutOrder  
        sectionList.Parent = SectionFrame  
        
        local sectionPadding = Instance.new("UIPadding")  
        sectionPadding.PaddingTop = UDim.new(0, 6)  
        sectionPadding.PaddingBottom = UDim.new(0, 6)  
        sectionPadding.PaddingLeft = UDim.new(0, 6)  
        sectionPadding.PaddingRight = UDim.new(0, 6)  
        sectionPadding.Parent = SectionFrame  
        
        sectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()  
            if SectionFrame and SectionFrame.Parent then
                SectionFrame.CanvasSize = UDim2.new(0, 0, 0, sectionList.AbsoluteContentSize.Y + 12)
            end
        end)  
        
        if #Window.Sections == 0 then  
            TabButton.BackgroundColor3 = Colors.TabActive  
            SectionFrame.Visible = true  
            Window.CurrentSection = Section  
        end  
        
        TabButton.MouseButton1Click:Connect(function()  
            CreateClickEffect(TabButton)  
            for _, tab in pairs(TabsContainer:GetChildren()) do  
                if tab:IsA("TextButton") then tab.BackgroundColor3 = Colors.TabInactive end  
            end  
            for _, frame in pairs(ContentArea:GetChildren()) do  
                if frame:IsA("ScrollingFrame") then frame.Visible = false end  
            end  
            TabButton.BackgroundColor3 = Colors.TabActive  
            SectionFrame.Visible = true  
            Window.CurrentSection = Section  
        end)  
        
        function Section:CreateButton(name, callback)  
            local Button = Instance.new("TextButton")  
            Button.Name = name  
            Button.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.ButtonHeight)  
            Button.BackgroundColor3 = Colors.Button  
            Button.Text = name  
            Button.TextColor3 = Colors.Text  
            Button.TextSize = 13  
            Button.Font = Fonts.Bold  
            Button.AutoButtonColor = false  
            Button.LayoutOrder = #SectionFrame:GetChildren()  
            Button.ZIndex = 5
            Button.Parent = SectionFrame  
            
            local btnCorner = Instance.new("UICorner")  
            btnCorner.CornerRadius = UDim.new(0, 5)  
            btnCorner.Parent = Button  
            SetupButtonHover(Button, false)  
            
            Button.MouseButton1Click:Connect(function()  
                CreateClickEffect(Button)  
                if callback then 
                    task.spawn(function() callback() end)
                end  
            end)  
            return Button  
        end  
        
        function Section:CreateToggle(name, default, callback)  
            local Toggle = Instance.new("Frame")  
            Toggle.Name = name  
            Toggle.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.ToggleHeight)  
            Toggle.BackgroundTransparency = 1  
            Toggle.LayoutOrder = #SectionFrame:GetChildren()  
            Toggle.Parent = SectionFrame  
            
            local ToggleLabel = Instance.new("TextLabel")  
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)  
            ToggleLabel.BackgroundTransparency = 1  
            ToggleLabel.Text = name  
            ToggleLabel.TextColor3 = Colors.Text  
            ToggleLabel.TextSize = 13  
            ToggleLabel.Font = Fonts.Bold  
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left  
            ToggleLabel.ZIndex = 5
            ToggleLabel.Parent = Toggle  
            
            local ToggleButton = Instance.new("TextButton")  
            ToggleButton.Name = "Toggle"  
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)  
            ToggleButton.Position = UDim2.new(1, -42, 0.5, -10)  
            ToggleButton.BackgroundColor3 = default and Colors.ToggleOn or Colors.ToggleOff  
            ToggleButton.Text = ""  
            ToggleButton.AutoButtonColor = false  
            ToggleButton.ZIndex = 5
            ToggleButton.Parent = Toggle  
            
            local toggleCorner = Instance.new("UICorner")  
            toggleCorner.CornerRadius = UDim.new(1, 0)  
            toggleCorner.Parent = ToggleButton  
            
            local ToggleCircle = Instance.new("Frame")  
            ToggleCircle.Name = "Circle"  
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)  
            ToggleCircle.Position = UDim2.new(0, default and 21 or 2, 0.5, -8)  
            ToggleCircle.BackgroundColor3 = Colors.Text  
            ToggleCircle.ZIndex = 6
            ToggleCircle.Parent = ToggleButton  
            
            local circleCorner = Instance.new("UICorner")  
            circleCorner.CornerRadius = UDim.new(1, 0)  
            circleCorner.Parent = ToggleCircle  
            
            local ToggleData = {
                State = default or false,
                Callback = callback
            }
            table.insert(Window.AllToggles, ToggleData)
            
            ToggleButton.MouseEnter:Connect(function()  
                if ToggleButton and ToggleButton.Parent then
                    game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {  
                        BackgroundColor3 = ToggleData.State and Colors.Accent or Colors.Hover  
                    }):Play()
                end
            end)  
            
            ToggleButton.MouseLeave:Connect(function()  
                if ToggleButton and ToggleButton.Parent then
                    game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {  
                        BackgroundColor3 = ToggleData.State and Colors.ToggleOn or Colors.ToggleOff  
                    }):Play()
                end
            end)  
            
            ToggleButton.MouseButton1Click:Connect(function()  
                CreateClickEffect(ToggleButton)  
                ToggleData.State = not ToggleData.State  
                
                local targetPos = ToggleData.State and 21 or 2  
                if ToggleCircle and ToggleCircle.Parent then
                    game:GetService("TweenService"):Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, targetPos, 0.5, -8) }):Play()
                end
                if ToggleButton and ToggleButton.Parent then
                    game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), { BackgroundColor3 = ToggleData.State and Colors.ToggleOn or Colors.ToggleOff }):Play()
                end
                
                if callback then 
                    task.spawn(function() callback(ToggleData.State) end)
                end  
            end)  
            return Toggle  
        end  
        
        function Section:CreateSlider(name, min, max, default, callback)  
            local Slider = Instance.new("Frame")  
            Slider.Name = name  
            Slider.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.SliderHeight)  
            Slider.BackgroundTransparency = 1  
            Slider.LayoutOrder = #SectionFrame:GetChildren()  
            Slider.Parent = SectionFrame  
            
            local SliderLabel = Instance.new("TextLabel")  
            SliderLabel.Size = UDim2.new(1, 0, 0, 18)  
            SliderLabel.BackgroundTransparency = 1  
            SliderLabel.Text = name .. ": " .. default  
            SliderLabel.TextColor3 = Colors.Text  
            SliderLabel.TextSize = 13  
            SliderLabel.Font = Fonts.Bold  
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left  
            SliderLabel.ZIndex = 5
            SliderLabel.Parent = Slider  
            
            local SliderTrack = Instance.new("Frame")  
            SliderTrack.Name = "Track"  
            SliderTrack.Size = UDim2.new(0, 230, 0, 4)  
            SliderTrack.Position = UDim2.new(0, 0, 0, 22)  
            SliderTrack.BackgroundColor3 = Colors.ToggleOff  
            SliderTrack.ZIndex = 5
            SliderTrack.Parent = Slider  
            
            local trackCorner = Instance.new("UICorner")  
            trackCorner.CornerRadius = UDim.new(1, 0)  
            trackCorner.Parent = SliderTrack  
            
            local SliderFill = Instance.new("Frame")  
            SliderFill.Name = "Fill"  
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)  
            SliderFill.BackgroundColor3 = Colors.Slider  
            SliderFill.ZIndex = 6
            SliderFill.Parent = SliderTrack  
            
            local fillCorner = Instance.new("UICorner")  
            fillCorner.CornerRadius = UDim.new(1, 0)  
            fillCorner.Parent = SliderFill  
            
            local SliderButton = Instance.new("TextButton")  
            SliderButton.Name = "SliderButton"  
            SliderButton.Size = UDim2.new(0, 16, 0, 16)  
            SliderButton.Position = UDim2.new(SliderFill.Size.X.Scale, -8, 0.5, -8)  
            SliderButton.BackgroundColor3 = Colors.Text  
            SliderButton.Text = ""  
            SliderButton.AutoButtonColor = false  
            SliderButton.ZIndex = 7
            SliderButton.Parent = SliderTrack  
            
            local btnCorner = Instance.new("UICorner")  
            btnCorner.CornerRadius = UDim.new(1, 0)  
            btnCorner.Parent = SliderButton  
            
            local draggingSlider = false  
            
            SliderButton.MouseButton1Down:Connect(function() draggingSlider = true end)  
            
            SliderTrack.InputBegan:Connect(function(input)  
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
                    draggingSlider = true  
                    local pos = UDim2.new(math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1), -8, 0.5, -8)  
                    SliderButton.Position = pos  
                    SliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)  
                    local value = math.floor(min + (pos.X.Scale * (max - min)))  
                    SliderLabel.Text = name .. ": " .. value  
                    if callback then callback(value) end  
                end  
            end)  
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)  
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSlider = false end  
            end)  
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)  
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
                    local pos = UDim2.new(math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1), -8, 0.5, -8)  
                    SliderButton.Position = pos  
                    SliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)  
                    local value = math.floor(min + (pos.X.Scale * (max - min)))  
                    SliderLabel.Text = name .. ": " .. value  
                    if callback then callback(value) end  
                end  
            end)  
            return Slider  
        end  
        
        function Section:CreateDropdown(name, options, default, callback)  
            local Dropdown = Instance.new("Frame")  
            Dropdown.Name = name  
            Dropdown.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.DropdownHeight)  
            Dropdown.BackgroundTransparency = 1  
            Dropdown.ClipsDescendants = false  
            Dropdown.LayoutOrder = #SectionFrame:GetChildren()  
            Dropdown.ZIndex = 5
            Dropdown.Parent = SectionFrame  
            
            local DropdownButton = Instance.new("TextButton")  
            DropdownButton.Name = "DropdownButton"  
            DropdownButton.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.DropdownHeight)  
            DropdownButton.BackgroundColor3 = Colors.Button  
            DropdownButton.Text = options[default] or options[1] or "Select"  
            DropdownButton.TextColor3 = Colors.Text  
            DropdownButton.TextSize = 13  
            DropdownButton.Font = Fonts.Bold  
            DropdownButton.AutoButtonColor = false  
            DropdownButton.ZIndex = 5
            DropdownButton.Parent = Dropdown  
            
            local btnCorner = Instance.new("UICorner")  
            btnCorner.CornerRadius = UDim.new(0, 5)  
            btnCorner.Parent = DropdownButton  
            
            DropdownButton.MouseEnter:Connect(function()  
                if DropdownButton and DropdownButton.Parent then
                    game:GetService("TweenService"):Create(DropdownButton, TweenInfo.new(0.2), { BackgroundColor3 = Colors.Border }):Play()
                end
            end)  
            DropdownButton.MouseLeave:Connect(function()  
                if DropdownButton and DropdownButton.Parent then
                    game:GetService("TweenService"):Create(DropdownButton, TweenInfo.new(0.2), { BackgroundColor3 = Colors.Button }):Play()
                end
            end)  
            
            local open = false  
            local OptionsContainer  
            
            local function CloseOptions()  
                if OptionsContainer then pcall(function() OptionsContainer:Destroy() end) OptionsContainer = nil end  
                open = false  
                activeDropdowns[OptionsContainer] = nil  
            end  
            
            DropdownButton.MouseButton1Click:Connect(function()  
                CreateClickEffect(DropdownButton)  
                if open then CloseOptions() return end  
                
                open = true  
                local OptionsScreenGui = Instance.new("ScreenGui")  
                OptionsScreenGui.Name = "DropdownOptions"  
                OptionsScreenGui.ResetOnSpawn = false  
                OptionsScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling  
                OptionsScreenGui.Parent = ScreenGui  
                
                OptionsContainer = Instance.new("Frame")  
                OptionsContainer.Name = "OptionsContainer"  
                OptionsContainer.Size = UDim2.new(0, DropdownButton.AbsoluteSize.X, 0, #options * 22 + 8)  
                OptionsContainer.Position = UDim2.new(0, DropdownButton.AbsolutePosition.X, 0, DropdownButton.AbsolutePosition.Y + DropdownButton.AbsoluteSize.Y + 5)  
                OptionsContainer.BackgroundColor3 = Colors.SectionBg  
                OptionsContainer.BorderSizePixel = 0  
                OptionsContainer.ZIndex = 100  
                OptionsContainer.Parent = OptionsScreenGui  
                
                local optionsCorner = Instance.new("UICorner")  
                optionsCorner.CornerRadius = UDim.new(0, 5)  
                optionsCorner.Parent = OptionsContainer  
                
                for i, option in pairs(options) do  
                    local OptionButton = Instance.new("TextButton")  
                    OptionButton.Name = option  
                    OptionButton.Size = UDim2.new(1, -8, 0, 20)  
                    OptionButton.Position = UDim2.new(0, 4, 0, (i-1)*22 + 4)  
                    OptionButton.BackgroundColor3 = Colors.Button  
                    OptionButton.Text = option  
                    OptionButton.TextColor3 = Colors.Text  
                    OptionButton.TextSize = 11  
                    OptionButton.Font = Fonts.Bold  
                    OptionButton.AutoButtonColor = false  
                    OptionButton.ZIndex = 101  
                    OptionButton.Parent = OptionsContainer  
                    
                    local optionCorner = Instance.new("UICorner")  
                    optionCorner.CornerRadius = UDim.new(0, 3)  
                    optionCorner.Parent = OptionButton  
                    
                    OptionButton.MouseEnter:Connect(function() if OptionButton and OptionButton.Parent then OptionButton.BackgroundColor3 = Colors.Border end end)  
                    OptionButton.MouseLeave:Connect(function() if OptionButton and OptionButton.Parent then OptionButton.BackgroundColor3 = Colors.Button end end)  
                    
                    OptionButton.MouseButton1Click:Connect(function()  
                        CreateClickEffect(OptionButton)  
                        DropdownButton.Text = option  
                        if callback then 
                            task.spawn(function() callback(option) end)
                        end  
                        CloseOptions()  
                        OptionsScreenGui:Destroy()  
                    end)  
                end  
                activeDropdowns[OptionsContainer] = true  
                
                local dropdownConnection  
                dropdownConnection = RunService.Heartbeat:Connect(function()  
                    if OptionsContainer and open then  
                         if OptionsContainer and DropdownButton then  
                            local buttonPos = DropdownButton.AbsolutePosition  
                            local buttonSize = DropdownButton.AbsoluteSize  
                            OptionsContainer.Position = UDim2.new(0, buttonPos.X, 0, buttonPos.Y + buttonSize.Y + 5)  
                        end  
                    end  
                end)
                table.insert(Window.ActiveConnections, dropdownConnection)
                
                local function checkClickOutside(input)  
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then  
                        local mousePos = UserInputService:GetMouseLocation()  
                        local buttonPos = DropdownButton.AbsolutePosition  
                        local buttonSize = DropdownButton.AbsoluteSize  
                        local containerPos = OptionsContainer and OptionsContainer.AbsolutePosition  
                        local containerSize = OptionsContainer and OptionsContainer.AbsoluteSize  
                        
                        if not (mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and  
                            mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y) and  
                        not (containerPos and containerSize and   
                            mousePos.X >= containerPos.X and mousePos.X <= containerPos.X + containerSize.X and  
                            mousePos.Y >= containerPos.Y and mousePos.Y <= containerPos.Y + containerSize.Y) then  
                            if dropdownConnection then dropdownConnection:Disconnect() end  
                            CloseOptions()  
                            OptionsScreenGui:Destroy()  
                        end  
                    end  
                end  
                UserInputService.InputBegan:Connect(checkClickOutside)  
            end)  
            return Dropdown  
        end  
        
        function Section:CreateTextbox(name, callback)  
            local Textbox = Instance.new("Frame")  
            Textbox.Name = name  
            Textbox.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.TextboxHeight)  
            Textbox.BackgroundTransparency = 1  
            Textbox.LayoutOrder = #SectionFrame:GetChildren()  
            Textbox.ZIndex = 5
            Textbox.Parent = SectionFrame  
            
            local InputBox = Instance.new("TextBox")  
            InputBox.Name = "Input"  
            InputBox.Size = UDim2.new(1, 0, 1, 0)  
            InputBox.BackgroundColor3 = Colors.Button  
            InputBox.Text = ""  
            InputBox.PlaceholderText = name  
            InputBox.TextColor3 = Colors.Text  
            InputBox.PlaceholderColor3 = Colors.Text  
            InputBox.TextSize = 13  
            InputBox.Font = Fonts.Bold  
            InputBox.TextXAlignment = Enum.TextXAlignment.Center  
            InputBox.ZIndex = 5
            InputBox.Parent = Textbox  
            
            local inputCorner = Instance.new("UICorner")  
            inputCorner.CornerRadius = UDim.new(0, 5)  
            inputCorner.Parent = InputBox  
            
            InputBox.FocusLost:Connect(function()  
                if callback then 
                    task.spawn(function() callback(InputBox.Text) end)
                end  
            end)  
            return Textbox  
        end  
        
        table.insert(Window.Sections, Section)  
        return Section  
    end  
  
    -- =========================================================================
    -- REMOTE LOGGER DETECTION SYSTEM
    -- =========================================================================
    local CoreGui = game:GetService("CoreGui")
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local DetectedSpies = {}
    local notificationDebounce = false
    
    local RemoteLoggerSignatures = {
        hasRemoteMonitoring = function(obj)
            if not obj:IsA("ScreenGui") then return false end
            local labelCount = 0
            local hasRemoteInfo = false
            
            for _, desc in pairs(obj:GetDescendants()) do
                if desc:IsA("TextLabel") or desc:IsA("TextBox") then
                    local txt = (desc.Text or ""):lower() .. (desc.Name or ""):lower()
                    if string.find(txt, "remotefunction") or string.find(txt, "remoteevent") or
                       string.find(txt, "arguments") or string.find(txt, "transmitted") or
                       string.find(txt, "replicated") then
                        hasRemoteInfo = true
                        labelCount = labelCount + 1
                    end
                end
            end
            
            return hasRemoteInfo and labelCount >= 2
        end,
        
        hasSpyFeatures = function(obj)
            if not obj:IsA("ScreenGui") then return false end
            local hasLogList = false
            local hasDetailPanel = false
            
            for _, child in pairs(obj:GetDescendants()) do
                if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                    if child.Size.X.Scale > 0.3 or child.Size.Y.Scale > 0.3 then
                        hasLogList = true
                    end
                end
                if child:IsA("TextLabel") then
                    local txt = (child.Text or ""):lower()
                    if string.find(txt, "monitor") or string.find(txt, "trace") or
                       string.find(txt, "capture") or string.find(txt, "inspect") then
                        hasDetailPanel = true
                    end
                end
            end
            
            return hasLogList and hasDetailPanel
        end,
        
        hasSpyName = function(obj)
            if not obj:IsA("ScreenGui") then return false end
            local name = (obj.Name or ""):lower()
            local blacklist = {"remotespy", "simplespy", "hydroxide", "turtlespy", "darkdex", "spy", "logger", "monitor", "debugger", "tracer"}
            for _, badName in pairs(blacklist) do
                if string.find(name, badName) then return true end
            end
            return false
        end
    }
    
    local function IsRemoteLogger(obj)
        if not obj or not obj:IsA("ScreenGui") then return false end
        if obj.Name == "OxireunUI" then return false end
        
        return RemoteLoggerSignatures.hasRemoteMonitoring(obj) or 
               RemoteLoggerSignatures.hasSpyFeatures(obj) or
               RemoteLoggerSignatures.hasSpyName(obj)
    end
    
    -- İlk tarama
    for _, v in pairs(CoreGui:GetChildren()) do 
        if IsRemoteLogger(v) then
            pcall(function() v:Destroy() end)
            DetectedSpies[v] = true
            if not notificationDebounce then
                OxireunUI:SendNotification("🛡️ Security", "Nope Nope!", 3)
                notificationDebounce = true
                task.wait(0.5)
                notificationDebounce = false
            end
        end
    end
    
    for _, v in pairs(PlayerGui:GetChildren()) do 
        if IsRemoteLogger(v) then
            pcall(function() v:Destroy() end)
            DetectedSpies[v] = true
            if not notificationDebounce then
                OxireunUI:SendNotification("🛡️ Security", "Nope Nope!", 3)
                notificationDebounce = true
                task.wait(0.5)
                notificationDebounce = false
            end
        end
    end

    -- Sürekli monitorlama
    local c1 = CoreGui.ChildAdded:Connect(function(child)
        if not DetectedSpies[child] then
            task.wait(0.05)
            if child and child.Parent and IsRemoteLogger(child) then
                pcall(function() child:Destroy() end)
                DetectedSpies[child] = true
                if not notificationDebounce then
                    OxireunUI:SendNotification("🛡️ Security", "Nope Nope!", 3)
                    notificationDebounce = true
                    task.wait(0.5)
                    notificationDebounce = false
                end
            end
        end
    end)
    
    local c2 = PlayerGui.ChildAdded:Connect(function(child)
        if not DetectedSpies[child] then
            task.wait(0.05)
            if child and child.Parent and IsRemoteLogger(child) then
                pcall(function() child:Destroy() end)
                DetectedSpies[child] = true
                if not notificationDebounce then
                    OxireunUI:SendNotification("🛡️ Security", "Nope Nope!", 3)
                    notificationDebounce = true
                    task.wait(0.5)
                    notificationDebounce = false
                end
            end
        end
    end)
    
    table.insert(Window.ActiveConnections, c1)
    table.insert(Window.ActiveConnections, c2)
    
    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")  
    table.insert(self.Windows, Window)  
    return Window
end

return OxireunUI.new()
