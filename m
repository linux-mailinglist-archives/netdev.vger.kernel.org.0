Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8585C465712
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352870AbhLAU3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:29:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34406 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245644AbhLAU3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 15:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9t/wI0fc03WGikVl5r6griFu6GhMxVqIqcBIT/nUnSw=; b=yW5Zzo8ZSNzha3AwTDZ+IkOxA/
        PE7+O6LLH9alDco1Oig1w5U/CNVUeaWRi3QZ9aQirxiQK/o8Wz4W3eaWPqxubu+P/jJeFe4aVcXQ6
        yvHOkMebluhd/2hTXq9xNnWlNbmXBY8Sn5rIgl5AuAiQmyeki51qBbHOMc+Cq0VVZmBE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msWAS-00FGAD-Au; Wed, 01 Dec 2021 21:25:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [patch RFC net-next v2 2/3] icmp: ICMPV6: Examine invoking packet for Segment Route Headers.
Date:   Wed,  1 Dec 2021 21:25:18 +0100
Message-Id: <20211201202519.3637005-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211201202519.3637005-1-andrew@lunn.ch>
References: <20211201202519.3637005-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC8754 says:

ICMP error packets generated within the SR domain are sent to source
nodes within the SR domain.  The invoking packet in the ICMP error
message may contain an SRH.  Since the destination address of a packet
with an SRH changes as each segment is processed, it may not be the
destination used by the socket or application that generated the
invoking packet.

For the source of an invoking packet to process the ICMP error
message, the ultimate destination address of the IPv6 header may be
required.  The following logic is used to determine the destination
address for use by protocol-error handlers.

*  Walk all extension headers of the invoking IPv6 packet to the
   routing extension header preceding the upper-layer header.

   -  If routing header is type 4 Segment Routing Header (SRH)

      o  The SID at Segment List[0] may be used as the destination
         address of the invoking packet.

Mangle the skb so the network header points to the invoking packet
inside the ICMP packet. The seg6 helpers can then be used on the skb
to find any segment routing headers. If found, mark this fact in the
IPv6 control block of the skb, and store the offset into the packet of
the SRH. Then restore the skb back to its old state.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/ipv6.h |  2 ++
 net/ipv6/icmp.c      | 36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 20c1f968da7c..a59d25f19385 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -133,6 +133,7 @@ struct inet6_skb_parm {
 	__u16			dsthao;
 #endif
 	__u16			frag_max_size;
+	__u16			srhoff;
 
 #define IP6SKB_XFRM_TRANSFORMED	1
 #define IP6SKB_FORWARDED	2
@@ -142,6 +143,7 @@ struct inet6_skb_parm {
 #define IP6SKB_HOPBYHOP        32
 #define IP6SKB_L3SLAVE         64
 #define IP6SKB_JUMBOGRAM      128
+#define IP6SKB_SEG6	      256
 };
 
 #if defined(CONFIG_NET_L3_MASTER_DEV)
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index a7c31ab67c5d..dd1fe8a822e3 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -57,6 +57,7 @@
 #include <net/protocol.h>
 #include <net/raw.h>
 #include <net/rawv6.h>
+#include <net/seg6.h>
 #include <net/transp_v6.h>
 #include <net/ip6_route.h>
 #include <net/addrconf.h>
@@ -818,9 +819,40 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	local_bh_enable();
 }
 
+/* Determine if the invoking packet contains a segment routing header.
+ * If it does, extract the true destination address, which is in the
+ * first segment address
+ */
+static void icmpv6_notify_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
+{
+	__u16 network_header = skb->network_header;
+	struct ipv6_sr_hdr *srh;
+
+	/* Update network header to point to the invoking packet
+	 * inside the ICMP packet, so we can use the seg6_get_srh()
+	 * helper.
+	 */
+	skb_reset_network_header(skb);
+
+	srh = seg6_get_srh(skb, 0);
+	if (!srh)
+		goto out;
+
+	if (srh->type != IPV6_SRCRT_TYPE_4)
+		goto out;
+
+	opt->flags |= IP6SKB_SEG6;
+	opt->srhoff = (unsigned char *)srh - skb->data;
+
+out:
+	/* Restore the network header back to the ICMP packet */
+	skb->network_header = network_header;
+}
+
 void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 {
 	const struct inet6_protocol *ipprot;
+	struct inet6_skb_parm *opt = IP6CB(skb);
 	int inner_offset;
 	__be16 frag_off;
 	u8 nexthdr;
@@ -829,6 +861,8 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto out;
 
+	icmpv6_notify_srh(skb, opt);
+
 	nexthdr = ((struct ipv6hdr *)skb->data)->nexthdr;
 	if (ipv6_ext_hdr(nexthdr)) {
 		/* now skip over extension headers */
@@ -853,7 +887,7 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 
 	ipprot = rcu_dereference(inet6_protos[nexthdr]);
 	if (ipprot && ipprot->err_handler)
-		ipprot->err_handler(skb, NULL, type, code, inner_offset, info);
+		ipprot->err_handler(skb, opt, type, code, inner_offset, info);
 
 	raw6_icmp_error(skb, nexthdr, type, code, inner_offset, info);
 	return;
-- 
2.33.1

