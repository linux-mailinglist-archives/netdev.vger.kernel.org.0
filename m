Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7528429FABA
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgJ3Bti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:38 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:45367
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725963AbgJ3Bth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3oQW2ChSg6F7HguXXlHZx6O+fv0KF4981UkHxjIec6vHPjmtLCml+dsq+QahnD1Z67o6aPXCUEaOd4ny4PxD+xe/g/iycz3IjLv1Om3heTYL58arODjligjqn4c1LeipICukEU48e8oC2Um+4nRuogUdIcK74i1Nl47JkfavaYx3a5nIwNeGiifVibORZzVsDBJPDCEtW/HPqdyBwjaDVWCrjSoXWh81qBaGza3tjnHNIajWbxzoEn/ojWmyWUoDmEAf8jPEsTDeyaoEl+kF3p4+6SZgiA/GbpZdHOgGUfMy2KnxFAKizQ0+pX6yX+u9dBCSi70d4JPB4jxFLOz3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IYiP9UIzXhCl5uXT3kiLvoRmZ8zaQRCeESL57HeSS8=;
 b=fMg1AReYQDRJoGmrKhZhBWV5w23on+k3n8AEuEBXxV5qXzFF7OeuL9lK2k49ppTZuehrHXGkOoFXNU4wvdcE//pwqILaKVrA+atUgpF5F4JNdXBtTXc/eVIc/kwJwjIEaDkg++wnKUejueD/6REIBHcbIENyZpQJKm+yKHD88DutaLKRt8IMkQEiHTcB7w1NkyzXOd/gnZCtk27INBa6bCDFOo7uYfK/JVc1tSxFNJrnjJG80U/JMqMpiAVnDmwJmx7cQm01rBIanJoLmMY/AcE8uGaG9ZcNW+uWIHQ2WgqhAzrZbm5LcDNFAtaESAWBgR56soS5sTso+kCblXQoYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IYiP9UIzXhCl5uXT3kiLvoRmZ8zaQRCeESL57HeSS8=;
 b=W727ZencIHwIArz5u6ykzZFBX1ukrB4C/KQ0BBoFawes3iE+l2h8z1oqJcs+eMnDzLquGYfIyz01GiCVtw3iaeuVMgYD/dtYCxq+d6Zm8zeIX19sX97urI/gIRml3zAdH5QjLpBO3Tgt87m53Z6odio86QlOiICL66jHriN5+4A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:29 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net-next 02/12] net: dsa: tag_ksz: don't allocate additional memory for padding/tagging
Date:   Fri, 30 Oct 2020 03:49:00 +0200
Message-Id: <20201030014910.2738809-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 24273a8e-5f2b-450a-acb8-08d87c760a3f
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25090B2C5AFCF6E0B2F94B0EE0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hbW+682qBc6VTIcj0qBYVFndlTY6Br9VmPaHx4Dx3AMixA6lDmpN4cFE1dJNGmEtLABPC0MVZgMrs3875FC9DiOZ70vf80MDbeQIs41sNgNuxpGGKP8R8c4ZYstpOMQ7hK7O4NLplOBWIS5H4pkTLQiv65U+yAWpNvfzcq7WJgHq0UJ/rw4+oY/3gME5jfmf7VuLJ+JLkTvnCjfxAJqO5GW1W/7HxqUntqFZJAI/rdas14vo8E6JY2uhvUjAlMOcjo3bVPK9w6j7AaNQL+hB6sL8qQa5s31SJUYvCuVwILCzCVFO45onwxdUqQtqsAoZqmn9sXKSmgRCZYZbuFig4YVtogX1uGaIpAg97Gw8xYXEfetFSZrodOj3oj0qe5JT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PZUZQvZN+VQ9A/pF/wu3bWSTPspLANY/QJ6iZ38RrrBjax53Jtm/NLHt+hP86WDUfBMIu584kv6tt76EYDqfbNATC4flJhimPgwR19z9+IkqCjEkN65VDK1WP22pCApFJc+IN+k8xLSpvfwnu8/XQixExObUByct6h9/zZ+Uqdw6Zc4QEH2Dz1u8/Ly7FBR1LiWanqLftm6cQP9nPWtWT5t1CW+VxN+X0ZVP+D9IMe893IOxP28tAYAIzUvMA9YNVsqsH8vVp7Q7jVmkH70JAET1nfWlj+kVk962wUkdOxiFK12QwAgLvE03hOhKvjYjXJHRdi4K2PQMtiHsb7RgfCrSxNrpKkXjjXwJuxJqhTYd9oH3nh5FaJ88+lHmX/lVYYY5iOqytJHC4Ab24LK1hOwYfwjtf+NBUDD8yGp1HVhV3Okd9UIJEsA24kzKE1moCKJK/4ExC3+V5LOSpRRfTbkL9LjFPKcT14YZpKQHuXGU7ND3oNTEncgmW182gMSCVzuwq4sP8dRzYhKhIAliOAF3L4jDahDZkW92PvCx6D0mrNw16lHEpj+6ekVVzaqnuOpSKKORCUPqwbJYlQgirfUqbdOTVsp8j/P+WQeClEUT+X3qJCjZhMqUHdk4mPwhLyxKembEQJ20E5NlXQ9OhQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24273a8e-5f2b-450a-acb8-08d87c760a3f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:29.4544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gY5ftAgimqHw2mhdE8o/zC6cN9u0E00Mx9jVbiw/CmIpwybc17YN7Ck1oAqnWCKEGnbQQnTSGjKAqV4gSTyGVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

The caller (dsa_slave_xmit) guarantees that the frame length is at least
ETH_ZLEN and that enough memory for tail tagging is available.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_ksz.c | 73 ++++++-----------------------------------------
 1 file changed, 9 insertions(+), 64 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 0a5aa982c60d..4820dbcedfa2 100644
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
@@ -156,18 +111,13 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
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
 
@@ -176,7 +126,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	*tag = cpu_to_be16(val);
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -213,24 +163,19 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
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

