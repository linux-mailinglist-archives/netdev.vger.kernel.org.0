Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB9352B2A7
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiERGuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiERGuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:50:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC0822BCD
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BE9CB81E96
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365C0C385AA;
        Wed, 18 May 2022 06:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856592;
        bh=YeF48vwfMqZT+mAatIqPMIOYWAV6Chj1cHStzUWJkvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAIYSFLMdkR38yfmrC5fgKh4ud+aXesUjMroIg0YNPC4Pe0elcXSNNpDqdPHx/kJI
         XrBLlao4PxOdvpf9zOjvTAYRSV/U2nr+/qinls2oQToBj3icJhz1voWU/p+e3LuHxX
         U3ibil316uZR579v1qICFr71cK7MsVmmBAZ3BWohERdP/Ns3Hgr8jE38eyVYx82cFu
         cOz1hCTX/09IgmHxGpqR970sD7H0Tlazg43IsUlEfumf4eRnKVIng0B3wbgEm/UfyP
         zharPU7+SaJmlHrD1lq0uHUTufZLe4QIZY72/W/Px1o/WV7ayGxWqkc3oYGvzdxZ4A
         GhOuSzh3uan+A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Marina Varshaver <marinav@nvidia.com>,
        Gal Shalom <galshalom@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/16] net/mlx5e: Allow relaxed ordering over VFs
Date:   Tue, 17 May 2022 23:49:32 -0700
Message-Id: <20220518064938.128220-11-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

By PCI spec, the config space of the VF always report relaxed ordering
not supported while it inherits this property from its PF. Hence using
pcie_relaxed_ordering_enable(), always disables the relaxed ordering on
all VFs. Remove this check and rely on the firmware which queries the
config space of the PF and set the capability bit accordingly.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Marina Varshaver <marinav@nvidia.com>
Reviewed-by: Gal Shalom <galshalom@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 3c1edfa33aa7..68364484a435 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -565,8 +565,7 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 static u8 rq_end_pad_mode(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
 	bool lro_en = params->packet_merge.type == MLX5E_PACKET_MERGE_LRO;
-	bool ro = pcie_relaxed_ordering_enabled(mdev->pdev) &&
-		MLX5_CAP_GEN(mdev, relaxed_ordering_write);
+	bool ro = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
 
 	return ro && lro_en ?
 		MLX5_WQ_END_PAD_MODE_NONE : MLX5_WQ_END_PAD_MODE_ALIGN;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index c0f409c195bf..43a536cb81db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -38,12 +38,11 @@
 
 void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
 {
-	bool ro_pci_enable = pcie_relaxed_ordering_enabled(mdev->pdev);
 	bool ro_write = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
 	bool ro_read = MLX5_CAP_GEN(mdev, relaxed_ordering_read);
 
-	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_pci_enable && ro_read);
-	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_pci_enable && ro_write);
+	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_read);
+	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_write);
 }
 
 static int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-- 
2.36.1

