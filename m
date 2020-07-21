Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6ED228A03
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgGUUhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGUUhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A6AC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz0e-0003v0-NE; Tue, 21 Jul 2020 22:37:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 01/12] tcp: remove cookie_ts bit from request_sock
Date:   Tue, 21 Jul 2020 22:36:31 +0200
Message-Id: <20200721203642.32753-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need for this anymore; nowadays output function has a 'synack_type'
argument that tells us when the syn/ack is emitted via syncookies.

The request already tells us when timestamps are supported, so check
both to detect special timestamp for tcp option encoding is needed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 1 -
 include/net/request_sock.h              | 3 +--
 net/ipv4/tcp_input.c                    | 2 --
 net/ipv4/tcp_output.c                   | 2 +-
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index f200fae6f7cb..fcd41f586da8 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1347,7 +1347,6 @@ static void chtls_pass_accept_request(struct sock *sk,
 
 	oreq->rsk_rcv_wnd = 0;
 	oreq->rsk_window_clamp = 0;
-	oreq->cookie_ts = 0;
 	oreq->mss = 0;
 	oreq->ts_recent = 0;
 
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index cf8b33213bbc..2f717d4dafc5 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -54,8 +54,7 @@ struct request_sock {
 	struct request_sock		*dl_next;
 	u16				mss;
 	u8				num_retrans; /* number of retransmits */
-	u8				cookie_ts:1; /* syncookie: encode tcpopts in timestamp */
-	u8				num_timeout:7; /* number of timeouts */
+	u8				num_timeout; /* number of timeouts */
 	u32				ts_recent;
 	struct timer_list		rsk_timer;
 	const struct request_sock_ops	*rsk_ops;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 82906deb7874..727ca87a2929 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6518,7 +6518,6 @@ static void tcp_openreq_init(struct request_sock *req,
 	struct inet_request_sock *ireq = inet_rsk(req);
 
 	req->rsk_rcv_wnd = 0;		/* So that tcp_send_synack() knows! */
-	req->cookie_ts = 0;
 	tcp_rsk(req)->rcv_isn = TCP_SKB_CB(skb)->seq;
 	tcp_rsk(req)->rcv_nxt = TCP_SKB_CB(skb)->seq + 1;
 	tcp_rsk(req)->snt_synack = 0;
@@ -6738,7 +6737,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	if (want_cookie) {
 		isn = cookie_init_sequence(af_ops, sk, skb, &req->mss);
-		req->cookie_ts = tmp_opt.tstamp_ok;
 		if (!tmp_opt.tstamp_ok)
 			inet_rsk(req)->ecn_ok = 0;
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index dc0117013ba5..0ca3d75dcc52 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3390,7 +3390,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	memset(&opts, 0, sizeof(opts));
 	now = tcp_clock_ns();
 #ifdef CONFIG_SYN_COOKIES
-	if (unlikely(req->cookie_ts))
+	if (unlikely(synack_type == TCP_SYNACK_COOKIE && inet_rsk(req)->tstamp_ok))
 		skb->skb_mstamp_ns = cookie_init_timestamp(req, now);
 	else
 #endif
-- 
2.26.2

