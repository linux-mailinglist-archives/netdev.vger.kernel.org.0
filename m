Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B606E4793C3
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240255AbhLQSRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:17:41 -0500
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com ([104.47.58.107]:31253
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240217AbhLQSRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZdE9Q3KLoN0mk4dp+DePSRSVerBxu6wr4xgU6R+1lRQ66oSdMwEQNEMaEt3IyMg3C130X9eS8H9vNysusePitR+q7lAX8F2+plbcEVK4FpqRgLbDqGNXb9MVeIz+tkqp3/q2h1r2LKS/PEpJN0hBGF4eQuPTMzo2NM+8xYYEhTfljk5z3Pn/EsUO0I/VSShBaQm1l/ZfPTH2qPPFTEFKyrrIQnJBAcQ60OjqCsZ3FL0y8Z94MXhpWPuMjrGkfyBynX4KrVErewvJ/y638RK3yWwv/b/Tk/SiDWuj4sh1W/q2vXdVPiRDN5j4p2kOiV8jEdz4IsPU4LMYpnrwvA+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZzKAzNCYUKQI8Flr4CbURWRJSIB/K3RaHeUH39cEC0=;
 b=AcD42agj4tgMOp+BOl0HWnBdDLW/HvLcmXjHQUrmFi6/+YXVeX6VF64f76acFzCnO0PThSXUROgCEgn8KiyfoQXnpDldlShbEcrfteeZ8TqDW+ryjAbWC2yB1WzNHzC0uN3uepQBeyBP6hIO2AxAGcy0VQ0FNjVEpVOSqrTAfhoGdu2UTWXTau2q7TRQBnUwQeZ3OasFTjGDuPwXcuE05FZBsONDeNkuFtcc7pjXyvTtaQTgUAoZatxbjDsfdyFDvTLXIeYQuRdz9Z5IeRYF7FF5Pe3ByL+7zuazs6Fq+JRdzUo9B4JirCEy66/XpP/9u5xvRgrtxkcE5a8oUqUlvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZzKAzNCYUKQI8Flr4CbURWRJSIB/K3RaHeUH39cEC0=;
 b=CMx0ywiAzntAoojtqzPkDJXuok4uaxrnspE+1g8TsmehB6nCBIPu8nblgcSLJLSgBTl9mkM6PxoMH6Zs3Hv7VdJqybTXSqfVWFXN+vv3aiThZeDaIAx4LLr9BX9Gq6IsndaQIiQ8FcWecey2dKwlUdtmGTmuVzlDpvt+kN9OsPE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5589.namprd13.prod.outlook.com (2603:10b6:510:142::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.9; Fri, 17 Dec
 2021 18:17:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:35 +0000
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
Subject: [PATCH v8 net-next 06/13] flow_offload: allow user to offload tc action to net device
Date:   Fri, 17 Dec 2021 19:16:22 +0100
Message-Id: <20211217181629.28081-7-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2478454d-7f36-4009-b623-08d9c1897fc4
X-MS-TrafficTypeDiagnostic: PH0PR13MB5589:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB558940779C976F54A1EB3C2CE8789@PH0PR13MB5589.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: quGH8PFVCqv1ROwMxoOrIxS2QbooIWDq+QR+kwT3vz7XHwz+2r6pP3Sxqbt4xpAhQ059JnHadAnJZMNaR5g3MrUlOOEon5J4Q/9aKQf1f9hwxUyYnX6Ht6NhtW2EXAd3FS/Umtodn1ia+bHILKp5SOFwk0BVbQQF1Tz3nO4OqLZHaXTMI0YrwhBklka8QkmjV+cWAxc1shqVG/56oJp04OWWRzxfhXQeyGJvQxm2Gt4OW9tPE0oXnfnRFoobPY0/GLFoPsj6ZF76RfiWbcBNCN9WvtOlDhvoEOBUXnYqp7CmM91oJdLqbXL6zDhn70J1/l9DNM8eZNEnE82enFhoJJ9vHFNvrTBtg0mvGS5eRs5JkaZ8ZF3XdfWDBzTlyHhcScnfd9r3v4V22j7vgKPufGDO3esHiVbIy4QLRxwRdsQsH8IfqDv4VzpwUfs7gOa+HElJvV9fmZw3UNkELQGXiHWH83Su6oeTaIymWiwp0z0/JLIax3h6NJm+Xk3MKhrHPY+cV0BZ9fL9Rd4Z3hliDyKBb4e+qaNImapegtZ15eFxtDiDdXnek+QoF0tOx2s6MxCTdjis8DMK6jalgl/yiv7iq3FQpwxplJqlU+h4C12UL+hIN1PLhTdjYiIMJgCKmQIpbNqdT8x2idfegzdJEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(366004)(39840400004)(396003)(136003)(508600001)(107886003)(52116002)(6666004)(6512007)(86362001)(2616005)(6486002)(186003)(83380400001)(1076003)(8676002)(316002)(6506007)(2906002)(54906003)(66946007)(44832011)(110136005)(30864003)(7416002)(4326008)(8936002)(66476007)(66556008)(5660300002)(36756003)(38100700002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Fw/aDGP1hhRyFQsMnJEwbY9sosb7Cj8mEQ/QfliPLkwjYE3wxtygi/zJK8/?=
 =?us-ascii?Q?cdeQEE65yn7XHNkRZKWE0CBZR28IeoveOTrq7g78QMx6d3GIvTRFjDvWVlAD?=
 =?us-ascii?Q?soIJWLHZv6fT89iOno69q6PTroNeepnSIwRgCjwxR9x1n97hgoSYV3WLzD+e?=
 =?us-ascii?Q?DsEw826CcrlPJwX8IL54KaQQ+t33J/qqw6MDDXbzYfPaHk+eq6BLfMFrEelz?=
 =?us-ascii?Q?9ulfZS/1dh7UjjyZCSzSAXwBFsNGuONDmNWcVlL2H9VcqQ+PSQ6SoTWvm+y2?=
 =?us-ascii?Q?yU3xuMXWS8okNHOnIU7ZuWV+EvUvm4DXdMO05rRZ9BXaXJxeCaLgOirOY9CN?=
 =?us-ascii?Q?pxGjZDIGKAt0CVfXQHh0K/hOVF7ORDMKWlEo9jhna3iXXRpMTgHNgrfHxWW2?=
 =?us-ascii?Q?d44flNAnNVo4JtKeUSRoH0OwHfiddETkOibW2NbB2qtaQ2xV33KNCe05zJlY?=
 =?us-ascii?Q?hUrz5XMt0MgWsVCNJAQlmSklvIoABPtl5W8bEcPrGS0GbcITF+f6S/rsEjbq?=
 =?us-ascii?Q?oylcakooJa1bcBf6cct1dTZlDDRNl3Wdiqwmbvuvw91FEouBjffxfnPOGSyK?=
 =?us-ascii?Q?PI2Cb9b+2GCqGlKoa6N+BbVnxGqMjauju5wGIXl3p+f9hCEAGh2W6QPpYuCP?=
 =?us-ascii?Q?isDEf3PgTENW38vxBWzot1UeldO+FcGAZvVYP2L6YsH2/H5lFAm9t6lW55b0?=
 =?us-ascii?Q?FuHXoP3MwCeBBj8hJaA+P7f0OkJE7SSRDeryU46WeFKiF4qwpmp2sNYDaxtl?=
 =?us-ascii?Q?gy812tYMyu1f+ynHhQ+H37wocL665IZXFKnFGpIJxV47Ubm6+PPMwqjqlKE0?=
 =?us-ascii?Q?Wqf/tsqCqQsUfqKL8Ljp5pLSxCKkSlffkTH1v5gzonakE7Gmq+vrFSok1P4C?=
 =?us-ascii?Q?LJWBv9yT4urv354cDeEEj4OP+SL7bHy5rVrcAGMeGY+a6A3xW9WGNfN1eZpQ?=
 =?us-ascii?Q?V5rY4Oak1yIgWlkFkiZ6vV6JzkCe5Dqcy/yBsXnz2zdlsur7slqyp0IeesNs?=
 =?us-ascii?Q?jmC4YsBzvGaBDbntfsKTXPVPEK/Q1DqC4VpJ6Z5aBWuoAO7iJ/r0qnJgza8o?=
 =?us-ascii?Q?r2gDKwRJIkW4LJldt7WeJQrJHb8aFOifSCMsPnYltVStTmDHAwugpVXQHRpc?=
 =?us-ascii?Q?VKI8qGLW7NQSNYag73M/9AdpWgUQhCAw1IU3INib2u6pbYqy+4QOvpvrfMR5?=
 =?us-ascii?Q?Cy4zmUs0svq0A/XmERR/tXO3I8JLk8SMPkfuBaLmC7EhtbyWv7+JXcZwVFvO?=
 =?us-ascii?Q?E8Ynwh3PyO21GJQvQyfr+Znpjr/txkhhAwFm2f5MCopgicxWMZZuUdjMIpiW?=
 =?us-ascii?Q?jK7bmWXQoV33tbPA7Ui30kWsf/ZZ+eB+DIT7gqHRTsBf+7l26m37Um0adNVW?=
 =?us-ascii?Q?db6IAdvforNkqYhRx40JnWdt3n1YB62jJ3JfLTrEppKqL3hdkvbhNQ66Er2q?=
 =?us-ascii?Q?v525drIiPw6vBlTzTsTyETkZOMOCUGFOD32cpjMpiX4A29XoDd/8360KahMa?=
 =?us-ascii?Q?+AJY1MpJevTucFcRHQbX/rnnF0rEYwE6JQj4AJWEx0Cs3+EmQKlHA7BS4oUs?=
 =?us-ascii?Q?rZcZqIFvnut4kUT1g3+Jw/Hm1ijMwm1Zy8ZLK7HeOwyVDFqIQySQ+JZJdyyj?=
 =?us-ascii?Q?6Di/jsus0rkzfPDmEXXCFpIaGEgDAag8tIT1Bdz61Gbkv0VY+v2VBxY+6cvr?=
 =?us-ascii?Q?zG/E4hrvWR2YEMfm8QjFWDeC84LM1Vx8UVq4ddc3X1XTCSFYse//9b6y6qlk?=
 =?us-ascii?Q?dpRioBTP/w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2478454d-7f36-4009-b623-08d9c1897fc4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:35.1010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BsjFXbAcOmF2K3i/56Gn+Y7HoQbd5ziV5Shv3eM/IOoH0T7Qnzo+2APDyc9QGNih4B8V3YcRywm8VufoIKF3GzgBJCbohhwNUZc+27te7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5589
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Use flow_indr_dev_register/flow_indr_dev_setup_offload to
offload tc action.

We need to call tc_cleanup_flow_action to clean up tc action entry since
in tc_setup_action, some actions may hold dev refcnt, especially the mirror
action.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/linux/netdevice.h  |  1 +
 include/net/flow_offload.h | 17 +++++++
 include/net/pkt_cls.h      |  5 ++
 net/core/flow_offload.c    | 42 +++++++++++++----
 net/sched/act_api.c        | 93 ++++++++++++++++++++++++++++++++++++++
 net/sched/act_csum.c       |  4 +-
 net/sched/act_ct.c         |  4 +-
 net/sched/act_gact.c       | 13 +++++-
 net/sched/act_gate.c       |  4 +-
 net/sched/act_mirred.c     | 13 +++++-
 net/sched/act_mpls.c       | 16 ++++++-
 net/sched/act_police.c     |  4 +-
 net/sched/act_sample.c     |  4 +-
 net/sched/act_skbedit.c    | 11 ++++-
 net/sched/act_tunnel_key.c |  9 +++-
 net/sched/act_vlan.c       | 16 ++++++-
 net/sched/cls_api.c        | 21 +++++++--
 17 files changed, 254 insertions(+), 23 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a419718612c6..8b0bdeb4734e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -920,6 +920,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_TBF,
 	TC_SETUP_QDISC_FIFO,
 	TC_SETUP_QDISC_HTB,
+	TC_SETUP_ACT,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 2271da5aa8ee..5b8c54eb7a6b 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -551,6 +551,23 @@ struct flow_cls_offload {
 	u32 classid;
 };
 
+enum offload_act_command  {
+	FLOW_ACT_REPLACE,
+	FLOW_ACT_DESTROY,
+	FLOW_ACT_STATS,
+};
+
+struct flow_offload_action {
+	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
+	enum offload_act_command  command;
+	enum flow_action_id id;
+	u32 index;
+	struct flow_stats stats;
+	struct flow_action action;
+};
+
+struct flow_offload_action *offload_action_alloc(unsigned int num_actions);
+
 static inline struct flow_rule *
 flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
 {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 5d4ff76d37e2..1bfb616ea759 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -262,6 +262,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (; 0; (void)(i), (void)(a), (void)(exts))
 #endif
 
+#define tcf_act_for_each_action(i, a, actions) \
+	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
@@ -539,6 +542,8 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 int tc_setup_offload_action(struct flow_action *flow_action,
 			    const struct tcf_exts *exts);
 void tc_cleanup_offload_action(struct flow_action *flow_action);
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[]);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop, bool rtnl_held);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 6beaea13564a..022c945817fa 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -27,6 +27,26 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 }
 EXPORT_SYMBOL(flow_rule_alloc);
 
+struct flow_offload_action *offload_action_alloc(unsigned int num_actions)
+{
+	struct flow_offload_action *fl_action;
+	int i;
+
+	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
+			    GFP_KERNEL);
+	if (!fl_action)
+		return NULL;
+
+	fl_action->action.num_entries = num_actions;
+	/* Pre-fill each action hw_stats with DONT_CARE.
+	 * Caller can override this if it wants stats for a given action.
+	 */
+	for (i = 0; i < num_actions; i++)
+		fl_action->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
+
+	return fl_action;
+}
+
 #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
 	const struct flow_match *__m = &(__rule)->match;			\
 	struct flow_dissector *__d = (__m)->dissector;				\
@@ -549,19 +569,25 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 				void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct flow_indr_dev *this;
+	u32 count = 0;
+	int err;
 
 	mutex_lock(&flow_indr_block_lock);
+	if (bo) {
+		if (bo->command == FLOW_BLOCK_BIND)
+			indir_dev_add(data, dev, sch, type, cleanup, bo);
+		else if (bo->command == FLOW_BLOCK_UNBIND)
+			indir_dev_remove(data);
+	}
 
-	if (bo->command == FLOW_BLOCK_BIND)
-		indir_dev_add(data, dev, sch, type, cleanup, bo);
-	else if (bo->command == FLOW_BLOCK_UNBIND)
-		indir_dev_remove(data);
-
-	list_for_each_entry(this, &flow_block_indr_dev_list, list)
-		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
+	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
+		err = this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
+		if (!err)
+			count++;
+	}
 
 	mutex_unlock(&flow_indr_block_lock);
 
-	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
+	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 3258da3d5bed..5c21401b0555 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -19,8 +19,10 @@
 #include <net/sock.h>
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
+#include <net/tc_act/tc_pedit.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
+#include <net/flow_offload.h>
 
 #ifdef CONFIG_INET
 DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
@@ -129,8 +131,92 @@ static void free_tcf(struct tc_action *p)
 	kfree(p);
 }
 
+static unsigned int tcf_offload_act_num_actions_single(struct tc_action *act)
+{
+	if (is_tcf_pedit(act))
+		return tcf_pedit_nkeys(act);
+	else
+		return 1;
+}
+
+static int offload_action_init(struct flow_offload_action *fl_action,
+			       struct tc_action *act,
+			       enum offload_act_command  cmd,
+			       struct netlink_ext_ack *extack)
+{
+	fl_action->extack = extack;
+	fl_action->command = cmd;
+	fl_action->index = act->tcfa_index;
+
+	if (act->ops->offload_act_setup)
+		return act->ops->offload_act_setup(act, fl_action, NULL, false);
+
+	return -EOPNOTSUPP;
+}
+
+static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
+					  fl_act, NULL, NULL);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+/* offload the tc action after it is inserted */
+static int tcf_action_offload_add(struct tc_action *action,
+				  struct netlink_ext_ack *extack)
+{
+	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
+		[0] = action,
+	};
+	struct flow_offload_action *fl_action;
+	int num, err = 0;
+
+	num = tcf_offload_act_num_actions_single(action);
+	fl_action = offload_action_alloc(num);
+	if (!fl_action)
+		return -ENOMEM;
+
+	err = offload_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
+	if (err)
+		goto fl_err;
+
+	err = tc_setup_action(&fl_action->action, actions);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to setup tc actions for offload\n");
+		goto fl_err;
+	}
+
+	err = tcf_action_offload_cmd(fl_action, extack);
+	tc_cleanup_offload_action(&fl_action->action);
+
+fl_err:
+	kfree(fl_action);
+
+	return err;
+}
+
+static int tcf_action_offload_del(struct tc_action *action)
+{
+	struct flow_offload_action fl_act = {};
+	int err = 0;
+
+	err = offload_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
+	if (err)
+		return err;
+
+	return tcf_action_offload_cmd(&fl_act, NULL);
+}
+
 static void tcf_action_cleanup(struct tc_action *p)
 {
+	tcf_action_offload_del(p);
 	if (p->ops->cleanup)
 		p->ops->cleanup(p);
 
@@ -1061,6 +1147,11 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return ERR_PTR(err);
 }
 
+static bool tc_act_bind(u32 flags)
+{
+	return !!(flags & TCA_ACT_FLAGS_BIND);
+}
+
 /* Returns numbers of initialized actions or negative error. */
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
@@ -1103,6 +1194,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
+		if (!tc_act_bind(flags))
+			tcf_action_offload_add(act, extack);
 	}
 
 	/* We have to commit them all together, because if any error happened in
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 4428852a03d7..e0f515b774ca 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -705,7 +705,9 @@ static int tcf_csum_offload_act_setup(struct tc_action *act, void *entry_data,
 		entry->csum_flags = tcf_csum_update_flags(act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_CSUM;
 	}
 
 	return 0;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index dc64f31e5191..1c537913a189 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1505,7 +1505,9 @@ static int tcf_ct_offload_act_setup(struct tc_action *act, void *entry_data,
 		entry->ct.flow_table = tcf_ct_ft(act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_CT;
 	}
 
 	return 0;
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index f77be22069f4..bde6a6c01e64 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -272,7 +272,18 @@ static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_gact_ok(act))
+			fl_action->id = FLOW_ACTION_ACCEPT;
+		else if (is_tcf_gact_shot(act))
+			fl_action->id = FLOW_ACTION_DROP;
+		else if (is_tcf_gact_trap(act))
+			fl_action->id = FLOW_ACTION_TRAP;
+		else if (is_tcf_gact_goto_chain(act))
+			fl_action->id = FLOW_ACTION_GOTO;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 1d8297497692..d56e73843a4b 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -637,7 +637,9 @@ static int tcf_gate_offload_act_setup(struct tc_action *act, void *entry_data,
 			return err;
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_GATE;
 	}
 
 	return 0;
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 8eecf55be0a2..39acd1d18609 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -482,7 +482,18 @@ static int tcf_mirred_offload_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_mirred_egress_redirect(act))
+			fl_action->id = FLOW_ACTION_REDIRECT;
+		else if (is_tcf_mirred_egress_mirror(act))
+			fl_action->id = FLOW_ACTION_MIRRED;
+		else if (is_tcf_mirred_ingress_redirect(act))
+			fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
+		else if (is_tcf_mirred_ingress_mirror(act))
+			fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index a4615e1331e0..b9ff3459fdab 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -415,7 +415,21 @@ static int tcf_mpls_offload_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		switch (tcf_mpls_action(act)) {
+		case TCA_MPLS_ACT_PUSH:
+			fl_action->id = FLOW_ACTION_MPLS_PUSH;
+			break;
+		case TCA_MPLS_ACT_POP:
+			fl_action->id = FLOW_ACTION_MPLS_POP;
+			break;
+		case TCA_MPLS_ACT_MODIFY:
+			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return 0;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index abb6d16a20b2..0923aa2b8f8a 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -421,7 +421,9 @@ static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
 		entry->police.mtu = tcf_police_tcfp_mtu(act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_POLICE;
 	}
 
 	return 0;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 07e56903211e..9a22cdda6bbd 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -303,7 +303,9 @@ static int tcf_sample_offload_act_setup(struct tc_action *act, void *entry_data,
 		tcf_offload_sample_get_group(entry, act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_SAMPLE;
 	}
 
 	return 0;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index c380f9e6cc95..ceba11b198bb 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -347,7 +347,16 @@ static int tcf_skbedit_offload_act_setup(struct tc_action *act, void *entry_data
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_skbedit_mark(act))
+			fl_action->id = FLOW_ACTION_MARK;
+		else if (is_tcf_skbedit_ptype(act))
+			fl_action->id = FLOW_ACTION_PTYPE;
+		else if (is_tcf_skbedit_priority(act))
+			fl_action->id = FLOW_ACTION_PRIORITY;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index e96a65a5323e..23aba03d26a8 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -827,7 +827,14 @@ static int tcf_tunnel_key_offload_act_setup(struct tc_action *act,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_tunnel_set(act))
+			fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
+		else if (is_tcf_tunnel_release(act))
+			fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 0300792084f0..756e2dcde1cd 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -395,7 +395,21 @@ static int tcf_vlan_offload_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		switch (tcf_vlan_action(act)) {
+		case TCA_VLAN_ACT_PUSH:
+			fl_action->id = FLOW_ACTION_VLAN_PUSH;
+			break;
+		case TCA_VLAN_ACT_POP:
+			fl_action->id = FLOW_ACTION_VLAN_POP;
+			break;
+		case TCA_VLAN_ACT_MODIFY:
+			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return 0;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 53f263c9a725..353e1eed48be 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3488,8 +3488,8 @@ static int tc_setup_offload_act(struct tc_action *act,
 #endif
 }
 
-int tc_setup_offload_action(struct flow_action *flow_action,
-			    const struct tcf_exts *exts)
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[])
 {
 	int i, j, index, err = 0;
 	struct tc_action *act;
@@ -3498,11 +3498,11 @@ int tc_setup_offload_action(struct flow_action *flow_action,
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
 
-	if (!exts)
+	if (!actions)
 		return 0;
 
 	j = 0;
-	tcf_exts_for_each_action(i, act, exts) {
+	tcf_act_for_each_action(i, act, actions) {
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
@@ -3531,6 +3531,19 @@ int tc_setup_offload_action(struct flow_action *flow_action,
 	spin_unlock_bh(&act->tcfa_lock);
 	goto err_out;
 }
+
+int tc_setup_offload_action(struct flow_action *flow_action,
+			    const struct tcf_exts *exts)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (!exts)
+		return 0;
+
+	return tc_setup_action(flow_action, exts->actions);
+#else
+	return 0;
+#endif
+}
 EXPORT_SYMBOL(tc_setup_offload_action);
 
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
-- 
2.20.1

