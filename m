Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC95A1938C8
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgCZGjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:39:16 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727830AbgCZGjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:39:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3oGuKibDX6DIADBF9cP5v13ohGejZamCdkGHzb8mS7YXGtiy3C188GiRm5BzwZovJJHsJi4swKjTQ0N4Muz5keHBrkFic7jW9gpVMDsH2mheo8Rk9H9PocUiLfaFW+hzj6mnf+DvfCCdAEQLJ2+A8Tf33FNM3yNi2/rRH5zc0S46SoV7E3WmA/JJ0L/DCKntxSG/Dx4zHoZT674VzAEL7TDRE+ujM3eEZCObq7QAviGpsUgplGYMNTgT45072hFdi2HjhYFlsxqxD8HXpqcpU18+gFbmdzkh41+Z7MqRrZx8T0EhIiLunY5RfuhaauuOiTlAquOR6aHJHyaxpW5yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhKFnpCFiONJPS6YC4i1C5/eZeHMGJliKhna+HHR3nU=;
 b=ICeB2y4fs+Bo2Ss+oHSF1PDyoPN29XvyijV6zsaC7MyfFpHj7ZKYr5nHscWXRJQHSp9M51Q0d9uyyo/+CxSZcAxJ/jW2HRFpmrng3KL7YNGHb2kIsTaAW7wdAr+6KQuvSkPKYyQd6pKZiiU8jRcODS26kCzrt32Yk/XRH9YJCIuJRDIhRMq6JfmHCfBw/T6pOkpAnxUVseEQppz3Vm21FNZnxsp1DH/xUL4D9GKiClBVBuuG5Ihva1mJkp9b58ZTUtCmVgP+rtalqdJ4S+qN+KxxlI4rNyYhZm+PkXV4e0EDv1Oj9G3Zq288WEIxJrdaEdd+WdiBFI6Z7tigjmkOzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhKFnpCFiONJPS6YC4i1C5/eZeHMGJliKhna+HHR3nU=;
 b=ENQG9MNc/Z0FVuAOaUQDut+dEg+BSr5cyGP7pB0tCr9VMeFcVRX3hCka9CKUIOpHXHPThuyZKMZkmzSky0JlsNaojlTQFtf3ADa1AVgQRd8JsCoEPdToldCpxxsN4/9xrcIM7zH0G2ZiywfZh80uhPWH5L0RVMQG3MAUqYR+VMo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:39:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:39:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 16/16] net/mlx5: E-switch, Protect eswitch mode changes
Date:   Wed, 25 Mar 2020 23:38:09 -0700
Message-Id: <20200326063809.139919-17-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:39:08 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ef922f64-8b86-42b0-da78-08d7d150649c
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6479CC8707B2AD6B25529620BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(30864003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qIKUHOsBHppfPhx1/ydv0YID4FYL+uRCRqDDxuLqFWVolYWjFVXmSP7kl9UyKJjb/9pXE/2UVNBbMux4bIlSE/ywViVxDmioTDCuUKuHod/gxBpTNZovnJqw0esCQ513dgeYlAbsAz86njdVCXTf2ckD8I13vfAL6u/4bvbB8I32hvHkb36KDFVwDrF47dGaSSfmw3//4J+4nmfadiXqra/A+++Kwbc04lLSTbhBgBmVxpcsdXeu9vgO/T5B22d/4B78HDf3+Ykrcuq7RHnFIVlPQAUhVA4SNk1g2NNgZNKHjXOpLuuELc96FbPMZU5utT1ZnNI+KLc0SfcytH3xH78nRvlEZ7kYwjQqYjke7rGqHVmi2oGBixRLuNkEBFiq/uR3AhGW8Fq2JMlqpqheiu1t8ESry4YR+dmgHk40+BpcOYFbfjnUSSlBGWWj50W18E6HsKrCW8Mw3IJTG+mt0rR/SMYAEDlJ8q2IgrakvGcvg8qDlwvfmeBjiYSsVFOD
X-MS-Exchange-AntiSpam-MessageData: 2FTLWE8lV5fRQtjm1kwE6RH9pwRi+7g9rGt+btsjxHFohDiK1tGl9iBga9CUJTpyMm0q/grJvJ0/OIpyRBibRqv5jiO9l3uGC0wyWmAdUuI1JRJpm6ipKW2L5PDL5Wtn2kP6hvvYOn9HBzT2/G60qQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef922f64-8b86-42b0-da78-08d7d150649c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:39:11.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eSJH1lRAs4P3C0wJGa/yzdKn8pN6p3PYTQnV/jeyN/xgt8EL5ZLqjDIu+3JPBrj5JdpOroGAEeb76EjEVXcZ3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Currently eswitch mode change is occurring from 2 different execution
contexts as below.
1. sriov sysfs enable/disable
2. devlink eswitch set commands

Both of them need to access eswitch related data structures in
synchronized manner.
Without any synchronization below race condition exist.

SR-IOV enable/disable with devlink eswitch mode change:

          cpu-0                         cpu-1
          -----                         -----
mlx5_device_disable_sriov()        mlx5_devlink_eswitch_mode_set()
  mlx5_eswitch_disable()             esw_offloads_stop()
    esw_offloads_disable()             mlx5_eswitch_disable()
                                         esw_offloads_disable()

Hence, they are synchronized using a new mode_lock.
eswitch's state_lock is not used as it can lead to a deadlock scenario
below and state_lock is only for vport and fdb exclusive access.

ip link set vf <param>
  netlink rcv_msg() - Lock A
    rtnl_lock
    vfinfo()
      esw->state_lock() - Lock B
devlink eswitch_set
   devlink_mutex
     esw->state_lock() - Lock B
       attach_netdev()
         register_netdev()
           rtnl_lock - Lock A

Alternatives considered:
1. Acquiring rtnl lock before taking esw->state_lock to follow similar
locking sequence as ip link flow during eswitch mode set.
rtnl lock is not good idea for two reasons.
(a) Holding rtnl lock for several hundred device commands is not good
    idea.
(b) It leads to below and more similar deadlocks.

devlink eswitch_set
   devlink_mutex
     rtnl_lock - Lock A
       esw->state_lock() - Lock B
         eswitch_disable()
           reload()
             ib_register_device()
               ib_cache_setup_one()
                 rtnl_lock()

2. Exporting devlink lock may lead to undesired use of it in vendor
driver(s) in future.

3. Unloading representors outside of the mode_lock requires
serialization with other process trying to enable the eswitch.

4. Differing the representors life cycle to a different workqueue
requires synchronization with func_change_handler workqueue.

Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  54 +++++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  11 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 105 ++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |   3 +-
 4 files changed, 123 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index a22f9c77e4c3..7f618a443bfd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2092,7 +2092,7 @@ mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, int num_vfs)
 }
 
 /**
- * mlx5_eswitch_enable - Enable eswitch
+ * mlx5_eswitch_enable_locked - Enable eswitch
  * @esw:	Pointer to eswitch
  * @mode:	Eswitch mode to enable
  * @num_vfs:	Enable eswitch for given number of VFs. This is optional.
@@ -2104,16 +2104,17 @@ mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, int num_vfs)
  *		eswitch. Caller should pass < 0 when num_vfs should be
  *		completely ignored. This is typically the case when eswitch
  *		is enabled without sriov regardless of PF/ECPF system.
- * mlx5_eswitch_enable() Enables eswitch in either legacy or offloads mode.
- * If num_vfs >=0 is provided, it setup VF related eswitch vports. It returns
- * 0 on success or error code on failure.
+ * mlx5_eswitch_enable_locked() Enables eswitch in either legacy or offloads
+ * mode. If num_vfs >=0 is provided, it setup VF related eswitch vports.
+ * It returns 0 on success or error code on failure.
  */
-int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode, int num_vfs)
+int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 {
 	int err;
 
-	if (!ESW_ALLOWED(esw) ||
-	    !MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ft_support)) {
+	lockdep_assert_held(&esw->mode_lock);
+
+	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ft_support)) {
 		esw_warn(esw->dev, "FDB is not supported, aborting ...\n");
 		return -EOPNOTSUPP;
 	}
@@ -2164,11 +2165,34 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode, int num_vfs)
 	return err;
 }
 
-void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
+/**
+ * mlx5_eswitch_enable - Enable eswitch
+ * @esw:	Pointer to eswitch
+ * @num_vfs:	Enable eswitch swich for given number of VFs.
+ *		Caller must pass num_vfs > 0 when enabling eswitch for
+ *		vf vports.
+ * mlx5_eswitch_enable() returns 0 on success or error code on failure.
+ */
+int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
+{
+	int ret;
+
+	if (!ESW_ALLOWED(esw))
+		return 0;
+
+	mutex_lock(&esw->mode_lock);
+	ret = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY, num_vfs);
+	mutex_unlock(&esw->mode_lock);
+	return ret;
+}
+
+void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 {
 	int old_mode;
 
-	if (!ESW_ALLOWED(esw) || esw->mode == MLX5_ESWITCH_NONE)
+	lockdep_assert_held_write(&esw->mode_lock);
+
+	if (esw->mode == MLX5_ESWITCH_NONE)
 		return;
 
 	esw_info(esw->dev, "Disable: mode(%s), nvfs(%d), active vports(%d)\n",
@@ -2197,6 +2221,16 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
 		mlx5_eswitch_clear_vf_vports_info(esw);
 }
 
+void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
+{
+	if (!ESW_ALLOWED(esw))
+		return;
+
+	mutex_lock(&esw->mode_lock);
+	mlx5_eswitch_disable_locked(esw, clear_vf);
+	mutex_unlock(&esw->mode_lock);
+}
+
 int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eswitch *esw;
@@ -2248,6 +2282,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	hash_init(esw->offloads.mod_hdr.hlist);
 	atomic64_set(&esw->offloads.num_flows, 0);
 	mutex_init(&esw->state_lock);
+	mutex_init(&esw->mode_lock);
 
 	mlx5_esw_for_all_vports(esw, i, vport) {
 		vport->vport = mlx5_eswitch_index_to_vport_num(esw, i);
@@ -2282,6 +2317,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
 	esw_offloads_cleanup_reps(esw);
+	mutex_destroy(&esw->mode_lock);
 	mutex_destroy(&esw->state_lock);
 	mutex_destroy(&esw->offloads.mod_hdr.lock);
 	mutex_destroy(&esw->offloads.encap_tbl_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 752d399bdffb..39f42f985fbd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -258,6 +258,11 @@ struct mlx5_eswitch {
 	 */
 	struct mutex            state_lock;
 
+	/* Protects eswitch mode change that occurs via one or more
+	 * user commands, i.e. sriov state change, devlink commands.
+	 */
+	struct mutex mode_lock;
+
 	struct {
 		bool            enabled;
 		u32             root_tsar_id;
@@ -298,7 +303,9 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev);
 void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw);
 
 #define MLX5_ESWITCH_IGNORE_NUM_VFS (-1)
-int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode, int num_vfs);
+int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs);
+int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs);
+void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf);
 void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf);
 int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
 			       u16 vport, u8 mac[ETH_ALEN]);
@@ -674,7 +681,7 @@ void mlx5_eswitch_unload_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs);
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
 static inline void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw) {}
-static inline int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode, int num_vfs) { return 0; }
+static inline int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs) { return 0; }
 static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf) {}
 static inline bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct mlx5_core_dev *dev1) { return true; }
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev) { return false; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 84a38f0739d0..612bc7d1cdcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1592,14 +1592,14 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 		return -EINVAL;
 	}
 
-	mlx5_eswitch_disable(esw, false);
-	err = mlx5_eswitch_enable(esw, MLX5_ESWITCH_OFFLOADS,
-				  esw->dev->priv.sriov.num_vfs);
+	mlx5_eswitch_disable_locked(esw, false);
+	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_OFFLOADS,
+					 esw->dev->priv.sriov.num_vfs);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed setting eswitch to offloads");
-		err1 = mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY,
-					   MLX5_ESWITCH_IGNORE_NUM_VFS);
+		err1 = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY,
+						  MLX5_ESWITCH_IGNORE_NUM_VFS);
 		if (err1) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Failed setting eswitch back to legacy");
@@ -2397,13 +2397,13 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 {
 	int err, err1;
 
-	mlx5_eswitch_disable(esw, false);
-	err = mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY,
-				  MLX5_ESWITCH_IGNORE_NUM_VFS);
+	mlx5_eswitch_disable_locked(esw, false);
+	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY,
+					 MLX5_ESWITCH_IGNORE_NUM_VFS);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
-		err1 = mlx5_eswitch_enable(esw, MLX5_ESWITCH_OFFLOADS,
-					   MLX5_ESWITCH_IGNORE_NUM_VFS);
+		err1 = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_OFFLOADS,
+						  MLX5_ESWITCH_IGNORE_NUM_VFS);
 		if (err1) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Failed setting eswitch back to offloads");
@@ -2525,6 +2525,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 				  struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	u16 cur_mlx5_mode, mlx5_mode = 0;
 	int err;
 
@@ -2532,40 +2533,50 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (err)
 		return err;
 
-	err = eswitch_devlink_esw_mode_check(dev->priv.eswitch);
-	if (err)
-		return err;
-
-	cur_mlx5_mode = dev->priv.eswitch->mode;
-
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
+	mutex_lock(&esw->mode_lock);
+	err = eswitch_devlink_esw_mode_check(esw);
+	if (err)
+		goto unlock;
+
+	cur_mlx5_mode = esw->mode;
+
 	if (cur_mlx5_mode == mlx5_mode)
-		return 0;
+		goto unlock;
 
 	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
-		return esw_offloads_start(dev->priv.eswitch, extack);
+		err = esw_offloads_start(esw, extack);
 	else if (mode == DEVLINK_ESWITCH_MODE_LEGACY)
-		return esw_offloads_stop(dev->priv.eswitch, extack);
+		err = esw_offloads_stop(esw, extack);
 	else
-		return -EINVAL;
+		err = -EINVAL;
+
+unlock:
+	mutex_unlock(&esw->mode_lock);
+	return err;
 }
 
 int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	int err;
 
 	err = mlx5_eswitch_check(dev);
 	if (err)
 		return err;
 
+	mutex_lock(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(dev->priv.eswitch);
 	if (err)
-		return err;
+		goto unlock;
 
-	return esw_mode_to_devlink(dev->priv.eswitch->mode, mode);
+	err = esw_mode_to_devlink(esw->mode, mode);
+unlock:
+	mutex_unlock(&esw->mode_lock);
+	return err;
 }
 
 int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
@@ -2580,18 +2591,20 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	if (err)
 		return err;
 
+	mutex_lock(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
-		return err;
+		goto out;
 
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
 		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
-			return 0;
+			goto out;
 		/* fall through */
 	case MLX5_CAP_INLINE_MODE_L2:
 		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto out;
 	case MLX5_CAP_INLINE_MODE_VPORT_CONTEXT:
 		break;
 	}
@@ -2599,7 +2612,8 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	if (atomic64_read(&esw->offloads.num_flows) > 0) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can't set inline mode when flows are configured");
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto out;
 	}
 
 	err = esw_inline_mode_from_devlink(mode, &mlx5_mode);
@@ -2616,6 +2630,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	}
 
 	esw->offloads.inline_mode = mlx5_mode;
+	mutex_unlock(&esw->mode_lock);
 	return 0;
 
 revert_inline_mode:
@@ -2625,6 +2640,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 						 vport,
 						 esw->offloads.inline_mode);
 out:
+	mutex_unlock(&esw->mode_lock);
 	return err;
 }
 
@@ -2638,11 +2654,15 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	if (err)
 		return err;
 
+	mutex_lock(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
-		return err;
+		goto unlock;
 
-	return esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
+	err = esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
+unlock:
+	mutex_unlock(&esw->mode_lock);
+	return err;
 }
 
 int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
@@ -2657,30 +2677,36 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	if (err)
 		return err;
 
+	mutex_lock(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
-		return err;
+		goto unlock;
 
 	if (encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE &&
 	    (!MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) ||
-	     !MLX5_CAP_ESW_FLOWTABLE_FDB(dev, decap)))
-		return -EOPNOTSUPP;
+	     !MLX5_CAP_ESW_FLOWTABLE_FDB(dev, decap))) {
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
 
-	if (encap && encap != DEVLINK_ESWITCH_ENCAP_MODE_BASIC)
-		return -EOPNOTSUPP;
+	if (encap && encap != DEVLINK_ESWITCH_ENCAP_MODE_BASIC) {
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
 
 	if (esw->mode == MLX5_ESWITCH_LEGACY) {
 		esw->offloads.encap = encap;
-		return 0;
+		goto unlock;
 	}
 
 	if (esw->offloads.encap == encap)
-		return 0;
+		goto unlock;
 
 	if (atomic64_read(&esw->offloads.num_flows) > 0) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can't set encapsulation when flows are configured");
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto unlock;
 	}
 
 	esw_destroy_offloads_fdb_tables(esw);
@@ -2696,6 +2722,8 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 		(void)esw_create_offloads_fdb_tables(esw, esw->nvports);
 	}
 
+unlock:
+	mutex_unlock(&esw->mode_lock);
 	return err;
 }
 
@@ -2710,11 +2738,14 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 	if (err)
 		return err;
 
+	mutex_lock(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
-		return err;
+		goto unlock;
 
 	*encap = esw->offloads.encap;
+unlock:
+	mutex_unlock(&esw->mode_lock);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 10a64b91d04c..3094d20297a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -77,8 +77,7 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 	if (!MLX5_ESWITCH_MANAGER(dev))
 		goto enable_vfs_hca;
 
-	err = mlx5_eswitch_enable(dev->priv.eswitch, MLX5_ESWITCH_LEGACY,
-				  num_vfs);
+	err = mlx5_eswitch_enable(dev->priv.eswitch, num_vfs);
 	if (err) {
 		mlx5_core_warn(dev,
 			       "failed to enable eswitch SRIOV (%d)\n", err);
-- 
2.25.1

