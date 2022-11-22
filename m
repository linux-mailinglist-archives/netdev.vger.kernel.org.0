Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9A16341F9
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiKVQ5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbiKVQ5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:57:01 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D1373BB3;
        Tue, 22 Nov 2022 08:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669136220; x=1700672220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TwcpyD+C5wdcSZTD5L4oimXZvwrY6s0XFW56TjB/fmk=;
  b=R1fMumSn40pvwra1FzmQdBnVr0fv1t3V4beWtEvyLGsno32w17TRk7f9
   ukm+aC8kIHldlXMfbLReWqB4ELDF/Wr2drs0ObLpRyLder5GfuuayqiuI
   au1r2G0b5acfV3S1xYy3We0RFeLYk6NgmehyJKFHdyH1QHxlDFoqweSOr
   Z8vZiQHvKOgYlqdQZgE7L+RO5ViHgh47AXbyhev1939ykLrjtNMU40W+t
   CFtiuLuipGMhgQyr38oC/slydLCSFdU4oUIiHP+D6O7UCFZUnalaZix8z
   SQkZ/Q2g2B2HC7QwfwO6UzEKKW3B/yFh8tv/08JcieVBQ1KlP+OQJz+DS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="378119411"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="378119411"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 08:56:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="886602553"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="886602553"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2022 08:56:57 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AMGutK1031705;
        Tue, 22 Nov 2022 16:56:55 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 6/7] net: lan966x: Add support for XDP_TX
Date:   Tue, 22 Nov 2022 17:56:46 +0100
Message-Id: <20221122165646.428674-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121212850.3212649-7-horatiu.vultur@microchip.com>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com> <20221121212850.3212649-7-horatiu.vultur@microchip.com>
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
Date: Mon, 21 Nov 2022 22:28:49 +0100

> Extend lan966x XDP support with the action XDP_TX. In this case when the
> received buffer needs to execute XDP_TX, the buffer will be moved to the
> TX buffers. So a new RX buffer will be allocated.
> When the TX finish with the frame, it would give back the buffer to the
> page pool.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 78 +++++++++++++++++--
>  .../ethernet/microchip/lan966x/lan966x_main.c |  4 +-
>  .../ethernet/microchip/lan966x/lan966x_main.h |  8 ++
>  .../ethernet/microchip/lan966x/lan966x_xdp.c  |  8 ++
>  4 files changed, 90 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> index f8287a6a86ed5..b14fdb8e15e22 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> @@ -411,12 +411,18 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
>  		dcb_buf->dev->stats.tx_bytes += dcb_buf->len;
>  
>  		dcb_buf->used = false;
> -		dma_unmap_single(lan966x->dev,
> -				 dcb_buf->dma_addr,
> -				 dcb_buf->len,
> -				 DMA_TO_DEVICE);
> -		if (!dcb_buf->ptp)
> -			dev_kfree_skb_any(dcb_buf->skb);
> +		if (dcb_buf->skb) {
> +			dma_unmap_single(lan966x->dev,
> +					 dcb_buf->dma_addr,
> +					 dcb_buf->len,
> +					 DMA_TO_DEVICE);
> +
> +			if (!dcb_buf->ptp)
> +				dev_kfree_skb_any(dcb_buf->skb);

Damn, forgot to remind you you wanted to switch to
napi_consume_skb() :s

> +		}
> +
> +		if (dcb_buf->xdpf)
> +			xdp_return_frame_rx_napi(dcb_buf->xdpf);
>  
>  		clear = true;
>  	}

[...]

> -- 
> 2.38.0

Thanks,
Olek
