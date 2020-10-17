Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14662914C2
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439674AbgJQVgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:36:50 -0400
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:2205
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439571AbgJQVgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/guNfZ3Kw8qWSWVGcoKjjflmtp9OO+/yGidZP0v0uEaHu62SnQxkg/eQdpu60qMu7mNw3Btbbkr8GYu/2ZaD5yEFI5CplDVXn7ydbokFEABBzxJVTd6QW12Hbd+af+4b1i4IwDcNEk9YAxhAevcHH8uMtmqxgS/2XfNyIzO4FI5+JWNH+kPUYqJpRTV1DJppDDIRFYn0WVM4wohQH2ACAgZVqgsYW/ciklUEltrNbAlDWr5mRfciT49IXBG0+/cFVmO6eKpFcS85gRBCCPZIb/m8hwup3v50b8POhpAJ6Bx8/WBXE2sJ8+oK/0irLtL2U7b+/QvbTUr+dOAUMbSVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNvKApBPi1G5wozBbipSUnx+lnpcbrQnLsNzDBRsR2Q=;
 b=Kz8seYqgC9PtahrX0IrPIMr7LpEcQyKb175lUaVv+zZ5x6x7THXmf9/K/y6kkdAGMcPq9cCRafiTpItEQATezjZ23rysZBoArsztEWbfFEM7ItE+gRejt8icNNxQqn/6xN0f2F4UbTvwaOkmAvX1wCiUA9U2d8LTWaL8zUnLKULdnRNl8HYxFVhgI8CXIdfb9r9tbH1eLvoyF+xG2Lp6xmrSscf1dTdLGEyTrNWDvWqfeRrw6xsqf0qyOGDW7GAucietYPpYloZIN1U9DT9mXJNBKmyo9uf4xS+fP89VvWVY394LXBUfpGi4BFwoTJQu3d6mKHO4Ip2/q6AsI1yLCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNvKApBPi1G5wozBbipSUnx+lnpcbrQnLsNzDBRsR2Q=;
 b=WiB0PSNcKUTa6ZiN4k9NMeZWzplp/Uj38rwJ8+g56V7Uq52j3OxL8q/03QYVdBCMtf1fr/97D5oTmhFXbP1BdXg0pXHddepCyyEJnSENJFvt/GR2O8oVPrYFs6/3qTEHT/CInSEs1rdiNItSHTJ93JWAI+SAxxb59/aYfL492wE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:36 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 03/13] net: dsa: tag_ksz: don't allocate additional memory for padding/tagging
Date:   Sun, 18 Oct 2020 00:36:01 +0300
Message-Id: <20201017213611.2557565-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: VI1P195CA0091.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 33b69c15-4199-4936-9c34-08d872e4b91c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB58540A08FBA0D207ECD3E422E0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lZxWHj4arydIoCjiECyWZE6fjXc6FPcHeBnM5/ppKND3pv+FtBRjFSrx8aeUi73dE7z6Jsa/AKOqnAcd40DV2HddGCKrs9MeW7xaQgtDvurNeoLl935lFt9Yndvbl8JekLHreEodRXEeenYbjX2Put7HekYYb7vgDnkJT+psl4g8DLNbiqKND5LlnnBd8gpDtl7vBhV6SHOnzE5ntxcJd41hNNXtGGDKqWrdV0C91f7rfSUeTwrlhq/X6VIAfI/X8XjMw+qYXTbStOKXg93Q3ALs1/eQ6pBuvSbMLuJbFiQqMWZccHYwNxOSdW/Wkw+sSODaiJcf/7RtONvuiDPoPQ7ey2s71l/3L2lhQZ3+6ug7HVUNPCJW0RHzpyCjxBdt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EwoKh9w0SWvh+2N9nahk7E53thKsxzTDQOmf4azOVPgePumELZOh5jsiiaywBdI460dPIlE3Lw+juJ6m4fC5YrCpJYs9IN5VxpD8EgOjPJC9tHeLjlvuezT36cPdghraC0jEvj0Mdes+fZyjnxWs0Pc8z0iwUTi/EBBLdnVsoeLUGqM3C2uPyUQS+X6RoI8nNhjzEp+tQQUfkWpazTnusE4uVXkeZyTW/gbYdafKDYdCWhH0XZGm38cUTFR9dDFC4iPaC9aJegQbbshSPg3PGKfqzv9dhsequamSBJneIsm6IS1NUsAYNEPG3BRJ+s9QQKBVLJ9TauY6I6As9dMudwYxOsBH7NF1uH7SHp+BmDiihkBadbiDP4G1J/HGt3wyeLuQp8nya5bRTJBivjaFOrXydYnb01Kxy0NPe+1xItbwVNyF6kAhcYMhdXIakg/Cez/qGeo0jFkUTNmOpXmQ8g/S/C/RDSE27kGXOTnF7ij1naKJvVDgA+/pS5Pv3UbXvww41O2SRUmA4BW9RO7Ob99C6oR1wrWW9cmgXIy2rQxQrgv2fmgUzL1/r1RMiIFEqYN2bao+aufOoMlv5JgHNaPfbAItE7LK5L6zrX0NnavRZnNDpeB3ZEBwPZ4lyw9m0OaU2KtQ+grP47zezEUHZQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b69c15-4199-4936-9c34-08d872e4b91c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:35.8264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQNSccFLFe7d3NYATmo74Sm7vH50RHmxSdZXzMpWlV8oE6fRgt4KXg9mQ/ljC0SxgN23FUvNEEEoDT57fSqnKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

The caller (dsa_slave_xmit) guarantees that the frame length is at least
ETH_ZLEN and that enough memory for tail tagging is available.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_ksz.c | 73 ++++++-----------------------------------------
 1 file changed, 9 insertions(+), 64 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 945a9bd5ba35..e78a783bb841 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -14,46 +14,6 @@
 #define KSZ_EGRESS_TAG_LEN		1
 #define KSZ_INGRESS_TAG_LEN		1
 
-static struct sk_buff *ksz_common_xmit(struct sk_buff *skb,
-				       struct net_device *dev, int len)
-{
-	struct sk_buff *nskb;
-	int padlen;
-
-	padlen = (skb->len >= ETH_ZLEN) ? 0 : ETH_ZLEN - skb->len;
-
-	if (skb_tailroom(skb) >= padlen + len) {
-		/* Let dsa_slave_xmit() free skb */
-		if (__skb_put_padto(skb, skb->len + padlen, false))
-			return NULL;
-
-		nskb = skb;
-	} else {
-		nskb = alloc_skb(NET_IP_ALIGN + skb->len +
-				 padlen + len, GFP_ATOMIC);
-		if (!nskb)
-			return NULL;
-		skb_reserve(nskb, NET_IP_ALIGN);
-
-		skb_reset_mac_header(nskb);
-		skb_set_network_header(nskb,
-				       skb_network_header(skb) - skb->head);
-		skb_set_transport_header(nskb,
-					 skb_transport_header(skb) - skb->head);
-		skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
-
-		/* Let skb_put_padto() free nskb, and let dsa_slave_xmit() free
-		 * skb
-		 */
-		if (skb_put_padto(nskb, nskb->len + padlen))
-			return NULL;
-
-		consume_skb(skb);
-	}
-
-	return nskb;
-}
-
 static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 				      struct net_device *dev,
 				      unsigned int port, unsigned int len)
@@ -90,23 +50,18 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 static struct sk_buff *ksz8795_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	u8 *tag;
 	u8 *addr;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	*tag = 1 << dp->index;
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ8795_TAIL_TAG_OVERRIDE;
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *ksz8795_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -155,18 +110,13 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	__be16 *tag;
 	u8 *addr;
 	u16 val;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ9477_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ9477_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	val = BIT(dp->index);
 
@@ -175,7 +125,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	*tag = cpu_to_be16(val);
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -211,24 +161,19 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	u8 *addr;
 	u8 *tag;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	*tag = BIT(dp->index);
 
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
-	return nskb;
+	return skb;
 }
 
 static const struct dsa_device_ops ksz9893_netdev_ops = {
-- 
2.25.1

