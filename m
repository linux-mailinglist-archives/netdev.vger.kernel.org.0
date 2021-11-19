Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFC6457506
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 18:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhKSRKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 12:10:11 -0500
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:58722 "EHLO
        smtpservice.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230296AbhKSRKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 12:10:10 -0500
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 7233460511;
        Fri, 19 Nov 2021 18:07:07 +0100 (CET)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mo7Lv-0002v9-A4; Fri, 19 Nov 2021 18:07:07 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Ghalem Boudour <ghalem.boudour@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] xfrm: fix policy lookup for ipv6 gre packets
Date:   Fri, 19 Nov 2021 18:04:02 +0100
Message-Id: <20211119170402.11213-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Ghalem Boudour <ghalem.boudour@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

This patch targets ipsec tree, but because this tree has not been yet
rebased on top of the net tree, I based the patch on top of net.

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
2.33.0

