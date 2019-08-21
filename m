Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70D0986C8
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbfHUVqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:46:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730950AbfHUVqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 17:46:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 315D52A09A3;
        Wed, 21 Aug 2019 21:46:05 +0000 (UTC)
Received: from hog.localdomain, (ovpn-204-30.brq.redhat.com [10.40.204.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A05C4513;
        Wed, 21 Aug 2019 21:46:03 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 4/7] xfrm: add route lookup to xfrm4_rcv_encap
Date:   Wed, 21 Aug 2019 23:46:22 +0200
Message-Id: <aa7233431bb1b7791c8da7c61ad164d4bba9033d.1566395202.git.sd@queasysnail.net>
In-Reply-To: <cover.1566395202.git.sd@queasysnail.net>
References: <cover.1566395202.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 21 Aug 2019 21:46:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At this point, with TCP encapsulation, the dst may be gone, but
xfrm_input needs one.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv4/xfrm4_protocol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ipv4/xfrm4_protocol.c b/net/ipv4/xfrm4_protocol.c
index bcab48944c15..1665e1a05ec5 100644
--- a/net/ipv4/xfrm4_protocol.c
+++ b/net/ipv4/xfrm4_protocol.c
@@ -76,6 +76,14 @@ int xfrm4_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
 	if (!head)
 		goto out;
 
+	if (!skb_dst(skb)) {
+		const struct iphdr *iph = ip_hdr(skb);
+
+		if (ip_route_input_noref(skb, iph->daddr, iph->saddr,
+					 iph->tos, skb->dev))
+			goto drop;
+	}
+
 	for_each_protocol_rcu(*head, handler)
 		if ((ret = handler->input_handler(skb, nexthdr, spi, encap_type)) != -EINVAL)
 			return ret;
@@ -83,6 +91,7 @@ int xfrm4_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
 out:
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 
+drop:
 	kfree_skb(skb);
 	return 0;
 }
-- 
2.22.0

