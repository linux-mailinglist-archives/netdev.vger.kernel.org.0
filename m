Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA52478DA8
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbhLQOWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:22:46 -0500
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com ([104.47.57.175]:23036
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237331AbhLQOWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnkYUvm/MFKRBxHsKWxnq7762inc3rYatEXNwVFqViqGlfClmEkV5PVNyNAIHiMJk5C/LbtW8GUwYScLYpVzVYqU3//kw2qyiQIltLVOJ852mK8SnZReCEiRCM7c6pPgyqw1w8sU2DZYFx6bGGyobP8O3EzDsgubb9uxRf/K1dbB+ongiY4MZJuhLy4Ze6nfhBDVEholtPuGK4akYx6h7cBHph1w9O/2Uwn35v71qQGIYou3mcBsthxV4wsKcgK6U/4gfaHl5TaCPYUJr2zMkYdf4ZGJrZcNSzTk5Z4U7cTyeqQCWEfC1VkaiCiVakVbOoSQLYbsJr1pWZPOb+GHsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hOUt66RXSz1uzkp3TRVkfAKL4KcUGHfDhag6bT9EoA=;
 b=kWv56kHYIlm6rXu3n3O3G2oWR4SnaZNnwIDRKg9esmbc3SAdUFfQ/Hnyz4WWpNlQ55ikP41jvSCzoPuerNGzup9jZrWDt8v8qVMLIiSsKriWhPn9T7U5qHEH4YRiORY8g9XgErL8XNg4hWa3ThmZICA45Jm/XCaYrm2joDJQWutAeVD774L97HKFR+mV6GlOKV1w5uqQDVY+4TKtcJuLdQn+yUMCufrnYABuCc30TBE+HyhlsGScGgAFaTGd1il7P4FSSSN9ydCCcoXJ1NU+rpCep9YZ6wwDlB0nfWWlQ5M+74SVODu/iWALWBItf0mXQNgs+/3lhuxgWW9vkVkZSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hOUt66RXSz1uzkp3TRVkfAKL4KcUGHfDhag6bT9EoA=;
 b=pd0YG9y4oKj+olrflPFSg6LkC2amaT5QImi8SQO9wGIF8/z8CKsad5M7QyMk5bQS++bBN0Y/dNjh9yt4m6vSYoLhrMG0utuNBpj8J5my0TS/xgDS5BRvUjRfgOWUhnF59N9XHeeXSr9hSLYFMnTiPNDcQmfYsQzVVeYmyBWNOnc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5595.namprd13.prod.outlook.com (2603:10b6:510:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:39 +0000
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
Subject: [PATCH v7 net-next 07/12] flow_offload: add skip_hw and skip_sw to control if offload the action
Date:   Fri, 17 Dec 2021 15:21:45 +0100
Message-Id: <20211217142150.17838-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217142150.17838-1-simon.horman@corigine.com>
References: <20211217142150.17838-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01eb6ca2-241f-41f5-e69d-08d9c168ae03
X-MS-TrafficTypeDiagnostic: PH7PR13MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB55953B6025272FF837191B9AE8789@PH7PR13MB5595.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aBLBNtuYAcPq+JTRKKnJKHLzdpJq/bwKZGBdP+beP+TS4idAJucI6WAi03IM6cjryOr0+wp5AXf5iohSdEPmepl5joB5G5hnEGazY9mdmIoiKl6KLBeXjGd8rVyObIEq2mTYQQXpltiQK0OWKhLCB+K0sWYbmXpjf6wrYUeW3tErMttQUmC3zqUJGa7x0SShEfIIaboqowpfg0KOkLF2t8f0p0kyiMeMq+FOhbwH7HO11dQXEpg/8KN/CeGC3zR21FNt5Cz9k6JbQbGy4t/MiHH5a++T7WcWmuJ0EwZ0ku6ipfrJgyeDq4pIg0Rj8cyrWu7CBB610Kl9jn2NSey4uAhTMJuF2D6MViKGRPufGpefyF6eNKlZTYlSvnTZ5WD/3sXxabzpkITsyqtEFGP2dP2dsHsono1VStdzPowEc7WumoPq1l3jOsY818cKzUaCbfmogLI7W/5GkpAyfODupVr4p+zt59msIHmjDeDpxUnIy3JwRIY42KY3IiuRrYDSeX6Bal/3fhPAu8uD4MlxFqLSuhHeufZXKAANuAGjKmnJs30CJgiBE3WVNLzqQvxaJKrJ5vWL1YdRqRwW3D59sNlH7NyUmHL/Do9Peg2e9dMKL6gvzVpZdZQD+jy5CFNcZV2hPebLAAJtoqhX0ktlflSenw1rXdF5J51PQPoexukhoeczRpaAa4RqRajf0I0kSTC3m9CqgU33n933OV5PCQ86SbXVvyrnpzbLGuMmgm8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(39840400004)(346002)(376002)(136003)(110136005)(8936002)(54906003)(8676002)(316002)(66946007)(66476007)(7416002)(2906002)(66556008)(4326008)(86362001)(38100700002)(107886003)(83380400001)(508600001)(1076003)(6486002)(36756003)(6506007)(2616005)(6666004)(52116002)(5660300002)(44832011)(186003)(6512007)(309714004)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WJLyUgVO0HIbR6qssyWsHSi9V+l5pdFj1t1uRgSv1yxITw8zinFmAGU/9LhL?=
 =?us-ascii?Q?Msr02RZfvu52M7Og62S9FMnL6CrxT+cGj8y8zMZgtDjqazCa3ZCj4XMv8oSi?=
 =?us-ascii?Q?kQC+k7GP7KsembEJ8RDS5ykQVB1a70+KfhIyX3/maHOdS9bE+wvnYicFRy2K?=
 =?us-ascii?Q?tXyBEQmrkWf94aetA2TFG0ipW9qBuUWxE+tlWIb1TI8kQ/hLXMFK2qOv5MsR?=
 =?us-ascii?Q?WYW29vfGUleEyMQNm8Spk1+0sZT5F9Sfu6323vWAdejFPLFX9uP92T/9X51K?=
 =?us-ascii?Q?2wD7wn6h1PLUN5WrTZhfbgcayJbUZ2UnM+SUIWZOKzqIcRFaoaUqufp9cub2?=
 =?us-ascii?Q?qAn50bP/Zdb6JaLlwCHk/OAot8T87iEFduR5qX4I5ijk7TembkDbVIlnD8Bl?=
 =?us-ascii?Q?wAhE/TZy2T3BgsGVHeCcJDofDwj2CTo3TGyHhQfWMoyewyCbJupMva9UhE7a?=
 =?us-ascii?Q?i4u0oBmMur198dZwZ66T8i/rGh6zXIhQkz7xUr2UpK6YBRsBPIYM8ZCMOtS/?=
 =?us-ascii?Q?QvEex9cfvKmZzesP4QOi7uRmyNCdHY5K/ufklYeZiTaL/8zQt5CTyodBethe?=
 =?us-ascii?Q?R7Kd6F7GumjWMX9jPMdW2a3fqeURMjH7GGUaSJc4eZMPSV34MZbvdN+NMOuz?=
 =?us-ascii?Q?MJw0cY24fLpMboLm3XH18/0WZ2EpjiBjNV/i8PHa8gbWFDL0ea4ZOK7sPTqb?=
 =?us-ascii?Q?317UMC4SSXaMb5vSJhJ7+uLT5UVl7O1+/mezRUqlCivMTZ8nJbc1B51Inaew?=
 =?us-ascii?Q?KZIAedy9ykfKfDtbxQPoIeZL7PxLUNE+f0t/P4KTZNMu9ruqyHT2rFaAjzZv?=
 =?us-ascii?Q?MRb/bMS8SL88GMr+Q0sHWdFiTQKPkinpq9GnJUzU54bZGwwMKDY6TJ2YMeEo?=
 =?us-ascii?Q?yClmpqL5fns0vberhY8oyBSo8Mr5NNzUYoHUEPLw60iWbeosPFqwFRqGd+Pa?=
 =?us-ascii?Q?fu+FcC2YnNWuGZn1xwbX6CdAH+c/NSJrua3VcgyZm+lkr9DsxmRpUUuzRlvD?=
 =?us-ascii?Q?rwppvKOsvYoPQzyIM7wfX+cRwFEz0oFhu0v7NwncDOoD+9EOYvtvJatNrTn1?=
 =?us-ascii?Q?MhtL3hDmXzT7QWjEjxSoIILfEPOGWbCtlXko+DDD462d5WZaV7SgVm9KvTs5?=
 =?us-ascii?Q?UPku2xxi8z4UNn+jj0LSxpXNJcgFkg3OYRikyxucc5S/XYYWBypkpeLznPVo?=
 =?us-ascii?Q?h4RcV+zUgt7HJU4Hus5sBOhWzFYDS695iqpzpSRhxJHJmbwg2BcBKuJpRgz+?=
 =?us-ascii?Q?RLLihMfPUtsxJcr/m3V3Q6c1dNiNokEI8Y/O+Mg5CqG4e67izH+hG1BiYiXn?=
 =?us-ascii?Q?cyibSPfTgBHNzdquP0N3q9Payxlk5bq5JWQJhgr6mxKXHOGt7Eh+Km0u+5ot?=
 =?us-ascii?Q?gFVw4yi+JkLfhUB83QOVukDPEiyZXjd5atEPkxRBZ+pwzx+3PMESmOtKeYrh?=
 =?us-ascii?Q?viYgQ/t9N25tATgnnplFsgRLpaTuDGNF2132wFjRFivs/FkmRPk/nfzuCNZx?=
 =?us-ascii?Q?ARNOq3ktShRVNMrXl+uYli6LGdN63IWvp/076SZKWZWDdCec2Im2M1PBpbFC?=
 =?us-ascii?Q?qzhDCjXEHMB3G0H9BlkS68wQ+3T/0D4hkqgrO1uoPOdQhvvw80LSo/Og58yI?=
 =?us-ascii?Q?grwh9rwDbs5L9L13bPaYxlLfwbyrHIINPJPj1/2193ifP7B+zQtV7AeXXChL?=
 =?us-ascii?Q?wFOMInGXFOwzLahCN8/Ed/ee9qExNaKfRrk4T1IrNcvQ+vYLqlN2VfOXO1tl?=
 =?us-ascii?Q?znjBFJnu/g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01eb6ca2-241f-41f5-e69d-08d9c168ae03
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:39.1848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nfPFKuF420FgghWHlCyVilAPT2stoWTQFm762G/CMRx1ETRjkLmqkbR0qgwMN01IdttcmKklrIcey/tKvJjTmklUB11PFwF8Mtt+Gj7jFOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

We add skip_hw and skip_sw for user to control if offload the action
to hardware.

We also add in_hw_count for user to indicate if the action is offloaded
to any hardware.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h        |  1 +
 include/uapi/linux/pkt_cls.h |  9 ++--
 net/sched/act_api.c          | 83 +++++++++++++++++++++++++++++++++---
 3 files changed, 84 insertions(+), 9 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index b418bb0e44e0..15c6a881817d 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -44,6 +44,7 @@ struct tc_action {
 	u8			hw_stats;
 	u8			used_hw_stats;
 	bool			used_hw_stats_valid;
+	u32			in_hw_count;
 };
 #define tcf_index	common.tcfa_index
 #define tcf_refcnt	common.tcfa_refcnt
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 6836ccb9c45d..ee38b35c3f57 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -19,13 +19,16 @@ enum {
 	TCA_ACT_FLAGS,
 	TCA_ACT_HW_STATS,
 	TCA_ACT_USED_HW_STATS,
+	TCA_ACT_IN_HW_COUNT,
 	__TCA_ACT_MAX
 };
 
 /* See other TCA_ACT_FLAGS_ * flags in include/net/act_api.h. */
-#define TCA_ACT_FLAGS_NO_PERCPU_STATS 1 /* Don't use percpu allocator for
-					 * actions stats.
-					 */
+#define TCA_ACT_FLAGS_NO_PERCPU_STATS (1 << 0) /* Don't use percpu allocator for
+						* actions stats.
+						*/
+#define TCA_ACT_FLAGS_SKIP_HW	(1 << 1) /* don't offload action to HW */
+#define TCA_ACT_FLAGS_SKIP_SW	(1 << 2) /* don't use action in SW */
 
 /* tca HW stats type
  * When user does not pass the attribute, he does not care.
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 207905df2b9c..073461d9eacf 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -131,6 +131,12 @@ static void free_tcf(struct tc_action *p)
 	kfree(p);
 }
 
+static void offload_action_hw_count_set(struct tc_action *act,
+					u32 hw_count)
+{
+	act->in_hw_count = hw_count;
+}
+
 static unsigned int tcf_offload_act_num_actions_single(struct tc_action *act)
 {
 	if (is_tcf_pedit(act))
@@ -139,6 +145,29 @@ static unsigned int tcf_offload_act_num_actions_single(struct tc_action *act)
 		return 1;
 }
 
+static bool tc_act_skip_hw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_SKIP_HW) ? true : false;
+}
+
+static bool tc_act_skip_sw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_SKIP_SW) ? true : false;
+}
+
+static bool tc_act_in_hw(struct tc_action *act)
+{
+	return !!act->in_hw_count;
+}
+
+/* SKIP_HW and SKIP_SW are mutually exclusive flags. */
+static bool tc_act_flags_valid(u32 flags)
+{
+	flags &= TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW;
+
+	return flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW);
+}
+
 static int offload_action_init(struct flow_offload_action *fl_action,
 			       struct tc_action *act,
 			       enum flow_offload_act_command cmd,
@@ -155,6 +184,7 @@ static int offload_action_init(struct flow_offload_action *fl_action,
 }
 
 static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  u32 *hw_count,
 				  struct netlink_ext_ack *extack)
 {
 	int err;
@@ -164,6 +194,9 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 	if (err < 0)
 		return err;
 
+	if (hw_count)
+		*hw_count = err;
+
 	return 0;
 }
 
@@ -171,12 +204,17 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 static int tcf_action_offload_add(struct tc_action *action,
 				  struct netlink_ext_ack *extack)
 {
+	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
 		[0] = action,
 	};
 	struct flow_offload_action *fl_action;
+	u32 in_hw_count = 0;
 	int num, err = 0;
 
+	if (tc_act_skip_hw(action->tcfa_flags))
+		return 0;
+
 	num = tcf_offload_act_num_actions_single(action);
 	fl_action = offload_action_alloc(num);
 	if (!fl_action)
@@ -193,7 +231,13 @@ static int tcf_action_offload_add(struct tc_action *action,
 		goto fl_err;
 	}
 
-	err = tcf_action_offload_cmd(fl_action, extack);
+	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
+	if (!err)
+		offload_action_hw_count_set(action, in_hw_count);
+
+	if (skip_sw && !tc_act_in_hw(action))
+		err = -EINVAL;
+
 	tc_cleanup_offload_action(&fl_action->action);
 
 fl_err:
@@ -205,13 +249,24 @@ static int tcf_action_offload_add(struct tc_action *action,
 static int tcf_action_offload_del(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
+	u32 in_hw_count = 0;
 	int err = 0;
 
+	if (!tc_act_in_hw(action))
+		return 0;
+
 	err = offload_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
 	if (err)
 		return err;
 
-	return tcf_action_offload_cmd(&fl_act, NULL);
+	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
+	if (err)
+		return err;
+
+	if (action->in_hw_count != in_hw_count)
+		return -EINVAL;
+
+	return 0;
 }
 
 static void tcf_action_cleanup(struct tc_action *p)
@@ -821,6 +876,9 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 			jmp_prgcnt -= 1;
 			continue;
 		}
+
+		if (tc_act_skip_sw(a->tcfa_flags))
+			continue;
 repeat:
 		ret = a->ops->act(skb, a, res);
 		if (ret == TC_ACT_REPEAT)
@@ -926,6 +984,9 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->tcfa_flags, a->tcfa_flags))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
+		goto nla_put_failure;
+
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
@@ -1005,7 +1066,9 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
-	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS),
+	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS |
+							TCA_ACT_FLAGS_SKIP_HW |
+							TCA_ACT_FLAGS_SKIP_SW),
 	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
 
@@ -1118,8 +1181,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			}
 		}
 		hw_stats = tcf_action_hw_stats_get(tb[TCA_ACT_HW_STATS]);
-		if (tb[TCA_ACT_FLAGS])
+		if (tb[TCA_ACT_FLAGS]) {
 			userflags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
+			if (!tc_act_flags_valid(userflags.value)) {
+				err = -EINVAL;
+				goto err_out;
+			}
+		}
 
 		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
 				userflags.value | flags, extack);
@@ -1194,8 +1262,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
-		if (!tc_act_bind(flags))
-			tcf_action_offload_add(act, extack);
+		if (!tc_act_bind(flags)) {
+			err = tcf_action_offload_add(act, extack);
+			if (tc_act_skip_sw(act->tcfa_flags) && err)
+				goto err;
+		}
 	}
 
 	/* We have to commit them all together, because if any error happened in
-- 
2.20.1

