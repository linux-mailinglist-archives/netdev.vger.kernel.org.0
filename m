Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C2F4E7BF8
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiCYT1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiCYT0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:26:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEC171E5222;
        Fri, 25 Mar 2022 12:00:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1AF313D5;
        Fri, 25 Mar 2022 11:42:25 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0FCD3F73D;
        Fri, 25 Mar 2022 11:42:22 -0700 (PDT)
Message-ID: <e077b229-c92b-c9a6-3581-61329c4b4a4b@arm.com>
Date:   Fri, 25 Mar 2022 18:42:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Content-Language: en-GB
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Christoph Hellwig <hch@lst.de>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
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
References: <1812355.tdWV9SEqCh@natalenko.name>
 <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
 <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com>
 <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324190216.0efa067f.pasic@linux.ibm.com> <20220325163204.GB16426@lst.de>
 <87y20x7vaz.fsf@toke.dk>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <87y20x7vaz.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-25 18:15, Toke Høiland-Jørgensen wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
>> On Thu, Mar 24, 2022 at 07:02:16PM +0100, Halil Pasic wrote:
>>>> If
>>>> ddbd89deb7d3 alone turns out to work OK then I'd be inclined to try a
>>>> partial revert of just that one hunk.
>>>>
>>>
>>> I'm not against being pragmatic and doing the partial revert. But as
>>> explained above, I do believe for correctness of swiotlb we ultimately
>>> do need that change. So if the revert is the short term solution,
>>> what should be our mid-term road-map?
>>
>> Unless I'm misunderstanding this thread we found the bug in ath9k
>> and have a fix for that now?
> 
> According to Maxim's comment on the other subthread, that ath9k patch
> wouldn't work on all platforms (and constitutes a bit of a violation of
> the DMA API ownership abstraction). So not quite, I think?

Indeed, it would potentially stand to pose the same problem as the 
SWIOTLB change, but on the scale of individual cache lines touched by 
ath9k_hw_process_rxdesc_edma() rather than the whole buffer. However, 
that might represent a less severe impact on a smaller number of users 
(maybe the MIPS systems? I'm not sure...) so perhaps it's an acceptable 
tourniquet? Note that the current code is already a violation of the DMA 
API (because the device keeps writing even when it doesn't have 
ownership), so there's not a very strong argument in that regard.

Thanks,
Robin.
