Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F66632A1D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 17:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiKUQzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 11:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKUQzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 11:55:52 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FAD7210D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 08:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669049750; x=1700585750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G2iJcXvS0zhaskTE1Pfig9C99ZUTxBpWV4h6OI7DZ3A=;
  b=eXeY4hwc0S2jCF97VI7xi6vJEtf9YRjhht0V+sHdK2gFXZZmxdcvIP0a
   DlNHI55CAD2ULJaLJdh4RFrUrcTzfObwvtlIcSTQ0PiWv7cv38PNcGxjD
   GZtnhJ21V9U1k0uBGtErC0C8jRLTYUzZwMnsgxGEfsQ12y2Gp/DeYMsJk
   bsrlTCoNKuZ6anlpWxpvP0/AMQZyMuXybMAuWOTW+2I0bWaUS5s7zyAII
   2luZN0LfuG+q2S94cGft1BHE9C9bmZduRF7/3yKjyeZ/ulWmfixM01mmb
   GIdY9n0fMe9oL8XMInkw2peI5LU7Q2w6OU09gdhpcK+ODSJSAGPEe2qx2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="296962789"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="296962789"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 08:55:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="970138771"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="970138771"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 21 Nov 2022 08:55:47 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ALGtjnc025169;
        Mon, 21 Nov 2022 16:55:45 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 1/5] net: ethernet: mtk_wed: return status value in mtk_wdma_rx_reset
Date:   Mon, 21 Nov 2022 17:55:21 +0100
Message-Id: <20221121165521.396686-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <8917d87eded7142a3a792c3ba64434a983278247.1669020847.git.lorenzo@kernel.org>
References: <cover.1669020847.git.lorenzo@kernel.org> <8917d87eded7142a3a792c3ba64434a983278247.1669020847.git.lorenzo@kernel.org>
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


From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 21 Nov 2022 09:59:21 +0100

> Move MTK_WDMA_RESET_IDX configuration in mtk_wdma_rx_reset routine.
> This is a preliminary patch to add Wireless Ethernet Dispatcher reset
> support.
> 
> Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_wed.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
> index 7d8842378c2b..dc898ded2f05 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> @@ -101,17 +101,21 @@ mtk_wdma_read_reset(struct mtk_wed_device *dev)
>  	return wdma_r32(dev, MTK_WDMA_GLO_CFG);
>  }
>  
> -static void
> +static int
>  mtk_wdma_rx_reset(struct mtk_wed_device *dev)
>  {
>  	u32 status, mask = MTK_WDMA_GLO_CFG_RX_DMA_BUSY;
> -	int i;
> +	int i, ret;
>  
>  	wdma_clr(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_RX_DMA_EN);
> -	if (readx_poll_timeout(mtk_wdma_read_reset, dev, status,
> -			       !(status & mask), 0, 1000))
> +	ret = readx_poll_timeout(mtk_wdma_read_reset, dev, status,
> +				 !(status & mask), 0, 10000);

You didn't mention anywhere this change of the timeout from 1000 to
10000, and for example for me it's not clear from the code why you
did this. Maybe leave a comment in the commitmsg?
Same in 2/5 for Tx, also 1000 -> 10000.

> +	if (ret)
>  		dev_err(dev->hw->dev, "rx reset failed\n");
>  
> +	wdma_w32(dev, MTK_WDMA_RESET_IDX, MTK_WDMA_RESET_IDX_RX);
> +	wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
> +
>  	for (i = 0; i < ARRAY_SIZE(dev->rx_wdma); i++) {
>  		if (dev->rx_wdma[i].desc)
>  			continue;

[...]

> -- 
> 2.38.1

Thanks,
Olek
