Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB543497D
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhJTK6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:58:40 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:17730
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230155AbhJTK6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 06:58:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0CAG2z40f6HmJkcpx+tq3AaBdtvSyiI1z9/eFwCV9G3L0dD8PVqJLCzt3eSgR6tdWZ48Cg/qZGKqykB7pRE1VYepKfbVLKHfJesXcGZdPSPnvVvQbMa/CnQT8x/4vMwhSU3WlCn1jpdw5r6YSKLjSEMbeVcpICism1urxAwFA3s9H/WTnlE6sww61qyTDIYdePKGp6rq8FnM+PUgdKDYQuTZIx+G3biHA6bqoaCrl6IrtbuaSTEA2bE3EppIh9fgYTw334P2wEMYLm25my5lxLTbfPXyT6pQtxM0gbPALOIwwtG40ZDQnJbuEWA6znjoZ6Ymkzo6sqXV5EtJwb0vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lfsufFAoXzalau96lnZbolwHySwUg/rnFYhlP876Mg=;
 b=gVKmWYNJYAQoLbYT17mJ4xOxUUYZzwdree4WbooHp55pea9k1vAbVQ/DW/CLJIyHEjD3++npAZut1xvvoErB5wDqfoj3P/+Lo0m8LPz7N6rVed4aO9N0B0LSXvu5oh4jXO/SDy81wLJZs2XqDiyOCMpvf9o9+rXPQVpvwatlM4H0Zd8HW379un2vZ+IdKCs1URz7DwZbVhZP2BRVwzyEh0roZMsqYxsdi8A3UyvIEMuDQUSzu/jeAXRHlBgDkMGnBFvYZ6iH1/sRw/cVJJRM3Ql6E2vt6TNAyEJ004q40s4frZDGpx/9cgp5/zH4kTbTL34wILjxUwZor/gYu9k5ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lfsufFAoXzalau96lnZbolwHySwUg/rnFYhlP876Mg=;
 b=l+AEgJ1+vngKi1VjtZFh6gcEVg3QJ2KeOMBYR+ufBg1O9CC0WQzUeaZUD9ccdOvX8+oW9/Js7RjZBvMVoWww5c3BAUdWvPd9JMYtQKenjeFa+oMtXg8zYmGZmYDztmTYUp2GvOL1ZvtuL4n1NQQWQWyUwdN443ZGmBODYY0+KDg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6702.eurprd04.prod.outlook.com (2603:10a6:803:123::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 10:56:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:56:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/5] net: mscc: ocelot: add a type definition for REW_TAG_CFG_TAG_CFG
Date:   Wed, 20 Oct 2021 13:55:58 +0300
Message-Id: <20211020105602.770329-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020105602.770329-1-vladimir.oltean@nxp.com>
References: <20211020105602.770329-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0111.eurprd05.prod.outlook.com
 (2603:10a6:207:2::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0111.eurprd05.prod.outlook.com (2603:10a6:207:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 10:56:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58a1dd33-8fd6-4564-82ea-08d993b84164
X-MS-TrafficTypeDiagnostic: VE1PR04MB6702:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB67026675DAE3C14D0B450B2AE0BE9@VE1PR04MB6702.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rz8EJfAlmFiuk8mex9TnKVhDsjQv7LHGbL5keJBegAjJj/oJ3huOnu1UU41DCoElVl+On6QVzV9N7uBKdiF6v/Vd9eLGITIeqcprcBur9JshbOzzE/Pbf0Cod6o2y9e3FQUu2M1tANKyYGFtNEeLXYYe3aRcQbOU4yQMYHRKqtdMDb/6U0q1clO5nC57bFlyBDiAN43A69JFWTZn+7VLGLeNA5XXgKxbUmDaXQWClAtscGJajIAUFbpRSAdpkJ1zyrMVLf/HAqQdfjAZeo9L3aId8CyCGCvKriVBDSH9K5MmzcmgJZ8XRcVY6+lXCE1E1g+F9kBA3Sr+Z4wVX0AsgIPQ1gtsqbIXZjQK2ERNnDdk6CPqmfYMK7aS6QI0/u78itWmi1ycXTVEApNlwVi035naghYmdrayLZ6eW/JpPtyGOoqiSzVJDk6IK885D+82RIrC+pOFmLt3ew16U0HNlWbvyA1+AUZmvkKj0KLUw/4rgd6rM2XvDrJ+FsdOzIwNRW6T4ub+p3O+ftDe3Sho3QBUqhHnnyyA0Z0IZ2hs2X58epjtGKYYX11EW7NZuSflMdL9b3WPfZ3iGhKFiYMSUTANGcjg4v8pZvUi8DDHRNxwujcwQZQPMZOfHYPtdsf3fFA9PbHOZe/kIke67N7h+J+YyFLiZPXODiAnx+9kj8oWUknlHSJ8qI/50g3DgyjPq0mvaWLzeeqCoFMiPbVmgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(5660300002)(8676002)(1076003)(26005)(38100700002)(52116002)(83380400001)(54906003)(316002)(86362001)(4326008)(186003)(8936002)(66946007)(6666004)(6636002)(66476007)(110136005)(508600001)(44832011)(2906002)(956004)(66556008)(6506007)(2616005)(38350700002)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7DGvQfCa31tdvzNjciVYSGPTbIkVpQoVP6eB/wp2wfKjXs5eAw36fy0WejWz?=
 =?us-ascii?Q?CVH6oItzXLdtnzQKCnb8LOnBhtT48mTN5qIz3MRzKlgIGlEGc6KWX4MZFQFp?=
 =?us-ascii?Q?o9Oovn+nuQEHpn6Yrc5NUJ5ASEZX9nIfSA4dnJjiqah3EFvjXw9AJ0ZYs2m7?=
 =?us-ascii?Q?2EyXQSO38cnDA7ls/kWhXNXkQGYsnGXddsXeslqA8zU1dSzXu+/tpMFhNXIB?=
 =?us-ascii?Q?r2cxFKXqmLwvyAQYJFgd9V2OJjRObqW6J4p2GehoECDFT4W5A8vt6MlAOO2H?=
 =?us-ascii?Q?C0UlvGmvE7MvXWMFbbV7K5E+v4Clu5OLhw9U+f8+G3/TJZjTg3HToz2Qgtmr?=
 =?us-ascii?Q?B/ZS6ODna9KqEIfZ3At3eGNU3ElhFF+HVz5ieHHo1eTLHhhd+v5B1YFAU3sM?=
 =?us-ascii?Q?AuHB7IGi1Q6trRtQA1SlxHFoyzwEcJVHqj1YmPY4Om2emzCVjo09fmPmU4Ov?=
 =?us-ascii?Q?smtYIHn/w97CNZVbD5bas+AOc1KNhG2vjzXfmnWQQ1IdNg553hwl9FqHVBeF?=
 =?us-ascii?Q?44ZYt9wPbAHVhdeg1ZdXelLvO+XrwVRdB4pMQ6HlSvuMZS8c25mRvjJgX1Pd?=
 =?us-ascii?Q?MO6wivwe4b9w6soV0GmcYDEPxTRmk3x4lkJGQ99GcdSTfcZ3jKvnwOGi5Y+m?=
 =?us-ascii?Q?tDI4Ppa1/VLlvypan/0z3nkFXcksSRmy87fd0uGtU96GJbJ0IDEVmd2Vlqui?=
 =?us-ascii?Q?XLzMarvGyXHvkq2MkC5vmOiNGYuUlqb7KCWVjzMdYC1ikPFNjJUNJ1U7gkj9?=
 =?us-ascii?Q?kA+KKWgqIULffksrDPHaK7RExD01wilx0NyrlqEJIOfGPkjZ1cvg9aoQzEdF?=
 =?us-ascii?Q?iAHzhRJkGhmz/VB1Sv+NPOrrh5z5eP22SDJLXj1koTb3jgXDPMySIxcyBszG?=
 =?us-ascii?Q?BEIAjlDV3k+5cYKkD8coraY3O82zYzCLQaUgekLrQs331t6a2W3UlmOg1VOB?=
 =?us-ascii?Q?BJRLXj/0Ar9mCbUOj8PAXQ3gikwppTM0ZBLUlauACsyOu0dMK1eF5+6poLHk?=
 =?us-ascii?Q?GpGHSQHHDANRPcwaWesRj+/hNFqbTxE6nBlIrF/EUnmZ1JjSXiNtvbHB8Mxu?=
 =?us-ascii?Q?/fq9jxh0glhtpAd5nLWQMkqQXMSTCqTCgI9BWismz+orMvzcLlGGK6aaR4Wr?=
 =?us-ascii?Q?X3C9VPdT9Yhtc9DbBPmosrvzBD7t6jX/kfIgp/ARp/4NG30NZsFyGznGqoFM?=
 =?us-ascii?Q?TFoI6SwEzqwcOEi4PefU4u6/mNC3e4Bf/4aRgI0MnRbz6tP5K2NSpWMVuPju?=
 =?us-ascii?Q?OhuNjj0YynVgu00BNo+oQLaALcfL+/+urvwr5kAM3twvD1dWSJoTyylTKoLj?=
 =?us-ascii?Q?dF7e9gW3u0jOxnQ0h7U5Hdqq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a1dd33-8fd6-4564-82ea-08d993b84164
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:56:23.1956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B7YHTjDL/IlXQrQPuh7eeXIznsVnV+C80XX1k4dwLuk/O0Zcbri5tHbM0g5/FD+D+M9CZ6j4K/N7qU78Ml2EbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6702
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic patch which clarifies what are the port tagging
options for Ocelot switches.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 13 +++++--------
 include/soc/mscc/ocelot.h          | 11 +++++++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 520a75b57866..b09929970273 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -166,7 +166,7 @@ static void ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 					struct ocelot_vlan native_vlan)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	u32 val = 0;
+	enum ocelot_port_tag_config tag_cfg;
 
 	ocelot_port->native_vlan = native_vlan;
 
@@ -176,16 +176,13 @@ static void ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 
 	if (ocelot_port->vlan_aware) {
 		if (native_vlan.valid)
-			/* Tag all frames except when VID == DEFAULT_VLAN */
-			val = REW_TAG_CFG_TAG_CFG(1);
+			tag_cfg = OCELOT_PORT_TAG_NATIVE;
 		else
-			/* Tag all frames */
-			val = REW_TAG_CFG_TAG_CFG(3);
+			tag_cfg = OCELOT_PORT_TAG_TRUNK;
 	} else {
-		/* Port tagging disabled. */
-		val = REW_TAG_CFG_TAG_CFG(0);
+		tag_cfg = OCELOT_PORT_TAG_DISABLED;
 	}
-	ocelot_rmw_gix(ocelot, val,
+	ocelot_rmw_gix(ocelot, REW_TAG_CFG_TAG_CFG(tag_cfg),
 		       REW_TAG_CFG_TAG_CFG_M,
 		       REW_TAG_CFG, port);
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d7055b41982d..0568b25c8659 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -568,6 +568,17 @@ struct ocelot_vlan {
 	u16 vid;
 };
 
+enum ocelot_port_tag_config {
+	/* all VLANs are egress-untagged */
+	OCELOT_PORT_TAG_DISABLED = 0,
+	/* all VLANs except the native VLAN and VID 0 are egress-tagged */
+	OCELOT_PORT_TAG_NATIVE = 1,
+	/* all VLANs except VID 0 are egress-tagged */
+	OCELOT_PORT_TAG_TRUNK_NO_VID0 = 2,
+	/* all VLANs are egress-tagged */
+	OCELOT_PORT_TAG_TRUNK = 3,
+};
+
 enum ocelot_sb {
 	OCELOT_SB_BUF,
 	OCELOT_SB_REF,
-- 
2.25.1

