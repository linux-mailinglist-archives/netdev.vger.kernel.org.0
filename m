Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9ADE4AD1A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbfFRVNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:13:33 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:46703 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729982AbfFRVNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:13:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07417;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TUXsfqg_1560892397;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TUXsfqg_1560892397)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 19 Jun 2019 05:13:28 +0800
Subject: Re: [PATCH] mm: mempolicy: handle vma with unmovable pages mapped
 correctly in mbind
To:     Michal Hocko <mhocko@kernel.org>
Cc:     akpm@linux-foundation.org, vbabka@suse.cz,
        mgorman@techsingularity.net, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <1560797290-42267-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190618130253.GH3318@dhcp22.suse.cz>
 <cf33b724-fdd5-58e3-c06a-1bc563525311@linux.alibaba.com>
 <20190618182848.GJ3318@dhcp22.suse.cz>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <68c2592d-b747-e6eb-329f-7a428bff1f86@linux.alibaba.com>
Date:   Tue, 18 Jun 2019 14:13:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190618182848.GJ3318@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/19 11:28 AM, Michal Hocko wrote:
> On Tue 18-06-19 10:06:54, Yang Shi wrote:
>>
>> On 6/18/19 6:02 AM, Michal Hocko wrote:
>>> [Cc networking people - see a question about setsockopt below]
>>>
>>> On Tue 18-06-19 02:48:10, Yang Shi wrote:
>>>> When running syzkaller internally, we ran into the below bug on 4.9.x
>>>> kernel:
>>>>
>>>> kernel BUG at mm/huge_memory.c:2124!
>>> What is the BUG_ON because I do not see any BUG_ON neither in v4.9 nor
>>> the latest stable/linux-4.9.y
>> The line number might be not exactly same with upstream 4.9 since there
>> might be some our internal patches.
>>
>> It is line 2096 at mm/huge_memory.c in 4.9.182.
> So it is
> 	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
> that is later mentioned that has been removed. Good. Thanks for the
> clarification!
>
>>>> invalid opcode: 0000 [#1] SMP KASAN
>>> [...]
>>>> Code: c7 80 1c 02 00 e8 26 0a 76 01 <0f> 0b 48 c7 c7 40 46 45 84 e8 4c
>>>> RIP  [<ffffffff81895d6b>] split_huge_page_to_list+0x8fb/0x1030 mm/huge_memory.c:2124
>>>>    RSP <ffff88006899f980>
>>>>
>>>> with the below test:
>>>>
>>>> ---8<---
>>>>
>>>> uint64_t r[1] = {0xffffffffffffffff};
>>>>
>>>> int main(void)
>>>> {
>>>> 	syscall(__NR_mmap, 0x20000000, 0x1000000, 3, 0x32, -1, 0);
>>>> 				intptr_t res = 0;
>>>> 	res = syscall(__NR_socket, 0x11, 3, 0x300);
>>>> 	if (res != -1)
>>>> 		r[0] = res;
>>>> *(uint32_t*)0x20000040 = 0x10000;
>>>> *(uint32_t*)0x20000044 = 1;
>>>> *(uint32_t*)0x20000048 = 0xc520;
>>>> *(uint32_t*)0x2000004c = 1;
>>>> 	syscall(__NR_setsockopt, r[0], 0x107, 0xd, 0x20000040, 0x10);
>>>> 	syscall(__NR_mmap, 0x20fed000, 0x10000, 0, 0x8811, r[0], 0);
>>>> *(uint64_t*)0x20000340 = 2;
>>>> 	syscall(__NR_mbind, 0x20ff9000, 0x4000, 0x4002, 0x20000340,
>>>> 0x45d4, 3);
>>>> 	return 0;
>>>> }
>>>>
>>>> ---8<---
>>>>
>>>> Actually the test does:
>>>>
>>>> mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
>>>> socket(AF_PACKET, SOCK_RAW, 768)        = 3
>>>> setsockopt(3, SOL_PACKET, PACKET_TX_RING, {block_size=65536, block_nr=1, frame_size=50464, frame_nr=1}, 16) = 0
>>>> mmap(0x20fed000, 65536, PROT_NONE, MAP_SHARED|MAP_FIXED|MAP_POPULATE|MAP_DENYWRITE, 3, 0) = 0x20fed000
>>>> mbind(..., MPOL_MF_STRICT|MPOL_MF_MOVE) = 0
>>> Ughh. Do I get it right that that this setsockopt allows an arbitrary
>>> contiguous memory allocation size to be requested by a unpriviledged
>>> user? Or am I missing something that restricts there any restriction?
>> It needs CAP_NET_RAW to call socket() to set socket type to RAW. The test is
>> run by root user.
> OK, good. That is much better. I just didn't see the capability check. I
> can see one in packet_create but I do not see any in setsockopt. Maybe I
> just got lost in indirection or implied security model.
>   
> [...]
>>>> Change migrate_page_add() to check if the page is movable or not, if it
>>>> is unmovable, just return -EIO.  We don't have to check non-LRU movable
>>>> pages since just zsmalloc and virtio-baloon support this.  And, they
>>>> should be not able to reach here.
>>> You are not checking whether the page is movable, right? You only rely
>>> on PageLRU check which is not really an equivalent thing. There are
>>> movable pages which are not LRU and also pages might be off LRU
>>> temporarily for many reasons so this could lead to false positives.
>> I'm supposed non-LRU movable pages could not reach here. Since most of them
>> are not mmapable, i.e. virtio-balloon, zsmalloc. zram device is mmapable,
>> but the page fault to that vma would end up allocating user space pages
>> which are on LRU. If I miss something please let me know.
> That might be true right now but it is a very subtle assumption that
> might break easily in the future. The point is still that even LRU pages
> might be isolated from the LRU list temporarily and you do not want this
> to cause the failure easily.

I used to have !__PageMovable(page), but it was removed since the 
aforementioned reason. I could add it back.

For the temporary off LRU page, I did a quick search, it looks the most 
paths have to acquire mmap_sem, so it can't race with us here. Page 
reclaim/compaction looks like the only race. But, since the mapping 
should be preserved even though the page is off LRU temporarily unless 
the page is reclaimed, so we should be able to exclude temporary off LRU 
pages by calling page_mapping() and page_anon_vma().

So, the fix may look like:

if (!PageLRU(head) && !__PageMovable(page)) {
     if (!(page_mapping(page) || page_anon_vma(page)))
         return -EIO;
}

>

