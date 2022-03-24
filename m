Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8F64E6779
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 18:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352106AbiCXRJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 13:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242253AbiCXRJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 13:09:05 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DCDB18A8;
        Thu, 24 Mar 2022 10:07:32 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648141651; bh=fBBTep0fsFEy1SpGBxltwkhke+QjxK1XAYERNO2rihY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=bhFRZWBsXOArjlqHIuob1rAQIRclaUsGXtG0oYMnqwucW0eBkVtBa836EE26AgPkP
         rDYnYVabCLw7xPJJZklieM6hKIXr4OOKDCxYIma89OF2kmdzdPfixk6LsMRH7/XpIt
         XoLz6iqw/Nel9vizNBhxFPAcqltsDSYj+nLrKAqu4dwFqA81LfGt1aBWoedpWXOH6J
         TNW9npCRFGqtmCp7jaAYTq7v1fDBmeIPIe6qntS+LTFQtOEYN7gPB7m6SWe7SuXTIy
         3+tCgwzG5AXbPni5j6XNyuq6vjIpvATiyCHA5Fg0gRLyJzJnOq1dioEQtcZ4hmYBua
         d42HhFVa3yW5w==
To:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
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
In-Reply-To: <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de>
 <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
Date:   Thu, 24 Mar 2022 18:07:29 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <871qyr9t4e.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robin Murphy <robin.murphy@arm.com> writes:

> On 2022-03-24 16:31, Christoph Hellwig wrote:
>> On Thu, Mar 24, 2022 at 05:29:12PM +0100, Maxime Bizon wrote:
>>>> I'm looking into this; but in the interest of a speedy resolution of
>>>> the regression I would be in favour of merging that partial revert
>>>> and reinstating it if/when we identify (and fix) any bugs in ath9k :)
>>>
>>> This looks fishy:
>>>
>>> ath9k/recv.c
>>>
>>>                  /* We will now give hardware our shiny new allocated skb */
>>>                  new_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
>>>                                                common->rx_bufsize, dma_type);
>>>                  if (unlikely(dma_mapping_error(sc->dev, new_buf_addr))) {
>>>                          dev_kfree_skb_any(requeue_skb);
>>>                          goto requeue_drop_frag;
>>>                  }
>>>
>>>                  /* Unmap the frame */
>>>                  dma_unmap_single(sc->dev, bf->bf_buf_addr,
>>>                                   common->rx_bufsize, dma_type);
>>>
>>>                  bf->bf_mpdu = requeue_skb;
>>>                  bf->bf_buf_addr = new_buf_addr;
>> 
>> Creating a new mapping for the same buffer before unmapping the
>> previous one does looks rather bogus.  But it does not fit the
>> pattern where revering the sync_single changes make the driver
>> work again.
>
> OK, you made me look :)
>
> Now that it's obvious what to look for, I can only conclude that during 
> the stanza in ath_edma_get_buffers(), the device is still writing to the 
> buffer while ownership has been transferred to the CPU, and whatever got 
> written while ath9k_hw_process_rxdesc_edma() was running then gets wiped 
> out by the subsequent sync_for_device, which currently resets the 
> SWIOTLB slot to the state that sync_for_cpu copied out. By the letter of 
> the DMA API that's not allowed, but on the other hand I'm not sure if we 
> even have a good idiom for "I can't tell if the device has finished with 
> this buffer or not unless I look at it" :/

Right, but is that sync_for_device call really needed? AFAICT, that
ath9k_hw_process_rxdesc_edma() invocation doesn't actually modify any of
the data when it returns EINPROGRESS, so could we just skip it? Like
the patch below? Or am I misunderstanding the semantics here?

-Toke


diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0c0624a3b40d..19244d4c0ada 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -647,12 +647,8 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
                                common->rx_bufsize, DMA_FROM_DEVICE);
 
        ret = ath9k_hw_process_rxdesc_edma(ah, rs, skb->data);
-       if (ret == -EINPROGRESS) {
-               /*let device gain the buffer again*/
-               dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
-                               common->rx_bufsize, DMA_FROM_DEVICE);
+       if (ret == -EINPROGRESS)
                return false;
-       }
 
        __skb_unlink(skb, &rx_edma->rx_fifo);
        if (ret == -EINVAL) {
