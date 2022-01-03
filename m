Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7493A48355E
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbiACRL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:11:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48558 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbiACRL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 12:11:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XIJzjC4tEAGFoIhNjwKKSvz3/L4fw2WVs8Z+uLD/AME=; b=XxJyDBf85gcZGR0WtW9mabY6rm
        mb2QEdD0vSPUm9ZNBjwoOHrmJtAL+qvu+ZvIKBFFlwg6kUfb8W1nlkvWkALOhzpMS5p1UMIoAi6KU
        zc44FdVVN9nfgkx84bN1nNbCBGA984uJ5o3DnTN6g8JfIAn/5n9EtcCL4EzM5DYqSPlU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n4Qs0-000OKJ-V6; Mon, 03 Jan 2022 18:11:40 +0100
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
Subject: [PATCH v5 net-next 3/3] udp6: Use Segment Routing Header for dest address if present
Date:   Mon,  3 Jan 2022 18:11:32 +0100
Message-Id: <20220103171132.93456-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220103171132.93456-1-andrew@lunn.ch>
References: <20220103171132.93456-1-andrew@lunn.ch>
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
 include/net/seg6.h | 19 +++++++++++++++++++
 net/ipv6/udp.c     |  3 ++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index 02b0cd305787..af668f17b398 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -65,4 +65,23 @@ extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
 extern int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 			       u32 tbl_id);
+
+/* If the packet which invoked an ICMP error contains an SRH return
+ * the true destination address from within the SRH, otherwise use the
+ * destination address in the IP header.
+ */
+static inline const struct in6_addr *seg6_get_daddr(struct sk_buff *skb,
+						    struct inet6_skb_parm *opt)
+{
+	struct ipv6_sr_hdr *srh;
+
+	if (opt->flags & IP6SKB_SEG6) {
+		srh = (struct ipv6_sr_hdr *)(skb->data + opt->srhoff);
+		return  &srh->segments[0];
+	}
+
+	return NULL;
+}
+
+
 #endif
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 1accc06abc54..df216268cb02 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -41,6 +41,7 @@
 #include <net/transp_v6.h>
 #include <net/ip6_route.h>
 #include <net/raw.h>
+#include <net/seg6.h>
 #include <net/tcp_states.h>
 #include <net/ip6_checksum.h>
 #include <net/ip6_tunnel.h>
@@ -562,7 +563,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	struct ipv6_pinfo *np;
 	const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
 	const struct in6_addr *saddr = &hdr->saddr;
-	const struct in6_addr *daddr = &hdr->daddr;
+	const struct in6_addr *daddr = seg6_get_daddr(skb, opt) ? : &hdr->daddr;
 	struct udphdr *uh = (struct udphdr *)(skb->data+offset);
 	bool tunnel = false;
 	struct sock *sk;
-- 
2.34.1

