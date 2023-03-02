Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E246A78DD
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 02:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCBB3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 20:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBB3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 20:29:30 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAAA125B5;
        Wed,  1 Mar 2023 17:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=m7RPuRziDCEkJcvhfL0c7LtBMVDaohLufLdFGJ0pcsg=; b=mb8/AX2vPqyr0IHaqWyZRJu5LT
        2vcZMvSPJ+Krvr0+hJ2pJMIkXayb+DcFeTWQBFXraWbAk6P3XBfYogG4UUDDVWWW321hRueBoVNBd
        l86UvgRmA2bb5qDyLtR1L4ZVbNfIiNa5UowbvdZlXBKunRdqYpg0A4KMozDexDhxkpl7Pj+Vjz6zh
        TFfJh5KVJaGAn93/ceXTxdvC7P10oh8zrrhauaiDu7p0ebN1or1cf6ZIcSfImGb5ie3z/wdT1nhy/
        5CK8xLsVANPv7am67bYOyZX9H3bcrc9nc2VUqJM6PGTPtpSs7hIIO+ZvV5IXG/ChJxT1HrrXynzBs
        bN2pNvWQ==;
Received: from [2601:1c2:980:9ec0::df2f]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pXXl7-000TG4-1j; Thu, 02 Mar 2023 01:29:25 +0000
Message-ID: <0644d4ff-fcc3-7a50-c70e-4248b8341e28@infradead.org>
Date:   Wed, 1 Mar 2023 17:29:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [patch 2/3] atomics: Provide rcuref - scalable reference counting
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linuxfoundation.org>
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
References: <20230228132118.978145284@linutronix.de>
 <20230228132910.991359171@linutronix.de>
 <CAHk-=wjeMbHK61Ee+Ug4w8AGHCSDx94GuLs5bPXhHNhA_+RjzA@mail.gmail.com>
 <87pm9slocp.ffs@tglx> <87bklcklnb.ffs@tglx>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <87bklcklnb.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(typos)

On 3/1/23 17:05, Thomas Gleixner wrote:
> On Wed, Mar 01 2023 at 12:09, Thomas Gleixner wrote:

> ---
> --- /dev/null
> +++ b/include/linux/rcuref.h
> @@ -0,0 +1,155 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _LINUX_RCUREF_H
> +#define _LINUX_RCUREF_H
> +
> +#include <linux/atomic.h>
> +#include <linux/bug.h>
> +#include <linux/limits.h>
> +#include <linux/lockdep.h>
> +#include <linux/preempt.h>
> +#include <linux/rcupdate.h>
> +
> +#define RCUREF_ONEREF		0x00000000U
> +#define RCUREF_MAXREF		0x7FFFFFFFU
> +#define RCUREF_SATURATED	0xA0000000U
> +#define RCUREF_RELEASED		0xC0000000U
> +#define RCUREF_DEAD		0xE0000000U
> +#define RCUREF_NOREF		0xFFFFFFFFU
> +
> +/**
> + * rcuref_init - Initialize a rcuref reference count with the given reference count
> + * @ref:	Pointer to the reference count
> + * @cnt:	The initial reference count typically '1'

		                      count, typically

> + */
> +static inline void rcuref_init(rcuref_t *ref, unsigned int cnt)
> +{
> +	atomic_set(&ref->refcnt, cnt - 1);
> +}
> +

[snip]

> --- /dev/null
> +++ b/lib/rcuref.c
> @@ -0,0 +1,281 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/*
> + * rcuref - A scalable reference count implementation for RCU managed objects
> + *
> + * rcuref is provided to replace open coded reference count implementations
> + * based on atomic_t. It protects explicitely RCU managed objects which can

                                     explicitly

> + * be visible even after the last reference has been dropped and the object
> + * is heading towards destruction.
> + *
> + * A common usage pattern is:
> + *
> + * get()
> + *	rcu_read_lock();
> + *	p = get_ptr();
> + *	if (p && !atomic_inc_not_zero(&p->refcnt))
> + *		p = NULL;
> + *	rcu_read_unlock();
> + *	return p;
> + *
> + * put()
> + *	if (!atomic_dec_return(&->refcnt)) {
> + *		remove_ptr(p);
> + *		kfree_rcu((p, rcu);
> + *	}
> + *
> + * atomic_inc_not_zero() is implemented with a try_cmpxchg() loop which has
> + * O(N^2) behaviour under contention with N concurrent operations.
> + *
> + * rcuref uses atomic_add_negative_relaxed() for the fast path, which scales
> + * better under contention.
> + *
> + * Why not refcount?
> + * =================
> + *
> + * In principle it should be possible to make refcount use the rcuref
> + * scheme, but the destruction race described below cannot be prevented
> + * unless the protected object is RCU managed.
> + *
> + * Theory of operation
> + * ===================
> + *
> + * rcuref uses an unsigned integer reference counter. As long as the
> + * counter value is greater than or equal to RCUREF_ONEREF and not larger
> + * than RCUREF_MAXREF the reference is alive:
> + *
> + * ONEREF   MAXREF               SATURATED             RELEASED      DEAD    NOREF
> + * 0        0x7FFFFFFF 0x8000000 0xA0000000 0xBFFFFFFF 0xC0000000 0xE0000000 0xFFFFFFFF
> + * <---valid --------> <-------saturation zone-------> <-----dead zone----->
> + *
> + * The get() and put() operations do unconditional increments and
> + * decrements. The result is checked after the operation. This optimizes
> + * for the fast path.
> + *
> + * If the reference count is saturated or dead, then the increments and
> + * decrements are not harmful as the reference count still stays in the
> + * respective zones and is always set back to STATURATED resp. DEAD. The

                                                 SATURATED

> + * zones have room for 2^28 racing operations in each direction, which
> + * makes it practically impossible to escape the zones.
> + *
> + * Once the last reference is dropped the reference count becomes
> + * RCUREF_NOREF which forces rcuref_put() into the slowpath operation. The
> + * slowpath then tries to set the reference count from RCUREF_NOREF to
> + * RCUREF_DEAD via a cmpxchg(). This opens a small window where a
> + * concurrent rcuref_get() can acquire the reference count and bring it
> + * back to RCUREF_ONEREF or even drop the reference again and mark it DEAD.
> + *
> + * If the cmpxchg() succeeds then a concurrent rcuref_get() will result in
> + * DEAD + 1, which is inside the dead zone. If that happens the reference
> + * count is put back to DEAD.
> + *
> + * The actual race is possible due to the unconditional increment and
> + * decrements in rcuref_get() and rcuref_put():
> + *
> + *	T1				T2
> + *	get()				put()
> + *					if (atomic_add_negative(1, &ref->refcnt))
> + *		succeeds->			atomic_cmpxchg(&ref->refcnt, -1, DEAD);
> + *
> + *	atomic_add_negative(1, &ref->refcnt);	<- Elevates refcount to DEAD + 1
> + *
> + * As the result of T1's add is negative, the get() goes into the slow path
> + * and observes refcnt being in the dead zone which makes the operation fail.
> + *
> + * Possible critical states:
> + *
> + *	Context Counter	References	Operation
> + *	T1	0	1		init()
> + *	T2	1	2		get()
> + *	T1	0	1		put()
> + *	T2     -1	0		put() tries to mark dead
> + *	T1	0	1		get()
> + *	T2	0	1		put() mark dead fails
> + *	T1     -1	0		put() tries to mark dead
> + *	T1    DEAD	0		put() mark dead succeeds
> + *	T2    DEAD+1	0		get() fails and puts it back to DEAD
> + *
> + * Of course there are more complex scenarios, but the above illustrates
> + * the working principle. The rest is left to the imagination of the
> + * reader.
> + *
> + * Deconstruction race
> + * ===================
> + *
> + * The release operation must be protected by prohibiting a grace period in
> + * order to prevent a possible use after free:
> + *
> + *	T1				T2
> + *	put()				get()
> + *	// ref->refcnt = ONEREF
> + *	if (atomic_add_negative(-1, &ref->cnt))
> + *		return false;				<- Not taken
> + *
> + *	// ref->refcnt == NOREF
> + *	--> preemption
> + *					// Elevates ref->c to ONEREF
> + *					if (!atomic_add_negative(1, &ref->refcnt))
> + *						return true;			<- taken
> + *
> + *					if (put(&p->ref)) { <-- Succeeds
> + *						remove_pointer(p);
> + *						kfree_rcu(p, rcu);
> + *					}
> + *
> + *		RCU grace period ends, object is freed
> + *
> + *	atomic_cmpxchg(&ref->refcnt, NONE, DEAD);	<- UAF
> + *
> + * This is prevented by disabling preemption around the put() operation as
> + * that's in most kernel configurations cheaper than a rcu_read_lock() /
> + * rcu_read_unlock() pair and in many cases even a NOOP. In any case it
> + * prevents the grace period which keeps the object alive until all put()
> + * operations complete.
> + *
> + * Saturation protection
> + * =====================
> + *
> + * The reference count has a saturation limit RCUREF_MAXREF (INT_MAX).
> + * Once this is exceedded the reference count becomes stale by setting it

                   exceeded

> + * to RCUREF_SATURATED, which will cause a memory leak, but it prevents
> + * wrap arounds which obviously cause worse problems than a memory

      wraparounds

> + * leak. When saturation is reached a warning is emitted.
> + *
> + * Race conditions
> + * ===============
> + *
> + * All reference count increment/decrement operations are unconditional and
> + * only verified after the fact. This optimizes for the good case and takes
> + * the occasional race vs. a dead or already saturated refcount into
> + * account. The saturation and dead zones are large enough to accomodate

                                                                 accommodate
"accommodate that" or "allow for that".

> + * for that.
> + *
> + * Memory ordering
> + * ===============
> + *
> + * Memory ordering rules are slightly relaxed wrt regular atomic_t functions

Preferably "with respect to".

> + * and provide only what is strictly required for refcounts.
> + *
> + * The increments are fully relaxed; these will not provide ordering. The
> + * rationale is that whatever is used to obtain the object to increase the
> + * reference count on will provide the ordering. For locked data
> + * structures, its the lock acquire, for RCU/lockless data structures its
> + * the dependent load.
> + *
> + * rcuref_get() provides a control dependency ordering future stores which
> + * ensures that the object is not modified when acquiring a reference
> + * fails.
> + *
> + * rcuref_put() provides release order, i.e. all prior loads and stores
> + * will be issued before. It also provides a control dependency ordering
> + * against the subsequent destruction of the object.
> + *
> + * If rcuref_put() successfully dropped the last reference and marked the
> + * object DEAD it also provides acquire ordering.
> + */
> +
> +#include <linux/export.h>
> +#include <linux/rcuref.h>
> +

[snip]

> +/**
> + * rcuref_put_slowpath - Slowpath of __rcuref_put()
> + * @ref:	Pointer to the reference count
> + *
> + * Invoked when the reference count is outside of the valid zone.
> + *
> + * Return:
> + *	True if this was the last reference with no future references
> + *	possible. This signals the caller that it can safely schedule the
> + *	object, which is protected by the reference counter, for
> + *	deconstruction.
> + *
> + *	False if there are still active references or the put() raced
> + *	with a concurrent get()/put() pair. Caller is not allowed to
> + *	deconstruct the protected object.
> + */
> +bool rcuref_put_slowpath(rcuref_t *ref)
> +{
> +	unsigned int cnt = atomic_read(&ref->refcnt);
> +
> +	/* Did this drop the last reference? */
> +	if (likely(cnt == RCUREF_NOREF)) {
> +		/*
> +		 * Carefully try to set the reference count to RCUREF_DEAD.
> +		 *
> +		 * This can fail if a concurrent get() operation has
> +		 * elevated it again or the corresponding put() even marked
> +		 * it dead already. Both are valid situations and do not
> +		 * require a retry. If this fails the caller is not
> +		 * allowed to deconstruct the object.
> +		 */
> +		if (atomic_cmpxchg_release(&ref->refcnt, RCUREF_NOREF, RCUREF_DEAD) != RCUREF_NOREF)
> +			return false;
> +
> +		/*
> +		 * The caller can safely schedule the object for
> +		 * deconstruction. Provide acquire ordering.
> +		 */
> +		smp_acquire__after_ctrl_dep();
> +		return true;
> +	}
> +
> +	/*
> +	 * If the reference count was already in the dead zone, then this
> +	 * put() operation is imbalanced. Warn, put the reference count back to
> +	 * DEAD and tell the caller to not deconstruct the object.
> +	 */
> +	if (WARN_ONCE(cnt >= RCUREF_RELEASED, "rcuref - imbalanced put()")) {
> +		atomic_set(&ref->refcnt, RCUREF_DEAD);
> +		return false;
> +	}
> +
> +	/*
> +	 * Is this a put() operation on a saturated refcount? If so, rRestore the

	                                                             restore

> +	 * mean saturation value and tell the caller to not deconstruct the
> +	 * object.
> +	 */
> +	if (cnt > RCUREF_MAXREF)
> +		atomic_set(&ref->refcnt, RCUREF_SATURATED);
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(rcuref_put_slowpath);


-- 
~Randy
