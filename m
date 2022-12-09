Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E543647CB8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiLIDmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 22:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiLIDmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 22:42:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9EDB0798
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 19:42:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C49D62152
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 03:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8743CC433EF;
        Fri,  9 Dec 2022 03:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670557336;
        bh=FZ821jJupWJgAVM86GsIoF0I3YFh5lKsNvb0r/jo1sA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V//3wfkt6P7a5WgyzYVsn1m91btkOOP4P6p0oZEDj6T576xmg31j0L2C41vpsqON3
         Ewx1ULUWUwb1ICicAT89ZwBOLhlfzWb/jRbZS5oADmyB4vsrvFvOcTxIXeCNvfJ1Me
         2NHBpTMAyUPV5iKAwTMJvkIZvRpx33NvJIggPRIDdewGejIkAgvEfAH5vnXH7iWUmg
         5XBqOi9rnIHDse1LsHTo6BB7QD7Cr8epOt0dp+0Nku4/FnMzeXYY65qb6lGGHX4r9A
         PPzVCrxiXK11zXCjORduZmeTqoy/mey/QxHtD7GIQhjoZkuEJV6OmB1HXrCXmRcq4d
         iw3pkaVBSKIdw==
Date:   Thu, 8 Dec 2022 19:42:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v2] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <20221208194215.55bc2ee1@kernel.org>
In-Reply-To: <20221206114035.66260-1-mengyuanlou@net-swift.com>
References: <20221206114035.66260-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Dec 2022 19:40:35 +0800 Mengyuan Lou wrote:
> Add mdio bus register for ngbe.
> The internal phy and external phy need to be handled separately.
> Add phy changed event detection.

>  static void ngbe_down(struct ngbe_adapter *adapter)
>  {
> -	netif_carrier_off(adapter->netdev);
> -	netif_tx_disable(adapter->netdev);
> +	struct ngbe_hw *hw = &adapter->hw;
> +
> +	phy_stop(hw->phydev);
> +	ngbe_disable_device(adapter);
>  };
>  
> +static void ngbe_up(struct ngbe_adapter *adapter)
> +{
> +	struct ngbe_hw *hw = &adapter->hw;
> +
> +	pci_set_master(adapter->pdev);

why set/clear bus master on up/down? This is normally done during probe
and cleared on remove. Having bus mastering enabled doesn't cost
anything.

> +	if (hw->gpio_ctrl)
> +		/* gpio0 is used to power on control*/
> +		wr32(&hw->wxhw, NGBE_GPIO_DR, 0);
> +	phy_start(hw->phydev);

> +static int ngbe_phy_read_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum)
> +{
> +	u32 command = 0, device_type = 0;
> +	struct ngbe_hw *hw = bus->priv;
> +	struct wx_hw *wxhw = &hw->wxhw;
> +	u32 phy_data = 0;
> +	u32 val = 0;
> +	int ret = 0;
> +
> +	if (regnum & MII_ADDR_C45) {
> +		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0x0);
> +		/* setup and write the address cycle command */
> +		command = NGBE_MSCA_RA(mdiobus_c45_regad(regnum)) |
> +			  NGBE_MSCA_PA(phy_addr) |
> +			  NGBE_MSCA_DA(mdiobus_c45_devad(regnum));
> +	} else {
> +		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
> +		/* setup and write the address cycle command */
> +		command = NGBE_MSCA_RA(regnum) |
> +			  NGBE_MSCA_PA(phy_addr) |
> +			  NGBE_MSCA_DA(device_type);
> +	}
> +	wr32(wxhw, NGBE_MSCA, command);
> +	command = NGBE_MSCC_CMD(NGBE_MSCA_CMD_READ) |
> +		  NGBE_MSCC_BUSY |
> +		  NGBE_MDIO_CLK(6);
> +	wr32(wxhw, NGBE_MSCC, command);
> +
> +	/* wait to complete */
> +	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
> +				100000, false, wxhw, NGBE_MSCC);
> +

spurious new line

> +	if (ret)
> +		wx_dbg(wxhw, "PHY address command did not complete.\n");
> +
> +	/* read data from MSCC */
> +	phy_data = 0xffff & rd32(wxhw, NGBE_MSCC);
> +
> +	return phy_data;
> +}
> +
> +static int ngbe_phy_write_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
> +{
> +	u32 command = 0, device_type = 0;
> +	struct ngbe_hw *hw = bus->priv;
> +	struct wx_hw *wxhw = &hw->wxhw;
> +	int ret = 0;
> +	u16 val = 0;

Don't pointlessly initialize all variables.
There is a compiler option which does that, for the paranoid.

> +	if (regnum & MII_ADDR_C45) {
> +		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0x0);
> +		/* setup and write the address cycle command */
> +		command = NGBE_MSCA_RA(mdiobus_c45_regad(regnum)) |
> +			  NGBE_MSCA_PA(phy_addr) |
> +			  NGBE_MSCA_DA(mdiobus_c45_devad(regnum));
> +	} else {
> +		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
> +		/* setup and write the address cycle command */
> +		command = NGBE_MSCA_RA(regnum) |
> +			  NGBE_MSCA_PA(phy_addr) |
> +			  NGBE_MSCA_DA(device_type);
> +	}
> +	wr32(wxhw, NGBE_MSCA, command);
> +	command = value |
> +		  NGBE_MSCC_CMD(NGBE_MSCA_CMD_WRITE) |
> +		  NGBE_MSCC_BUSY |
> +		  NGBE_MDIO_CLK(6);
> +	wr32(wxhw, NGBE_MSCC, command);
> +
> +	/* wait to complete */
> +	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
> +				100000, false, wxhw, NGBE_MSCC);
> +

spurious empty line

> +	if (ret)
> +		wx_dbg(wxhw, "PHY address command did not complete.\n");
> +
> +	return ret;
> +}
> +
> +static int ngbe_phy_read_reg(struct mii_bus *bus, int phy_addr, int regnum)
> +{
> +	struct ngbe_hw *hw = bus->priv;
> +	u16 phy_data = 0;

Why 0? If the mac_type is not known error would seem more appropriate?

> +	if (hw->mac_type == ngbe_mac_type_mdi)
> +		phy_data = ngbe_phy_read_reg_internal(bus, phy_addr, regnum);
> +	else if (hw->mac_type == ngbe_mac_type_rgmii)
> +		phy_data = ngbe_phy_read_reg_mdi(bus, phy_addr, regnum);
> +
> +	return phy_data;
> +}
> +
> +static int ngbe_phy_write_reg(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
> +{
> +	struct ngbe_hw *hw = bus->priv;
> +	int ret = 0;

Why 0? If the mac_type is not known error would seem more appropriate?

> +	if (hw->mac_type == ngbe_mac_type_mdi)
> +		ret = ngbe_phy_write_reg_internal(bus, phy_addr, regnum, value);
> +	else if (hw->mac_type == ngbe_mac_type_rgmii)
> +		ret = ngbe_phy_write_reg_mdi(bus, phy_addr, regnum, value);
> +	return ret;
> +}
> +
> +static void ngbe_handle_link_change(struct net_device *dev)
> +{
> +	struct ngbe_adapter *adapter = netdev_priv(dev);
> +	struct ngbe_hw *hw = &adapter->hw;
> +	struct wx_hw *wxhw = &hw->wxhw;
> +	u32 lan_speed = 2, reg;
> +	bool changed = false;
> +
> +	struct phy_device *phydev = hw->phydev;

Local variables should be in one block. 
If there is a problem with the ordering because of inter-dependencies
just initialize in the code rather than inline.

> +	if (hw->link != phydev->link ||
> +	    hw->speed != phydev->speed ||
> +	    hw->duplex != phydev->duplex) {
> +		changed = true;

This seems unnecessary, flip the condition and return here
without the need for @changed.

> +		hw->link = phydev->link;
> +		hw->speed = phydev->speed;
> +		hw->duplex = phydev->duplex;
> +	}

> +int ngbe_phy_connect(struct ngbe_hw *hw)
> +{
> +	struct ngbe_adapter *adapter = container_of(hw,
> +						    struct ngbe_adapter,
> +						    hw);
> +	int ret;
> +
> +	ret = phy_connect_direct(adapter->netdev,
> +				 hw->phydev,
> +				 ngbe_handle_link_change,
> +				 PHY_INTERFACE_MODE_RGMII_ID);
> +	if (ret) {
> +		wx_err(&hw->wxhw,
> +		       "PHY connect failed.\n");

Unnecessary line break

> +	snprintf(hw->mii_bus->id, MII_BUS_ID_SIZE, "ngbe-%x",
> +		 (pdev->bus->number << 8) |
> +		 pdev->devfn);

Unnecessary line break

