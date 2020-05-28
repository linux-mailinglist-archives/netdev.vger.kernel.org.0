Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDB41E52C9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgE1BRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:17:52 -0400
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:6231
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725940AbgE1BRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:17:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcgjHq8Q6caFLd8UK07M4yiD8TwOsY4E+f+PhQnKcFyak3WR2HKpAFy2OnS5WWYullODyXZy3myOSimuzqWqwKGyLxLi3wKGhA7azxEFsZd3juatv7nn9CxTAkVekNGzbz3sneXR/uRCYzZ5297daMIPGxkxizagdkwfsx1CKm38Ols03oL/wvfMxcjVi2G+tkV78iEdJvGS97QPIURTesjl9NisGAz/JxZ6hcxql8QAG/VIXnaMupOMFbuBIYdrO3KHk4HzCqGJkSxS3VgVewyGNp+l4ijyuPpSWipSsHmsXB4d8iCcgzcc7P0oJDTb9QsV1iakHroYOzzPLgBjHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAOMpAqfql//qR1vSAzQPeMkugDlTgAYaDhNDdJZPb4=;
 b=emgPNHvCKscsGpCJIaa0xEi2EO/MbruULVLTzMLueN0fAYPgfPzHmMOPm9F02Lr8oRlqlYkI1kBewbmra8Lhww9D6ihATQIdYOqD9dfac/iGrdCHpvlnPhkId0FVmvy1eRbDRZZAsK7gCnfERCIk6EYhdUN6JoKTWzVQwJ43eMEBOO/ZK/qwEwv2LjX8l2N+oTaUY0Og2YWTYVCqo1f/xufBN1je4NMvMfwpSaVZUPZ3RUQshNv9RY4C8msiSRZtuwyvg42F6txQNs6Snt0OkoB4gQzrPNxGbyDDbtqJjXh0l1aN2a6Z2aWS92GPb9A/f2cbr7hBVk5h4p/Tv3EQbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAOMpAqfql//qR1vSAzQPeMkugDlTgAYaDhNDdJZPb4=;
 b=Q4ez+/LeY5Wn3kgK5pDKzCsO46TTTzI9mZJRwIlOWKDCtaRId3jL3M/CTNL/ATUZzRENpLdE6KvupMr7hATrGFPFySBkVdtJ/+Rht1xP0Cj2LxHSpcbMpjW4AoW7JBzcrE86ZrAjTdpjc7zMrtJYWuOedSq2Qi5tf6pfyEy/R+4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 04/15] net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule
Date:   Wed, 27 May 2020 18:16:45 -0700
Message-Id: <20200528011656.559914-5-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:32 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2459d78a-2f83-475c-6d76-08d802a4e6bb
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4368E53908BA7CC00D5D4C7DBE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: knyIabb120pKVlFDhovMd670MoI33oajMg1Msprmbm1qca277ji58QpkFq+72NHLlNeBowBWPYTUb2EHj4x2jzWZC2I4VLPDMGEEmBC42yD8PZGd8cd7MK7sWnnL+BA/qLMVRSC7HbOnvICpTvOuVOyAWFeZKDJQak5I1WzCPx0O7mfjAuOTVwVodInbEsIFmATB4XXBY1Hbo5wIp4F53u7UJqIYZKU12/adUzQDQR1oyTIwH6XSELX/8z2tRcpZipIQgxGTNX+3J2YoX++0rYu5b2cY8Y4TcaG4zQBxGxdppIXI8rjBDaEXa25h9DTq+BQvUFsBJRfZyGILb4t+6jc3DIzjlcUyHhC2aeLeUyHaXT1up8U3kOjtBEXkNLIa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(6666004)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: alCuEzt/DLJV5aC2XWm00TU32mo0VyoG0wtNBYBEKab6Xk7uQd8wbPAcFd9yNVtt4TjNxWzLj5bLhrXP1in65nWGs+GX8TTySGNc+cVVE29k3dMPU1s1+ysJOzpCETypuZd1AJk6P7HOKEdrYx5icVadMz03wE92CTNbRv908n5CMg1yHayJic4xKVYk2aAWotCqrHhTrh97Dyxilb6JkFRGI6PtezQFCMIQsY5M70CVr/FEypNJ+nY7PNkYODBz5OF1ex3G6Z0T79aB52iKYGWiZQg4dIGUpQ8BOm7qU4BRiKZGsrWjJOdADSebGnoq0voBB57ObZjKBX4IkJnQg0TD3n1MG1cWBtWity6uOCLVZ3/HEpT5ckOXsrzFgiLt2czRzdPk/FHxO4NV+1Ng8mZQThQcq8/tLuNILM5NheE8fihEoo26B0l1Yb/QzfFm7X+OVkyl0bVagELeSOP59OVbsKVIZJNsiPNX/PlnJMk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2459d78a-2f83-475c-6d76-08d802a4e6bb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:34.5628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 43LAjZNh72VErgpsdq2Yrd4qmIF8/CIqVKSQH09aMPUeEkBVmSL9McOLz923Dx6TgrQ4Q+nuz3b99EmhMQufZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

Register a notifier block to handle netdev events for bond device
of non-uplink representors to support eswitch vports bonding.

When a non-uplink representor is a lower dev (slave) of bond and
becomes active, adding egress acl forward-to-vport rule of all slave
netdevs (active + standby) to forward to this representor's vport. Use
change lower netdev event to do this.

Use change upper event to detect slave representor unslaved from lag
device to delete its vport egress acl forward rule if any.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bond.c | 161 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   7 +
 4 files changed, 175 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 3934dc258041..b61e47bc16e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -34,7 +34,8 @@ mlx5_core-$(CONFIG_MLX5_EN_ARFS)     += en_arfs.o
 mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    += en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
-mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o lib/geneve.o lib/port_tun.o lag_mp.o
+mlx5_core-$(CONFIG_MLX5_ESWITCH)     += lag_mp.o lib/geneve.o lib/port_tun.o \
+					en_rep.o en/rep/bond.o
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					en/mapping.o esw/chains.o en/tc_tun.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
new file mode 100644
index 000000000000..d0aab36f1947
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Inc. All rights reserved. */
+
+#include <net/lag.h>
+
+#include "mlx5_core.h"
+#include "eswitch.h"
+#include "esw/acl/ofld.h"
+#include "en_rep.h"
+
+struct mlx5e_rep_bond {
+	struct notifier_block nb;
+	struct netdev_net_notifier nn;
+};
+
+static bool mlx5e_rep_is_lag_netdev(struct net_device *netdev)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
+	/* A given netdev is not a representor or not a slave of LAG configuration */
+	if (!mlx5e_eswitch_rep(netdev) || !bond_slave_get_rtnl(netdev))
+		return false;
+
+	/* Egress acl forward to vport is supported only non-uplink representor */
+	return rpriv->rep->vport != MLX5_VPORT_UPLINK;
+}
+
+static void mlx5e_rep_changelowerstate_event(struct net_device *netdev, void *ptr)
+{
+	struct netdev_notifier_changelowerstate_info *info;
+	struct netdev_lag_lower_state_info *lag_info;
+	struct mlx5e_rep_priv *rpriv;
+	struct net_device *lag_dev;
+	struct mlx5e_priv *priv;
+	struct list_head *iter;
+	struct net_device *dev;
+	u16 acl_vport_num;
+	u16 fwd_vport_num;
+
+	if (!mlx5e_rep_is_lag_netdev(netdev))
+		return;
+
+	info = ptr;
+	lag_info = info->lower_state_info;
+	/* This is not an event of a representor becoming active slave */
+	if (!lag_info->tx_enabled)
+		return;
+
+	priv = netdev_priv(netdev);
+	rpriv = priv->ppriv;
+	fwd_vport_num = rpriv->rep->vport;
+	lag_dev = netdev_master_upper_dev_get(netdev);
+
+	netdev_dbg(netdev, "lag_dev(%s)'s slave vport(%d) is txable(%d)\n",
+		   lag_dev->name, fwd_vport_num, net_lag_port_dev_txable(netdev));
+
+	/* Point everyone's egress acl to the vport of the active representor */
+	netdev_for_each_lower_dev(lag_dev, dev, iter) {
+		priv = netdev_priv(dev);
+		rpriv = priv->ppriv;
+		acl_vport_num = rpriv->rep->vport;
+		if (acl_vport_num != fwd_vport_num) {
+			mlx5_esw_acl_egress_vport_bond(priv->mdev->priv.eswitch,
+						       fwd_vport_num,
+						       acl_vport_num);
+		}
+	}
+}
+
+static void mlx5e_rep_changeupper_event(struct net_device *netdev, void *ptr)
+{
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_priv *priv;
+
+	if (!mlx5e_rep_is_lag_netdev(netdev))
+		return;
+
+	/* Nothing to setup for new enslaved representor */
+	if (info->linking)
+		return;
+
+	priv = netdev_priv(netdev);
+	rpriv = priv->ppriv;
+	netdev_dbg(netdev, "Unslave, reset vport(%d) egress acl\n", rpriv->rep->vport);
+
+	/* Reset all egress acl rules of unslave representor's vport */
+	mlx5_esw_acl_egress_vport_unbond(priv->mdev->priv.eswitch,
+					 rpriv->rep->vport);
+}
+
+/* Bond device of representors and netdev events are used here in specific way
+ * to support eswitch vports bonding and to perform failover of eswitch vport
+ * by modifying the vport's egress acl of lower dev representors. Thus this
+ * also change the traditional behavior of lower dev under bond device.
+ * All non-representor netdevs or representors of other vendors as lower dev
+ * of bond device are not supported.
+ */
+static int mlx5e_rep_esw_bond_netevent(struct notifier_block *nb,
+				       unsigned long event, void *ptr)
+{
+	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+
+	switch (event) {
+	case NETDEV_CHANGELOWERSTATE:
+		mlx5e_rep_changelowerstate_event(netdev, ptr);
+		break;
+	case NETDEV_CHANGEUPPER:
+		mlx5e_rep_changeupper_event(netdev, ptr);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+/* If HW support eswitch vports bonding, register a specific notifier to
+ * handle it when two or more representors are bonded
+ */
+int mlx5e_rep_bond_init(struct mlx5e_rep_priv *rpriv)
+{
+	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
+	struct net_device *netdev = rpriv->netdev;
+	struct mlx5e_priv *priv;
+	int ret = 0;
+
+	priv = netdev_priv(netdev);
+	if (!mlx5_esw_acl_egress_fwd2vport_supported(priv->mdev->priv.eswitch))
+		goto out;
+
+	uplink_priv->bond = kvzalloc(sizeof(*uplink_priv->bond), GFP_KERNEL);
+	if (!uplink_priv->bond) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	uplink_priv->bond->nb.notifier_call = mlx5e_rep_esw_bond_netevent;
+	ret = register_netdevice_notifier_dev_net(netdev,
+						  &uplink_priv->bond->nb,
+						  &uplink_priv->bond->nn);
+	if (ret) {
+		netdev_err(netdev, "register bonding netevent notifier, err(%d)\n", ret);
+		kvfree(uplink_priv->bond);
+		uplink_priv->bond = NULL;
+	}
+out:
+	return ret;
+}
+
+void mlx5e_rep_bond_cleanup(struct mlx5e_rep_priv *rpriv)
+{
+	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
+
+	if (!mlx5_esw_acl_egress_fwd2vport_supported(priv->mdev->priv.eswitch) ||
+	    !rpriv->uplink_priv.bond)
+		return;
+
+	unregister_netdevice_notifier_dev_net(rpriv->netdev,
+					      &rpriv->uplink_priv.bond->nb,
+					      &rpriv->uplink_priv.bond->nn);
+	kvfree(rpriv->uplink_priv.bond);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 4e13e37a9ecd..12593d75e885 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -959,16 +959,18 @@ static int mlx5e_init_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
 
 	mlx5_init_port_tun_entropy(&uplink_priv->tun_entropy, priv->mdev);
 
+	mlx5e_rep_bond_init(rpriv);
 	err = mlx5e_rep_tc_netdevice_event_register(rpriv);
 	if (err) {
 		mlx5_core_err(priv->mdev, "Failed to register netdev notifier, err: %d\n",
 			      err);
-		goto tc_rep_cleanup;
+		goto err_event_reg;
 	}
 
 	return 0;
 
-tc_rep_cleanup:
+err_event_reg:
+	mlx5e_rep_bond_cleanup(rpriv);
 	mlx5e_rep_tc_cleanup(rpriv);
 	return err;
 }
@@ -1001,7 +1003,7 @@ static void mlx5e_cleanup_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
 {
 	mlx5e_rep_tc_netdevice_event_unregister(rpriv);
 	mlx5e_rep_indr_clean_block_privs(rpriv);
-
+	mlx5e_rep_bond_cleanup(rpriv);
 	mlx5e_rep_tc_cleanup(rpriv);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 1c4af8522467..7e56787aa224 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -56,6 +56,7 @@ struct mlx5e_neigh_update_table {
 };
 
 struct mlx5_tc_ct_priv;
+struct mlx5e_rep_bond;
 struct mlx5_rep_uplink_priv {
 	/* Filters DB - instantiated by the uplink representor and shared by
 	 * the uplink's VFs
@@ -89,6 +90,9 @@ struct mlx5_rep_uplink_priv {
 	struct mapping_ctx *tunnel_enc_opts_mapping;
 
 	struct mlx5_tc_ct_priv *ct_priv;
+
+	/* support eswitch vports bonding */
+	struct mlx5e_rep_bond *bond;
 };
 
 struct mlx5e_rep_priv {
@@ -211,6 +215,9 @@ struct mlx5e_rep_sq {
 
 void mlx5e_rep_register_vport_reps(struct mlx5_core_dev *mdev);
 void mlx5e_rep_unregister_vport_reps(struct mlx5_core_dev *mdev);
+int mlx5e_rep_bond_init(struct mlx5e_rep_priv *rpriv);
+void mlx5e_rep_bond_cleanup(struct mlx5e_rep_priv *rpriv);
+
 bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv);
 int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv);
 void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv);
-- 
2.26.2

