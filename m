Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F1C478DA1
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbhLQOWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:22:35 -0500
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com ([104.47.57.173]:6423
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237263AbhLQOWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9sXazfXrIe9KkuSMisPKkJK99Pq9ydYKSr5dX0wNTVUFixtIq4mPFeF0TaBLd6Ip/sPNC3oJNz3in1V550yiSrUw7gJrHYOsbaQQAL8NsJvqdm8HjDfv5d8p2Kg+Z7TvIMvZk0JbWJst9wPBSFHRFM63A8I+sZ+qvedy9Vl7nXFHQ+UKnG56k+3jcWCv3qyUBtO+t/6vEkQpZ9ruyXW0p1PWFWDn42WODEGqphs3M9AL/o6G8NSx9g9qPJR/nOHZN4KUIG7zU1wZWmZVgyfemHZZNlVWpUiemMNHuI63yn1rV5+26rIuoGYW9gh027gSb/Q5qG76EwFQk2FGgNBIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVuBaZNncgpHU7GbMkmErVsvE+v8DDso+eiqreHriv8=;
 b=egiusSfkN+fREyVd52XycPk1f/mar6Z+vuJAhJnpqLoP5DsAmuetHOQ45uWzFagzTdr6Jdou8C1fp/m3gYYLi3HV88Tdu7sUz8fZoIuTNVGYm4R2K3qLn6NFPRsrAskZRITmwazVaq49QX9+oMGF+bK1O1iDnRVHX1O0m7Nxx4gh2M2TxvTiZMHC1u2mrlhJH6DunSUODKRGbL/C/o22w1XkefUuJaXWJxJ3u1pk+c9ryUcUPk+OWWvgXb0G8Lr6FcmMNbvCs8H2tVzuXg+J7KK8fUOAgLsAoIg9RDlHpwFa3U5DafRCrjzqBh0ZJ5j/ODfwLytEccWe2sZToTlOtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVuBaZNncgpHU7GbMkmErVsvE+v8DDso+eiqreHriv8=;
 b=VaIMDxloL2Mco5V1VVciJWfX/qPHJPCJU/uR6cC7K0iuSlScQMGWxtj7ofopE8R9KH5ugKudq6JpVodnYOpDy8lPTQO/VFWy8cvP3Glj1o/GR0+M8IuJ1ZpGqynMulfl+feXVaIqlwlYimvfVAUzH3jL7Vgoq1deOZ1doUSFr3c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5595.namprd13.prod.outlook.com (2603:10b6:510:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:30 +0000
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
Subject: [PATCH v7 net-next 05/12] flow_offload: add ops to tc_action_ops for flow action setup
Date:   Fri, 17 Dec 2021 15:21:43 +0100
Message-Id: <20211217142150.17838-6-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 05e5d9e4-4740-403f-91f2-08d9c168a885
X-MS-TrafficTypeDiagnostic: PH7PR13MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB5595ABCC3AE0E2FE6DB683E7E8789@PH7PR13MB5595.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /EHgu7ryFP2tRbdsataUClv8etgQkNu0pZVOBJ8hVWorl3czmo5fV/5tCPf/ANgQ5LP6744pdGugdZ8wRR/aVBJGwiMp+w4oh/Y60AxD3r0KC5l/pc2N6caKp5hhKQryxdDDZy0EQTKp+1/S6TICfQDyAq3ZCezQEHb9Zy+wcsYBJ82+Mgc9I8h3T4G10dPdWiAYtj+z1yP53BuGz0iJ74YhQqISHKa3sgz3n4xVHciwt4gQZKc3SKCWeCCHkdu8a4kibkE2DQTLLcog0tQQQJEFCVutPadSz10vU9bi/pF1O+b1+SGAFvJZ8JHsKKl9NMyR6cSGPWkyJULGgdsF5HT2s4mEpJuCJm7GdrB/fzHlkz4i4WLUBaY+YOoYOZ1b+FnuZBNEDfhskQXzgkAjkBMLcLb07/g6ZKjtNy3uzIpbik4wJakq+IIG+KoNk5YeaP249qlgOKrNVd7svqPf2q7dG8frzDPrc0Z70UQ6MZBu1e3hzUfqxPEGJzf0q12YlJ4bNndjfeAiu78H5+FzpJE2xnMScKSP6QIVbmYrr/tKgw5JNoKqjq33b5iKs8En6QpXZzewirmpAOhSOT2WxiHZAElepuIpnLAzV5qfnwl/gYSXKIODRkJkPoSGeilFr/dAITaPl3yU0NPudqLH4D7MYQ8sqGNdpJawV1RQYzO+UqTYzekI+Y9KiRxE+Fez
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(39840400004)(346002)(376002)(136003)(110136005)(8936002)(54906003)(8676002)(316002)(66946007)(66476007)(7416002)(2906002)(66556008)(4326008)(30864003)(86362001)(38100700002)(107886003)(83380400001)(508600001)(1076003)(6486002)(36756003)(6506007)(2616005)(6666004)(52116002)(5660300002)(44832011)(186003)(6512007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?abfyqrWL0lAOE1oXAZTue9OMyS8OXeqgoWV+5rSEgj0WU9eFQpAP50cRJtmA?=
 =?us-ascii?Q?lRsGKA5nEhXo2+q/37iUsaMYfHyDKBIn8IaoDSAbsdq6OlBP/cXU1K2+nJRR?=
 =?us-ascii?Q?iXTPQ+htVNcwsPj69RwB2Q6kRRbJFs75+Y2KekhfESggVRHmf5O1wClg0Zss?=
 =?us-ascii?Q?TEmiNHQfKs0QTywPIQ2JE/17KE61ii0X/++31R3T50v/ad7CYETq8RzS2cj6?=
 =?us-ascii?Q?wJMx/deTSApF1y6/IUgXyxWn77NVe5Kqtyzn7O7al7LMf3DjK4mMkwenA1fw?=
 =?us-ascii?Q?6yRMrewYtPtmRtJ+X75vxua55DDWolgM56cVQgt9XVRhlmi6Kd0ap7vVwHeS?=
 =?us-ascii?Q?lZONlTFY3ezvr7oJRe8yJjz6D1htcqOp2ef0SH49XCOyEJkC/bJRtLyX8UFt?=
 =?us-ascii?Q?4Vni4kjshptgIZoCUAe/uzWwLXXPV1qRMrN0DgWxyA9zZlx61zy5j7n8h8KI?=
 =?us-ascii?Q?aLGmWaXK5m0j0BbD9bm2U0dSBoQOY8IAd6JW+aYhuMftdIqqW5KytvPDwkmB?=
 =?us-ascii?Q?sfaWrRbT3nHZxId/g0I+1Fw5KPrvnbEWHyCQdUUUuIgyGVexbJqeCSX0SNGT?=
 =?us-ascii?Q?DIWJx/2FOko6R3TcfEys1mtcdnZh/u34Z/zaNkTtBLkw37/Ntivw66do8qhK?=
 =?us-ascii?Q?jb1GZjHTt+vd5tFHD82ALdH4jVvM4oPr3yZ4FdLzwCzE7Fsusc8J6/XsqHSe?=
 =?us-ascii?Q?FhakfXlxtOqtx6INpLX7aPZtjA4ihUUWSz5OiRu28uhPjaOpiSVi6rEGImR4?=
 =?us-ascii?Q?/DVHBNgKdqj7zBbpXitjgurGyQk5u6GW65fAzZ7B1xgpGlo7lr3flSE/p4q8?=
 =?us-ascii?Q?JB7t+Q0qM6X7mH3LVRhi/RYbIJi/1zcAD5FJ9O0w92BpEqJZuTTCgNRi/2ht?=
 =?us-ascii?Q?d/2LQk86Xxrp3lImEtY5/dIvPmEXkdkV87t+xOzwfFzFxsSiZ9uOsDJUAcDv?=
 =?us-ascii?Q?8Rr9ubi2kIkFyXotdH2FShrcUMxC2IsOQPBzSOCEOu7whh0Ao/YaDQnKm6bx?=
 =?us-ascii?Q?iSlVCNrYdPUlPJ3uaCWxrFHvm1akSvi5H3sBHtwbg3S4eqUvCm3dOYQ7hx3b?=
 =?us-ascii?Q?YHSOVEAR1yCt4cAEn1mjmPS7J9Njw8xhiPKCS4AqUrgR4FRhyJdnOzK4NCnh?=
 =?us-ascii?Q?XIEDofOoWpD6nxcl5MRzF5L3FfaWT8VMK8Sjgk6GcOJ5oAbrLmquujxY4GOS?=
 =?us-ascii?Q?cnIiEiAIDYDSNbx5ij8n6R5DELbgKath+EtVlKyLfE44ie/do6KN+YEQbxx9?=
 =?us-ascii?Q?PxL2kODyDWBcexqLd7H9DSNSxaWHN890rAANxQInBsoWtJj4WfyUvkQEt8yi?=
 =?us-ascii?Q?/9NRwNdDmeplJ8zdy0R/8DfagISrdAF8Wz+/NIIsJxTVMRattips1GUhfEDB?=
 =?us-ascii?Q?RulgIpvv4sDmScmjBE01tT0JULbIMxi52wIcJJzTCYQqJpIBxSpA42Sxc/bO?=
 =?us-ascii?Q?8eq4/dHNi9BtpJ23lN75+zu1K04bdGwIfO11+CUaFJ7tfpSoeg2wFFLKC/M8?=
 =?us-ascii?Q?sfmrtyJow6RVIIrei7qfOdr/MgSnl52FGLlj6VvVUZ6hHN9xMV6jcZC1WN3t?=
 =?us-ascii?Q?9ETWm2pmRDOlUytZUfXC0TztwyZ1TZuX2GanpMIVr7q1bSHAeOkvREc6IUQA?=
 =?us-ascii?Q?hrrsXJXyUaaUyoVf3XQe/kziJ+l8uecpfk62HznEoJQeleadqyZzhb1+mM5n?=
 =?us-ascii?Q?7KrHKNp0hKsma/5BpQf2dngxEicH0+bSa+3MncHNH+sxWNRExz9qoTLM/HxF?=
 =?us-ascii?Q?D0qCulx6Jw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e5d9e4-4740-403f-91f2-08d9c168a885
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:30.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1c4tbbCzJitBb1kwAHbIk+5x4DtpXeA4xPGyjQq5nGwa57+SNDAbQ+5RP+GRHmh3/pPyfO6gYPbuJOIAUAEBQY7Ed1wgOIcL9TaOW0WsLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5595
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
index cb2d10d3dcc0..75c03dde70f8 100644
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

