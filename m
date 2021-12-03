Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07D7467B5E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352865AbhLCQdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:33:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37908 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234855AbhLCQdc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 11:33:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ObMqh7lERFVdqc6wfTxnRhpfk0J6FLTY+2fSvC1bqbA=; b=B/cbbkC6VF4l6b6B1+O4CHUb+Y
        jSM1XC/LDg0g1dAm9kZItBO4uOIQdtzuhmTyNZxtVKRdCADzULDIF8NppKQmPcuM/tjSflayHL5wn
        y+igAdSK0N1PZIYFm2CHg5ysaOIN91L3v2Ajj5IeCJtpF7PAuwgPuxhM0QtUyZ4Na8Cs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mtBRZ-00FRQG-GC; Fri, 03 Dec 2021 17:29:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [[PATCH net-next v3] 3/3] udp6: Use Segment Routing Header for dest address if present
Date:   Fri,  3 Dec 2021 17:29:26 +0100
Message-Id: <20211203162926.3680281-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211203162926.3680281-1-andrew@lunn.ch>
References: <20211203162926.3680281-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When finding the socket to report an error on, if the invoking packet
is using Segment Routing, the IPv6 destination address is that of an
intermediate router, not the end destination. Extract the ultimate
destination address from the segment address.

This change allows traceroute to function in the presence of Segment
Routing.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/seg6.h |  2 ++
 net/ipv6/seg6.c    | 21 +++++++++++++++++++++
 net/ipv6/udp.c     |  3 ++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index 02b0cd305787..384956e9d4a3 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -60,6 +60,8 @@ extern void seg6_local_exit(void);
 extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced);
 extern struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags);
 extern void seg6_icmp_srh(struct sk_buff *skb, struct inet6_skb_parm *opt);
+extern const struct in6_addr *seg6_get_daddr(struct sk_buff *skb,
+					     struct inet6_skb_parm *opt);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 73aaabf0e966..4fd7d3793c1b 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -134,6 +134,27 @@ void seg6_icmp_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
 	skb->network_header = network_header;
 }
 
+/* If the packet which invoked an ICMP error contains an SRH return
+ * the true destination address from within the SRH, otherwise use the
+ * destination address in the IP header.
+ */
+const struct in6_addr *seg6_get_daddr(struct sk_buff *skb,
+				      struct inet6_skb_parm *opt)
+{
+	/* ipv6_hdr() does not work here, since this IP header is
+	 * nested inside an ICMP error report packet
+	 */
+	const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
+	struct ipv6_sr_hdr *srh;
+
+	if (opt->flags & IP6SKB_SEG6) {
+		srh = (struct ipv6_sr_hdr *)(skb->data + opt->srhoff);
+		return  &srh->segments[0];
+	}
+
+	return &hdr->daddr;
+}
+
 static struct genl_family seg6_genl_family;
 
 static const struct nla_policy seg6_genl_policy[SEG6_ATTR_MAX + 1] = {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 6a0e569f0bb8..47125d83920a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -40,6 +40,7 @@
 #include <net/transp_v6.h>
 #include <net/ip6_route.h>
 #include <net/raw.h>
+#include <net/seg6.h>
 #include <net/tcp_states.h>
 #include <net/ip6_checksum.h>
 #include <net/ip6_tunnel.h>
@@ -560,8 +561,8 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 {
 	struct ipv6_pinfo *np;
 	const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
+	const struct in6_addr *daddr = seg6_get_daddr(skb, opt);
 	const struct in6_addr *saddr = &hdr->saddr;
-	const struct in6_addr *daddr = &hdr->daddr;
 	struct udphdr *uh = (struct udphdr *)(skb->data+offset);
 	bool tunnel = false;
 	struct sock *sk;
-- 
2.33.1

