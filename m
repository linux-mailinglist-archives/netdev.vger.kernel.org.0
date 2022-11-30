Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7165E63DCD2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiK3SOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiK3SNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:13:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D0E862E7;
        Wed, 30 Nov 2022 10:13:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8630DB81CA1;
        Wed, 30 Nov 2022 18:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2187AC4315A;
        Wed, 30 Nov 2022 18:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669832008;
        bh=tLEwwsXJ50F5WMjv+BokwLjrPrLGPh46UmjaqeJOMNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qn/G0f3uTFbWSF42AqjtciE1KrJdOMt55GTNskCSfXG+ehVdvjQo7PT/4uic/Xzg1
         Wi/E5KetpU6444YTs4tO67fBw4KORpTJ0BKVkR/Z3EMAh6cV20/1KWN/BxoKaOaAAN
         4IPkSER2QT2w1PfvXv0JlBCGSXN2yG7XA0W899GLRdiFLJ5uYDWtNbzwrVYZ5jU9iz
         hauOlXc4XrtNkMQU9gYEnLcdZLg3winmFw/9vpHoo+ESsEjtdGfVEVJ2RCwpQJVQq1
         NwKPlMpxbYYVPJjir5RwdfEOfd2sKQckEBkPR+Stgh/QD3zHNsxWDTgBaOGCX58MaF
         0ukAfUlmoFqgg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 724285C1A02; Wed, 30 Nov 2022 10:13:27 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH rcu 15/16] net: Use call_rcu_hurry() for dst_release()
Date:   Wed, 30 Nov 2022 10:13:24 -0800
Message-Id: <20221130181325.1012760-15-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1>
References: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>

In a networking test on ChromeOS, kernels built with the new
CONFIG_RCU_LAZY=y Kconfig option fail a networking test in the teardown
phase.

This failure may be reproduced as follows: ip netns del <name>

The CONFIG_RCU_LAZY=y Kconfig option was introduced by earlier commits
in this series for the benefit of certain battery-powered systems.
This Kconfig option causes call_rcu() to delay its callbacks in order
to batch them.  This means that a given RCU grace period covers more
callbacks, thus reducing the number of grace periods, in turn reducing
the amount of energy consumed, which increases battery lifetime which
can be a very good thing.  This is not a subtle effect: In some important
use cases, the battery lifetime is increased by more than 10%.

This CONFIG_RCU_LAZY=y option is available only for CPUs that offload
callbacks, for example, CPUs mentioned in the rcu_nocbs kernel boot
parameter passed to kernels built with CONFIG_RCU_NOCB_CPU=y.

Delaying callbacks is normally not a problem because most callbacks do
nothing but free memory.  If the system is short on memory, a shrinker
will kick all currently queued lazy callbacks out of their laziness,
thus freeing their memory in short order.  Similarly, the rcu_barrier()
function, which blocks until all currently queued callbacks are invoked,
will also kick lazy callbacks, thus enabling rcu_barrier() to complete
in a timely manner.

However, there are some cases where laziness is not a good option.
For example, synchronize_rcu() invokes call_rcu(), and blocks until
the newly queued callback is invoked.  It would not be a good for
synchronize_rcu() to block for ten seconds, even on an idle system.
Therefore, synchronize_rcu() invokes call_rcu_hurry() instead of
call_rcu().  The arrival of a non-lazy call_rcu_hurry() callback on a
given CPU kicks any lazy callbacks that might be already queued on that
CPU.  After all, if there is going to be a grace period, all callbacks
might as well get full benefit from it.

Yes, this could be done the other way around by creating a
call_rcu_lazy(), but earlier experience with this approach and
feedback at the 2022 Linux Plumbers Conference shifted the approach
to call_rcu() being lazy with call_rcu_hurry() for the few places
where laziness is inappropriate.

Returning to the test failure, use of ftrace showed that this failure
cause caused by the aadded delays due to this new lazy behavior of
call_rcu() in kernels built with CONFIG_RCU_LAZY=y.

Therefore, make dst_release() use call_rcu_hurry() in order to revert
to the old test-failure-free behavior.

[ paulmck: Apply s/call_rcu_flush/call_rcu_hurry/ feedback from Tejun Heo. ]

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: <netdev@vger.kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 net/core/dst.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index bc9c9be4e0801..a4e738d321ba2 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -174,7 +174,7 @@ void dst_release(struct dst_entry *dst)
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
 		if (!newrefcnt)
-			call_rcu(&dst->rcu_head, dst_destroy_rcu);
+			call_rcu_hurry(&dst->rcu_head, dst_destroy_rcu);
 	}
 }
 EXPORT_SYMBOL(dst_release);
-- 
2.31.1.189.g2e36527f23

