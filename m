Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35D941836A
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 18:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhIYQrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 12:47:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60058 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhIYQrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 12:47:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=o7RrNyTLvII2PuPWJBMcGQfHdo/eKyCWMGZoLfln+IQ=; b=UcE/c1k3HmXMJW09AtYqL3Olj/
        I5zpsxMLkvpQbZfM0/x8p/UCwgp9EszA+2dwgswvykxmzvzDBffkSjgd31wYKGAw1QOQCLP/e0Owi
        fX26aRowKwANqo5Dbh1hFFcG3Z5rzxVMpmqVmzEIDy8v7gvLNswpI8MiGI7vWCJsulEM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUAne-008Dvw-7Y; Sat, 25 Sep 2021 18:45:18 +0200
Date:   Sat, 25 Sep 2021 18:45:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>
Subject: Re: [PATCH net-next 3/5] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <YU9SHpn4ZJrjqNuF@lunn.ch>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
 <1632519891-26510-4-git-send-email-justinpopo6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1632519891-26510-4-git-send-email-justinpopo6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int bcmasp_probe(struct platform_device *pdev)
> +{
> +	struct bcmasp_priv *priv;
> +	struct device_node *ports_node, *intf_node;
> +	struct device *dev = &pdev->dev;
> +	int ret, i, wol_irq, count = 0;
> +	struct bcmasp_intf *intf;
> +	struct resource *r;
> +	u32 u32_reserved_filters_bitmask;
> +	DECLARE_BITMAP(reserved_filters_bitmask, ASP_RX_NET_FILTER_MAX);
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->irq = platform_get_irq(pdev, 0);
> +	if (priv->irq <= 0) {
> +		dev_err(dev, "invalid interrupt\n");
> +		return -EINVAL;
> +	}
> +
> +	priv->clk = devm_clk_get(dev, "sw_asp");
> +	if (IS_ERR(priv->clk)) {
> +		if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +		dev_warn(dev, "failed to request clock\n");
> +		priv->clk = NULL;
> +	}

devm_clk_get_optional() makes this simpler/

> +
> +	/* Base from parent node */
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base = devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(priv->base)) {
> +		dev_err(dev, "failed to iomap\n");
> +		return PTR_ERR(priv->base);
> +	}
> +
> +	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40));
> +	if (ret)
> +		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to set DMA mask: %d\n", ret);
> +		return ret;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, priv);
> +	priv->pdev = pdev;
> +	spin_lock_init(&priv->mda_lock);
> +	spin_lock_init(&priv->clk_lock);
> +	mutex_init(&priv->net_lock);
> +
> +	ret = clk_prepare_enable(priv->clk);
> +	if (ret)
> +		return ret;
> +
> +	/* Enable all clocks to ensure successful probing */
> +	bcmasp_core_clock_set(priv, ASP_CTRL_CLOCK_CTRL_ASP_ALL_DISABLE, 0);
> +
> +	/* Switch to the main clock */
> +	bcmasp_core_clock_select(priv, false);
> +
> +	_intr2_mask_set(priv, 0xffffffff);
> +	intr2_core_wl(priv, 0xffffffff, ASP_INTR2_CLEAR);
> +
> +	ret = devm_request_irq(&pdev->dev, priv->irq, bcmasp_isr, 0,
> +			       pdev->name, priv);
> +	if (ret) {
> +		dev_err(dev, "failed to request ASP interrupt: %d\n", ret);
> +		return ret;
> +	}

Do you need to undo clk_prepare_enable()? 

> +
> +	/* Register mdio child nodes */
> +	of_platform_populate(dev->of_node, bcmasp_mdio_of_match, NULL,
> +			     dev);
> +
> +	ret = of_property_read_u32(dev->of_node,
> +				   "brcm,reserved-net-filters-mask",
> +				   &u32_reserved_filters_bitmask);
> +	if (ret)
> +		u32_reserved_filters_bitmask = 0;
> +
> +	priv->net_filters_count_max = ASP_RX_NET_FILTER_MAX;
> +	bitmap_zero(reserved_filters_bitmask, priv->net_filters_count_max);
> +	bitmap_from_arr32(reserved_filters_bitmask,
> +			  &u32_reserved_filters_bitmask,
> +			  priv->net_filters_count_max);
> +
> +	/* Discover bitmask of reserved filters */
> +	for_each_set_bit(i, reserved_filters_bitmask, ASP_RX_NET_FILTER_MAX) {
> +		priv->net_filters[i].reserved = true;
> +		priv->net_filters_count_max--;
> +	}
> +
> +	/*
> +	 * ASP specific initialization, Needs to be done irregardless of
> +	 * of how many interfaces come up.
> +	 */
> +	bcmasp_core_init(priv);
> +	bcmasp_core_init_filters(priv);
> +
> +	ports_node = of_find_node_by_name(dev->of_node, "ethernet-ports");
> +	if (!ports_node) {
> +		dev_warn(dev, "No ports found\n");
> +		return 0;
> +	}
> +
> +	priv->intf_count = of_get_available_child_count(ports_node);
> +
> +	priv->intfs = devm_kcalloc(dev, priv->intf_count,
> +				   sizeof(struct bcmasp_intf *),
> +				   GFP_KERNEL);
> +	if (!priv->intfs)
> +		return -ENOMEM;
> +
> +	/* Probe each interface (Initalization should continue even if
> +	 * interfaces are unable to come up)
> +	 */
> +	i = 0;
> +	for_each_available_child_of_node(ports_node, intf_node) {
> +		wol_irq = platform_get_irq_optional(pdev, i + 1);
> +		priv->intfs[i++] = bcmasp_interface_create(priv, intf_node,
> +							   wol_irq);
> +	}
> +
> +	/* Drop the clock reference count now and let ndo_open()/ndo_close()
> +	 * manage it for us from now on.
> +	 */
> +	bcmasp_core_clock_set(priv, 0, ASP_CTRL_CLOCK_CTRL_ASP_ALL_DISABLE);
> +
> +	clk_disable_unprepare(priv->clk);
> +
> +	/* Now do the registration of the network ports which will take care of
> +	 * managing the clock properly.
> +	 */
> +	for (i = 0; i < priv->intf_count; i++) {
> +		intf = priv->intfs[i];
> +		if (!intf)
> +			continue;
> +
> +		ret = register_netdev(intf->ndev);
> +		if (ret) {
> +			netdev_err(intf->ndev,
> +				   "failed to register net_device: %d\n", ret);
> +			bcmasp_interface_destroy(intf, false);
> +			continue;
> +		}
> +		count++;
> +	}
> +
> +	dev_info(dev, "Initialized %d port(s)\n", count);
> +
> +	return 0;
> +}
> +
> +static int bcmasp_remove(struct platform_device *pdev)
> +{
> +	struct bcmasp_priv *priv = dev_get_drvdata(&pdev->dev);
> +	struct bcmasp_intf *intf;
> +	int i;
> +
> +	for (i = 0; i < priv->intf_count; i++) {
> +		intf = priv->intfs[i];
> +		if (!intf)
> +			continue;
> +
> +		bcmasp_interface_destroy(intf, true);
> +	}
> +
> +	return 0;
> +}

Do you need to depopulate the mdio children?

> +static void bcmasp_get_drvinfo(struct net_device *dev,
> +			       struct ethtool_drvinfo *info)
> +{
> +	strlcpy(info->driver, "bcmasp", sizeof(info->driver));
> +	strlcpy(info->version, "v2.0", sizeof(info->version));

Please drop version. The core will fill it in with the kernel version,
which is more useful.

> +static int bcmasp_nway_reset(struct net_device *dev)
> +{
> +	if (!dev->phydev)
> +		return -ENODEV;
> +
> +	return genphy_restart_aneg(dev->phydev);
> +}

phy_ethtool_nway_reset().


> +static void bcmasp_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
> +{
> +	struct bcmasp_intf *intf = netdev_priv(dev);
> +
> +	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
> +	wol->wolopts = intf->wolopts;
> +	memset(wol->sopass, 0, sizeof(wol->sopass));
> +
> +	if (wol->wolopts & WAKE_MAGICSECURE)
> +		memcpy(wol->sopass, intf->sopass, sizeof(intf->sopass));
> +}

Maybe consider calling into the PHY to see what it can do? If the PHY
can do the WoL you want, it will do it with less power.

> +static int bcmasp_set_priv_flags(struct net_device *dev, u32 flags)
> +{
> +	struct bcmasp_intf *intf = netdev_priv(dev);
> +
> +	intf->wol_keep_rx_en = flags & BCMASP_WOL_KEEP_RX_EN ? 1 : 0;
> +
> +	return 0;

Please could you explain this some more. How can you disable RX and
still have WoL working?

> +static void bcmasp_adj_link(struct net_device *dev)
> +{
> +	struct bcmasp_intf *intf = netdev_priv(dev);
> +	struct phy_device *phydev = dev->phydev;
> +	int changed = 0;
> +	u32 cmd_bits = 0, reg;
> +
> +	if (intf->old_link != phydev->link) {
> +		changed = 1;
> +		intf->old_link = phydev->link;
> +	}
> +
> +	if (intf->old_duplex != phydev->duplex) {
> +		changed = 1;
> +		intf->old_duplex = phydev->duplex;
> +	}
> +
> +	switch (phydev->speed) {
> +	case SPEED_2500:
> +		cmd_bits = UMC_CMD_SPEED_2500;

All i've seen is references to RGMII. Is 2500 possible?

> +		break;
> +	case SPEED_1000:
> +		cmd_bits = UMC_CMD_SPEED_1000;
> +		break;
> +	case SPEED_100:
> +		cmd_bits = UMC_CMD_SPEED_100;
> +		break;
> +	case SPEED_10:
> +		cmd_bits = UMC_CMD_SPEED_10;
> +		break;
> +	default:
> +		break;
> +	}
> +	cmd_bits <<= UMC_CMD_SPEED_SHIFT;
> +
> +	if (phydev->duplex == DUPLEX_HALF)
> +		cmd_bits |= UMC_CMD_HD_EN;
> +
> +	if (intf->old_pause != phydev->pause) {
> +		changed = 1;
> +		intf->old_pause = phydev->pause;
> +	}
> +
> +	if (!phydev->pause)
> +		cmd_bits |= UMC_CMD_RX_PAUSE_IGNORE | UMC_CMD_TX_PAUSE_IGNORE;
> +
> +	if (!changed)
> +		return;

Shouldn't there be a comparison intd->old_speed != phydev->speed?  You
are risking the PHY can change speed without doing a link down/up?

> +
> +	if (phydev->link) {
> +		reg = umac_rl(intf, UMC_CMD);
> +		reg &= ~((UMC_CMD_SPEED_MASK << UMC_CMD_SPEED_SHIFT) |
> +			UMC_CMD_HD_EN | UMC_CMD_RX_PAUSE_IGNORE |
> +			UMC_CMD_TX_PAUSE_IGNORE);
> +		reg |= cmd_bits;
> +		umac_wl(intf, reg, UMC_CMD);
> +
> +		/* Enable RGMII pad */
> +		reg = rgmii_rl(intf, RGMII_OOB_CNTRL);
> +		reg |= RGMII_MODE_EN;
> +		rgmii_wl(intf, reg, RGMII_OOB_CNTRL);
> +
> +		intf->eee.eee_active = phy_init_eee(phydev, 0) >= 0;
> +		bcmasp_eee_enable_set(intf, intf->eee.eee_active);
> +	} else {
> +		/* Disable RGMII pad */
> +		reg = rgmii_rl(intf, RGMII_OOB_CNTRL);
> +		reg &= ~RGMII_MODE_EN;
> +		rgmii_wl(intf, reg, RGMII_OOB_CNTRL);
> +	}
> +
> +	if (changed)
> +		phy_print_status(phydev);

There has already been a return if !changed.

> +static void bcmasp_configure_port(struct bcmasp_intf *intf)
> +{
> +	u32 reg, id_mode_dis = 0;
> +
> +	reg = rgmii_rl(intf, RGMII_PORT_CNTRL);
> +	reg &= ~RGMII_PORT_MODE_MASK;
> +
> +	switch (intf->phy_interface) {
> +	case PHY_INTERFACE_MODE_RGMII:
> +		/* RGMII_NO_ID: TXC transitions at the same time as TXD
> +		 *		(requires PCB or receiver-side delay)
> +		 * RGMII:	Add 2ns delay on TXC (90 degree shift)
> +		 *
> +		 * ID is implicitly disabled for 100Mbps (RG)MII operation.
> +		 */
> +		id_mode_dis = RGMII_ID_MODE_DIS;
> +		fallthrough;
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		reg |= RGMII_PORT_MODE_EXT_GPHY;
> +		break;
> +	case PHY_INTERFACE_MODE_MII:
> +		reg |= RGMII_PORT_MODE_EXT_EPHY;
> +		break;
> +	default:
> +		break;
> +	}

Can we skip this and let the PHY do the delays? Ah, "This is an ugly
quirk..." Maybe add a comment here pointing towards
bcmasp_netif_init(), which is explains this.

> +static int bcmasp_netif_init(struct net_device *dev, bool phy_connect,
> +			     bool init_rx)
> +{
> +	struct bcmasp_intf *intf = netdev_priv(dev);
> +	phy_interface_t phy_iface = intf->phy_interface;
> +	u32 phy_flags = PHY_BRCM_AUTO_PWRDWN_ENABLE |
> +			PHY_BRCM_DIS_TXCRXC_NOENRGY |
> +			PHY_BRCM_IDDQ_SUSPEND;
> +	struct phy_device *phydev = NULL;
> +	int ret;
> +
> +	/* Always enable interface clocks */
> +	bcmasp_core_clock_set_intf(intf, true);
> +
> +	/* Enable internal PHY before any MAC activity */
> +	if (intf->internal_phy)
> +		bcmasp_ephy_enable_set(intf, true);
> +
> +	bcmasp_configure_port(intf);
> +
> +	/* This is an ugly quirk but we have not been correctly interpreting
> +	 * the phy_interface values and we have done that across different
> +	 * drivers, so at least we are consistent in our mistakes.
> +	 *
> +	 * When the Generic PHY driver is in use either the PHY has been
> +	 * strapped or programmed correctly by the boot loader so we should
> +	 * stick to our incorrect interpretation since we have validated it.
> +	 *
> +	 * Now when a dedicated PHY driver is in use, we need to reverse the
> +	 * meaning of the phy_interface_mode values to something that the PHY
> +	 * driver will interpret and act on such that we have two mistakes
> +	 * canceling themselves so to speak. We only do this for the two
> +	 * modes that GENET driver officially supports on Broadcom STB chips:
> +	 * PHY_INTERFACE_MODE_RGMII and PHY_INTERFACE_MODE_RGMII_TXID. Other
> +	 * modes are not *officially* supported with the boot loader and the
> +	 * scripted environment generating Device Tree blobs for those
> +	 * platforms.
> +	 *
> +	 * Note that internal PHY and fixed-link configurations are not
> +	 * affected because they use different phy_interface_t values or the
> +	 * Generic PHY driver.
> +	 */


> +static inline void bcmasp_map_res(struct bcmasp_priv *priv,
> +				  struct bcmasp_intf *intf)
> +{
> +	/* Per port */
> +	intf->res.umac = priv->base + UMC_OFFSET(intf);
> +	intf->res.umac2fb = priv->base + UMAC2FB_OFFSET(intf);
> +	intf->res.rgmii = priv->base + RGMII_OFFSET(intf);
> +
> +	/* Per ch */
> +	intf->tx_spb_dma = priv->base + TX_SPB_DMA_OFFSET(intf);
> +	intf->res.tx_spb_ctrl = priv->base + TX_SPB_CTRL_OFFSET(intf);
> +	/*
> +	 * Stop gap solution. This should be removed when 72165a0 is
> +	 * deprecated
> +	 */

Is that an internal commit?

   Andrew
