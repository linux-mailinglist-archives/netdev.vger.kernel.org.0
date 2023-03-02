Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBDF6A78AC
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 02:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCBBFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 20:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBBFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 20:05:50 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D3B5653A;
        Wed,  1 Mar 2023 17:05:47 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677719145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WT7yc/E2V/KiC5MOU4PzgfyIBKhMUvmrBDsXuJLu7uM=;
        b=bXfm538ZWKS5TmR4hRL37BzmJnJhfRAByAqJ1HoiAnPSprC9gIl4t9Ai2Yr1as7J7n/bVe
        61UX4cuk0yNzv1V3+430CGxhSUNKIw6+6y2HkbNzXJ13fLANIVUXiloX7WwN9fZdvG6jWY
        UyKNx/keLjFPfYSz2ERrf65Dunn0HSJtBKFC0pCeQDewjDfKE7lFjSR031Oy9FURxmaAPw
        GeImJdWKGgH3tqfGGNQVWymJcrK5B2wu3RICtLrQWjNY5rZG6fKNZDKPUY+KIB9JSuo7FO
        yzsbmWf2w41qLcLEWYJjomqTpfD8sbk5XZpb7/Acon90Xah2BPPQVXpLAmTN5g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677719145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WT7yc/E2V/KiC5MOU4PzgfyIBKhMUvmrBDsXuJLu7uM=;
        b=ODsHBYdidvneiqhROu/0zcwJjyCYtMCN62yFY87WyhYhjUQjPQ75kK0g2Eh2vTLNi7Lgys
        717lv/Nmbia1VNBg==
To:     Linus Torvalds <torvalds@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch 2/3] atomics: Provide rcuref - scalable reference counting
In-Reply-To: <87pm9slocp.ffs@tglx>
References: <20230228132118.978145284@linutronix.de>
 <20230228132910.991359171@linutronix.de>
 <CAHk-=wjeMbHK61Ee+Ug4w8AGHCSDx94GuLs5bPXhHNhA_+RjzA@mail.gmail.com>
 <87pm9slocp.ffs@tglx>
Date:   Thu, 02 Mar 2023 02:05:44 +0100
Message-ID: <87bklcklnb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01 2023 at 12:09, Thomas Gleixner wrote:
> On Tue, Feb 28 2023 at 16:42, Linus Torvalds wrote:
>> On Tue, Feb 28, 2023 at 6:33=E2=80=AFAM Thomas Gleixner <tglx@linutronix=
.de> wrote:
>> And yes, that may mean that it should have some architecture-specific
>> code (with fallback defaults for the generic case).
>
> Let me stare at that some more.

So I went back to something which I tried first and dumped it because I
couldn't convince myself that it is correct. That first implementation
was actually incorrect as I could not wrap my head around that dead race
UAF problem. I should have revisited it once I got that sorted. Duh!

The result of staring more is:

get():
    6b57:       f0 41 83 45 40 01       lock addl $0x1,0x40(%r13)
    6b5d:       0f 88 cd 00 00 00       js     6c30			// -> slowpath if neg=
ative

    Success

put(), PREEMPT=3Dn or invoked from RCU safe code
     414:	f0 83 47 40 ff       	lock addl $0xffffffff,0x40(%rdi)
     419:	78 06                	js     421			// -> slowpath if negative

    not last reference (fast path)

put(), PREEMPT=3Dy:

     574:	65 ff 05 00 00 00 00 	incl   %gs:0x0(%rip)		// preempt_disable()
     57b:	f0 83 47 40 ff       	lock addl $0xffffffff,0x40(%rdi)
     580:	0f 98 c0             	sets   %al			// safe result
     583:	78 2b                	js     5b0			// -> slowpath if negative
     585:	65 ff 0d 00 00 00 00 	decl   %gs:0x0(%rip)        	// preempt_ena=
ble()
     58c:	74 1b                	je     5a9			// -> preempt_schedule()
     58e:	84 c0                	test   %al,%al			// The actual result check=
ed
     590:	75 06                	jne    598			// -> destruct object

    not last reference

The current code looks like this:

get():

    63b4:       41 8b 47 40             mov    0x40(%r15),%eax          // =
initial read
    63b8:       85 c0                   test   %eax,%eax	        // check f=
or 0
    63ba:       0f 84 e9 00 00 00       je     64a9			// fail if 0
    63c0:       8d 50 01                lea    0x1(%rax),%edx		// + 1
    63c3:       f0 41 0f b1 57 40       lock cmpxchg %edx,0x40(%r15)	// try=
 update
    63c9:       0f 94 44 24 07          sete   0x7(%rsp)		// store result
    63ce:       0f b6 4c 24 07          movzbl 0x7(%rsp),%ecx		// read it b=
ack !?!
    63d3:       84 c9                   test   %cl,%cl			// test for success
    63d5:       74 e1                   je     63b8			// repeat on fail

    Success

put(), w/o sanity checking:

     29a:	b8 ff ff ff ff          mov    $0xffffffff,%eax		// -1
     29f:	f0 0f c1 47 40          lock xadd %eax,0x40(%rdi)	// add
     2a4:	83 f8 01                cmp    $0x1,%eax		// check old =3D=3D 1
     2a7:	74 05                   je     2ae			// slowpath destroy object

    Not last reference=20

but the actual network code does some sanity checking:

     29a:	41 55                   push   %r13			// extra push
     29c:	b9 ff ff ff ff          mov    $0xffffffff,%ecx		// -1
     2a1:	41 54                   push   %r12			// extra push
     2a3:	49 89 fc                mov    %rdi,%r12		// extra save RDI
     2a6:	f0 0f c1 4f 40          lock xadd %ecx,0x40(%rdi)	// add
     2ab:	83 e9 01                sub    $0x1,%ecx		// new =3D old - 1
     2ae:	41 89 cd                mov    %ecx,%r13d		// extra save
     2b1:	78 24                   js     2d7			// slowpath underrun
     2b3:	74 09                   je     2be			// slowpath destroy object
     2b5:	41 5c                   pop    %r12			// extra pop
     2b7:	41 5d                   pop    %r13			// extra pop
     2b9:	e9 00 00 00 00          jmpq   2be			// not last reference (fast =
path)

Awesome, right?

I also thought about the newfangled CMPccXADD instruction. That will
need some macro wrappery to handle the alternative and it get's rid of
the dead race in put(). There will be some ugly involved, but I'm sure
that this can be handled halfways sanely in common code.

All the ugly will be in the slowpath, which will still be there to
provide saturation and UAF detection/mitigation. The fast path will grow
in size as CMPccXADD is not one of the slim size instructions, but the
basic operating principle will still work out.

See the reworked patch below. This needs some atomic-fallback changes to
build. I force pushed the complete lot to:

  git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git rcuref

in case you want the full picture.

The main change is how the zones are defined. They are off by one
now. I'm glad I kept the defines of the initial version around. :)

The pathological test case showed a slight improvement in a quick test,
but I'm way too tired to say anything conclusive right now,

Thanks for nudging me!

        tglx
---
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
+ * rcuref_init - Initialize a rcuref reference count with the given refere=
nce count
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
+	unsigned int c =3D atomic_read(&ref->refcnt);
+
+	/* Return 0 if within the DEAD zone. */
+	return c >=3D RCUREF_RELEASED ? 0 : c + 1;
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
+ * object memory to be stable (RCU, etc.). It does provide a control depen=
dency
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
+ * rcuref_put_rcusafe -- Release one reference for a rcuref reference coun=
t RCU safe
+ * @ref:	Pointer to the reference count
+ *
+ * Provides release memory ordering, such that prior loads and stores are =
done
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
+ * Provides release memory ordering, such that prior loads and stores are =
done
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
+	released =3D __rcuref_put(ref);
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
=20
+typedef struct {
+	atomic_t refcnt;
+} rcuref_t;
+
+#define RCUREF_INIT(i)	{ .refcnt =3D ATOMIC_INIT(i - 1) }
+
 struct list_head {
 	struct list_head *next, *prev;
 };
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -47,7 +47,7 @@ obj-y +=3D bcd.o sort.o parser.o debug_loc
 	 list_sort.o uuid.o iov_iter.o clz_ctz.o \
 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o rhashtable.o base64.o \
-	 once.o refcount.o usercopy.o errseq.o bucket_locks.o \
+	 once.o refcount.o rcuref.o usercopy.o errseq.o bucket_locks.o \
 	 generic-radix-tree.o
 obj-$(CONFIG_STRING_SELFTEST) +=3D test_string.o
 obj-y +=3D string_helpers.o
--- /dev/null
+++ b/lib/rcuref.c
@@ -0,0 +1,281 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * rcuref - A scalable reference count implementation for RCU managed obje=
cts
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
+ *	p =3D get_ptr();
+ *	if (p && !atomic_inc_not_zero(&p->refcnt))
+ *		p =3D NULL;
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
+ * rcuref uses atomic_add_negative_relaxed() for the fast path, which scal=
es
+ * better under contention.
+ *
+ * Why not refcount?
+ * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ *
+ * In principle it should be possible to make refcount use the rcuref
+ * scheme, but the destruction race described below cannot be prevented
+ * unless the protected object is RCU managed.
+ *
+ * Theory of operation
+ * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ *
+ * rcuref uses an unsigned integer reference counter. As long as the
+ * counter value is greater than or equal to RCUREF_ONEREF and not larger
+ * than RCUREF_MAXREF the reference is alive:
+ *
+ * ONEREF   MAXREF               SATURATED             RELEASED      DEAD =
   NOREF
+ * 0        0x7FFFFFFF 0x8000000 0xA0000000 0xBFFFFFFF 0xC0000000 0xE00000=
00 0xFFFFFFFF
+ * <---valid --------> <-------saturation zone-------> <-----dead zone----=
->
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
+ * and observes refcnt being in the dead zone which makes the operation fa=
il.
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
+ * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ *
+ * The release operation must be protected by prohibiting a grace period in
+ * order to prevent a possible use after free:
+ *
+ *	T1				T2
+ *	put()				get()
+ *	// ref->refcnt =3D ONEREF
+ *	if (atomic_add_negative(-1, &ref->cnt))
+ *		return false;				<- Not taken
+ *
+ *	// ref->refcnt =3D=3D NOREF
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
+ * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ *
+ * The reference count has a saturation limit RCUREF_MAXREF (INT_MAX).
+ * Once this is exceedded the reference count becomes stale by setting it
+ * to RCUREF_SATURATED, which will cause a memory leak, but it prevents
+ * wrap arounds which obviously cause worse problems than a memory
+ * leak. When saturation is reached a warning is emitted.
+ *
+ * Race conditions
+ * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ *
+ * All reference count increment/decrement operations are unconditional and
+ * only verified after the fact. This optimizes for the good case and takes
+ * the occasional race vs. a dead or already saturated refcount into
+ * account. The saturation and dead zones are large enough to accomodate
+ * for that.
+ *
+ * Memory ordering
+ * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ *
+ * Memory ordering rules are slightly relaxed wrt regular atomic_t functio=
ns
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
+	unsigned int cnt =3D atomic_read(&ref->refcnt);
+
+	/*
+	 * If the reference count was already marked dead, undo the
+	 * increment so it stays in the middle of the dead zone and return
+	 * fail.
+	 */
+	if (cnt >=3D RCUREF_RELEASED) {
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
+	unsigned int cnt =3D atomic_read(&ref->refcnt);
+
+	/* Did this drop the last reference? */
+	if (likely(cnt =3D=3D RCUREF_NOREF)) {
+		/*
+		 * Carefully try to set the reference count to RCUREF_DEAD.
+		 *
+		 * This can fail if a concurrent get() operation has
+		 * elevated it again or the corresponding put() even marked
+		 * it dead already. Both are valid situations and do not
+		 * require a retry. If this fails the caller is not
+		 * allowed to deconstruct the object.
+		 */
+		if (atomic_cmpxchg_release(&ref->refcnt, RCUREF_NOREF, RCUREF_DEAD) !=3D=
 RCUREF_NOREF)
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
+	if (WARN_ONCE(cnt >=3D RCUREF_RELEASED, "rcuref - imbalanced put()")) {
+		atomic_set(&ref->refcnt, RCUREF_DEAD);
+		return false;
+	}
+
+	/*
+	 * Is this a put() operation on a saturated refcount? If so, rRestore the
+	 * mean saturation value and tell the caller to not deconstruct the
+	 * object.
+	 */
+	if (cnt > RCUREF_MAXREF)
+		atomic_set(&ref->refcnt, RCUREF_SATURATED);
+	return false;
+}
+EXPORT_SYMBOL_GPL(rcuref_put_slowpath);



