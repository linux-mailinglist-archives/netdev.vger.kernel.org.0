Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6001201974
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 19:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388545AbgFSR1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 13:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729255AbgFSR1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 13:27:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BDAC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 10:27:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f130so10728781yba.9
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZafaWqNO6CcHI+HlimiA3UFS19PbKHXoWp6DcR7K1/0=;
        b=KssRiovRE0hE+xFpvBOrzYpT9FJthNDNf6WIN7kxtAKCaoP38NAb0lE4LEmusTz1UP
         ZdpvGki+Yt8IGRwtui3W9EzWPpmQVsdE5onw8LaQl58DwzMdldlsez3vp98Neio/PeSM
         40YjrHZDdaAeZL18o2AlF/IaRhpWsDd7/QM/0yEF2/S7YzXENur3NWo8SNKW/VJlAOg9
         5XthsMbMAobXCH3u79dX+3hCi84A1ZCPWYVVGA7vToF4N/DydJeFu/g2I6vCJMUfN2fC
         mn0+OMGVQSWCAPir0nLjP4ehkj3WGR+MACWbP/J0TzA/Z/FJiQh/IxwtKFpT/+QoJTut
         PlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZafaWqNO6CcHI+HlimiA3UFS19PbKHXoWp6DcR7K1/0=;
        b=qdlUglPqzKqwyimJ7azoLqNXu63q+Mz0NVPaKwkb0DiAjnWcIJRpXAo/2hcLvTL6zJ
         ElYI9XibO/BAleX6Sa2rITA5ih5BdqUOS2onO96G9UOF3QnJQkQrf9l6HwA2ieSgVrD4
         ZWb8/l+/xJo7WapbroKffVDrqP+f2gSMHppMkQyntlcWK7AByylIOlpqucrniKSSdaGb
         T6ksBTZqxwIowjTpa06UakrNkoCdTTHVi//euXv4DVQtLCQrXko/VMBLyvbZ2TfaFpRQ
         sGxBg6sOCAHTVj18c9zvjw7PRCSrRXjbFIM1m1WrEJkGqhHbKd7TyrWTplMFTenraNaG
         p/OQ==
X-Gm-Message-State: AOAM530CpCSwcF4l/+HevslQriet4/GKmDN9E6jeR6RO+D1mbiY1ldcn
        lbJhj4/A+4BIu5Jy+D8mjQjaBOQEwdoSsQ==
X-Google-Smtp-Source: ABdhPJy0/rHiPBmUgeEqiowb+yntICzK24etBCUAIOPU31bXRm2qdAhqDp720QulJCh8v0FuQ+tgnrqdOWb9eQ==
X-Received: by 2002:a25:941:: with SMTP id u1mr8204892ybm.274.1592587670746;
 Fri, 19 Jun 2020 10:27:50 -0700 (PDT)
Date:   Fri, 19 Jun 2020 10:27:48 -0700
Message-Id: <20200619172748.15279-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next] ipv6: icmp6: avoid indirect call for icmpv6_send()
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

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/icmpv6.h | 22 +++++++++++++++++++++-
 net/ipv6/icmp.c        |  5 +++--
 net/ipv6/ip6_icmp.c    | 10 +++++-----
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index 33d37960231441d63a1d7a3d611da916734fc2cd..adeb4c6ae5affc2390db4faa02d95820eac4f70a 100644
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
+static void inline icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
+{
+	icmp6_send(skb, type, code, info, NULL);
+}
+static int inline inet6_register_icmp_sender(ip6_icmp_send_t *fn)
+{
+	BUILD_BUG_ON(fn != icmp6_send);
+	return 0;
+}
+static int inline inet6_unregister_icmp_sender(ip6_icmp_send_t *fn)
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

