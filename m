Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD1F2FF9CA
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbhAVBHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbhAVBHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 20:07:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76FAA20799;
        Fri, 22 Jan 2021 01:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611277627;
        bh=l7rkR42OuxejsKhxyiDFxuiuLb9LpmduXzlQoZ3Vc7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jg36tCaakT4Vqhe5/adn3GIemg2utiNRML23pug/q4XDesGpEuCIo7OA8L/ms1o7e
         OhhXOafBOZ0ErkYLOWQ+zJj40WcIvIy4g2m4lE/l35fAuQQ6x/NeyXdAsiyLzCd6WM
         lHHSjZjy6sIGY97gkYL5tJZNURVmy7/42baQ4nC2shJSiPY1JQt0QDJ/DU4fw3jiAG
         777os1J5oW0HPo7uvtQmnmS9Iq5q3MDV2cxKIu+qHlYr6xSX1xIu7eODKSHvWUywG2
         gTuTH53PJ3eqZPg+V8CBeKyKcgxGdNiwbGQu4Fj8VWIun+n/d4MgLMY3HvXxC1ioWQ
         0GjAibKH8uM7g==
Date:   Thu, 21 Jan 2021 17:07:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     <netdev@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] vmxnet3: Remove buf_info from device
 accessible structures
Message-ID: <20210121170705.08ecb23d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120021941.9655-1-doshir@vmware.com>
References: <20210120021941.9655-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 18:19:40 -0800 Ronak Doshi wrote:
> From: Petr Vandrovec <petr@vmware.com>
> 
> vmxnet3: Remove buf_info from device accessible structures

Something happened to the posting, looks like the subject is listed
twice?

> buf_info structures in RX & TX queues are private driver data that
> do not need to be visible to the device.  Although there is physical
> address and length in the queue descriptor that points to these
> structures, their layout is not standardized, and device never looks
> at them.
> 
> So lets allocate these structures in non-DMA-able memory, and fill
> physical address as all-ones and length as zero in the queue
> descriptor.
> 
> That should alleviate worries brought by Martin Radev in
> https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210104/022829.html
> that malicious vmxnet3 device could subvert SVM/TDX guarantees.
> 
> Signed-off-by: Petr Vandrovec <petr@vmware.com>
> Signed-off-by: Ronak Doshi <doshir@vmware.com>

> @@ -534,11 +530,13 @@ vmxnet3_tq_create(struct vmxnet3_tx_queue *tq,
>  		goto err;
>  	}
>  
> -	sz = tq->tx_ring.size * sizeof(tq->buf_info[0]);
> -	tq->buf_info = dma_alloc_coherent(&adapter->pdev->dev, sz,
> -					  &tq->buf_info_pa, GFP_KERNEL);
> -	if (!tq->buf_info)
> +	tq->buf_info = kmalloc_array_node(tq->tx_ring.size, sizeof(tq->buf_info[0]),
> +					  GFP_KERNEL | __GFP_ZERO,
> +					  dev_to_node(&adapter->pdev->dev));

kcalloc_node()

> +	if (!tq->buf_info) {
> +		netdev_err(adapter->netdev, "failed to allocate tx buffer info\n");

Please drop the message, OOM splat will be visible enough. checkpatch
usually points this out

>  		goto err;
> +	}

Same comments for vmxnet3_rq_create()
