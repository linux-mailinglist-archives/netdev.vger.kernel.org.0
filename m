Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758481A6642
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 14:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgDMMT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 08:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgDMMTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 08:19:03 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60D7320753;
        Mon, 13 Apr 2020 12:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586780342;
        bh=2DrwZWsBxVGP8vxqOiu+Su9aarPeIvjYnO/n3J6vhLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZeEJ+nRuITBrg3/ADWy1eFrS/jMFxJssTWL5SeYGnpBaL2o4gkWvcqsIfUm0+Atgn
         SwX0NEnNlNiKSjRZE1g24Fc4iSkFw0cnR5GeKV9G3XBIpkVe0dctxP/Wh0laCifovM
         oYS4pRtMleHiNk2hwmi3gZtLALZYedYOXLeDybeg=
Date:   Mon, 13 Apr 2020 15:18:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Lauri Jakku <lauri.jakku@pp.inet.fi>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd@realtek.com
Subject: Re: NET: r8168/r8169 identifying fix
Message-ID: <20200413121858.GN334007@unreal>
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <06489204-2bec-fe64-4dbd-7abe4c585c23@pp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06489204-2bec-fe64-4dbd-7abe4c585c23@pp.inet.fi>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 03:01:23PM +0300, Lauri Jakku wrote:
> Hi,
>
> I've tought that the debug's are worth to save behind an definition/commented out, so they can be enabled if needed.
>

Please stop to do top-posting.

>
> Latest version:
>
> From 1a75f6f9065a58180de1fa3c48fd80418af6c347 Mon Sep 17 00:00:00 2001
> From: Lauri Jakku <lja@iki.fi>
> Date: Mon, 13 Apr 2020 13:18:35 +0300
> Subject: [PATCH] NET: r8168/r8169 identifying fix
>
> The driver installation determination made properly by
> checking PHY vs DRIVER id's.
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 114 ++++++++++++++++++++--
>  drivers/net/phy/mdio_bus.c                |  15 ++-
>  2 files changed, 119 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index bf5bf05970a2..5e992f285527 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -61,6 +61,11 @@
>  #define R8169_MSG_DEFAULT \
>  	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
>
> +
> +/*
> +#define R8169_PROBE_DEBUG
> +*/

Of course not, it is even worse than before.
If user recompiles module, he will add prints.

Thanks

> +
>  /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
>     The RTL chips use a 64 element hash table based on the Ethernet CRC. */
>  #define	MC_FILTER_LIMIT	32
> @@ -5149,6 +5154,9 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  {
>  	struct pci_dev *pdev = tp->pci_dev;
>  	struct mii_bus *new_bus;
> +	u32 phydev_id = 0;
> +	u32 phydrv_id = 0;
> +	u32 phydrv_id_mask = 0;
>  	int ret;
>
>  	new_bus = devm_mdiobus_alloc(&pdev->dev);
> @@ -5165,20 +5173,69 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  	new_bus->write = r8169_mdio_write_reg;
>
>  	ret = mdiobus_register(new_bus);
> +
> +#ifdef R8169_PROBE_DEBUG
> +	dev_info(&pdev->dev,
> +		 "mdiobus_register: %s, %d\n",
> +		 new_bus->id, ret);
> +#endif
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
> +			phydev_id = tp->phydev->phy_id;
> +			phydrv_id = tp->phydev->drv->phy_id;
> +			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
> +
> +			drv_masked = phydrv_id & phydrv_id_mask;
> +			phydev_masked = phydev_id & phydrv_id_mask;
> +
> +#ifdef R8169_PROBE_DEBUG
> +			dev_debug(&pdev->dev,
> +				  "%s: ID Check: (%x -> %x), drv (%x -> %x)\n",
> +				new_bus->id, phydev_id, phydev_masked,
> +				phydrv_id, drv_masked);
> +#endif
> +
> +			phydev_match = phydev_masked & drv_masked;
> +			phydev_match = phydev_match == phydev_masked;
> +
> +			drv_match = phydev_masked & drv_masked;
> +			drv_match = drv_match == drv_masked;
> +
> +#ifdef R8169_PROBE_DEBUG
> +			dev_debug(&pdev->dev, "%s: ID Check: %x == %x\n",
> +				  new_bus->id, phydev_match, drv_match);
> +#endif
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
> @@ -5435,6 +5492,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	u64_stats_init(&tp->rx_stats.syncp);
>  	u64_stats_init(&tp->tx_stats.syncp);
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: MAC\n");
> +#endif
> +
>  	rtl_init_mac_address(tp);
>
>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
> @@ -5483,29 +5544,64 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	dev->hw_features |= NETIF_F_RXFCS;
>
>  	jumbo_max = rtl_jumbo_max(tp);
> +
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: jumbo max: %d\n", jumbo_max);
> +#endif
> +
>  	if (jumbo_max)
>  		dev->max_mtu = jumbo_max;
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: irq mask\n");
> +#endif
> +
>  	rtl_set_irq_mask(tp);
>
>  	tp->fw_name = rtl_chip_infos[chipset].fw_name;
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: FW name: %s\n", tp->fw_name);
> +#endif
> +
>  	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
>  					    &tp->counters_phys_addr,
>  					    GFP_KERNEL);
>  	if (!tp->counters)
>  		return -ENOMEM;
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: set driver data\n");
> +#endif
> +
>  	pci_set_drvdata(pdev, dev);
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: register mdio\n");
> +#endif
> +
>  	rc = r8169_mdio_register(tp);
> +
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: mdio register: %d\n", rc);
> +#endif
> +
>  	if (rc)
>  		return rc;
>
>  	/* chip gets powered up in rtl_open() */
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: pll pwr down\n");
> +#endif
> +
>  	rtl_pll_power_down(tp);
>
>  	rc = register_netdev(dev);
> +
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: netdev register: %d\n", rc);
> +#endif
> +
>  	if (rc)
>  		goto err_mdio_unregister;
>
> @@ -5525,6 +5621,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (pci_dev_run_wake(pdev))
>  		pm_runtime_put_sync(&pdev->dev);
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: ALL DONE!\n");
> +#endif
> +
>  	return 0;
>
>  err_mdio_unregister:
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 522760c8bca6..41777f379a57 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -112,14 +112,22 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>  {
>  	struct mdio_device *mdiodev = bus->mdio_map[addr];
> -
> +	struct phy_device *rv = NULL;
> +/*
> +	pr_debug("mii_bus %s addr %d, %p\n", bus->id, addr, mdiodev);
> +*/
>  	if (!mdiodev)
>  		return NULL;
>
>  	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
>  		return NULL;
>
> -	return container_of(mdiodev, struct phy_device, mdio);
> +	rv = container_of(mdiodev, struct phy_device, mdio);
> +/*
> + 	pr_debug("mii_bus OK? %s addr %d, %p -> %p\n",
> +		 bus->id, addr, mdiodev, rv);
> +*/
> +	return rv;
>  }
>  EXPORT_SYMBOL(mdiobus_get_phy);
>
> @@ -645,10 +653,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
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
>
>
> On 2020-04-13 14:34, Leon Romanovsky wrote:
> > On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote:
> >> Hi,
> >>
> >> Comments inline.
> >>
> >> On 2020-04-13 13:58, Leon Romanovsky wrote:
> >>> On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote:
> >>>> From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001
> >>>> From: Lauri Jakku <lja@iki.fi>
> >>>> Date: Mon, 13 Apr 2020 13:18:35 +0300
> >>>> Subject: [PATCH] NET: r8168/r8169 identifying fix
> >>>>
> >>>> The driver installation determination made properly by
> >>>> checking PHY vs DRIVER id's.
> >>>> ---
> >>>>  drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++---
> >>>>  drivers/net/phy/mdio_bus.c                | 11 +++-
> >>>>  2 files changed, 72 insertions(+), 9 deletions(-)
> >>>
> >>> I would say that most of the code is debug prints.
> >>>
> >>
> >> I tought that they are helpful to keep, they are using the debug calls, so
> >> they are not visible if user does not like those.
> >
> > You are missing the point of who are your users.
> >
> > Users want to have working device and the code. They don't need or like
> > to debug their kernel.
> >
> > Thanks
> >
>
> --
> Br,
> Lauri J.

> From 1a75f6f9065a58180de1fa3c48fd80418af6c347 Mon Sep 17 00:00:00 2001
> From: Lauri Jakku <lja@iki.fi>
> Date: Mon, 13 Apr 2020 13:18:35 +0300
> Subject: [PATCH] NET: r8168/r8169 identifying fix
>
> The driver installation determination made properly by
> checking PHY vs DRIVER id's.
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 114 ++++++++++++++++++++--
>  drivers/net/phy/mdio_bus.c                |  15 ++-
>  2 files changed, 119 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index bf5bf05970a2..5e992f285527 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -61,6 +61,11 @@
>  #define R8169_MSG_DEFAULT \
>  	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
>
> +
> +/*
> +#define R8169_PROBE_DEBUG
> +*/
> +
>  /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
>     The RTL chips use a 64 element hash table based on the Ethernet CRC. */
>  #define	MC_FILTER_LIMIT	32
> @@ -5149,6 +5154,9 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  {
>  	struct pci_dev *pdev = tp->pci_dev;
>  	struct mii_bus *new_bus;
> +	u32 phydev_id = 0;
> +	u32 phydrv_id = 0;
> +	u32 phydrv_id_mask = 0;
>  	int ret;
>
>  	new_bus = devm_mdiobus_alloc(&pdev->dev);
> @@ -5165,20 +5173,69 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  	new_bus->write = r8169_mdio_write_reg;
>
>  	ret = mdiobus_register(new_bus);
> +
> +#ifdef R8169_PROBE_DEBUG
> +	dev_info(&pdev->dev,
> +		 "mdiobus_register: %s, %d\n",
> +		 new_bus->id, ret);
> +#endif
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
> +			phydev_id = tp->phydev->phy_id;
> +			phydrv_id = tp->phydev->drv->phy_id;
> +			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
> +
> +			drv_masked = phydrv_id & phydrv_id_mask;
> +			phydev_masked = phydev_id & phydrv_id_mask;
> +
> +#ifdef R8169_PROBE_DEBUG
> +			dev_debug(&pdev->dev,
> +				  "%s: ID Check: (%x -> %x), drv (%x -> %x)\n",
> +				new_bus->id, phydev_id, phydev_masked,
> +				phydrv_id, drv_masked);
> +#endif
> +
> +			phydev_match = phydev_masked & drv_masked;
> +			phydev_match = phydev_match == phydev_masked;
> +
> +			drv_match = phydev_masked & drv_masked;
> +			drv_match = drv_match == drv_masked;
> +
> +#ifdef R8169_PROBE_DEBUG
> +			dev_debug(&pdev->dev, "%s: ID Check: %x == %x\n",
> +				  new_bus->id, phydev_match, drv_match);
> +#endif
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
> @@ -5435,6 +5492,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	u64_stats_init(&tp->rx_stats.syncp);
>  	u64_stats_init(&tp->tx_stats.syncp);
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: MAC\n");
> +#endif
> +
>  	rtl_init_mac_address(tp);
>
>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
> @@ -5483,29 +5544,64 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	dev->hw_features |= NETIF_F_RXFCS;
>
>  	jumbo_max = rtl_jumbo_max(tp);
> +
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: jumbo max: %d\n", jumbo_max);
> +#endif
> +
>  	if (jumbo_max)
>  		dev->max_mtu = jumbo_max;
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: irq mask\n");
> +#endif
> +
>  	rtl_set_irq_mask(tp);
>
>  	tp->fw_name = rtl_chip_infos[chipset].fw_name;
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: FW name: %s\n", tp->fw_name);
> +#endif
> +
>  	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
>  					    &tp->counters_phys_addr,
>  					    GFP_KERNEL);
>  	if (!tp->counters)
>  		return -ENOMEM;
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: set driver data\n");
> +#endif
> +
>  	pci_set_drvdata(pdev, dev);
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: register mdio\n");
> +#endif
> +
>  	rc = r8169_mdio_register(tp);
> +
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: mdio register: %d\n", rc);
> +#endif
> +
>  	if (rc)
>  		return rc;
>
>  	/* chip gets powered up in rtl_open() */
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: pll pwr down\n");
> +#endif
> +
>  	rtl_pll_power_down(tp);
>
>  	rc = register_netdev(dev);
> +
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: netdev register: %d\n", rc);
> +#endif
> +
>  	if (rc)
>  		goto err_mdio_unregister;
>
> @@ -5525,6 +5621,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (pci_dev_run_wake(pdev))
>  		pm_runtime_put_sync(&pdev->dev);
>
> +#ifdef R816X_PROBE_DEBUG
> +	dev_dbg(&pdev->dev, "init: ALL DONE!\n");
> +#endif
> +
>  	return 0;
>
>  err_mdio_unregister:
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 522760c8bca6..41777f379a57 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -112,14 +112,22 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>  {
>  	struct mdio_device *mdiodev = bus->mdio_map[addr];
> -
> +	struct phy_device *rv = NULL;
> +/*
> +	pr_debug("mii_bus %s addr %d, %p\n", bus->id, addr, mdiodev);
> +*/
>  	if (!mdiodev)
>  		return NULL;
>
>  	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
>  		return NULL;
>
> -	return container_of(mdiodev, struct phy_device, mdio);
> +	rv = container_of(mdiodev, struct phy_device, mdio);
> +/*
> + 	pr_debug("mii_bus OK? %s addr %d, %p -> %p\n",
> +		 bus->id, addr, mdiodev, rv);
> +*/
> +	return rv;
>  }
>  EXPORT_SYMBOL(mdiobus_get_phy);
>
> @@ -645,10 +653,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
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

