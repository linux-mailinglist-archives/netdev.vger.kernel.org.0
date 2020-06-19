Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57615201AD8
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388345AbgFSTDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 15:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733241AbgFSTDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:03:04 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60419C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:03:04 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id y5so7935842qtd.0
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BHyg0my/QndGeNmsLah2cDzvP0Hw5QChruMY2dKPYMI=;
        b=rfbKK4MVCO/jvTgUfwYXTWs2zBs7W8Er/HT7M97mPW49mpjuZWz1cETepH4daYk6ZP
         sUji8ZkroGCGUV2u/najesfvpWsCflIGzrj6VePKcG3KT90Gyw53MW2LqglY77PqL90r
         /zTuiJDul+ZW4/RtrBoXUtRhqW5ILm/gWOr1GU9aldR2ROyf8HqEkh91jmTHzfKvyiX1
         A6A291+FOOnpWKrsBj9WFKoVthg5ZG/OdcpVFHGfoB9p24AHpnPz3iuK3oTeKdv+UnZx
         ME+LcrqhJqfucFsrLL17UIOuQeic/rOEsziHgFuXrXrCaotpmxEeC3J0m0oI9k1FJHOV
         a4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BHyg0my/QndGeNmsLah2cDzvP0Hw5QChruMY2dKPYMI=;
        b=YbzdbxhZhDFpo0fhxyWJeSXB9MTqflKsglM5+2KpyIRjy76nfczvVAV2TYrT1/+bPf
         0rmuMcQjDLl4BKGNnvCclJLULh5MM40eed3gEYK0mzZDRRFCfYwCNE3zmTBGPvTRDfyQ
         xj99Q8Z2mGouh+IzFXsHFcycHm2dIZZ/ftrcHBPIPnPSOTVHG9sRxjJvOf25DtX/ijZy
         LN4cdciFyg/qfWhRbK2AbaxUh/WISFODhjOfqS68t0abk08FqAkHEpN3VS0+5Hi0el+r
         LqMCUnTHITm9MUUQ0BnKNjJJAXk9tu6/WZH1GnQKsHDEzZTdgpFMGqCw4cP1I/F6NZ8+
         3KVw==
X-Gm-Message-State: AOAM530Rw/+pnSYWTy9MGorpoTApqdh8fj3uY06rzjAfJQ1JHi5l0BV9
        Ie5jCw5SVOIdO6s0AXvvI1iGTKTwK4BYBw==
X-Google-Smtp-Source: ABdhPJxXA2OwLH4kP0b3JJxz2GRFXqR2RtqHHV1inkNKyJRF/KLpch8onQ7bTKbwEAh5ySbG3PZQli3D3hendQ==
X-Received: by 2002:a05:6214:1705:: with SMTP id db5mr10235927qvb.14.1592593383582;
 Fri, 19 Jun 2020 12:03:03 -0700 (PDT)
Date:   Fri, 19 Jun 2020 12:02:59 -0700
Message-Id: <20200619190259.170189-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH v2 net-next] ipv6: icmp6: avoid indirect call for icmpv6_send()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IPv6 is builtin, we do not need an expensive indirect call
to reach cmp6_send().

v2: put inline keyword before the type to avoid sparse warnings.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/icmpv6.h | 22 +++++++++++++++++++++-
 net/ipv6/icmp.c        |  5 +++--
 net/ipv6/ip6_icmp.c    | 10 +++++-----
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index 33d37960231441d63a1d7a3d611da916734fc2cd..1b3371ae819362466c88fad6fe4ee7c9907390c7 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -13,12 +13,32 @@ static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
 #include <linux/netdevice.h>
 
 #if IS_ENABLED(CONFIG_IPV6)
-extern void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info);
 
 typedef void ip6_icmp_send_t(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 			     const struct in6_addr *force_saddr);
+#if IS_BUILTIN(CONFIG_IPV6)
+void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
+		const struct in6_addr *force_saddr);
+static inline void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
+{
+	icmp6_send(skb, type, code, info, NULL);
+}
+static inline int inet6_register_icmp_sender(ip6_icmp_send_t *fn)
+{
+	BUILD_BUG_ON(fn != icmp6_send);
+	return 0;
+}
+static inline int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn)
+{
+	BUILD_BUG_ON(fn != icmp6_send);
+	return 0;
+}
+#else
+extern void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info);
 extern int inet6_register_icmp_sender(ip6_icmp_send_t *fn);
 extern int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn);
+#endif
+
 int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
 			       unsigned int data_len);
 
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index fc5000370030d67094ba11f15aaaaaa7ba519cde..91e0f2fd2523e6fb7d47c5a92e997c90ad53b9fc 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -439,8 +439,8 @@ static int icmp6_iif(const struct sk_buff *skb)
 /*
  *	Send an ICMP message in response to a packet in error
  */
-static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
-		       const struct in6_addr *force_saddr)
+void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
+		const struct in6_addr *force_saddr)
 {
 	struct inet6_dev *idev = NULL;
 	struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -625,6 +625,7 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 out_bh_enable:
 	local_bh_enable();
 }
+EXPORT_SYMBOL(icmp6_send);
 
 /* Slightly more convenient version of icmp6_send.
  */
diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
index e0086758b6ee3c3e91568e59028838c770fac795..70c8c2f36c980cd95db10380a1702a6d08e8c223 100644
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -9,6 +9,8 @@
 
 #if IS_ENABLED(CONFIG_IPV6)
 
+#if !IS_BUILTIN(CONFIG_IPV6)
+
 static ip6_icmp_send_t __rcu *ip6_icmp_send;
 
 int inet6_register_icmp_sender(ip6_icmp_send_t *fn)
@@ -37,14 +39,12 @@ void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
 
 	rcu_read_lock();
 	send = rcu_dereference(ip6_icmp_send);
-
-	if (!send)
-		goto out;
-	send(skb, type, code, info, NULL);
-out:
+	if (send)
+		send(skb, type, code, info, NULL);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(icmpv6_send);
+#endif
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 #include <net/netfilter/nf_conntrack.h>
-- 
2.27.0.111.gc72c7da667-goog

