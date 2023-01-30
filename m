Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6D06817A7
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbjA3Rcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbjA3Rcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:35 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2078.outbound.protection.outlook.com [40.107.13.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E61A442FD
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXX74222agktdjsOzTFf+obR5hIw1k+MSZocTZA9eThIC5iHDJdAsdv1xjC11TT7eoy2oUXHN02CwU5zVBlDY7CN0rbg1EbgiLO6SMgcZiqIKPf6L93NYOUgHZXw9D5M2fA4WPE4z12O14X2M4qLjZ0qu+V+XIRbezBdZO7MDgUlCQsW1T+8q7zut9XooblP81P+Up5llmU8duP526x6Dly1QSZZB+nodBQaLE01vVyG7e9Cu5s9mAqaQMbrtToTY86jleleMmewSy9Qy0ka2lck6Gfqg/3Cf3R+X3vNMXcmddM8Z379fpPc+nlujsZEXo/rlwX5IcJXS/Xa40RsjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYkHvxq6IORixcz5knxOQlMC21se9PS6o5hIGW2J6oI=;
 b=oBYA78Eoe2HTyMCsaR0o/HZqlTGEFqz/89rwomrLUDOWNgfRxa8+aVrAgU3OdnN9809EINDnqxo6Vq09tfUXCAzK9UaGfPjdEcUKrYn7R3MLR0qgGEmZDhUfWz2Ju3O26SXRjLogffbf0YusKhql+7thRj2efwiejyWuJs+2PQ1yfN9bDr0AhysO+EVWmnx/oz6Ele94R794x/1emsT/5pQBzc71m5/I7hQxKRsmZvAtor620ohodfpb3vZMOEi83aRPyxRM5mumZdaAeMPN4HHBQSyCQRE0EO0D+HFEj4KAGJ2WdcO9fjaRcf31WWzRUoXfB1US03/V8OpHCdCk2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYkHvxq6IORixcz5knxOQlMC21se9PS6o5hIGW2J6oI=;
 b=LlwzQBnonXodtsNq4hHIQ8xC/64qGZqMhJSqSRvBg+e85WVIyo88WZT4ylXRqTWMqYtCMtRRY+xouJjHqy1gKqNIG5tZbMUwcri5FTCRfFa9YhqK2pM6kijGR5x6AI9wAdoE5skgX5802kiFAUyUJ+BaOCNujCI3Xz+ZZw5u6Ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:13 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:13 +0000
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
Subject: [PATCH v4 net-next 05/15] net/sched: mqprio: refactor nlattr parsing to a separate function
Date:   Mon, 30 Jan 2023 19:31:35 +0200
Message-Id: <20230130173145.475943-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: a251e46c-222a-40d9-418b-08db02e7ec3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XB8PpBF5FdBHJ+aJjW8MIoW562N1S9Q1CVWCQQjvy5gdq9hDKAlBIQ4lHX9d6xi/V+++4iMQbFCIf/XrlsQWIUXUqLDgRfY+HuN+QIzsjeaPPGrQR2TZzdKXStflWZj5DNI399pkwq8V7g2PjADC5qIYR6fnVDfpaJtORg11C4TS+nwqLTFkHX+KQ2NvQVu/iOZ4nm2a8nn4Hy04FsZSc0U1K11oSfR+nJt9ksU1SNN8WavDmBlkx7zPj8fsf42KEc3fY+E6VJgyCkQLfjSAu06zD1NsxX5MmkFm6tjr33YMD1o6rITk3/O5R52D2cKh6/ucj30ynRsieLkwMZ6zhwev8voc1WDja3SUwqNfnvmoei80TMYTVv46Tarb/C6nllf/c4jy6n38aE57V0LJz3+4VdZGp6H/vTKZpz7VGDBkr7QMcJlBC7v0rgAXNz+ARbKsDTf5X3azq01Tj7cD3WNJDNvHl81EVZJJUXugP2yQ/Y7TTp4ALyiPvyMob6ga6zFlU/CWseqFWJRFWd2csqLZ/JcSonLUpo8h5ilp122ROulQZnsKBa/OpN9GjEQokFaX/WyPqnrLH/1T+1GEDV951LzKzDVxLjkSa0bP0hoXwoLliJQEAPL50c4QuJFiTtT5uJU/EOBBiXYr+qs2ZVpFhDVOfA6QEo+3UXPegKsmGw/JD5vmIuaVkrRgATpMnKp5ajhrRy06pHFIp5Ycuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?63l0dar7h71Af2s5OKdyGEUMSSmjRlKCeCS1K6vF7GwSQmcYY06WMf1S4x51?=
 =?us-ascii?Q?trGggkLycWm9ZuIgrjoUrHNdvDh3Eqt6GZi3qxiPLGP5oWTFbsDW9Rl+gz3B?=
 =?us-ascii?Q?5Hp9QzN+swdUXBM6X+1UAzvp1FVPTu5nZoITIRabK9gB4URLucuUZcCnVDqk?=
 =?us-ascii?Q?6PINwmmcI5ivZGb0IkAS0U7tW8YpBYA6rsGDksyv/FyIln30vt2HCu0c6Cbz?=
 =?us-ascii?Q?csEf1UgHp0GZAoLf3ExWEZmBL3BbIfFPwAv/LMNC1k0uyGenCdPcLff2HOpS?=
 =?us-ascii?Q?pdO7AgTe9wAYcQu08L46Nz6+M+fW6pFG6Zw3G7E5xdGQ5JfQzgYhbYB+Oj5U?=
 =?us-ascii?Q?lJ/kbys/ZbiPEEP8ue8A7zK7WJICJZ0asEKcHluAJSkRWDX1nxLmqD/XjDka?=
 =?us-ascii?Q?vq31s81dFADVRKEdtsCakFalBNDGApaNVu1J7QpACUmGMOV9t3bs0GwFTBMs?=
 =?us-ascii?Q?8OHqGiDDzM+nwWHhc7awYcGj77siQUBWv+BXhZh5EsTzQIzlsIdd2E5+41FU?=
 =?us-ascii?Q?7O7ZpIn+6c0fTf7GNF3lqJZJ1zIXFQn/0vBA7hQDfsHiFqtDFVL2xtV40drz?=
 =?us-ascii?Q?YNGjbzzFGIq8LumcoUoGf9pBafiu3YseBTm21+qrgBg9PotkzP2sTSbfLVqr?=
 =?us-ascii?Q?r9JWPgFjB3duhbk2NFsQazeq/EbkT68HoIfH9rs51EVxjLq/fKHqCG3jz4FJ?=
 =?us-ascii?Q?JldRQYKCfptZOO2Ofen0tXt70J8VfkgFvLQKcjtysdawYxKEI8trLf4bY2Ky?=
 =?us-ascii?Q?itm4BeVcb7ps7bJZOuRnqk6mwCjMCLvzT5XPrvaOd0ZVrXBhuB4IqlcJejk8?=
 =?us-ascii?Q?wKjbbbNeq6BLL4vvsnekc4yfZlkSaJT9sb/47TTTYEjlCHVjTfXZHj8PU1Ng?=
 =?us-ascii?Q?w2rllrMZyANsmUZIimn2iB1zqq/FH2w49/eryAkNOAcAE/k3/1wKdaxYfNy3?=
 =?us-ascii?Q?t1QTyjZ7Kh3ij2/dkT83ivdem4lGk6kN9OGl91KDm7Ep5cCjG1hlkWB5Cenq?=
 =?us-ascii?Q?6ka64lLajWwRI1+Mnci/ZyIjaORnpTgFZ3fUj1s6ktoB6gmsR1SZxe7DhlUG?=
 =?us-ascii?Q?C1cEOVVIcDCTAn9UZo49JZnjbKXlvJhP3MDraVDB8/cgNq5FOYVWbg9E2qgq?=
 =?us-ascii?Q?KbNJB/2svIR7U/7cOYovYnV1gcFmH1l9IhlDKCrfh3WOimPcthVbUcQoY9EJ?=
 =?us-ascii?Q?CtLU3AIreQljlE6iQSlVodBNCnetXJ8wBdDxoII4wzYXiENEtfMaZx9QTAik?=
 =?us-ascii?Q?v8bVu9u9lDz7F4EMt9Tx/7ZtzTEGCCD5hDb48Y18eqAa58WaDSPhw/5OiYOM?=
 =?us-ascii?Q?9YtQ44b88KInO0rqfXKOT/e8i+3WdXD3u2ERSeiMoLX2wSNDXe61vQweaffM?=
 =?us-ascii?Q?9cBaqXSt3Qe4IP488XuA0u393CKQMeH1ReqD0bOiPdBp3FzDoxS3YwDRm2U4?=
 =?us-ascii?Q?R7ONlHQHK++S2h8VGKBX4fXPIw/IVA8XqAw4aiXGieEKwN9i0YHya1Z+zjJs?=
 =?us-ascii?Q?Fvfx/sT5ZiYfIx4pCfnmWNDe2a9hd06NQ0m1PNV76QalUQ3PS28CC9rJ/xO0?=
 =?us-ascii?Q?KIZbwG80yZH0qd+GMjmczTjMHL/VMKLG1x2G8yhvbMJHlW0jQ4GIr2G489yd?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a251e46c-222a-40d9-418b-08db02e7ec3e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:13.1323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9n2vUf9UXPWHqYWcymfZSm6VLo/8RFhDs+dNNu3sE+IWYDGp8UgC2stTHc5RcDDA2TplCI16/SLTXnMttOTfkA==
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

mqprio_init() is quite large and unwieldy to add more code to.
Split the netlink attribute parsing to a dedicated function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v4: none

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

