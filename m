Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D34205D4
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfEPLkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfEPLkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 630E220848;
        Thu, 16 May 2019 11:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006838;
        bh=JN6P18+RCeWAPcmc7FHjynnZRDrQ3Nyg80QwszVGty0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoF4TD1f+admPwsI+CGYFlShqyDfjjVUPc+lDW3cvhNN7xHftTeRlM/xOQ74fdLbe
         3rGZYdg6sIuJ4pededgux5LnXWpRtJzl8Vu8EhK5E5UForeLvqupPqeBbYFjGJRJXR
         GXoSaM9VailPPU3jeS+Q+wQN6oS+hOTCRhOsckHw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/25] xfrm4: Fix uninitialized memory read in _decode_session4
Date:   Thu, 16 May 2019 07:40:10 -0400
Message-Id: <20190516114029.8682-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114029.8682-1-sashal@kernel.org>
References: <20190516114029.8682-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 8742dc86d0c7a9628117a989c11f04a9b6b898f3 ]

We currently don't reload pointers pointing into skb header
after doing pskb_may_pull() in _decode_session4(). So in case
pskb_may_pull() changed the pointers, we read from random
memory. Fix this by putting all the needed infos on the
stack, so that we don't need to access the header pointers
after doing pskb_may_pull().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/xfrm4_policy.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index d73a6d6652f60..2b144b92ae46a 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -111,7 +111,8 @@ static void
 _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	u8 *xprth = skb_network_header(skb) + iph->ihl * 4;
+	int ihl = iph->ihl;
+	u8 *xprth = skb_network_header(skb) + ihl * 4;
 	struct flowi4 *fl4 = &fl->u.ip4;
 	int oif = 0;
 
@@ -122,6 +123,11 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
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
@@ -133,7 +139,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be16 *ports;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ports = (__be16 *)xprth;
 
 				fl4->fl4_sport = ports[!!reverse];
@@ -146,7 +152,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			    pskb_may_pull(skb, xprth + 2 - skb->data)) {
 				u8 *icmp;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				icmp = xprth;
 
 				fl4->fl4_icmp_type = icmp[0];
@@ -159,7 +165,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be32 *ehdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ehdr = (__be32 *)xprth;
 
 				fl4->fl4_ipsec_spi = ehdr[0];
@@ -171,7 +177,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			    pskb_may_pull(skb, xprth + 8 - skb->data)) {
 				__be32 *ah_hdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ah_hdr = (__be32 *)xprth;
 
 				fl4->fl4_ipsec_spi = ah_hdr[1];
@@ -183,7 +189,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be16 *ipcomp_hdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ipcomp_hdr = (__be16 *)xprth;
 
 				fl4->fl4_ipsec_spi = htonl(ntohs(ipcomp_hdr[1]));
@@ -196,7 +202,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 				__be16 *greflags;
 				__be32 *gre_hdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				greflags = (__be16 *)xprth;
 				gre_hdr = (__be32 *)xprth;
 
@@ -213,10 +219,6 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			break;
 		}
 	}
-	fl4->flowi4_proto = iph->protocol;
-	fl4->daddr = reverse ? iph->saddr : iph->daddr;
-	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
 }
 
 static void xfrm4_update_pmtu(struct dst_entry *dst, struct sock *sk,
-- 
2.20.1

