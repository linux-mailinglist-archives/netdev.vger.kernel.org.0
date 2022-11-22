Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553516331C9
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 02:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbiKVBEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 20:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKVBE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 20:04:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E04911A12;
        Mon, 21 Nov 2022 17:04:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B273B818DF;
        Tue, 22 Nov 2022 01:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA9BC4315E;
        Tue, 22 Nov 2022 01:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669079063;
        bh=82QgUkdn96zAlaY+UFpNNtcTMhQgVxk6sdFaelyo3zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oj2o0MV7bWppKYphpTZpnE345/Ekq1qeCL51DEXRnLTr9ODMUfEY6Po0mW1vDwE0N
         ZKt1Nr856cCvvre9rHNL7oio8FbnDnddN3xQDc/PpWXjmQUzB9Bbo4807N7jvKa+AX
         87o4Tj/mVIAeC27B9POj/7hSsfsa5wE9QYk4sIycuuSeBgVhHY6Yc/Graw+BLBgdYe
         o8jkA8DFvGrnVI0c29rXdES4mjK6TiEOu0d3mqMORsQQgZ4cMEjqKNZT8H6/+6MXxU
         x4aRyTkMoQsvQgE7SOCx0yMQZ8zK5oriDMDd+lM5jCpeuQ8ZGIzm6AtDJsyBNP8HFk
         QSv+x/5jDzJLw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 8CE7F5C18FF; Mon, 21 Nov 2022 17:04:22 -0800 (PST)
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
Subject: [PATCH v2 rcu 15/16] net: Use call_rcu_flush() for dst_release()
Date:   Mon, 21 Nov 2022 17:04:20 -0800
Message-Id: <20221122010421.3799681-15-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20221122010408.GA3799268@paulmck-ThinkPad-P17-Gen-1>
References: <20221122010408.GA3799268@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Therefore, synchronize_rcu() invokes call_rcu_flush() instead of
call_rcu().  The arrival of a non-lazy call_rcu_flush() callback on a
given CPU kicks any lazy callbacks that might be already queued on that
CPU.  After all, if there is going to be a grace period, all callbacks
might as well get full benefit from it.

Yes, this could be done the other way around by creating a
call_rcu_lazy(), but earlier experience with this approach and
feedback at the 2022 Linux Plumbers Conference shifted the approach
to call_rcu() being lazy with call_rcu_flush() for the few places
where laziness is inappropriate.

Returning to the test failure, use of ftrace showed that this failure
cause caused by the aadded delays due to this new lazy behavior of
call_rcu() in kernels built with CONFIG_RCU_LAZY=y.

Therefore, make dst_release() use call_rcu_flush() in order to revert
to the old test-failure-free behavior.

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
index bc9c9be4e0801..15b16322703f4 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -174,7 +174,7 @@ void dst_release(struct dst_entry *dst)
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
 		if (!newrefcnt)
-			call_rcu(&dst->rcu_head, dst_destroy_rcu);
+			call_rcu_flush(&dst->rcu_head, dst_destroy_rcu);
 	}
 }
 EXPORT_SYMBOL(dst_release);
-- 
2.31.1.189.g2e36527f23

