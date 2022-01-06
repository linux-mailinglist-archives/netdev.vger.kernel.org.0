Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE9C48622C
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbiAFJgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:36:14 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:38736 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237371AbiAFJgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:36:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 13B2B2065A;
        Thu,  6 Jan 2022 10:36:13 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Aqe6tc7N67bK; Thu,  6 Jan 2022 10:36:12 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2337D2064D;
        Thu,  6 Jan 2022 10:36:12 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 1470A80004A;
        Thu,  6 Jan 2022 10:36:12 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 10:36:11 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 10:36:11 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0BC35318045E; Thu,  6 Jan 2022 10:36:09 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/6] xfrm: fix policy lookup for ipv6 gre packets
Date:   Thu, 6 Jan 2022 10:36:01 +0100
Message-ID: <20220106093606.3046771-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106093606.3046771-1-steffen.klassert@secunet.com>
References: <20220106093606.3046771-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ghalem Boudour <ghalem.boudour@6wind.com>

On egress side, xfrm lookup is called from __gre6_xmit() with the
fl6_gre_key field not initialized leading to policies selectors check
failure. Consequently, gre packets are sent without encryption.

On ingress side, INET6_PROTO_NOPOLICY was set, thus packets were not
checked against xfrm policies. Like for egress side, fl6_gre_key should be
correctly set, this is now done in decode_session6().

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Cc: stable@vger.kernel.org
Signed-off-by: Ghalem Boudour <ghalem.boudour@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/ip6_gre.c     |  5 ++++-
 net/xfrm/xfrm_policy.c | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index d831d2439693..f5a511c57aa2 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -755,6 +755,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		fl6->daddr = key->u.ipv6.dst;
 		fl6->flowlabel = key->label;
 		fl6->flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+		fl6->fl6_gre_key = tunnel_id_to_key32(key->tun_id);
 
 		dsfield = key->tos;
 		flags = key->tun_flags &
@@ -990,6 +991,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		fl6.daddr = key->u.ipv6.dst;
 		fl6.flowlabel = key->label;
 		fl6.flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+		fl6.fl6_gre_key = tunnel_id_to_key32(key->tun_id);
 
 		dsfield = key->tos;
 		if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
@@ -1098,6 +1100,7 @@ static void ip6gre_tnl_link_config_common(struct ip6_tnl *t)
 	fl6->flowi6_oif = p->link;
 	fl6->flowlabel = 0;
 	fl6->flowi6_proto = IPPROTO_GRE;
+	fl6->fl6_gre_key = t->parms.o_key;
 
 	if (!(p->flags&IP6_TNL_F_USE_ORIG_TCLASS))
 		fl6->flowlabel |= IPV6_TCLASS_MASK & p->flowinfo;
@@ -1544,7 +1547,7 @@ static void ip6gre_fb_tunnel_init(struct net_device *dev)
 static struct inet6_protocol ip6gre_protocol __read_mostly = {
 	.handler     = gre_rcv,
 	.err_handler = ip6gre_err,
-	.flags       = INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
+	.flags       = INET6_PROTO_FINAL,
 };
 
 static void ip6gre_destroy_tunnels(struct net *net, struct list_head *head)
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 1a06585022ab..84d2361da015 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -33,6 +33,7 @@
 #include <net/flow.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
+#include <net/gre.h>
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 #include <net/mip6.h>
 #endif
@@ -3422,6 +3423,26 @@ decode_session6(struct sk_buff *skb, struct flowi *fl, bool reverse)
 			}
 			fl6->flowi6_proto = nexthdr;
 			return;
+		case IPPROTO_GRE:
+			if (!onlyproto &&
+			    (nh + offset + 12 < skb->data ||
+			     pskb_may_pull(skb, nh + offset + 12 - skb->data))) {
+				struct gre_base_hdr *gre_hdr;
+				__be32 *gre_key;
+
+				nh = skb_network_header(skb);
+				gre_hdr = (struct gre_base_hdr *)(nh + offset);
+				gre_key = (__be32 *)(gre_hdr + 1);
+
+				if (gre_hdr->flags & GRE_KEY) {
+					if (gre_hdr->flags & GRE_CSUM)
+						gre_key++;
+					fl6->fl6_gre_key = *gre_key;
+				}
+			}
+			fl6->flowi6_proto = nexthdr;
+			return;
+
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 		case IPPROTO_MH:
 			offset += ipv6_optlen(exthdr);
-- 
2.25.1

