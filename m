Return-Path: <netdev+bounces-8201-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBBA4723188
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 017441C20D53
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790441C752;
	Mon,  5 Jun 2023 20:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9EE323E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 20:40:23 +0000 (UTC)
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101E3E6
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:40:21 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-ba81ded8d3eso6235113276.3
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 13:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1685997620; x=1688589620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7zwdq9cxdMzP7e3dEpgnF0u6fG70OzUAzUxnhpai8+M=;
        b=qmRb5dFBN8zwncE+8Ysbv2J+UlEybsf/q7dEI72ujyZFo//UyunNhYUd7kIHruz5at
         Wno6OKR60tvNSqEWCSd7RPMoP5h0u1UxHiWfkWBDwGrWOV4muVj7Qb4LxOsbvInhjDm2
         2bnXtq/VTODvuxaobW4ySR+10hna2/WJCam14=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685997620; x=1688589620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7zwdq9cxdMzP7e3dEpgnF0u6fG70OzUAzUxnhpai8+M=;
        b=amxufBX3PCgcAYqb7Sfyu+I9WwikdzVW2Hv9r24Lp+3G42SyOw8aJ8AKVgYbpouYnZ
         f2JlefOU7UqpsQxJ1BH3pWfsBO240b+NHvJOL4QHf5CKQgZKIUohUR2NkvwtbbQDmlCE
         iKy1Baz038mWexPQCQCYO9LOvRJR8AnUbRnmJSUV1UtM/n4cZBKk3nr7WvvkTDOkxzb/
         oUqlUZq6RFkXTY+viwYl/H92QsoRxOGlMzTVtQ7hnelHuw426WNHVt7rbUXC95+ZedUp
         nkGxXzCzYH7Ss0mElmocpQJURb++I/IxuiDwq6wWt71cOGDlm2g4hN1B4EhqhsDC2nPr
         9xsQ==
X-Gm-Message-State: AC+VfDy/lmZVLVtS33bW2ledVxkkYhm6rkZZd6D41WEL7aa6mD3IMcv7
	CE+FHvN7RGm5MzOGAExdyJheQuQueOHQPkCG0XQ=
X-Google-Smtp-Source: ACHHUZ6eK3m0FtuPZmvlCaEqD65boEXkIjBDel2DzPs/M8p8JU/XpWOJD1V/XEBxdodhGM2zkceKXQ==
X-Received: by 2002:a0d:d712:0:b0:569:1e86:1c6a with SMTP id z18-20020a0dd712000000b005691e861c6amr10423128ywd.41.1685997619701;
        Mon, 05 Jun 2023 13:40:19 -0700 (PDT)
Received: from mfreemon-cf-laptop.. ([169.197.147.212])
        by smtp.gmail.com with ESMTPSA id m67-20020a0dca46000000b00561e83db519sm3572950ywd.3.2023.06.05.13.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 13:40:19 -0700 (PDT)
From: Mike Freemon <mfreemon@cloudflare.com>
To: netdev@vger.kernel.org
Cc: kernel-team@cloudflare.com,
	mfreemon@cloudflare.com
Subject: [PATCH] Add a sysctl to allow TCP window shrinking in order to honor memory limits
Date: Mon,  5 Jun 2023 15:38:57 -0500
Message-Id: <20230605203857.1672816-1-mfreemon@cloudflare.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>

Under certain circumstances, the tcp receive buffer memory limit
set by autotuning is ignored, and the receive buffer can grow
unrestrained until it reaches tcp_rmem[2].

To reproduce:  Connect a TCP session with the receiver doing
nothing and the sender sending small packets (an infinite loop
of socket send() with 4 bytes of payload with a sleep of 1 ms
in between each send()).  This will fill the tcp receive buffer
all the way to tcp_rmem[2], ignoring the autotuning limit
(sk_rcvbuf).

As a result, a host can have individual tcp sessions with receive
buffers of size tcp_rmem[2], and the host itself can reach tcp_mem
limits, causing the host to go into tcp memory pressure mode.

The fundamental issue is the relationship between the granularity
of the window scaling factor and the number of byte ACKed back
to the sender.  This problem has previously been identified in
RFC 7323, appendix F [1].

The Linux kernel currently adheres to never shrinking the window.

In addition to the overallocation of memory mentioned above, this
is also functionally incorrect, because once tcp_rmem[2] is
reached, the receiver will drop in-window packets resulting in
retransmissions and an eventual timeout of the tcp session.  A
receive buffer full condition should instead result in a zero
window and an indefinite wait.

In practice, this problem is largely hidden for most flows.  It
is not applicable to mice flows.  Elephant flows can send data
fast enough to "overrun" the sk_rcvbuf limit (in a single ACK),
triggering a zero window.

But this problem does show up for other types of flows.  A good
example are websockets and other type of flows that send small
amounts of data spaced apart slightly in time.  In these cases,
we directly encounter the problem described in [1].

RFC 7323, section 2.4 [2], says there are instances when a retracted
window can be offered, and that TCP implementations MUST ensure
that they handle a shrinking window, as specified in RFC 1122,
section 4.2.2.16 [3].  All prior RFCs on the topic of tcp window
management have made clear that sender must accept a shrunk window
from the receiver, including RFC 793 [4] and RFC 1323 [5].

This patch implements the functionality to shrink the tcp window
when necessary to keep the right edge within the memory limit by
autotuning (sk_rcvbuf).  This new functionality is enabled with
the following sysctl:

sysctl: net.ipv4.tcp_shrink_window

This sysctl changes how the TCP window is calculated.

If sysctl tcp_shrink_window is zero (the default value), then the
window is never shrunk.

If sysctl tcp_shrink_window is non-zero, then the memory limit
set by autotuning is honored.  This requires that the TCP window
be shrunk ("retracted") as described in RFC 1122.

[1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
[2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
[3] https://www.rfc-editor.org/rfc/rfc1122#page-91
[4] https://www.rfc-editor.org/rfc/rfc793
[5] https://www.rfc-editor.org/rfc/rfc1323

Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
---
 Documentation/networking/ip-sysctl.rst | 14 ++++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  9 ++++
 net/ipv4/tcp_ipv4.c                    |  2 +
 net/ipv4/tcp_output.c                  | 59 +++++++++++++++++++-------
 5 files changed, 70 insertions(+), 15 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 6ec06a33688a..6c713d3a97e5 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -970,6 +970,20 @@ tcp_tw_reuse - INTEGER
 tcp_window_scaling - BOOLEAN
 	Enable window scaling as defined in RFC1323.
 
+tcp_shrink_window - BOOLEAN
+	This changes how the TCP receive window is calculated when window
+	scaling is in effect.
+
+	RFC 7323, section 2.4, says there are instances when a retracted
+	window can be offered, and that TCP implementations MUST ensure
+	that they handle a shrinking window, as specified in RFC 1122.
+
+	- 0 - Disabled.	The window is never shrunk.
+	- 1 - Enabled.	The window is shrunk when necessary to remain within
+			the memory limit set by autotuning (sk_rcvbuf).
+
+	Default: 0
+
 tcp_wmem - vector of 3 INTEGERs: min, default, max
 	min: Amount of memory reserved for send buffers for TCP sockets.
 	Each TCP socket has rights to use it due to fact of its birth.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index db762e35aca9..e30442bdc9c0 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -65,6 +65,7 @@ struct netns_ipv4 {
 #endif
 	bool			fib_has_custom_local_routes;
 	bool			fib_offload_disabled;
+	u8			sysctl_tcp_shrink_window;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	atomic_t		fib_num_tclassid_users;
 #endif
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 40fe70fc2015..12470660744d 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1470,6 +1470,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = &tcp_plb_max_cong_thresh,
 	},
+	{
+		.procname	= "tcp_shrink_window",
+		.data		= &init_net.ipv4.sysctl_tcp_shrink_window,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 06d2573685ca..ed0ce4b4b96d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3276,6 +3276,8 @@ static int __net_init tcp_sk_init(struct net *net)
 	else
 		net->ipv4.tcp_congestion_control = &tcp_reno;
 
+	net->ipv4.sysctl_tcp_shrink_window = 0;
+
 	return 0;
 }
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cfe128b81a01..6bdd59716028 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -260,8 +260,8 @@ static u16 tcp_select_window(struct sock *sk)
 	u32 old_win = tp->rcv_wnd;
 	u32 cur_win = tcp_receive_window(tp);
 	u32 new_win = __tcp_select_window(sk);
+	struct net *net = sock_net(sk);
 
-	/* Never shrink the offered window */
 	if (new_win < cur_win) {
 		/* Danger Will Robinson!
 		 * Don't update rcv_wup/rcv_wnd here or else
@@ -270,11 +270,15 @@ static u16 tcp_select_window(struct sock *sk)
 		 *
 		 * Relax Will Robinson.
 		 */
-		if (new_win == 0)
-			NET_INC_STATS(sock_net(sk),
-				      LINUX_MIB_TCPWANTZEROWINDOWADV);
-		new_win = ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
+		if (!net->ipv4.sysctl_tcp_shrink_window) {
+			/* Never shrink the offered window */
+			if (new_win == 0)
+				NET_INC_STATS(sock_net(sk),
+					      LINUX_MIB_TCPWANTZEROWINDOWADV);
+			new_win = ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
+		}
 	}
+
 	tp->rcv_wnd = new_win;
 	tp->rcv_wup = tp->rcv_nxt;
 
@@ -2947,6 +2951,7 @@ u32 __tcp_select_window(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
+	struct net *net = sock_net(sk);
 	/* MSS for the peer's data.  Previous versions used mss_clamp
 	 * here.  I don't know if the value based on our guesses
 	 * of peer's MSS is better for the performance.  It's more correct
@@ -2968,16 +2973,24 @@ u32 __tcp_select_window(struct sock *sk)
 		if (mss <= 0)
 			return 0;
 	}
+
+	if (net->ipv4.sysctl_tcp_shrink_window) {
+		/* new window should always be an exact multiple of scaling factor */
+		free_space = round_down(free_space, 1 << tp->rx_opt.rcv_wscale);
+	}
+
 	if (free_space < (full_space >> 1)) {
 		icsk->icsk_ack.quick = 0;
 
 		if (tcp_under_memory_pressure(sk))
 			tcp_adjust_rcv_ssthresh(sk);
 
-		/* free_space might become our new window, make sure we don't
-		 * increase it due to wscale.
-		 */
-		free_space = round_down(free_space, 1 << tp->rx_opt.rcv_wscale);
+		if (!net->ipv4.sysctl_tcp_shrink_window) {
+			/* free_space might become our new window, make sure we don't
+			 * increase it due to wscale.
+			 */
+			free_space = round_down(free_space, 1 << tp->rx_opt.rcv_wscale);
+		}
 
 		/* if free space is less than mss estimate, or is below 1/16th
 		 * of the maximum allowed, try to move to zero-window, else
@@ -2988,10 +3001,24 @@ u32 __tcp_select_window(struct sock *sk)
 		 */
 		if (free_space < (allowed_space >> 4) || free_space < mss)
 			return 0;
+
+		if (net->ipv4.sysctl_tcp_shrink_window && free_space < (1 << tp->rx_opt.rcv_wscale))
+			return 0;
 	}
 
-	if (free_space > tp->rcv_ssthresh)
+	if (free_space > tp->rcv_ssthresh) {
 		free_space = tp->rcv_ssthresh;
+		if (net->ipv4.sysctl_tcp_shrink_window) {
+			/* new window should always be an exact multiple of scaling factor
+			 *
+			 * For this case, we ALIGN "up" (increase free_space) because
+			 * we know free_space is not zero here, it has been reduced from
+			 * the memory-based limit, and rcv_ssthresh is not a hard limit
+			 * (unlike sk_rcvbuf).
+			 */
+			free_space = ALIGN(free_space, (1 << tp->rx_opt.rcv_wscale));
+		}
+	}
 
 	/* Don't do rounding if we are using window scaling, since the
 	 * scaled window will not line up with the MSS boundary anyway.
@@ -2999,11 +3026,13 @@ u32 __tcp_select_window(struct sock *sk)
 	if (tp->rx_opt.rcv_wscale) {
 		window = free_space;
 
-		/* Advertise enough space so that it won't get scaled away.
-		 * Import case: prevent zero window announcement if
-		 * 1<<rcv_wscale > mss.
-		 */
-		window = ALIGN(window, (1 << tp->rx_opt.rcv_wscale));
+		if (!net->ipv4.sysctl_tcp_shrink_window) {
+			/* Advertise enough space so that it won't get scaled away.
+			 * Import case: prevent zero window announcement if
+			 * 1<<rcv_wscale > mss.
+			 */
+			window = ALIGN(window, (1 << tp->rx_opt.rcv_wscale));
+		}
 	} else {
 		window = tp->rcv_wnd;
 		/* Get the largest window that is a nice multiple of mss.
-- 
2.40.0


