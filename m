Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAABE6AFE70
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCHFeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjCHFeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:34:24 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388D28C53A
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:34:21 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id t1so6074987iln.8
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 21:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1678253660;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v9z4c06hN8Ofn0+JfpNmKdLKB7vgLw2YyZr/1q3jKM0=;
        b=k1mUOKmRPsZtb0Zk6j4g1ODXbIwBd52mDZK6/75bwu1F9Gf95UwYp/s0FxWSUSO7in
         yazKtdjOQRNpfpatgMr5c/h2kArJmF62y9kuJJOwMpyvP/AglTF9F+68jXRga9T6VHhQ
         RUbaRh55yLIAGsd/4C5Pf6I75cxpD8WIKpqP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678253660;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v9z4c06hN8Ofn0+JfpNmKdLKB7vgLw2YyZr/1q3jKM0=;
        b=WU0T7w4VXB0j5dRw0cwz5l8poGT6QcxdmXpEY1Mm9gbJ1siEiLn7+p01TlAS6HZ3+x
         8FfLW7eJuc7diBJAfPi2L77jK7N7+cxpOfKHt0EZeAQJKgM+rFk6f+YXKfTeOG67scvi
         YUinNlKVy9zH+ZwxiNQxWKprT5LfYSisI3OPcckjBf3k4vMqp82b85gbCBsTEQ3sfw1v
         nGUbrV4cgYDvfr0ptaLjAIpQ9eUcKtvQOLfJNx2TJLhIltwZx8Y9Iwgj99eAHQd85ATp
         n6kb74T0Wgt7TD6hpJlbR917Zh9ZfO0npKnZpCQ3WjrfPAQ3evVkWTX8Oz4cxhcW+azh
         ml6Q==
X-Gm-Message-State: AO0yUKWYks3QF6sjEO6nmO1ohwd4PVXbCN9XpWOpiFLUU675hxtS9GKd
        YvXBCaNg7bmPQXBkTfhbh6RmXeAFIWVOIRYw5dN1tQ==
X-Google-Smtp-Source: AK7set+7R82/0dDsWR5k3qzuZtrLVyGnt4h+2HlJBtJKKTAEBgaOex7VE2Bd/H7+lOu+wqhtkBpDfQ==
X-Received: by 2002:a05:6e02:2164:b0:314:5aa:94b6 with SMTP id s4-20020a056e02216400b0031405aa94b6mr12896111ilv.24.1678253660286;
        Tue, 07 Mar 2023 21:34:20 -0800 (PST)
Received: from mfreemon-cf-laptop.. ([169.197.147.212])
        by smtp.gmail.com with ESMTPSA id h17-20020a02c731000000b00375a885f908sm4585490jao.36.2023.03.07.21.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 21:34:19 -0800 (PST)
From:   Mike Freemon <mfreemon@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
Subject: [RFC PATCH v2] Add a sysctl to allow TCP window shrinking in order to honor memory limits
Date:   Tue,  7 Mar 2023 23:33:53 -0600
Message-Id: <20230308053353.675086-1-mfreemon@cloudflare.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

But this problem does show up for other types of flows.  Good
examples are websockets and other type of flows that send small
amounts of data spaced apart slightly in time.  In these cases,
we directly encounter the problem described in [1].

RFC 7323, section 2.4 [2], says there are instances when a retracted
window can be offered, and that TCP implementations MUST ensure
that they handle a shrinking window, as specified in RFC 1122,
section 4.2.2.16 [3].  All prior RFCs on the topic of tcp window
management have made clear that sender must accept a shrunk window
from the receiver, including RFC 793 [4] and RFC 1323 [5].

This patch implements the functionality to shrink the tcp window
when necessary to keep the right edge within the memory limit set
by autotuning (sk_rcvbuf).  This new functionality is enabled by
setting the sysctl net.ipv4.tcp_shrink_window to 1.

[1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
[2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
[3] https://www.rfc-editor.org/rfc/rfc1122#page-91
[4] https://www.rfc-editor.org/rfc/rfc793
[5] https://www.rfc-editor.org/rfc/rfc1323

Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
---
 Documentation/networking/ip-sysctl.rst | 14 ++++++
 include/net/netns/ipv4.h               |  2 +
 net/ipv4/sysctl_net_ipv4.c             |  7 +++
 net/ipv4/tcp_ipv4.c                    |  2 +
 net/ipv4/tcp_output.c                  | 59 +++++++++++++++++++-------
 5 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 87dd1c5283e6..67dfcadfe350 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -968,6 +968,20 @@ tcp_tw_reuse - INTEGER
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
+					the memory limit set by autotuning (sk_rcvbuf).
+
+	Default: 0
+
 tcp_wmem - vector of 3 INTEGERs: min, default, max
 	min: Amount of memory reserved for send buffers for TCP sockets.
 	Each TCP socket has rights to use it due to fact of its birth.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index db762e35aca9..fbc67afac75a 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -237,5 +237,7 @@ struct netns_ipv4 {
 
 	atomic_t	rt_genid;
 	siphash_key_t	ip_id_key;
+
+	unsigned int sysctl_tcp_shrink_window;
 };
 #endif
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 0d0cc4ef2b85..c6d181f79534 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1467,6 +1467,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = &tcp_plb_max_cong_thresh,
 	},
+	{
+		.procname	= "tcp_shrink_window",
+		.data		= &init_net.ipv4.sysctl_tcp_shrink_window,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ea370afa70ed..d976f01413d7 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3275,6 +3275,8 @@ static int __net_init tcp_sk_init(struct net *net)
 	else
 		net->ipv4.tcp_congestion_control = &tcp_reno;
 
+	net->ipv4.sysctl_tcp_shrink_window = 0;
+
 	return 0;
 }
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 71d01cf3c13e..7f7a96e797fa 100644
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
2.39.2

