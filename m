Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2941752AFFD
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiERBjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbiERBjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:39:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71F831DF6;
        Tue, 17 May 2022 18:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEEC0B81D97;
        Wed, 18 May 2022 01:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA06C385B8;
        Wed, 18 May 2022 01:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652837977;
        bh=iMqRtnzqU/EqtFUtJsABiZAWBZ8H3DWHwaJYTCqmoPc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LYOthdjMsguNHDhpDllew202sUBsqem6OyOS0GbrCWnonf6K9Uu3C5pW8tyRvPoZx
         B/TzqSn/pnBhzxNNZrJcBHCb6ApXgiXmA0OOf4XGdOKkOKe4N6YWB2yjzhE95brDGs
         0M1uGPByWA1hshbo13QZKkoSVYBqWcH16MStA+a84RzqF1zBz38mfXrhNewnCOmJdi
         yDLAZdneJu4rIVuLNPvUFNgaOMW0YI0BcUksuYpMOfPfovhfxd/GO1+BFqxhc0Nn+x
         Rkxo1XlvzWeejnobHRxSDk675iISLzRXgJSqSVdXxd7HCJP3ike8ostVQsuqUbJcZ8
         VKhTWnGH76wtw==
Date:   Tue, 17 May 2022 18:39:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 10/15] net: ethernet: mtk_eth_soc: rely on
 rxd_size field in mtk_rx_alloc/mtk_rx_clean
Message-ID: <20220517183935.6863ddc7@kernel.org>
In-Reply-To: <eca56ab1af7f4bbedc4a6d0990a10ff58911d842.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
        <eca56ab1af7f4bbedc4a6d0990a10ff58911d842.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 18:06:37 +0200 Lorenzo Bianconi wrote:
> +
> +		rxd = (void *)ring->dma + i * eth->soc->txrx.rxd_size;
> +		rxd->rxd1 = (unsigned int)dma_addr;
>  
>  		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
> -			ring->dma[i].rxd2 = RX_DMA_LSO;
> +			rxd->rxd2 = RX_DMA_LSO;
>  		else
> -			ring->dma[i].rxd2 = RX_DMA_PLEN0(ring->buf_size);
> +			rxd->rxd2 = RX_DMA_PLEN0(ring->buf_size);
> +
> +		rxd->rxd3 = 0;
> +		rxd->rxd4 = 0;

The clearing of rxd3/rxd4 should probably have been mentioned in the
commit message. It does not seem related to descriptor size.
