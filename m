Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0545765CB
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbiGORUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235653AbiGORUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:20:47 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4877B7BE
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657905647; x=1689441647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0gvnCO39BTpBPr2V5rrhUXbMrZg0CaFUCGfDVeXzjVw=;
  b=SnD9/q0E43Lh0PndoriNgwHLlNsGb1mVovz4XIHX/XwuOZggEmzTa+0s
   B6gZGmcVokEQs+J7ocCbjY1tZ8Kcb8lTtfi3jzy4pBrYUIXDDzm72xBm5
   TNglJrkfw4aVqop2kR0v+VHRheguo0+S1MJW+sL88R8Ge+/T6zOLNwP9d
   A=;
X-IronPort-AV: E=Sophos;i="5.92,274,1650931200"; 
   d="scan'208";a="238839902"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 15 Jul 2022 17:20:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com (Postfix) with ESMTPS id 0FC38141D29;
        Fri, 15 Jul 2022 17:20:46 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 15 Jul 2022 17:20:45 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 15 Jul 2022 17:20:42 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 10/15] tcp: Fix data-races around some timeout sysctl knobs.
Date:   Fri, 15 Jul 2022 10:17:50 -0700
Message-ID: <20220715171755.38497-11-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220715171755.38497-1-kuniyu@amazon.com>
References: <20220715171755.38497-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.124]
X-ClientProxiedBy: EX13D31UWA003.ant.amazon.com (10.43.160.130) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading these sysctl knobs, they can be changed concurrently.
Thus, we need to add READ_ONCE() to their readers.

  - tcp_retries1
  - tcp_retries2
  - tcp_orphan_retries
  - tcp_fin_timeout

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/tcp.h     |  3 ++-
 net/ipv4/tcp.c        |  2 +-
 net/ipv4/tcp_output.c |  2 +-
 net/ipv4/tcp_timer.c  | 10 +++++-----
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 7e5a3da4682e..b78f1d60be33 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1523,7 +1523,8 @@ static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
 
 static inline int tcp_fin_time(const struct sock *sk)
 {
-	int fin_timeout = tcp_sk(sk)->linger2 ? : sock_net(sk)->ipv4.sysctl_tcp_fin_timeout;
+	int fin_timeout = tcp_sk(sk)->linger2 ? :
+		READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fin_timeout);
 	const int rto = inet_csk(sk)->icsk_rto;
 
 	if (fin_timeout < (rto << 2) - (rto >> 1))
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b3632fa5df07..b1b1bcbc4f60 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3973,7 +3973,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	case TCP_LINGER2:
 		val = tp->linger2;
 		if (val >= 0)
-			val = (val ? : net->ipv4.sysctl_tcp_fin_timeout) / HZ;
+			val = (val ? : READ_ONCE(net->ipv4.sysctl_tcp_fin_timeout)) / HZ;
 		break;
 	case TCP_DEFER_ACCEPT:
 		val = retrans_to_secs(icsk->icsk_accept_queue.rskq_defer_accept,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 02ab3a9c6657..3b3552d292a5 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4090,7 +4090,7 @@ void tcp_send_probe0(struct sock *sk)
 
 	icsk->icsk_probes_out++;
 	if (err <= 0) {
-		if (icsk->icsk_backoff < net->ipv4.sysctl_tcp_retries2)
+		if (icsk->icsk_backoff < READ_ONCE(net->ipv4.sysctl_tcp_retries2))
 			icsk->icsk_backoff++;
 		timeout = tcp_probe0_when(sk, TCP_RTO_MAX);
 	} else {
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index a234704e8163..ec5277becc6a 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -143,7 +143,7 @@ static int tcp_out_of_resources(struct sock *sk, bool do_reset)
  */
 static int tcp_orphan_retries(struct sock *sk, bool alive)
 {
-	int retries = sock_net(sk)->ipv4.sysctl_tcp_orphan_retries; /* May be zero. */
+	int retries = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_orphan_retries); /* May be zero. */
 
 	/* We know from an ICMP that something is wrong. */
 	if (sk->sk_err_soft && !alive)
@@ -243,14 +243,14 @@ static int tcp_write_timeout(struct sock *sk)
 			READ_ONCE(net->ipv4.sysctl_tcp_syn_retries);
 		expired = icsk->icsk_retransmits >= retry_until;
 	} else {
-		if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1, 0)) {
+		if (retransmits_timed_out(sk, READ_ONCE(net->ipv4.sysctl_tcp_retries1), 0)) {
 			/* Black hole detection */
 			tcp_mtu_probing(icsk, sk);
 
 			__dst_negative_advice(sk);
 		}
 
-		retry_until = net->ipv4.sysctl_tcp_retries2;
+		retry_until = READ_ONCE(net->ipv4.sysctl_tcp_retries2);
 		if (sock_flag(sk, SOCK_DEAD)) {
 			const bool alive = icsk->icsk_rto < TCP_RTO_MAX;
 
@@ -381,7 +381,7 @@ static void tcp_probe_timer(struct sock *sk)
 		 msecs_to_jiffies(icsk->icsk_user_timeout))
 		goto abort;
 
-	max_probes = sock_net(sk)->ipv4.sysctl_tcp_retries2;
+	max_probes = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_retries2);
 	if (sock_flag(sk, SOCK_DEAD)) {
 		const bool alive = inet_csk_rto_backoff(icsk, TCP_RTO_MAX) < TCP_RTO_MAX;
 
@@ -589,7 +589,7 @@ void tcp_retransmit_timer(struct sock *sk)
 	}
 	inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
 				  tcp_clamp_rto_to_user_timeout(sk), TCP_RTO_MAX);
-	if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1 + 1, 0))
+	if (retransmits_timed_out(sk, READ_ONCE(net->ipv4.sysctl_tcp_retries1) + 1, 0))
 		__sk_dst_reset(sk);
 
 out:;
-- 
2.30.2

