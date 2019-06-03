Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC27333D8
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfFCPsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:48:04 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:45678 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727458AbfFCPsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 11:48:04 -0400
Received: by mail-pf1-f172.google.com with SMTP id s11so10832837pfm.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 08:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=TnuuO/EthjA0EV2Y3JshweY85TFtp18DCpPoy0lraxs=;
        b=2MvlB6EGU7IjGlDGbkUWLLAkzx4/f+ifg/vn4Q1c/fUYzF2gezO/SJrXxQg9LGziT4
         OORwMLDDVTgiyzaWKHCJBFEuemJHpYMrRSNtDsT7a+XzVkKOxXDM/GJtvNIdAMZXjdmK
         AOELFrmEySjfXkaq1kaTTKoZQONHhKE/Vhj6RQghqxvqjc/rQpMWKbh9I09JJRymmY33
         RFXfLCBpI4+y34FEMVpyzLOPdiUkwmiGPCSe0J1J/6N7CeTJpV8ew1Ti2uQtaxAgg9/3
         X601UjmCqDbv/G/a2KEXXeSpW2sjBeA7IJxze7hO2d5Q36M5nH15N1egRxxB8USMvB53
         Hvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TnuuO/EthjA0EV2Y3JshweY85TFtp18DCpPoy0lraxs=;
        b=jzt0BoT+hG9aZ7RR2T3yXr9UyudkgNhNg/pdIFo+6z7tDnyxcYH+I6bHhh2hIDpYPy
         in4pFfsF9/vwBU0Ua2JdFWvhuGoXCRZpyMB91RUAK6RSSmvS4GAasOqpbKBAv52Xp3Fc
         ch6+o3cLcHA+KnJCVhiseSl38+b7B3ng55kiMQj1H7YAEeKTiTDhSbIGz2LVwKqY7ego
         PfPd5lCM1fdm49tVbqnpFxX9/jrJNwDl/NgFRzdujWL+ewVOnPrJLdJMRPEOigY8KY5t
         fmw/5mCC393CdnuHjLwfARRO6q70Vkb/ojJTAbgyyiTeilCGvpdnPDWOU3gQVS2YxbGx
         iDbQ==
X-Gm-Message-State: APjAAAVDI79Ln3PUYDcAeIReVenBNzD7zH/PUL1Sf+T9J7jFuWzjANFS
        hzF9yW3I4M2+ZcUx/vVcXiVurTHUABI=
X-Google-Smtp-Source: APXvYqx8KXDm6osiWLl8eagtu4AqhkhnfxamhNNAn2zE31f5hbHKLCppd+E1t15zCMjKw0wdK7l6hQ==
X-Received: by 2002:a63:1844:: with SMTP id 4mr27370490pgy.402.1559576883357;
        Mon, 03 Jun 2019 08:48:03 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id j72sm16485462pje.12.2019.06.03.08.48.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 03 Jun 2019 08:48:02 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v2 net-next] ipv6: Send ICMP errors for exceeding extension header limits
Date:   Mon,  3 Jun 2019 08:47:47 -0700
Message-Id: <1559576867-4241-1-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define constants and add support to send ICMPv6 Parameter Problem
errors as specified in draft-ietf-6man-icmp-limits-02.

The following parameter problem errors are sent when processing
Hop-by-Hop or Destination Options:

   * ICMPV6_TOOBIG_OPTION
      - Sent if the length of an option exceeds the extent of the
        extension header.
      - Sent if a packet exceeding the padding limit is received
        (more than seven consecutive bytes of padding).

   * ICMPV6_TOOMANY_OPTIONS
      - Sent if a packet is received and HBH option count exceeds
        ipv6.sysctl.max_hbh_opts_cnt or DO option count exceeds
        ipv6.sysctl.max_dst_opts_cnt.

   * ICMPV6_EXTHDR_TOOBIG
      - Sent if length of HBH EH exceeds ipv6.sysctl.max_hbh_opts_len
        or length of DO EH exceeds ipv6.sysctl.max_dst_opts_len.
      - Sent if the length of an extension header exceeds the
        extent of the packet.

   * ICMPV6_HDR_FIELD
      - Sent if a data byte in PADN is non-zero

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/uapi/linux/icmpv6.h |  6 ++++++
 net/ipv6/exthdrs.c          | 50 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
index 2622b5a..966279b 100644
--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -124,6 +124,7 @@ struct icmp6hdr {
 #define ICMPV6_PORT_UNREACH		4
 #define ICMPV6_POLICY_FAIL		5
 #define ICMPV6_REJECT_ROUTE		6
+#define ICMPV6_SRCRT_ERR		7
 
 /*
  *	Codes for Time Exceeded
@@ -137,6 +138,11 @@ struct icmp6hdr {
 #define ICMPV6_HDR_FIELD		0
 #define ICMPV6_UNK_NEXTHDR		1
 #define ICMPV6_UNK_OPTION		2
+#define ICMPV6_FIRST_FRAG_INCOMP	3
+#define ICMPV6_EXTHDR_TOOBIG		4
+#define ICMPV6_EXTHDR_CHAINLONG		5
+#define ICMPV6_TOOMANY_OPTIONS		6
+#define ICMPV6_TOOBIG_OPTION		7
 
 /*
  *	constants for (set|get)sockopt
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 20291c2..05061f4 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -131,8 +131,11 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 		max_count = -max_count;
 	}
 
-	if (skb_transport_offset(skb) + len > skb_headlen(skb))
+	if (skb_transport_offset(skb) + len > skb_headlen(skb)) {
+		icmpv6_send(skb, ICMPV6_PARAMPROB,
+			    ICMPV6_EXTHDR_TOOBIG, skb_transport_offset(skb));
 		goto bad;
+	}
 
 	off += 2;
 	len -= 2;
@@ -145,8 +148,11 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 		case IPV6_TLV_PAD1:
 			optlen = 1;
 			padlen++;
-			if (padlen > 7)
+			if (padlen > 7) {
+				icmpv6_send(skb, ICMPV6_PARAMPROB,
+					    ICMPV6_TOOBIG_OPTION, off);
 				goto bad;
+			}
 			break;
 
 		case IPV6_TLV_PADN:
@@ -156,25 +162,37 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 			 * See also RFC 4942, Section 2.1.9.5.
 			 */
 			padlen += optlen;
-			if (padlen > 7)
+			if (padlen > 7) {
+				icmpv6_send(skb, ICMPV6_PARAMPROB,
+					    ICMPV6_TOOBIG_OPTION, off);
 				goto bad;
+			}
 			/* RFC 4942 recommends receiving hosts to
 			 * actively check PadN payload to contain
 			 * only zeroes.
 			 */
 			for (i = 2; i < optlen; i++) {
-				if (nh[off + i] != 0)
+				if (nh[off + i] != 0) {
+					icmpv6_send(skb, ICMPV6_PARAMPROB,
+						    ICMPV6_HDR_FIELD, off + i);
 					goto bad;
+				}
 			}
 			break;
 
 		default: /* Other TLV code so scan list */
-			if (optlen > len)
+			if (optlen > len) {
+				icmpv6_send(skb, ICMPV6_PARAMPROB,
+					    ICMPV6_TOOBIG_OPTION, off);
 				goto bad;
+			}
 
 			tlv_count++;
-			if (tlv_count > max_count)
+			if (tlv_count > max_count) {
+				icmpv6_send(skb, ICMPV6_PARAMPROB,
+					    ICMPV6_TOOMANY_OPTIONS, off);
 				goto bad;
+			}
 
 			for (curr = procs; curr->type >= 0; curr++) {
 				if (curr->type == nh[off]) {
@@ -200,6 +218,8 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 	if (len == 0)
 		return true;
 bad:
+	__IP6_INC_STATS(dev_net(skb->dev), __in6_dev_get(skb->dev),
+			IPSTATS_MIB_INHDRERRORS);
 	kfree_skb(skb);
 	return false;
 }
@@ -300,8 +320,15 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	}
 
 	extlen = (skb_transport_header(skb)[1] + 1) << 3;
-	if (extlen > net->ipv6.sysctl.max_dst_opts_len)
+	if (extlen > net->ipv6.sysctl.max_dst_opts_len) {
+		icmpv6_send(skb, ICMPV6_PARAMPROB,
+			    ICMPV6_EXTHDR_TOOBIG,
+			    skb_network_header_len(skb) +
+				net->ipv6.sysctl.max_dst_opts_len);
+		__IP6_INC_STATS(dev_net(dst->dev), idev,
+				IPSTATS_MIB_INHDRERRORS);
 		goto fail_and_free;
+	}
 
 	opt->lastopt = opt->dst1 = skb_network_header_len(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -843,8 +870,15 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 	}
 
 	extlen = (skb_transport_header(skb)[1] + 1) << 3;
-	if (extlen > net->ipv6.sysctl.max_hbh_opts_len)
+	if (extlen > net->ipv6.sysctl.max_hbh_opts_len) {
+		__IP6_INC_STATS(net, __in6_dev_get(skb->dev),
+				IPSTATS_MIB_INHDRERRORS);
+		icmpv6_send(skb, ICMPV6_PARAMPROB,
+			    ICMPV6_EXTHDR_TOOBIG,
+			skb_network_header_len(skb) +
+				net->ipv6.sysctl.max_hbh_opts_len);
 		goto fail_and_free;
+	}
 
 	opt->flags |= IP6SKB_HOPBYHOP;
 	if (ip6_parse_tlv(tlvprochopopt_lst, skb,
-- 
2.7.4

