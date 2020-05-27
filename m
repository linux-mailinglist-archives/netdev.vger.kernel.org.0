Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBFB1E49DD
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390999AbgE0QXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:23:39 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:27424
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390995AbgE0QXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:23:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkyUeFCT5c1MIgC068732LbIBpyhAlqZqvRj57mREmz9JDSRZ+TmH1/eD0WQFij+DX9pKEG63OA0Fb2SSZqgla96bmJ9Pf4ISTc1+YDGIfIjxJDlkRbScN/+GeC+1d8BHC8vWSNHcVjUOfJVHwQk145BUdwT4yFIeOMdJ4m18U1Y8KmfM7oiRDK+XPtxO//IA6NgZL1QUYg3AmrSPkYFs/ZDblTQohSkLX4ZOJbTs1nIwluAGi5FcZ7iPf2sTCUz/mRdD+vobbptNIoO73JInxV137tf9BmbtMM4xOH5Pp9XI655aOjSvRlglYldx4qjDwgubC1oDTItsjMX+bHqtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otbVZdgMdC3AHs8VfZl+E2KfEUCjmQP2vmf4TrfQ2nY=;
 b=FWI9a2yhn+DSG+qmSXNyPwpK96BriB69LR3BMtKw+PB8jPAs16H6YKbZ3TKeggj7v+QoZ5rT02uXsxfevfZ6+HlyE+8RM/yVx1gRN0xKkrtAo0gpa7vso62hKHQAQNUWzXxfz4K2YAgxNySnCh/1kPVqvvvLWblb2KuPo0WyqepUP7m5u7/x2D+Gzkp3ytzGYfUSJc/BQrdhmaCXQ/QQRDUns3gLqJYB8P3ac+vM2WCKIL9faLrew660+peraG4q6o/kvDpdEGLsIDaoiXYP0v50E4upYM4PtpCSP41JcPC3r+Rtdr1qRKrRTQ+q6LTymVMJStpDYXq1T5LrdjzLqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otbVZdgMdC3AHs8VfZl+E2KfEUCjmQP2vmf4TrfQ2nY=;
 b=cVrtPVEYxNugmZNdUZENa3e9kfdfpew5gWG22/kiMHM+Uerb4y66WfWj5awlveWCpPzV1c0mnLHAw2bcOdOF85G2QjcH51XUhu0DlED+VNseF6jmWvanlYEj9/CN9WfioHbzi7xBa2D0VAhO726bvccNfKWCYOy7hsD6fh6VXNU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7039.eurprd05.prod.outlook.com (2603:10a6:800:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 16:22:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 15/15] net/mlx5: DR, Split RX and TX lock for parallel insertion
Date:   Wed, 27 May 2020 09:21:39 -0700
Message-Id: <20200527162139.333643-16-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527162139.333643-1-saeedm@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:29 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 72057ed9-659e-4e07-e818-08d8025a2797
X-MS-TrafficTypeDiagnostic: VI1PR05MB7039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB70395EAC592DB04EC2436680BEB10@VI1PR05MB7039.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTuZE/mmF7zhbhqzGaei+lW4GXYkpY8asUUkfJZKUXuQ95eh+HI9kogNrAJ3rcnyXWh+O/lfZn7F+G1soHxJi50SBVNv6jimhiFZ1Zp3Jx5d4CzuPA9IynWefGpeDhWHv4ZvP2wOZE4hdiIvg3sy+Fp0rvVjKV1Si8G3WC74Ci6euO2df+/TTCqENHC5LcYACBIJ2VNyBN5ArVHL6yxBNhq9AJ+q26p0qT87vsRozbZP5cebWWDJeCRjg82Hpaes5kq3hc9vSHrRpY1qsI9xZ3fEGo5rr6lUMW30sbhsRt4qTHbTAVPShEQ35UGOCnjFvUd4t3Rvw5akSInr4xU4aQbsKSVLZtV25dzC30P6dLE9Z+bUStSgap1sPD8ZWIDe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(956004)(36756003)(6486002)(54906003)(478600001)(107886003)(6512007)(86362001)(83380400001)(316002)(5660300002)(26005)(16526019)(6506007)(66476007)(66946007)(66556008)(186003)(52116002)(1076003)(2616005)(4326008)(6666004)(2906002)(8676002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AEg7uOSkY6pGo36bq1mDOUFwZLho1MhZgDBMWWPF0jOpbwkIeJzzXJYm3J4zGgIeIAoWN9DQqMjriJw76zRz0jDx+JL/cEShooOb1FGEf/x8NE2MUOWKUDfkjuHkQlAYvxOj0EyQ6TAnZQ8ataQhvQLAJxW9Zd0hozQNaUuBol6tCaqXptF1noef/RM6GQrwtxSPVNrDuqkAWe2rmEsA1JOXfmvUDbdPZpmI8d/ZlRLOgW2Nr5tKPCGtfSQmbgRFv01/OWnXwHbghEhc/myRib4+BpQ+3gLl7lWQWjx9n8Bc+Dc8dEYhZduLh1q0bGkungFK5mmbhe2U0bmghEucKKbWYYFdMa6uXOXLMlnnEuUukTLPDyTLFXnJO8/adXiOGXxKUw/uyzgEKhVup2Tvn3Pr00PnAsXhxx/iCPuSIC4h4/u7JQEbLb/X2Dw4o8zVPeP8vZIB/8vGHGK87lQ1jv7hzYF8m8jvSux6tyLYlfA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72057ed9-659e-4e07-e818-08d8025a2797
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:30.9802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmGb7qF9oeZ7VYXMdH0T2tf8dJSG51Nc37gmq/lWS/I2CwvhPy8Gdm7QeimveM0z2+0BC+rkCcQ53lKHPBTEZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7039
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

