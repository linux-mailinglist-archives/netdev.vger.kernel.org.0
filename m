Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1862E6C68
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgL1Wzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729433AbgL1UlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 15:41:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4F98222B3;
        Mon, 28 Dec 2020 20:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609188025;
        bh=KcZQ6o41rlq4RH1a4W27CrNjjwRWrvYAisvQC5+hb/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HRxe6sPWVmeHl9CauFK/gog0Ri0Mh//aoaIozuEbcAX8W8ciyeRbRMWxsobPxSGdh
         FwVl56MVcRvwQz/hIcr4yPFiuTGcxNNCW7qE6dcmBTenrelSGkW2i3xC46mpYC9Q2Q
         QxW2J+IMs4hOL3tGnuDpcchkjEBM5LIUKrO++DD3YMio5C42qmZP8cs7EumnsSrn0K
         HnCC3WGXvq79HilrAFrxu//+aX5/FhykA+hFpO0/wkyDK0XeB6DKWPVhnCkYpZL+yE
         YpWxbHU8YyKCkA6CYE/opNDjDPqLZPggsK5ETI1a/RNOESRBlKiidBnWfOqH3e3krc
         Ld+aczWEy7bfw==
Date:   Mon, 28 Dec 2020 12:40:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/6] bcm63xx_enet: add xmit_more support
Message-ID: <20201228124024.32ceb0fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201224142421.32350-4-liew.s.piaw@gmail.com>
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
        <20201224142421.32350-4-liew.s.piaw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Dec 2020 22:24:18 +0800 Sieng Piaw Liew wrote:
> Support bulking hardware TX queue by using netdev_xmit_more().
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> index 90f8214b4d22..452968f168ed 100644
> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> @@ -633,14 +633,17 @@ bcm_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	netdev_sent_queue(dev, skb->len);
>  
> -	/* kick tx dma */
> -	enet_dmac_writel(priv, priv->dma_chan_en_mask,
> -				 ENETDMAC_CHANCFG, priv->tx_chan);
> -
>  	/* stop queue if no more desc available */
>  	if (!priv->tx_desc_count)
>  		netif_stop_queue(dev);
>  
> +	/* kick tx dma */
> +        if (!netdev_xmit_more() || !priv->tx_desc_count)
> +                enet_dmac_writel(priv, priv->dma_chan_en_mask,
> +                                 ENETDMAC_CHANCFG, priv->tx_chan);
> +
> +
> +
>  	dev->stats.tx_bytes += skb->len;
>  	dev->stats.tx_packets++;
>  	ret = NETDEV_TX_OK;

Please address checkpatch --strict issues throughout the series:

ERROR: code indent should use tabs where possible
#31: FILE: drivers/net/ethernet/broadcom/bcm63xx_enet.c:641:
+        if (!netdev_xmit_more() || !priv->tx_desc_count)$

WARNING: please, no spaces at the start of a line
#31: FILE: drivers/net/ethernet/broadcom/bcm63xx_enet.c:641:
+        if (!netdev_xmit_more() || !priv->tx_desc_count)$

ERROR: code indent should use tabs where possible
#32: FILE: drivers/net/ethernet/broadcom/bcm63xx_enet.c:642:
+                enet_dmac_writel(priv, priv->dma_chan_en_mask,$

WARNING: please, no spaces at the start of a line
#32: FILE: drivers/net/ethernet/broadcom/bcm63xx_enet.c:642:
+                enet_dmac_writel(priv, priv->dma_chan_en_mask,$

ERROR: code indent should use tabs where possible
#33: FILE: drivers/net/ethernet/broadcom/bcm63xx_enet.c:643:
+                                 ENETDMAC_CHANCFG, priv->tx_chan);$

WARNING: please, no spaces at the start of a line
#33: FILE: drivers/net/ethernet/broadcom/bcm63xx_enet.c:643:
+                                 ENETDMAC_CHANCFG, priv->tx_chan);$

CHECK: Please don't use multiple blank lines
#35: FILE: drivers/net/ethernet/broadcom/bcm63xx_enet.c:645:
+
+
