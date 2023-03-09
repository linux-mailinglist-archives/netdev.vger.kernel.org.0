Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DC06B1E57
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 09:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjCIIhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 03:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjCIIhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 03:37:22 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E99C35B9;
        Thu,  9 Mar 2023 00:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678350944; x=1709886944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Z03IcnWFGG3Wb0J5NQK1cXbN7py7d13W/RrstUIkXrs=;
  b=ew+MP6kzZZBdZiiOwnLjS2IHecmQBBoECKKMfe79BgLpXRHLy0Ir0l6l
   8VJYjX1LPBEhZeGiyWRE7cjjFkLrCJshIo4nx+i7Vk1HSr2Y7fCbrcc92
   7lhPRXCBNo82H3a74XSzIy7bh8iThh9Z5bfRtD7VzuBpQI97wc1TKa7QT
   Ew1aXQLP3LP3fF83nNlNcDLbv2J6A0JaH2HMyp8LeJLzPYRRNCnlNGHyk
   e/Unp/Rj9oTKqz75ILfl6lxuiqP3RQhOipDiTsqprIfe22Mu4JgUCbnNC
   bfyUs/vCkTDEgXTYPCw4EUEi2xcTka7z1XbNT2tlAplzCwNoezyOkJeS4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="316782699"
X-IronPort-AV: E=Sophos;i="5.98,245,1673942400"; 
   d="scan'208";a="316782699"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 00:35:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="654668877"
X-IronPort-AV: E=Sophos;i="5.98,245,1673942400"; 
   d="scan'208";a="654668877"
Received: from qiuxu-clx.sh.intel.com ([10.239.53.105])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 00:35:28 -0800
From:   Qiuxu Zhuo <qiuxu.zhuo@intel.com>
To:     tglx@linutronix.de
Cc:     arjan.van.de.ven@intel.com, arjan@linux.intel.com,
        boqun.feng@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, maz@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, peterz@infradead.org,
        torvalds@linuxfoundation.org, wangyang.guo@intel.com,
        will@kernel.org, x86@kernel.org
Subject: Re: [patch V2 3/4] atomics: Provide rcuref - scalable reference counting
Date:   Thu,  9 Mar 2023 16:35:23 +0800
Message-Id: <20230309083523.66592-1-qiuxu.zhuo@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230307125538.932671660@linutronix.de>
References: <20230307125538.932671660@linutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

Some comments on the comments.
If I'm wrong, please correct me ;-).

> From: Thomas Gleixner <tglx@linutronix.de>
> To: LKML <linux-kernel@vger.kernel.org>
> Cc: Linus Torvalds <torvalds@linuxfoundation.org>,
> 	x86@kernel.org, Wangyang Guo <wangyang.guo@intel.com>,
> 	Arjan van De Ven <arjan@linux.intel.com>,
> 	"David S. Miller" <davem@davemloft.net>,
> 	Eric Dumazet <edumazet@google.com>,
> 	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
> 	netdev@vger.kernel.org, Will Deacon <will@kernel.org>,
> 	Peter Zijlstra <peterz@infradead.org>,
> 	Boqun Feng <boqun.feng@gmail.com>,
> 	Mark Rutland <mark.rutland@arm.com>,
> 	Marc Zyngier <maz@kernel.org>,
> 	Arjan Van De Ven <arjan.van.de.ven@intel.com>
> Subject: [patch V2 3/4] atomics: Provide rcuref - scalable reference counting
> 
> atomic_t based reference counting, including refcount_t, uses
> atomic_inc_not_zero() for acquiring a reference. atomic_inc_not_zero() is
> implemented with a atomic_try_cmpxchg() loop. High contention of the
> reference count leads to retry loops and scales badly. There is nothing to
> improve on this implementation as the semantics have to be preserved.
> 
> Provide rcuref as a scalable alternative solution which is suitable for RCU
> managed objects. Similar to refcount_t it comes with overflow and underflow
> detection and mitigation.
> 
> rcuref treats the underlying atomic_t as an unsigned integer and partitions
> this space into zones:
> 
>   0x00000000 - 0x7FFFFFFF	valid zone (1 .. INT_MAX references)

From the point of rcuref_read()'s view:
0x00000000 encodes 1, ...,  then 0x7FFFFFFF should encode INT_MAX + 1 references.

>   0x80000000 - 0xBFFFFFFF	saturation zone
>   0xC0000000 - 0xFFFFFFFE	dead zone
>   0xFFFFFFFF   			no reference
> 
> rcuref_get() unconditionally increments the reference count with
> atomic_add_negative_relaxed(). rcuref_put() unconditionally decrements the
> reference count with atomic_add_negative_release().
> 
> This unconditional increment avoids the inc_not_zero() problem, but
> requires a more complex implementation on the put() side when the count
> drops from 0 to -1.
> 
> When this transition is detected then it is attempted to mark the reference
> count dead, by setting it to the midpoint of the dead zone with a single
> atomic_cmpxchg_release() operation. This operation can fail due to a
> concurrent rcuref_get() elevating the reference count from -1 to 0 again.
> 
> If the unconditional increment in rcuref_get() hits a reference count which
> is marked dead (or saturated) it will detect it after the fact and bring
> back the reference count to the midpoint of the respective zone. The zones
> provide enough tolerance which makes it practically impossible to escape
> from a zone.

[...]

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

For T2 put() here:
"if (atomic_add_negative(1, &ref->refcnt))" ->
"if (atomic_add_negative(-1, &ref->refcnt))"

> + *		succeeds->			atomic_cmpxchg(&ref->refcnt, -1, DEAD);

Is it more readable if 's/-1/NODEF/g' ?

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

For T1 put() here:
"if (atomic_add_negative(-1, &ref->cnt))" ->
"if (!atomic_add_negative(-1, &ref->cnt))"

> + *		return false;				<- Not taken
> + *
> + *	// ref->refcnt == NOREF
> + *	--> preemption
> + *					// Elevates ref->c to ONEREF

s/ref->c/ref->refcnt/g

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

s/NONE/NOREF/g

[...]
