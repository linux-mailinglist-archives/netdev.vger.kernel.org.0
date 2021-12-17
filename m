Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F81E478D95
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbhLQOWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:22:19 -0500
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com ([104.47.70.105]:16746
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229587AbhLQOWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2XZmmdHu1QdP8/ExVRsOok04SfaQ+g3m3ojCIO3hEqiyoqoCNVS2eS9VbBokuPF7P50NdfvpBIozNERfO7fmIyvtFpWeix/oGaZ4UiFPu5asvbT2b3Sw9j+K9lc4g1170Uy4vaPmfjgYctRm0S2iZs7YVqJy6xi6XZJLpWsuRxQtKO83/V02Un5Qr/3y/+EpBGBqKScKRisOcmSLI0LvXaF9JVJq1H6PzCCIe7NpDRqLYjXNktQX/g4aRFhtsOyVFqGJIfAdSCTuH83U9S6V8cFRIVCq9q1+PNO0CmqZC5m8z6s9VMs92oQcUj6xx3iyARCUBW5iuDcS+FW++T0VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IGwWhdokVA7Y7a6J70GoTbMdojF6CQOJO78VX+r3lfs=;
 b=nhjuQDEQ76Ev1+0pcUW0N8TzmqMeTdfZnNaM5Srq4R7DjNEI3iFbJP58SGPSPiNiAlylNaIHgAC5WdLgbc6bbXPOpMIImmwj62cja1JB0fEWko08nagAphYBLvuDV8Fdf2nf6aFuDt1U2xc/V79g25V2Yxe/uLlcVEB8Xc1d2CqtySrJehz6CYl/6lwyrKApw2vGMIxgOeRjMd9DeiQ0rtkuzL7p/vPJmTrBQ6HhIQ68bjThzqx6QD0jSL0Z6paTt/HWgkBvf2rUDJXrFC2mD/imujOy91zEDbimWXro0rWt/37xJiRrcQLu0xfTuTiHpJOvmplNUXWibf+MCI/0JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGwWhdokVA7Y7a6J70GoTbMdojF6CQOJO78VX+r3lfs=;
 b=TfNq0kgoL0kFUhicI3aLnew8Voa4hQd3CDl+na0DplC7ixjIuBKkXSKuXl+p2tRiaKceAWH30lBKps7H5BZHbCd7T3MRTT+S0VrOPsusN96v8OriXkhRA4tQYF5TrpS1Tv9OhjIJ1YONzZqL3gbNyrvlDGWHuGtvP5YKZ4bftmE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5469.namprd13.prod.outlook.com (2603:10b6:510:142::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:12 +0000
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
Subject: [PATCH v7 net-next 01/12] flow_offload: fill flags to action structure
Date:   Fri, 17 Dec 2021 15:21:39 +0100
Message-Id: <20211217142150.17838-2-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: dacc0896-0b32-47f9-6738-08d9c1689de7
X-MS-TrafficTypeDiagnostic: PH0PR13MB5469:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5469F9D686EBCE9C1F3F3755E8789@PH0PR13MB5469.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gbX3t7eyRDxft390y7W9o8k7CfDUK3d9Lah20K6M3oWI4lN6L/rKJLGcK4R/wBsEiHBk36tCA5CtzhUBnlRg6pv5FwtRop69K7i0VxtmHUMU7+J7QQIlImuZIWas20YIrYm78gz5SFRZ+xZkxau08rdbB+LTW9N0UzsuohBB1tXVN7YkQJVh/wtB4PYtcmug7Pbn1eFiwRK7n8laIkiOfi63C/HVNWBG0x2Qbb7/9ZkLOt+MeL62xoSydUyokowEnBfoFr2SadOCHahqZYIaW4NNvP02xK0ITKRuw6jH4HWH+9pxtvvTTOPQ9KSCn8aEhVquCKIE5pQCppTyDi0zMiTfUSVEEWnNY5ZRBjm8fgtcanF82Mymgg+mTLTHt3w7s8gVCM+4YN5+Nf4TQIObVodR74zCteY68+K6rcpa+tWkjP2ib8yl7d3N3idZJNdWPKkjJd2cyVqb/5OoKQL0XFEFc+Rqg4vf/HivZoGqxHOlj0KYgkacAfeqZQlB+PAzUITJOZK2RTkU12UhlW9EVKPibW1Fdr19lpAz3tm9o4zhWpH/UsgLB/3+e48wG65V0rXM+UNJN5sUAnZ3ouR3DOPttym/kCaoCOfDMOW2EDmyBmmjTNW3BCCInaKAIlX7exojQ80UIH2daPj2Wz/ZjLPYhrk/NC+RaLd1DJlT2eHmgdcghI8es1bVaFFbG8K9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39840400004)(376002)(136003)(346002)(396003)(7416002)(5660300002)(83380400001)(36756003)(6666004)(186003)(44832011)(1076003)(107886003)(6506007)(2906002)(6512007)(6486002)(52116002)(66476007)(66556008)(4326008)(38100700002)(66946007)(54906003)(110136005)(508600001)(8936002)(86362001)(316002)(8676002)(2616005)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4QjFJlVIqc/5f1yVu299YV5PurMifxRjYtWKvA3x9A9Ub94hzp0oDJ9tXUu1?=
 =?us-ascii?Q?nQhoT5W2aa758ZgY5pDejeaIQ9KKgLImRtYwqIj6YdpFalLo7wzBW5LCPyH3?=
 =?us-ascii?Q?jiVmLDnu2zl2DqRIgtHbEwDGV0gnLDgJVy4Y6Y2iAKiFvCMCvmxBhz93a6Xv?=
 =?us-ascii?Q?/xInZw0tGLZSVQ23kVKZMNowP/j/VaJMD25jPkdxB9ZhC5HZTKiSOMSzHKBO?=
 =?us-ascii?Q?if43fQQlUMcvRU3pMjuHJ27w5POL/1DblQf/7bGrdwcT+FX9rH8KAtd1IIuY?=
 =?us-ascii?Q?ULgngIHfeyc5BwOv5f5dIG9pOFWQrIsLnGUDUlb/I4SOpgWxdxM+39hXwjYx?=
 =?us-ascii?Q?3HKiKQjtOemJmQZ9IGNEmu0hApM58ny+vgylCuL3FbaVX3sxbqVUFuokQ3lU?=
 =?us-ascii?Q?IOO4nQi5gU9uNQxzscRb1U0f/AU5KyuxB8bDVRp4FPJQTRGaq7k9OahUDrOt?=
 =?us-ascii?Q?WFJxMdZGc/bLGgmqmECFdlIC95qwPYxjDblXt3M1kA2/4dJXU5mk233+al63?=
 =?us-ascii?Q?xLvHaj08COdaVQSI9I1HD36NixtsFyGd1YdVVVG866AmxVcm762K+6iP6fgW?=
 =?us-ascii?Q?Lg4+mdev6R93qQ981G9JEon1DWnP1si9fX11HsBELZU8ScR6ybOsXU6a32ZY?=
 =?us-ascii?Q?DIMat8Cvyzf+74rLTjuSFOC7qLPoh70IAAnigzI6Zmmu5FrBbST847Qc19KR?=
 =?us-ascii?Q?Qd1WkKwzxrmzDwXltX6fqnhT4SWIjeKnI7NUAiEWs2wMXSgLK45LWFTDR2fr?=
 =?us-ascii?Q?j/ekLzRh7pKxHBlz1zGcTTWSK4q/xNhzqNsmyImqY2W0Ft9a/o1hhNJcOAzc?=
 =?us-ascii?Q?+gxgXZwwc/lVlJQ/DJXH52LGHGQbEUgSb1jr3/apDt3ybg96lpjk72KmACOt?=
 =?us-ascii?Q?igu65XmIgWuMJJD/fpi772ICYnS8k4wPrwdic1R5wK5C8NhJL7r0djyjvGNw?=
 =?us-ascii?Q?qJRPsGeSSwTLEShRftiRelvOHssCLaPE7rh9bM6IDeIf/E7tgPQPofB990Kq?=
 =?us-ascii?Q?3eZZqavII6PucqnrpmZyWnehORRONRHJwYQ+PStQV8A28+p4HbSDIGSjaxCp?=
 =?us-ascii?Q?SmMN8CLkSaFmsQIc1rrYmYve8Ki67fk/933jT+2qVtY/93nPW1GcCWk0q5fe?=
 =?us-ascii?Q?yzR9c4DGZNh5/4+2Kj3rGckDrWeTye7IRERoQBw+mrLRwAPliSny0qDKLB9x?=
 =?us-ascii?Q?DM9TMAXYMrIac1yBjSd29g+Cl+n/Eyt0omoK31Ja/Yxe6feQBpxagcLcZc8j?=
 =?us-ascii?Q?KzZlSL4ua4rwQAFLHcAwGPY6bKJgeRjCkgL+PTehQglM+UBpo8oXFUpiKKlH?=
 =?us-ascii?Q?Ggm9zwdqyDS7ivv+2h2Kx35wLRHKQZarNcfYyFT4nm78jN9tlnB0H5VFsSDn?=
 =?us-ascii?Q?uNuGXqJKeRP986HMUmsnpXNIInE/nWSHWGATj32mtMQoDwHcWbkDCSofBgbc?=
 =?us-ascii?Q?cgEA3lfMoQ5rN2Mh110mp6PyYRLCzm9+kZh+CyRgYdHxLql49IpGv1/2/bCF?=
 =?us-ascii?Q?PazdCIrnHLV/pvODPHynn8im73C93a0GCJZQ2SQEVsrIywaTB1nhhy/Gh5WW?=
 =?us-ascii?Q?lFbZ40n9Eo5siei3CwP4Xpaz82YwdyYJztizvaQYyT1n1mMoWKaTxQREGoFv?=
 =?us-ascii?Q?rnNQlC1Ef3OjfCwYa/SpDT28NRlwUGD2i//FnGeHL2gnGcAxM1wbtKbXaTDT?=
 =?us-ascii?Q?yKEzmb4HaIBQYH5GzS5KBOR9WdSdVRIKjOx1a3LTggk3p8tyTeoPo1s5CDMm?=
 =?us-ascii?Q?C+0UThju1Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dacc0896-0b32-47f9-6738-08d9c1689de7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:12.1594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSkEufQAU3HzyDVtL+oGlKD/N3j8CSflo3TYst5ML1tqGT9LG15ekVqP7VribfidUGndd8ymnvSAohGa5FFV2m7M9ee5dbf/pqTNSNcs0YE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5469
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Fill flags to action structure to allow user control if
the action should be offloaded to hardware or not.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
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

