Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496DF649316
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 08:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiLKHff convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Dec 2022 02:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLKHfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 02:35:34 -0500
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1542812D06
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 23:35:29 -0800 (PST)
X-QQ-mid: bizesmtpipv602t1670744106tee6
Received: from smtpclient.apple ( [255.25.208.13])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 11 Dec 2022 15:35:04 +0800 (CST)
X-QQ-SSF: 00400000002000M0N000B00A0000000
X-QQ-FEAT: D6RqbDSxuq5pqKYBPeUMMzMLHdsWf0ofNYrDVQJl44qE7ClWAh4nIn+PQvgd9
        tn3G6qg5T9r4U3j9qyKnGMkZxtUXeoA6Ae4DsH9U1oR/orJ6Hwfkx8buodxwacvV/QINxQC
        fkxrj6SSpBslyZRg1082vg/GIuYK8JrlGAB+af3BhRBO5mW3hpGigsDcW0vQwow+U0Iim6q
        yoTiE/6q9U4NWC6gaxKf+WEusNeiyNa9Z9XcICSQJCjJnJLsy8WW/7iaaRzpVJ94SKXyAkN
        C7u+oDm0fdJ/E5KT3dasQsdVUmDEdP6Z736/Q1d9HhYW9jkic5BnjtZJPO2z1LBJwX93zFk
        CW82zQAni00XC3dG9FrD9+YVPkPJILsMJqKZbQ2eZpC6RuYfoiaFucp0ChFOw==
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next v2] net: ngbe: Add ngbe mdio bus driver.
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <Y5RjwYgetMdzlQVZ@lunn.ch>
Date:   Sun, 11 Dec 2022 15:35:04 +0800
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Content-Transfer-Encoding: 8BIT
Message-Id: <8BEEC6D9-EB5F-4A66-8BFD-E8FEE4EB723F@net-swift.com>
References: <20221206114035.66260-1-mengyuanlou@net-swift.com>
 <Y5RjwYgetMdzlQVZ@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpipv:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,RCVD_ILLEGAL_IP,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2022年12月10日 18:47，Andrew Lunn <andrew@lunn.ch> 写道：
> 
>> int ngbe_reset_hw(struct ngbe_hw *hw)
>> {
>> 	struct wx_hw *wxhw = &hw->wxhw;
>> -	int status = 0;
>> -	u32 reset = 0;
>> +	u32 val = 0;
>> +	int ret = 0;
>> 
>> 	/* Call adapter stop to disable tx/rx and clear interrupts */
>> -	status = wx_stop_adapter(wxhw);
>> -	if (status != 0)
>> -		return status;
>> -	reset = WX_MIS_RST_LAN_RST(wxhw->bus.func);
>> -	wr32(wxhw, WX_MIS_RST, reset | rd32(wxhw, WX_MIS_RST));
>> +	ret = wx_stop_adapter(wxhw);
>> +	if (ret != 0)
>> +		return ret;
>> +
>> +	if (hw->mac_type != ngbe_mac_type_mdi) {
>> +		val = WX_MIS_RST_LAN_RST(wxhw->bus.func);
>> +		wr32(wxhw, WX_MIS_RST, val | rd32(wxhw, WX_MIS_RST));
>> +
>> +		ret = read_poll_timeout(rd32, val,
>> +					!(val & (BIT(9) << wxhw->bus.func)), 1000,
>> +					100000, false, wxhw, 0x10028);
>> +		if (ret)
>> +			wx_dbg(wxhw, "Lan reset exceed s maximum times.\n");
> 
> This is a real error. Return it up the call stack so the user gets to
> know. This should be netdev_err(), since it is an error.
> 
>> +static void ngbe_up(struct ngbe_adapter *adapter)
>> +{
>> +	struct ngbe_hw *hw = &adapter->hw;
>> +
>> +	pci_set_master(adapter->pdev);
>> +	if (hw->gpio_ctrl)
>> +		/* gpio0 is used to power on control*/
>> +		wr32(&hw->wxhw, NGBE_GPIO_DR, 0);
> 
> Control of what?
Control for sfp modules power down/up.
The chip has not i2c interface, so I do not use phylink.

> 
>> +static int ngbe_phy_read_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum)
>> +{
>> +	u32 command = 0, device_type = 0;
>> +	struct ngbe_hw *hw = bus->priv;
>> +	struct wx_hw *wxhw = &hw->wxhw;
>> +	u32 phy_data = 0;
>> +	u32 val = 0;
>> +	int ret = 0;
>> +
>> +	if (regnum & MII_ADDR_C45) {
>> +		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0x0);
>> +		/* setup and write the address cycle command */
>> +		command = NGBE_MSCA_RA(mdiobus_c45_regad(regnum)) |
>> +			  NGBE_MSCA_PA(phy_addr) |
>> +			  NGBE_MSCA_DA(mdiobus_c45_devad(regnum));
>> +	} else {
>> +		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
>> +		/* setup and write the address cycle command */
>> +		command = NGBE_MSCA_RA(regnum) |
>> +			  NGBE_MSCA_PA(phy_addr) |
>> +			  NGBE_MSCA_DA(device_type);
>> +	}
>> +	wr32(wxhw, NGBE_MSCA, command);
>> +	command = NGBE_MSCC_CMD(NGBE_MSCA_CMD_READ) |
>> +		  NGBE_MSCC_BUSY |
>> +		  NGBE_MDIO_CLK(6);
>> +	wr32(wxhw, NGBE_MSCC, command);
>> +
>> +	/* wait to complete */
>> +	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
>> +				100000, false, wxhw, NGBE_MSCC);
>> +
>> +	if (ret)
>> +		wx_dbg(wxhw, "PHY address command did not complete.\n");
> 
> netdev_err() and return the error code.
> 
>> +static int ngbe_phy_write_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
>> +{
>> +	u32 command = 0, device_type = 0;
>> +	struct ngbe_hw *hw = bus->priv;
>> +	struct wx_hw *wxhw = &hw->wxhw;
>> +	int ret = 0;
>> +	u16 val = 0;
>> +
>> +	if (regnum & MII_ADDR_C45) {
>> +		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0x0);
>> +		/* setup and write the address cycle command */
>> +		command = NGBE_MSCA_RA(mdiobus_c45_regad(regnum)) |
>> +			  NGBE_MSCA_PA(phy_addr) |
>> +			  NGBE_MSCA_DA(mdiobus_c45_devad(regnum));
>> +	} else {
>> +		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
>> +		/* setup and write the address cycle command */
>> +		command = NGBE_MSCA_RA(regnum) |
>> +			  NGBE_MSCA_PA(phy_addr) |
>> +			  NGBE_MSCA_DA(device_type);
>> +	}
>> +	wr32(wxhw, NGBE_MSCA, command);
>> +	command = value |
>> +		  NGBE_MSCC_CMD(NGBE_MSCA_CMD_WRITE) |
>> +		  NGBE_MSCC_BUSY |
>> +		  NGBE_MDIO_CLK(6);
>> +	wr32(wxhw, NGBE_MSCC, command);
>> +
>> +	/* wait to complete */
>> +	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
>> +				100000, false, wxhw, NGBE_MSCC);
>> +
>> +	if (ret)
>> +		wx_dbg(wxhw, "PHY address command did not complete.\n");
> 
> dev_error().
> 
>> +
>> +	return ret;
>> +}
>> +
>> +static int ngbe_phy_read_reg(struct mii_bus *bus, int phy_addr, int regnum)
>> +{
>> +	struct ngbe_hw *hw = bus->priv;
>> +	u16 phy_data = 0;
>> +
>> +	if (hw->mac_type == ngbe_mac_type_mdi)
>> +		phy_data = ngbe_phy_read_reg_internal(bus, phy_addr, regnum);
>> +	else if (hw->mac_type == ngbe_mac_type_rgmii)
>> +		phy_data = ngbe_phy_read_reg_mdi(bus, phy_addr, regnum);
>> +
>> +	return phy_data;
> 
> You return 0 if it is neither MDI or RGMII. It would be better to
> either return -EINVAL, or 0xffff. A read on an MDIO bus for an address
> without a device returns 0xffff due to the pull up resisters. That
> will let Linux know there is no device there.
> 
>> +static void ngbe_handle_link_change(struct net_device *dev)
>> +{
>> +	struct ngbe_adapter *adapter = netdev_priv(dev);
>> +	struct ngbe_hw *hw = &adapter->hw;
>> +	struct wx_hw *wxhw = &hw->wxhw;
>> +	u32 lan_speed = 2, reg;
>> +	bool changed = false;
>> +
>> +	struct phy_device *phydev = hw->phydev;
>> +
>> +	if (hw->link != phydev->link ||
>> +	    hw->speed != phydev->speed ||
>> +	    hw->duplex != phydev->duplex) {
>> +		changed = true;
>> +		hw->link = phydev->link;
>> +		hw->speed = phydev->speed;
>> +		hw->duplex = phydev->duplex;
>> +	}
>> +
>> +	if (!changed)
>> +		return;
>> +
>> +	switch (phydev->speed) {
>> +	case SPEED_1000:
>> +		lan_speed = 2;
>> +		break;
>> +	case SPEED_100:
>> +		lan_speed = 1;
>> +		break;
>> +	case SPEED_10:
>> +		lan_speed = 0;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +	wr32m(wxhw, NGBE_CFG_LAN_SPEED, 0x3, lan_speed);
>> +
>> +	if (phydev->link) {
>> +		if (phydev->speed & (SPEED_1000 | SPEED_100 | SPEED_10)) {
> 
> You logically OR 10, 100 and 1000? These SPEED_FOO macros are not
> bits.
> 
> 	Andrew
> 

