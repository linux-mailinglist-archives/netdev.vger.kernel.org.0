Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF191938C7
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgCZGjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:39:14 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727821AbgCZGjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:39:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdhJopqwLk9mh/MxoGF8LDTz5cvRKTj7keOshC+iGr7iniFzG9/+WambNJ4lvubUq8Pp31arcuO94r2l2lekQ0vEQB6i/0GrmbBK8FJDzg7jfNT4hZco/ywEjlWaCFhT0Bfvr4Ycpzv7fbTuQnbO6iUFUUjoKLTRWlNPq6xp6JqPzA2pbWIxuXEY6GpESLzHfsNQMkZVjtZtMBuvw+sEcuBme9bkYvdLKNcjIEEbMqcw6Fw0C8M3SU6zJiEuOa3R0iS+XDEab03FUrJfaHQoSWc2nnLkzHB2JXGbUbHJUWr1e1PSGPMCoRtlgmmrK5fsM2Q/NeQUoS1ILkT7bLekyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxyUbW3jxKxSkbE6uMwshA3WZWks0ek9yiJ+UM2273I=;
 b=FRkaxU40VS6hGffpNrmsTOPdWRxlq1reSFKNATWS8Rf+SD2N3TGIUBZ6sPckpRCKkXRCYxCORtODaUf45/bfO/dCPzqbP9TkwcTrACNCvLSjSGAuDoAJSZ6gNpkYwcHEPMBcPqXuhz63COfQbri4o8gNpkbXLtRx9LW/5Jjtq74HsM3Nhsx+PwHc/hQEIQ25aExCG4HGC1F7EIPSpPXO597iQXqL57Me1RlPpjpjXKe/FKYZa3l3DuR8ELF2+cDaJcx1qEF/pc9P8/jPXt78KPLtvKDlEc/vqqA5c07O2nSuZUrKnqEflWJDyILR4jK+OWDBWE6h/mRX1EKKP2GHdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxyUbW3jxKxSkbE6uMwshA3WZWks0ek9yiJ+UM2273I=;
 b=VuOLYQb9sRnI8zg2NRn9CiWb7MKKx2tgJqPA6bl+9Rq56pmhNwyG/lNudwLzGZtgAHzGEJCLxUXA/cUgHr/ouHkrQ4hl8kUXWcTBmFaVjd6XanaKz/xCTIldiH2ITrdl6cr0Nb088lc7Sidiqfa0cSLYXC0U4gOelIW6HCIjrRc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:39:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:39:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/16] net/mlx5: E-switch, Extend eswitch enable to handle num_vfs change
Date:   Wed, 25 Mar 2020 23:38:08 -0700
Message-Id: <20200326063809.139919-16-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:39:05 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 53d18923-6f5e-411e-ce56-08d7d15062d3
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6479EBDFF3A87F67765A6DDBBECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4yLm9Z9BhdINXKHGNiVkUK8vsvQlQDWHZnEc19cqT8G8nrnoHsdLnfZYiV15iBH4dtGu+nRJgzsVbQ38yLOlwsU+iwR3F50hQqgwNYpBWRyC8Fjmh/5g0ZIj0JpMGbPeBoe/mz73tSeYhFAics3HzqtTyFaXl6ztkFqOqXzKssEjSbh2jw4B1po3m6QKoXazE6ILpMmUXkKmQkGh/4xR0ncYj7b8CnJVYXXuMizTEWXg6wxppqN9Cz6OSKQyk5K9lSKzz/vsk4mmMq/j7V2VvQuevb+NrBNHJbxWqS3EZPfjgm9aaiRCUv00+ZLzyBMk6EK20pjlGhpBQ/wg6npOaQENwimYTauEkw7/w73UlVQtAeXwU3Yh8ojMi8/9Klc0uLa7a8xXskdhj8c/1Pdowhl/tZ7Jsy9nQ2gt7JsPEdZYDKrTh/IAWFvtkKnIW5O1G9x8KU8zVn3+FmgkfK4wv5c1wE+994RfTL5MPBNl0pxUbqUL5/K51dTReJK5KTR
X-MS-Exchange-AntiSpam-MessageData: G/hbIsHHPDhY0AnSnnlDbgEIY4RGnoNbOl9i6JOcvJHYoIL92DWRL787OyBTSePa19WGATIeNZgw6ibABbFioy0JgmY3skKK8oaEWnfPrcuxF8x2onN8N8NQFo1DJZx6NKss5iejuKx0ImaSZ4QmUQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53d18923-6f5e-411e-ce56-08d7d15062d3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:39:08.5339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pE2V4rIUJwokGmPdeJsGa73upxgrEKQPsjq02t4zzCQ/uf3XxWEddiLGdgrQkgyc28Fo5/JYG2pt3LPT4rY+uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Subsequent patch protects eswitch mode changes across sriov and devlink
interfaces. It is desirable for eswitch to provide thread safe eswitch
enable and disable APIs.
Hence, extend eswitch enable API to optionally update num_vfs when
requested.

In subsequent patch, eswitch num_vfs are updated after all the eswitch
users eswitch drops its reference count.

Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 63 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 10 ++-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 13 ++--
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  4 +-
 4 files changed, 58 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 8fc351240f4c..a22f9c77e4c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2067,7 +2067,48 @@ static void mlx5_eswitch_get_devlink_param(struct mlx5_eswitch *esw)
 	}
 }
 
-int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode)
+static void
+mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, int num_vfs)
+{
+	const u32 *out;
+
+	WARN_ON_ONCE(esw->mode != MLX5_ESWITCH_NONE);
+
+	if (num_vfs < 0)
+		return;
+
+	if (!mlx5_core_is_ecpf_esw_manager(esw->dev)) {
+		esw->esw_funcs.num_vfs = num_vfs;
+		return;
+	}
+
+	out = mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(out))
+		return;
+
+	esw->esw_funcs.num_vfs = MLX5_GET(query_esw_functions_out, out,
+					  host_params_context.host_num_of_vfs);
+	kvfree(out);
+}
+
+/**
+ * mlx5_eswitch_enable - Enable eswitch
+ * @esw:	Pointer to eswitch
+ * @mode:	Eswitch mode to enable
+ * @num_vfs:	Enable eswitch for given number of VFs. This is optional.
+ *		Valid value are 0, > 0 and MLX5_ESWITCH_IGNORE_NUM_VFS.
+ *		Caller should pass num_vfs > 0 when enabling eswitch for
+ *		vf vports. Caller should pass num_vfs = 0, when eswitch
+ *		is enabled without sriov VFs or when caller
+ *		is unaware of the sriov state of the host PF on ECPF based
+ *		eswitch. Caller should pass < 0 when num_vfs should be
+ *		completely ignored. This is typically the case when eswitch
+ *		is enabled without sriov regardless of PF/ECPF system.
+ * mlx5_eswitch_enable() Enables eswitch in either legacy or offloads mode.
+ * If num_vfs >=0 is provided, it setup VF related eswitch vports. It returns
+ * 0 on success or error code on failure.
+ */
+int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode, int num_vfs)
 {
 	int err;
 
@@ -2085,6 +2126,8 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode)
 
 	mlx5_eswitch_get_devlink_param(esw);
 
+	mlx5_eswitch_update_num_of_vfs(esw, num_vfs);
+
 	esw_create_tsar(esw);
 
 	esw->mode = mode;
@@ -2811,22 +2854,4 @@ bool mlx5_esw_multipath_prereq(struct mlx5_core_dev *dev0,
 		dev1->priv.eswitch->mode == MLX5_ESWITCH_OFFLOADS);
 }
 
-void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int num_vfs)
-{
-	const u32 *out;
-
-	WARN_ON_ONCE(esw->mode != MLX5_ESWITCH_NONE);
-
-	if (!mlx5_core_is_ecpf_esw_manager(esw->dev)) {
-		esw->esw_funcs.num_vfs = num_vfs;
-		return;
-	}
-
-	out = mlx5_esw_query_functions(esw->dev);
-	if (IS_ERR(out))
-		return;
 
-	esw->esw_funcs.num_vfs = MLX5_GET(query_esw_functions_out, out,
-					  host_params_context.host_num_of_vfs);
-	kvfree(out);
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 95532b258c2b..752d399bdffb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -296,7 +296,9 @@ int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
 /* E-Switch API */
 int mlx5_eswitch_init(struct mlx5_core_dev *dev);
 void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw);
-int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode);
+
+#define MLX5_ESWITCH_IGNORE_NUM_VFS (-1)
+int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode, int num_vfs);
 void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf);
 int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
 			       u16 vport, u8 mac[ETH_ALEN]);
@@ -635,7 +637,6 @@ mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num);
 
 bool mlx5_eswitch_is_vf_vport(const struct mlx5_eswitch *esw, u16 vport_num);
 
-void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int num_vfs);
 int mlx5_esw_funcs_changed_handler(struct notifier_block *nb, unsigned long type, void *data);
 
 int
@@ -673,7 +674,7 @@ void mlx5_eswitch_unload_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs);
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
 static inline void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw) {}
-static inline int  mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode) { return 0; }
+static inline int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode, int num_vfs) { return 0; }
 static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf) {}
 static inline bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct mlx5_core_dev *dev1) { return true; }
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev) { return false; }
@@ -682,14 +683,11 @@ static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-static inline void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int num_vfs) {}
-
 static inline struct mlx5_flow_handle *
 esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
-
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif /* __MLX5_ESWITCH_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 53fcb00ddbac..84a38f0739d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1593,12 +1593,13 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 	}
 
 	mlx5_eswitch_disable(esw, false);
-	mlx5_eswitch_update_num_of_vfs(esw, esw->dev->priv.sriov.num_vfs);
-	err = mlx5_eswitch_enable(esw, MLX5_ESWITCH_OFFLOADS);
+	err = mlx5_eswitch_enable(esw, MLX5_ESWITCH_OFFLOADS,
+				  esw->dev->priv.sriov.num_vfs);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed setting eswitch to offloads");
-		err1 = mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY);
+		err1 = mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY,
+					   MLX5_ESWITCH_IGNORE_NUM_VFS);
 		if (err1) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Failed setting eswitch back to legacy");
@@ -2397,10 +2398,12 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 	int err, err1;
 
 	mlx5_eswitch_disable(esw, false);
-	err = mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY);
+	err = mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY,
+				  MLX5_ESWITCH_IGNORE_NUM_VFS);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
-		err1 = mlx5_eswitch_enable(esw, MLX5_ESWITCH_OFFLOADS);
+		err1 = mlx5_eswitch_enable(esw, MLX5_ESWITCH_OFFLOADS,
+					   MLX5_ESWITCH_IGNORE_NUM_VFS);
 		if (err1) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Failed setting eswitch back to offloads");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 03f037811f1d..10a64b91d04c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -77,8 +77,8 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 	if (!MLX5_ESWITCH_MANAGER(dev))
 		goto enable_vfs_hca;
 
-	mlx5_eswitch_update_num_of_vfs(dev->priv.eswitch, num_vfs);
-	err = mlx5_eswitch_enable(dev->priv.eswitch, MLX5_ESWITCH_LEGACY);
+	err = mlx5_eswitch_enable(dev->priv.eswitch, MLX5_ESWITCH_LEGACY,
+				  num_vfs);
 	if (err) {
 		mlx5_core_warn(dev,
 			       "failed to enable eswitch SRIOV (%d)\n", err);
-- 
2.25.1

