Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479CA478DAE
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbhLQOWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:22:52 -0500
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com ([104.47.59.172]:37698
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237375AbhLQOWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRGVF3HAxMM5Y5gLjFZRqO6IPfZ82zImKfuLSiLQuzJ/yTZ4AO2FSSxK8486bOVecaLSJK4EFMX0K+bIdf5epz42tt4IVAklmtl3KXGU7HVi1YcEG00AaVMWoZyfcLmu0WoonLZhkfpI5J5bA1LRIDWmNnId3mjbmN4BBkrWAMiBcrmPZx2FkjxtH6o6uuivKA8WCspqEkVaekF3GebS+1FXl75dupGY3RQgn+7+lg3VnzEri/NqeBy7rFIuTKoln0INiPgQsobsYI2b103yQhhPcRxNAOHrJ00Exzv+Vpzi5MBgcPFOkQl36HaSINXAsQXdfXz164hqwmBZx8Novg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwnbpnGQsujWzVpx0G3VIKNtNa/iDjgKdHVE5iByKUg=;
 b=F/vmF3ciSSdz/RTPKGw+mA7+9cBLy8h9XMhJfh3a/KKPOWnQ8+aq3tZ+1YgMhdyZY/WZkIn/piUv6TwIp3ZtSMOelmV6AnKfbCEBsLAXpocNeJwkln7lTNRVK4nIv1sKuq5aFIXi6P0nLCHFidgSKOODeVVOxktg8ajgMqla3CMXCB0fjRM7v16iPuh9VYld6fIbBfFbVl3F7HT5sVpOMp0phe2CT0Ol0MjaqIn0uD8qRqlAvpwaiamYTmmF76SEDb6mVhgGzrYOWG98uvtczQwiQq2slMm/6dapzcmG12hqYR/yiWTBHqmt6P6y94nYOv1Hs5qsZq3QEgdl5bRZWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwnbpnGQsujWzVpx0G3VIKNtNa/iDjgKdHVE5iByKUg=;
 b=Ca7RExL0cTWwnqEr4WJ5UtBblPdO95Di5OaDnuuJFlEhmllGLJ8p+klhkY3UxjCcG7jfqxHDdf0Oq/+73cT398CroahJXM5rvwOotOepsTWu+cotX0bVLA/2pPiLx9B1wHdc0yblDE6L3fRq3nk0aPHncHFhA6fVToSp/xSYHU8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5595.namprd13.prod.outlook.com (2603:10b6:510:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:48 +0000
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
Subject: [PATCH v7 net-next 09/12] net: sched: save full flags for tc action
Date:   Fri, 17 Dec 2021 15:21:47 +0100
Message-Id: <20211217142150.17838-10-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2f5c639e-914d-4f00-22f1-08d9c168b353
X-MS-TrafficTypeDiagnostic: PH7PR13MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB5595F7E53447274EA2725EC6E8789@PH7PR13MB5595.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wKBYgCc0yBuYVu9hqJjd1IpwOs0t0eG5sAQd5FaNtIM2MZshqnSTGvD9sIABegoa60lxec4ncj/wdYi7GGUzPXqYciTr7/eDerj34YkIEcT0v95OaNogrWOS3bins7n/h7dfoHdlseXaRkwSskROVKM1n1b+Jnnue6hdRe1xQNXVwDwYKcbBFGMGFHY5TLZroFiDCVd0SYS9m5l7kFifI7bxuVyizO6HaXQowOdvEg1zjgZnl64e35nCGsroXP2EukO+ao/PF4wXf/zU2TKmrz1Thrmau/xZ+GnsM/8intE8EHpPGfXy3P8m+Mz3aFgkexD1pxy7eaBHEGC+sBYZEGV3+DYcvdl+5oeIx6qjeS4JzUzKjVbc6pPbFj32/T3F9Ck23eAAxBLBxKVw1eo5nHa81IrybA4losylxKX5X2p7ek/RUpQ2MM/WQUYT1IwyrGK23wZsrRwcwiXTOcu3qhXHWqJWS/OD4FLQRA+QAOHKcj/6kfUhMqpyr67dpnEPvKW6MxGTU7OcyPvN6EsqIA9XMcPxxH5Jl7cfiVJYZhcDB6ad6wA6JX7OQCf7F1omevHn7CRvtmuno9oBX3nqp5+R77BjpHGKqUjNX44LoajbthUdt7lTR2oaX+KYF0p0xpCY49NFTiFH1ZCpkkOHme7n4ekmeHPMN6BfvxyQsl9ybFcd0p7ZxLbXrN1rUNFy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(39840400004)(346002)(376002)(136003)(110136005)(8936002)(54906003)(8676002)(316002)(66946007)(66476007)(7416002)(2906002)(66556008)(4326008)(86362001)(38100700002)(107886003)(83380400001)(508600001)(1076003)(6486002)(36756003)(6506007)(2616005)(52116002)(5660300002)(44832011)(186003)(6512007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pFI6HdNln5kvgkB75CEEAWhvWUiePZRJNLF9+TNr4+NNWEr0sfvjCOc0SgwG?=
 =?us-ascii?Q?A19/xlIWPkB/1H9BziAFrmbsDlNWDPZ2JVtuLFNOXXxeixvng1cvgh4g/Pj6?=
 =?us-ascii?Q?0bsyj7zZ5bvpi/PPX85ybeWgGBxJb0RTJ30Is7n5C30KnNYVzfoJrSMSGXfq?=
 =?us-ascii?Q?obPR02KWZW04cccw+bG2GgY4Tp10X8/ErjCQhDs8rq4KsJeSfs0FTG2nshTq?=
 =?us-ascii?Q?XyNWb4DEU3M/FTo+komPfEf7i4TKRio2ojEdqDLg7MTzsKAtANYOX/qYwvJm?=
 =?us-ascii?Q?/J1LJk29sW5PtSiP9Caos+6EHDu0jLmC+nmVsQoM8NjkdjIZHnrcuRZi30R1?=
 =?us-ascii?Q?tpH51wd+JJP/rB71prjSRBqh4bujC1BTxwEpMB/RaG83zvAx7QI+b8O7Nhyp?=
 =?us-ascii?Q?qIbxswRs//WnavdynTXC3qGTw1sRoJP3XGLfWKuxbAfrAKsUwmUzzvNBJ1pg?=
 =?us-ascii?Q?9Kx1xhWSJgepzroKDaYbVdk7/Tn/y3IKeesEOXb/KLmdJQTBtdzbhPE63MID?=
 =?us-ascii?Q?FP2EnScEp2ulADtx7g/G9TGlqzrOD2e6wEqeSLU0q2+JXcuYZtMQZWLFWvUd?=
 =?us-ascii?Q?IUnDnwYvvuaX8sDQkOaEN6W0u3Dv+9yvno6y2+TQO6Sp4AltHPu4ebltXQ7L?=
 =?us-ascii?Q?jIX5qW61yM7h5Gl0KCgl2RkK451+/dDavKGjxw2q4WeQdi5L1/aw7KTZU5pk?=
 =?us-ascii?Q?r11+LrIQjWQW6qNq8xZ8dm+bSk5lZ6hh5u3S1giWYIo5ukWkXBUJS/ECMXwf?=
 =?us-ascii?Q?9LyiCSe/YCO5DFKq8Ia671mbtS0C+beOphsC/xoJa9pVC/yh3n5SxXPYlR9t?=
 =?us-ascii?Q?2QVRoizopePdN2pWuvgybuvvevCVL0WGsf2hx/fpRZIlaK1/NfsfW1xQJz8Z?=
 =?us-ascii?Q?CvYBMixa7DweeWF+uKJBvZ98/kt9q2AM9giTeYheLSuraGg4O5/iMvRlDv1Y?=
 =?us-ascii?Q?LVqlhd1Eoahd+0MISsEl8IPQyv0qmdecLKVbY+ENhE2tm3u+UP4dexFwOZGg?=
 =?us-ascii?Q?TAQ6b2IId+7aQYTZF48SOBBVLxtppDD/mDR8dhuT7wODpt+I6DTDauTndiHT?=
 =?us-ascii?Q?VWzw+YkUdNlESotKG/t1pkBEvyGRC4xRf7huLXIKqW8oiFC1C2OfMafyl4/N?=
 =?us-ascii?Q?JQbuoY6EYWlVAoTVYcFx/YyCstXPNn03xXWzRz4Yx0KxErgt1OjJe+IhL/Qz?=
 =?us-ascii?Q?OIqqq3nDQjQtw3obSVtsdo9aDp6I9HO07rkrBu8HdAJXrk+UWxQ7ZO7yyivK?=
 =?us-ascii?Q?07Dvrj8jfslgXneLSQUMvjeLzqzFmJNd09Mp96obmtw/qJKtjHDSiSIxjzT6?=
 =?us-ascii?Q?PyJNBesNDaJZ2cU6Vq4fI77ekeek+i3CApucQARd006LGLOzZBs+7TogbI6m?=
 =?us-ascii?Q?3tvMfk+31OVjrqFf0RAuR04Pf/iHuhX6K4aue9CRMd69bgFBZsELIa9i3a4u?=
 =?us-ascii?Q?tAJBTa/QaRz8Bf7lKBcmzuB5ufPoban7wgeIa79ihFSkVWJHsRwteJRyuQBV?=
 =?us-ascii?Q?yqmgvkkI3r2SLdml6REIryR/eyp54Ll2ShHV+s8AIr9wpNODKvwaztfh4rve?=
 =?us-ascii?Q?5JvaqCjnExH+M3wg+oQJ9FJzTKOGZ+0YyQ0bmrsfoa9Xy/EOqjRu0CGpEOhF?=
 =?us-ascii?Q?vATvHsmu/xRqFKslU+T/OQ0pphCfoNv/PtcrPGcPLzuXThz6VF+Builfayxa?=
 =?us-ascii?Q?Gk1VBNRrd6weho8hS19UpgTX9oTQnxLrdTSCJXHu6s4yfO/0HB+dr98HvioS?=
 =?us-ascii?Q?RUmlIvr0Ug=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5c639e-914d-4f00-22f1-08d9c168b353
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:48.0757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dj8+Tzw8q7BduE4iXxtducAvSw/irg4WiIhKPq/34ONP6ANGjMdqCE9HUTep0bPTz4oMXGssveux88yzgBr0RDQgXKPj5q84EwKzjradWAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5595
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
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/act_api.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index ac6c2c396d4f..75f34e6fdea0 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -669,7 +669,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	p->tcfa_tm.install = jiffies;
 	p->tcfa_tm.lastuse = jiffies;
 	p->tcfa_tm.firstuse = 0;
-	p->tcfa_flags = flags & TCA_ACT_FLAGS_USER_MASK;
+	p->tcfa_flags = flags;
 	if (est) {
 		err = gen_new_estimator(&p->tcfa_bstats, p->cpu_bstats,
 					&p->tcfa_rate_est,
@@ -996,6 +996,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	int err = -EINVAL;
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
+	u32 flags;
 
 	if (tcf_action_dump_terse(skb, a, false))
 		goto nla_put_failure;
@@ -1010,9 +1011,10 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
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

