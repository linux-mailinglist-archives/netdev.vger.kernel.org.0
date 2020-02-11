Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE31159A03
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbgBKTr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:47:29 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52685 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728448AbgBKTr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 14:47:28 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5d47fe09;
        Tue, 11 Feb 2020 19:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=hRaB6i1t8LKCzPm0iPB3G6/bk
        EU=; b=vR+mNDlpNSwSZrFMMjn4Fy86AmWFV08nNTIzECrulmO1iYgFYQzVWypFD
        +hNSpP3q38u46XY4dnu7D+7zG4/bpg1vPjFrriyHpL/ELdMMUCmqGCO6mApkuMsO
        aD3fvLCc9mdWzXCUEXY1Nwk3K/NqY7HpIbMe7u2FTgUmkn3Ra0CbbO6Eg8fp9575
        s9OK1hEPFpySPf1mIo7RjJe57pNEu+u29QNJC0vsU3/goCs2TVjG1XCTlaD13V+X
        GlI3maEtYQC2ZzYhznFdi1z/gRZ5OYdvEKUZ25EJtZoaD3TYV8fpPnT1vf/Dmyzj
        WpgcCslduE7/SwW6SYPlsUeXcsfoQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id edc6fcd0 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 19:45:41 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net 1/5] icmp: introduce helper for nat'd source address in network device context
Date:   Tue, 11 Feb 2020 20:47:05 +0100
Message-Id: <20200211194709.723383-2-Jason@zx2c4.com>
In-Reply-To: <20200211194709.723383-1-Jason@zx2c4.com>
References: <20200211194709.723383-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces a helper function to be called only by network drivers
that wraps calls to icmp[v6]_send in a conntrack transformation, in case
NAT has been used. We don't want to pollute the non-driver path, though,
so we introduce this as a helper to be called by places that actually
make use of this, as suggested by Florian.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Florian Westphal <fw@strlen.de>
---
 include/linux/icmpv6.h |  6 ++++++
 include/net/icmp.h     |  6 ++++++
 net/ipv4/icmp.c        | 33 +++++++++++++++++++++++++++++++++
 net/ipv6/ip6_icmp.c    | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index ef1cbb5f454f..93338fd54af8 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -31,6 +31,12 @@ static inline void icmpv6_send(struct sk_buff *skb,
 }
 #endif
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info);
+#else
+#define icmpv6_ndo_send icmpv6_send
+#endif
+
 extern int				icmpv6_init(void);
 extern int				icmpv6_err_convert(u8 type, u8 code,
 							   int *err);
diff --git a/include/net/icmp.h b/include/net/icmp.h
index 5d4bfdba9adf..9ac2d2672a93 100644
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -43,6 +43,12 @@ static inline void icmp_send(struct sk_buff *skb_in, int type, int code, __be32
 	__icmp_send(skb_in, type, code, info, &IPCB(skb_in)->opt);
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info);
+#else
+#define icmp_ndo_send icmp_send
+#endif
+
 int icmp_rcv(struct sk_buff *skb);
 int icmp_err(struct sk_buff *skb, u32 info);
 int icmp_init(void);
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 18068ed42f25..f369e7ce685b 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -748,6 +748,39 @@ out:;
 }
 EXPORT_SYMBOL(__icmp_send);
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+#include <net/netfilter/nf_conntrack.h>
+void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
+{
+	struct sk_buff *cloned_skb = NULL;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	__be32 orig_ip;
+
+	ct = nf_ct_get(skb_in, &ctinfo);
+	if (!ct || !(ct->status & IPS_SRC_NAT)) {
+		icmp_send(skb_in, type, code, info);
+		return;
+	}
+
+	if (skb_shared(skb_in))
+		skb_in = cloned_skb = skb_clone(skb_in, GFP_ATOMIC);
+
+	if (unlikely(!skb_in || skb_network_header(skb_in) < skb_in->head ||
+	    (skb_network_header(skb_in) + sizeof(struct iphdr)) >
+	    skb_tail_pointer(skb_in) || skb_ensure_writable(skb_in,
+	    skb_network_offset(skb_in) + sizeof(struct iphdr))))
+		goto out;
+
+	orig_ip = ip_hdr(skb_in)->saddr;
+	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
+	icmp_send(skb_in, type, code, info);
+	ip_hdr(skb_in)->saddr = orig_ip;
+out:
+	consume_skb(cloned_skb);
+}
+EXPORT_SYMBOL(icmp_ndo_send);
+#endif
 
 static void icmp_socket_deliver(struct sk_buff *skb, u32 info)
 {
diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
index 02045494c24c..e0086758b6ee 100644
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -45,4 +45,38 @@ void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(icmpv6_send);
+
+#if IS_ENABLED(CONFIG_NF_NAT)
+#include <net/netfilter/nf_conntrack.h>
+void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
+{
+	struct sk_buff *cloned_skb = NULL;
+	enum ip_conntrack_info ctinfo;
+	struct in6_addr orig_ip;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb_in, &ctinfo);
+	if (!ct || !(ct->status & IPS_SRC_NAT)) {
+		icmpv6_send(skb_in, type, code, info);
+		return;
+	}
+
+	if (skb_shared(skb_in))
+		skb_in = cloned_skb = skb_clone(skb_in, GFP_ATOMIC);
+
+	if (unlikely(!skb_in || skb_network_header(skb_in) < skb_in->head ||
+	    (skb_network_header(skb_in) + sizeof(struct ipv6hdr)) >
+	    skb_tail_pointer(skb_in) || skb_ensure_writable(skb_in,
+	    skb_network_offset(skb_in) + sizeof(struct ipv6hdr))))
+		goto out;
+
+	orig_ip = ipv6_hdr(skb_in)->saddr;
+	ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
+	icmpv6_send(skb_in, type, code, info);
+	ipv6_hdr(skb_in)->saddr = orig_ip;
+out:
+	consume_skb(cloned_skb);
+}
+EXPORT_SYMBOL(icmpv6_ndo_send);
+#endif
 #endif
-- 
2.25.0

