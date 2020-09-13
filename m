Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC87267E39
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 08:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgIMG4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 02:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgIMG4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Sep 2020 02:56:04 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 060B420758;
        Sun, 13 Sep 2020 06:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599980163;
        bh=MFOsHHlRXQokbJQFQqgLPqPAX9+N8PMEzABG1yqClVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mAhhmDp3Zx8fquVcwAakO1l/JK3mxG9GGEv49R8H0Qosv283CfqJb2qL4FoAUBNnf
         sFeTGWRKJ52aQxurFO4LAb748twprXCJWGwI3edTMHaVFyz75U4xzQ1He4jGZvLEQx
         8p7xD2yMKwAbSYtbwwUiLPbiRbaKkcN7UyGUhW9w=
Date:   Sun, 13 Sep 2020 09:55:59 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, snelson@pensando.io,
        jeffrey.t.kirsher@intel.com, mhabets@solarflare.com,
        yuehaibing@huawei.com, mchehab+huawei@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: dl2k: switch from 'pci_' to 'dma_' API
Message-ID: <20200913065559.GB35718@unreal>
References: <20200913061417.347682-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200913061417.347682-1-christophe.jaillet@wanadoo.fr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 08:14:17AM +0200, Christophe JAILLET wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
>
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
>
> When memory is allocated in 'rio_probe1()' GFP_KERNEL can be used because
> it is a probe function and no lock is taken in the between.
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
> ---
> If needed, see post from Christoph Hellwig on the kernel-janitors ML:
>    https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
> ---
>  drivers/net/ethernet/dlink/dl2k.c | 80 ++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
> index e8e563d6e86b..734acb834c98 100644
> --- a/drivers/net/ethernet/dlink/dl2k.c
> +++ b/drivers/net/ethernet/dlink/dl2k.c
> @@ -222,13 +222,15 @@ rio_probe1 (struct pci_dev *pdev, const struct pci_device_id *ent)
>
>  	pci_set_drvdata (pdev, dev);
>
> -	ring_space = pci_alloc_consistent (pdev, TX_TOTAL_SIZE, &ring_dma);
> +	ring_space = dma_alloc_coherent(&pdev->dev, TX_TOTAL_SIZE, &ring_dma,
> +					GFP_KERNEL);
>  	if (!ring_space)
>  		goto err_out_iounmap;
>  	np->tx_ring = ring_space;
>  	np->tx_ring_dma = ring_dma;
>
> -	ring_space = pci_alloc_consistent (pdev, RX_TOTAL_SIZE, &ring_dma);
> +	ring_space = dma_alloc_coherent(&pdev->dev, RX_TOTAL_SIZE, &ring_dma,
> +					GFP_KERNEL);
>  	if (!ring_space)
>  		goto err_out_unmap_tx;
>  	np->rx_ring = ring_space;
> @@ -279,9 +281,11 @@ rio_probe1 (struct pci_dev *pdev, const struct pci_device_id *ent)
>  	return 0;
>
>  err_out_unmap_rx:
> -	pci_free_consistent (pdev, RX_TOTAL_SIZE, np->rx_ring, np->rx_ring_dma);
> +	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, np->rx_ring,
> +			  np->rx_ring_dma);
>  err_out_unmap_tx:
> -	pci_free_consistent (pdev, TX_TOTAL_SIZE, np->tx_ring, np->tx_ring_dma);
> +	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, np->tx_ring,
> +			  np->tx_ring_dma);
>  err_out_iounmap:
>  #ifdef MEM_MAPPING
>  	pci_iounmap(pdev, np->ioaddr);
> @@ -435,8 +439,9 @@ static void free_list(struct net_device *dev)
>  	for (i = 0; i < RX_RING_SIZE; i++) {
>  		skb = np->rx_skbuff[i];
>  		if (skb) {
> -			pci_unmap_single(np->pdev, desc_to_dma(&np->rx_ring[i]),
> -					 skb->len, PCI_DMA_FROMDEVICE);
> +			dma_unmap_single(&np->pdev->dev,
> +					 desc_to_dma(&np->rx_ring[i]),
> +					 skb->len, DMA_FROM_DEVICE);
>  			dev_kfree_skb(skb);
>  			np->rx_skbuff[i] = NULL;
>  		}
> @@ -446,8 +451,9 @@ static void free_list(struct net_device *dev)
>  	for (i = 0; i < TX_RING_SIZE; i++) {
>  		skb = np->tx_skbuff[i];
>  		if (skb) {
> -			pci_unmap_single(np->pdev, desc_to_dma(&np->tx_ring[i]),
> -					 skb->len, PCI_DMA_TODEVICE);
> +			dma_unmap_single(&np->pdev->dev,
> +					 desc_to_dma(&np->tx_ring[i]),
> +					 skb->len, DMA_TO_DEVICE);
>  			dev_kfree_skb(skb);
>  			np->tx_skbuff[i] = NULL;
>  		}
> @@ -504,9 +510,8 @@ static int alloc_list(struct net_device *dev)
>  						sizeof(struct netdev_desc));
>  		/* Rubicon now supports 40 bits of addressing space. */
>  		np->rx_ring[i].fraginfo =
> -		    cpu_to_le64(pci_map_single(
> -				  np->pdev, skb->data, np->rx_buf_sz,
> -				  PCI_DMA_FROMDEVICE));
> +		    cpu_to_le64(dma_map_single(&np->pdev->dev, skb->data,
> +					       np->rx_buf_sz, DMA_FROM_DEVICE));

I'm aware that this was before, but both pci_map_single and
dma_map_single return an ERROR and it is wrong to set .fraginfo without
checking result.

Thanks
