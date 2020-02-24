Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C17516A92E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgBXPDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:03:49 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50223 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgBXPDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:25 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFy-00052t-3b; Mon, 24 Feb 2020 16:02:50 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id B2F2610409C;
        Mon, 24 Feb 2020 16:02:44 +0100 (CET)
Message-Id: <20200224145644.509685912@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:51 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [patch V3 20/22] bpf: Prepare hashtab locking for PREEMPT_RT
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PREEMPT_RT forbids certain operations like memory allocations (even with
GFP_ATOMIC) from atomic contexts. This is required because even with
GFP_ATOMIC the memory allocator calls into code pathes which acquire locks
with long held lock sections. To ensure the deterministic behaviour these
locks are regular spinlocks, which are converted to 'sleepable' spinlocks
on RT. The only true atomic contexts on an RT kernel are the low level
hardware handling, scheduling, low level interrupt handling, NMIs etc. None
of these contexts should ever do memory allocations.

As regular device interrupt handlers and soft interrupts are forced into
thread context, the existing code which does
  spin_lock*(); alloc(GPF_ATOMIC); spin_unlock*();
just works.

In theory the BPF locks could be converted to regular spinlocks as well,
but the bucket locks and percpu_freelist locks can be taken from arbitrary
contexts (perf, kprobes, tracepoints) which are required to be atomic
contexts even on RT. These mechanisms require preallocated maps, so there
is no need to invoke memory allocations within the lock held sections.

BPF maps which need dynamic allocation are only used from (forced) thread
context on RT and can therefore use regular spinlocks which in turn allows
to invoke memory allocations from the lock held section.

To achieve this make the hash bucket lock a union of a raw and a regular
spinlock and initialize and lock/unlock either the raw spinlock for
preallocated maps or the regular variant for maps which require memory
allocations.

On a non RT kernel this distinction is neither possible nor required.
spinlock maps to raw_spinlock and the extra code and conditional is
optimized out by the compiler. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/bpf/hashtab.c |   65 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 9 deletions(-)

--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -46,10 +46,43 @@
  * from one of these contexts completed. sys_bpf() uses the same mechanism
  * by pinning the task to the current CPU and incrementing the recursion
  * protection accross the map operation.
+ *
+ * This has subtle implications on PREEMPT_RT. PREEMPT_RT forbids certain
+ * operations like memory allocations (even with GFP_ATOMIC) from atomic
+ * contexts. This is required because even with GFP_ATOMIC the memory
+ * allocator calls into code pathes which acquire locks with long held lock
+ * sections. To ensure the deterministic behaviour these locks are regular
+ * spinlocks, which are converted to 'sleepable' spinlocks on RT. The only
+ * true atomic contexts on an RT kernel are the low level hardware
+ * handling, scheduling, low level interrupt handling, NMIs etc. None of
+ * these contexts should ever do memory allocations.
+ *
+ * As regular device interrupt handlers and soft interrupts are forced into
+ * thread context, the existing code which does
+ *   spin_lock*(); alloc(GPF_ATOMIC); spin_unlock*();
+ * just works.
+ *
+ * In theory the BPF locks could be converted to regular spinlocks as well,
+ * but the bucket locks and percpu_freelist locks can be taken from
+ * arbitrary contexts (perf, kprobes, tracepoints) which are required to be
+ * atomic contexts even on RT. These mechanisms require preallocated maps,
+ * so there is no need to invoke memory allocations within the lock held
+ * sections.
+ *
+ * BPF maps which need dynamic allocation are only used from (forced)
+ * thread context on RT and can therefore use regular spinlocks which in
+ * turn allows to invoke memory allocations from the lock held section.
+ *
+ * On a non RT kernel this distinction is neither possible nor required.
+ * spinlock maps to raw_spinlock and the extra code is optimized out by the
+ * compiler.
  */
 struct bucket {
 	struct hlist_nulls_head head;
-	raw_spinlock_t lock;
+	union {
+		raw_spinlock_t raw_lock;
+		spinlock_t     lock;
+	};
 };
 
 struct bpf_htab {
@@ -88,13 +121,26 @@ struct htab_elem {
 	char key[0] __aligned(8);
 };
 
+static inline bool htab_is_prealloc(const struct bpf_htab *htab)
+{
+	return !(htab->map.map_flags & BPF_F_NO_PREALLOC);
+}
+
+static inline bool htab_use_raw_lock(const struct bpf_htab *htab)
+{
+	return (!IS_ENABLED(CONFIG_PREEMPT_RT) || htab_is_prealloc(htab));
+}
+
 static void htab_init_buckets(struct bpf_htab *htab)
 {
 	unsigned i;
 
 	for (i = 0; i < htab->n_buckets; i++) {
 		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
-		raw_spin_lock_init(&htab->buckets[i].lock);
+		if (htab_use_raw_lock(htab))
+			raw_spin_lock_init(&htab->buckets[i].raw_lock);
+		else
+			spin_lock_init(&htab->buckets[i].lock);
 	}
 }
 
@@ -103,7 +149,10 @@ static inline unsigned long htab_lock_bu
 {
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	if (htab_use_raw_lock(htab))
+		raw_spin_lock_irqsave(&b->raw_lock, flags);
+	else
+		spin_lock_irqsave(&b->lock, flags);
 	return flags;
 }
 
@@ -111,7 +160,10 @@ static inline void htab_unlock_bucket(co
 				      struct bucket *b,
 				      unsigned long flags)
 {
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	if (htab_use_raw_lock(htab))
+		raw_spin_unlock_irqrestore(&b->raw_lock, flags);
+	else
+		spin_unlock_irqrestore(&b->lock, flags);
 }
 
 static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node);
@@ -128,11 +180,6 @@ static bool htab_is_percpu(const struct
 		htab->map.map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH;
 }
 
-static bool htab_is_prealloc(const struct bpf_htab *htab)
-{
-	return !(htab->map.map_flags & BPF_F_NO_PREALLOC);
-}
-
 static inline void htab_elem_set_ptr(struct htab_elem *l, u32 key_size,
 				     void __percpu *pptr)
 {

