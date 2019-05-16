Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597B420297
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 11:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfEPJb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 05:31:29 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43472 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbfEPJb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 05:31:28 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hRCjU-00026j-2Q; Thu, 16 May 2019 11:31:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, Florian Westphal <fw@strlen.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net] xfrm: ressurrect "Fix uninitialized memory read in _decode_session4"
Date:   Thu, 16 May 2019 11:28:16 +0200
Message-Id: <20190516092816.10296-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This resurrects commit 8742dc86d0c7a9628
("xfrm4: Fix uninitialized memory read in _decode_session4"),
which got lost during a merge conflict resolution between ipsec-next
and net-next tree.

c53ac41e3720 ("xfrm: remove decode_session indirection from afinfo_policy")
in ipsec-next moved the (buggy) _decode_session4 from
net/ipv4/xfrm4_policy.c to net/xfrm/xfrm_policy.c.
In mean time, 8742dc86d0c7a was applied to ipsec.git and fixed the
problem in the "old" location.

When the trees got merged, the moved, old function was kept.
This applies the "lost" commit again, to the new location.

Fixes: a658a3f2ecbab ("Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/xfrm/xfrm_policy.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 410233c5681e..7a43ae6b2a44 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3264,7 +3264,8 @@ static void
 decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	u8 *xprth = skb_network_header(skb) + iph->ihl * 4;
+	int ihl = iph->ihl;
+	u8 *xprth = skb_network_header(skb) + ihl * 4;
 	struct flowi4 *fl4 = &fl->u.ip4;
 	int oif = 0;
 
@@ -3275,6 +3276,11 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 	fl4->flowi4_mark = skb->mark;
 	fl4->flowi4_oif = reverse ? skb->skb_iif : oif;
 
+	fl4->flowi4_proto = iph->protocol;
+	fl4->daddr = reverse ? iph->saddr : iph->daddr;
+	fl4->saddr = reverse ? iph->daddr : iph->saddr;
+	fl4->flowi4_tos = iph->tos;
+
 	if (!ip_is_fragment(iph)) {
 		switch (iph->protocol) {
 		case IPPROTO_UDP:
@@ -3286,7 +3292,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be16 *ports;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ports = (__be16 *)xprth;
 
 				fl4->fl4_sport = ports[!!reverse];
@@ -3298,7 +3304,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 			    pskb_may_pull(skb, xprth + 2 - skb->data)) {
 				u8 *icmp;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				icmp = xprth;
 
 				fl4->fl4_icmp_type = icmp[0];
@@ -3310,7 +3316,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be32 *ehdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ehdr = (__be32 *)xprth;
 
 				fl4->fl4_ipsec_spi = ehdr[0];
@@ -3321,7 +3327,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 			    pskb_may_pull(skb, xprth + 8 - skb->data)) {
 				__be32 *ah_hdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ah_hdr = (__be32 *)xprth;
 
 				fl4->fl4_ipsec_spi = ah_hdr[1];
@@ -3332,7 +3338,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be16 *ipcomp_hdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ipcomp_hdr = (__be16 *)xprth;
 
 				fl4->fl4_ipsec_spi = htonl(ntohs(ipcomp_hdr[1]));
@@ -3344,7 +3350,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 				__be16 *greflags;
 				__be32 *gre_hdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				greflags = (__be16 *)xprth;
 				gre_hdr = (__be32 *)xprth;
 
@@ -3360,10 +3366,6 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 			break;
 		}
 	}
-	fl4->flowi4_proto = iph->protocol;
-	fl4->daddr = reverse ? iph->saddr : iph->daddr;
-	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.21.0

