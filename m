Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCD2543BDD
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbiFHS70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiFHS7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:59:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ECD3AA5A
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 11:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E75061C43
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E16EC34116;
        Wed,  8 Jun 2022 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654714756;
        bh=EETfE/n6kUmG1QcAkgO3z9o4bg4CHY8Jxq4D90qcF6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHX4BaoufGrmHyJ2Bv9akNAxgBVMwbWx1gHCrSkWEvr6nwWMeuEc6PfUVpxZfndWv
         BsZkmKkqfOBpIeANDkASPo4JbZU+D9N8E77Eb/mBbyeJaUwiKOnfsGubfgNms5Rg/0
         VieAAwxR4BpLjj7seyhlvMK5AtYiSoc0u6XVpbdT8v4wDFRnXL3BICayXSyZRj/Jqa
         ArtBW09dKbEw6XKOwYL9S+2uGnoLZgzkFizMp7G0fBguG7ksqVNabCMckqz/gR47Rn
         IcZjfPHbbd41XN7x23KwbFBEPV+XObaJ7yibWlM0Hy/2XgX7oqDuBKBaZ69PC24FyA
         I64+2QbtbPDgA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/6] Revert "net/mlx5e: Allow relaxed ordering over VFs"
Date:   Wed,  8 Jun 2022 11:58:51 -0700
Message-Id: <20220608185855.19818-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608185855.19818-1-saeed@kernel.org>
References: <20220608185855.19818-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

FW is not ready, fix was sent too soon.
This reverts commit f05ec8d9d0d62367b6e1f2cb50d7d2a45e7747cf.

Fixes: f05ec8d9d0d6 ("net/mlx5e: Allow relaxed ordering over VFs")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 68364484a435..3c1edfa33aa7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -565,7 +565,8 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 static u8 rq_end_pad_mode(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
 	bool lro_en = params->packet_merge.type == MLX5E_PACKET_MERGE_LRO;
-	bool ro = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
+	bool ro = pcie_relaxed_ordering_enabled(mdev->pdev) &&
+		MLX5_CAP_GEN(mdev, relaxed_ordering_write);
 
 	return ro && lro_en ?
 		MLX5_WQ_END_PAD_MODE_NONE : MLX5_WQ_END_PAD_MODE_ALIGN;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 43a536cb81db..c0f409c195bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -38,11 +38,12 @@
 
 void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
 {
+	bool ro_pci_enable = pcie_relaxed_ordering_enabled(mdev->pdev);
 	bool ro_write = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
 	bool ro_read = MLX5_CAP_GEN(mdev, relaxed_ordering_read);
 
-	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_read);
-	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_write);
+	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_pci_enable && ro_read);
+	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_pci_enable && ro_write);
 }
 
 static int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-- 
2.36.1

