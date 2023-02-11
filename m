Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A936932C0
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 18:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBKRFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 12:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKRFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 12:05:43 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A221AF
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 09:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AXAntZXi28bsLBWXcc47aJMoY93CK0LptWTAtjnYB2s=; b=TTQh3d6D66spiOhmSAMR4EJ/wN
        LsGm/kavnuEtEn8ofsXY0ZyWi8ZH9QDrlTj2rb9pC0SilUYL787lA0Nonrc6hGRgILjlmOQTP915s
        uKhY/ayU6avHXL0CehnF5t3TCbuEEjGQx0PmpiJlxMRxMaVE2cJCT34lC3JusVAPEDrE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pQtJZ-004iLU-C7; Sat, 11 Feb 2023 18:05:29 +0100
Date:   Sat, 11 Feb 2023 18:05:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harsh Jain <h.jain@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, thomas.lendacky@amd.com, Raju.Rangoju@amd.com,
        Shyam-sundar.S-k@amd.com, harshjain.prof@gmail.com,
        abhijit.gangurde@amd.com, puneet.gupta@amd.com,
        nikhil.agarwal@amd.com, tarak.reddy@amd.com, netdev@vger.kernel.org
Subject: Re: [PATCH  5/6] net: ethernet: efct: Add ethtool support
Message-ID: <Y+fK2QF0r+R7barZ@lunn.ch>
References: <20230210130321.2898-1-h.jain@amd.com>
 <20230210130321.2898-6-h.jain@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210130321.2898-6-h.jain@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void efct_ethtool_get_drvinfo(struct net_device *net_dev,
> +				     struct ethtool_drvinfo *info)
> +{
> +	struct efct_device *efct_dev;
> +	struct efct_nic *efct;
> +
> +	efct = efct_netdev_priv(net_dev);
> +	efct_dev = efct_nic_to_device(efct);
> +	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> +	if (!in_interrupt()) {
> +		efct_mcdi_print_fwver(efct, info->fw_version, sizeof(info->fw_version));
> +		efct_mcdi_erom_ver(efct, info->erom_version, sizeof(info->erom_version));

What is the code path where ethtool ops are called in interrupt
context?

> +	} else {
> +		strscpy(info->fw_version, "N/A", sizeof(info->fw_version));
> +		strscpy(info->erom_version, "N/A", sizeof(info->erom_version));
> +	}
> +	strscpy(info->bus_info, pci_name(efct_dev->pci_dev), sizeof(info->bus_info));
> +	info->n_priv_flags = 0;

Why set it to zero?

> +	data += EFCT_ETHTOOL_SW_STAT_COUNT;
> +	for (i = 0; i < EFCT_MAX_CORE_TX_QUEUES; i++) {
> +		data[0] = efct->txq[i].tx_packets;
> +		data++;

pretty unusual way to do this, Why not *data++ = efct->txq[i].tx_packets ?

> +static int efct_ethtool_get_coalesce(struct net_device *net_dev,
> +				     struct ethtool_coalesce *coalesce,
> +				     struct kernel_ethtool_coalesce *kernel_coal,
> +				     struct netlink_ext_ack *extack)
> +{
> +	struct efct_nic *efct = efct_netdev_priv(net_dev);
> +	u32 tx_usecs, rx_usecs;
> +
> +	tx_usecs = 0;
> +	rx_usecs = 0;
> +	efct_get_tx_moderation(efct, &tx_usecs);
> +	efct_get_rx_moderation(efct, &rx_usecs);
> +	coalesce->tx_coalesce_usecs = tx_usecs;
> +	coalesce->tx_coalesce_usecs_irq = 0;
> +	coalesce->rx_coalesce_usecs = rx_usecs;
> +	coalesce->rx_coalesce_usecs_irq = 0;
> +	coalesce->use_adaptive_rx_coalesce = efct->irq_rx_adaptive;

As a general rule of thumb, in any linux get callbacks, you only need
to set values if they are not 0. So you can skip the irqs.

> +static int efct_ethtool_set_coalesce(struct net_device *net_dev,
> +				     struct ethtool_coalesce *coalesce,
> +				     struct kernel_ethtool_coalesce *kernel_coal,
> +				     struct netlink_ext_ack *extack)
> +{
> +	struct efct_nic *efct = efct_netdev_priv(net_dev);
> +	struct efct_ev_queue *evq;
> +	u32 tx_usecs, rx_usecs;
> +	u32 timer_max_us;
> +	bool tx = false;
> +	bool rx = false;
> +	int i;
> +
> +	tx_usecs = 0;
> +	rx_usecs = 0;
> +	timer_max_us = efct->timer_max_ns / 1000;
> +	evq = efct->evq;
> +
> +	if (coalesce->rx_coalesce_usecs_irq || coalesce->tx_coalesce_usecs_irq) {
> +		netif_err(efct, drv, efct->net_dev, "Only rx/tx_coalesce_usecs are supported\n");

This is not an error. This is just userspace not knowing what you
hardware can do. netif_dbg(), or nothing at all.

> +		return -EINVAL;

EOPNOTSUP would be more accurate. Your hardware cannot do it, so it is
not supported.

> +static int efct_ethtool_set_ringparam(struct net_device *net_dev,
> +				      struct ethtool_ringparam *ring,
> +				      struct kernel_ethtool_ringparam *kring,
> +				      struct netlink_ext_ack *ext_ack)
> +{
> +	struct efct_nic *efct = efct_netdev_priv(net_dev);
> +	u32 entries_per_buff, min_rx_num_entries;
> +	bool if_up = false;
> +	int rc;
> +
> +	if (ring->tx_pending != efct->txq[0].num_entries) {
> +		netif_err(efct, drv, efct->net_dev,
> +			  "Tx ring size changes not supported\n");

netif_dbg()

> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (ring->rx_pending == efct->rxq[0].num_entries)
> +		/* Nothing to do */
> +		return 0;
> +
> +	min_rx_num_entries = RX_MIN_DRIVER_BUFFS * DIV_ROUND_UP(efct->rxq[0].buffer_size,
> +								efct->rxq[0].pkt_stride);
> +	entries_per_buff = DIV_ROUND_UP(efct->rxq[0].buffer_size, efct->rxq[0].pkt_stride);
> +	if (ring->rx_pending % entries_per_buff || ring->rx_pending < min_rx_num_entries) {
> +		netif_err(efct, drv, efct->net_dev,
> +			  "Unsupported RX ring size. Should be multiple of %u and more than %u",
> +			  entries_per_buff, min_rx_num_entries);

netif_dbg()

> +		return -EINVAL;
> +	}
> +
> +	ASSERT_RTNL();
> +
> +	if (netif_running(net_dev)) {
> +		dev_close(net_dev);
> +		if_up = true;
> +	}
> +
> +	mutex_lock(&efct->state_lock);
> +	rc = efct_realloc_rx_evqs(efct, ring->rx_pending);
> +	mutex_unlock(&efct->state_lock);
> +
> +	if (rc) {
> +		netif_err(efct, drv, efct->net_dev,
> +			  "Failed reallocate rx evqs. Device disabled\n");

This not how it should work, precisely because of this problem of what
to do when there is no memory available. What you should do is first
allocate the memory needed for the new rings, and if that is
successful, free the old rings and swap to the new memory. If you
cannot allocate the new memory, no harm has been done, you still have
the rings, return -ENOMEM and life goes on.

> +int efct_mcdi_phy_set_ksettings(struct efct_nic *efct,
> +				const struct ethtool_link_ksettings *settings,
> +			       unsigned long *advertising)
> +{
> +	const struct ethtool_link_settings *base = &settings->base;
> +	struct efct_mcdi_phy_data *phy_cfg = efct->phy_data;
> +	u32 caps;
> +	int rc;
> +
> +	memcpy(advertising, settings->link_modes.advertising,
> +	       sizeof(__ETHTOOL_DECLARE_LINK_MODE_MASK()));

linkmode_copy()

> +
> +	/* Remove flow control settings that the MAC supports
> +	 * but that the PHY can't advertise.
> +	 */
> +	if (~phy_cfg->supported_cap & (1 << MC_CMD_PHY_CAP_PAUSE_LBN))
> +		__clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, advertising);
> +	if (~phy_cfg->supported_cap & (1 << MC_CMD_PHY_CAP_ASYM_LBN))
> +		__clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, advertising);

linkmode_clear_bit()

> +	.get_coalesce		= efct_ethtool_get_coalesce,
> +	.set_coalesce		= efct_ethtool_set_coalesce,
> +	.get_ringparam      = efct_ethtool_get_ringparam,
> +	.set_ringparam      = efct_ethtool_set_ringparam,

tab vs spaces issues. checkpatch.pl should of told you about that. You
are using checkpatch right?

    Andrew
