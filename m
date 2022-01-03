Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386A0483560
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbiACRL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:11:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48564 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235030AbiACRL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 12:11:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=q71yBXkWpnHmqVYYhwWNLWcfsaAdC6LUYwApTrEBA2o=; b=QhO21K5oRM1+U6R5kkYdyqaKSL
        7A5TtdpjuS2fqWsf6y8DkvaX9b/9akWQxfjKpJB4hA6K8QVE1zmLNJgkdMKYtkjnOtr/lpN3pZtJx
        HygCBO51fmSL1IIb1KFHgXO4dAlUe37pWheC0mTuDCGyw49rA3v2WvX6n9oHis4IxHD0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n4Qs0-000OKG-TY; Mon, 03 Jan 2022 18:11:40 +0100
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
Subject: [PATCH v5 net-next 2/3] icmp: ICMPV6: Examine invoking packet for Segment Route Headers.
Date:   Mon,  3 Jan 2022 18:11:31 +0100
Message-Id: <20220103171132.93456-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220103171132.93456-1-andrew@lunn.ch>
References: <20220103171132.93456-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 include/net/seg6.h   |  1 +
 net/ipv6/icmp.c      |  6 +++++-
 net/ipv6/seg6.c      | 30 ++++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 1 deletion(-)

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
diff --git a/include/net/seg6.h b/include/net/seg6.h
index a6f25983670a..02b0cd305787 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -59,6 +59,7 @@ extern void seg6_local_exit(void);
 
 extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced);
 extern struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags);
+extern void seg6_icmp_srh(struct sk_buff *skb, struct inet6_skb_parm *opt);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index a7c31ab67c5d..96c5cc0f30ce 100644
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
@@ -820,6 +821,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 
 void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 {
+	struct inet6_skb_parm *opt = IP6CB(skb);
 	const struct inet6_protocol *ipprot;
 	int inner_offset;
 	__be16 frag_off;
@@ -829,6 +831,8 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto out;
 
+	seg6_icmp_srh(skb, opt);
+
 	nexthdr = ((struct ipv6hdr *)skb->data)->nexthdr;
 	if (ipv6_ext_hdr(nexthdr)) {
 		/* now skip over extension headers */
@@ -853,7 +857,7 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 
 	ipprot = rcu_dereference(inet6_protos[nexthdr]);
 	if (ipprot && ipprot->err_handler)
-		ipprot->err_handler(skb, NULL, type, code, inner_offset, info);
+		ipprot->err_handler(skb, opt, type, code, inner_offset, info);
 
 	raw6_icmp_error(skb, nexthdr, type, code, inner_offset, info);
 	return;
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 5bc9bf892199..73aaabf0e966 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -104,6 +104,36 @@ struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags)
 	return srh;
 }
 
+/* Determine if an ICMP invoking packet contains a segment routing
+ * header.  If it does, extract the offset to the true destination
+ * address, which is in the first segment address.
+ */
+void seg6_icmp_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
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
 static struct genl_family seg6_genl_family;
 
 static const struct nla_policy seg6_genl_policy[SEG6_ATTR_MAX + 1] = {
-- 
2.34.1

