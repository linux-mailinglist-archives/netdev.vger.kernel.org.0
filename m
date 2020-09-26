Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A3D279B71
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgIZRcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:32:16 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:45635
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729870AbgIZRcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:32:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEdW0QckUTB4mXWhzIsIJhmAEVQLehGbekhQJzb5zSbO1lkVikbpMCVDsfJ//Z8cnzIEW2UiCYzYlJpWAiE+wspLpPhMY6kajVupuNIZr8muu0ebH/gvZME26kn5NicbVQty8ogpk3vQ1IJPjsWSXn2GgCZx1HIkd7Q785WIrjZUA3WuaiQrERx0PwX9HBOc4OSYR2Mag6YdTU+WU+dANmWrBQlgj3i8IyZcjMQnCbsYD/+T/j5kUdy8vaFa9sXtglX8j9T5c9pFDa5X5ZOQ1fdufkO4SRds4k6NCTW30+AY7TxHom6mlo0upERux0G/F9gZRiKM9015r4DnyrcyPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwSDFqYNjcIHiud8Us6ffNJca+mqArUINNRoT+QU+pM=;
 b=f7MhQm+PFZ2A60DzBEDbIl3tVomDj2rhwG9aD80RLAo264Yx/JWPygCTPpR5vzc1aNJcBK0zCCa0Yzi/eOsCtD9xNZ3FbK0ZObiLQSfQ43Opk2MfypBop0o975TYq4DzLSVEH6z+yHNvn/8rXNOvEy/bBZWe8zYvXiiH5EorEgwgKk9+sfvm7UNwZymaMlnEbb9nTbnOTQHD48fQ7Brc2UXEvLJz0j04jxSl/OBaD/j65yHKhWJ5QkKRzXBwaKW/xYBrtluOJIXfp6qYiZBiSPxLFDTOt2v/tXZeWkOcqddBPsnt+r+gmPGfkWhYt3DLBLtN/WxtwpTxrKc5g0pbfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwSDFqYNjcIHiud8Us6ffNJca+mqArUINNRoT+QU+pM=;
 b=iFbgWHGb2LaDfzuvqm13JMShT9OSDXTqDR072YVIYHc9r8MJ0W/VhqYPsG85J2On+pFJX4iuQ1DRjm4Ptwg+x4EmOVVMgt6AilJjaupKdmnv6XG8Orez5qf27YjBEHBYGZEOQPzCUQzaOJv5Sc5kBUmzRD0i0DRUHUrI7Z9g1tU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:25 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 05/16] net: dsa: make the .flow_dissect tagger callback return void
Date:   Sat, 26 Sep 2020 20:30:57 +0300
Message-Id: <20200926173108.1230014-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:24 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 178fab47-ba49-4584-988d-08d86241fe3d
X-MS-TrafficTypeDiagnostic: VE1PR04MB6640:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6640428EA4539C6BCB952CB6E0370@VE1PR04MB6640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EUz7tgIiubbt14LZg9BUL30MTVMUdLdJW33aeg+fnm442Lr43olrdUmqAanniovtNxpGEk2Tm9qTPFOc9S1vHvsVNmQVVCwaFa9urEZjbJeaI0q9TvBYPqeqxmlaTeDXjPsev1J3hsD6bxLEMRYIwk305ph/OFxL9yZdLuaiOKWmL5UwM4sR6yJUnIKSudZaB3k0Jb2nHWl04rMm0ItJVWvx9QfzL4+ydB2WTpI80bfd3ro/vYXBFQDhyoGn0C/ht8M6fY2JOgoWCA1fXno6j6q8cEil0OF39gUTP1VasDgYSxpiTJwEumuXNPKRBFxfK0VXhnYdaebyuckSRG0xeXFXOSGZSUYTaWmaFPL3fLLjY9q9dVaa/5kE+NVzeyx0ZKi2eDQhulak6eKnl9Njtzp+BQwmZqdh1UojjsG63yFXVMWm0Ot/rs4b8daKFZzotATWvGEwIrirPMtpziezlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(956004)(8936002)(1076003)(6486002)(4326008)(5660300002)(52116002)(26005)(6506007)(66556008)(66476007)(2906002)(8676002)(36756003)(6666004)(44832011)(66946007)(316002)(16526019)(186003)(2616005)(478600001)(83380400001)(86362001)(6512007)(69590400008)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: b2dvezuyaIH0uUrXaSGORh2zvFfnvfAvePtw4wSfPtRAKr5Q1XPB8b99goTaFObksPVJhmqOYiEwy8y7sPFVGYCI7jjxNTP9iQxisMlhlyugZwxJOoUiF/LgxSNXZs5T773eQxirWtSPqOoRIL+TupP51E6sGvqxbBjL/fvsUT1S6dss3bMHxYYTpr8pjL/YLFziT7hcmcy5BQh8arTdNF8sBUD17z0ZYRMXmoJ+wDXQmYwCyZrhZDeTSQ8fjRCoubR1ePUPaoPKM39V7rvTxy2qvKjGBGfLkcq/R5d+UVsNQFxctEh9ygtkAcwRO3agWziExsGOXrJX1mcaafg1kkivSSuo6eqe87LS9yyjhCssB/W7Vm6XhxHww7exOLDSqvkizzaBOGGr+ar6zlG88JWyHnbSaLdF47lXJxb0ddDmiUBT7KyA7+u5NbGw/FrM4GAGbdB1xYePEpd5GuiE0fNoeYXe/YEiNP3wBr90gVJ5i24mFKgc1zsP5nscGlK81ZFsJWFxPWhzBGUcrNPdkhsdhxlv4ma16IZAZSwcudIbvqJtb3AUIRgXTKJgd1xrDmfkaox6C4Otgfv5jHbs0SNDUVg0sORQ2pIraOJzZjloicGA8Q3Qe1gumvdI8w0YhhNS8tGrZyx+sGTovXbdSg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 178fab47-ba49-4584-988d-08d86241fe3d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:25.2749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYWGkEZE/ah79cQHJYx9rPlE4lXUfr9nTwdfk1zRmo2Y6MHlp5E6DF8hNc2f/Si78DFGD9T6Wq2knYEJwUD0NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no tagger that returns anything other than zero, so just change
the return type appropriately.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h         | 4 ++--
 net/core/flow_dissector.c | 4 ++--
 net/dsa/tag_brcm.c        | 5 ++---
 net/dsa/tag_dsa.c         | 5 ++---
 net/dsa/tag_edsa.c        | 5 ++---
 net/dsa/tag_mtk.c         | 6 ++----
 net/dsa/tag_qca.c         | 6 ++----
 net/dsa/tag_rtl4_a.c      | 6 ++----
 8 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 70571b179d05..80f5a388337c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -74,8 +74,8 @@ struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt);
-	int (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
-			    int *offset);
+	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
+			     int *offset);
 	/* Used to determine which traffic should match the DSA filter in
 	 * eth_type_trans, and which, if any, should bypass it and be processed
 	 * as regular on the master net device.
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 29806eb765cf..13cc4c0a8863 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -932,8 +932,8 @@ bool __skb_flow_dissect(const struct net *net,
 			int offset = 0;
 
 			ops = skb->dev->dsa_ptr->tag_ops;
-			if (ops->flow_dissect &&
-			    !ops->flow_dissect(skb, &proto, &offset)) {
+			if (ops->flow_dissect) {
+				ops->flow_dissect(skb, &proto, &offset);
 				hlen -= offset;
 				nhoff += offset;
 			}
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 1dab212a294f..610bc7469667 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -150,8 +150,8 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 	return skb;
 }
 
-static int brcm_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				 int *offset)
+static void brcm_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				  int *offset)
 {
 	/* We have been called on the DSA master network device after
 	 * eth_type_trans() which pulled the Ethernet header already.
@@ -168,7 +168,6 @@ static int brcm_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 	 */
 	*offset = BRCM_TAG_LEN;
 	*proto = ((__be16 *)skb->data)[1];
-	return 0;
 }
 #endif
 
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 7ddec9794477..ef15aee58dfc 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -142,12 +142,11 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int dsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				int *offset)
+static void dsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
 {
 	*offset = 4;
 	*proto = ((__be16 *)skb->data)[1];
-	return 0;
 }
 
 static const struct dsa_device_ops dsa_netdev_ops = {
diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index d6200ff98200..275e7d931b1a 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -192,12 +192,11 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int edsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				 int *offset)
+static void edsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				  int *offset)
 {
 	*offset = 8;
 	*proto = ((__be16 *)skb->data)[3];
-	return 0;
 }
 
 static const struct dsa_device_ops edsa_netdev_ops = {
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index f602fc758d68..2aba17b43e69 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -105,13 +105,11 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int mtk_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				int *offset)
+static void mtk_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
 {
 	*offset = 4;
 	*proto = ((__be16 *)skb->data)[1];
-
-	return 0;
 }
 
 static const struct dsa_device_ops mtk_netdev_ops = {
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 7066f5e697d7..a75c6b20c215 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -89,13 +89,11 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-                                int *offset)
+static void qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
 {
 	*offset = QCA_HDR_LEN;
 	*proto = ((__be16 *)skb->data)[0];
-
-	return 0;
 }
 
 static const struct dsa_device_ops qca_netdev_ops = {
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 7b63010fa87b..868980ba1fcd 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -106,14 +106,12 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
 	return skb;
 }
 
-static int rtl4a_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				  int *offset)
+static void rtl4a_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				   int *offset)
 {
 	*offset = RTL4_A_HDR_LEN;
 	/* Skip past the tag and fetch the encapsulated Ethertype */
 	*proto = ((__be16 *)skb->data)[1];
-
-	return 0;
 }
 
 static const struct dsa_device_ops rtl4a_netdev_ops = {
-- 
2.25.1

