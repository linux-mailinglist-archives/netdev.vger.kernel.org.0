Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C192F2141F8
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 01:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgGCXh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 19:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbgGCXh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 19:37:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0B0420826;
        Fri,  3 Jul 2020 23:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593819448;
        bh=sceI8uPJ9HtHadoOMgw8HFD1MzvU7M9ZVJ/CMw7krP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gn0nXZgjETS23uNrvIB9iIIa1lT/Vmc+VtmkHegPDdvf99lCgtI4HR9Nl43G2ZVUA
         VhVzBPeS6T4ykYeMztWLupR79au2BXABymXgbr7Yv6fWmB/axDMDFCHLxY5r5OlvmH
         zIEMgsk4gS368NWKGUpeka1Yg4UT9fWvE/ooz8sI=
Date:   Fri, 3 Jul 2020 16:37:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/8] bnxt_en: Implement ethtool -X to set
 indirection table.
Message-ID: <20200703163726.63321b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593760787-31695-7-git-send-email-michael.chan@broadcom.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
        <1593760787-31695-7-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Jul 2020 03:19:45 -0400 Michael Chan wrote:
> With the new infrastructure in place, we can now support the setting of
> the indirection table from ethtool.
> 
> When changing channels, in a rare case that firmware cannot reserve the
> rings that were promised, the RSS map will revert to default.
> 
> v2: When changing channels, if the RSS table size changes and RSS map
>     is non-default, return error.

Sorry, still not what I had in mind :(

> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 6c90a94..0edb692 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -6061,6 +6061,10 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
>  		rx = rx_rings << 1;
>  	cp = sh ? max_t(int, tx, rx_rings) : tx + rx_rings;
>  	bp->tx_nr_rings = tx;
> +
> +	/* Reset the RSS indirection if we cannot reserve all the RX rings */
> +	if (rx_rings != bp->rx_nr_rings)
> +		bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;

Ethtool core will check that if user set RSS table explicitly and now
changes ring count - the RSS table will not point to rings which will
no longer exist. IOW if RSS table is set we're likely increasing the
number of rings, and I'd venture to guess that the FW is not gonna give
us less rings than we previously had. So it seems like we may be
clearing the flag, and the RSS table unnecessarily here.

What I was suggesting, was that it perhaps be better to modulo the
number or rings in __bnxt_fill_hw_rss_tbl* by the actual table size,
but leave the user-set RSS table in place. That'd be the lowest LoC.

Also I still think that there should be a warning printed when FW gave
us less rings than expected.

>  	bp->rx_nr_rings = rx_rings;
>  	bp->cp_nr_rings = cp;
>  
> @@ -8265,7 +8269,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
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
> index 46f3978..9098818 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -926,6 +926,13 @@ static int bnxt_set_channels(struct net_device *dev,
>  		return rc;
>  	}
>  
> +	if (bnxt_get_nr_rss_ctxs(bp, req_rx_rings) !=
> +	    bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings) &&
> +	    (dev->priv_flags & IFF_RXFH_CONFIGURED)) {

In this case copy the old values over and zero-fill the new rings.

> +		netdev_warn(dev, "RSS table size change required, RSS table entries must be default to proceed\n");
> +		return -EINVAL;
> +	}
> +
>  	if (netif_running(dev)) {
>  		if (BNXT_PF(bp)) {
>  			/* TODO CHIMP_FW: Send message to all VF's
> @@ -1315,6 +1322,35 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
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

I see in patch 4 there is a:

	bool no_rss = !(vnic->flags & BNXT_VNIC_RSS_FLAG);

Should there be some check here to only allow users to change the
indirection table if RSS is supported / allowed?
