Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC04E6A5ADD
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 15:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjB1Odc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 09:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjB1Oda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 09:33:30 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E7AF755;
        Tue, 28 Feb 2023 06:33:28 -0800 (PST)
Message-ID: <20230228132910.934296889@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677594807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=164HU9inGaDSStz20kDbBC51Xj3hrcXjyamsooLd+5g=;
        b=i/JOnT2AKbM7BC9p9Q1bE+9kdzNuT9zADvs8sRa0yxUg4BHyvMmjDf0TsL3S9kfTJJ9Rhm
        /4ddfUHSBqHHwfcL3CwSYWZPKqS6dpFg8MmvWVN0B1aQ/5+Em2gn2Fk9dZxBoGV1C6PvaN
        ajTPa8brDAjcv79DeIM4ZXaJkAcqcU8Lb6UYA1fFkRBTyPj8Rg/+4Q4FzG2RialEYCv0jW
        EFHjJOWKhh9GC1f/OdtRaw6lA85mv9atBfGFiY/hh3rZnhMaZnbYZtscLeBiG3kO72XSXG
        coaZgRtrZo/23+7EXKYcw+sGnptVB9TTld4wZ3oMdpPTs7Zvvm11yBjGi7npzg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677594807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=164HU9inGaDSStz20kDbBC51Xj3hrcXjyamsooLd+5g=;
        b=DcfZ7D0xyV3ezgSoUkW+DvoTF83VWC4wcoRRY6eQ5PHaotzI1Vkc+0xDrwPBY9i1wSg6SR
        O4il+nVOdAmdyVAg==
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
Subject: [patch 1/3] net: dst: Prevent false sharing vs. dst_entry::__refcnt
References: <20230228132118.978145284@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 28 Feb 2023 15:33:26 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wangyang Guo <wangyang.guo@intel.com>

dst_entry::__refcnt is highly contended in scenarios where many connections
happen from and to the same IP. The reference count is an atomic_t, so the
reference count operations have to take the cache-line exclusive.

Aside of the unavoidable reference count contention there is another
significant problem which is caused by that: False sharing.

perf top identified two affected read accesses. dst_entry::lwtstate and
rtable::rt_genid.

dst_entry:__refcnt is located at offset 64 of dst_entry, which puts it into
a seperate cacheline vs. the read mostly members located at the beginning
of the struct.

That prevents false sharing vs. the struct members in the first 64
bytes of the structure, but there is also

     dst_entry::lwtstate

which is located after the reference count and in the same cache line. This
member is read after a reference count has been acquired.

struct rtable embeds a struct dst_entry at offset 0. struct dst_entry has a
size of 112 bytes, which means that the struct members of rtable which
follow the dst member share the same cache line as dst_entry::__refcnt.
Especially

      	  rtable::rt_genid

is also read by the contexts which have a reference count acquired
already.

When dst_entry:__refcnt is incremented or decremented via an atomic
operation these read accesses stall.

This was found when analysing the memtier benchmark in 1:100 mode, which
amplifies the problem extremly.

Rearrange and pad the structure so that the lwtstate member is in the next
cache-line. This increases the struct size from 112 to 136 bytes on 64bit.

The resulting improvement depends on the micro-architecture and the number
of CPUs. It ranges from +20% to +120% with a localhost memtier/memcached
benchmark.

[ tglx: Rearrange struct ]

Signed-off-by: Wangyang Guo <wangyang.guo@intel.com>
Signed-off-by: Arjan van De Ven <arjan@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
---
 include/net/dst.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -69,15 +69,25 @@ struct dst_entry {
 #endif
 	int			__use;
 	unsigned long		lastuse;
-	struct lwtunnel_state   *lwtstate;
 	struct rcu_head		rcu_head;
 	short			error;
 	short			__pad;
 	__u32			tclassid;
 #ifndef CONFIG_64BIT
+	struct lwtunnel_state   *lwtstate;
 	atomic_t		__refcnt;	/* 32-bit offset 64 */
 #endif
 	netdevice_tracker	dev_tracker;
+#ifdef CONFIG_64BIT
+	/*
+	 * Ensure that lwtstate is not in the same cache line as __refcnt,
+	 * because that would lead to false sharing under high contention
+	 * of __refcnt. This also ensures that rtable::rt_genid is not
+	 * sharing the same cache-line.
+	 */
+	int			pad2[6];
+	struct lwtunnel_state   *lwtstate;
+#endif
 };
 
 struct dst_metrics {

