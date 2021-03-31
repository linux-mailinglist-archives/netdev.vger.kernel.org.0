Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F2035028B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbhCaOmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:42:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:40620 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235758AbhCaOmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 10:42:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 03B56B30F;
        Wed, 31 Mar 2021 14:42:20 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>, qianjun.kernel@gmail.com
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20210329123635.56915-1-qianjun.kernel@gmail.com>
 <20210330224406.5e195f3b8b971ff2a56c657d@linux-foundation.org>
 <9f012469-ccda-2c95-aa5a-7ca4f6fb2891@suse.cz>
Subject: Re: [PATCH V2 1/1] mm:improve the performance during fork
Message-ID: <7148385c-befd-608c-0aee-2a0719f2ea0e@suse.cz>
Date:   Wed, 31 Mar 2021 16:42:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <9f012469-ccda-2c95-aa5a-7ca4f6fb2891@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/21 2:11 PM, Vlastimil Babka wrote:
> On 3/31/21 7:44 AM, Andrew Morton wrote:
>> On Mon, 29 Mar 2021 20:36:35 +0800 qianjun.kernel@gmail.com wrote:
>> 
>>> From: jun qian <qianjun.kernel@gmail.com>
>>> 
>>> In our project, Many business delays come from fork, so
>>> we started looking for the reason why fork is time-consuming.
>>> I used the ftrace with function_graph to trace the fork, found
>>> that the vm_normal_page will be called tens of thousands and
>>> the execution time of this vm_normal_page function is only a
>>> few nanoseconds. And the vm_normal_page is not a inline function.
>>> So I think if the function is inline style, it maybe reduce the
>>> call time overhead.
>>> 
>>> I did the following experiment:
>>> 
>>> use the bpftrace tool to trace the fork time :
>>> 
>>> bpftrace -e 'kprobe:_do_fork/comm=="redis-server"/ {@st=nsecs;} \
>>> kretprobe:_do_fork /comm=="redis-server"/{printf("the fork time \
>>> is %d us\n", (nsecs-@st)/1000)}'
>>> 
>>> no inline vm_normal_page:
>>> result:
>>> the fork time is 40743 us
>>> the fork time is 41746 us
>>> the fork time is 41336 us
>>> the fork time is 42417 us
>>> the fork time is 40612 us
>>> the fork time is 40930 us
>>> the fork time is 41910 us
>>> 
>>> inline vm_normal_page:
>>> result:
>>> the fork time is 39276 us
>>> the fork time is 38974 us
>>> the fork time is 39436 us
>>> the fork time is 38815 us
>>> the fork time is 39878 us
>>> the fork time is 39176 us
>>> 
>>> In the same test environment, we can get 3% to 4% of
>>> performance improvement.
>>> 
>>> note:the test data is from the 4.18.0-193.6.3.el8_2.v1.1.x86_64,
>>> because my product use this version kernel to test the redis
>>> server, If you need to compare the latest version of the kernel
>>> test data, you can refer to the version 1 Patch.
>>> 
>>> We need to compare the changes in the size of vmlinux:
>>>                   inline           non-inline       diff
>>> vmlinux size      9709248 bytes    9709824 bytes    -576 bytes
>>> 
>> 
>> I get very different results with gcc-7.2.0:
>> 
>> q:/usr/src/25> size mm/memory.o
>>    text    data     bss     dec     hex filename
>>   74898    3375      64   78337   13201 mm/memory.o-before
>>   75119    3363      64   78546   132d2 mm/memory.o-after
> 
> I got this:
> 
> ./scripts/bloat-o-meter memory.o.before mm/memory.o
> add/remove: 0/0 grow/shrink: 1/3 up/down: 285/-86 (199)
> Function                                     old     new   delta
> copy_pte_range                              2095    2380    +285
> vm_normal_page                               168     163      -5
> do_anonymous_page                           1039    1003     -36
> do_swap_page                                1835    1790     -45
> Total: Before=42411, After=42610, chg +0.47%
> 
> 
>> That's a somewhat significant increase in code size, and larger code
>> size has a worsened cache footprint.
>> 
>> Not that this is necessarily a bad thing for a function which is
>> tightly called many times in succession as is vm__normal_page()
> 
> Hm but the inline only affects the users within mm/memory.c, unless the kernel
> is built with link time optimization (LTO), which is not AFAIK not the standard yet.

So I tried to inline the fast path of vm_normal_page() for every caller, see
below. The difference is only on architectures with CONFIG_ARCH_HAS_PTE_SPECIAL
where the fast path doesn't even need to look at vma flags. Of course inlining
has size costs, but there might be performance benefits, so you might want to
try measuring if it's worth it and I should make it a formal patch.

It might be also even better if we give up on the highest_memmap_pfn check or
make it CONFIG_DEBUG_VM only.

> ./scripts/bloat-o-meter vmlinux.before vmlinux.after 
add/remove: 1/2 grow/shrink: 27/3 up/down: 2796/-479 (2317)
Function                                     old     new   delta
collapse_pte_mapped_thp                     1141    1364    +223
khugepaged_scan_pmd                         1532    1738    +206
__vm_normal_page                               -     168    +168
pagemap_pmd_range                           1679    1835    +156
__collapse_huge_page_isolate                1485    1628    +143
follow_page_pte                             1454    1596    +142
queue_pages_pte_range                        774     906    +132
clear_refs_pte_range                         944    1061    +117
do_numa_page                                 643     758    +115
__munlock_pagevec_fill                       438     551    +113
do_wp_page                                   567     676    +109
copy_pte_range                              1953    2055    +102
madvise_free_pte_range                      2053    2154    +101
gather_pte_stats                             693     793    +100
zap_pte_range                               1914    2000     +86
mc_handle_present_pte                        144     230     +86
smaps_hugetlb_range                          322     407     +85
clear_soft_dirty                             273     357     +84
get_gate_page                                668     751     +83
madvise_cold_or_pageout_pte_range           2885    2966     +81
get_mctgt_type                               576     657     +81
change_pte_range                            1300    1376     +76
smaps_pte_entry.isra                         455     513     +58
wp_page_copy                                1647    1696     +49
pud_offset.isra                              126     167     +41
do_swap_page                                1754    1790     +36
free_pud_range                              1050    1065     +15
arch_local_irq_enable                        136     144      +8
__pmd_alloc                                  670     668      -2
__handle_mm_fault                           1754    1738     -16
mem_cgroup_move_charge_pte_range            1661    1535    -126
mc_handle_swap_pte.constprop                 167       -    -167
vm_normal_page                               168       -    -168
Total: Before=29768466, After=29770783, chg +0.01%

----8<----
From f70bda6fbb7f17e13f3fa88fac203b7f426d0752 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 31 Mar 2021 15:59:15 +0200
Subject: [PATCH] inline vm_normal_page()

---
 include/linux/mm.h | 18 +++++++++++++++++-
 mm/internal.h      |  2 --
 mm/memory.c        |  2 +-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3e4dc6678eb2..1df6ce4ab668 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1711,8 +1711,24 @@ struct zap_details {
 	pgoff_t last_index;			/* Highest page->index to unmap */
 };
 
-struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
+struct page *__vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
+extern unsigned long highest_memmap_pfn;
+static inline struct page *vm_normal_page(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t pte)
+{
+	unsigned long pfn;
+
+	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)
+	    && likely(!pte_special(pte))) {
+		pfn = pte_pfn(pte);
+		if (likely(pfn <= highest_memmap_pfn))
+			return pfn_to_page(pfn);
+	}
+
+	return __vm_normal_page(vma, addr, pte);
+}
+
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd);
 
diff --git a/mm/internal.h b/mm/internal.h
index 547a8d7f0cbb..cca1cbc3f6fa 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -117,8 +117,6 @@ static inline bool is_page_poisoned(struct page *page)
 	return false;
 }
 
-extern unsigned long highest_memmap_pfn;
-
 /*
  * Maximum number of reclaim retries without progress before the OOM
  * killer is consider the only way forward.
diff --git a/mm/memory.c b/mm/memory.c
index 5c3b29d3af66..d801914cfce4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -603,7 +603,7 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
  * PFNMAP mappings in order to support COWable mappings.
  *
  */
-struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
+struct page *__vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			    pte_t pte)
 {
 	unsigned long pfn = pte_pfn(pte);
-- 
2.30.2




