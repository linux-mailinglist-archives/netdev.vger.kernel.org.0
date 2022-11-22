Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E556B63320C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 02:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiKVBQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 20:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiKVBQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 20:16:00 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE44B5F83;
        Mon, 21 Nov 2022 17:15:58 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NGRC36t1rz15Mlf;
        Tue, 22 Nov 2022 09:15:27 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 09:15:56 +0800
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     <xiangxia.m.yue@gmail.com>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20221121100521.56601-1-xiangxia.m.yue@gmail.com>
 <20221121100521.56601-2-xiangxia.m.yue@gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <7ed2f531-79a3-61fe-f1c2-b004b752c3f7@huawei.com>
Date:   Tue, 22 Nov 2022 09:15:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20221121100521.56601-2-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/21/2022 6:05 PM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The commit 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked"),
> try to fix deadlock, but in some case, the deadlock occurs:
>
> * CPUn in task context with K1, and taking lock.
> * CPUn interrupted by NMI context, with K2.
> * They are using the same bucket, but different map_locked.
It is possible when n_buckets is less than HASHTAB_MAP_LOCK_COUNT (e.g.,
n_bucket=4). If using hash & min(HASHTAB_MAP_LOCK_MASK, n_bucket - 1) as the
index of map_locked, I think the deadlock will be gone.
>
> 	    | Task
> 	    |
> 	+---v----+
> 	|  CPUn  |
> 	+---^----+
> 	    |
> 	    | NMI
>
> Anyway, the lockdep still warn:
> [   36.092222] ================================
> [   36.092230] WARNING: inconsistent lock state
> [   36.092234] 6.1.0-rc5+ #81 Tainted: G            E
> [   36.092236] --------------------------------
> [   36.092237] inconsistent {INITIAL USE} -> {IN-NMI} usage.
> [   36.092238] perf/1515 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [   36.092242] ffff888341acd1a0 (&htab->lockdep_key){....}-{2:2}, at: htab_lock_bucket+0x4d/0x58
> [   36.092253] {INITIAL USE} state was registered at:
> [   36.092255]   mark_usage+0x1d/0x11d
> [   36.092262]   __lock_acquire+0x3c9/0x6ed
> [   36.092266]   lock_acquire+0x23d/0x29a
> [   36.092270]   _raw_spin_lock_irqsave+0x43/0x7f
> [   36.092274]   htab_lock_bucket+0x4d/0x58
> [   36.092276]   htab_map_delete_elem+0x82/0xfb
> [   36.092278]   map_delete_elem+0x156/0x1ac
> [   36.092282]   __sys_bpf+0x138/0xb71
> [   36.092285]   __do_sys_bpf+0xd/0x15
> [   36.092288]   do_syscall_64+0x6d/0x84
> [   36.092291]   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   36.092295] irq event stamp: 120346
> [   36.092296] hardirqs last  enabled at (120345): [<ffffffff8180b97f>] _raw_spin_unlock_irq+0x24/0x39
> [   36.092299] hardirqs last disabled at (120346): [<ffffffff81169e85>] generic_exec_single+0x40/0xb9
> [   36.092303] softirqs last  enabled at (120268): [<ffffffff81c00347>] __do_softirq+0x347/0x387
> [   36.092307] softirqs last disabled at (120133): [<ffffffff810ba4f0>] __irq_exit_rcu+0x67/0xc6
> [   36.092311]
> [   36.092311] other info that might help us debug this:
> [   36.092312]  Possible unsafe locking scenario:
> [   36.092312]
> [   36.092313]        CPU0
> [   36.092313]        ----
> [   36.092314]   lock(&htab->lockdep_key);
> [   36.092315]   <Interrupt>
> [   36.092316]     lock(&htab->lockdep_key);
> [   36.092318]
> [   36.092318]  *** DEADLOCK ***
> [   36.092318]
> [   36.092318] 3 locks held by perf/1515:
> [   36.092320]  #0: ffff8881b9805cc0 (&cpuctx_mutex){+.+.}-{4:4}, at: perf_event_ctx_lock_nested+0x8e/0xba
> [   36.092327]  #1: ffff8881075ecc20 (&event->child_mutex){+.+.}-{4:4}, at: perf_event_for_each_child+0x35/0x76
> [   36.092332]  #2: ffff8881b9805c20 (&cpuctx_lock){-.-.}-{2:2}, at: perf_ctx_lock+0x12/0x27
> [   36.092339]
> [   36.092339] stack backtrace:
> [   36.092341] CPU: 0 PID: 1515 Comm: perf Tainted: G            E      6.1.0-rc5+ #81
> [   36.092344] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> [   36.092349] Call Trace:
> [   36.092351]  <NMI>
> [   36.092354]  dump_stack_lvl+0x57/0x81
> [   36.092359]  lock_acquire+0x1f4/0x29a
> [   36.092363]  ? handle_pmi_common+0x13f/0x1f0
> [   36.092366]  ? htab_lock_bucket+0x4d/0x58
> [   36.092371]  _raw_spin_lock_irqsave+0x43/0x7f
> [   36.092374]  ? htab_lock_bucket+0x4d/0x58
> [   36.092377]  htab_lock_bucket+0x4d/0x58
> [   36.092379]  htab_map_update_elem+0x11e/0x220
> [   36.092386]  bpf_prog_f3a535ca81a8128a_bpf_prog2+0x3e/0x42
> [   36.092392]  trace_call_bpf+0x177/0x215
> [   36.092398]  perf_trace_run_bpf_submit+0x52/0xaa
> [   36.092403]  ? x86_pmu_stop+0x97/0x97
> [   36.092407]  perf_trace_nmi_handler+0xb7/0xe0
> [   36.092415]  nmi_handle+0x116/0x254
> [   36.092418]  ? x86_pmu_stop+0x97/0x97
> [   36.092423]  default_do_nmi+0x3d/0xf6
> [   36.092428]  exc_nmi+0xa1/0x109
> [   36.092432]  end_repeat_nmi+0x16/0x67
> [   36.092436] RIP: 0010:wrmsrl+0xd/0x1b
> [   36.092441] Code: 04 01 00 00 c6 84 07 48 01 00 00 01 5b e9 46 15 80 00 5b c3 cc cc cc cc c3 cc cc cc cc 48 89 f2 89 f9 89 f0 48 c1 ea 20 0f 30 <66> 90 c3 cc cc cc cc 31 d2 e9 2f 04 49 00 0f 1f 44 00 00 40 0f6
> [   36.092443] RSP: 0018:ffffc900043dfc48 EFLAGS: 00000002
> [   36.092445] RAX: 000000000000000f RBX: ffff8881b96153e0 RCX: 000000000000038f
> [   36.092447] RDX: 0000000000000007 RSI: 000000070000000f RDI: 000000000000038f
> [   36.092449] RBP: 000000070000000f R08: ffffffffffffffff R09: ffff8881053bdaa8
> [   36.092451] R10: ffff8881b9805d40 R11: 0000000000000005 R12: ffff8881b9805c00
> [   36.092452] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881075ec970
> [   36.092460]  ? wrmsrl+0xd/0x1b
> [   36.092465]  ? wrmsrl+0xd/0x1b
> [   36.092469]  </NMI>
> [   36.092469]  <TASK>
> [   36.092470]  __intel_pmu_enable_all.constprop.0+0x7c/0xaf
> [   36.092475]  event_function+0xb6/0xd3
> [   36.092478]  ? cpu_to_node+0x1a/0x1a
> [   36.092482]  ? cpu_to_node+0x1a/0x1a
> [   36.092485]  remote_function+0x1e/0x4c
> [   36.092489]  generic_exec_single+0x48/0xb9
> [   36.092492]  ? __lock_acquire+0x666/0x6ed
> [   36.092497]  smp_call_function_single+0xbf/0x106
> [   36.092499]  ? cpu_to_node+0x1a/0x1a
> [   36.092504]  ? kvm_sched_clock_read+0x5/0x11
> [   36.092508]  ? __perf_event_task_sched_in+0x13d/0x13d
> [   36.092513]  cpu_function_call+0x47/0x69
> [   36.092516]  ? perf_event_update_time+0x52/0x52
> [   36.092519]  event_function_call+0x89/0x117
> [   36.092521]  ? __perf_event_task_sched_in+0x13d/0x13d
> [   36.092526]  ? _perf_event_disable+0x4a/0x4a
> [   36.092528]  perf_event_for_each_child+0x3d/0x76
> [   36.092532]  ? _perf_event_disable+0x4a/0x4a
> [   36.092533]  _perf_ioctl+0x564/0x590
> [   36.092537]  ? __lock_release+0xd5/0x1b0
> [   36.092543]  ? perf_event_ctx_lock_nested+0x8e/0xba
> [   36.092547]  perf_ioctl+0x42/0x5f
> [   36.092551]  vfs_ioctl+0x1e/0x2f
> [   36.092554]  __do_sys_ioctl+0x66/0x89
> [   36.092559]  do_syscall_64+0x6d/0x84
> [   36.092563]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   36.092566] RIP: 0033:0x7fe7110f362b
> [   36.092569] Code: 0f 1e fa 48 8b 05 5d b8 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d b8 2c 00 f7 d8 64 89 018
> [   36.092570] RSP: 002b:00007ffebb8e4b08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   36.092573] RAX: ffffffffffffffda RBX: 0000000000002400 RCX: 00007fe7110f362b
> [   36.092575] RDX: 0000000000000000 RSI: 0000000000002400 RDI: 0000000000000013
> [   36.092576] RBP: 00007ffebb8e4b40 R08: 0000000000000001 R09: 000055c1db4a5b40
> [   36.092577] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [   36.092579] R13: 000055c1db3b2a30 R14: 0000000000000000 R15: 0000000000000000
> [   36.092586]  </TASK>
>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Song Liu <song@kernel.org>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  kernel/bpf/hashtab.c | 96 +++++++++++++++++---------------------------
>  1 file changed, 36 insertions(+), 60 deletions(-)
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 22855d6ff6d3..429acd97c869 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -80,9 +80,6 @@ struct bucket {
>  	raw_spinlock_t raw_lock;
>  };
>  
> -#define HASHTAB_MAP_LOCK_COUNT 8
> -#define HASHTAB_MAP_LOCK_MASK (HASHTAB_MAP_LOCK_COUNT - 1)
> -
>  struct bpf_htab {
>  	struct bpf_map map;
>  	struct bpf_mem_alloc ma;
> @@ -104,7 +101,6 @@ struct bpf_htab {
>  	u32 elem_size;	/* size of each element in bytes */
>  	u32 hashrnd;
>  	struct lock_class_key lockdep_key;
> -	int __percpu *map_locked[HASHTAB_MAP_LOCK_COUNT];
>  };
>  
>  /* each htab element is struct htab_elem + key + value */
> @@ -146,35 +142,26 @@ static void htab_init_buckets(struct bpf_htab *htab)
>  	}
>  }
>  
> -static inline int htab_lock_bucket(const struct bpf_htab *htab,
> -				   struct bucket *b, u32 hash,
> +static inline int htab_lock_bucket(struct bucket *b,
>  				   unsigned long *pflags)
>  {
>  	unsigned long flags;
>  
> -	hash = hash & HASHTAB_MAP_LOCK_MASK;
> -
> -	preempt_disable();
> -	if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
> -		__this_cpu_dec(*(htab->map_locked[hash]));
> -		preempt_enable();
> -		return -EBUSY;
> +	if (in_nmi()) {
> +		if (!raw_spin_trylock_irqsave(&b->raw_lock, flags))
> +			return -EBUSY;
> +	} else {
> +		raw_spin_lock_irqsave(&b->raw_lock, flags);
>  	}
>  
> -	raw_spin_lock_irqsave(&b->raw_lock, flags);
>  	*pflags = flags;
> -
>  	return 0;
>  }
map_locked is also used to prevent the re-entrance of htab_lock_bucket() on the
same CPU, so only check in_nmi() is not enough.
>  
> -static inline void htab_unlock_bucket(const struct bpf_htab *htab,
> -				      struct bucket *b, u32 hash,
> +static inline void htab_unlock_bucket(struct bucket *b,
>  				      unsigned long flags)
>  {
> -	hash = hash & HASHTAB_MAP_LOCK_MASK;
>  	raw_spin_unlock_irqrestore(&b->raw_lock, flags);
> -	__this_cpu_dec(*(htab->map_locked[hash]));
> -	preempt_enable();
>  }
>  
>  static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node);
> @@ -467,7 +454,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>  	bool percpu_lru = (attr->map_flags & BPF_F_NO_COMMON_LRU);
>  	bool prealloc = !(attr->map_flags & BPF_F_NO_PREALLOC);
>  	struct bpf_htab *htab;
> -	int err, i;
> +	int err;
>  
>  	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE);
>  	if (!htab)
> @@ -513,15 +500,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>  	if (!htab->buckets)
>  		goto free_htab;
>  
> -	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++) {
> -		htab->map_locked[i] = bpf_map_alloc_percpu(&htab->map,
> -							   sizeof(int),
> -							   sizeof(int),
> -							   GFP_USER);
> -		if (!htab->map_locked[i])
> -			goto free_map_locked;
> -	}
> -
>  	if (htab->map.map_flags & BPF_F_ZERO_SEED)
>  		htab->hashrnd = 0;
>  	else
> @@ -549,13 +527,13 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>  	if (htab->use_percpu_counter) {
>  		err = percpu_counter_init(&htab->pcount, 0, GFP_KERNEL);
>  		if (err)
> -			goto free_map_locked;
> +			goto free_buckets;
>  	}
>  
>  	if (prealloc) {
>  		err = prealloc_init(htab);
>  		if (err)
> -			goto free_map_locked;
> +			goto free_buckets;
>  
>  		if (!percpu && !lru) {
>  			/* lru itself can remove the least used element, so
> @@ -568,12 +546,12 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>  	} else {
>  		err = bpf_mem_alloc_init(&htab->ma, htab->elem_size, false);
>  		if (err)
> -			goto free_map_locked;
> +			goto free_buckets;
>  		if (percpu) {
>  			err = bpf_mem_alloc_init(&htab->pcpu_ma,
>  						 round_up(htab->map.value_size, 8), true);
>  			if (err)
> -				goto free_map_locked;
> +				goto free_buckets;
>  		}
>  	}
>  
> @@ -581,11 +559,10 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>  
>  free_prealloc:
>  	prealloc_destroy(htab);
> -free_map_locked:
> +free_buckets:
>  	if (htab->use_percpu_counter)
>  		percpu_counter_destroy(&htab->pcount);
> -	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
> -		free_percpu(htab->map_locked[i]);
> +
>  	bpf_map_area_free(htab->buckets);
>  	bpf_mem_alloc_destroy(&htab->pcpu_ma);
>  	bpf_mem_alloc_destroy(&htab->ma);
> @@ -782,7 +759,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
>  	b = __select_bucket(htab, tgt_l->hash);
>  	head = &b->head;
>  
> -	ret = htab_lock_bucket(htab, b, tgt_l->hash, &flags);
> +	ret = htab_lock_bucket(b, &flags);
>  	if (ret)
>  		return false;
>  
> @@ -793,7 +770,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
>  			break;
>  		}
>  
> -	htab_unlock_bucket(htab, b, tgt_l->hash, flags);
> +	htab_unlock_bucket(b, flags);
>  
>  	return l == tgt_l;
>  }
> @@ -1107,7 +1084,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
>  		 */
>  	}
>  
> -	ret = htab_lock_bucket(htab, b, hash, &flags);
> +	ret = htab_lock_bucket(b, &flags);
>  	if (ret)
>  		return ret;
>  
> @@ -1152,7 +1129,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
>  	}
>  	ret = 0;
>  err:
> -	htab_unlock_bucket(htab, b, hash, flags);
> +	htab_unlock_bucket(b, flags);
>  	return ret;
>  }
>  
> @@ -1198,7 +1175,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
>  	copy_map_value(&htab->map,
>  		       l_new->key + round_up(map->key_size, 8), value);
>  
> -	ret = htab_lock_bucket(htab, b, hash, &flags);
> +	ret = htab_lock_bucket(b, &flags);
>  	if (ret)
>  		return ret;
>  
> @@ -1219,7 +1196,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
>  	ret = 0;
>  
>  err:
> -	htab_unlock_bucket(htab, b, hash, flags);
> +	htab_unlock_bucket(b, flags);
>  
>  	if (ret)
>  		htab_lru_push_free(htab, l_new);
> @@ -1255,7 +1232,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
>  	b = __select_bucket(htab, hash);
>  	head = &b->head;
>  
> -	ret = htab_lock_bucket(htab, b, hash, &flags);
> +	ret = htab_lock_bucket(b, &flags);
>  	if (ret)
>  		return ret;
>  
> @@ -1280,7 +1257,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
>  	}
>  	ret = 0;
>  err:
> -	htab_unlock_bucket(htab, b, hash, flags);
> +	htab_unlock_bucket(b, flags);
>  	return ret;
>  }
>  
> @@ -1321,7 +1298,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
>  			return -ENOMEM;
>  	}
>  
> -	ret = htab_lock_bucket(htab, b, hash, &flags);
> +	ret = htab_lock_bucket(b, &flags);
>  	if (ret)
>  		return ret;
>  
> @@ -1345,7 +1322,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
>  	}
>  	ret = 0;
>  err:
> -	htab_unlock_bucket(htab, b, hash, flags);
> +	htab_unlock_bucket(b, flags);
>  	if (l_new)
>  		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
>  	return ret;
> @@ -1384,7 +1361,7 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
>  	b = __select_bucket(htab, hash);
>  	head = &b->head;
>  
> -	ret = htab_lock_bucket(htab, b, hash, &flags);
> +	ret = htab_lock_bucket(b, &flags);
>  	if (ret)
>  		return ret;
>  
> @@ -1397,7 +1374,7 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
>  		ret = -ENOENT;
>  	}
>  
> -	htab_unlock_bucket(htab, b, hash, flags);
> +	htab_unlock_bucket(b, flags);
>  	return ret;
>  }
>  
> @@ -1420,7 +1397,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
>  	b = __select_bucket(htab, hash);
>  	head = &b->head;
>  
> -	ret = htab_lock_bucket(htab, b, hash, &flags);
> +	ret = htab_lock_bucket(b, &flags);
>  	if (ret)
>  		return ret;
>  
> @@ -1431,7 +1408,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
>  	else
>  		ret = -ENOENT;
>  
> -	htab_unlock_bucket(htab, b, hash, flags);
> +	htab_unlock_bucket(b, flags);
>  	if (l)
>  		htab_lru_push_free(htab, l);
>  	return ret;
> @@ -1494,7 +1471,6 @@ static void htab_map_free_timers(struct bpf_map *map)
>  static void htab_map_free(struct bpf_map *map)
>  {
>  	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> -	int i;
>  
>  	/* bpf_free_used_maps() or close(map_fd) will trigger this map_free callback.
>  	 * bpf_free_used_maps() is called after bpf prog is no longer executing.
> @@ -1517,10 +1493,10 @@ static void htab_map_free(struct bpf_map *map)
>  	bpf_map_area_free(htab->buckets);
>  	bpf_mem_alloc_destroy(&htab->pcpu_ma);
>  	bpf_mem_alloc_destroy(&htab->ma);
> +
>  	if (htab->use_percpu_counter)
>  		percpu_counter_destroy(&htab->pcount);
> -	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
> -		free_percpu(htab->map_locked[i]);
> +
>  	lockdep_unregister_key(&htab->lockdep_key);
>  	bpf_map_area_free(htab);
>  }
> @@ -1564,7 +1540,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
>  	b = __select_bucket(htab, hash);
>  	head = &b->head;
>  
> -	ret = htab_lock_bucket(htab, b, hash, &bflags);
> +	ret = htab_lock_bucket(b, &bflags);
>  	if (ret)
>  		return ret;
>  
> @@ -1602,7 +1578,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
>  			free_htab_elem(htab, l);
>  	}
>  
> -	htab_unlock_bucket(htab, b, hash, bflags);
> +	htab_unlock_bucket(b, bflags);
>  
>  	if (is_lru_map && l)
>  		htab_lru_push_free(htab, l);
> @@ -1720,7 +1696,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>  	head = &b->head;
>  	/* do not grab the lock unless need it (bucket_cnt > 0). */
>  	if (locked) {
> -		ret = htab_lock_bucket(htab, b, batch, &flags);
> +		ret = htab_lock_bucket(b, &flags);
>  		if (ret) {
>  			rcu_read_unlock();
>  			bpf_enable_instrumentation();
> @@ -1743,7 +1719,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>  		/* Note that since bucket_cnt > 0 here, it is implicit
>  		 * that the locked was grabbed, so release it.
>  		 */
> -		htab_unlock_bucket(htab, b, batch, flags);
> +		htab_unlock_bucket(b, flags);
>  		rcu_read_unlock();
>  		bpf_enable_instrumentation();
>  		goto after_loop;
> @@ -1754,7 +1730,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>  		/* Note that since bucket_cnt > 0 here, it is implicit
>  		 * that the locked was grabbed, so release it.
>  		 */
> -		htab_unlock_bucket(htab, b, batch, flags);
> +		htab_unlock_bucket(b, flags);
>  		rcu_read_unlock();
>  		bpf_enable_instrumentation();
>  		kvfree(keys);
> @@ -1815,7 +1791,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>  		dst_val += value_size;
>  	}
>  
> -	htab_unlock_bucket(htab, b, batch, flags);
> +	htab_unlock_bucket(b, flags);
>  	locked = false;
>  
>  	while (node_to_free) {

