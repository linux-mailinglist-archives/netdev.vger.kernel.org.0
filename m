Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026645913C4
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 18:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbiHLQNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 12:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239277AbiHLQNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 12:13:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53750A61F9
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Vkl98HUSH7LrgTiCeQtI99MvdsMadj+IZm1K+LHUkN0=; b=ALlD8awN/SWnMHfotie1hRTW/8
        spJIVx8IeN5+Qox32C6gaIdcY6J6uSrAaoAtVRPBJkUC9qlu7sdr/qBMGPPiqt83rmiB4grLphH25
        Ewveu7/lnGJN8Kc8qZaxVDvwazcmA+dTlBs9qgqN1eW0lRcOFW8O3GuRuh3Lx44HiDBc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oMXI7-00D92v-H5; Fri, 12 Aug 2022 18:13:43 +0200
Date:   Fri, 12 Aug 2022 18:13:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guobin Huang <huangguobin4@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: moxa: inherit DMA masks to make dma_map_single()
 work
Message-ID: <YvZ8NwzGV/9QDInR@lunn.ch>
References: <20220812154820.2225457-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812154820.2225457-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 06:48:20PM +0300, Sergei Antonov wrote:
> dma_map_single() calls fail in moxart_mac_setup_desc_ring() and
> moxart_mac_start_xmit() which leads to an incessant output of this:
> 
> [   16.043925] moxart-ethernet 92000000.mac eth0: DMA mapping error
> [   16.050957] moxart-ethernet 92000000.mac eth0: DMA mapping error
> [   16.058229] moxart-ethernet 92000000.mac eth0: DMA mapping error
> 
> To make dma_map_single() work, inherit DMA masks from the platform device.
> 
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> CC: Jakub Kicinski <kuba@kernel.org>
> CC: Pavel Skripkin <paskripkin@gmail.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Guobin Huang <huangguobin4@huawei.com>
> CC: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/ethernet/moxa/moxart_ether.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
> index a3214a762e4b..de99211d85c2 100644
> --- a/drivers/net/ethernet/moxa/moxart_ether.c
> +++ b/drivers/net/ethernet/moxa/moxart_ether.c
> @@ -537,6 +537,10 @@ static int moxart_mac_probe(struct platform_device *pdev)
>  	ndev->priv_flags |= IFF_UNICAST_FLT;
>  	ndev->irq = irq;
>  
> +	/* Inherit the DMA masks from the platform device */
> +	ndev->dev.dma_mask = p_dev->dma_mask;
> +	ndev->dev.coherent_dma_mask = p_dev->coherent_dma_mask;

There is only one other ethernet driver which does this. What you see
much more often is:

alacritech/slicoss.c:	paddr = dma_map_single(&sdev->pdev->dev, skb->data, maplen,
neterion/s2io.c:				dma_map_single(&sp->pdev->dev, ba->ba_1,
dlink/dl2k.c:			    cpu_to_le64(dma_map_single(&np->pdev->dev, skb->data,
micrel/ksz884x.c:		dma_buf->dma = dma_map_single(&hw_priv->pdev->dev, skb->data,

	Andrew
