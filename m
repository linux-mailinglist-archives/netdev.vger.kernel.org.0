Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F796AD07C
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjCFVcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjCFVcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:32:03 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8DE74A65
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:31:17 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id 4so7203853ilz.6
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 13:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1678138276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hMdJ/otvoAPOxBsPnenD3y3BMNquRTht8QPyBldt/mo=;
        b=Ftotev8lmSeNmKN3Hpo7ID1xwrWhZ2Emd/Fsjrz3HOQVTd4wq11xMTm3j7OtTiblU1
         n5BAwQgetPbGAKIBsXYWYOoE0y4EP3ZfcW3Lk+3//2nDlO8mLzLBTlAvO9JcnxyKNkau
         ZbUDM5dTcmjQY+KnXJYTDUycl0IoapjESR8GA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678138276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMdJ/otvoAPOxBsPnenD3y3BMNquRTht8QPyBldt/mo=;
        b=0NEw3ZL2/4QhY6OuH2WgBJ9lLgEmh4VbSAGqSTSIDghmQn4E35f51e6HW+dQzgEfxG
         sbNaeGNA9oS+LMyQ0Efaxk1POea6C2bQ/wYI9X1/Mw49emtU+vbzbAXBrsZDQuzLpk77
         cYOXxNb+DkHOG2XHxoyzaDZW15DvJ8VS+p4Oq6NqvGi3/GBGVSesaNmqZMa812bRT3fp
         d/0VYWVenFwTaWb1oQrqZuC0J0fkIxICnGUELk9GUoWo7aWxOlq+X6e8o0pMfaM3A7Me
         Jpl+nqbptReD8dKxvHNnzJS817MJbA9L/DUCvELP9REjrFJjxtNOcUH3zcmYaSqwDWAW
         0lPA==
X-Gm-Message-State: AO0yUKU9+l0mvLczlF07js2Y/TVnvFbaO5J/3m8qR0p6/KOmauQs9pnF
        jUfWHCruOnbxE6j2zAv2JfpRwpshkCn6CtIZjRU=
X-Google-Smtp-Source: AK7set8ErR4jwf3D5lKXNM0q2cjwxJi+exjVRzxehPdB7co0OClhuccUyH9TG/k7XT0buViTPVgMfA==
X-Received: by 2002:a05:6e02:20c7:b0:310:c746:d35d with SMTP id 7-20020a056e0220c700b00310c746d35dmr12273724ilq.25.1678138276162;
        Mon, 06 Mar 2023 13:31:16 -0800 (PST)
Received: from mfreemon-cf-laptop.. ([169.197.147.212])
        by smtp.gmail.com with ESMTPSA id q16-20020a02c8d0000000b00389fb6c2ca5sm3497966jao.98.2023.03.06.13.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 13:31:15 -0800 (PST)
From:   Mike Freemon <mfreemon@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
Subject: [RFC PATCH] Add a sysctl to allow TCP window shrinking in order to honor memory limits
Date:   Mon,  6 Mar 2023 15:30:58 -0600
Message-Id: <20230306213058.598516-1-mfreemon@cloudflare.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
---
 include/net/netns/ipv4.h   |  1 +
 net/ipv4/sysctl_net_ipv4.c |  7 ++++
 net/ipv4/tcp_ipv4.c        |  2 +
 net/ipv4/tcp_output.c      | 82 +++++++++++++++++++++++++++++++-------
 4 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index db762e35aca9..cb3a85ce18f8 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -194,6 +194,7 @@ struct netns_ipv4 {
 	int sysctl_udp_rmem_min;
 
 	u8 sysctl_fib_notify_on_flag_change;
+	unsigned int sysctl_tcp_shrink_window;
 
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	u8 sysctl_udp_l3mdev_accept;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 0d0cc4ef2b85..63948130950d 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1467,6 +1467,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = &tcp_plb_max_cong_thresh,
 	},
+	{
+        .procname   = "tcp_shrink_window",
+        .data       = &init_net.ipv4.sysctl_tcp_shrink_window,
+        .maxlen     = sizeof(unsigned int),
+        .mode       = 0644,
+        .proc_handler   = proc_douintvec_minmax,
+    },
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
index 71d01cf3c13e..00357e36ac3e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -260,6 +260,7 @@ static u16 tcp_select_window(struct sock *sk)
 	u32 old_win = tp->rcv_wnd;
 	u32 cur_win = tcp_receive_window(tp);
 	u32 new_win = __tcp_select_window(sk);
+	struct net *net = sock_net(sk);
 
 	/* Never shrink the offered window */
 	if (new_win < cur_win) {
@@ -269,12 +270,38 @@ static u16 tcp_select_window(struct sock *sk)
 		 * window in time.  --DaveM
 		 *
 		 * Relax Will Robinson.
+		 *
+		 * "Never shrink the offered window" is too strong.
+		 *
+		 * RFC 7323, section 2.4, says there are instances when a retracted
+		 * window can be offered, and that TCP implementations MUST ensure
+		 * that they handle a shrinking window, as specified in RFC 1122.
+		 *
+		 * This patch implements that functionality, which is enabled by
+		 * setting the following sysctl.
+		 *
+		 * sysctl: net.ipv4.tcp_shrink_window
+		 *
+		 * This sysctl changes how the TCP window is calculated.
+		 *
+		 * If sysctl tcp_shrink_window is zero (the default value), then the
+		 * window is never shrunk.
+		 *
+		 * If sysctl tcp_shrink_window is non-zero, then the memory limit
+		 * set by autotuning is honored.  This requires that the TCP window
+		 * be shrunk ("retracted") as described in RFC 1122.
+		 *
+		 * For context and additional information about this patch, see the
+		 * blog post at TODO
 		 */
-		if (new_win == 0)
-			NET_INC_STATS(sock_net(sk),
-				      LINUX_MIB_TCPWANTZEROWINDOWADV);
-		new_win = ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
+		if (!net->ipv4.sysctl_tcp_shrink_window) {
+			if (new_win == 0)
+				NET_INC_STATS(sock_net(sk),
+					      LINUX_MIB_TCPWANTZEROWINDOWADV);
+			new_win = ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
+		}
 	}
+
 	tp->rcv_wnd = new_win;
 	tp->rcv_wup = tp->rcv_nxt;
 
@@ -2947,6 +2974,7 @@ u32 __tcp_select_window(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
+	struct net *net = sock_net(sk);
 	/* MSS for the peer's data.  Previous versions used mss_clamp
 	 * here.  I don't know if the value based on our guesses
 	 * of peer's MSS is better for the performance.  It's more correct
@@ -2968,16 +2996,24 @@ u32 __tcp_select_window(struct sock *sk)
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
@@ -2988,10 +3024,26 @@ u32 __tcp_select_window(struct sock *sk)
 		 */
 		if (free_space < (allowed_space >> 4) || free_space < mss)
 			return 0;
+
+		if (net->ipv4.sysctl_tcp_shrink_window) {
+			if (free_space < (1 << tp->rx_opt.rcv_wscale))
+				return 0;
+		}
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
@@ -2999,11 +3051,13 @@ u32 __tcp_select_window(struct sock *sk)
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

