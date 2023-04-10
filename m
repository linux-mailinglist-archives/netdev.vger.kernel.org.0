Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B896DCDB0
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 00:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjDJWx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 18:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjDJWxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 18:53:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5861FED;
        Mon, 10 Apr 2023 15:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCDA961F27;
        Mon, 10 Apr 2023 22:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3013DC433EF;
        Mon, 10 Apr 2023 22:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681167224;
        bh=PBq6Pho8K6a+RvufYUks/PO6mSqnNledF7opKlNbT/U=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Gfo+N7R09DMPn0NoZNP8fZjGZ9jzR/hYhy/qendafaMlbLU4UzE9tIsFpidGp2Jxd
         3e1T1oTJYNkt4ZWvBKFNA8RHBK8PHtb+S7YoP+BxoFXHsZLWB/Seel0GwMEoDJ7S3E
         fJctC1ib0kPRDW7xEgutKslxEjraWQw1OspbOt5bxUIY83gF6864llfXcgCVnbJLFj
         OXARTmDtBnPn+73n/W5JkgC4jY0x9p9dR0hrIxipKK3MFt69WeiL8yETxEwBJVDSCw
         mQXNqOG+t+iYwvTJ9LxsM9/HSoFMtAaHDom5jlQJIAe7q8s22m1quegL2mkivU3P+e
         E/ZUI2LhJtTIA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id C2C931540478; Mon, 10 Apr 2023 15:53:43 -0700 (PDT)
Date:   Mon, 10 Apr 2023 15:53:43 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
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
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [patch V3 0/4] net, refcount: Address dst_entry reference count
 scalability issues
Message-ID: <bf0816ba-4143-46fe-88b1-46010bc14117@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20230323102649.764958589@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323102649.764958589@linutronix.de>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 09:55:27PM +0100, Thomas Gleixner wrote:
> Hi!
> 
> This is version 3 of this series. Version 2 can be found here:
> 
>      https://lore.kernel.org/lkml/20230307125358.772287565@linutronix.de
> 
> Wangyang and Arjan reported a bottleneck in the networking code related to
> struct dst_entry::__refcnt. Performance tanks massively when concurrency on
> a dst_entry increases.
> 
> This happens when there are a large amount of connections to or from the
> same IP address. The memtier benchmark when run on the same host as
> memcached amplifies this massively. But even over real network connections
> this issue can be observed at an obviously smaller scale (due to the
> network bandwith limitations in my setup, i.e. 1Gb). How to reproduce:
> 
>   Run memcached with -t $N and memtier_benchmark with -t $M and --ratio=1:100
>   on the same machine. localhost connections amplify the problem.
> 
>   Start with the defaults for $N and $M and increase them. Depending on
>   your machine this will tank at some point. But even in reasonably small
>   $N, $M scenarios the refcount operations and the resulting false sharing
>   fallout becomes visible in perf top. At some point it becomes the
>   dominating issue.
> 
> There are two factors which make this reference count a scalability issue:
> 
>    1) False sharing
> 
>       dst_entry:__refcnt is located at offset 64 of dst_entry, which puts
>       it into a seperate cacheline vs. the read mostly members located at
>       the beginning of the struct.
> 
>       That prevents false sharing vs. the struct members in the first 64
>       bytes of the structure, but there is also
> 
>       	    dst_entry::lwtstate
> 
>       which is located after the reference count and in the same cache
>       line. This member is read after a reference count has been acquired.
> 
>       The other problem is struct rtable, which embeds a struct dst_entry
>       at offset 0. struct dst_entry has a size of 112 bytes, which means
>       that the struct members of rtable which follow the dst member share
>       the same cache line as dst_entry::__refcnt. Especially
> 
>       	  rtable::rt_genid
> 
>       is also read by the contexts which have a reference count acquired
>       already.
> 
>       When dst_entry:__refcnt is incremented or decremented via an atomic
>       operation these read accesses stall and contribute to the performance
>       problem.
> 
>    2) atomic_inc_not_zero()
> 
>       A reference on dst_entry:__refcnt is acquired via
>       atomic_inc_not_zero() and released via atomic_dec_return().
> 
>       atomic_inc_not_zero() is implemted via a atomic_try_cmpxchg() loop,
>       which exposes O(N^2) behaviour under contention with N concurrent
>       operations. Contention scalability is degrading with even a small
>       amount of contenders and gets worse from there.
> 
>       Lightweight instrumentation exposed an average of 8!! retry loops per
>       atomic_inc_not_zero() invocation in a inc()/dec() loop running
>       concurrently on 112 CPUs.

Huh.  8 is pretty bad, 8! far worse, but 8!!?  3.4e168186???

(Sorry, couldn't resist...)

>       There is nothing which can be done to make atomic_inc_not_zero() more
>       scalable.
> 
> The following series addresses these issues:
> 
>     1) Reorder and pad struct dst_entry to prevent the false sharing.
> 
>     2) Implement and use a reference count implementation which avoids the
>        atomic_inc_not_zero() problem.
> 
>        It is slightly less performant in the case of the final 0 -> -1
>        transition, but the deconstruction of these objects is a low
>        frequency event. get()/put() pairs are in the hotpath and that's
>        what this implementation optimizes for.
> 
>        The algorithm of this reference count is only suitable for RCU
>        managed objects. Therefore it cannot replace the refcount_t
>        algorithm, which is also based on atomic_inc_not_zero(), due to a
>        subtle race condition related to the 0 -> -1 transition and the final
>        verdict to mark the reference count dead. See details in patch 2/3.
> 
>        It might be just my lack of imagination which declares this to be
>        impossible and I'd be happy to be proven wrong.

It is possible to make something like rcuref_get that does only a
READ_ONCE(), WRITE_ONCE() to storage local to the task, smp_mb(),
READ_ONCE() and compare in the common case.  There would be something
like rcuref_put() that did an smp_store_release() to the same storage
local to the task.

Of course, there is always a catch, and here there are several:

1.	Instead of just returning a pointer to a struct dst_entry,
	sk_dst_get() would need to hand back both that pointer along
	with a pointer to the aforementioned storage local to the task.

2.	A generally useful implementation would require the counterpart
	to rcuref_get() to sometimes allocate memory.  Failure to allocate
	memory would imply failure to gain a reference.

3.	The structure would not need to be RCU-freed, but it still
	would need to be freed specially.  (All of the non-NULL
	locations in all the storage local to the tasks needs to be
	checked, but batching optimizations work well here.)

4.	The smp_mb() compares well to the atomic_add_negative_relaxed(),
	but getting rid of that smp_mb() either adds more RCU-like delays
	on the free path on the one hand, or requires IPIs on the free
	path on the other.

5.	The aforementioned storage local to the task could instead be
	local to the CPU, but at the expense of some put-side cache
	misses and possible false sharing in the case where rcuref_get()
	runs on one CPU and rcuref_put() runs on another.  Of course,
	the current rcuref_put() gets that already due to the use of
	atomic_add_negative_release() on shared memory, so perhaps not
	a big deal.

Not sure it is worth it, but you did ask!

If this does turn out to be an attractive option, please let me know.

							Thanx, Paul

>        As a bonus the new rcuref implementation provides underflow/overflow
>        detection and mitigation while being performance wise on par with
>        open coded atomic_inc_not_zero() / atomic_dec_return() pairs even in
>        the non-contended case.
> 
> The combination of these two changes results in performance gains in micro
> benchmarks and also localhost and networked memtier benchmarks talking to
> memcached. It's hard to quantify the benchmark results as they depend
> heavily on the micro-architecture and the number of concurrent operations.
> 
> The overall gain of both changes for localhost memtier ranges from 1.2X to
> 3.2X and from +2% to %5% range for networked operations on a 1Gb connection.
> 
> A micro benchmark which enforces maximized concurrency shows a gain between
> 1.2X and 4.7X!!!
> 
> Obviously this is focussed on a particular problem and therefore needs to
> be discussed in detail. It also requires wider testing outside of the cases
> which this is focussed on.
> 
> Though the false sharing issue is obvious and should be addressed
> independent of the more focussed reference count changes.
> 
> The series is also available from git:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git rcuref
> 
> Changes vs. V2:
> 
>   - Rename __refcnt to __rcuref (Linus)
> 
>   - Fix comments and changelogs (Mark, Qiuxu)
> 
>   - Fixup kernel doc of generated atomic_add_negative() variants
> 
> I want to say thanks to Wangyang who analyzed the issue and provided the
> initial fix for the false sharing problem. Further thanks go to Arjan
> Peter, Marc, Will and Borislav for valuable input and providing test
> results on machines which I do not have access to, and to Linus and
> Eric, Qiuxu and Mark for helpful feedback.
> 
> Thanks,
> 
> 	tglx
> 
