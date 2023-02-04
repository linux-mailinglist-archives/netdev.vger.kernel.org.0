Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432CE68AA5D
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbjBDNxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbjBDNxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:30 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988F9B448
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHnxT5w59DNHppYEMyV/Nw1z4xumdoladFqpkYPlb/bFddnM+Ox3XP9cIV1jFYIVq6WhaBgQSmIqtV9PSqyunRgvBOMvFDYzr4tHFJ902gLy6OKemFwheSMnNO/8tzwvD6/cD8QuBNyU6yTbQhpDoBAC/IW60ps2e5mCcAlNQ3kOUsGcRtMI9tJbYUI491cYt4xDvZVSEeAy7ZfMbTqJaMDvsWdWsRTmepRzVmPY7YU6BTeQZNRYDzgtbPCslxdRhKpavO5K2XWeRkylS5EUx/K0WhUyUz6Sm0x7oT8zVTuqVdXFM2BL4+6ys61XaLv7Ffgb8BnEcpzhLypYbO+Sag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EE5hw7FnxoPzKEIdmOSTMmIKMUAui5diJHTJ5FAYQrY=;
 b=K2nU+UDaYP9BkvyJIXVocXkjyBeTAznYBgVOPPo9lwBLo44h6HDloEyBLj1v2rIw7yOchWTCM1Dq9G0NPYeXDRGMSj3QG4NnBbAuJ3GlQpOx2Rm2raHy4veJAnvezuGUiQR7iNC5kUu4JiK3uSu2FnjulU74uQJAxM7mbtz58MHPUHynF+CVlbgvquthTLAyyDOqDOPcZVGaD2r+zyYq7uoXT5BHnQ6ytSieVP0NPgYysxNIixQjMMQd9bLhN/NJgSjTSdA+74Yd1Enu2DFmx+/yr4SnlEKPgiRMqCrAc7NxezNbVpN2Rkr2DQn8ECnZqrpVwRdVGBEjiiQbJb8xEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EE5hw7FnxoPzKEIdmOSTMmIKMUAui5diJHTJ5FAYQrY=;
 b=sywqtBQzk3AydiUOprv6Y0ASe5jp5wHdWh8J0W2+Q48Zx1pnAKX5ihU+CYx+Bv7mQD1BMS5bxwzGOS5KMqfBSASGvFLJnJzn9Bj8swzERfuaIJTQ2h12vxhnZbRa1Pc1wLz+q3Tn0qzALD7j7ISLELbzeH8JVfJZXeH9oAaLYLo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8783.eurprd04.prod.outlook.com (2603:10a6:102:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:26 +0000
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
Subject: [PATCH v6 net-next 01/13] net/sched: mqprio: refactor nlattr parsing to a separate function
Date:   Sat,  4 Feb 2023 15:52:55 +0200
Message-Id: <20230204135307.1036988-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 71f41a95-39be-4a66-728f-08db06b72fd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bxRAqFelbdD7PEwDKkeEnxeRPDbv8E56767KIRpSJ2j7rDGSk/scjVSBXOK2fuoBLi1bl5afDs/m5SABQFrPtLtf1Ew8S21DfHzn5ynmFDI7TCa/gM/JF6IDr1RpLtKpDR8frk88u10WVCSAOOb92viIalHJXw78/SXDwUzoFlUJ6ddp+fWPjPaxKNxyupTE9ypLA8BZW9g1Nz7vjtPRItgBBy1NqWpExVWdbH4sQvXrsF9Ts/XUAHHouJAmZ3fSAsFw+uUNvoOYSW6bN9BaQxNo8pTWF1Er+/1GOdESIgEffVAuUVuhd3WIg/3FT8ksnbXD8XdBRGJ9x0um7a2c6DDDoGsvkhboDFMQH7wgpE1I67GZOMMwZR5Rejo5q5RfYeRXyosxikmMwoJe5UAD4Q59msmPAI3T7fxPIwK4SZMVAdbcEkLPARddfheO4CvDw37Ow7MSF+eDpWPVOkH/w6Tx4Z1bsav0MxvXOnB7gWhPS/Lkr1mYIuTG8s2C031GpNq07rbOJQFhL/VEtANHkQPRmCAWNJSeK3hTFrQsJLcTp85CJH2QDA7MlOxaoZt1NOWkxqcnE5nEVwn0Gii243PjqJ0056ZNUioRHiEQNVUWMjHYbqbHY6he89phQ2ifyP9sD2emZsBpecMZDU9BWJ2MpEYJB16G7gqlo2i/cS5c4cia0jU/U9622i6IbzoOu7lVDcYboDhcQGIcTwFNLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(478600001)(6486002)(2906002)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6666004)(6506007)(1076003)(41300700001)(8676002)(8936002)(6916009)(66556008)(4326008)(44832011)(7416002)(316002)(5660300002)(54906003)(38100700002)(38350700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hkvqe+uz5mnq1SgoYXi9bkGW++4d1UgoopqekCv9ZD7Nc5HBBnDRrjbRFuyy?=
 =?us-ascii?Q?UQq7KNFQa/fRQoDteJkOXTN1p9ATtnm3WFN6rMf572t/ciGj26uLYWc2gAya?=
 =?us-ascii?Q?qQDtOZAg5GCbDf+lv2FG2+n8iCbxa1syTLlqNprG44VFq7VVwwEk4v3a6ILG?=
 =?us-ascii?Q?ZlTS025wFzfsDM4aQOTYdf+Z25/Zh8X0Q3+jGV8uP8m937kKXUl0OB+zrTal?=
 =?us-ascii?Q?iuq5ZMzdAtuD7mAaFMAR+l9RdicresDdMkc3VuPtRDs6b6kc8yi4DgfzN1cS?=
 =?us-ascii?Q?ENYaUKaqmAvLpxLTJTgtXjyL9cyZ88ZqXsYShouW9wvMIBKE4AZ8KHF2+lvI?=
 =?us-ascii?Q?sThHZrHgssidF+BE+jiJmdEEjd8s4ueCwvLbtN5eihpX18/oEecBpR7VLZsd?=
 =?us-ascii?Q?BnjGAPcrDabMvq/V8BGEwZVp478FVA6FUx1kpMw4NlKJZ4qz2W2NowjxUnGj?=
 =?us-ascii?Q?Smd2wG5eIo/OLxKoGDx5rgYHNy/TARDDJLD0AhCmz4vIsqc3NNOvVWNqZzu8?=
 =?us-ascii?Q?mCbtzRLpNEqQTG7fFVl1lKQEPdqzPtlYXK2HbP7r9BKUZBb46lp2kOaEpPvX?=
 =?us-ascii?Q?n3kiFx1fIORkj1Qv7jSkn6sgL1jKUzlHUekZ8SrgQP6F5SG9Jm/Z6ld7jEIq?=
 =?us-ascii?Q?dopotBi4//hs/2F07jXYqvM2h+49TMz9GYW7J54acF1xIqU/wt5vAQRyweSl?=
 =?us-ascii?Q?XuAr93z/CkfcFKBXv0ae0l0wSRIKVY0kWEqUE03RUyp1STYLOED8AoBVUNJ4?=
 =?us-ascii?Q?G0irypsem+Joc1ABRWnDcliHf9eCmJuFFA/HkIxcG4bBrbnOkUuPL8Ll6gmb?=
 =?us-ascii?Q?tJrJHjblhOv6sh+gk5tQLL852fezMkg3cillHHszBna0obx5uK+kIeWncTV0?=
 =?us-ascii?Q?8DYJsYHrjTXMWWQtujjJNT3kGdRjz4n6T9q4DwIpFJ7xtXeu1HNfscIFG+V4?=
 =?us-ascii?Q?UKZAiu/rP33eUc5LSJWnD2bfgSjSA4U4iRsmaXkrvcj+RP8QnM9nhFpH6vN5?=
 =?us-ascii?Q?vSzs9feYFlhhXblbXDaWy6/0ls4vfjQKD+xDfntrNIM2n/KBK7RUizLD9ZQx?=
 =?us-ascii?Q?UgjLYXItgvwZXXVitMaggIJcZKeexlG27ZcdrWG4iNxdev/KoH9x8nSSOjyb?=
 =?us-ascii?Q?Rm7clYWLNgyGk2rSjszSl+cX1y+DOJvfUsR3wBC4JvZx+c3v7FKyqdgWCL1n?=
 =?us-ascii?Q?SGbmSn4SwDoZ7rRediW0Ex7SEodbMU52qEBI0QOASwP/h0EuUGGUXuqz/vKO?=
 =?us-ascii?Q?ROpAlWLz9eRuGY6IPwmh1B+pItX7eKlvsYevW+BiLioGmE6+yjdYo5hNtnx0?=
 =?us-ascii?Q?uTrhT856iJGJYlR27AVT/gRs8sHa1+x6xeE7axhF1fLMXgU4w7LJWszO1AyO?=
 =?us-ascii?Q?RIH9mDpUnw04D1i7rJgTb3ZHCEBG79VHo1zpkZoE0dXvUmxWzy04c1BOr3lh?=
 =?us-ascii?Q?DcSBmbyw2E1KuliCrvCvJSpKlZWO3pT9HZeS5zrbaVdlqlQ/H3BBwLUjykSj?=
 =?us-ascii?Q?G+YJ95hskCWxuhUE3HIfLgvazwBLayfh2uqMIW3/ZO7poJuQz1FkmonF5dpM?=
 =?us-ascii?Q?cFLKkhVuv+UHQudW59aV+yQnNcaHqIqbsU8vdJgIfyKkaV6M0JlJwVqtn0SO?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f41a95-39be-4a66-728f-08db06b72fd5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:26.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zgHnMC6JPs48GPzVAiYDhEQX3VIW3suRz9IrgbvHlMVxbryi427zrgazI5I4mFHlsPwBzK/FFAUml5IuK3m6aA==
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

mqprio_init() is quite large and unwieldy to add more code to.
Split the netlink attribute parsing to a dedicated function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v6: none

 net/sched/sch_mqprio.c | 114 +++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 51 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 4c68abaa289b..d2d8a02ded05 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -130,6 +130,67 @@ static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *nla,
 	return 0;
 }
 
+static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
+			       struct nlattr *opt)
+{
+	struct mqprio_sched *priv = qdisc_priv(sch);
+	struct nlattr *tb[TCA_MQPRIO_MAX + 1];
+	struct nlattr *attr;
+	int i, rem, err;
+
+	err = parse_attr(tb, TCA_MQPRIO_MAX, opt, mqprio_policy,
+			 sizeof(*qopt));
+	if (err < 0)
+		return err;
+
+	if (!qopt->hw)
+		return -EINVAL;
+
+	if (tb[TCA_MQPRIO_MODE]) {
+		priv->flags |= TC_MQPRIO_F_MODE;
+		priv->mode = *(u16 *)nla_data(tb[TCA_MQPRIO_MODE]);
+	}
+
+	if (tb[TCA_MQPRIO_SHAPER]) {
+		priv->flags |= TC_MQPRIO_F_SHAPER;
+		priv->shaper = *(u16 *)nla_data(tb[TCA_MQPRIO_SHAPER]);
+	}
+
+	if (tb[TCA_MQPRIO_MIN_RATE64]) {
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+			return -EINVAL;
+		i = 0;
+		nla_for_each_nested(attr, tb[TCA_MQPRIO_MIN_RATE64],
+				    rem) {
+			if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64)
+				return -EINVAL;
+			if (i >= qopt->num_tc)
+				break;
+			priv->min_rate[i] = *(u64 *)nla_data(attr);
+			i++;
+		}
+		priv->flags |= TC_MQPRIO_F_MIN_RATE;
+	}
+
+	if (tb[TCA_MQPRIO_MAX_RATE64]) {
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+			return -EINVAL;
+		i = 0;
+		nla_for_each_nested(attr, tb[TCA_MQPRIO_MAX_RATE64],
+				    rem) {
+			if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64)
+				return -EINVAL;
+			if (i >= qopt->num_tc)
+				break;
+			priv->max_rate[i] = *(u64 *)nla_data(attr);
+			i++;
+		}
+		priv->flags |= TC_MQPRIO_F_MAX_RATE;
+	}
+
+	return 0;
+}
+
 static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 		       struct netlink_ext_ack *extack)
 {
@@ -139,9 +200,6 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	struct Qdisc *qdisc;
 	int i, err = -EOPNOTSUPP;
 	struct tc_mqprio_qopt *qopt = NULL;
-	struct nlattr *tb[TCA_MQPRIO_MAX + 1];
-	struct nlattr *attr;
-	int rem;
 	int len;
 
 	BUILD_BUG_ON(TC_MAX_QUEUE != TC_QOPT_MAX_QUEUE);
@@ -166,55 +224,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
 	if (len > 0) {
-		err = parse_attr(tb, TCA_MQPRIO_MAX, opt, mqprio_policy,
-				 sizeof(*qopt));
-		if (err < 0)
+		err = mqprio_parse_nlattr(sch, qopt, opt);
+		if (err)
 			return err;
-
-		if (!qopt->hw)
-			return -EINVAL;
-
-		if (tb[TCA_MQPRIO_MODE]) {
-			priv->flags |= TC_MQPRIO_F_MODE;
-			priv->mode = *(u16 *)nla_data(tb[TCA_MQPRIO_MODE]);
-		}
-
-		if (tb[TCA_MQPRIO_SHAPER]) {
-			priv->flags |= TC_MQPRIO_F_SHAPER;
-			priv->shaper = *(u16 *)nla_data(tb[TCA_MQPRIO_SHAPER]);
-		}
-
-		if (tb[TCA_MQPRIO_MIN_RATE64]) {
-			if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
-				return -EINVAL;
-			i = 0;
-			nla_for_each_nested(attr, tb[TCA_MQPRIO_MIN_RATE64],
-					    rem) {
-				if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64)
-					return -EINVAL;
-				if (i >= qopt->num_tc)
-					break;
-				priv->min_rate[i] = *(u64 *)nla_data(attr);
-				i++;
-			}
-			priv->flags |= TC_MQPRIO_F_MIN_RATE;
-		}
-
-		if (tb[TCA_MQPRIO_MAX_RATE64]) {
-			if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
-				return -EINVAL;
-			i = 0;
-			nla_for_each_nested(attr, tb[TCA_MQPRIO_MAX_RATE64],
-					    rem) {
-				if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64)
-					return -EINVAL;
-				if (i >= qopt->num_tc)
-					break;
-				priv->max_rate[i] = *(u64 *)nla_data(attr);
-				i++;
-			}
-			priv->flags |= TC_MQPRIO_F_MAX_RATE;
-		}
 	}
 
 	/* pre-allocate qdisc, attachment can't fail */
-- 
2.34.1

