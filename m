Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6CF2AB370
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 10:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgKIJU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 04:20:26 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:43316 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgKIJU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 04:20:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=wenan.mao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UEhtbfS_1604913616;
Received: from VM20200710-3.tbsite.net(mailfrom:wenan.mao@linux.alibaba.com fp:SMTPD_---0UEhtbfS_1604913616)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 09 Nov 2020 17:20:22 +0800
From:   Mao Wenan <wenan.mao@linux.alibaba.com>
To:     edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Mao Wenan <wenan.mao@linux.alibaba.com>
Subject: [PATCH] net: Update window_clamp if SOCK_RCVBUF is set
Date:   Mon,  9 Nov 2020 17:20:14 +0800
Message-Id: <1604913614-19432-1-git-send-email-wenan.mao@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When net.ipv4.tcp_syncookies=1 and syn flood is happened,
cookie_v4_check tries to redo what tcp_v4_send_synack did,
rsk_window_clamp will be changed if SOCK_RCVBUF is set
by user, which will make rcv_wscale is different, the client
still operates with initial window scale and can overshot
granted window, the client use the initial scale but local
server use new scale to advertise window value, and session
work abnormally.

Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>
---
 net/ipv4/syncookies.c | 4 ++++
 1 file changed, 4 insertions(+)

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
-- 
1.8.3.1

