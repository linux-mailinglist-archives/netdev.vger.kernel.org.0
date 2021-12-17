Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F2F4793C9
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240315AbhLQSRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:17:50 -0500
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com ([104.47.58.107]:36846
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240279AbhLQSRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivdLH5cMi53K9yhNCjGHtkfBcxBQMx9mLkkt+h7Swv7ojWJp6GYzl6Dh4OG4HreJQ8k7fLdPem5v1nFnZ8gkBVo9Udhi19PXwH5HgAICL129Yj5Gxx3unDe+FFveatu0ub0XPD6zQHSOvsLNwr5reZhxyswRZL7EIoXz2LodgzjYrw3LYrzG3b6c4ES4wzX142PaK2g307AjVwbjg4tBnTp5Ksf44rScHp3D4x80ynb/dzVP5WQG8qDX0J6+paNiPAfnpMuozkMYK/prCx9V5vS3rf09FWa5K3/EmHHFe+m/I2EjLLbClSBODMQvfSAy56QWIcZYrLd5uKLiXVnjFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6but3WQbAbaDUq49Xg+Hl2ofSBrTrp1BQNNd3rahVWI=;
 b=fd3ovZO+VjHy68v+pCK4HZWKu8C7SGYyESsMroWzJfDZQLZAs1d/QQ5OfifGj75gUg6KKblkNFld4kfodCzjgYyCjNwZw/FToKRnLEstbsCSqIMgoH0tp/m7cw/MOAe3Yb69f5mkvhPw9kuT+0dwunNsVdhaoPlGeX6T8KRMnE0nQNbbZu/usu2/8Azo5h+Fl/lKX58s0z5AS4STa2GN0tRgiInnQzJin0JGhK4+ViTbYY555XPU+SuBPYrRCYKlvuV58dYrFN07RzAVpwmRvBU2k+183/hyhf3wmRUyz6Cm0r+GJ+F/MwiZtygNaG0JEmzTxEDDFwGS4tA9yVW52w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6but3WQbAbaDUq49Xg+Hl2ofSBrTrp1BQNNd3rahVWI=;
 b=ZAKBeYosfWmND6VCNqardWWG80Y/zuSFEqj7akMuMfweuHjhKC1jwqrnHD9AbupEOA1h+eweuKyZPvEudSn8EpmtSmPgyQv/pZHi8ypFAYr+7F7HD+DMqMZBM3zRw6GEajQKSLB+RPgq0A5oAPSMr+5MBSX9+rpS2/XSVDyBa9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5589.namprd13.prod.outlook.com (2603:10b6:510:142::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.9; Fri, 17 Dec
 2021 18:17:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:44 +0000
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
Subject: [PATCH v8 net-next 08/13] flow_offload: rename exts stats update functions with hw
Date:   Fri, 17 Dec 2021 19:16:24 +0100
Message-Id: <20211217181629.28081-9-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 560778a8-24d2-4f9f-43d4-08d9c1898580
X-MS-TrafficTypeDiagnostic: PH0PR13MB5589:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5589C57FA3746917D53A7C4CE8789@PH0PR13MB5589.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:619;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pVUjMxnHtASkTJDpi4l9x2PIGhJiBQDOp2w6XhKWyVysd0Gzo7QAYJPfco4NlUYHy4ggoc1D7glia89RBAl6N+jbyitELzrwkP8NxPRNCBau/vjw/hUGYKjTep7wjJBL6QCmxz1vDUexj/suSc/xTIdUngcbwhKAoxWgn4knrgGP0/GY8hBkSpPKH+JkSZmspb7qk1zsTLV+ipcWEUs44PuDUrG7v0Btc90e7StTJJZjkV4fQOfLOElf2BSaTm1BHKA5hkp7vD1Wjwmbcr9SS+5y52Aa/EJsfPAp0qtWYG0V5wA4EAAqxomQfvneDz+Usv2IlpEzDXxFukiB6w1Odd6FfLNwJqtE9/1v2OHWR0xdKVOgEzZbFLSD0P5erkYeVOtKMSIWahKLO7gz8j8Nnspbe5RJzP37M6FJf/kHjvS8igxtHvz186qdT6+QQFlNsdLw4ur1tdS186pcZXDd7PeYvw262fvkxwk+On5wWclfP3OJaZtLkLEVIVvfqvoy6RUWzl4iiNtPNVNDo1N8Iret2pd/ncnI1diuPDQNerm44fIY5m2uu/2FPS6RTdY8DunEruMxHYO2zI1pp1JvEn5QWcek/VCxd9SzjE2OsREGGxIwoMKHgurAwdtK2TVjKnCWol4TPnu/K6CGeDsw6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(366004)(39840400004)(396003)(136003)(508600001)(107886003)(52116002)(6666004)(6512007)(86362001)(2616005)(6486002)(186003)(83380400001)(1076003)(8676002)(316002)(6506007)(2906002)(54906003)(66946007)(15650500001)(44832011)(110136005)(7416002)(4326008)(8936002)(66476007)(66556008)(5660300002)(36756003)(38100700002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?01G+kvJKhdebo7LStpyI0R0HTGyEI08xTQ1ilQ6mL1/qQBEWFGSSrwYBC5k6?=
 =?us-ascii?Q?ueoeyaWy+7abyJKJ62FAjDRrUEZ7u9YQAUgcSaJCI8WOv/gesJE31tfgyqzJ?=
 =?us-ascii?Q?0vlpFXBh5kuwEeVcloxXm9fpM8uwJMiPYP0gJlNFXFpBPaxpwczzs3qln0C3?=
 =?us-ascii?Q?HCCeDNZ+VG9GyboHlFc9YlasRunNIoO0/c+KTYRCj2B8ElcFAmjAa4PxzFcu?=
 =?us-ascii?Q?wXoMRYPZoMYhqEn5fZRGx7SfdK6qv8HdWgFu1a6G04aoEIf7PP5T9lXwHbul?=
 =?us-ascii?Q?wDxzV2xH2z54q6iv1KDoBYOVbdMK7GLoWKnuEe6rmFj2jqVVI1GzpaRkZa5h?=
 =?us-ascii?Q?umFILDNt2MPQ0H3KWNoMnmzJ50nLVosUS2LXtl+eae79GR1KgT8M2YlAbT2q?=
 =?us-ascii?Q?5gYrGbb+kpojT0dFn6uWCZcQexF/XX+FbHv1SIyXVMl8H8Qd/O0GaFUlo/Zm?=
 =?us-ascii?Q?3AXezRfn/ay09ejt2F+NW7O7rLTR0u4gtuunZmoP1IrYMLY0crStEDvMMuM5?=
 =?us-ascii?Q?wzArStC5Ri9LlA/QZ2u3/LuzM6c9/5mrc54UsD5myprjgzHRplTTt7HbBOiW?=
 =?us-ascii?Q?fze6+XkjuF9uFgWPYq4LjRMWjGXEa9soiNEB+24/sgkt/P7SB8Yfz2hUCDH+?=
 =?us-ascii?Q?WZhxyhT6HtF5xAofJhep6Xz5orsEBDzgh12kEs5QnFP1BiCBsrZKMVjN6PtN?=
 =?us-ascii?Q?JF5jpdT+bBaU6+or/zZJNm8MY16U1RFYS0bgxeGcjeHDhyvsbh0pmCUWdJun?=
 =?us-ascii?Q?2RPJixBMphXqqggiyXJiFbQasH4PPeWH12q5XupkAJWHVFnc2IYLs/L56HD2?=
 =?us-ascii?Q?PfzKtAYEnXbaR+QSI+54XcSLwR3Q6Iz/HJxDetrJxCgic0FeVbXxMc2rYqWM?=
 =?us-ascii?Q?FwWFuktXdAWeZejK7dd86ji+/u/xJixjlC0cGIY+x2hPe9bdTS/rXvs7dtiM?=
 =?us-ascii?Q?kloOUQwl/LKHCpQBDK6rIReTZ129MPa/CN9J+Q5swzqDeTvGcFjhun+MwuOf?=
 =?us-ascii?Q?vxYxoB4+QoO3Ev0XZ6hPfn9nufKwn3j8Mi+llYHFxu7HkDBUVfh0o3y9qP/s?=
 =?us-ascii?Q?/JBtxEM3hH0EtGvaNFL5mftRxJzqsIK/7cSTsps8589I35/mHvAwlqv4nAkp?=
 =?us-ascii?Q?4PHXFHMU3oVQgl4IxWE7/1VrpkwB3mIReJrLl/3zeCVkYC9tNBL4w1d6NELt?=
 =?us-ascii?Q?bQg/oL1QbUb/N0FWP8fuxFggeuG3yNR9nCtCiPnvwggJp10FZP78Z/A3Rt8U?=
 =?us-ascii?Q?2ZjIvznSmLEQJENQE0hsyZYQrpz17OOj3jSvxe7IhtwsfBA7xraBmzH+yv6y?=
 =?us-ascii?Q?LvvetLGTpCmqZ0NLyKFQLMwiTYFJ0bi/3LtU7aD2uwNneVZa32mOKClLbn03?=
 =?us-ascii?Q?Df7CIYw5HaTIRyJyi9lwJn087d4jS7SDgJtIrPO5lOaT89pJyRncxecR+xz1?=
 =?us-ascii?Q?h+Gk3QF1RQti7H70S3Fq7lE5Oo/qz8J4tI/2BMTnrt9gqcQG9QLR9VxYqw9e?=
 =?us-ascii?Q?lfJ3wL2wgWW9yMDUNSZ6BMDHvhqaRvIC/4C+ViE/CEFnMxYOe1SmjvLj0+xU?=
 =?us-ascii?Q?b9IToemczzVSPZh469FFZv8dcH6mqDDU8SAPJozF49DPrRtoW7NdukjsO5YF?=
 =?us-ascii?Q?WrjI8/EMzJmCAWigAaztAaSmGiZ1UVnMsPf3oADHtSdaNGB5I3cR7zAK4qiZ?=
 =?us-ascii?Q?JN14izi5qNxtrluU/SQBg4nDqACTn/MRn9emxCAPQBawjIVAAO7oulxAR/8/?=
 =?us-ascii?Q?XYegcLIU/g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560778a8-24d2-4f9f-43d4-08d9c1898580
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:44.5684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4tmCL9EtFbRsuunzGfp2tSWPiiXVfzYbM7Ufq/dtORx/NFEWmG/V8Ab/yGjetMZZKszocayJq1k/8km7V5V/htJqI66uPM5vtvZ7nbUSe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5589
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Rename exts stats update functions with hw for readability.

We make this change also to update stats from hw for an action
when it is offloaded to hw as a single action.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/pkt_cls.h    |  6 +++---
 net/sched/cls_flower.c   | 12 ++++++------
 net/sched/cls_matchall.c | 10 +++++-----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 1bfb616ea759..efdfab8eb00c 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -266,9 +266,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
 
 static inline void
-tcf_exts_stats_update(const struct tcf_exts *exts,
-		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
-		      u8 used_hw_stats, bool used_hw_stats_valid)
+tcf_exts_hw_stats_update(const struct tcf_exts *exts,
+			 u64 bytes, u64 packets, u64 drops, u64 lastuse,
+			 u8 used_hw_stats, bool used_hw_stats_valid)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f4dad3be31c9..9a63bc49104f 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -501,12 +501,12 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
 			 rtnl_held);
 
-	tcf_exts_stats_update(&f->exts, cls_flower.stats.bytes,
-			      cls_flower.stats.pkts,
-			      cls_flower.stats.drops,
-			      cls_flower.stats.lastused,
-			      cls_flower.stats.used_hw_stats,
-			      cls_flower.stats.used_hw_stats_valid);
+	tcf_exts_hw_stats_update(&f->exts, cls_flower.stats.bytes,
+				 cls_flower.stats.pkts,
+				 cls_flower.stats.drops,
+				 cls_flower.stats.lastused,
+				 cls_flower.stats.used_hw_stats,
+				 cls_flower.stats.used_hw_stats_valid);
 }
 
 static void __fl_put(struct cls_fl_filter *f)
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 2d2702915cfa..5b9264da46f8 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -336,11 +336,11 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 
 	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
 
-	tcf_exts_stats_update(&head->exts, cls_mall.stats.bytes,
-			      cls_mall.stats.pkts, cls_mall.stats.drops,
-			      cls_mall.stats.lastused,
-			      cls_mall.stats.used_hw_stats,
-			      cls_mall.stats.used_hw_stats_valid);
+	tcf_exts_hw_stats_update(&head->exts, cls_mall.stats.bytes,
+				 cls_mall.stats.pkts, cls_mall.stats.drops,
+				 cls_mall.stats.lastused,
+				 cls_mall.stats.used_hw_stats,
+				 cls_mall.stats.used_hw_stats_valid);
 }
 
 static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
-- 
2.20.1

