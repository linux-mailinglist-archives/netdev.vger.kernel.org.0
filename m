Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC746817AB
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237879AbjA3Rcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237869AbjA3Rcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:39 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2066.outbound.protection.outlook.com [40.107.21.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAE02BF38
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhbwZETJukvOWeYflSLJ5isA3sprepUe1XFDkl6v7UGsjMlBN8QLqk5iWvSTC7fIit1OTFQkYvibkD3CDUqwsDHnyyhaxSgLnY/AGvEu88wrKDzRl/jpWG5ANs/SSODoChWH4V7mgrXg5KENBG0pqqLrY+VIrNSutnnE8cN5QCEGzVCsgMr6QGs6aZyp6XzBrB5WnBP1UKH6HjpBERdpt5fMpz+63nacx21Po9F+ovCjtEFa2fjetYR3sg9VVUrXYnC3C9sWbFb3C9lz2ClUjEMPkQPVcLTqPCn1k8xxn7g8nA6XPy22ycn/ugtNES964bR7e4JeWrwFZTsxCy6TOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yA2Ndn8CVpDG1vC9HQjhsz4xN/HRw1+ZWo8NwfW4HtQ=;
 b=Bkba98ogZFY1dyp7KU1J/7EXvM9p2u1dfpCN6Mir03WYd69Eu9c17lTRYOOlXccASCyiy1AzN85env4gS0psi/o5WiSyMxzq3+go+X76JvfINOrSDi5xHySJhCyGTVMvqO051jeAVN+Wf1GGwCPKBVPvaXCqH7J4LiVWUYDQYTrkV2hJbDGy8AGyZspjyOPlm61640gHefR4McYdzAfXMMnr8Vbmg8wlwG7EGH6blZWxuymcyqx+4E+W+yKXp+UYxSssJqlTBaxXamiyabcH1NJSsGZ0kJgWMtjrTW+acFNpK5n5PAkZzGZUhWeP/jpjJ4MRBaIpq2GytbvOtPWYHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yA2Ndn8CVpDG1vC9HQjhsz4xN/HRw1+ZWo8NwfW4HtQ=;
 b=Z7Kai0N2QuGVQat02wDXQCUzb2SdA2YavDpwSLGANnZbCsuKFQEB5b8nMpE99A4iBCZlcBkvBHj7498Dt7LQ6zkuykCiqf7I844fj3eWcRdWXQDWcum6Af4QevYyOl9UtvrTwf04R7qiHyRodX08dWN5CiTHd4IBYDDQThBOWIY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:18 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:18 +0000
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
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v4 net-next 08/15] net/sched: mqprio: allow offloading drivers to request queue count validation
Date:   Mon, 30 Jan 2023 19:31:38 +0200
Message-Id: <20230130173145.475943-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PA4PR04MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3b512b-b369-4bc7-0d58-08db02e7ef64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAuTapOWwQMmVrd/0EBzSSRxR14dN/itj+9NnNlUg/E8o3CgpHYDEHTg1/NpbjzSUgCI6137kwlJIuVF0wtE5ylJjEBwJAqkUWvZhQsj1Lhu10o+Z7Adz5eZnHZ1wwvVpMy+P4yTVXP50WfdoZNFEv2Y6rOZDM2LpTuw0/zyKrTiCDUWEHQDoboBhjT4tMlwIidvgJdYFn2VLqpazv2q7aZ5GFvxm8Cz4/eUZs+LBn+oZmoIxLVnbbjqmjyxOx2in3E6M0Qz+47Wm4SnqmJMvs4pwHHftbegNbBSmTzf2WJNBE5kL8FBgmodeH3N618aRpXzny6kGYdUIFCvJU82X7l+9oaEPL/lZ60PZGnjb83Q3/dlThEohz4VJble1qqKnnojuJLGNCtDQvrbXossXwI68Fx0iQv1tfvckQrQnmJyLc7PvbzQ8mnl6FsVSK0aFd/DMxzqjpBtpU0VyTSfIqMZ1AZf7NJl6DvmrNJf07RAXZ77CJr92R+chDR+zF4aSrWjrpIV853ZVDHJN70VR8AJ+wP3T3ZotJRL7ZQIIajoV9AZCWe37P31dDKwVMHya42J9ogBz57H3p0IhDfEKBVJMlyhRLEum8TF+T5JNcO1m/Ca9iiszJT9arkmUONOo7sQESl7ZDyOCYdi8oUlBEwWpp8vyQC80fCxT2cRk5XkJXZBzGLfGUs/BxMMdI+G3fD4l/+ma0y5wDxqDypI6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xZjBjvcwVvnVnBm1v3Brw3LL87qz+KPTYSkcnHjL1ov6GgdRELIWYkJO0p9o?=
 =?us-ascii?Q?IRQLdrUtFB1eGJvm18kVxeJlVJrrC9DYjO79UqyL0EpuxSjUpSIkAReG0GfZ?=
 =?us-ascii?Q?67yy3MKrV3t9l8UV5QXCvZG2v6OpMW0brpZy7MbwDy/lyz7dyoP3rVOMwAPX?=
 =?us-ascii?Q?I/HKczg98+bWQe6vXBmVv3pfwtKbzqh2mz7vxocKEd++A69q6tVC1OtxxlVU?=
 =?us-ascii?Q?+9r7D39Hg48MlRoQeAsJQisu/msMZR136oYZsygk6lnGN1+dCGisLghFMyrR?=
 =?us-ascii?Q?YM6RnV7YwSx6QJbWB1zOMvOs/wFVsqWFRGbi+H5Pw5BhW6NM0DLkFWnpEqlX?=
 =?us-ascii?Q?TWuisVaIzRkdVJKaA5riA400GdIpKlREVO/2Fzx50h8aSzBNGmwJtL4S4ZgL?=
 =?us-ascii?Q?C5mXZf+jjVvg5EhXIIXdpxodpm6a/AkMiJE4J642oSjWI17wH6hwzooTT/VB?=
 =?us-ascii?Q?Qk3Q3h6ynRF7Lwlm+0wDx8HxtyYhRCxa+WM6T0EO2iZ2vBm50osPg0eQAkK2?=
 =?us-ascii?Q?c4khk97NysP/6uAoHUBL0jBnDZbXnDjACYV95ZlwXnOgj7Yr4DNjZsVJrMTa?=
 =?us-ascii?Q?xLWVZlg0fm+3LGPUDimJGfXi3xHGSlb9+N8CZJtHFTm69kA7XejdFvhzg8i4?=
 =?us-ascii?Q?VLvm9F4k37qERQN4SB4AcdNuoptGm5zbFs/fXR3yLt/TMY02CwETyIPNoFmh?=
 =?us-ascii?Q?jwESuBv7hLIJWEwWny35gbSqs1dPKKUkLbB85GontbuvZwD8bqelZvFGKEQT?=
 =?us-ascii?Q?2DRGA8I7e5MmYl/k76OjDgrvr2tHdzY5O8RC/r72L3o09Hir+LtG4xqQpbpu?=
 =?us-ascii?Q?VFuUEdW3snq+TObedUMKCjBs0gth6KSz8d5iO4qf5dcqcPJx5EH1JqOLbCji?=
 =?us-ascii?Q?VXo6645u0zmTH2ZlIChgbXUa71CNpWkRQPVcDPBdd+WHdWlSJMOzcL0fwy2d?=
 =?us-ascii?Q?i5uxp/eRugnyjn+kqLeN2nRn7uK+BmrE0kN79C/6llIOzhdhVG5KaloyLfY4?=
 =?us-ascii?Q?x1xuAhHwmTLmEGLAbhBMYC/dmqqwPFVxmYXNKKZwwQIp+Xq/cXMiZoKL8ll7?=
 =?us-ascii?Q?3vu7NX+UIWX+YWAHWMEtauvbTpBaQxoTawLoQBzcewkNpsyiajMGhov2PKeu?=
 =?us-ascii?Q?NyKRMCKuxBHL+R26AknO1yIvwX6d4h9VWh82d1bHswGtO1owA+Xlbat8Sd48?=
 =?us-ascii?Q?/2fmuY+Q9k3Q/DG1N69QwQ9YlYVKjd51rM4lhFPk7JESdHqpfxeDIjIAVt6G?=
 =?us-ascii?Q?QkElCZHybhIk4Y1LZYjQ7qxgooM0CHIx+9nOH0ZMKRR+qe/ZJzSxN1GNXCfa?=
 =?us-ascii?Q?nY1em7a/0GeP/IB0vRKxydZ9PJPoPsV6OvbieHUHgNd32p/48tc853QjBPR9?=
 =?us-ascii?Q?DEW5G+v5UAA4LqDQtW2PjHqbbZ9RykdrvXlHGE+urtpeM+3xr0N/Mle8supQ?=
 =?us-ascii?Q?1S/Hg5pnoJT71Uli4U+wXySSOWHSjWawoJx4DRr9s0j4nDDcQmVWVTuVMlIR?=
 =?us-ascii?Q?9cc52EHZVO6DbUlB00z3I1vMVEpsKnQMVRU/LfzBlcWy2ZN/X3wVfo2DGqK3?=
 =?us-ascii?Q?3ivuoeiDj77Ku7xJua6bvRPqdUwA9Kz/imIHQ+r72lafqt6VWX5c1Hmw7d9x?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3b512b-b369-4bc7-0d58-08db02e7ef64
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:18.1944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cLwoSbaNBALvUmgXwNCfz9lxEx7Sl0eNJp8aPkh5XotKUDQ7gwqGGzYMlzfvvN6EMBfxGzhKqZyS/0964k69mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7677
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mqprio_parse_opt() proudly has a comment:

	/* If hardware offload is requested we will leave it to the device
	 * to either populate the queue counts itself or to validate the
	 * provided queue counts.
	 */

Unfortunately some device drivers did not get this memo, and don't
validate the queue counts.

Introduce a tc capability, and make mqprio query it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v4: none

 include/net/pkt_sched.h |  4 +++
 net/sched/sch_mqprio.c  | 58 +++++++++++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 6c5e64e0a0bb..02e3ccfbc7d1 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -160,6 +160,10 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_mqprio_caps {
+	bool validate_queue_counts:1;
+};
+
 struct tc_mqprio_qopt_offload {
 	/* struct tc_mqprio_qopt must always be the first element */
 	struct tc_mqprio_qopt qopt;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 3579a64da06e..5fdceab82ea1 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -27,14 +27,50 @@ struct mqprio_sched {
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
 };
 
+static int mqprio_validate_queue_counts(struct net_device *dev,
+					const struct tc_mqprio_qopt *qopt)
+{
+	int i, j;
+
+	for (i = 0; i < qopt->num_tc; i++) {
+		unsigned int last = qopt->offset[i] + qopt->count[i];
+
+		/* Verify the queue count is in tx range being equal to the
+		 * real_num_tx_queues indicates the last queue is in use.
+		 */
+		if (qopt->offset[i] >= dev->real_num_tx_queues ||
+		    !qopt->count[i] ||
+		    last > dev->real_num_tx_queues)
+			return -EINVAL;
+
+		/* Verify that the offset and counts do not overlap */
+		for (j = i + 1; j < qopt->num_tc; j++) {
+			if (last > qopt->offset[j])
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int mqprio_enable_offload(struct Qdisc *sch,
 				 const struct tc_mqprio_qopt *qopt)
 {
 	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
 	struct mqprio_sched *priv = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct tc_mqprio_caps caps;
 	int err, i;
 
+	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
+				 &caps, sizeof(caps));
+
+	if (caps.validate_queue_counts) {
+		err = mqprio_validate_queue_counts(dev, qopt);
+		if (err)
+			return err;
+	}
+
 	switch (priv->mode) {
 	case TC_MQPRIO_MODE_DCB:
 		if (priv->shaper != TC_MQPRIO_SHAPER_DCB)
@@ -104,7 +140,7 @@ static void mqprio_destroy(struct Qdisc *sch)
 
 static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 {
-	int i, j;
+	int i;
 
 	/* Verify num_tc is not out of max range */
 	if (qopt->num_tc > TC_MAX_QUEUE)
@@ -131,25 +167,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 	if (qopt->hw)
 		return dev->netdev_ops->ndo_setup_tc ? 0 : -EINVAL;
 
-	for (i = 0; i < qopt->num_tc; i++) {
-		unsigned int last = qopt->offset[i] + qopt->count[i];
-
-		/* Verify the queue count is in tx range being equal to the
-		 * real_num_tx_queues indicates the last queue is in use.
-		 */
-		if (qopt->offset[i] >= dev->real_num_tx_queues ||
-		    !qopt->count[i] ||
-		    last > dev->real_num_tx_queues)
-			return -EINVAL;
-
-		/* Verify that the offset and counts do not overlap */
-		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (last > qopt->offset[j])
-				return -EINVAL;
-		}
-	}
-
-	return 0;
+	return mqprio_validate_queue_counts(dev, qopt);
 }
 
 static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
-- 
2.34.1

