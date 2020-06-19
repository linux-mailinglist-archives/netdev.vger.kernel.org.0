Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF99201AFA
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733038AbgFSTMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 15:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732987AbgFSTMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:12:43 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034D2C0613EE
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:12:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o84so11283967ybg.0
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZGr4x+HY7sM56dfEcVNJkcvSjTd//e3/P3MCIxhGmWA=;
        b=DQocEaD87RYIpUumsGg7tbIFDiVD0zaryVHHu50YO01o7/mhObBOfo41kV+G3ccF3G
         Q0ri91vOkjHIcyjcHWgV8u6e1qv+UX2bS6stKXkhDO4YfAoq2Y6w3q764kJWXMFIK47G
         051O1yIBSP+fXxqmJx2txu+km3VAYsxtGHbjJA392oXrvuRcvCrnTUbQkAx0IA8ShWnn
         98/0hINyGuotXAModn0x+WE2r31T6LrpiKWPpPVEfMKLoJOlE1XPLcj3FYoapB+Iyf8Y
         oEMRoDOBlKiZOxKZgS4YoY3kQTTXl8Pnjy7P4c09pFU58enXyhAfUFQyb1/EHym6lS55
         FYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZGr4x+HY7sM56dfEcVNJkcvSjTd//e3/P3MCIxhGmWA=;
        b=qHOv7G8XL1g9bUf23Mfc9Xh/Sdi/XjcRTHAaWJJogG6HmPHELpv/eaO5zUelVcnf9Q
         QQ/UnHYe0n9eo3nAc8V/UI47h/79ZOJ1vAUdOCOD/XPCNNyZgmy9IIJfP+csvSLcw+NS
         OncKuz/br5D6up8bO5U9Xdp1o0yODPu3dBUonSvJ6MeIMamDgcFGds3eCWBv6CR7x2Yj
         fBvbkMAxkfB6vOfYobpuySsX+bc6r240x6iRidLjSFK/vnXn3eiGQHC8TzXhi75nfQJc
         7OHmQKABmfaj7Er+8zmQrz2o8VrJ/1GpGaTzyTEMvqy76YTQiu4/49O+E2eopePGiohT
         Hi4A==
X-Gm-Message-State: AOAM5327SnCtiVmxSUQRQNZiVT3P81M9YoZ6EkUcRdjETad7fDrAPBXU
        TUj2G20y8M938HaShadaN2XbZcd5YeFrfg==
X-Google-Smtp-Source: ABdhPJwjMRBegCVcKDIjpZPU0wZGmuc6xNBU4gm6GbOs+3ZPB0F2NBvrLOUis/VHNO8WooGkKkh630PheFi+eQ==
X-Received: by 2002:a25:cb45:: with SMTP id b66mr8445598ybg.397.1592593962239;
 Fri, 19 Jun 2020 12:12:42 -0700 (PDT)
Date:   Fri, 19 Jun 2020 12:12:35 -0700
In-Reply-To: <20200619191235.199506-1-edumazet@google.com>
Message-Id: <20200619191235.199506-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200619191235.199506-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next 2/2] tcp: remove indirect calls for icsk->icsk_af_ops->send_check
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mitigate RETPOLINE costs in __tcp_transmit_skb()
by using INDIRECT_CALL_INET() wrapper.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip6_checksum.h | 9 ---------
 include/net/tcp.h          | 3 +++
 net/ipv4/tcp_output.c      | 5 ++++-
 net/ipv6/tcp_ipv6.c        | 7 +++++++
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/net/ip6_checksum.h b/include/net/ip6_checksum.h
index 27ec612cd4a4598dc01e4984e61bc42c6ee5e77b..b3f4eaa88672a2e64ec3fbb3e77a60fe383e59d9 100644
--- a/include/net/ip6_checksum.h
+++ b/include/net/ip6_checksum.h
@@ -85,15 +85,6 @@ static inline void tcp_v6_gso_csum_prep(struct sk_buff *skb)
 	th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
 }
 
-#if IS_ENABLED(CONFIG_IPV6)
-static inline void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb)
-{
-	struct ipv6_pinfo *np = inet6_sk(sk);
-
-	__tcp_v6_send_check(skb, &np->saddr, &sk->sk_v6_daddr);
-}
-#endif
-
 static inline __sum16 udp_v6_check(int len,
 				   const struct in6_addr *saddr,
 				   const struct in6_addr *daddr,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index e5d7e0b099245cf245a5f1c994d164a9fff66124..cd9cc348dbf9c62efa30d909f23a0ed1b39e4492 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -932,6 +932,9 @@ static inline int tcp_v6_sdif(const struct sk_buff *skb)
 #endif
 	return 0;
 }
+
+INDIRECT_CALLABLE_DECLARE(void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb));
+
 #endif
 
 static inline bool inet_exact_dif_match(struct net *net, struct sk_buff *skb)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index be1bd37185d82e5827dfc5105ae74cd815ba1877..04b70fe31fa2cdad739ca49447cf4dd7e9d90cce 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1066,6 +1066,7 @@ static void tcp_update_skb_after_send(struct sock *sk, struct sk_buff *skb,
 
 INDIRECT_CALLABLE_DECLARE(int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl));
 INDIRECT_CALLABLE_DECLARE(int inet6_csk_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl));
+INDIRECT_CALLABLE_DECLARE(void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb));
 
 /* This routine actually transmits TCP packets queued in by
  * tcp_do_sendmsg().  This is used by both the initial
@@ -1210,7 +1211,9 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	}
 #endif
 
-	icsk->icsk_af_ops->send_check(sk, skb);
+	INDIRECT_CALL_INET(icsk->icsk_af_ops->send_check,
+			   tcp_v6_send_check, tcp_v4_send_check,
+			   sk, skb);
 
 	if (likely(tcb->tcp_flags & TCPHDR_ACK))
 		tcp_event_ack_sent(sk, tcp_skb_pcount(skb), rcv_nxt);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f67d45ff00b468f8c50053f6d2e430a1f5247db5..4502db706f75349b49672a859492a036a8722bb6 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1811,6 +1811,13 @@ static struct timewait_sock_ops tcp6_timewait_sock_ops = {
 	.twsk_destructor = tcp_twsk_destructor,
 };
 
+INDIRECT_CALLABLE_SCOPE void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb)
+{
+	struct ipv6_pinfo *np = inet6_sk(sk);
+
+	__tcp_v6_send_check(skb, &np->saddr, &sk->sk_v6_daddr);
+}
+
 const struct inet_connection_sock_af_ops ipv6_specific = {
 	.queue_xmit	   = inet6_csk_xmit,
 	.send_check	   = tcp_v6_send_check,
-- 
2.27.0.111.gc72c7da667-goog

