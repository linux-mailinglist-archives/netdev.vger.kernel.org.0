Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEED305191
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhA0EZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:25:34 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5004 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388671AbhAZXZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:25:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4b90000>; Tue, 26 Jan 2021 15:24:41 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:40 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/14] net/mlx5: Add support for devlink traps in mlx5 core driver
Date:   Tue, 26 Jan 2021 15:24:07 -0800
Message-ID: <20210126232419.175836-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126232419.175836-1-saeedm@nvidia.com>
References: <20210126232419.175836-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611703481; bh=+k6W+tEk03wYBNZdsbYCGPO24gzJEhHZiaVRNbHVGpk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=D5tcwqXgirn+yjJjUOWDvpoqsNievCJWiQVQExZl7nbzuzbdomO6qzyBSEkjmTTCz
         Zxb+hGTRbxm56pdq5+wMJHuWRBgpoUmcdW1uOnbuFnaOZmO8cIz/o1CcOLNLoVudPm
         cjRxFPTnmY73pBUf4cG1+DNZJPwtwC7HyC73Tx1Egg+cUEcxSfiidyGYWqNCBWd+7C
         uwaQAQd+OPROd3UluXLVxwqWk2Xbai3wcGM+PYIMIJ+YEd53h6SOBEOkclgw9Kzw3u
         Z905GL37/PkG1Ar8eJhbGELiYj6RKXvADNr9UBdxAYrzattMprKQ1j2z3UtPf4F8L+
         O3xJ28wjOc5oQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add devlink traps infra-structure to mlx5 core driver. Add traps list to
mlx5_priv and corresponding API:
 - mlx5_devlink_trap_report() to wrap trap reports to devlink
 - mlx5_devlink_trap_get_num_active() to decide whether to open/close trap
   resources.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 84 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h | 16 ++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  2 +
 include/linux/mlx5/driver.h                   |  1 +
 4 files changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index 3261d0dc1104..f04afaf785cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -168,6 +168,56 @@ static int mlx5_devlink_reload_up(struct devlink *devl=
ink, enum devlink_reload_a
 	return 0;
 }
=20
+static struct mlx5_devlink_trap *mlx5_find_trap_by_id(struct mlx5_core_dev=
 *dev, int trap_id)
+{
+	struct mlx5_devlink_trap *dl_trap;
+
+	list_for_each_entry(dl_trap, &dev->priv.traps, list)
+		if (dl_trap->trap.id =3D=3D trap_id)
+			return dl_trap;
+
+	return NULL;
+}
+
+static int mlx5_devlink_trap_init(struct devlink *devlink, const struct de=
vlink_trap *trap,
+				  void *trap_ctx)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	struct mlx5_devlink_trap *dl_trap;
+
+	dl_trap =3D kzalloc(sizeof(*dl_trap), GFP_KERNEL);
+	if (!dl_trap)
+		return -ENOMEM;
+
+	dl_trap->trap.id =3D trap->id;
+	dl_trap->trap.action =3D DEVLINK_TRAP_ACTION_DROP;
+	dl_trap->item =3D trap_ctx;
+
+	if (mlx5_find_trap_by_id(dev, trap->id)) {
+		kfree(dl_trap);
+		mlx5_core_err(dev, "Devlink trap: Trap 0x%x already found", trap->id);
+		return -EEXIST;
+	}
+
+	list_add_tail(&dl_trap->list, &dev->priv.traps);
+	return 0;
+}
+
+static void mlx5_devlink_trap_fini(struct devlink *devlink, const struct d=
evlink_trap *trap,
+				   void *trap_ctx)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	struct mlx5_devlink_trap *dl_trap;
+
+	dl_trap =3D mlx5_find_trap_by_id(dev, trap->id);
+	if (!dl_trap) {
+		mlx5_core_err(dev, "Devlink trap: Missing trap id 0x%x", trap->id);
+		return;
+	}
+	list_del(&dl_trap->list);
+	kfree(dl_trap);
+}
+
 static const struct devlink_ops mlx5_devlink_ops =3D {
 #ifdef CONFIG_MLX5_ESWITCH
 	.eswitch_mode_set =3D mlx5_devlink_eswitch_mode_set,
@@ -186,8 +236,42 @@ static const struct devlink_ops mlx5_devlink_ops =3D {
 	.reload_limits =3D BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
 	.reload_down =3D mlx5_devlink_reload_down,
 	.reload_up =3D mlx5_devlink_reload_up,
+	.trap_init =3D mlx5_devlink_trap_init,
+	.trap_fini =3D mlx5_devlink_trap_fini,
 };
=20
+void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, stru=
ct sk_buff *skb,
+			      struct devlink_port *dl_port)
+{
+	struct devlink *devlink =3D priv_to_devlink(dev);
+	struct mlx5_devlink_trap *dl_trap;
+
+	dl_trap =3D mlx5_find_trap_by_id(dev, trap_id);
+	if (!dl_trap) {
+		mlx5_core_err(dev, "Devlink trap: Report on invalid trap id 0x%x", trap_=
id);
+		return;
+	}
+
+	if (dl_trap->trap.action !=3D DEVLINK_TRAP_ACTION_TRAP) {
+		mlx5_core_dbg(dev, "Devlink trap: Trap id %d has action %d", trap_id,
+			      dl_trap->trap.action);
+		return;
+	}
+	devlink_trap_report(devlink, skb, dl_trap->item, dl_port, NULL);
+}
+
+int mlx5_devlink_trap_get_num_active(struct mlx5_core_dev *dev)
+{
+	struct mlx5_devlink_trap *dl_trap;
+	int count =3D 0;
+
+	list_for_each_entry(dl_trap, &dev->priv.traps, list)
+		if (dl_trap->trap.action =3D=3D DEVLINK_TRAP_ACTION_TRAP)
+			count++;
+
+	return count;
+}
+
 struct devlink *mlx5_devlink_alloc(void)
 {
 	return devlink_alloc(&mlx5_devlink_ops, sizeof(struct mlx5_core_dev));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.h
index f0de327a59be..a9829006fa78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -12,6 +12,22 @@ enum mlx5_devlink_param_id {
 	MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
 };
=20
+struct mlx5_trap_ctx {
+	int id;
+	int action;
+};
+
+struct mlx5_devlink_trap {
+	struct mlx5_trap_ctx trap;
+	void *item;
+	struct list_head list;
+};
+
+struct mlx5_core_dev;
+void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, stru=
ct sk_buff *skb,
+			      struct devlink_port *dl_port);
+int mlx5_devlink_trap_get_num_active(struct mlx5_core_dev *dev);
+
 struct devlink *mlx5_devlink_alloc(void);
 void mlx5_devlink_free(struct devlink *devlink);
 int mlx5_devlink_register(struct devlink *devlink, struct device *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index ca6f2fc39ea0..bfedf064db1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1305,6 +1305,8 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, =
int profile_idx)
=20
 	priv->dbg_root =3D debugfs_create_dir(dev_name(dev->device),
 					    mlx5_debugfs_root);
+	INIT_LIST_HEAD(&priv->traps);
+
 	err =3D mlx5_health_init(dev);
 	if (err)
 		goto err_health_init;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f93bfe7473aa..c4615dc51b6f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -564,6 +564,7 @@ struct mlx5_priv {
 	int			host_pf_pages;
=20
 	struct mlx5_core_health health;
+	struct list_head	traps;
=20
 	/* start: qp staff */
 	struct dentry	       *qp_debugfs;
--=20
2.29.2

