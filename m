Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82C252AFF3
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiERBfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiERBf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:35:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A82238BD7;
        Tue, 17 May 2022 18:35:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E56C9B81BE0;
        Wed, 18 May 2022 01:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F08C385B8;
        Wed, 18 May 2022 01:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652837724;
        bh=eejmgDeuegMldE1NuLPI6JWdYtBkX+d0FP7BFTmWlno=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LeX6/giq7LE48APMFpUdl5WeU82P9kRhmyYa9J5KgwWOFBsULnsJMkZ35rvTmPPKv
         D5UUk2mHJzCycYNiVoT/nl3Mj4YbF3G3sQ9yxfFe/ww8com89z+gJhVb4vhL1j4136
         cMdGPjf0QjM92lCyQCKVarQIrNPOxRgedQKSvnXix6LpUp5HpJImdHDhwt7/+YsYfm
         hjh7i6RRDgcle8sO7nnPM97yyxxQfKupusd5SI5YW+aTpLu7i8UemyPCh1AiOpyIh0
         axsPK4eTnF5y7NFeglnXSeU4/wzr1hn9+lY/FRl4ecOWjLqi7MmY2LHqBeTkxHEuqQ
         ysp4oWZM219+w==
Date:   Tue, 17 May 2022 18:35:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 05/15] net: ethernet: mtk_eth_soc: rely on
 txd_size in mtk_tx_alloc/mtk_tx_clean
Message-ID: <20220517183522.4a585885@kernel.org>
In-Reply-To: <c5228daa3d277cd71a134a1062525bc19b34fa2f.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
        <c5228daa3d277cd71a134a1062525bc19b34fa2f.1652716741.git.lorenzo@kernel.org>
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

On Mon, 16 May 2022 18:06:32 +0200 Lorenzo Bianconi wrote:
>  static int mtk_tx_alloc(struct mtk_eth *eth)
>  {
> +	const struct mtk_soc_data *soc = eth->soc;
>  	struct mtk_tx_ring *ring = &eth->tx_ring;
> -	int i, sz = sizeof(*ring->dma);

The change would be smaller if you left sz in place. 
I guess you have a reason not to?

> +	struct mtk_tx_dma *txd;
> +	int i;
>  
>  	ring->buf = kcalloc(MTK_DMA_SIZE, sizeof(*ring->buf),
>  			       GFP_KERNEL);
>  	if (!ring->buf)
>  		goto no_tx_mem;
>  
> -	ring->dma = dma_alloc_coherent(eth->dma_dev, MTK_DMA_SIZE * sz,
> +	ring->dma = dma_alloc_coherent(eth->dma_dev,
> +				       MTK_DMA_SIZE * soc->txrx.txd_size,
>  				       &ring->phys, GFP_ATOMIC);

Another GFP nugget.
