Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C7F6CD945
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjC2MVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjC2MVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:21:34 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C175D49EC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:21:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkCu8H1z+akmqw7vRz/Ry76LtWQmRM/bz2oCYWePpVkOsEipMsx6ZJe9hpChGSWlLEobCfWFz3mvbbYZuvrD0B/nM1q/IcVFiCSJnbgNBJ7GNOWQv3fqvacd0qQryIFmwhcsfqtJD1B7ZW00A7DQUGlzPG1LP3nmzZxlhzpTPFbdatax9huG2ABWRh0nlujfFTEVX4RYyt+E5DYOaRKGJnT2yoi8g+GL/ZMlDc3WhXgDKjptnoaUowScAeEOTSl/pdw8yB02vSU32bcKQ1RilrAAHGT0WzH4K0OawRvqFdlzup7LX2THYygDWYJQZr9ME252gDzkm7rd1TFsxs1Y4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilVh48J336QMuSyptZNSlZeeGBgjH+0xdgyRUHh4FAY=;
 b=fFXkG0NR7eUjC8Jrwe4OwoTyBBilYFHeH/dAW4/JXf3bpBPvXbBo0rmIYMKJFtGTRVR/uUwXKI8btr2hoybFpxTgx4s7AafXfpt1VCK+mNiGY8Ce/5xH5Z2UvynKSnXkByAswyum1ZQxyrELLVWlzhNB3AqdYB0BtHRyFGvySmxLV68wefp78GMEPJQwIQKuYbei5RwmM5fATb2IkQgMoT6d0vNod53kNebWwEKEhTRQqF80gePLOT7mTTRqs8gnVqd8Aabd7tUFMD/te7PfjJqSMmCaGm+K2mlnv1yZKaMThsfjHtX23WxaSb7tr7TiJICvjYo6Anx8VDlEThYyZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilVh48J336QMuSyptZNSlZeeGBgjH+0xdgyRUHh4FAY=;
 b=AYS8gkWhX/CGPaZrX6xnAyWKpI4Zwvb/1OUyADTr/Yfy4OhgKt/FPXUi0Qx0TtmDPN4WAIlBl9yiE6L98BkO6di5TnUz2n0BVPHHhnAX8DqheTItROn4UZ/AwZH9M04DsIHsUukm4dRD6BSsB1oGiCWH0y1D4UKVEn0kKjTL6IR7OSAPTPEjGLpBCcwyB/BbqhCC6RZCys8ZLApIQZZk1ILHoslAvcmCQscFZY5Ajy1EY/LCmIQ5Ozr5P/JCeJazF7BM7KRNDOTVAolpOdALFtWIX41HSOtto4CEwK7HXRIcGCGGXymCdKC+G+FkfTgt6n4Ul7Tv2ZEalVUOe9+3Nw==
Received: from DS7PR06CA0020.namprd06.prod.outlook.com (2603:10b6:8:2a::21) by
 PH8PR12MB7025.namprd12.prod.outlook.com (2603:10b6:510:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 12:21:28 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::e6) by DS7PR06CA0020.outlook.office365.com
 (2603:10b6:8:2a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Wed, 29 Mar 2023 12:21:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Wed, 29 Mar 2023 12:21:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 29 Mar 2023
 05:21:20 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 29 Mar 2023 05:21:19 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Wed, 29 Mar
 2023 05:21:17 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 2/4] net/mlx5: Support MACsec over VLAN
Date:   Wed, 29 Mar 2023 15:21:05 +0300
Message-ID: <20230329122107.22658-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230329122107.22658-1-ehakim@nvidia.com>
References: <20230329122107.22658-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT022:EE_|PH8PR12MB7025:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ab542ab-e2a7-497b-3895-08db30501f1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fsnM7+uiReKqjcd6hDKm35ciBt0VACQyAxWu9CG8nD5VJxHzJsUpXKTf1tn32YcJWxRwJKnuzLI7dMmRP6Nrv+YOLUKLJyT2FvDsrkwgzvRNrZY+xskizRFbXFo7pnkP7GMttMWykx6HWwYatY2YmxrR2AI+dRs27lKpma8LdaX8nJPSZQ0ReXVw9i/IhVWXBu2T6raatD6yCZN4D16pGsiBvnXzpGZ5UjRdoAPm9j4uqOcXBQ4YSh93ldTGSxbTWtfI79l/cinoX0V4XTqjTpdifrYXfLSHMX+wKz3Q5g+4pHI+Rq4BneXERG0/p66k6RK3CDOaP7mREbhWXG2mkR+4ZGYL257MYkWHSRHRxZgVVMOrGyT64rKSAf02jFte+a4X8JLjTg59gGBOfn/oNeXLxCdRciIbu41XBiABo8Ab38kPnfiPbKeqQk0YZ+y2tyuywWk0IqF2f/oW5H/BvkaucJ1N8bzUaqM3hxqI7XfDwCVUCwNfFDXGLnTmXG3pBUYq/vwSlVKdFniVhyrtbuyXEAsPIM7mxlnayXhlo8fAbMGkGXrMXCpbramtkch6cTILJlhn31SIp5mhGSJPddktvM+26m1GzUPkOoO4wImdaeXa5i9AZxXFIwEcS+EWqyy96wuPjg6jlGkwqZFjgONd9RH9Pw8yhMH45hEsV1fdiwZZr/8+OnP2oEmSLajhLO1e5f0AdvnmZNtkR0IvJkwTfTh4JeOYyUiCbQGpt+wO3DcUds5X5rqKRhRSwiWV9kE2ChCgr4mL5awHlJrDrg==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199021)(40470700004)(46966006)(36840700001)(6666004)(107886003)(7696005)(1076003)(26005)(316002)(54906003)(110136005)(478600001)(34020700004)(2616005)(186003)(47076005)(36860700001)(70586007)(426003)(336012)(70206006)(83380400001)(8676002)(41300700001)(8936002)(356005)(4326008)(5660300002)(7636003)(2906002)(82740400003)(40460700003)(86362001)(40480700001)(82310400005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 12:21:27.9151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ab542ab-e2a7-497b-3895-08db30501f1f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7025
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MACsec device may have a VLAN device on top of it.
Detect MACsec state correctly under this condition,
and return the correct net device accordingly.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 42 ++++++++++++-------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 33b3620ea45c..f1646fa6737d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -4,6 +4,7 @@
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/xarray.h>
+#include <linux/if_vlan.h>
 
 #include "en.h"
 #include "lib/aso.h"
@@ -348,12 +349,21 @@ static void mlx5e_macsec_cleanup_sa(struct mlx5e_macsec *macsec,
 	sa->macsec_rule = NULL;
 }
 
+static inline struct mlx5e_priv *macsec_netdev_priv(const struct net_device *dev)
+{
+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
+	if (is_vlan_dev(dev))
+		return netdev_priv(vlan_dev_priv(dev)->real_dev);
+#endif
+	return netdev_priv(dev);
+}
+
 static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 				struct mlx5e_macsec_sa *sa,
 				bool encrypt,
 				bool is_tx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec *macsec = priv->macsec;
 	struct mlx5_macsec_rule_attrs rule_attrs;
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -427,7 +437,7 @@ static int macsec_rx_sa_active_update(struct macsec_context *ctx,
 				      struct mlx5e_macsec_sa *rx_sa,
 				      bool active)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec *macsec = priv->macsec;
 	int err = 0;
 
@@ -510,7 +520,7 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 {
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_secy *secy = ctx->secy;
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -585,7 +595,7 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 {
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_sa *tx_sa;
@@ -645,7 +655,7 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 
 static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_sa *tx_sa;
@@ -696,7 +706,7 @@ static u32 mlx5e_macsec_get_sa_from_hashtable(struct rhashtable *sci_hash, sci_t
 static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 {
 	struct mlx5e_macsec_rx_sc_xarray_element *sc_xarray_element;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sc *ctx_rx_sc = ctx->rx_sc;
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc;
@@ -776,7 +786,7 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 
 static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sc *ctx_rx_sc = ctx->rx_sc;
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc;
@@ -854,7 +864,7 @@ static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec
 
 static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc;
 	struct mlx5e_macsec *macsec;
@@ -890,8 +900,8 @@ static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 
 static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
 {
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sa *ctx_rx_sa = ctx->sa.rx_sa;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 assoc_num = ctx->sa.assoc_num;
@@ -976,8 +986,8 @@ static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
 
 static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 {
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sa *ctx_rx_sa = ctx->sa.rx_sa;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_rx_sc *rx_sc;
@@ -1033,7 +1043,7 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 
 static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	sci_t sci = ctx->sa.rx_sa->sc->sci;
 	struct mlx5e_macsec_rx_sc *rx_sc;
@@ -1085,7 +1095,7 @@ static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 
 static int mlx5e_macsec_add_secy(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct net_device *dev = ctx->secy->netdev;
 	const struct net_device *netdev = ctx->netdev;
 	struct mlx5e_macsec_device *macsec_device;
@@ -1137,7 +1147,7 @@ static int mlx5e_macsec_add_secy(struct macsec_context *ctx)
 static int macsec_upd_secy_hw_address(struct macsec_context *ctx,
 				      struct mlx5e_macsec_device *macsec_device)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct net_device *dev = ctx->secy->netdev;
 	struct mlx5e_macsec *macsec = priv->macsec;
 	struct mlx5e_macsec_rx_sc *rx_sc, *tmp;
@@ -1184,8 +1194,8 @@ static int macsec_upd_secy_hw_address(struct macsec_context *ctx,
  */
 static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
 {
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	const struct net_device *dev = ctx->secy->netdev;
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_sa *tx_sa;
@@ -1240,7 +1250,7 @@ static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
 
 static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc, *tmp;
 	struct mlx5e_macsec_sa *tx_sa;
@@ -1741,7 +1751,7 @@ void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev,
 {
 	struct mlx5e_macsec_rx_sc_xarray_element *sc_xarray_element;
 	u32 macsec_meta_data = be32_to_cpu(cqe->ft_metadata);
-	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(netdev);
 	struct mlx5e_macsec_rx_sc *rx_sc;
 	struct mlx5e_macsec *macsec;
 	u32  fs_id;
-- 
2.21.3

