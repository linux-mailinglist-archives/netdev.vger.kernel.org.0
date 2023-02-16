Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D31869A240
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjBPXW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjBPXWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:22:08 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2089.outbound.protection.outlook.com [40.107.104.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F87154D17;
        Thu, 16 Feb 2023 15:21:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHcvMViSQKx2hO4BfZScwZoycBSiMxKsiKc+ItqU/QKLnCbvo1ouroISzkXD11noDXZn0OaVGN5nKOq6z7q0QKwgejq0bbN6V1MJYAX6ok509FGnRahEYSw4au0szMcrd/WHmgv7acwATXhsSVtTsplStIDcFaRvLRPNNrkBbL+m7m2fObEFQkUNVFXG+lcfcU2tfVy4+6r1Qpl4JkIa6nBaGeSLIyBOn5uilBO6B62BPEpvdh1N+JU/w/taKlWLHhMKAmhtlhKrjVmzQp4M2CqBa+A23CXd6qUP0L+nF5MexM11NLAP7pEfL9vCQwlpRQt5HzeFUj4HekAbxFxTYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hN68A9dOgisiMZbohGpFUD572fa+AlUlqQ84jTWoNKo=;
 b=H2cNoSmCN78OCfMdy3VrxdTpo0pCpY4QFKh47dN9YhNkDLVQ+sB6RnWIps4SeWqFWd9or3aSLdR50KfCL+lnWEoqHsDi4lifvMptkrxTM94N7rumzK49zkkl37KdjUD7PtBH6v8O+iLHq04jibJSl8mY7Xy/1p4zEIyDi6AKM/RDAf4n+g+EsMGUrC22uGJksltpV4ddKGOQ6VA0cfXp9KacXHKEprdvVewpibOCkc5zHW4E6gxuSKkb65OcwlMe8cCCPAr6jxGMxrl0085Xu73AY6wQLBhswi6Re1D8TkZuqkX8POQwmAY2lzZmuz7DP/hU/lIyyfXgaxSHlhjFvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hN68A9dOgisiMZbohGpFUD572fa+AlUlqQ84jTWoNKo=;
 b=CTbA0viFznR9DmedONb28l0YO58iYmOSLQ21ivxX+gZRZOTjvFYrALY2Nf3hDrBdivAfy3IsHBl3dPwpIG8pXePWKZIKgwrDIXnpIdggMQXgudhHrGv1U6N2hCnEC904mN4YDG9MRU21gBUCzC5B7umAsGmgG+GXzx2x5rO9d/M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/12] net/sched: mqprio: add extack to mqprio_parse_nlattr()
Date:   Fri, 17 Feb 2023 01:21:21 +0200
Message-Id: <20230216232126.3402975-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 5703ae59-58dd-4f8f-cdac-08db107493b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 072dGNqbiZr6R6IlDXR/X3MzNUBux8NR5Xy01VImTXTE5XxrUX6qpd5M7aulXCr0MuDznIgOi1TYkgiJ5VaLAvdu9mFny0QbTzYxd1MXBOxQx/RpywJIy2B3NGdPdk9v4xn0ro3c/iLaQxNPOoH9E1IR02UIoDXmWklsY3CZag9hgO1MU2GZH7MfTmy0gC1Huj3Io9ym/CbV+2YpDE/Bm1g3UhtAMwgk1U6VYY1EE2FsGvwNUMVeYWSObDLlJG/9yUonqif89KyTpkerRS9P6LN5Qm3hTGPCp6kaMGYFRYteQO38B5WpZ2I2jasvmEn5Vb301WD/b+6jVhsElTNq1pxLyK7wKxJJ99j8akDwCCsB2A2IuXYj0/H3kP7ZQusp6hg3M+XWWCSns9qoHCKhIDb434lCsUum8UD5UoPQ2ip3i/vn/Oqjt1P/pWjM8UNvO7v84mIpOlGzizscpEadtShm0awT3QWUoGpaGFqM4VIlDEWiy5Bt+G6JL/6kOmC+DP6eEQ8tb/v6lh7pRoNRIHiD0v4RphwqCgccAC9f0psfdf1sqLM358zNqB4zY1nSRKJMwbeQD7acDWo8ZtG2mhBUzcg0Ks63OKuRh0ajvFKMCeSAtU2fbeb8OPmt5KX8AKqglJcHLlcH0pouqr4gHFUd3+aA61V2FDgzsRzA9YL3sudZyeuPy2FeegMwmjurAScBJamKep7vgyXKl+1Rog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9GYEZMd87KllhVSUJxRrSAc12tnnS50iD+YEvzDYw93mxdW5LsCCA4FpNKdV?=
 =?us-ascii?Q?+BGPCA7e6rTv0fIA3bH40wOFk2nRR8IRxSIeMjxQpqsDN75kp8D0vuQadYWC?=
 =?us-ascii?Q?qu78XzOt7Q/8sXFvdv6jnHqKUkHt0pvVv/m4Y8xJFl8Kl+7TqfGIR0kLZ4V4?=
 =?us-ascii?Q?euGAG9s/3Yb1O5JSme6Ku2jNvw1wsMW9AfZxgeyRjqqozHiCRbqLlLAhAygs?=
 =?us-ascii?Q?SMuaMN5Yk5majAyOGdEttMBMbi2lxE+qLBdyzThhMGNUXjyUlmwE2q6jgDb0?=
 =?us-ascii?Q?8BN52m5p1AB6LDpkb0PrZM/eFTeUq/uAdXzXFSJBZB5bBn8hkG4NraIlWxk/?=
 =?us-ascii?Q?ujOxmOPQVsa3S8SdK9rEgQBgjt6AnQNdkViLko4E7m3FwcYukOKRAKXEUjKg?=
 =?us-ascii?Q?aUPaxokGPWCL0DygdsiNVnyR1EmvfgmyJjm7edqCSxzQ1zhFs9/hPIxME2oY?=
 =?us-ascii?Q?YMRnNQ3eRMWmeu7UwEB2mCrCrBn6tnuK/qiSQR7/tee5f6/WFmYrVJ499Rf1?=
 =?us-ascii?Q?BJXGTEmNUBIsaFgG0Lg8zMUmUVuKP35uoc+rpn1AtIFStIvPFvltZZ1pzJQf?=
 =?us-ascii?Q?2+UIKzb3yNQ3EDCbximHdDtgEt+Ra/kT6w6eAILBPFrkS7EsgFn9nHqrsqd/?=
 =?us-ascii?Q?pNGKdz3cWaYoytJR/T7kEFlObosO6naPRfLsCr4TryKcSkegvW99tJhLEAGG?=
 =?us-ascii?Q?/FNvYF2Ept0CGhMBLudvlGnPUcQ/EU60lHc6oQeRHaR//8a0qv28HYLcuCP6?=
 =?us-ascii?Q?vHsiHqho+oST8E72vsn6YHSGPhBNqbaYF+TS52CJRpZZSEBKtY7UmABNhWxT?=
 =?us-ascii?Q?6RvnNaULk6r80Q1+ksz92+Xhuy/FqQDH7lnsV8lPtuSjTF2GyGX5J8TMVUaL?=
 =?us-ascii?Q?i4wCJPqJMtwWkZ6dv25uZ9wikEPfzUf2T/O5gsNsdJ0yzhXtVulIrdMYCohm?=
 =?us-ascii?Q?V8yOFAzKI3w5foEIsNQ1AFewK+56P09d7yS1EqJ3idSiqmSdoj4R7Pi4o/oF?=
 =?us-ascii?Q?FJZ9Z3Zds+qklYqYieRm25CDq84qEUxlXClon21Z8W6NKyiHgzvgpEYCa7mW?=
 =?us-ascii?Q?fTv26qUmxiMBoy8xRY9ecjy2V3Qu6+7hwhZz7+qnCrSiKEhpnIz6AVtE2Mjm?=
 =?us-ascii?Q?Idu9fsup9O7P2oP0XqCXBefyxSSJR/EhdLerOgwd4+8mk5O9nSZ7TMfhyPrM?=
 =?us-ascii?Q?1qeapv+UFappaqKnBdfCaGe0iVKHlRBulVvV6nS6au8x/DPtaTT58BieZZne?=
 =?us-ascii?Q?lSrnoGs2jLtADL3ia3rP1uxazt4OEnvJ6XnW0qrZZxttEfQEFhdQootE9A+t?=
 =?us-ascii?Q?Ak89pcruj9mvRRcbwRHk1yaaDHLzPxLto60fjImma672CObs3ANbtdpYFZVO?=
 =?us-ascii?Q?kZHAvs9p1jnJsEGsB0S5vjD53JkG5rKI4kYbdP715G35RWYjQ368phL9ca3m?=
 =?us-ascii?Q?H58MEKzgSa3hCXUCLEJq3jOjK4q1n0OJtjvhWOIz7M1tOz9w71U7mXCPwQjs?=
 =?us-ascii?Q?djptPA2naCM9BYzBI4So/SELuus0KMwdy9O6Rx0wxahRVpa3gswEfIIxs42i?=
 =?us-ascii?Q?xw20RfimXe0H1gVaN9XFrvkF0wCGzcec30kUE30XRwbuUzXSYR9nYsMWjpMp?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5703ae59-58dd-4f8f-cdac-08db107493b1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:48.5086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0FxYVhcn1/1kVkFUW7uK/MxvBQtfdBvmo6jQPcGXglJ7JDGo/Sc/z9q8E+GZFV9zQki9lZfz7rQPrJf+O0hDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netlink attribute parsing in mqprio is a minesweeper game, with many
options having the possibility of being passed incorrectly and the user
being none the wiser.

Try to make errors less sour by giving user space some information
regarding what went wrong.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_mqprio.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index cbb9cd2c3eff..18eda5fade81 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -151,7 +151,8 @@ static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
  * TCA_OPTIONS, which are appended right after struct tc_mqprio_qopt.
  */
 static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
-			       struct nlattr *opt)
+			       struct nlattr *opt,
+			       struct netlink_ext_ack *extack)
 {
 	struct nlattr *nlattr_opt = nla_data(opt) + NLA_ALIGN(sizeof(*qopt));
 	int nlattr_opt_len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
@@ -168,8 +169,11 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 			return err;
 	}
 
-	if (!qopt->hw)
+	if (!qopt->hw) {
+		NL_SET_ERR_MSG(extack,
+			       "mqprio TCA_OPTIONS can only contain netlink attributes in hardware mode");
 		return -EINVAL;
+	}
 
 	if (tb[TCA_MQPRIO_MODE]) {
 		priv->flags |= TC_MQPRIO_F_MODE;
@@ -182,13 +186,19 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 	}
 
 	if (tb[TCA_MQPRIO_MIN_RATE64]) {
-		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_MQPRIO_MIN_RATE64],
+					    "min_rate accepted only when shaper is in bw_rlimit mode");
 			return -EINVAL;
+		}
 		i = 0;
 		nla_for_each_nested(attr, tb[TCA_MQPRIO_MIN_RATE64],
 				    rem) {
-			if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64)
+			if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "Attribute type expected to be TCA_MQPRIO_MIN_RATE64");
 				return -EINVAL;
+			}
 			if (i >= qopt->num_tc)
 				break;
 			priv->min_rate[i] = *(u64 *)nla_data(attr);
@@ -198,13 +208,19 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 	}
 
 	if (tb[TCA_MQPRIO_MAX_RATE64]) {
-		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_MQPRIO_MAX_RATE64],
+					    "max_rate accepted only when shaper is in bw_rlimit mode");
 			return -EINVAL;
+		}
 		i = 0;
 		nla_for_each_nested(attr, tb[TCA_MQPRIO_MAX_RATE64],
 				    rem) {
-			if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64)
+			if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "Attribute type expected to be TCA_MQPRIO_MAX_RATE64");
 				return -EINVAL;
+			}
 			if (i >= qopt->num_tc)
 				break;
 			priv->max_rate[i] = *(u64 *)nla_data(attr);
@@ -253,7 +269,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
 	if (len > 0) {
-		err = mqprio_parse_nlattr(sch, qopt, opt);
+		err = mqprio_parse_nlattr(sch, qopt, opt, extack);
 		if (err)
 			return err;
 	}
-- 
2.34.1

