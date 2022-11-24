Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83260637B21
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiKXOKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiKXOKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:10:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100F86AEFD;
        Thu, 24 Nov 2022 06:10:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40FC4CE2ABE;
        Thu, 24 Nov 2022 14:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6C0C433C1;
        Thu, 24 Nov 2022 14:10:44 +0000 (UTC)
Message-ID: <95cf026d-b37c-0b89-881a-325756645dae@xs4all.nl>
Date:   Thu, 24 Nov 2022 15:10:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 1/7] media: videobuf-dma-contig: use dma_mmap_coherent
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <20221113163535.884299-1-hch@lst.de>
 <20221113163535.884299-2-hch@lst.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <20221113163535.884299-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On 13/11/2022 17:35, Christoph Hellwig wrote:
> dma_alloc_coherent does not return a physical address, but a DMA address,
> which might be remapped or have an offset.  Passing the DMA address to
> vm_iomap_memory is thus broken.
> 
> Use the proper dma_mmap_coherent helper instead, and stop passing
> __GFP_COMP to dma_alloc_coherent, as the memory management inside the
> DMA allocator is hidden from the callers and does not require it.
> 
> With this the gfp_t argument to __videobuf_dc_alloc can be removed and
> hard coded to GFP_KERNEL.
> 
> Fixes: a8f3c203e19b ("[media] videobuf-dma-contig: add cache support")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/media/v4l2-core/videobuf-dma-contig.c | 22 +++++++------------

Very, very old code :-) Hopefully in the not-too-distant future we can kill off
the old videobuf framework. But for now:

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

I assume you take this? If not, then let me know and I will pick it up for the media
subsystem.

Regards,

	Hans

>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
> index 52312ce2ba056..f2c4393595574 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> @@ -36,12 +36,11 @@ struct videobuf_dma_contig_memory {
>  
>  static int __videobuf_dc_alloc(struct device *dev,
>  			       struct videobuf_dma_contig_memory *mem,
> -			       unsigned long size, gfp_t flags)
> +			       unsigned long size)
>  {
>  	mem->size = size;
> -	mem->vaddr = dma_alloc_coherent(dev, mem->size,
> -					&mem->dma_handle, flags);
> -
> +	mem->vaddr = dma_alloc_coherent(dev, mem->size, &mem->dma_handle,
> +					GFP_KERNEL);
>  	if (!mem->vaddr) {
>  		dev_err(dev, "memory alloc size %ld failed\n", mem->size);
>  		return -ENOMEM;
> @@ -258,8 +257,7 @@ static int __videobuf_iolock(struct videobuf_queue *q,
>  			return videobuf_dma_contig_user_get(mem, vb);
>  
>  		/* allocate memory for the read() method */
> -		if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(vb->size),
> -					GFP_KERNEL))
> +		if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(vb->size)))
>  			return -ENOMEM;
>  		break;
>  	case V4L2_MEMORY_OVERLAY:
> @@ -295,22 +293,18 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  	BUG_ON(!mem);
>  	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
>  
> -	if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(buf->bsize),
> -				GFP_KERNEL | __GFP_COMP))
> +	if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(buf->bsize)))
>  		goto error;
>  
> -	/* Try to remap memory */
> -	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -
>  	/* the "vm_pgoff" is just used in v4l2 to find the
>  	 * corresponding buffer data structure which is allocated
>  	 * earlier and it does not mean the offset from the physical
>  	 * buffer start address as usual. So set it to 0 to pass
> -	 * the sanity check in vm_iomap_memory().
> +	 * the sanity check in dma_mmap_coherent().
>  	 */
>  	vma->vm_pgoff = 0;
> -
> -	retval = vm_iomap_memory(vma, mem->dma_handle, mem->size);
> +	retval = dma_mmap_coherent(q->dev, vma, mem->vaddr, mem->dma_handle,
> +				   mem->size);
>  	if (retval) {
>  		dev_err(q->dev, "mmap: remap failed with error %d. ",
>  			retval);

