Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B2F478DA4
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbhLQOWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:22:38 -0500
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com ([104.47.59.176]:25502
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237331AbhLQOWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kw4Y1DPl/R5Yz59hqXUutmMeTze+tStXoad24zlMsux+oU5Ltlo9PaTJHlGkU+oH/mk/8yWiym9LYodaujExB/+wYZkkduPUCVgKeG3UAvdV+8OlJ7GxWGUpwS1JAKkMnAqwQmP2mC8cYE2ffsHN3vY5q74Zjgc7ITmVTRTMOhrrFcTDE6kzXEiCNVmlaaUShbFnUkYXgY7Ytq8Bkb/t9snpk6B/ZH5WGeaowLKMbuiV5zoNxa/72Di/4yNBM/Cu1h4bNhnRZKTVTOJC0QsgTKqz3d3adbfdIOwLtwfd3XWk5UyIyMck5tsQ4ujo49GE4EtS0GKxftz8vPFKBfabfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gyPnqcHR0MtJVYMHc7msT7h2nxVOEhhVJc+KPijcS0Q=;
 b=ZDBMz+z3QjpFtEe/VpUX+oClphaWdw+gzBVyEZIhIr6SFC3LUyx/q1hPaXh07yxVO1Nm3R8/MG2Ap5iiy7I66HrxBt4uMK/hzWXxpw+v2JTLyDHVtZ728T1nxJu7Rhi+qjA8jkFxU1DF2kMTecafjK9keDXyx8KwL5zzXVa7h8dX2qMillEBaNaoShOvleXU+i4vYqH9H9yjhqOBQtXuh/CFLqRTCp0BZuzh8NY39TP0UwDcBXPQjTBEJIVli91U7b4zIly8DVnywFVTe+4wNkJz4pNnM4O2h/7Qt7IcVqM6JSjwxYlf/WUWC2uq/+3mppqYC91a56ADTRsygfOFSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyPnqcHR0MtJVYMHc7msT7h2nxVOEhhVJc+KPijcS0Q=;
 b=O8Wz6pikL4ARqTHFdBs/GORkEq5P39EEiel3uhbY/sBPLQNzvyBbeclJ0wH1jNAEF9nkXggfM0dL6MD5kAZ4MQx7CAq05D5xN/IJ2BiNR3IRxXCwApyIBxaizZUEIhiQ3HInafBlYtmVONKmJSP4QXZ7CipftXixz45yjhzvPQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5595.namprd13.prod.outlook.com (2603:10b6:510:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:34 +0000
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
Subject: [PATCH v7 net-next 06/12] flow_offload: allow user to offload tc action to net device
Date:   Fri, 17 Dec 2021 15:21:44 +0100
Message-Id: <20211217142150.17838-7-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1498e083-af89-4f51-a862-08d9c168ab38
X-MS-TrafficTypeDiagnostic: PH7PR13MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB55951509791592318BD1B245E8789@PH7PR13MB5595.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1gNmd5w+2X2KyAJ66d4Ej1FxmKbRtcmCpgYxhfnx5GRDKOvncC4WuBXkz1wAhkOahDmM6In5zMpdEBHLYCOeYsFtq5YPorPvqASLVwn91QpuWSGCz2qMD0JLlkpq+pXpta0B6w9GkzTTJ6LYTG6lXyGfj7gdN9XDz3XQoK1DtF91sZo5YUB3UmITw6YmZdYOZY3kBNDmW2JfGVOVG/DvAmhB8LR4O2I/MM3cvZ2QIvrUw+FZJWqGsIwWSxVIS9GzPDNfkuUay5hUHqNUNWFSpdk9TJEdthj5UoIX316CPc2t6M/Gc96p2s5G1e32bykQetn/Tium88WYxmOcAUMVBxKOTeYG5DCVLlCdvQtg6y6W7VYJu1wU2wef0Qc7KkOwKF9cyZQsNf+Y4ZJC56gvV7cxlfgIHdbZ0/QEFwi/cbisn+9/GPlCmgR65QnxTwiz+jVjtkvC5/lSfrxj8W3Yc8uOCdrjIzri/6/lTXsuZvkD0ikbyc575kZs339/26Gy48zrovB+9Ck7EJqzCWsBL6/MRVYCcSpG2V9qk399l9+vvCwjVNMNbh8ngJxftW0Qikr24BZP5b4wTmmGX+s70urFpukRHx8H4ahK0Ikl4+8QDv80tvmKOUxw4BxLbYljkHznHo9zFGhExm6aqH2A72UV7OksqYgCDoMo3UedVPhUw07FLl9/vSlQE8/60hSF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(39840400004)(346002)(376002)(136003)(110136005)(8936002)(54906003)(8676002)(316002)(66946007)(66476007)(7416002)(2906002)(66556008)(4326008)(30864003)(86362001)(38100700002)(107886003)(83380400001)(508600001)(1076003)(6486002)(36756003)(6506007)(2616005)(6666004)(52116002)(5660300002)(44832011)(186003)(6512007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9N4iDPnL4mKgUO9IR8fAr1L9QcgFWLuQYLFP2QrY6CN2/30TULLB6JvxSCig?=
 =?us-ascii?Q?PL4lyrhUYzAQ0In1KVc4tYPeZhFDVLTRiIOW7OzWNPSNVS6hLIv+sDldtzoc?=
 =?us-ascii?Q?pi0fsTsjnW8j7Y6OYyR6ttYBy0tkEQINX9QokTIlXhUMZNtLXG1MP3f88hOI?=
 =?us-ascii?Q?TB4CsaPh2uU2JWyBFdxqPBi//i/3URG5HhMIApSqf8c743hfoRDM3ODlPIBN?=
 =?us-ascii?Q?u06Sa06DL8Lthq9UxZ8sSUgzpwQOHIHqSs4ON0McbCdaf/H4UZp4ABOwbZTP?=
 =?us-ascii?Q?npVQvc3or0UicIopW+H/DJM3MEKl3kERoUNCTLvvI2mTj0m/1Ugteid2/Ry4?=
 =?us-ascii?Q?1LicicGJAUAm7HVYG9eg2giFAUvfWk3ZuAGUWyz4gvnhr7CYTJuoyFRc2TKM?=
 =?us-ascii?Q?K9cu+GKjzbChz9SZ+jq2ZGyDQUCFiQiW88+jXVeZ6i8uyZGJ6dGHdMrMaxZa?=
 =?us-ascii?Q?gchXad28hjddSvxOoBQznckbkA1JoNXjC8i2I4L/2sxJa2a3w6yIc40Nfs9M?=
 =?us-ascii?Q?LIfl8utzGBvv6Osv26LcjbScMoyaB/MXoQL9XOHhLEWVPdWEXFbIOJ1JKWs8?=
 =?us-ascii?Q?WlgLaZzyc11+RrSqYFyTPHRBOgxfNd4I35PZlur5A5NAqMpq/NURMf6ByNo8?=
 =?us-ascii?Q?rRS9zjpUDoLy70vn2x+FG4NIlh6K+heiC37pVJiwzGslCsXMrELEwKsPrDAT?=
 =?us-ascii?Q?kx0YPxrrkHWn9sMuHOcqTHqk5NtRQ49M0mB58SD0WhIoCrJ/TXBRJKb5Klmo?=
 =?us-ascii?Q?F107Itpb1aFRL2krH/ZGZrNaf28eq9UBVmnKNFS+h4fDEJwMH2Pg62K6dzia?=
 =?us-ascii?Q?hUNaGAqPze38WL+G8Lo/AgyKi0rDZ3BGxUmN8VQZntvPXuP25rjpDhJjB7qi?=
 =?us-ascii?Q?k56jw05NqM/6OB4i+TEVacm0E+vj5fvwYk/m4jzzbT+rk+boGRDG0pAHRWTy?=
 =?us-ascii?Q?rpucb390Q39FnMMhSFFqKlX2ySNRjxc1evs5K0xxRJh0ab+Qj77C8MJz/ro5?=
 =?us-ascii?Q?qIpDivkAOFK3HPpl++b3bQLirug1FoyknfI++c68ALlEERy2ZjbCwsiUXg8Q?=
 =?us-ascii?Q?oIveVxdEIAHsfQQBk8j9PSyqr0dy8qihvKIeGQTO6OPZetx3yFllomY5UYtw?=
 =?us-ascii?Q?XruN/w+oYYKAbDKf0DtT+NkjbV2Oq+3FkS7g2OwTrkzRQQLBmOkxM0XBPsH9?=
 =?us-ascii?Q?2PIpAJFJZ6Ubu8K/kv1Rc/+2mEegvAcBnTayLnRrZr1Zbb9L/NSsKBUQ8oru?=
 =?us-ascii?Q?nB0du1aVuXL9oT/4ru0N2ZhwWm4qq3wgo2uj5xCeovmR2aFUQHeWIzXUON8G?=
 =?us-ascii?Q?biqQKPPf20P8vK0FHorWNfGJc45I9DdBhxK6QGI0g3NH26tAxi1EDTAYkJMB?=
 =?us-ascii?Q?SL4Y5y90851926yyyLg9hsTh5TlvoRYehBmm1LvWcSpnDh77P04vB5hEFxJR?=
 =?us-ascii?Q?c9kv6Bb+RqO6dqjbGS5efTK1tucJrwx3yWjzh5kHn3pCWiem1ikYTpNWZVDH?=
 =?us-ascii?Q?a9ffSLgZbWPyDjdNzoJHH0tp0fF93KbsjK2ItSM6WsPRcK9RvIDsqLM1/pIG?=
 =?us-ascii?Q?M+i4AQhcxXZG2H2EzTV/QgEGXA0T4KMJNMkbwwJEN6kEdv5d+oJ+836Em7K+?=
 =?us-ascii?Q?wsDw3TOpb8crR5ybb9zvuDgS0+IhcfRXCwcz+vutqS4NFXCR8jLwbl4VD+4c?=
 =?us-ascii?Q?9PONFX0TKAxRzJSfjKCGWiZqhT9g5zRG+WIOQiPFLd+O+dp+SC9akiv79LOh?=
 =?us-ascii?Q?B/clX7MnWw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1498e083-af89-4f51-a862-08d9c168ab38
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:34.5153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQHNeo+Lxm9ntK67m0if4dWWDDZN6gDBgUjkjfGo/Jt8vL7cNJIUe5csUMDVxsOyzhlf2ZHFqHTZBdySnsrHc2Kv6kZvwTmnvxgm95womo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5595
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
index 2271da5aa8ee..71f91eb2d3e6 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -551,6 +551,23 @@ struct flow_cls_offload {
 	u32 classid;
 };
 
+enum flow_offload_act_command {
+	FLOW_ACT_REPLACE,
+	FLOW_ACT_DESTROY,
+	FLOW_ACT_STATS,
+};
+
+struct flow_offload_action {
+	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
+	enum flow_offload_act_command command;
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
index 3258da3d5bed..207905df2b9c 100644
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
+			       enum flow_offload_act_command cmd,
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
index 75c03dde70f8..72bf49e3ca07 100644
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

