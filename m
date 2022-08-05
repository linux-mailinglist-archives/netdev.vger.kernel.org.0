Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D5158B027
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 21:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241224AbiHETC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 15:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbiHETC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 15:02:56 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550551A825;
        Fri,  5 Aug 2022 12:02:54 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275IwEkG013875;
        Fri, 5 Aug 2022 21:00:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=12052020; bh=DY+k8f6xizD0E3lDErdfonPO+Yme8zArGJdWjHyUqU8=;
 b=3VptLbCDLonm4U2mDgkzwUEUC52OQtaEECvttjmJGO6EyOdi1IBEJtIJZS4HE+ocj+90
 v8Rm5ZSoqnUJS4z3swui6gcJRXZJFE2D1JsnWSU1t6FqMVoJOY2lI2dIT0FztKh7xv3d
 VrKdtuPxOCwF308CQ56PQLgEnEPUx+bbqMMu619/NybVRu65fC0I7KymMDlB3BOGvvSQ
 UVaSrEbzvrnim4Q/wA8BLrU4Vbyv666WUHEYELrLYQIwZPYYtfpycck7h0ZsBA6w1U4T
 oarnPJVD2oBOdaPFiVOT4BjAhL4ukEiJB6aUElOQ2GVp0asJrijgxCAEGjhmIQJNREv9 BA== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hr402hn6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 21:00:20 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Fri, 5 Aug 2022 21:00:17 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <nicolas.dichtel@6wind.com>,
        <eyal.birger@gmail.com>, <linux-kernel@vger.kernel.org>,
        <jesse@nicira.com>, <pshelar@nicira.com>, <tgraf@suug.ch>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH v4 net] geneve: fix TOS inheriting for ipv4
Date:   Fri, 5 Aug 2022 21:00:06 +0200
Message-ID: <20220805190006.8078-1-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: AfOFOut94Z3B6azK3CtgGuOFKlYf8rtW
X-Proofpoint-ORIG-GUID: AfOFOut94Z3B6azK3CtgGuOFKlYf8rtW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code retrieves the TOS field after the lookup
on the ipv4 routing table. The routing process currently
only allows routing based on the original 3 TOS bits, and
not on the full 6 DSCP bits.
As a result the retrieved TOS is cut to the 3 bits.
However for inheriting purposes the full 6 bits should be used.

Extract the full 6 bits before the route lookup and use
that instead of the cut off 3 TOS bits.

Fixes: e305ac6cf5a1 ("geneve: Add support to collect tunnel metadata.")
Signed-off-by: Matthias May <matthias.may@westermo.com>
---
v1 -> v2:
 - Fix typo in "Fixes" tag
v2 -> v3:
 - Add missing CCs
v3 -> v4:
 - Drop reference to IPv6 equivalent of this patch (Guillaume Nault)
 - Return of full_tos in geneve_get_v4_rt only when needed (David Ahern))
---
 drivers/net/geneve.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 018d365f9deb..fafe7dea2227 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -797,7 +797,8 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 				       struct geneve_sock *gs4,
 				       struct flowi4 *fl4,
 				       const struct ip_tunnel_info *info,
-				       __be16 dport, __be16 sport)
+				       __be16 dport, __be16 sport,
+				       __u8 *full_tos)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct geneve_dev *geneve = netdev_priv(dev);
@@ -823,6 +824,8 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 		use_cache = false;
 	}
 	fl4->flowi4_tos = RT_TOS(tos);
+	if (full_tos)
+		*full_tos = tos;
 
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
@@ -911,6 +914,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	const struct ip_tunnel_key *key = &info->key;
 	struct rtable *rt;
 	struct flowi4 fl4;
+	__u8 full_tos;
 	__u8 tos, ttl;
 	__be16 df = 0;
 	__be16 sport;
@@ -921,7 +925,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
-			      geneve->cfg.info.key.tp_dst, sport);
+			      geneve->cfg.info.key.tp_dst, sport, &full_tos);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
@@ -965,7 +969,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 
 		df = key->tun_flags & TUNNEL_DONT_FRAGMENT ? htons(IP_DF) : 0;
 	} else {
-		tos = ip_tunnel_ecn_encap(fl4.flowi4_tos, ip_hdr(skb), skb);
+		tos = ip_tunnel_ecn_encap(full_tos, ip_hdr(skb), skb);
 		if (geneve->cfg.ttl_inherit)
 			ttl = ip_tunnel_get_ttl(ip_hdr(skb), skb);
 		else
@@ -1149,7 +1153,7 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 					  1, USHRT_MAX, true);
 
 		rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
-				      geneve->cfg.info.key.tp_dst, sport);
+				      geneve->cfg.info.key.tp_dst, sport, NULL);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 
-- 
2.35.1

