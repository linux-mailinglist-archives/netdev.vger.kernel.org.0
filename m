Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADDA6ADF50
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 13:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCGM5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 07:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCGM5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 07:57:50 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E231276F7A;
        Tue,  7 Mar 2023 04:57:42 -0800 (PST)
Message-ID: <20230307125358.772287565@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1678193861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=70ja+L8pUpBHMFR6s75dIy6IRVw7UVxorVBRMgbRHi0=;
        b=PQlCUc8FyBuQUL1qGgVe5yjq3gbBMxCKduaZA5Zbg5qU1CnFNzX5nfnE0d6CU3D5tGUh3q
        QTINeyhSPnwj792yLFQW9hS3UvRYyVcxHqVXilxBS89b5rE6r9tC0aDECBz5sPQZVN3z5c
        dbaSI1XLO0u2uYEu42bjA7gufLwKsSQ7ngayyjEW7UhqjJD+JWiaL16HHFbsvOs8clRBsa
        CD9rLSQ5VdBGRZcjlqY2b6ZDwds6DZQrYVoyfJnSD83xq9INxlCQ+4NR2DQc58tfa9QOHI
        hTOJpWA65S1KRiMKmhpVX48QQ9+I6+pwB8JFL+9++0kGpjgL+ypvlASX8HoEsA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1678193861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=70ja+L8pUpBHMFR6s75dIy6IRVw7UVxorVBRMgbRHi0=;
        b=9ZZbV6c+Fo5QdmB+LHMNQnEYhwKHmxg89v/yePjTZLYX9roOTEKEWAEuh519G0kM7kFGeX
        xllZHYqf2yxeBdCA==
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
        Marc Zyngier <maz@kernel.org>
Subject: [patch V2 0/4] net, refcount: Address dst_entry reference count
 scalability issues
Date:   Tue,  7 Mar 2023 13:57:40 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This is version 2 of this series. Version 1 can be found here:

     https://lore.kernel.org/lkml/20230228132118.978145284@linutronix.de

Wangyang and Arjan reported a bottleneck in the networking code related to
struct dst_entry::__refcnt. Performance tanks massively when concurrency on
a dst_entry increases.

This happens when there are a large amount of connections to or from the
same IP address. The memtier benchmark when run on the same host as
memcached amplifies this massively. But even over real network connections
this issue can be observed at an obviously smaller scale (due to the
network bandwith limitations in my setup, i.e. 1Gb). How to reproduce:

  Run memcached with -t $N and memtier_benchmark with -t $M and --ratio=1:100
  on the same machine. localhost connections amplify the problem.

  Start with the defaults for $N and $M and increase them. Depending on
  your machine this will tank at some point. But even in reasonably small
  $N, $M scenarios the refcount operations and the resulting false sharing
  fallout becomes visible in perf top. At some point it becomes the
  dominating issue.

There are two factors which make this reference count a scalability issue:

   1) False sharing

      dst_entry:__refcnt is located at offset 64 of dst_entry, which puts
      it into a seperate cacheline vs. the read mostly members located at
      the beginning of the struct.

      That prevents false sharing vs. the struct members in the first 64
      bytes of the structure, but there is also

      	    dst_entry::lwtstate

      which is located after the reference count and in the same cache
      line. This member is read after a reference count has been acquired.

      The other problem is struct rtable, which embeds a struct dst_entry
      at offset 0. struct dst_entry has a size of 112 bytes, which means
      that the struct members of rtable which follow the dst member share
      the same cache line as dst_entry::__refcnt. Especially

      	  rtable::rt_genid

      is also read by the contexts which have a reference count acquired
      already.

      When dst_entry:__refcnt is incremented or decremented via an atomic
      operation these read accesses stall and contribute to the performance
      problem.

   2) atomic_inc_not_zero()

      A reference on dst_entry:__refcnt is acquired via
      atomic_inc_not_zero() and released via atomic_dec_return().

      atomic_inc_not_zero() is implemted via a atomic_try_cmpxchg() loop,
      which exposes O(N^2) behaviour under contention with N concurrent
      operations. Contention scalability is degrading with even a small
      amount of contenders and gets worse from there.

      Lightweight instrumentation exposed an average of 8!! retry loops per
      atomic_inc_not_zero() invocation in a inc()/dec() loop running
      concurrently on 112 CPUs.

      There is nothing which can be done to make atomic_inc_not_zero() more
      scalable.

The following series addresses these issues:

    1) Reorder and pad struct dst_entry to prevent the false sharing.

    2) Implement and use a reference count implementation which avoids the
       atomic_inc_not_zero() problem.

       It is slightly less performant in the case of the final 0 -> -1
       transition, but the deconstruction of these objects is a low
       frequency event. get()/put() pairs are in the hotpath and that's
       what this implementation optimizes for.

       The algorithm of this reference count is only suitable for RCU
       managed objects. Therefore it cannot replace the refcount_t
       algorithm, which is also based on atomic_inc_not_zero(), due to a
       subtle race condition related to the 0 -> -1 transition and the final
       verdict to mark the reference count dead. See details in patch 2/3.

       It might be just my lack of imagination which declares this to be
       impossible and I'd be happy to be proven wrong.

       As a bonus the new rcuref implementation provides underflow/overflow
       detection and mitigation while being performance wise on par with
       open coded atomic_inc_not_zero() / atomic_dec_return() pairs even in
       the non-contended case.

The combination of these two changes results in performance gains in micro
benchmarks and also localhost and networked memtier benchmarks talking to
memcached. It's hard to quantify the benchmark results as they depend
heavily on the micro-architecture and the number of concurrent operations.

The overall gain of both changes for localhost memtier ranges from 1.2X to
3.2X and from +2% to %5% range for networked operations on a 1Gb connection.

A micro benchmark which enforces maximized concurrency shows a gain between
1.2X and 4.7X!!!

Obviously this is focussed on a particular problem and therefore needs to
be discussed in detail. It also requires wider testing outside of the cases
which this is focussed on.

Though the false sharing issue is obvious and should be addressed
independent of the more focussed reference count changes.

The series is also available from git:

  git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git

Changes vs. V1:

  - Move rt[6i]_uncached[_list] into struct dst_entry instead of blindly
    padding. (Eric)

  - Use atomic_add_negative() for rcuref (Linus)

I want to say thanks to Wangyang who analyzed the issue and provided the
initial fix for the false sharing problem. Further thanks go to Arjan
Peter, Marc, Will and Borislav for valuable input and providing test
results on machines which I do not have access to, and to Linus and
Eric for helpful feedback on V1.

Thanks,

	tglx
