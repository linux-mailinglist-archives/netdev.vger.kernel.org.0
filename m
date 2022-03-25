Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278034E78D6
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376583AbiCYQZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354899AbiCYQZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:25:17 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E27AD5EBF7;
        Fri, 25 Mar 2022 09:23:41 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E0F1D6E;
        Fri, 25 Mar 2022 09:23:40 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E48393F73D;
        Fri, 25 Mar 2022 09:23:37 -0700 (PDT)
Message-ID: <11d4c863-5bee-aa98-526c-ac7170296485@arm.com>
Date:   Fri, 25 Mar 2022 16:23:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Content-Language: en-GB
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
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
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324190216.0efa067f.pasic@linux.ibm.com>
 <20220325162508.3273e0db.pasic@linux.ibm.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220325162508.3273e0db.pasic@linux.ibm.com>
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

On 2022-03-25 15:25, Halil Pasic wrote:
> On Thu, 24 Mar 2022 19:02:16 +0100
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
>>> I'll admit I still never quite grasped the reason for also adding the
>>> override to swiotlb_sync_single_for_device() in aa6f8dcbab47, but I
>>> think by that point we were increasingly tired and confused and starting
>>> to second-guess ourselves (well, I was, at least).
>>
>> I raised the question, do we need to do the same for
>> swiotlb_sync_single_for_device(). Did that based on my understanding of the
>> DMA API documentation. I had the following scenario in mind
>>
>> SWIOTLB without the snyc_single:
>>                                    Memory      Bounce buffer      Owner
>> --------------------------------------------------------------------------
>> start                             12345678    xxxxxxxx             C
>> dma_map(DMA_FROM_DEVICE)          12345678 -> 12345678             C->D
>> device writes partial data        12345678    12ABC678 <- ABC      D
>> sync_for_cpu(DMA_FROM_DEVICE)     12ABC678 <- 12ABC678             D->C
>> cpu modifies buffer               66666666    12ABC678             C
>> sync_for_device(DMA_FROM_DEVICE)  66666666    12ABC678             C->D
>> device writes partial data        66666666    1EFGC678 <-EFG       D
>> dma_unmap(DMA_FROM_DEVICE)        1EFGC678 <- 1EFGC678             D->C
>>
>> Legend: in Owner column C stands for cpu and D for device.
>>
>> Without swiotlb, I believe we should have arrived at 6EFG6666. To get the
>> same result, IMHO, we need to do a sync in sync_for_device().
>> And aa6f8dcbab47 is an imperfect solution to that (because of size).
>>
> 
> @Robin, Christoph: Do we consider this a valid scenario?

Aha, I see it now (turns out diagrams really do help!) - so essentially 
the original situation but with buffer recycling thrown into the mix as 
well... I think it's technically valid, but do we know if anything's 
actually doing that in a way which ends up affected? For sure it would 
be nice to know that we had all bases covered without having to audit 
whether we need to, but if it's fundamentally incompatible with what 
other code expects, that we know *is* being widely used, and however 
questionable it may be we don't have an easy fix for, then we're in a 
bit of a tough spot :(

Thanks,
Robin.
