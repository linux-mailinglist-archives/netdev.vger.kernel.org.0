Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7DA640EFB
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiLBUP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiLBUPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B6A12606
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C29DA623AD
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F3DC433D6;
        Fri,  2 Dec 2022 20:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012122;
        bh=DO8mFI8X0asZHs25RqyXEGhPrYJA5AjMcitwB2vAiqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxScl2vmTtMFNwMA17BWohpZJwXTVK0u7fU9zDpPaCiRi8FKAJwEPCvbGq9zprQp7
         tso7qJp1oHBiCrP7+KnIgCFZJgmUlYDof0DzuUt4Rvju2fb92swyEBPtcUHXci/uOZ
         lX0mU/yDMEVxWpo67uqH/WddxwLTSC7mDUFkXs9to9DPlLxQarTfn5ZP57B3ADXs/s
         aSKmweeS8358x2Y7T0Lv6AsJExUKMpcHdBDKJCc0FXyjHQ9C5KMQ6mDqkEPEjOIWIX
         qgiPWsSwL1yDnX94vd6YDyAtjqdvlCAQCrk07h0WDH4i1IC6cuR/iKvnQ/zUIZhUi4
         FUDmSJwBFSVqQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next 01/13] net/mlx5e: Create IPsec policy offload tables
Date:   Fri,  2 Dec 2022 22:14:45 +0200
Message-Id: <ea8ce2925941d0cda37df4979596894a3c9cd9ac.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Add empty table to be used for IPsec policy offload.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  3 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 53 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  6 +--
 3 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index bf2741eb7f9b..379c6dc9a3be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -84,7 +84,8 @@ enum {
 	MLX5E_ARFS_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 #endif
 #ifdef CONFIG_MLX5_EN_IPSEC
-	MLX5E_ACCEL_FS_ESP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
+	MLX5E_ACCEL_FS_POL_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
+	MLX5E_ACCEL_FS_ESP_FT_LEVEL,
 	MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
 #endif
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 5bc6f9d1f5a6..a3c7d0f142c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -11,6 +11,7 @@
 
 struct mlx5e_ipsec_ft {
 	struct mutex mutex; /* Protect changes to this struct */
+	struct mlx5_flow_table *pol;
 	struct mlx5_flow_table *sa;
 	struct mlx5_flow_table *status;
 	u32 refcnt;
@@ -23,12 +24,14 @@ struct mlx5e_ipsec_miss {
 
 struct mlx5e_ipsec_rx {
 	struct mlx5e_ipsec_ft ft;
+	struct mlx5e_ipsec_miss pol;
 	struct mlx5e_ipsec_miss sa;
 	struct mlx5e_ipsec_rule status;
 };
 
 struct mlx5e_ipsec_tx {
 	struct mlx5e_ipsec_ft ft;
+	struct mlx5e_ipsec_miss pol;
 	struct mlx5_flow_namespace *ns;
 };
 
@@ -157,6 +160,10 @@ static int ipsec_miss_create(struct mlx5_core_dev *mdev,
 
 static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 {
+	mlx5_del_flow_rules(rx->pol.rule);
+	mlx5_destroy_flow_group(rx->pol.group);
+	mlx5_destroy_flow_table(rx->ft.pol);
+
 	mlx5_del_flow_rules(rx->sa.rule);
 	mlx5_destroy_flow_group(rx->sa.group);
 	mlx5_destroy_flow_table(rx->ft.sa);
@@ -200,8 +207,27 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (err)
 		goto err_fs;
 
+	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_POL_FT_LEVEL, MLX5E_NIC_PRIO,
+			     1);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_pol_ft;
+	}
+	rx->ft.pol = ft;
+	memset(&dest, 0x00, sizeof(dest));
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = rx->ft.sa;
+	err = ipsec_miss_create(mdev, rx->ft.pol, &rx->pol, &dest);
+	if (err)
+		goto err_pol_miss;
+
 	return 0;
 
+err_pol_miss:
+	mlx5_destroy_flow_table(rx->ft.pol);
+err_pol_ft:
+	mlx5_del_flow_rules(rx->sa.rule);
+	mlx5_destroy_flow_group(rx->sa.group);
 err_fs:
 	mlx5_destroy_flow_table(rx->ft.sa);
 err_fs_ft:
@@ -236,7 +262,7 @@ static struct mlx5e_ipsec_rx *rx_ft_get(struct mlx5_core_dev *mdev,
 
 	/* connect */
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = rx->ft.sa;
+	dest.ft = rx->ft.pol;
 	mlx5_ttc_fwd_dest(ttc, family2tt(family), &dest);
 
 skip:
@@ -277,14 +303,34 @@ static void rx_ft_put(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 /* IPsec TX flow steering */
 static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx)
 {
+	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_table *ft;
+	int err;
 
-	ft = ipsec_ft_create(tx->ns, 0, 0, 1);
+	ft = ipsec_ft_create(tx->ns, 1, 0, 1);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
 	tx->ft.sa = ft;
+
+	ft = ipsec_ft_create(tx->ns, 0, 0, 1);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_pol_ft;
+	}
+	tx->ft.pol = ft;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = tx->ft.sa;
+	err = ipsec_miss_create(mdev, tx->ft.pol, &tx->pol, &dest);
+	if (err)
+		goto err_pol_miss;
 	return 0;
+
+err_pol_miss:
+	mlx5_destroy_flow_table(tx->ft.pol);
+err_pol_ft:
+	mlx5_destroy_flow_table(tx->ft.sa);
+	return err;
 }
 
 static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5_core_dev *mdev,
@@ -318,6 +364,9 @@ static void tx_ft_put(struct mlx5e_ipsec *ipsec)
 	if (tx->ft.refcnt)
 		goto out;
 
+	mlx5_del_flow_rules(tx->pol.rule);
+	mlx5_destroy_flow_group(tx->pol.group);
+	mlx5_destroy_flow_table(tx->ft.pol);
 	mlx5_destroy_flow_table(tx->ft.sa);
 out:
 	mutex_unlock(&tx->ft.mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d53749248fa0..9995307d374b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -111,8 +111,8 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}} */
-#define KERNEL_NIC_PRIO_NUM_LEVELS 7
+/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}}, IPsec policy */
+#define KERNEL_NIC_PRIO_NUM_LEVELS 8
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc */
 #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
@@ -133,7 +133,7 @@
 #define LAG_MIN_LEVEL (OFFLOADS_MIN_LEVEL + KERNEL_RX_MACSEC_MIN_LEVEL + 1)
 
 #define KERNEL_TX_IPSEC_NUM_PRIOS  1
-#define KERNEL_TX_IPSEC_NUM_LEVELS 1
+#define KERNEL_TX_IPSEC_NUM_LEVELS 2
 #define KERNEL_TX_IPSEC_MIN_LEVEL        (KERNEL_TX_IPSEC_NUM_LEVELS)
 
 #define KERNEL_TX_MACSEC_NUM_PRIOS  1
-- 
2.38.1

