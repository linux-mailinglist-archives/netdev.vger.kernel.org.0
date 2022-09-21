Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24F35C002C
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 16:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiIUOoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 10:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiIUOoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 10:44:06 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150080.outbound.protection.outlook.com [40.107.15.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0F29750F;
        Wed, 21 Sep 2022 07:44:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYjOedMI1jTQah/U3yTzLentxswByFqtxEqMjtcWZ/EKGSwqEUkVHN4aj2E/6Svvf1bIk8QSNyVEMhqg8kMiMNk8IAuHcTzXHucFJqUaWdw2G+LBvBq1dmAemzH8ILlxdAbuNa9lKxVP5iuvjKHsEe8QH8uKvMzGyK17rlRWG8bsue65lMqq9HMg6nWlDzExiNjQ8iZ2aXj+c68qWaDVSOh+V8gro5Qacn6GRcy/QlZ4X9Xw3n1s3rtM426djkLZlA7cMh5XhjkVgOTiiGdCapl3EUNR54ShDei/s6VZjSDrhx9Mn32tCX2CWGALI4f4FtGhhA0JVlk9s9/96EYqUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQuMc2h0jaBDVHC7d355Nam85t05IScwR13A7awbt1o=;
 b=msZVGU41G9+PLYQn08/UgE0RzDWXTorXWJ96/1jmdryuSqWAuamXEn/Ss7KIi6JrHXCY8+g5g2Bd8/izzyqlTYpZ7HYYV7k7ovnFjuE88P5TBCjzeZ6oq4gqGWZ46xJeyyUU6Vj/5CmpOdeRgMmjXLyxhsBn7fG8vl6J+rb4U0qI6CoaWGrnW5rpAWgA4HW/KhGZRwig5JuGXgztmKmzo91uA4AZmjL7IhsAlTo0IWfHbPX8FzcFxwfTr3CCThJyVNbdLIxQYkrE9e8ou84W8psFFnU4EbmNdpI+K8FKPLXQb7spWrSM31t4YOdILCg9tA7d0gAcY8btj+6h17Qkhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQuMc2h0jaBDVHC7d355Nam85t05IScwR13A7awbt1o=;
 b=TEuBFlvTQAaiQyka1csWXPYgM7h8cU0PclTKJ21K9xiOZWuRDNPlVQuacMx9obMVRiLGgY25RJwSaT7j0WEHNNReX/YLlvn7YJ+KYTAeQesl63Fk/O5GM5L7+/IiAl9vPC+sf4MFYcVBbYn2O4+Vu17Ilu0HtTAuS7pvHlYWSto=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8661.eurprd04.prod.outlook.com (2603:10a6:10:2dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 14:44:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 14:44:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: enetc: use common naming scheme for PTGCR and PTGCAPR registers
Date:   Wed, 21 Sep 2022 17:43:49 +0300
Message-Id: <20220921144349.1529150-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220921144349.1529150-1-vladimir.oltean@nxp.com>
References: <20220921144349.1529150-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8661:EE_
X-MS-Office365-Filtering-Correlation-Id: a3171bb7-3910-42c9-959e-08da9bdfb927
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FGt5/7a8b3UnMezLKC2GT5TW0ykye+5T645FMv4FZjxEAEUHmXicBcBt5oUy0YBooy/3nynd3PX0xkySorUxqZCNrHNoU0mSbjbV/8GWrEi53NhYeZrYdUR6+2Pi1bx8aHPNSqBwGmoYlV7PEVWdaMRuP+Qu7LmkOI95JRawBhTf9lKNNLhT+Oog4Cx1NMvxVdtT1m03RnsLiPdK2P2jOZqTdkXURsl25s7CoVCaRTLA0eOLjhr/g+QRycCwhBHKnSrK1K+fKlxpylJqY1xVORU9HT8blzGoN75z4xeEZgeyLN9qCtfBLdolWmOBpFga2srEfjLKpME3booIKM0iGSY7EwusOjIHI6d6ghH7lRZO9KdH5ESAanp2CP4TfJ4ofJtGMztW8YSs5IWX19jIj2chVtAExgrGii1HHOhewZH+DK2Ok9GF/JWiwIcxm+BIKlQAc/DCs6JCdosQQsWzplXbYpfPacYGqxs8ZRDkykGgHZeOuLlvF/NsPakZiY/njlLzRkC4g8jCHJJMKmAlehPbrNRzmx4Jd03Ke4UxrZuetFH3enhmOui+63rcI2SXvLh1zrNpiyHlqw9NNaMGQgFMjpH3treh+1tIYmvVHUGfy55EBY7klMG6vt70DFWnyAAgkeZFLGOnM+GN/fi7yBYBxfB2HGFOfIAEuGfmTa4EqCmafYqySm7tLK7Ytz4GbHZkOixwrp/VK/HktVkRbim8EEwwHyWxeraieYYcyq0Rbdu3dOON6O4wgfOmF82fPsEVCPOTcGzN4MRRJUYeYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(6486002)(6666004)(2906002)(6512007)(52116002)(26005)(66476007)(316002)(86362001)(66946007)(66556008)(8676002)(4326008)(44832011)(186003)(1076003)(6916009)(8936002)(5660300002)(54906003)(36756003)(478600001)(6506007)(38350700002)(38100700002)(2616005)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3NK0DVMVpGHYHSC9M+pLvboHYf+vc7k5Rwd/QLt4botUkPl4ikV1OF2G9kOx?=
 =?us-ascii?Q?7VukzYxWu8AGJhQVLoCeNA0m+m7EdK5Hs5jisUJkLnA6IGOO0wvsLIR1/whf?=
 =?us-ascii?Q?kjcUtXq5KhlKSnPyzq/W6R0EWqVh+KEvJxfptUTbyuMqNMF+tMu3e3hJ1OvU?=
 =?us-ascii?Q?+PymeGuPTagn6+00zqZoi4S2kMyzUACow9i+sK4g8S2mKtkTPBZijxwH3dz7?=
 =?us-ascii?Q?uV+QBWTa1e59Bdh5uu0cdAZt/a4Fq4E4GSTGIRBkPzIE2JkVgQG/S4S+4xCe?=
 =?us-ascii?Q?J3SKtWX2KDj278uA8z4hroUiYoOrtHN7hwoldzGWOCijoqoOUjftkFlkjfjw?=
 =?us-ascii?Q?bda4LLK+COv2dStTnIEflHKu09XcMGwKSLw73iHOeLj51vehexr3dTfik60w?=
 =?us-ascii?Q?1BYCp49fXNPAGuXdLrZahGFKvAcuQEc+Q7jcFlIUD5Mr6TgmvqjtIUGsBOpW?=
 =?us-ascii?Q?Bp4PVms+EJan2QNUL1SBB2UUSTp6Gi3IxaUq85Ci22QNzYdz7OW1s9d95ToL?=
 =?us-ascii?Q?loZjWONraBJMVd34cBFd2zPXMX2lRVgHrE0k5Kh+V6vr6nfy/dbQQG7C6b38?=
 =?us-ascii?Q?Cpv1RxaY2ZIKw/OFeT0dQmeuygjypdfD56CjE+dVjZ7+fI2cmEg9/092U4qg?=
 =?us-ascii?Q?cOWwHYbp8gUDQ+m3Ex9E+mJTgJgSfk/cI6tH8659RKIhtXumwM7vlUSkYvlm?=
 =?us-ascii?Q?2XXKIdpFD3aAWJsSytcGUzkRW3jfKwiYQlAymxjKG/5YInscEVjFrV/xXXE8?=
 =?us-ascii?Q?/Q3LESsqJQLO+K9eeRTV5uhvbQF6sUa9ln6Wom8FcuATm5/ney0qNN87KfMs?=
 =?us-ascii?Q?627H/Zs5Iu/QIpc56o97tpqPyMWWhI1LB4x6Yzv/Xu+Y+CdwZnuQw1USF2V7?=
 =?us-ascii?Q?sUveV/wwTAocXx6Oq8H9kJlpvIOb/g/VcTa+QHaXjjjtgTuYXCQ0clccoi0g?=
 =?us-ascii?Q?NlPIZGcumTGOGe6hXT03aohbFjRGG6nBfRADJO+7GDqZk11/KNpmnyGA3q+h?=
 =?us-ascii?Q?VFWZY+bNgpuouMrWghEDrz9tEaniyV1CeHf+IZ7PPvKs8LV6JhUY9x/YZQ/g?=
 =?us-ascii?Q?SGKcaP9l/2VGK52pForApqZOBkQ83Ne8mz3wA4q53Ulna8VdFMStahIS8F7L?=
 =?us-ascii?Q?IkbtZZCGwZwD7WeXNUgfmNRU/R/IC5fqwFFjNPBIAW2PsqGlNcVPKXiMEamx?=
 =?us-ascii?Q?25SRB2MIL22l31aVdc/QYLtQlp+Loc2T6BtABm1fguyEEaBKSS5tgDWqkL4w?=
 =?us-ascii?Q?sZGcafAL/XXz97ZqUtmN/0QGgEK0nZWgyXUUE7Tj1FSuqjuCbRJaNVlCxZL4?=
 =?us-ascii?Q?Aw2rpHdXdjSBCvi6L4LSMjvibcv/TeHl6+4vnycO+zw7FF1dqhN25d8byp6n?=
 =?us-ascii?Q?eYY7T7r2jS0pSzkdXl5iwwDmVGW7uoqowcXCm/jj2bx1aLzKypMmyw/HCe74?=
 =?us-ascii?Q?pTlM0vK9x6F5gfEm5tV1AXo/8a8Yzb0toLo9CByUot9JGocRUvTZYP5k2f9M?=
 =?us-ascii?Q?z6NX0H6SFZu1Pi8truU/apu5gJK2ayeUGV8gtkiwxVN2Of39ryYC8rKPkjYk?=
 =?us-ascii?Q?OAJEHUNupb5Me9/TFaft6l5F27A2KZztZxD/CiCPfQnbuGEwho10VBKW+t6p?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3171bb7-3910-42c9-959e-08da9bdfb927
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 14:44:01.4612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeW+e/Mi91fNB0ON4Npvlmrpcg5c//h7FVsUw8ucPSCTZ6QqyeCr+L3+FduO6MnHtOSHo1i0DXkAZRQbLMToWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8661
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Port Time Gating Control Register (PTGCR) and Port Time Gating
Capability Register (PTGCAPR) have definitions in the driver which
aren't in line with the other registers. Rename these.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h  | 10 +++++-----
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 13 ++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 0b85e37a00eb..18ca1f42b1f7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -945,13 +945,13 @@ static inline u32 enetc_usecs_to_cycles(u32 usecs)
 }
 
 /* port time gating control register */
-#define ENETC_QBV_PTGCR_OFFSET		0x11a00
-#define ENETC_QBV_TGE			BIT(31)
-#define ENETC_QBV_TGPE			BIT(30)
+#define ENETC_PTGCR			0x11a00
+#define ENETC_PTGCR_TGE			BIT(31)
+#define ENETC_PTGCR_TGPE		BIT(30)
 
 /* Port time gating capability register */
-#define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
-#define ENETC_QBV_MAX_GCL_LEN_MASK	GENMASK(15, 0)
+#define ENETC_PTGCAPR			0x11a08
+#define ENETC_PTGCAPR_MAX_GCL_LEN_MASK	GENMASK(15, 0)
 
 /* Port time specific departure */
 #define ENETC_PTCTSDR(n)	(0x1210 + 4 * (n))
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 2e783ef73690..ee28cb62afe8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -11,8 +11,7 @@
 
 static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 {
-	return enetc_rd(hw, ENETC_QBV_PTGCAPR_OFFSET)
-		& ENETC_QBV_MAX_GCL_LEN_MASK;
+	return enetc_rd(hw, ENETC_PTGCAPR) & ENETC_PTGCAPR_MAX_GCL_LEN_MASK;
 }
 
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
@@ -65,9 +64,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 		return -EINVAL;
 	gcl_len = admin_conf->num_entries;
 
-	tge = enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET);
+	tge = enetc_rd(hw, ENETC_PTGCR);
 	if (!admin_conf->enable) {
-		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
+		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
 
 		priv->active_offloads &= ~ENETC_F_QBV;
 
@@ -115,11 +114,11 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
-	enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge | ENETC_QBV_TGE);
+	enetc_wr(hw, ENETC_PTGCR, tge | ENETC_PTGCR_TGE);
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
-		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
+		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
 
 	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
@@ -299,7 +298,7 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
-	if (enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
+	if (enetc_rd(hw, ENETC_PTGCR) & ENETC_PTGCR_TGE)
 		return -EBUSY;
 
 	priv->tx_ring[tc]->tsd_enable = qopt->enable;
-- 
2.34.1

