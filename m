Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93053050CB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbhA0E11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:27:27 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8211 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388684AbhAZXZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:25:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4bc0000>; Tue, 26 Jan 2021 15:24:44 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:43 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/14] net/mlx5: Notify on trap action by blocking event
Date:   Tue, 26 Jan 2021 15:24:11 -0800
Message-ID: <20210126232419.175836-7-saeedm@nvidia.com>
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
        t=1611703484; bh=h4v3iSI0MYdiARVDyoQQnZOBy2wr3CSamLRzTTYsHe4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=m46mq2J0dbq/lJcTwoXJYJx/OIWgcOs/P+KUT76+OpABhAaFaZ+Nwqj7zYyRfp1mO
         KK34oWnTSkRJ9pFKRjeSaheKq5nwUZT9uP2862hnFkjBDZ+hJAqQ6mcP3gOnWmg0Gx
         aN1YNCs7NmjrLUKZBTd1letAPkFH939mrqykICIDkfNWYmaUiva9Zb5qkYHTs2ycuB
         fz0m/vHITFXdJTv7gtbJZ1aDqDom3a5oP2gguRl+VrkX2i5OhDmK6eLQHeAIlRrzKm
         x5Uqp7ldZ8BOvkU7CFg40GFRGG44SX74McmZU4NNE6RBSGkhqc3P2CCIqRI12eo2ig
         uAjvqPiZpNJdA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

In order to allow mlx5 core driver to trigger synchronous operations to
its consumers, add a blocking events handler. Add wrappers to
blocking_notifier_[call_chain/chain_register/chain_unregister]. Add trap
callback for action set and notify about this change. Following patches
in the set add a listener for this event.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 36 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/events.c  | 28 +++++++++++++++
 include/linux/mlx5/device.h                   |  4 +++
 include/linux/mlx5/driver.h                   | 15 ++++++++
 4 files changed, 83 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index f081eff9be25..c47291467cb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -218,6 +218,41 @@ static void mlx5_devlink_trap_fini(struct devlink *dev=
link, const struct devlink
 	kfree(dl_trap);
 }
=20
+static int mlx5_devlink_trap_action_set(struct devlink *devlink,
+					const struct devlink_trap *trap,
+					enum devlink_trap_action action,
+					struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	enum devlink_trap_action action_orig;
+	struct mlx5_devlink_trap *dl_trap;
+	int err =3D 0;
+
+	dl_trap =3D mlx5_find_trap_by_id(dev, trap->id);
+	if (!dl_trap) {
+		mlx5_core_err(dev, "Devlink trap: Set action on invalid trap id 0x%x", t=
rap->id);
+		err =3D -EINVAL;
+		goto out;
+	}
+
+	if (action !=3D DEVLINK_TRAP_ACTION_DROP && action !=3D DEVLINK_TRAP_ACTI=
ON_TRAP) {
+		err =3D -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (action =3D=3D dl_trap->trap.action)
+		goto out;
+
+	action_orig =3D dl_trap->trap.action;
+	dl_trap->trap.action =3D action;
+	err =3D mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_TYPE_TRA=
P,
+						&dl_trap->trap);
+	if (err)
+		dl_trap->trap.action =3D action_orig;
+out:
+	return err;
+}
+
 static const struct devlink_ops mlx5_devlink_ops =3D {
 #ifdef CONFIG_MLX5_ESWITCH
 	.eswitch_mode_set =3D mlx5_devlink_eswitch_mode_set,
@@ -238,6 +273,7 @@ static const struct devlink_ops mlx5_devlink_ops =3D {
 	.reload_up =3D mlx5_devlink_reload_up,
 	.trap_init =3D mlx5_devlink_trap_init,
 	.trap_fini =3D mlx5_devlink_trap_fini,
+	.trap_action_set =3D mlx5_devlink_trap_action_set,
 };
=20
 void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, stru=
ct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net=
/ethernet/mellanox/mlx5/core/events.c
index 054c0bc36d24..670f25f5ffd1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -61,6 +61,8 @@ struct mlx5_events {
 	struct mlx5_pme_stats pme_stats;
 	/*pcie_core*/
 	struct work_struct pcie_core_work;
+	/* driver notifier chain for sw events */
+	struct blocking_notifier_head sw_nh;
 };
=20
 static const char *eqe_type_str(u8 type)
@@ -351,6 +353,7 @@ int mlx5_events_init(struct mlx5_core_dev *dev)
 		return -ENOMEM;
 	}
 	INIT_WORK(&events->pcie_core_work, mlx5_pcie_event);
+	BLOCKING_INIT_NOTIFIER_HEAD(&events->sw_nh);
=20
 	return 0;
 }
@@ -406,3 +409,28 @@ int mlx5_notifier_call_chain(struct mlx5_events *event=
s, unsigned int event, voi
 {
 	return atomic_notifier_call_chain(&events->fw_nh, event, data);
 }
+
+/* This API is used only for processing and forwarding driver-specific
+ * events to mlx5 consumers.
+ */
+int mlx5_blocking_notifier_register(struct mlx5_core_dev *dev, struct noti=
fier_block *nb)
+{
+	struct mlx5_events *events =3D dev->priv.events;
+
+	return blocking_notifier_chain_register(&events->sw_nh, nb);
+}
+
+int mlx5_blocking_notifier_unregister(struct mlx5_core_dev *dev, struct no=
tifier_block *nb)
+{
+	struct mlx5_events *events =3D dev->priv.events;
+
+	return blocking_notifier_chain_unregister(&events->sw_nh, nb);
+}
+
+int mlx5_blocking_notifier_call_chain(struct mlx5_core_dev *dev, unsigned =
int event,
+				      void *data)
+{
+	struct mlx5_events *events =3D dev->priv.events;
+
+	return blocking_notifier_call_chain(&events->sw_nh, event, data);
+}
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index f1de49d64a98..77ba54d38772 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -359,6 +359,10 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_MAX                =3D 0x100,
 };
=20
+enum mlx5_driver_event {
+	MLX5_DRIVER_EVENT_TYPE_TRAP =3D 0,
+};
+
 enum {
 	MLX5_TRACER_SUBTYPE_OWNERSHIP_CHANGE =3D 0x0,
 	MLX5_TRACER_SUBTYPE_TRACES_AVAILABLE =3D 0x1,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index c4615dc51b6f..45df5b465ba8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1073,11 +1073,26 @@ enum {
 	MAX_MR_CACHE_ENTRIES
 };
=20
+/* Async-atomic event notifier used by mlx5 core to forward FW
+ * evetns recived from event queue to mlx5 consumers.
+ * Optimise event queue dipatching.
+ */
 int mlx5_notifier_register(struct mlx5_core_dev *dev, struct notifier_bloc=
k *nb);
 int mlx5_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_bl=
ock *nb);
+
+/* Async-atomic event notifier used for forwarding
+ * evetns from the event queue into the to mlx5 events dispatcher,
+ * eswitch, clock and others.
+ */
 int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *n=
b);
 int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb =
*nb);
=20
+/* Blocking event notifier used to forward SW events, used for slow path *=
/
+int mlx5_blocking_notifier_register(struct mlx5_core_dev *dev, struct noti=
fier_block *nb);
+int mlx5_blocking_notifier_unregister(struct mlx5_core_dev *dev, struct no=
tifier_block *nb);
+int mlx5_blocking_notifier_call_chain(struct mlx5_core_dev *dev, unsigned =
int event,
+				      void *data);
+
 int mlx5_core_query_vendor_id(struct mlx5_core_dev *mdev, u32 *vendor_id);
=20
 int mlx5_cmd_create_vport_lag(struct mlx5_core_dev *dev);
--=20
2.29.2

