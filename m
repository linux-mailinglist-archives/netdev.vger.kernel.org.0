Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A3D642E27
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiLEREd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiLEREc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:04:32 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF2A1758C
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1XtzUoipYQsWDe7i+sH8w/wi6ZW1iuV1z/Xc8cA+j68=; b=HOFPpDZtBGoI0HyiFlIWYj+JNi
        0jPYUtTUK3NMPYKoXJXycmUCvUl9qFLm7la16U6w9RjcGmwwvIuZJTHdIKqPkKfUDCNcKfr1NVcTH
        veK+elCv7NQXG49mekC4PySw4HBHsMpYWfBHSKaHSYb/Mx5h6l6uJ+A7gmi/+zwHN7pk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2EtH-004QUA-39; Mon, 05 Dec 2022 18:04:27 +0100
Date:   Mon, 5 Dec 2022 18:04:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next] net: ngbe: Add mdio bus driver.
Message-ID: <Y44kmyE3Lw7/vxcS@lunn.ch>
References: <20221202083558.57618-1-mengyuanlou@net-swift.com>
 <Y4p0dQWijzQMlBmW@lunn.ch>
 <B561CAB9-E99D-473E-95AC-C6B13BCB5701@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B561CAB9-E99D-473E-95AC-C6B13BCB5701@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> + ret = wx_stop_adapter(wxhw);
> >> + if (ret != 0)
> >> + return ret;
> >> + val = WX_MIS_RST_LAN_RST(wxhw->bus.func);
> >> + wr32(wxhw, WX_MIS_RST, val | rd32(wxhw, WX_MIS_RST));
> >> +
> >> + ret = read_poll_timeout(rd32, val,
> >> + !(val & (BIT(9) << wxhw->bus.func)), 1000,
> >> + 100000, false, wxhw, 0x10028);
> >> + if (ret)
> >> + wx_dbg(wxhw, "Lan reset exceed s maximum times.\n");
> >> +
> >> + wr32(wxhw, NGBE_PHY_CONFIG(0x1f), 0xa43);
> >> + ret = read_poll_timeout(rd32, val, val & 0x20, 1000,
> >> + 100000, false, wxhw, NGBE_PHY_CONFIG(0x1d));
> >> + if (ret)
> >> + wx_dbg(wxhw, "Gphy reset failed.\n");
> > 
> > What is this doing? Toggling a GPIO which is connected to the PHY
> > reset input?
> > 
> Waittiing for internal phy can access through the mdio

An MDIO bus driver has this member:

	/** @reset: Perform a reset of the bus */
	int (*reset)(struct mii_bus *bus);

It seems like this function should be used here. That is why i'm
asking what this is doing.

> >> switch (type_mask) {
> >> case NGBE_SUBID_M88E1512_SFP:
> >> case NGBE_SUBID_LY_M88E1512_SFP:
> >> - hw->phy.type = ngbe_phy_m88e1512_sfi;
> >> + hw->phy.type = ngbe_phy_mv_sfi;
> >> break;
> >> case NGBE_SUBID_M88E1512_RJ45:
> >> - hw->phy.type = ngbe_phy_m88e1512;
> >> + hw->phy.type = ngbe_phy_mv;
> >> break;
> >> case NGBE_SUBID_M88E1512_MIX:
> >> - hw->phy.type = ngbe_phy_m88e1512_unknown;
> >> + hw->phy.type = ngbe_phy_mv_mix;
> >> break;
> >> case NGBE_SUBID_YT8521S_SFP:
> >> case NGBE_SUBID_YT8521S_SFP_GPIO:
> >> case NGBE_SUBID_LY_YT8521S_SFP:
> >> - hw->phy.type = ngbe_phy_yt8521s_sfi;
> >> + hw->phy.type = ngbe_phy_yt_mix;
> >> break;
> >> case NGBE_SUBID_INTERNAL_YT8521S_SFP:
> >> case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
> >> - hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
> >> + hw->phy.type = ngbe_phy_internal_yt_sfi;
> >> break;
> >> case NGBE_SUBID_RGMII_FPGA:
> >> case NGBE_SUBID_OCP_CARD:
> > 
> > Generally, a MAC driver does not care what sort of PHY is connected to
> > it. The PHY driver does all that is needed. So it is not clear to me
> > why you need this.
> > 
> Because the mac driver wants to configure the phy on special boards.

That is not how it works in Mainline linux. You have a MAC driver, and
a collection of PHY drivers. phylib sits in the middle. The MAC driver
should not care what PHY driver is being used, phylib abstracts all
access to it.

> >> +static int ngbe_phy_read_reg(struct mii_bus *bus, int phy_addr, int regnum)
> >> +{
> >> + struct ngbe_hw *hw = bus->priv;
> >> + u16 phy_data = 0;
> >> +
> >> + if (hw->mac_type == ngbe_mac_type_mdi)
> >> + phy_data = ngbe_phy_read_reg_internal(bus, phy_addr, regnum);
> >> + else if (hw->mac_type == ngbe_mac_type_rgmii)
> >> + phy_data = ngbe_phy_read_reg_mdi(bus, phy_addr, regnum);
> > 
> > Do you have two mdio busses?
> There are two different ways to access the internal and external PHYs.

So you have two MDIO busses. An internal MDIO bus and an external MDIO
bus. This is not that uncommon. Some Marvell switches are like this.
Is there anything stopping both being used at the same time?

Since you hardware has two MDIO busses, you should be registering them
both.

> >> +static void ngbe_gphy_wait_mdio_access_on(struct phy_device *phydev)
> >> +{
> >> + u16 val;
> >> + int ret;
> >> +
> >> + /* select page to 0xa43*/
> >> + phy_write(phydev, 0x1f, 0x0a43);
> >> + /* wait to phy can access */
> >> + ret = read_poll_timeout(phy_read, val, val & 0x20, 100,
> >> + 2000, false, phydev, 0x1d);
> > 
> > What is this doing? The MAC should not be directly accessing the PHY.
> > 
> We need to do some work around it, the phy driver can not do what I want.

Heiner suggested this is an errata fix for a specific PHY. Why cannot
the PHY driver do it? Why should every MAC driver using this PHY need
its own copy of the errata fix?

> > This is how other MAC drivers do this:
> > 
> > /* disable EEE autoneg, EEE not supported by TSNEP */
> > memset(&ethtool_eee, 0, sizeof(ethtool_eee));
> > phy_ethtool_set_eee(adapter->phydev, &ethtool_eee);
> > 
> > Please delete all code which directly access the PHY. You might need
> > to add new functionality to the PHY driver, but in general, it is not
> > needed, the existing PHY drivers should do what you need.
> > 
> For internal phy: The phy cannot be automatically ready, we need to manually set the Special calibration and then make the phy up.

Why cannot the PHY driver do this?

> For external phy: phy_reset clear all, we need to reconfigure phy led oem configuration

Please give more details. We can then figure out the correct way to do
this in Linux.

> >> +int ngbe_mdio_init(struct ngbe_hw *hw)
> >> +{
> >> + struct pci_dev *pdev = hw->wxhw.pdev;
> >> + int ret;
> >> +
> >> + hw->mii_bus = devm_mdiobus_alloc(&pdev->dev);
> >> + if (!hw->mii_bus)
> >> + return -ENOMEM;
> >> +
> >> + hw->mii_bus->name = "ngbe_mii_bus";
> >> + hw->mii_bus->read = &ngbe_phy_read_reg;
> >> + hw->mii_bus->write = &ngbe_phy_write_reg;
> >> + hw->mii_bus->phy_mask = 0xfffffffe;
> >> + hw->mii_bus->parent = &pdev->dev;
> >> + hw->mii_bus->priv = hw;
> >> +
> >> + snprintf(hw->mii_bus->id, MII_BUS_ID_SIZE, "ngbe-%x",
> >> + (pdev->bus->number << 8) |
> >> + pdev->devfn);
> >> +
> >> + ret = devm_mdiobus_register(&pdev->dev, hw->mii_bus);
> >> + if (ret)
> >> + return ret;
> >> +
> >> + hw->phydev = mdiobus_get_phy(hw->mii_bus, 0);
> > 
> > Is this a hardware limitation? Only address 0 is supported?
> 0-3 address is supported.

So why 0xfffffffe ?

And why on 0-3? What happens with the other 28 addresses on the bus?
Does the hardware explode? Lock up?

    Andrew
