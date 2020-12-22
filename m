Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACAF2E0372
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgLVAee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 19:34:34 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:61509
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725780AbgLVAed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 19:34:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gxc2vA38Pq+o6lpfGVLocQLscYihFS8I1REk6h7WYszSA7OzEqpNRSGR+HiYTWG3wmrWIDJ9zmmmBeokANmWx4DLFcRJuNSVrIniVqsFJbsss6DhTbC3OSkBbibN8JU+JKSmoNMaN4ZtxcJQmxvvgHUFGVANV6MstdMypBavMIPECsmEO7TS3b1UPfKGnymdTUEZ4VWJmwMuzm40reQQnt7VhWP5dTgN0r7Phm+J05AilaLE4sDi66GGXYa5Oa5fXhiavS0JJKq0nq//kmQHGysHIxAEx35ei60oOPYnyjrBkHl8zLK4WR1sFDdaxTsD3QEzYNM/4B8LIjE3qBXcqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVED9lN0KtZuRuYOM4CMf8sNaIHB9IQrRBW7KF7mAwA=;
 b=PCmTuT6Ca0no+u/ctgKF9TE1dTHYtyfxFKNzsxCrhY5Uj4ZnDLMmOPa7GPVW3mIfcG7EFmThIMNNIjQ2W2Q1e8wPckChmqiAkU3nvzMFRLaAvAP9axUhciVYkX2hrp0c8sat/3y+9XeZ10E9SKzLb+eZcZVTU1935E8vu5A61I7W+2/So01qmlC4lvAdY8LXwpDt8MlWaIpui8IMrbdrQVQxEcHoSyxnv169qmrBM5hycMXbTmKrJiF06i/TzBbSGRJYRs3xSSasWqhs5KaNuyOpDH2lKhYzccaMAzBzPNlzPpysPBBKUTZ710914O11FOC4cWB633VTYKo8Dh8QLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVED9lN0KtZuRuYOM4CMf8sNaIHB9IQrRBW7KF7mAwA=;
 b=LoLY/cb6IwI3hDN8lwBisBoHXNzyvS6a91HHGhJuYSoHqzdEh0tyQlwMJA1iNiqmA5uB2KX3Ds0n+hhcfMzl0xaBFcDUa68Dl96l8uOeGZ76BLJyBjqqQdPujfBnNmdlmn77b45tN1md2pNm5HGYELTYRrd6ghDfAKMi4YTzKTs=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Tue, 22 Dec
 2020 00:33:13 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 00:33:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 1/2] net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or TX VLAN
Date:   Tue, 22 Dec 2020 02:31:11 +0200
Message-Id: <20201222003112.1990768-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222003112.1990768-1-vladimir.oltean@nxp.com>
References: <20201222003112.1990768-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM3PR07CA0076.eurprd07.prod.outlook.com
 (2603:10a6:207:4::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM3PR07CA0076.eurprd07.prod.outlook.com (2603:10a6:207:4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.24 via Frontend Transport; Tue, 22 Dec 2020 00:33:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 53c24a13-b380-4a2b-e7c1-08d8a6112ae1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3712:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3712BC035C71AC965EFFD0F8E0DF0@VI1PR0402MB3712.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RUbs2UDtZnQPgFQzTcLlHr/ByPCQMQePHljujiY0DZl7enBAUiITSIZ4bIvwNPbr1bj/g+xUXawZlqu5fnq0xsFk1WP7AMNzu2ZAWmJG3KzYArA5SciXGgbcyCbYogfTDAX+fjh00452UzbYCVobGbcDHm0UhI8GUi8TvfevolPn48X1ef4JzHhTyX2hyGy1MCGD7jhAE9JqbSDCRPs22LKy/NM7OxuFjqRdTQE3HGf/qo9c+uJD+Hj7A/L8dhrOOgiuGbmH2MHfP/MfQaRHSKrJS7psgcyPFny4MTNe3Hpnk+FSEfEd37KCxtrLSNmqevNu5S8vw3fAcwUMMqPSox8UDaSHNrRyXWuQEAzmnVAantXrFXiES3IOeWsjDm3BTYcU0P1Jt2RXgut3Rvc9vcZAPvIrzLDj7oVt+uM8kBHasyOfySXTRHU9xhH3AJ6EragJpVI2RQETBudEw7T6mA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(69590400010)(5660300002)(36756003)(86362001)(2616005)(4326008)(956004)(44832011)(8936002)(8676002)(66476007)(66946007)(6506007)(478600001)(6512007)(66556008)(186003)(6486002)(54906003)(110136005)(26005)(16526019)(316002)(52116002)(83380400001)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tSO5FF2thmfrNC0cyosGhFyDslA/NftBQ9T614iCzjJyMbzeIuG57LUNCxiv?=
 =?us-ascii?Q?xoHXfOo+l5r/vHek81b0C4aUUewzXZKIR/dyoaxzuYtwLW4Nk0WxbOU3IegG?=
 =?us-ascii?Q?JxX1jIpfpGH71IEt1qC0CjdQV2Idb69JzOeYHkxzkEIRFoZ02T7pcJMqsbaB?=
 =?us-ascii?Q?7VyYEFtli2DrAw5/dBBXQpHh9/osEBTKktnl+snLyoNP7AJwrRV09jtQY7G/?=
 =?us-ascii?Q?Bj5k49iXjn7V+L3+PbJgvmad2nI4F78YTKdd6+KLsLzxs1DJoqvQ91YKEa2P?=
 =?us-ascii?Q?8OE8B/oXVKWQUI8tFyBQABd71dCnx9kmlYcPpmFMGN43yqJ3P4WR6C6HFgvI?=
 =?us-ascii?Q?wDOxTOUujmwYyKsgHIO1YTILb+ow5V0uyIMQNRSaNy+HOyseaP7vXW+kTBHA?=
 =?us-ascii?Q?uOKRCkEBG7UVDSyWNqFI9ZF8MCKNwhHDUh3TMpg0LWQXgJOKk9kG7c8cm6kE?=
 =?us-ascii?Q?Xm52XlZUGzsPnTWMeR2V8g0DR1M0NYputYwsugKcKjgD4iswIQRNn7VMAVQE?=
 =?us-ascii?Q?74Rz5pBn3l4mZ8jZmEME/gT/16XQsK+tpGdTNOy2jFGxW3P6gVtv76mcirNY?=
 =?us-ascii?Q?hIwyIQi4BzM1ychEFK36BMK9w2nilV2BqUbjW879kvduXaLr7RCF8K3BlSSg?=
 =?us-ascii?Q?EInoJ9DKs80lByM6L7jhu2cVICQCYKXqjzd0ZAD3bp4V4csiL7KD+Q7/CFOj?=
 =?us-ascii?Q?JbIgduWckQqIKa5UCVMc5PHUh8BKZ2cxTN6fRO/q9q8IwTJcI2eTDEnmc6R7?=
 =?us-ascii?Q?SNsNb4a0B8CPjz9ij290jdBTE52nZAlIlSvc+9/kd6vmi6DRKgIjRDf99ZYh?=
 =?us-ascii?Q?TeP50GKkqbW7IIk06ZJjE7ggwLuD6tkkW30EahpLY6MfY8L2mwWoLysaRZYG?=
 =?us-ascii?Q?MIbeSv3uAEZEItB7d705CnCyYC6LLiVffKUqel8JxGCDg9+6Qd0iG2sHoMma?=
 =?us-ascii?Q?lgkUMqITxg2fYNyUeRtwL1mQNH+CtJZUvGSS7RSDlmdS7eKy2dEjgBT2DbkL?=
 =?us-ascii?Q?ETgD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 00:33:13.5658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c24a13-b380-4a2b-e7c1-08d8a6112ae1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CxMcALJK4MtfMPErL9ULRKGKh6FSKKfzH8TCBBKj7l1uIBUn4Oz4wdmXN9sx7wKI+p8PFZ06XMY4pY2UrMUG+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 implementation can be blind about this, but the felix driver
doesn't do exactly what it's being told, so it needs to know whether it
is a TX or an RX VLAN, so it can install the appropriate type of TCAM
rule.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h | 14 ++++++++++++++
 net/dsa/tag_8021q.c       | 15 +++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 88cd72dfa4e0..b12b05f1c8b4 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -64,6 +64,10 @@ int dsa_8021q_rx_source_port(u16 vid);
 
 u16 dsa_8021q_rx_subvlan(u16 vid);
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid);
+
+bool vid_is_dsa_8021q_txvlan(u16 vid);
+
 bool vid_is_dsa_8021q(u16 vid);
 
 #else
@@ -123,6 +127,16 @@ u16 dsa_8021q_rx_subvlan(u16 vid)
 	return 0;
 }
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid)
+{
+	return false;
+}
+
+bool vid_is_dsa_8021q_txvlan(u16 vid)
+{
+	return false;
+}
+
 bool vid_is_dsa_8021q(u16 vid)
 {
 	return false;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8e3e8a5b8559..008c1ec6e20c 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -133,10 +133,21 @@ u16 dsa_8021q_rx_subvlan(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_subvlan);
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid)
+{
+	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX;
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_rxvlan);
+
+bool vid_is_dsa_8021q_txvlan(u16 vid)
+{
+	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX;
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_txvlan);
+
 bool vid_is_dsa_8021q(u16 vid)
 {
-	return ((vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX ||
-		(vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX);
+	return vid_is_dsa_8021q_rxvlan(vid) || vid_is_dsa_8021q_txvlan(vid);
 }
 EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
 
-- 
2.25.1

