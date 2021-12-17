Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C883C4793C6
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbhLQSRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:17:43 -0500
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com ([104.47.58.107]:31253
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240246AbhLQSRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0yyidn3PtFLp/WG+hd/ngqqqzNo/EhdK+GDF+xuQh7ytExy5h6KMN2VIQGNGTMnYB+eQth1zQzDYXctx92HCvdEUMOg3h+4ozY5xMvFe4XbK8h0OvPn+2D1xV/DVBEPrIi6PWmtslnNSb5MsgCrBfOl/Q/W4Sx0ZP7UzgMDYyY35qwFI47kqIr0cMeJw/sbK7qHS+M4WWwf6IEEpJGvWFO5ciFZ9xYnkKcf1kXvqYyu/7zLF2i5CajNvy9Crml+ZrIJ8OAvrQbYjZg+WbNZKVLy39fQjuavMz9PcgHSJlimeR4bXctMS4ju/+0vXt6Rj7fr57OSQLNItLyGMV2fYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zRaCzaabMo/a5mPyDgj5aEQmu+wrJeuPsXUpb3w+tKc=;
 b=dbf59SPAZfSGlSsZaEmJxDLQay8oYrVcDyQNHJX91C3k+gjFa9MRx8jaKntCAG5Fc6CUJKUKS1ukFHqCe5EZWy/VjJbqh7q2vfb6AEU33eDT9/HKcW0AaqkBopzgVTMpUXfA76NzksAnpcPJw1aP/IlNc9jF2SIj7ufElxdjRIbQ0+Wq/rsWc6SnsE1z6QfJ34nt35P0oM4WjfUsjzCmy3CeuylPZ5V0T8o4BahbMlHWcbtoX37yrXJ1LuwA0LHcmI+VbyWKaTTMwn+gQbGNuIl7KHCHCS3lTfQyO9SV+scnEnO6DPCPkRkzZeEd4zKFD8OnT8wdSxeHVbYR44b8Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRaCzaabMo/a5mPyDgj5aEQmu+wrJeuPsXUpb3w+tKc=;
 b=U5Nvlb7F6XH44ItrhZwRIWNUCUwMU4DSDqs8mDuNZ09RJbKB+OHZ2KrhAoh/XExqfIioc6WDGOOFnAYhTSs1ZtgEnYqFZQ1ebNTWwxMn1jvF7qM8ag9e2+zrf5dXCiO2qkJ+/ms64fdbmARSpNWONdYQaQVhYpxjzLWdAsupp8Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5589.namprd13.prod.outlook.com (2603:10b6:510:142::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.9; Fri, 17 Dec
 2021 18:17:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:39 +0000
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
Subject: [PATCH v8 net-next 07/13] flow_offload: add skip_hw and skip_sw to control if offload the action
Date:   Fri, 17 Dec 2021 19:16:23 +0100
Message-Id: <20211217181629.28081-8-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: edda1ee0-6d01-48fc-3f0a-08d9c1898297
X-MS-TrafficTypeDiagnostic: PH0PR13MB5589:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB55891039B0AB7E6EE42234A2E8789@PH0PR13MB5589.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: onvGRJGuXi4QTIpWIuHDTZMsE/9B6IrscKbw/EY+bUElpu1plMcRikhZTqwzGFkdA9CuKnEje/+jKp5fwNEGTA+taec0SLiIouLea+W5gXTsYgY1fucQ9GMWXyaLcrhx9MuKJ+4u74ULluzNFHOit34qhzaSimIsLwnhoyE2tdHnQ6+mfG95khkoflHcEe7sgqgO2bf7+U2eOp2dzba2/dHCIZK3p9sdjEMeyTn4BUep+LrQA4VXB2gGGeYx8b+guAlChn4Z82K7+/xqb1inLnh7KlvNeY1tflKWB9uD4Mvby++2PXMUmNLm+omphjRPEQY1/PPAfCu3qu+LCViEa4BX4rno/2KEzy7UXKRSOpdaJwROwghGszujKWx47qKhw6AQ+uy7Tx/zZMk6Q38OokG9iPs9BUtnzGN2W3lLUxmUSbwuVS8dtY/6l2ldqa3CmIo8dlsm1SkG4xtB5MTqmT7en/qQzo9738u/EPObNJ8xFjYHthJY5nei/muzcNWHHFFPp2+9ukpVFJXQtf0r+52v22QgENaXJsCAjmJC/4dy/nScY2cUeyv3IYDBa7EkAZ4ZxClb9ml5QvsBAylr/QJkiuYuxGSPsR+neOb6Z5ZZ1n/xIfgJ8J26DOW6jRROolPdmGHpVqTdkIj+ZKmGUAdcduMRTsuFDRh2qMpIzghHvk9dcjsw9JKrTngZ95MR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(366004)(39840400004)(396003)(136003)(508600001)(107886003)(52116002)(6666004)(6512007)(86362001)(2616005)(6486002)(186003)(83380400001)(1076003)(8676002)(316002)(6506007)(2906002)(54906003)(66946007)(44832011)(110136005)(7416002)(4326008)(8936002)(66476007)(66556008)(5660300002)(36756003)(38100700002)(309714004)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AZS3/h35IlvLKK5HYqGC6ZStkzIPVrSqlWeaTbcvp21GDsdhDA2eYV0hsJy3?=
 =?us-ascii?Q?i9vZErDUcuw/Hqrpx0zDA7duE8vGVdmI4ePAdJs2Uw2HnxtaHVPweVhVW9Et?=
 =?us-ascii?Q?9rrx9+WyvpxyZVTRwBoxgSXG5qCGA4LoHwzsa8VqmAgvdgWkr7Jr0fbn/Qhk?=
 =?us-ascii?Q?OdfNMHPNGgo57krKWDXKuDdmwgq2szn9Em9+e0RV3yKHlpmTJVy0zFVWfB26?=
 =?us-ascii?Q?GqBDg25conZAB4q9CrDyfbb6asZkhoL0j5s+nmRMrNDRqJyhnbKNE7VWvd4h?=
 =?us-ascii?Q?V0iRGmc2LKGmN0f3J1wBdpge17p4A21AGXDmzKlR8S58ide3T9Zte9QD1alq?=
 =?us-ascii?Q?+/8iFoXGY46H/HKNa+/J+OnN55vO4xu4AMtduZOznPw4505ZwIl9TH9VnvDV?=
 =?us-ascii?Q?6qYV2xzwD9lSF4Lt9OcefiE3U207AkJ7I9W82xVXcynm1VFBIuxnRToHDGTN?=
 =?us-ascii?Q?HtL+qY5DHkc9lwbOx1xO+Np01EVmonuoC/BDPnHgSwjJ6vgyxc3J6WwqCqW2?=
 =?us-ascii?Q?MpvemhZg7n5K+M5bmG0gQqeT8AqM7k2AsJqzw95mjYAcCkdFNzxtqxAA5WIw?=
 =?us-ascii?Q?0Jj66Oo4g+PtNdff6E9j1/1tCfkT+mdj0Qzj3lEuoTwEL8BxEg61nypS5MB0?=
 =?us-ascii?Q?UaZUOkJ71QL0B3eE//P6f9+Q1R+Pa+MgqzYVktbzS4ONkRVcZNgbZE0g9FlC?=
 =?us-ascii?Q?Uu8BcHbHoUrK59bsZcY0VrBCjfiUegmV87ha35gO5mYYUrfc5qQQqjHXCgls?=
 =?us-ascii?Q?xduA8L/gY1nJohSLXhMS27OmrawRpUSSkdlBioM4887tKzmfawRANATHZ9CY?=
 =?us-ascii?Q?sGEaRiEhNtkdH7ETetEATkhphdype6MzABnHqWS5mb2I3kMVa8+z0jk300a+?=
 =?us-ascii?Q?cYJNkTCznsogSTTBna03wcLD9tuxIrSTbLthyVUlT5MLd8BGpH0cyZ6c6dMm?=
 =?us-ascii?Q?xCx/EyA/U2cXnlzqNadO3cyojAD22h3ogRJKh9nQgtskHWZ3jg/FBqVgslU2?=
 =?us-ascii?Q?MKG57oHmQyQI21CIF39wE1p0txOG7AWZWz0Vn5YjCRyfwgcwqSi0aW57cuFo?=
 =?us-ascii?Q?xzQPAZ9nLGxD+ekzeHmPHYHJzk+O+yhMRhmz6A36q69OfpLDH9e2F3688CwH?=
 =?us-ascii?Q?lkdqNOkzdqYBON5VfYvINpCjZz8kJkJzJsSwd/JhQGZoojPjyXe2f+wN6b54?=
 =?us-ascii?Q?w5u2wjajr3kzmHp/ygsjVO6JRL7CnCin46SQBjqoIpdKkHy4BNfRtmfCRyYu?=
 =?us-ascii?Q?6ltYUxB49xLYo/gc63Tp6PkpcFZO+UOrT3+0TuhQIPcdeTGBoWbITASc+guk?=
 =?us-ascii?Q?B995EEwewP3WdLAJWrPVCmswDoJPbooIr6yiyZhnwVV4X9I6PItXJ/bOV3X1?=
 =?us-ascii?Q?Mtd/2EddLEcwR3mEE/BkvnUg9yYGKzg/vibiqMbTjqGh8yyKdt9jSJhSMtXr?=
 =?us-ascii?Q?8xXsnpmpDlDSaNFJ/HVK+Tr1D5eKtSTekdL+OwaT26iVaftzx8V/p1XX4MXv?=
 =?us-ascii?Q?BMqv8P+Dz5qTcMv83uhPydvtbtPgh6NRz5ronHfXtN42QHArMlKfnOUcQf6P?=
 =?us-ascii?Q?ChDn9ZLHo0PvtjMImPhATFkNXzVlOL86MBTNtUZRA32b4DNpyCps0B5Stcqb?=
 =?us-ascii?Q?CUvFyBvKy6qGzVQtflKqnQkRNYkhBVIIL2mjYndj93BvPl4UaFHApQKmGpF9?=
 =?us-ascii?Q?Uo1qaVY5oLCbPfYplNGalvzaFL/aDmmlGKqDL8O6SIsRt9fNJTicBf2fuhWV?=
 =?us-ascii?Q?2acsA7LClg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edda1ee0-6d01-48fc-3f0a-08d9c1898297
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:39.7148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f07HfJABJNE6T63MJ7BXU2dwzo+l7OXNvChXWYL379FiHtVgisBw+wRzZsauKRGeyfiZJq0HbKs39uD2Ln42Mq43XoINbPSh/nJhQ3gSQY8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5589
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
index 5c21401b0555..d446e89ececc 100644
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
 			       enum offload_act_command  cmd,
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

