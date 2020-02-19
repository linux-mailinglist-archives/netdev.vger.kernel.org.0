Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9D21645E9
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 14:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgBSNqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 08:46:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726551AbgBSNqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 08:46:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582120014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AsOAJntgYEqLqQBm6Er/vhjY7n7ShwDmEcgzimDVwlQ=;
        b=YxFzVhDzFPekPs7TGs9Tk0JHHl+T0kupMZ9W4VT023qHOQLgPInE/9XbZ7RYqsJTlIVbK3
        vhFCv/wEJLf79FmwM4HNa5Lgkwcr/bDbJ/L3rNxNzMkCwnE2PFAn+GJ8F/p7OfH2XKmbGS
        ZDeZ4Geg5PSPCDsuKmPq694m8DtSXBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-BnhEGNdYP4mKI6shw1Yj5g-1; Wed, 19 Feb 2020 08:46:52 -0500
X-MC-Unique: BnhEGNdYP4mKI6shw1Yj5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDC4E107ACC7;
        Wed, 19 Feb 2020 13:46:50 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 604CD19756;
        Wed, 19 Feb 2020 13:46:42 +0000 (UTC)
Date:   Wed, 19 Feb 2020 14:46:40 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, kuba@kernel.org, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
Message-ID: <20200219144640.63964b2d@carbon>
In-Reply-To: <6c5f27aff46e6dd6be92ce29b65bc3670eeabffc.1582105994.git.lorenzo@kernel.org>
References: <6c5f27aff46e6dd6be92ce29b65bc3670eeabffc.1582105994.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 10:57:37 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce "rx" prefix in the name scheme for xdp counters
> on rx path.
> Differentiate between XDP_TX and ndo_xdp_xmit counters
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> ---
> Changes since RFC:
> - rename rx_xdp_tx_xmit in rx_xdp_tx
> - move tx stats accounting in mvneta_xdp_xmit_back/mvneta_xdp_xmit

I like how you managed to bulk update the ndo_xdp_xmit counters.

> ---
>  drivers/net/ethernet/marvell/mvneta.c | 52 ++++++++++++++++++---------
>  1 file changed, 36 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index b7045b6a15c2..8e1feb678cea 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -344,6 +344,7 @@ enum {
>  	ETHTOOL_XDP_REDIRECT,
>  	ETHTOOL_XDP_PASS,
>  	ETHTOOL_XDP_DROP,
> +	ETHTOOL_XDP_XMIT,
>  	ETHTOOL_XDP_TX,
>  	ETHTOOL_MAX_STATS,
>  };
> @@ -399,10 +400,11 @@ static const struct mvneta_statistic mvneta_statistics[] = {
>  	{ ETHTOOL_STAT_EEE_WAKEUP, T_SW, "eee_wakeup_errors", },
>  	{ ETHTOOL_STAT_SKB_ALLOC_ERR, T_SW, "skb_alloc_errors", },
>  	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
> -	{ ETHTOOL_XDP_REDIRECT, T_SW, "xdp_redirect", },
> -	{ ETHTOOL_XDP_PASS, T_SW, "xdp_pass", },
> -	{ ETHTOOL_XDP_DROP, T_SW, "xdp_drop", },
> -	{ ETHTOOL_XDP_TX, T_SW, "xdp_tx", },
> +	{ ETHTOOL_XDP_REDIRECT, T_SW, "rx_xdp_redirect", },
> +	{ ETHTOOL_XDP_PASS, T_SW, "rx_xdp_pass", },
> +	{ ETHTOOL_XDP_DROP, T_SW, "rx_xdp_drop", },
> +	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx", },
> +	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },
>  };

I'm fine with these names.

Based on the code, the "rx_xdp_tx" counter is counting the successful
XDP_TX operations, which I actually like.  I could use this to debug,
if my XDP_TX operations are drop packets (due to TX-queue full), by
using fexit or XDP-prog counter to deduct this.  I think it would be
valuable to provide a "rx_xdp_tx_err" counter, that would detect this,
it makes it easier to detect this for end-users (as a followup patch).


>  struct mvneta_stats {
> @@ -414,6 +416,7 @@ struct mvneta_stats {
>  	u64	xdp_redirect;
>  	u64	xdp_pass;
>  	u64	xdp_drop;
> +	u64	xdp_xmit;
>  	u64	xdp_tx;
>  };
>  
> @@ -2012,7 +2015,6 @@ static int
>  mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
>  			struct xdp_frame *xdpf, bool dma_map)
>  {
> -	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
>  	struct mvneta_tx_desc *tx_desc;
>  	struct mvneta_tx_buf *buf;
>  	dma_addr_t dma_addr;
> @@ -2047,12 +2049,6 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
>  	tx_desc->buf_phys_addr = dma_addr;
>  	tx_desc->data_size = xdpf->len;
>  
> -	u64_stats_update_begin(&stats->syncp);
> -	stats->es.ps.tx_bytes += xdpf->len;
> -	stats->es.ps.tx_packets++;
> -	stats->es.ps.xdp_tx++;
> -	u64_stats_update_end(&stats->syncp);
> -
>  	mvneta_txq_inc_put(txq);
>  	txq->pending++;
>  	txq->count++;
> @@ -2079,8 +2075,17 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
>  
>  	__netif_tx_lock(nq, cpu);
>  	ret = mvneta_xdp_submit_frame(pp, txq, xdpf, false);
> -	if (ret == MVNETA_XDP_TX)
> +	if (ret == MVNETA_XDP_TX) {
> +		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
> +
> +		u64_stats_update_begin(&stats->syncp);
> +		stats->es.ps.tx_bytes += xdpf->len;
> +		stats->es.ps.tx_packets++;
> +		stats->es.ps.xdp_tx++;
> +		u64_stats_update_end(&stats->syncp);
> +
>  		mvneta_txq_pend_desc_add(pp, txq, 0);
> +	}
>  	__netif_tx_unlock(nq);
>  
>  	return ret;
> @@ -2091,10 +2096,11 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
>  		struct xdp_frame **frames, u32 flags)
>  {
>  	struct mvneta_port *pp = netdev_priv(dev);
> +	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
> +	int i, nxmit_byte = 0, nxmit = num_frame;
>  	int cpu = smp_processor_id();
>  	struct mvneta_tx_queue *txq;
>  	struct netdev_queue *nq;
> -	int i, drops = 0;
>  	u32 ret;
>  
>  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> @@ -2106,9 +2112,11 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
>  	__netif_tx_lock(nq, cpu);
>  	for (i = 0; i < num_frame; i++) {
>  		ret = mvneta_xdp_submit_frame(pp, txq, frames[i], true);
> -		if (ret != MVNETA_XDP_TX) {
> +		if (ret == MVNETA_XDP_TX) {
> +			nxmit_byte += frames[i]->len;
> +		} else {
>  			xdp_return_frame_rx_napi(frames[i]);
> -			drops++;
> +			nxmit--;
>  		}
>  	}
>  
> @@ -2116,7 +2124,13 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
>  		mvneta_txq_pend_desc_add(pp, txq, 0);
>  	__netif_tx_unlock(nq);
>  
> -	return num_frame - drops;
> +	u64_stats_update_begin(&stats->syncp);
> +	stats->es.ps.tx_bytes += nxmit_byte;
> +	stats->es.ps.tx_packets += nxmit;
> +	stats->es.ps.xdp_xmit += nxmit;
> +	u64_stats_update_end(&stats->syncp);
> +
> +	return nxmit;
>  }

Updating xmit counter per bulk, nice.

>  
[...]

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

