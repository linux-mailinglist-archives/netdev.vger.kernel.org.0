Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9482B279C34
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbgIZTfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:35:51 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:60485
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730206AbgIZTfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:35:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ana8TwtYReLGVO4GWduBB/j7ujCnLVqoDKD1hgReSU9tAX2mtfJPNv0WyypYd3nZ37yNkcfh9WcHVZQ4nsYe1XjNcNMw0rD2dPtV75UiD2ysipD4gSWcmt9DjbyXPTJPTU1mlMsPpPPRmZeF8NbKbKAk/ZCKGrnYw5Xbra2rfUCk4rqs8HjhKWwJOnohPHnmGuk8GAND8+f2NxJiHzqgs2iZBTSB9yl6C1j6hNurqybTgGgB6s2phBwsa8eXuKvWh3OL2kOYTzhk9avEB5yX43Hfc9J6KIK+wV506eopIna8mZV7UPh20LaGOC7rM9GpE/4gk0srESsAc8cj1WReQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0wkL6bDF/Rk9FBB6X+WlGO0nWHao7GJp8DO189Kn9E=;
 b=OFYZL5/kklrlAudTHiuEq45yhVdTHxOWDqpiCESrxGxlSPcvR5zHcIBReeiRgyu/c0htUZEK3ostaTELYwzDXgoHhHpI45eBhXsQcPNVrmpHTqnai/vrm+Y9e4KJjv7zzu1ZbzHjBPy/+Eyy9nN8DvvbyPZ2wFKiFAjpQmOmuqWlDprn8uhUiUCuIjP2hEDtgCFVIiUQgWOMsaDaF/f9fmqDboxnRYG2XWOhgxCmohX+UIfG5yFlz5ZUF/OKrWe9ZkBQs/JQahlP8I8KYK8dfezPCIctEWtFQ7MRXnDIYMT2aCy4c772iKQSGK+xfqiHZm47PhUkUdOgAUxjuFmLyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0wkL6bDF/Rk9FBB6X+WlGO0nWHao7GJp8DO189Kn9E=;
 b=R1vySWxtJDDaEsm3Uu3UQpw9ubGGa3ExKPCOJM/3/6h7ak0MbVtVz+s6arm9mgNgjaXi5oOrV+hQ8ZW6ra1mVM8rNFPcxbUdV+sImwj5h6GVg2M4O1KzuaAxpWApsgvWKleAuY2I1YogX/pKjliD4P+rpCXD6wZ0OnBQVsd+m80=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:03 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 05/15] net: dsa: make the .flow_dissect tagger callback return void
Date:   Sat, 26 Sep 2020 22:32:05 +0300
Message-Id: <20200926193215.1405730-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:02 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6e6be947-e701-4ec6-e34b-08d86252fc2b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295CE6B56EC56F1D136FAC2E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E2qoej3jNDl5G2UIMm/6a1rhQb2NRJPng9AuycZbcCPv7hYIz/vuvuIQpwe21LsEFTHfExzp+c6OMkBUo2G84ONUZmxTVPJlA1PL0Fj7rUeL+pJmuRwAWySaFWiWf07FMhyYPViTDHQaA2mTkrXPL92LcqzoTXUfXjT6hgAzNdej33p4g0A//zzmYD98cG2ShSbNAqmOYV5WPWos1cN/v6cjKaI2GSTzTojaKH3P4R3yc0/2qtxhDeEaTmrH/azAYl1FDPlPMo8HZtUXsDoonz1KhVrHfZOAopou1/Rq4u+WsUdGT/ZDKDKVbc1V5BaKnWVXPEOcJCN5qx7EfQk9iFp5YKUynP7PAT2A1lQB5xV5c+oR6cI49U7kUJHgBvMy8JlINbD5pLhUhxgW8u49QNeX3CaL3lNx5xqHvCiO3hALoXXcrV2rfcPP7Znr0NTGCYU1FM5v9OVJUmx+mPRXLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(4326008)(69590400008)(66946007)(316002)(5660300002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OKUSUbnqtyTv3J3eNPY/CF40wz5e3p9tq/uzzqnAmFX1x21MxDCyhLa2IRo1m1wqWSiDTiAUU0lRVZWZuTPKxr7p+z4uCBsgnOsq7A2vSsGBmA/K2qZyzl8CZOkmUJ7fXKfeNDwfJ3T0V9h1t6giGryfaxspmixccmVdkm2cOshHfcINNZGeaqrF4XUuWYUVY3rttN4/xZgH1MiazF/tJrv0gDboTY9pktqCnRgRQ1Orkfp9V7Gw6MZbVWpXBZf1c5cZNpyQEVShw/EeseBrGwbcbgeq31O6Yl5dfMG0LKMqXb0Rrv+qnCA2ST5F0nYQvwQ1Z8tcVDcMUeMA7PFMx0qNtWcP6aZXG1j8pQ57RnTVdQlN9QIyfLI70sSYEYxEG6MDJvF9S9MC8wfKVN00CkZ8+3MA2Cixyj9V/Z4Q+zsf2ATDZQE3Rc+ZLOyIjbbNbjOFXMuf39mJzgrkeU4RcoMcct4qACNEGBBLCKkRADP9EJZSYnAfEXKAa0GIDOagTNgKDfQsHOGOkStiQohgxHGQXr4HnhYsEli1STtKVivPs8Nh/1W/RtYWcDJtR6/Oo7xEPfrLiGeZLgUGvj0qyisLf5ZBQ7SEwSsFdjqShiDYNalvSm3viWbdhAziNXwmFWKgwmZZRa7i0f3C5Yuw7w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e6be947-e701-4ec6-e34b-08d86252fc2b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:03.2399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQtr509Fua3xByxb2TONvk8W0LuPDvRubKwKt/N7/JszIlM5l4GFYiFGToju+Xuo5pew+fP3o/PC8f8SK4D4xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no tagger that returns anything other than zero, so just change
the return type appropriately.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v3:
None.

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
index 46019edc32cb..98d339311898 100644
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

