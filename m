Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0BB56FBBD
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 11:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbiGKJex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 05:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbiGKJdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 05:33:24 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAFC48CAF;
        Mon, 11 Jul 2022 02:18:02 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26B7hBTa008991;
        Mon, 11 Jul 2022 11:17:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=dOKOgT8uYEst4dpp+xBHWU6voFeMpKr78Y/1VjHo7z0=;
 b=ioAZ9/zRv1y59+VRk3agFw1oBVBK/hL5fLcCxppgmRqMmLUhLFyyrpK13NsX1H+NFFX2
 Y44qPgVy/DHsPjF5KVH0JvgtaaN4+ZVKKO/h3a/hVRqSMGzuebLmwsXhObPrl8NvI2t7
 VRAemqT3+YhRECdyNvWWVkpR0+eOTDLv8Es8ARFqJy5muulUazjO9IBGU0pQMlB6RD+N
 cSobmrbTSVO4Xp0YX/PlBAiWHPQGjQLJBFgNUNM9ntwrnnmLWxhC7+cU4Vtm+lmA8LkE
 Nvwat9O8S1L9pHIdUgkWHOkJOilQRrNR4m1udb5+E9D4yOh7I92pqXuBZioigudblYTw Vw== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h6wp61x7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 11:17:40 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Mon, 11 Jul 2022 11:17:39 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH 1/4 v3 net-next] ip_tunnel: allow to inherit from VLAN encapsulated IP
Date:   Mon, 11 Jul 2022 11:17:19 +0200
Message-ID: <20220711091722.14485-2-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220711091722.14485-1-matthias.may@westermo.com>
References: <20220711091722.14485-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-ORIG-GUID: q9xWnP5NGaI7zblKRpbibQgsZYxlOt2M
X-Proofpoint-GUID: q9xWnP5NGaI7zblKRpbibQgsZYxlOt2M
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code allows to inherit the TOS, TTL, DF from the payload
when skb->protocol is ETH_P_IP or ETH_P_IPV6.
However when the payload is VLAN encapsulated (e.g because the tunnel
is of type GRETAP), then this inheriting does not work, because the
visible skb->protocol is of type ETH_P_8021Q or ETH_P_8021AD.

Instead of skb->protocol, use skb_protocol().

Signed-off-by: Matthias May <matthias.may@westermo.com>
---
v2 -> v3:
 - Instead of manual parsing, use skb_protocol() as suggested by Eyal Birger
v1 -> v2:
 - Add support for ETH_P_8021AD as suggested by Jakub Kicinski.
---
 net/ipv4/ip_tunnel.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 94017a8c3994..dbe18c16b9f6 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -641,6 +641,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	const struct iphdr *inner_iph;
 	unsigned int max_headroom;	/* The extra header space needed */
 	struct rtable *rt = NULL;		/* Route to the other host */
+	__be16 payload_protocol;
 	bool use_cache = false;
 	struct flowi4 fl4;
 	bool md = false;
@@ -651,6 +652,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	inner_iph = (const struct iphdr *)skb_inner_network_header(skb);
 	connected = (tunnel->parms.iph.daddr != 0);
+	payload_protocol = skb_protocol(skb, true);
 
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 
@@ -670,13 +672,12 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 			dst = tun_info->key.u.ipv4.dst;
 			md = true;
 			connected = true;
-		}
-		else if (skb->protocol == htons(ETH_P_IP)) {
+		} else if (payload_protocol == htons(ETH_P_IP)) {
 			rt = skb_rtable(skb);
 			dst = rt_nexthop(rt, inner_iph->daddr);
 		}
 #if IS_ENABLED(CONFIG_IPV6)
-		else if (skb->protocol == htons(ETH_P_IPV6)) {
+		else if (payload_protocol == htons(ETH_P_IPV6)) {
 			const struct in6_addr *addr6;
 			struct neighbour *neigh;
 			bool do_tx_error_icmp;
@@ -716,10 +717,10 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	tos = tnl_params->tos;
 	if (tos & 0x1) {
 		tos &= ~0x1;
-		if (skb->protocol == htons(ETH_P_IP)) {
+		if (payload_protocol == htons(ETH_P_IP)) {
 			tos = inner_iph->tos;
 			connected = false;
-		} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		} else if (payload_protocol == htons(ETH_P_IPV6)) {
 			tos = ipv6_get_dsfield((const struct ipv6hdr *)inner_iph);
 			connected = false;
 		}
@@ -765,7 +766,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	df = tnl_params->frag_off;
-	if (skb->protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
+	if (payload_protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
 		df |= (inner_iph->frag_off & htons(IP_DF));
 
 	if (tnl_update_pmtu(dev, skb, rt, df, inner_iph, 0, 0, false)) {
@@ -786,10 +787,10 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	tos = ip_tunnel_ecn_encap(tos, inner_iph, skb);
 	ttl = tnl_params->ttl;
 	if (ttl == 0) {
-		if (skb->protocol == htons(ETH_P_IP))
+		if (payload_protocol == htons(ETH_P_IP))
 			ttl = inner_iph->ttl;
 #if IS_ENABLED(CONFIG_IPV6)
-		else if (skb->protocol == htons(ETH_P_IPV6))
+		else if (payload_protocol == htons(ETH_P_IPV6))
 			ttl = ((const struct ipv6hdr *)inner_iph)->hop_limit;
 #endif
 		else
-- 
2.35.1

