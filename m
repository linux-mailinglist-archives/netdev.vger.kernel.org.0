Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01336B8AF8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCNGN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjCNGNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:13:22 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4B1C3;
        Mon, 13 Mar 2023 23:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678774400; x=1710310400;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lYU9/lOsDjrGWnrNFnc3eD+bZCqLaCoXFbUAdhwVlmw=;
  b=DgzQPJ/tlWNjob1Tq2lPzE7fj9cWi9ac0V3I4YM9UJPRh2Z3x9LFasa4
   dqMbvUMzx8860mFrqM1LDP7mMa8lN1aIRweluvbad8V9H15AVnBGj5HwH
   1j7PxKR4yIu5zTGLLtOIDm0XpxYHMZgpXHlPwmOpUoSKDMSA8tHLUTZvY
   a/8s6F1EMvfJcO8frlGEUmzleG52UaX+IT80MfiSl+b9lBnhVywIsMSUE
   RArN/G5hsocc5OP73pPKytbhoMfq8Ul8NvkFQPhjE3Bzi+aRpQOuDYx0S
   gKVZ//b0sYawou+snZAqGO07nlJPzXukFFLgwjTjRW+85FOusY4ADk1MT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="334818367"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="334818367"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 23:12:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="681296678"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="681296678"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 23:12:44 -0700
Date:   Tue, 14 Mar 2023 07:12:35 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        Leon Romanovsky <leon@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Long Li <longli@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [PATCH] net: mana: Add new MANA VF performance counters for
 easier troubleshooting
Message-ID: <ZBAQU2qJg6kcud50@localhost.localdomain>
References: <1678771810-21050-1-git-send-email-shradhagupta@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1678771810-21050-1-git-send-email-shradhagupta@linux.microsoft.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 10:30:10PM -0700, Shradha Gupta wrote:
> Extended performance counter stats in 'ethtool -S <interface>' output
> for MANA VF to facilitate troubleshooting.
> 
> Tested-on: Ubuntu22
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 67 ++++++++++++++++++-
>  .../ethernet/microsoft/mana/mana_ethtool.c    | 52 +++++++++++++-
>  include/net/mana/mana.h                       | 18 +++++
>  3 files changed, 133 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 6120f2b6684f..9762bdda6df1 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -156,6 +156,8 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  	struct mana_txq *txq;
>  	struct mana_cq *cq;
>  	int err, len;
> +	u16 ihs;
> +	int hopbyhop = 0;
RCT

>  
>  	if (unlikely(!apc->port_is_up))
>  		goto tx_drop;
> @@ -166,6 +168,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  	txq = &apc->tx_qp[txq_idx].txq;
>  	gdma_sq = txq->gdma_sq;
>  	cq = &apc->tx_qp[txq_idx].tx_cq;
> +	tx_stats = &txq->stats;
>  
>  	pkg.tx_oob.s_oob.vcq_num = cq->gdma_id;
>  	pkg.tx_oob.s_oob.vsq_frame = txq->vsq_frame;
> @@ -179,10 +182,17 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  
>  	pkg.tx_oob.s_oob.pkt_fmt = pkt_fmt;
>  
> -	if (pkt_fmt == MANA_SHORT_PKT_FMT)
> +	if (pkt_fmt == MANA_SHORT_PKT_FMT) {
>  		pkg.wqe_req.inline_oob_size = sizeof(struct mana_tx_short_oob);
> -	else
> +		u64_stats_update_begin(&tx_stats->syncp);
> +		tx_stats->short_pkt_fmt++;
> +		u64_stats_update_end(&tx_stats->syncp);
> +	} else {
>  		pkg.wqe_req.inline_oob_size = sizeof(struct mana_tx_oob);
> +		u64_stats_update_begin(&tx_stats->syncp);
> +		tx_stats->long_pkt_fmt++;
> +		u64_stats_update_end(&tx_stats->syncp);
> +	}
>  
>  	pkg.wqe_req.inline_oob_data = &pkg.tx_oob;
>  	pkg.wqe_req.flags = 0;
> @@ -232,9 +242,37 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  						 &ipv6_hdr(skb)->daddr, 0,
>  						 IPPROTO_TCP, 0);
>  		}
> +
> +		if (skb->encapsulation) {
> +			ihs = skb_inner_tcp_all_headers(skb);
> +			u64_stats_update_begin(&tx_stats->syncp);
> +			tx_stats->tso_inner_packets++;
> +			tx_stats->tso_inner_bytes += skb->len - ihs;
> +			u64_stats_update_end(&tx_stats->syncp);
> +		} else {
hopbyhop can be defined here

> +			if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
> +				ihs = skb_transport_offset(skb) + sizeof(struct udphdr);
> +			} else {
> +				ihs = skb_tcp_all_headers(skb);
> +				if (ipv6_has_hopopt_jumbo(skb)) {
> +					hopbyhop = sizeof(struct hop_jumbo_hdr);
> +					ihs -= sizeof(struct hop_jumbo_hdr);
> +				}
Maybe I missed sth, but it looks like this part of code can be removed.
hopbyhop is only used to calculate tso_bytes. Instead of substract
hopbyhop from ihs, and calculate tso_bytes as len - ihs - hopbyhop, You
can remove hopbyhop and calculate tso_bytes like len - ihs.

> +			}
> +
> +			u64_stats_update_begin(&tx_stats->syncp);
> +			tx_stats->tso_packets++;
> +			tx_stats->tso_bytes += skb->len - ihs - hopbyhop;
> +			u64_stats_update_end(&tx_stats->syncp);
> +		}
> +
>  
[...]

> @@ -1341,11 +1394,17 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
>  {
>  	struct gdma_comp *comp = cq->gdma_comp_buf;
>  	struct mana_rxq *rxq = cq->rxq;
> +	struct net_device *ndev;
> +	struct mana_port_context *apc;
RCT
>  	int comp_read, i;
>  
> +	ndev = rxq->ndev;
> +	apc = netdev_priv(ndev);
maybe:
apc = netdev_priv(rxq->ndev);
> +
>  	comp_read = mana_gd_poll_cq(cq->gdma_cq, comp, CQE_POLLING_BUFFER);
>  	WARN_ON_ONCE(comp_read > CQE_POLLING_BUFFER);
>  
> +	apc->eth_stats.rx_cqes = comp_read;
>  	rxq->xdp_flush = false;
>  
>  	for (i = 0; i < comp_read; i++) {
> @@ -1357,6 +1416,8 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
>  			return;
>  
>  		mana_process_rx_cqe(rxq, cq, &comp[i]);
> +
> +		apc->eth_stats.rx_cqes--;
>  	}
>  
>  	if (rxq->xdp_flush)
>  
[...]

> -- 
> 2.37.2
> 
