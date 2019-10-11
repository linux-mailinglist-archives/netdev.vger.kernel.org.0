Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12366D438B
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfJKO5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfJKO5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 10:57:00 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EE23F2BF73;
        Fri, 11 Oct 2019 14:56:59 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.206.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3C935C1B2;
        Fri, 11 Oct 2019 14:56:58 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next v4 3/6] xfrm: add route lookup to xfrm4_rcv_encap
Date:   Fri, 11 Oct 2019 16:57:26 +0200
Message-Id: <286a02df9173e92e21b4f44e3f777e096ec34faa.1570787286.git.sd@queasysnail.net>
In-Reply-To: <cover.1570787286.git.sd@queasysnail.net>
References: <cover.1570787286.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 11 Oct 2019 14:57:00 +0000 (UTC)
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
index 8a4285712808..ea595c8549c7 100644
--- a/net/ipv4/xfrm4_protocol.c
+++ b/net/ipv4/xfrm4_protocol.c
@@ -72,6 +72,14 @@ int xfrm4_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
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
@@ -79,6 +87,7 @@ int xfrm4_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
 out:
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 
+drop:
 	kfree_skb(skb);
 	return 0;
 }
-- 
2.23.0

