Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E3D231363
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgG1UAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:53 -0400
Received: from mail-eopbgr00064.outbound.protection.outlook.com ([40.107.0.64]:19686
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729300AbgG1UAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSoBwI18C88lXTFalYJX67AtDx0l6hyDBC854EOUrYbxmLKblpOsy7vffAeqcyFlNLRB60W5k8EBdtKnkr1aAuJh2Qka8MBDiuakXJvl9cD6WDDxUdoKQwJN+ksSxMRUW3DLr2sBV94jJ3J6aE3oySNbAbngvzGuqr4N6tyZnX9hfO4x+pDlOabGhLGYfOeVqveVupPYgrL1GeLGpuuDClMfdruesulsreMokr+8voX1yRStL+WmKMiZ+kSnRCYJzXLSKs4QG8x1rzzN8r7XW+/JxTqhccFMLYBveozgFTbLZ74M0n9NaQX+00qNgII7YCuXSlmEaCW69Fs/usK1vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h57vDBXZzLrgEn6cIlweyy+lp5zjeQjYWgXwka7Q3bI=;
 b=fUwA7gd2sh7gY1PiG1HGJ/hieINYQiJR6FhTLZ7/AMVlo7ycuN/9Z3ocTmAR2QqbyEEcUYSrMkwF5kLKCNySVVjnePFpFx416MwOwJWENSdWqLpJRjKqVTgTX4fVmNaS+yDZpTonRP/s50Ujn3nLUTTMdfbHt/MkKiJrO6X3F5EM7M97ndS9DHNWcFVlWAIACslTKU7pIOgmT/1SEoPAlbX2JIdOlXE66hS4QZD1ufH/yYqS4Vfc2OuoVctN6KxtlIPpOxYh/RR5y7SBLOn/juSEbqMlT6+E3RX2IYHOJextDAKUNCxix7SeD36dCDjeAyRshF3R0uxbriAdjJfibQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h57vDBXZzLrgEn6cIlweyy+lp5zjeQjYWgXwka7Q3bI=;
 b=NciF1jxw+plL7m07WXjvmKR0Mi16ZdjgLrBhZj+aRTFVuxs29HfGmY9S3jVz0b71SAZzmdR5V7Z8xAqvq+mU37/wMnBdMcs2V+v0Y2it9XLXcZxtfW2li1G93g9zCUD3lEYFUlkOY8+0FtrcZgOOPgni1WOwClszcInpTyir6/s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ron Diskin <rondi@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 10/11] net/mlx5e: Modify uplink state on interface up/down
Date:   Tue, 28 Jul 2020 12:59:34 -0700
Message-Id: <20200728195935.155604-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728195935.155604-1-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:45 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f35cd8b9-9419-4969-82f6-08d83330eb10
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB25922199A622D1FDDCFF9BC3BE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQaCiIxceshimF7LzLi0UtJxyrXcmBBXMuH1P1MzvT6CQUuWCY8/2Mpo/thThhZUkMLahNA9PTQKKqdUd2Ly2UmUEcXH2tvOIE94gDXrzMLad/nfaQo8NQoeK+jYruwuKDGvlMKCmau5aYD3ZVyguMwdcDj5RoIwBX56dMny7sauyARZNl9dJF2N06tdWOhVfrE5DgGVNiG5AGtCGA4hCI0VDN2aI6TulKNNMKNwVPV3rw4SAjEzn3quEK2x8yM3chwpBzniMW0rY8HYOoU/k2oPtxVU7KF/RfzZy7eVlGyLmWAItpoguTznNHePekYWprTZYwWq9lHIARAjamaHmzcy/6P2tMHVtz05WiCEZqXEpKb6W9UChwugOVY6rHDY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(6666004)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hYwlVOPhBYZzb6lKMQywVB2d3R6N0bNMCJ4b7H/uguAid4ECnBsGleoaZXtKup7cepbT931Lv8wH7YGd3cTbAQ3/Rkll60wx8xJRytIJxC1Mwhtiuw0iPcptiMxFt+b3Qc/jRt15KMPtAH0UR0KGU01AO+JSFIr5cjNFyd6enqEmlaiTm8sDxsKPpkjvr0tCfjVjfaasWR+KxAiln76jDcgpMLOsC/JB5c2ejKpSnkxaDeMK4iYW4eG5tEFaY0gUamnNYbiOT5qHZUy4gI8NPJff7lOtiH56Jauon9sD+Jx00sUC+obbspUvHehuAALLi5rm9Rp87RiLSJV61u1fdWrMRiY4txy8tgWHpGMJwn4Fi++M/Fq8KUzL5ysR0xPW/6+dpHeaKULldfPYVAuyWZp7sC3OmO+gTmrY/5gBxvPWmJZ65EkDDaEvMsZLRUMdcRfK08pthWboykzURgaeFbbu3E2lErvXDRUYpV0hRIk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f35cd8b9-9419-4969-82f6-08d83330eb10
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:47.4248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDNVahwzA2TUrSPu5p6V+l/9PimX37L2AsZ+QBu5B2MKJBGrBgC2cThhmw0Cg+SGwQYYoCnA078qSNojrgJfgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ron Diskin <rondi@mellanox.com>

When setting the PF interface up/down, notify the firmware to update
uplink state via MODIFY_VPORT_STATE, when E-Switch is enabled.

This behavior will prevent sending traffic out on uplink port when PF is
down, such as sending traffic from a VF interface which is still up.
Currently when calling mlx5e_open/close(), the driver only sends PAOS
command to notify the firmware to set the physical port state to
up/down, however, it is not sufficient. When VF is in "auto" state, it
follows the uplink state, which was not updated on mlx5e_open/close()
before this patch.

When switchdev mode is enabled and uplink representor is first enabled,
set the uplink port state value back to its FW default "AUTO".

Fixes: 63bfd399de55 ("net/mlx5e: Send PAOS command on interface up/down")
Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 25 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 16 +++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 ++
 include/linux/mlx5/mlx5_ifc.h                 |  1 +
 5 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 31f9ecae98df9..07fdbea7ea13b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3069,6 +3069,25 @@ void mlx5e_timestamp_init(struct mlx5e_priv *priv)
 	priv->tstamp.rx_filter = HWTSTAMP_FILTER_NONE;
 }
 
+static void mlx5e_modify_admin_state(struct mlx5_core_dev *mdev,
+				     enum mlx5_port_status state)
+{
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+	int vport_admin_state;
+
+	mlx5_set_port_admin_status(mdev, state);
+
+	if (!MLX5_ESWITCH_MANAGER(mdev) ||  mlx5_eswitch_mode(esw) == MLX5_ESWITCH_OFFLOADS)
+		return;
+
+	if (state == MLX5_PORT_UP)
+		vport_admin_state = MLX5_VPORT_ADMIN_STATE_AUTO;
+	else
+		vport_admin_state = MLX5_VPORT_ADMIN_STATE_DOWN;
+
+	mlx5_eswitch_set_vport_state(esw, MLX5_VPORT_UPLINK, vport_admin_state);
+}
+
 int mlx5e_open_locked(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -3101,7 +3120,7 @@ int mlx5e_open(struct net_device *netdev)
 	mutex_lock(&priv->state_lock);
 	err = mlx5e_open_locked(netdev);
 	if (!err)
-		mlx5_set_port_admin_status(priv->mdev, MLX5_PORT_UP);
+		mlx5e_modify_admin_state(priv->mdev, MLX5_PORT_UP);
 	mutex_unlock(&priv->state_lock);
 
 	return err;
@@ -3135,7 +3154,7 @@ int mlx5e_close(struct net_device *netdev)
 		return -ENODEV;
 
 	mutex_lock(&priv->state_lock);
-	mlx5_set_port_admin_status(priv->mdev, MLX5_PORT_DOWN);
+	mlx5e_modify_admin_state(priv->mdev, MLX5_PORT_DOWN);
 	err = mlx5e_close_locked(netdev);
 	mutex_unlock(&priv->state_lock);
 
@@ -5182,7 +5201,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 
 	/* Marking the link as currently not needed by the Driver */
 	if (!netif_running(netdev))
-		mlx5_set_port_admin_status(mdev, MLX5_PORT_DOWN);
+		mlx5e_modify_admin_state(mdev, MLX5_PORT_DOWN);
 
 	mlx5e_set_netdev_mtu_boundaries(priv);
 	mlx5e_set_dev_port_mtu(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 8c294ab43f908..9519a61bd8ec5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1081,6 +1081,8 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 
 	mlx5e_rep_tc_enable(priv);
 
+	mlx5_modify_vport_admin_state(mdev, MLX5_VPORT_STATE_OP_MOD_UPLINK,
+				      0, 0, MLX5_VPORT_ADMIN_STATE_AUTO);
 	mlx5_lag_add(mdev, netdev);
 	priv->events_nb.notifier_call = uplink_rep_async_event;
 	mlx5_notifier_register(mdev, &priv->events_nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index d9376627584e9..71d01143c4556 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1826,6 +1826,8 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 				 u16 vport, int link_state)
 {
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
+	int opmod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
+	int other_vport = 1;
 	int err = 0;
 
 	if (!ESW_ALLOWED(esw))
@@ -1833,15 +1835,17 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 	if (IS_ERR(evport))
 		return PTR_ERR(evport);
 
+	if (vport == MLX5_VPORT_UPLINK) {
+		opmod = MLX5_VPORT_STATE_OP_MOD_UPLINK;
+		other_vport = 0;
+		vport = 0;
+	}
 	mutex_lock(&esw->state_lock);
 
-	err = mlx5_modify_vport_admin_state(esw->dev,
-					    MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
-					    vport, 1, link_state);
+	err = mlx5_modify_vport_admin_state(esw->dev, opmod, vport, other_vport, link_state);
 	if (err) {
-		mlx5_core_warn(esw->dev,
-			       "Failed to set vport %d link state, err = %d",
-			       vport, err);
+		mlx5_core_warn(esw->dev, "Failed to set vport %d link state, opmod = %d, err = %d",
+			       vport, opmod, err);
 		goto unlock;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index a5175e98c0b34..5785596f13f5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -680,6 +680,8 @@ static inline int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs) { r
 static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf) {}
 static inline bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct mlx5_core_dev *dev1) { return true; }
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev) { return false; }
+static inline
+int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw, u16 vport, int link_state) { return 0; }
 static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 {
 	return ERR_PTR(-EOPNOTSUPP);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 073b79eacc991..1340e02b14ef2 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -4381,6 +4381,7 @@ struct mlx5_ifc_query_vport_state_out_bits {
 enum {
 	MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT  = 0x0,
 	MLX5_VPORT_STATE_OP_MOD_ESW_VPORT   = 0x1,
+	MLX5_VPORT_STATE_OP_MOD_UPLINK      = 0x2,
 };
 
 struct mlx5_ifc_arm_monitor_counter_in_bits {
-- 
2.26.2

