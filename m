Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF6862C358
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbiKPQDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiKPQDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:03:13 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509C1554DD;
        Wed, 16 Nov 2022 08:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668614592; x=1700150592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lW3NzBq/Ii+Agn3S+Dz3HjWB+SGRuGzzSqo90mBPD+E=;
  b=GLtdMgE9cn7mHqxHrproI1kIGMnbkT63xovzw1KoMZiGiIrCmGAKpI1d
   0Bke5CVrNJzZZ4majB5gCJdlPk93jjAox2LSsgXnEvsx7GzGE9ReoTJG9
   DO3EF/cWpVfWZO85VjQ17QTAugbO4N74F83Zbcz/Rp2eBe6uAsHYA6WWq
   5N7T2DokIsdOUwFm+Sq5zxZRjiCGWivVd3qFCKq4qtccxUQecwg09T18v
   0Gw43OooHxi/H5wrko8TEJyGwK9ulbizmImc6XQaJoYCv9iUb8Vpkth+B
   1c9aZndajRLWYVyVc1hwih1oxn17icUZ4l6kI877CH4XDiKBCOb6ZOZgR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="398867789"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="398867789"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 08:02:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="633673629"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="633673629"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 16 Nov 2022 08:02:36 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AGG2YS1001458;
        Wed, 16 Nov 2022 16:02:34 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v5 2/3] net: fec: add xdp statistics
Date:   Wed, 16 Nov 2022 17:02:15 +0100
Message-Id: <20221116160215.3391284-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115204951.370217-3-shenwei.wang@nxp.com>
References: <20221115204951.370217-1-shenwei.wang@nxp.com> <20221115204951.370217-3-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shenwei Wang <shenwei.wang@nxp.com>
Date: Tue, 15 Nov 2022 14:49:50 -0600

> Add xdp statistics for ethtool stats and using u64 to record the xdp counters.
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> Reported-by: kernel test robot <lkp@intel.com>

Nit: would be nice if you Cc me for the next submissions as I was
commenting on the previous ones. Just to make sure reviewers won't
miss anything.

> ---
>  drivers/net/ethernet/freescale/fec.h      | 15 +++++
>  drivers/net/ethernet/freescale/fec_main.c | 74 +++++++++++++++++++++--
>  2 files changed, 83 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index 61e847b18343..adbe661552be 100644
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
> @@ -546,6 +559,8 @@ struct fec_enet_priv_rx_q {
>  	/* page_pool */
>  	struct page_pool *page_pool;
>  	struct xdp_rxq_info xdp_rxq;
> +	struct u64_stats_sync syncp;
> +	u64 stats[XDP_STATS_TOTAL];

Why `u64`? u64_stats infra declares `u64_stat_t` type and a bunch of
helpers like u64_stats_add(), u64_stats_read() and so on, they will
be solved then by the compiler to the most appropriate ops for the
architecture. So they're more "generic" if you prefer.
Sure, if you show some numbers where `u64_stat_t` is slower than
`u64` on your machine, then okay, but otherwise...

>  
>  	/* rx queue number, in the range 0-7 */
>  	u8 id;

[...]

> -- 
> 2.34.1

Thanks,
Olek
