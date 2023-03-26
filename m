Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D1B6C92F6
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 09:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCZH1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 03:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjCZH1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 03:27:42 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2069.outbound.protection.outlook.com [40.107.100.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9A0A5D7
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 00:27:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3BrY0csriJLome30LRZCgacpId6vj8F5RpdYPZI8q/ENzL7lXItar0dRgk6Rzo60Njy4z/qHr68H5bkJiWffMve/PomJNWcGyMqPXQkBSMC1bao+Y3oR3Poi0MYorlw4NTr6pgZS0C+YWPmlLvCG0VIXlhiI/JkNz3t3qGvpI9T9faj2SB05/4RgsMevEgnzcLyZ1Sf7y7RW9/eDT4PQ8wylHV6uzSLbFa4YyQn7arqD2O7xB9LUYk/smpSv9ppam+dDWATz3jizG/75UfQKabTtyhZATQUFIJYBVY/hxH5M1cAtEXDDuX6A5ifjwaXKsC4dDg+wwacF59f0FsKxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilVh48J336QMuSyptZNSlZeeGBgjH+0xdgyRUHh4FAY=;
 b=V01HJx+uJGuTzCLyaYv4xHzp4yS78dxCIKwb9pQRZfHSNjm7bPoMXTCD8WOpl2nU/v2s0Cyapb3PBwhB01ZSo5UJqhQ7bYYRh1eeTWd1eiL1PNSQ3CqVlr8RFIpbvpt5ha5SGYFlZwXmyzlqvixebWZHQHrbfzl16lZCEsQIyOEzNffl1AjYQxqBntDfXzdJWkRszT9CvEn6OwpYGm3b1PpEs71bg1kTl3B73owk/l5N5pEu/LMLbE3ibdv5LXir8OvuL+s/a9/V47zd2QHGblgAKW4c1nwTXOx5JyvqlREZs5kaO4z6PIdaJZEgCRNmGw74icwgYM2K9y8zK3ZCMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilVh48J336QMuSyptZNSlZeeGBgjH+0xdgyRUHh4FAY=;
 b=hvTpaD2cvRj2UFdd6hajpeMYfBYd47x1AJUtOLR69KglVSnISAjQDhOufLNB7hiwT82yVIUP1KAaval7+1Mbo7JWs2KXD5ycJkKbWH5SyDF6yhZb0KMdRuWk/teMgsTD82Bn1P/FKQyZFVkYAuDN/bFeFNkeYfNtFzGV66hqryDKArZCLT/A1lIwGhgS2aFNaY45aB7Gj0U65Y0/Mjn6OE6u08AsOl/WWQH+Jd6rEEHrC01Mhhj66YclpiUQ8zaZyunJaZq8ROGtiXhvGHEvHcfxP/9Ox6LDbUqcZhaXQu8rRmIxFHtvSvXD58/detDe1/Yr5ucZJML71RypC+vk9w==
Received: from MW4PR03CA0197.namprd03.prod.outlook.com (2603:10b6:303:b8::22)
 by PH7PR12MB5950.namprd12.prod.outlook.com (2603:10b6:510:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 07:27:38 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::55) by MW4PR03CA0197.outlook.office365.com
 (2603:10b6:303:b8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Sun, 26 Mar 2023 07:27:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Sun, 26 Mar 2023 07:27:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 26 Mar 2023
 00:27:31 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sun, 26 Mar 2023 00:27:31 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Sun, 26 Mar
 2023 00:27:29 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 2/4] net/mlx5: Support MACsec over VLAN
Date:   Sun, 26 Mar 2023 10:26:34 +0300
Message-ID: <20230326072636.3507-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230326072636.3507-1-ehakim@nvidia.com>
References: <20230326072636.3507-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|PH7PR12MB5950:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ea05687-3eae-4202-b378-08db2dcb93e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 553zmrWqnzQKAem6RVjYtgGV6qjY9b9ECFXNtDQc31xk83GdzJ+RMLPfIe66JLHET9Dmq9anbRZR/syBtOak42Qxpeogx6xoZ7iddXeXTReSgTDmdIDJZD5Qzx49i3mwhZPl90W7jZm6igibFVlgAqrUsJS/UEnxEH94nrCSAmpEgKVWEuJ88DttiHOVfuArQQpKHKJtmKf0cyVsMcV/PlA1qc/6O3mg9wUWqSf3CVEtXuRfCI6gXDm5kzWVGgeA2TYF0TqR+LdLMajQSpqwDA3lyCOoLDfBQ5P0ygnxrIg8bhmyzmoe8R9HAA+MqGSTYBx/RN1qRDZJMXJqWTN0kZlJqbb2TAcVEZ6Zzeld723WCY/dGF2rFmV1H1M7DKQgkwQQMHkWmIyrgn7NiLyhNFJyBZWfqrb6KwwoG9rWY8rESU1m0LAfc84ACmEFuGTUNE7HuCNk/L0uoe0necspPTynRaLI53YHTkAK5nmfPSUZlK1AjNbn3GiodTogJt46zkztzi8emkfmRTOxy99EQ2ZiZuAb4J6Qj0dPecDwI4I07etmTTtc3Rty6yQKjzY4ggHIp4EIO82kjYdYO/X4lDwz4LGVEB/c26bXOO/WlXGiLLz1xxxLEnknFkdbL5TSYklobQVKKRCk1V2mEdSx4VbsfsOlE+E2UnWMwuVltGCNQSyA+p15pJhOzfEPRYu1XdCyS9yQm0X+H2F+0fYBE7qQ3XQ4xxaP5qE6NY3dKNCCNKC+GL6obb8F76iY/sI9p0Bj710S4Ayfa0uYOBBDjQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(7696005)(8936002)(41300700001)(186003)(6666004)(107886003)(5660300002)(478600001)(1076003)(26005)(2616005)(4326008)(336012)(8676002)(70206006)(70586007)(54906003)(47076005)(426003)(83380400001)(316002)(110136005)(82740400003)(36860700001)(7636003)(34020700004)(82310400005)(2906002)(356005)(36756003)(40480700001)(40460700003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 07:27:38.4838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea05687-3eae-4202-b378-08db2dcb93e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5950
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

