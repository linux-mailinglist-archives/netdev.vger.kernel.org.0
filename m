Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2109346E596
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhLIJcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:36 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236246AbhLIJcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0ysTtRaQear/32hKzX+KHufc7nXFjtn0uAJ1nEeouBKrRuq8/wMDyU23epCd4ZmuWVB5eSyiDTMRYJHI2QMmraDvjT20O8WQOfoyj9z2QjssloajBnrLcBt0TH9ER+OE1p0Gnefy60PQfZlUYVCM/pM4AmpJuWQHvmJuCn8IgqKGWyrsEKTDpDkBe0DSO69n3esAdWGriPOKaFOxGfaQdC0xoexSfglw8Pw9ZV8+bgnrzqIX0WuRE5SHtYn+4U3zt6spHu1CO+X2FiR9D8gOaj5ccTwLYRklZcXWeWCYQbmKiEXjHnQxnPL+ue2vf93xz7x9QJ47H0z5C1qSPYHYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lh6WPemjbx317oyN9/BM6DLmJNvc13bAQG0u7nkGCDs=;
 b=XTxJ5ww20GOyMBUE0au7iXJ4mZzTyN0xk8CL3vnpdT5DoXHpY6jfmhofUnW5pdGit6tHN4UEnUoN/pKaruT2F0FpvUxHSYyalDWpUGv4aSaLtVmmMKYCqe17q411FWwahXkdcgY5nzByNpWPQ/kzN4fOfw14B2UY+aC8XRzSXVTlJjohHtKkNq5LnxziPgPpppb3d/MwRnQ3jG7bStGKThPE0eyCqIB9STkceDycds3jEcQnRx/SQ0ZjR9ye2gyksQSsrSLktBNNZRGp12iJYb2iNVMkIhpeCkARUEcRNpl1CnK7ZbMRqP5dgrgCHuT/cUNoVMXq/vALEkJQPFm/8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lh6WPemjbx317oyN9/BM6DLmJNvc13bAQG0u7nkGCDs=;
 b=EsJqgaDa0fz2lkY1h1D7hbbcVxLK3b/CokK7kFN2WHXWHY5xjnYBmODVALu3pYoZb1nO2jOVPDGCYgqPYbeZrQ2fUkGEN72zdd8o0ErD0tgsBQXSS4BIGoOKfusqMTNlnqHArQlL7VkzpKhqa4hbufGCm5XQvViEUzgZamQBtdU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:50 +0000
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
Subject: [PATCH v6 net-next 09/12] net: sched: save full flags for tc action
Date:   Thu,  9 Dec 2021 10:28:03 +0100
Message-Id: <20211209092806.12336-10-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: f6382420-5b1b-4212-3bbd-08d9baf64f01
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5494ED7135303B9586FFA4EEE8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q+H/9wWv5kb/XtTP3cDZDsc56NfXfktGN+ArgpcvjX1HFUdvgEFN783YqFPXQzt8Zr3ODE3itDb4UHVG6akEfzkDi96vh9tSuJQ/yinj6PESFftesSOfKCyBdTHtZpkORtIwm0mGbiN2eYgi8O/FkNeveP9eHwC5rmJdD5OpWQgrT1KBsvpZx9+eLPFjACMc2aOAsQBAcXFJW04B5b30GqCHaZ6QWD4SXypUGDiFWadGTtLjwTli+gKT/iSeBDoop+bvFV1S3GRTorj+sDh2hWk/wM5P7AGL4q5cTJwL44zswOMNo/WBMoaaePYdCSY+nIk29ptcBP+baKx7lfeASlS4omZvw/h00Qzg46hVhDmYKi50zzSXO+QXu/NjirWU5coxNKr2WSaxcqK2CtCzB++Z5xdSpb4JRarx7mpsb30vmHC5Opq63clL+EphR9YE91VGojK59Vv04uI3N+Tg5W4Fdy2XG1p8adtQq77YCH8ul7/lRunfEM3EDxOhPuPxTvWxBU7uwQ1iw+IWY3SXEGKzESo3rAGc0iZwy6MbBsLy0f8Hz4TOFRWEEuuma2HOP1hb89yXEMTat4fHF70Efp7HaEncVgVXX7HQSTeSkHfjuIfldiXnYIO5mCO/Piow6mgTiXpCyQJu7pX6V1zaOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(86362001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(508600001)(54906003)(66946007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+YHgXBnNKDnpsnjWXtavkheGZMhu8LnqjqQ0g+Sb/VYObCi0mp7WDv4tuHb9?=
 =?us-ascii?Q?N1Db3G+bbFtr1IdGap/suAQ8pBsn3ur8RO6fFUsQinZOFkhEpkeyI+UU1DUG?=
 =?us-ascii?Q?lWU4QYpfGLaB6bgaPDnPIMsjk/M4vg+MWg9MxmxHc/fqEbzoBz4V8fqjCJkj?=
 =?us-ascii?Q?rjledB3KCNCX7cqNrpi8G9hZuJm/xyXBRPj6sFpqqRt6sCZGk42Zgeyb+OgZ?=
 =?us-ascii?Q?q6tesqAHnL3rVVGf7dWPXn4YEfYxqgaqCBw5wSTYmXWAfGcAjn8f2KTWnYWL?=
 =?us-ascii?Q?F3hmxyEbMjS0Hmgt4iYOKE7d5ffR7JwVYmwsHFU61LSZc0kbbgzItGDdlOoi?=
 =?us-ascii?Q?uG6WVO4JXRimp+sm0x4/G19I24eEHSlJy2ocl9XFhi8S7uDKnzt/mH9TGpw9?=
 =?us-ascii?Q?yCYSJtZDyKuXG/ad5FeB50x7zMau6BTn5qtpPKWFi4nkiOTB6R9RCT65xl4t?=
 =?us-ascii?Q?cE4ihRNtjc1FwL9D6/VCMX92if43RodhXUDbbcn3X75RpeJXp6eB+mW/nXtZ?=
 =?us-ascii?Q?81jwGS11b3C/63+PSb1pUU7FKW5bMqisZWqDnGuKxr0G7u2dtVOU93iYiWRc?=
 =?us-ascii?Q?da3WgW/k29derE5147Ei0gBbfnNV1do7wo2N9duywnEPi/UoreuRgVg/tH/3?=
 =?us-ascii?Q?xxWadWD09pRsgJ/pAr/WnnIhxYTmuQ8wxdpCXTYXflqo2HK3oAN+V1RTU6dI?=
 =?us-ascii?Q?NxRGepyFSZ5DmrakkRJMn3vnw9IFIljm+LJw0XbYIysfRiM13fuzioNK3Tan?=
 =?us-ascii?Q?5Nf1Yj+E9aeI/7wGWTHlIUIfQBDszrhGcJqG2DyExe7EEidtDf2ITo9H72/Y?=
 =?us-ascii?Q?WnLu/EbHy0wUZomwKtBBPXUCdrSfjarv9GaSLbOWvek2yx6uL6ZNMCTYOd/4?=
 =?us-ascii?Q?a+9Uzx6WGH2wAc58t5818B5Vk2x63NE1We2ptDvdU9fL1019hK/BrTxP7Jhx?=
 =?us-ascii?Q?yLi4KBS6anaCgzFxYgr41N8XFqJpwh/wpUAT/KEy78KMAnnXGe49LHUBT6mw?=
 =?us-ascii?Q?DnkTGVV7brjvTSzzsiXmhOF8RmDiHtTFgWTj/pAdmdhsL/aR3KIHfk4M+mic?=
 =?us-ascii?Q?JtZv34LW6lq89C8zTw8tIfzbXMaG9RmTipq85n0Fcu8kVtVMOl5rNTCQZwEF?=
 =?us-ascii?Q?E8QhH9jQNeFVEUEpTpibRYSn26Fs4nq5+/Ip2iZra9JGpfsU2OerO+UFJN4o?=
 =?us-ascii?Q?x4rDGG4cBo4wqbPyXIkYMnxMOVK57eUY816ZwK3AYU3i9gr0i9G78+BmvyX5?=
 =?us-ascii?Q?UrGjh4UW5nIjZPxvL9saUPGpUCH9XFeRXoB4XIw6kgU3iKJUdWFDopYHBYro?=
 =?us-ascii?Q?MlA9djm/6l/TgSYAurmN3CfpYKm/RTUMEvRmmuQKo+/k7atxuTubIANg5Vw2?=
 =?us-ascii?Q?YZ3zG5qMiCOjiHX8Jw2ljZ2JZfaRdYLMZ5co1n6ODK2RMg0LNpXFh+EnMjN1?=
 =?us-ascii?Q?awQdNAhfxGjsWw+KFKIddSlxU8tX8lEzzL+0Q+BrDRyXbyftJfP0uKKvniXU?=
 =?us-ascii?Q?ja/pHzdJiymkq1A6t7ga06Gc+rvPRq6BUmYiRmmycpwj5YC23w62ARhunlwn?=
 =?us-ascii?Q?dh7VcnhM/HQ3SmQ9Gtm5LMebzfdzYqf5M7+RoerwwexMGeUxCwpRy5V3WqJ/?=
 =?us-ascii?Q?53PM8UkVK9vUTKdpRAyZgQinRD09sbX//Kx2pjWYXV5S6COtrS20VvbBvzCd?=
 =?us-ascii?Q?f2W02dVjX4JksBDNzJWV62HffU1gfxONBSjfXRaEcc5xzox07/WoDyps/P3M?=
 =?us-ascii?Q?p4g8yr1rDTm20s1GivT9hfDLFbiIMoM=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6382420-5b1b-4212-3bbd-08d9baf64f01
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:50.1002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eP1Oc9Gj9aYS1wVVv6i3fncNgPzMfu5EnnAJK/OXwP1V77cQUlFP9VOJphR2yZK88Yqei7VaGZFNfEgKHK86+uezCN+N96qJ6SxCvoGQiII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Save full action flags and return user flags when return flags to
user space.

Save full action flags to distinguish if the action is created
independent from classifier.

We made this change mainly for further patch to reoffload tc actions.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/act_api.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 4e309b8e49bb..e11a73b5934c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -668,7 +668,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	p->tcfa_tm.install = jiffies;
 	p->tcfa_tm.lastuse = jiffies;
 	p->tcfa_tm.firstuse = 0;
-	p->tcfa_flags = flags & TCA_ACT_FLAGS_USER_MASK;
+	p->tcfa_flags = flags;
 	if (est) {
 		err = gen_new_estimator(&p->tcfa_bstats, p->cpu_bstats,
 					&p->tcfa_rate_est,
@@ -995,6 +995,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	int err = -EINVAL;
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
+	u32 flags;
 
 	if (tcf_action_dump_terse(skb, a, false))
 		goto nla_put_failure;
@@ -1009,9 +1010,10 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->used_hw_stats, TCA_ACT_HW_STATS_ANY))
 		goto nla_put_failure;
 
-	if (a->tcfa_flags &&
+	flags = a->tcfa_flags & TCA_ACT_FLAGS_USER_MASK;
+	if (flags &&
 	    nla_put_bitfield32(skb, TCA_ACT_FLAGS,
-			       a->tcfa_flags, a->tcfa_flags))
+			       flags, flags))
 		goto nla_put_failure;
 
 	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
-- 
2.20.1

