Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754774793C0
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240244AbhLQSRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:17:33 -0500
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com ([104.47.58.104]:6099
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240237AbhLQSRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HL+y4OATlWjZWYdayFLxWAxP8vYnTkW813SZrk/TroVvoBqAqASJvvH9sXWodsNply385Ut8xOgXemYXxzJweET/GFC+OQEbmwfuTNt7rhUzg+kTb3R/hoqJV02bTgKP/qOG+F6oIikIdJukku4/I8NiRDTKxrSiOVYkxo1C4A1UL+5Gr3oCQeU4h5LWWNjj7x3LcipBxD2tRGuuLDBtBSOZUCLiMQQupjgDQBimPPnMiYlYWtXIJ9J2AXZrUmfb970z+SnV8EtI85iy4a+4ttgSSNKGQmZcn0ccH4vDKcYtoGYYuVUT61IYZu+EkiRlzZ3mMJ85b8QiUhEDqq7O+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MZZiclSoRMq7iLCn8kRfs/GVfnwOPivvtL5sJ/LC6Q=;
 b=Syn0S2Y7oOiUt5WUYFSfqZNxouG81P5DRduv5zg0XHb7jOk8Rao/Z3xLDFmtLzh8tzopHB5qHgN5M1EjNff4J7mOL0bp5OIvNlh2rsLwdGv1VN4JReqA58wsVWTl6KR4+Ft+rw6fOkUVEPOoM6+VLgWLkO/UeXFeafAY4cZaADb2YP7kRzFGn/kLpsjNIicQ8KAvRfLAh4KYs9kevm7j4jpBu7iAFnod87jF/G77FTwXnCt7oJw7KxFfIpuDhmJAS53m3D2MxvUrZBZKoOneydOh4CYc0kxKwvHxNyLINANebYHcmyp6RuLFPXC2Ks2vdlotrkRBlzzDnS0FowrcSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MZZiclSoRMq7iLCn8kRfs/GVfnwOPivvtL5sJ/LC6Q=;
 b=sg8IZzNnjmTWwwrsmmDVm3/vfi1zTXliPU2OqsZ724KBng3Uc+nadgmkJJISy18LlysvyIeNrHgrgjmJAbgHW4q/fnf/I4lxn5S0AH9kH+Ft1iLMnvTe/517CNJpbvABAe19/0Y9B6yVoM42bVAjysTi6+uOYM/w7XFnAaz0zjs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5589.namprd13.prod.outlook.com (2603:10b6:510:142::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.9; Fri, 17 Dec
 2021 18:17:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:30 +0000
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
Subject: [PATCH v8 net-next 05/13] flow_offload: add ops to tc_action_ops for flow action setup
Date:   Fri, 17 Dec 2021 19:16:21 +0100
Message-Id: <20211217181629.28081-6-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 570955c0-b3ff-413b-3dfb-08d9c1897cff
X-MS-TrafficTypeDiagnostic: PH0PR13MB5589:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5589AE4126D2EF04846DCD13E8789@PH0PR13MB5589.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5ABALPbLwxoZL+4YQe1jfqe6d/Wa0tuazZEJsD709tUxjkXccBiVo9f/F6EBY5cE2DgOurJOCB7uKRJ9N8vyCcNei5rVIz8XSmefCqV6Je7t0GzSawLsE5onZVcVEAwMvNc9TT+YSFSLIqMsDe/r5GQNY3kFqWx7cge+OO1mbpqBQGQZgRnqGW7yDmeqg2sanRvXlgfgij/ZynfawLPnsUkjb+PpOv6LRUBIQb+pq9BqR6P8DdqThY+RpF4CBipQt6Zu7KUDS2wjNWl12QBB6qUQpvzXFYGk1Z/f/CZ5phVxUYjWw+MPypG4RjVTHVMG7ZBHxx8KnDz8hNE+NFTwoLtEQ7C2fq3luSmgqgu4YbfrdpT7prmqDnJ3j9z/a0qhVkMevCsvA0iDowDinYpfcKs/Ss3T0aA1SxQUeoiE2a4mAAV+OeVh2aPtDeO2YN/B3TFE0bT4C9LdYYXZs6UnpSyFbzEswDN1iiE6la1y9uRz5zESmNXbWjmxtrVc0XQN/OnPt/C4oOGsZ2ImITxny9I/I7LMf+jMfkjDNUL4tNb76lnoYP0RIt2Fv+1kpO3qpcKUrwFsxzh57qMe6cxNL7HNkaroVAxeFY3t5BLe+kSB8CT+dE1n9iZnCwXE80O5Cq2khKykauTrdVx2OwEmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(366004)(39840400004)(396003)(136003)(508600001)(107886003)(52116002)(6666004)(6512007)(86362001)(2616005)(6486002)(186003)(83380400001)(1076003)(8676002)(316002)(6506007)(2906002)(54906003)(66946007)(44832011)(110136005)(30864003)(7416002)(4326008)(8936002)(66476007)(66556008)(5660300002)(36756003)(38100700002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3XieyUWRG1AJq8eaYxdtOtLqSJGOTkB8/tuoL34MjBDTI6jdnONOX7/dLzxu?=
 =?us-ascii?Q?vio4M/Glw4KEY8NV3gWbt0OjvwO4j0rIcvOPZC0hKI+ECnvPq50l2lG2TTwU?=
 =?us-ascii?Q?YmaDdw2pzVcjLUiQ6EB1h7u1N8bGdOdsJDI942vWk4Vfc4psPZwx5OV/Y5Hf?=
 =?us-ascii?Q?mwgXj3wUpaX2580yF/2Q09vkzTK8TPLYxNetkgxhQdANR0fso8dXOCgyq/S0?=
 =?us-ascii?Q?lXcYOBLcJCQ8u752kLU+Wjv+YO/IELsNFJtTJEIdGvAJ3F00bAGro6oHaZT1?=
 =?us-ascii?Q?aPy/bplLfDzVnEJvtaumiqFsmqBRS43wrm0KyQwz5gswcUYhjC+xP75gnhyc?=
 =?us-ascii?Q?THWDda9naqcMj/UrBtawBTbV14tr8BNCf39NUOGx8nNBElSurx3xh/+wWEOA?=
 =?us-ascii?Q?6D+6T1yA7cARK1+fJhvlz2WGVqD97uJGlZypyR77LG8DiI3gl+b/Pb+tCQ7d?=
 =?us-ascii?Q?OdFh7tyL8xrEjOVMsq1DVrfPViqGIyQLiQrHPdCJJiXlGTiXND+IQgb8lneX?=
 =?us-ascii?Q?7A0b52bsNURUWFWWc9fZeiRwtCKbXuvAxdCrstvxsZoKrn0E37zk9qT0z7Og?=
 =?us-ascii?Q?rqy26MO0XYD8wCB0Q2zvyKJLbmlrt/NXp4bkbZdumSgktSO3Mp8kvwRmANZ8?=
 =?us-ascii?Q?Gbd49hUc95ndglXM4LfHgRxQacKdfrX84g2eUM/jT7MGptXyUNg5jSkbL+tn?=
 =?us-ascii?Q?io7gXqRKyUDDUX3X8BIYiPHwTDdJWZ5ulWxZJoZAXfdYF/MH4hB26sJioOHL?=
 =?us-ascii?Q?W+bgaR5U88Ynd0Aes5USPW3ohU4y34ftBEfvjHj8YlTgwmqZSXzrJNNA0Sm/?=
 =?us-ascii?Q?k+Ta4jYikElqvQCsIXpglEY4Oh190mFOvP71CTuXwf+rKoA1yaSr6Mp25RWH?=
 =?us-ascii?Q?plc/qqXCOuQMMFq+SuQ7uunRs+Ncq+EhULtRyxor5BAgS50P9bTDfftxD3GF?=
 =?us-ascii?Q?SxvHFKrPk38N0HpWjaXS5BOwkrldsmN4qyYsh3+IqCas6Nl4EYJVSXF3zNyM?=
 =?us-ascii?Q?dGQbMQf5M+jjZDQIxQbLxMDHo/WbJty9DC/O400StgtUmoZnW/oeLvfFbsGL?=
 =?us-ascii?Q?7snukKSFZH1y5wZdj2offJKi/0FMs2ADnJW6WvFf2vrULbO4lud7mQL02jAc?=
 =?us-ascii?Q?hrA0bGuaYjeuAwd+ZD4uVIkw1FnGzUlaPZI25l4glheZFCBL6nfVrRNAE8si?=
 =?us-ascii?Q?PPMJCdtD7hb97YwbThtv+rRcmX2xw9YYyDN8l1/obAm+M2WPwMwoYXntUUbV?=
 =?us-ascii?Q?HX8xrqJNW4EePYtqDmuyYV0audVETQRhJm7RK3hO2tdKGAnt1EPkp/U72JNz?=
 =?us-ascii?Q?/4UsvnNTC6h9Baax/uIw7o3RlJC9q+IBZU4z/MxSARM7EG5sHLP08GQns2He?=
 =?us-ascii?Q?ivNgrx1NP+duLGNz9xlJ5+RZC4Q69KG2LyeSj53H5tELaQ0x17iTV67azSJx?=
 =?us-ascii?Q?vuYyRCRUGcjQGYB0CQ+3IH2+Q/UB3hpuN3BraS/SvrBi8TxZhuMI3D1Qw/9b?=
 =?us-ascii?Q?Mf7wg0JS69vt311oPTcrrnY8801/paz9zXo2GOBw+LncbFhKHy2IuJw8cPam?=
 =?us-ascii?Q?TZvRuQn8uvA2J5YC3fWpfEx8LY8udEl9zsqlIzFkSMiFQJQmlUIctnB+8rcc?=
 =?us-ascii?Q?lKVpJGYYjborKzv1aaoWVz4OiPGMeTw4MjOdhWwQMLkBR+xItGhmIPE+wNT4?=
 =?us-ascii?Q?h09aoRky+q3nKBXmJZTMHDHuzd5LLIXzVFNCkzWETtXt7wLIpWPy3cNANY3f?=
 =?us-ascii?Q?kLxGNmIWKw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570955c0-b3ff-413b-3dfb-08d9c1897cff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:30.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fmWCOyMO+S39i1BFjy0Xh68nhe+4AJIjOBVoTpmgLXnuQsGCBodd64CdX4EPvvbisQqdViqSulcN92DLvJA9ANHVLIQKxuCmbRRwfdtte4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5589
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add a new ops to tc_action_ops for flow action setup.

Refactor function tc_setup_flow_action to use this new ops.

We make this change to facilitate to add standalone action module.

We will also use this ops to offload action independent of filter
in following patch.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h      |  12 ++
 net/sched/act_csum.c       |  17 +++
 net/sched/act_ct.c         |  19 ++++
 net/sched/act_gact.c       |  27 +++++
 net/sched/act_gate.c       |  47 ++++++++
 net/sched/act_mirred.c     |  39 +++++++
 net/sched/act_mpls.c       |  38 +++++++
 net/sched/act_pedit.c      |  34 ++++++
 net/sched/act_police.c     |  23 ++++
 net/sched/act_sample.c     |  28 +++++
 net/sched/act_skbedit.c    |  27 +++++
 net/sched/act_tunnel_key.c |  47 ++++++++
 net/sched/act_vlan.c       |  34 ++++++
 net/sched/cls_api.c        | 222 +++----------------------------------
 14 files changed, 406 insertions(+), 208 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index b5b624c7e488..b418bb0e44e0 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -88,6 +88,16 @@ static inline void tcf_tm_dump(struct tcf_t *dtm, const struct tcf_t *stm)
 	dtm->expires = jiffies_to_clock_t(stm->expires);
 }
 
+static inline enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
+{
+	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
+		return FLOW_ACTION_HW_STATS_DONT_CARE;
+	else if (!hw_stats)
+		return FLOW_ACTION_HW_STATS_DISABLED;
+
+	return hw_stats;
+}
+
 #ifdef CONFIG_NET_CLS_ACT
 
 #define ACT_P_CREATED 1
@@ -121,6 +131,8 @@ struct tc_action_ops {
 	struct psample_group *
 	(*get_psample_group)(const struct tc_action *a,
 			     tc_action_priv_destructor *destructor);
+	int     (*offload_act_setup)(struct tc_action *act, void *entry_data,
+				     u32 *index_inc, bool bind);
 };
 
 struct tc_action_net {
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index a15ec95e69c3..4428852a03d7 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -695,6 +695,22 @@ static size_t tcf_csum_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_csum));
 }
 
+static int tcf_csum_offload_act_setup(struct tc_action *act, void *entry_data,
+				      u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_CSUM;
+		entry->csum_flags = tcf_csum_update_flags(act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_csum_ops = {
 	.kind		= "csum",
 	.id		= TCA_ID_CSUM,
@@ -706,6 +722,7 @@ static struct tc_action_ops act_csum_ops = {
 	.walk		= tcf_csum_walker,
 	.lookup		= tcf_csum_search,
 	.get_fill_size  = tcf_csum_get_fill_size,
+	.offload_act_setup = tcf_csum_offload_act_setup,
 	.size		= sizeof(struct tcf_csum),
 };
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ab1810f2e660..dc64f31e5191 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1493,6 +1493,24 @@ static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
 	c->tcf_tm.lastuse = max_t(u64, c->tcf_tm.lastuse, lastuse);
 }
 
+static int tcf_ct_offload_act_setup(struct tc_action *act, void *entry_data,
+				    u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_CT;
+		entry->ct.action = tcf_ct_action(act);
+		entry->ct.zone = tcf_ct_zone(act);
+		entry->ct.flow_table = tcf_ct_ft(act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_ct_ops = {
 	.kind		=	"ct",
 	.id		=	TCA_ID_CT,
@@ -1504,6 +1522,7 @@ static struct tc_action_ops act_ct_ops = {
 	.walk		=	tcf_ct_walker,
 	.lookup		=	tcf_ct_search,
 	.stats_update	=	tcf_stats_update,
+	.offload_act_setup =	tcf_ct_offload_act_setup,
 	.size		=	sizeof(struct tcf_ct),
 };
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index d8dce173df37..f77be22069f4 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -252,6 +252,32 @@ static size_t tcf_gact_get_fill_size(const struct tc_action *act)
 	return sz;
 }
 
+static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
+				      u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_gact_ok(act)) {
+			entry->id = FLOW_ACTION_ACCEPT;
+		} else if (is_tcf_gact_shot(act)) {
+			entry->id = FLOW_ACTION_DROP;
+		} else if (is_tcf_gact_trap(act)) {
+			entry->id = FLOW_ACTION_TRAP;
+		} else if (is_tcf_gact_goto_chain(act)) {
+			entry->id = FLOW_ACTION_GOTO;
+			entry->chain_index = tcf_gact_goto_chain_index(act);
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_gact_ops = {
 	.kind		=	"gact",
 	.id		=	TCA_ID_GACT,
@@ -263,6 +289,7 @@ static struct tc_action_ops act_gact_ops = {
 	.walk		=	tcf_gact_walker,
 	.lookup		=	tcf_gact_search,
 	.get_fill_size	=	tcf_gact_get_fill_size,
+	.offload_act_setup =	tcf_gact_offload_act_setup,
 	.size		=	sizeof(struct tcf_gact),
 };
 
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index ac985c53ebaf..1d8297497692 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -597,6 +597,52 @@ static size_t tcf_gate_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_gate));
 }
 
+static void tcf_gate_entry_destructor(void *priv)
+{
+	struct action_gate_entry *oe = priv;
+
+	kfree(oe);
+}
+
+static int tcf_gate_get_entries(struct flow_action_entry *entry,
+				const struct tc_action *act)
+{
+	entry->gate.entries = tcf_gate_get_list(act);
+
+	if (!entry->gate.entries)
+		return -EINVAL;
+
+	entry->destructor = tcf_gate_entry_destructor;
+	entry->destructor_priv = entry->gate.entries;
+
+	return 0;
+}
+
+static int tcf_gate_offload_act_setup(struct tc_action *act, void *entry_data,
+				      u32 *index_inc, bool bind)
+{
+	int err;
+
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_GATE;
+		entry->gate.prio = tcf_gate_prio(act);
+		entry->gate.basetime = tcf_gate_basetime(act);
+		entry->gate.cycletime = tcf_gate_cycletime(act);
+		entry->gate.cycletimeext = tcf_gate_cycletimeext(act);
+		entry->gate.num_entries = tcf_gate_num_entries(act);
+		err = tcf_gate_get_entries(entry, act);
+		if (err)
+			return err;
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_gate_ops = {
 	.kind		=	"gate",
 	.id		=	TCA_ID_GATE,
@@ -609,6 +655,7 @@ static struct tc_action_ops act_gate_ops = {
 	.stats_update	=	tcf_gate_stats_update,
 	.get_fill_size	=	tcf_gate_get_fill_size,
 	.lookup		=	tcf_gate_search,
+	.offload_act_setup =	tcf_gate_offload_act_setup,
 	.size		=	sizeof(struct tcf_gate),
 };
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 952416bd65e6..8eecf55be0a2 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -450,6 +450,44 @@ static size_t tcf_mirred_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_mirred));
 }
 
+static void tcf_offload_mirred_get_dev(struct flow_action_entry *entry,
+				       const struct tc_action *act)
+{
+	entry->dev = act->ops->get_dev(act, &entry->destructor);
+	if (!entry->dev)
+		return;
+	entry->destructor_priv = entry->dev;
+}
+
+static int tcf_mirred_offload_act_setup(struct tc_action *act, void *entry_data,
+					u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_mirred_egress_redirect(act)) {
+			entry->id = FLOW_ACTION_REDIRECT;
+			tcf_offload_mirred_get_dev(entry, act);
+		} else if (is_tcf_mirred_egress_mirror(act)) {
+			entry->id = FLOW_ACTION_MIRRED;
+			tcf_offload_mirred_get_dev(entry, act);
+		} else if (is_tcf_mirred_ingress_redirect(act)) {
+			entry->id = FLOW_ACTION_REDIRECT_INGRESS;
+			tcf_offload_mirred_get_dev(entry, act);
+		} else if (is_tcf_mirred_ingress_mirror(act)) {
+			entry->id = FLOW_ACTION_MIRRED_INGRESS;
+			tcf_offload_mirred_get_dev(entry, act);
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_mirred_ops = {
 	.kind		=	"mirred",
 	.id		=	TCA_ID_MIRRED,
@@ -462,6 +500,7 @@ static struct tc_action_ops act_mirred_ops = {
 	.walk		=	tcf_mirred_walker,
 	.lookup		=	tcf_mirred_search,
 	.get_fill_size	=	tcf_mirred_get_fill_size,
+	.offload_act_setup =	tcf_mirred_offload_act_setup,
 	.size		=	sizeof(struct tcf_mirred),
 	.get_dev	=	tcf_mirred_get_dev,
 };
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 2b30dc562743..a4615e1331e0 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -384,6 +384,43 @@ static int tcf_mpls_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_mpls_offload_act_setup(struct tc_action *act, void *entry_data,
+				      u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		switch (tcf_mpls_action(act)) {
+		case TCA_MPLS_ACT_PUSH:
+			entry->id = FLOW_ACTION_MPLS_PUSH;
+			entry->mpls_push.proto = tcf_mpls_proto(act);
+			entry->mpls_push.label = tcf_mpls_label(act);
+			entry->mpls_push.tc = tcf_mpls_tc(act);
+			entry->mpls_push.bos = tcf_mpls_bos(act);
+			entry->mpls_push.ttl = tcf_mpls_ttl(act);
+			break;
+		case TCA_MPLS_ACT_POP:
+			entry->id = FLOW_ACTION_MPLS_POP;
+			entry->mpls_pop.proto = tcf_mpls_proto(act);
+			break;
+		case TCA_MPLS_ACT_MODIFY:
+			entry->id = FLOW_ACTION_MPLS_MANGLE;
+			entry->mpls_mangle.label = tcf_mpls_label(act);
+			entry->mpls_mangle.tc = tcf_mpls_tc(act);
+			entry->mpls_mangle.bos = tcf_mpls_bos(act);
+			entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_mpls_ops = {
 	.kind		=	"mpls",
 	.id		=	TCA_ID_MPLS,
@@ -394,6 +431,7 @@ static struct tc_action_ops act_mpls_ops = {
 	.cleanup	=	tcf_mpls_cleanup,
 	.walk		=	tcf_mpls_walker,
 	.lookup		=	tcf_mpls_search,
+	.offload_act_setup =	tcf_mpls_offload_act_setup,
 	.size		=	sizeof(struct tcf_mpls),
 };
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index cd3b8aad3192..31fcd279c177 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -487,6 +487,39 @@ static int tcf_pedit_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
+				       u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+		int k;
+
+		for (k = 0; k < tcf_pedit_nkeys(act); k++) {
+			switch (tcf_pedit_cmd(act, k)) {
+			case TCA_PEDIT_KEY_EX_CMD_SET:
+				entry->id = FLOW_ACTION_MANGLE;
+				break;
+			case TCA_PEDIT_KEY_EX_CMD_ADD:
+				entry->id = FLOW_ACTION_ADD;
+				break;
+			default:
+				return -EOPNOTSUPP;
+			}
+			entry->mangle.htype = tcf_pedit_htype(act, k);
+			entry->mangle.mask = tcf_pedit_mask(act, k);
+			entry->mangle.val = tcf_pedit_val(act, k);
+			entry->mangle.offset = tcf_pedit_offset(act, k);
+			entry->hw_stats = tc_act_hw_stats(act->hw_stats);
+			entry++;
+		}
+		*index_inc = k;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_pedit_ops = {
 	.kind		=	"pedit",
 	.id		=	TCA_ID_PEDIT,
@@ -498,6 +531,7 @@ static struct tc_action_ops act_pedit_ops = {
 	.init		=	tcf_pedit_init,
 	.walk		=	tcf_pedit_walker,
 	.lookup		=	tcf_pedit_search,
+	.offload_act_setup =	tcf_pedit_offload_act_setup,
 	.size		=	sizeof(struct tcf_pedit),
 };
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index c13a6245dfba..abb6d16a20b2 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -405,6 +405,28 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
+					u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_POLICE;
+		entry->police.burst = tcf_police_burst(act);
+		entry->police.rate_bytes_ps =
+			tcf_police_rate_bytes_ps(act);
+		entry->police.burst_pkt = tcf_police_burst_pkt(act);
+		entry->police.rate_pkt_ps =
+			tcf_police_rate_pkt_ps(act);
+		entry->police.mtu = tcf_police_tcfp_mtu(act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 MODULE_AUTHOR("Alexey Kuznetsov");
 MODULE_DESCRIPTION("Policing actions");
 MODULE_LICENSE("GPL");
@@ -420,6 +442,7 @@ static struct tc_action_ops act_police_ops = {
 	.walk		=	tcf_police_walker,
 	.lookup		=	tcf_police_search,
 	.cleanup	=	tcf_police_cleanup,
+	.offload_act_setup =	tcf_police_offload_act_setup,
 	.size		=	sizeof(struct tcf_police),
 };
 
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 91a7a93d5f6a..07e56903211e 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -282,6 +282,33 @@ tcf_sample_get_group(const struct tc_action *a,
 	return group;
 }
 
+static void tcf_offload_sample_get_group(struct flow_action_entry *entry,
+					 const struct tc_action *act)
+{
+	entry->sample.psample_group =
+		act->ops->get_psample_group(act, &entry->destructor);
+	entry->destructor_priv = entry->sample.psample_group;
+}
+
+static int tcf_sample_offload_act_setup(struct tc_action *act, void *entry_data,
+					u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_SAMPLE;
+		entry->sample.trunc_size = tcf_sample_trunc_size(act);
+		entry->sample.truncate = tcf_sample_truncate(act);
+		entry->sample.rate = tcf_sample_rate(act);
+		tcf_offload_sample_get_group(entry, act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_sample_ops = {
 	.kind	  = "sample",
 	.id	  = TCA_ID_SAMPLE,
@@ -294,6 +321,7 @@ static struct tc_action_ops act_sample_ops = {
 	.walk	  = tcf_sample_walker,
 	.lookup	  = tcf_sample_search,
 	.get_psample_group = tcf_sample_get_group,
+	.offload_act_setup    = tcf_sample_offload_act_setup,
 	.size	  = sizeof(struct tcf_sample),
 };
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index f6df717b9f17..c380f9e6cc95 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -327,6 +327,32 @@ static size_t tcf_skbedit_get_fill_size(const struct tc_action *act)
 		+ nla_total_size_64bit(sizeof(u64)); /* TCA_SKBEDIT_FLAGS */
 }
 
+static int tcf_skbedit_offload_act_setup(struct tc_action *act, void *entry_data,
+					 u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_skbedit_mark(act)) {
+			entry->id = FLOW_ACTION_MARK;
+			entry->mark = tcf_skbedit_mark(act);
+		} else if (is_tcf_skbedit_ptype(act)) {
+			entry->id = FLOW_ACTION_PTYPE;
+			entry->ptype = tcf_skbedit_ptype(act);
+		} else if (is_tcf_skbedit_priority(act)) {
+			entry->id = FLOW_ACTION_PRIORITY;
+			entry->priority = tcf_skbedit_priority(act);
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_skbedit_ops = {
 	.kind		=	"skbedit",
 	.id		=	TCA_ID_SKBEDIT,
@@ -339,6 +365,7 @@ static struct tc_action_ops act_skbedit_ops = {
 	.walk		=	tcf_skbedit_walker,
 	.get_fill_size	=	tcf_skbedit_get_fill_size,
 	.lookup		=	tcf_skbedit_search,
+	.offload_act_setup =	tcf_skbedit_offload_act_setup,
 	.size		=	sizeof(struct tcf_skbedit),
 };
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index d9cd174eecb7..e96a65a5323e 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -787,6 +787,52 @@ static int tunnel_key_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static void tcf_tunnel_encap_put_tunnel(void *priv)
+{
+	struct ip_tunnel_info *tunnel = priv;
+
+	kfree(tunnel);
+}
+
+static int tcf_tunnel_encap_get_tunnel(struct flow_action_entry *entry,
+				       const struct tc_action *act)
+{
+	entry->tunnel = tcf_tunnel_info_copy(act);
+	if (!entry->tunnel)
+		return -ENOMEM;
+	entry->destructor = tcf_tunnel_encap_put_tunnel;
+	entry->destructor_priv = entry->tunnel;
+	return 0;
+}
+
+static int tcf_tunnel_key_offload_act_setup(struct tc_action *act,
+					    void *entry_data,
+					    u32 *index_inc,
+					    bool bind)
+{
+	int err;
+
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_tunnel_set(act)) {
+			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
+			err = tcf_tunnel_encap_get_tunnel(entry, act);
+			if (err)
+				return err;
+		} else if (is_tcf_tunnel_release(act)) {
+			entry->id = FLOW_ACTION_TUNNEL_DECAP;
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_tunnel_key_ops = {
 	.kind		=	"tunnel_key",
 	.id		=	TCA_ID_TUNNEL_KEY,
@@ -797,6 +843,7 @@ static struct tc_action_ops act_tunnel_key_ops = {
 	.cleanup	=	tunnel_key_release,
 	.walk		=	tunnel_key_walker,
 	.lookup		=	tunnel_key_search,
+	.offload_act_setup =	tcf_tunnel_key_offload_act_setup,
 	.size		=	sizeof(struct tcf_tunnel_key),
 };
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index e4dc5a555bd8..0300792084f0 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -368,6 +368,39 @@ static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
 		+ nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
 }
 
+static int tcf_vlan_offload_act_setup(struct tc_action *act, void *entry_data,
+				      u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		switch (tcf_vlan_action(act)) {
+		case TCA_VLAN_ACT_PUSH:
+			entry->id = FLOW_ACTION_VLAN_PUSH;
+			entry->vlan.vid = tcf_vlan_push_vid(act);
+			entry->vlan.proto = tcf_vlan_push_proto(act);
+			entry->vlan.prio = tcf_vlan_push_prio(act);
+			break;
+		case TCA_VLAN_ACT_POP:
+			entry->id = FLOW_ACTION_VLAN_POP;
+			break;
+		case TCA_VLAN_ACT_MODIFY:
+			entry->id = FLOW_ACTION_VLAN_MANGLE;
+			entry->vlan.vid = tcf_vlan_push_vid(act);
+			entry->vlan.proto = tcf_vlan_push_proto(act);
+			entry->vlan.prio = tcf_vlan_push_prio(act);
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_vlan_ops = {
 	.kind		=	"vlan",
 	.id		=	TCA_ID_VLAN,
@@ -380,6 +413,7 @@ static struct tc_action_ops act_vlan_ops = {
 	.stats_update	=	tcf_vlan_stats_update,
 	.get_fill_size	=	tcf_vlan_get_fill_size,
 	.lookup		=	tcf_vlan_search,
+	.offload_act_setup =	tcf_vlan_offload_act_setup,
 	.size		=	sizeof(struct tcf_vlan),
 };
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 61b5012c65dc..53f263c9a725 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3474,81 +3474,25 @@ void tc_cleanup_offload_action(struct flow_action *flow_action)
 }
 EXPORT_SYMBOL(tc_cleanup_offload_action);
 
-static void tcf_mirred_get_dev(struct flow_action_entry *entry,
-			       const struct tc_action *act)
+static int tc_setup_offload_act(struct tc_action *act,
+				struct flow_action_entry *entry,
+				u32 *index_inc)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	entry->dev = act->ops->get_dev(act, &entry->destructor);
-	if (!entry->dev)
-		return;
-	entry->destructor_priv = entry->dev;
-#endif
-}
-
-static void tcf_tunnel_encap_put_tunnel(void *priv)
-{
-	struct ip_tunnel_info *tunnel = priv;
-
-	kfree(tunnel);
-}
-
-static int tcf_tunnel_encap_get_tunnel(struct flow_action_entry *entry,
-				       const struct tc_action *act)
-{
-	entry->tunnel = tcf_tunnel_info_copy(act);
-	if (!entry->tunnel)
-		return -ENOMEM;
-	entry->destructor = tcf_tunnel_encap_put_tunnel;
-	entry->destructor_priv = entry->tunnel;
+	if (act->ops->offload_act_setup)
+		return act->ops->offload_act_setup(act, entry, index_inc, true);
+	else
+		return -EOPNOTSUPP;
+#else
 	return 0;
-}
-
-static void tcf_sample_get_group(struct flow_action_entry *entry,
-				 const struct tc_action *act)
-{
-#ifdef CONFIG_NET_CLS_ACT
-	entry->sample.psample_group =
-		act->ops->get_psample_group(act, &entry->destructor);
-	entry->destructor_priv = entry->sample.psample_group;
 #endif
 }
 
-static void tcf_gate_entry_destructor(void *priv)
-{
-	struct action_gate_entry *oe = priv;
-
-	kfree(oe);
-}
-
-static int tcf_gate_get_entries(struct flow_action_entry *entry,
-				const struct tc_action *act)
-{
-	entry->gate.entries = tcf_gate_get_list(act);
-
-	if (!entry->gate.entries)
-		return -EINVAL;
-
-	entry->destructor = tcf_gate_entry_destructor;
-	entry->destructor_priv = entry->gate.entries;
-
-	return 0;
-}
-
-static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
-{
-	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
-		return FLOW_ACTION_HW_STATS_DONT_CARE;
-	else if (!hw_stats)
-		return FLOW_ACTION_HW_STATS_DISABLED;
-
-	return hw_stats;
-}
-
 int tc_setup_offload_action(struct flow_action *flow_action,
 			    const struct tcf_exts *exts)
 {
+	int i, j, index, err = 0;
 	struct tc_action *act;
-	int i, j, k, err = 0;
 
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_ANY != FLOW_ACTION_HW_STATS_ANY);
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
@@ -3569,151 +3513,13 @@ int tc_setup_offload_action(struct flow_action *flow_action,
 
 		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
 		entry->hw_index = act->tcfa_index;
-
-		if (is_tcf_gact_ok(act)) {
-			entry->id = FLOW_ACTION_ACCEPT;
-		} else if (is_tcf_gact_shot(act)) {
-			entry->id = FLOW_ACTION_DROP;
-		} else if (is_tcf_gact_trap(act)) {
-			entry->id = FLOW_ACTION_TRAP;
-		} else if (is_tcf_gact_goto_chain(act)) {
-			entry->id = FLOW_ACTION_GOTO;
-			entry->chain_index = tcf_gact_goto_chain_index(act);
-		} else if (is_tcf_mirred_egress_redirect(act)) {
-			entry->id = FLOW_ACTION_REDIRECT;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_mirred_egress_mirror(act)) {
-			entry->id = FLOW_ACTION_MIRRED;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_mirred_ingress_redirect(act)) {
-			entry->id = FLOW_ACTION_REDIRECT_INGRESS;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_mirred_ingress_mirror(act)) {
-			entry->id = FLOW_ACTION_MIRRED_INGRESS;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_vlan(act)) {
-			switch (tcf_vlan_action(act)) {
-			case TCA_VLAN_ACT_PUSH:
-				entry->id = FLOW_ACTION_VLAN_PUSH;
-				entry->vlan.vid = tcf_vlan_push_vid(act);
-				entry->vlan.proto = tcf_vlan_push_proto(act);
-				entry->vlan.prio = tcf_vlan_push_prio(act);
-				break;
-			case TCA_VLAN_ACT_POP:
-				entry->id = FLOW_ACTION_VLAN_POP;
-				break;
-			case TCA_VLAN_ACT_MODIFY:
-				entry->id = FLOW_ACTION_VLAN_MANGLE;
-				entry->vlan.vid = tcf_vlan_push_vid(act);
-				entry->vlan.proto = tcf_vlan_push_proto(act);
-				entry->vlan.prio = tcf_vlan_push_prio(act);
-				break;
-			default:
-				err = -EOPNOTSUPP;
-				goto err_out_locked;
-			}
-		} else if (is_tcf_tunnel_set(act)) {
-			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
-			err = tcf_tunnel_encap_get_tunnel(entry, act);
-			if (err)
-				goto err_out_locked;
-		} else if (is_tcf_tunnel_release(act)) {
-			entry->id = FLOW_ACTION_TUNNEL_DECAP;
-		} else if (is_tcf_pedit(act)) {
-			for (k = 0; k < tcf_pedit_nkeys(act); k++) {
-				switch (tcf_pedit_cmd(act, k)) {
-				case TCA_PEDIT_KEY_EX_CMD_SET:
-					entry->id = FLOW_ACTION_MANGLE;
-					break;
-				case TCA_PEDIT_KEY_EX_CMD_ADD:
-					entry->id = FLOW_ACTION_ADD;
-					break;
-				default:
-					err = -EOPNOTSUPP;
-					goto err_out_locked;
-				}
-				entry->mangle.htype = tcf_pedit_htype(act, k);
-				entry->mangle.mask = tcf_pedit_mask(act, k);
-				entry->mangle.val = tcf_pedit_val(act, k);
-				entry->mangle.offset = tcf_pedit_offset(act, k);
-				entry->hw_stats = tc_act_hw_stats(act->hw_stats);
-				entry = &flow_action->entries[++j];
-			}
-		} else if (is_tcf_csum(act)) {
-			entry->id = FLOW_ACTION_CSUM;
-			entry->csum_flags = tcf_csum_update_flags(act);
-		} else if (is_tcf_skbedit_mark(act)) {
-			entry->id = FLOW_ACTION_MARK;
-			entry->mark = tcf_skbedit_mark(act);
-		} else if (is_tcf_sample(act)) {
-			entry->id = FLOW_ACTION_SAMPLE;
-			entry->sample.trunc_size = tcf_sample_trunc_size(act);
-			entry->sample.truncate = tcf_sample_truncate(act);
-			entry->sample.rate = tcf_sample_rate(act);
-			tcf_sample_get_group(entry, act);
-		} else if (is_tcf_police(act)) {
-			entry->id = FLOW_ACTION_POLICE;
-			entry->police.burst = tcf_police_burst(act);
-			entry->police.rate_bytes_ps =
-				tcf_police_rate_bytes_ps(act);
-			entry->police.burst_pkt = tcf_police_burst_pkt(act);
-			entry->police.rate_pkt_ps =
-				tcf_police_rate_pkt_ps(act);
-			entry->police.mtu = tcf_police_tcfp_mtu(act);
-		} else if (is_tcf_ct(act)) {
-			entry->id = FLOW_ACTION_CT;
-			entry->ct.action = tcf_ct_action(act);
-			entry->ct.zone = tcf_ct_zone(act);
-			entry->ct.flow_table = tcf_ct_ft(act);
-		} else if (is_tcf_mpls(act)) {
-			switch (tcf_mpls_action(act)) {
-			case TCA_MPLS_ACT_PUSH:
-				entry->id = FLOW_ACTION_MPLS_PUSH;
-				entry->mpls_push.proto = tcf_mpls_proto(act);
-				entry->mpls_push.label = tcf_mpls_label(act);
-				entry->mpls_push.tc = tcf_mpls_tc(act);
-				entry->mpls_push.bos = tcf_mpls_bos(act);
-				entry->mpls_push.ttl = tcf_mpls_ttl(act);
-				break;
-			case TCA_MPLS_ACT_POP:
-				entry->id = FLOW_ACTION_MPLS_POP;
-				entry->mpls_pop.proto = tcf_mpls_proto(act);
-				break;
-			case TCA_MPLS_ACT_MODIFY:
-				entry->id = FLOW_ACTION_MPLS_MANGLE;
-				entry->mpls_mangle.label = tcf_mpls_label(act);
-				entry->mpls_mangle.tc = tcf_mpls_tc(act);
-				entry->mpls_mangle.bos = tcf_mpls_bos(act);
-				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
-				break;
-			default:
-				err = -EOPNOTSUPP;
-				goto err_out_locked;
-			}
-		} else if (is_tcf_skbedit_ptype(act)) {
-			entry->id = FLOW_ACTION_PTYPE;
-			entry->ptype = tcf_skbedit_ptype(act);
-		} else if (is_tcf_skbedit_priority(act)) {
-			entry->id = FLOW_ACTION_PRIORITY;
-			entry->priority = tcf_skbedit_priority(act);
-		} else if (is_tcf_gate(act)) {
-			entry->id = FLOW_ACTION_GATE;
-			entry->gate.prio = tcf_gate_prio(act);
-			entry->gate.basetime = tcf_gate_basetime(act);
-			entry->gate.cycletime = tcf_gate_cycletime(act);
-			entry->gate.cycletimeext = tcf_gate_cycletimeext(act);
-			entry->gate.num_entries = tcf_gate_num_entries(act);
-			err = tcf_gate_get_entries(entry, act);
-			if (err)
-				goto err_out_locked;
-		} else {
-			err = -EOPNOTSUPP;
+		index = 0;
+		err = tc_setup_offload_act(act, entry, &index);
+		if (!err)
+			j += index;
+		else
 			goto err_out_locked;
-		}
 		spin_unlock_bh(&act->tcfa_lock);
-
-		if (!is_tcf_pedit(act))
-			j++;
 	}
 
 err_out:
-- 
2.20.1

