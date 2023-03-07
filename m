Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393736ADF5A
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 13:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjCGM6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 07:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjCGM56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 07:57:58 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DC876F4E;
        Tue,  7 Mar 2023 04:57:46 -0800 (PST)
Message-ID: <20230307125538.932671660@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1678193865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=yaUeKrb/cXO19gjELpzICq7BBFFgL8dqhoclD2dqf0M=;
        b=NXi4B4D4lD2N3Z/4QjxZxjsKodjNMI1k6SzxYbANnHpuB9xzNSTdat9qWe6/T+twDBThQD
        U7lbJanmSRg8oQzHuQmy0vSNtyC8ioJiApPpcYAY7Y31yLJ3zHdFmgVwkngF3jnQMQZKmR
        YirETrHcyusHeA0fRGBt7oA5BIDw/GN1q4+a/EinVVvEu9VVJocL7UWPgZHDeAewsSSQTZ
        8u+EdA7qHRuUpDUJeotTgQXYRnWkxUxBvRAA1o3BK/RNzQ2ne/F77eXpSlYbtSt8vgQAIT
        aZOJYfYmvVSKvL+spg54uhmEm/iFJ/JTt91bxo3+dqtgwoI3iJKZZcO6SNSETw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1678193865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=yaUeKrb/cXO19gjELpzICq7BBFFgL8dqhoclD2dqf0M=;
        b=kt6liPONSiavxpDHHpGQUvpzakEQQ4ST/jYGJ9ij0sJn1+k5eAlJTxM02tV/KKn9khR7Yh
        BvjlpEzBQ/yxYqDw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>
Subject: [patch V2 3/4] atomics: Provide rcuref - scalable reference counting
References: <20230307125358.772287565@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue,  7 Mar 2023 13:57:44 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

atomic_t based reference counting, including refcount_t, uses
atomic_inc_not_zero() for acquiring a reference. atomic_inc_not_zero() is
implemented with a atomic_try_cmpxchg() loop. High contention of the
reference count leads to retry loops and scales badly. There is nothing to
improve on this implementation as the semantics have to be preserved.

Provide rcuref as a scalable alternative solution which is suitable for RCU
managed objects. Similar to refcount_t it comes with overflow and underflow
detection and mitigation.

rcuref treats the underlying atomic_t as an unsigned integer and partitions
this space into zones:

  0x00000000 - 0x7FFFFFFF	valid zone (1 .. INT_MAX references)
  0x80000000 - 0xBFFFFFFF	saturation zone
  0xC0000000 - 0xFFFFFFFE	dead zone
  0xFFFFFFFF   			no reference

rcuref_get() unconditionally increments the reference count with
atomic_add_negative_relaxed(). rcuref_put() unconditionally decrements the
reference count with atomic_add_negative_release().

This unconditional increment avoids the inc_not_zero() problem, but
requires a more complex implementation on the put() side when the count
drops from 0 to -1.

When this transition is detected then it is attempted to mark the reference
count dead, by setting it to the midpoint of the dead zone with a single
atomic_cmpxchg_release() operation. This operation can fail due to a
concurrent rcuref_get() elevating the reference count from -1 to 0 again.

If the unconditional increment in rcuref_get() hits a reference count which
is marked dead (or saturated) it will detect it after the fact and bring
back the reference count to the midpoint of the respective zone. The zones
provide enough tolerance which makes it practically impossible to escape
from a zone.

The racy implementation of rcuref_put() requires to protect rcuref_put()
against a grace period ending in order to prevent a subtle use after
free. As RCU is the only mechanism which allows to protect against that, it
is not possible to fully replace the atomic_inc_not_zero() based
implementation of refcount_t with this scheme.

The final drop is slightly more expensive than the atomic_dec_return()
counterpart, but that's not the case which this is optimized for. The
optimization is on the high frequeunt get()/put() pairs and their
scalability.

The performance of an uncontended rcuref_get()/put() pair where the put()
is not dropping the last reference is still on par with the plain atomic
operations, while at the same time providing overflow and underflow
detection and mitigation.

The performance of rcuref compared to plain atomic_inc_not_zero() and
atomic_dec_return() based reference counting under contention:

 -  Micro benchmark: All CPUs running a increment/decrement loop on an
    elevated reference count, which means the 0 to -1 transition never
    happens.

    The performance gain depends on microarchitecture and the number of
    CPUs and has been observed in the range of 1.3X to 4.7X

 - Conversion of dst_entry::__refcnt to rcuref and testing with the
    localhost memtier/memcached benchmark. That benchmark shows the
    reference count contention prominently.
    
    The performance gain depends on microarchitecture and the number of
    CPUs and has been observed in the range of 1.1X to 2.6X over the
    previous fix for the false sharing issue vs. struct
    dst_entry::__refcnt.

    When memtier is run over a real 1Gb network connection, there is a
    small gain on top of the false sharing fix. The two changes combined
    result in a 2%-5% total gain for that networked test.

Reported-by: Wangyang Guo <wangyang.guo@intel.com>
Reported-by: Arjan Van De Ven <arjan.van.de.ven@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
---
V2: Switch to atomic_add_negative() to make the fast path lean
    (Linus)
---
 include/linux/rcuref.h |  155 +++++++++++++++++++++++++++
 include/linux/types.h  |    6 +
 lib/Makefile           |    2 
 lib/rcuref.c           |  281 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 443 insertions(+), 1 deletion(-)

--- /dev/null
+++ b/include/linux/rcuref.h
@@ -0,0 +1,155 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_RCUREF_H
+#define _LINUX_RCUREF_H
+
+#include <linux/atomic.h>
+#include <linux/bug.h>
+#include <linux/limits.h>
+#include <linux/lockdep.h>
+#include <linux/preempt.h>
+#include <linux/rcupdate.h>
+
+#define RCUREF_ONEREF		0x00000000U
+#define RCUREF_MAXREF		0x7FFFFFFFU
+#define RCUREF_SATURATED	0xA0000000U
+#define RCUREF_RELEASED		0xC0000000U
+#define RCUREF_DEAD		0xE0000000U
+#define RCUREF_NOREF		0xFFFFFFFFU
+
+/**
+ * rcuref_init - Initialize a rcuref reference count with the given reference count
+ * @ref:	Pointer to the reference count
+ * @cnt:	The initial reference count typically '1'
+ */
+static inline void rcuref_init(rcuref_t *ref, unsigned int cnt)
+{
+	atomic_set(&ref->refcnt, cnt - 1);
+}
+
+/**
+ * rcuref_read - Read the number of held reference counts of a rcuref
+ * @ref:	Pointer to the reference count
+ *
+ * Return: The number of held references (0 ... N)
+ */
+static inline unsigned int rcuref_read(rcuref_t *ref)
+{
+	unsigned int c = atomic_read(&ref->refcnt);
+
+	/* Return 0 if within the DEAD zone. */
+	return c >= RCUREF_RELEASED ? 0 : c + 1;
+}
+
+extern __must_check bool rcuref_get_slowpath(rcuref_t *ref);
+
+/**
+ * rcuref_get - Acquire one reference on a rcuref reference count
+ * @ref:	Pointer to the reference count
+ *
+ * Similar to atomic_inc_not_zero() but saturates at RCUREF_MAXREF.
+ *
+ * Provides no memory ordering, it is assumed the caller has guaranteed the
+ * object memory to be stable (RCU, etc.). It does provide a control dependency
+ * and thereby orders future stores. See documentation in lib/rcuref.c
+ *
+ * Return:
+ *	False if the attempt to acquire a reference failed. This happens
+ *	when the last reference has been put already
+ *
+ *	True if a reference was successfully acquired
+ */
+static inline __must_check bool rcuref_get(rcuref_t *ref)
+{
+	/*
+	 * Unconditionally increase the reference count. The saturation and
+	 * dead zones provide enough tolerance for this.
+	 */
+	if (likely(!atomic_add_negative_relaxed(1, &ref->refcnt)))
+		return true;
+
+	/* Handle the cases inside the saturation and dead zones */
+	return rcuref_get_slowpath(ref);
+}
+
+extern __must_check bool rcuref_put_slowpath(rcuref_t *ref);
+
+/*
+ * Internal helper. Do not invoke directly.
+ */
+static __always_inline __must_check bool __rcuref_put(rcuref_t *ref)
+{
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held() && preemptible(),
+			 "suspicious rcuref_put_rcusafe() usage");
+	/*
+	 * Unconditionally decrease the reference count. The saturation and
+	 * dead zones provide enough tolerance for this.
+	 */
+	if (likely(!atomic_add_negative_release(-1, &ref->refcnt)))
+		return false;
+
+	/*
+	 * Handle the last reference drop and cases inside the saturation
+	 * and dead zones.
+	 */
+	return rcuref_put_slowpath(ref);
+}
+
+/**
+ * rcuref_put_rcusafe -- Release one reference for a rcuref reference count RCU safe
+ * @ref:	Pointer to the reference count
+ *
+ * Provides release memory ordering, such that prior loads and stores are done
+ * before, and provides an acquire ordering on success such that free()
+ * must come after.
+ *
+ * Can be invoked from contexts, which guarantee that no grace period can
+ * happen which would free the object concurrently if the decrement drops
+ * the last reference and the slowpath races against a concurrent get() and
+ * put() pair. rcu_read_lock()'ed and atomic contexts qualify.
+ *
+ * Return:
+ *	True if this was the last reference with no future references
+ *	possible. This signals the caller that it can safely release the
+ *	object which is protected by the reference counter.
+ *
+ *	False if there are still active references or the put() raced
+ *	with a concurrent get()/put() pair. Caller is not allowed to
+ *	release the protected object.
+ */
+static inline __must_check bool rcuref_put_rcusafe(rcuref_t *ref)
+{
+	return __rcuref_put(ref);
+}
+
+/**
+ * rcuref_put -- Release one reference for a rcuref reference count
+ * @ref:	Pointer to the reference count
+ *
+ * Can be invoked from any context.
+ *
+ * Provides release memory ordering, such that prior loads and stores are done
+ * before, and provides an acquire ordering on success such that free()
+ * must come after.
+ *
+ * Return:
+ *
+ *	True if this was the last reference with no future references
+ *	possible. This signals the caller that it can safely schedule the
+ *	object, which is protected by the reference counter, for
+ *	deconstruction.
+ *
+ *	False if there are still active references or the put() raced
+ *	with a concurrent get()/put() pair. Caller is not allowed to
+ *	deconstruct the protected object.
+ */
+static inline __must_check bool rcuref_put(rcuref_t *ref)
+{
+	bool released;
+
+	preempt_disable();
+	released = __rcuref_put(ref);
+	preempt_enable();
+	return released;
+}
+
+#endif
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -175,6 +175,12 @@ typedef struct {
 } atomic64_t;
 #endif
 
+typedef struct {
+	atomic_t refcnt;
+} rcuref_t;
+
+#define RCUREF_INIT(i)	{ .refcnt = ATOMIC_INIT(i - 1) }
+
 struct list_head {
 	struct list_head *next, *prev;
 };
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -47,7 +47,7 @@ obj-y += bcd.o sort.o parser.o debug_loc
 	 list_sort.o uuid.o iov_iter.o clz_ctz.o \
 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o rhashtable.o base64.o \
-	 once.o refcount.o usercopy.o errseq.o bucket_locks.o \
+	 once.o refcount.o rcuref.o usercopy.o errseq.o bucket_locks.o \
 	 generic-radix-tree.o
 obj-$(CONFIG_STRING_SELFTEST) += test_string.o
 obj-y += string_helpers.o
--- /dev/null
+++ b/lib/rcuref.c
@@ -0,0 +1,281 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * rcuref - A scalable reference count implementation for RCU managed objects
+ *
+ * rcuref is provided to replace open coded reference count implementations
+ * based on atomic_t. It protects explicitely RCU managed objects which can
+ * be visible even after the last reference has been dropped and the object
+ * is heading towards destruction.
+ *
+ * A common usage pattern is:
+ *
+ * get()
+ *	rcu_read_lock();
+ *	p = get_ptr();
+ *	if (p && !atomic_inc_not_zero(&p->refcnt))
+ *		p = NULL;
+ *	rcu_read_unlock();
+ *	return p;
+ *
+ * put()
+ *	if (!atomic_dec_return(&->refcnt)) {
+ *		remove_ptr(p);
+ *		kfree_rcu((p, rcu);
+ *	}
+ *
+ * atomic_inc_not_zero() is implemented with a try_cmpxchg() loop which has
+ * O(N^2) behaviour under contention with N concurrent operations.
+ *
+ * rcuref uses atomic_add_negative_relaxed() for the fast path, which scales
+ * better under contention.
+ *
+ * Why not refcount?
+ * =================
+ *
+ * In principle it should be possible to make refcount use the rcuref
+ * scheme, but the destruction race described below cannot be prevented
+ * unless the protected object is RCU managed.
+ *
+ * Theory of operation
+ * ===================
+ *
+ * rcuref uses an unsigned integer reference counter. As long as the
+ * counter value is greater than or equal to RCUREF_ONEREF and not larger
+ * than RCUREF_MAXREF the reference is alive:
+ *
+ * ONEREF   MAXREF               SATURATED             RELEASED      DEAD    NOREF
+ * 0        0x7FFFFFFF 0x8000000 0xA0000000 0xBFFFFFFF 0xC0000000 0xE0000000 0xFFFFFFFF
+ * <---valid --------> <-------saturation zone-------> <-----dead zone----->
+ *
+ * The get() and put() operations do unconditional increments and
+ * decrements. The result is checked after the operation. This optimizes
+ * for the fast path.
+ *
+ * If the reference count is saturated or dead, then the increments and
+ * decrements are not harmful as the reference count still stays in the
+ * respective zones and is always set back to STATURATED resp. DEAD. The
+ * zones have room for 2^28 racing operations in each direction, which
+ * makes it practically impossible to escape the zones.
+ *
+ * Once the last reference is dropped the reference count becomes
+ * RCUREF_NOREF which forces rcuref_put() into the slowpath operation. The
+ * slowpath then tries to set the reference count from RCUREF_NOREF to
+ * RCUREF_DEAD via a cmpxchg(). This opens a small window where a
+ * concurrent rcuref_get() can acquire the reference count and bring it
+ * back to RCUREF_ONEREF or even drop the reference again and mark it DEAD.
+ *
+ * If the cmpxchg() succeeds then a concurrent rcuref_get() will result in
+ * DEAD + 1, which is inside the dead zone. If that happens the reference
+ * count is put back to DEAD.
+ *
+ * The actual race is possible due to the unconditional increment and
+ * decrements in rcuref_get() and rcuref_put():
+ *
+ *	T1				T2
+ *	get()				put()
+ *					if (atomic_add_negative(1, &ref->refcnt))
+ *		succeeds->			atomic_cmpxchg(&ref->refcnt, -1, DEAD);
+ *
+ *	atomic_add_negative(1, &ref->refcnt);	<- Elevates refcount to DEAD + 1
+ *
+ * As the result of T1's add is negative, the get() goes into the slow path
+ * and observes refcnt being in the dead zone which makes the operation fail.
+ *
+ * Possible critical states:
+ *
+ *	Context Counter	References	Operation
+ *	T1	0	1		init()
+ *	T2	1	2		get()
+ *	T1	0	1		put()
+ *	T2     -1	0		put() tries to mark dead
+ *	T1	0	1		get()
+ *	T2	0	1		put() mark dead fails
+ *	T1     -1	0		put() tries to mark dead
+ *	T1    DEAD	0		put() mark dead succeeds
+ *	T2    DEAD+1	0		get() fails and puts it back to DEAD
+ *
+ * Of course there are more complex scenarios, but the above illustrates
+ * the working principle. The rest is left to the imagination of the
+ * reader.
+ *
+ * Deconstruction race
+ * ===================
+ *
+ * The release operation must be protected by prohibiting a grace period in
+ * order to prevent a possible use after free:
+ *
+ *	T1				T2
+ *	put()				get()
+ *	// ref->refcnt = ONEREF
+ *	if (atomic_add_negative(-1, &ref->cnt))
+ *		return false;				<- Not taken
+ *
+ *	// ref->refcnt == NOREF
+ *	--> preemption
+ *					// Elevates ref->c to ONEREF
+ *					if (!atomic_add_negative(1, &ref->refcnt))
+ *						return true;			<- taken
+ *
+ *					if (put(&p->ref)) { <-- Succeeds
+ *						remove_pointer(p);
+ *						kfree_rcu(p, rcu);
+ *					}
+ *
+ *		RCU grace period ends, object is freed
+ *
+ *	atomic_cmpxchg(&ref->refcnt, NONE, DEAD);	<- UAF
+ *
+ * This is prevented by disabling preemption around the put() operation as
+ * that's in most kernel configurations cheaper than a rcu_read_lock() /
+ * rcu_read_unlock() pair and in many cases even a NOOP. In any case it
+ * prevents the grace period which keeps the object alive until all put()
+ * operations complete.
+ *
+ * Saturation protection
+ * =====================
+ *
+ * The reference count has a saturation limit RCUREF_MAXREF (INT_MAX).
+ * Once this is exceedded the reference count becomes stale by setting it
+ * to RCUREF_SATURATED, which will cause a memory leak, but it prevents
+ * wrap arounds which obviously cause worse problems than a memory
+ * leak. When saturation is reached a warning is emitted.
+ *
+ * Race conditions
+ * ===============
+ *
+ * All reference count increment/decrement operations are unconditional and
+ * only verified after the fact. This optimizes for the good case and takes
+ * the occasional race vs. a dead or already saturated refcount into
+ * account. The saturation and dead zones are large enough to accomodate
+ * for that.
+ *
+ * Memory ordering
+ * ===============
+ *
+ * Memory ordering rules are slightly relaxed wrt regular atomic_t functions
+ * and provide only what is strictly required for refcounts.
+ *
+ * The increments are fully relaxed; these will not provide ordering. The
+ * rationale is that whatever is used to obtain the object to increase the
+ * reference count on will provide the ordering. For locked data
+ * structures, its the lock acquire, for RCU/lockless data structures its
+ * the dependent load.
+ *
+ * rcuref_get() provides a control dependency ordering future stores which
+ * ensures that the object is not modified when acquiring a reference
+ * fails.
+ *
+ * rcuref_put() provides release order, i.e. all prior loads and stores
+ * will be issued before. It also provides a control dependency ordering
+ * against the subsequent destruction of the object.
+ *
+ * If rcuref_put() successfully dropped the last reference and marked the
+ * object DEAD it also provides acquire ordering.
+ */
+
+#include <linux/export.h>
+#include <linux/rcuref.h>
+
+/**
+ * rcuref_get_slowpath - Slowpath of rcuref_get()
+ * @ref:	Pointer to the reference count
+ *
+ * Invoked when the reference count is outside of the valid zone.
+ *
+ * Return:
+ *	False if the reference count was already marked dead
+ *
+ *	True if the reference count is saturated, which prevents the
+ *	object from being deconstructed ever.
+ */
+bool rcuref_get_slowpath(rcuref_t *ref)
+{
+	unsigned int cnt = atomic_read(&ref->refcnt);
+
+	/*
+	 * If the reference count was already marked dead, undo the
+	 * increment so it stays in the middle of the dead zone and return
+	 * fail.
+	 */
+	if (cnt >= RCUREF_RELEASED) {
+		atomic_set(&ref->refcnt, RCUREF_DEAD);
+		return false;
+	}
+
+	/*
+	 * If it was saturated, warn and mark it so. In case the increment
+	 * was already on a saturated value restore the saturation
+	 * marker. This keeps it in the middle of the saturation zone and
+	 * prevents the reference count from overflowing. This leaks the
+	 * object memory, but prevents the obvious reference count overflow
+	 * damage.
+	 */
+	if (WARN_ONCE(cnt > RCUREF_MAXREF, "rcuref saturated - leaking memory"))
+		atomic_set(&ref->refcnt, RCUREF_SATURATED);
+	return true;
+}
+EXPORT_SYMBOL_GPL(rcuref_get_slowpath);
+
+/**
+ * rcuref_put_slowpath - Slowpath of __rcuref_put()
+ * @ref:	Pointer to the reference count
+ *
+ * Invoked when the reference count is outside of the valid zone.
+ *
+ * Return:
+ *	True if this was the last reference with no future references
+ *	possible. This signals the caller that it can safely schedule the
+ *	object, which is protected by the reference counter, for
+ *	deconstruction.
+ *
+ *	False if there are still active references or the put() raced
+ *	with a concurrent get()/put() pair. Caller is not allowed to
+ *	deconstruct the protected object.
+ */
+bool rcuref_put_slowpath(rcuref_t *ref)
+{
+	unsigned int cnt = atomic_read(&ref->refcnt);
+
+	/* Did this drop the last reference? */
+	if (likely(cnt == RCUREF_NOREF)) {
+		/*
+		 * Carefully try to set the reference count to RCUREF_DEAD.
+		 *
+		 * This can fail if a concurrent get() operation has
+		 * elevated it again or the corresponding put() even marked
+		 * it dead already. Both are valid situations and do not
+		 * require a retry. If this fails the caller is not
+		 * allowed to deconstruct the object.
+		 */
+		if (atomic_cmpxchg_release(&ref->refcnt, RCUREF_NOREF, RCUREF_DEAD) != RCUREF_NOREF)
+			return false;
+
+		/*
+		 * The caller can safely schedule the object for
+		 * deconstruction. Provide acquire ordering.
+		 */
+		smp_acquire__after_ctrl_dep();
+		return true;
+	}
+
+	/*
+	 * If the reference count was already in the dead zone, then this
+	 * put() operation is imbalanced. Warn, put the reference count back to
+	 * DEAD and tell the caller to not deconstruct the object.
+	 */
+	if (WARN_ONCE(cnt >= RCUREF_RELEASED, "rcuref - imbalanced put()")) {
+		atomic_set(&ref->refcnt, RCUREF_DEAD);
+		return false;
+	}
+
+	/*
+	 * This is a put() operation on a saturated refcount. Restore the
+	 * mean saturation value and tell the caller to not deconstruct the
+	 * object.
+	 */
+	if (cnt > RCUREF_MAXREF)
+		atomic_set(&ref->refcnt, RCUREF_SATURATED);
+	return false;
+}
+EXPORT_SYMBOL_GPL(rcuref_put_slowpath);

