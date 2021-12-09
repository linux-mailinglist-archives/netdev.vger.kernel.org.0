Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F307046E591
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhLIJcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:25 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236248AbhLIJcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIC8AuLX0f8+wGa1LY11ZvZNacx71cAg71SyzC8glYjvqRZ6XYpFAjQCW4RztNW/p4V7sKTbD9Co/+ASppgTQNcxwJ1DktdfJgRC25w2YwbM62KIOkEJmRJnPCGSnscd9w3t5ImCZqe44ur26EU27UwMR0zjZwek3FfmBpUdyNg575kPe9lZuW+2O5p8BL8Vg1pIQPNElzUp6AGWrN/z1+iFKlMDWxXWZ/NzI2scmYzb5G413NrZYtGSlDMuMcev1sljLfCOZZ8B5fuvdHwvxsXGmYa8IXezf2V4oAYvGe/6QnMUUO5jp5ChCDF3AsWaVHgVT5vquQ/G26Mp5kFu+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2OBkj9X5POozdYrp2fPiEE+HrGJUsKKXizHoCL0ZFQ=;
 b=PzTi82T9b7Ti19UOvqkZtaA9b/x7p4n+SY2yhT2t79TdqB3XnNxJ89NbJwHYg55zwJdjs0fzTht3eSxVF8HfO0oUFJ8Tj1t5e83rKQLhekUN/xlWLPshgwGlZDfvOhj5/MCh+VD3CQrlatHzc8+VyC2BbJpWQB99Ih25aI9Ph1MQF9tAHSTwKH7pMKXHId13aQm/EGIkDjlGWmAtATBHLgMh2Z/MZ+v7eiVwKVfu3S9pjrk9XeDNVLZdJIk4yL/aILMM7Kxe9lbCGIMB/4TBvApd5YsntO/koVLX7GfpWJ8hKLCPhyJ1gzgGIFZr5Gc0pZ58UwuJa+dNkaS22SQHRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2OBkj9X5POozdYrp2fPiEE+HrGJUsKKXizHoCL0ZFQ=;
 b=XCeRnsWVQfuIBWjr6oPu/0r6pGMJNjFq5NflJCMV59MlWY5uh9wQe9z4RgmYnmcSHO188AuHqw5p0BGD8r+TyE5Xah/dUsq+61OY1Tv81aF8+1Z4JRck87KMnv9RkG3je4ls9j9OesxeekKpcLe1fveZyzAnCFhv2yaYDfksKO0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:44 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 07/12] flow_offload: add skip_hw and skip_sw to control if offload the action
Date:   Thu,  9 Dec 2021 10:28:01 +0100
Message-Id: <20211209092806.12336-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b1358c5-993c-4a70-cf60-08d9baf64bc4
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5494CC920616409ED8FB1FD3E8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8I4aOGVm4sg2auJ4Ghmy0v9qm2OuEyfB/mvCh+8u65Gxp55VxSTZ4UI+gr0DFJhj5q3aHeg6Uym8n54ORssAwHQzinRfYpHfLYRFY0VmxUTsLP5axCikWtUTMGCt7EwjGn8J74438AirIl7qmRJFW5v3n9zdCnpDvC47qVuvoAzck9nbaU0QjErCZb6eVeFkQC8PfiD8/Ph4r0yW79XbDtVuY18GbffeRz6301T796Jwf8ZkANA9wOX6bDsy2pLy0AS4ONecoHtwikWkX76f+S4/Ot2ZZPSvMmDKu/L4BtqpEKvmIYr0tY7hKu9qlGwy5/SFlktxeFqvAv18wSOQywgDMTKlmo0Jnb6CS2l8Q0RvVXeqxyLaWRC2kohFf6guZUB30tUhuRiva71LZfqx3j2a/MM5NPq9kBHfuc164UiXOPNc+lDQcABU8uHju1iRKhbv7dkXg1PaxuwrpBcL4U89gYlYCAk5traryqLALLmgC5RTPWMIl7Hnqg0tFtkW2IlBlDlcFNpaiozdO8o1TNZjc65FI90/rYuTcteUxqUGfIVgkehhwF4/T7lIUoULwnJv1d7hogNDQ4MCbtP/O3WvwwsdoJ8U4UcJZZx6sBg1J6ktoLRLn6iNw+V7McVC+EAF5Z7gSuyRFe7k3tIfTHZVZCc8MIG02nKEGPJDtE/CZ0l4feUyAL2wjICchZgIZsqgMTd9uWdHC8+UVq7sQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(86362001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(508600001)(54906003)(66946007)(107886003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nA9fEuKZifb77dSS+FIweYUautE3iULN2G+npcxSTI5W36yiaLKMguzjnWfl?=
 =?us-ascii?Q?NXCQ1ad1g1S/GYyuM876pGFhmQrfJc4kx2ZqG3hWrgxcIw5YhayJYP8XKKfB?=
 =?us-ascii?Q?CWo+3ZKm3KEUBD6e4VBh+PYsmu8+GnempSsHEtzeyVBTa26z9k5rIpXwDBvp?=
 =?us-ascii?Q?HLfM1IOhMBVNeMMGH+XLglQOIvBnxydVm7ombtKwHoFe/+woszkCbJtgQYhj?=
 =?us-ascii?Q?ofnF4tWH+Nq7PoGSjmy02xJ8M+xpyZzJh2IacXirpFUJYSAg+aXKTq+YflLU?=
 =?us-ascii?Q?LAZqiuz3+RNBcmtcXKNolJCRRreg/kh+DO7CgIvfssEzRx4pk0Y254tltJTp?=
 =?us-ascii?Q?O3oXvkPtmzTaJhAJLobSTfCpcOplE8bpXQeA0+nM+s23SNDpLvPlS866EGxP?=
 =?us-ascii?Q?Qoh4V8Glfwgvv6uxWe5wWbDaO0WKc11ObtPRsJbAeSdXFZrIwE8bRQ4D3u6F?=
 =?us-ascii?Q?7kfEwa7Vpk0D7dybGSnbh/i3hH5Udoemi5BXX7tFlynNexAd3Y0LIezbF/sW?=
 =?us-ascii?Q?sLFvP04TiYINTgCrObeApgvkbBXYTCAjPlynTisyCFcr3nSQ8mCknAhhfxdz?=
 =?us-ascii?Q?YojlPIZdFqJ9xXQnucAa+C0Sr9Cb+3/eV0eBQgEfqkcFXzIG7yTmPyU8llEn?=
 =?us-ascii?Q?UTfDHEXJLVHweymESB18I2QeDZ9rVSVeVk5TUKP5nRzrWjr/s+lohZ2/zp9z?=
 =?us-ascii?Q?PyHaL4pFpbT4JRWnJ/MRtwHeENaq1kyIB2HMJ3hUm3jsf/WEx6rz3IRxr05f?=
 =?us-ascii?Q?Cjj1Y3AScKocEfDXJ5ElkW/0V8E/NyYFJMAo2Zv9lg93FQuRq48654IF8w7d?=
 =?us-ascii?Q?IIvCbYolg/0frmda5jryTTyW8yc/gYpChLTudSwPSrIp5a9x2eZrN/rGp4Tz?=
 =?us-ascii?Q?QFiqQVxwMP02HonMrnk/wzi7KvJFjE9RlQxVofxLyfrHzhR0ZPe/+zFNImtL?=
 =?us-ascii?Q?S3Nrl3F6NjWQNUojIInPHPEuj+iVAK8kDeZoiwKO5PzHKkidAdrkgZBjxrZI?=
 =?us-ascii?Q?eihs7eWwA3dWPlbqEoEJ+6AMzbgsL4ZXpS/n4imIaKRmZd2Jm4iq2uI7LL75?=
 =?us-ascii?Q?34EEKq9fVj7jsd8N8LYOCBnqvJjHQIWlvNxR6Y+Dyz7jKUS8OGTIl1P9O6KR?=
 =?us-ascii?Q?sAMON+z+Si2XBS1W/kThBLjA68pcaD23brcf1jnBsxw/faPmFgPl8lQ5ebSp?=
 =?us-ascii?Q?q7eAaa94Xk5UmUw+uLWF8LFf5IL+fdLCufwwBSVU9zgRXIUB5q+YnVMpXsQS?=
 =?us-ascii?Q?a0rAnejZ8F9t2hcSx1iCR4Mlzclcnh0Va8APeFLQk5QLpQciTkvj7es0Wkbp?=
 =?us-ascii?Q?snIUGZThLWmJ2fK9PWgsyLPFCIoNGnqH6iPGMAmqJee0Jtb29eYKlMUsIhPs?=
 =?us-ascii?Q?z4e21d9oTh6w9L4filNWZb2sJe1R/A1K/sbz5rTrhf4CnBFuHrT+M+Aoma+L?=
 =?us-ascii?Q?QOOrS8mSNSOYt6MAfWZo8CK+JXUPMMViufMyxRlgatqqjB6JhH3xARqTAzVF?=
 =?us-ascii?Q?bboqltO51PAdz87RkH1I/4iTksYElLIQF7je9SfKOuVp8x+aXVQ9jW6Stej9?=
 =?us-ascii?Q?M/d1HdlxP/Um2Zu9JA8TM3OT9YiUuJtAINCuPCpAPw+obEwWzeLWwPWRo+/j?=
 =?us-ascii?Q?YJWGBFhUwYd22kiED4kQpAPg4h2s2KXzj7uwBgnmCoksfDfENdWqGLvIZBip?=
 =?us-ascii?Q?GDe3LSBwnFNTz633NJse2EihL+hoGuYH/CJPxH9vN74Di/pvnBXlov/EoQqz?=
 =?us-ascii?Q?xSp6cXj9Vdc4jULxcs+RdIXtUl418yo=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b1358c5-993c-4a70-cf60-08d9baf64bc4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:44.7089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ak7stEAr2/DH7vheOypjop4UIVs/UanaYaeJ53oyvwqhk9NXQQk0umdyK+L444pnuXZgxz/7yuioT5i6iV/Hzqh0fcYd9LUCYIM2aBNcA0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
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
---
 include/net/act_api.h        |  1 +
 include/uapi/linux/pkt_cls.h |  9 ++--
 net/sched/act_api.c          | 83 +++++++++++++++++++++++++++++++++---
 3 files changed, 84 insertions(+), 9 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 73f15c4ff928..7e4e79b50216 100644
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
index 120e72d8502c..1d469029f2cd 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -131,6 +131,12 @@ static void free_tcf(struct tc_action *p)
 	kfree(p);
 }
 
+static void flow_action_hw_count_set(struct tc_action *act,
+				     u32 hw_count)
+{
+	act->in_hw_count = hw_count;
+}
+
 static unsigned int tcf_act_num_actions_single(struct tc_action *act)
 {
 	if (is_tcf_pedit(act))
@@ -139,6 +145,29 @@ static unsigned int tcf_act_num_actions_single(struct tc_action *act)
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
 static int flow_action_init(struct flow_offload_action *fl_action,
 			    struct tc_action *act,
 			    enum flow_act_command cmd,
@@ -155,6 +184,7 @@ static int flow_action_init(struct flow_offload_action *fl_action,
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
 	int err = 0;
 
+	if (tc_act_skip_hw(action->tcfa_flags))
+		return 0;
+
 	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
 	if (!fl_action)
 		return -ENOMEM;
@@ -192,7 +230,13 @@ static int tcf_action_offload_add(struct tc_action *action,
 		goto fl_err;
 	}
 
-	err = tcf_action_offload_cmd(fl_action, extack);
+	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
+	if (!err)
+		flow_action_hw_count_set(action, in_hw_count);
+
+	if (skip_sw && !tc_act_in_hw(action))
+		err = -EINVAL;
+
 	tc_cleanup_flow_action(&fl_action->action);
 
 fl_err:
@@ -204,13 +248,24 @@ static int tcf_action_offload_add(struct tc_action *action,
 static int tcf_action_offload_del(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
+	u32 in_hw_count = 0;
 	int err = 0;
 
+	if (!tc_act_in_hw(action))
+		return 0;
+
 	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
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
@@ -820,6 +875,9 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 			jmp_prgcnt -= 1;
 			continue;
 		}
+
+		if (tc_act_skip_sw(a->tcfa_flags))
+			continue;
 repeat:
 		ret = a->ops->act(skb, a, res);
 		if (ret == TC_ACT_REPEAT)
@@ -925,6 +983,9 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->tcfa_flags, a->tcfa_flags))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
+		goto nla_put_failure;
+
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
@@ -1004,7 +1065,9 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
-	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS),
+	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS |
+							TCA_ACT_FLAGS_SKIP_HW |
+							TCA_ACT_FLAGS_SKIP_SW),
 	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
 
@@ -1117,8 +1180,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
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
@@ -1193,8 +1261,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
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

