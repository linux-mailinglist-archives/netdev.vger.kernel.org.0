Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5403DE106
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhHBUwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:52:04 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:40502 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbhHBUwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:52:02 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 090B2200DF90;
        Mon,  2 Aug 2021 22:51:43 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 090B2200DF90
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1627937503;
        bh=RVc+PisHuEj/CGa2TrTkJkUURwD267/c52cMbwJbPG4=;
        h=From:To:Cc:Subject:Date:From;
        b=u8D1ovNs+xm8zh0lwSD0izL33OVmsZnu/+RVgrk9RFsLJfIaQOlY2VdzHyeqhQAaG
         2ujHd4giO6fVODB9XI+tuVC9RuO5iMV38JW8QjzzqaRGg6WCFesl0rnA2DoYwInQAE
         PE8PlGxobsd1Eq3rKw3BBn/C1RXqPj8C4t5+ULw0UOkkIUm5IZ7cagjDxpYVwJvnNw
         y7HX9Z6KJz8gF+TsoSiDPVi36/mw5n6uH2omph/TxeTz76nroALTnE8Su4XW0HhBce
         xdamsBLDV6/lNOlsbcK3mwsda5BF2dM+XFOeIhsd47wYw4gaN3iM+k/6CHtjWMUaDy
         cwMpQjF2X1yuw==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, eric.dumazet@gmail.com, tom@herbertland.com,
        justin.iurman@uliege.be
Subject: [RFC net-next] ipv6: Attempt to improve options code parsing
Date:   Mon,  2 Aug 2021 22:51:33 +0200
Message-Id: <20210802205133.24071-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per Eric's comment on a previous patchset that was adding a new HopbyHop
option, i.e. why should a new option appear before or after existing ones in the
list, here is an attempt to suppress such competition. It also improves the
efficiency and fasten the process of matching a Hbh or Dst option, which is
probably something we want regarding the list of new options that could quickly
grow in the future.

Basically, the two "lists" of options (Hbh and Dst) are replaced by two arrays.
Each array has a size of 256 (for each code point). Each code point points to a
function to process its specific option.

Thoughts?

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 net/ipv6/exthdrs.c | 86 ++++++++++++++++++----------------------------
 1 file changed, 33 insertions(+), 53 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index d897faa4e9e6..4687fe456608 100644
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
@@ -114,14 +101,14 @@ static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
 
 /* Parse tlv encoded option header (hop-by-hop or destination) */
 
-static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
+static bool ip6_parse_tlv(bool (**procs)(struct sk_buff *skb, int offset),
 			  struct sk_buff *skb,
 			  int max_count)
 {
 	int len = (skb_transport_header(skb)[1] + 1) << 3;
 	const unsigned char *nh = skb_network_header(skb);
+	bool (*func)(struct sk_buff *skb, int offset);
 	int off = skb_network_header_len(skb);
-	const struct tlvtype_proc *curr;
 	bool disallow_unknowns = false;
 	int tlv_count = 0;
 	int padlen = 0;
@@ -176,19 +163,17 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 			if (tlv_count > max_count)
 				goto bad;
 
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
+			func = procs[nh[off]];
+			if (func) {
+				/* type specific length/alignment checks
+				 * will be performed in the func().
+				 */
+				if (func(skb, off) == false)
+					return false;
+			} else if (!ip6_tlvopt_unknown(skb, off,
+							disallow_unknowns)) {
 				return false;
+			}
 
 			padlen = 0;
 		}
@@ -267,14 +252,16 @@ static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
 }
 #endif
 
-static const struct tlvtype_proc tlvprocdestopt_lst[] = {
+/*	Parsing tlv encoded headers for Destination Options.
+ *
+ *	Parsing functions below return true, if parsing succeed
+ *	and false, if it failed.
+ *	They MUST NOT touch skb->h.
+ */
+static bool (*tlvprocdestopt[256])(struct sk_buff *skb, int offset) = {
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
-	{
-		.type	= IPV6_TLV_HAO,
-		.func	= ipv6_dest_hao,
-	},
+	[IPV6_TLV_HAO]	= ipv6_dest_hao,
 #endif
-	{-1,			NULL}
 };
 
 static int ipv6_destopt_rcv(struct sk_buff *skb)
@@ -307,7 +294,7 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	dstbuf = opt->dst1;
 #endif
 
-	if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
+	if (ip6_parse_tlv(tlvprocdestopt, skb,
 			  net->ipv6.sysctl.max_dst_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
@@ -1051,24 +1038,17 @@ static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
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
+/*	Parsing tlv encoded headers for HopbyHop Options.
+ *
+ *	Parsing functions below return true, if parsing succeed
+ *	and false, if it failed.
+ *	They MUST NOT touch skb->h.
+ */
+static bool (*tlvprochopopt[256])(struct sk_buff *skb, int offset) = {
+	[IPV6_TLV_ROUTERALERT]	= ipv6_hop_ra,
+	[IPV6_TLV_CALIPSO]	= ipv6_hop_calipso,
+	[IPV6_TLV_IOAM]	= ipv6_hop_ioam,
+	[IPV6_TLV_JUMBO]	= ipv6_hop_jumbo,
 };
 
 int ipv6_parse_hopopts(struct sk_buff *skb)
@@ -1096,7 +1076,7 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 		goto fail_and_free;
 
 	opt->flags |= IP6SKB_HOPBYHOP;
-	if (ip6_parse_tlv(tlvprochopopt_lst, skb,
+	if (ip6_parse_tlv(tlvprochopopt, skb,
 			  net->ipv6.sysctl.max_hbh_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
-- 
2.25.1

