Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6D41853C1
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgCNBRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:17:05 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:31971
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727802AbgCNBRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:17:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mj+4alGv24oF5rnh6fyQkUYHdfOhbUkKzroCzd1X+O+1ST7P5YBnPHfETwYOogi8qdlqam3dRQ728qU6pj9e2coShVVzh9/KquNGYqgs7gBA7Cf8XlTyTC7yvgsFwhisupHuG/aj95XXGhFHp6tpHtuSvwly+VcwdCRS4/dK7YcOsmb+tG9z6Azg3wWBEqw/VcgiUgnu4P2iTtUs3cZYjkUU8CMsnjhC26FOrd5csRhhlwFBg3WWxbqfgJgqrmiMi/Q/JbRv4brr+cLj83m+fUKLlFixyOPERaSxsvC0SAb6P9TxFjYjn426JIJwD2u20F1cK2n0eTNngOzO2svfkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9I8GIHjILJfIX9y+1HdlSW8OyXYClTaoFVoX6lusPmA=;
 b=cSTRyS9WPUvMR5iyH7gHSqfwjpIWvIeiaMF08ycpxf1kOiIXMZFExcynv5vOAZHFtKttKculHqbhFiByUigsS4/N+J5BK8c146zuJqyd4dZB0TukWOrRRZTbgUBwojgLfa7+f5YIUh2DIPVvDyYx240HWvvmKbO8dRdZTEADoS33lMwuZlkUFjs5l3Se1xM3Dvr+TMh2Uh4Tw6RxYt/0MyixqEVPjBGxMacqKzhDBMxBkaV0zk9G1Cvm/b4qWCmC4zHxMoLzC2IUXEyoDwHmOuz7AM1qIMhEozphmDj0+WS4VvhbW3K7FoV6U1XFbjGfMeeCJ0CFjzAQ1hX7vlTFPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9I8GIHjILJfIX9y+1HdlSW8OyXYClTaoFVoX6lusPmA=;
 b=KH23iQSF4zKnKDzcmGWzL8WvjEVw1gEvxW4fyD0ImScGinKX6f3naqb0tsOaLIXxolKQ2qY9CSH86G987xODgErM2LedxHtiTAiARLBQQ2+utKpYizGg6Jc3tWfpC7BbWyEmpUaWZdKnHKUp1zDPNxpRf1uCx2N+sTPvKNjkV/M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:16:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:16:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/14] net/mlx5: E-Switch, Introduce per vport configuration for eswitch modes
Date:   Fri, 13 Mar 2020 18:16:14 -0700
Message-Id: <20200314011622.64939-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:16:52 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7c3fc2f2-f204-45cb-03dd-08d7c7b5622a
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB684525909044B1320D7BE741BEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(30864003)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUI/hT8qOEVCMwbjj7bjo+OoApRBhZWZEEwgAq38qM4x/r7oTRGh64amnc+naRoMzTsSWTx6hsHtTx6PfwTEMK8irNRGzdUXeAI9d9G9uLHX10srcL9k56dsVGbA3LDVi44KffwHfqItFpTVbVoeVrs+tLLI8Iw4wvLUbThZLTuAx1qIKrEfhvkb/Dfb0Xo2B36xeWo9y3USrVTZMFtjo/qOpxGmraisKDmJctGWIpBDAa/WpUtReKoBF+MJQ2pQY0NGBRAn0FR19d2EBh0KtB4rHSNZR3hc81bSWx0+QnAAXbV9Zp0MV9zqqlYVJ1wywDjkbagE6Sfx+okninq3AHWFuMs7EUnyt8fnR5uk72G6WFL1cbQ6jM42mbg0arQTKvcDV0LuLSlbdfUO2KotasYboCY6nXyciQsD+QJA36tJeonQzvvedgOs2lPT7qZ0hTOUo8o8gwQCFDbyOX8Im9N4CnB8oYrLQtwyW9UjZTzZXbvo8Il1jbYdiHW1CgtGII8MChyab5BW1LFhgMlvY+2lLIkvQ7r7Qh3GoRUJxfs=
X-MS-Exchange-AntiSpam-MessageData: GGrNiaGDudsUKRsBzjAwiYpoQKEdqzZbYVXRmvOdKLrrok9F/X+QGsxVeMiBoXuKu9HnqM06/UD82063rNkfS7BN+V5P0X4E5ermZ6R5RlM3KWvsu5Cui7jewIiyht08v/hrJBH2WynWtkYIm9kGdA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3fc2f2-f204-45cb-03dd-08d7c7b5622a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:16:55.7026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0XzCFHGCbZjZZDvjbiQ0oIa+cjFdpLc/PFwFaffAY/RWOmmzBUeRsLZNdS52/+8D3gPwGJp91+uLVSTFyh8ijA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

Both legacy and offload modes require vport setup, only offload mode
requires rep setup. Before this patch, vport and rep operations are
separated applied to all relevant vports in different stages.

Change to use per vport configuration, so that vport and rep operations
are modularized per vport.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  73 ++++++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   3 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 143 +++++++-----------
 3 files changed, 111 insertions(+), 108 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 603286883550..2f556c820230 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1806,12 +1806,14 @@ static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 	esw_vport_cleanup_acl(esw, vport);
 }
 
-static int esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+static int esw_enable_vport(struct mlx5_eswitch *esw, u16 vport_num,
 			    enum mlx5_eswitch_vport_event enabled_events)
 {
-	u16 vport_num = vport->vport;
+	struct mlx5_vport *vport;
 	int ret;
 
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+
 	mutex_lock(&esw->state_lock);
 	WARN_ON(vport->enabled);
 
@@ -1841,10 +1843,11 @@ static int esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 	return ret;
 }
 
-static void esw_disable_vport(struct mlx5_eswitch *esw,
-			      struct mlx5_vport *vport)
+static void esw_disable_vport(struct mlx5_eswitch *esw, u16 vport_num)
 {
-	u16 vport_num = vport->vport;
+	struct mlx5_vport *vport;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
 
 	mutex_lock(&esw->state_lock);
 	if (!vport->enabled)
@@ -1950,6 +1953,32 @@ static void mlx5_eswitch_clear_vf_vports_info(struct mlx5_eswitch *esw)
 /* Public E-Switch API */
 #define ESW_ALLOWED(esw) ((esw) && MLX5_ESWITCH_MANAGER((esw)->dev))
 
+static int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
+				   enum mlx5_eswitch_vport_event enabled_events)
+{
+	int err;
+
+	err = esw_enable_vport(esw, vport_num, enabled_events);
+	if (err)
+		return err;
+
+	err = esw_offloads_load_rep(esw, vport_num);
+	if (err)
+		goto err_rep;
+
+	return err;
+
+err_rep:
+	esw_disable_vport(esw, vport_num);
+	return err;
+}
+
+static void mlx5_eswitch_unload_vport(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	esw_offloads_unload_rep(esw, vport_num);
+	esw_disable_vport(esw, vport_num);
+}
+
 /* mlx5_eswitch_enable_pf_vf_vports() enables vports of PF, ECPF and VFs
  * whichever are present on the eswitch.
  */
@@ -1957,28 +1986,25 @@ int
 mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 				 enum mlx5_eswitch_vport_event enabled_events)
 {
-	struct mlx5_vport *vport;
 	int num_vfs;
 	int ret;
 	int i;
 
 	/* Enable PF vport */
-	vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
-	ret = esw_enable_vport(esw, vport, enabled_events);
+	ret = mlx5_eswitch_load_vport(esw, MLX5_VPORT_PF, enabled_events);
 	if (ret)
 		return ret;
 
 	/* Enable ECPF vport */
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
-		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
-		ret = esw_enable_vport(esw, vport, enabled_events);
+		ret = mlx5_eswitch_load_vport(esw, MLX5_VPORT_ECPF, enabled_events);
 		if (ret)
 			goto ecpf_err;
 	}
 
 	/* Enable VF vports */
-	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs) {
-		ret = esw_enable_vport(esw, vport, enabled_events);
+	mlx5_esw_for_each_vf_vport_num(esw, i, esw->esw_funcs.num_vfs) {
+		ret = mlx5_eswitch_load_vport(esw, i, enabled_events);
 		if (ret)
 			goto vf_err;
 	}
@@ -1986,17 +2012,14 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 
 vf_err:
 	num_vfs = i - 1;
-	mlx5_esw_for_each_vf_vport_reverse(esw, i, vport, num_vfs)
-		esw_disable_vport(esw, vport);
+	mlx5_esw_for_each_vf_vport_num_reverse(esw, i, num_vfs)
+		mlx5_eswitch_unload_vport(esw, i);
 
-	if (mlx5_ecpf_vport_exists(esw->dev)) {
-		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
-		esw_disable_vport(esw, vport);
-	}
+	if (mlx5_ecpf_vport_exists(esw->dev))
+		mlx5_eswitch_unload_vport(esw, MLX5_VPORT_ECPF);
 
 ecpf_err:
-	vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
-	esw_disable_vport(esw, vport);
+	mlx5_eswitch_unload_vport(esw, MLX5_VPORT_PF);
 	return ret;
 }
 
@@ -2005,11 +2028,15 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
  */
 void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw)
 {
-	struct mlx5_vport *vport;
 	int i;
 
-	mlx5_esw_for_all_vports_reverse(esw, i, vport)
-		esw_disable_vport(esw, vport);
+	mlx5_esw_for_each_vf_vport_num_reverse(esw, i, esw->esw_funcs.num_vfs)
+		mlx5_eswitch_unload_vport(esw, i);
+
+	if (mlx5_ecpf_vport_exists(esw->dev))
+		mlx5_eswitch_unload_vport(esw, MLX5_VPORT_ECPF);
+
+	mlx5_eswitch_unload_vport(esw, MLX5_VPORT_PF);
 }
 
 static void mlx5_eswitch_get_devlink_param(struct mlx5_eswitch *esw)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 2e0417dd8ce3..1213a69cf397 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -651,6 +651,9 @@ esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag);
 u32
 esw_get_max_restore_tag(struct mlx5_eswitch *esw);
 
+int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num);
+void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c36185eb5fbb..865c120f577e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1678,14 +1678,6 @@ static void __unload_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
 	__unload_reps_special_vport(esw, rep_type);
 }
 
-static void esw_offloads_unload_all_reps(struct mlx5_eswitch *esw)
-{
-	u8 rep_type = NUM_REP_TYPES;
-
-	while (rep_type-- > 0)
-		__unload_reps_all_vport(esw, rep_type);
-}
-
 static int __esw_offloads_load_rep(struct mlx5_eswitch *esw,
 				   struct mlx5_eswitch_rep *rep, u8 rep_type)
 {
@@ -1702,44 +1694,6 @@ static int __esw_offloads_load_rep(struct mlx5_eswitch *esw,
 	return err;
 }
 
-static int __load_reps_special_vport(struct mlx5_eswitch *esw, u8 rep_type)
-{
-	struct mlx5_eswitch_rep *rep;
-	int err;
-
-	rep = mlx5_eswitch_get_rep(esw, MLX5_VPORT_UPLINK);
-	err = __esw_offloads_load_rep(esw, rep, rep_type);
-	if (err)
-		return err;
-
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
-		rep = mlx5_eswitch_get_rep(esw, MLX5_VPORT_PF);
-		err = __esw_offloads_load_rep(esw, rep, rep_type);
-		if (err)
-			goto err_pf;
-	}
-
-	if (mlx5_ecpf_vport_exists(esw->dev)) {
-		rep = mlx5_eswitch_get_rep(esw, MLX5_VPORT_ECPF);
-		err = __esw_offloads_load_rep(esw, rep, rep_type);
-		if (err)
-			goto err_ecpf;
-	}
-
-	return 0;
-
-err_ecpf:
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
-		rep = mlx5_eswitch_get_rep(esw, MLX5_VPORT_PF);
-		__esw_offloads_unload_rep(esw, rep, rep_type);
-	}
-
-err_pf:
-	rep = mlx5_eswitch_get_rep(esw, MLX5_VPORT_UPLINK);
-	__esw_offloads_unload_rep(esw, rep, rep_type);
-	return err;
-}
-
 static int __load_reps_vf_vport(struct mlx5_eswitch *esw, int nvports,
 				u8 rep_type)
 {
@@ -1759,26 +1713,6 @@ static int __load_reps_vf_vport(struct mlx5_eswitch *esw, int nvports,
 	return err;
 }
 
-static int __load_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
-{
-	int err;
-
-	/* Special vports must be loaded first, uplink rep creates mdev resource. */
-	err = __load_reps_special_vport(esw, rep_type);
-	if (err)
-		return err;
-
-	err = __load_reps_vf_vport(esw, esw->esw_funcs.num_vfs, rep_type);
-	if (err)
-		goto err_vfs;
-
-	return 0;
-
-err_vfs:
-	__unload_reps_special_vport(esw, rep_type);
-	return err;
-}
-
 static int esw_offloads_load_vf_reps(struct mlx5_eswitch *esw, int nvports)
 {
 	u8 rep_type = 0;
@@ -1798,25 +1732,46 @@ static int esw_offloads_load_vf_reps(struct mlx5_eswitch *esw, int nvports)
 	return err;
 }
 
-static int esw_offloads_load_all_reps(struct mlx5_eswitch *esw)
+int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
 {
-	u8 rep_type = 0;
+	struct mlx5_eswitch_rep *rep;
+	int rep_type;
 	int err;
 
-	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++) {
-		err = __load_reps_all_vport(esw, rep_type);
-		if (err)
-			goto err_reps;
-	}
+	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
+		return 0;
 
-	return err;
+	rep = mlx5_eswitch_get_rep(esw, vport_num);
+	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++)
+		if (atomic_cmpxchg(&rep->rep_data[rep_type].state,
+				   REP_REGISTERED, REP_LOADED) == REP_REGISTERED) {
+			err = esw->offloads.rep_ops[rep_type]->load(esw->dev, rep);
+			if (err)
+				goto err_reps;
+		}
+
+	return 0;
 
 err_reps:
-	while (rep_type-- > 0)
-		__unload_reps_all_vport(esw, rep_type);
+	atomic_set(&rep->rep_data[rep_type].state, REP_REGISTERED);
+	for (--rep_type; rep_type >= 0; rep_type--)
+		__esw_offloads_unload_rep(esw, rep, rep_type);
 	return err;
 }
 
+void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_eswitch_rep *rep;
+	int rep_type;
+
+	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
+		return;
+
+	rep = mlx5_eswitch_get_rep(esw, vport_num);
+	for (rep_type = NUM_REP_TYPES - 1; rep_type >= 0; rep_type--)
+		__esw_offloads_unload_rep(esw, rep, rep_type);
+}
+
 #define ESW_OFFLOADS_DEVCOM_PAIR	(0)
 #define ESW_OFFLOADS_DEVCOM_UNPAIR	(1)
 
@@ -2466,22 +2421,23 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
 		vport->info.link_state = MLX5_VPORT_ADMIN_STATE_DOWN;
 
-	err = mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_VPORT_UC_ADDR_CHANGE);
+	/* Uplink vport rep must load first. */
+	err = esw_offloads_load_rep(esw, MLX5_VPORT_UPLINK);
 	if (err)
-		goto err_vports;
+		goto err_uplink;
 
-	err = esw_offloads_load_all_reps(esw);
+	err = mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_VPORT_UC_ADDR_CHANGE);
 	if (err)
-		goto err_reps;
+		goto err_vports;
 
 	esw_offloads_devcom_init(esw);
 	mutex_init(&esw->offloads.termtbl_mutex);
 
 	return 0;
 
-err_reps:
-	mlx5_eswitch_disable_pf_vf_vports(esw);
 err_vports:
+	esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
+err_uplink:
 	esw_set_passing_vport_metadata(esw, false);
 err_vport_metadata:
 	esw_offloads_steering_cleanup(esw);
@@ -2512,8 +2468,8 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 void esw_offloads_disable(struct mlx5_eswitch *esw)
 {
 	esw_offloads_devcom_cleanup(esw);
-	esw_offloads_unload_all_reps(esw);
 	mlx5_eswitch_disable_pf_vf_vports(esw);
+	esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
 	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
 	mlx5_rdma_disable_roce(esw->dev);
@@ -2786,6 +2742,21 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 	return 0;
 }
 
+static bool
+mlx5_eswitch_vport_has_rep(const struct mlx5_eswitch *esw, u16 vport_num)
+{
+	/* Currently, only ECPF based device has representor for host PF. */
+	if (vport_num == MLX5_VPORT_PF &&
+	    !mlx5_core_is_ecpf_esw_manager(esw->dev))
+		return false;
+
+	if (vport_num == MLX5_VPORT_ECPF &&
+	    !mlx5_ecpf_vport_exists(esw->dev))
+		return false;
+
+	return true;
+}
+
 void mlx5_eswitch_register_vport_reps(struct mlx5_eswitch *esw,
 				      const struct mlx5_eswitch_rep_ops *ops,
 				      u8 rep_type)
@@ -2796,8 +2767,10 @@ void mlx5_eswitch_register_vport_reps(struct mlx5_eswitch *esw,
 
 	esw->offloads.rep_ops[rep_type] = ops;
 	mlx5_esw_for_all_reps(esw, i, rep) {
-		rep_data = &rep->rep_data[rep_type];
-		atomic_set(&rep_data->state, REP_REGISTERED);
+		if (likely(mlx5_eswitch_vport_has_rep(esw, i))) {
+			rep_data = &rep->rep_data[rep_type];
+			atomic_set(&rep_data->state, REP_REGISTERED);
+		}
 	}
 }
 EXPORT_SYMBOL(mlx5_eswitch_register_vport_reps);
-- 
2.24.1

