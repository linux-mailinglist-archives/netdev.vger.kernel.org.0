Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5200C558FF6
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 06:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiFXEei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXEef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:34:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847DC60F25;
        Thu, 23 Jun 2022 21:34:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11F71620FE;
        Fri, 24 Jun 2022 04:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79368C34114;
        Fri, 24 Jun 2022 04:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656045273;
        bh=IZ5ZDn+9JIMGyBmDD2iT5ZTpxrtT5hVkr4pA6eYPL1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WPhKfR9xr4x2sOntt3FQPKFrIn/4f4ExdSawkL52JIm1ImarWI5KFECBHQe9mh/gu
         PWpPiGfWpkzOhzd2/2smGxrjw8D786MLMSJbmg7Xtv/bgDVT01DVEdic8Q3W2f+ijb
         rzYnZNxrfX1NjTEdqFG9YSppTtnwqNKZj49OLffBrpFx1YAgAwWd40XTk7tCbJkGHa
         lCLlRcQgEFBHQNgIHvQ3Gs4hZeeUYLkX6dmvp9oTkUmMvcRibr4qHTr6Cc4lfqwL/R
         Jf1E2it522tpqTUBmZAj28ZS6Ans+02GRKtGKdn0qIiBpec+UR8Gf9mZkZzDoNa8RR
         poad5oYVZbaAw==
Date:   Thu, 23 Jun 2022 21:34:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>,
        Felix Fietkau <nbd@nbd.name>,
        "John Crispin" <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: Re: [PATCH net-next v3 09/10] net: ethernet: mtk-star-emac:
 separate tx/rx handling with two NAPIs
Message-ID: <20220623213431.23528544@kernel.org>
In-Reply-To: <20220622090545.23612-10-biao.huang@mediatek.com>
References: <20220622090545.23612-1-biao.huang@mediatek.com>
        <20220622090545.23612-10-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jun 2022 17:05:44 +0800 Biao Huang wrote:
> +	if (rx || tx) {
> +		spin_lock_irqsave(&priv->lock, flags);
> +		/* mask Rx and TX Complete interrupt */
> +		mtk_star_disable_dma_irq(priv, rx, tx);
> +		spin_unlock_irqrestore(&priv->lock, flags);

You do _irqsave / _irqrestore here

> +		if (rx)
> +			__napi_schedule_irqoff(&priv->rx_napi);
> +		if (tx)
> +			__napi_schedule_irqoff(&priv->tx_napi);

Yet assume _irqoff here.

So can this be run from non-IRQ context or not?

> -	if (mtk_star_ring_full(ring))
> +	if (unlikely(mtk_star_tx_ring_avail(ring) < MAX_SKB_FRAGS + 1))
>  		netif_stop_queue(ndev);

Please look around other drivers (like ixgbe) and copy the way they
handle safe stopping of the queues. You need to add some barriers and
re-check after disabling.

> -	spin_unlock_bh(&priv->lock);
> -
>  	mtk_star_dma_resume_tx(priv);
>  
>  	return NETDEV_TX_OK;


> +	while ((entry != head) && (count < MTK_STAR_RING_NUM_DESCS - 1)) {
>  

Parenthesis unnecessary, so is the empty line after the while ().

>  		ret = mtk_star_tx_complete_one(priv);
>  		if (ret < 0)
>  			break;
> +
> +		count++;
> +		pkts_compl++;
> +		bytes_compl += ret;
> +		entry = ring->tail;
>  	}
>  
> +	__netif_tx_lock_bh(netdev_get_tx_queue(priv->ndev, 0));
>  	netdev_completed_queue(ndev, pkts_compl, bytes_compl);
> +	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->ndev, 0));

what are you taking this lock for?

> -	if (wake && netif_queue_stopped(ndev))
> +	if (unlikely(netif_queue_stopped(ndev)) &&
> +	    (mtk_star_tx_ring_avail(ring) > MTK_STAR_TX_THRESH))
>  		netif_wake_queue(ndev);
>  
> -	spin_unlock(&priv->lock);
> +	if (napi_complete(napi)) {
> +		spin_lock_irqsave(&priv->lock, flags);
> +		mtk_star_enable_dma_irq(priv, false, true);
> +		spin_unlock_irqrestore(&priv->lock, flags);
> +	}
> +
> +	return 0;
>  }

> @@ -1475,6 +1514,7 @@ static int mtk_star_set_timing(struct mtk_star_priv *priv)
>  
>  	return regmap_write(priv->regs, MTK_STAR_REG_TEST0, delay_val);
>  }
> +
>  static int mtk_star_probe(struct platform_device *pdev)
>  {
>  	struct device_node *of_node;

spurious whitespace change
