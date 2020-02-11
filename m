Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EFB15926D
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgBKPAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:00:47 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34135 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgBKPAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 10:00:46 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id dbafbced;
        Tue, 11 Feb 2020 14:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=3uXxfPkhVfNwm/pqA20yRBoDW
        6A=; b=PIA+qVseu7WnVo3wGwPiEI3+Xp5nEQh/8IaY9j5ttNQDnsVDF8orHhakI
        UiegCp459UqODsUUP3xqjd/FB6vqJPE6rPcqm+qwqFlMD21irKVrax5CLtLl/Mj4
        VNPJ7v4s20fVYqPJukwY2Am+TFdPlSszmkJts5S9MGonceMRb3FzPaiH/2YcwNy0
        2MMnmgQzw6Go0agzaQqvlJVMakZ0MjWncaEpQNJbWTJgHhwCbAX2xRyuV1S+cWK4
        +wWnhCgKgHGjEVQehEAzy+lafIi52RD7GQ4hhkbO+CmqFRp2cG4+2ZzLeARjlxvI
        C+NEoDcgf+ZrJrk+/CZOZNSVALvoA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 410533aa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 14:59:01 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 net 1/9] icmp: introduce helper for nat'd source address in network device context
Date:   Tue, 11 Feb 2020 16:00:20 +0100
Message-Id: <20200211150028.688073-2-Jason@zx2c4.com>
In-Reply-To: <20200211150028.688073-1-Jason@zx2c4.com>
References: <20200210141423.173790-2-Jason@zx2c4.com>
 <20200211150028.688073-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces a helper function to be called only by network drivers
that wraps calls to icmp[v6]_send in a conntrack transformation, in case
NAT has been used. The transformation happens only from a non-shared skb
context, and the skb is fixed back up to its original state after, in
case the calling code continues to use it.

We don't want to pollute the non-driver path, though, so we introduce
this as a helper to be called by places that actually make use of
this, as suggested by Florian.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Florian Westphal <fw@strlen.de>
---
 include/linux/icmpv6.h |  6 ++++++
 include/net/icmp.h     |  6 ++++++
 net/ipv4/icmp.c        | 28 ++++++++++++++++++++++++++++
 net/ipv6/ip6_icmp.c    | 29 +++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+)

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
index 18068ed42f25..0cd23df4ad5c 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -748,6 +748,34 @@ out:;
 }
 EXPORT_SYMBOL(__icmp_send);
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+#include <net/netfilter/nf_conntrack.h>
+void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
+{
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
+	if (unlikely(WARN_ON(skb_shared(skb_in)) ||
+	    skb_network_header(skb_in) < skb_in->head ||
+	    (skb_network_header(skb_in) + sizeof(struct iphdr)) >
+	    skb_tail_pointer(skb_in) || skb_ensure_writable(skb_in,
+	    skb_network_offset(skb_in) + sizeof(struct iphdr))))
+		return;
+
+	orig_ip = ip_hdr(skb_in)->saddr;
+	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
+	icmp_send(skb_in, type, code, info);
+	ip_hdr(skb_in)->saddr = orig_ip;
+}
+EXPORT_SYMBOL(icmp_ndo_send);
+#endif
 
 static void icmp_socket_deliver(struct sk_buff *skb, u32 info)
 {
diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
index 02045494c24c..00e94e1dffae 100644
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -45,4 +45,33 @@ void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(icmpv6_send);
+
+#if IS_ENABLED(CONFIG_NF_NAT)
+#include <net/netfilter/nf_conntrack.h>
+void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
+{
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
+	if (unlikely(WARN_ON(skb_shared(skb_in)) ||
+	    skb_network_header(skb_in) < skb_in->head ||
+	    (skb_network_header(skb_in) + sizeof(struct ipv6hdr)) >
+	    skb_tail_pointer(skb_in) || skb_ensure_writable(skb_in,
+	    skb_network_offset(skb_in) + sizeof(struct ipv6hdr))))
+		return;
+
+	orig_ip = ipv6_hdr(skb_in)->saddr;
+	ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
+	icmpv6_send(skb_in, type, code, info);
+	ipv6_hdr(skb_in)->saddr = orig_ip;
+}
+EXPORT_SYMBOL(icmpv6_ndo_send);
+#endif
 #endif
-- 
2.25.0

