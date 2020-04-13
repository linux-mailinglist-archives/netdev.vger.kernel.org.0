Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FEB1A6572
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 13:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgDMK6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 06:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgDMK6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 06:58:42 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4C4320692;
        Mon, 13 Apr 2020 10:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586775521;
        bh=dcquoavhxgzLuLJKdN8UbLT2HP2FiLe0SFjhYmnMn9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vwHPgr2kvcvPW/Qckg+RxSl6jnYwoBaz7zPiNxXhY2CwOSdN5ilUONX4wOTizjCVB
         PqmldxfguTCciTjUrVdBxrolYCqJK+HDGC2XlYdiIcAcHsTWXZYumYulXtOnXLu5L8
         JtaJMSOFgFvPmF4vZZfy4INhC1rhuLhoGlFr1PaA=
Date:   Mon, 13 Apr 2020 13:58:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Lauri Jakku <ljakku77@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd@realtek.com
Subject: Re: NET: r8168/r8169 identifying fix
Message-ID: <20200413105838.GK334007@unreal>
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote:
> From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001
> From: Lauri Jakku <lja@iki.fi>
> Date: Mon, 13 Apr 2020 13:18:35 +0300
> Subject: [PATCH] NET: r8168/r8169 identifying fix
>
> The driver installation determination made properly by
> checking PHY vs DRIVER id's.
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++---
>  drivers/net/phy/mdio_bus.c                | 11 +++-
>  2 files changed, 72 insertions(+), 9 deletions(-)

I would say that most of the code is debug prints.

>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index bf5bf05970a2..1ea6f121b561 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5149,6 +5149,9 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  {
>  	struct pci_dev *pdev = tp->pci_dev;
>  	struct mii_bus *new_bus;
> +	u32 phydev_id = 0;
> +	u32 phydrv_id = 0;
> +	u32 phydrv_id_mask = 0;
>  	int ret;
>
>  	new_bus = devm_mdiobus_alloc(&pdev->dev);
> @@ -5165,20 +5168,62 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  	new_bus->write = r8169_mdio_write_reg;
>
>  	ret = mdiobus_register(new_bus);
> +	dev_info(&pdev->dev,
> +		 "mdiobus_register: %s, %d\n",
> +		 new_bus->id, ret);
>  	if (ret)
>  		return ret;
>
>  	tp->phydev = mdiobus_get_phy(new_bus, 0);
> +
>  	if (!tp->phydev) {
>  		mdiobus_unregister(new_bus);
>  		return -ENODEV;
> -	} else if (!tp->phydev->drv) {
> -		/* Most chip versions fail with the genphy driver.
> -		 * Therefore ensure that the dedicated PHY driver is loaded.
> -		 */
> -		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
> -		mdiobus_unregister(new_bus);
> -		return -EUNATCH;
> +	} else {
> +		/* tp -> phydev ok */
> +		int everything_OK = 0;
> +
> +		/* Check driver id versus phy */
> +
> +		if (tp->phydev->drv) {
> +			u32 phydev_masked = 0xBEEFDEAD;
> +			u32 drv_masked = ~0;
> +			u32 phydev_match = ~0;
> +			u32 drv_match = 0xDEADBEEF;
> +
> +			phydev_id      = tp->phydev->phy_id;
> +			phydrv_id      = tp->phydev->drv->phy_id;
> +			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
> +
> +			drv_masked    = phydrv_id & phydrv_id_mask;
> +			phydev_masked = phydev_id & phydrv_id_mask;

Please don't do vertical space alignment, every change later near such
lines will be whitespace disaster.

Thanks

> +
> +			dev_debug(&pdev->dev,
> +				  "%s: ID Check: (%x -> %x), drv (%x -> %x)\n",
> +				new_bus->id, phydev_id, phydev_masked,
> +				phydrv_id, drv_masked);
> +
> +			phydev_match = phydev_masked & drv_masked;
> +			phydev_match = phydev_match == phydev_masked;
> +
> +			drv_match    = phydev_masked & drv_masked;
> +			drv_match    = drv_match == drv_masked;
> +
> +			dev_debug(&pdev->dev, "%s: ID Check: %x == %x\n",
> +				  new_bus->id, phydev_match, drv_match);
> +
> +			everything_OK = (phydev_match == drv_match);
> +		}
> +
> +		if (!everything_OK) {
> +			/* Most chip versions fail with the genphy driver.
> +			 * Therefore ensure that the dedicated PHY driver
> +			 * is loaded.
> +			 */
> +			dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
> +			mdiobus_unregister(new_bus);
> +			return -EUNATCH;
> +		}
>  	}
>
>  	/* PHY will be woken up in rtl_open() */
> @@ -5435,6 +5480,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	u64_stats_init(&tp->rx_stats.syncp);
>  	u64_stats_init(&tp->tx_stats.syncp);
>
> +	dev_dbg(&pdev->dev, "init: MAC\n");
>  	rtl_init_mac_address(tp);
>
>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
> @@ -5483,12 +5529,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	dev->hw_features |= NETIF_F_RXFCS;
>
>  	jumbo_max = rtl_jumbo_max(tp);
> +	dev_dbg(&pdev->dev, "init: jumbo max: %d\n", jumbo_max);
>  	if (jumbo_max)
>  		dev->max_mtu = jumbo_max;
>
> +	dev_dbg(&pdev->dev, "init: irq mask\n");
>  	rtl_set_irq_mask(tp);
>
>  	tp->fw_name = rtl_chip_infos[chipset].fw_name;
> +	dev_dbg(&pdev->dev, "init: FW name: %s\n", tp->fw_name);
>
>  	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
>  					    &tp->counters_phys_addr,
> @@ -5496,16 +5545,21 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (!tp->counters)
>  		return -ENOMEM;
>
> +	dev_dbg(&pdev->dev, "init: set driver data\n");
>  	pci_set_drvdata(pdev, dev);
>
> +	dev_dbg(&pdev->dev, "init: register mdio\n");
>  	rc = r8169_mdio_register(tp);
> +	dev_dbg(&pdev->dev, "init: mdio register: %d\n", rc);
>  	if (rc)
>  		return rc;
>
>  	/* chip gets powered up in rtl_open() */
> +	dev_dbg(&pdev->dev, "init: pll pwr down\n");
>  	rtl_pll_power_down(tp);
>
>  	rc = register_netdev(dev);
> +	dev_dbg(&pdev->dev, "init: netdev register: %d\n", rc);
>  	if (rc)
>  		goto err_mdio_unregister;
>
> @@ -5525,6 +5579,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (pci_dev_run_wake(pdev))
>  		pm_runtime_put_sync(&pdev->dev);
>
> +	dev_dbg(&pdev->dev, "init: ALL DONE!\n");
> +
>  	return 0;
>
>  err_mdio_unregister:
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 522760c8bca6..719ea48164f6 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -112,6 +112,9 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>  {
>  	struct mdio_device *mdiodev = bus->mdio_map[addr];
> +	struct phy_device *rv = NULL;
> +
> +	pr_debug("mii_bus %s addr %d, %p\n", bus->id, addr, mdiodev);
>
>  	if (!mdiodev)
>  		return NULL;
> @@ -119,7 +122,10 @@ struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>  	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
>  		return NULL;
>
> -	return container_of(mdiodev, struct phy_device, mdio);
> +	rv = container_of(mdiodev, struct phy_device, mdio);
> +	pr_debug("mii_bus OK? %s addr %d, %p -> %p\n",
> +		 bus->id, addr, mdiodev, rv);
> +	return rv;
>  }
>  EXPORT_SYMBOL(mdiobus_get_phy);
>
> @@ -645,10 +651,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
>
>  	bus->state = MDIOBUS_REGISTERED;
> -	pr_info("%s: probed\n", bus->name);
> +	pr_info("%s: probed (mdiobus_register)\n", bus->name);
>  	return 0;
>
>  error:
> +	pr_err("%s: Error while in mdiobus_register: %d\n", bus->name, err);
>  	while (--i >= 0) {
>  		mdiodev = bus->mdio_map[i];
>  		if (!mdiodev)
> --
> 2.26.0
>
>

> From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001
> From: Lauri Jakku <lja@iki.fi>
> Date: Mon, 13 Apr 2020 13:18:35 +0300
> Subject: [PATCH] NET: r8168/r8169 identifying fix
>
> The driver installation determination made properly by
> checking PHY vs DRIVER id's.
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++---
>  drivers/net/phy/mdio_bus.c                | 11 +++-
>  2 files changed, 72 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index bf5bf05970a2..1ea6f121b561 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5149,6 +5149,9 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  {
>  	struct pci_dev *pdev = tp->pci_dev;
>  	struct mii_bus *new_bus;
> +	u32 phydev_id = 0;
> +	u32 phydrv_id = 0;
> +	u32 phydrv_id_mask = 0;
>  	int ret;
>
>  	new_bus = devm_mdiobus_alloc(&pdev->dev);
> @@ -5165,20 +5168,62 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  	new_bus->write = r8169_mdio_write_reg;
>
>  	ret = mdiobus_register(new_bus);
> +	dev_info(&pdev->dev,
> +		 "mdiobus_register: %s, %d\n",
> +		 new_bus->id, ret);
>  	if (ret)
>  		return ret;
>
>  	tp->phydev = mdiobus_get_phy(new_bus, 0);
> +
>  	if (!tp->phydev) {
>  		mdiobus_unregister(new_bus);
>  		return -ENODEV;
> -	} else if (!tp->phydev->drv) {
> -		/* Most chip versions fail with the genphy driver.
> -		 * Therefore ensure that the dedicated PHY driver is loaded.
> -		 */
> -		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
> -		mdiobus_unregister(new_bus);
> -		return -EUNATCH;
> +	} else {
> +		/* tp -> phydev ok */
> +		int everything_OK = 0;
> +
> +		/* Check driver id versus phy */
> +
> +		if (tp->phydev->drv) {
> +			u32 phydev_masked = 0xBEEFDEAD;
> +			u32 drv_masked = ~0;
> +			u32 phydev_match = ~0;
> +			u32 drv_match = 0xDEADBEEF;
> +
> +			phydev_id      = tp->phydev->phy_id;
> +			phydrv_id      = tp->phydev->drv->phy_id;
> +			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
> +
> +			drv_masked    = phydrv_id & phydrv_id_mask;
> +			phydev_masked = phydev_id & phydrv_id_mask;
> +
> +			dev_debug(&pdev->dev,
> +				  "%s: ID Check: (%x -> %x), drv (%x -> %x)\n",
> +				new_bus->id, phydev_id, phydev_masked,
> +				phydrv_id, drv_masked);
> +
> +			phydev_match = phydev_masked & drv_masked;
> +			phydev_match = phydev_match == phydev_masked;
> +
> +			drv_match    = phydev_masked & drv_masked;
> +			drv_match    = drv_match == drv_masked;
> +
> +			dev_debug(&pdev->dev, "%s: ID Check: %x == %x\n",
> +				  new_bus->id, phydev_match, drv_match);
> +
> +			everything_OK = (phydev_match == drv_match);
> +		}
> +
> +		if (!everything_OK) {
> +			/* Most chip versions fail with the genphy driver.
> +			 * Therefore ensure that the dedicated PHY driver
> +			 * is loaded.
> +			 */
> +			dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
> +			mdiobus_unregister(new_bus);
> +			return -EUNATCH;
> +		}
>  	}
>
>  	/* PHY will be woken up in rtl_open() */
> @@ -5435,6 +5480,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	u64_stats_init(&tp->rx_stats.syncp);
>  	u64_stats_init(&tp->tx_stats.syncp);
>
> +	dev_dbg(&pdev->dev, "init: MAC\n");
>  	rtl_init_mac_address(tp);
>
>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
> @@ -5483,12 +5529,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	dev->hw_features |= NETIF_F_RXFCS;
>
>  	jumbo_max = rtl_jumbo_max(tp);
> +	dev_dbg(&pdev->dev, "init: jumbo max: %d\n", jumbo_max);
>  	if (jumbo_max)
>  		dev->max_mtu = jumbo_max;
>
> +	dev_dbg(&pdev->dev, "init: irq mask\n");
>  	rtl_set_irq_mask(tp);
>
>  	tp->fw_name = rtl_chip_infos[chipset].fw_name;
> +	dev_dbg(&pdev->dev, "init: FW name: %s\n", tp->fw_name);
>
>  	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
>  					    &tp->counters_phys_addr,
> @@ -5496,16 +5545,21 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (!tp->counters)
>  		return -ENOMEM;
>
> +	dev_dbg(&pdev->dev, "init: set driver data\n");
>  	pci_set_drvdata(pdev, dev);
>
> +	dev_dbg(&pdev->dev, "init: register mdio\n");
>  	rc = r8169_mdio_register(tp);
> +	dev_dbg(&pdev->dev, "init: mdio register: %d\n", rc);
>  	if (rc)
>  		return rc;
>
>  	/* chip gets powered up in rtl_open() */
> +	dev_dbg(&pdev->dev, "init: pll pwr down\n");
>  	rtl_pll_power_down(tp);
>
>  	rc = register_netdev(dev);
> +	dev_dbg(&pdev->dev, "init: netdev register: %d\n", rc);
>  	if (rc)
>  		goto err_mdio_unregister;
>
> @@ -5525,6 +5579,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (pci_dev_run_wake(pdev))
>  		pm_runtime_put_sync(&pdev->dev);
>
> +	dev_dbg(&pdev->dev, "init: ALL DONE!\n");
> +
>  	return 0;
>
>  err_mdio_unregister:
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 522760c8bca6..719ea48164f6 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -112,6 +112,9 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>  {
>  	struct mdio_device *mdiodev = bus->mdio_map[addr];
> +	struct phy_device *rv = NULL;
> +
> +	pr_debug("mii_bus %s addr %d, %p\n", bus->id, addr, mdiodev);
>
>  	if (!mdiodev)
>  		return NULL;
> @@ -119,7 +122,10 @@ struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>  	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
>  		return NULL;
>
> -	return container_of(mdiodev, struct phy_device, mdio);
> +	rv = container_of(mdiodev, struct phy_device, mdio);
> +	pr_debug("mii_bus OK? %s addr %d, %p -> %p\n",
> +		 bus->id, addr, mdiodev, rv);
> +	return rv;
>  }
>  EXPORT_SYMBOL(mdiobus_get_phy);
>
> @@ -645,10 +651,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
>
>  	bus->state = MDIOBUS_REGISTERED;
> -	pr_info("%s: probed\n", bus->name);
> +	pr_info("%s: probed (mdiobus_register)\n", bus->name);
>  	return 0;
>
>  error:
> +	pr_err("%s: Error while in mdiobus_register: %d\n", bus->name, err);
>  	while (--i >= 0) {
>  		mdiodev = bus->mdio_map[i];
>  		if (!mdiodev)
> --
> 2.26.0
>

