Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72AEFFB
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfD3FbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:31:03 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46878 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbfD3Faw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 01:30:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 714DF2027B;
        Tue, 30 Apr 2019 07:30:51 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zNI_D1YbigxK; Tue, 30 Apr 2019 07:30:50 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E1CE72026C;
        Tue, 30 Apr 2019 07:30:48 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 07:30:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 192E53180628;
 Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 11/12] xfrm4: Fix uninitialized memory read in _decode_session4
Date:   Tue, 30 Apr 2019 07:30:29 +0200
Message-ID: <20190430053030.27009-12-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430053030.27009-1-steffen.klassert@secunet.com>
References: <20190430053030.27009-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 9E471DF7-7842-40DD-A1AC-50F8AD26E79A
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently don't reload pointers pointing into skb header
after doing pskb_may_pull() in _decode_session4(). So in case
pskb_may_pull() changed the pointers, we read from random
memory. Fix this by putting all the needed infos on the
stack, so that we don't need to access the header pointers
after doing pskb_may_pull().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/xfrm4_policy.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index d73a6d6652f6..2b144b92ae46 100644
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
2.17.1

