Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB95068726A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjBBAhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBBAhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:37:18 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2044.outbound.protection.outlook.com [40.107.15.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A3D74C09
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:37:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iU7jQe6YdOXDtP7h92jgTF2m+uz2ExLHk9LGJpFKC45t7rDsvdx63PzUb8HozOH6NhSkJnBn6C5aeCftOEFBHWcVdfoSMIbYFpGEMK3mQCXnGDdVtMIFJ1hmJQrEBsN+3a/hJGg69QTQx4S0vHN0DMSyz0oLnKPaKyxP+uVBuMBtModgmqV/TsgfnBnJBn1tM9ajBrOL7E005QKRavPG9aB3JUHRFq9plBN5TQ8XP/i2Nl6CHqPcff+x2gWCJd5iDGDbYWKWmaSJtJ1jyPTd6GpvKC9CGKPbLlqwzSmduB416KQadSgJCf/tm1bQevYDUYRy9IfY9y1jHkiMOKrbzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/c2wmNxoxkamfjwqc4PX7zHFrZ96xKuRjzD6ZJODa0=;
 b=AMfLekR1qojIa+OH8wQybn+B24HsoteA0xb/aHex+IfVGXouoLo/+ORBgaNCOzz2XXyZMinEkL6bBmSx1qb2ruOSW8cM3JqBTqhw5TQCwFymOVJ+UfRaNpPSEa2KmQfRAXYieyRUbuRBTZR8cN0GNBc5NaJ7llALCicDUBXFRdQipy5+GRT5JOrfV0xS4vqyRgLr28Na4VJUZ5USdUZt8rkzu9IlxNINtONK84pe8n+UV7/FLwD0mtnwciJKOFPopgQjXZFLyMBWS6XtXrKYAwitSQbw31OM2T5xuqPUpDPg9+I6U/hvexN2Hi3LWxq6u1dthe+V9R07ABOcXskK6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/c2wmNxoxkamfjwqc4PX7zHFrZ96xKuRjzD6ZJODa0=;
 b=PgPZsx7JV+2zu+D3t2frIcC9QiLaZ9yvla51aq6I2lU/j140EwNiP4EJjJ0z+bjJh2yFbdJktDZgONrfloM+0ynKMDkMg2vFkaLZ+9mGCOTapJKwU4B2zyAfmpQnZtSdnvpQOh9fgfapyXuZV+uqHjAvrJpi2NFuqHnvYDLaDB4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8362.eurprd04.prod.outlook.com (2603:10a6:10:241::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 00:37:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:37:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 16/17] net: enetc: act upon the requested mqprio queue configuration
Date:   Thu,  2 Feb 2023 02:36:20 +0200
Message-Id: <20230202003621.2679603-17-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8362:EE_
X-MS-Office365-Filtering-Correlation-Id: 9af981aa-bd1e-4f51-96ca-08db04b59ad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KeScCZUmKPU6OCoCwr5ILQcJPaQs7jagqLefNCT8MEhaXIvXjSastE1VShcLRoOhmu/GAWtBPzsU6gGvLn/quPw617txLDb2Ni9Z2UT5jqiFj1lv0GOQiAC1AK56heq1aQqLU2rkMfG8MTnszOcXsmU54u3OonSOj+6+JX8NUL1eYIOrS6D4y0oEI9EZYLLqyFcLmVWRwO2u7JKpWVcuwR2tga8hZfMYh56ABwODbYspU1RtWmsyfHR74RspF/4G3PkxwcBvXF93roCeVwwf5NBl1px/WKCT/Cwey6BofiP6c8OtErA+UFiKXNTPmxllViUCsqhLGVsWJnRCJQJqb0tfG+DZPJNxd+m6fO4pumPUCM9cMMCpZVuShK1N3ue/3u8ErRUFSICv8GeJNanyyiQ6WVdoIDp2THrkO7YQrI1nlAeEfsya0hnS7hSfCvHkCfefSqFqStl0l2VvCcZ1bgqYrTb3wuL6jeycwK4PPvuDSAf5nC8TcdtsFtIHu5otlDFxanASCPV5s9sBjkdQgeGQCRiZKQQjV0Ac5bOkKEtWeHr+BjcnmYLkYIKyNyTnp9Jqe+khWpsy35LAwOP/XxSRbwCIPCNrALFUStjaOzDRaG2QtMMi0wSCToHm3aD1O5ASQrCLIzglzVjeMCxwqej+uU+do/GArh7bnrkKMv7mWqEqo5XD32hoaTKxHlu8QQyTgydhu8ICa3JSlqYQrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199018)(478600001)(44832011)(54906003)(38100700002)(38350700002)(316002)(6486002)(83380400001)(52116002)(7416002)(1076003)(6506007)(86362001)(5660300002)(2906002)(6666004)(186003)(8676002)(26005)(6512007)(36756003)(2616005)(4326008)(41300700001)(66556008)(66476007)(6916009)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kdyuvj7bMqJkjEgDaiHfpocwtUODJOHJfUlsgFt4IoeNbbwfgm8ZKsSZJW0P?=
 =?us-ascii?Q?2f/xBl5EBytdRzZ2j3DELDBaVLzF4sdiWYalB3KmB2gopDsrVgSntBePM7tm?=
 =?us-ascii?Q?RuQE29io8Ka/7j8djdtSJZg2lhF/omMuRAkA2fOo6sW97NDkY6BLX2D8Q5MB?=
 =?us-ascii?Q?8ef/eWz9atuM5JDzTN2tTsN+PJOmbHiAUMOiWXobXLTqPn307mx10CloBN/u?=
 =?us-ascii?Q?rHDqg/FuuuwXkJBR63TQ87/WiCoijNwy40yC4ktMzGSlKJGLMeir8QhS55M2?=
 =?us-ascii?Q?YgGxIjWHFKi4WC8GMEBlkKKd8bJT3MzE86xg4MiOYqnXKVyuc5q1DPpcm2Wt?=
 =?us-ascii?Q?WxWeOfTnyG+SjeOI9KsoIF3ld8N3uuaDBldhEbAXn2ESJ2AwsktRicJ5/LHx?=
 =?us-ascii?Q?wotPsjXRIEnPVcAcMC3ukAWjyBbnfcOaBv4C2Juaccev4/z7L/jGYohRJLmx?=
 =?us-ascii?Q?rndD/zisO8z9quNBGyerQo7n+Rg0chDNMyxJjiXX4jRWCVqZckijdp4aeRbn?=
 =?us-ascii?Q?VhUGAl/Psj4qVRE9AzlcFcH5NShf3pNttOqW/DzEGosI+SyW3VaAIpBe/KdZ?=
 =?us-ascii?Q?ymwmTx90zsBcHVqNRLd7xtAIftV5QrXtxe+QHOLgFQBt6dgztXDT9W4MI7aN?=
 =?us-ascii?Q?DEivApTQi+YpVrDjEdt0ITlPcIumMZKLFm/2dMbHyAg1rWEqh0UbYGbbCzJ0?=
 =?us-ascii?Q?BoujAlKFx6aknc4jYvsKlnhLMuAvVfQxYb/CmCZAHgerfIid4wSYMMbIKIeZ?=
 =?us-ascii?Q?QuqCagITCY/IA3qzw1Ar7XJXGdIFEW483lzwZjqXxn+Kf+RLVNTEbvRn+qdi?=
 =?us-ascii?Q?vN2e3/H+xrSDQMGhczXb9pzbRoUd4wPCRjJyp0BVRMGHCbT/zSRJVu19Dump?=
 =?us-ascii?Q?bOvwYCjqP+2bF/fmfEc9U/MyzGW2mR7/9aRW1Djq/H74eiWpP+tOyLfFw8BQ?=
 =?us-ascii?Q?x99wkmmKiZEwE+ZQbEEpMcn8jV0T85nkrvUWvI5FGhOZr+ZZ4rJc1+j1PGIh?=
 =?us-ascii?Q?agx4yX8UosGgxGFKGkNjgNs0PR4P4ApYx+pr5CLARaHu1HdXsTQYTzTv46Ec?=
 =?us-ascii?Q?rEuhloONDLeOLgEfgJEKIeRYB6gCaC2fvmKASypv4sbmxtpfaLb/QobLZTtq?=
 =?us-ascii?Q?CpDSAiwNT3hZa1Qr/+CIIznVP8PIR4t/SjpYTWCQyz+ecHAA488sypQP0Mcd?=
 =?us-ascii?Q?V0WVtN1NpdfcKcbHIG9bhIcP43C+UKWVSf8BdDdB0iEbu1jGsONHrJ2gFb1R?=
 =?us-ascii?Q?iZfnq+XHLZ3zIHU/91ZVyQOyjyYqLUcz6z1ZkEbD2kd6oXO5FBhNX9doQxUb?=
 =?us-ascii?Q?7tAGOcbSEkcjh7bGU4u+pApjF9b5+8twXa7SWCgZusxVQsJjLLA2fRxPbLwK?=
 =?us-ascii?Q?nu1rJei4Jkwpo1uZ9G0igbSo++IHSu5331Es6ILgttvjxosHa/9iWFJWyImb?=
 =?us-ascii?Q?p1OIepSk9/IUBTi1X2oV9ZLBDiFoodRDsj1ETMzTRHjUahrK4rao697zMJvj?=
 =?us-ascii?Q?F65d1/O3JViHGDJ5XkNmWuBtMhXvWFbZBgzmeIOxr2kSAJIepu0Ph2fbSV1k?=
 =?us-ascii?Q?kIT38Asd2ruzy2NVqo3bHxy5yVsH3LjjjOWbVNQHuaXhG4GhGC7Nzd/+aTSD?=
 =?us-ascii?Q?3w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af981aa-bd1e-4f51-96ca-08db04b59ad8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:37:03.8409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: belxvH9jDiIsKxKlfSx2+5Xo1oCdBBWrRH/Xn9RYqQTj1d5KCQyoVPr5GguPhq9npvepR80i48LqHav0PfzdjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8362
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regardless of the requested queue count per traffic class, the enetc
driver allocates a number of TX rings equal to the number of TCs, and
hardcodes a queue configuration of "1@0 1@1 ... 1@max-tc". Other
configurations are silently ignored and treated the same.

Improve that by allowing what the user requests to be actually
fulfilled. This allows more than one TX ring per traffic class.
For example:

$ tc qdisc add dev eno0 root handle 1: mqprio num_tc 4 \
	map 0 0 1 1 2 2 3 3 queues 2@0 2@2 2@4 2@6
[  146.267648] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
[  146.273451] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 0
[  146.283280] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 1
[  146.293987] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 1
[  146.300467] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 2
[  146.306866] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 2
[  146.313261] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 3
[  146.319622] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 3
$ tc qdisc del dev eno0 root
[  178.238418] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
[  178.244369] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 0
[  178.251486] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 0
[  178.258006] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 0
[  178.265038] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 0
[  178.271557] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 0
[  178.277910] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 0
[  178.284281] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 0
$ tc qdisc add dev eno0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1
[  186.113162] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
[  186.118764] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 1
[  186.124374] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 2
[  186.130765] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 3
[  186.136404] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 4
[  186.142049] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 5
[  186.147674] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 6
[  186.153305] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 7

The driver used to set TC_MQPRIO_HW_OFFLOAD_TCS, near which there is
this comment in the UAPI header:

        TC_MQPRIO_HW_OFFLOAD_TCS,       /* offload TCs, no queue counts */

which is what enetc was doing up until now (and no longer is; we offload
queue counts too), remove that assignment.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v4->v5:
- slightly reword commit message
- increment num_stack_tx_queues by "count" at a time, not by 1
v2->v4: none
v1->v2: move the mqprio teardown to enetc_reset_tc_mqprio(), and also
        call it on the error path

 drivers/net/ethernet/freescale/enetc/enetc.c | 101 +++++++++++++------
 1 file changed, 70 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e4718b50cf31..2fc712b24d12 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2609,56 +2609,95 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	return err;
 }
 
-int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+static void enetc_debug_tx_ring_prios(struct enetc_ndev_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		netdev_dbg(priv->ndev, "TX ring %d prio %d\n", i,
+			   priv->tx_ring[i]->prio);
+}
+
+static void enetc_reset_tc_mqprio(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct tc_mqprio_qopt *mqprio = type_data;
 	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_bdr *tx_ring;
 	int num_stack_tx_queues;
-	u8 num_tc;
 	int i;
 
 	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
-	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
-	num_tc = mqprio->num_tc;
 
-	if (!num_tc) {
-		netdev_reset_tc(ndev);
-		netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
-		priv->min_num_stack_tx_queues = num_possible_cpus();
-
-		/* Reset all ring priorities to 0 */
-		for (i = 0; i < priv->num_tx_rings; i++) {
-			tx_ring = priv->tx_ring[i];
-			tx_ring->prio = 0;
-			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-		}
+	netdev_reset_tc(ndev);
+	netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+	priv->min_num_stack_tx_queues = num_possible_cpus();
+
+	/* Reset all ring priorities to 0 */
+	for (i = 0; i < priv->num_tx_rings; i++) {
+		tx_ring = priv->tx_ring[i];
+		tx_ring->prio = 0;
+		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+	}
+
+	enetc_debug_tx_ring_prios(priv);
+}
 
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct tc_mqprio_qopt *mqprio = type_data;
+	struct enetc_hw *hw = &priv->si->hw;
+	int num_stack_tx_queues = 0;
+	u8 num_tc = mqprio->num_tc;
+	struct enetc_bdr *tx_ring;
+	int offset, count;
+	int err, tc, q;
+
+	if (!num_tc) {
+		enetc_reset_tc_mqprio(ndev);
 		return 0;
 	}
 
-	/* For the moment, we use only one BD ring per TC.
-	 *
-	 * Configure num_tc BD rings with increasing priorities.
-	 */
-	for (i = 0; i < num_tc; i++) {
-		tx_ring = priv->tx_ring[i];
-		tx_ring->prio = i;
-		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+	err = netdev_set_num_tc(ndev, num_tc);
+	if (err)
+		return err;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		offset = mqprio->offset[tc];
+		count = mqprio->count[tc];
+		num_stack_tx_queues += count;
+
+		err = netdev_set_tc_queue(ndev, tc, count, offset);
+		if (err)
+			goto err_reset_tc;
+
+		for (q = offset; q < offset + count; q++) {
+			tx_ring = priv->tx_ring[q];
+			/* The prio_tc_map is skb_tx_hash()'s way of selecting
+			 * between TX queues based on skb->priority. As such,
+			 * there's nothing to offload based on it.
+			 * Make the mqprio "traffic class" be the priority of
+			 * this ring group, and leave the Tx IPV to traffic
+			 * class mapping as its default mapping value of 1:1.
+			 */
+			tx_ring->prio = tc;
+			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+		}
 	}
 
-	/* Reset the number of netdev queues based on the TC count */
-	netif_set_real_num_tx_queues(ndev, num_tc);
-	priv->min_num_stack_tx_queues = num_tc;
+	err = netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+	if (err)
+		goto err_reset_tc;
 
-	netdev_set_num_tc(ndev, num_tc);
+	priv->min_num_stack_tx_queues = num_stack_tx_queues;
 
-	/* Each TC is associated with one netdev queue */
-	for (i = 0; i < num_tc; i++)
-		netdev_set_tc_queue(ndev, i, 1, i);
+	enetc_debug_tx_ring_prios(priv);
 
 	return 0;
+
+err_reset_tc:
+	enetc_reset_tc_mqprio(ndev);
+	return err;
 }
 EXPORT_SYMBOL_GPL(enetc_setup_tc_mqprio);
 
-- 
2.34.1

