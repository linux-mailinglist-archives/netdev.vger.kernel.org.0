Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8382AC99D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 01:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgKJAQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 19:16:43 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:36305 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729243AbgKJAQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 19:16:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=wenan.mao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UEpA7Z3_1604967392;
Received: from VM20200710-3.tbsite.net(mailfrom:wenan.mao@linux.alibaba.com fp:SMTPD_---0UEpA7Z3_1604967392)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 Nov 2020 08:16:39 +0800
From:   Mao Wenan <wenan.mao@linux.alibaba.com>
To:     edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Mao Wenan <wenan.mao@linux.alibaba.com>
Subject: [PATCH net v5] net: Update window_clamp if SOCK_RCVBUF is set
Date:   Tue, 10 Nov 2020 08:16:31 +0800
Message-Id: <1604967391-123737-1-git-send-email-wenan.mao@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CANn89i+ABLMJTEKat=9=qujNwe0BFavphzqYc1CQGtrdkwUnXg@mail.gmail.com>
References: <CANn89i+ABLMJTEKat=9=qujNwe0BFavphzqYc1CQGtrdkwUnXg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When net.ipv4.tcp_syncookies=1 and syn flood is happened,
cookie_v4_check or cookie_v6_check tries to redo what
tcp_v4_send_synack or tcp_v6_send_synack did,
rsk_window_clamp will be changed if SOCK_RCVBUF is set,
which will make rcv_wscale is different, the client
still operates with initial window scale and can overshot
granted window, the client use the initial scale but local
server use new scale to advertise window value, and session
work abnormally.

Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's rcv-buffer via setsockopt")
Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>
---
 v5: fix variable to adapat to Christmas tree format.
 v4: change fixes tag format, and delay the actual call to
     tcp_full_space().
 v3: add local variable full_space, add fixes tag.
 v2: fix for ipv6.
 net/ipv4/syncookies.c |  9 +++++++--
 net/ipv6/syncookies.c | 10 ++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 6ac473b..00dc3f9 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -331,7 +331,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	__u32 cookie = ntohl(th->ack_seq) - 1;
 	struct sock *ret = sk;
 	struct request_sock *req;
-	int mss;
+	int full_space, mss;
 	struct rtable *rt;
 	__u8 rcv_wscale;
 	struct flowi4 fl4;
@@ -427,8 +427,13 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 
 	/* Try to redo what tcp_v4_send_synack did. */
 	req->rsk_window_clamp = tp->window_clamp ? :dst_metric(&rt->dst, RTAX_WINDOW);
+	/* limit the window selection if the user enforce a smaller rx buffer */
+	full_space = tcp_full_space(sk);
+	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK &&
+	    (req->rsk_window_clamp > full_space || req->rsk_window_clamp == 0))
+		req->rsk_window_clamp = full_space;
 
-	tcp_select_initial_window(sk, tcp_full_space(sk), req->mss,
+	tcp_select_initial_window(sk, full_space, req->mss,
 				  &req->rsk_rcv_wnd, &req->rsk_window_clamp,
 				  ireq->wscale_ok, &rcv_wscale,
 				  dst_metric(&rt->dst, RTAX_INITRWND));
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index e796a64..9b6cae1 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -136,7 +136,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	__u32 cookie = ntohl(th->ack_seq) - 1;
 	struct sock *ret = sk;
 	struct request_sock *req;
-	int mss;
+	int full_space, mss;
 	struct dst_entry *dst;
 	__u8 rcv_wscale;
 	u32 tsoff = 0;
@@ -241,7 +241,13 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	}
 
 	req->rsk_window_clamp = tp->window_clamp ? :dst_metric(dst, RTAX_WINDOW);
-	tcp_select_initial_window(sk, tcp_full_space(sk), req->mss,
+	/* limit the window selection if the user enforce a smaller rx buffer */
+	full_space = tcp_full_space(sk);
+	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK &&
+	    (req->rsk_window_clamp > full_space || req->rsk_window_clamp == 0))
+		req->rsk_window_clamp = full_space;
+
+	tcp_select_initial_window(sk, full_space, req->mss,
 				  &req->rsk_rcv_wnd, &req->rsk_window_clamp,
 				  ireq->wscale_ok, &rcv_wscale,
 				  dst_metric(dst, RTAX_INITRWND));
-- 
1.8.3.1

