Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506E5578860
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbiGRR2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiGRR2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:28:35 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CD32CDC2
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658165314; x=1689701314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N+luqcuQ0B2pvIvG5zbp2ueIhvcv/moOyNJI3vB87Dc=;
  b=aNCq05ww4YbE5geL+DAay7Iqlh46wjq2MvB21hFF0Jk3Vq99ryPdm44E
   ZTZy9okfSLE+S46OoLs/dxYSlKHCpYK7C/uD2I9obDCfWHwKwuMEJceA1
   J3y8lnjj99dYnRw4PCLmNo6+wy9jqR2oyFojz+aS1znnQ5XE9PGisb9Wn
   g=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="1035321125"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 18 Jul 2022 17:28:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com (Postfix) with ESMTPS id B00A343F05;
        Mon, 18 Jul 2022 17:28:33 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 17:28:32 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 17:28:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 06/15] tcp: Fix data-races around sysctl knobs related to SYN option.
Date:   Mon, 18 Jul 2022 10:26:44 -0700
Message-ID: <20220718172653.22111-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718172653.22111-1-kuniyu@amazon.com>
References: <20220718172653.22111-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D04UWA004.ant.amazon.com (10.43.160.234) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading these knobs, they can be changed concurrently.
Thus, we need to add READ_ONCE() to their readers.

  - tcp_sack
  - tcp_window_scaling
  - tcp_timestamps

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    |  6 +++---
 net/core/secure_seq.c                                  |  4 ++--
 net/ipv4/syncookies.c                                  |  6 +++---
 net/ipv4/tcp_input.c                                   |  6 +++---
 net/ipv4/tcp_output.c                                  | 10 +++++-----
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 7c760aa65540..ddfe9208529a 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1236,8 +1236,8 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	csk->sndbuf = newsk->sk_sndbuf;
 	csk->smac_idx = ((struct port_info *)netdev_priv(ndev))->smt_idx;
 	RCV_WSCALE(tp) = select_rcv_wscale(tcp_full_space(newsk),
-					   sock_net(newsk)->
-						ipv4.sysctl_tcp_window_scaling,
+					   READ_ONCE(sock_net(newsk)->
+						     ipv4.sysctl_tcp_window_scaling),
 					   tp->window_clamp);
 	neigh_release(n);
 	inet_inherit_port(&tcp_hashinfo, lsk, newsk);
@@ -1384,7 +1384,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 #endif
 	}
 	if (req->tcpopt.wsf <= 14 &&
-	    sock_net(sk)->ipv4.sysctl_tcp_window_scaling) {
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling)) {
 		inet_rsk(oreq)->wscale_ok = 1;
 		inet_rsk(oreq)->snd_wscale = req->tcpopt.wsf;
 	}
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 5f85e01d4093..b0ff6153be62 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -64,7 +64,7 @@ u32 secure_tcpv6_ts_off(const struct net *net,
 		.daddr = *(struct in6_addr *)daddr,
 	};
 
-	if (net->ipv4.sysctl_tcp_timestamps != 1)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_timestamps) != 1)
 		return 0;
 
 	ts_secret_init();
@@ -120,7 +120,7 @@ EXPORT_SYMBOL(secure_ipv6_port_ephemeral);
 #ifdef CONFIG_INET
 u32 secure_tcp_ts_off(const struct net *net, __be32 saddr, __be32 daddr)
 {
-	if (net->ipv4.sysctl_tcp_timestamps != 1)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_timestamps) != 1)
 		return 0;
 
 	ts_secret_init();
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 9b234b42021e..942d2dfa1115 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -247,12 +247,12 @@ bool cookie_timestamp_decode(const struct net *net,
 		return true;
 	}
 
-	if (!net->ipv4.sysctl_tcp_timestamps)
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_timestamps))
 		return false;
 
 	tcp_opt->sack_ok = (options & TS_OPT_SACK) ? TCP_SACK_SEEN : 0;
 
-	if (tcp_opt->sack_ok && !net->ipv4.sysctl_tcp_sack)
+	if (tcp_opt->sack_ok && !READ_ONCE(net->ipv4.sysctl_tcp_sack))
 		return false;
 
 	if ((options & TS_OPT_WSCALE_MASK) == TS_OPT_WSCALE_MASK)
@@ -261,7 +261,7 @@ bool cookie_timestamp_decode(const struct net *net,
 	tcp_opt->wscale_ok = 1;
 	tcp_opt->snd_wscale = options & TS_OPT_WSCALE_MASK;
 
-	return net->ipv4.sysctl_tcp_window_scaling != 0;
+	return READ_ONCE(net->ipv4.sysctl_tcp_window_scaling) != 0;
 }
 EXPORT_SYMBOL(cookie_timestamp_decode);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d451248bebec..92626e15115c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4060,7 +4060,7 @@ void tcp_parse_options(const struct net *net,
 				break;
 			case TCPOPT_WINDOW:
 				if (opsize == TCPOLEN_WINDOW && th->syn &&
-				    !estab && net->ipv4.sysctl_tcp_window_scaling) {
+				    !estab && READ_ONCE(net->ipv4.sysctl_tcp_window_scaling)) {
 					__u8 snd_wscale = *(__u8 *)ptr;
 					opt_rx->wscale_ok = 1;
 					if (snd_wscale > TCP_MAX_WSCALE) {
@@ -4076,7 +4076,7 @@ void tcp_parse_options(const struct net *net,
 			case TCPOPT_TIMESTAMP:
 				if ((opsize == TCPOLEN_TIMESTAMP) &&
 				    ((estab && opt_rx->tstamp_ok) ||
-				     (!estab && net->ipv4.sysctl_tcp_timestamps))) {
+				     (!estab && READ_ONCE(net->ipv4.sysctl_tcp_timestamps)))) {
 					opt_rx->saw_tstamp = 1;
 					opt_rx->rcv_tsval = get_unaligned_be32(ptr);
 					opt_rx->rcv_tsecr = get_unaligned_be32(ptr + 4);
@@ -4084,7 +4084,7 @@ void tcp_parse_options(const struct net *net,
 				break;
 			case TCPOPT_SACK_PERM:
 				if (opsize == TCPOLEN_SACK_PERM && th->syn &&
-				    !estab && net->ipv4.sysctl_tcp_sack) {
+				    !estab && READ_ONCE(net->ipv4.sysctl_tcp_sack)) {
 					opt_rx->sack_ok = TCP_SACK_SEEN;
 					tcp_sack_reset(opt_rx);
 				}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 3b3552d292a5..38a71e711edc 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -791,18 +791,18 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 	opts->mss = tcp_advertise_mss(sk);
 	remaining -= TCPOLEN_MSS_ALIGNED;
 
-	if (likely(sock_net(sk)->ipv4.sysctl_tcp_timestamps && !*md5)) {
+	if (likely(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_timestamps) && !*md5)) {
 		opts->options |= OPTION_TS;
 		opts->tsval = tcp_skb_timestamp(skb) + tp->tsoffset;
 		opts->tsecr = tp->rx_opt.ts_recent;
 		remaining -= TCPOLEN_TSTAMP_ALIGNED;
 	}
-	if (likely(sock_net(sk)->ipv4.sysctl_tcp_window_scaling)) {
+	if (likely(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling))) {
 		opts->ws = tp->rx_opt.rcv_wscale;
 		opts->options |= OPTION_WSCALE;
 		remaining -= TCPOLEN_WSCALE_ALIGNED;
 	}
-	if (likely(sock_net(sk)->ipv4.sysctl_tcp_sack)) {
+	if (likely(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_sack))) {
 		opts->options |= OPTION_SACK_ADVERTISE;
 		if (unlikely(!(OPTION_TS & opts->options)))
 			remaining -= TCPOLEN_SACKPERM_ALIGNED;
@@ -3647,7 +3647,7 @@ static void tcp_connect_init(struct sock *sk)
 	 * See tcp_input.c:tcp_rcv_state_process case TCP_SYN_SENT.
 	 */
 	tp->tcp_header_len = sizeof(struct tcphdr);
-	if (sock_net(sk)->ipv4.sysctl_tcp_timestamps)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_timestamps))
 		tp->tcp_header_len += TCPOLEN_TSTAMP_ALIGNED;
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -3683,7 +3683,7 @@ static void tcp_connect_init(struct sock *sk)
 				  tp->advmss - (tp->rx_opt.ts_recent_stamp ? tp->tcp_header_len - sizeof(struct tcphdr) : 0),
 				  &tp->rcv_wnd,
 				  &tp->window_clamp,
-				  sock_net(sk)->ipv4.sysctl_tcp_window_scaling,
+				  READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling),
 				  &rcv_wscale,
 				  rcv_wnd);
 
-- 
2.30.2

