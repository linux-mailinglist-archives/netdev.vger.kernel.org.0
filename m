Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D696DE359
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjDKSCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjDKSC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:02:28 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4CD5593;
        Tue, 11 Apr 2023 11:02:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+depjGJc6mUe+8SvwJMREKtkUeMQcWztMBuCHBK/OcuHPo5f3stcLS5ebwGkoUwCnZstQ9c1Q942aSpe2xCBm32dUthbd5VU3e5LD9UNjzZaoOCgDxzk6l6qDfYrec9+0xEhwtF5JQYEDXcRivpT7GW2yVC/qcdmezwilIwDSk+WANubdXKdm0fLBiLMlvniWq9CW7oYfVTuh6AyX3STu3IiNH+3cfIBMOKNIx+1ejwfYBKgl92PkTsXfJI8qpR1Z9plz9jvSdlZMJlPP91a02XHVhR6cLS52UER2i2SE9I6DuaEwPfwhGDsKkxgpSoziG4D6LMzgGkHH4s735pPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4MfKnnorVexmxTPclAKEWkprWBM20wpATNp+uMF4dY=;
 b=cP0RDcLKA6gH8k12Uu0svesTgzfuUSgviHkq4EWRzhiJtja+9dvIB4FAuhZ/AF5H9ENNLHSLM9EztDxnS/H9pQrsnNwLJPjRFu5J5XSLtFA6MP2dxUgObgJz6XfPGsZafpyuDqgFzLhdifpaZj99Uwi53YDtI/0n27xWd6SBq+tsv9IaZnfKR1RdjNg1u5lrHLY8thE5MAEoXgOk1wVcxXw/YX2SZuCu9IV0HOYBXsiOOAA6wSrwODT1d1RB5uDq35M/nlp7jwV4/GpS06mcsGzTSlXXcwK/7Y50nZdoJye1rR9NBCtYtQo3/qjK510mBoWe8EB9pEUV5CtYev1EVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4MfKnnorVexmxTPclAKEWkprWBM20wpATNp+uMF4dY=;
 b=i3iQnLboKSUpuaUwF9j4wwszzbPWjKESdWWO6/7jzJE8wile3TWBbggCslZYO7CWryC+MCvibfptR045sX3YHH2Z1sQTCoSnhVwxDAREddqofYWgQY+LdDglPwFCleBT1wrMGRLylEWEUZU+JqXlup10oPGWmTMc589TZkeMf84=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:02:25 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 18:02:25 +0000
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
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 3/9] net/sched: mqprio: add extack to mqprio_parse_nlattr()
Date:   Tue, 11 Apr 2023 21:01:51 +0300
Message-Id: <20230411180157.1850527-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
References: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: c660420b-c188-4b89-a524-08db3ab6e7ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x0H/Ebw0OSvuNjvgLY3wdgmL1Z61KmCskJSKNq6GsDm8ZH27GkiFhwy1ML7acw10TsMAo1xrC1OSk2bfaEt0XWfGEraqyyfJfk83Dj1bF3flbxKnM6vb7yAhIFHBUDHxoTCd1wVARvE0uKTulxNHMYeOyZqwKSo3MaHGo+am+JwoyP1CcRnifjbVGKKMKywQFFECPfCj0lKiji4OaG6Y8xJRf2SWQcO508rjj4YOptALv1h7LHejKnkJb1q8/4dGamgZ5qMr/gCvN3gWIN236FyvGU1B/thdSrmYHrvfg5/mhxXS6HugmSC92f7nAoIfg+M0K1ltaXnLTgYxUD4g4N3E0O+d9RmTSQN9leYGtPetFzzgReMvWMUGwhqC2uKsFuS+/0BkdVrdTpiWngopKataJStt2C70FVdCfn8I5n3DpO0DifpGCvQ+IF+JT2olOtZ20bm43OggKnxfVaMZRIbjlb44e2HSeS3TN04MEg1rBCDyQD1I7cmsatI+1i8cEtq3S+a32/NmzLvzXvFVwXbRlOAY4gGqtg8GrQFagj8hMVI0aMqzn6KPf33ZnLSgfsVXVtDY2T1+1mSSXE9MNyjcUAcqmGePYo8IiZkFTkTgxbSTAauvgXxnS1wnIEDI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(41300700001)(478600001)(86362001)(316002)(54906003)(8676002)(52116002)(6916009)(66946007)(66556008)(4326008)(66476007)(8936002)(6486002)(5660300002)(7416002)(44832011)(2616005)(186003)(36756003)(38100700002)(38350700002)(26005)(6506007)(6512007)(1076003)(83380400001)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WjJZJB7JWDdWexrWpUFheuz51PExbtFz0Er8v1CbQ3I5sA6n2fSpyTGL9M0W?=
 =?us-ascii?Q?IqFIkNg3hxnOU/lo+JsV58yZNkTB7mYzPsRvr+wCQUwY1tV+E39hqnrO9wQF?=
 =?us-ascii?Q?YedorwCf5orvmdBNNMlilnNxXl2bOjnUXK6uf/Gl+kTO+In1dcwtMA4w9N6Y?=
 =?us-ascii?Q?JrUR5IaHJ1kK2QE06FKyp5BLeWGNaj8ZCCgyLXYURO7IouPntlb5F/zRR3NZ?=
 =?us-ascii?Q?bGMXCu4SVg6tXYPIoRq0JXBjP6BrSqW+vzVgGL5hW/vVKD6+JqWHsKYWKfiE?=
 =?us-ascii?Q?l4ODvY0jtwu2KLCA53FvsflNLg6wDLGhkV5HwYmAMaOLsp2PqYxr+axunx7H?=
 =?us-ascii?Q?dozCX/iZxZEbIDva9yhVhjJIsS8QuLqb5rkjUJghuM59B6CjFqNJE9xX3Y8I?=
 =?us-ascii?Q?3OUyO4u1pEoeH9z0FTrgeyq1TdaI3T/ka5yVC/iR9Qqjq6H4+UO+fCvtENYS?=
 =?us-ascii?Q?b6blirhV8E5Sdc4k8z8on9+lWxMn+T897R/9hH6KP14+7Z7FD2qhvkZivi2J?=
 =?us-ascii?Q?CG0iOV34uvHpoVqb45dksohcfYpEE1UWfEgw6tQ4cnWJ/eUffCMGY/HnZBPD?=
 =?us-ascii?Q?B56er/HZndvEnSMXgjCzQQ20KfNPpBugGjSnyHijmKcxaLxv+sxm7DC1x3Mu?=
 =?us-ascii?Q?F0ZIUbULYSB9diUsvDoQArWpLbAsl64SF87+xxApP8cAHBN/1C9PAKqlfiVA?=
 =?us-ascii?Q?uiBVDWh4P5wgalf2LCnmli9Ckv8HEsC+1QP9HYjNilZhocYvqxD3/5bWcPas?=
 =?us-ascii?Q?cYbbdHno+MKJNDLKLHrcByeoOzdLAAO6yXH8zDv0m+EBrR7PVrrrtQ+sJ5SM?=
 =?us-ascii?Q?7Np00MGFYE5N6PMXupfyOvUX7aVHlUmsuKOtdF6zx0rHZH/fsLpGLg9+wwc6?=
 =?us-ascii?Q?a7pBT73OXY84HfT7dcTx5R1kgDTMznViMcqeWYqQAo1Er5pcHBPuzARfy0Fv?=
 =?us-ascii?Q?A1+4ALFANPWMHBCTNAhigE0/blirtWUTufb0/zZBtX+NWIMeSsUxh7Gzm/cH?=
 =?us-ascii?Q?D8vu8j06hftL6FbikyRKusFMbAunK8HBKZFVRPfCLCipA7gQUwIWKP84JCPT?=
 =?us-ascii?Q?XhitI5Vse/xXM57UpPmrOGMQ7oMZa36MSDVIxkrKYLVOsnh6FP2WH+onIrM8?=
 =?us-ascii?Q?UzU0XZ8xBJpL5C2s7LB2DdJM+4yWHUnH2Q3uXn/3SCiVGwFvO8hCyu21fIHY?=
 =?us-ascii?Q?6U7yyRXwdKYrPtRGHePG5NI8KkSqric6mXdHM59BleDnApgJLdDfrRRdcb0S?=
 =?us-ascii?Q?cBknWbj2MdtPJVwDtHFj/ixUHmg9iGPt9OlreHRwgvFaWBuKuYNWq96w0P73?=
 =?us-ascii?Q?PZrXk71wu8XHwXPgEd6raYZZ+8SCSDIj85hWtuEqaKTGJjn5bSo/BC+op/en?=
 =?us-ascii?Q?UFx+U6+tGPoXsCJH1/6RQ3UPO7PtoGc8qyQJlbht3Lf5cwDfcly67T5Yk9KV?=
 =?us-ascii?Q?zUfcnOnyYdDG3YSClZ3ed8UKb2H4bOK4l0CcaEbj0jOKIeUCo9bEgPSMF6MR?=
 =?us-ascii?Q?2xht6FKC14P+arXRPr6fwSnnN8X+VjVezFq1TU3aJbdIEeSwpC3+Q4Sagmmt?=
 =?us-ascii?Q?1fAfxDZbPMebkIobVCX8CXZpX6UAUt+Wsn4+Azm+IUqeHajs14rp6eCR/Tzj?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c660420b-c188-4b89-a524-08db3ab6e7ec
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:02:25.4624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvTuKR794MPQBJBBLqxLt/JCep2u1UP8dy4mO6e8yRSMmx06ziFWekS3U62EB7E5ky8YlFc4PNvLbFGQT7szZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7829
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
v1->v5: none

 net/sched/sch_mqprio.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 89e5dfb22db6..8e8151ca8307 100644
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
 			priv->min_rate[i] = nla_get_u64(attr);
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
 			priv->max_rate[i] = nla_get_u64(attr);
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

