Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C51E5EF777
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbiI2OZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbiI2OZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:25:17 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AB148EBB
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:25:09 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id a20so837969qtw.10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=GtHYf3iVdc+f30XeS9Wq+jWVJNM2b9jhjVfLKOLClTo=;
        b=YnKSwXpUmQ8UUSddlydFw7KFJyVDQFNUlp15V6kDKoUop1Kh135GLHMS9AgZreMCQT
         E+cVVe0hsswA2orm4JNjD5rt+I1n823bISq0p69zvhrntRMZQJfaJkrWE8v+L7co1510
         bshQRGEitsv2eKdFoCtLxENMxyFWA+qZ6OIwZllD4yaba6C0QLi1TvtM/60tUi4j0ud1
         en/KvWWksfZAx/dm7rQMSZUFtKhU9tzQ3amBuGABBDMprxRviNYhZodS0Jw2QlhS1SsT
         EFZuM5kNuNZA1Os6bYze8zxYmTiOp773WW3M98sFmEAgoCG+LblD1YclnDW/vggsKRik
         86ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=GtHYf3iVdc+f30XeS9Wq+jWVJNM2b9jhjVfLKOLClTo=;
        b=gBv42ausSKPR7jyqmpnnETjYNfFNv9kg8F67uoK4+d40c/wY/XbpT5WjQy/9Mz1/rp
         VqD1zYRzGpug2Niua0omBjW5z5SDebB2uHmarnGMrExo3tr+St8rY+raoP5c+NrGaZ9u
         FHhPwFuG3TCACVWVO+mBlaHVp+ZxvIX6WnI+2pbOrUTDw1SdxpNSmMgtI8NQfy7h2BSY
         1hsM5jkJngpJe6pJaECpK4c+1l9e0ijKsvqAgFhD0f4+xQkO1y0r79WvRVv28PXP0HHV
         G2jZJaGn/gA9YJksrg45pE39n4PIDCamaC2Vu+YJTRGLr+lC3iiDQQJcM1lWjA09S4fL
         9Uxw==
X-Gm-Message-State: ACrzQf2z0tKnGDpDg2kYNwOSYXLYWb3+A0ZflMBhLGNEWKzo/Q5nRsvE
        qtSsHQnYznnUSjrChi83h4Vp8FaU3ow=
X-Google-Smtp-Source: AMsMyM4+/CsIyrPsbTxUY5ZmOZEYfFUWP9k6D9jPqLj/lI3RRPE74ETYZoLW+sONAoPykm20ywtipA==
X-Received: by 2002:a05:622a:10c:b0:35d:4d0f:fead with SMTP id u12-20020a05622a010c00b0035d4d0ffeadmr2583401qtw.325.1664461508206;
        Thu, 29 Sep 2022 07:25:08 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id z21-20020ac87f95000000b00342f8984348sm5889952qtj.87.2022.09.29.07.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 07:25:07 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 2/5] tcp: add PLB functionality for TCP
Date:   Thu, 29 Sep 2022 14:24:44 +0000
Message-Id: <20220929142447.3821638-3-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220929142447.3821638-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
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
 include/net/tcp.h  |  28 +++++++++++++
 net/ipv4/Makefile  |   2 +-
 net/ipv4/tcp_plb.c | 102 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 1 deletion(-)
 create mode 100644 net/ipv4/tcp_plb.c

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 27e8d378c70a..c50af63addea 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2135,6 +2135,34 @@ extern void tcp_rack_advance(struct tcp_sock *tp, u8 sacked, u32 end_seq,
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
2.37.3.998.g577e59143f-goog

