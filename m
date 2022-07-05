Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06520567233
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiGEPL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiGEPLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:11:41 -0400
X-Greylist: delayed 963 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Jul 2022 08:11:36 PDT
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DB717598
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 08:11:36 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265Bm3dP022400;
        Tue, 5 Jul 2022 16:55:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=12052020; bh=IdIdJuJI+iyfrh1Q8HLtMiVUHTDL47KICSRrw8QtGO4=;
 b=3fOU9u7L36JyoAfKn8EbRa7yoEJbJ2xmMcr+08Y/QM4Y2VTc+r2PifQU2L+/gDS3MEgq
 GaxfZCJrKYcBJ4FAW/Rz+x0BEdyB8PZ5Vnnn6YDgvnFpCbe+2VK9EUncdqM8KuW+a3++
 F5hU1HJPDmLKJyX0Gphj1O8LLXey2HQPMxmzhGPj7Sh5VRpqn6BzkRktAgjAuvc9F1Ds
 DEnZLOWRQJlT+5oWbtl2LMZaztdjwIuUYI/3yevZBojksKBQEvZuQOgtc926qChI9p1l
 FtO30qiQJK7768l4txxhxOI6PB+ULLiDstTGeQKQXC5t/gClc103xvLU4AtzFhZPZ5D+ GQ== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h2accu6su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 16:55:29 +0200
Received: from Orpheus.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Tue, 5 Jul 2022 16:55:26 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     Matthias May <matthias.may@westermo.com>
Subject: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP frames
Date:   Tue, 5 Jul 2022 16:54:42 +0200
Message-ID: <20220705145441.11992-1-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-ORIG-GUID: vkAJXhV_0oRWsaK5HGZDiLjVBStr0jlB
X-Proofpoint-GUID: vkAJXhV_0oRWsaK5HGZDiLjVBStr0jlB
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
visible skb->protocol is of type ETH_P_8021Q.

Add a check on ETH_P_8021Q and subsequently check the payload protocol.

Signed-off-by: Matthias May <matthias.may@westermo.com>
---
 net/ipv4/ip_tunnel.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 94017a8c3994..0dbd24861707 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -648,6 +648,12 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	u8 tos, ttl;
 	__be32 dst;
 	__be16 df;
+	__be16 *payload_protocol;
+
+	if (skb->protocol == htons(ETH_P_8021Q))
+		payload_protocol = (__be16 *)(skb->head + skb->network_header - 2);
+	else
+		payload_protocol = &skb->protocol;
 
 	inner_iph = (const struct iphdr *)skb_inner_network_header(skb);
 	connected = (tunnel->parms.iph.daddr != 0);
@@ -670,13 +676,12 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 			dst = tun_info->key.u.ipv4.dst;
 			md = true;
 			connected = true;
-		}
-		else if (skb->protocol == htons(ETH_P_IP)) {
+		} else if (*payload_protocol == htons(ETH_P_IP)) {
 			rt = skb_rtable(skb);
 			dst = rt_nexthop(rt, inner_iph->daddr);
 		}
 #if IS_ENABLED(CONFIG_IPV6)
-		else if (skb->protocol == htons(ETH_P_IPV6)) {
+		else if (*payload_protocol == htons(ETH_P_IPV6)) {
 			const struct in6_addr *addr6;
 			struct neighbour *neigh;
 			bool do_tx_error_icmp;
@@ -716,10 +721,10 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	tos = tnl_params->tos;
 	if (tos & 0x1) {
 		tos &= ~0x1;
-		if (skb->protocol == htons(ETH_P_IP)) {
+		if (*payload_protocol == htons(ETH_P_IP)) {
 			tos = inner_iph->tos;
 			connected = false;
-		} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		} else if (*payload_protocol == htons(ETH_P_IPV6)) {
 			tos = ipv6_get_dsfield((const struct ipv6hdr *)inner_iph);
 			connected = false;
 		}
@@ -765,7 +770,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	df = tnl_params->frag_off;
-	if (skb->protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
+	if (*payload_protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
 		df |= (inner_iph->frag_off & htons(IP_DF));
 
 	if (tnl_update_pmtu(dev, skb, rt, df, inner_iph, 0, 0, false)) {
@@ -786,10 +791,10 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	tos = ip_tunnel_ecn_encap(tos, inner_iph, skb);
 	ttl = tnl_params->ttl;
 	if (ttl == 0) {
-		if (skb->protocol == htons(ETH_P_IP))
+		if (*payload_protocol == htons(ETH_P_IP))
 			ttl = inner_iph->ttl;
 #if IS_ENABLED(CONFIG_IPV6)
-		else if (skb->protocol == htons(ETH_P_IPV6))
+		else if (*payload_protocol == htons(ETH_P_IPV6))
 			ttl = ((const struct ipv6hdr *)inner_iph)->hop_limit;
 #endif
 		else
-- 
2.35.1

