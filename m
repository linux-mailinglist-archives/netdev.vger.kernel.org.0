Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54A42000D3
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgFSDdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:33:45 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:57212
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730962AbgFSDdn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 23:33:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHpNoEJGBm3qRjpDf6bwzE/Nz4kpV6UanxrbUS/K/s+2xLyczaVmurwX4aipwl6nOZDkd8eoUXhGuDsm5pyHrzu1G0rVnp12j7uQfTgy1jUL5Luk/om51Y6UQ8HAYohxkSBdmc40yaSv+Y+EH23d6rIx0Fs0iaton48F/SBdEd7CaaLSg+vrI9F/QlxxwPxzJ1tV659mTYfe4qXMD1TdWledUFHLlh8tPhJIQonNxAsIFu1EPaZpRXd+TM2xMkoAzDCYp1Y0mEEuF3yOOI0C/TxzB3ahsSVcPC3bLssY5mYjiQ7eaczQDlX302Vr4spvZgsv+y9J9QBDl2aNR4EUxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jatV1TJUaxjZOC4Z+8goiTkRHn+lGLqnQVtf1Ku43Yk=;
 b=fVNFF6nuEhDUmhTcTuNrmTAowDjGo/hSHqax7JcEGsbr6N0Ag0S7VxNdEx76kgSCreRh1nUCJMgaidXhzKOeo/xLES5ulQUDHDrD5uI4ymGGaRSarvKPoozuRawLRCYcyTc4KIz3NkQnvwJBFClL+zrVhh8xULjrXDDklNRSYcv9XM19dZ/D76OmgPhYTO/KxKbK6vIvJIhNAiBWKtkEArDQC9OpRbVyAXS7S+qaF2DQNWGX+RtrpORa0qN6qj4kJ8pOfw10A/qiQFGYDldK+AtVWTnYPMDsFOz1Vepfi4gA5XXTrnnD7zFRAvqJ38t40OSUF1InPIT2ar3cJ7IKng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jatV1TJUaxjZOC4Z+8goiTkRHn+lGLqnQVtf1Ku43Yk=;
 b=oyK24gybXRdV95WPe8h6G9HYjyCBeJLu/Z4LFUJkSXFkGUs4v/tMdihzoq9UpXCrhdzou5LEcI9l01nrlfJfrRLJKs5ksDzPL5yH27vme+1pQiwCVZiI7BaFYb8q3RvwREb8x/eEYqwkwa+CpmUNp23StaF4V0feYqiheYWIXs0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6804.eurprd05.prod.outlook.com (2603:10a6:20b:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 03:33:28 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 03:33:28 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 5/9] net/mlx5: E-switch, Introduce and use eswitch support check helper
Date:   Fri, 19 Jun 2020 03:32:51 +0000
Message-Id: <20200619033255.163-6-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200619033255.163-1-parav@mellanox.com>
References: <20200619033255.163-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0019.namprd04.prod.outlook.com
 (2603:10b6:803:21::29) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 03:33:26 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 71d882b8-fdf2-4f48-0f3a-08d8140187eb
X-MS-TrafficTypeDiagnostic: AM0PR05MB6804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB680468B78189A3CA0635426AD1980@AM0PR05MB6804.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMYq+6pbjHOVfAa11zldN8ofFG3AbZEzbvo8lu+FFwl9plvaiPRikucdc6jzFC0vvk2fFzB2tn6jMqrH1qB2Q3F29edhf4vSYquAltzSvt0rwexmTheoq1XUXFvggolvdegkpIMT0NzR4U04Hk8+nxFpqd+UU2Yo7uKunQI2F5Ow9Wm+HQmPM9JjM/ucv1MQDirJ/85KRgGi2uVRjw6IkndYrHNA+yiHbRRgR4QC3D6z87Ln4YNbGYc3X9qh5bzf/z9NFdUPlK9cBDHoXLUhb8cj0UfCsE8RxuPDX1opEWo3/uXmpVn50KutwoQDQwr+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(2616005)(2906002)(4326008)(107886003)(6486002)(478600001)(8936002)(6512007)(5660300002)(6916009)(956004)(6666004)(26005)(66476007)(16526019)(186003)(66556008)(66946007)(83380400001)(316002)(6506007)(54906003)(86362001)(52116002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wRnui4jsU/gUK7hyAxt8rNtOcoytCJnz8IYIPaBHWZim/9soTxz6BZy9tO5IpZv0FoOpAApHJLASGG2pd8nwl0EezmkIi/0X//onX1f1Mw/W4tEEln+qGAmFExsd7GePIKj5TWAvzShPv5vrZF0xV28jGg7kCMlph2YoeiQoTIpryxZQ89nzfTNVkpkcm6uNqyFglysd9jZMV/AtC4GmZBNE8MyxZ3ZJRMyuJooOIoMVSuPPd+6eSoT3F44FemlzCdWsdDMMF6uthzrMotPEW269UVKMwzuk/90Sl3AoquSTheXIOv09rnlKHLFJ1XtUel5yXaT0VvcROtxgiJmdsj8Mld6WukNFwwHlVkxajg4+BY5qp8CpotbfyjBv6Tgpimie6JEV/h0wFOmP9Wch//wtOZzodCtK7qPW0Rcd1S+UCqkpwS0zZCihsRmbvDISfDm4CVgCJwR7x3P4044k3+Grq0iCvEcm4n8nJz7LFSkCte0WCxL98QMHFAkSh4hT
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d882b8-fdf2-4f48-0f3a-08d8140187eb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 03:33:28.4205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1/j45uO+PBrOcc3BCllwZRt9tvlfwjYuLhS2oH8/4C5UM9szwvhgAZljknXD1yKrvA5BtdomTD+paMAIS+pzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce an helper routine to get esw from a devlink device and use it
at eswitch callbacks and in subsequent patch.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 23 +++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 66 ++++++++-----------
 3 files changed, 50 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index d6a585a143dc..9f04fd10cb1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -63,6 +63,29 @@ struct vport_addr {
 static void esw_destroy_legacy_fdb_table(struct mlx5_eswitch *esw);
 static void esw_cleanup_vepa_rules(struct mlx5_eswitch *esw);
 
+static int mlx5_eswitch_check(const struct mlx5_core_dev *dev)
+{
+	if (MLX5_CAP_GEN(dev, port_type) != MLX5_CAP_PORT_TYPE_ETH)
+		return -EOPNOTSUPP;
+
+	if (!MLX5_ESWITCH_MANAGER(dev))
+		return -EPERM;
+
+	return 0;
+}
+
+struct mlx5_eswitch *mlx5_devlink_eswitch_get(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	int err;
+
+	err = mlx5_eswitch_check(dev);
+	if (err)
+		return ERR_PTR(err);
+
+	return dev->priv.eswitch;
+}
+
 struct mlx5_vport *__must_check
 mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 165a23efc608..dde5a36fee9d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -634,6 +634,7 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 	for ((vport) = (nvfs);						\
 	     (vport) >= (esw)->first_host_vport; (vport)--)
 
+struct mlx5_eswitch *mlx5_devlink_eswitch_get(struct devlink *devlink);
 struct mlx5_vport *__must_check
 mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 060354bb211a..74a2b76c7c07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2279,17 +2279,6 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 	return 0;
 }
 
-static int mlx5_eswitch_check(const struct mlx5_core_dev *dev)
-{
-	if (MLX5_CAP_GEN(dev, port_type) != MLX5_CAP_PORT_TYPE_ETH)
-		return -EOPNOTSUPP;
-
-	if(!MLX5_ESWITCH_MANAGER(dev))
-		return -EPERM;
-
-	return 0;
-}
-
 static int eswitch_devlink_esw_mode_check(const struct mlx5_eswitch *esw)
 {
 	/* devlink commands in NONE eswitch mode are currently supported only
@@ -2302,14 +2291,13 @@ static int eswitch_devlink_esw_mode_check(const struct mlx5_eswitch *esw)
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 				  struct netlink_ext_ack *extack)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	u16 cur_mlx5_mode, mlx5_mode = 0;
+	struct mlx5_eswitch *esw;
 	int err;
 
-	err = mlx5_eswitch_check(dev);
-	if (err)
-		return err;
+	esw = mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
 
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
@@ -2338,16 +2326,15 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 
 int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	struct mlx5_eswitch *esw;
 	int err;
 
-	err = mlx5_eswitch_check(dev);
-	if (err)
-		return err;
+	esw = mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
 
 	mutex_lock(&esw->mode_lock);
-	err = eswitch_devlink_esw_mode_check(dev->priv.eswitch);
+	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
 
@@ -2361,13 +2348,13 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 					 struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
-	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	int err, vport, num_vport;
+	struct mlx5_eswitch *esw;
 	u8 mlx5_mode;
 
-	err = mlx5_eswitch_check(dev);
-	if (err)
-		return err;
+	esw = mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
 
 	mutex_lock(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
@@ -2424,13 +2411,12 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 
 int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	struct mlx5_eswitch *esw;
 	int err;
 
-	err = mlx5_eswitch_check(dev);
-	if (err)
-		return err;
+	esw = mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
 
 	mutex_lock(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
@@ -2448,12 +2434,12 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 					struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
-	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	struct mlx5_eswitch *esw;
 	int err;
 
-	err = mlx5_eswitch_check(dev);
-	if (err)
-		return err;
+	esw = mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
 
 	mutex_lock(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
@@ -2508,13 +2494,13 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 					enum devlink_eswitch_encap_mode *encap)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	struct mlx5_eswitch *esw;
 	int err;
 
-	err = mlx5_eswitch_check(dev);
-	if (err)
-		return err;
+	esw = mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
 
 	mutex_lock(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
-- 
2.19.2

