Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4753415558
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 04:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238887AbhIWCFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 22:05:22 -0400
Received: from mail-dm3nam07on2127.outbound.protection.outlook.com ([40.107.95.127]:20832
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238857AbhIWCFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 22:05:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX/g4eQ7lLu/pgfnaAvJsvLj+E0ptAxge8m5Af0Hd5UPPR6GajPgpDuHNwUHD6z9KR0vBvaTi28Yh+ZeYOc2qm6mrU7iCTxLIfV9D+II57ecFFhpfQWKwFcRmtQ3y6OSgWCXACAYZTw2FTnsoO6Kz6CkfnSpu8Oa8dWGrI4FuNFMjvpg9uv9BNxyKIdkN79mDIaLtgrlfO/68MF6aMwXQ85hpEPhN+i343FdISwSuXzHvchsZH0KaLzxc3gH4ZkEYYTevWuhCwpnGbnpTfA4mhSuY23QCrN9mGSG2cEEN4+K6rYNMC+dB/1Bfv20bHiMrHNX/GVz68sfJmlYA25mkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CcXjAgBZYuChmfT6QF22kdsjkG3xfmL40CahwWHRyr8=;
 b=BqhAlG37dfFIAeW7pHuJHa/UG8291DJeZx4KBZ707BwsfjgbgBSW+2gTFl6uddmU7nGb54rjs8zcAxQCPO2O9KM/JDy+jRrql/+eXjHts4ZmRJsr3vudfr0WqmRbY27rwvTBq7Ak03PKC3srqm3DvHli7Wci8PA/YhyeIePQdiGPW5w3A6I77go4k/CXpqnrm/YFgC/l7w++PNNoMan9nsJOb+JEI6pb1MoNjsxZntrMNoajOyAmLdK6xDnzPESBRPe8rvEzAGzOQbq8nyMJTdUC1BiLQpQzmCoDjt2TRlzxBA1YwDOPvzB8AZrVlrZaHIHbtgAQSnSjalIlWCldqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcXjAgBZYuChmfT6QF22kdsjkG3xfmL40CahwWHRyr8=;
 b=Hgl2WbYNV1XHUhxn5JaEqMlFhY8Y6sVRjJFSqvTnOTH6xFu0o1voyXuIvLsv3xqMQu18kpnInoOl5+VqzVinXu/1Lr3eD1ZPHNyO1Nu6sAjSGR742JZ6fbSQaI8g3gfqzKFl0nF0yMkIZ/d1iNdPqi6r1XgfB/jS9Tepo/i+Vak=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com (10.174.170.165) by
 MWHPR10MB1934.namprd10.prod.outlook.com (10.175.55.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.17; Thu, 23 Sep 2021 02:03:47 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4523.018; Thu, 23 Sep 2021
 02:03:47 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 net 1/1] net: mscc: ocelot: fix forwarding from BLOCKING ports remaining enabled
Date:   Wed, 22 Sep 2021 19:03:38 -0700
Message-Id: <20210923020338.1945812-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210923020338.1945812-1-colin.foster@in-advantage.com>
References: <20210923020338.1945812-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0375.namprd04.prod.outlook.com
 (2603:10b6:303:81::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR04CA0375.namprd04.prod.outlook.com (2603:10b6:303:81::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Thu, 23 Sep 2021 02:03:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a3a680f-2044-4005-da57-08d97e366102
X-MS-TrafficTypeDiagnostic: MWHPR10MB1934:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1934404CCADFA2E585898628A4A39@MWHPR10MB1934.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7W1yfq2Q4iONP38QVtAQaHmuc83xoFJl5yofyoCsd3e3+k4rCgC5PeqcNL+CHntgl0IEdqG/EVBJoiuSnUhMc4yPC/ci4LpATomoJrpXikaLNlqohx0mspNEH1NNvxxxr1vqqrtP/eg/BdfZHaWS0qWZKeyM7Y77/zbN7VBcS4sF3a8QqtBQwfLsmj4BWzt7ksfmJqczezhV/Byv1TEDmuo3uJG/ad/z5nQ0tUDuQCCUYh3yze5x0QnnB10PGbF2YU0t/E2KCntIr07P87atbPq2r56paYv1PPzE8zHp1DeJh6ghrsUSGjqdVXbKm2qpoST7Gw8nemRmvhJa322Cb+mNwgB9yskz7pJTNq7y2wK1cI56PFQ3f78NHp2pM0nV3Vd7Ag0c/Hm+p+hFy2FHliSd5vj28Hi1BrIFHmGIm7VgyhDsbs4JV7/JoyJmflzuoiGsGttIMsLsC/9CFQxwWTFOZZd4E05qO5aD2pG3I0y5eiqG7/0rDjHjofn4qOrGpUA8G6QwMFyvbon+0olbv1dRcBOI3HR2WVsbmIYl3Yi0Mnbbhk1i8j65xuBA248zoJuz3GC0ltC7EAX17DsbzPHCZMAEB+1MSLIuAD89Yrijx2egQJgBYaipR6QZaVfyzMYNVBHgR/02w8YYs6RP03/IuCWcKtg9cM8MIR0A4qGcxuKPt7rxz6hF67n6RdOgomlTxm5bwc1A/4E7yAjAng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39830400003)(396003)(136003)(8936002)(956004)(2616005)(6666004)(5660300002)(66556008)(66476007)(6506007)(44832011)(86362001)(8676002)(83380400001)(52116002)(4326008)(36756003)(186003)(6486002)(66946007)(26005)(2906002)(54906003)(38100700002)(316002)(1076003)(6512007)(38350700002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SyzZq1xDM2FrMsmz2HDFXMZd2XDqbVfIs203CQ63rl8RL2uC5N84X86sCYlN?=
 =?us-ascii?Q?3RvSp6SGnegeoiWMoGwkYqYB78e/2lIi+uSqcCznjGq0kuitLDbwJMiORNTW?=
 =?us-ascii?Q?gJsmOt/rdAiYuCVEsnTdYaVz7vJ+rgu5IQC1SyOfIaIrp/8VJd/M5AoR/4r0?=
 =?us-ascii?Q?X0cc5DVgypvGUSTEjHjDBiP02cFL6iedlFXDoXQlRrQKq5zlbKo76hcwwO5n?=
 =?us-ascii?Q?4sWb5SUDZy7/XYv8DTL6ytnYTNBB/6HshJ0uJgMhpskEBUO1kgcS9uhfkTbv?=
 =?us-ascii?Q?lf9v8AiHlTTb13SVsvpKu62nzqfLRqUxmv21ix37ji6G3s2K4RMDa4ALw7sL?=
 =?us-ascii?Q?3GCPzJmOfe7ruqSLZV8nRsMJH2bZxnOXG62bKI9zNHYo4+LTqdbyqKgTEQD7?=
 =?us-ascii?Q?D3X1Eu4xi1kaxWlmuqURKZFPvsJINO8LjFM01r5cuwznXa0DIhM2ABJnRsQa?=
 =?us-ascii?Q?rDcwsqJ/o41VutpS4WSUHT7Gt6a5zia6QWWVPRO8032HzMz9jvuX70rEBeXr?=
 =?us-ascii?Q?ZVmtqXsA9P8INQq8rDZkhAcNCcd9V7oO+DhPPtV+H+4vhH6Y91WRleab33dE?=
 =?us-ascii?Q?QMg512QVB+f/ZFIdmmSfhPKSLyVO98gWTXevCQkeS4UgQp3owEVGkv2xGFlk?=
 =?us-ascii?Q?WwDSPQN/RhoutEf9T/FRxIZjVQrpff9sB8By3XYa17thGNELTZRIh2BkTSsb?=
 =?us-ascii?Q?gqbNhDMf6Rf10UadRCqF/gUPft+67EvLff5UH1d858+d9ZCR63V9gmA+4Q2A?=
 =?us-ascii?Q?7hzlaI24EFiJxBdrCdq6F4NvI2IR1LMZv6PSf4AW3j8y79lqHtPElblJsxFg?=
 =?us-ascii?Q?11lx661i/Atb7uuAHgUIV3nPpqR8dTRtVf737K1JMXmoOeX5Z5YxEinXasE1?=
 =?us-ascii?Q?MTcmNVMfrZmCDeGjMxNZ0YiGf/30ruCmIqLEfgkHyqiM6jN66OOuk31esoib?=
 =?us-ascii?Q?+dnTtpPqmePnTFm+gwSM9hiJZLc+wBzvuY08scNqWoq5BzMgua9V+811BXhk?=
 =?us-ascii?Q?j52eMwxaQqlZYQGDQGFHPf8bLdWtUshTAXnphvBQLra4/IEjkX/N0d/8u7eK?=
 =?us-ascii?Q?tQJNBSgq6q23d4uR9bD1MlMkIKj4+1H5vYAwFNPFSXC4m2+jhjO2o623YA7y?=
 =?us-ascii?Q?gwOAixAQt9Lb9NOIdj2/MqLYTDTQVERNpT5CK44xTvTKhQx5rzprAiiUt/vN?=
 =?us-ascii?Q?2STHOxlvLu0muNs/0SVD2chkpIGkENeuD9blqcTk21HLVzZpF/f8kfbPjW8/?=
 =?us-ascii?Q?DvH758nB6X24esejkSHcbaJJt8js43MGPknurtmFNSaQTJ3/6Xb7MOL1urcc?=
 =?us-ascii?Q?VXJ8xxTktNkadCLDzUinpLgH?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a3a680f-2044-4005-da57-08d97e366102
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 02:03:47.2575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RsnSe88f67sDda5crmitnQAVvU8Jm4CKPCc4S/7yqmd/S9D8GCzUKpnQycYkM8d98qrF/YGzGprWRuNyAE3zaotXJRSM6B6g5/WlPpvuO1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1934
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The blamed commit made the fatally incorrect assumption that ports which
aren't in the FORWARDING STP state should not have packets forwarded
towards them, and that is all that needs to be done.

However, that logic alone permits BLOCKING ports to forward to
FORWARDING ports, which of course allows packet storms to occur when
there is an L2 loop.

The ocelot_get_bridge_fwd_mask should not only ask "what can the bridge
do for you", but "what can you do for the bridge". This way, only
FORWARDING ports forward to the other FORWARDING ports from the same
bridging domain, and we are still compatible with the idea of multiple
bridges.

Fixes: df291e54ccca ("net: ocelot: support multiple bridges")
Suggested-by: Colin Foster <colin.foster@in-advantage.com>
Reported-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c581b955efb3..94d80b0f0274 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1303,14 +1303,19 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
 	return mask;
 }
 
-static u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot,
+static u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port,
 				      struct net_device *bridge)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[src_port];
 	u32 mask = 0;
 	int port;
 
+	if (!ocelot_port || ocelot_port->bridge != bridge ||
+	    ocelot_port->stp_state != BR_STATE_FORWARDING)
+		return 0;
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		ocelot_port = ocelot->ports[port];
 
 		if (!ocelot_port)
 			continue;
@@ -1376,7 +1381,7 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			struct net_device *bridge = ocelot_port->bridge;
 			struct net_device *bond = ocelot_port->bond;
 
-			mask = ocelot_get_bridge_fwd_mask(ocelot, bridge);
+			mask = ocelot_get_bridge_fwd_mask(ocelot, port, bridge);
 			mask |= cpu_fwd_mask;
 			mask &= ~BIT(port);
 			if (bond) {
-- 
2.25.1

