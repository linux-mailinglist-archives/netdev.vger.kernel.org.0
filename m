Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1052D26B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 01:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfE1XdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:33:01 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51205 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbfE1XdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:33:00 -0400
Received: by mail-it1-f194.google.com with SMTP id m3so628850itl.1
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=pRkz65DZ4lUDOKKTUJucdP+aSs3QdflDXVMaZhkJDBU=;
        b=c54jPc1oHZoxbffd8+I1Mk8Iru1Xnp+l4rWJa5eZuJCB5Crn1chd/iPtvOgQBq/1B1
         0GDg1c1AwzkVIzMCAAOUrQ6jbLFaOrLpqNCyWShOTVku1xg5GbrqFu3BNQl2TROFTcNh
         jrkLgxrYFKMOUHON7jBjewhVwAX18D0rsQMonjFe/v6r4xDoecgsNSyyJBpJRi0mLBpo
         1bEVM732+wvnojtHVwXA4BRTTnad1bKipAbof5auLQ5Of6KuovVxkEILdyjM1eK4/iHP
         LJu8RJqWOO3xlX/jQ+VP4eWxL7Ms39OYpzUBForDDiBpECHz0Csi1XA1AP5ATy6PMGOM
         ORsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pRkz65DZ4lUDOKKTUJucdP+aSs3QdflDXVMaZhkJDBU=;
        b=Oi4vK4RkMK9Mw8Beyb3PbRteRxTIpopabreeLnYzsdPqEMBhLEO8rHbJqsyVxLh41p
         ShcJDg+gwyR41ev17jLVM4YGX3DctenD8KJ16atQwjug2SZ3T/4ZGwqf6JbhQpxDbKb0
         ko7RM7oekneA71+AdjdWYYwaBq7dXgKz92+U9lLZqRAGIg1JDVCugorcDzLC7w3L173Q
         06KLLsEQc7JbPc3ing1D+Z2X2zSusWjDssbruGS1EBNgXtIpPBlIoEDf/I118uIefZBR
         Fk45my0q6KcbDsBOFQbSuKvvz+HiM9U0Ct/fGfquJdjmn4n+C5X/3VYASzudUGeGysGo
         lm5g==
X-Gm-Message-State: APjAAAXsgcKsjAhMszgzG5LTkECCRb0rjiEB6MkSLwFOznyWeWVm23ZD
        YxU7zQ+rOOEMIgMyvtkldkKPv7DubF4Xlg==
X-Google-Smtp-Source: APXvYqxrdM9s/rNtnXg6VzzhgT+fsFsq91DfDSu8dujCKL4KMWlhX9bALrWoxgcamyz3V5e8RSmcLQ==
X-Received: by 2002:a24:2116:: with SMTP id e22mr5281186ita.121.1559086379443;
        Tue, 28 May 2019 16:32:59 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id r22sm4941810ioh.54.2019.05.28.16.32.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 16:32:58 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next] ipv6: Send ICMP errors for exceeding extension header limits
Date:   Tue, 28 May 2019 16:32:42 -0700
Message-Id: <1559086362-2470-1-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
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
index 20291c2..ed0e4f5 100644
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
@@ -156,8 +159,11 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
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
@@ -173,8 +179,11 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
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
@@ -200,6 +209,8 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 	if (len == 0)
 		return true;
 bad:
+	__IP6_INC_STATS(dev_net(skb->dev), __in6_dev_get(skb->dev),
+			IPSTATS_MIB_INHDRERRORS);
 	kfree_skb(skb);
 	return false;
 }
@@ -300,8 +311,15 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
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
@@ -843,8 +861,15 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
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

