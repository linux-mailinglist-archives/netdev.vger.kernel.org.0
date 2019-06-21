Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470B74EEC0
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfFUSXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:23:51 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:55244 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbfFUSXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:23:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TUqdGdq_1561141423;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TUqdGdq_1561141423)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 22 Jun 2019 02:23:46 +0800
Subject: Re: [PATCH] mm: mempolicy: handle vma with unmovable pages mapped
 correctly in mbind
To:     Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>
Cc:     akpm@linux-foundation.org, mgorman@techsingularity.net,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <1560797290-42267-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190618130253.GH3318@dhcp22.suse.cz>
 <cf33b724-fdd5-58e3-c06a-1bc563525311@linux.alibaba.com>
 <20190618182848.GJ3318@dhcp22.suse.cz>
 <68c2592d-b747-e6eb-329f-7a428bff1f86@linux.alibaba.com>
 <20190619052133.GB2968@dhcp22.suse.cz>
 <21a0b20c-5b62-490e-ad8e-26b4b78ac095@suse.cz>
 <687f4e57-5c50-7900-645e-6ef3a5c1c0c7@linux.alibaba.com>
 <55eb2ea9-2c74-87b1-4568-b620c7913e17@linux.alibaba.com>
 <d81b36bb-876e-917a-6115-cedf496b4923@suse.cz>
 <d185f277-85ed-4dc1-8ff2-2984b54a0d64@linux.alibaba.com>
 <9945a66f-4434-b2a6-63ac-3240ef1d52c9@suse.cz>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <7d770cda-3f62-f1a2-6f48-529ca71bd6bd@linux.alibaba.com>
Date:   Fri, 21 Jun 2019 11:23:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <9945a66f-4434-b2a6-63ac-3240ef1d52c9@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/21/19 4:33 AM, Vlastimil Babka wrote:
> On 6/20/19 6:08 PM, Yang Shi wrote:
>>
>> On 6/20/19 12:18 AM, Vlastimil Babka wrote:
>>> On 6/19/19 8:19 PM, Yang Shi wrote:
>>>>>>> This is getting even more muddy TBH. Is there any reason that we
>>>>>>> have to
>>>>>>> handle this problem during the isolation phase rather the migration?
>>>>>> I think it was already said that if pages can't be isolated, then
>>>>>> migration phase won't process them, so they're just ignored.
>>>>> Yes，exactly.
>>>>>
>>>>>> However I think the patch is wrong to abort immediately when
>>>>>> encountering such page that cannot be isolated (AFAICS). IMHO it should
>>>>>> still try to migrate everything it can, and only then return -EIO.
>>>>> It is fine too. I don't see mbind semantics define how to handle such
>>>>> case other than returning -EIO.
>>> I think it does. There's:
>>> If MPOL_MF_MOVE is specified in flags, then the kernel *will attempt to
>>> move all the existing pages* ... If MPOL_MF_STRICT is also specified,
>>> then the call fails with the error *EIO if some pages could not be moved*
>>>
>>> Aborting immediately would be against the attempt to move all.
>>>
>>>> By looking into the code, it looks not that easy as what I thought.
>>>> do_mbind() would check the return value of queue_pages_range(), it just
>>>> applies the policy and manipulates vmas as long as the return value is 0
>>>> (success), then migrate pages on the list. We could put the movable
>>>> pages on the list by not breaking immediately, but they will be ignored.
>>>> If we migrate the pages regardless of the return value, it may break the
>>>> policy since the policy will *not* be applied at all.
>>> I think we just need to remember if there was at least one page that
>>> failed isolation or migration, but keep working, and in the end return
>>> EIO if there was such page(s). I don't think it breaks the policy. Once
>>> pages are allocated in a mapping, changing the policy is a best effort
>>> thing anyway.
>> The current behavior is:
>> If queue_pages_range() return -EIO (vma is not migratable, ignore other
>> conditions since we just focus on page migration), the policy won't be
>> set and no page will be migrated.
> Ah, I see. IIUC the current behavior is due to your recent commit
> a7f40cfe3b7a ("mm: mempolicy: make mbind() return -EIO when
> MPOL_MF_STRICT is specified") in order to fix commit 6f4576e3687b
> ("mempolicy: apply page table walker on queue_pages_range()"), which
> caused -EIO to be not returned enough. But I think you went too far and
> instead return -EIO too much. If I look at the code in parent commit of
> 6f4576e3687b, I can see in queue_pages_range():
>
> if ((flags & MPOL_MF_STRICT) ||
>          ((flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) &&
>          vma_migratable(vma))) {
>
>          err = queue_pages_pgd_range(vma, start, endvma, nodes,
>                                  flags, private);
>          if (err)
>                  break;
> }
>
> and in queue_pages_pte_range():
>
> if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
>          migrate_page_add(page, private, flags);
> else
>          break;
>
> So originally, there was no returning of -EIO due to !vma_migratable() -
> as long as MPOL_MF_STRICT and MPOL_MF_MOVE* was specified, the code
> tried to queue for migration everything it could and didn't ever abort,
> AFAICS. And I still think that's the best possible behavior.
>
>> However, the problem here is the vma might look migratable, but some or
>> all the underlying pages are unmovable. So, my patch assumes the vma is
>> *not* migratable if at least one page is unmovable. I'm not sure if it
>> is possible to have both movable and unmovable pages for the same
>> mapping or not, I'm supposed the vma would be split much earlier.
>>
>> If we don't abort immediately, then we record if there is unmovable
>> page, then we could do:
>> #1. Still follows the current behavior (then why not abort immediately?)
> See above how the current behavior differs from the original one.
>
>> #2. Set mempolicy then migrate all the migratable pages. But, we may end
>> up with the pages on node A, but the policy says node B. Doesn't it
>> break the policy?
> The policy can already be "broken" (violated is probably better word) by
> migrate_pages() failing. If that happens, we don't rollback the migrated
> pages and reset the policy back, right? I think the manpage is clear
> that MPOL_MF_MOVE is a best-effort. Userspace will know that not
> everything was successfully migrated (via -EIO), and can take whatever
> steps it deems necessary - attempt rollback, determine which exact
> page(s) are violating the policy, etc.

I see your point. It makes some sense to me. So, the policy should be 
set if MPOL_MF_MOVE* is specified even though no page is migrated so 
that we have consistent behavior for different cases:
* vma is not migratable
* vma is migratable, but pages are unmovable
* vma is migratable, pages are movable, but migrate_pages() fails

>

