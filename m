Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8A3279B6C
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgIZRb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:58 -0400
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:18948
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729493AbgIZRbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYOfC+SXRmH/tdWewsV+Et0ETYNEMaiVTcGkUjZEhp2y0AFYnyCTWpZ+4hqmtbtrq///uPlg8f5E1naKZkim/I+YcAjdXmavab9p1nNeSTxaa3B49mQUtEGeE7eZk83oLuzIh08PQ5fjkMTgpdLpRZxJ97JRtO2C5Emb1ZfvG2lqL7sCd2KJ9HGtsO3AtiquQYvdiQSSUa8rlB6J6u6zVY016FALHS9vnbjAiRr/biNxWgEZ18k7U/ngRguSvhBm/nQT+KJafGpftIF/Ggpq+yRoUDNne0a2DnfUPDcjHfan2wteTVA+pxvjaz4jCYKnNa0Rfl4ZlifSlAt/GFrfoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NThhHqJ4jvELdagKhfD2g7zLEkNwEXiKeUMBLaUNG48=;
 b=K5iYyrH8his7uDQDDYr4ba9bVXTC6DASPv56zbFm+jGfX7qyEj8avB3rHc8gJEJVfy/B1TyuyOtL1nLd2irVuSueLNPWJoD+3cF+8P93yIO2YbDS32J8tW6eRFVmIIUsG1Vb1PRBQZSd4tzojGjmYcMPzEzIzI+Qxbg8uV9aFd5fAxsN9iQa6kNT0MzU1xDzStGtY03KjnNPEkXu/ORbMxwBBypJBfp2EZj2fdN9LS+pAUIVRXKkfyi9iou39QQ3CbYNmVPJyVPZ3YaeUib0cOShuTrPcyG3qaSvWNxfqlDs/CLhLVxFkFfY3Y4+B7WCTa6EHs4NBK1FsdMldHg3vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NThhHqJ4jvELdagKhfD2g7zLEkNwEXiKeUMBLaUNG48=;
 b=ryWWkJQseezmbNc3bqM7ARVZ3dd7PSlnE1eBSjk8zv59fTS/tLb3KpS3siGfd/g5+L393rijOApjMZ7Tj7JSg4AQAiEfpWr4BfOyd1JOcj7+y3+8nOxdxQYPB0lUMjLFhh4kuWF2Vufh384PnoawV1RyjhZYHlzCGcWr4035Hho=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:35 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 15/16] net: dsa: tag_sja1105: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 20:31:07 +0300
Message-Id: <20200926173108.1230014-16-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:34 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a4899bfd-cfa2-4a4f-cfa2-08d862420445
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB48139C5FE38735AF1C5C5733E0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sNTwHX5QhPf9FvdAbBH/tk9HGTE9aeWGmZ7JdiIeB0piN0RoRteXGDAzT8B9dfu9FmgEcI8qYnScgumshsZAfQQhqNO64PMWq0kXd2uy+6VzM5+Q6IKjUsD7GvErG/K7bG+aeHXi5f2beGDBcnXhAEXXyeEJ29vpfnAD+n/z+/cGjuH0J/qfn5wSVGSdd3Um/cjZdc2QplCu1c7Gpg98Vz/0IWxFP8ykhkayMcFJS7oaPcq9uhwr+K3L9CWxvMw+YH7jywX2fS4D1KaaxDE6SrcBpNcYlsDrmL3fCFEAnuLgNiIxSK1ATRS65omFVX6dP1wF2ya9yxa+BTidD7Q5FYlwGtVqqkxzo8B7jw/ods1ieBj5j8AYJTtxQRb0MaJGH5oGS0rdTAKRsg1OIOIHwjLMwVf3SJVJnLULo4hv/wNTCHdvrVub5rOwjc52sqAuU+HonZQaGfj9Z47tFtPQlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RovK/GS3QmsjmtDnJcls3iT9hT3ZIAqVx3mHcobC+nM8k9woZaHeIfjMi9exdE4h8alMIaDcgVVRbylc9AmwGbnFZrvLpPU0vqDpispZrW9uSXonmMuOdpA24m1glwRGOtywQj+uoopGVna7Yz56hXf0NWxpziLnPov+SLF2+srLhNipkKsLMrRjsYQ3CBNV9ua/u/Iinh14e2ykoFeTj1yjgoCZuzoKygwNJJYLInAQRZoZMgHjfXEB+5bkhtSctWA2OknH/LF4UZmRg1JFZ6V5hcDwQlmHx9+y32uFberP7IZfplQSDlx2mIrI7AYdydqXUvgPn5FR255w6dUP1IA7U85LFJJjsnz4aFHGAH+6MyteTTgvdr9cRE69M0H+GLtnwMCWvvsUCikWQtVyIwR1dkQBeg01k/vIzdNLQ0iBCunLzPsIgmALWjP4Nsxiwb78rxe/4M8Ovt6tIS5QjkMLqgwTT+LesG9vxb0GBULE/3a+3xoJCAkhdzQhgTTh+mQp/URKhBMhlJjEIUBFQ0P20WVSk2muBNvBFGeWp65LpFWhKhMPPC3ChsUmD5OTnF13j+lFLAMYTuro6t8PLAiCRCrjiGjJeGT0dVtvE9O0Yzc+wvaQAYob+DlotsFL3ul+sku3Dwp/HlJw54UYVw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4899bfd-cfa2-4a4f-cfa2-08d862420445
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:35.3951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tG3fo9MUNRX3tfhI7ZBFwsjHX39FzTeR8V6asDub8rNpKYdXlZFEw5odz3rv0eYAB5FijQL2pZDp5SG5THiZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 is a bit of a special snowflake, in that not all frames are
transmitted/received in the same way. L2 link-local frames are received
with the source port/switch ID information put in the destination MAC
address. For the rest, a tag_8021q header is used. So only the latter
frames displace the rest of the headers and need to use the generic flow
dissector procedure.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_sja1105.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 3710f9daa46d..57408bbd789b 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -346,6 +346,16 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 					      is_meta);
 }
 
+static void sja1105_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
+{
+	/* No tag added for management frames, all ok */
+	if (unlikely(sja1105_is_link_local(skb)))
+		return;
+
+	dsa_tag_generic_flow_dissect(skb, proto, offset);
+}
+
 static const struct dsa_device_ops sja1105_netdev_ops = {
 	.name = "sja1105",
 	.proto = DSA_TAG_PROTO_SJA1105,
@@ -353,6 +363,7 @@ static const struct dsa_device_ops sja1105_netdev_ops = {
 	.rcv = sja1105_rcv,
 	.filter = sja1105_filter,
 	.overhead = VLAN_HLEN,
+	.flow_dissect = sja1105_flow_dissect,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.25.1

