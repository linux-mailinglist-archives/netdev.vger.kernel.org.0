Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA790FA64D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfKMBuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:50:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbfKMBui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C15C72245A;
        Wed, 13 Nov 2019 01:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609837;
        bh=4uPKCiglYWI6Eoxlw3ywo1sZJes3gYihxdUZJ4juF/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtdb4+YknPnkCSdGhh1V6SFKGJyUix98Rgxz+uNquBPbNcH5GpSzqgMwMAKqNGX2J
         WH8xetPYh/6ni2muQKjxa2BN2mnCTFfeHOOQXoH5A2w9vha0o+pkeh2nXYzicgX9dG
         1kP3aKb5VRYDraQ74Q7+ca3fHLXwBAU3AJvl+r7I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>, Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 010/209] tcp: up initial rmem to 128KB and SYN rwin to around 64KB
Date:   Tue, 12 Nov 2019 20:47:06 -0500
Message-Id: <20191113015025.9685-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit a337531b942bd8a03e7052444d7e36972aac2d92 ]

Previously TCP initial receive buffer is ~87KB by default and
the initial receive window is ~29KB (20 MSS). This patch changes
the two numbers to 128KB and ~64KB (rounding down to the multiples
of MSS) respectively. The patch also simplifies the calculations s.t.
the two numbers are directly controlled by sysctl tcp_rmem[1]:

  1) Initial receiver buffer budget (sk_rcvbuf): while this should
     be configured via sysctl tcp_rmem[1], previously tcp_fixup_rcvbuf()
     always override and set a larger size when a new connection
     establishes.

  2) Initial receive window in SYN: previously it is set to 20
     packets if MSS <= 1460. The number 20 was based on the initial
     congestion window of 10: the receiver needs twice amount to
     avoid being limited by the receive window upon out-of-order
     delivery in the first window burst. But since this only
     applies if the receiving MSS <= 1460, connection using large MTU
     (e.g. to utilize receiver zero-copy) may be limited by the
     receive window.

With this patch TCP memory configuration is more straight-forward and
more properly sized to modern high-speed networks by default. Several
popular stacks have been announcing 64KB rwin in SYNs as well.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c        |  4 ++--
 net/ipv4/tcp_input.c  | 25 ++-----------------------
 net/ipv4/tcp_output.c | 25 ++++---------------------
 3 files changed, 8 insertions(+), 46 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 611ba174265c8..1a1fcb32c4917 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3910,8 +3910,8 @@ void __init tcp_init(void)
 	init_net.ipv4.sysctl_tcp_wmem[2] = max(64*1024, max_wshare);
 
 	init_net.ipv4.sysctl_tcp_rmem[0] = SK_MEM_QUANTUM;
-	init_net.ipv4.sysctl_tcp_rmem[1] = 87380;
-	init_net.ipv4.sysctl_tcp_rmem[2] = max(87380, max_rshare);
+	init_net.ipv4.sysctl_tcp_rmem[1] = 131072;
+	init_net.ipv4.sysctl_tcp_rmem[2] = max(131072, max_rshare);
 
 	pr_info("Hash tables configured (established %u bind %u)\n",
 		tcp_hashinfo.ehash_mask + 1, tcp_hashinfo.bhash_size);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 14a6a489937c1..0e2b07be08585 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -426,26 +426,7 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
 	}
 }
 
-/* 3. Tuning rcvbuf, when connection enters established state. */
-static void tcp_fixup_rcvbuf(struct sock *sk)
-{
-	u32 mss = tcp_sk(sk)->advmss;
-	int rcvmem;
-
-	rcvmem = 2 * SKB_TRUESIZE(mss + MAX_TCP_HEADER) *
-		 tcp_default_init_rwnd(mss);
-
-	/* Dynamic Right Sizing (DRS) has 2 to 3 RTT latency
-	 * Allow enough cushion so that sender is not limited by our window
-	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf)
-		rcvmem <<= 2;
-
-	if (sk->sk_rcvbuf < rcvmem)
-		sk->sk_rcvbuf = min(rcvmem, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
-}
-
-/* 4. Try to fixup all. It is made immediately after connection enters
+/* 3. Try to fixup all. It is made immediately after connection enters
  *    established state.
  */
 void tcp_init_buffer_space(struct sock *sk)
@@ -454,8 +435,6 @@ void tcp_init_buffer_space(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	int maxwin;
 
-	if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK))
-		tcp_fixup_rcvbuf(sk);
 	if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
 		tcp_sndbuf_expand(sk);
 
@@ -485,7 +464,7 @@ void tcp_init_buffer_space(struct sock *sk)
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 }
 
-/* 5. Recalculate window clamp after socket hit its memory bounds. */
+/* 4. Recalculate window clamp after socket hit its memory bounds. */
 static void tcp_clamp_window(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 2697e4397e46c..53f910bb55087 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -179,21 +179,6 @@ static inline void tcp_event_ack_sent(struct sock *sk, unsigned int pkts,
 	inet_csk_clear_xmit_timer(sk, ICSK_TIME_DACK);
 }
 
-
-u32 tcp_default_init_rwnd(u32 mss)
-{
-	/* Initial receive window should be twice of TCP_INIT_CWND to
-	 * enable proper sending of new unsent data during fast recovery
-	 * (RFC 3517, Section 4, NextSeg() rule (2)). Further place a
-	 * limit when mss is larger than 1460.
-	 */
-	u32 init_rwnd = TCP_INIT_CWND * 2;
-
-	if (mss > 1460)
-		init_rwnd = max((1460 * init_rwnd) / mss, 2U);
-	return init_rwnd;
-}
-
 /* Determine a window scaling and initial window to offer.
  * Based on the assumption that the given amount of space
  * will be offered. Store the results in the tp structure.
@@ -228,7 +213,10 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	if (sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows)
 		(*rcv_wnd) = min(space, MAX_TCP_WINDOW);
 	else
-		(*rcv_wnd) = space;
+		(*rcv_wnd) = min_t(u32, space, U16_MAX);
+
+	if (init_rcv_wnd)
+		*rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
 
 	(*rcv_wscale) = 0;
 	if (wscale_ok) {
@@ -241,11 +229,6 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 			(*rcv_wscale)++;
 		}
 	}
-
-	if (!init_rcv_wnd) /* Use default unless specified otherwise */
-		init_rcv_wnd = tcp_default_init_rwnd(mss);
-	*rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
-
 	/* Set the clamp no higher than max representable value */
 	(*window_clamp) = min_t(__u32, U16_MAX << (*rcv_wscale), *window_clamp);
 }
-- 
2.20.1

