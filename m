Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CEA628192
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiKNNqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiKNNqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:46:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC7523E9A;
        Mon, 14 Nov 2022 05:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668433561; x=1699969561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pZsDOJH7YZVEvK7c5X8wY11sJ+2Kq256SCE5sNiG6QI=;
  b=Ei9YJVFxeYu2WNTxpX0ySz2HC1RKn37SIcW5aVyrUUdG2MwWAxZb8URC
   aCfPpyDA/D4Z7V6ZJR3PxoJp4Pv7G34FP6RboA9NStJ9c6LEpeH/mNCVK
   wYUiwJcmgNNN7bl2TIy0AUp2Sep6YDSYJCtSmABO4JuVtSdYYgJ5VpMnl
   W37r3/ZJLD4qJMRlG/BshL8hewS+7N61txQU7mz//lPYY5rWA1jZIyjgp
   f+5vBdFvEEa7/ivAun9IAG9vbSiIq98jT/1O9sGH/aXJoKShjpEW4hwuz
   iydNJzb+szvSwufCUIOZvJA6s2JBz2zZPhtP3KUoBwlO2rq1lNWSJqhMD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="295332361"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="295332361"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 05:46:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="638480160"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="638480160"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 14 Nov 2022 05:45:57 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AEDjupb006363;
        Mon, 14 Nov 2022 13:45:56 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 1/1] net: fec: add xdp and page pool statistics
Date:   Mon, 14 Nov 2022 14:45:42 +0100
Message-Id: <20221114134542.697174-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111153505.434398-1-shenwei.wang@nxp.com>
References: <20221111153505.434398-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shenwei Wang <shenwei.wang@nxp.com>
Date: Fri, 11 Nov 2022 09:35:05 -0600

> Added xdp and page pool statistics.
> In order to make the implementation simple and compatible, the patch
> uses the 32bit integer to record the XDP statistics.
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> Reported-by: kernel test robot <lkp@intel.com>

I was this went upstream[0], I think it was quite premature.
First of all, there was a non-acked reply to me in the v2 thread,
but okay, I can live with that. More serious issues in the inline
comments below.

> ---
>  Changes in v3:
>  - change memcpy to strncpy to fix the warning reported by Paolo Abeni
>  - fix the compile errors on powerpc
> 
>  Changes in v2:
>  - clean up and restructure the codes per Andrew Lunn's review comments
>  - clear the statistics when the adaptor is down
> 
>  drivers/net/ethernet/freescale/Kconfig    |  1 +
>  drivers/net/ethernet/freescale/fec.h      | 14 ++++
>  drivers/net/ethernet/freescale/fec_main.c | 85 +++++++++++++++++++++--
>  3 files changed, 95 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
> index ce866ae3df03..f1e80d6996ef 100644
> --- a/drivers/net/ethernet/freescale/Kconfig
> +++ b/drivers/net/ethernet/freescale/Kconfig
> @@ -29,6 +29,7 @@ config FEC
>  	select CRC32
>  	select PHYLIB
>  	select PAGE_POOL
> +	select PAGE_POOL_STATS

Drivers should never select PAGE_POOL_STATS. This Kconfig option was
made to allow user to choose whether he wants stats or better
performance on slower systems. It's pure user choice, if something
doesn't build or link, it must be guarded with
IS_ENABLED(CONFIG_PAGE_POOL_STATS).

>  	imply NET_SELFTESTS
>  	help
>  	  Say Y here if you want to use the built-in 10/100 Fast ethernet
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index 61e847b18343..5ba1e0d71c68 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -526,6 +526,19 @@ struct fec_enet_priv_txrx_info {
>  	struct  sk_buff *skb;
>  };
> 
> +enum {
> +	RX_XDP_REDIRECT = 0,
> +	RX_XDP_PASS,
> +	RX_XDP_DROP,
> +	RX_XDP_TX,
> +	RX_XDP_TX_ERRORS,
> +	TX_XDP_XMIT,
> +	TX_XDP_XMIT_ERRORS,
> +
> +	/* The following must be the last one */
> +	XDP_STATS_TOTAL,
> +};
> +
>  struct fec_enet_priv_tx_q {
>  	struct bufdesc_prop bd;
>  	unsigned char *tx_bounce[TX_RING_SIZE];
> @@ -546,6 +559,7 @@ struct fec_enet_priv_rx_q {
>  	/* page_pool */
>  	struct page_pool *page_pool;
>  	struct xdp_rxq_info xdp_rxq;
> +	u32 stats[XDP_STATS_TOTAL];

Still not convinced it is okay to deliberately provoke overflows
here, maybe we need some more reviewers to help us agree on what is
better?

> 
>  	/* rx queue number, in the range 0-7 */
>  	u8 id;

[...]

>  	case ETH_SS_STATS:
> -		for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
> -			memcpy(data + i * ETH_GSTRING_LEN,
> -				fec_stats[i].name, ETH_GSTRING_LEN);
> +		for (i = 0; i < ARRAY_SIZE(fec_stats); i++) {
> +			memcpy(data, fec_stats[i].name, ETH_GSTRING_LEN);
> +			data += ETH_GSTRING_LEN;
> +		}
> +		for (i = 0; i < ARRAY_SIZE(fec_xdp_stat_strs); i++) {
> +			strncpy(data, fec_xdp_stat_strs[i], ETH_GSTRING_LEN);

strncpy() is deprecated in favor of strscpy(), there were tons of
commits which replace the former with the latter across the whole
tree.

> +			data += ETH_GSTRING_LEN;
> +		}
> +		page_pool_ethtool_stats_get_strings(data);
> +
>  		break;
>  	case ETH_SS_TEST:
>  		net_selftest_get_strings(data);

[...]

> +	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
> +		rxq = fep->rx_queue[i];
> +		for (j = 0; j < XDP_STATS_TOTAL; j++)
> +			rxq->stats[j] = 0;

(not critical) Just memset(&rxq->stats)?

> +	}
> +
>  	/* Don't disable MIB statistics counters */
>  	writel(0, fep->hwp + FEC_MIB_CTRLSTAT);
>  }
> @@ -3084,6 +3156,9 @@ static void fec_enet_free_buffers(struct net_device *ndev)
>  		for (i = 0; i < rxq->bd.ring_size; i++)
>  			page_pool_release_page(rxq->page_pool, rxq->rx_skb_info[i].page);
> 
> +		for (i = 0; i < XDP_STATS_TOTAL; i++)
> +			rxq->stats[i] = 0;
> +
>  		if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
>  			xdp_rxq_info_unreg(&rxq->xdp_rxq);
>  		page_pool_destroy(rxq->page_pool);
> --
> 2.34.1

Could you please send a follow-up maybe, fixing at least that
PAGE_POOL_STATS select and strncpy()?

[0] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?h=main&id=6970ef27ff7fd1ce3455b2c696081503d0c0f8ac

Thanks,
Olek
