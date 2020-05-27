Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F171E3509
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgE0Buq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:46 -0400
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:61537
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728373AbgE0Buo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezJLkZWUiNCC+EFfuO/WppqcIbRoLSVsArNN4+SXPATBOXQpXo6DM8lSvXQ9zWSkJx3RES6IryzTLZauxsI17OGPdKJ8vr7WzgUe8Ynhb7bwn1gl1UKJgIIC6RhxRXxhFSEA5BVb/R2+trBBm8cb/5LHvKCmIUoBSZarHvyVB9/MM4WfJHrZPnG+u4CsbPkkiQivpiiSsAc33GX0t+RVGCbU8uToq/DKpgCWO+UhBdkFWUGt9dz3R18kjJXlDsciOsDZ2iWA9b8ta6vpP8co75oMnoD84v06TbjJ8e86z2URLTtis82grRIgWhQ91bMwfw0ZR45xGX5gkZiXwo+Uag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otbVZdgMdC3AHs8VfZl+E2KfEUCjmQP2vmf4TrfQ2nY=;
 b=W+7arwyhTsLwrhLsRtQQfvaOifFXO1K+hH32QxybF0hWbL9/rjrPzZn20HblrWGGBw+h2yPysd7dxDmVmidT61l7p5x0PTVcQ448mvR3BpnxFDXBVWscs/k1Kl75RjNPqrVnrkloz5H6vefBuQ1s4tO3MqRknbl/WXyFsjphePLbQkFrteRyT5eICf2EUCPi9yHWcHFIDSyPG2M6a3imo4rnAK7ugUASStk9k+UFOdBkpKsq29VAP98ekTk6BMbPVqYnDN5NRXBfZdFio+oit9nvFxCbnkszwIcMlbszwY8cYoUY7dDK8liPaAzdY0g+ysYR1qIqrh1AZWW3a8jR1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otbVZdgMdC3AHs8VfZl+E2KfEUCjmQP2vmf4TrfQ2nY=;
 b=YUszg+uYNl9wJCkGyvhHkxVv2ehTblPq20+QBsgw/FyiudUqPN9w+JLU8qUMZva9IqPpgqo0JRnIlTJcr6FbnWh8HOjH0csQ8kTGoTGkCJEh0g/zl91mhFCJrb2nZT8nPiaaLhDXfixdwBwGYAFarLPphkw2bnPuk2DPzmN+4KQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6637.eurprd05.prod.outlook.com (2603:10a6:800:142::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 01:50:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 16/16] net/mlx5: DR, Split RX and TX lock for parallel insertion
Date:   Tue, 26 May 2020 18:49:24 -0700
Message-Id: <20200527014924.278327-17-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:28 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c063166-a49b-4f95-6ca9-08d801e055c9
X-MS-TrafficTypeDiagnostic: VI1PR05MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB663736ABF8057EFB87E32F9DBEB10@VI1PR05MB6637.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: np26/RJyYrPUqiOgppA3VfgiRxpztiyXRpk0HrAJHj8C7XuNyV9ITLF8aAkK2JVNqOEpUKdwbp5keQqoeHHVPCGWMTlCiPbtvr82pl3ylAQq1WJmp6Z9bT/mtF2tYG0JT7o2PphTqOYAoKJdwVB0v9nNWmOIJfgReJZvfmwFO0CZnEnMjdjTXs2lRwC1FtCwpUJR4RmxU66xJ9sk8TZDRI+qp8Ig+jjl7sXcGKbz582OdSstY9i3DkPG5VY7xT4UG4qHAyeqs8eUwvZyvCs3MQZ1ntUAkIrn9PxJEZYxn4hnvTmWHNz8MwazegzzgjERtqsOu1Xde2Ecd0ulEfL8uF58r9NlDwcLSH1Xo71/GVeM82NsRxQC/Nhd1uxuwjjg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(26005)(6506007)(6486002)(6512007)(8676002)(478600001)(16526019)(86362001)(2906002)(186003)(6666004)(5660300002)(1076003)(66476007)(36756003)(54906003)(2616005)(956004)(66946007)(107886003)(8936002)(316002)(52116002)(66556008)(4326008)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CD3zv+U2cE5T7MDY23nKG0f+D2mptf6VbIbPJkY+B6Mb13X1OvVxmS3mcCf0n2HNeMlQ1U70LW9pHb1eF+ii0dPaGGxgWkR4yCwI3dms9qM2WIlx6cQBf23I5rxkkml5l44WFBlGcJQ+S8NTE7BgjMw+8wbivLeIkfPEQBUUoeBTM/Dd61hAbirakdnQv+Pe6uzmwArzfDjCdTkgldEwxd3OUTOquXLH2F+lUnfHOB9nR+noEODcfUiaZ2GhLp8Yw0idnnAGd4XBiPp3hdsPFl3kvuiAsWS7S1t4YtdgCytcSxmKAvw2oI6oJl2jq3skeJPUJcydbJWt4ta7hvZ/7vNoml35jj7JZ5Kjy6WshOVkL49hYnldZer4cWdnRalFlfv+9PElwvrN6Q941EpI7OWZs8OIDg3dJNzs+lbI2fly73EDrXLaj2clyEl7s5aSiZDjwE7wwfnFjb0btcES+6vfmUPra5vRjYXiuUvRWzU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c063166-a49b-4f95-6ca9-08d801e055c9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:30.1118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1DA0GEqiGig4LQwe55IbqjiEcAXAp3Pq1QR0gtIDq403cYSU5QF3pHaQ9KhXVPzvWUztzgQbUTRPekhvxvShA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6637
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

