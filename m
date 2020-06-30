Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9AF20E9E0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgF3AGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbgF3AGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:06:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D65120780;
        Tue, 30 Jun 2020 00:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593475580;
        bh=E+PkJChncUxMWK/MK1xlsUqYxh2uI8xkpIzc90fkcms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M2dXbaVg43CnTUsLZqzDax6uzNA16/UfGmyfa25TDnoIMDEG/XWfjCOJoH16GDKUW
         E1K+S+q1OvO6c5uEwdQDFUz7nwV6MgCeYDA1MF84uPZC9gQ/q4kOUN8KSwMc/t2Ch7
         Ev5IQA6ZygrtQEmwwOxE97J8ZSVbZ5YddoVCyrr0=
Date:   Mon, 29 Jun 2020 17:06:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 6/8] bnxt_en: Implement ethtool -X to set
 indirection table.
Message-ID: <20200629170618.2b265417@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593412464-503-7-git-send-email-michael.chan@broadcom.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
        <1593412464-503-7-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 02:34:22 -0400 Michael Chan wrote:
> With the new infrastructure in place, we can now support the setting of
> the indirection table from ethtool.
> 
> The user-configured indirection table will need to be reset to default
> if we are unable to reserve the requested number of RX rings or if the
> RSS table size changes.
> 
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Hm. Clearing IFF_RXFH_CONFIGURED seems wrong. The user has clearly
requested a RSS mapping, if it can't be maintained driver should 
return an error from the operation which attempts to change the ring
count.

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 87d37dc..eb7f2d4 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -6063,6 +6063,10 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
>  		rx = rx_rings << 1;
>  	cp = sh ? max_t(int, tx, rx_rings) : tx + rx_rings;
>  	bp->tx_nr_rings = tx;
> +
> +	/* Reset the RSS indirection if we cannot reserve all the RX rings */
> +	if (rx_rings != bp->rx_nr_rings)
> +		bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
>  	bp->rx_nr_rings = rx_rings;
>  	bp->cp_nr_rings = cp;
>  
> @@ -8267,7 +8271,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
>  			rc = bnxt_init_int_mode(bp);
>  		bnxt_ulp_irq_restart(bp, rc);
>  	}
> -	bnxt_set_dflt_rss_indir_tbl(bp);
> +	if (!netif_is_rxfh_configured(bp->dev))
> +		bnxt_set_dflt_rss_indir_tbl(bp);
>  
>  	if (rc) {
>  		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index 46f3978..ae10ebd 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -926,6 +926,10 @@ static int bnxt_set_channels(struct net_device *dev,
>  		return rc;
>  	}
>  
> +	if (bnxt_get_nr_rss_ctxs(bp, req_rx_rings) !=
> +	    bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings))
> +		bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
> +
>  	if (netif_running(dev)) {
>  		if (BNXT_PF(bp)) {
>  			/* TODO CHIMP_FW: Send message to all VF's
> @@ -1315,6 +1319,35 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
>  	return 0;
>  }
>  
> +static int bnxt_set_rxfh(struct net_device *dev, const u32 *indir,
> +			 const u8 *key, const u8 hfunc)
> +{
> +	struct bnxt *bp = netdev_priv(dev);
> +	int rc = 0;
> +
> +	if (hfunc && hfunc != ETH_RSS_HASH_TOP)
> +		return -EOPNOTSUPP;
> +
> +	if (key)
> +		return -EOPNOTSUPP;
> +
> +	if (indir) {
> +		u32 i, pad, tbl_size = bnxt_get_rxfh_indir_size(dev);
> +
> +		for (i = 0; i < tbl_size; i++)
> +			bp->rss_indir_tbl[i] = indir[i];
> +		pad = bp->rss_indir_tbl_entries - tbl_size;
> +		if (pad)
> +			memset(&bp->rss_indir_tbl[i], 0, pad * sizeof(u16));
> +	}
> +
> +	if (netif_running(bp->dev)) {
> +		bnxt_close_nic(bp, false, false);
> +		rc = bnxt_open_nic(bp, false, false);

Ah, FWIW this makes the feature far less useful for use cases which try
to work around the inability to create/take down queues without
impacting all traffic, but it's probably still useful for asymmetric
traffic distribution.

> +	}
> +	return rc;
> +}
> +
>  static void bnxt_get_drvinfo(struct net_device *dev,
>  			     struct ethtool_drvinfo *info)
>  {
> @@ -3621,6 +3654,7 @@ void bnxt_ethtool_free(struct bnxt *bp)
>  	.get_rxfh_indir_size    = bnxt_get_rxfh_indir_size,
>  	.get_rxfh_key_size      = bnxt_get_rxfh_key_size,
>  	.get_rxfh               = bnxt_get_rxfh,
> +	.set_rxfh		= bnxt_set_rxfh,
>  	.flash_device		= bnxt_flash_device,
>  	.get_eeprom_len         = bnxt_get_eeprom_len,
>  	.get_eeprom             = bnxt_get_eeprom,

