Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF8C67CB53
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236519AbjAZMyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236368AbjAZMyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:00 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2065.outbound.protection.outlook.com [40.107.241.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0025367CF
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiqoCqul2YPuIeACrOYyxECuwPmfmuPXIZvVuKtTNzZWz/SJIJYI7EnCxv8+7SrrKleH9zhXqDjsWCkfSfIqXfAGwfWAhl40Qih+hzwMbXu2wIhZVkFtLdlQ/CyzRIuVTHXtMPdb/q4zemn5/DHc6SFh4y3mTXbOG/kzxXAjYTvRBKULLiK6FdHmRnsJ985aLmMUViOeFVBQnZuQMNG2HeUuAG7gwcV0svf1TDUlyZWJvm2deOPCUpN185Z1Xd4NunsdA14cU9G0v/1NJpk+2Gm9o4Ac56nFiVkoRxCt6dXcLW3CUMZrthHysRyKjh4+23xftMDN+ow39cuPZyG7DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27JPviZ2UQk7ztOpDqXJEXQof5tC+ThtxNXcq8DqEos=;
 b=PtTG3vQx56dhhdHN+NAkB6Gm173rjK6MQvusQ/16z0wcK8VLQsmrFV+GSlmjvoUggv8lopsB8v+mpIOVmpYfZdmO74TywvvSyECYyvRrWfG5SI75/BUTYnKBQPfXAesbEwSOjM66pd+zOBp3AA7fg0YqAoBrUFV68KIRMChwEiZ80gHlqIFrpZoObND5pwJIQqq/ZdqaxLZtZ5irF7qRGyKggFrFncivba8ywrKk9FK981vdny+NvXLDa+BxqkSJ5b+5RTi32fOEltX3TPEsC1RenLKdi6aVHhfvyf7Cw+M1DU3V0BDkWp8kPbHyQBQk6YVW0uFpy2TUcJ2NRd4URQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27JPviZ2UQk7ztOpDqXJEXQof5tC+ThtxNXcq8DqEos=;
 b=MYqhDjA/X0lwrohRw3l62gUIqKc5wQjHiMYKMWxOHBsRxlBYCO8/y9l2ziGCK4Y8M9HUp3gDn9QuOqaSu/ArnXZwGwPM9mhmDCKrJREAmY51Kw/Uq7TP/XTti2hcuGBKo6ur74KhfkxizEtV7vLfskjw14W2uxkqIGOVhe6RMt4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 06/15] net/sched: mqprio: refactor offloading and unoffloading to dedicated functions
Date:   Thu, 26 Jan 2023 14:52:59 +0200
Message-Id: <20230126125308.1199404-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 597576c9-9c11-432e-47aa-08daff9c5941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: THG8+5P4KPz5YMiZ/iBNc/+djtvtH18rn6C2sp/aouHQUGPDbFwd4ChgA6yXegxcLr8zLlq7dg4xkFaUGC5ShfYnkZz8eGu9DAOoZrMIZbM3SDEK08QAX+dG97PdzPxl83FN105xl1g89yxYoTDD0N7izcDFZLuVoWy2nQCAPf8I7hkpAZvfuIqInEZzMTBI1oG3ytIsVB9iHJjjkgt6DQ+e/c4WwqSIQm5EU3VhSHWygvpJZNopVdcP10aXmeyvvOUMEhwM7m2/qqF4xMduXmcPa7xUFp7CwNoJqViFtt9EIrokZYp2kWwPN5YU9MkOxwPqmBkdExGwydoXcdWQLgVteHW9E8Y4BR5bgxUBb7NZA/bRVOwtCaRugCALoQ40BA2ZUpDIIboJLRCXINUaoTpfs67NYkyrDLBJT8jBf4RzEgmwLsU1uFQh+8VPZ3No+SYBsMK/HouLkkf/IiFBN1M9WdzSCk+GuVdMjBAC+pInvG1uuA6eusxdEVhkeF+zKOiEfGE5Yz5uXXgRD/2We5enBCrw1v2XUI5tJpr/GjellcIFu/EoRLJKIROJhHr+pyHMA8cYA0fAvrthwJhxmA65QLnUi+NvIthMUEbPchQ5cyAetEC02jo5dK6Eq26h0NniTMwH8n5qKvXDSWJvykUhSP/QOhx5tKTmg3FN5Ygb+tqlusxAsGC9xMN7HYDlkNnryGLFs8VrPRPktSfTjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(6506007)(44832011)(2906002)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rpncYa7LpKPFBPgq2f5Loto4bEont+Ye/7AA8MuLe//cYw6QWcWSMhyrNZ6w?=
 =?us-ascii?Q?CvOLRRxSy8+dflUhcJVM3Cx3bxUQX0tV6hy319eOQNT9MWVHpLGcRHrLcZbl?=
 =?us-ascii?Q?mvgkYmgG1Wq/g9m9MIbvDzTvXgEC+eB/4gKerVU3uaw1MWy+ctC6qWF14BNb?=
 =?us-ascii?Q?0QOPKAWPBG+T0xC8B7RBzM7TXgjTZf7/tuacgb8oRXvCLtaa5V7lcl23gEvG?=
 =?us-ascii?Q?PN5TUSp26/d9f7lI7Ygr+QEG1/Fq/iGlnauKM4poYK72hnkdhNIO3Y7BLPcC?=
 =?us-ascii?Q?4QqQIbSp+7AcqiAtJZarfn/MLtX4ZSZSG0fd0Pd6cta8O4Ie0qTWjTU3Kypb?=
 =?us-ascii?Q?y9Q8GUOrXAetORlhWD4ejewcOwsazJIQnJrUWJhw3+tVOClC/brhs9DLzeMZ?=
 =?us-ascii?Q?SK4ijWO0pLsnLIGQpg+HJNOg1PwT9WG28iNFNYcY+iX9SU6YAnuuRXtvtwsk?=
 =?us-ascii?Q?cp7/H98oLzPvmju+/hXAnH+1Ttd5IsA/+Ma/Id0ysKrKBmbAzLsoDvpTeHGG?=
 =?us-ascii?Q?DDYeMTHLHcVPMypOrDMi/bUJzTckHktL7SQ7cmWUQaRsxqqy+L1cFWEFLiDO?=
 =?us-ascii?Q?G64vQdcexbfp1iWeGZNwo5MJXZCv1KbT3VJ3K1/TuMWPNloLdWjU2FTW/L9N?=
 =?us-ascii?Q?m5cruavMSRJ7/iythRm1FpHJKFE6lmyNno3/H954CUhKs6lkPri9JRFVu78q?=
 =?us-ascii?Q?V8M9iDxONofw3tpk52iRhyDx669yLSdNh6tY4w2LbdypATVpqWV4c27L///s?=
 =?us-ascii?Q?vAlK1DwW6sGzo3U+z7zZXQ5oKSl1oHhX763cnNIXH8rowb6z3wp5z8eJYTGG?=
 =?us-ascii?Q?SRog0HEQN3BFk5iuqvc0qjUwFw8HJWQT4lC1LkgKB0Di6OUi7p0INhQ6w6fs?=
 =?us-ascii?Q?XNZgwoCfnnJdtMc6hsVr6lloTC42ekg9tNFU0GdpZTorZtikPXUijKwStz+t?=
 =?us-ascii?Q?Lm7OFUrK08uhZpjlEplJpBLrsh/grCT7l/HENIxAUSxcH8m/bKcvVpNrjkpo?=
 =?us-ascii?Q?IhMsTrItke/5QHnDVf9i5F2UlGr/nYcFTSx2xSQbrEk+hw533d2UhrhYcHrj?=
 =?us-ascii?Q?66lR0Dj9TWBIU5OXnA2L+5wIwNRiaE1B3tNIDNmrEw9j69HO7iZEOF3CVetX?=
 =?us-ascii?Q?X5Lp802SDyefi1zNEnstJcGVneZKTgWNgRmvWqxoL4us/M3PIaUS0UllG23C?=
 =?us-ascii?Q?tDSTNm+Q3vktVOraQbxL6QM3ESh/NQXgi0pwfnlvkoft4YRZF5Vtw7hUQ5pP?=
 =?us-ascii?Q?FcPJjuhivBVnWuDKojvLNJ4BwFs8EaIJq8nYUNRxlhI+izQYZI+TeOk8L1xb?=
 =?us-ascii?Q?RM0NOAXqmM7RVPzyqoRxDIkjaxS/HjjlBDHcpvFJ0HrgItAM8I2Jm8doug3q?=
 =?us-ascii?Q?zaarNddTs4DDPtvmsK1c1Y3iGhctTv06oOLulD/nkJPU/dMxkXS+xauox+jh?=
 =?us-ascii?Q?vkW+h2btYtdp5RMoqTThFZCYVvw/ULv8YYjAxrzw9asASrbS3OosAk/AWG7Y?=
 =?us-ascii?Q?Zsms2+Psq356YBRAz4bptHQk40YP95y7E5NKj3mbPqxWtJNdqw94PCwWl5mV?=
 =?us-ascii?Q?fIMNAaJm9fxqtA1sU9vv+qymKSX6OSw58cXuzMTeLas4uNNnhja5azCp2pAj?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 597576c9-9c11-432e-47aa-08daff9c5941
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:40.6277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vJrYMO5vmehx9c28lWOb1f09inWm2qtijEo2uuG9Cwdr2O7wRKDf6Grw5pCDszL0AgKKQV/ogCmj5RWsI9/HKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7795
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some more logic will be added to mqprio offloading, so split that code
up from mqprio_init(), which is already large, and create a new
function, mqprio_enable_offload(), similar to taprio_enable_offload().
Also create the opposite function mqprio_disable_offload().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v2: none

 net/sched/sch_mqprio.c | 102 ++++++++++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 43 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index d2d8a02ded05..3579a64da06e 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -27,6 +27,61 @@ struct mqprio_sched {
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
 };
 
+static int mqprio_enable_offload(struct Qdisc *sch,
+				 const struct tc_mqprio_qopt *qopt)
+{
+	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
+	struct mqprio_sched *priv = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int err, i;
+
+	switch (priv->mode) {
+	case TC_MQPRIO_MODE_DCB:
+		if (priv->shaper != TC_MQPRIO_SHAPER_DCB)
+			return -EINVAL;
+		break;
+	case TC_MQPRIO_MODE_CHANNEL:
+		mqprio.flags = priv->flags;
+		if (priv->flags & TC_MQPRIO_F_MODE)
+			mqprio.mode = priv->mode;
+		if (priv->flags & TC_MQPRIO_F_SHAPER)
+			mqprio.shaper = priv->shaper;
+		if (priv->flags & TC_MQPRIO_F_MIN_RATE)
+			for (i = 0; i < mqprio.qopt.num_tc; i++)
+				mqprio.min_rate[i] = priv->min_rate[i];
+		if (priv->flags & TC_MQPRIO_F_MAX_RATE)
+			for (i = 0; i < mqprio.qopt.num_tc; i++)
+				mqprio.max_rate[i] = priv->max_rate[i];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_MQPRIO,
+					    &mqprio);
+	if (err)
+		return err;
+
+	priv->hw_offload = mqprio.qopt.hw;
+
+	return 0;
+}
+
+static void mqprio_disable_offload(struct Qdisc *sch)
+{
+	struct tc_mqprio_qopt_offload mqprio = { { 0 } };
+	struct mqprio_sched *priv = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+
+	switch (priv->mode) {
+	case TC_MQPRIO_MODE_DCB:
+	case TC_MQPRIO_MODE_CHANNEL:
+		dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_MQPRIO,
+					      &mqprio);
+		break;
+	}
+}
+
 static void mqprio_destroy(struct Qdisc *sch)
 {
 	struct net_device *dev = qdisc_dev(sch);
@@ -41,22 +96,10 @@ static void mqprio_destroy(struct Qdisc *sch)
 		kfree(priv->qdiscs);
 	}
 
-	if (priv->hw_offload && dev->netdev_ops->ndo_setup_tc) {
-		struct tc_mqprio_qopt_offload mqprio = { { 0 } };
-
-		switch (priv->mode) {
-		case TC_MQPRIO_MODE_DCB:
-		case TC_MQPRIO_MODE_CHANNEL:
-			dev->netdev_ops->ndo_setup_tc(dev,
-						      TC_SETUP_QDISC_MQPRIO,
-						      &mqprio);
-			break;
-		default:
-			return;
-		}
-	} else {
+	if (priv->hw_offload && dev->netdev_ops->ndo_setup_tc)
+		mqprio_disable_offload(sch);
+	else
 		netdev_set_num_tc(dev, 0);
-	}
 }
 
 static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
@@ -253,36 +296,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	 * supplied and verified mapping
 	 */
 	if (qopt->hw) {
-		struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
-
-		switch (priv->mode) {
-		case TC_MQPRIO_MODE_DCB:
-			if (priv->shaper != TC_MQPRIO_SHAPER_DCB)
-				return -EINVAL;
-			break;
-		case TC_MQPRIO_MODE_CHANNEL:
-			mqprio.flags = priv->flags;
-			if (priv->flags & TC_MQPRIO_F_MODE)
-				mqprio.mode = priv->mode;
-			if (priv->flags & TC_MQPRIO_F_SHAPER)
-				mqprio.shaper = priv->shaper;
-			if (priv->flags & TC_MQPRIO_F_MIN_RATE)
-				for (i = 0; i < mqprio.qopt.num_tc; i++)
-					mqprio.min_rate[i] = priv->min_rate[i];
-			if (priv->flags & TC_MQPRIO_F_MAX_RATE)
-				for (i = 0; i < mqprio.qopt.num_tc; i++)
-					mqprio.max_rate[i] = priv->max_rate[i];
-			break;
-		default:
-			return -EINVAL;
-		}
-		err = dev->netdev_ops->ndo_setup_tc(dev,
-						    TC_SETUP_QDISC_MQPRIO,
-						    &mqprio);
+		err = mqprio_enable_offload(sch, qopt);
 		if (err)
 			return err;
-
-		priv->hw_offload = mqprio.qopt.hw;
 	} else {
 		netdev_set_num_tc(dev, qopt->num_tc);
 		for (i = 0; i < qopt->num_tc; i++)
-- 
2.34.1

