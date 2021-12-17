Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421704793D9
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbhLQSSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:18:22 -0500
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com ([104.47.55.174]:6485
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240298AbhLQSSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:18:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CyU3E+IwA1B8VkDALyZJEAQ2mIh29Z6vf4Cr1vKi15yVfgY0UJhnpYSHJDdvfr8qhzXVNmoVlJ5duNhyP1oLGD0ZRzUABaC/5Azn6mtdCZjUEFO8NlwTMAkXVNL0hrjQycR0wRQJbgR1hb1aUZbyBZpq5u7FI2KcjhiTkgy4kbFQ+SYQC+EzvoUOWOtNdVugNBejDG2U9uR1qFhs6MhnsH3oP9q2yNGorfdOSE74Lw3yMK/SyibefNuLM91vk2yS8z8zWUJO69HTkCQ2svrUWM2WzHeQ1FkRwLKcoThPBCtygG8uR6yb88g9J39LY3GHTADk37QjWRuXwdCJnWRxVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPHztvF8ZgPBGoag2dwgHY1YHAh4emhDGws5pBrGAI8=;
 b=blacVd2h0+yRWG0GjFjYNY5zRnk9Xzvy8A/TohK6A1ichdYtjrmgaaeVE67AI3c5HakBb9qRMvdDyz5qbOJOiIDOjU5cMEoiNGcoU20Vk/n53g6wzSdBf8xVAJNr3cDSvPo1llkSJrG0XFCIPa6OMMCkXtDLJyQFPsZet5d3j9MttEenMhby9BAKtbqv+iS61uz8wxJF0xXJRfCCKAooMXycsfBTP/n/jm0cnZaCEJK2IU45fcAYQGEnxmaYPipWe6jfWPwx0a4hAon/GuuRXUgI58teVk+KG0NIT916wNlSzeHMwJ0d4pPdaMpHYsIqx/s+z8+Jqv1ke+Z4TWZKnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPHztvF8ZgPBGoag2dwgHY1YHAh4emhDGws5pBrGAI8=;
 b=L6DB5YWhZ9Jp9iVF9QseiR2b68Ry2wvrIgC7bNxE6rjkHS4dpGr5fxbOm21qAdoVV183RJlOv7XCyb5IFoSMjUbQBag48ds8siW5HxhVR2rHaR7FHpsZQAyrIiLDDXsonoUGCjYSRw+ppiMOLUhX7B/7sSqdrjsPa9Bd2cDFy9o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5502.namprd13.prod.outlook.com (2603:10b6:510:130::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.7; Fri, 17 Dec
 2021 18:18:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:18:02 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v8 net-next 12/13] flow_offload: validate flags of filter and actions
Date:   Fri, 17 Dec 2021 19:16:28 +0100
Message-Id: <20211217181629.28081-13-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217181629.28081-1-simon.horman@corigine.com>
References: <20211217181629.28081-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebfcce2e-5289-4093-15e4-08d9c189906a
X-MS-TrafficTypeDiagnostic: PH7PR13MB5502:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB55023EC0EAA603538C8756FDE8789@PH7PR13MB5502.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:16;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RNY8xYVqN8SzCruKB8RuXUdde0eMubl6fARBzjN/WP/Y2sQv61gELF4zAAjsXf3vGuQwnR1LuwuB2kQY7O31Gh75yqYGniKa8NyZqP5j5eHHRmCJW36o2mwHVc3dXA7teE+mjffpdQQj+uS4nO1kL+TdltJieK+uXWqoRb7Ltu4dDTJcuskbSP48BeZcuQ9ZUc9me0LVLjc0g3UN77iQV8un3a5GxZuNLmsWHdEPUF7FCWET1hZVYFpHXxPBCmmyeiybut2HhY3603a9dFgDvAloq32N1X9akom3rpBWk6TazPDBnjx6yqeNfKxLQXeogwMME+olMDc9GyiawGGcD94qJSt7lS1ngTiF02GEdbJuggLux1SSpbzXwzFkhlfxIauXFsCuxNJkdzwzN4zd+TX49B+qWFuEwS/1eH+zBjMSCXDGTw0ltyMwMQO/JZUlTlxZThIvX5sD4sG7XTzTQStUZmJID+CtKdVcbcWamSVdNVYWXSIpvtSU/qCmTUwVm752VZ0xTbMS35okWRNkoL/9d+fDMPzkkvxbOHe/D/DsQQppeIwd5TWoeaVhFdfPBSIatlZqzE3Shgxf3uux7sq7VE9tAxP1RruKa2H/knndH0k15z6mYb/Zr/3XgusflFqLTQiaOTy+BOQElxtjYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(39840400004)(366004)(376002)(346002)(44832011)(54906003)(15650500001)(66946007)(316002)(110136005)(6506007)(2906002)(36756003)(38100700002)(7416002)(4326008)(8936002)(5660300002)(66476007)(8676002)(66556008)(86362001)(107886003)(52116002)(6666004)(508600001)(2616005)(6486002)(6512007)(83380400001)(186003)(1076003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q5zn5G1vtc8h2AZwcbswSrxYbIEojRJ/bVORBiIgF0d9cXCyEClJ7adJSyLN?=
 =?us-ascii?Q?b5vGFwQj/av8qik/TynKFkHrKrJgcc1Mo0e/sD+ey2Akvb8nxinMMQ1T+BzH?=
 =?us-ascii?Q?oxFVK6geXH825i/xu3P6Gf1ggcvlQlpQrSHLrFfKfHoPBlW0Si3knqli0Dr5?=
 =?us-ascii?Q?6+FtGj53NeKCZuHzZhvdly1A7revEsTDNCJDBy6zwg38/f/2sPRM2Z9ogmNt?=
 =?us-ascii?Q?1bO6zOqzE7YqyObZLZCcOxrGbnVQSHq5D6nJIPshEuCv7fZJKTQvrbWIt5XZ?=
 =?us-ascii?Q?ysoJ92R4v0Z+IULLw3f5qEPCAng+JFhzR1eKtj1njzxpiiduwjuTsWkiXdmM?=
 =?us-ascii?Q?rgqg/jMj9111ouIWJ1AWpVll7On9McIjlvADZASFKHgfVb/Fl0s4FDinn2/n?=
 =?us-ascii?Q?+fGccwMws9y4PuPdocn3/NZGXWP5/cGhBfUXsdB495+1NME6pMLDu90+GlI9?=
 =?us-ascii?Q?bfa2f+yJ1UE/G70lsHg3V22x1TqzqmGAAIIquHQ3KIFKwz+/C+tKPdVnr9kb?=
 =?us-ascii?Q?4hoqfMZPs1pOKc4H8YD1sVIdk6yVpksWH9fFiAfdR7pr0PYv6c0284O6uVUR?=
 =?us-ascii?Q?UZJeEYwrwGrkCgXrUtozc6bLV7kKI6LctqTULTRyIVSCN11WdNzAxiBUUB+5?=
 =?us-ascii?Q?2OUY/1Gmz/KE9U8PqyvazYigXWc3jaNMT/SAghVqGt3Ey/z32yfqzyg+JMAn?=
 =?us-ascii?Q?RQdxiSr0wrgBROFyt0ZjX9yNpaLJRqq1TfPHSlDu9SARj8VNBlwp8u3/T8vc?=
 =?us-ascii?Q?1Rj4iiAXEEROWPhBqL8VvDKrRzfuPLD5x7MXMv8a28M7AzYH+dPuvhIjlnZq?=
 =?us-ascii?Q?yqaCbRjs2fCuNuRN137xkNYnbbU+cGY+Q6IUsv+FKKqBFiNuwmJNY6yndTJr?=
 =?us-ascii?Q?nC0y+PIeEUmu43VCugKCwNQEn9W7tBl+COOpdi0IkIQ8mOzMo29CApKPhJJC?=
 =?us-ascii?Q?QYBxDDpbY9/9jWx4zjdasmhhgyBbPlJzC6FCu4o6JJTj5FfBSs7nCVVN1+NP?=
 =?us-ascii?Q?CkE9St+m8i1hns4B6q4YNEwlDqV/0t4g0tmOuPHAbzEJ92I8DIAVzvNZq5Rd?=
 =?us-ascii?Q?66lNKu0TsUHSlQbVKsxaOJSJcSJjkvXAJvzRzq0EzV/1ruHaklDuGqS1wFFu?=
 =?us-ascii?Q?1n+L4HOV4KzBxN2aRS0rEPUi6h8GTPlcrMr/VuGeEiMcbs7WxMEXHX9hg2WK?=
 =?us-ascii?Q?7JvzpwtDFIukyOTTZRriWojcz/ffRFSs8grWQPxqYlGq4xkzctOZn0qsEoW7?=
 =?us-ascii?Q?FfBStvLRSCiab9AwHQUkSgCUXaVTSAcTyZ2rHz7LxL28wsQVVcFnkZHlRyWL?=
 =?us-ascii?Q?7EIR5OCzHPW7KN/nKdiPIeNJvOwrxVqLc1XgcSMKwClMbIiHtcmTl6OpLgso?=
 =?us-ascii?Q?x2Can0S8M0wrJ2/CgU0eEjGd0dbc5Uncnk3FXHRHHhoUadtZ+pipjWZOQr39?=
 =?us-ascii?Q?hYhmsIbkrhlO5fa5twsVeVv4pAqHbdLd4H76bmT/Qg95XiJGIDk1jijSYtJX?=
 =?us-ascii?Q?meagH0TiiqF6jHfNZke8RlQYZIKrlEDRuwKSdGMMGCcenQ18XnZgLp4BV+2f?=
 =?us-ascii?Q?zGzh/f2/v1TcRt/nItRtmh4UwIWx/xLQDNjQB137o1HTsgIRM+ES6wLt+x2k?=
 =?us-ascii?Q?FQsAAMX7rRgfX+Js8KFdcEk0rtbiwLU5xQTN3jWQzKt2iQ6a5TUgLUvzk+jx?=
 =?us-ascii?Q?Mk0F50G+Xre4egGN36M1K+ZcpLB8Py8lu3vVVh3nPycadWczL823xSWxQnEI?=
 =?us-ascii?Q?KFuotUB0Ng=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebfcce2e-5289-4093-15e4-08d9c189906a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:18:02.8890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ub05D29dmwVTBeiT0ckisKW7ApW++WsqecCYUKksBFz/rR+cfeXW7+wVznHHQ6fWWmpC5u2gpnFyIAyFh8tyQ09sOcBFOzpZzmohmSBqSAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add process to validate flags of filter and actions when adding
a tc filter.

We need to prevent adding filter with flags conflicts with its actions.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h    |  2 +-
 include/net/pkt_cls.h    |  3 +++
 net/sched/act_api.c      | 18 +++++++++++++++---
 net/sched/cls_api.c      | 18 ++++++++++++++----
 net/sched/cls_flower.c   |  9 ++++++---
 net/sched/cls_matchall.c |  9 +++++----
 net/sched/cls_u32.c      | 12 +++++++-----
 7 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 0f5f69deb3ce..3049cb69c025 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -203,7 +203,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est,
 		    struct tc_action *actions[], int init_res[], size_t *attr_size,
-		    u32 flags, struct netlink_ext_ack *extack);
+		    u32 flags, u32 fl_flags, struct netlink_ext_ack *extack);
 struct tc_action_ops *tc_action_load_ops(struct nlattr *nla, bool police,
 					 bool rtnl_held,
 					 struct netlink_ext_ack *extack);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 337a3ebb4666..ebef45e821af 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -330,6 +330,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp,
 		      struct nlattr **tb, struct nlattr *rate_tlv,
 		      struct tcf_exts *exts, u32 flags,
 		      struct netlink_ext_ack *extack);
+int tcf_exts_validate_ex(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
+			 struct nlattr *rate_tlv, struct tcf_exts *exts,
+			 u32 flags, u32 fl_flags, struct netlink_ext_ack *extack);
 void tcf_exts_destroy(struct tcf_exts *exts);
 void tcf_exts_change(struct tcf_exts *dst, struct tcf_exts *src);
 int tcf_exts_dump(struct sk_buff *skb, struct tcf_exts *exts);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 99f998be2040..b2f8a393d3c5 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1385,7 +1385,8 @@ static bool tc_act_bind(u32 flags)
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, struct tc_action *actions[],
-		    int init_res[], size_t *attr_size, u32 flags,
+		    int init_res[], size_t *attr_size,
+		    u32 flags, u32 fl_flags,
 		    struct netlink_ext_ack *extack)
 {
 	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
@@ -1423,7 +1424,18 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
-		if (!tc_act_bind(flags)) {
+		if (tc_act_bind(flags)) {
+			bool skip_sw = tc_skip_sw(fl_flags);
+			bool skip_hw = tc_skip_hw(fl_flags);
+
+			if (tc_act_bind(act->tcfa_flags))
+				continue;
+			if (skip_sw != tc_act_skip_sw(act->tcfa_flags) ||
+			    skip_hw != tc_act_skip_hw(act->tcfa_flags)) {
+				err = -EINVAL;
+				goto err;
+			}
+		} else {
 			err = tcf_action_offload_add(act, extack);
 			if (tc_act_skip_sw(act->tcfa_flags) && err)
 				goto err;
@@ -1926,7 +1938,7 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 
 	for (loop = 0; loop < 10; loop++) {
 		ret = tcf_action_init(net, NULL, nla, NULL, actions, init_res,
-				      &attr_size, flags, extack);
+				      &attr_size, flags, 0, extack);
 		if (ret != -EAGAIN)
 			break;
 	}
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 353e1eed48be..e3e26d358c7f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3025,9 +3025,9 @@ void tcf_exts_destroy(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_destroy);
 
-int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
-		      struct nlattr *rate_tlv, struct tcf_exts *exts,
-		      u32 flags, struct netlink_ext_ack *extack)
+int tcf_exts_validate_ex(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
+			 struct nlattr *rate_tlv, struct tcf_exts *exts,
+			 u32 flags, u32 fl_flags, struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	{
@@ -3061,7 +3061,8 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 			flags |= TCA_ACT_FLAGS_BIND;
 			err = tcf_action_init(net, tp, tb[exts->action],
 					      rate_tlv, exts->actions, init_res,
-					      &attr_size, flags, extack);
+					      &attr_size, flags, fl_flags,
+					      extack);
 			if (err < 0)
 				return err;
 			exts->nr_actions = err;
@@ -3077,6 +3078,15 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 
 	return 0;
 }
+EXPORT_SYMBOL(tcf_exts_validate_ex);
+
+int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
+		      struct nlattr *rate_tlv, struct tcf_exts *exts,
+		      u32 flags, struct netlink_ext_ack *extack)
+{
+	return tcf_exts_validate_ex(net, tp, tb, rate_tlv, exts,
+				    flags, 0, extack);
+}
 EXPORT_SYMBOL(tcf_exts_validate);
 
 void tcf_exts_change(struct tcf_exts *dst, struct tcf_exts *src)
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 9a63bc49104f..c73f65738ef7 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1917,12 +1917,14 @@ static int fl_set_parms(struct net *net, struct tcf_proto *tp,
 			struct cls_fl_filter *f, struct fl_flow_mask *mask,
 			unsigned long base, struct nlattr **tb,
 			struct nlattr *est,
-			struct fl_flow_tmplt *tmplt, u32 flags,
+			struct fl_flow_tmplt *tmplt,
+			u32 flags, u32 fl_flags,
 			struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = tcf_exts_validate(net, tp, tb, est, &f->exts, flags, extack);
+	err = tcf_exts_validate_ex(net, tp, tb, est, &f->exts, flags,
+				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
@@ -2036,7 +2038,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 
 	err = fl_set_parms(net, tp, fnew, mask, base, tb, tca[TCA_RATE],
-			   tp->chain->tmplt_priv, flags, extack);
+			   tp->chain->tmplt_priv, flags, fnew->flags,
+			   extack);
 	if (err)
 		goto errout;
 
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 5b9264da46f8..ca5670fd5228 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -163,12 +163,13 @@ static const struct nla_policy mall_policy[TCA_MATCHALL_MAX + 1] = {
 static int mall_set_parms(struct net *net, struct tcf_proto *tp,
 			  struct cls_mall_head *head,
 			  unsigned long base, struct nlattr **tb,
-			  struct nlattr *est, u32 flags,
+			  struct nlattr *est, u32 flags, u32 fl_flags,
 			  struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = tcf_exts_validate(net, tp, tb, est, &head->exts, flags, extack);
+	err = tcf_exts_validate_ex(net, tp, tb, est, &head->exts, flags,
+				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
@@ -226,8 +227,8 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 		goto err_alloc_percpu;
 	}
 
-	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE], flags,
-			     extack);
+	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE],
+			     flags, new->flags, extack);
 	if (err)
 		goto err_set_parms;
 
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4272814487f0..cf5649292ee0 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -709,12 +709,13 @@ static const struct nla_policy u32_policy[TCA_U32_MAX + 1] = {
 static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 			 unsigned long base,
 			 struct tc_u_knode *n, struct nlattr **tb,
-			 struct nlattr *est, u32 flags,
+			 struct nlattr *est, u32 flags, u32 fl_flags,
 			 struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = tcf_exts_validate(net, tp, tb, est, &n->exts, flags, extack);
+	err = tcf_exts_validate_ex(net, tp, tb, est, &n->exts, flags,
+				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
@@ -895,7 +896,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 			return -ENOMEM;
 
 		err = u32_set_parms(net, tp, base, new, tb,
-				    tca[TCA_RATE], flags, extack);
+				    tca[TCA_RATE], flags, new->flags,
+				    extack);
 
 		if (err) {
 			u32_destroy_key(new, false);
@@ -1060,8 +1062,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	}
 #endif
 
-	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE], flags,
-			    extack);
+	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE],
+			    flags, n->flags, extack);
 	if (err == 0) {
 		struct tc_u_knode __rcu **ins;
 		struct tc_u_knode *pins;
-- 
2.20.1

