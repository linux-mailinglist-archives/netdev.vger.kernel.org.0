Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E5A1E52D4
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgE1BTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:19:38 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:45795
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgE1BTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:19:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZR7ITdwx4qjVMMq+zT/O1LLpxVdGyw5KzxngKJNO73hjQ27FqSebwPIuJ9JV9KJsVW2rqfrZF6DRgHMKXxpV0VkOP77Ytew/6QVrlu1sVi5nZ8MMMTzlMt+WjC2U7hiebrev1LC4heqq2wx/0wstfFB1m112GuhpnnTasB0swUCZ08JdWsgvrQfcz//lF+buD6H6BtmS9R4TCrJfN2quIqdATj1/L/MuZfo8iujruVAVlDhUXMb2Znc2GbNwSN02X/e7qz2nDQdfs077dibBa/h9rd3DBQlsv2yve6266Zz1QttQycZNkw0MLu/fEYvAUvqFtPO+X5GbC4lonbDoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otbVZdgMdC3AHs8VfZl+E2KfEUCjmQP2vmf4TrfQ2nY=;
 b=RLQG0C6kgGwjkmg5yZdpDv98vn4nNI+HnpXP1+r8ER0/deJBZqcbQMaqFxqgH95Hk7zi33NVwkm+oVsOvth60IIDoEGbq853NnQMsaNT/10RDnjp6hgnF6LLS0KdmpmxTTbcmkqf+fbeZFoRSrouaC50IxP7hRcINFlHprht56sfoI+U+bVV6q1qxh+QCQo0g4mp391RX1p4wmi+uibDj9sXGNsTCRmlabKzDSlWKZPDrxkMOKplNz5LWM8yQ+yhL1Ugtm8GQySUZr9lyXDsYV+gMvFHdheeEc0Xo/q6cLC6HFfExcCOJriBEnSnlI7YESEsXbju+gWtoPkVvxTTdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otbVZdgMdC3AHs8VfZl+E2KfEUCjmQP2vmf4TrfQ2nY=;
 b=gwb2C32RCNJbndc9O68xA+WN331y5M1VL84GWMQCXvpkK8iBa+POjZPpiwj5ddbezdJjiHxaPyiaHzzSozxzt+g8zV6WbxvjcptRKbbzn8OGdi8yrskxoO4mBZWfGQ0xWsDfer/83wHoihfBVHpbU/pQI9yXjbZU31EaXEoqXbg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:18:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:18:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 15/15] net/mlx5: DR, Split RX and TX lock for parallel insertion
Date:   Wed, 27 May 2020 18:16:56 -0700
Message-Id: <20200528011656.559914-16-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6a592ce6-fe78-4fc6-7b9c-08d802a4f607
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43683196DFD06E82FEED6549BE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/WuvLzoFVELYSx5RgHfdmJZwIdFUViZWgsS7SFg458owbe788kcXU5ZOQutiJZjMiN9vbxSv51nNQhrW9OXCXdavLdCOx6wbSW7AFmjX3uhLBoZ/f0xaEEDrYlC8rzjz0C+EpuE1teOC+rmzqbUY3wnBORzIHa6YLkfwjC+ylsuttZenqRYer0sEJYfW40bWxw3MK+gvqGGXN8mf/EC+wpoeWYojd9/fBLcL9O04tBunWXmtlRBdDY+XwmXSdOtxv7sM2g574WjW+bEMaIcw4gFucMgTkMBXp8YpEYc++rsaTxX/sBGFPpZPHit3jt89xabbLXoJPMRoCqxfUKiO/DNH3WC1SLLCYNtelLxyXPYH6FDg/8gVXXdDg771LPK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KvFlO46+fX9WuckOfk4BJvsLNI/A+yiwZko0Nelbh+5pvdsP5HTDlatjvu4dUtkd/kxiVX8o1O9eUHKU3TjRvX193fSdVrVWPdrA0uqM/uCV7DbKSmvzyHIw/F02Rlm31iJTEZFao7Tetb0XUhCqqc0pmWZZPPUSkmc/Qq37cwtL+6aG3gyuCdKO61Mb6vx8hi/KF9YYISY9hrQ8zZadOlMI1G6iuwKHliXuiuuShr0LRV/j8IZZHegF+qkD2/7+JNi87WKrH+2wBYZMJ8uKKM3ABOBdP9PRXrYwq2kvZaBy4+YoXax4lRvkYcWWy8WRoYStvFugqA6LWGlIv7BQJjcFOJ6y+yXA0LfLUVPAFBxAp4hG47Qrvm6oIsTcKfTXSeZGx/w9K/Lgk0RCptxSX9bqPUxPcW1TfJ9bv1yTSjBa4J8ZK4/WrRmnwkP1Y/juyB9C4IkS7L9TDI9PiZS9C3yHqq1B0q5cjpgfrgjrwcM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a592ce6-fe78-4fc6-7b9c-08d802a4f607
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:18:00.0721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQOZXpG9+W++HYEihWn0hadcc9p+RR9YxFPMgY0bDghsPmN9f4yH4qQMnrXhh3Y4kHDqDyhc7L3GrgBttczgrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Change the locking flow to support RX and TX locks, splitting
the single lock to two will allow inserting rules in parallel
for RX and TX parts of the FDB.

Locking the dr_domain will be done by locking the RX domain
and the TX domain locks, this is mostly used for control operations
on the dr_domain. When inserting rules for RX or TX the single
nic_doamin RX or TX lock will be used. Splitting the lock is safe since
RX and TX domains are logically separated from each other, shared
objects such the send-ring and memory pool are protected by locks.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_domain.c   | 14 +++++----
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 10 +++---
 .../mellanox/mlx5/core/steering/dr_rule.c     | 31 +++++++++----------
 .../mellanox/mlx5/core/steering/dr_table.c    | 12 +++----
 .../mellanox/mlx5/core/steering/dr_types.h    | 24 +++++++++++++-
 5 files changed, 56 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 48b6358b6845..890767a2a7cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -297,7 +297,8 @@ mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type type)
 	dmn->mdev = mdev;
 	dmn->type = type;
 	refcount_set(&dmn->refcount, 1);
-	mutex_init(&dmn->mutex);
+	mutex_init(&dmn->info.rx.mutex);
+	mutex_init(&dmn->info.tx.mutex);
 
 	if (dr_domain_caps_init(mdev, dmn)) {
 		mlx5dr_err(dmn, "Failed init domain, no caps\n");
@@ -345,9 +346,9 @@ int mlx5dr_domain_sync(struct mlx5dr_domain *dmn, u32 flags)
 	int ret = 0;
 
 	if (flags & MLX5DR_DOMAIN_SYNC_FLAGS_SW) {
-		mutex_lock(&dmn->mutex);
+		mlx5dr_domain_lock(dmn);
 		ret = mlx5dr_send_ring_force_drain(dmn);
-		mutex_unlock(&dmn->mutex);
+		mlx5dr_domain_unlock(dmn);
 		if (ret) {
 			mlx5dr_err(dmn, "Force drain failed flags: %d, ret: %d\n",
 				   flags, ret);
@@ -371,7 +372,8 @@ int mlx5dr_domain_destroy(struct mlx5dr_domain *dmn)
 	dr_domain_uninit_cache(dmn);
 	dr_domain_uninit_resources(dmn);
 	dr_domain_caps_uninit(dmn);
-	mutex_destroy(&dmn->mutex);
+	mutex_destroy(&dmn->info.tx.mutex);
+	mutex_destroy(&dmn->info.rx.mutex);
 	kfree(dmn);
 	return 0;
 }
@@ -379,7 +381,7 @@ int mlx5dr_domain_destroy(struct mlx5dr_domain *dmn)
 void mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
 			    struct mlx5dr_domain *peer_dmn)
 {
-	mutex_lock(&dmn->mutex);
+	mlx5dr_domain_lock(dmn);
 
 	if (dmn->peer_dmn)
 		refcount_dec(&dmn->peer_dmn->refcount);
@@ -389,5 +391,5 @@ void mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
 	if (dmn->peer_dmn)
 		refcount_inc(&dmn->peer_dmn->refcount);
 
-	mutex_unlock(&dmn->mutex);
+	mlx5dr_domain_unlock(dmn);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index a95938874798..31abcbb95ca2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -690,7 +690,7 @@ mlx5dr_matcher_create(struct mlx5dr_table *tbl,
 	refcount_set(&matcher->refcount, 1);
 	INIT_LIST_HEAD(&matcher->matcher_list);
 
-	mutex_lock(&tbl->dmn->mutex);
+	mlx5dr_domain_lock(tbl->dmn);
 
 	ret = dr_matcher_init(matcher, mask);
 	if (ret)
@@ -700,14 +700,14 @@ mlx5dr_matcher_create(struct mlx5dr_table *tbl,
 	if (ret)
 		goto matcher_uninit;
 
-	mutex_unlock(&tbl->dmn->mutex);
+	mlx5dr_domain_unlock(tbl->dmn);
 
 	return matcher;
 
 matcher_uninit:
 	dr_matcher_uninit(matcher);
 free_matcher:
-	mutex_unlock(&tbl->dmn->mutex);
+	mlx5dr_domain_unlock(tbl->dmn);
 	kfree(matcher);
 dec_ref:
 	refcount_dec(&tbl->refcount);
@@ -791,13 +791,13 @@ int mlx5dr_matcher_destroy(struct mlx5dr_matcher *matcher)
 	if (refcount_read(&matcher->refcount) > 1)
 		return -EBUSY;
 
-	mutex_lock(&tbl->dmn->mutex);
+	mlx5dr_domain_lock(tbl->dmn);
 
 	dr_matcher_remove_from_tbl(matcher);
 	dr_matcher_uninit(matcher);
 	refcount_dec(&matcher->tbl->refcount);
 
-	mutex_unlock(&tbl->dmn->mutex);
+	mlx5dr_domain_unlock(tbl->dmn);
 	kfree(matcher);
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index cce3ee7a6614..cd708dcc2e3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -938,7 +938,10 @@ static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
 static int dr_rule_destroy_rule_nic(struct mlx5dr_rule *rule,
 				    struct mlx5dr_rule_rx_tx *nic_rule)
 {
+	mlx5dr_domain_nic_lock(nic_rule->nic_matcher->nic_tbl->nic_dmn);
 	dr_rule_clean_rule_members(rule, nic_rule);
+	mlx5dr_domain_nic_unlock(nic_rule->nic_matcher->nic_tbl->nic_dmn);
+
 	return 0;
 }
 
@@ -1039,18 +1042,18 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	if (dr_rule_skip(dmn->type, nic_dmn->ste_type, &matcher->mask, param))
 		return 0;
 
+	hw_ste_arr = kzalloc(DR_RULE_MAX_STE_CHAIN * DR_STE_SIZE, GFP_KERNEL);
+	if (!hw_ste_arr)
+		return -ENOMEM;
+
+	mlx5dr_domain_nic_lock(nic_dmn);
+
 	ret = mlx5dr_matcher_select_builders(matcher,
 					     nic_matcher,
 					     dr_rule_get_ipv(&param->outer),
 					     dr_rule_get_ipv(&param->inner));
 	if (ret)
-		goto out_err;
-
-	hw_ste_arr = kzalloc(DR_RULE_MAX_STE_CHAIN * DR_STE_SIZE, GFP_KERNEL);
-	if (!hw_ste_arr) {
-		ret = -ENOMEM;
-		goto out_err;
-	}
+		goto free_hw_ste;
 
 	/* Set the tag values inside the ste array */
 	ret = mlx5dr_ste_build_ste_arr(matcher, nic_matcher, param, hw_ste_arr);
@@ -1115,6 +1118,8 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	if (htbl)
 		mlx5dr_htbl_put(htbl);
 
+	mlx5dr_domain_nic_unlock(nic_dmn);
+
 	kfree(hw_ste_arr);
 
 	return 0;
@@ -1129,8 +1134,8 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 		kfree(ste_info);
 	}
 free_hw_ste:
+	mlx5dr_domain_nic_unlock(nic_dmn);
 	kfree(hw_ste_arr);
-out_err:
 	return ret;
 }
 
@@ -1232,31 +1237,23 @@ struct mlx5dr_rule *mlx5dr_rule_create(struct mlx5dr_matcher *matcher,
 {
 	struct mlx5dr_rule *rule;
 
-	mutex_lock(&matcher->tbl->dmn->mutex);
 	refcount_inc(&matcher->refcount);
 
 	rule = dr_rule_create_rule(matcher, value, num_actions, actions);
 	if (!rule)
 		refcount_dec(&matcher->refcount);
 
-	mutex_unlock(&matcher->tbl->dmn->mutex);
-
 	return rule;
 }
 
 int mlx5dr_rule_destroy(struct mlx5dr_rule *rule)
 {
 	struct mlx5dr_matcher *matcher = rule->matcher;
-	struct mlx5dr_table *tbl = rule->matcher->tbl;
 	int ret;
 
-	mutex_lock(&tbl->dmn->mutex);
-
 	ret = dr_rule_destroy_rule(rule);
-
-	mutex_unlock(&tbl->dmn->mutex);
-
 	if (!ret)
 		refcount_dec(&matcher->refcount);
+
 	return ret;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index c2fe48d7b75a..b599b6beb5b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -14,7 +14,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 	if (action && action->action_type != DR_ACTION_TYP_FT)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tbl->dmn->mutex);
+	mlx5dr_domain_lock(tbl->dmn);
 
 	if (!list_empty(&tbl->matcher_list))
 		last_matcher = list_last_entry(&tbl->matcher_list,
@@ -78,7 +78,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 		refcount_inc(&action->refcount);
 
 out:
-	mutex_unlock(&tbl->dmn->mutex);
+	mlx5dr_domain_unlock(tbl->dmn);
 	return ret;
 }
 
@@ -95,7 +95,7 @@ static void dr_table_uninit_fdb(struct mlx5dr_table *tbl)
 
 static void dr_table_uninit(struct mlx5dr_table *tbl)
 {
-	mutex_lock(&tbl->dmn->mutex);
+	mlx5dr_domain_lock(tbl->dmn);
 
 	switch (tbl->dmn->type) {
 	case MLX5DR_DOMAIN_TYPE_NIC_RX:
@@ -112,7 +112,7 @@ static void dr_table_uninit(struct mlx5dr_table *tbl)
 		break;
 	}
 
-	mutex_unlock(&tbl->dmn->mutex);
+	mlx5dr_domain_unlock(tbl->dmn);
 }
 
 static int dr_table_init_nic(struct mlx5dr_domain *dmn,
@@ -177,7 +177,7 @@ static int dr_table_init(struct mlx5dr_table *tbl)
 
 	INIT_LIST_HEAD(&tbl->matcher_list);
 
-	mutex_lock(&tbl->dmn->mutex);
+	mlx5dr_domain_lock(tbl->dmn);
 
 	switch (tbl->dmn->type) {
 	case MLX5DR_DOMAIN_TYPE_NIC_RX:
@@ -201,7 +201,7 @@ static int dr_table_init(struct mlx5dr_table *tbl)
 		break;
 	}
 
-	mutex_unlock(&tbl->dmn->mutex);
+	mlx5dr_domain_unlock(tbl->dmn);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index b6061c639cb1..c6d5a81d138b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -636,6 +636,7 @@ struct mlx5dr_domain_rx_tx {
 	u64 drop_icm_addr;
 	u64 default_icm_addr;
 	enum mlx5dr_ste_entry_type ste_type;
+	struct mutex mutex; /* protect rx/tx domain */
 };
 
 struct mlx5dr_domain_info {
@@ -660,7 +661,6 @@ struct mlx5dr_domain {
 	struct mlx5_uars_page *uar;
 	enum mlx5dr_domain_type type;
 	refcount_t refcount;
-	struct mutex mutex; /* protect domain */
 	struct mlx5dr_icm_pool *ste_icm_pool;
 	struct mlx5dr_icm_pool *action_icm_pool;
 	struct mlx5dr_send_ring *send_ring;
@@ -814,6 +814,28 @@ struct mlx5dr_icm_chunk {
 	struct list_head *miss_list;
 };
 
+static inline void mlx5dr_domain_nic_lock(struct mlx5dr_domain_rx_tx *nic_dmn)
+{
+	mutex_lock(&nic_dmn->mutex);
+}
+
+static inline void mlx5dr_domain_nic_unlock(struct mlx5dr_domain_rx_tx *nic_dmn)
+{
+	mutex_unlock(&nic_dmn->mutex);
+}
+
+static inline void mlx5dr_domain_lock(struct mlx5dr_domain *dmn)
+{
+	mlx5dr_domain_nic_lock(&dmn->info.rx);
+	mlx5dr_domain_nic_lock(&dmn->info.tx);
+}
+
+static inline void mlx5dr_domain_unlock(struct mlx5dr_domain *dmn)
+{
+	mlx5dr_domain_nic_unlock(&dmn->info.tx);
+	mlx5dr_domain_nic_unlock(&dmn->info.rx);
+}
+
 static inline int
 mlx5dr_matcher_supp_flex_parser_icmp_v4(struct mlx5dr_cmd_caps *caps)
 {
-- 
2.26.2

