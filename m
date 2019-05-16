Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C6620538
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbfEPLl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbfEPLlx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:41:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BF642168B;
        Thu, 16 May 2019 11:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006912;
        bh=sE1gk79s+6ATMN7Tffe9CtiMbkkXHKwl8khKvxMad+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0hQ+fHeVzzJA2RB6Lji5vV25NI10Q2h1pqkrz0HHVHhd6YXE28mXEywcuCV5NYoF
         nwAwcqOpHIKRWJmL2JceV2AQaI2pkhZJswXKYSv42LVtVshBgIVe60ExJZJHAOrpW4
         WvJSBB0oFZ7KPE2rqa180WUJs6WDV4UN/EAkQLYI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/8] xfrm4: Fix uninitialized memory read in _decode_session4
Date:   Thu, 16 May 2019 07:41:42 -0400
Message-Id: <20190516114146.9267-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114146.9267-1-sashal@kernel.org>
References: <20190516114146.9267-1-sashal@kernel.org>
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
index fddae0164b918..d9758ecdcba6a 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -108,7 +108,8 @@ static void
 _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	u8 *xprth = skb_network_header(skb) + iph->ihl * 4;
+	int ihl = iph->ihl;
+	u8 *xprth = skb_network_header(skb) + ihl * 4;
 	struct flowi4 *fl4 = &fl->u.ip4;
 	int oif = 0;
 
@@ -119,6 +120,11 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
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
@@ -130,7 +136,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be16 *ports;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ports = (__be16 *)xprth;
 
 				fl4->fl4_sport = ports[!!reverse];
@@ -143,7 +149,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			    pskb_may_pull(skb, xprth + 2 - skb->data)) {
 				u8 *icmp;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				icmp = xprth;
 
 				fl4->fl4_icmp_type = icmp[0];
@@ -156,7 +162,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be32 *ehdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ehdr = (__be32 *)xprth;
 
 				fl4->fl4_ipsec_spi = ehdr[0];
@@ -168,7 +174,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			    pskb_may_pull(skb, xprth + 8 - skb->data)) {
 				__be32 *ah_hdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ah_hdr = (__be32 *)xprth;
 
 				fl4->fl4_ipsec_spi = ah_hdr[1];
@@ -180,7 +186,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be16 *ipcomp_hdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				ipcomp_hdr = (__be16 *)xprth;
 
 				fl4->fl4_ipsec_spi = htonl(ntohs(ipcomp_hdr[1]));
@@ -193,7 +199,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 				__be16 *greflags;
 				__be32 *gre_hdr;
 
-				xprth = skb_network_header(skb) + iph->ihl * 4;
+				xprth = skb_network_header(skb) + ihl * 4;
 				greflags = (__be16 *)xprth;
 				gre_hdr = (__be32 *)xprth;
 
@@ -210,10 +216,6 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 			break;
 		}
 	}
-	fl4->flowi4_proto = iph->protocol;
-	fl4->daddr = reverse ? iph->saddr : iph->daddr;
-	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
 }
 
 static inline int xfrm4_garbage_collect(struct dst_ops *ops)
-- 
2.20.1

