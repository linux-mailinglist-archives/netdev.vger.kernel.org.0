Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DA4455C57
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhKRNL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:11:59 -0500
Received: from mail-dm6nam12on2130.outbound.protection.outlook.com ([40.107.243.130]:54048
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230158AbhKRNLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gu6XcbAGh/lzVfQs+t+3VECwmL4NjDg65MYMA4A6RPt2CCegfT9nd7QmzbyLa/lIgeCZHWdbRvnsRIZjfKVr6XE7oi+q4KO7qDKZPuDXDqWlbZKjU+a+VNeT6Zaf9MzI8pa703DyqXLVEAQEay+X/u16uRmfCMHhHqaYA5kPKZNinJs71JHzhx4qGS/usG6b5Xwq3YdF4aR/PfFkC47bgdxdwsuQdXsy8bz2fIPG/B0Y3AhJdxiBh5nN7RrSelbxIFM7kv9XMh9JBLrzkgDxlu4sRR8K3Y0X/a5814PLQYpgLik5JOuvUCSZocdSCy+ScZWQAY4UYcRad0WbhlBseg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7E7CF/0TniKHGZRey+E2tmeuC2vw0i0JnH1eEDf1U8=;
 b=hZM5GDiEnABJUlbhG2UskGjUA+H1GuonPJYXw+ze7TvZWYvCaq34ij1Hk2fYAl5inmWDcPGc9gzjTJCH9eHIcOACGPRG0++sm5mBVAU5SkndVVEnXi8BLXMobWa4ihu1Fn8SftERnuCPrNCSPnPtm+eVOiQhCOpiy5R9ozs5BK0R5/WXog5bnSIflUnvIP050GG4Dcfa0ftNyKLbp9pQOLKiDPXy/wEyR/cjfMTRSKx0+8js6bduG4An3aVor2ypxzGQm77G39FFslHBG8VE8Xio+C8kMhnJz8FmuJbkgKV7mKZec0HAZ3TTe653zD/IYbA6h3/4aqvJYc/gH5RSnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7E7CF/0TniKHGZRey+E2tmeuC2vw0i0JnH1eEDf1U8=;
 b=Hp+bVd0YznMe0Y3P0yiQ8RgiA30jzLGFouB68AAsScQhJ8W0mIW9oLXbjTwv+cx2uBnnfFvFn9hoVqIeyYaWLF7mOa6m3y+qWAHbmEvqC8q/k86yL7+aE91YSahp9AsL4YtpbFTyk0nbTXjiR+suKRQMNHYLMXSQYVD7cjRVCAM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5422.namprd13.prod.outlook.com (2603:10b6:510:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.10; Thu, 18 Nov
 2021 13:08:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:28 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: [PATCH v4 05/10] flow_offload: add skip_hw and skip_sw to control if offload the action
Date:   Thu, 18 Nov 2021 14:08:00 +0100
Message-Id: <20211118130805.23897-6-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ce1b9ac-d81b-439e-55f0-08d9aa948367
X-MS-TrafficTypeDiagnostic: PH0PR13MB5422:
X-Microsoft-Antispam-PRVS: <PH0PR13MB5422C5287261251572047E66E89B9@PH0PR13MB5422.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QummTjObpkxEloiV1Ndwd7iy5u1PPxKUSfwf9kKWayHXCBL5aD3uRUh2g8GUWmJh5mrin+qlcLpC7AVlRfPYXI/D8LfIgkKu9VNBeSbcLi4bO2odyQagZXEOQ2Bd09hPmjYAYhaGP4WWgKKhcoeUwfWNnnOFXw7F91QkCxZ6dw5BX4bu5rgdK4/tSZaF1ZCZgcv0zhsgkncriGoiH9UEYVbxMSIJzPdF5DALRzSXVm5q+TJfPm9SNXwwzfxaYdC5SA0PwQYm46L7FTlRcdZq5DS0nPR4QVjzmr6s9QEGusCENVz3z9SnzZc1/svt2qthlMFqmDfbbuR29q4ks6Juy6r/IKicuDUY2/zoCpAuWjSV68jwo9JLmKvekpyaYAZ69zb7yfKS1xIkv7ieRxfNoKHD8CFHWwLcBVZfYDfzoRNHbHEl9XG6R+Sv8aD31NMEO0Lk6JDiQpJvQHVEVBHvILhaCRuHKEgqLyBWBGLDrpHfDDk1veJbQZ30vELvN9koqq+Ho3PpRgjnDes3xe/PF7nwWZ/kxlkeatwmRq5PYwqPCLoJBDCfk5KFPpXpEq9wgsRUivGwt+qFOGV+zT0OGBv052K+VUXgWFu/Q5cPHtClGO+nKo4dB1c6gANySm8lQegmZ0opXfE/NCVlz0hFZ9swbg+noWHy9hU/pRpZyTCuO/u7eliFBazNxNovFzC+y/kQxfZGWh9XWy7u15n8IA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(136003)(376002)(346002)(6486002)(2906002)(54906003)(6666004)(316002)(86362001)(52116002)(6506007)(1076003)(38100700002)(186003)(6916009)(107886003)(2616005)(44832011)(5660300002)(4326008)(8676002)(508600001)(66946007)(8936002)(36756003)(83380400001)(6512007)(66556008)(66476007)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CCeaS4Q4mflzVnurRn0Kix/cffXwVfuYMFOdvEG7j5SgBOQkLhuE2NNth7yZ?=
 =?us-ascii?Q?itRafg41+0dR1UgCqB3wVQ0YQt+WXjrHqwG5b0dj0FBWd0v2XeYtXNn4GoH7?=
 =?us-ascii?Q?LdlZTuOG/avyDb/qSBaUsiKVM3zaexXdXY9d/hUv8FZ+YqNBX999a6sQfHPB?=
 =?us-ascii?Q?L9G3l4RUmmw7drNFtFKZWNNToehB2ghUuoni2dUoihRKUysd340pRQDOAGqx?=
 =?us-ascii?Q?6u0Q27eDNrzqoSfKaP9yyjhF0CNKj8bH4WyKEpT07DDhVT1kDicFnJrYtMSa?=
 =?us-ascii?Q?dVHT5zf7jPN8EKcucfhgTvaqGv/IlKSgSxx6sHcT2tkoBl3dLJp1zSei3aIP?=
 =?us-ascii?Q?LYir5hGYlP2aBOVye15nr9FJK1VhwxyJFRnP01AUJNn869NGH5l8tyl8L5Qg?=
 =?us-ascii?Q?ZiePfBwe9YrKNzAyvnUp61AG1h+hjn333KfK8VVOlv5j7Y0jseR40Mub4XSi?=
 =?us-ascii?Q?1yaP48vH15sSoWKLudJgFZBDlYc9lI2jxp4+JZWK+T5EPF8Ek6GJXzz07PHN?=
 =?us-ascii?Q?QMa4z9gz5h51Fu2N8WhvucZgxWECv7VJkRd2EbeVySbCmY6JYk60Ub9RKi2C?=
 =?us-ascii?Q?XwLgytJ5rpUKjJKf1Kvx9KDfprfAvocKi9PkwwzsK0KFHtc6ZfvIZf697t8V?=
 =?us-ascii?Q?xK4AdWXcYt1e6jPWll1SjN1/CKjDUAakJWRUOi7droB0nRCX1tcBKgrNpTqs?=
 =?us-ascii?Q?ZElL0pRK4djnip/4amB5htbFEAnvLroc7X38E6Np2qHlWc0A32v5+tHuWwWX?=
 =?us-ascii?Q?Yh0xxLpYuEYxmqPzgUxmhlvkvWch2/dQ0aEr5hwDVg0HWkXAUuQRjqJH4USl?=
 =?us-ascii?Q?TE2MU2SkwVS5zYQ8fr4Z4ZjLD4HXOqoIqefyvLmBdcSvuRJALtozSoCsDSaZ?=
 =?us-ascii?Q?GkSYn42yaH2gXvxLyL5l7khsZ6XYnBnv+Ett7FNilHrgZyld7un0DUJ/fzns?=
 =?us-ascii?Q?tmA/6lvExZjMvhfYmWQ2sn8vkE+g4lUooYHy+frsEgN+JwqyhbT8dedRQ2BP?=
 =?us-ascii?Q?Y+MBG7er/zXS8YSbuyl/aDKrNIkDMmDNnyPvyUUZX6KdYlM92U7z/AUuVyNb?=
 =?us-ascii?Q?2NsNc6kOMoYnH7Ljja4CfrDmdQs8hl57luhE1vuk1cRD2WBskIUwprS1UAiE?=
 =?us-ascii?Q?NMaiurmMBEOpd7Ekkyl0Q/cslohxNTuEtJ4KZTy1G/KrBEhsqW32iBF5rXa4?=
 =?us-ascii?Q?J12tfJBCpicupB9yYQQXt6SNRgEvuQHtpv/IbcvVHMvT1TfD19gLJcoJYEIq?=
 =?us-ascii?Q?/W4t9giXS3Pi0FupIox9vVNxLQlP/pyOO5hEW2KnDBClhClpayohRV6hDKxr?=
 =?us-ascii?Q?Rno3lTBYcwpdPcLNJ/GQ2LXdAZHFh4Ae+/pUBaeIcUw8Tr1viLNaHBefOvF5?=
 =?us-ascii?Q?9Ef9bRDSNn2bo7BUqlknRCg9CZFG/OR+8CP6dvrPBueyEwREXbEuz4aPHU8X?=
 =?us-ascii?Q?zx1SJ1hDJwF1K8TfLoKroyEeJXBP+4EIJtWS94cBJDyfQ88gXj/KNkNsUnZw?=
 =?us-ascii?Q?0uQmHxHmQsxTKUxb4sO5tRtsjLDOZ4euGmNo7forP5osL8WycVXmqfvZBCzg?=
 =?us-ascii?Q?xlrAiDGRiGWpJSLkvexqfI0WeVK6UdufF1X3RXtcQXTJOXCkhq5kuD78DvV+?=
 =?us-ascii?Q?WHNF88B3LPkF8T2k86c9AUpnvOvgJ/VdfA0EXOrzOKzEC5DessGzdHdtOn0Y?=
 =?us-ascii?Q?20oT7uNyGNEG9EXXDEZCXCTvF5caQBgFwc0rIFWLAPO7PDII76SkQSjq5TJJ?=
 =?us-ascii?Q?sMpzsecmgb93C8AJrJjqmBjjoxQ4rlE=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce1b9ac-d81b-439e-55f0-08d9aa948367
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:28.7588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jx4pxF+o1O9u5LzsTamwaKLXsRFs8ectQYVHHmwNN4WTEkCuMnarxWUoYPa28vLk4PwGR9EiTvhajp9WTchCH71bi+oegd2QaMId0QrBKcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5422
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
 include/net/act_api.h        |  7 +++++
 include/net/pkt_cls.h        | 23 +++++++++++++++
 include/uapi/linux/pkt_cls.h |  9 ++++--
 net/sched/act_api.c          | 54 ++++++++++++++++++++++++++++++++----
 4 files changed, 84 insertions(+), 9 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index b5b624c7e488..68d6f245f7e9 100644
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
@@ -236,6 +237,12 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
 	spin_unlock(&a->tcfa_lock);
 }
 
+static inline void flow_action_hw_count_set(struct tc_action *act,
+					    u32 hw_count)
+{
+	act->in_hw_count = hw_count;
+}
+
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 14d098a887d0..b00fd421e7c0 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -261,6 +261,29 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 #define tcf_act_for_each_action(i, a, actions) \
 	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
 
+static inline bool tc_act_skip_hw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_SKIP_HW) ? true : false;
+}
+
+static inline bool tc_act_skip_sw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_SKIP_SW) ? true : false;
+}
+
+static inline bool tc_act_in_hw(struct tc_action *act)
+{
+	return !!act->in_hw_count;
+}
+
+/* SKIP_HW and SKIP_SW are mutually exclusive flags. */
+static inline bool tc_act_flags_valid(u32 flags)
+{
+	flags &= TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW;
+
+	return flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW);
+}
+
 static inline bool tc_act_bind(u32 flags)
 {
 	return !!(flags & TCA_ACT_FLAGS_BIND);
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
index c3d08b710661..29fba4fa1616 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -226,6 +226,7 @@ static int flow_action_init(struct flow_offload_action *fl_action,
 }
 
 static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  u32 *hw_count,
 				  struct netlink_ext_ack *extack)
 {
 	int err;
@@ -238,6 +239,9 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 	if (err < 0)
 		return err;
 
+	if (hw_count)
+		*hw_count = err;
+
 	return 0;
 }
 
@@ -245,12 +249,17 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
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
@@ -266,7 +275,13 @@ static int tcf_action_offload_add(struct tc_action *action,
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
@@ -278,16 +293,27 @@ static int tcf_action_offload_add(struct tc_action *action,
 static int tcf_action_offload_del(struct tc_action *action)
 {
 	struct flow_offload_action fl_act;
+	u32 in_hw_count = 0;
 	int err = 0;
 
 	if (!action)
 		return -EINVAL;
 
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
@@ -897,6 +923,9 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 			jmp_prgcnt -= 1;
 			continue;
 		}
+
+		if (tc_act_skip_sw(a->tcfa_flags))
+			continue;
 repeat:
 		ret = a->ops->act(skb, a, res);
 		if (ret == TC_ACT_REPEAT)
@@ -1002,6 +1031,9 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->tcfa_flags, a->tcfa_flags))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
+		goto nla_put_failure;
+
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
@@ -1081,7 +1113,9 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
-	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS),
+	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS |
+							TCA_ACT_FLAGS_SKIP_HW |
+							TCA_ACT_FLAGS_SKIP_SW),
 	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
 
@@ -1194,8 +1228,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
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
@@ -1265,8 +1304,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
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

