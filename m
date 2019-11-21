Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD4B105055
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfKUKSs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Nov 2019 05:18:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23757 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726861AbfKUKSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:18:45 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-Q0qn47bzPYaxsU1LWMYS6Q-1; Thu, 21 Nov 2019 05:18:41 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E51DA1005502;
        Thu, 21 Nov 2019 10:18:39 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-31.ams2.redhat.com [10.36.116.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8431A6FDCE;
        Thu, 21 Nov 2019 10:18:38 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH ipsec-next v6 3/6] xfrm: add route lookup to xfrm4_rcv_encap
Date:   Thu, 21 Nov 2019 11:18:25 +0100
Message-Id: <a28745ec23fb2a9cff0d6ef607060c0ef1b9f923.1574329035.git.sd@queasysnail.net>
In-Reply-To: <cover.1574329035.git.sd@queasysnail.net>
References: <cover.1574329035.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Q0qn47bzPYaxsU1LWMYS6Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At this point, with TCP encapsulation, the dst may be gone, but
xfrm_input needs one.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: David S. Miller <davem@davemloft.net>
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

