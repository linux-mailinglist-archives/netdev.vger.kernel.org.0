Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA594ED57C
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiCaI0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbiCaI0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:26:40 -0400
Received: from m12-12.163.com (m12-12.163.com [220.181.12.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F412625C8;
        Thu, 31 Mar 2022 01:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=YDQlZ
        qcen5qVjN/uH7qP6dIID2tLa9CyPJjJm8Xi+1A=; b=ebUbVQi4xNCkOw1ANGJtZ
        rdYzLq1jwrWfGDMKBzv5aX0l87dwQ1ZYK3x0PrJeIO10xnJHhi81d27M08F+4kty
        ujIWfQIhx8dCJpfGxITrAx6VPkyNlApHYZwg9im6lzogoCaUptnJy03RejkhJff+
        Rhs4Iz6itDwJrIGw4Bzad4=
Received: from localhost.localdomain (unknown [101.86.107.106])
        by smtp8 (Coremail) with SMTP id DMCowADH+lr1ZEVilGI2AQ--.25548S2;
        Thu, 31 Mar 2022 16:23:18 +0800 (CST)
From:   jackygam2001 <jacky_gam_2001@163.com>
To:     dkirjanov@suse.de
Cc:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, rostedt@goodmis.org, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, yhs@fb.com,
        ping.gan@dell.com, Ping Gan <jacky_gam_2001@163.com>
Subject: [PATCH v2 net-next] tcp: Add tracepoint for tcp_set_ca_state
Date:   Thu, 31 Mar 2022 16:21:49 +0800
Message-Id: <20220331082149.15910-1-jacky_gam_2001@163.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <9f7a92f5-5674-5c9f-e5ec-4a68ec8cb0d1@suse.de>
References: <9f7a92f5-5674-5c9f-e5ec-4a68ec8cb0d1@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowADH+lr1ZEVilGI2AQ--.25548S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAw48WF4fWF1ftF4kZrWfuFg_yoWrAw1rpF
        1DAr1Sg3y5JryagF93Ary8t3sxW348Wr1a9ry7Ww1ak3ZFqF1rtF4ktryjyayYvrZYk39x
        Wa129r1rGanrZr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pi66wJUUUUU=
X-Originating-IP: [101.86.107.106]
X-CM-SenderInfo: 5mdfy55bjdzsisqqiqqrwthudrp/xtbBbADUKVc7O4We1wAAsK
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping Gan <jacky_gam_2001@163.com>

The congestion status of a tcp flow may be updated since there
is congestion between tcp sender and receiver. It makes sense to
add tracepoint for congestion status set function to summate cc
status duration and evaluate the performance of network
and congestion algorithm. The backgound of this patch is below.

Link: https://github.com/iovisor/bcc/pull/3899

Signed-off-by: Ping Gan <jacky_gam_2001@163.com>
---
 include/net/tcp.h          | 12 +++---------
 include/trace/events/tcp.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_cong.c        | 12 ++++++++++++
 3 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 70ca4a5e330a..9a3786f33798 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1139,15 +1139,6 @@ static inline bool tcp_ca_needs_ecn(const struct sock *sk)
 	return icsk->icsk_ca_ops->flags & TCP_CONG_NEEDS_ECN;
 }
 
-static inline void tcp_set_ca_state(struct sock *sk, const u8 ca_state)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-
-	if (icsk->icsk_ca_ops->set_state)
-		icsk->icsk_ca_ops->set_state(sk, ca_state);
-	icsk->icsk_ca_state = ca_state;
-}
-
 static inline void tcp_ca_event(struct sock *sk, const enum tcp_ca_event event)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
@@ -1156,6 +1147,9 @@ static inline void tcp_ca_event(struct sock *sk, const enum tcp_ca_event event)
 		icsk->icsk_ca_ops->cwnd_event(sk, event);
 }
 
+/* From tcp_cong.c */
+void tcp_set_ca_state(struct sock *sk, const u8 ca_state);
+
 /* From tcp_rate.c */
 void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb);
 void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 521059d8dc0a..69a68b01c1de 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -371,6 +371,51 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
 	TP_ARGS(skb)
 );
 
+TRACE_EVENT(tcp_cong_state_set,
+
+	TP_PROTO(struct sock *sk, const u8 ca_state),
+
+	TP_ARGS(sk, ca_state),
+
+	TP_STRUCT__entry(
+		__field(const void *, skaddr)
+		__field(__u16, sport)
+		__field(__u16, dport)
+		__array(__u8, saddr, 4)
+		__array(__u8, daddr, 4)
+		__array(__u8, saddr_v6, 16)
+		__array(__u8, daddr_v6, 16)
+		__field(__u8, cong_state)
+	),
+
+	TP_fast_assign(
+		struct inet_sock *inet = inet_sk(sk);
+		__be32 *p32;
+
+		__entry->skaddr = sk;
+
+		__entry->sport = ntohs(inet->inet_sport);
+		__entry->dport = ntohs(inet->inet_dport);
+
+		p32 = (__be32 *) __entry->saddr;
+		*p32 = inet->inet_saddr;
+
+		p32 = (__be32 *) __entry->daddr;
+		*p32 =  inet->inet_daddr;
+
+		TP_STORE_ADDRS(__entry, inet->inet_saddr, inet->inet_daddr,
+			   sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
+
+		__entry->cong_state = ca_state;
+	),
+
+	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c cong_state=%u",
+		  __entry->sport, __entry->dport,
+		  __entry->saddr, __entry->daddr,
+		  __entry->saddr_v6, __entry->daddr_v6,
+		  __entry->cong_state)
+);
+
 #endif /* _TRACE_TCP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index dc95572163df..98b48bdb8be7 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -16,6 +16,7 @@
 #include <linux/gfp.h>
 #include <linux/jhash.h>
 #include <net/tcp.h>
+#include <trace/events/tcp.h>
 
 static DEFINE_SPINLOCK(tcp_cong_list_lock);
 static LIST_HEAD(tcp_cong_list);
@@ -33,6 +34,17 @@ struct tcp_congestion_ops *tcp_ca_find(const char *name)
 	return NULL;
 }
 
+void tcp_set_ca_state(struct sock *sk, const u8 ca_state)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	trace_tcp_cong_state_set(sk, ca_state);
+
+	if (icsk->icsk_ca_ops->set_state)
+		icsk->icsk_ca_ops->set_state(sk, ca_state);
+	icsk->icsk_ca_state = ca_state;
+}
+
 /* Must be called with rcu lock held */
 static struct tcp_congestion_ops *tcp_ca_find_autoload(struct net *net,
 						       const char *name)
-- 
2.15.0

