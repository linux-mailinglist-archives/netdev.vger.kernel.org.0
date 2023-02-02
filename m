Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B38687261
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjBBAhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjBBAg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:36:58 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3596E744B4
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:36:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEZioXTUlvkQzMrDw6edjIuKiM92ukPX023cKd32VkZLvxQEGeI16wmuHdmcTm8KcLEyP+aqnbyvFmZF9qvxBMnbDJHZv2yuDOn5rMwjqtFlkDL/lPRnu4b2tCWeW0JXq0YoQk1r7EVAktq+VTmi+5KexUK+HyAYSFU5i0OUU+zbAW+tBok9tnd/SaPUDMGdbXbCqS+ougJdZ4JioRpMudjRTZvA+WWKHgvGlAFSZF7IoRsw8ntR0xgVaKtKHyGJ//w+f015s+R+95bWwAlOvXsIivGXBGUNNJJwPMpNWEkT5BCRpywSnHoCkvotZh/FBDjhIlhHY4lYfYJgVrHTag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cuncC9AhLoKBsJXbQNrdK2IQvKSzZsW+vgArceErrQQ=;
 b=KsCzjZdGPl4qoth2eq0XGCVgxzjKKLOHA1HgiaSjZi9H2lDPgcEWqRHUF7yTpjT0cXIidN31dm9LhHx3u2thqW68wMqcAMltGJnLCYaaDQKo8SeKUpUNoNoBSiwHdw1M+TS2XeIl9pb4rRKDx3dj7MS7cVfya3SW/MiM0ewbISDnAG/M0NpQgzDzx9VTq4V02ZDTRPrXyV2fu5RwmNcaLUtKNLngiusc+YK9gPHU2gDTlDHb1nehxE0eQ5zXcYLX6bvDt23Ug3cyNkI6ko5VT1x9VgDvLi6rS0YmjHirN0zNrNVOkPnct2FZlmKKo5j7ViDCAETekKWzhHohvQD43g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cuncC9AhLoKBsJXbQNrdK2IQvKSzZsW+vgArceErrQQ=;
 b=Y1WmArCNJfE3l9V1qYJHYq0UHVdDEGe/sjDlrVMpSUkjWRXOmCgXJkzQz1+kUvMuw7mXhQwltO+5C7ItOI63wZ2I9lVyKxuC/giwl9brtVfJAtUzY279i6xhD/DG2BxjlTWX0Bye8oEPfaOIf6SxBPkhflaRoOF7NtdR7ec4I30=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:52 +0000
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
Subject: [PATCH v5 net-next 06/17] net/sched: mqprio: refactor offloading and unoffloading to dedicated functions
Date:   Thu,  2 Feb 2023 02:36:10 +0200
Message-Id: <20230202003621.2679603-7-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: f63db26e-a19c-4a02-a52e-08db04b593ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0V6J2fxN+QwKVRiLTCdze41FfpeQ/bIPcRjC9OBXVv6Dpga6F0d4N6gYDkgf9bbtZsa2RoocNzisUBxZc0dz/5QChds/OrtPjukafz98P8Ak+HjBlxFGZbfWjPP2Nc6yQRqPcbHLHMvFGFG69RYSwuZN5/9GFkchG/UlJWSLawrOWu3IwYEalHoBW/Va+lIxNmeqO9gv9XqwflnCwtPyPGSFJ2gDUggRLk5Jay767rQWBJQcO8kawnTc4Vu3/Yi+TL2nmZi6x/s4WFcqESz+iJCBvs2mie6Zr5Oa9PMaLrUqpCipeem+Nde0YWT8bW2rmxyefq/KGbLxy+v2Ypea0XyRe5eyoIAgJY/WSzhwssCInPrj/pt6xbeRmw3jayQEVOKUe60IjQAUQThKpgsOai/D0iqIjDpoHuMYZR1iQODjPf7tkUCV1Mrj5k6CDhV1cVlxwkwz55jeSP6BEeciOVZYjNHiPF25z9Jetl2hwuzDp9bJo6dH6r24wqnTKQCITpMFIk8D5bba/QBNTUwZg+keOJVhuW8c0CTW/t71ApibQP22mAZ+QiKwJ74QE1iloEDUX3PPs1nFWkDC42NqrZ8+yHDiLlyECRDnbk0D7/0RTl78TuPZY/k6wlT2KlMBaAe0CCV/5cxlPOQqcRW3JUzBTyDiBovDKGKzUU9x+KLXMfQW1WzIwsXDdII7Er+zruJDRWWCtVesyI6qmYd7Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QOEru6Lnflxh+VKLUSFgyG2gaDYWGPGxCUKk9k9fuOu6fkQHSTXrTIH2jUcn?=
 =?us-ascii?Q?+tsycvrzUiE7FcHEY+rI+S5CZ43EYx9pmwpg/xl1XnArk4S61nlblPQCXAvR?=
 =?us-ascii?Q?DhbxtPQaQ1pOVploGMFQlwP5CHpe96jzUiQdS0xfhR89f4WtG/S5yYoH6wlr?=
 =?us-ascii?Q?Pq3kF2uQhRoG7MCkLVQ5XTuq3BZxoETzqxzIMumhLcs9+bTS77MtfybhsiYY?=
 =?us-ascii?Q?0xEXlVCSBqCtf0Xk82vtLfNo0cNaZX83iiHTiYoEOyS9Kx2thO7Jkr11ghCK?=
 =?us-ascii?Q?J8y9Kd50yWCwxD/IpMiZcUozIrIAsISM01D67uSYeLKTnJlKuUgzJ/NVHiv8?=
 =?us-ascii?Q?zqZPugQkimdeZG3xJAJv+QQGpUmzveYqAI7CbMOo4K3pj3TZT4X6FOr8x1H+?=
 =?us-ascii?Q?qG/MIkJlxY0xowzMqAPkKCyzgV0aqyWPP0M+jk0lPsbAYGTBEIV03KlEiziT?=
 =?us-ascii?Q?jwnhNzV3h6x49duZ0lNGKkxTj6GcJN3kb7UPUgwcQuLNnXxmsv/FOaGCrv/T?=
 =?us-ascii?Q?6JzPqm1drn+pN743y89SFrKojRkQir/ESZ9sZJlkKbrNqDNC1oLj1YLY/OM8?=
 =?us-ascii?Q?60+aIz+++RspoxabnR+rS/JY8xV/0Nnkmf+2xsLuXi+9Drgki2KSGJvUbrH0?=
 =?us-ascii?Q?z4TPw/TY8jn1kdBqfo4gf0QktRGeBuLNIwnwPoMn7830CYBNw/ttIVuMEWiV?=
 =?us-ascii?Q?0HvHeIZzVNj4GwaSSOpTsHMFZ2ogurwX+15JPDnLY4XSR5Ac/xZp6gZEUC/E?=
 =?us-ascii?Q?I54+104bCHvj2pK2qMbCHKlV2uzjo7Dvu3leQl3hxheEQOumgXyecjVsMOWd?=
 =?us-ascii?Q?5Q7rMXNoMj8qraS0TKEtWzcCLj8P0JL6HrSSx/w0LHtDyMuTiloT0aBU4HcB?=
 =?us-ascii?Q?JMvgtz38rkPb8G8bxMM+mapYJZiFi3Z/Br3N4OmTppkV4COvwYCVAHz/SjJH?=
 =?us-ascii?Q?4KJfI0k31uWkgTo/dO0xkhLYD8slMk+KAwiFCn0OIXHMpItyH1H/FLJQdioh?=
 =?us-ascii?Q?KowlF94dbxO9Mj4sVNW9x7XieFjhhFbH4UzQs25s2U+r/2XarWtI7HAufYMc?=
 =?us-ascii?Q?jVxlJHNBahPTDRTYBNV/TZ94aDrxA0Q8kiynFEMzAYyF/VINXdspbEa+UiO1?=
 =?us-ascii?Q?we8I3qeCXuyZLeG+3vYlezb6PwJ/jzVl8eit5eMYZrjgf0V4hHEyliqz6RJS?=
 =?us-ascii?Q?j66dl+G4kjPSGPiYYCam+oZwwcgHTTLlX5LlCcm289QAu0iVL98tLpxEiGfc?=
 =?us-ascii?Q?C/kxwWlTH0VnJdln7ArNZYfGYgadl0+8Hr6fdnJ6ebjUgz/+7pdgTUemd76Q?=
 =?us-ascii?Q?08kiCnK8oSkV6Pay40SZsO5j9T2DX4yDa4LfNJSBmVG11+L7enpMV1OanES0?=
 =?us-ascii?Q?Ch8tijyZD0ahbFPZnUkmkRPM9lTMa7sRjEIJ5ZRR0a9FuaCHrc6dMZMgUez6?=
 =?us-ascii?Q?cDKsJdj2kg3NcC0idryVlCWFsuEJzv5yZuAVzX5AJfUbNXPmS4BXwnRfIrnb?=
 =?us-ascii?Q?5LQQlwr+X5+OsKnXwYKRBdgtxPF2JOZf0dvnZStkUS48PqLhBkoLSp8EnZTn?=
 =?us-ascii?Q?aWGoz2baKNtTcDPgk0/Z/F1xYOg7Bu5pckb6ZvbUYM+Y/E1ur4EMCDXbazsH?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f63db26e-a19c-4a02-a52e-08db04b593ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:52.4510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I096ndMyh46EpKbldpnmIb73Im8g1QsJSib+VqmQt/7QSd4dknjK4CJ3d+sVyzigNbC4GuVxuMB5CDST2yAdfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
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
v1->v5: none

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

