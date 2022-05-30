Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419AE53888E
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 23:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240246AbiE3VUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 17:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiE3VUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 17:20:19 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D244EA30;
        Mon, 30 May 2022 14:20:18 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nvmo7-000EnB-SM; Mon, 30 May 2022 23:20:11 +0200
Received: from [85.1.206.226] (helo=linux-2.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nvmo7-000Sj7-Dh; Mon, 30 May 2022 23:20:11 +0200
Subject: Re: [PATCH v3 1/2] bpf: avoid grabbing spin_locks of all cpus when no
 free elems
To:     Feng zhou <zhoufeng.zf@bytedance.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com
References: <20220530091340.53443-1-zhoufeng.zf@bytedance.com>
 <20220530091340.53443-2-zhoufeng.zf@bytedance.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3cd2bc87-d766-0466-7079-eaff14fbe422@iogearbox.net>
Date:   Mon, 30 May 2022 23:20:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220530091340.53443-2-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26557/Mon May 30 10:05:44 2022)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/22 11:13 AM, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> This patch add is_empty in pcpu_freelist_head to check freelist
> having free or not. If having, grab spin_lock, or check next cpu's
> freelist.
> 
> Before patch: hash_map performance
> ./map_perf_test 1
> 0:hash_map_perf pre-alloc 975345 events per sec
> 4:hash_map_perf pre-alloc 855367 events per sec
> 12:hash_map_perf pre-alloc 860862 events per sec
> 8:hash_map_perf pre-alloc 849561 events per sec
> 3:hash_map_perf pre-alloc 849074 events per sec
> 6:hash_map_perf pre-alloc 847120 events per sec
> 10:hash_map_perf pre-alloc 845047 events per sec
> 5:hash_map_perf pre-alloc 841266 events per sec
> 14:hash_map_perf pre-alloc 849740 events per sec
> 2:hash_map_perf pre-alloc 839598 events per sec
> 9:hash_map_perf pre-alloc 838695 events per sec
> 11:hash_map_perf pre-alloc 845390 events per sec
> 7:hash_map_perf pre-alloc 834865 events per sec
> 13:hash_map_perf pre-alloc 842619 events per sec
> 1:hash_map_perf pre-alloc 804231 events per sec
> 15:hash_map_perf pre-alloc 795314 events per sec
> 
> hash_map the worst: no free
> ./map_perf_test 2048
> 6:worse hash_map_perf pre-alloc 28628 events per sec
> 5:worse hash_map_perf pre-alloc 28553 events per sec
> 11:worse hash_map_perf pre-alloc 28543 events per sec
> 3:worse hash_map_perf pre-alloc 28444 events per sec
> 1:worse hash_map_perf pre-alloc 28418 events per sec
> 7:worse hash_map_perf pre-alloc 28427 events per sec
> 13:worse hash_map_perf pre-alloc 28330 events per sec
> 14:worse hash_map_perf pre-alloc 28263 events per sec
> 9:worse hash_map_perf pre-alloc 28211 events per sec
> 15:worse hash_map_perf pre-alloc 28193 events per sec
> 12:worse hash_map_perf pre-alloc 28190 events per sec
> 10:worse hash_map_perf pre-alloc 28129 events per sec
> 8:worse hash_map_perf pre-alloc 28116 events per sec
> 4:worse hash_map_perf pre-alloc 27906 events per sec
> 2:worse hash_map_perf pre-alloc 27801 events per sec
> 0:worse hash_map_perf pre-alloc 27416 events per sec
> 3:worse hash_map_perf pre-alloc 28188 events per sec
> 
> ftrace trace
> 
> 0)               |  htab_map_update_elem() {
> 0)   0.198 us    |    migrate_disable();
> 0)               |    _raw_spin_lock_irqsave() {
> 0)   0.157 us    |      preempt_count_add();
> 0)   0.538 us    |    }
> 0)   0.260 us    |    lookup_elem_raw();
> 0)               |    alloc_htab_elem() {
> 0)               |      __pcpu_freelist_pop() {
> 0)               |        _raw_spin_lock() {
> 0)   0.152 us    |          preempt_count_add();
> 0)   0.352 us    |          native_queued_spin_lock_slowpath();
> 0)   1.065 us    |        }
> 		 |	  ...
> 0)               |        _raw_spin_unlock() {
> 0)   0.254 us    |          preempt_count_sub();
> 0)   0.555 us    |        }
> 0) + 25.188 us   |      }
> 0) + 25.486 us   |    }
> 0)               |    _raw_spin_unlock_irqrestore() {
> 0)   0.155 us    |      preempt_count_sub();
> 0)   0.454 us    |    }
> 0)   0.148 us    |    migrate_enable();
> 0) + 28.439 us   |  }
> 
> The test machine is 16C, trying to get spin_lock 17 times, in addition
> to 16c, there is an extralist.
> 
> after patch: hash_map performance
> ./map_perf_test 1
> 0:hash_map_perf pre-alloc 969348 events per sec
> 10:hash_map_perf pre-alloc 906526 events per sec
> 11:hash_map_perf pre-alloc 904557 events per sec
> 9:hash_map_perf pre-alloc 902384 events per sec
> 15:hash_map_perf pre-alloc 912287 events per sec
> 14:hash_map_perf pre-alloc 905689 events per sec
> 12:hash_map_perf pre-alloc 903680 events per sec
> 13:hash_map_perf pre-alloc 902631 events per sec
> 8:hash_map_perf pre-alloc 875369 events per sec
> 4:hash_map_perf pre-alloc 862808 events per sec
> 1:hash_map_perf pre-alloc 857218 events per sec
> 2:hash_map_perf pre-alloc 852875 events per sec
> 5:hash_map_perf pre-alloc 846497 events per sec
> 6:hash_map_perf pre-alloc 828467 events per sec
> 3:hash_map_perf pre-alloc 812542 events per sec
> 7:hash_map_perf pre-alloc 805336 events per sec
> 
> hash_map worst: no free
> ./map_perf_test 2048
> 7:worse hash_map_perf pre-alloc 391104 events per sec
> 4:worse hash_map_perf pre-alloc 388073 events per sec
> 5:worse hash_map_perf pre-alloc 387038 events per sec
> 1:worse hash_map_perf pre-alloc 386546 events per sec
> 0:worse hash_map_perf pre-alloc 384590 events per sec
> 11:worse hash_map_perf pre-alloc 379378 events per sec
> 10:worse hash_map_perf pre-alloc 375480 events per sec
> 12:worse hash_map_perf pre-alloc 372394 events per sec
> 6:worse hash_map_perf pre-alloc 367692 events per sec
> 3:worse hash_map_perf pre-alloc 363970 events per sec
> 9:worse hash_map_perf pre-alloc 364008 events per sec
> 8:worse hash_map_perf pre-alloc 363759 events per sec
> 2:worse hash_map_perf pre-alloc 360743 events per sec
> 14:worse hash_map_perf pre-alloc 361195 events per sec
> 13:worse hash_map_perf pre-alloc 360276 events per sec
> 15:worse hash_map_perf pre-alloc 360057 events per sec
> 0:worse hash_map_perf pre-alloc 378177 events per sec
> 
> ftrace trace
> 0)               |  htab_map_update_elem() {
> 0)   0.317 us    |    migrate_disable();
> 0)               |    _raw_spin_lock_irqsave() {
> 0)   0.260 us    |      preempt_count_add();
> 0)   1.803 us    |    }
> 0)   0.276 us    |    lookup_elem_raw();
> 0)               |    alloc_htab_elem() {
> 0)   0.586 us    |      __pcpu_freelist_pop();
> 0)   0.945 us    |    }
> 0)               |    _raw_spin_unlock_irqrestore() {
> 0)   0.160 us    |      preempt_count_sub();
> 0)   0.972 us    |    }
> 0)   0.657 us    |    migrate_enable();
> 0)   8.669 us    |  }
> 
> It can be seen that after adding this patch, the map performance is
> almost not degraded, and when free=0, first check is_empty instead of
> directly acquiring spin_lock.
> 
> As for why to add is_empty instead of directly judging head->first, my
> understanding is this, head->first is frequently modified during updating
> map, which will lead to invalid other cpus's cache, and is_empty is after
> freelist having no free elems will be changed, the performance will be better.
> 
> Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>   kernel/bpf/percpu_freelist.c | 28 +++++++++++++++++++++++++---
>   kernel/bpf/percpu_freelist.h |  1 +
>   2 files changed, 26 insertions(+), 3 deletions(-)
[...]
>   	/* per cpu lists are all empty, try extralist */
> +	if (s->extralist.is_empty)
> +		return NULL;
>   	raw_spin_lock(&s->extralist.lock);
>   	node = s->extralist.first;
> -	if (node)
> +	if (node) {
>   		s->extralist.first = node->next;
> +		if (!s->extralist.first)
> +			s->extralist.is_empty = true;
> +	}
>   	raw_spin_unlock(&s->extralist.lock);
>   	return node;
>   }
> @@ -164,15 +178,20 @@ ___pcpu_freelist_pop_nmi(struct pcpu_freelist *s)
>   	orig_cpu = cpu = raw_smp_processor_id();
>   	while (1) {
>   		head = per_cpu_ptr(s->freelist, cpu);
> +		if (head->is_empty)

This should use READ_ONCE/WRITE_ONCE pair for head->is_empty.

> +			goto next_cpu;
>   		if (raw_spin_trylock(&head->lock)) {
>   			node = head->first;
>   			if (node) {
>   				head->first = node->next;
> +				if (!head->first)
> +					head->is_empty = true;
>   				raw_spin_unlock(&head->lock);
>   				return node;
>   			}
>   			raw_spin_unlock(&head->lock);
>   		}
> +next_cpu:
>   		cpu = cpumask_next(cpu, cpu_possible_mask);
>   		if (cpu >= nr_cpu_ids)
>   			cpu = 0;
