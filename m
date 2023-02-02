Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965D9687260
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjBBAhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjBBAgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:36:53 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD45174490
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:36:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TI4j+2BEI5Ci40HqrjuvrzmM5rtqtH7DOrjRcExk7C1Q5FQwDiXPKHA1bRHv2376K5IvSzvjZk0J/v3TsL3XtrC/9/uTyiz2ThzXiSTjWwAJSn6ZLlOZOm3/AUTB5jcdX5cg58ikdF8bLiO4bxNWTbG5JYdYJG7njCd1jX4DIE2FtG20V7wrEyuOEMPvhDVWJsPb7b+W1J/V6+i18Ssx035iG52zspW/hJB3kY0zbPvImAuNr5mlzOTNmlO9Cg492U500rka10aq8kEoOD9VemmhSjCMvNpnT4KYKAldq/d3NphzsFcCRCi6YjnMj6/wf5x7/maOV4GbbwUhLgtr4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8lTB/mhBtR4Quu7d2WK+ct8sbygmU39Dwc7aGY1bivI=;
 b=hYnkIIcZUinI5bV0GUJeqf+1D8MWdcFr85yM1OHn/0H1Yl+TmwsBVRSdj56zIVw/4HPhxDeF0xjRob60tYbNiSe/KuJEVof7Tjw1GGPOwV0Hqs2xT3JpwvtmZYxqhc6Dfm6rUw+bN/OicKdrIQWBLhTXVkOSGrk18dS0g9uoJbe0g+6K1wn9zI9jJ+68NLelSWOT0BRlmsx5sCteJdWFTHiujo7BNzi4YGNoN7vuw5E5qtDsWHH2Lih7qt9WWNSqYEVt+Ps184bIXB7Z+esjVFbc0d7H7LqTYPG85piAcGg25mVF81MjB4uD4UMOguxdKq7pPfk4+XbNhwiMkX9AKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lTB/mhBtR4Quu7d2WK+ct8sbygmU39Dwc7aGY1bivI=;
 b=hdWNXOppiNriNNvAaPy4wAboVXQdjr4z5yycs1DhHEac9oI6/yuOZP3kjAi8XOo+xUvIcikhsFmoOPpQPe5LBP9L7vKAtVGH4mi7GAfQjyObHOdqjHi4LiH3iTW0U3EQ1z37kXi2zLkYhfPUyHqXWi2uS37h+LJdDCv+K4K5Xsk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:50 +0000
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
Subject: [PATCH v5 net-next 05/17] net/sched: mqprio: refactor nlattr parsing to a separate function
Date:   Thu,  2 Feb 2023 02:36:09 +0200
Message-Id: <20230202003621.2679603-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7aedc90a-2779-429b-a679-08db04b592a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /4CFS0fjTu/MUMyaGzhcFqoOkqpfkRuuEJSNACHJPKnYP7Mf3A7sGTj+RqSYUNQp+A8+OzCXWYU7W3MLlaKfhjPxWYgyZlZeM31Bpyhdf3BVyBV5zY0c1NU3eqTW25zQdZGu7si7zkpJclGNhMjSfdCamJQVgqI6MhhqS7/CYDYE8on3IbDdaDxu1GrJSC78E4W8LyTRC8/JhtjyvqQLnXrqRKeYTcn0pY88d+vlpd3yef6+0Xqaiu8sLsVcU+KiW5teOAQDx7/S5X6Qu40Yt4TTj2TpJQbNVhiQkznKbEAGMPrhdogtpyVxj8pfM0YV8imdhiBW3nHTlBM4X6uF7Kd1S7QhkvXYpI49Lda83D0DSGYeLjPPkKfEVEfgwASTSeg/rW9gfLEeLs739eQPuSY5KzzwS1k2cjykRGSQmNH3D+zXwhmSkoaM2/Ct6yn8lWOs8ljHWhQsqPX8Z87iTjs9VrwPM6RT5phyURHzwCdSt7cKnMljrE9S9k995reoWkHx26omwgcPsTfl5zKAZmvi9u5tdMKnFqdIDZeiVSw/lPsWxEo7ks2YamTQ3Ar0/HjXmWf3tDa8yZ8moDGM2kNOtahjAQSTNNBiPxQTT2B2oSrow3fy5G1qP6YpP1TewL8X+zavUvG2a5ETm5szwl3lwle+AOqALMvURRsZeIqgh0fxWPU9x5N28MVUWhrWoiUNxZVItnt4EqR5eqt35g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wVIb8kkymVWBHCo8U5arUy7Hv0jMYhb5s1ZcZ4WZL9T8VlW4BdHFfRXqyxvb?=
 =?us-ascii?Q?sEOGqj6LkA/XltDnfCfsSUbTCfdaSaXQM2jx6m1da81t1SxQwSPjuyCEZ9HB?=
 =?us-ascii?Q?qfXQnvm/jq6+bDXevMX1E4vEo7vAdId29ET9nEQNiAOHbpobaj7YX2lSbY0g?=
 =?us-ascii?Q?bT+4FaIIeLGiNjmJuc3tZCrlcryiArr/RIMINb6Hy5iV6T6dZuVdKLSIe3Vg?=
 =?us-ascii?Q?LE+Y+mSOThy6+XMQL9hvbnZyBpQJQKVetX8FPfyuzOmrhHwJtQtCOdxWbsMe?=
 =?us-ascii?Q?wRjpZXfZEaAPwUJxLl1+PGLZskD62d1k4fh01ypCe1Iw13bs2eGVf/vuvFOr?=
 =?us-ascii?Q?QbUPEawH5cnB6mvXnAWxEJhrMFJYx3OB9AZ/4WUeqSm0zNyiFU7XF37iTnR2?=
 =?us-ascii?Q?c7OBJjzUjIplyzxfFiNRwHaIY3qXGWl8EpXZt1VJAHSWW55o0WnuE9S45PoF?=
 =?us-ascii?Q?CGZtTadmezhncw8Zs/5mxOdFFBAXHiEtywGrVyi6V9z6Gis/rWCH6apDgiUd?=
 =?us-ascii?Q?hmh7LhuhCMZq1bjdzjLu0/HGNAIaPYCGuGgV+CKLbIGl+G26g9ufdHfbeKFe?=
 =?us-ascii?Q?iR09q5mRuWxNTWPpegnu5hbvgovTOc0sGn4D/61SjArbqxszIlJlEMDGIMp9?=
 =?us-ascii?Q?xu83CVPu0xiVw4WtYuNj1q6vQaxJbNuJ0dSDnfF7d0TViXM0XzK2zR/RXSjn?=
 =?us-ascii?Q?fg61li4YudxR60FWhCMHVnH3w91affwXl5GQHrnxR0B3466TT0EvMYmr8GEs?=
 =?us-ascii?Q?/sZ1bRr0QIhCV6UwU03doGlzmrhYXRqIpuSYV1ooZnyq0jV3Wemni+ksxVs6?=
 =?us-ascii?Q?ZfrXQUl4llu8ZageiylX7x0RaGMsvmgtvMeBq3hRzQYMVnmCf4A1/12GjJFl?=
 =?us-ascii?Q?Y+MPVBiduePRupczhoa1fDX26cM/zX9HHOcIdAXV9UTpKb/5BODMbISH323H?=
 =?us-ascii?Q?pVEhDBQrqRbNps5eDjiIaZfBMpoAgj6MPmOt9lJD0zolcz79TZepPRB+cjPq?=
 =?us-ascii?Q?49DWwmJ/5NS8S4IIllycV0gxIPTqgzwAJ0+QJRWoYseZ3CYcIaVntGCDB/zf?=
 =?us-ascii?Q?WzkQQAqeExnnOjNMmSZbOL9q9KzMjeYyfR/o4kicqUdRXVz3MTAZR0zaQpG3?=
 =?us-ascii?Q?WKQJFPgmv1UJctrOJXdyQT5N+3DZ+BzdzQyNSnCWKmSa1sclVYhTa3jBLAVW?=
 =?us-ascii?Q?2k7K+53TOKMbXGlLM8EselRS7pBFYdZKX2qDJVQrWDmUsxqWPlzQNtfG/IFU?=
 =?us-ascii?Q?VZrAsPY5QIatOlVPPNzGpVQRsE+kmCD3cfXwXAlDqBgruuWnCBpelDT4d9o6?=
 =?us-ascii?Q?Cpzy6EjryzJ4FGCbnBe1mbtTC7sbzebM+GCA6nyQZl7+Tw0+wFoV1A4NUh4f?=
 =?us-ascii?Q?rXAbo+a4ukDI9OZ7B9v9tghD9U7DuScqYcGd0K83jPi0V9YPqKQwvLU/cKR0?=
 =?us-ascii?Q?UZf1+3LEZ+n8SNlww6FQoqQuLGCS+L9hAwJSq1obn6xPr5QMZrgLeWDwAR6R?=
 =?us-ascii?Q?fRlA09twNiJn59oN0MZzkRGUXEexXPaKLm05jD04MUyKF4yd6YT6OQHPeIvy?=
 =?us-ascii?Q?2335RNkTCUEr/GYWTmZN09PhyyIcZZXXBkNnn06M0RTje5MuahPsRnHc8k1p?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aedc90a-2779-429b-a679-08db04b592a6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:50.8887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wSyALUvQ8M0IFGaS1h9M6VqNHlo2RcXeF7fvR0y5Ix3R5cFGmhbMthBCc5tMtWDfeOIF7/q+ehTxLbhSgNs8lQ==
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

mqprio_init() is quite large and unwieldy to add more code to.
Split the netlink attribute parsing to a dedicated function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v5: none

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

