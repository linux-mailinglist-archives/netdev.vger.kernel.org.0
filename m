Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFA25F03F5
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 06:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbiI3Ezl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 00:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiI3Ez3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 00:55:29 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD74110EEA
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:06 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id gb14so2055067qtb.3
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=BzWI29pkGwtlT/PCh4dPqvhE13PbJksVNQXbLVRhbcM=;
        b=A42FfI2xC9E1X3zoJzR1jO3W6aJPbFvlaFeLNKavGCxGwBUDYxsckx4liLMp/1JAzF
         cG/YcKcD53MjDB3IQ+p09ETmk5ISI6KVuhcOjwNH/ywF4WVnJhqomeuRl/bY2+oFUpZ3
         4fQsT3onmTson8tRXZ1WqBaK5cokV456Cm50A91yzJUuBf3XBmhy+gakt3L+jkQuiyk/
         ZIzXTdbhicVJdIMy/pfLzok7AkfZuKnpHV0c+D3SRqsyMXsK5lUq86r1VDVIhh/Xa5fM
         Bhi4My0ZSis/07WTg+JkEVC3+z4wIWoO4EFnfkXhlw0T00f6H+2lVUDT9oq5exgoUm0D
         nEdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=BzWI29pkGwtlT/PCh4dPqvhE13PbJksVNQXbLVRhbcM=;
        b=IUsu4tRZKkzIxA1P3v1TkGmb620Rp/bk8l7roqTSgtETkrKGzzo62k/8eAQd4JkLxb
         ehwcrD1fH0PfSBy/GbDLM7t2zH2KyYyRNOeONolKIOHAztZR00816oGecx8txmuZryAC
         v6c4RRBoXBrivUOapPf25YH2cP7JbjW4gUT+vhkRYwNJji6R72Hlc+62bKqS0l99EaRS
         yzzI0IA1QcfifNI+yaCU//zkQzlKIOuc/kF/VRZls4gzgaRLFiPqva2RRhJkIaccB2WM
         XdNvkhzhpvBtYBwJIhET/VUyDY11qYMG3a6rgLS3y3B37V1CsNAAPAJfkM9Ds7jSpV76
         iz+A==
X-Gm-Message-State: ACrzQf3DdBHxDuJjetvxKFQWAhUw+ibGSwdaPgyuxHSFSdMlBQNwDE+m
        3mcFrxS4ZrQm3nXhBBbj84vZVmSjWYMEKw==
X-Google-Smtp-Source: AMsMyM7/P4nd8i3zofMAVHR6Kvz7dbTM4yRPYhm1IMopZvsNBZrgVqgutiNv930q8wE85oOA1zc45A==
X-Received: by 2002:a05:622a:130a:b0:35b:b454:8644 with SMTP id v10-20020a05622a130a00b0035bb4548644mr5372418qtk.624.1664513632635;
        Thu, 29 Sep 2022 21:53:52 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id de9-20020a05620a370900b006bb82221013sm1550059qkb.0.2022.09.29.21.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 21:53:52 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v2 2/5] tcp: add PLB functionality for TCP
Date:   Fri, 30 Sep 2022 04:53:17 +0000
Message-Id: <20220930045320.5252-3-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220930045320.5252-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
 <20220930045320.5252-1-mubashirmaq@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mubashir Adnan Qureshi <mubashirq@google.com>

Congestion control algorithms track PLB state and cause the connection
to trigger a path change when either of the 2 conditions is satisfied:

- No packets are in flight and (# consecutive congested rounds >=
  sysctl_tcp_plb_idle_rehash_rounds)
- (# consecutive congested rounds >= sysctl_tcp_plb_rehash_rounds)

A round (RTT) is marked as congested when congestion signal
(ECN ce_ratio) over an RTT is greater than sysctl_tcp_plb_cong_thresh.
In the event of RTO, PLB (via tcp_write_timeout()) triggers a path
change and disables congestion-triggered path changes for random time
between (sysctl_tcp_plb_suspend_rto_sec, 2*sysctl_tcp_plb_suspend_rto_sec)
to avoid hopping onto the "connectivity blackhole". RTO-triggered
path changes can still happen during this cool-off period.

Signed-off-by: Mubashir Adnan Qureshi <mubashirq@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h   |  28 ++++++++++++
 net/ipv4/Makefile   |   2 +-
 net/ipv4/tcp_ipv4.c |   2 +-
 net/ipv4/tcp_plb.c  | 102 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 132 insertions(+), 2 deletions(-)
 create mode 100644 net/ipv4/tcp_plb.c

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4f71cc15ff8e..41d4757a695b 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2137,6 +2137,34 @@ extern void tcp_rack_advance(struct tcp_sock *tp, u8 sacked, u32 end_seq,
 extern void tcp_rack_reo_timeout(struct sock *sk);
 extern void tcp_rack_update_reo_wnd(struct sock *sk, struct rate_sample *rs);
 
+/* tcp_plb.c */
+
+/*
+ * Scaling factor for fractions in PLB. For example, tcp_plb_update_state
+ * expects cong_ratio which represents fraction of traffic that experienced
+ * congestion over a single RTT. In order to avoid floating point operations,
+ * this fraction should be mapped to (1 << TCP_PLB_SCALE) and passed in.
+ */
+#define TCP_PLB_SCALE 8
+
+/* State for PLB (Protective Load Balancing) for a single TCP connection. */
+struct tcp_plb_state {
+	u8	consec_cong_rounds:5, /* consecutive congested rounds */
+		unused:3;
+	u32	pause_until; /* jiffies32 when PLB can resume rerouting */
+};
+
+static inline void tcp_plb_init(const struct sock *sk,
+				struct tcp_plb_state *plb)
+{
+	plb->consec_cong_rounds = 0;
+	plb->pause_until = 0;
+}
+void tcp_plb_update_state(const struct sock *sk, struct tcp_plb_state *plb,
+			  const int cong_ratio);
+void tcp_plb_check_rehash(struct sock *sk, struct tcp_plb_state *plb);
+void tcp_plb_update_state_upon_rto(struct sock *sk, struct tcp_plb_state *plb);
+
 /* At how many usecs into the future should the RTO fire? */
 static inline s64 tcp_rto_delta_us(const struct sock *sk)
 {
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index bbdd9c44f14e..af7d2cf490fb 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -10,7 +10,7 @@ obj-y     := route.o inetpeer.o protocol.o \
 	     tcp.o tcp_input.o tcp_output.o tcp_timer.o tcp_ipv4.o \
 	     tcp_minisocks.o tcp_cong.o tcp_metrics.o tcp_fastopen.o \
 	     tcp_rate.o tcp_recovery.o tcp_ulp.o \
-	     tcp_offload.o datagram.o raw.o udp.o udplite.o \
+	     tcp_offload.o tcp_plb.o datagram.o raw.o udp.o udplite.o \
 	     udp_offload.o arp.o icmp.o devinet.o af_inet.o igmp.o \
 	     fib_frontend.o fib_semantics.o fib_trie.o fib_notifier.o \
 	     inet_fragment.o ping.o ip_tunnel_core.o gre_offload.o \
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e3911138edae..3b23410a3aea 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3222,7 +3222,7 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_plb_rehash_rounds = 12;
 	net->ipv4.sysctl_tcp_plb_suspend_rto_sec = 60;
 	/* Default congestion threshold for PLB to mark a round is 50% */
-	net->ipv4.sysctl_tcp_plb_cong_thresh = 128;
+	net->ipv4.sysctl_tcp_plb_cong_thresh = (1 << TCP_PLB_SCALE) / 2;
 
 	/* Reno is always built in */
 	if (!net_eq(net, &init_net) &&
diff --git a/net/ipv4/tcp_plb.c b/net/ipv4/tcp_plb.c
new file mode 100644
index 000000000000..26ffc5a45f53
--- /dev/null
+++ b/net/ipv4/tcp_plb.c
@@ -0,0 +1,102 @@
+/* Protective Load Balancing (PLB)
+ *
+ * PLB was designed to reduce link load imbalance across datacenter
+ * switches. PLB is a host-based optimization; it leverages congestion
+ * signals from the transport layer to randomly change the path of the
+ * connection experiencing sustained congestion. PLB prefers to repath
+ * after idle periods to minimize packet reordering. It repaths by
+ * changing the IPv6 Flow Label on the packets of a connection, which
+ * datacenter switches include as part of ECMP/WCMP hashing.
+ *
+ * PLB is described in detail in:
+ *
+ *	Mubashir Adnan Qureshi, Yuchung Cheng, Qianwen Yin, Qiaobin Fu,
+ *	Gautam Kumar, Masoud Moshref, Junhua Yan, Van Jacobson,
+ *	David Wetherall,Abdul Kabbani:
+ *	"PLB: Congestion Signals are Simple and Effective for
+ *	 Network Load Balancing"
+ *	In ACM SIGCOMM 2022, Amsterdam Netherlands.
+ *
+ */
+
+#include <net/tcp.h>
+
+/* Called once per round-trip to update PLB state for a connection. */
+void tcp_plb_update_state(const struct sock *sk, struct tcp_plb_state *plb,
+			  const int cong_ratio)
+{
+	struct net *net = sock_net(sk);
+
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_plb_enabled))
+		return;
+
+	if (cong_ratio >= 0) {
+		if (cong_ratio < READ_ONCE(net->ipv4.sysctl_tcp_plb_cong_thresh))
+			plb->consec_cong_rounds = 0;
+		else if (plb->consec_cong_rounds <
+			 READ_ONCE(net->ipv4.sysctl_tcp_plb_rehash_rounds))
+			plb->consec_cong_rounds++;
+	}
+}
+EXPORT_SYMBOL_GPL(tcp_plb_update_state);
+
+/* Check whether recent congestion has been persistent enough to warrant
+ * a load balancing decision that switches the connection to another path.
+ */
+void tcp_plb_check_rehash(struct sock *sk, struct tcp_plb_state *plb)
+{
+	struct net *net = sock_net(sk);
+	bool can_idle_rehash, can_force_rehash;
+	u32 max_suspend;
+
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_plb_enabled))
+		return;
+
+	/* Note that tcp_jiffies32 can wrap; we detect wraps by checking for
+	 * cases where the max suspension end is before the actual suspension
+	 * end. We clear pause_until to 0 to indicate there is no recent
+	 * RTO event that constrains PLB rehashing.
+	 */
+	max_suspend = 2 * READ_ONCE(net->ipv4.sysctl_tcp_plb_suspend_rto_sec) * HZ;
+	if (plb->pause_until &&
+	    (!before(tcp_jiffies32, plb->pause_until) ||
+	     before(tcp_jiffies32 + max_suspend, plb->pause_until)))
+		plb->pause_until = 0;
+
+	can_idle_rehash = READ_ONCE(net->ipv4.sysctl_tcp_plb_idle_rehash_rounds) &&
+			  !tcp_sk(sk)->packets_out &&
+			  plb->consec_cong_rounds >=
+			  READ_ONCE(net->ipv4.sysctl_tcp_plb_idle_rehash_rounds);
+	can_force_rehash = plb->consec_cong_rounds >=
+			   READ_ONCE(net->ipv4.sysctl_tcp_plb_rehash_rounds);
+
+	if (!plb->pause_until && (can_idle_rehash || can_force_rehash)) {
+		sk_rethink_txhash(sk);
+		plb->consec_cong_rounds = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(tcp_plb_check_rehash);
+
+/* Upon RTO, disallow load balancing for a while, to avoid having load
+ * balancing decisions switch traffic to a black-holed path that was
+ * previously avoided with a sk_rethink_txhash() call at RTO time.
+ */
+void tcp_plb_update_state_upon_rto(struct sock *sk, struct tcp_plb_state *plb)
+{
+	struct net *net = sock_net(sk);
+	u32 pause;
+
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_plb_enabled))
+		return;
+
+	pause = READ_ONCE(net->ipv4.sysctl_tcp_plb_suspend_rto_sec) * HZ;
+	pause += prandom_u32_max(pause);
+	plb->pause_until = tcp_jiffies32 + pause;
+
+	/* Reset PLB state upon RTO, since an RTO causes a sk_rethink_txhash() call
+	 * that may switch this connection to a path with completely different
+	 * congestion characteristics.
+	 */
+	plb->consec_cong_rounds = 0;
+}
+EXPORT_SYMBOL_GPL(tcp_plb_update_state_upon_rto);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

