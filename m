Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B6D3A3B07
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 06:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhFKE2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 00:28:09 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:51972 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhFKE2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 00:28:07 -0400
Received: by mail-pj1-f41.google.com with SMTP id k5so4968351pjj.1;
        Thu, 10 Jun 2021 21:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k+GM+G6IQUzrqvhir3VniRHzwUN1OyYpKvWQ2hS4ObE=;
        b=qfDB9jzwhRwVlrEmoGFcBtZYrgHpwe9PAodMqA+L3zMvYop9kCR5vNxqXJO0vFEY/h
         BG3K6viiCsh2XkQQpF2NRUXW26jCmo8y/++uu1nZHKZkocM354QTV2QfJfNsHALvWgxu
         SRTmpdWc6sgWGTV9s8bTdiNx4R2MiAa76pjsccPl2OJG2HEfmEcqufcR3G/BzHzNNszs
         RGtcVQ3xl4fwyQXp2E52tCF9oFvkhnPHe5vMIGeqV8tRRTeeVLphYQ4OEByXQEyt++da
         Xu4NFnTVLsQMXqleMDS2JpsL2YYTYK3Qt/hp+N1W1Y4FaiYERUGuoVomvCCAMskbY1d/
         sg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k+GM+G6IQUzrqvhir3VniRHzwUN1OyYpKvWQ2hS4ObE=;
        b=k4CxnM1/hb9oxI5S0TI8H/uzk+J/5LMj2GoAkF6qkEAEj7VkNDea7BcxHNFoQHADmv
         X1ERCH+4iNpf+7dTMHcNfX44fFF7xe3mXu+Ikthfb+0YvRmTDugTwwCbdo0xuz8KfjPr
         C6JA5RKqhE43C7EXkwty2Qs9w+LWK3pgMrBHwUIuorVsVreAp8ZP6RW8+nkbo854EvCI
         BSWIN8xF6cERE5+CJEUfUUqE3woKTadBGAQPadAHSx2EPvUmhSkd5TZnCD5uxTe8mMxJ
         sElHc46dT7Z2Z0L9mlsHCsJcMtfsuIZHvSszQWD0zukJhWi9Vn5Rm43oSDHWAzj7WoxQ
         OnBQ==
X-Gm-Message-State: AOAM531wLijqrysZM/J2Me3tFoNOl1j/t4nenN+ePqFE2gk7EtbQOLkq
        VR/p79r4QBjIvGOpvEJwcDA=
X-Google-Smtp-Source: ABdhPJyVCpXco3bgzUzs0YndulUuh9S8J23urCdBFwCl2BUTF2Q4nJU6k7JxbAqxapz68iKiY40Xww==
X-Received: by 2002:a17:90a:ab96:: with SMTP id n22mr2439750pjq.92.1623385487772;
        Thu, 10 Jun 2021 21:24:47 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:7360])
        by smtp.gmail.com with ESMTPSA id p11sm3942234pgn.65.2021.06.10.21.24.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 21:24:47 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
Date:   Thu, 10 Jun 2021 21:24:40 -0700
Message-Id: <20210611042442.65444-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
in hash/array/lru maps as regular field and helpers to operate on it:

// Initialize the timer to call 'callback_fn' static function
// First 4 bits of 'flags' specify clockid.
// Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags);

// Start the timer and set its expiration 'nsec' nanoseconds from the current time.
long bpf_timer_start(struct bpf_timer *timer, u64 nsec);

// Cancel the timer and wait for callback_fn to finish if it was running.
long bpf_timer_cancel(struct bpf_timer *timer);

Here is how BPF program might look like:
struct map_elem {
    int counter;
    struct bpf_timer timer;
};

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 1000);
    __type(key, int);
    __type(value, struct map_elem);
} hmap SEC(".maps");

static int timer_cb(void *map, int *key, struct map_elem *val);
/* val points to particular map element that contains bpf_timer. */

SEC("fentry/bpf_fentry_test1")
int BPF_PROG(test1, int a)
{
    struct map_elem *val;
    int key = 0;

    val = bpf_map_lookup_elem(&hmap, &key);
    if (val) {
        bpf_timer_init(&val->timer, timer_cb, CLOCK_REALTIME);
        bpf_timer_start(&val->timer, 1000 /* call timer_cb2 in 1 usec */);
    }
}

This patch adds helper implementations that rely on hrtimers
to call bpf functions as timers expire.
The following patch adds necessary safety checks.

Only programs with CAP_BPF are allowed to use bpf_timer.

The amount of timers used by the program is constrained by
the memcg recorded at map creation time.

The bpf_timer_init() helper is receiving hidden 'map' and 'prog' arguments
supplied by the verifier. The prog pointer is needed to do refcnting of bpf
program to make sure that program doesn't get freed while timer is armed.

The bpf_map_delete_elem() and bpf_map_update_elem() operations cancel
and free the timer if given map element had it allocated.
"bpftool map update" command can be used to cancel timers.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h            |   2 +
 include/uapi/linux/bpf.h       |  40 ++++++
 kernel/bpf/helpers.c           | 227 +++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          | 109 ++++++++++++++++
 kernel/trace/bpf_trace.c       |   2 +-
 scripts/bpf_doc.py             |   2 +
 tools/include/uapi/linux/bpf.h |  40 ++++++
 7 files changed, 421 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 86dec5001ae2..3816b6bae6d3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -221,6 +221,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 }
 void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 			   bool lock_src);
+void bpf_timer_cancel_and_free(void *timer);
 int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size);
 
 struct bpf_offload_dev;
@@ -314,6 +315,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_FUNC,	/* pointer to a bpf program function */
 	ARG_PTR_TO_STACK_OR_NULL,	/* pointer to stack or NULL */
 	ARG_PTR_TO_CONST_STR,	/* pointer to a null terminated read-only string */
+	ARG_PTR_TO_TIMER,	/* pointer to bpf_timer */
 	__BPF_ARG_TYPE_MAX,
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2c1ba70abbf1..d25bbcdad8e6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4778,6 +4778,38 @@ union bpf_attr {
  * 		Execute close syscall for given FD.
  * 	Return
  * 		A syscall result.
+ *
+ * long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags)
+ *	Description
+ *		Initialize the timer to call *callback_fn* static function.
+ *		First 4 bits of *flags* specify clockid. Only CLOCK_MONOTONIC,
+ *		CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
+ *		All other bits of *flags* are reserved.
+ *	Return
+ *		0 on success.
+ *		**-EBUSY** if *timer* is already initialized.
+ *		**-EINVAL** if invalid *flags* are passed.
+ *
+ * long bpf_timer_start(struct bpf_timer *timer, u64 nsecs)
+ *	Description
+ *		Start the timer and set its expiration N nanoseconds from the
+ *		current time. The timer callback_fn will be invoked in soft irq
+ *		context on some cpu and will not repeat unless another
+ *		bpf_timer_start() is made. In such case the next invocation can
+ *		migrate to a different cpu.
+ *	Return
+ *		0 on success.
+ *		**-EINVAL** if *timer* was not initialized with bpf_timer_init() earlier.
+ *
+ * long bpf_timer_cancel(struct bpf_timer *timer)
+ *	Description
+ *		Cancel the timer and wait for callback_fn to finish if it was running.
+ *	Return
+ *		0 if the timer was not active.
+ *		1 if the timer was active.
+ *		**-EINVAL** if *timer* was not initialized with bpf_timer_init() earlier.
+ *		**-EDEADLK** if callback_fn tried to call bpf_timer_cancel() on its own timer
+ *		which would have led to a deadlock otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4949,6 +4981,9 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(timer_init),			\
+	FN(timer_start),		\
+	FN(timer_cancel),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -6061,6 +6096,11 @@ struct bpf_spin_lock {
 	__u32	val;
 };
 
+struct bpf_timer {
+	__u64 :64;
+	__u64 :64;
+};
+
 struct bpf_sysctl {
 	__u32	write;		/* Sysctl is being read (= 0) or written (= 1).
 				 * Allows 1,2,4-byte read, but no write.
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 544773970dbc..3a693d451ca3 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -985,6 +985,227 @@ const struct bpf_func_proto bpf_snprintf_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+struct bpf_hrtimer {
+	struct hrtimer timer;
+	struct bpf_map *map;
+	struct bpf_prog *prog;
+	void *callback_fn;
+	void *value;
+};
+
+/* the actual struct hidden inside uapi struct bpf_timer */
+struct bpf_timer_kern {
+	struct bpf_hrtimer *timer;
+	struct bpf_spin_lock lock;
+};
+
+static DEFINE_PER_CPU(struct bpf_hrtimer *, hrtimer_running);
+
+static enum hrtimer_restart bpf_timer_cb(struct hrtimer *timer)
+{
+	struct bpf_hrtimer *t = container_of(timer, struct bpf_hrtimer, timer);
+	struct bpf_prog *prog = t->prog;
+	struct bpf_map *map = t->map;
+	void *key;
+	u32 idx;
+	int ret;
+
+	/* bpf_timer_cb() runs in hrtimer_run_softirq. It doesn't migrate and
+	 * cannot be preempted by another bpf_timer_cb() on the same cpu.
+	 * Remember the timer this callback is servicing to prevent
+	 * deadlock if callback_fn() calls bpf_timer_cancel() on the same timer.
+	 */
+	this_cpu_write(hrtimer_running, t);
+	if (map->map_type == BPF_MAP_TYPE_ARRAY) {
+		struct bpf_array *array = container_of(map, struct bpf_array, map);
+
+		/* compute the key */
+		idx = ((char *)t->value - array->value) / array->elem_size;
+		key = &idx;
+	} else { /* hash or lru */
+		key = t->value - round_up(map->key_size, 8);
+	}
+
+	ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
+					    (u64)(long)key,
+					    (u64)(long)t->value, 0, 0);
+	WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */
+
+	/* The bpf function finished executed. Drop the prog refcnt.
+	 * It could reach zero here and trigger free of bpf_prog
+	 * and subsequent free of the maps that were holding timers.
+	 * If callback_fn called bpf_timer_start on this timer
+	 * the prog refcnt will be > 0.
+	 *
+	 * If callback_fn deleted map element the 't' could have been freed,
+	 * hence t->prog deref is done earlier.
+	 */
+	bpf_prog_put(prog);
+	this_cpu_write(hrtimer_running, NULL);
+	return HRTIMER_NORESTART;
+}
+
+BPF_CALL_5(bpf_timer_init, struct bpf_timer_kern *, timer, void *, cb, int, flags,
+	   struct bpf_map *, map, struct bpf_prog *, prog)
+{
+	clockid_t clockid = flags & (MAX_CLOCKS - 1);
+	struct bpf_hrtimer *t;
+	int ret = 0;
+
+	BUILD_BUG_ON(MAX_CLOCKS != 16);
+	if (flags >= MAX_CLOCKS ||
+	    /* similar to timerfd except _ALARM variants are not supported */
+            (clockid != CLOCK_MONOTONIC &&
+             clockid != CLOCK_REALTIME &&
+             clockid != CLOCK_BOOTTIME))
+		return -EINVAL;
+	____bpf_spin_lock(&timer->lock);
+	t = timer->timer;
+	if (t) {
+		ret = -EBUSY;
+		goto out;
+	}
+	/* allocate hrtimer via map_kmalloc to use memcg accounting */
+	t = bpf_map_kmalloc_node(map, sizeof(*t), GFP_ATOMIC, NUMA_NO_NODE);
+	if (!t) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	t->callback_fn = cb;
+	t->value = (void *)timer /* - offset of bpf_timer inside elem */;
+	t->map = map;
+	t->prog = prog;
+	hrtimer_init(&t->timer, clockid, HRTIMER_MODE_REL_SOFT);
+	t->timer.function = bpf_timer_cb;
+	timer->timer = t;
+out:
+	____bpf_spin_unlock(&timer->lock);
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_timer_init_proto = {
+	.func		= bpf_timer_init,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_TIMER,
+	.arg2_type	= ARG_PTR_TO_FUNC,
+	.arg3_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_2(bpf_timer_start, struct bpf_timer_kern *, timer, u64, nsecs)
+{
+	struct bpf_hrtimer *t;
+	int ret = 0;
+
+	____bpf_spin_lock(&timer->lock);
+	t = timer->timer;
+	if (!t) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (!hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer))
+		/* If the timer wasn't active or callback already executing
+		 * bump the prog refcnt to keep it alive until
+		 * callback is invoked (again).
+		 */
+		bpf_prog_inc(t->prog);
+	hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);
+out:
+	____bpf_spin_unlock(&timer->lock);
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_timer_start_proto = {
+	.func		= bpf_timer_start,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_TIMER,
+	.arg2_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
+{
+	struct bpf_hrtimer *t;
+	int ret = 0;
+
+	____bpf_spin_lock(&timer->lock);
+	t = timer->timer;
+	if (!t) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (this_cpu_read(hrtimer_running) == t) {
+		/* If bpf callback_fn is trying to bpf_timer_cancel()
+		 * its own timer the hrtimer_cancel() will deadlock
+		 * since it waits for callback_fn to finish
+		 */
+		ret = -EDEADLK;
+		goto out;
+	}
+	/* Cancel the timer and wait for associated callback to finish
+	 * if it was running.
+	 */
+	if (hrtimer_cancel(&t->timer) == 1) {
+		/* If the timer was active then drop the prog refcnt,
+		 * since callback will not be invoked.
+		 */
+		bpf_prog_put(t->prog);
+		ret = 1;
+	}
+out:
+	____bpf_spin_unlock(&timer->lock);
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_timer_cancel_proto = {
+	.func		= bpf_timer_cancel,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_TIMER,
+};
+
+/* This function is called by delete_element in htab and lru maps
+ * and by map_free for array, lru, htab maps.
+ */
+void bpf_timer_cancel_and_free(void *val)
+{
+	struct bpf_timer_kern *timer = val;
+	struct bpf_hrtimer *t;
+
+	____bpf_spin_lock(&timer->lock);
+	t = timer->timer;
+	if (!t)
+		goto out;
+	/* Cancel the timer and wait for callback to complete if it was
+	 * running. Only individual delete_element in htab or lru maps can
+	 * return 1 from hrtimer_cancel.
+	 * The whole map is destroyed when its refcnt reaches zero.
+	 * That happens after bpf prog refcnt reaches zero.
+	 * bpf prog refcnt will not reach zero until all timers are executed.
+	 * So when maps are destroyed hrtimer_cancel will surely return 0.
+	 * In such case t->prog is a pointer to freed memory.
+	 *
+	 * When htab or lru is deleting individual element check that
+	 * bpf_map_delete_elem() isn't trying to delete elem with running timer.
+	 * In such case don't call hrtimer_cancel() (since it will deadlock)
+	 * and don't call hrtimer_try_to_cancel() (since it will just return -1).
+	 * Instead free the timer and set timer->timer = NULL.
+	 * The subsequent bpf_timer_start/cancel() helpers won't be able to use it.
+	 * In preallocated maps it's safe to do timer->timer = NULL.
+	 * The memory could be reused for another element while current timer
+	 * callback can still do bpf_timer_init() on it.
+	 * In non-preallocated maps timer->timer = NULL will happen after
+	 * callback completes, since prog execution is an RCU critical section.
+	 */
+	if (this_cpu_read(hrtimer_running) != t &&
+	    hrtimer_cancel(&t->timer) == 1)
+		bpf_prog_put(t->prog);
+	kfree(t);
+	timer->timer = NULL;
+out:
+	____bpf_spin_unlock(&timer->lock);
+}
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
@@ -1051,6 +1272,12 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_per_cpu_ptr_proto;
 	case BPF_FUNC_this_cpu_ptr:
 		return &bpf_this_cpu_ptr_proto;
+	case BPF_FUNC_timer_init:
+		return &bpf_timer_init_proto;
+	case BPF_FUNC_timer_start:
+		return &bpf_timer_start_proto;
+	case BPF_FUNC_timer_cancel:
+		return &bpf_timer_cancel_proto;
 	default:
 		break;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1de4b8c6ee42..44ec9760b562 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4656,6 +4656,35 @@ static int process_spin_lock(struct bpf_verifier_env *env, int regno,
 	return 0;
 }
 
+static int process_timer_func(struct bpf_verifier_env *env, int regno,
+			      struct bpf_call_arg_meta *meta)
+{
+	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	bool is_const = tnum_is_const(reg->var_off);
+	struct bpf_map *map = reg->map_ptr;
+	u64 val = reg->var_off.value;
+
+	if (!is_const) {
+		verbose(env,
+			"R%d doesn't have constant offset. bpf_timer has to be at the constant offset\n",
+			regno);
+		return -EINVAL;
+	}
+	if (!map->btf) {
+		verbose(env, "map '%s' has to have BTF in order to use bpf_timer\n",
+			map->name);
+		return -EINVAL;
+	}
+	if (val) {
+		/* This restriction will be removed in the next patch */
+		verbose(env, "bpf_timer field can only be first in the map value element\n");
+		return -EINVAL;
+	}
+	WARN_ON(meta->map_ptr);
+	meta->map_ptr = map;
+	return 0;
+}
+
 static bool arg_type_is_mem_ptr(enum bpf_arg_type type)
 {
 	return type == ARG_PTR_TO_MEM ||
@@ -4788,6 +4817,7 @@ static const struct bpf_reg_types percpu_btf_ptr_types = { .types = { PTR_TO_PER
 static const struct bpf_reg_types func_ptr_types = { .types = { PTR_TO_FUNC } };
 static const struct bpf_reg_types stack_ptr_types = { .types = { PTR_TO_STACK } };
 static const struct bpf_reg_types const_str_ptr_types = { .types = { PTR_TO_MAP_VALUE } };
+static const struct bpf_reg_types timer_types = { .types = { PTR_TO_MAP_VALUE } };
 
 static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_MAP_KEY]		= &map_key_value_types,
@@ -4819,6 +4849,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_FUNC]		= &func_ptr_types,
 	[ARG_PTR_TO_STACK_OR_NULL]	= &stack_ptr_types,
 	[ARG_PTR_TO_CONST_STR]		= &const_str_ptr_types,
+	[ARG_PTR_TO_TIMER]		= &timer_types,
 };
 
 static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
@@ -5000,6 +5031,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			verbose(env, "verifier internal error\n");
 			return -EFAULT;
 		}
+	} else if (arg_type == ARG_PTR_TO_TIMER) {
+		if (process_timer_func(env, regno, meta))
+			return -EACCES;
 	} else if (arg_type == ARG_PTR_TO_FUNC) {
 		meta->subprogno = reg->subprogno;
 	} else if (arg_type_is_mem_ptr(arg_type)) {
@@ -5742,6 +5776,43 @@ static int set_map_elem_callback_state(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static int set_timer_init_callback_state(struct bpf_verifier_env *env,
+					 struct bpf_func_state *caller,
+					 struct bpf_func_state *callee,
+					 int insn_idx)
+{
+	struct bpf_insn_aux_data *insn_aux = &env->insn_aux_data[insn_idx];
+	struct bpf_map *map_ptr;
+
+	if (bpf_map_ptr_poisoned(insn_aux)) {
+		verbose(env, "bpf_timer_init abusing map_ptr\n");
+		return -EINVAL;
+	}
+
+	map_ptr = BPF_MAP_PTR(insn_aux->map_ptr_state);
+
+	/* bpf_timer_init(struct bpf_timer *timer, void *callback_fn, u64 flags);
+	 * callback_fn(struct bpf_map *map, void *key, void *value);
+	 */
+	callee->regs[BPF_REG_1].type = CONST_PTR_TO_MAP;
+	__mark_reg_known_zero(&callee->regs[BPF_REG_1]);
+	callee->regs[BPF_REG_1].map_ptr = map_ptr;
+
+	callee->regs[BPF_REG_2].type = PTR_TO_MAP_KEY;
+	__mark_reg_known_zero(&callee->regs[BPF_REG_2]);
+	callee->regs[BPF_REG_2].map_ptr = map_ptr;
+
+	callee->regs[BPF_REG_3].type = PTR_TO_MAP_VALUE;
+	__mark_reg_known_zero(&callee->regs[BPF_REG_3]);
+	callee->regs[BPF_REG_3].map_ptr = map_ptr;
+
+	/* unused */
+	__mark_reg_not_init(env, &callee->regs[BPF_REG_4]);
+	__mark_reg_not_init(env, &callee->regs[BPF_REG_5]);
+	callee->in_callback_fn = true;
+	return 0;
+}
+
 static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 {
 	struct bpf_verifier_state *state = env->cur_state;
@@ -5837,6 +5908,7 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	    func_id != BPF_FUNC_map_pop_elem &&
 	    func_id != BPF_FUNC_map_peek_elem &&
 	    func_id != BPF_FUNC_for_each_map_elem &&
+	    func_id != BPF_FUNC_timer_init &&
 	    func_id != BPF_FUNC_redirect_map)
 		return 0;
 
@@ -6069,6 +6141,13 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			return -EINVAL;
 	}
 
+	if (func_id == BPF_FUNC_timer_init) {
+		err = __check_func_call(env, insn, insn_idx_p, meta.subprogno,
+					set_timer_init_callback_state);
+		if (err < 0)
+			return -EINVAL;
+	}
+
 	if (func_id == BPF_FUNC_snprintf) {
 		err = check_bpf_snprintf_call(env, regs);
 		if (err < 0)
@@ -12526,6 +12605,36 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			insn      = new_prog->insnsi + i + delta;
 			continue;
 		}
+		if (insn->imm == BPF_FUNC_timer_init) {
+			aux = &env->insn_aux_data[i + delta];
+			if (bpf_map_ptr_poisoned(aux)) {
+				verbose(env, "bpf_timer_init abusing map_ptr\n");
+				return -EINVAL;
+			}
+			map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
+			{
+				struct bpf_insn ld_addrs[4] = {
+					BPF_LD_IMM64(BPF_REG_4, (long)map_ptr),
+					BPF_LD_IMM64(BPF_REG_5, (long)prog),
+				};
+
+				insn_buf[0] = ld_addrs[0];
+				insn_buf[1] = ld_addrs[1];
+				insn_buf[2] = ld_addrs[2];
+				insn_buf[3] = ld_addrs[3];
+			}
+			insn_buf[4] = *insn;
+			cnt = 5;
+
+			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += cnt - 1;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			goto patch_call_imm;
+		}
 
 		/* BPF_EMIT_CALL() assumptions in some of the map_gen_lookup
 		 * and other inlining handlers are currently limited to 64 bit
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d2d7cf6cfe83..453a46c2d732 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1065,7 +1065,7 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_snprintf:
 		return &bpf_snprintf_proto;
 	default:
-		return NULL;
+		return bpf_base_func_proto(func_id);
 	}
 }
 
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 2d94025b38e9..00ac7b79cddb 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -547,6 +547,7 @@ COMMANDS
             'struct inode',
             'struct socket',
             'struct file',
+            'struct bpf_timer',
     ]
     known_types = {
             '...',
@@ -594,6 +595,7 @@ COMMANDS
             'struct inode',
             'struct socket',
             'struct file',
+            'struct bpf_timer',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2c1ba70abbf1..d25bbcdad8e6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4778,6 +4778,38 @@ union bpf_attr {
  * 		Execute close syscall for given FD.
  * 	Return
  * 		A syscall result.
+ *
+ * long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags)
+ *	Description
+ *		Initialize the timer to call *callback_fn* static function.
+ *		First 4 bits of *flags* specify clockid. Only CLOCK_MONOTONIC,
+ *		CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
+ *		All other bits of *flags* are reserved.
+ *	Return
+ *		0 on success.
+ *		**-EBUSY** if *timer* is already initialized.
+ *		**-EINVAL** if invalid *flags* are passed.
+ *
+ * long bpf_timer_start(struct bpf_timer *timer, u64 nsecs)
+ *	Description
+ *		Start the timer and set its expiration N nanoseconds from the
+ *		current time. The timer callback_fn will be invoked in soft irq
+ *		context on some cpu and will not repeat unless another
+ *		bpf_timer_start() is made. In such case the next invocation can
+ *		migrate to a different cpu.
+ *	Return
+ *		0 on success.
+ *		**-EINVAL** if *timer* was not initialized with bpf_timer_init() earlier.
+ *
+ * long bpf_timer_cancel(struct bpf_timer *timer)
+ *	Description
+ *		Cancel the timer and wait for callback_fn to finish if it was running.
+ *	Return
+ *		0 if the timer was not active.
+ *		1 if the timer was active.
+ *		**-EINVAL** if *timer* was not initialized with bpf_timer_init() earlier.
+ *		**-EDEADLK** if callback_fn tried to call bpf_timer_cancel() on its own timer
+ *		which would have led to a deadlock otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4949,6 +4981,9 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(timer_init),			\
+	FN(timer_start),		\
+	FN(timer_cancel),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -6061,6 +6096,11 @@ struct bpf_spin_lock {
 	__u32	val;
 };
 
+struct bpf_timer {
+	__u64 :64;
+	__u64 :64;
+};
+
 struct bpf_sysctl {
 	__u32	write;		/* Sysctl is being read (= 0) or written (= 1).
 				 * Allows 1,2,4-byte read, but no write.
-- 
2.30.2

