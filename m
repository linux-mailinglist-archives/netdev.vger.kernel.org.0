Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25EF4A5617
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiBAFOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:14:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33296 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiBAFOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:14:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78E80B82CED;
        Tue,  1 Feb 2022 05:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB98C340EB;
        Tue,  1 Feb 2022 05:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643692470;
        bh=SlKUSsanHhv7euwwKvLYnC9xWaO8rbm0sDYqIncPNu4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r/FcHYRKpN4xD2cdNW6iG/m08du0FVd0XzCfbJSu4/HqmEtBd1FzyPcQyb2z0q59l
         +gl8Fqc8sVM49lgP23DNsx9hUQ/VBg6ZklP9nvvpOhL4AO098zT+WrueyeBRjz6ycY
         n/ckC47kZPu/Q+wPPXSnY8vHqhmUHszhW3AFxPTjwgioKMpPa4pPUsAc5YNOb7uEmN
         UC5OSPOSqYaw6mPesdwGN1uPssumQcmaPQ1J3RQZ7Xa2TUMPFaVLRWQ4yCIHMXzKKD
         30IPss69TTW/N5nUO5nlzC2COC0ubW9DVQxtzPg6Y1g40sSUSQGjFSKg3jZskoGWk8
         Xgt0zTSJNJoxA==
Date:   Mon, 31 Jan 2022 21:14:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Georgi Valkov <gvalkov@abv.bg>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Message-ID: <20220131211428.07cc4aa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2f001839-2628-cf80-f5e3-415e7492e206@siemens.com>
References: <2f001839-2628-cf80-f5e3-415e7492e206@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022 19:58:14 +0100 Jan Kiszka wrote:
> From: Georgi Valkov <gvalkov@abv.bg>
> 
> When rx_buf is allocated we need to account for IPHETH_IP_ALIGN,
> which reduces the usable size by 2 bytes. Otherwise we have 1512
> bytes usable instead of 1514, and if we receive more than 1512
> bytes, ipheth_rcvbulk_callback is called with status -EOVERFLOW,
> after which the driver malfunctiones and all communication stops.
> 
> Resolves ipheth 2-1:4.2: ipheth_rcvbulk_callback: urb status: -75
> 
> Fixes: f33d9e2b48a3 ("usbnet: ipheth: fix connectivity with iOS 14")
> Signed-off-by: Georgi Valkov <gvalkov@abv.bg>
> Tested-by: Jan Kiszka <jan.kiszka@siemens.com>

Hm, I'm starting to suspect this patch is cursed..

> diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
> index cd33955df0b6..6a769df0b421 100644
> --- a/drivers/net/usb/ipheth.c
> +++ b/drivers/net/usb/ipheth.c
> @@ -121,7 +121,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
>   	if (tx_buf == NULL)

There is an extra space character at the start of each line of context.

>   		goto free_rx_urb;
>   
> -	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,

But not on the changed lines.

> +	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
>   				    GFP_KERNEL, &rx_urb->transfer_dma);
>   	if (rx_buf == NULL)
>   		goto free_tx_buf;
> @@ -146,7 +146,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
>   
>   static void ipheth_free_urbs(struct ipheth_device *iphone)
>   {
> -	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,

Pretty clear here in how the opening bracket does not align after the -.

> +	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, iphone->rx_buf,
>   			  iphone->rx_urb->transfer_dma);
>   	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
>   			  iphone->tx_urb->transfer_dma);
> @@ -317,7 +317,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
>   
>   	usb_fill_bulk_urb(dev->rx_urb, udev,
>   			  usb_rcvbulkpipe(udev, dev->bulk_in),
> -			  dev->rx_buf, IPHETH_BUF_SIZE,
> +			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
>   			  ipheth_rcvbulk_callback,
>   			  dev);
>   	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;

