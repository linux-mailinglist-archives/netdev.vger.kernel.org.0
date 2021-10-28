Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412B743DFBC
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhJ1LJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:09:36 -0400
Received: from mail-dm6nam10on2099.outbound.protection.outlook.com ([40.107.93.99]:59585
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230195AbhJ1LJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 07:09:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCamKz/6lVvrAG7D+RC0od3sk2D8X41jk/bNErLNyRb7SZ24QAlzEZGO0y8oSHlpuGLUDZNaiCt1YmcFiswapQlgOV2FcRKCGTc9f083qeAceeovckHmB54oyNXhD0dY+zajM/ESbuehWWfm7LI860aWH84MmB5CIY978FX2QJHfCD57O9GRcc/SZfOgDIUBR+CiijJiiv+MzW27zKjdKk/pGkbxN6li1fCPtliy+hkAbhD1JTYUG29SD1t9L2u5169dtrJgcWFjHm2wyZyC+3uQb4P/CfpxCjnZa8ILG7+prhobGYxvfixo8/VihMysYHT8l/7lOG+4x20El+siUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRp1HCPVPqPJU3OHFquMchwhifHi9LhY7LZW7gk03f4=;
 b=C8wGqFlqRemVCTaTjpLqI14x3glfmP77tegE9mJfk1WLKl/k1VQs68+4kmLbAz2mirA1EO5d/ZZGKT1rIqrS8KeoYQhXBlyBrsZinz5JQ3r5DAKtn/gZ8P4h+4Qe54ATE1L/OcYmiRYRRvX2rG6H8zZa+cPDJ6vIJmdUhNddbLjMrAzi/KaJSP+56euhl8qcHtlLvmoV8yFU18MgJbQsToS/ZM8LdGGRpa2g3hQ/RA0kV5vqogYHlYsqvdf0yFtQp+hqeMwfhdpx/y1oahWpR8/NWpivWRmOs7KQ1RdJ9wMWFTjeR7Pv71ii9B00fHHJdOYp/e1GWsvYd+PkHb3+Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRp1HCPVPqPJU3OHFquMchwhifHi9LhY7LZW7gk03f4=;
 b=gKsJRhbKEDyP52/JCK6eqQpVRr+EFXcAWIz2Zb5WAH03iKx6RnRq7vWTajfGlaVAqdWWhXh8u2W0HGgBT3yJS7VZJTeto1G2bG++qnlyM0UxmXSoPCUJrT1S1PY4S6yEP8zbkEHZ/mL04Iubu6DkAzgkLvm2YL+cNJxJtRJZaog=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5764.namprd13.prod.outlook.com (2603:10b6:510:11b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Thu, 28 Oct
 2021 11:07:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Thu, 28 Oct 2021
 11:07:06 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v3 1/8] flow_offload: fill flags to action structure
Date:   Thu, 28 Oct 2021 13:06:39 +0200
Message-Id: <20211028110646.13791-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211028110646.13791-1-simon.horman@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 11:07:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19086274-032d-400f-d406-08d99a031424
X-MS-TrafficTypeDiagnostic: PH0PR13MB5764:
X-Microsoft-Antispam-PRVS: <PH0PR13MB5764AC6BE916073974FCFD7EE8869@PH0PR13MB5764.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8f+mhLLJ0Ib2AJy7iTlM2BrVJuFdtJ+A95AA2ztisXdS2xpCYzS9b9JPwgRWyyJCLe/xrzjThbBpjRncNaKkvbSbcj8K2edoSsBroqB2WSknOmjpTSW7GzLjk1OQVmuH4CnmPn4cHCnC2cfYuN3Gbw6ZmB6QPaz17bDUqN/TrVy8fQwu8imYcjiPrdb/RHnqUBDd8nVHVO2VdpBW809BkHiAdSOQi3QudW+LnctUem90JMLi/fXUookQp08NW/c9BWddnwsYpU+LgFlL+GQua7g7mGSHVmiIESlSD0fGiNkyM6bdn7ae2Z+xTCL2u5O/Uc0h4QxpTH/MZsntq8H5Z0Isq9aPdtnrNqsMxHYeTbkfGyOr+a9eMU8HsDzNKfIyqPLVhpyyNfQq1MQ878N5vHvYg/+OCumzaXEHofRpWDtBP8fopnWaojKxSAoonCN0xU1VnzUoOxeldQiDyRCcpjkBTpJ8WUGtDhSa6gua5FkaHM7c0yShnL7YLT7/eYpe3YFbyw1vqxwgw/ovLwGXzuXeWM7o3U1L4TyM+6LBhQWD/7+NIBzyv80WiaYmDcs7NkZym+yKu5HBvuxU44XxNur+wLZIkWC0ZcZXT/b6B1buUmTQQr202jjAmaWbGxXK5YBr1xhlAKp7x5BypDNcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(346002)(39840400004)(6916009)(6486002)(83380400001)(6506007)(4326008)(5660300002)(1076003)(6666004)(86362001)(52116002)(44832011)(186003)(36756003)(8676002)(508600001)(38100700002)(107886003)(316002)(66556008)(66946007)(54906003)(6512007)(66476007)(2906002)(8936002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q9S3LFNX1WfIxbcsDX8ZdA6JBUiwLoVA7KgW9Rb05JI48vBEQUeslqEfiaiT?=
 =?us-ascii?Q?9B13cpd5jbZDAIp8piQrSxJevueA+SELEBXVghp6hVeBowy93tNcHbWNUnkR?=
 =?us-ascii?Q?MAC1PFSr0OizU3LJkOGo/pJCdORGkt/vSzqj46ybzPHTWXt9ikDQwtu1SnXE?=
 =?us-ascii?Q?5g2d5Xuvi9AgQt4dAcmBzZ87UIKLYHZni7FKb1hZa7n4hNsgxaHz/bL7MRmr?=
 =?us-ascii?Q?iL3YwilIxpklRvXCfcSaqLyqy3SIMC5yvqbjZWJmsuh4HfC8gG9fDyHgeYTR?=
 =?us-ascii?Q?UPA3fdGERbEvwix/ikhj+RkawJx3C0xQqaj4egEcCweelJannHhBXaLakQdy?=
 =?us-ascii?Q?Uw/68bUWOCd5/fH89h6p+nAMRxyZkMs7x19waJiNo0NSNO9yLxWszIGMk3Pf?=
 =?us-ascii?Q?zQoKilACfKlNooucq9XOdUiTLB2hKOd6jBJaM2Ly9SUJ7juFBo5+CU6uIvIM?=
 =?us-ascii?Q?sov6uh1MosMXl9ChhTvdKSNzvWYgbJ7uvbKRQHIa1PRe6Bet9OmUn8QeXA4X?=
 =?us-ascii?Q?7Ysj5eaCqONZSihtChlPnWTrwM5eivc8N9tU8Blfb5/Vq7IeCu8De/0U3C6C?=
 =?us-ascii?Q?4m/Cwt6P6+xmVrVDApUC8uQp5LKdu0yZw8hIhboT+OOFz/ueyh2sF2F2dHrH?=
 =?us-ascii?Q?pL0pLEW06Mj5vdwgVExSznW/8OVQHbNo+s5HEzFVH8856n/6LqVIxFBAPlGR?=
 =?us-ascii?Q?LydoUEfBd0Dx697xaZuP+IT9Mt6R8sL1ah9VJI+UXbHqEhOyGUID5t2lrqDp?=
 =?us-ascii?Q?YTEillM4IRC/01h0LN0nGyQ+Ov8AloOL3XbUQ0wMDFa0yQrRCy9U9Hio+kAP?=
 =?us-ascii?Q?z9N+ovKgDoqbt33WziylvpZyQj5M0xPXrP9UQ8Qcybf5gy9IRbv4KWNp0JcV?=
 =?us-ascii?Q?b9MOfY4oqQuagsNh4uWROMa3vX6rMI82YB0FrWYW8750BGU9qIzRHDckJGdU?=
 =?us-ascii?Q?J4ZDJYsX83rOQn3NeYvZv6R9KEDktMB7aVr5wtIG1uuUZNUD4WguxnTXIPro?=
 =?us-ascii?Q?IsDlJ3F3Eth+G0dXwb+Q4QmgQ1GttOjEpY73Inushuq5V7ke9s+cUlWak1mX?=
 =?us-ascii?Q?ZpVsRpooSq4qp/ttE9BokmqlYtkEMaNBi5iqR0jCvwZKFNWvnSS8kW0qGe6L?=
 =?us-ascii?Q?4wqCGp8nOS4KRDVKprxEjs7RiMYpIwDYXdy1aOjYglhgTT3pJFA5ESC0a13k?=
 =?us-ascii?Q?RgNUkK9EUu1aOSC2pX5BfLCOE+rQfLY24nc9Jk8tXT3KoDtzL4NmqXk8mFso?=
 =?us-ascii?Q?t8hEcElMXqRFbH1BXj12JGQN94JiWBCw6wNPOAC650eOCw/B/B17HR+J5S5e?=
 =?us-ascii?Q?wsm0QVLGYne067Lzx3qYZTssseNJr/7Qi2MrkVfxn92VFvezdGOU8P8CNrdv?=
 =?us-ascii?Q?v07bd0nQQ3SprTYe7TXgtqkDstHo9yV3JJzT85W21CVd+ecUAQjOj2sibHqt?=
 =?us-ascii?Q?7RRIUI9NGhnoAXdvOOUjhdBns3LiIoW4Hy00Of5B7Wqk+yhH2OgtM1gWP+Rj?=
 =?us-ascii?Q?Ra2x3C/hTAfwxNDr2Q7i1rh8CZvvrDwi0vwb0NPT4alK4lCJXv9FB9G/EpPM?=
 =?us-ascii?Q?FWRx+WDpIT9IBy7M1J7D0ey+vvKo7zJ2m3g0gnRkHd3fDFLAhiJEZGU3toBk?=
 =?us-ascii?Q?YAdutiabJIs2MA3tP0F90ZRYKGTmgFtwnBjfp3yytPz1j3aeB2l2pcw9GR98?=
 =?us-ascii?Q?C/uM49tI9Q7eBlQFv/gnR2iVbkP66R4kV0O5HcBh9XwTGYpC5p0UWKT6haYk?=
 =?us-ascii?Q?j2gricSdeYK7qwSYP2qtOZ9PNVzM4hs=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19086274-032d-400f-d406-08d99a031424
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 11:07:06.5303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yVgm5zLrrVjThyqAQmE2Nv1U6GdC9DSp3FEe23dO5e1FLrgUDWuOJaPik5k8X0WfvyhHsJXsLirmy1pKX5ExUA9UMjoFQ7mGoB1uVFOMlgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5764
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Fill flags to action structure to allow user control if
the action should be offloaded to hardware or not.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/act_bpf.c      | 2 +-
 net/sched/act_connmark.c | 2 +-
 net/sched/act_ctinfo.c   | 2 +-
 net/sched/act_gate.c     | 2 +-
 net/sched/act_ife.c      | 2 +-
 net/sched/act_ipt.c      | 2 +-
 net/sched/act_mpls.c     | 2 +-
 net/sched/act_nat.c      | 2 +-
 net/sched/act_pedit.c    | 2 +-
 net/sched/act_police.c   | 2 +-
 net/sched/act_sample.c   | 2 +-
 net/sched/act_simple.c   | 2 +-
 net/sched/act_skbedit.c  | 2 +-
 net/sched/act_skbmod.c   | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index f2bf896331a5..a77d8908e737 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -305,7 +305,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, act, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, act,
-				     &act_bpf_ops, bind, true, 0);
+				     &act_bpf_ops, bind, true, flags);
 		if (ret < 0) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 94e78ac7a748..09e2aafc8943 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -124,7 +124,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_connmark_ops, bind, false, 0);
+				     &act_connmark_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 549374a2d008..0281e45987a4 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -212,7 +212,7 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_ctinfo_ops, bind, false, 0);
+				     &act_ctinfo_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 7df72a4197a3..ac985c53ebaf 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -357,7 +357,7 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_gate_ops, bind, false, 0);
+				     &act_gate_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index b757f90a2d58..41ba55e60b1b 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -553,7 +553,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, &act_ife_ops,
-				     bind, true, 0);
+				     bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			kfree(p);
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 265b1443e252..2f3d507c24a1 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -145,7 +145,7 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, ops, bind,
-				     false, 0);
+				     false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 8faa4c58305e..2b30dc562743 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -248,7 +248,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mpls_ops, bind, true, 0);
+				     &act_mpls_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 7dd6b586ba7f..2a39b3729e84 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -61,7 +61,7 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_nat_ops, bind, false, 0);
+				     &act_nat_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c6c862c459cc..cd3b8aad3192 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -189,7 +189,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_pedit_ops, bind, false, 0);
+				     &act_pedit_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			goto out_free;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 9e77ba8401e5..c13a6245dfba 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -90,7 +90,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, NULL, a,
-				     &act_police_ops, bind, true, 0);
+				     &act_police_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index ce859b0e0deb..91a7a93d5f6a 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -70,7 +70,7 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_sample_ops, bind, true, 0);
+				     &act_sample_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index e617ab4505ca..8c1d60bde93e 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -129,7 +129,7 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_simp_ops, bind, false, 0);
+				     &act_simp_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index d30ecbfc8f84..cb2d10d3dcc0 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -176,7 +176,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbedit_ops, bind, true, 0);
+				     &act_skbedit_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 9b6b52c5e24e..2083612d8780 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -168,7 +168,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbmod_ops, bind, true, 0);
+				     &act_skbmod_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
-- 
2.20.1

