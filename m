Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BDF156ADA
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 15:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgBIOb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 09:31:58 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:50091 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727514AbgBIOb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Feb 2020 09:31:58 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5708746a;
        Sun, 9 Feb 2020 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=JJFus9S7NRZEQ1ty6m+23awMJTw=; b=rMItmok5qKFDcXSCJLct
        G83276y/f1XDr/0c6xZCaxRXY4UEylB08qVqtRzAY3D8rGReizfbDywDxHiWn/MW
        hJE/UayShC2Ao1OIneiAq0A+SjB6vQfh/zegFemG+SFzmkMAr0imLtTrSvWjrGNm
        LmYntBRTobemUoydPSr0b6LyEMBl9Vt+UAkRZSY6SyQV23BFIeUgiv7dEFMZDnBF
        ZDXF48ZVw3rB+mJU+wPUYywBZGuRTQk7QqAIn4Nyogi+sS5tQbZJEUiKPtfxckJ0
        bj0OeYTL+y8EkgWcrYuX1UVX1PkIlBLneX6ht2CfzB0+5anrx/NChh5PRVRupaJY
        mQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id be171211 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 9 Feb 2020 14:30:28 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 1/5] icmp: introduce helper for NAT'd source address in ndo context
Date:   Sun,  9 Feb 2020 15:31:39 +0100
Message-Id: <20200209143143.151632-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ICMP routines use the source address for two reasons:

    1. Rate-limiting ICMP transmissions based on source address, so
       that one source address cannot provoke a flood of replies. If
       the source address is wrong, the rate limiting will be
       incorrectly applied.

    2. Choosing the interface and hence new source address of the
       generated ICMP packet. If the original packet source address
       is wrong, ICMP replies will be sent from the wrong source
       address, resulting in either a misdelivery, infoleak, or just
       general network admin confusion.

Most of the time, the icmp_send and icmpv6_send routines can just reach
down into the skb's IP header to determine the saddr. However, if
icmp_send or icmpv6_send is being called from a network device driver --
there are a few in the tree -- then it's possible that by the time
icmp_send or icmpv6_send looks at the packet, the packet's source
address has already been transformed by SNAT or MASQUERADE or some other
transformation that CONNTRACK knows about. In this case, the packet's
source address is most certainly the *wrong* source address to be used
for the purpose of ICMP replies.

Rather, the source address we want to use for ICMP replies is the
original one, from before the transformation occurred.

Fortunately, it's very easy to just ask CONNTRACK if it knows about this
packet, and if so, how to fix it up. The saddr is the only field in the
header we need to fix up, for the purposes of the subsequent processing
in the icmp_send and icmpv6_send functions, so we do the lookup very
early on, so that the rest of the ICMP machinery can progress as usual.

We don't want to pollute the non-driver path, though, so we introduce
this as a helper to be called by places that actually make use of
this, as suggested by Florian.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Florian Westphal <fw@strlen.de>
---
Dave - this fixes bugs, so net.git seemed fitting, but if you think this
is a bit invasive or will require several more series of development, I
don't mind working on this in net-next.git instead.

 include/linux/icmpv6.h |  6 ++++++
 include/net/icmp.h     |  6 ++++++
 net/ipv4/icmp.c        | 14 ++++++++++++++
 net/ipv6/ip6_icmp.c    | 15 +++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index ef1cbb5f454f..47cea3779eb1 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -31,6 +31,12 @@ static inline void icmpv6_send(struct sk_buff *skb,
 }
 #endif
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+void icmpv6_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info);
+#else
+#define icmpv6_ndo_send icmpv6_send
+#endif
+
 extern int				icmpv6_init(void);
 extern int				icmpv6_err_convert(u8 type, u8 code,
 							   int *err);
diff --git a/include/net/icmp.h b/include/net/icmp.h
index 5d4bfdba9adf..30257506c038 100644
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -43,6 +43,12 @@ static inline void icmp_send(struct sk_buff *skb_in, int type, int code, __be32
 	__icmp_send(skb_in, type, code, info, &IPCB(skb_in)->opt);
 }
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info);
+#else
+#define icmp_ndo_send icmp_send
+#endif
+
 int icmp_rcv(struct sk_buff *skb);
 int icmp_err(struct sk_buff *skb, u32 info);
 int icmp_init(void);
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 18068ed42f25..54b923bca655 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -748,6 +748,20 @@ out:;
 }
 EXPORT_SYMBOL(__icmp_send);
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack.h>
+void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb_in, &ctinfo);
+	if (ct)
+		ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
+	icmp_send(skb_in, type, code, info);
+}
+EXPORT_SYMBOL(icmp_ndo_send);
+#endif
 
 static void icmp_socket_deliver(struct sk_buff *skb, u32 info)
 {
diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
index 02045494c24c..c79bf2d616cf 100644
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -45,4 +45,19 @@ void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(icmpv6_send);
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack.h>
+void icmpv6_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb_in, &ctinfo);
+	if (ct)
+		ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
+	icmpv6_send(skb_in, type, code, info);
+}
+EXPORT_SYMBOL(icmpv6_ndo_send);
+#endif
 #endif
-- 
2.25.0

