Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42AE4793D0
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbhLQSSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:18:08 -0500
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com ([104.47.58.105]:24917
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240403AbhLQSR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LV0/Jji18fFfodRPH29JueQJPtg8FX3vshvc6aqa1EoqMiDhDkYmlrcjiyul7WXYu+mn2DFwvHUIAud4S1mombHZWd/wmYt0lRph/K//umk/XuyVF8JWLGPtx1TUSms1SjqLoXYCDxHjJk17dV1ogsGhLNzktmW7WZyP69rkGAf29Q3gcRy4Z0SiHJuFtee456HOOqcpYCGb7eB7PqtOa8Lub06jZN00Ad0tJ7tSpeKsmezGkPXfszybFoy9lvSomYon69MVGw6GOmObU8D9qqUYUUhpH+RbhzXDq+qap7a5v3pWYKvFlg089ZC3PpXFBOsyp7T8ZdqzVK9VsKaZfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BTA7FwwNKF/Y/7KDPQXYZQSBTdlW7E97VIIBj8WcX3A=;
 b=VkvO0S/cR3JstGPI7/hqKsTQS9Z0sv6Fk010OnPxMSdSamXA0PTdaz7VPtVqH8mLD2Qj1sHA5FMQYhv5I1z5Q1ac8uYGQBcmr9XFOpm2KjoJXlMgn6210DoPjwftnrvx5fHSQj9ZMfvc+M5mPuk6MmEKsgwKm6fWF/wK0c/KkATBJryX4YHkzVh+YD6w6mDinoV5n3sTcfNhiXXiu9g84itrP2jysEMU977ROjCJ2uHfBDj++NbxDIYIOL3D2Ht3HkRGwuq6T4d2MPNqMoBljMqsoBt7R75bS59bwbN6AF4uXKrlYBrZAmIB2tM68498Kpzd5xwB842FeQGuVzQTJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTA7FwwNKF/Y/7KDPQXYZQSBTdlW7E97VIIBj8WcX3A=;
 b=rLbYfMS0CtFpXl3kmK+dUidgBx9f9F21be1plMF66Yx4GXU3L2JSxC6v+QnOgr5MNTwOMma7UOZaWPw1TDin3bfF9EoDy0iFEfr3oCFU3n6gEACDP8bCOry/T/kuZ15zXYRt3Tm+eIfUPAo0IUQzxpuDZY3YKNMG97Ser0g310A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5589.namprd13.prod.outlook.com (2603:10b6:510:142::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.9; Fri, 17 Dec
 2021 18:17:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:53 +0000
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
Subject: [PATCH v8 net-next 10/13] net: sched: save full flags for tc action
Date:   Fri, 17 Dec 2021 19:16:26 +0100
Message-Id: <20211217181629.28081-11-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2b629554-dd8e-4b48-ec56-08d9c1898afc
X-MS-TrafficTypeDiagnostic: PH0PR13MB5589:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB558992AD39979E8969ADE6D1E8789@PH0PR13MB5589.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AfORnDuOuhop/SmnQcK5YBtahv35d4Nopm8atCB8i129QyJM0/qeKEntH8QV4O03o40Hswlp54nPW9vmAMVDOHerMEKhUfhT6O080b5ZtPuP1e3tegz5P1eacja3FfzxIbZwT4HJVQRPtKT7rbBOdAdRq7iQQq1Q4YrYhd0cGUXL1HS1lU1D/pOiVxF8ZlSk4b/Ib4X9dw8AZVJahJwNAXZjToHGN9yVxUBvV/LymZzNaTpbCSfzyyRsXVanaffD0ztQqu8mqQZ4zy8b4nq7SlQ0hZQ5873azN2TBpkZ4eTDPCowk8PbG5wM7SNybE+P67frGDobuB755goHwyjcpw8p56A57LdX59WlqE2sIOR5MLAbYy4YwVBOpf1LAipqs8yBmUWy0BXILXbgUG5hGrlP3r4qK94mke75DoZlFgVFuKXYpo6HnqLRfQzAUr4gtQ5yzNCPiQaTwoeov0o9i+GQZ7zOfrqgO4WS7Cwn4TVcKamjGFZ3lrtA7S7HHW4I/+N0ZKb9SWSTxzF9pBdokA2PoOfTQdVDWnWEVGmFi9GiAV0g/adH+hxsE87O/95Z1RtkObbbNwlucU7ekz1kOJaULsG//cdtGoyvCQT0qEgSC8v5bw9lMhUWwXDbuJVyqfzloVpNn2eBkoZ8rMKZ7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(366004)(39840400004)(396003)(136003)(508600001)(107886003)(52116002)(6666004)(6512007)(86362001)(2616005)(6486002)(186003)(83380400001)(1076003)(8676002)(316002)(6506007)(2906002)(54906003)(66946007)(44832011)(110136005)(7416002)(4326008)(8936002)(66476007)(66556008)(5660300002)(36756003)(38100700002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SDSbRJpO1QYDaoOzV1D7Umqg9Pahf1oBQwn71V2CKQdBM79u3hmCESqUdRjb?=
 =?us-ascii?Q?zh2c0QqXS81OmFbZDlSs+b1TCFKyAjeohYZxgeSp39neDBq/C3z7AiQn9/wB?=
 =?us-ascii?Q?5IhkfQuEEhWP9PqrqVmOWY+6iRoHHjTUuEnRtwW36z1TWx4AK4llT4Nc8/11?=
 =?us-ascii?Q?EjARTIRBj6JTYfLYotBklauhv8qwIC+NyjDCVR0hh9uuMj+h2vCMYPygDGAl?=
 =?us-ascii?Q?Kmk3W+QqvFdz7vJnsIvlyJhp0yfy9plxUBuKeDUeu5hoG4peZFBZG7wOA/hE?=
 =?us-ascii?Q?ymeL+ZNSOsoerikf50cpqpAIQysVciBuAObKvbqbFqtkarIDnndUtooZ93tA?=
 =?us-ascii?Q?vGUZFmwjJXw9dhuEzxrlZNe6xD4C0mIB1gmHdMo4YuhaKj8JMCEC7kyzvLfc?=
 =?us-ascii?Q?GBKqqXIjmotrZHa/zqUm4RWa/Grk4xo1G6rXmJYNnWhxMFDV3Y5qg5kotTYo?=
 =?us-ascii?Q?ApvUX7AZUHTgn4xKEHE1N3EiMG/i4fqLjvD+SkKkH9mP4qhQiGSoO9ihuAEq?=
 =?us-ascii?Q?TMce3ZGHQgQIYIpfJ7H6S2esI5w4wG4jtEVU3Izc6+Tu4wRElJ5GsY/uVY7X?=
 =?us-ascii?Q?Izki6C/5N5uDHpZZG6dZWqBU/jXcu0lNZwSFDk4xryE8lz1rxJzcISLivKGN?=
 =?us-ascii?Q?X6MCVKvu+qxK5BpduZ8Tk3ptoINylgLlJvjAJRheuf7XoPl9Jpf2HDH33VEX?=
 =?us-ascii?Q?xVIr0Q0wL0888jZMTjyEvOdjhYTphoLEKUPemOdCH4IShGNHD+LPJZFrM9dk?=
 =?us-ascii?Q?anjdCI/hU4sBkgmysOffRMFaKGJyyxl4zbaCHr4gqEQXLyT49DoG8cAeKCpR?=
 =?us-ascii?Q?sgpV4ycSKjnWmGCGNdGGlqBsQ0fGivf5NWvL78gmgRxJhgpS66Yd4rqo/fle?=
 =?us-ascii?Q?DFnsEExhHz8WknkEg+gjFSjPLTfQmVLzMbG8zr9SizCxajfy/KBJ7m5WvbO9?=
 =?us-ascii?Q?Ut958A7OOBUa9YPcHIyPE8SsyCmDGUDb8ykHhZ+oL0x0O7mFLFse7JQ2XpRN?=
 =?us-ascii?Q?/mdgPSwm3KTuZpT903aRo6y1LtH+3hEOa3krTC4JkIks1WzJFsz/9OO4afNu?=
 =?us-ascii?Q?4sMYbvIgbZP+funaWV6CqRjlbYvNrbN0PmIAbFT5r09jZzZx3Ji0X6Hy6Ee1?=
 =?us-ascii?Q?kyFBTPrrYM9LQU9eRV3i/Tkhkql1nxM7i4AtO3lzGTHF84/OnlqJZkLs63BK?=
 =?us-ascii?Q?R/W4CLyYaQjaIxM5UbpOAgplbcMuk+zfAOoBZM6Z6ztNnbEn0EpegiHJUSdw?=
 =?us-ascii?Q?7B4qU+aYP5exlD5epZ+urhaIx0bVizU2i7F9RRwflcLHG3MdBIwW2V7PaUIm?=
 =?us-ascii?Q?Uy6POKajY4VFD1RM6CuW64phfOCecFa9/W2uYH/MPrSwwRrgRYGFYp/BTKpY?=
 =?us-ascii?Q?GXntAiAbgFXUkZIdHBqvlje7WCLC6qoZcYucBVnDikm7T5bXp5oIpQZTmLTM?=
 =?us-ascii?Q?dfLTzVaAs0UU4umXaAEvrrHeOXZkz855nWql1fgIILSGByHbQlr7bYgZfQNK?=
 =?us-ascii?Q?jVYqWlOsqjsHJ5PjkoBmhAZtKNaSGGxNYAuzLL4ndljvU4oGuSOgUy2y9FY1?=
 =?us-ascii?Q?N9tODqnXeW7QuuJR76zbEQtuzQyVHGGk+jmydnavbz/3iK7St8VYV5e/1aTU?=
 =?us-ascii?Q?CPOFo31dDCjcjs3Q60+0SRoYhWBmOxm21Ifxp61p74jSfkqjR8Tg5a04RM81?=
 =?us-ascii?Q?vWSTqOgtccZ6xeLLlVAAmKpiC3ahachK8frt4nFLAaKoiYIRNDKLDzyJlhrN?=
 =?us-ascii?Q?NfrHfNlnJg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b629554-dd8e-4b48-ec56-08d9c1898afc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:53.7790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MBfedWsZ/FxfN9nQaVUxZTnelhV+fuk8GjI6gUcRon+N9QQY7kw6WFfXWkcXTCQ2CnaYKzItrD84apY4ZCGhbqLuuju9bBeB5RBw9o/tgjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5589
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
index f9186f283488..b32680ad75d3 100644
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

