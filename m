Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3BA68AA5E
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbjBDNxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbjBDNxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:32 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD561769C
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GioukWIFp61N3KISkk70O0dUcsUpo61MlcB0FpRE0AJ2tmVGGtcsyaPTSgK6tbKDNpSSC3OTC0Gv7yhEpV1FsXWIgBLcT3kn/7FS0pHbvjIYiiCm6JE/xwEpOd1qSnjecZEO49uSVv7Imyqinh18wsSyHxqpbtx7LtDcwmQYShHvyJ6SJmWqOjtjmqwMCtL+nYy4s481U0JFndggh03KBSL7U/JZ06lGDpviTATf+6PEyQF5U1JjY/iTW7gYC1KKRyed3dy5HNqr16LRoEAJEUrF/NjLEGT4AWPrjgpP88LXaM53OiCIhgGHbXr2S4yXnYJGE1yt1fEo6UXlNlgp/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=woRM4qOFTszniTdHyRhts8jr5N7Rpe1JdmrdLJZJbXM=;
 b=E9e7z+giAfxDTyZmSIiXfshGShiRBSLVH9wKi9uStTOjPYLKWnjdap15jZkVhZbTGuONVF0vEYQLFUPljK4Ff5roy/tVvb6h7nx8Kvkejzg5eBrhw2M5CWDrr1hp9elhW2YDs51rGgd3n/4H7TBCcdUvHQI+Abc4w2Xo8u9FowmyXhPnOynCbU0F4hHkuFdidtHiQyipids51eltxGg5zjGXPXyxZt3ix/zx6AW3cSXsdcFAdXlNItYA5t8tjjmbEYU5ERSC3SqSRvYEuSQwDDtHDv6vgPrIGuIj1oxBRIHcPjO6Y2SiHSvRtNJ9QBqwypK9u5mm+QKWWzEmwUvzHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woRM4qOFTszniTdHyRhts8jr5N7Rpe1JdmrdLJZJbXM=;
 b=RNtPpbeGkCTkDXRkJRkz9F+T2ieVnTCFM3EfGlrOTpoX3d5+fib1BwFPP2fQ+VTgjYL2TAW9f4ksF/gBbyc5kOPi1CaTBWzFEjB2EQO04FOGavmooFq3SZiyaaq2EXS/uBOf4GWzmpUTUruhMFLz69uKKa51ObMezT3WhWd2rog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8783.eurprd04.prod.outlook.com (2603:10a6:102:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:28 +0000
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
Subject: [PATCH v6 net-next 02/13] net/sched: mqprio: refactor offloading and unoffloading to dedicated functions
Date:   Sat,  4 Feb 2023 15:52:56 +0200
Message-Id: <20230204135307.1036988-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: 240c7d42-d1fc-4313-83bf-08db06b73131
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iq9j08Ds8WI1jpZrJFYXvakdNCACqiaGHkT4AUF9q94Wupu6kXuE9PhmYlg8sCKK7Ym80KyVgUIfYLKxg3SH6vUMjdOKoCcBlEvYARPamozp9OYFdULn/4c545pO1IKudchaIl4BTNQOD/oCDgG3VtT51BohB+Q8p8OlDn8/oePdO37AXgthoVhI8s2UUY16gh8wRV4rLhSscFlx+OrPrlbnhafHQG5glZ9i3k9JPUIZGltqYVqJR0p+VYkbjkelEJbgZ/2vMem+2uDm2/UJvha+oWFZMK1vT+S+19CeBV/1Ab1c3mkNzrBbhWNo52iVW65YM4pL1SbRsAojWcd4ZO6AYcatooU3DAx3iPFk4MuqkiplCBRA46geP2Eu9B4U7sZbwdhOMZw/3NLf3k1WV+XswozlmH++bA0PqlTqk/KZbnr5ALrzxXaR0KYE1H4yx6+EsZZsas8jk7vN34ZH9Bfad/nsWM5jijbvkizKJOOatmra/QZEE2IBKTmlHw2a+sZ3tkEur2zQF1RRGe/MN5UlEAlziH07gHAcPobNb6lmPCL8ecm3cB5xAjt9T8jN7wpR4zyhbqGMS/32954ZNNHtsVIfeDuZOopeX+ofoxb77TEFyUEJ8WiYeFDxE0moIV3zW/zcFFs/Xt3l4hwu5FRHVJknEMVMGpZQwMlz9dp8JpDzDOD51S3oIljfX4hMWQWAJhcGRoYtKguhwCFGCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(478600001)(6486002)(2906002)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6666004)(6506007)(1076003)(41300700001)(8676002)(8936002)(6916009)(66556008)(4326008)(44832011)(7416002)(316002)(5660300002)(54906003)(38100700002)(38350700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RPBmIVy/AGS2SaZAAoa9WsePlTuk2eXfhs5z00GpIvdkmajs5FAAA51FC2R2?=
 =?us-ascii?Q?SKffgQxLqHsUcDRz2jNiT+mzgJTu2xodS5qPY6zJCDuoHGSekMTYVURGxhyz?=
 =?us-ascii?Q?DxAZvenWeciqjiVyAgKTQXZEAFXKjbHcmm7SjpjiFoZRQzTy/pH+zf8WZDal?=
 =?us-ascii?Q?oz/PSLCBhy3qjghVmRzpU38JN8qxo1g+n/uhTxapU80Z0V0s3FP97OVltvKC?=
 =?us-ascii?Q?9vku6c5AUjZHkzg9RjdoAb701LB2QkGyaeBnvguKmhkJeFAGgdpIP5pRwUUe?=
 =?us-ascii?Q?ALe1JoSX6OLoTntwklIEptuANd7WJvJmmMYtPWmJr31E5hsB1E5q6I1mmR2H?=
 =?us-ascii?Q?UyCwLo2u8enMBGgdTshpjxTIEJ0wLwyzla4LzUutViavNFeI77gs8MsK22B/?=
 =?us-ascii?Q?GdTLXu4ABDsyd6trEPAVRkxfoeOHaiqBn7yAiL4KZY4lAJStY4pfxzSCq4Rf?=
 =?us-ascii?Q?EyUh2iS2OB4ZqjwPcvIzuklUiHeyn0tcnl57hK3c7q3f1VWeO/TvEkNMrYWB?=
 =?us-ascii?Q?JK5U55IIR1G76pg+1PBc+/UUainNIb+rOAZoNbhHU4irBZXXHv0IwXe1iU2U?=
 =?us-ascii?Q?kCq9fKuwJeAfzHXTzDhAQBrxFuBiGXHiHRzEe7jSl7YUn4LrZWDNgm8LqVgz?=
 =?us-ascii?Q?uwjBszU6Zs1/aM81tSXoLtBQW4UT1UCR07Qe/RtAYl7KOkhZDi6yR8yF3TE7?=
 =?us-ascii?Q?KEM2Njb7voMMuw5J7+TXfFh/DAfH3/YSMDfx6g5mGaoNWEECw94XbDY9weKT?=
 =?us-ascii?Q?OIcAmwE0yB/AV4jXT5MDhIFWwc4Af56XTk3733y02PiNcsw4CymFSGPc9h/F?=
 =?us-ascii?Q?0XyRPbdNSehhvd8O+m7TdAZ9/1C0e+Burfd6SS9G1hKM/xYmpO/nN9u6V8c/?=
 =?us-ascii?Q?p9I0tHpuJQqtqEts/9l3xx1CQIz3qOTQPemDocWZZLU96y8b7exHh4ZZ5OVG?=
 =?us-ascii?Q?Z7PnTRNX1hA26epHy9Fse7oNvUNoC4v+E1xKGUBEcEXkf87SgjecIHKIPCs4?=
 =?us-ascii?Q?0y9uvrjxusEbb4zPTzKIy8730BOWrFQ+KkOiANPQ6rZMuIkTLI1HIwOZWrY+?=
 =?us-ascii?Q?zezky8vBk4EZpLgxa0dmma01Ftdza1gjuoHU3S4i0De4Nu+je23L4qbLvH7s?=
 =?us-ascii?Q?KzMMRObDwxlDnJm/Y847iKNcgIsYpQEyI1Iv2CODlHIN5KDcGjRvQtINHe/8?=
 =?us-ascii?Q?OXPFuMd5NvyEWti5YiVMrcZrEJmSKzb8NgMannqA8RJsxH9NhOiyO0YfKVGt?=
 =?us-ascii?Q?6lY+2Z2XsQGe8YKhdflEAEMt7Rqn9h4crt1Fw/rdUlidlbOdhNUbGfG9TkYK?=
 =?us-ascii?Q?Uak6kiaF19Z3TMbDTNeLmJErweAoEt6+Ua1+LtRzMPfRu20ZrVr9D1RnFs4V?=
 =?us-ascii?Q?KxcGvlZZ3bcQBHos4/EEIp1Wuv/DzKt3CK8OmVg/XmAvVlXxxFrv89qPiaqb?=
 =?us-ascii?Q?9S/Zg3kYz8Stij1i9s87G+IQhXRRdvXOrQ1YX/QXs3vatHGvmNA5y3fYxN5t?=
 =?us-ascii?Q?wNPbtFntOC9VwtQLgvQcx5MHXGH0Dr2xMe4A2cTZQiTq7hqTYoENnrk2YMqY?=
 =?us-ascii?Q?MOfzgHhCyGBIWi99x4ETSk94wFQTRQKalfhgH4xoV5bY+ojxzOrSOEwMnjF/?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 240c7d42-d1fc-4313-83bf-08db06b73131
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:27.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9azsdDayyANpjN2Xr+vbsL/OEztQCaAsnG/XUPfvOPrv3FT8IgGent0pJed5Y7v1RO0Yyq0XvURYHj1C6K9vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8783
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v6: none

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

