Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF29C363487
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 11:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhDRJxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 05:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhDRJxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 05:53:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8ABF61245;
        Sun, 18 Apr 2021 09:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618739585;
        bh=Ba4waG/GMIaliKOryxeDCXHOqw2qzedBBiR3ALILMi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kPKkAB6hXefM/OhpqmhqZEGAao8Ulzz4N52Zv6JB8tDUeWqzRQmURXi4Jh/QEDktd
         HJ2z2cRCm2tHAN6aI2Jj5Isz4IDwf4yLt+uzGHOlznGlBEAJn4g1kBJyoPw4jUZ7AF
         q81Gz4QlejOHVFq4693jQM+a2Iaoh6r/DaiS0JGVcJlK+CRBeKmS9fPG5cn68mVgmr
         u6cT0VT02D8/zsfmpV12Q+8keiUhUdH70PEA80xRl2m4IJ+k4zPzNBplT79sl4MTSx
         Q8brrx0ynX0AmrnnVUztCoenCl4N1ySCJyBy8YXvSYKncqO+XDGp8o6FXAEN8QN8jv
         HYBARynjAwD4w==
Date:   Sun, 18 Apr 2021 12:53:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [RFC V2 PATCH 11/12] HV/Netvsc: Add Isolation VM support for
 netvsc driver
Message-ID: <YHwBfVvUU5i+E43o@unreal>
References: <20210413152217.3386288-1-ltykernel@gmail.com>
 <20210413152217.3386288-12-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413152217.3386288-12-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 11:22:16AM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> pagebuffer() still need to handle. Use DMA API to map/umap these
> memory during sending/receiving packet and Hyper-V DMA ops callback
> will use swiotlb fucntion to allocate bounce buffer and copy data
> from/to bounce buffer.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/net/hyperv/hyperv_net.h   |  11 +++
>  drivers/net/hyperv/netvsc.c       | 137 ++++++++++++++++++++++++++++--
>  drivers/net/hyperv/rndis_filter.c |   3 +
>  3 files changed, 144 insertions(+), 7 deletions(-)

<...>

> +	packet->dma_range = kzalloc(sizeof(struct dma_range) * page_count,
> +			      GFP_KERNEL);
> +	if (!packet->dma_range)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < page_count; i++) {
> +		char *src = phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
> +					 + pb[i].offset);
> +		u32 len = pb[i].len;
> +
> +		dma = dma_map_single(&hv_dev->device, src, len,
> +				     DMA_TO_DEVICE);
> +		if (dma_mapping_error(&hv_dev->device, dma))
> +			return -ENOMEM;

Don't you leak dma_range here?

BTW, It will be easier if you CC all on all patches, so we will be able
to get whole context.

Thanks
