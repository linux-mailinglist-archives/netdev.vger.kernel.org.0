Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49F46D0607
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjC3NKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbjC3NKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:10:40 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11EBAAF16
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:10:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07BB22F4;
        Thu, 30 Mar 2023 06:11:00 -0700 (PDT)
Received: from [10.57.54.254] (unknown [10.57.54.254])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 717243F663;
        Thu, 30 Mar 2023 06:10:14 -0700 (PDT)
Message-ID: <76c7e508-c7ca-e2d9-5915-545b394623ae@arm.com>
Date:   Thu, 30 Mar 2023 14:10:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: AMD IOMMU problem after NIC uses multi-page allocation
Content-Language: en-GB
From:   Robin Murphy <robin.murphy@arm.com>
To:     Joerg Roedel <joro@8bytes.org>, Jakub Kicinski <kuba@kernel.org>,
        Vasant Hegde <vasant.hegde@amd.com>
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Saeed Mahameed <saeed@kernel.org>
References: <20230329181407.3eed7378@kernel.org> <ZCU9KZMlGMWb2ezZ@8bytes.org>
 <202ea27f-aa79-66b6-0c80-ba0459eef5bd@arm.com>
In-Reply-To: <202ea27f-aa79-66b6-0c80-ba0459eef5bd@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-03-30 14:04, Robin Murphy wrote:
> On 2023-03-30 08:41, Joerg Roedel wrote:
>> Also adding Vasant and Robin.
>>
>> Vasant, Robin, any idea?
>>
>> On Wed, Mar 29, 2023 at 06:14:07PM -0700, Jakub Kicinski wrote:
>>> Hi Joerg, Suravee,
>>>
>>> I see an odd NIC behavior with AMD IOMMU in lazy mode (on 5.19).
>>>
>>> The NIC allocates a buffer for Rx packets which is MTU rounded up
>>> to page size. If I run it with 1500B MTU or 9000 MTU everything is
>>> fine, slight but manageable perf hit.
>>>
>>> But if I flip the MTU to 9k, run some traffic and then go back to 1.5k
>>> - 70%+ of CPU cycles are spent in alloc_iova (and children).
>>>
>>> Does this ring any bells?
> 
> There is that old issue already mentioned where there seems to be some 
> interplay between the IOVA caching and the lazy flush queue, which we 
> never really managed to get to the bottom of. IIRC my hunch was that 
> with a sufficiently large number of CPUs, fq_flush_timeout() overwhelms 
> the rcache depot and gets into a pathological state where it then 
> continually thrashes the IOVA rbtree in a fight with the caching system.
> 
> Another (simpler) possibility which comes to mind is if the 9K MTU 
> (which I guess means 16KB IOVA allocations) puts you up against the 
> threshold of available 32-bit IOVA space - if you keep using the 16K 
> entries then you'll mostly be recycling them out of the IOVA caches, 
> which is nice and fast. However once you switch back to 1500 so needing 
> 2KB IOVAs, you've now got a load of IOVA space hogged by all the 16KB 
> entries that are now hanging around in caches, which could push you into 
> the case where the optimistic 32-bit allocation starts to fail (but 
> because it *can* fall back to a 64-bit allocation, it's not going to 
> purge those unused 16KB entries to free up more 32-bit space). If the 
> 32-bit space then *stays* full, alloc_iova should stay in fail-fast 
> mode, but if some 2KB allocations were below 32 bits and eventually get 
> freed back to the tree, then subsequent attempts are liable to spend 
> ages doing doing their best to scrape up all the available 32-bit space 
> until it's definitely full again. For that case, [1] should help.

...where by "2KB" I obviously mean 4KB, since apparently in remembering 
that the caches round up to powers of two I managed to forget that 
that's still in units of IOVA pages, derp.

Robin.

> 
> Even in the second case, though, I think hitting the rbtree much at all 
> still implies that the caches might not be well-matched to the 
> workload's map/unmap pattern, and maybe scaling up the depot size could 
> still be the biggest win.
> 
> Thanks,
> Robin.
> 
> [1] 
> https://lore.kernel.org/linux-iommu/e9abc601b00e26fd15a583fcd55f2a8227903077.1674061620.git.robin.murphy@arm.com/
> 
