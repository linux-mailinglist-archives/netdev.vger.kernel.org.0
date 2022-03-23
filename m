Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4A24E5A3C
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 21:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344825AbiCWUzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 16:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244002AbiCWUzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 16:55:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2318B8AE78;
        Wed, 23 Mar 2022 13:54:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E8E4D6E;
        Wed, 23 Mar 2022 13:54:15 -0700 (PDT)
Received: from [10.57.43.230] (unknown [10.57.43.230])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CBF03F73B;
        Wed, 23 Mar 2022 13:54:12 -0700 (PDT)
Message-ID: <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
Date:   Wed, 23 Mar 2022 20:54:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Content-Language: en-GB
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
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
References: <1812355.tdWV9SEqCh@natalenko.name>
 <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
 <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com>
 <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-23 19:16, Linus Torvalds wrote:
> On Wed, Mar 23, 2022 at 12:06 PM Robin Murphy <robin.murphy@arm.com> wrote:
>>
>> On 2022-03-23 17:27, Linus Torvalds wrote:
>>>
>>> I'm assuming that the ath9k issue is that it gives DMA mapping a big
>>> enough area to handle any possible packet size, and just expects -
>>> quite reasonably - smaller packets to only fill the part they need.
>>>
>>> Which that "info leak" patch obviously breaks entirely.
>>
>> Except that's the exact case which the new patch is addressing
> 
> Not "addressing". Breaking.
> 
> Which is why it will almost certainly get reverted.
> 
> Not doing DMA to the whole area seems to be quite the sane thing to do
> for things like network packets, and overwriting the part that didn't
> get DMA'd with zeroes seems to be exactly the wrong thing here.
> 
> So the SG_IO - and other random untrusted block command sources - data
> leak will almost certainly have to be addressed differently. Possibly
> by simply allocating the area with GFP_ZERO to begin with.

Er, the point of the block layer case is that whole area *is* zeroed to 
begin with, and a latent memory corruption problem in SWIOTLB itself 
replaces those zeros with random other kernel data unexpectedly. Let me 
try illustrating some sequences for clarity...

Expected behaviour/without SWIOTLB:
                              Memory
---------------------------------------------------
start                        12345678
dma_map(DMA_FROM_DEVICE)      no-op
device writes partial data   12ABC678 <- ABC
dma_unmap(DMA_FROM_DEVICE)   12ABC678


SWIOTLB previously:
                              Memory      Bounce buffer
---------------------------------------------------
start                        12345678    xxxxxxxx
dma_map(DMA_FROM_DEVICE)             no-op
device writes partial data   12345678    xxABCxxx <- ABC
dma_unmap(DMA_FROM_DEVICE)   xxABCxxx <- xxABCxxx


SWIOTLB Now:
                              Memory      Bounce buffer
---------------------------------------------------
start                        12345678    xxxxxxxx
dma_map(DMA_FROM_DEVICE)     12345678 -> 12345678
device writes partial data   12345678    12ABC678 <- ABC
dma_unmap(DMA_FROM_DEVICE)   12ABC678 <- 12ABC678


Now, sure we can prevent any actual information leakage by initialising 
the bounce buffer slot with zeros, but then we're just corrupting the 
not-written-to parts of the mapping with zeros instead of anyone else's 
old data. That's still fundamentally not OK. The only thing SWIOTLB can 
do to be correct is treat DMA_FROM_DEVICE as a read-modify-write of the 
entire mapping, because it has no way to know how much of it is actually 
going to be modified.

I'll admit I still never quite grasped the reason for also adding the 
override to swiotlb_sync_single_for_device() in aa6f8dcbab47, but I 
think by that point we were increasingly tired and confused and starting 
to second-guess ourselves (well, I was, at least). I don't think it's 
wrong per se, but as I said I do think it can bite anyone who's been 
doing dma_sync_*() wrong but getting away with it until now. If 
ddbd89deb7d3 alone turns out to work OK then I'd be inclined to try a 
partial revert of just that one hunk.

Thanks,
Robin.
