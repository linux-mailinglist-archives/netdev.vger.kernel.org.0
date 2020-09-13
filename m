Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133AB268041
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 18:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgIMQ16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 12:27:58 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50716 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgIMQ1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 12:27:45 -0400
Received: by mail-pj1-f65.google.com with SMTP id fa1so4235478pjb.0;
        Sun, 13 Sep 2020 09:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=99mJRke/K5Jx/9ojxZkFXY3kQViInUZG48Hln+GwTEc=;
        b=WOwd2DVtfqtanem40liLPLhDjDhlHQttWxCX3bT8eUGOVLU7hCf6lJyENJNoF9AhNx
         HtoabOf28LGdiAqNosG0m1N0bjpvBkmBdt56rkaloJzhSi/ZBZ80kPQxqcFlgGDVt1Zt
         RZEQxHlHcCIU1BqkAst3wp1PY5l0VLyTndYOj3NqnZj/YAZixXmB6jfO1QQ88eK+1jvv
         5mm3fvyE2C9pBMU1FaV0VP7tvcZc9uRN5eE0fvGXsMB/Z/OMB5bsJQ7DGUlbsmibAOzj
         iXfhrdeKpNEsB1Qh+hkDE8OcfhbvL78pqWV1vZ6HGCXV7lhVrVb/JhPcyJQrVfAeiBcF
         a4ag==
X-Gm-Message-State: AOAM531npQ/WvtgMZrc+Rcj9d6GCGuByYxtOW4+5sf9BVWG+ycUzi1F/
        AoFscut9AmDHdHgQl2KQsKpwzLvQS18=
X-Google-Smtp-Source: ABdhPJzFcKSHvxkCZ98ToNisIGMfxoVgrbsaoVAMJ3Uq9kwdhLD1tShNb/3h13fu79JtznLl5C49Fw==
X-Received: by 2002:a17:90a:b88a:: with SMTP id o10mr10414878pjr.58.1600014464214;
        Sun, 13 Sep 2020 09:27:44 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1161:a4cc:eef9:fbc0:2781])
        by smtp.gmail.com with ESMTPSA id c1sm1589070pfj.219.2020.09.13.09.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 09:27:43 -0700 (PDT)
Date:   Sun, 13 Sep 2020 09:27:42 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, mhabets@solarflare.com,
        arnd@arndb.de, hkallweit1@gmail.com, mdf@kernel.org,
        mst@redhat.com, vaibhavgupta40@gmail.com, leon@kernel.org,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tulip: de2104x: switch from 'pci_' to 'dma_' API
Message-ID: <20200913162742.GA38105@epycbox.lan>
References: <20200913124453.355542-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200913124453.355542-1-christophe.jaillet@wanadoo.fr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 02:44:53PM +0200, Christophe JAILLET wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'de_alloc_rings()' GFP_KERNEL can be used
> because it is only called from 'de_open()' which is a '.ndo_open'
> function. Such functions are synchronized using the rtnl_lock() semaphore
> and no lock is taken in the between.
> 
> 
> @@
> @@
> -    PCI_DMA_BIDIRECTIONAL
> +    DMA_BIDIRECTIONAL
> 
> @@
> @@
> -    PCI_DMA_TODEVICE
> +    DMA_TO_DEVICE
> 
> @@
> @@
> -    PCI_DMA_FROMDEVICE
> +    DMA_FROM_DEVICE
> 
> @@
> @@
> -    PCI_DMA_NONE
> +    DMA_NONE
> 
> @@
> expression e1, e2, e3;
> @@
> -    pci_alloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> 
> @@
> expression e1, e2, e3;
> @@
> -    pci_zalloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_free_consistent(e1, e2, e3, e4)
> +    dma_free_coherent(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_single(e1, e2, e3, e4)
> +    dma_map_single(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_single(e1, e2, e3, e4)
> +    dma_unmap_single(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4, e5;
> @@
> -    pci_map_page(e1, e2, e3, e4, e5)
> +    dma_map_page(&e1->dev, e2, e3, e4, e5)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_page(e1, e2, e3, e4)
> +    dma_unmap_page(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_sg(e1, e2, e3, e4)
> +    dma_map_sg(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_sg(e1, e2, e3, e4)
> +    dma_unmap_sg(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
> +    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_device(e1, e2, e3, e4)
> +    dma_sync_single_for_device(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
> +    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
> +    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2;
> @@
> -    pci_dma_mapping_error(e1, e2)
> +    dma_mapping_error(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_dma_mask(e1, e2)
> +    dma_set_mask(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_consistent_dma_mask(e1, e2)
> +    dma_set_coherent_mask(&e1->dev, e2)
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
> If needed, see post from Christoph Hellwig on the kernel-janitors ML:
>    https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
> ---
>  drivers/net/ethernet/dec/tulip/de2104x.c | 62 ++++++++++++++----------
>  1 file changed, 36 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
> index cb116b530f5e..0931881403b6 100644
> --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> @@ -443,21 +443,23 @@ static void de_rx (struct de_private *de)
>  		}
>  
>  		if (!copying_skb) {
> -			pci_unmap_single(de->pdev, mapping,
> -					 buflen, PCI_DMA_FROMDEVICE);
> +			dma_unmap_single(&de->pdev->dev, mapping, buflen,
> +					 DMA_FROM_DEVICE);
>  			skb_put(skb, len);
>  
>  			mapping =
>  			de->rx_skb[rx_tail].mapping =
> -				pci_map_single(de->pdev, copy_skb->data,
> -					       buflen, PCI_DMA_FROMDEVICE);
> +				dma_map_single(&de->pdev->dev, copy_skb->data,
> +					       buflen, DMA_FROM_DEVICE);
>  			de->rx_skb[rx_tail].skb = copy_skb;
>  		} else {
> -			pci_dma_sync_single_for_cpu(de->pdev, mapping, len, PCI_DMA_FROMDEVICE);
> +			dma_sync_single_for_cpu(&de->pdev->dev, mapping, len,
> +						DMA_FROM_DEVICE);
>  			skb_reserve(copy_skb, RX_OFFSET);
>  			skb_copy_from_linear_data(skb, skb_put(copy_skb, len),
>  						  len);
> -			pci_dma_sync_single_for_device(de->pdev, mapping, len, PCI_DMA_FROMDEVICE);
> +			dma_sync_single_for_device(&de->pdev->dev, mapping,
> +						   len, DMA_FROM_DEVICE);
>  
>  			/* We'll reuse the original ring buffer. */
>  			skb = copy_skb;
> @@ -554,13 +556,15 @@ static void de_tx (struct de_private *de)
>  			goto next;
>  
>  		if (unlikely(skb == DE_SETUP_SKB)) {
> -			pci_unmap_single(de->pdev, de->tx_skb[tx_tail].mapping,
> -					 sizeof(de->setup_frame), PCI_DMA_TODEVICE);
> +			dma_unmap_single(&de->pdev->dev,
> +					 de->tx_skb[tx_tail].mapping,
> +					 sizeof(de->setup_frame),
> +					 DMA_TO_DEVICE);
>  			goto next;
>  		}
>  
> -		pci_unmap_single(de->pdev, de->tx_skb[tx_tail].mapping,
> -				 skb->len, PCI_DMA_TODEVICE);
> +		dma_unmap_single(&de->pdev->dev, de->tx_skb[tx_tail].mapping,
> +				 skb->len, DMA_TO_DEVICE);
>  
>  		if (status & LastFrag) {
>  			if (status & TxError) {
> @@ -620,7 +624,8 @@ static netdev_tx_t de_start_xmit (struct sk_buff *skb,
>  	txd = &de->tx_ring[entry];
>  
>  	len = skb->len;
> -	mapping = pci_map_single(de->pdev, skb->data, len, PCI_DMA_TODEVICE);
> +	mapping = dma_map_single(&de->pdev->dev, skb->data, len,
> +				 DMA_TO_DEVICE);
>  	if (entry == (DE_TX_RING_SIZE - 1))
>  		flags |= RingEnd;
>  	if (!tx_free || (tx_free == (DE_TX_RING_SIZE / 2)))
> @@ -763,8 +768,8 @@ static void __de_set_rx_mode (struct net_device *dev)
>  
>  	de->tx_skb[entry].skb = DE_SETUP_SKB;
>  	de->tx_skb[entry].mapping = mapping =
> -	    pci_map_single (de->pdev, de->setup_frame,
> -			    sizeof (de->setup_frame), PCI_DMA_TODEVICE);
> +	    dma_map_single(&de->pdev->dev, de->setup_frame,
> +			   sizeof(de->setup_frame), DMA_TO_DEVICE);
>  
>  	/* Put the setup frame on the Tx list. */
>  	txd = &de->tx_ring[entry];
> @@ -1279,8 +1284,10 @@ static int de_refill_rx (struct de_private *de)
>  		if (!skb)
>  			goto err_out;
>  
> -		de->rx_skb[i].mapping = pci_map_single(de->pdev,
> -			skb->data, de->rx_buf_sz, PCI_DMA_FROMDEVICE);
> +		de->rx_skb[i].mapping = dma_map_single(&de->pdev->dev,
> +						       skb->data,
> +						       de->rx_buf_sz,
> +						       DMA_FROM_DEVICE);
>  		de->rx_skb[i].skb = skb;
>  
>  		de->rx_ring[i].opts1 = cpu_to_le32(DescOwn);
> @@ -1313,7 +1320,8 @@ static int de_init_rings (struct de_private *de)
>  
>  static int de_alloc_rings (struct de_private *de)
>  {
> -	de->rx_ring = pci_alloc_consistent(de->pdev, DE_RING_BYTES, &de->ring_dma);
> +	de->rx_ring = dma_alloc_coherent(&de->pdev->dev, DE_RING_BYTES,
> +					 &de->ring_dma, GFP_KERNEL);
>  	if (!de->rx_ring)
>  		return -ENOMEM;
>  	de->tx_ring = &de->rx_ring[DE_RX_RING_SIZE];
> @@ -1333,8 +1341,9 @@ static void de_clean_rings (struct de_private *de)
>  
>  	for (i = 0; i < DE_RX_RING_SIZE; i++) {
>  		if (de->rx_skb[i].skb) {
> -			pci_unmap_single(de->pdev, de->rx_skb[i].mapping,
> -					 de->rx_buf_sz, PCI_DMA_FROMDEVICE);
> +			dma_unmap_single(&de->pdev->dev,
> +					 de->rx_skb[i].mapping, de->rx_buf_sz,
> +					 DMA_FROM_DEVICE);
>  			dev_kfree_skb(de->rx_skb[i].skb);
>  		}
>  	}
> @@ -1344,15 +1353,15 @@ static void de_clean_rings (struct de_private *de)
>  		if ((skb) && (skb != DE_DUMMY_SKB)) {
>  			if (skb != DE_SETUP_SKB) {
>  				de->dev->stats.tx_dropped++;
> -				pci_unmap_single(de->pdev,
> -					de->tx_skb[i].mapping,
> -					skb->len, PCI_DMA_TODEVICE);
> +				dma_unmap_single(&de->pdev->dev,
> +						 de->tx_skb[i].mapping,
> +						 skb->len, DMA_TO_DEVICE);
>  				dev_kfree_skb(skb);
>  			} else {
> -				pci_unmap_single(de->pdev,
> -					de->tx_skb[i].mapping,
> -					sizeof(de->setup_frame),
> -					PCI_DMA_TODEVICE);
> +				dma_unmap_single(&de->pdev->dev,
> +						 de->tx_skb[i].mapping,
> +						 sizeof(de->setup_frame),
> +						 DMA_TO_DEVICE);
>  			}
>  		}
>  	}
> @@ -1364,7 +1373,8 @@ static void de_clean_rings (struct de_private *de)
>  static void de_free_rings (struct de_private *de)
>  {
>  	de_clean_rings(de);
> -	pci_free_consistent(de->pdev, DE_RING_BYTES, de->rx_ring, de->ring_dma);
> +	dma_free_coherent(&de->pdev->dev, DE_RING_BYTES, de->rx_ring,
> +			  de->ring_dma);
>  	de->rx_ring = NULL;
>  	de->tx_ring = NULL;
>  }
> -- 
> 2.25.1
> 
Thanks,
Moritz
