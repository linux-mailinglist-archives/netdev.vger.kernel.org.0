Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28BFC633B80
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiKVLg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiKVLgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:36:05 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7BD17078;
        Tue, 22 Nov 2022 03:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669116628; x=1700652628;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EUs3v5zzG9DDU2IR/ERFhdsdv5DgY0vpIZcHgBcJ/j4=;
  b=iojumDoB1ETExG4r4D6bD56/+roag8EF22rQGKcgJ8Gyb/P+pRKCLO2r
   4Udkrvi2EsKYYKUM+2MPwoDN7z4jLcb9C084cczvlQ0Z60S5g6a99/zjX
   /vysPbbkoFHCYAFZkej59ZqR3gmUMJWFfEV1kqNWzTrQLTkAxd8vJmM3F
   K7aw78QFl6GIT6Gvpcf/uubxcH3ydw+HTUJuWFeij5nyk/ASqSg2Ee9Du
   KUbBdO/42qYc4BTo/1EfPgQEOs71MehnSby5iz3uGykDlLcl9rQwwGevy
   eaMblYuUNB2BEPJXtyobb2Vx7JQtBeYJLHt0QhOX7db7Eu4LLj3aNpNNo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="294184542"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="294184542"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 03:30:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="674320405"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="674320405"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 22 Nov 2022 03:30:25 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AMBUNAB001561;
        Tue, 22 Nov 2022 11:30:23 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 3/7] net: lan966x: Add len field to lan966x_tx_dcb_buf
Date:   Tue, 22 Nov 2022 12:30:22 +0100
Message-Id: <20221122113022.418632-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121212850.3212649-4-horatiu.vultur@microchip.com>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com> <20221121212850.3212649-4-horatiu.vultur@microchip.com>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 21 Nov 2022 22:28:46 +0100

> Currently when a frame was transmitted, it is required to unamp the
> frame that was transmitted. The length of the frame was taken from the
> transmitted skb. In the future we might not have an skb, therefore store
> the length skb directly in the lan966x_tx_dcb_buf and use this one to
> unamp the frame.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 5 +++--
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> index 94c720e59caee..384ed34197d58 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> @@ -391,12 +391,12 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
>  			continue;
>  
>  		dcb_buf->dev->stats.tx_packets++;
> -		dcb_buf->dev->stats.tx_bytes += dcb_buf->skb->len;
> +		dcb_buf->dev->stats.tx_bytes += dcb_buf->len;
>  
>  		dcb_buf->used = false;
>  		dma_unmap_single(lan966x->dev,
>  				 dcb_buf->dma_addr,
> -				 dcb_buf->skb->len,
> +				 dcb_buf->len,
>  				 DMA_TO_DEVICE);
>  		if (!dcb_buf->ptp)
>  			dev_kfree_skb_any(dcb_buf->skb);
> @@ -709,6 +709,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
>  	/* Fill up the buffer */
>  	next_dcb_buf = &tx->dcbs_buf[next_to_use];
>  	next_dcb_buf->skb = skb;
> +	next_dcb_buf->len = skb->len;
>  	next_dcb_buf->dma_addr = dma_addr;
>  	next_dcb_buf->used = true;
>  	next_dcb_buf->ptp = false;
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> index bc93051aa0798..7bb9098496f60 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -175,6 +175,7 @@ struct lan966x_rx {
>  struct lan966x_tx_dcb_buf {
>  	struct net_device *dev;
>  	struct sk_buff *skb;
> +	int len;

Nit: perhaps you can define it as `u32` since fram length can't be
negative?

>  	dma_addr_t dma_addr;

Oh, also, on platforms with 64-bit addressing, `int len` placed in
between ::skb and ::dma_addr would create a 4-byte hole in the
structure. Placing `len` after ::dma_addr would make it holeless on
any architercture.

>  	bool used;
>  	bool ptp;
> -- 
> 2.38.0

Thanks,
Olek
