Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43E312A3B9
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 18:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfLXR4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 12:56:22 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41615 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfLXR4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 12:56:21 -0500
Received: by mail-pg1-f196.google.com with SMTP id x8so10670271pgk.8
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 09:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JqpeM+oW5jxEfG3sJewzQg5xxBlMnROukK73i/KAe6w=;
        b=UnA3EagZZZJzb67G1jtyKX61qx8UrDbciFiBU4T/kU57c8CHzlOim8Bfa/lb3U/tC9
         VpDyX8GcUxqYs8+EwOz4mWkSwy6FDr7gQJvCFarUpVmfRQEy+1vyXujobemTRA4pAuY8
         07ttwB51LMAnzeBTkoanC1WBDoj2N/Lfc3iqQSp7o0jyEYmVLAx/qKUvtSRpzLB2UYfg
         iDTbxblqqaDkdnelgg3Nsg7paYkBZQZZNZ5Y8Vltef55wrkcoVboM/tTsbme2YmcW3p1
         vUrQ6VJ8dKzLdm89CbRprW7hhFMYEsAxujdGQKndadqWCFRtOOh1IqnjlQZ6on7/NPkj
         MDAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JqpeM+oW5jxEfG3sJewzQg5xxBlMnROukK73i/KAe6w=;
        b=ZGAZk7oaaITqPHLmf87esxVx+bn1wZgyA5nE1czezHGZhFB0OG7P2x8ngzFJQ3pDWE
         UMe2eUW8CP7GgGoH8vKl25Fc7AgwPTJFxbf/42FkuSQPoAtI3SarSnJViTZboZ5iKhjY
         5insKpZueIw+amv1pvAEk4wH5y0tPUB/FfqVNhKAPmmWjIHb17ivtGU+JNw4p45612XN
         4KhVPDmtyawIm3kua2jwt1Ehv46ucvY2g+VehyEpfTn+817BrLDb/yT0kH4phsrIV5AV
         W0Mq4TVkMDsYPEYOxyikFxmgg3U+9M8/DXWlQ8U1DHt7vuhaNQeuXReeYM8H89KVTw1F
         SqKg==
X-Gm-Message-State: APjAAAU/HK3S05vbhGW3AkEjb5T1uMpT4Azv0lpf2iBUhDc/rpvW0Ah5
        nBSsLiCmxm+voSG/ED4WTrq8mA==
X-Google-Smtp-Source: APXvYqwKViLOFg1ZsKhzZJni71WSdNWCw5Rxhf2RvVTekplItDVZYdIHSgNFUl/nmmLDWckQe5FzOw==
X-Received: by 2002:a63:1a1c:: with SMTP id a28mr39978650pga.374.1577210180474;
        Tue, 24 Dec 2019 09:56:20 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id l22sm4410433pjc.0.2019.12.24.09.56.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 24 Dec 2019 09:56:19 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com, willemdebruijn.kernel@gmail.com
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v7 net-next 4/9] ipeh: Generic TLV parser
Date:   Tue, 24 Dec 2019 09:55:43 -0800
Message-Id: <1577210148-7328-5-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577210148-7328-1-git-send-email-tom@herbertland.com>
References: <1577210148-7328-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@quantonium.net>

Create a generic TLV parser. This will be used with various
extension headers that carry options including Destination,
Hop-by-Hop, Segment Routing TLVs, and other cases of simple
stateless TLV parsing.

Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 include/net/ipeh.h        |  11 ++++
 net/ipv6/exthdrs.c        | 142 ++--------------------------------------------
 net/ipv6/exthdrs_common.c | 137 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 154 insertions(+), 136 deletions(-)

diff --git a/include/net/ipeh.h b/include/net/ipeh.h
index 3b24831..81f92f8 100644
--- a/include/net/ipeh.h
+++ b/include/net/ipeh.h
@@ -31,4 +31,15 @@ struct ipv6_txoptions *ipeh_renew_options(struct sock *sk,
 struct ipv6_txoptions *ipeh_fixup_options(struct ipv6_txoptions *opt_space,
 					  struct ipv6_txoptions *opt);
 
+/* The generic TLV parser assumes that the type value of PAD1 is 0, and PADN
+ * is 1. This is true for IPv6 Destination and Hop-by-Hop Options. For Segment
+ * Routing TLVs, PAD1 is also 0, however PADN is 4 so the latter necessitates
+ * some change to the parser to support Segment Routing TLVs.
+ */
+#define IPEH_TLV_PAD1	0
+#define IPEH_TLV_PADN	1
+
+bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
+		    int max_count, int off, int len);
+
 #endif /* _NET_IPEH_H */
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 86e562c..7b4183c 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -54,138 +54,6 @@
   Generic functions
  *********************/
 
-/* An unknown option is detected, decide what to do */
-
-static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
-			       bool disallow_unknowns)
-{
-	if (disallow_unknowns) {
-		/* If unknown TLVs are disallowed by configuration
-		 * then always silently drop packet. Note this also
-		 * means no ICMP parameter problem is sent which
-		 * could be a good property to mitigate a reflection DOS
-		 * attack.
-		 */
-
-		goto drop;
-	}
-
-	switch ((skb_network_header(skb)[optoff] & 0xC0) >> 6) {
-	case 0: /* ignore */
-		return true;
-
-	case 1: /* drop packet */
-		break;
-
-	case 3: /* Send ICMP if not a multicast address and drop packet */
-		/* Actually, it is redundant check. icmp_send
-		   will recheck in any case.
-		 */
-		if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr))
-			break;
-		/* fall through */
-	case 2: /* send ICMP PARM PROB regardless and drop packet */
-		icmpv6_param_prob(skb, ICMPV6_UNK_OPTION, optoff);
-		return false;
-	}
-
-drop:
-	kfree_skb(skb);
-	return false;
-}
-
-/* Parse tlv encoded option header (hop-by-hop or destination) */
-
-static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
-			  struct sk_buff *skb,
-			  int max_count)
-{
-	int len = (skb_transport_header(skb)[1] + 1) << 3;
-	const unsigned char *nh = skb_network_header(skb);
-	int off = skb_network_header_len(skb);
-	const struct tlvtype_proc *curr;
-	bool disallow_unknowns = false;
-	int tlv_count = 0;
-	int padlen = 0;
-
-	if (unlikely(max_count < 0)) {
-		disallow_unknowns = true;
-		max_count = -max_count;
-	}
-
-	if (skb_transport_offset(skb) + len > skb_headlen(skb))
-		goto bad;
-
-	off += 2;
-	len -= 2;
-
-	while (len > 0) {
-		int optlen = nh[off + 1] + 2;
-		int i;
-
-		switch (nh[off]) {
-		case IPV6_TLV_PAD1:
-			optlen = 1;
-			padlen++;
-			if (padlen > 7)
-				goto bad;
-			break;
-
-		case IPV6_TLV_PADN:
-			/* RFC 2460 states that the purpose of PadN is
-			 * to align the containing header to multiples
-			 * of 8. 7 is therefore the highest valid value.
-			 * See also RFC 4942, Section 2.1.9.5.
-			 */
-			padlen += optlen;
-			if (padlen > 7)
-				goto bad;
-			/* RFC 4942 recommends receiving hosts to
-			 * actively check PadN payload to contain
-			 * only zeroes.
-			 */
-			for (i = 2; i < optlen; i++) {
-				if (nh[off + i] != 0)
-					goto bad;
-			}
-			break;
-
-		default: /* Other TLV code so scan list */
-			if (optlen > len)
-				goto bad;
-
-			tlv_count++;
-			if (tlv_count > max_count)
-				goto bad;
-
-			for (curr = procs; curr->type >= 0; curr++) {
-				if (curr->type == nh[off]) {
-					/* type specific length/alignment
-					   checks will be performed in the
-					   func(). */
-					if (curr->func(skb, off) == false)
-						return false;
-					break;
-				}
-			}
-			if (curr->type < 0 &&
-			    !ip6_tlvopt_unknown(skb, off, disallow_unknowns))
-				return false;
-
-			padlen = 0;
-			break;
-		}
-		off += optlen;
-		len -= optlen;
-	}
-
-	if (len == 0)
-		return true;
-bad:
-	kfree_skb(skb);
-	return false;
-}
-
 static int ipv6_destopt_rcv(struct sk_buff *skb)
 {
 	struct inet6_skb_parm *opt = IP6CB(skb);
@@ -213,8 +81,9 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	dstbuf = opt->dst1;
 #endif
 
-	if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
-			  init_net.ipv6.sysctl.max_dst_opts_cnt)) {
+	if (ipeh_parse_tlv(tlvprocdestopt_lst, skb,
+			   init_net.ipv6.sysctl.max_dst_opts_cnt,
+			   2, extlen - 2)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -638,8 +507,9 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 		goto fail_and_free;
 
 	opt->flags |= IP6SKB_HOPBYHOP;
-	if (ip6_parse_tlv(tlvprochopopt_lst, skb,
-			  init_net.ipv6.sysctl.max_hbh_opts_cnt)) {
+	if (ipeh_parse_tlv(tlvprochopopt_lst, skb,
+			   init_net.ipv6.sysctl.max_hbh_opts_cnt,
+			   2, extlen - 2)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 		opt->nhoff = sizeof(struct ipv6hdr);
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index 2c68184..d0c4ec3 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -142,3 +142,140 @@ struct ipv6_txoptions *ipeh_fixup_options(struct ipv6_txoptions *opt_space,
 	return opt;
 }
 EXPORT_SYMBOL_GPL(ipeh_fixup_options);
+
+/* An unknown option is detected, decide what to do */
+
+static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
+			       bool disallow_unknowns)
+{
+	if (disallow_unknowns) {
+		/* If unknown TLVs are disallowed by configuration
+		 * then always silently drop packet. Note this also
+		 * means no ICMP parameter problem is sent which
+		 * could be a good property to mitigate a reflection DOS
+		 * attack.
+		 */
+
+		goto drop;
+	}
+
+	switch ((skb_network_header(skb)[optoff] & 0xC0) >> 6) {
+	case 0: /* ignore */
+		return true;
+
+	case 1: /* drop packet */
+		break;
+
+	case 3: /* Send ICMP if not a multicast address and drop packet */
+		/* Actually, it is redundant check. icmp_send
+		 * will recheck in any case.
+		 */
+		if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr))
+			break;
+		/* fall through */
+	case 2: /* send ICMP PARM PROB regardless and drop packet */
+		icmpv6_param_prob(skb, ICMPV6_UNK_OPTION, optoff);
+		return false;
+	}
+
+drop:
+	kfree_skb(skb);
+	return false;
+}
+
+/* Generic extension header TLV parser
+ *
+ * Arguments:
+ *   - skb_transport_header points to the extension header containing options
+ *   - off is offset from skb_transport_header where first TLV is
+ *   - len is length of TLV block
+ */
+bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
+		    int max_count, int off, int len)
+{
+	const unsigned char *nh = skb_network_header(skb);
+	const struct tlvtype_proc *curr;
+	bool disallow_unknowns = false;
+	int tlv_count = 0;
+	int padlen = 0;
+
+	if (unlikely(max_count < 0)) {
+		disallow_unknowns = true;
+		max_count = -max_count;
+	}
+
+	if (skb_transport_offset(skb) + off + len > skb_headlen(skb))
+		goto bad;
+
+	/* ops function based offset on network header */
+	off += skb_network_header_len(skb);
+
+	while (len > 0) {
+		int optlen = nh[off + 1] + 2;
+		int i;
+
+		switch (nh[off]) {
+		case IPEH_TLV_PAD1:
+			optlen = 1;
+			padlen++;
+			if (padlen > 7)
+				goto bad;
+			break;
+
+		case IPEH_TLV_PADN:
+			/* RFC 2460 states that the purpose of PadN is
+			 * to align the containing header to multiples
+			 * of 8. 7 is therefore the highest valid value.
+			 * See also RFC 4942, Section 2.1.9.5.
+			 */
+			padlen += optlen;
+			if (padlen > 7)
+				goto bad;
+
+			/* RFC 4942 recommends receiving hosts to
+			 * actively check PadN payload to contain
+			 * only zeroes.
+			 */
+			for (i = 2; i < optlen; i++) {
+				if (nh[off + i] != 0)
+					goto bad;
+			}
+			break;
+
+		default: /* Other TLV code so scan list */
+			if (optlen > len)
+				goto bad;
+
+			tlv_count++;
+			if (tlv_count > max_count)
+				goto bad;
+
+			for (curr = procs; curr->type >= 0; curr++) {
+				if (curr->type == nh[off]) {
+					/* type specific length/alignment
+					 * checks will be performed in the
+					 * func().
+					 */
+					if (curr->func(skb, off) == false)
+						return false;
+					break;
+				}
+			}
+			if (curr->type < 0 &&
+			    !ip6_tlvopt_unknown(skb, off, disallow_unknowns))
+				return false;
+
+			padlen = 0;
+			break;
+		}
+		off += optlen;
+		len -= optlen;
+	}
+
+	if (len == 0)
+		return true;
+bad:
+	kfree_skb(skb);
+	return false;
+}
+EXPORT_SYMBOL(ipeh_parse_tlv);
-- 
2.7.4

