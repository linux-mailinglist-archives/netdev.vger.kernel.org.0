Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4FD1E49CB
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390941AbgE0QWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:22:37 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:46308
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390913AbgE0QWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:22:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1YYSX4Z2ggryh29bar609xTYSP+lLVyjD7R4GT5GLfWzMIQ0dkhga7GrbHiAnjuPl7IjSrmcv7sGZTRJY04W9JtWhJa9TzAto0MlRWj8/TD42fUd/Gh571pQUbumJ0GGO+5kCVNM/qdp6XfRCmNm9Ff/QlgC57lzcyCdOEjHerdIXMinsKZhhr9MECu+mQ+ydmGhsvo7UOJSQWHvEmA7TVucxilUmM6xutpR9yxtWZ1QsvE+YtupokYKSjvxFXe41mhkWRcoD1qemOOFgy+NkE7idghvfLSiroWMpJAvkRhx5BZCCDXrSQFVeHvYT38+nj1NQ2/F0ELMMZHMvu/Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAOMpAqfql//qR1vSAzQPeMkugDlTgAYaDhNDdJZPb4=;
 b=YKRv0mN8vp9Rjb7AtF7ms0a4WJm39xqNa0HHeoteI2jtmBVy/Q7ZVUQjiZ+nXctV8i21OUCtrFm43ortcx80tpDTpNE0vnZdXkukbo/iJKiG4KM9rp7+huUbYw9qyf2XtreInPu1lUIsdHt8B5jx/2zi6iUNSWeghLUwBlkoNqnzMFO5LCx3Sv5P5C1KHHfuT9YbLeIYYQLnUa5PiaoC5fpJsfi1S/TziCBAALuiDowUxv+KkSY9If8CK77PBtNk9ysmhHV1CC9UsxH0oZcggImefaRbdd9oarosCJO/A8PoBdx7viVU2oicZBYiwdXaPhkQ+yopfkzvbvLMK1CjNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAOMpAqfql//qR1vSAzQPeMkugDlTgAYaDhNDdJZPb4=;
 b=dhmemb470CGOq5mGSxuoML4OLN5D19oaEFyXkKIjFomr1/gO0mBC/ogzWfjPIj5AanfenvmWU1dF7IIf2BI1NHPlNIRJdT02G844Qax71Zp4da+0sc4AtLKgKMzyPewitFmQPB8QcBiETOFHk46vNB/bvIjbDRIhv6nRdbYyZ5A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5054.eurprd05.prod.outlook.com (2603:10a6:803:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Wed, 27 May
 2020 16:22:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 04/15] net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule
Date:   Wed, 27 May 2020 09:21:28 -0700
Message-Id: <20200527162139.333643-5-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:04 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2e542dcb-c298-48dd-fd8e-08d8025a18fb
X-MS-TrafficTypeDiagnostic: VI1PR05MB5054:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5054CD60CE9EDCD73B880798BEB10@VI1PR05MB5054.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iMQXYCguTkj9AWxdsmJF4l+LVHqE5g0m7haSmIhr7hmTFNhRixlQxCpWLLLHZfZkwC6HfxmNN79aLXTLygKE9Z2dPQQjQicd9m3Q9mQgKVU5J3N8FgOcMC7519YC1F1mV/uBnPI/FhfA7eNQ6xj9GuHxGt+vNTK44dRn24ml6iq+xVhQ7WjJpBlzVhr2+Jghx2pgWyTJRLWWbGf/4Pdt75+8uOKRxMG+l4b6V/Emqub3shcq3zQYwEQkSh0br+/qTZLn472fvPy0bGkfLEb6FYllMqAdpqsY/Na65obHhCX2ie+iLbB13yAZTa8820XXDatvHTgBmZuzz3BYJFjfAb9shOXIQIrthmEi4pdXDw518yNB8cjIhYD2rJwu2PVr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(6512007)(107886003)(66476007)(66946007)(66556008)(52116002)(956004)(2616005)(6506007)(5660300002)(6666004)(8676002)(26005)(1076003)(86362001)(8936002)(478600001)(2906002)(4326008)(186003)(6486002)(16526019)(316002)(54906003)(36756003)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C4CNbGRpetIzcwK5OlDWCV374fqHEq8wErna8RG9LxnGVQRdSlk340hz+Qk0cCgPhl++B+eDtDArVN6lnJeUh1+xrilUXNiZuZ0y2mJN1cdoSY1mEEp0xVR9ak6C0R6+6K+e68n61jUFlQttGUJ9PNqbc1f1XcybAwy74Yw2dJJIlPr//BnVTUsK9/VhOcYLOQpqRD3ZvdyAPWf0wiBtemTUJHPhaDg7vGcllCi3ytaaNbD6d1YDZ4i2BvOfZwqwttq/OMioWM1RtmuWg/OwVD+TVSNa/zmC8Wsi3HW28/uMaC2/7IhfYld1tgOjSlgV1fmqtZcMxI7QbkfWRbvQjPYp9BxG+tLZviuBBds22dyTMS0vMSSmyKGKBh2nwYrOJ8ZnwiTqY/bySjuLj3y0LwKM6CwKR8aGYvZVZqD4laqiJs+3wSGyeJpjmr1E1mO+sC7wkINAF2mjiiRznG7MnCM25QuMTeM4yc3D1ZlZxlc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e542dcb-c298-48dd-fd8e-08d8025a18fb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:06.5123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcbIJZ/igXcq3qnU4/QrRVXNQoLj02jXnI5lCrqoA8JRu7JTWdYPP+BDFuj0+mpqruGVisEWPmytKXSUSkIzUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5054
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

