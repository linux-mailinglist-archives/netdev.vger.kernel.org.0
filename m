Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6ED1965C8
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 12:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgC1L3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 07:29:32 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33380 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgC1L3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 07:29:31 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3DE6020561;
        Sat, 28 Mar 2020 12:29:30 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id twhaTSQYdjP7; Sat, 28 Mar 2020 12:29:29 +0100 (CET)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C3C172026E;
        Sat, 28 Mar 2020 12:29:29 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sat, 28 Mar
 2020 12:29:29 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6372E3180285; Sat, 28 Mar 2020 12:29:29 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/5] esp6: add gso_segment for esp6 beet mode
Date:   Sat, 28 Mar 2020 12:29:23 +0100
Message-ID: <20200328112924.676-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328112924.676-1-steffen.klassert@secunet.com>
References: <20200328112924.676-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 cas-essen-01.secunet.de (10.53.40.201)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

Similar to xfrm6_tunnel/transport_gso_segment(), _gso_segment()
is added to do gso_segment for esp6 beet mode. Before calling
inet6_offloads[proto]->callbacks.gso_segment, it needs to do:

  - Get the upper proto from ph header to get its gso_segment
    when xo->proto is IPPROTO_BEETPH.

  - Add SKB_GSO_TCPV6 to gso_type if x->sel.family != AF_INET6
    and the proto == IPPROTO_TCP, so that the current tcp ipv6
    packet can be segmented.

  - Calculate a right value for skb->transport_header and move
    skb->data to the transport header position.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/esp6_offload.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index fd535053245b..8eab2c869d61 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -159,6 +159,40 @@ static struct sk_buff *xfrm6_transport_gso_segment(struct xfrm_state *x,
 	return segs;
 }
 
+static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
+					      struct sk_buff *skb,
+					      netdev_features_t features)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	const struct net_offload *ops;
+	int proto = xo->proto;
+
+	skb->transport_header += x->props.header_len;
+
+	if (proto == IPPROTO_BEETPH) {
+		struct ip_beet_phdr *ph = (struct ip_beet_phdr *)skb->data;
+
+		skb->transport_header += ph->hdrlen * 8;
+		proto = ph->nexthdr;
+	}
+
+	if (x->sel.family != AF_INET6) {
+		skb->transport_header -=
+			(sizeof(struct ipv6hdr) - sizeof(struct iphdr));
+
+		if (proto == IPPROTO_TCP)
+			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV6;
+	}
+
+	__skb_pull(skb, skb_transport_offset(skb));
+	ops = rcu_dereference(inet6_offloads[proto]);
+	if (likely(ops && ops->callbacks.gso_segment))
+		segs = ops->callbacks.gso_segment(skb, features);
+
+	return segs;
+}
+
 static struct sk_buff *xfrm6_outer_mode_gso_segment(struct xfrm_state *x,
 						    struct sk_buff *skb,
 						    netdev_features_t features)
@@ -168,6 +202,8 @@ static struct sk_buff *xfrm6_outer_mode_gso_segment(struct xfrm_state *x,
 		return xfrm6_tunnel_gso_segment(x, skb, features);
 	case XFRM_MODE_TRANSPORT:
 		return xfrm6_transport_gso_segment(x, skb, features);
+	case XFRM_MODE_BEET:
+		return xfrm6_beet_gso_segment(x, skb, features);
 	}
 
 	return ERR_PTR(-EOPNOTSUPP);
-- 
2.17.1

