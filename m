Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE8C4E5E5A
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 06:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347412AbiCXF7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 01:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346218AbiCXF7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 01:59:09 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B0F9398F;
        Wed, 23 Mar 2022 22:57:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 320C868B05; Thu, 24 Mar 2022 06:57:33 +0100 (CET)
Date:   Thu, 24 Mar 2022 06:57:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Message-ID: <20220324055732.GB12078@lst.de>
References: <1812355.tdWV9SEqCh@natalenko.name> <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com> <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com> <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 08:54:08PM +0000, Robin Murphy wrote:
> I'll admit I still never quite grasped the reason for also adding the 
> override to swiotlb_sync_single_for_device() in aa6f8dcbab47, but I think 
> by that point we were increasingly tired and confused and starting to 
> second-guess ourselves (well, I was, at least). I don't think it's wrong 
> per se, but as I said I do think it can bite anyone who's been doing 
> dma_sync_*() wrong but getting away with it until now. If ddbd89deb7d3 
> alone turns out to work OK then I'd be inclined to try a partial revert of 
> just that one hunk.

Agreed.  Let's try that first.

Oleksandr, can you try the patch below:


diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 6db1c475ec827..6c350555e5a1c 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -701,13 +701,10 @@ void swiotlb_tbl_unmap_single(struct device *dev, phys_addr_t tlb_addr,
 void swiotlb_sync_single_for_device(struct device *dev, phys_addr_t tlb_addr,
 		size_t size, enum dma_data_direction dir)
 {
-	/*
-	 * Unconditional bounce is necessary to avoid corruption on
-	 * sync_*_for_cpu or dma_ummap_* when the device didn't overwrite
-	 * the whole lengt of the bounce buffer.
-	 */
-	swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
-	BUG_ON(!valid_dma_direction(dir));
+	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
+		swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
+	else
+		BUG_ON(dir != DMA_FROM_DEVICE);
 }
 
 void swiotlb_sync_single_for_cpu(struct device *dev, phys_addr_t tlb_addr,
