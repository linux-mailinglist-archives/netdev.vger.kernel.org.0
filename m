Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04ED13DC642
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 16:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhGaOO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 10:14:56 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:62085
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232770AbhGaOOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 10:14:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iW7oz/PNVK5VCWI2JeLHcyY865HO8C4PAPW317/z08c7pEROhdoSPU1gKAMUikXR2S/8VXGEj3ZQFJDZqhAC+jZ3wgQqhoO66mcPK50TwSjZuIy8UbCXnUZFfHXWLc3f0FMdkcD8IFC71ETFgkAQsnSV0F9/SGBemGW5hbmIPEhToDbrNbVH+KDO+916TlcqXbjNIlm9YALwiMlRMvQEHHKpK5I16N/8YktNi67ol5s1HcbXgSgoMcr/HIYeWo8980O6hyTFMx3hhXjBy4uIw9wA7mMmiyM7wqnPpU7nHAUZiE31oLwwjpOa9O3ti3g/WzJ0uAxQ26I3q+U3aJzWig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eqEpIzRf/2hgRwwqY+6Mutv9MLbvs8P2J0ka8+ZToc=;
 b=i+pQsr+IgpInQc2t62W9mprnXM0vTffP6h6xhWIlxvBcH77szHyF0K9Garhr90KO51gUKo501OamcAi+jM1Bcq0bovjRtjdW4+T4ebPP7meJVnI7P5zw3mwldogoI5j3BMPh+kOLRXeGbOiQaL5KRGsZqXHQrMb3k8f8bQQXC2ku3PRupRCoh6TBwRh6y9eHcyB7ZkdU4I5VxpWyK0qm0jmnG0mOvEpEECFOMCJdOVBpV4hyUKzxBJNk3jfTONcRwCvZyak8UD74bojvHW0MTTpt6XcUbpA0om6VJk39uQUilEZoyYLlpLbRKeRcbJ2JqQXsE4pUvRFOBZx78m+BpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eqEpIzRf/2hgRwwqY+6Mutv9MLbvs8P2J0ka8+ZToc=;
 b=CfZN7/nsZiyg611SeGrLBzoXRChiW/wJ8NuGEthcFrTHpAgHgALX06J/YsN7qANMgLK2SIGmIbJ+33LF5lHiBU8IB9fkIk4WIIc16/MHYBT0aG4CtCCqNye5BMew/bc/DUl6RPqwlVGLB0y25j3RK4Zjt27gIJXx9BaSLCSwNq4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Sat, 31 Jul
 2021 14:14:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 14:14:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: remove the struct packet_type argument from dsa_device_ops::rcv()
Date:   Sat, 31 Jul 2021 17:14:32 +0300
Message-Id: <20210731141432.2183420-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR1PR01CA0021.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR1PR01CA0021.eurprd01.prod.exchangelabs.com (2603:10a6:102::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Sat, 31 Jul 2021 14:14:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94565f1b-bc97-4f4e-4f99-08d9542d8cbb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5696457EAE299CD38D47C785E0ED9@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfMQ43nh15v/AU4qbKmCz1WNzIYOcRN7poj/nHb5slnMPQZD3rD+KI/Ibz8c88ZIMpbmB0tBck8cgCnsl9lly1/dzMwJOctoTvfBk+m8b8oKGoXeC02/BTkl6A3bRr6e5DGJoulRSM6Mnp59KvySczirGrmGg/BF6wXKqwnkVGwkn+hjdN2exMarQnlLbmegtuK6DKydkzh440+Z6NowyFG22ept6lOoPPZdDXONsC0qgfsnxMRRB+SeGWFyG8sFhXD9M+4eS+O1AfLZQdNQcngrftSrGophCsIf+lKSobLFawwcU3qvWASBlh6y4rzTzFTnK/xQTb9IcuEveeiAyoNrEvi0jR7BupYgqI8XqQfPK9KSRwpQY7ophawfmtSBkp9L2pd/JEmeEfh7Lh9gHJ7hL/ku3jZQo9Ou+Jvqz7xQQOm9au/e/7fst9e+IMfqGpigm21z8zGmfoqPQ4mcxDop9o738Ehwuy68raZCegv4kA7645Pg66XmZaQtq3Rm2RdrBQPyBVFfsuGsbdxvN3up/gIjKQXIoq0ljIMmmMUwNbStCAYcBXx8on9blAsZPkRa0v/C2MxUij8p/wIHBfSb7ucmDGXZsf7HXuniQ/KR+t5cGhKiRD1SH9EUNC0Ks2ZVY+b6fkM9vVZBVhkS8gmZwWXPwVPA9LEnkJ/+fwqeHWyKG6FTVeXtQDDjNCx2yBFZ1rwH1sY+gPRX0ytqkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(346002)(366004)(396003)(136003)(38350700002)(38100700002)(6512007)(36756003)(6486002)(83380400001)(86362001)(956004)(6506007)(26005)(2616005)(30864003)(66476007)(66946007)(66556008)(5660300002)(316002)(8936002)(186003)(52116002)(478600001)(54906003)(4326008)(110136005)(1076003)(44832011)(8676002)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gz0h1WBX7DhTXa/i0c/SVaaeT3wcNnEJzQlsah59z7DElwDRoxF5hUnoSs7H?=
 =?us-ascii?Q?xwO7RpyB1RiRSaQ3scNNOzVf8E6s2nDtal6axCfOVTkuIdThVBpJn0n6JxFT?=
 =?us-ascii?Q?5729eNXbLXLXasbfcWokGuBOld1nXBugVHjiUn2nbv88oz/igYM0LkyU5mjk?=
 =?us-ascii?Q?DUsmOvH9k0wkDp0K5aVDYbjwVJhmAaboEMLnKUFkRAzWjLN0oxHgDuNCFFCz?=
 =?us-ascii?Q?e0kw/0eMNYBT1UKCmmUlf6EtzSNaC3mL+nLcRPcZxER4IZ+XxH0SlRFNHzBX?=
 =?us-ascii?Q?Lo+Jjq+gT+A4XrZbb3WZ+2potAe3HRiL5FN5HfHaMDrnnJeat6w5v4iD5qzV?=
 =?us-ascii?Q?PXsFQUzRo2vcf9G7npx0cnKXOG8f2QeDY+hq8NkG25K4gqXwa7xL2/Fc44Mj?=
 =?us-ascii?Q?WNTCeW6v7mStZIZcujSZrlVXr+p8RO0tk2RoX53NZBqPCw3agImyvcMTEkOw?=
 =?us-ascii?Q?/X7HzVsDiwCozi9Rv5a0W1tUPxcdZojQpnyP0cPi4g1n1YFiTQKI1pEli3jU?=
 =?us-ascii?Q?xPAontQF5lEtwP02Wn/NX1rtaVXKJvdyhXfVIZR6mBNLyc9VHjdnTp6QVx01?=
 =?us-ascii?Q?dx6UiEzHLOW1k1ua0saz0DKMO+LSFaiEhmMkXIWqsMFW876/HBDb5rXQa4L4?=
 =?us-ascii?Q?P36iZaO4uarOGRnKqkOXthWFHCOmM8V4ZilzM2sUsj6DvowZqMKiTuBccjuF?=
 =?us-ascii?Q?4YP+0u6pbpla//KmSJO3aGLz5jAL68MIW9eNkZz8ZzEVHHWuT7uQZu4Njnj6?=
 =?us-ascii?Q?DDuNUBBN1N0JodKXDu3N3OxguxWQ9a0MN2vlcMq8IYLoR7wABlVz+LgFfleA?=
 =?us-ascii?Q?BPMJnICF6rNR4BWQ+eSWW2CElrXhGIRaSTwP4frApYoc4lCs8CERTpcD88K3?=
 =?us-ascii?Q?cze3JKVQjWXGnDz/fRk26aPhgqnSEwT5Uwi2RlAcK6RF2M5C+XtAPCKiOBel?=
 =?us-ascii?Q?aD2Iv/5xAMTNQw4okQQykuNE01j0+TKc++2/sZ8nZae6KwVZR9eLZL5bVJQ3?=
 =?us-ascii?Q?r3uKCqOijm5W3n2Atyl8KclYi1c4B8bFNTv1IuwRza/61yyRQC/+xaD9+ojc?=
 =?us-ascii?Q?frHm/e0MeJoqT9GLNZkCkCwG4XJTRRGg5EieVjhbB4YV+ds8dJBhK9puWy0y?=
 =?us-ascii?Q?xkjUXTF0dI1zaW3AGtHIbc6ZJvRVPEQtuVexQM0Eh1s7SCzdMuNhOalUTOtm?=
 =?us-ascii?Q?PWlbcIvRLa1gtP1xpwQ3HOrz551KhfjsbXN14dD2JpLQM3GOH7rbHIpKqVgD?=
 =?us-ascii?Q?NjxRTmz6e9kL37Ch3i1BeU4Cvu7qZIpxLqdJMPCslOLY+ptnH/DvmDpJL3fw?=
 =?us-ascii?Q?ddBF8eGyRLHooWJVP0q5Zk6j?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94565f1b-bc97-4f4e-4f99-08d9542d8cbb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 14:14:46.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRCTMIl2YPMgBV7clgQlqK9MmYpeAXZePCcuupiMyjgGucFIGDiqlmYhRYWTrHk1KkR/sTEkgFfQ8zOK3DCl6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No tagging driver uses this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h          |  7 ++-----
 net/dsa/dsa.c              |  2 +-
 net/dsa/tag_ar9331.c       |  3 +--
 net/dsa/tag_brcm.c         | 14 +++++---------
 net/dsa/tag_dsa.c          |  6 ++----
 net/dsa/tag_gswip.c        |  3 +--
 net/dsa/tag_hellcreek.c    |  3 +--
 net/dsa/tag_ksz.c          |  6 ++----
 net/dsa/tag_lan9303.c      |  3 +--
 net/dsa/tag_mtk.c          |  3 +--
 net/dsa/tag_ocelot.c       |  3 +--
 net/dsa/tag_ocelot_8021q.c |  3 +--
 net/dsa/tag_qca.c          |  3 +--
 net/dsa/tag_rtl4_a.c       |  3 +--
 net/dsa/tag_sja1105.c      |  6 ++----
 net/dsa/tag_trailer.c      |  3 +--
 net/dsa/tag_xrs700x.c      |  3 +--
 17 files changed, 25 insertions(+), 49 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2af6ee2f2bfb..7cc9507282d3 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -79,13 +79,11 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
 };
 
-struct packet_type;
 struct dsa_switch;
 
 struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
-	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
-			       struct packet_type *pt);
+	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
 	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
 			     int *offset);
 	unsigned int needed_headroom;
@@ -239,8 +237,7 @@ struct dsa_port {
 
 	/* Copies for faster access in master receive hot path */
 	struct dsa_switch_tree *dst;
-	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
-			       struct packet_type *pt);
+	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
 
 	enum {
 		DSA_PORT_TYPE_UNUSED = 0,
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 84cad1be9ce4..1dc45e40f961 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -238,7 +238,7 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!skb)
 		return 0;
 
-	nskb = cpu_dp->rcv(skb, dev, pt);
+	nskb = cpu_dp->rcv(skb, dev);
 	if (!nskb) {
 		kfree_skb(skb);
 		return 0;
diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index 0efae1a372b3..8a02ac44282f 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -44,8 +44,7 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
 }
 
 static struct sk_buff *ar9331_tag_rcv(struct sk_buff *skb,
-				      struct net_device *ndev,
-				      struct packet_type *pt)
+				      struct net_device *ndev)
 {
 	u8 ver, port;
 	u16 hdr;
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index a27f5096777a..96e93b544a0d 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -136,7 +136,6 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
  */
 static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 				       struct net_device *dev,
-				       struct packet_type *pt,
 				       unsigned int offset)
 {
 	int source_port;
@@ -182,13 +181,12 @@ static struct sk_buff *brcm_tag_xmit(struct sk_buff *skb,
 }
 
 
-static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev,
-				    struct packet_type *pt)
+static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	struct sk_buff *nskb;
 
 	/* skb->data points to the EtherType, the tag is right before it */
-	nskb = brcm_tag_rcv_ll(skb, dev, pt, 2);
+	nskb = brcm_tag_rcv_ll(skb, dev, 2);
 	if (!nskb)
 		return nskb;
 
@@ -251,8 +249,7 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
 }
 
 static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
-					struct net_device *dev,
-					struct packet_type *pt)
+					struct net_device *dev)
 {
 	int source_port;
 	u8 *brcm_tag;
@@ -302,11 +299,10 @@ static struct sk_buff *brcm_tag_xmit_prepend(struct sk_buff *skb,
 }
 
 static struct sk_buff *brcm_tag_rcv_prepend(struct sk_buff *skb,
-					    struct net_device *dev,
-					    struct packet_type *pt)
+					    struct net_device *dev)
 {
 	/* tag is prepended to the packet */
-	return brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
+	return brcm_tag_rcv_ll(skb, dev, ETH_HLEN);
 }
 
 static const struct dsa_device_ops brcm_prepend_netdev_ops = {
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 3607499d0697..e32f8160e895 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -332,8 +332,7 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 	return dsa_xmit_ll(skb, dev, 0);
 }
 
-static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
-			       struct packet_type *pt)
+static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	if (unlikely(!pskb_may_pull(skb, DSA_HLEN)))
 		return NULL;
@@ -373,8 +372,7 @@ static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
-static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
-				struct packet_type *pt)
+static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	if (unlikely(!pskb_may_pull(skb, EDSA_HLEN)))
 		return NULL;
diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index 5985dab06ab8..df7140984da3 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -75,8 +75,7 @@ static struct sk_buff *gswip_tag_xmit(struct sk_buff *skb,
 }
 
 static struct sk_buff *gswip_tag_rcv(struct sk_buff *skb,
-				     struct net_device *dev,
-				     struct packet_type *pt)
+				     struct net_device *dev)
 {
 	int port;
 	u8 *gswip_tag;
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index c41208cbd936..f64b805303cd 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -29,8 +29,7 @@ static struct sk_buff *hellcreek_xmit(struct sk_buff *skb,
 }
 
 static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
-				     struct net_device *dev,
-				     struct packet_type *pt)
+				     struct net_device *dev)
 {
 	/* Tag decoding */
 	u8 *tag = skb_tail_pointer(skb) - HELLCREEK_TAG_LEN;
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 1c2dfa80f9b0..fa1d60d13ad9 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -67,8 +67,7 @@ static struct sk_buff *ksz8795_xmit(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
-static struct sk_buff *ksz8795_rcv(struct sk_buff *skb, struct net_device *dev,
-				  struct packet_type *pt)
+static struct sk_buff *ksz8795_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
 
@@ -134,8 +133,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 	return skb;
 }
 
-static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
-				   struct packet_type *pt)
+static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	/* Tag decoding */
 	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index cf7cf2fa1240..58d3a0e712d2 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -74,8 +74,7 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
-static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
-				   struct packet_type *pt)
+static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	__be16 *lan9303_tag;
 	u16 lan9303_tag1;
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 3fb80e43f3a5..bbf37c031d44 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -61,8 +61,7 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	return skb;
 }
 
-static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
-				   struct packet_type *pt)
+static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	u16 hdr;
 	int port;
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 3252634a29b8..d37ab98e7fe1 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -55,8 +55,7 @@ static struct sk_buff *seville_xmit(struct sk_buff *skb,
 }
 
 static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
-				  struct net_device *netdev,
-				  struct packet_type *pt)
+				  struct net_device *netdev)
 {
 	u64 src_port, qos_class;
 	u64 vlan_tci, tag_type;
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index c95de71d13b0..3038a257ba05 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -38,8 +38,7 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 }
 
 static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
-				  struct net_device *netdev,
-				  struct packet_type *pt)
+				  struct net_device *netdev)
 {
 	int src_port, switch_id;
 
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 693bda013065..6e3136990491 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -48,8 +48,7 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
-static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
-				   struct packet_type *pt)
+static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	u8 ver;
 	u16  hdr;
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index f6b63aad6551..aaddca3c0245 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -64,8 +64,7 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 }
 
 static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
-				     struct net_device *dev,
-				     struct packet_type *pt)
+				     struct net_device *dev)
 {
 	u16 protport;
 	__be16 *p;
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 664cb802b71a..745c4560b4aa 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -391,8 +391,7 @@ static void sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
 }
 
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
-				   struct net_device *netdev,
-				   struct packet_type *pt)
+				   struct net_device *netdev)
 {
 	int source_port = -1, switch_id = -1;
 	struct sja1105_meta meta = {0};
@@ -546,8 +545,7 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 }
 
 static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
-				   struct net_device *netdev,
-				   struct packet_type *pt)
+				   struct net_device *netdev)
 {
 	int source_port = -1, switch_id = -1;
 	bool host_only = false;
diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
index ba73804340a5..5749ba85c2b8 100644
--- a/net/dsa/tag_trailer.c
+++ b/net/dsa/tag_trailer.c
@@ -24,8 +24,7 @@ static struct sk_buff *trailer_xmit(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
-static struct sk_buff *trailer_rcv(struct sk_buff *skb, struct net_device *dev,
-				   struct packet_type *pt)
+static struct sk_buff *trailer_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	u8 *trailer;
 	int source_port;
diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
index da231c16ac82..ff442b8af636 100644
--- a/net/dsa/tag_xrs700x.c
+++ b/net/dsa/tag_xrs700x.c
@@ -25,8 +25,7 @@ static struct sk_buff *xrs700x_xmit(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
-static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
-				   struct packet_type *pt)
+static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	int source_port;
 	u8 *trailer;
-- 
2.25.1

