Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDE12E325F
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 19:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgL0SPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 13:15:25 -0500
Received: from mail-m963.mail.126.com ([123.126.96.3]:51156 "EHLO
        mail-m963.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgL0SPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 13:15:25 -0500
X-Greylist: delayed 3331 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Dec 2020 13:15:24 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=V0motPXrHIE470fx0+
        pT3LORve4Gw0vkJkk+XZZKFjs=; b=c6XELI8MoVdhagQkThGG6BMqDK+1IKa3rH
        2djFF3jgO9WAKaZIBFjyk2Z/xezNyu9CurfBVLIZoWzbq4+J5VfpP3WF/LrBgPtT
        +C4PcA9fDVttkiS2+BH0hQj8Fgxue9sZsMqqHAhqJ+XEMPUOWWq97hBULFkRdDvv
        Ex+lvKfUs=
Received: from localhost.localdomain (unknown [36.112.86.14])
        by smtp8 (Coremail) with SMTP id NORpCgB3xaQdluhfSPVxBA--.32014S2;
        Sun, 27 Dec 2020 22:11:43 +0800 (CST)
From:   Defang Bo <bodefang@126.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Defang Bo <bodefang@126.com>
Subject: [PATCH] ipv6: Prevent overrun when parsing v6 header options
Date:   Sun, 27 Dec 2020 22:11:35 +0800
Message-Id: <1609078295-4025719-1-git-send-email-bodefang@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: NORpCgB3xaQdluhfSPVxBA--.32014S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZrWkJr4fAFy3Ar1rZFyrWFg_yoW5WrykpF
        1DK3WktrsrK3y0gr4xCrs5uryrKa4kGFWUAa4Ik3yFkryDtr1FqFykCryjgFWftFy8uw1f
        JryrtrWrWryIvrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UVuWJUUUUU=
X-Originating-IP: [36.112.86.14]
X-CM-SenderInfo: pergvwxdqjqiyswou0bp/1tbiCx8I11x5cpn-rgAAsU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit<2423496af35>, the fragmentation code tries to parse the header options in order
to figure out where to insert the fragment option.  Since nexthdr points
to an invalid option, the calculation of the size of the network header
can made to be much larger than the linear section of the skb and data
is read outside of it.

Signed-off-by: Defang Bo <bodefang@126.com>
---
 net/ipv6/mip6.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index 878fcec..adf984c 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -251,8 +251,7 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
 			       u8 **nexthdr)
 {
 	u16 offset = sizeof(struct ipv6hdr);
-	struct ipv6_opt_hdr *exthdr =
-				   (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
+
 	const unsigned char *nh = skb_network_header(skb);
 	unsigned int packet_len = skb_tail_pointer(skb) -
 		skb_network_header(skb);
@@ -261,6 +260,7 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
 	*nexthdr = &ipv6_hdr(skb)->nexthdr;
 
 	while (offset + 1 <= packet_len) {
+		struct ipv6_opt_hdr *exthdr;
 
 		switch (**nexthdr) {
 		case NEXTHDR_HOP:
@@ -287,12 +287,15 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
 			return offset;
 		}
 
+		if (offset + sizeof(struct ipv6_opt_hdr) > packet_len)
+			return -EINVAL;
+
+		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
 		offset += ipv6_optlen(exthdr);
 		*nexthdr = &exthdr->nexthdr;
-		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
 	}
 
-	return offset;
+	return -EINVAL;
 }
 
 static int mip6_destopt_init_state(struct xfrm_state *x)
@@ -387,8 +390,7 @@ static int mip6_rthdr_offset(struct xfrm_state *x, struct sk_buff *skb,
 			     u8 **nexthdr)
 {
 	u16 offset = sizeof(struct ipv6hdr);
-	struct ipv6_opt_hdr *exthdr =
-				   (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
+
 	const unsigned char *nh = skb_network_header(skb);
 	unsigned int packet_len = skb_tail_pointer(skb) -
 		skb_network_header(skb);
@@ -396,7 +398,8 @@ static int mip6_rthdr_offset(struct xfrm_state *x, struct sk_buff *skb,
 
 	*nexthdr = &ipv6_hdr(skb)->nexthdr;
 
-	while (offset + 1 <= packet_len) {
+	while (offset <= packet_len) {
+		struct ipv6_opt_hdr *exthdr;
 
 		switch (**nexthdr) {
 		case NEXTHDR_HOP:
@@ -422,12 +425,15 @@ static int mip6_rthdr_offset(struct xfrm_state *x, struct sk_buff *skb,
 			return offset;
 		}
 
+		if (offset + sizeof(struct ipv6_opt_hdr) > packet_len)
+			return -EINVAL;
+
+		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
 		offset += ipv6_optlen(exthdr);
 		*nexthdr = &exthdr->nexthdr;
-		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
 	}
 
-	return offset;
+	return -EINVAL;
 }
 
 static int mip6_rthdr_init_state(struct xfrm_state *x)
-- 
2.7.4

