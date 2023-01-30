Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375E8681D83
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjA3V4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjA3V4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:56:18 -0500
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D13349961
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:56:14 -0800 (PST)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id Mc8FpvJQ3JJsoMc8Fpma9E; Mon, 30 Jan 2023 22:56:12 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 30 Jan 2023 22:56:12 +0100
X-ME-IP: 86.243.2.178
Message-ID: <810730f9-5097-4fb1-bea0-13e3e7084f9c@wanadoo.fr>
Date:   Mon, 30 Jan 2023 22:56:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/2] net: ll_temac: fix DMA resources leak
To:     Jonas Suhr Christensen <jsc@umbraculum.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        esben@geanix.com
References: <20230126101607.88407-1-jsc@umbraculum.org>
Content-Language: fr
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20230126101607.88407-1-jsc@umbraculum.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/01/2023 à 11:16, Jonas Suhr Christensen a écrit :
> Add missing conversion of address when unmapping dma region causing
> unmapping to silently fail. At some point resulting in buffer
> overrun eg. when releasing device.
> 
> Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>
> ---
>   drivers/net/ethernet/xilinx/ll_temac_main.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index 1066420d6a83..66c04027f230 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -300,6 +300,7 @@ static void temac_dma_bd_release(struct net_device *ndev)
>   {
>   	struct temac_local *lp = netdev_priv(ndev);
>   	int i;
> +	struct cdmac_bd *bd;
>   
>   	/* Reset Local Link (DMA) */
>   	lp->dma_out(lp, DMA_CONTROL_REG, DMA_CONTROL_RST);
> @@ -307,9 +308,14 @@ static void temac_dma_bd_release(struct net_device *ndev)
>   	for (i = 0; i < lp->rx_bd_num; i++) {
>   		if (!lp->rx_skb[i])
>   			break;
> -		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
> +
> +		bd = &lp->rx_bd_v[1];

Hi,
just a naive question from s.o. who knows nothing of this code:

Is really [1] ([one]) expected here?
[i] would look more "standard" in a 'for' loop.

just my 2c,

CJ


> +		dma_unmap_single(ndev->dev.parent, be32_to_cpu(bd->phys),
>   				 XTE_MAX_JUMBO_FRAME_SIZE, DMA_FROM_DEVICE);
> +		bd->phys = 0;
> +		bd->len = 0;
>   		dev_kfree_skb(lp->rx_skb[i]);
> +		lp->rx_skb[i] = NULL;
>   	}
>   	if (lp->rx_bd_v)
>   		dma_free_coherent(ndev->dev.parent,

