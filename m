Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6113DF192
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbhHCPbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbhHCPbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:31:39 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087CCC0617BA
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 08:31:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mt6so30133768pjb.1
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 08:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jrkU8Qj+0nNAzkpdvpqlCvibX4RodGgN6SfNGWllDcY=;
        b=iumIyjgshEscnZYjnTMOYSVBRkRBqiLHeAax3/ow1HD0RbBZEVShQlM/NmzpZhCmhy
         7bwF4ADS8+xTJIRQOnd8vAj7Apg40wZaU1Y309vQwNElxnM9XE4X8smWnCiRqRQW6MeP
         QiB6YeqYIr+29BJhiLt2x65vVZHstTNpdo7hNfx/Ja5J1syX62X7vuJ2HdJ+mLZ0Slgs
         veC9g7lRMm9P8yZgc+Vw0vjy0Q1KxA7gxfeJbG+AkOWSpHYNFLMopOpIIojlZ72UE2bO
         7Jom0MMTh/wYnezQjnTyGGG2i2x7PhyzPeAUlo5wroX88Dn4L307qqTPEBR8jvGsdg8k
         tLWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jrkU8Qj+0nNAzkpdvpqlCvibX4RodGgN6SfNGWllDcY=;
        b=N05/aDdvCj4/PXgw4AcEdGJYowBj0SabfXYI8sTOZUMCARrEW6J+f1z8EaKDvHkTyR
         8icJTra+MZ6S1gxYpmoC+cgUWuKuGAoGAr2oJy+BwCIRPITruqIs+3FnMQAWVstQDgyC
         tXHDpzwvo3ylcxcxruGxkuIKivn/cdKdK7VV0iIk0xkII7fyrNctZiq3LYW/tgI/E/+q
         sGsd0WYUY7pMcHudqXDyx79seUbLG9rHNpCm7jlISG/ZnVOd5/DIjx7AdV5KVAs+qgWh
         ty+hY8uODY5uKWwSJmztR7WLSyOsa7AwFHlZ/thuEDSah5/JKpnkuJ4hx29cTNcIR0wf
         pq6w==
X-Gm-Message-State: AOAM530hjYWpuGV/tqXmD+MaigZK+w6qaftddTuHhcAXyc3rWAI41IAb
        DOZGtq8UYVprCNuJIplhnqw=
X-Google-Smtp-Source: ABdhPJwFGwmV8zmCGfOu66R6oCE0EbTrUwp/UIHQ09fC1X4M4kIewxJX2x7CsnFTB3mDpX+iqLO41A==
X-Received: by 2002:a05:6a00:8c1:b029:3a3:b86a:302f with SMTP id s1-20020a056a0008c1b02903a3b86a302fmr23403895pfu.31.1628004670492;
        Tue, 03 Aug 2021 08:31:10 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3354:9bf4:fc5:c7e4])
        by smtp.gmail.com with ESMTPSA id n123sm18171091pga.69.2021.08.03.08.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 08:31:09 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Coco Li <lixiaoyan@google.com>
Subject: [PATCH net-next] ipv6: exthdrs: get rid of indirect calls in ip6_parse_tlv()
Date:   Tue,  3 Aug 2021 08:31:05 -0700
Message-Id: <20210803153105.1414473-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

As presented last month in our "BIG TCP" talk at netdev 0x15,
we plan using IPv6 jumbograms.

One of the minor problem we talked about is the fact that
ip6_parse_tlv() is currently using tables to list known tlvs,
thus using potentially expensive indirect calls.

While we could mitigate this cost using macros from
indirect_call_wrapper.h, we also can get rid of the tables
and let the compiler emit optimized code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Justin Iurman <justin.iurman@uliege.be>
Cc: Coco Li <lixiaoyan@google.com>
---
 net/ipv6/exthdrs.c | 105 ++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 59 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index d897faa4e9e63831b9b4f0ad0e59bf7032b2bd96..3a871a09f9625443d34435dde9911f3e8fea7d53 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -55,19 +55,6 @@
 
 #include <linux/uaccess.h>
 
-/*
- *	Parsing tlv encoded headers.
- *
- *	Parsing function "func" returns true, if parsing succeed
- *	and false, if it failed.
- *	It MUST NOT touch skb->h.
- */
-
-struct tlvtype_proc {
-	int	type;
-	bool	(*func)(struct sk_buff *skb, int offset);
-};
-
 /*********************
   Generic functions
  *********************/
@@ -112,16 +99,23 @@ static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
 	return false;
 }
 
+static bool ipv6_hop_ra(struct sk_buff *skb, int optoff);
+static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff);
+static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff);
+static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff);
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+static bool ipv6_dest_hao(struct sk_buff *skb, int optoff);
+#endif
+
 /* Parse tlv encoded option header (hop-by-hop or destination) */
 
-static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
+static bool ip6_parse_tlv(bool hopbyhop,
 			  struct sk_buff *skb,
 			  int max_count)
 {
 	int len = (skb_transport_header(skb)[1] + 1) << 3;
 	const unsigned char *nh = skb_network_header(skb);
 	int off = skb_network_header_len(skb);
-	const struct tlvtype_proc *curr;
 	bool disallow_unknowns = false;
 	int tlv_count = 0;
 	int padlen = 0;
@@ -176,20 +170,45 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 			if (tlv_count > max_count)
 				goto bad;
 
-			for (curr = procs; curr->type >= 0; curr++) {
-				if (curr->type == nh[off]) {
-					/* type specific length/alignment
-					   checks will be performed in the
-					   func(). */
-					if (curr->func(skb, off) == false)
+			if (hopbyhop) {
+				switch (nh[off]) {
+				case IPV6_TLV_ROUTERALERT:
+					if (!ipv6_hop_ra(skb, off))
+						return false;
+					break;
+				case IPV6_TLV_IOAM:
+					if (!ipv6_hop_ioam(skb, off))
+						return false;
+					break;
+				case IPV6_TLV_JUMBO:
+					if (!ipv6_hop_jumbo(skb, off))
+						return false;
+					break;
+				case IPV6_TLV_CALIPSO:
+					if (!ipv6_hop_calipso(skb, off))
+						return false;
+					break;
+				default:
+					if (!ip6_tlvopt_unknown(skb, off,
+								disallow_unknowns))
+						return false;
+					break;
+				}
+			} else {
+				switch (nh[off]) {
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+				case IPV6_TLV_HAO:
+					if (!ipv6_dest_hao(skb, off))
+						return false;
+					break;
+#endif
+				default:
+					if (!ip6_tlvopt_unknown(skb, off,
+								disallow_unknowns))
 						return false;
 					break;
 				}
 			}
-			if (curr->type < 0 &&
-			    !ip6_tlvopt_unknown(skb, off, disallow_unknowns))
-				return false;
-
 			padlen = 0;
 		}
 		off += optlen;
@@ -267,16 +286,6 @@ static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
 }
 #endif
 
-static const struct tlvtype_proc tlvprocdestopt_lst[] = {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-	{
-		.type	= IPV6_TLV_HAO,
-		.func	= ipv6_dest_hao,
-	},
-#endif
-	{-1,			NULL}
-};
-
 static int ipv6_destopt_rcv(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
@@ -307,8 +316,7 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	dstbuf = opt->dst1;
 #endif
 
-	if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
-			  net->ipv6.sysctl.max_dst_opts_cnt)) {
+	if (ip6_parse_tlv(false, skb, net->ipv6.sysctl.max_dst_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -1051,26 +1059,6 @@ static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
 	return false;
 }
 
-static const struct tlvtype_proc tlvprochopopt_lst[] = {
-	{
-		.type	= IPV6_TLV_ROUTERALERT,
-		.func	= ipv6_hop_ra,
-	},
-	{
-		.type	= IPV6_TLV_IOAM,
-		.func	= ipv6_hop_ioam,
-	},
-	{
-		.type	= IPV6_TLV_JUMBO,
-		.func	= ipv6_hop_jumbo,
-	},
-	{
-		.type	= IPV6_TLV_CALIPSO,
-		.func	= ipv6_hop_calipso,
-	},
-	{ -1, }
-};
-
 int ipv6_parse_hopopts(struct sk_buff *skb)
 {
 	struct inet6_skb_parm *opt = IP6CB(skb);
@@ -1096,8 +1084,7 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 		goto fail_and_free;
 
 	opt->flags |= IP6SKB_HOPBYHOP;
-	if (ip6_parse_tlv(tlvprochopopt_lst, skb,
-			  net->ipv6.sysctl.max_hbh_opts_cnt)) {
+	if (ip6_parse_tlv(true, skb, net->ipv6.sysctl.max_hbh_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 		opt->nhoff = sizeof(struct ipv6hdr);
-- 
2.32.0.554.ge1b32706d8-goog

