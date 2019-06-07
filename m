Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6E3394EA
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbfFGS4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:56:05 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42065 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732323AbfFGS4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:56:03 -0400
Received: by mail-pl1-f195.google.com with SMTP id go2so1151060plb.9
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=liKEgyX2d4glE6rP0aMaMB1pOxJnFBtpKyYuMVv92cE=;
        b=exRzuM1Bk1KyJ57sMSJ3yA1nOnfPlq2LEztskpo7ndNVFaDv24IyEGxzNAtPf/WMWs
         R7NexcGeHbi1aFUKwmaIVS8x4b1VrDslyIqYuacOdBpojutC5YZrNy6q4yvRuAfTsd/k
         e6/Y0jMpPJ/jsxdlpUnJUHmw3QuJYwpKZZ/FtGf1uGG+Nl0w9gyMoWUaGem4dachJMuf
         ZneWEGbJI1eWsqd0kWCps/crq/buTBq9Csvs8JcSLiR9gqHugzYOEQkcPVvqLBdTDdVx
         SMzZXnsau14MdlBJmUpz5WrQcGPWDgUP+tYjng+r3GBDsYpTA9Dg78s+muvb4oeHbuIe
         I6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=liKEgyX2d4glE6rP0aMaMB1pOxJnFBtpKyYuMVv92cE=;
        b=CtFY6op/cIKGiY/weC6rAr0iEezLDOZJQ5NEItDRJA+agOULrkBj32jrNRM1DhbOwu
         nDsRTGhEcCM8DFKSXl2HIFQRdkMd29EmkoxPlu/We92E+yXevlVfFuTnApj07FU8l9EQ
         4G7xSTCFNKVyR/44WKh8BWaZ2P58Ewnlu9l2BTVoOLLt/fyU9gwtERipz8E6foDLz2ff
         5o5Xex/ZEMgSHYZtpoh5cCPkPEihWubpYhlLX7q0M2+D+3uFiJYrzuAWuyLVzlKJEmUo
         +q8xGJHx3PPuvo6c4Eyj2CcKEjJKRA5MN5pg25s8OPDli54SoxXal/BFhcGlx0n2Iz/y
         l9Hw==
X-Gm-Message-State: APjAAAVZe/YUIhQBLpSypNhV9LqCf3nkD7V7f4pakrjuQmWH/yi6AQ6C
        bF4pukwYVGeVhMbglz2aenl2PcIIqxA=
X-Google-Smtp-Source: APXvYqwLxHwwGhoYEuTUAfFnpHOG+nMu4qgqOssCoxXAFJXrnr9uYAVvO3mc5B1C5AjVSKPhcQiebA==
X-Received: by 2002:a17:902:868f:: with SMTP id g15mr57204402plo.67.1559933762800;
        Fri, 07 Jun 2019 11:56:02 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id i25sm3181933pfr.73.2019.06.07.11.56.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Jun 2019 11:56:02 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC v2 PATCH 5/5] seg6: Leverage ip6_parse_tlv
Date:   Fri,  7 Jun 2019 11:55:08 -0700
Message-Id: <1559933708-13947-6-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559933708-13947-1-git-send-email-tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call ip6_parse_tlv from segment routing receive function to properly
parse TLVs and to leverage to existing implementation that already
parses Destination and Hop-by-Hop Options. This includes applying
the denial of service mitigations and limits to processing segment
routing TLVs.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/seg6.h      |  5 +++++
 include/net/seg6_hmac.h |  2 +-
 net/ipv6/exthdrs.c      | 51 ++++++++++++++++++++++++++++++++++++++++++++++---
 net/ipv6/seg6_hmac.c    | 16 +++-------------
 net/ipv6/seg6_local.c   | 21 ++++++++++++++------
 5 files changed, 72 insertions(+), 23 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index 8b2dc68..b7d8a94 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -38,6 +38,11 @@ static inline void update_csum_diff16(struct sk_buff *skb, __be32 *from,
 	skb->csum = ~csum_partial((char *)diff, sizeof(diff), ~skb->csum);
 }
 
+static inline unsigned int seg6_tlv_offset(struct ipv6_sr_hdr *srh)
+{
+	return sizeof(*srh) + ((srh->first_segment + 1) << 4);
+}
+
 struct seg6_pernet_data {
 	struct mutex lock;
 	struct in6_addr __rcu *tun_src;
diff --git a/include/net/seg6_hmac.h b/include/net/seg6_hmac.h
index 7fda469..6ad33e2 100644
--- a/include/net/seg6_hmac.h
+++ b/include/net/seg6_hmac.h
@@ -53,7 +53,7 @@ extern int seg6_hmac_info_add(struct net *net, u32 key,
 extern int seg6_hmac_info_del(struct net *net, u32 key);
 extern int seg6_push_hmac(struct net *net, struct in6_addr *saddr,
 			  struct ipv6_sr_hdr *srh);
-extern bool seg6_hmac_validate_skb(struct sk_buff *skb);
+extern bool seg6_hmac_validate_skb(struct sk_buff *skb, int optoff);
 extern int seg6_hmac_init(void);
 extern void seg6_hmac_exit(void);
 extern int seg6_hmac_net_init(struct net *net);
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index a394d20..7d14c0d 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -112,7 +112,8 @@ static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
 	return false;
 }
 
-/* Parse tlv encoded option header (hop-by-hop or destination)
+/* Parse tlv encoded option header (hop-by-hop, destination, or
+ * segment routing header)
  *
  * Arguments:
  *   procs - TLV proc structure
@@ -365,14 +366,42 @@ static void seg6_update_csum(struct sk_buff *skb)
 			   (__be32 *)addr);
 }
 
+static bool seg6_recv_hmac(struct sk_buff *skb, int optoff)
+{
+	if (!seg6_hmac_validate_skb(skb, optoff)) {
+		kfree_skb(skb);
+		return false;
+	}
+
+	return true;
+}
+
+static const struct tlvtype_proc tlvprocsrhopt_lst[] = {
+#ifdef CONFIG_IPV6_SEG6_HMAC
+	{
+		.type	= SR6_TLV_HMAC,
+		.func	= seg6_recv_hmac,
+	},
+#endif
+	{-1,			NULL}
+};
+
+static bool seg6_srhopt_unknown(struct sk_buff *skb, int optoff,
+				bool disallow_unknowns)
+{
+	/* Unknown segment routing header options are ignored */
+
+	return !disallow_unknowns;
+}
+
 static int ipv6_srh_rcv(struct sk_buff *skb)
 {
 	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct net *net = dev_net(skb->dev);
+	int accept_seg6, tlvoff, tlvlen;
 	struct ipv6_sr_hdr *hdr;
 	struct inet6_dev *idev;
 	struct in6_addr *addr;
-	int accept_seg6;
 
 	hdr = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 
@@ -387,8 +416,24 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 		return -1;
 	}
 
+	tlvoff = seg6_tlv_offset(hdr);
+	tlvlen = ipv6_optlen((struct ipv6_opt_hdr *)hdr) - tlvoff;
+
+	if (tlvlen) {
+		if (tlvlen > net->ipv6.sysctl.max_srh_opts_len) {
+			kfree_skb(skb);
+			return -1;
+		}
+
+		if (!ip6_parse_tlv(tlvprocsrhopt_lst, skb,
+				   init_net.ipv6.sysctl.max_srh_opts_cnt,
+				   tlvoff, tlvlen, seg6_srhopt_unknown))
+			return -1;
+	}
+
 #ifdef CONFIG_IPV6_SEG6_HMAC
-	if (!seg6_hmac_validate_skb(skb)) {
+	if (idev->cnf.seg6_require_hmac > 0 && !sr_has_hmac(hdr)) {
+		/* mandatory check but no HMAC tlv */
 		kfree_skb(skb);
 		return -1;
 	}
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 8546f94..18f82f2 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -240,7 +240,7 @@ EXPORT_SYMBOL(seg6_hmac_compute);
  *
  * called with rcu_read_lock()
  */
-bool seg6_hmac_validate_skb(struct sk_buff *skb)
+bool seg6_hmac_validate_skb(struct sk_buff *skb, int optoff)
 {
 	u8 hmac_output[SEG6_HMAC_FIELD_LEN];
 	struct net *net = dev_net(skb->dev);
@@ -251,23 +251,13 @@ bool seg6_hmac_validate_skb(struct sk_buff *skb)
 
 	idev = __in6_dev_get(skb->dev);
 
-	srh = (struct ipv6_sr_hdr *)skb_transport_header(skb);
-
-	tlv = seg6_get_tlv_hmac(srh);
-
-	/* mandatory check but no tlv */
-	if (idev->cnf.seg6_require_hmac > 0 && !tlv)
-		return false;
-
 	/* no check */
 	if (idev->cnf.seg6_require_hmac < 0)
 		return true;
 
-	/* check only if present */
-	if (idev->cnf.seg6_require_hmac == 0 && !tlv)
-		return true;
+	srh = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 
-	/* now, seg6_require_hmac >= 0 && tlv */
+	tlv = (struct sr6_tlv_hmac *)(skb_network_header(skb) + optoff);
 
 	hinfo = seg6_hmac_info_lookup(net, be32_to_cpu(tlv->hmackeyid));
 	if (!hinfo)
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 78155fd..d486ed8 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -92,6 +92,19 @@ static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb)
 	return srh;
 }
 
+static bool seg6_local_hmac_validate_skb(struct sk_buff *skb,
+					 struct ipv6_sr_hdr *srh)
+{
+#ifdef CONFIG_IPV6_SEG6_HMAC
+	int off = sr_hmac_offset(srh);
+
+	return off ? seg6_hmac_validate_skb(skb, off) :
+		     (__in6_dev_get(skb->dev)->cnf.seg6_require_hmac <= 0);
+#else
+	return true;
+#endif
+}
+
 static struct ipv6_sr_hdr *get_and_validate_srh(struct sk_buff *skb)
 {
 	struct ipv6_sr_hdr *srh;
@@ -103,10 +116,8 @@ static struct ipv6_sr_hdr *get_and_validate_srh(struct sk_buff *skb)
 	if (srh->segments_left == 0)
 		return NULL;
 
-#ifdef CONFIG_IPV6_SEG6_HMAC
-	if (!seg6_hmac_validate_skb(skb))
+	if (!seg6_local_hmac_validate_skb(skb, srh))
 		return NULL;
-#endif
 
 	return srh;
 }
@@ -120,10 +131,8 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
 	if (srh && srh->segments_left > 0)
 		return false;
 
-#ifdef CONFIG_IPV6_SEG6_HMAC
-	if (srh && !seg6_hmac_validate_skb(skb))
+	if (srh && !seg6_local_hmac_validate_skb(skb, srh))
 		return false;
-#endif
 
 	if (ipv6_find_hdr(skb, &off, proto, NULL, NULL) < 0)
 		return false;
-- 
2.7.4

