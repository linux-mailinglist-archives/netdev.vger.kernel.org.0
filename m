Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E61437C4
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 08:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAUHjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 02:39:07 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36740 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728708AbgAUHjG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 02:39:06 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CA4F320185;
        Tue, 21 Jan 2020 08:39:04 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ss4Ux7Zmi6mH; Tue, 21 Jan 2020 08:39:04 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8ABF520533;
        Tue, 21 Jan 2020 08:39:03 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 08:39:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 47D1431802DB;
 Tue, 21 Jan 2020 08:39:03 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/6] xfrm: add route lookup to xfrm4_rcv_encap
Date:   Tue, 21 Jan 2020 08:38:55 +0100
Message-ID: <20200121073858.31120-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121073858.31120-1-steffen.klassert@secunet.com>
References: <20200121073858.31120-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

At this point, with TCP encapsulation, the dst may be gone, but
xfrm_input needs one.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.17.1

