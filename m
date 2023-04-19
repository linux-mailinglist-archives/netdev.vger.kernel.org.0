Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FB46E7C46
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjDSOWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjDSOWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:22:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D622689
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:22:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+CSA4SFbUfHV+08IdFvCozlkqIuiW+LOBXRrBNOKOsU+PGIj84hQ4X+blaLBLVmDgB8PGgZP8KK31/uA7BjxQirGSMa2oGpG/baqPBgAz4KfVEouJzyjNRzrnd/hXng+rVX/6rbGyiiXBHtKGuVFc0rdRpuZRMJ5035A9SpMFcghqSoVJrmEv65ExkZbAYYH0CxHPZJH7k25n9UhVd70AQAqizp3mUm18OD/OuMsFqoFBA4OrclXIkyXVw7OxixN0l+YJwb2YXmtbn6ODxbVebQAc3WtblnqheTPmpyipl+opd54qOldOkotvQ4z2bJX1E/7C7y761kRos9FPIJ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o6nmZu0aTDSCv0NPhNQqgTr9K48plAIOCPm+2GzkfD8=;
 b=nYy2SOzddmdLGSKEhJjAcBHSlyIXR8sXP0GK5G0MB3lpRUjeZvoOv9uB2Y5s3+ch2lnc9bio8w60i7KQJvZz+qdtJMUxV3UDt9gF7/P9Pt8ZbJk/SVQFuIEPAsunEzDeJ4GkDoyjSY7FGCebqzGKr/KeXqdIBiuGALnU6Rc7mKr9TxhvqyqLxxldxw7EPaM4j77uCDZoJBNRLwToAX8BzTghCj01GGnKgLF9OF98qLcNs+VKQ3hkDMsNyYOc03vRJBsPgn2DCJrg6BBcO6lLbjSiy+HNrCx8k9yJR2+/FoEHbXqJsAPicC+guqzU0R9uTAyIvsZ4mN+ZxYN8nagl8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6nmZu0aTDSCv0NPhNQqgTr9K48plAIOCPm+2GzkfD8=;
 b=HOeUulWa+9rHKpqDl6wFh/QgkGm3m/pof70guDa1znVIti+Uty7Um2b/NvvridEWM8SImNHK68A5r0Jxr2oEBr0nJZkG1kd9E/MRVG0lJr/51yvkAPjowUf0f+4qldwYMtzVEcujO4aa5y1E/QTrsHt7Cw5Oe4glbN5Ht1XYXzmRuOmiZuxzxBC6cGEOTd7b27vGWAt9jsQJv/uDTmVZqBMIDl7rWqyuGIwAwk2NVeS4EvPdwhCyRX8jFc7Ze8k4gPZoFjmLUH6bbxqBBRbwpJhliHPfs5o8C8VT1e2bJtICSA8wgJsZhE4/doTBM3/rlLvhI2zEDVPj2I6KaegnJA==
Received: from BN9PR03CA0516.namprd03.prod.outlook.com (2603:10b6:408:131::11)
 by SA1PR12MB6917.namprd12.prod.outlook.com (2603:10b6:806:24c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 14:21:59 +0000
Received: from BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::d8) by BN9PR03CA0516.outlook.office365.com
 (2603:10b6:408:131::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 14:21:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT087.mail.protection.outlook.com (10.13.177.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 14:21:58 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 19 Apr 2023
 07:21:45 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 19 Apr
 2023 07:21:44 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Wed, 19 Apr
 2023 07:21:42 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v7 3/5] net/mlx5: Support MACsec over VLAN
Date:   Wed, 19 Apr 2023 17:21:24 +0300
Message-ID: <20230419142126.9788-4-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230419142126.9788-1-ehakim@nvidia.com>
References: <20230419142126.9788-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT087:EE_|SA1PR12MB6917:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fc8e656-0818-40b1-1365-08db40e16fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rfevc+CaBACg5MUfdgQBuXSFpwWK9cR8AQE1BkuJqD6SbvWh5VEV4/AfYBbwL5gZ/TZIoV/esk2nME+nU90FU74glOKJl1bvne/Pw6ubwydqFzMhM1KwWNpZcSFb7DokMr9nrPceQ0d2raygFvivegKBziSQTf9QLqTWe60cwXr0xzFMyAedh6aNy0cmMlaLnVE/oZHBITGJm7ShpctceiTWmaZ5jM5eTQfJdRz2tFUCdwFIZYpfI8T7pTsBgpX8jPbQyekKO8vCf602uDEPxJGBz+9I/DVnhjgrPn3cW0SHmWFLnuZm5zZqsXIwgdwYRd769eK3PKeNoz97OnwoubPG4Wnf6J4oUKgVtr6Cw99EtbU7QdX/XahEym5oplOUQ8AkOmH/fimB5Q57TJoJ2x4rzgr+6s6XQhUG3IuCWdEVJH+k5wKXn4FPt4Ykb95U03Fh9HqJW0mquKbholWzUeZPW85fNVSxeAb35hO9ze83rEcHorIY9bXHeRjpfI28PqX+DKTG3EDNhI5EkfatByT2pKjDsdN6g+Xe3JHsPT/0Ii8xQasIffrxBEMVcwEzD6Hh2PWF+yWIQ6E47TL9EpcJQKN8icTuA3KTvWt75u13r61wj3tZHzCgJXkkqTtdGd8p3WY/OOw1o8J7+0X1yrn8bGwRxnlGDAVBkRrGupwosc4gE3GR94pyDLts+yFpcG0GZkkN/vea+5JlDA9w2c6eQT9f22F3Z6F2JiigyuUOAozpI9HAvp6i8wqZtyGGvn/w4Y4/LTknVmMJT6J09w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199021)(46966006)(36840700001)(40470700004)(478600001)(6666004)(8936002)(34070700002)(8676002)(316002)(82740400003)(41300700001)(4326008)(70586007)(70206006)(40480700001)(54906003)(7636003)(110136005)(356005)(186003)(40460700003)(107886003)(2906002)(36756003)(1076003)(26005)(83380400001)(426003)(86362001)(336012)(47076005)(82310400005)(2616005)(5660300002)(36860700001)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:21:58.9997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc8e656-0818-40b1-1365-08db40e16fe3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6917
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
index 33b3620ea45c..f3428dbeb298 100644
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
 
+static struct mlx5e_priv *macsec_netdev_priv(const struct net_device *dev)
+{
+#if IS_ENABLED(CONFIG_VLAN_8021Q)
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
 
@@ -508,9 +518,9 @@ static void update_macsec_epn(struct mlx5e_macsec_sa *sa, const struct macsec_ke
 
 static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 {
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	const struct macsec_secy *secy = ctx->secy;
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -583,9 +593,9 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 
 static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 {
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
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

