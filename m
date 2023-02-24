Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E916A21BA
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBXStw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBXStv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:49:51 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AC76A7A6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:49:49 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pVd8c-0007pZ-34; Fri, 24 Feb 2023 19:49:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shakeelb@google.com, soheil@google.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net] net: avoid indirect memory pressure calls
Date:   Fri, 24 Feb 2023 19:46:06 +0100
Message-Id: <20230224184606.7101-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a noticeable tcp performance regression (loopback or cross-netns),
seen with iperf3 -Z (sendfile mode) when generic retpolines are needed.

With SK_RECLAIM_THRESHOLD checks gone number of calls to enter/leave
memory pressure happen much more often. For TCP indirect calls are
used.

We can't remove the if-set-return short-circuit check in
tcp_enter_memory_pressure because there are callers other than
sk_enter_memory_pressure.  Doing a check in the sk wrapper too
reduces the indirect calls enough to recover some performance.

Before,
0.00-60.00  sec   322 GBytes  46.1 Gbits/sec                  receiver

After:
0.00-60.04  sec   359 GBytes  51.4 Gbits/sec                  receiver

"iperf3 -c $peer -t 60 -Z -f g", connected via veth in another netns.

Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/core/sock.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 341c565dbc26..45d247112aa5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2809,22 +2809,26 @@ EXPORT_SYMBOL(sock_cmsg_send);
 
 static void sk_enter_memory_pressure(struct sock *sk)
 {
-	if (!sk->sk_prot->enter_memory_pressure)
+	unsigned long *memory_pressure = sk->sk_prot->memory_pressure;
+
+	if (!memory_pressure || READ_ONCE(*memory_pressure))
 		return;
 
-	sk->sk_prot->enter_memory_pressure(sk);
+	if (sk->sk_prot->enter_memory_pressure)
+		sk->sk_prot->enter_memory_pressure(sk);
 }
 
 static void sk_leave_memory_pressure(struct sock *sk)
 {
-	if (sk->sk_prot->leave_memory_pressure) {
-		sk->sk_prot->leave_memory_pressure(sk);
-	} else {
-		unsigned long *memory_pressure = sk->sk_prot->memory_pressure;
+	unsigned long *memory_pressure = sk->sk_prot->memory_pressure;
 
-		if (memory_pressure && READ_ONCE(*memory_pressure))
-			WRITE_ONCE(*memory_pressure, 0);
-	}
+	if (!memory_pressure || READ_ONCE(*memory_pressure) == 0)
+		return;
+
+	if (sk->sk_prot->leave_memory_pressure)
+		sk->sk_prot->leave_memory_pressure(sk);
+	else
+		WRITE_ONCE(*memory_pressure, 0);
 }
 
 DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
-- 
2.39.2

