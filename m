Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0521853C2
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgCNBRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:17:07 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:31971
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727805AbgCNBRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:17:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCAYx4iaruILZjz1wYNxEISWI3pr4SOKa4y9b8DRY6QVgbrz2uD+MkSv3/tpyG8Tn4kfo/azREx45z5pzFC8WwXAMW3Hmm43VMztnoTUnv87gon9UvIacs9Peg/hd/+vKD+MfbuLRyu24sA+OKwBWHUWZqM3OkcYMys8Fl/8u7KvR1S2yJzf1qtRjmAWj0e8R1ShIXdRlorj5RWWo93Mpqfibo5hQ2yHgVdWOe/YYCtFXzmHq57jeisih1st1BjtTp6PN9r5Y9oUbWBq6ghBzivZ9vn71FB1j/R2CygG8aRQK7MvVyHfWq5M1zL6TsvLxHAb+ll61Ob0arh8CnEYkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+X+WGFI09GGN5nmg7DNq/bHFg7AVgPhgz3BCunka7Y=;
 b=deBq7h5TVisRFN+ScrborrEz6EKB40kyThIEyYgQTfh9hwW+eXsn2okhMB4LHQNtKieST/GVLDc6lo0tiaTTh0B8Yeq1qHYM87auzsFnfPkpoo7oNXV9xBci6+LEeT3mn8pRFXwpXtplJdBKAx6IUG6B6/XKcSGJCTH3B0eJ8vT13EbyRXhHeG5z07CmjyPF4LPJ0RdFwaWAOUGxa7jxnJbGojNsQ0jFLQOP6zl5FJwGRuwva5+jh5iaMkWB58Ik0iwL1Do9XUwBvPQ81iEA6m8KNXPCKHpa2Mhb0Wu/4yXDC1QXybUSkqyZHtRLSJlLK9VzUEGaDDipMuQ0eiSGdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+X+WGFI09GGN5nmg7DNq/bHFg7AVgPhgz3BCunka7Y=;
 b=i5YwV98A47CsH8W6cGZhnINWUaJTzAD+LReE8okyiamJdQoktClfcUX+7pTW30Yq+PKZJrwhyOO8DSdGp6/gFQQhVCVKUlTblBZbCaqNnoqgjfwkDh6cYXdSiyegIUJ88/cf5rByCd48o+2N3FEAkxPCPIjy5R0oC8XQ/bbdt0s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:16:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:16:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/14] net/mlx5: E-Switch, Update VF vports config when num of VFs changed
Date:   Fri, 13 Mar 2020 18:16:15 -0700
Message-Id: <20200314011622.64939-8-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:16:56 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed716e60-c8e6-483b-2b4e-08d7c7b5648c
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6845F417F06938434C77A48ABEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(15650500001)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPWFxG5Qor6jspOUR1BllMG4CNzcYZc9YVkeoxKaRCZ8GOlhYi+AIYCnra/hmTAjNJZzdz7VdZm36j39WzHobEK4ad3TqKBdP0U93NqWrBbybvmkH2mW5cVi6xDm1Ja9nxuUioIkDVbFXbLaoneN6k4wadNC+lvJDj87qQVMjUSpVsKccijoQjrz7sNewa2doRkZsWJ9MbrF5yP3NsjJDfmfhgGmydVeaTwWXSR/NuK7x36npgBJqVycl27Xk0BfjIaFCqor103u5AtQUHGt5Y1+S5tmmclumlbolOx/hTmN7PLgod0ycamhBejQx2hgIDXFGpKyau65ATw5QJXB/om0hlb3TVsmP4uHLUPxqZIlSbPEa9ZDaZiQb+hElgwtVWlqPVQAEB7J5QUk9iYg4eBsWeg/8atSQW8AIHoAYT54DuBTRXSqj1DWiR9A3BjiBDrruGW292E0J2tHzqzPG/2fgu8SfH9tSERR53WW/p9JqLPmsudNna04RqI0/apDAr/pyqYcjkJPBUJGv5FbIsLnjOdbEhtewO3ZOuhLgts=
X-MS-Exchange-AntiSpam-MessageData: P8uY9ZZdA/HHNdSE3DlYhy3tnaXER+CqnaVzimtlS9N5s30xp5lPVyFw60baloHHpwoW8M8ae1yId/vjeSsEztsWqgwYXbffh8dwbdERoOBZywl84UKqRIccdxJGgKeMotVOWAoBUu+/px3PTtqbow==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed716e60-c8e6-483b-2b4e-08d7c7b5648c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:16:58.9678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BS34K9Eh7trQDaGHIMSfcLgUnpPJU/ECGFnJhPRWxJ19C5RNOenTVF4zznkSj0PaC9bZIGk1A2fHLSgvGkPMbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

Currently, ECPF eswitch manager does one-time only configuration for
VF vports when device switches to offloads mode. However, when num of
VFs changed from host side, driver doesn't update VF vports
configurations.

Hence, perform VFs vport configuration update whenever num_vfs change
event occurs.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 53 ++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  8 +++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 67 +------------------
 3 files changed, 46 insertions(+), 82 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 2f556c820230..1de2472a72e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1953,8 +1953,8 @@ static void mlx5_eswitch_clear_vf_vports_info(struct mlx5_eswitch *esw)
 /* Public E-Switch API */
 #define ESW_ALLOWED(esw) ((esw) && MLX5_ESWITCH_MANAGER((esw)->dev))
 
-static int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
-				   enum mlx5_eswitch_vport_event enabled_events)
+int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
+			    enum mlx5_eswitch_vport_event enabled_events)
 {
 	int err;
 
@@ -1973,12 +1973,39 @@ static int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 	return err;
 }
 
-static void mlx5_eswitch_unload_vport(struct mlx5_eswitch *esw, u16 vport_num)
+void mlx5_eswitch_unload_vport(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	esw_offloads_unload_rep(esw, vport_num);
 	esw_disable_vport(esw, vport_num);
 }
 
+void mlx5_eswitch_unload_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs)
+{
+	int i;
+
+	mlx5_esw_for_each_vf_vport_num_reverse(esw, i, num_vfs)
+		mlx5_eswitch_unload_vport(esw, i);
+}
+
+int mlx5_eswitch_load_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs,
+				enum mlx5_eswitch_vport_event enabled_events)
+{
+	int err;
+	int i;
+
+	mlx5_esw_for_each_vf_vport_num(esw, i, num_vfs) {
+		err = mlx5_eswitch_load_vport(esw, i, enabled_events);
+		if (err)
+			goto vf_err;
+	}
+
+	return 0;
+
+vf_err:
+	mlx5_eswitch_unload_vf_vports(esw, i - 1);
+	return err;
+}
+
 /* mlx5_eswitch_enable_pf_vf_vports() enables vports of PF, ECPF and VFs
  * whichever are present on the eswitch.
  */
@@ -1986,9 +2013,7 @@ int
 mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 				 enum mlx5_eswitch_vport_event enabled_events)
 {
-	int num_vfs;
 	int ret;
-	int i;
 
 	/* Enable PF vport */
 	ret = mlx5_eswitch_load_vport(esw, MLX5_VPORT_PF, enabled_events);
@@ -2003,18 +2028,13 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 	}
 
 	/* Enable VF vports */
-	mlx5_esw_for_each_vf_vport_num(esw, i, esw->esw_funcs.num_vfs) {
-		ret = mlx5_eswitch_load_vport(esw, i, enabled_events);
-		if (ret)
-			goto vf_err;
-	}
+	ret = mlx5_eswitch_load_vf_vports(esw, esw->esw_funcs.num_vfs,
+					  enabled_events);
+	if (ret)
+		goto vf_err;
 	return 0;
 
 vf_err:
-	num_vfs = i - 1;
-	mlx5_esw_for_each_vf_vport_num_reverse(esw, i, num_vfs)
-		mlx5_eswitch_unload_vport(esw, i);
-
 	if (mlx5_ecpf_vport_exists(esw->dev))
 		mlx5_eswitch_unload_vport(esw, MLX5_VPORT_ECPF);
 
@@ -2028,10 +2048,7 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
  */
 void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw)
 {
-	int i;
-
-	mlx5_esw_for_each_vf_vport_num_reverse(esw, i, esw->esw_funcs.num_vfs)
-		mlx5_eswitch_unload_vport(esw, i);
+	mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
 
 	if (mlx5_ecpf_vport_exists(esw->dev))
 		mlx5_eswitch_unload_vport(esw, MLX5_VPORT_ECPF);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 1213a69cf397..91b2aedcf52b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -654,6 +654,14 @@ esw_get_max_restore_tag(struct mlx5_eswitch *esw);
 int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num);
 void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num);
 
+int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
+			    enum mlx5_eswitch_vport_event enabled_events);
+void mlx5_eswitch_unload_vport(struct mlx5_eswitch *esw, u16 vport_num);
+
+int mlx5_eswitch_load_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs,
+				enum mlx5_eswitch_vport_event enabled_events);
+void mlx5_eswitch_unload_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 865c120f577e..badae90206ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1662,14 +1662,6 @@ static void __unload_reps_vf_vport(struct mlx5_eswitch *esw, int nvports,
 		__esw_offloads_unload_rep(esw, rep, rep_type);
 }
 
-static void esw_offloads_unload_vf_reps(struct mlx5_eswitch *esw, int nvports)
-{
-	u8 rep_type = NUM_REP_TYPES;
-
-	while (rep_type-- > 0)
-		__unload_reps_vf_vport(esw, nvports, rep_type);
-}
-
 static void __unload_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
 {
 	__unload_reps_vf_vport(esw, esw->esw_funcs.num_vfs, rep_type);
@@ -1678,60 +1670,6 @@ static void __unload_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
 	__unload_reps_special_vport(esw, rep_type);
 }
 
-static int __esw_offloads_load_rep(struct mlx5_eswitch *esw,
-				   struct mlx5_eswitch_rep *rep, u8 rep_type)
-{
-	int err = 0;
-
-	if (atomic_cmpxchg(&rep->rep_data[rep_type].state,
-			   REP_REGISTERED, REP_LOADED) == REP_REGISTERED) {
-		err = esw->offloads.rep_ops[rep_type]->load(esw->dev, rep);
-		if (err)
-			atomic_set(&rep->rep_data[rep_type].state,
-				   REP_REGISTERED);
-	}
-
-	return err;
-}
-
-static int __load_reps_vf_vport(struct mlx5_eswitch *esw, int nvports,
-				u8 rep_type)
-{
-	struct mlx5_eswitch_rep *rep;
-	int err, i;
-
-	mlx5_esw_for_each_vf_rep(esw, i, rep, nvports) {
-		err = __esw_offloads_load_rep(esw, rep, rep_type);
-		if (err)
-			goto err_vf;
-	}
-
-	return 0;
-
-err_vf:
-	__unload_reps_vf_vport(esw, --i, rep_type);
-	return err;
-}
-
-static int esw_offloads_load_vf_reps(struct mlx5_eswitch *esw, int nvports)
-{
-	u8 rep_type = 0;
-	int err;
-
-	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++) {
-		err = __load_reps_vf_vport(esw, nvports, rep_type);
-		if (err)
-			goto err_reps;
-	}
-
-	return err;
-
-err_reps:
-	while (rep_type-- > 0)
-		__unload_reps_vf_vport(esw, nvports, rep_type);
-	return err;
-}
-
 int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_eswitch_rep *rep;
@@ -2346,11 +2284,12 @@ esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
 
 	/* Number of VFs can only change from "0 to x" or "x to 0". */
 	if (esw->esw_funcs.num_vfs > 0) {
-		esw_offloads_unload_vf_reps(esw, esw->esw_funcs.num_vfs);
+		mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
 	} else {
 		int err;
 
-		err = esw_offloads_load_vf_reps(esw, new_num_vfs);
+		err = mlx5_eswitch_load_vf_vports(esw, new_num_vfs,
+						  MLX5_VPORT_UC_ADDR_CHANGE);
 		if (err)
 			return;
 	}
-- 
2.24.1

