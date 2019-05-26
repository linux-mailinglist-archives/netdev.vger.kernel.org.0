Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217B02AC4B
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 23:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfEZVPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 17:15:37 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46979 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfEZVPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 17:15:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id v9so1503445pgr.13
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 14:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9eHGwa6ggYzSP5R77wF9lJQtr/8cuNoCsj28JYcbO9s=;
        b=WnCt1IB5EFmvcxl0fl35tPecuMebac77NzR3WupFdASD+0cCqooiazxt//eWJndoIF
         2sLZFDz5Bmx9g/4FbDd3A00obEjgsTUhfHvJWq9QyO5RGMlVSGwNAe/tbTLKcwTIJZ59
         7k8tyKLqVOSG+5/yB1RkjxJbgf/pKge8b/A8ELuUDhdWFasRStB163IbvTksTeVSe2gq
         AT0tzn+3jFI85mVKIbMzCfhZU9bR6A+kRqqoTwJXya6y7SPgf+PmPkICjYSoZ0E9N7sg
         /wGce1nksSabbBzoTDOkiD0qQzyfdciRL97WedMH4v4lYGu399GtuctdybV+H0HQLeZi
         gkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9eHGwa6ggYzSP5R77wF9lJQtr/8cuNoCsj28JYcbO9s=;
        b=YTy1kwP24u/mo731iQC6SXyvuL4BKIYifHETd7FeLQtjU9N0vGy8IZpEs3hfiUgAOj
         fYKhljARYG2KoBDWZ4cqWVnFe6RYYRfkQhYUUHw95lArkfuTtiD+Dpx3Ucp7M2jxAOBs
         uDCE3Fa9v3Tv16aSg3PYjIILc9aSPLSYzV8fV3KBgbiiGgNofxyxAtUUkJbSrXMV8jJU
         DljdMGCTPT03g2w3YamblnRo4mZcz2QpGlE+UEAciH+tqTaNkuJJvLtSA4N9d6sNPitv
         6ZRslePMwlh6qsCur0+cQCX5hFsRg1Mk1Imj3LaThWq77HJgvLitg1ELDRoPNQlyj7+4
         iEQA==
X-Gm-Message-State: APjAAAVEI1pcgxOpFqIp6EIPLbfkjklxfzwWV5+GsN2zqmjLnZQPI0jQ
        1mNxtSfNnvKUv+xr5xj1gK7iKA==
X-Google-Smtp-Source: APXvYqy22uVtHBKEJY7rg1rJD1qMtvNoePDKinMhr9wIUS3V6qN7rXTox6wGF5Qe4Vdo8+1Tbo5z3g==
X-Received: by 2002:a65:420a:: with SMTP id c10mr54562506pgq.376.1558905335147;
        Sun, 26 May 2019 14:15:35 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id f40sm13325325pjg.9.2019.05.26.14.15.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 26 May 2019 14:15:34 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 4/4] ipv6: Send ICMP errors for exceeding extension header limits
Date:   Sun, 26 May 2019 14:15:06 -0700
Message-Id: <1558905306-2968-5-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558905306-2968-1-git-send-email-tom@quantonium.net>
References: <1558905306-2968-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define constants and add support to send ICMPv6 Parameter Problem
errors as defined in draft-ietf-6man-icmp-limits-02.

ICMPV6_TOOBIG_OPTION is sent if a packet exceeding the padding limit
is received (more than seven consecutive bytes of padding),
ICMPV6_TOOMANY_OPTIONS is sent if a packet is received and HBH option
count exceeds ipv6.sysctl.max_hbh_opts_cnt or DO option count exceeds
ipv6.sysctl.max_dst_opts_cnt. ICMPV6_EXTHDR_TOOBIG is sent if length
of HBH EH exceeds ipv6.sysctl.max_hbh_opts_len or length of DO EH
exceeds ipv6.sysctl.max_dst_opts_len.

Additionally, when packets are dropped in the above cases bump
IPSTATS_MIB_INHDRERRORS.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/uapi/linux/icmpv6.h |  6 ++++++
 net/ipv6/exthdrs.c          | 35 ++++++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 5 deletions(-)

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
index f0e0f7a..fe6d9b2 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -145,8 +145,11 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
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
@@ -157,8 +160,11 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 			 * RFC 8504, Section 5.3.
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
@@ -174,8 +180,11 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 				goto bad;
 
 			tlv_count++;
-			if (tlv_count > max_count)
+			if (tlv_count > max_count) {
+				icmpv6_send(skb, ICMPV6_PARAMPROB,
+					    ICMPV6_TOOMANY_OPTIONS, off);
 				goto bad;
+			}
 
 			for (curr = procs; curr->type >= 0; curr++) {
 				if (curr->type == nh[off]) {
@@ -201,6 +210,8 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 	if (len == 0)
 		return true;
 bad:
+	__IP6_INC_STATS(dev_net(skb->dev), __in6_dev_get(skb->dev),
+			IPSTATS_MIB_INHDRERRORS);
 	kfree_skb(skb);
 	return false;
 }
@@ -301,8 +312,15 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
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
@@ -844,8 +862,15 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
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

