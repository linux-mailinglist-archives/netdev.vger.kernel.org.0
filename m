Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED3D1EBA6E
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgFBLb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:31:59 -0400
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:9760
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726728AbgFBLb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 07:31:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZAnDMtufYeHKIHq1GZfTQilahQwVFqbig3HXLiaVe3JnkjxIoHztlU0LmpS4nSDG+XKziEVYSwnm53tjBdVBQca7VCfFip8xcFKhe7f+Var1rfVZs2xDIJSUyULRbWyjSm9u2gS32V4aoGKuwoAIJewcVd+2KFhWQhAKHSU/7O8nnCVUYQboY7gO9+pRvQhqHUQAda7DKZGdY2l+2ey2kB/DIYGEavtH47GdiV94wEnsV4BNV8DdChvcj+6wVeHf9GTLKvRgqRwy/ZnJQxXdFD+nvCGbIJ9MNiVgZYCtY5qYLAe1LPs9zkWdA3EkvgrEDLfp6qD18nAoFQY2/X5fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nq9+a40fxDPkT+/FqEzguZD7eMDwa/IJ9vHOnwKUUCE=;
 b=WymgDaOVA267LyEY3T/zVeG+bwmz50Qzxm5thvFyqLkUt73XmWVVxmFKnv1lWErId42pDbCZjZCQB9YfboijK1YKhFzqEdmpjwO0kOU53flkWH6/D3o1uO/G8Aif44bF8aAxq2XHvIqLKv+iyOu2PKoa3aAcvfkJbIIv2wxj1BIJSitVPjHi0KOfrg2GdlEZ2UBk/4/gr2lE5XLQ02fCbiep0JjpPHGaZ7UFtoqstSdZN1xdt/vGe2Ud32+buqIDHt95jfbLNXSgnRpIUCJazbd+JojUqTo5cUZOU1d2SrHaMEIN0LtkgQd6teRXztRFkqlY85Alpr0XUPtfoRprIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nq9+a40fxDPkT+/FqEzguZD7eMDwa/IJ9vHOnwKUUCE=;
 b=mzuOGE6/KMsAjyZ+BRWoFo+LVq4WE5Ic+s9uBgcQIQbN0am/bItFKbL1O3v+teZPutshhsB0KEFkRze2aLqJrNUaHKMM9nUed2OXRx7j5SeBNpv3DspobWBHaOpi6hKyx/bQsEc5LmUIvY/SSsGYy6mLy7dWbTWG4+Nh/juxjxw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6628.eurprd05.prod.outlook.com (2603:10a6:20b:15b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 11:31:52 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 11:31:52 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, michael.chan@broadcom.com, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [RFC PATCH net-next 3/8] devlink: Replace devlink_port_attrs_set parameters with a struct
Date:   Tue,  2 Jun 2020 14:31:14 +0300
Message-Id: <20200602113119.36665-4-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200602113119.36665-1-danieller@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 11:31:49 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e80595ba-aacb-4c4d-647c-08d806e88b88
X-MS-TrafficTypeDiagnostic: AM0PR05MB6628:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6628C9A9D86300915B87E8AFD58B0@AM0PR05MB6628.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+HGnvMcyb/eNadY9Vz5fmZ1ip9scOOOQ2JSI3OEXKgO7alWYD1cX8G2ZUncr3iaPJvjarHTRjWc/Uw92++7iryhhr4TFBA7txXdSdQ7gR2Y9MXopmjlYuUrXVNr6W6fJP9pizlFaGwshKfoViClHQACXkjlRIvW3FrQXamgAY5XcOJKOv+wjlZtgwJK8eiVXBBfzrBywE7luJ3ni1Gx6IUdhsGv+jrSZ/aAhUchc4fM/7x353hg6Wvnr8I7D3YBTGxaeb2x8iO+2GcllIA9euhAo19Vmj0wZJYz4yLjbx11+ZQR2Lwms3EBRScLEBpZxxSPGL+oqJ8rqEO10Q1rSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(186003)(16526019)(26005)(83380400001)(6506007)(86362001)(36756003)(2616005)(2906002)(52116002)(107886003)(6916009)(956004)(6486002)(8676002)(7416002)(30864003)(66556008)(478600001)(6666004)(6512007)(66476007)(66946007)(5660300002)(316002)(4326008)(8936002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LqE+YTWo19B+36CwSfBFdD+e1KWwG02/3sE7svFFRmjto2pFjofaXFjZl0EUC9DGdw1eSXa8wxqvSfPm0RT8l0YGtMVbDXm/JY54Py0t41KZ9sTwt3EKNNQIa/cZUoS+dSy36tcN1eC/gHDWw9qFs98lTT623765h5GWMtBrQtXQTmUsFLpcED1pj7uUhaRrIlHGGkHB8f/+Ovyd4JCnZbPz19F+lGKspJ20Xfd0OIGCRPCr0cCrl4V16grRwOOplgp/nKVk3YyO8VAe2fT7iCvDfb6T2nP6N20nPNEEJHoA81DtUbMm26ZPoegQ6YuagBSpeMZJmzofi4YxbdjcbFZBV7D4NoFxzg0z1oSQyv484l2O+02x+Gqvd+OT7FcAopOczWVysdxc0yKB6cSx8XpYgsSQQQRDaYr+qM5uDt0EQYQfUZekKtdXmTFov4ktyhFIPAz7w5v8LfeiuQYMPZ1TsfevmRxyGLkaHJQjiAoZR+aK90DnKGETf6QWwErr
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e80595ba-aacb-4c4d-647c-08d806e88b88
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 11:31:52.6050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EhevTF86teifoudky55XpkADK1Pj4mWMxof/uzZJ8Q0+ddz/66+Op9v7G2Q7mAUvIPKx2gQv1+aKalf/BalOQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6628
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, devlink_port_attrs_set accepts a long list of parameters,
that most of them are devlink port's attributes.

Use the devlink_port_attrs struct to replace the relevant parameters.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 13 +++-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  6 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 19 +++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 20 +++---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 11 +++-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  | 11 +++-
 .../ethernet/pensando/ionic/ionic_devlink.c   |  5 +-
 drivers/net/netdevsim/dev.c                   | 14 ++--
 include/net/devlink.h                         | 12 +---
 net/core/devlink.c                            | 64 ++++++-------------
 net/dsa/dsa2.c                                | 17 +++--
 11 files changed, 97 insertions(+), 95 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a812beb46325..babaccf92b23 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -685,6 +685,9 @@ static void bnxt_dl_params_unregister(struct bnxt *bp)
 
 int bnxt_dl_register(struct bnxt *bp)
 {
+	struct devlink_port_attrs attrs = {};
+	const unsigned char *switch_id;
+	unsigned char switch_id_len;
 	struct devlink *dl;
 	int rc;
 
@@ -713,9 +716,13 @@ int bnxt_dl_register(struct bnxt *bp)
 	if (!BNXT_PF(bp))
 		return 0;
 
-	devlink_port_attrs_set(&bp->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       bp->pf.port_id, false, 0, bp->dsn,
-			       sizeof(bp->dsn));
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = bp->pf.port_id;
+	switch_id = bp->dsn;
+	switch_id_len = sizeof(bp->dsn);
+	memcpy(attrs.switch_id.id, switch_id, switch_id_len);
+	attrs.switch_id.id_len = switch_id_len;
+	devlink_port_attrs_set(&bp->dl_port, &attrs);
 	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
 	if (rc) {
 		netdev_err(bp->dev, "devlink_port_register failed\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index a73d06e06b5d..69715a0cbfe8 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -312,6 +312,7 @@ int ice_devlink_create_port(struct ice_pf *pf)
 	struct devlink *devlink = priv_to_devlink(pf);
 	struct ice_vsi *vsi = ice_get_main_vsi(pf);
 	struct device *dev = ice_pf_to_dev(pf);
+	struct devlink_port_attrs attrs = {};
 	int err;
 
 	if (!vsi) {
@@ -319,8 +320,9 @@ int ice_devlink_create_port(struct ice_pf *pf)
 		return -EIO;
 	}
 
-	devlink_port_attrs_set(&pf->devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       pf->hw.pf_id, false, 0, NULL, 0);
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = pf->hw.pf_id;
+	devlink_port_attrs_set(&pf->devlink_port, &attrs);
 	err = devlink_port_register(devlink, &pf->devlink_port, pf->hw.pf_id);
 	if (err) {
 		dev_err(dev, "devlink_port_register failed: %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index f8b2de4b04be..a69c62d72d16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -6,17 +6,16 @@
 int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 {
 	struct devlink *devlink = priv_to_devlink(priv->mdev);
+	struct devlink_port_attrs attrs = {};
 
-	if (mlx5_core_is_pf(priv->mdev))
-		devlink_port_attrs_set(&priv->dl_port,
-				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       PCI_FUNC(priv->mdev->pdev->devfn),
-				       false, 0,
-				       NULL, 0);
-	else
-		devlink_port_attrs_set(&priv->dl_port,
-				       DEVLINK_PORT_FLAVOUR_VIRTUAL,
-				       0, false, 0, NULL, 0);
+	if (mlx5_core_is_pf(priv->mdev)) {
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		attrs.phys.port_number = PCI_FUNC(priv->mdev->pdev->devfn);
+	} else {
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_VIRTUAL;
+	}
+
+	devlink_port_attrs_set(&priv->dl_port, &attrs);
 
 	return devlink_port_register(devlink, &priv->dl_port, 1);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index af89a4803c7d..e6f467037c5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1193,8 +1193,11 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 {
 	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	struct devlink_port_attrs attrs = {};
 	struct netdev_phys_item_id ppid = {};
 	unsigned int dl_port_index = 0;
+	const unsigned char *switch_id;
+	unsigned char switch_id_len;
 	u16 pfnum;
 
 	if (!is_devlink_port_supported(dev, rpriv))
@@ -1203,19 +1206,18 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
 	dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
 	pfnum = PCI_FUNC(dev->pdev->devfn);
-
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = pfnum;
+	switch_id = &ppid.id[0];
+	switch_id_len = ppid.id_len;
+	memcpy(attrs.switch_id.id, switch_id, switch_id_len);
+	attrs.switch_id.id_len = switch_id_len;
 	if (rep->vport == MLX5_VPORT_UPLINK)
-		devlink_port_attrs_set(&rpriv->dl_port,
-				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       pfnum, false, 0,
-				       &ppid.id[0], ppid.id_len);
+		devlink_port_attrs_set(&rpriv->dl_port, &attrs);
 	else if (rep->vport == MLX5_VPORT_PF)
-		devlink_port_attrs_pci_pf_set(&rpriv->dl_port,
-					      &ppid.id[0], ppid.id_len,
-					      pfnum);
+		devlink_port_attrs_pci_pf_set(&rpriv->dl_port, pfnum);
 	else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport))
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
-					      &ppid.id[0], ppid.id_len,
 					      pfnum, rep->vport - 1);
 
 	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e9ccd333f61d..bbe7358d4ea5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2129,12 +2129,17 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 	struct mlxsw_core_port *mlxsw_core_port =
 					&mlxsw_core->ports[local_port];
 	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
+	struct devlink_port_attrs attrs = {};
 	int err;
 
+	attrs.split = split;
+	attrs.flavour = flavour;
+	attrs.phys.port_number = port_number;
+	attrs.phys.split_subport_number = split_port_subnumber;
+	memcpy(attrs.switch_id.id, switch_id, switch_id_len);
+	attrs.switch_id.id_len = switch_id_len;
 	mlxsw_core_port->local_port = local_port;
-	devlink_port_attrs_set(devlink_port, flavour, port_number,
-			       split, split_port_subnumber,
-			       switch_id, switch_id_len);
+	devlink_port_attrs_set(devlink_port, &attrs);
 	err = devlink_port_register(devlink, devlink_port, local_port);
 	if (err)
 		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 07dbf4d72227..71f4e624b3db 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -353,6 +353,7 @@ const struct devlink_ops nfp_devlink_ops = {
 
 int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 {
+	struct devlink_port_attrs attrs = {};
 	struct nfp_eth_table_port eth_port;
 	struct devlink *devlink;
 	const u8 *serial;
@@ -365,10 +366,14 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 	if (ret)
 		return ret;
 
+	attrs.split = eth_port.is_split;
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = eth_port.label_port;
+	attrs.phys.split_subport_number = eth_port.label_subport;
 	serial_len = nfp_cpp_serial(port->app->cpp, &serial);
-	devlink_port_attrs_set(&port->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       eth_port.label_port, eth_port.is_split,
-			       eth_port.label_subport, serial, serial_len);
+	memcpy(attrs.switch_id.id, serial, serial_len);
+	attrs.switch_id.id_len = serial_len;
+	devlink_port_attrs_set(&port->dl_port, &attrs);
 
 	devlink = priv_to_devlink(app->pf);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 273c889faaad..aa224d0cfa54 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -69,6 +69,7 @@ void ionic_devlink_free(struct ionic *ionic)
 int ionic_devlink_register(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
+	struct devlink_port_attrs attrs = {};
 	int err;
 
 	err = devlink_register(dl, ionic->dev);
@@ -81,8 +82,8 @@ int ionic_devlink_register(struct ionic *ionic)
 	if (ionic->is_mgmt_nic)
 		return 0;
 
-	devlink_port_attrs_set(&ionic->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       0, false, 0, NULL, 0);
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	devlink_port_attrs_set(&ionic->dl_port, &attrs);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
 	if (err)
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ec6b6f7818ac..d88316ea8684 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -889,8 +889,11 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 			       unsigned int port_index)
 {
+	struct devlink_port_attrs attrs = {};
 	struct nsim_dev_port *nsim_dev_port;
 	struct devlink_port *devlink_port;
+	const unsigned char *switch_id;
+	unsigned char switch_id_len;
 	int err;
 
 	nsim_dev_port = kzalloc(sizeof(*nsim_dev_port), GFP_KERNEL);
@@ -899,10 +902,13 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	nsim_dev_port->port_index = port_index;
 
 	devlink_port = &nsim_dev_port->devlink_port;
-	devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       port_index + 1, 0, 0,
-			       nsim_dev->switch_id.id,
-			       nsim_dev->switch_id.id_len);
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = port_index + 1;
+	switch_id = nsim_dev->switch_id.id;
+	switch_id_len = nsim_dev->switch_id.id_len;
+	memcpy(attrs.switch_id.id, switch_id, switch_id_len);
+	attrs.switch_id.id_len = switch_id_len;
+	devlink_port_attrs_set(devlink_port, &attrs);
 	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
 				    port_index);
 	if (err)
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 4d840997690a..96fe5c05f62f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1158,17 +1158,9 @@ void devlink_port_type_ib_set(struct devlink_port *devlink_port,
 			      struct ib_device *ibdev);
 void devlink_port_type_clear(struct devlink_port *devlink_port);
 void devlink_port_attrs_set(struct devlink_port *devlink_port,
-			    enum devlink_port_flavour flavour,
-			    u32 port_number, bool split,
-			    u32 split_subport_number,
-			    const unsigned char *switch_id,
-			    unsigned char switch_id_len);
-void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
-				   const unsigned char *switch_id,
-				   unsigned char switch_id_len, u16 pf);
+			    struct devlink_port_attrs *devlink_port_attrs);
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf);
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
-				   const unsigned char *switch_id,
-				   unsigned char switch_id_len,
 				   u16 pf, u16 vf);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index c4507fd9fc11..6a783e712794 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7377,9 +7377,7 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
 static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
-				    enum devlink_port_flavour flavour,
-				    const unsigned char *switch_id,
-				    unsigned char switch_id_len)
+				    enum devlink_port_flavour flavour)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 
@@ -7387,12 +7385,10 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
 		return -EEXIST;
 	devlink_port->attrs_set = true;
 	attrs->flavour = flavour;
-	if (switch_id) {
+	if (attrs->switch_id.id) {
 		devlink_port->switch_port = true;
-		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
-			switch_id_len = MAX_PHYS_ITEM_ID_LEN;
-		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
-		attrs->switch_id.id_len = switch_id_len;
+		if (WARN_ON(attrs->switch_id.id_len > MAX_PHYS_ITEM_ID_LEN))
+			attrs->switch_id.id_len = MAX_PHYS_ITEM_ID_LEN;
 	} else {
 		devlink_port->switch_port = false;
 	}
@@ -7403,33 +7399,27 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
  *	devlink_port_attrs_set - Set port attributes
  *
  *	@devlink_port: devlink port
- *	@flavour: flavour of the port
- *	@port_number: number of the port that is facing user, for example
- *	              the front panel port number
- *	@split: indicates if this is split port
- *	@split_subport_number: if the port is split, this is the number
- *	                       of subport.
- *	@switch_id: if the port is part of switch, this is buffer with ID,
- *	            otwerwise this is NULL
- *	@switch_id_len: length of the switch_id buffer
+ *	@devlink_port_attrs: devlink port attributes, holds:
+ *			     @flavour: flavour of the port
+ *			     @port_number: number of the port that is facing
+ *					   user, for example the front panel
+ *			                   port number
+ *			     @split: indicates if this is split port
+ *			     @split_subport_number: if the port is split, this
+ *			                            is the number of subport.
+ *			     @switch_id: if the port is part of switch, this is
+ *					 buffer with ID, otherwise this is NULL
+ *			     @switch_id_len: length of the switch_id buffer
  */
 void devlink_port_attrs_set(struct devlink_port *devlink_port,
-			    enum devlink_port_flavour flavour,
-			    u32 port_number, bool split,
-			    u32 split_subport_number,
-			    const unsigned char *switch_id,
-			    unsigned char switch_id_len)
+			    struct devlink_port_attrs *attrs)
 {
-	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	ret = __devlink_port_attrs_set(devlink_port, flavour,
-				       switch_id, switch_id_len);
+	ret = __devlink_port_attrs_set(devlink_port, attrs->flavour);
 	if (ret)
 		return;
-	attrs->split = split;
-	attrs->phys.port_number = port_number;
-	attrs->phys.split_subport_number = split_subport_number;
+	devlink_port->attrs = *attrs;
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
 
@@ -7438,20 +7428,14 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
  *
  *	@devlink_port: devlink port
  *	@pf: associated PF for the devlink port instance
- *	@switch_id: if the port is part of switch, this is buffer with ID,
- *	            otherwise this is NULL
- *	@switch_id_len: length of the switch_id buffer
  */
-void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
-				   const unsigned char *switch_id,
-				   unsigned char switch_id_len, u16 pf)
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
 	ret = __devlink_port_attrs_set(devlink_port,
-				       DEVLINK_PORT_FLAVOUR_PCI_PF,
-				       switch_id, switch_id_len);
+				       DEVLINK_PORT_FLAVOUR_PCI_PF);
 	if (ret)
 		return;
 
@@ -7465,21 +7449,15 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
  *	@devlink_port: devlink port
  *	@pf: associated PF for the devlink port instance
  *	@vf: associated VF of a PF for the devlink port instance
- *	@switch_id: if the port is part of switch, this is buffer with ID,
- *	            otherwise this is NULL
- *	@switch_id_len: length of the switch_id buffer
  */
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
-				   const unsigned char *switch_id,
-				   unsigned char switch_id_len,
 				   u16 pf, u16 vf)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
 	ret = __devlink_port_attrs_set(devlink_port,
-				       DEVLINK_PORT_FLAVOUR_PCI_VF,
-				       switch_id, switch_id_len);
+				       DEVLINK_PORT_FLAVOUR_PCI_VF);
 	if (ret)
 		return;
 	attrs->pci_vf.pf = pf;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 076908fdd29b..e055efff390b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -261,10 +261,15 @@ static int dsa_port_setup(struct dsa_port *dp)
 	struct devlink_port *dlp = &dp->devlink_port;
 	bool dsa_port_link_registered = false;
 	bool devlink_port_registered = false;
+	struct devlink_port_attrs attrs = {};
 	struct devlink *dl = ds->devlink;
 	bool dsa_port_enabled = false;
 	int err = 0;
 
+	attrs.phys.port_number = dp->index;
+	memcpy(attrs.switch_id.id, id, len);
+	attrs.switch_id.id_len = len;
+
 	if (dp->setup)
 		return 0;
 
@@ -274,8 +279,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		memset(dlp, 0, sizeof(*dlp));
-		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_CPU,
-				       dp->index, false, 0, id, len);
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
+		devlink_port_attrs_set(dlp, &attrs);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
 			break;
@@ -294,8 +299,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_DSA:
 		memset(dlp, 0, sizeof(*dlp));
-		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_DSA,
-				       dp->index, false, 0, id, len);
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
+		devlink_port_attrs_set(dlp, &attrs);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
 			break;
@@ -314,8 +319,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_USER:
 		memset(dlp, 0, sizeof(*dlp));
-		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       dp->index, false, 0, id, len);
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		devlink_port_attrs_set(dlp, &attrs);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
 			break;
-- 
2.20.1

