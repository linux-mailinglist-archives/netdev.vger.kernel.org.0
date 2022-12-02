Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89A564103F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 22:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiLBV40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 16:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbiLBV4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 16:56:25 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B3FF1CC3
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 13:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9sZHXzIxIQapTscsh4sPvFWsC5jaoeT3CbyIKmxxhxo=; b=uLRlcqf67MNOYsO2vSHTumVqPh
        nZ/Wv7CgWf4Qn75fnnfofJmgCOJzur0hc1PkcPF/IFp4kHy3wWBAuY+rfg78Wes9HcG0KA3nDPIfI
        AvZMjKYQawloGNHb88Ux0Lh8mTTuWfXzSj4TFNTcVZtcL2FQopm9Tn2OrOPZLKDo+vjA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1E0r-004E2c-6e; Fri, 02 Dec 2022 22:56:05 +0100
Date:   Fri, 2 Dec 2022 22:56:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next] net: ngbe: Add mdio bus driver.
Message-ID: <Y4p0dQWijzQMlBmW@lunn.ch>
References: <20221202083558.57618-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202083558.57618-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/ethernet/wangxun/Kconfig
> +++ b/drivers/net/ethernet/wangxun/Kconfig
> @@ -25,6 +25,9 @@ config NGBE
>  	tristate "Wangxun(R) GbE PCI Express adapters support"
>  	depends on PCI
>  	select LIBWX
> +	select PHYLIB
> +	select MARVELL_PHY
> +	select MOTORCOMM_PHY

Don't select specific PHYs. Distros build them all as modules.

> +int ngbe_phy_led_oem_hostif(struct ngbe_hw *hw, u32 *data)
> +{
> +	struct wx_hic_read_shadow_ram buffer;
> +	struct wx_hw *wxhw = &hw->wxhw;
> +	int status;

Please break the patch up into smaller chunks and write good commit
messages. I've no idea what this has to do with MDIO or PHY. Something
to do with controlling the PHYs LEDS?

It seems like you could have one patch adding the MDIO bus support,
and one patch adding calls to phylib. And then try to break the rest
up into logical collections of changes.

> +	ret = wx_stop_adapter(wxhw);
> +	if (ret != 0)
> +		return ret;
> +	val = WX_MIS_RST_LAN_RST(wxhw->bus.func);
> +	wr32(wxhw, WX_MIS_RST, val | rd32(wxhw, WX_MIS_RST));
> +
> +	ret = read_poll_timeout(rd32, val,
> +				!(val & (BIT(9) << wxhw->bus.func)), 1000,
> +				100000, false, wxhw, 0x10028);
> +	if (ret)
> +		wx_dbg(wxhw, "Lan reset exceed s maximum times.\n");
> +
> +	wr32(wxhw, NGBE_PHY_CONFIG(0x1f), 0xa43);
> +	ret = read_poll_timeout(rd32, val, val & 0x20, 1000,
> +				100000, false, wxhw, NGBE_PHY_CONFIG(0x1d));
> +	if (ret)
> +		wx_dbg(wxhw, "Gphy reset failed.\n");

What is this doing? Toggling a GPIO which is connected to the PHY
reset input?

> -	/* reset num_rar_entries to 128 */
> +	/* reset num_rar_entries to 32 */

This looks like an unrelated change, nothing to do with MDIO or PHY.

>  	switch (type_mask) {
>  	case NGBE_SUBID_M88E1512_SFP:
>  	case NGBE_SUBID_LY_M88E1512_SFP:
> -		hw->phy.type = ngbe_phy_m88e1512_sfi;
> +		hw->phy.type = ngbe_phy_mv_sfi;
>  		break;
>  	case NGBE_SUBID_M88E1512_RJ45:
> -		hw->phy.type = ngbe_phy_m88e1512;
> +		hw->phy.type = ngbe_phy_mv;
>  		break;
>  	case NGBE_SUBID_M88E1512_MIX:
> -		hw->phy.type = ngbe_phy_m88e1512_unknown;
> +		hw->phy.type = ngbe_phy_mv_mix;
>  		break;
>  	case NGBE_SUBID_YT8521S_SFP:
>  	case NGBE_SUBID_YT8521S_SFP_GPIO:
>  	case NGBE_SUBID_LY_YT8521S_SFP:
> -		hw->phy.type = ngbe_phy_yt8521s_sfi;
> +		hw->phy.type = ngbe_phy_yt_mix;
>  		break;
>  	case NGBE_SUBID_INTERNAL_YT8521S_SFP:
>  	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
> -		hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
> +		hw->phy.type = ngbe_phy_internal_yt_sfi;
>  		break;
>  	case NGBE_SUBID_RGMII_FPGA:
>  	case NGBE_SUBID_OCP_CARD:

Generally, a MAC driver does not care what sort of PHY is connected to
it. The PHY driver does all that is needed. So it is not clear to me
why you need this.


> @@ -481,6 +539,8 @@ static int ngbe_probe(struct pci_dev *pdev,
>  		   "PHY: %s, PBA No: Wang Xun GbE Family Controller\n",
>  		   hw->phy.type == ngbe_phy_internal ? "Internal" : "External");
>  	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
> +	/* print PCI link speed and width */
> +	pcie_print_link_status(pdev);

Also seems unrelated.

> +static int ngbe_phy_read_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum)
> +{
> +	u32 command = 0, device_type = 0;
> +	struct ngbe_hw *hw = bus->priv;
> +	struct wx_hw *wxhw = &hw->wxhw;
> +	u32 phy_data = 0;
> +	u32 val = 0;
> +	int ret = 0;
> +
> +	/* setup and write the address cycle command */
> +	command = NGBE_MSCA_RA(regnum) |
> +		  NGBE_MSCA_PA(phy_addr) |
> +		  NGBE_MSCA_DA(device_type);
> +	wr32(wxhw, NGBE_MSCA, command);
> +
> +	command = NGBE_MSCC_CMD(NGBE_MSCA_CMD_READ) |
> +		  NGBE_MSCC_BUSY |
> +		  NGBE_MDIO_CLK(6);
> +	wr32(wxhw, NGBE_MSCC, command);

It looks like you don't support C45? If so, please return -EOPNOTSUPP
if asked to do a C45 transaction.

> +static int ngbe_phy_read_reg(struct mii_bus *bus, int phy_addr, int regnum)
> +{
> +	struct ngbe_hw *hw = bus->priv;
> +	u16 phy_data = 0;
> +
> +	if (hw->mac_type == ngbe_mac_type_mdi)
> +		phy_data = ngbe_phy_read_reg_internal(bus, phy_addr, regnum);
> +	else if (hw->mac_type == ngbe_mac_type_rgmii)
> +		phy_data = ngbe_phy_read_reg_mdi(bus, phy_addr, regnum);

Do you have two mdio busses?

> +static void ngbe_gphy_wait_mdio_access_on(struct phy_device *phydev)
> +{
> +	u16 val;
> +	int ret;
> +
> +	/* select page to 0xa43*/
> +	phy_write(phydev, 0x1f, 0x0a43);
> +	/* wait to phy can access */
> +	ret = read_poll_timeout(phy_read, val, val & 0x20, 100,
> +				2000, false, phydev, 0x1d);

What is this doing? The MAC should not be directly accessing the PHY.

> +
> +	if (ret)
> +		phydev_err(phydev, "Access to phy timeout\n");
> +}
> +
> +static void ngbe_gphy_dis_eee(struct phy_device *phydev)
> +{
> +	phy_write(phydev, 0x1f, 0x0a4b);
> +	phy_write(phydev, 0x11, 0x1110);
> +	phy_write(phydev, 0x1f, 0x0000);
> +	phy_write(phydev, 0xd, 0x0007);
> +	phy_write(phydev, 0xe, 0x003c);
> +	phy_write(phydev, 0xd, 0x4007);
> +	phy_write(phydev, 0xe, 0x0000);

Again, the MAC should not be accessing the PHY. From the name, i'm
guessing your MAC does not support EEE? So you want to stop the PHY
advertising EEE?

This is how other MAC drivers do this:

	/* disable EEE autoneg, EEE not supported by TSNEP */
	memset(&ethtool_eee, 0, sizeof(ethtool_eee));
	phy_ethtool_set_eee(adapter->phydev, &ethtool_eee);

Please delete all code which directly access the PHY. You might need
to add new functionality to the PHY driver, but in general, it is not
needed, the existing PHY drivers should do what you need.

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
> +				 PHY_INTERFACE_MODE_RGMII);

Who is responsible for RGMII delays? In general, the PHY adds the
delay, so you pass PHY_INTERFACE_MODE_RGMII_ID here.

> +int ngbe_mdio_init(struct ngbe_hw *hw)
> +{
> +	struct pci_dev *pdev = hw->wxhw.pdev;
> +	int ret;
> +
> +	hw->mii_bus = devm_mdiobus_alloc(&pdev->dev);
> +	if (!hw->mii_bus)
> +		return -ENOMEM;
> +
> +	hw->mii_bus->name = "ngbe_mii_bus";
> +	hw->mii_bus->read = &ngbe_phy_read_reg;
> +	hw->mii_bus->write = &ngbe_phy_write_reg;
> +	hw->mii_bus->phy_mask = 0xfffffffe;
> +	hw->mii_bus->parent = &pdev->dev;
> +	hw->mii_bus->priv = hw;
> +
> +	snprintf(hw->mii_bus->id, MII_BUS_ID_SIZE, "ngbe-%x",
> +		 (pdev->bus->number << 8) |
> +		 pdev->devfn);
> +
> +	ret = devm_mdiobus_register(&pdev->dev, hw->mii_bus);
> +	if (ret)
> +		return ret;
> +
> +	hw->phydev = mdiobus_get_phy(hw->mii_bus, 0);

Is this a hardware limitation? Only address 0 is supported?

> +	if (!hw->phydev) {
> +		return -ENODEV;
> +	} else if (!hw->phydev->drv) {
> +		wx_err(&hw->wxhw,
> +		       "No dedicated PHY driver found for PHY ID 0x%08x.\n",
> +		       hw->phydev->phy_id);
> +		return -EUNATCH;
> +	}

That is probably wrong. The module could still be loading. It is only
when you connect the MAC to the PHY does it need to have a PHY
driver. At that point, if there is no driver loaded it will fall back
to the generic PHY driver. You don't see any other MAC driver with
code like this.

As a general comment, if you do something which no other driver does,
you are probably doing something you should not do.

    Andrew

