Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF053B24F1
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhFXC1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFXC1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:27:43 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D99FC061574;
        Wed, 23 Jun 2021 19:25:24 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id i4so2140130plt.12;
        Wed, 23 Jun 2021 19:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vuOcEwzfO4u/7pW1gwjn72puq93Q+uZiPxIWN/G/UWs=;
        b=CPkKvtR7Ze8O/zvZbT+Pm3YJ/NZlmtdnfszNCE3P4K1923ll09XMrcBicAOxs5rz8r
         cAwTFE/PoW9MPjzZz5+uGjVrzZCWcc/2ES1xPnApcbcGHWVA9YHyhQVWEq4tczcubKDJ
         KiiwHxXO+/sbfIyE4hulwaKSKktbhESsJeulwE4Gwa/NGPFkw59mOYTXPXzJOiFC4h18
         vdFvALNGSDeybaXSy+gy2QIjBGejg6YZMarb4BzlaoppJ4UoRimT3ceO3nS3o8oS7po8
         dJtG1qPtl/LrPeIpKshl/uegREybTPajVMqujHZYlQz+5eplF5T8hWmOKTBPJXBnkKCN
         qicQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vuOcEwzfO4u/7pW1gwjn72puq93Q+uZiPxIWN/G/UWs=;
        b=DxmfLI/qWFNmUQ/cPtJb1p0oIoY39h24S5Ogyae9VslMYtmSrwag+ebltyyR9rIOb3
         sp2pg+YOJ5YL28ps2ETu+GokSP0I0aTXwZZDQuniyShkDUTs50jTM51UO+Imf/Wy4ZGR
         gDmAQn/Wq7EsI+sMcTt+gsP+d0DXzERy4ZUEDx0Nl0Xa4eddJsbWnUfi6sBq40xM6Gb9
         hy+kMrRC7SNikxsUnPXFdoJQJs701/wh1nlvGuuoeBTip7831/NPxMc+0b+EvS+oCEpP
         Y3Airjy1NPEOlouyUtkp6ZZkypThlT0khLTfpnKKSn5cFEe1VVhx+30nbA5SmJBOq1Ou
         wgtg==
X-Gm-Message-State: AOAM532LuXMhxhto9FDkTPg2TL5wYKZ7+6/15SlARuOxhCUr91wYY9uD
        XWqn7ed99yC8whe51CCCR8E=
X-Google-Smtp-Source: ABdhPJyDI4jHorlXQfLI9sGm/FHPfESnhErwtO84vcJmqtILO+Hzk1wGWZIXy3+E50e1jcd5FE/haA==
X-Received: by 2002:a17:90a:6345:: with SMTP id v5mr12700067pjs.17.1624501523496;
        Wed, 23 Jun 2021 19:25:23 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:a319])
        by smtp.gmail.com with ESMTPSA id f17sm4675965pjj.21.2021.06.23.19.25.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:25:22 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
Date:   Wed, 23 Jun 2021 19:25:11 -0700
Message-Id: <20210624022518.57875-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
in hash/array/lru maps as a regular field and helpers to operate on it:

// Initialize the timer.
// First 4 bits of 'flags' specify clockid.
// Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
long bpf_timer_init(struct bpf_timer *timer, int flags);

// Arm the timer to call callback_fn static function and set its
// expiration 'nsec' nanoseconds from the current time.
long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsec);

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
        bpf_timer_init(&val->timer, CLOCK_REALTIME);
        bpf_timer_start(&val->timer, timer_cb, 1000 /* call timer_cb2 in 1 usec */);
    }
}

This patch adds helper implementations that rely on hrtimers
to call bpf functions as timers expire.
The following patches add necessary safety checks.

Only programs with CAP_BPF are allowed to use bpf_timer.

The amount of timers used by the program is constrained by
the memcg recorded at map creation time.

The bpf_timer_init() helper is receiving hidden 'map' argument and
bpf_timer_start() is receiving hidden 'prog' argument supplied by the verifier.
The prog pointer is needed to do refcnting of bpf program to make sure that
program doesn't get freed while the timer is armed. This apporach relies on
"user refcnt" scheme used in prog_array that stores bpf programs for
bpf_tail_call. The bpf_timer_start() will increment the prog refcnt which is
paired with bpf_timer_cancel() that will drop the prog refcnt. The
ops->map_release_uref is responsible for cancelling the timers and dropping
prog refcnt when user space reference to a map reaches zero.
This uref approach is done to make sure that Ctrl-C of user space process will
not leave timers running forever unless the user space explicitly pinned a map
that contained timers in bpffs.

The bpf_map_delete_elem() and bpf_map_update_elem() operations cancel
and free the timer if given map element had it allocated.
"bpftool map update" command can be used to cancel timers.

The 'struct bpf_timer' is explicitly __attribute__((aligned(8))) because
'__u64 :64' has 1 byte alignment of 8 byte padding.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h            |   3 +
 include/uapi/linux/bpf.h       |  55 +++++++
 kernel/bpf/helpers.c           | 281 +++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          | 138 ++++++++++++++++
 kernel/trace/bpf_trace.c       |   2 +-
 scripts/bpf_doc.py             |   2 +
 tools/include/uapi/linux/bpf.h |  55 +++++++
 7 files changed, 535 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f309fc1509f2..72da9d4d070c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -168,6 +168,7 @@ struct bpf_map {
 	u32 max_entries;
 	u32 map_flags;
 	int spin_lock_off; /* >=0 valid offset, <0 error */
+	int timer_off; /* >=0 valid offset, <0 error */
 	u32 id;
 	int numa_node;
 	u32 btf_key_type_id;
@@ -221,6 +222,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 }
 void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 			   bool lock_src);
+void bpf_timer_cancel_and_free(void *timer);
 int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size);
 
 struct bpf_offload_dev;
@@ -314,6 +316,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_FUNC,	/* pointer to a bpf program function */
 	ARG_PTR_TO_STACK_OR_NULL,	/* pointer to stack or NULL */
 	ARG_PTR_TO_CONST_STR,	/* pointer to a null terminated read-only string */
+	ARG_PTR_TO_TIMER,	/* pointer to bpf_timer */
 	__BPF_ARG_TYPE_MAX,
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bf9252c7381e..5e0a2a40507e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4780,6 +4780,53 @@ union bpf_attr {
  * 		Execute close syscall for given FD.
  * 	Return
  * 		A syscall result.
+ *
+ * long bpf_timer_init(struct bpf_timer *timer, u64 flags)
+ *	Description
+ *		Initialize the timer.
+ *		First 4 bits of *flags* specify clockid.
+ *		Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
+ *		All other bits of *flags* are reserved.
+ *	Return
+ *		0 on success.
+ *		**-EBUSY** if *timer* is already initialized.
+ *		**-EINVAL** if invalid *flags* are passed.
+ *
+ * long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsecs)
+ *	Description
+ *		Configure the timer to call *callback_fn* static function and
+ *		set its expiration N nanoseconds from the current time.
+ *		The *callback_fn* will be invoked in soft irq context on some cpu
+ *		and will not repeat unless another bpf_timer_start() is made.
+ *		In such case the next invocation can migrate to a different cpu.
+ *		Since struct bpf_timer is a field inside map element the map
+ *		owns the timer. The bpf_timer_start() will increment refcnt
+ *		of BPF program to make sure that callback_fn code stays valid.
+ *		When user space reference to a map reaches zero all timers
+ *		in a map are cancelled and corresponding program's refcnts are
+ *		decremented. This is done to make sure that Ctrl-C of a user
+ *		process doesn't leave any timers running. If map is pinned in
+ *		bpffs the callback_fn can re-arm itself indefinitely.
+ *		bpf_map_update/delete_elem() helpers and user space sys_bpf commands
+ *		cancel and free the timer in the given map element.
+ *		The map can contain timers that invoke callback_fn-s from different
+ *		programs. The same callback_fn can serve different timers from
+ *		different maps if key/value layout matches across maps.
+ *		Every bpf_timer_start() can have different callback_fn.
+ *
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
@@ -4951,6 +4998,9 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(timer_init),			\
+	FN(timer_start),		\
+	FN(timer_cancel),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -6077,6 +6127,11 @@ struct bpf_spin_lock {
 	__u32	val;
 };
 
+struct bpf_timer {
+	__u64 :64;
+	__u64 :64;
+} __attribute__((aligned(8)));
+
 struct bpf_sysctl {
 	__u32	write;		/* Sysctl is being read (= 0) or written (= 1).
 				 * Allows 1,2,4-byte read, but no write.
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a2f1f15ce432..584a37a1b974 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -989,6 +989,281 @@ const struct bpf_func_proto bpf_snprintf_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+/* BPF map elements can contain 'struct bpf_timer'.
+ * Such map owns all of its BPF timers.
+ * 'struct bpf_timer' is allocated as part of map element allocation
+ * and it's zero initialized.
+ * That space is used to keep 'struct bpf_timer_kern'.
+ * bpf_timer_init() allocates 'struct bpf_hrtimer', inits hrtimer, and
+ * remembers 'struct bpf_map *' pointer it's part of.
+ * bpf_timer_start() arms the timer and increments struct bpf_prog refcnt.
+ * If user space reference to a map goes to zero at this point
+ * ops->map_release_uref callback is responsible for cancelling the timers,
+ * freeing their memory, and decrementing prog's refcnts.
+ * bpf_timer_cancel() cancels the timer and decrements prog's refcnt.
+ *
+ * The timer callback bpf_timer_cb() is doing refcnt++ and -- around
+ * bpf subprogram invocation to make that bpf_map_delete_elem() done
+ * explicitly or implicitly in case of LRU maps will not free bpf_prog
+ * while the callback is running.
+ *
+ * Inner maps can contain bpf timers as well. ops->map_release_uref is
+ * freeing the timers when inner map is replaced or deleted by user space.
+ */
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
+	/* bpf_spin_lock is used here instead of spinlock_t to make
+	 * sure that it always fits into space resereved by struct bpf_timer
+	 * regardless of LOCKDEP and spinlock debug flags.
+	 */
+	struct bpf_spin_lock lock;
+} __attribute__((aligned(8)));
+
+static DEFINE_PER_CPU(struct bpf_hrtimer *, hrtimer_running);
+
+static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
+{
+	struct bpf_hrtimer *t = container_of(hrtimer, struct bpf_hrtimer, timer);
+	struct bpf_map *map = t->map;
+	void *value = t->value;
+	struct bpf_timer_kern *timer = value + map->timer_off;
+	struct bpf_prog *prog;
+	void *callback_fn;
+	void *key;
+	u32 idx;
+	int ret;
+
+	____bpf_spin_lock(&timer->lock);
+	/* callback_fn and prog need to match. They're updated together
+	 * and have to be read under lock.
+	 */
+	prog = t->prog;
+	callback_fn = t->callback_fn;
+
+	/* wrap bpf subprog invocation with prog->refcnt++ and -- to make
+	 * sure that refcnt doesn't become zero when subprog is executing.
+	 * Do it under lock to make sure that bpf_timer_start doesn't drop
+	 * prev prog refcnt to zero before timer_cb has a chance to bump it.
+	 */
+	bpf_prog_inc(prog);
+	____bpf_spin_unlock(&timer->lock);
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
+		idx = ((char *)value - array->value) / array->elem_size;
+		key = &idx;
+	} else { /* hash or lru */
+		key = value - round_up(map->key_size, 8);
+	}
+
+	ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
+					 (u64)(long)key,
+					 (u64)(long)value, 0, 0);
+	WARN_ON(ret != 0); /* Next patch moves this check into the verifier */
+	bpf_prog_put(prog);
+
+	this_cpu_write(hrtimer_running, NULL);
+	return HRTIMER_NORESTART;
+}
+
+BPF_CALL_3(bpf_timer_init, struct bpf_timer_kern *, timer, u64, flags,
+	   struct bpf_map *, map)
+{
+	clockid_t clockid = flags & (MAX_CLOCKS - 1);
+	struct bpf_hrtimer *t;
+	int ret = 0;
+
+	BUILD_BUG_ON(MAX_CLOCKS != 16);
+	BUILD_BUG_ON(sizeof(struct bpf_timer_kern) > sizeof(struct bpf_timer));
+	BUILD_BUG_ON(__alignof__(struct bpf_timer_kern) != __alignof__(struct bpf_timer));
+
+	if (flags >= MAX_CLOCKS ||
+	    /* similar to timerfd except _ALARM variants are not supported */
+	    (clockid != CLOCK_MONOTONIC &&
+	     clockid != CLOCK_REALTIME &&
+	     clockid != CLOCK_BOOTTIME))
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
+	t->value = (void *)timer - map->timer_off;
+	t->map = map;
+	t->prog = NULL;
+	t->callback_fn = NULL;
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
+	.arg2_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_4(bpf_timer_start, struct bpf_timer_kern *, timer, void *, callback_fn,
+	   u64, nsecs, struct bpf_prog *, prog)
+{
+	struct bpf_hrtimer *t;
+	struct bpf_prog *prev;
+	int ret = 0;
+
+	____bpf_spin_lock(&timer->lock);
+	t = timer->timer;
+	if (!t) {
+		ret = -EINVAL;
+		goto out;
+	}
+	prev = t->prog;
+	if (prev != prog) {
+		if (prev)
+			/* Drop pref prog refcnt when swapping with new prog */
+			bpf_prog_put(prev);
+		/* Dump prog refcnt once.
+		 * Every bpf_timer_start() can pick different callback_fn-s
+		 * within the same prog.
+		 */
+		bpf_prog_inc(prog);
+		t->prog = prog;
+	}
+	t->callback_fn = callback_fn;
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
+	.arg2_type	= ARG_PTR_TO_FUNC,
+	.arg3_type	= ARG_ANYTHING,
+};
+
+static void drop_prog_refcnt(struct bpf_hrtimer *t)
+{
+	struct bpf_prog *prog = t->prog;
+
+	if (prog) {
+		/* If timer was armed with bpf_timer_start()
+		 * drop prog refcnt.
+		 */
+		bpf_prog_put(prog);
+		t->prog = NULL;
+		t->callback_fn = NULL;
+	}
+}
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
+	ret = hrtimer_cancel(&t->timer);
+	drop_prog_refcnt(t);
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
+/* This function is called by map_delete/update_elem for individual element.
+ * By ops->map_release_uref when the user space reference to a map reaches zero
+ * and by ops->map_free when the kernel reference reaches zero.
+ */
+void bpf_timer_cancel_and_free(void *val)
+{
+	struct bpf_timer_kern *timer = val;
+	struct bpf_hrtimer *t;
+
+	/* Performance optimization: read timer->timer without lock first. */
+	if (!READ_ONCE(timer->timer))
+		return;
+
+	____bpf_spin_lock(&timer->lock);
+	/* re-read it under lock */
+	t = timer->timer;
+	if (!t)
+		goto out;
+	/* Cancel the timer and wait for callback to complete if it was running.
+	 * Check that bpf_map_delete/update_elem() wasn't called from timer callback_fn.
+	 * In such case don't call hrtimer_cancel() (since it will deadlock)
+	 * and don't call hrtimer_try_to_cancel() (since it will just return -1).
+	 * Instead free the timer and set timer->timer = NULL.
+	 * The subsequent bpf_timer_start/cancel() helpers won't be able to use it,
+	 * since it won't be initialized.
+	 * In preallocated maps it's safe to do timer->timer = NULL.
+	 * The memory could be reused for another map element while current
+	 * callback_fn can do bpf_timer_init() on it.
+	 * In non-preallocated maps bpf_timer_cancel_and_free and
+	 * timer->timer = NULL will happen after callback_fn completes, since
+	 * program execution is an RCU critical section.
+	 */
+	if (this_cpu_read(hrtimer_running) != t)
+		hrtimer_cancel(&t->timer);
+	drop_prog_refcnt(t);
+	kfree(t);
+	timer->timer = NULL;
+out:
+	____bpf_spin_unlock(&timer->lock);
+}
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
@@ -1055,6 +1330,12 @@ bpf_base_func_proto(enum bpf_func_id func_id)
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
index b7d51fc937c7..fa15bd30e331 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4656,6 +4656,38 @@ static int process_spin_lock(struct bpf_verifier_env *env, int regno,
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
+	if (meta->map_ptr) {
+		verbose(env, "verifier bug. Two map pointers in a timer helper\n");
+		return -EFAULT;
+	}
+	meta->map_ptr = map;
+	return 0;
+}
+
 static bool arg_type_is_mem_ptr(enum bpf_arg_type type)
 {
 	return type == ARG_PTR_TO_MEM ||
@@ -4788,6 +4820,7 @@ static const struct bpf_reg_types percpu_btf_ptr_types = { .types = { PTR_TO_PER
 static const struct bpf_reg_types func_ptr_types = { .types = { PTR_TO_FUNC } };
 static const struct bpf_reg_types stack_ptr_types = { .types = { PTR_TO_STACK } };
 static const struct bpf_reg_types const_str_ptr_types = { .types = { PTR_TO_MAP_VALUE } };
+static const struct bpf_reg_types timer_types = { .types = { PTR_TO_MAP_VALUE } };
 
 static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_MAP_KEY]		= &map_key_value_types,
@@ -4819,6 +4852,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_FUNC]		= &func_ptr_types,
 	[ARG_PTR_TO_STACK_OR_NULL]	= &stack_ptr_types,
 	[ARG_PTR_TO_CONST_STR]		= &const_str_ptr_types,
+	[ARG_PTR_TO_TIMER]		= &timer_types,
 };
 
 static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
@@ -5000,6 +5034,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			verbose(env, "verifier internal error\n");
 			return -EFAULT;
 		}
+	} else if (arg_type == ARG_PTR_TO_TIMER) {
+		if (process_timer_func(env, regno, meta))
+			return -EACCES;
 	} else if (arg_type == ARG_PTR_TO_FUNC) {
 		meta->subprogno = reg->subprogno;
 	} else if (arg_type_is_mem_ptr(arg_type)) {
@@ -5742,6 +5779,34 @@ static int set_map_elem_callback_state(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static int set_timer_start_callback_state(struct bpf_verifier_env *env,
+					  struct bpf_func_state *caller,
+					  struct bpf_func_state *callee,
+					  int insn_idx)
+{
+	struct bpf_map *map_ptr = caller->regs[BPF_REG_1].map_ptr;
+
+	/* bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsecs);
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
+	return 0;
+}
+
 static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 {
 	struct bpf_verifier_state *state = env->cur_state;
@@ -5837,6 +5902,8 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	    func_id != BPF_FUNC_map_pop_elem &&
 	    func_id != BPF_FUNC_map_peek_elem &&
 	    func_id != BPF_FUNC_for_each_map_elem &&
+	    func_id != BPF_FUNC_timer_init &&
+	    func_id != BPF_FUNC_timer_start &&
 	    func_id != BPF_FUNC_redirect_map)
 		return 0;
 
@@ -6069,6 +6136,13 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			return -EINVAL;
 	}
 
+	if (func_id == BPF_FUNC_timer_start) {
+		err = __check_func_call(env, insn, insn_idx_p, meta.subprogno,
+					set_timer_start_callback_state);
+		if (err < 0)
+			return -EINVAL;
+	}
+
 	if (func_id == BPF_FUNC_snprintf) {
 		err = check_bpf_snprintf_call(env, regs);
 		if (err < 0)
@@ -12533,6 +12607,70 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
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
+				struct bpf_insn ld_addrs[2] = {
+					BPF_LD_IMM64(BPF_REG_3, (long)map_ptr),
+				};
+
+				insn_buf[0] = ld_addrs[0];
+				insn_buf[1] = ld_addrs[1];
+			}
+			insn_buf[2] = *insn;
+			cnt = 3;
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
+
+		if (insn->imm == BPF_FUNC_timer_start) {
+			/* There is no need to do:
+			 *     aux = &env->insn_aux_data[i + delta];
+			 *     if (bpf_map_ptr_poisoned(aux)) return -EINVAL;
+			 * for bpf_timer_start(). If the same callback_fn is shared
+			 * by different timers in different maps the poisoned check
+			 * will return false positive.
+			 *
+			 * The verifier will process callback_fn as many times as necessary
+			 * with different maps and the register states prepared by
+			 * set_timer_start_callback_state will be accurate.
+			 *
+			 * There is no need for bpf_timer_start() to check in the
+			 * run-time that bpf_hrtimer->map stored during bpf_timer_init()
+			 * is the same map as in bpf_timer_start()
+			 * because it's the same map element value.
+			 */
+			struct bpf_insn ld_addrs[2] = {
+				BPF_LD_IMM64(BPF_REG_4, (long)prog),
+			};
+
+			insn_buf[0] = ld_addrs[0];
+			insn_buf[1] = ld_addrs[1];
+			insn_buf[2] = *insn;
+			cnt = 3;
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
+
 		/* BPF_EMIT_CALL() assumptions in some of the map_gen_lookup
 		 * and other inlining handlers are currently limited to 64 bit
 		 * only.
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7a52bc172841..80f6e6dafd5e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1057,7 +1057,7 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
index bf9252c7381e..5e0a2a40507e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4780,6 +4780,53 @@ union bpf_attr {
  * 		Execute close syscall for given FD.
  * 	Return
  * 		A syscall result.
+ *
+ * long bpf_timer_init(struct bpf_timer *timer, u64 flags)
+ *	Description
+ *		Initialize the timer.
+ *		First 4 bits of *flags* specify clockid.
+ *		Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
+ *		All other bits of *flags* are reserved.
+ *	Return
+ *		0 on success.
+ *		**-EBUSY** if *timer* is already initialized.
+ *		**-EINVAL** if invalid *flags* are passed.
+ *
+ * long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsecs)
+ *	Description
+ *		Configure the timer to call *callback_fn* static function and
+ *		set its expiration N nanoseconds from the current time.
+ *		The *callback_fn* will be invoked in soft irq context on some cpu
+ *		and will not repeat unless another bpf_timer_start() is made.
+ *		In such case the next invocation can migrate to a different cpu.
+ *		Since struct bpf_timer is a field inside map element the map
+ *		owns the timer. The bpf_timer_start() will increment refcnt
+ *		of BPF program to make sure that callback_fn code stays valid.
+ *		When user space reference to a map reaches zero all timers
+ *		in a map are cancelled and corresponding program's refcnts are
+ *		decremented. This is done to make sure that Ctrl-C of a user
+ *		process doesn't leave any timers running. If map is pinned in
+ *		bpffs the callback_fn can re-arm itself indefinitely.
+ *		bpf_map_update/delete_elem() helpers and user space sys_bpf commands
+ *		cancel and free the timer in the given map element.
+ *		The map can contain timers that invoke callback_fn-s from different
+ *		programs. The same callback_fn can serve different timers from
+ *		different maps if key/value layout matches across maps.
+ *		Every bpf_timer_start() can have different callback_fn.
+ *
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
@@ -4951,6 +4998,9 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(timer_init),			\
+	FN(timer_start),		\
+	FN(timer_cancel),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -6077,6 +6127,11 @@ struct bpf_spin_lock {
 	__u32	val;
 };
 
+struct bpf_timer {
+	__u64 :64;
+	__u64 :64;
+} __attribute__((aligned(8)));
+
 struct bpf_sysctl {
 	__u32	write;		/* Sysctl is being read (= 0) or written (= 1).
 				 * Allows 1,2,4-byte read, but no write.
-- 
2.30.2

