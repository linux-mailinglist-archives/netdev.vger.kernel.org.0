Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3375E0E97
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 01:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389751AbfJVXhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 19:37:42 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42580 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731847AbfJVXhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 19:37:42 -0400
Received: by mail-lj1-f196.google.com with SMTP id u4so4878783ljj.9
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 16:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fyB/vFz/ujzkN6+eBb05+enZnYQwWLICp2sAjF5YyB4=;
        b=u4ROBM+GmFnhKuRQQePAa9dFvciN0LgelsN4rk7gTQNLmluoGPQLZgplrqu4MDENb4
         3y+X6aoVyFzEjm9txZREb7EM+ofotOK0Kdwu3gNDAtu5/0K5iUvooDmpnECZxHh03hjJ
         mSLXN48gnYxZoXkg1xznrYP0K6eN095BH4lRH9538fLa7Q3C4wEEnb6G+7vW6EVtlGvN
         twCaibhlqvt6ENXKf+6Fo8mAALd/mR2qJkFFDSSoNCJ0Hl2dUY7Dv3RnUwohNtb7CmzQ
         cJ4pg5u++5z7c1J5oG+drLjonhAIlUK9TLYfj/WWEbXy7XK8jdSXPurblYhgOTrl+tww
         N+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fyB/vFz/ujzkN6+eBb05+enZnYQwWLICp2sAjF5YyB4=;
        b=FZA8hRZJb1+IHCpXrUC2fxtEUbxdz+UFAb05JTjjfsQzyTPO/whPjAhEDYAuY8hNmb
         ho2kRB3eV/5ACt8GOTRXrLBPSeZRb8Igo7VLgIF31Q3/lLxeWGIziWJaXmu+ZgFMtxBB
         Y3Uh8W6r0IHz0MlDgZZQHWVA3usytg22AzlrD4N38PfbsJLO/chGGR/igUcMmuWC+zOT
         Da9mSHUVYp3aWqK8kOcYQKzcz7IflBCJGGk6Ur/kmj2MLJ1QmEO2grnpnCMKCnfbiGFV
         RpEbCov41H+QBfsxZZA8YTEpxTFT1njowkQNofQ8J1UdJwdkY9C2JRvTnqYbjVWe9/o2
         kb1w==
X-Gm-Message-State: APjAAAWTpn2C30GjRTIxhxGcG30cvy+hCO8gkXIt8K4QIecmrt18DnpS
        pvDNIgb7LHLEFfzLZcmupzR1zQ==
X-Google-Smtp-Source: APXvYqxQ+mecaLWGVJduYrIsZZZVa+m+4eWk+pe5FBf+W/cOiGHEioDfCt0axBPgBmXkTHoPAkoriw==
X-Received: by 2002:a2e:999a:: with SMTP id w26mr897618lji.200.1571787459881;
        Tue, 22 Oct 2019 16:37:39 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w23sm2741973lfe.84.2019.10.22.16.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 16:37:39 -0700 (PDT)
Date:   Tue, 22 Oct 2019 16:37:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 5/6] ionic: implement support for rx sgl
Message-ID: <20191022163732.102f357c@cakuba.netronome.com>
In-Reply-To: <20191022203113.30015-6-snelson@pensando.io>
References: <20191022203113.30015-1-snelson@pensando.io>
        <20191022203113.30015-6-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 13:31:12 -0700, Shannon Nelson wrote:
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> index ab6663d94f42..8c96f5fe43a2 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> @@ -34,52 +34,107 @@ static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
>  	return netdev_get_tx_queue(q->lif->netdev, q->index);
>  }
>  
> -static void ionic_rx_recycle(struct ionic_queue *q, struct ionic_desc_info *desc_info,
> -			     struct sk_buff *skb)
> +static struct sk_buff *ionic_rx_skb_alloc(struct ionic_queue *q,
> +					  unsigned int len, bool frags)
>  {
> -	struct ionic_rxq_desc *old = desc_info->desc;
> -	struct ionic_rxq_desc *new = q->head->desc;
> +	struct ionic_lif *lif = q->lif;
> +	struct ionic_rx_stats *stats;
> +	struct net_device *netdev;
> +	struct sk_buff *skb;
> +
> +	netdev = lif->netdev;
> +	stats = q_to_rx_stats(q);
>  
> -	new->addr = old->addr;
> -	new->len = old->len;
> +	if (frags)
> +		skb = napi_get_frags(&q_to_qcq(q)->napi);
> +	else
> +		skb = netdev_alloc_skb_ip_align(netdev, len);
>  
> -	ionic_rxq_post(q, true, ionic_rx_clean, skb);
> +	if (unlikely(!skb)) {
> +		net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
> +				     netdev->name, q->name);
> +		stats->alloc_err++;
> +		return NULL;
> +	}
> +
> +	return skb;
>  }
>  
> -static bool ionic_rx_copybreak(struct ionic_queue *q, struct ionic_desc_info *desc_info,
> -			       struct ionic_cq_info *cq_info, struct sk_buff **skb)
> +static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
> +				      struct ionic_desc_info *desc_info,
> +				      struct ionic_cq_info *cq_info)
>  {
>  	struct ionic_rxq_comp *comp = cq_info->cq_desc;
> -	struct ionic_rxq_desc *desc = desc_info->desc;
> -	struct net_device *netdev = q->lif->netdev;
>  	struct device *dev = q->lif->ionic->dev;
> -	struct sk_buff *new_skb;
> -	u16 clen, dlen;
> -
> -	clen = le16_to_cpu(comp->len);
> -	dlen = le16_to_cpu(desc->len);
> -	if (clen > q->lif->rx_copybreak) {
> -		dma_unmap_single(dev, (dma_addr_t)le64_to_cpu(desc->addr),
> -				 dlen, DMA_FROM_DEVICE);
> -		return false;
> -	}
> +	struct ionic_page_info *page_info;
> +	struct sk_buff *skb;
> +	unsigned int i;
> +	u16 frag_len;
> +	u16 len;
>  
> -	new_skb = netdev_alloc_skb_ip_align(netdev, clen);
> -	if (!new_skb) {
> -		dma_unmap_single(dev, (dma_addr_t)le64_to_cpu(desc->addr),
> -				 dlen, DMA_FROM_DEVICE);
> -		return false;
> -	}
> +	page_info = &desc_info->pages[0];
> +	len = le16_to_cpu(comp->len);
>  
> -	dma_sync_single_for_cpu(dev, (dma_addr_t)le64_to_cpu(desc->addr),
> -				clen, DMA_FROM_DEVICE);
> +	prefetch(page_address(page_info->page) + NET_IP_ALIGN);
>  
> -	memcpy(new_skb->data, (*skb)->data, clen);
> +	skb = ionic_rx_skb_alloc(q, len, true);
> +	if (unlikely(!skb))
> +		return NULL;
>  
> -	ionic_rx_recycle(q, desc_info, *skb);
> -	*skb = new_skb;
> +	i = comp->num_sg_elems + 1;
> +	do {
> +		if (unlikely(!page_info->page)) {
> +			dev_kfree_skb(skb);
> +			return NULL;
> +		}

Would you not potentially free the napi->skb here? is that okay?
