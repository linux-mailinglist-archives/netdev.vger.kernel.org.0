Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357A453C3C1
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 06:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiFCEbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 00:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiFCEbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 00:31:12 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A9836307;
        Thu,  2 Jun 2022 21:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=EYuaU/n29S6mPWu7974aUOfQXdaYQnassV8I6gREXSk=; b=jFs5aKNPKQND+2mAmm11jMfMsE
        oaCck4bKK7ocz1ORSzv1n7xnYz304ARX6tWej2j4cphCoj+oDzZUJoFx4zuXIP/ZsG3p3SVCE466n
        k0ZK2P5lPgkE1SsT+MHdzYnXqDNq3gt9SpJYllbd8tngS03nKSE90ps+c5Ha/P3Mnvps=;
Received: from p200300daa70ef200058bb5d56adcce0c.dip0.t-ipconnect.de ([2003:da:a70e:f200:58b:b5d5:6adc:ce0c] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nwyxP-0004ok-B8; Fri, 03 Jun 2022 06:30:43 +0200
Message-ID: <2997c5b0-3611-5e00-466c-b2966f09f067@nbd.name>
Date:   Fri, 3 Jun 2022 06:30:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-Language: en-US
To:     Chen Lin <chen45464546@163.com>, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com
References: <1654229435-2934-1-git-send-email-chen45464546@163.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev_alloc_frag
In-Reply-To: <1654229435-2934-1-git-send-email-chen45464546@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.06.22 06:10, Chen Lin wrote:
> When rx_flag == MTK_RX_FLAGS_HWLRO,
> rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
> netdev_alloc_frag is for alloction of page fragment only.
> Reference to other drivers and Documentation/vm/page_frags.rst
> 
> Branch to use kmalloc when rx_data_len > PAGE_SIZE.
> 
> Signed-off-by: Chen Lin <chen45464546@163.com>
> ---
>   drivers/net/ethernet/mediatek/mtk_eth_soc.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index b3b3c07..d0eebca 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -1914,7 +1914,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
>   		return -ENOMEM;
>   
>   	for (i = 0; i < rx_dma_size; i++) {
> -		ring->data[i] = netdev_alloc_frag(ring->frag_size);
> +		if (ring->frag_size <= PAGE_SIZE)
> +			ring->data[i] = netdev_alloc_frag(ring->frag_size);
> +		else
> +			ring->data[i] = kmalloc(ring->frag_size, GFP_KERNEL);
I'm pretty sure you also need to update all the other places in the code 
that currently assume that the buffer is allocated using the page frag 
allocator.

- Felix
