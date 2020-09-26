Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591D5279B63
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgIZRbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:33 -0400
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:18948
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729412AbgIZRbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZaWU+BK1PSl3Io23sqwj0SKIkEFYkZGER3YiACafPg8pumKPOU+qrJtUHQgAZ/XnZm7dBKGpkp3dIT++forDHST7F+d+FHbxERAEoabh53U6zrzIT+FAa6GyHt1/kd8KkD3iY61sy0VNhMZx1mkClXA011aYd5MwDgcrZF9rEsAQGwj2Zc1xMkYYtOC8JcXljnzME5RPhYWRQdXx6GqnoCbY7Exki9H/s86fAHt6DzxQS+Obx/XDhpMVdpzBUOdphA8fqXzwCSnvSaVNstEkx/jDMQMuu4tQMR3uOpU+Ufnmud/2i5BEtV9d//2MZZpiYPHuk5ZkHJuDAcqXCCwEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aN8rHFXz6ElyD9GdMYjuJo8YIJudH4T6Zp6WxH11Ngs=;
 b=fbpMbjFZBNaYvqpWiqEE5RSfmpKeJgMfJZQRkIw78U4r9v+88QR/ndmGzzHQBKPA/TvXnOm+U0J0egTBgmBCyUM5tDBvcn0CCPkCOESLdjEPqxHDF8Vy65nV8YATjTFhypxAfXPgvwH5eMSAQ4xbpPvAMWxQ1bqR5u4Rq+tAxXm5huMBFA0TwwpdgIqrLzeiIWrqvYx2KYev/vTBRZft9B/1OwIQwKMeOCoT7dPTlD13Jzn532dPozos1wcBBCh/Fm6nO6VFE9v0QyI739ZvmvmRnddtmMqGrxeX6uQC1yBIAN4gqXBXwd+5n0kzlZES6ggfqDPyDf65P09yIF8+sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aN8rHFXz6ElyD9GdMYjuJo8YIJudH4T6Zp6WxH11Ngs=;
 b=jAha6KCLzfSMg6ZyVXZ3+Coblu1KnOL7EB/2sMJ9AxeuZvYUeDLUx3tlUwvGKitdTv6Kw71njSchMFjJV8aMBHaUcmOQP4yVfNb1TE38m6S4TAlTwj3+m8GpSX1jT74vsRdJr5n97irf8tL79Sh8QWenMXBI+78mA+yQ/m0iEFY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:28 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 08/16] net: dsa: tag_brcm: use generic flow dissector procedure
Date:   Sat, 26 Sep 2020 20:31:00 +0300
Message-Id: <20200926173108.1230014-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:27 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fdd2e5d8-b911-446b-6e4d-08d862420015
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB48136DDC5001CEF4EF9DFB0BE0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G2KBnkz2K3ih3PWw/XU2kw/rhi7raq33zK4ZAa/3YSTtFHC7Ey07XRxsreJjMo/acMhKqjcT7zsoReHS6YN0sVloXmrt6kpgfO47mgnRerLMt5JfaK4OBj2eelZkVWX8wFkVbqjmcSkBNOkcYpc0+y7zNhNznBEH+R80KmoutGbv82AGbksjASbUV9KxCJp5IJCe+ez9BopSrvjkqA7tlvgPvB1gKHSJ4TOlE8gTp9i06BoVZqfJLxL77jp+8JI6GIEq0UzzIt/jaqkVRUVSZmXdAsaGLGjGYsyDm5/7u+tJos2cz4GwfKvWhs6aqR9sT3Oo4tHaIRh8eJfwZJh4Rf6WbaF5JKg2mjSqXCoNHNx+5ivI+wJeCHqGqVMKywmpO4sBBHmDOLhhpx72NrDJWvJXngpK2A1N4WcUxAsbDNqmP9628YDtR2Mi6Q6xx43nka1E9LlPZOSCht9FaSULxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(83380400001)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jjlKHF0m+BRaPYASgyg7qMmYumnLPZeqZ2rChpp1pMIFD5VMiTQVUmFLadPMPwQSd69bqDqN7cwwdZX4mDOcr7iXlSOaso4M2RgrAgP8cuEqPIVTBCEV1ZbFyI+x8u5hDcfey9kg41a6hkotWbmdF7VJiBm2jX6aPdtwc02UjeqfDPP+JXB+YPSXsbyH+OLH4bLWlr+jkf/YkgUpSnBAkN19FD+yOg8Fso5qsjUcxPml65GtAxzllKtf/xv/QbEsgdtxIR4RkJAb48ThsAJL3NgUmntVaPnmYDP8PfbCYlmWWtfV3JgMFmB/ieznh0uknEQRafdyw4Z5zs2XHl2ZsrPvRtYYsKTN58mN3bqoVlxMJv69/ClfwVzSvzCgXkPbZWO7KzDj5Hcrh5l3F4IW7hcwn802JiTxWmW08qLMDOvaKW9BfNEZcswUPfSfnS7gK+CpJPx1mjGgxiognP3l61C1Wd46ql3/o0NjC5AjmmfWjwmpEouRMYEQYWjA+vtdrMVIFmcK/kysMJ1muTRTTaL6XLNfSRxk3sPHTev2Go0u7iYfHEGthBzx01ChR+9Lxm+LECHCK6pvsp4T5V8odTc1NXDEtEuvmnes4wWEj+GVzgdPKYiA+Gx351jhaxL0LGQY6IjX1pNxdHfchK9jPg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd2e5d8-b911-446b-6e4d-08d862420015
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:28.3762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1kTdWlU61OB+QV2dCIfESUCWJpA9J9+2oIod2L2LugAGdJaVYUz+ypqNxB8cBAVU0rwQ6cTJPT785TtyVcfDCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 Broadcom tags in use, one places the DSA tag before the
Ethernet destination MAC address, and the other before the EtherType.
Nonetheless, both displace the rest of the headers, so this tagger can
use the generic flow dissector procedure which accounts for that.

The ASCII art drawing is a good reference though, so keep it but move it
somewhere else.

Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_brcm.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 610bc7469667..880736e39d3a 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -107,6 +107,18 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	return skb;
 }
 
+/* Frames with this tag have one of these two layouts:
+ * -----------------------------------
+ * | MAC DA | MAC SA | 4b tag | Type | DSA_TAG_PROTO_BRCM
+ * -----------------------------------
+ * -----------------------------------
+ * | 4b tag | MAC DA | MAC SA | Type | DSA_TAG_PROTO_BRCM_PREPEND
+ * -----------------------------------
+ * In both cases, at receive time, skb->data points 2 bytes before the actual
+ * Ethernet type field and we have an offset of 4bytes between where skb->data
+ * and where the payload starts. So the same low-level receive function can be
+ * used.
+ */
 static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 				       struct net_device *dev,
 				       struct packet_type *pt,
@@ -149,26 +161,6 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 
 	return skb;
 }
-
-static void brcm_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				  int *offset)
-{
-	/* We have been called on the DSA master network device after
-	 * eth_type_trans() which pulled the Ethernet header already.
-	 * Frames have one of these two layouts:
-	 * -----------------------------------
-	 * | MAC DA | MAC SA | 4b tag | Type | DSA_TAG_PROTO_BRCM
-	 * -----------------------------------
-	 * -----------------------------------
-	 * | 4b tag | MAC DA | MAC SA | Type | DSA_TAG_PROTO_BRCM_PREPEND
-	 * -----------------------------------
-	 * skb->data points 2 bytes before the actual Ethernet type field and
-	 * we have an offset of 4bytes between where skb->data and where the
-	 * payload starts.
-	 */
-	*offset = BRCM_TAG_LEN;
-	*proto = ((__be16 *)skb->data)[1];
-}
 #endif
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
@@ -204,7 +196,7 @@ static const struct dsa_device_ops brcm_netdev_ops = {
 	.xmit	= brcm_tag_xmit,
 	.rcv	= brcm_tag_rcv,
 	.overhead = BRCM_TAG_LEN,
-	.flow_dissect = brcm_tag_flow_dissect,
+	.flow_dissect = dsa_tag_generic_flow_dissect,
 };
 
 DSA_TAG_DRIVER(brcm_netdev_ops);
@@ -239,7 +231,7 @@ static const struct dsa_device_ops brcm_prepend_netdev_ops = {
 	.xmit	= brcm_tag_xmit_prepend,
 	.rcv	= brcm_tag_rcv_prepend,
 	.overhead = BRCM_TAG_LEN,
-	.flow_dissect = brcm_tag_flow_dissect,
+	.flow_dissect = dsa_tag_generic_flow_dissect,
 };
 
 DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
-- 
2.25.1

