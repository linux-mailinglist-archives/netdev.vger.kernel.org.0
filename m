Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4EF69CACD
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjBTMYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjBTMYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:24:17 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6DA1C322;
        Mon, 20 Feb 2023 04:24:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6+0aNYciQQQIhCokmgPM7WapN6OkqmlPhUh34d1NtsH3tyjDZrD5NFx4zL0Bo2I1xgWVLi4CDp7EFxETk4qdm9IVr9rD9hpOqr13BFNdOTn9rRXn5U1srJyLcX84qibj09MLTlazsl0K3aQGGjLFIePRyP6hXwBbVr6lQoneV4YjvU7C0Kw6FnSs//7kAatv48KTd3zJ6Icq8Z+ikRHTfBpm46WfL9ej1KIFIQLx1DiOHJpZ7ckj0atMfE/6s8Dmhc3SE/PzG8ufrIQU3dqvqv45sGKKf7dNONXWuWYzdn5XWGC+cr7Bq5e3uSsSALlSkW/9udvgDDYnJkeb61BnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QyyofujqUIRJiXljGPJ3G/lvIRLm5Yx2jXCQIilfv9A=;
 b=A84WNTwAMiLu6DkrU3/DB7arxqdO2NMw/G/ipTsmzSldQtmNCfMWSSdBOtxJ1a1C5wlCj42FCZ8flWEGISi5xZ6vd/4kzC/gTio/gRHgrqnduKQMLZ3WTSjHJqoD23wdMR6rjW0FnIasTfJ/8MQxsfledQqeUexfgeiKBj+kiK6oFiOYeocMsq9R2CYUHcEw2qg1yL1TTkOjlTiOPuQLt3Ffys83C14dZYJ8AVQm4dCNBzvaMh88GVIrsiVgJGna3h2WNiIBb2qnFHNK+T15JxM2y99zQ+6xX4UeijkcmuA8JYCvsE08EC99MDIe/BzEYZiBGd9KNMFqXwnB74+QnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyyofujqUIRJiXljGPJ3G/lvIRLm5Yx2jXCQIilfv9A=;
 b=hNDGAX7k1UbntYhSIsOUiLpShLxDxvMg4Db3d20kOADLbWtf+2UsaK6XaWc/ICku9mhhBSIEjLH1VfmKzWc2Sa7r3ys3fTaXepg4ptYJlH+5Rsrth2ULRrz6xRKJFBQx7TzkBkXOQyF621nHI63K0z90b+KLWJ7PQrTYYKfny0E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:05 +0000
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
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 04/13] net/sched: mqprio: add extack to mqprio_parse_nlattr()
Date:   Mon, 20 Feb 2023 14:23:34 +0200
Message-Id: <20230220122343.1156614-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f4ecc86-8459-4f46-eb45-08db133d5b9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRuw5s5zJEFg7hAJxfw9Geh8iHGKfMI/9DU4YLehuZo/G8EjJW+JAbNu++hcDYYE2HSyftwAhRrs3w1Bi8qEQatj7DwbAL0gZks3ZV3AiQzJeK/9Nm8l2ddWaeyP1PINzkiEEPVTRADEq3LFwKyF55uxKLcgzYdkv819JuX7EHEsyvFuNsfnVxA1Yt5FtvXLk0i67TfnGFYDbUf/72EOeczxyfvP2sBAKCuklX75uxU6ek7I6vVdkS7YZFsQyg0U/0zxJiV9odgbILVhSJmykstg3oxRYBPRCtMdSszSp6ULvYbO1wa0pOtBqt4ycuXNaD5hpeeUNH4PbOlPAN3A65SEjWMnJ9ksDLihUauOr/bEUOXz4umr3L5MTbjVlgX5TPMfAE4Mm0lqR4QU4ZD4AxiWjYRjl418+GTbw+0YHO2sGdNfmee3jqfiAhr9S5WA/7vJVt6tX98llrPTInOKfaoOOi+j/1UGtcgW3hqiIO8jQtmZ2jwrXyQgeDLQ9nosNgQG9iVgH7mBF3plL32FclRYncbj++BF6cjFCBs1dVSRWobHFRakWd8eTL7wR32JUKu2yXEiGQ/tnBzTbq999EC9DLSINgSwn5PHbUMjCg1maCbd3T7Y0c5/jZO0smjNRQ0p/6/IvMoiICjFbRIFJP6cZ7Bjp4egi7JaW75pDxvW/ikG17QAYMNxGwYQ6UHIBYUk5Xw2x5uOE2Rc5lx3IA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0fQQ69r3esQq3Pc1YJx0wLKgsByhSxuajWBe4yLerOoxkf7DGrIKgCv2TunW?=
 =?us-ascii?Q?Tv5z06QDQ8D6j+9L/MCH780grMMhUMcycEHN34JMAE1MSiDSje29wCM3GPrb?=
 =?us-ascii?Q?hypXW6G8B44WrIiO0b+ri9aD6PvIWDTMEkTI/DXBQZDcwfUgOFQVJt5Ptjo6?=
 =?us-ascii?Q?qJ8t70TBrLzOpFJUPH5+3CAyFJUAJTA6Z6P9GhTFdAQsCRAkBj/EWkkxptfG?=
 =?us-ascii?Q?4w+BjGAINMLQjju6UECbMcCKbu0Q+um0fY5n09QGKnnDRzvka5fYkQL87iIc?=
 =?us-ascii?Q?qaX1j1ZBcd2xQ91UN7zcJB5LdpSKtv1DCkML7kpRDJT5WYE8ff5ZyDeWkYRW?=
 =?us-ascii?Q?nyRzutlqHzgdnXS7Swb/cutmZpHg01P/2JHD/RBKr+tJHeaumJMRaSyeujAs?=
 =?us-ascii?Q?91bg5Y6RWeLeXwEZTdizhiAnBoKmNXKNh954dg2g4XX3FBTxOO5tXxBxfwRi?=
 =?us-ascii?Q?KdJPImGrZ0mVXFgvAc1qzztFp7JXhu6UQpdLkYZnOLFgJhaIRIjqePThAhsH?=
 =?us-ascii?Q?AngLSxGSoGf6D9phn2MWoE77H+c16eSQr9HOG7Xkzn3j+5Eju8X6UmowClhX?=
 =?us-ascii?Q?8C+J+9tmHCOjXW5OPqOO58Znhq4HCLc8GG977kenzn43qwbJ8qBpclvmGS8X?=
 =?us-ascii?Q?YrAFrj0y3YCIh79NXJb59uAQYJLsYME5SsWbDczblFBcK0tn/wRpNUbdVhPu?=
 =?us-ascii?Q?S0dPPG9fqMUUQQvih/Pakxb32+I1YEmUesQm0znEQvMubk+0r2diBq+t5pSl?=
 =?us-ascii?Q?N9qNctOi/eEyM4vXSNNFI7EGAJcQ27j4CgShc3jMKQxP4cA+fIYhEDqkqhZU?=
 =?us-ascii?Q?E28yWlOo+ahpD2wZC0aZM3Hdb6XhBOHGuwQ/MfGfJdqOVj2Npe8ZLcFgOWmJ?=
 =?us-ascii?Q?KlPCzM3o+iPNSuuUcFJ98I6EU0C6ULPDkBHRpadKDwzsFm6fF5hULLe018RS?=
 =?us-ascii?Q?caHco2gXR5tvS0vknjzA07Z4nfmFOqV7HSu678/90HqVkR25OrUOHdHEg2zW?=
 =?us-ascii?Q?OxfRUT8YTnmn8Zct2bqh8C8/FYPb0r2JLlO/KQWSbfvRkYJoxKxe1WM0VAfB?=
 =?us-ascii?Q?hE5ekcTqhnraKGlMbtjua+/4jwZpyMyGhWwwopwu5gMWmMUgp7N6/1bcoPDL?=
 =?us-ascii?Q?TVyTI02e1zRWa+NuS2cJZCLa1bTWkjjCFn0CrmGulMawleF3og+n3DYTa7ws?=
 =?us-ascii?Q?dQqfk+34W3LaKH5NDuKh5bQNNqOd2rOrHB2PO8QETpJFGAuQCGM0EXSkrrun?=
 =?us-ascii?Q?EJH/9KjvRdyiAzHPOVusN8MjpD/+NMYcJZDLCUR1jcl30iPyTMopP6kodB3p?=
 =?us-ascii?Q?nb4WJMumpARBPrUB6JE1rqOdbJPnUf37GEErDzs4eLZYaHYuWigrA/IDsmqT?=
 =?us-ascii?Q?MNCby9NwKkkOeK66HyLOjJjE4UdgfaEomUWhaIRI4Z8JjyftW9gCZdYi4r6w?=
 =?us-ascii?Q?/msk25WM43yEw3oqPHqTVU68lAZ7aEmMIdTkfq1T6YfIpwVmmkisgAwXqsVl?=
 =?us-ascii?Q?5fpb34+yamiqr7BPFeQ50HHBJRMdaVakOxyzUSVZugRSIGg/YH1lDJBLjsVZ?=
 =?us-ascii?Q?o9lTJKF5N17h/vZeX3Ml28qQU1yhBo1y5dCOAY5N3LAiP+ngdngfkd7HOfrQ?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4ecc86-8459-4f46-eb45-08db133d5b9c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:05.6187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u715lqPIu3IVgnS4Fh6Auwc/2n3naKSIui8e4IouWdzCSwd8x0kA6JpQAQ8SxExbTYmdvAgZ15hgTLM0eu5yiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
---
v1->v3: none

 net/sched/sch_mqprio.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 94093971da5e..5a9261c38b95 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -150,7 +150,8 @@ static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
  * TCA_OPTIONS, which are appended right after struct tc_mqprio_qopt.
  */
 static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
-			       struct nlattr *opt)
+			       struct nlattr *opt,
+			       struct netlink_ext_ack *extack)
 {
 	struct nlattr *nlattr_opt = nla_data(opt) + NLA_ALIGN(sizeof(*qopt));
 	int nlattr_opt_len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
@@ -167,8 +168,11 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
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
@@ -181,13 +185,19 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
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
@@ -197,13 +207,19 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
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
@@ -252,7 +268,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
 	if (len > 0) {
-		err = mqprio_parse_nlattr(sch, qopt, opt);
+		err = mqprio_parse_nlattr(sch, qopt, opt, extack);
 		if (err)
 			return err;
 	}
-- 
2.34.1

