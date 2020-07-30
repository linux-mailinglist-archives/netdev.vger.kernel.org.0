Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640BC2338EF
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgG3T0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3T0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:26:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0838EC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:26:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k1EBs-0003VS-L0; Thu, 30 Jul 2020 21:26:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 1/9] tcp: rename request_sock cookie_ts bit to syncookie
Date:   Thu, 30 Jul 2020 21:25:50 +0200
Message-Id: <20200730192558.25697-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730192558.25697-1-fw@strlen.de>
References: <20200730192558.25697-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nowadays output function has a 'synack_type' argument that tells us when
the syn/ack is emitted via syncookies.

The request already tells us when timestamps are supported, so check
both to detect special timestamp for tcp option encoding is needed.

We could remove cookie_ts altogether, but a followup patch would
otherwise need to adjust function signatures to pass 'want_cookie' to
mptcp core.

This way, the 'existing' bit can be used.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 2 +-
 include/net/request_sock.h              | 2 +-
 net/ipv4/tcp_input.c                    | 3 +--
 net/ipv4/tcp_output.c                   | 2 +-
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index f924c335a195..05520dccd906 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1348,7 +1348,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 
 	oreq->rsk_rcv_wnd = 0;
 	oreq->rsk_window_clamp = 0;
-	oreq->cookie_ts = 0;
+	oreq->syncookie = 0;
 	oreq->mss = 0;
 	oreq->ts_recent = 0;
 
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index cf8b33213bbc..b2eb8b4ba697 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -54,7 +54,7 @@ struct request_sock {
 	struct request_sock		*dl_next;
 	u16				mss;
 	u8				num_retrans; /* number of retransmits */
-	u8				cookie_ts:1; /* syncookie: encode tcpopts in timestamp */
+	u8				syncookie:1; /* syncookie: encode tcpopts in timestamp */
 	u8				num_timeout:7; /* number of timeouts */
 	u32				ts_recent;
 	struct timer_list		rsk_timer;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a018bafd7bdf..11a6f128e51c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6519,7 +6519,6 @@ static void tcp_openreq_init(struct request_sock *req,
 	struct inet_request_sock *ireq = inet_rsk(req);
 
 	req->rsk_rcv_wnd = 0;		/* So that tcp_send_synack() knows! */
-	req->cookie_ts = 0;
 	tcp_rsk(req)->rcv_isn = TCP_SKB_CB(skb)->seq;
 	tcp_rsk(req)->rcv_nxt = TCP_SKB_CB(skb)->seq + 1;
 	tcp_rsk(req)->snt_synack = 0;
@@ -6674,6 +6673,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	if (!req)
 		goto drop;
 
+	req->syncookie = want_cookie;
 	tcp_rsk(req)->af_specific = af_ops;
 	tcp_rsk(req)->ts_off = 0;
 #if IS_ENABLED(CONFIG_MPTCP)
@@ -6739,7 +6739,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	if (want_cookie) {
 		isn = cookie_init_sequence(af_ops, sk, skb, &req->mss);
-		req->cookie_ts = tmp_opt.tstamp_ok;
 		if (!tmp_opt.tstamp_ok)
 			inet_rsk(req)->ecn_ok = 0;
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index d8f16f6a9b02..85ff417bda7f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3393,7 +3393,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	memset(&opts, 0, sizeof(opts));
 	now = tcp_clock_ns();
 #ifdef CONFIG_SYN_COOKIES
-	if (unlikely(req->cookie_ts))
+	if (unlikely(synack_type == TCP_SYNACK_COOKIE && ireq->tstamp_ok))
 		skb->skb_mstamp_ns = cookie_init_timestamp(req, now);
 	else
 #endif
-- 
2.26.2

