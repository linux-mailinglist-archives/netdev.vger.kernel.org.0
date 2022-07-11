Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAC656FBB3
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 11:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiGKJes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 05:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbiGKJdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 05:33:24 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B147AB1B;
        Mon, 11 Jul 2022 02:18:02 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26B5tOZk024300;
        Mon, 11 Jul 2022 11:17:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=JO2c4R+K+0TD0LGMJsNYHX2sr7LZuUrrSsISr8n4sug=;
 b=g9YNUdiN5k5/MwegSPG6yODjoaF9kiC06EwzPiqlGa8U4y0zFr5mfxHWEprJdtrxI92H
 ULYQtgr3wO77EnlzzuNsSek8xrmuaiYfpUA9ta04lOGKkEaDIL6+yOPeM6FgdKJpd9i+
 NuiSLoHYXVuZ6mYd2L0wmbsILBDJEycpIm+32ssqrDjy5PednvCU8ctdahgMl0hVudcm
 VnaDHIdtIbU2qrS7TOI955XjlG1rb/Ykl1kroLF8G7PrB2+oO1SFk0+F4+C/MpnShtG3
 vf/GTCsgj0h6I07+TD6s27vEDXRCyjsIYqBCSsRVOPR5smeUgTPDSpcFtPEjfjWxUHuA sg== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h6wp61x84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 11:17:45 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Mon, 11 Jul 2022 11:17:44 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH 4/4 net-next] ip6_tunnel: allow to inherit from VLAN encapsulated IP
Date:   Mon, 11 Jul 2022 11:17:22 +0200
Message-ID: <20220711091722.14485-5-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220711091722.14485-1-matthias.may@westermo.com>
References: <20220711091722.14485-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-ORIG-GUID: zrC7kDlZOZ7Ml5Tf8mmwD52WVEqV1d8w
X-Proofpoint-GUID: zrC7kDlZOZ7Ml5Tf8mmwD52WVEqV1d8w
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code allows to inherit the TTL (hop_limit) from the
payload when skb->protocol is ETH_P_IP or ETH_P_IPV6.
However when the payload is VLAN encapsulated (e.g because the tunnel
is of type GRETAP), then this inheriting does not work, because the
visible skb->protocol is of type ETH_P_8021Q or ETH_P_8021AD.

Instead of skb->protocol, use skb_protocol().

Signed-off-by: Matthias May <matthias.may@westermo.com>
---
 net/ipv6/ip6_tunnel.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 19325b7600bb..4244a66eb859 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1085,10 +1085,13 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	unsigned int eth_hlen = t->dev->type == ARPHRD_ETHER ? ETH_HLEN : 0;
 	unsigned int psh_hlen = sizeof(struct ipv6hdr) + t->encap_hlen;
 	unsigned int max_headroom = psh_hlen;
+	__be16 payload_protocol;
 	bool use_cache = false;
 	u8 hop_limit;
 	int err = -1;
 
+	payload_protocol = skb_protocol(skb, true);
+
 	if (t->parms.collect_md) {
 		hop_limit = skb_tunnel_info(skb)->key.ttl;
 		goto route_lookup;
@@ -1098,7 +1101,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 
 	/* NBMA tunnel */
 	if (ipv6_addr_any(&t->parms.raddr)) {
-		if (skb->protocol == htons(ETH_P_IPV6)) {
+		if (payload_protocol == htons(ETH_P_IPV6)) {
 			struct in6_addr *addr6;
 			struct neighbour *neigh;
 			int addr_type;
@@ -1119,7 +1122,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 
 			memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));
 			neigh_release(neigh);
-		} else if (skb->protocol == htons(ETH_P_IP)) {
+		} else if (payload_protocol == htons(ETH_P_IP)) {
 			const struct rtable *rt = skb_rtable(skb);
 
 			if (!rt)
@@ -1230,9 +1233,9 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	skb_dst_set(skb, dst);
 
 	if (hop_limit == 0) {
-		if (skb->protocol == htons(ETH_P_IP))
+		if (payload_protocol == htons(ETH_P_IP))
 			hop_limit = ip_hdr(skb)->ttl;
-		else if (skb->protocol == htons(ETH_P_IPV6))
+		else if (payload_protocol == htons(ETH_P_IPV6))
 			hop_limit = ipv6_hdr(skb)->hop_limit;
 		else
 			hop_limit = ip6_dst_hoplimit(dst);
-- 
2.35.1

