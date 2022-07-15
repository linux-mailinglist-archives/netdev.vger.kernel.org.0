Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858775765C5
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbiGORUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234994AbiGORUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:20:02 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB1872EEF
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657905600; x=1689441600;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RwFDggA9JK72zS8Bn4YznhB/JsIvZXR+Qkk3oSUiPTk=;
  b=iNUUhPtGHT9I0+YvuQX3C0fr1HvQe71j0dFEL+boqGUJOTA3SFRoHmij
   B07jIhJ72W3RyQ1zMJo+EHg/FAbmP9LHmBEVODA4ympF0DeFJVg50YOSC
   hbTCx84x/mSuOY//BWQRR+ZnSk3vJUk79sRipyo9nk5Ltb+KGu+7n1k6Q
   Y=;
X-IronPort-AV: E=Sophos;i="5.92,274,1650931200"; 
   d="scan'208";a="1034625121"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 15 Jul 2022 17:20:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com (Postfix) with ESMTPS id 2A5C5922E6;
        Fri, 15 Jul 2022 17:20:00 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 15 Jul 2022 17:19:59 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 15 Jul 2022 17:19:56 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 07/15] tcp: Fix data-races around sysctl_tcp_syncookies.
Date:   Fri, 15 Jul 2022 10:17:47 -0700
Message-ID: <20220715171755.38497-8-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220715171755.38497-1-kuniyu@amazon.com>
References: <20220715171755.38497-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.124]
X-ClientProxiedBy: EX13D31UWA003.ant.amazon.com (10.43.160.130) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_syncookies, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/core/filter.c     |  4 ++--
 net/ipv4/syncookies.c |  3 ++-
 net/ipv4/tcp_input.c  | 20 ++++++++++++--------
 net/ipv6/syncookies.c |  3 ++-
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2a6a0b0ce43e..7950f7520765 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7041,7 +7041,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
 		return -EINVAL;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
 		return -EINVAL;
 
 	if (!th->ack || th->rst || th->syn)
@@ -7116,7 +7116,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
 		return -EINVAL;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
 		return -ENOENT;
 
 	if (!th->syn || th->ack || th->fin || th->rst)
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index b387c4835155..9b234b42021e 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -340,7 +340,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	struct flowi4 fl4;
 	u32 tsoff = 0;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies || !th->ack || th->rst)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
+	    !th->ack || th->rst)
 		goto out;
 
 	if (tcp_synq_no_recent_overflow(sk))
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3ec4edc37313..8271eaad887b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6797,11 +6797,14 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 {
 	struct request_sock_queue *queue = &inet_csk(sk)->icsk_accept_queue;
 	const char *msg = "Dropping request";
-	bool want_cookie = false;
 	struct net *net = sock_net(sk);
+	bool want_cookie = false;
+	u8 syncookies;
+
+	syncookies = READ_ONCE(net->ipv4.sysctl_tcp_syncookies);
 
 #ifdef CONFIG_SYN_COOKIES
-	if (net->ipv4.sysctl_tcp_syncookies) {
+	if (syncookies) {
 		msg = "Sending cookies";
 		want_cookie = true;
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDOCOOKIES);
@@ -6809,8 +6812,7 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 #endif
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDROP);
 
-	if (!queue->synflood_warned &&
-	    net->ipv4.sysctl_tcp_syncookies != 2 &&
+	if (!queue->synflood_warned && syncookies != 2 &&
 	    xchg(&queue->synflood_warned, 1) == 0)
 		net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
 				     proto, sk->sk_num, msg);
@@ -6859,7 +6861,7 @@ u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
 	struct tcp_sock *tp = tcp_sk(sk);
 	u16 mss;
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_syncookies != 2 &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) != 2 &&
 	    !inet_csk_reqsk_queue_is_full(sk))
 		return 0;
 
@@ -6893,13 +6895,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	bool want_cookie = false;
 	struct dst_entry *dst;
 	struct flowi fl;
+	u8 syncookies;
+
+	syncookies = READ_ONCE(net->ipv4.sysctl_tcp_syncookies);
 
 	/* TW buckets are converted to open requests without
 	 * limitations, they conserve resources and peer is
 	 * evidently real one.
 	 */
-	if ((net->ipv4.sysctl_tcp_syncookies == 2 ||
-	     inet_csk_reqsk_queue_is_full(sk)) && !isn) {
+	if ((syncookies == 2 || inet_csk_reqsk_queue_is_full(sk)) && !isn) {
 		want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
 		if (!want_cookie)
 			goto drop;
@@ -6949,7 +6953,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	if (!want_cookie && !isn) {
 		/* Kill the following clause, if you dislike this way. */
-		if (!net->ipv4.sysctl_tcp_syncookies &&
+		if (!syncookies &&
 		    (net->ipv4.sysctl_max_syn_backlog - inet_csk_reqsk_queue_len(sk) <
 		     (net->ipv4.sysctl_max_syn_backlog >> 2)) &&
 		    !tcp_peer_is_proven(req, dst)) {
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 9cc123f000fb..5014aa663452 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -141,7 +141,8 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	__u8 rcv_wscale;
 	u32 tsoff = 0;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies || !th->ack || th->rst)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
+	    !th->ack || th->rst)
 		goto out;
 
 	if (tcp_synq_no_recent_overflow(sk))
-- 
2.30.2

