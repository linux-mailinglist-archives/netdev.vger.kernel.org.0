Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FA469B5A0
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjBQWiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBQWiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:38:14 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB8293EC
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:37:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKwAih3HKnhYxDuPHiXMFHQBcVeTx2J2vi/swoC19iSdOsfXlJTuDeM0xxApWG6I2YJ2qvLGCCFRMHwGoyFJUtsh+1CaUQez3j0Z8uk2Pod8YEOPWlRaYMobDzl5Jb0sekjy81SI+zREsTgWiT6bPbxEosRrjyDoyH6CVGrYKaeDd8N7y5cyn3gh1b+rW9aijizR9+zmvyYCG0x/8cz39X7UHi8rE6hMrzt6shfTVLnpKD2VgCDXPgBQcLi1uBZJnugmNYrdFVycGcZ+1mGKpLqFz0/J63XXgfcw6BZPqJLLOPBlWKFSAoqWbEBYQuQTnSMXG5VhQfWmXmYJf31gFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gh1g9//4Yj7jIwto+28qKjJ9/OTEl2wemMwcoJVr9DA=;
 b=HoEcWEkck8pQTD6Y0MA6iGkIhpaQgBUlIrTFDlzw9R2c7gb6V8aG4JMVdAqO97AdXBKZMWECGXwaWDEnyrBeg4EwhwKjO+6mboKXFsUTQTJB0gLdNnSgysK7+kBKo7d2ujwm+2HpMMPyp9fzuHNcc+/mK8BFPgu91vIfvK3KaWEqEb/etAXT6NiZxotWdQqlVfi2D9obMFRBaSpnbsKy9KAa3f70fAA/Dcqrs5HhyBqwGUAAgu3IucWV4RgG4vwRXNOHpDV6mJjOgkzFMt9SZv7ZTgHKRb7p0GenUshg69ZRiGQAvUTTvb6qZWLX9W14oCde8gigSlhyXvkm+e0Yog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gh1g9//4Yj7jIwto+28qKjJ9/OTEl2wemMwcoJVr9DA=;
 b=ZQK0nAulJKezaY0EXD+wBzg6eDIVSJno6wbz8h2MxgRctqRxmyTmFOuvy1LlDLv/lwPiijS09kNg74sbVhYHtPPKidW351JCRdOVKWrNcaWGUS4n2pNB2uzkK/LbcFBRyW3yW7tFb1koXXOgtPVV9wVMUnrPGOG5QL8CCUgkCELDw9+7s5MOOooUEzW7K0tfz6O2hyZ29h5oWtCl43F+3oTeZSubkLs3aCSt6Sn8IwWvJWP/PbKVEZQWjFLz+Q1NrwnOJFDBfCLdG+9opHnqwQQyXHLUH1J0R56ng0ZtIZYXy/Lgmiz1fJiFrhsE1dtGSCCS6ZvoNVS1f6t4+8LRdw==
Received: from MN2PR07CA0019.namprd07.prod.outlook.com (2603:10b6:208:1a0::29)
 by SA0PR12MB4493.namprd12.prod.outlook.com (2603:10b6:806:72::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Fri, 17 Feb
 2023 22:36:50 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:208:1a0:cafe::60) by MN2PR07CA0019.outlook.office365.com
 (2603:10b6:208:1a0::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15 via Frontend
 Transport; Fri, 17 Feb 2023 22:36:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:36:50 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:32 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:32 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Fri, 17 Feb 2023 14:36:28 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v13 1/8] net/sched: Rename user cookie and act cookie
Date:   Sat, 18 Feb 2023 00:36:13 +0200
Message-ID: <20230217223620.28508-2-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230217223620.28508-1-paulb@nvidia.com>
References: <20230217223620.28508-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|SA0PR12MB4493:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c8a4346-9a93-4dee-2ae8-08db11377642
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BUe7jsfkSmOUKIBr8GpU9eJpiupNJziq8q0DRPoAGfgMqmjEUAhovTEzYX6/Ekp/YtK6tRqKhUM0MJTQUXcKgf1wj0wwb/5fpAuDdOpnD7o6uCVfGTe6MRTEQb46w8HLUeTWH5+u+p0VIliX5amZwUm/7rxGj/qCX8yO6ci8JH2pIlBNFoxDfxxOKp3Yn/Ik8sF5ruROGKIcnwSKeNfB9QrMiMq93eoq3Af7BWke7lq6L0ZQA79z8XpSn0uHB21TRBXMmNej5TXDc80I8qbwbKP8VB3qBV8+1GvGpuErHHTZBejj3sU4LqkeVC1dtoe46ov1CeUErdL2vmy73khSMY8PgMeJxMOBqUeJRRNQlTPjyutM9rfpsS9ZRUdWR41DxuhDL76mY4w9wK00YQZH6C46oKzWBMcTvI15ajSfzmuUxuh0AytGGB90HtEIdEMIUq/+HI94AhzRuBfck7Cn9ujvu1WRhllT/KeCiD/dA40xxnGhd7kF6872ttGJU11YugPLrBzyrR8k1bmDFDdEz6HFj5MLDMu2X1U5xRD6djMRmaPUQcIILYyeIP+S7jwih9Rik0oi1w0NrKDu09/OMRIDoQ7QbPuhXKfEESy+rev80odLQoWkxxL13CebzCrnIRQyrZjlIXaUrI1wITyZFq1Z/MBo9tqod14F/c/EAwLF/J7Yb6Kea421JYl2yFL1cp15w92epAS3RIflCEbxJnLf9iZz5+g4avAOYBnFXw=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(82740400003)(36860700001)(921005)(356005)(86362001)(7636003)(36756003)(5660300002)(4326008)(2906002)(8676002)(70586007)(40480700001)(70206006)(8936002)(82310400005)(186003)(336012)(2616005)(26005)(40460700003)(83380400001)(426003)(41300700001)(47076005)(110136005)(316002)(54906003)(478600001)(6666004)(107886003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:36:50.5790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8a4346-9a93-4dee-2ae8-08db11377642
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4493
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct tc_action->act_cookie is a user defined cookie,
and the related struct flow_action_entry->act_cookie is
used as an handle similar to struct flow_cls_offload->cookie.

Rename tc_action->act_cookie to user_cookie, and
flow_action_entry->act_cookie to cookie so their names
would better fit their usage.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  2 +-
 include/net/act_api.h                         |  2 +-
 include/net/flow_offload.h                    |  4 +--
 net/sched/act_api.c                           | 26 ++++++++---------
 net/sched/cls_api.c                           | 28 +++++++++----------
 6 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9bbd31e304be..b401cf291782 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4176,7 +4176,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 
 		parse_state->actions |= attr->action;
 		if (!tc_act->stats_action)
-			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->act_cookie;
+			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->cookie;
 
 		/* Split attr for multi table act if not the last act. */
 		if (jump_state.jump_target ||
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index e91fb205e0b4..594cdcb90b3d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -103,7 +103,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			}
 			ingress = mlxsw_sp_flow_block_is_ingress_bound(block);
 			err = mlxsw_sp_acl_rulei_act_drop(rulei, ingress,
-							  act->cookie, extack);
+							  act->user_cookie, extack);
 			if (err) {
 				NL_SET_ERR_MSG_MOD(extack, "Cannot append drop action");
 				return err;
diff --git a/include/net/act_api.h b/include/net/act_api.h
index 2a6f443f0ef6..4ae0580b63ca 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -39,7 +39,7 @@ struct tc_action {
 	struct gnet_stats_basic_sync __percpu *cpu_bstats;
 	struct gnet_stats_basic_sync __percpu *cpu_bstats_hw;
 	struct gnet_stats_queue __percpu *cpu_qstats;
-	struct tc_cookie	__rcu *act_cookie;
+	struct tc_cookie	__rcu *user_cookie;
 	struct tcf_chain	__rcu *goto_chain;
 	u32			tcfa_flags;
 	u8			hw_stats;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 8c05455b1e34..9c5cb12f8a90 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -228,7 +228,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
 struct flow_action_entry {
 	enum flow_action_id		id;
 	u32				hw_index;
-	unsigned long			act_cookie;
+	unsigned long			cookie;
 	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
@@ -321,7 +321,7 @@ struct flow_action_entry {
 			u16		sid;
 		} pppoe;
 	};
-	struct flow_action_cookie *cookie; /* user defined action cookie */
+	struct flow_action_cookie *user_cookie; /* user defined action cookie */
 };
 
 struct flow_action {
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index eda58b78da13..e67ebc939901 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -125,7 +125,7 @@ static void free_tcf(struct tc_action *p)
 	free_percpu(p->cpu_bstats_hw);
 	free_percpu(p->cpu_qstats);
 
-	tcf_set_action_cookie(&p->act_cookie, NULL);
+	tcf_set_action_cookie(&p->user_cookie, NULL);
 	if (chain)
 		tcf_chain_put_by_act(chain);
 
@@ -431,14 +431,14 @@ EXPORT_SYMBOL(tcf_idr_release);
 
 static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 {
-	struct tc_cookie *act_cookie;
+	struct tc_cookie *user_cookie;
 	u32 cookie_len = 0;
 
 	rcu_read_lock();
-	act_cookie = rcu_dereference(act->act_cookie);
+	user_cookie = rcu_dereference(act->user_cookie);
 
-	if (act_cookie)
-		cookie_len = nla_total_size(act_cookie->len);
+	if (user_cookie)
+		cookie_len = nla_total_size(user_cookie->len);
 	rcu_read_unlock();
 
 	return  nla_total_size(0) /* action number nested */
@@ -488,7 +488,7 @@ tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a, bool from_act)
 		goto nla_put_failure;
 
 	rcu_read_lock();
-	cookie = rcu_dereference(a->act_cookie);
+	cookie = rcu_dereference(a->user_cookie);
 	if (cookie) {
 		if (nla_put(skb, TCA_ACT_COOKIE, cookie->len, cookie->data)) {
 			rcu_read_unlock();
@@ -1362,9 +1362,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 {
 	bool police = flags & TCA_ACT_FLAGS_POLICE;
 	struct nla_bitfield32 userflags = { 0, 0 };
+	struct tc_cookie *user_cookie = NULL;
 	u8 hw_stats = TCA_ACT_HW_STATS_ANY;
 	struct nlattr *tb[TCA_ACT_MAX + 1];
-	struct tc_cookie *cookie = NULL;
 	struct tc_action *a;
 	int err;
 
@@ -1375,8 +1375,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 		if (err < 0)
 			return ERR_PTR(err);
 		if (tb[TCA_ACT_COOKIE]) {
-			cookie = nla_memdup_cookie(tb);
-			if (!cookie) {
+			user_cookie = nla_memdup_cookie(tb);
+			if (!user_cookie) {
 				NL_SET_ERR_MSG(extack, "No memory to generate TC cookie");
 				err = -ENOMEM;
 				goto err_out;
@@ -1402,7 +1402,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	*init_res = err;
 
 	if (!police && tb[TCA_ACT_COOKIE])
-		tcf_set_action_cookie(&a->act_cookie, cookie);
+		tcf_set_action_cookie(&a->user_cookie, user_cookie);
 
 	if (!police)
 		a->hw_stats = hw_stats;
@@ -1410,9 +1410,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return a;
 
 err_out:
-	if (cookie) {
-		kfree(cookie->data);
-		kfree(cookie);
+	if (user_cookie) {
+		kfree(user_cookie->data);
+		kfree(user_cookie);
 	}
 	return ERR_PTR(err);
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index bfabc9c95fa9..656049ead8bb 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3490,28 +3490,28 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 }
 EXPORT_SYMBOL(tc_setup_cb_reoffload);
 
-static int tcf_act_get_cookie(struct flow_action_entry *entry,
-			      const struct tc_action *act)
+static int tcf_act_get_user_cookie(struct flow_action_entry *entry,
+				   const struct tc_action *act)
 {
-	struct tc_cookie *cookie;
+	struct tc_cookie *user_cookie;
 	int err = 0;
 
 	rcu_read_lock();
-	cookie = rcu_dereference(act->act_cookie);
-	if (cookie) {
-		entry->cookie = flow_action_cookie_create(cookie->data,
-							  cookie->len,
-							  GFP_ATOMIC);
-		if (!entry->cookie)
+	user_cookie = rcu_dereference(act->user_cookie);
+	if (user_cookie) {
+		entry->user_cookie = flow_action_cookie_create(user_cookie->data,
+							       user_cookie->len,
+							       GFP_ATOMIC);
+		if (!entry->user_cookie)
 			err = -ENOMEM;
 	}
 	rcu_read_unlock();
 	return err;
 }
 
-static void tcf_act_put_cookie(struct flow_action_entry *entry)
+static void tcf_act_put_user_cookie(struct flow_action_entry *entry)
 {
-	flow_action_cookie_destroy(entry->cookie);
+	flow_action_cookie_destroy(entry->user_cookie);
 }
 
 void tc_cleanup_offload_action(struct flow_action *flow_action)
@@ -3520,7 +3520,7 @@ void tc_cleanup_offload_action(struct flow_action *flow_action)
 	int i;
 
 	flow_action_for_each(i, entry, flow_action) {
-		tcf_act_put_cookie(entry);
+		tcf_act_put_user_cookie(entry);
 		if (entry->destructor)
 			entry->destructor(entry->destructor_priv);
 	}
@@ -3565,7 +3565,7 @@ int tc_setup_action(struct flow_action *flow_action,
 
 		entry = &flow_action->entries[j];
 		spin_lock_bh(&act->tcfa_lock);
-		err = tcf_act_get_cookie(entry, act);
+		err = tcf_act_get_user_cookie(entry, act);
 		if (err)
 			goto err_out_locked;
 
@@ -3577,7 +3577,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		for (k = 0; k < index ; k++) {
 			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
 			entry[k].hw_index = act->tcfa_index;
-			entry[k].act_cookie = (unsigned long)act;
+			entry[k].cookie = (unsigned long)act;
 		}
 
 		j += index;
-- 
2.30.1

