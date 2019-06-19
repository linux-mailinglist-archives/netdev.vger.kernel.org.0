Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2B14C0AA
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 20:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbfFSSTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 14:19:20 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:37460 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbfFSSTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 14:19:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TUfkZRu_1560968352;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TUfkZRu_1560968352)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jun 2019 02:19:15 +0800
Subject: Re: [PATCH] mm: mempolicy: handle vma with unmovable pages mapped
 correctly in mbind
From:   Yang Shi <yang.shi@linux.alibaba.com>
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
Message-ID: <55eb2ea9-2c74-87b1-4568-b620c7913e17@linux.alibaba.com>
Date:   Wed, 19 Jun 2019 11:19:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <687f4e57-5c50-7900-645e-6ef3a5c1c0c7@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/19 9:21 AM, Yang Shi wrote:
>
>
> On 6/19/19 1:22 AM, Vlastimil Babka wrote:
>> On 6/19/19 7:21 AM, Michal Hocko wrote:
>>> On Tue 18-06-19 14:13:16, Yang Shi wrote:
>>> [...]
>>>> I used to have !__PageMovable(page), but it was removed since the
>>>> aforementioned reason. I could add it back.
>>>>
>>>> For the temporary off LRU page, I did a quick search, it looks the 
>>>> most
>>>> paths have to acquire mmap_sem, so it can't race with us here. Page
>>>> reclaim/compaction looks like the only race. But, since the mapping 
>>>> should
>>>> be preserved even though the page is off LRU temporarily unless the 
>>>> page is
>>>> reclaimed, so we should be able to exclude temporary off LRU pages by
>>>> calling page_mapping() and page_anon_vma().
>>>>
>>>> So, the fix may look like:
>>>>
>>>> if (!PageLRU(head) && !__PageMovable(page)) {
>>>>      if (!(page_mapping(page) || page_anon_vma(page)))
>>>>          return -EIO;
>>> This is getting even more muddy TBH. Is there any reason that we 
>>> have to
>>> handle this problem during the isolation phase rather the migration?
>> I think it was already said that if pages can't be isolated, then
>> migration phase won't process them, so they're just ignored.
>
> Yes，exactly.
>
>> However I think the patch is wrong to abort immediately when
>> encountering such page that cannot be isolated (AFAICS). IMHO it should
>> still try to migrate everything it can, and only then return -EIO.
>
> It is fine too. I don't see mbind semantics define how to handle such 
> case other than returning -EIO.

By looking into the code, it looks not that easy as what I thought. 
do_mbind() would check the return value of queue_pages_range(), it just 
applies the policy and manipulates vmas as long as the return value is 0 
(success), then migrate pages on the list. We could put the movable 
pages on the list by not breaking immediately, but they will be ignored. 
If we migrate the pages regardless of the return value, it may break the 
policy since the policy will *not* be applied at all.

>
>

