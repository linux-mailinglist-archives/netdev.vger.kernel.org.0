Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71C246E598
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhLIJc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:56 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236270AbhLIJcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JA9CeKD8mVDzY3+2KF1RYA4iopqcpf0BX/cdNnFbjz40jakg/8s7aJlW5CXJB7hA1jIzkFRmWokd544715ehuNwb2WUuVgAMoSw7cA+5CfcJrVq6cRK9KQrFcnGPxeoXn6+ozsaZgAPGly6dVtDY2duL/hUYd756W4BhsxcEl+2+4b3Kwf01Av70OBCxy9UzUT4K6iWZ6TGvSGXxiYPL7zkPG8X9fEjVZ/lscj+b8EwXkw2h26vBUxaXECV/l2tzBdXXmJewq0fgV5vFmvHu87+ciBfMkGeWO6E1jk5ODLNMyf1dQ/Eay0SQQ357mYPbNBFiUZjDnbt0zRiGUdAcxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/lmcJP0n7pHAKNjn3gzEc5hYOQt+3RQl2YyEOWZ2RM=;
 b=ChmWLladMmjuHYO1v+C2dVVefFwhkDHpU8h1KQPNqoFu02mmRwmSOLcv7tLkLr2AtPs4YISetuvmNMNwgoasLKzhRddFdSvzlHnkh9jfNKaihjqMPZx5FLcawhWCFyvpdPDKEfq+LlUGO30k/ZkdNBUPqavp7/0Q4Vox8Q5/BmWZDxKKCs6ptORrQXX1MWBz2ncPBCQEanZLDhzJRU0wbSAhGJxMgzMGYZFku0EA5rkLPdiZjf430FTAN+Pj73rLyTssBd4+bcXV+xHoQGcdPEoPa9V297Xbe/SYi9IjzBYF4gFzIDKqoiYnGU8diLmjPe5Syp35gmZprI6B/0Af+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/lmcJP0n7pHAKNjn3gzEc5hYOQt+3RQl2YyEOWZ2RM=;
 b=N6uEXJjK59qgIfKgSrNq63z0gbR0EcjnDScMumL4p36qzb9BosHek4x6BuSq5ss1meV0gFMKVQkINXN+fThE8DsZngkNs3D9aNelzLQtnaWYPoUDDKG8WVbrnNNzKs//tIVfAPIk7+NNYxg295beaJI+ajT/kVZJLQkVLrqr5I8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:56 +0000
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
Subject: [PATCH v6 net-next 11/12] flow_offload: validate flags of filter and actions
Date:   Thu,  9 Dec 2021 10:28:05 +0100
Message-Id: <20211209092806.12336-12-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 63ea9ff9-9fb8-4e57-aaca-08d9baf65285
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5494EC204D71CDEB97FF5B4AE8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:16;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9bJKu7QFxzMXrbj4FmzHtX41z853fbZY7/zV2937gvioGUWpUNb7oH5oOOEroWlUr/8wQuEyi/KV340CusKfzNHYxwwD0HJSc5Mpeu7Ei/gTbvB4hbft+IYdEgmKCFPzEX7fwi7gI1L2nXayUrSXddWQptQMCGsHq+xFFJCU9tNJ0+Z3NfrBMmerI7iqzrDXGR1/4H3fjNo2/pjsIP/iILGAWf53mk7Pyk0vr+mHlZoXuQHI5NaGBODAuQsLsvJGav4wFfmKw4BaKwEVzYnXG/S6rA1UPh/xf14hjN9Sd1Kmv7O5LfzBnUPv3SrYiUMIsHhhIVCyP5yfcFnFoMZaujkyKUex3K/ncmgAJqzD2swjTw5mLGhNL8V2DvyjMY9FC/44nqw72LUwy6x8fTIBsv9j0wb0Lkc2NV57tw1twqLxY2XaSoyAPYoDBjP85+Eto+qDdOEysnjCjAcNotAfotSHipQr9tIcBElxQEiBc8iUK0bI4MyjF4IeCnGKIoKhQa5pLaV9mbMzw6OSnloboKI1jvzrZJ8vEpM0yP7mASduw0Wd4dSezYdKL+5mSaKlDKSdaZv6A7FNjsr9YSBUr5MNYC5+0q5EfWOiNPsWo/od5epBmvdQTKG9vY1eWdKyMVIk5XwkLEUPCSxblEd/YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(86362001)(15650500001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(508600001)(54906003)(66946007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sg5JcHGfOrNym9H5sS9/9j+Gwrm7f67PirIZSM8rIF2Or9UIS5Xpft2Y8VcE?=
 =?us-ascii?Q?O9KRyXrOelqDIBrU3SKrx3oDDcPUeMIFR+ISw9KKU34cJCHi7OoStKyjZ0MK?=
 =?us-ascii?Q?r1wulKx1nzuH0rpAVnmjsLwgQwNU4jkjkRoe5dKgPlrel8w+KGEbI2hEHEzN?=
 =?us-ascii?Q?0EqNSKv661be9WQ/jX43rPUtrerqF/PdvdfwcNkVJ3bMiM+I8JaIkIsjFcmJ?=
 =?us-ascii?Q?wfLlRyIZHjiyzy8O3gZmcMcdLdeh53AEvqflT9zDCWLM6rPcXbJ0ChEDyzOF?=
 =?us-ascii?Q?74ES/Sml/KBCfxAvb6nhyNiqU0TNOBwiQzWUqXrFNodBlQbzmxEYS9IdBwIU?=
 =?us-ascii?Q?V6yvyIQGfyQYwebTEbU6EVexq7GoP8HZiSrAnwiOfo9oWIYs21v9BQbDNwKP?=
 =?us-ascii?Q?txOWtcj8wh2GEBhN63e1gdVg53OjnpwIibqL9L5G0FrgoSCf39GLQCKNCzoe?=
 =?us-ascii?Q?5NsZC5NN10bP1ZXWaJ9YAEKKsbl9SYYC03coPbfgFp1ea94S1lvM2zXY7OoL?=
 =?us-ascii?Q?RlqDSCyaSxAfa+0znffF/dVfiBY2A074bjbNQHCLZv902a5TlQXWKJcS4hS+?=
 =?us-ascii?Q?OS14tuQqfGuHumIksyS/FodHiy38ap0aW0eNdo7eXfGkB6lB6Y1i3H+JE4jn?=
 =?us-ascii?Q?PeJ5DH6Z67cta13YqlYJLyVYqusBkgGe9nyXt3mUncPtPGpS3CkShipABdvI?=
 =?us-ascii?Q?HKSlGpXSDzeROsF8d/ITvE9eW97RJeSwCAfU93qpBkaj/rffNngPH66b7TTf?=
 =?us-ascii?Q?GUqMqN9GlBIvmCTfDr1XaUOZEGvRvdJZ9OOuMEE/ISXLxwJRagT7dSyglLLi?=
 =?us-ascii?Q?6aXpNk46BM4DoBy1LC3XEtjtKDQOdvp19LfKL45XH2hdSyJ01XY3HvUGtG8S?=
 =?us-ascii?Q?u9hXyJ4zVMl3ATutylup+M6OfEs//AIa4MDgn+0ZOZhyI1CJzCUWzPGfbQhk?=
 =?us-ascii?Q?3Zfh+l2ZZfj4Wryz0488SFzQqfzNT9SHPbUsPvgHHtW8gBTMeyxc19cRzP6P?=
 =?us-ascii?Q?buJhxO35/5eLV5xZtzbGgHcQoU/nY3opun0q3il4lha0NLVR8W+VtKP3Ie6a?=
 =?us-ascii?Q?3ThyH8IWJo9rLPjr9eM/fxTtpzOwWJon7N0LWZr8MhBq2XbSDB6lqnXxA5M5?=
 =?us-ascii?Q?t5Wini71fPXgM3tq29VB28nscvvqUEb22NPKq2iCJKjphXNERThUE8pvkqUt?=
 =?us-ascii?Q?sY+JU1ph/AKipUbNua1q7Pk5PrmHo5pBjvfdKB7GHVc2kmaPJJWxs6hw0RVi?=
 =?us-ascii?Q?YYf1acdlzGxeKQe1nB2oeHb2sfl+bi2hrT9kObMc7mVbMihJKraL7XXUD+GA?=
 =?us-ascii?Q?iRBieftyxPPVBaybUzJKNqofA1GyarZvQDCQcSV7rAokR4vhGLFlYdYnn/xS?=
 =?us-ascii?Q?MSnwr/Q9YtA4YH0D2FPM8DdHAZy4zI1UR0tn/uO4hEX3g+XZR4+Jybaeuxgt?=
 =?us-ascii?Q?BlwhYKyhA+/qDHu1fNJIhOMuIPsmT6neWDlk0+h4atZo7EMU+fbhfYmghghb?=
 =?us-ascii?Q?rg2Y1Bfnm/Z5jw1L6oFy8g7HudRz0CWWkCCP5gkFKbBlIlzB5JPnTtzNt36d?=
 =?us-ascii?Q?FNE74LZqpMhHkHjIJmEtnEmTjzqXX9xbx02176f69nuijsX2Mw4WMhNkAoFR?=
 =?us-ascii?Q?cYxBUCobm4n/FUtgs8l+NMcHVV5EM9AYq8SfQl3qXF2HYT2l+oAojPrgQWzs?=
 =?us-ascii?Q?LA841ZmP0v8P1pJ/32CbHn/OGnTEYddBFW4kP+sHJLb5oNfzM7lTil/T2bzx?=
 =?us-ascii?Q?JTZAa1sUoVEYeMoSg80Zr2YiudJaPss=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63ea9ff9-9fb8-4e57-aaca-08d9baf65285
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:56.0302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFG1N4vlWTfyR5s96ZFQY/J2w1zy8lcKXAX9w7jNHO5RNmfyju/DN2dwy7hDv6BEdA7MfMnUc8/jPWnfK55eOg6R0YR1lrWSBWUKZN22gMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
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
index 87ad1d3f2063..39daa1bf1af5 100644
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
index 1942fe72b3e3..55abc3c1d761 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -326,6 +326,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp,
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
index 668e596b539c..47532806dabd 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1384,7 +1384,8 @@ static bool tc_act_bind(u32 flags)
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, struct tc_action *actions[],
-		    int init_res[], size_t *attr_size, u32 flags,
+		    int init_res[], size_t *attr_size,
+		    u32 flags, u32 fl_flags,
 		    struct netlink_ext_ack *extack)
 {
 	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
@@ -1422,7 +1423,18 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
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
@@ -1925,7 +1937,7 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 
 	for (loop = 0; loop < 10; loop++) {
 		ret = tcf_action_init(net, NULL, nla, NULL, actions, init_res,
-				      &attr_size, flags, extack);
+				      &attr_size, flags, 0, extack);
 		if (ret != -EAGAIN)
 			break;
 	}
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2a1cc7fe2dd9..0894a1c90943 100644
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
index aab13ba11767..c3a104832a17 100644
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
index 24f0046ce0b3..a0c2a81d5762 100644
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

