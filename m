Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D322AB3A9
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 10:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgKIJdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 04:33:52 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:58823 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKIJdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 04:33:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=wenan.mao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UEjN9Yi_1604914421;
Received: from VM20200710-3.tbsite.net(mailfrom:wenan.mao@linux.alibaba.com fp:SMTPD_---0UEjN9Yi_1604914421)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 09 Nov 2020 17:33:49 +0800
From:   Mao Wenan <wenan.mao@linux.alibaba.com>
To:     edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Mao Wenan <wenan.mao@linux.alibaba.com>
Subject: [PATCH net v2] net: Update window_clamp if SOCK_RCVBUF is set
Date:   Mon,  9 Nov 2020 17:33:37 +0800
Message-Id: <1604914417-24578-1-git-send-email-wenan.mao@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604913614-19432-1-git-send-email-wenan.mao@linux.alibaba.com>
References: <1604913614-19432-1-git-send-email-wenan.mao@linux.alibaba.com>
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

Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>
---
 v2: fix for ipv6.
 net/ipv4/syncookies.c | 4 ++++
 net/ipv6/syncookies.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 6ac473b..57ce317 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -427,6 +427,10 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 
 	/* Try to redo what tcp_v4_send_synack did. */
 	req->rsk_window_clamp = tp->window_clamp ? :dst_metric(&rt->dst, RTAX_WINDOW);
+	/* limit the window selection if the user enforce a smaller rx buffer */
+	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK &&
+	    (req->rsk_window_clamp > tcp_full_space(sk) || req->rsk_window_clamp == 0))
+		req->rsk_window_clamp = tcp_full_space(sk);
 
 	tcp_select_initial_window(sk, tcp_full_space(sk), req->mss,
 				  &req->rsk_rcv_wnd, &req->rsk_window_clamp,
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index e796a64..c041360 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -241,6 +241,11 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	}
 
 	req->rsk_window_clamp = tp->window_clamp ? :dst_metric(dst, RTAX_WINDOW);
+	/* limit the window selection if the user enforce a smaller rx buffer */
+	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK &&
+	    (req->rsk_window_clamp > tcp_full_space(sk) || req->rsk_window_clamp == 0))
+		req->rsk_window_clamp = tcp_full_space(sk);
+
 	tcp_select_initial_window(sk, tcp_full_space(sk), req->mss,
 				  &req->rsk_rcv_wnd, &req->rsk_window_clamp,
 				  ireq->wscale_ok, &rcv_wscale,
-- 
1.8.3.1

