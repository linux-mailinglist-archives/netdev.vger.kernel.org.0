Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADD41DB801
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgETPV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:21:58 -0400
Received: from novek.ru ([213.148.174.62]:60446 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgETPV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:21:56 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D503A50297C;
        Wed, 20 May 2020 18:21:50 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D503A50297C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589988111; bh=koLO4TISG4gY89/5vPvgGSwyjXwmtufqW8yuetn79g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSOKF2BXivokcrvKm/QW9dlRkcRZZcdvMzI6FKfslXcoQrjGWq3ZpoALGe2EWtXCI
         MgXDZeGV5Hn1oz416idJ0W5sc7InYe5VtHjUh/5F89cMld1uok7x4cEV2vHqOgnRnA
         IuJBWe7mZqcod54Z+0wiXTJnARrAcAeIcml9g41E=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net-next v2 2/5] ip6_tunnel: add MPLS transmit support
Date:   Wed, 20 May 2020 18:21:36 +0300
Message-Id: <1589988099-13095-3-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
References: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=1.7 required=5.0 tests=UNPARSEABLE_RELAY,URIBL_BLACK
        autolearn=no autolearn_force=no version=3.4.1
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ETH_P_MPLS_UC as supported protocol.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv6/ip6_tunnel.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index dae6f71..6b94c87 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1232,6 +1232,8 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 		ipv6_push_frag_opts(skb, &opt.ops, &proto);
 	}
 
+	skb_set_inner_ipproto(skb, proto);
+
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
 	ipv6h = ipv6_hdr(skb);
@@ -1348,6 +1350,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 				fl6.flowlabel |= ip6_flowlabel(ipv6h);
 			break;
 		default:
+			orig_dsfield = dsfield = ip6_tclass(t->parms.flowinfo);
 			break;
 		}
 	}
@@ -1358,8 +1361,6 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	if (iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6))
 		return -1;
 
-	skb_set_inner_ipproto(skb, protocol);
-
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
 			   protocol);
 	if (err != 0) {
@@ -1402,6 +1403,9 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 			goto tx_err;
 		ipproto = IPPROTO_IPV6;
 		break;
+	case htons(ETH_P_MPLS_UC):
+		ipproto = IPPROTO_MPLS;
+		break;
 	default:
 		goto tx_err;
 	}
-- 
1.8.3.1

