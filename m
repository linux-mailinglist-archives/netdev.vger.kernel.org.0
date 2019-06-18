Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A024A7E1
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfFRRHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:07:17 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:50858 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729774AbfFRRHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:07:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TUXRpT3_1560877625;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TUXRpT3_1560877625)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 19 Jun 2019 01:07:12 +0800
Subject: Re: [PATCH] mm: mempolicy: handle vma with unmovable pages mapped
 correctly in mbind
To:     Michal Hocko <mhocko@kernel.org>
Cc:     akpm@linux-foundation.org, vbabka@suse.cz,
        mgorman@techsingularity.net, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <1560797290-42267-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190618130253.GH3318@dhcp22.suse.cz>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <cf33b724-fdd5-58e3-c06a-1bc563525311@linux.alibaba.com>
Date:   Tue, 18 Jun 2019 10:06:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190618130253.GH3318@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/19 6:02 AM, Michal Hocko wrote:
> [Cc networking people - see a question about setsockopt below]
>
> On Tue 18-06-19 02:48:10, Yang Shi wrote:
>> When running syzkaller internally, we ran into the below bug on 4.9.x
>> kernel:
>>
>> kernel BUG at mm/huge_memory.c:2124!
> What is the BUG_ON because I do not see any BUG_ON neither in v4.9 nor
> the latest stable/linux-4.9.y

The line number might be not exactly same with upstream 4.9 since there 
might be some our internal patches.

It is line 2096 at mm/huge_memory.c in 4.9.182.

>
>> invalid opcode: 0000 [#1] SMP KASAN
> [...]
>> Code: c7 80 1c 02 00 e8 26 0a 76 01 <0f> 0b 48 c7 c7 40 46 45 84 e8 4c
>> RIP  [<ffffffff81895d6b>] split_huge_page_to_list+0x8fb/0x1030 mm/huge_memory.c:2124
>>   RSP <ffff88006899f980>
>>
>> with the below test:
>>
>> ---8<---
>>
>> uint64_t r[1] = {0xffffffffffffffff};
>>
>> int main(void)
>> {
>> 	syscall(__NR_mmap, 0x20000000, 0x1000000, 3, 0x32, -1, 0);
>> 				intptr_t res = 0;
>> 	res = syscall(__NR_socket, 0x11, 3, 0x300);
>> 	if (res != -1)
>> 		r[0] = res;
>> *(uint32_t*)0x20000040 = 0x10000;
>> *(uint32_t*)0x20000044 = 1;
>> *(uint32_t*)0x20000048 = 0xc520;
>> *(uint32_t*)0x2000004c = 1;
>> 	syscall(__NR_setsockopt, r[0], 0x107, 0xd, 0x20000040, 0x10);
>> 	syscall(__NR_mmap, 0x20fed000, 0x10000, 0, 0x8811, r[0], 0);
>> *(uint64_t*)0x20000340 = 2;
>> 	syscall(__NR_mbind, 0x20ff9000, 0x4000, 0x4002, 0x20000340,
>> 0x45d4, 3);
>> 	return 0;
>> }
>>
>> ---8<---
>>
>> Actually the test does:
>>
>> mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
>> socket(AF_PACKET, SOCK_RAW, 768)        = 3
>> setsockopt(3, SOL_PACKET, PACKET_TX_RING, {block_size=65536, block_nr=1, frame_size=50464, frame_nr=1}, 16) = 0
>> mmap(0x20fed000, 65536, PROT_NONE, MAP_SHARED|MAP_FIXED|MAP_POPULATE|MAP_DENYWRITE, 3, 0) = 0x20fed000
>> mbind(..., MPOL_MF_STRICT|MPOL_MF_MOVE) = 0
> Ughh. Do I get it right that that this setsockopt allows an arbitrary
> contiguous memory allocation size to be requested by a unpriviledged
> user? Or am I missing something that restricts there any restriction?

It needs CAP_NET_RAW to call socket() to set socket type to RAW. The 
test is run by root user.

>
>> The setsockopt() would allocate compound pages (16 pages in this test)
>> for packet tx ring, then the mmap() would call packet_mmap() to map the
>> pages into the user address space specifed by the mmap() call.
>>
>> When calling mbind(), it would scan the vma to queue the pages for
>> migration to the new node.  It would split any huge page since 4.9
>> doesn't support THP migration, however, the packet tx ring compound
>> pages are not THP and even not movable.  So, the above bug is triggered.
>>
>> However, the later kernel is not hit by this issue due to the commit
>> d44d363f65780f2ac2ec672164555af54896d40d ("mm: don't assume anonymous
>> pages have SwapBacked flag"), which just removes the PageSwapBacked
>> check for a different reason.
>>
>> But, there is a deeper issue.  According to the semantic of mbind(), it
>> should return -EIO if MPOL_MF_MOVE or MPOL_MF_MOVE_ALL was specified and
>> the kernel was unable to move all existing pages in the range.  The tx ring
>> of the packet socket is definitely not movable, however, mbind returns
>> success for this case.
>>
>> Although the most socket file associates with non-movable pages, but XDP
>> may have movable pages from gup.  So, it sounds not fine to just check
>> the underlying file type of vma in vma_migratable().
>>
>> Change migrate_page_add() to check if the page is movable or not, if it
>> is unmovable, just return -EIO.  We don't have to check non-LRU movable
>> pages since just zsmalloc and virtio-baloon support this.  And, they
>> should be not able to reach here.
> You are not checking whether the page is movable, right? You only rely
> on PageLRU check which is not really an equivalent thing. There are
> movable pages which are not LRU and also pages might be off LRU
> temporarily for many reasons so this could lead to false positives.

I'm supposed non-LRU movable pages could not reach here. Since most of 
them are not mmapable, i.e. virtio-balloon, zsmalloc. zram device is 
mmapable, but the page fault to that vma would end up allocating user 
space pages which are on LRU. If I miss something please let me know.

The migrate_page_add() also just checks PageLRU(), non-LRU pages will be 
*not* put on the migration list at all. See migrate_page_add() -> 
isolate_lru_page().

> So I do not think this fix is correct. Blowing up on a BUG_ON is
> definitely not a right thing to do but we should rely on migrate_pages
> to fail the migration and report the failure based on that.

The BUG_ON was removed by commit 
d44d363f65780f2ac2ec672164555af54896d40d ("mm: don't assume anonymous 
pages have SwapBacked flag") since 4.12.

Actually, those pages will *not* be put on the migration list at all 
since they are !PageLRU. So, we can't rely on migrate_pages(). This is 
why I added the check in migrate_page_add().

>
>> With this change the above test would return -EIO as expected.
>>
>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>> ---
>>   include/linux/mempolicy.h |  3 ++-
>>   mm/mempolicy.c            | 22 +++++++++++++++++-----
>>   2 files changed, 19 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
>> index 5228c62..cce7ba3 100644
>> --- a/include/linux/mempolicy.h
>> +++ b/include/linux/mempolicy.h
>> @@ -198,7 +198,8 @@ static inline bool vma_migratable(struct vm_area_struct *vma)
>>   	if (vma->vm_file &&
>>   		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
>>   								< policy_zone)
>> -			return false;
>> +		return false;
>> +
> Any reason to make this change?

Just a indent fix by hand.

>
>>   	return true;
>>   }
>>   
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index 2219e74..4d9e17d 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -403,7 +403,7 @@ void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
>>   	},
>>   };
>>   
>> -static void migrate_page_add(struct page *page, struct list_head *pagelist,
>> +static int migrate_page_add(struct page *page, struct list_head *pagelist,
>>   				unsigned long flags);
>>   
>>   struct queue_pages {
>> @@ -467,7 +467,9 @@ static int queue_pages_pmd(pmd_t *pmd, spinlock_t *ptl, unsigned long addr,
>>   			goto unlock;
>>   		}
>>   
>> -		migrate_page_add(page, qp->pagelist, flags);
>> +		ret = migrate_page_add(page, qp->pagelist, flags);
>> +		if (ret)
>> +			goto unlock;
>>   	} else
>>   		ret = -EIO;
>>   unlock:
>> @@ -521,7 +523,9 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
>>   		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
>>   			if (!vma_migratable(vma))
>>   				break;
>> -			migrate_page_add(page, qp->pagelist, flags);
>> +			ret = migrate_page_add(page, qp->pagelist, flags);
>> +			if (ret)
>> +				break;
>>   		} else
>>   			break;
>>   	}
>> @@ -940,10 +944,15 @@ static long do_get_mempolicy(int *policy, nodemask_t *nmask,
>>   /*
>>    * page migration, thp tail pages can be passed.
>>    */
>> -static void migrate_page_add(struct page *page, struct list_head *pagelist,
>> +static int migrate_page_add(struct page *page, struct list_head *pagelist,
>>   				unsigned long flags)
>>   {
>>   	struct page *head = compound_head(page);
>> +
>> +	/* Non-movable page may reach here. */
>> +	if (!PageLRU(head))
>> +		return -EIO;
>> +
>>   	/*
>>   	 * Avoid migrating a page that is shared with others.
>>   	 */
>> @@ -955,6 +964,8 @@ static void migrate_page_add(struct page *page, struct list_head *pagelist,
>>   				hpage_nr_pages(head));
>>   		}
>>   	}
>> +
>> +	return 0;
>>   }
>>   
>>   /* page allocation callback for NUMA node migration */
>> @@ -1157,9 +1168,10 @@ static struct page *new_page(struct page *page, unsigned long start)
>>   }
>>   #else
>>   
>> -static void migrate_page_add(struct page *page, struct list_head *pagelist,
>> +static int migrate_page_add(struct page *page, struct list_head *pagelist,
>>   				unsigned long flags)
>>   {
>> +	return -EIO;
>>   }
>>   
>>   int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
>> -- 
>> 1.8.3.1
>>

