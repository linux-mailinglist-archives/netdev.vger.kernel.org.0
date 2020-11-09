Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5972E2AC174
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbgKIQyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:54:06 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:59444 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730202AbgKIQyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:54:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=wenan.mao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UEoLgHG_1604940832;
Received: from VM20200710-3.tbsite.net(mailfrom:wenan.mao@linux.alibaba.com fp:SMTPD_---0UEoLgHG_1604940832)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 Nov 2020 00:54:00 +0800
From:   Mao Wenan <wenan.mao@linux.alibaba.com>
To:     edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Mao Wenan <wenan.mao@linux.alibaba.com>
Subject: [PATCH net v3] net: Update window_clamp if SOCK_RCVBUF is set
Date:   Tue, 10 Nov 2020 00:53:50 +0800
Message-Id: <1604940830-74688-1-git-send-email-wenan.mao@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CANn89iLhCjh7ZQRanVEj6Sytzn6LhFOb9Xo7O=teLHPouoeopw@mail.gmail.com>
References: <CANn89iLhCjh7ZQRanVEj6Sytzn6LhFOb9Xo7O=teLHPouoeopw@mail.gmail.com>
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

Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's
rcv-buffer via setsockopt")

Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>
---
 v3: add local variable full_space, add fixes tag.
 v2: fix for ipv6.
 net/ipv4/syncookies.c | 7 ++++++-
 net/ipv6/syncookies.c | 8 +++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 6ac473b..eea4698 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -327,6 +327,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	struct inet_request_sock *ireq;
 	struct tcp_request_sock *treq;
 	struct tcp_sock *tp = tcp_sk(sk);
+	int full_space = tcp_full_space(sk);
 	const struct tcphdr *th = tcp_hdr(skb);
 	__u32 cookie = ntohl(th->ack_seq) - 1;
 	struct sock *ret = sk;
@@ -427,8 +428,12 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 
 	/* Try to redo what tcp_v4_send_synack did. */
 	req->rsk_window_clamp = tp->window_clamp ? :dst_metric(&rt->dst, RTAX_WINDOW);
+	/* limit the window selection if the user enforce a smaller rx buffer */
+	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK &&
+	    (req->rsk_window_clamp > full_space || req->rsk_window_clamp == 0))
+		req->rsk_window_clamp = full_space;
 
-	tcp_select_initial_window(sk, tcp_full_space(sk), req->mss,
+	tcp_select_initial_window(sk, full_space, req->mss,
 				  &req->rsk_rcv_wnd, &req->rsk_window_clamp,
 				  ireq->wscale_ok, &rcv_wscale,
 				  dst_metric(&rt->dst, RTAX_INITRWND));
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index e796a64..5b09bb6 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -132,6 +132,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	struct tcp_request_sock *treq;
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
+	int full_space = tcp_full_space(sk);
 	const struct tcphdr *th = tcp_hdr(skb);
 	__u32 cookie = ntohl(th->ack_seq) - 1;
 	struct sock *ret = sk;
@@ -241,7 +242,12 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	}
 
 	req->rsk_window_clamp = tp->window_clamp ? :dst_metric(dst, RTAX_WINDOW);
-	tcp_select_initial_window(sk, tcp_full_space(sk), req->mss,
+	/* limit the window selection if the user enforce a smaller rx buffer */
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

