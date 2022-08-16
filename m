Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6FB595A06
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiHPL0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiHPLZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036C2E0FC7
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04A3160FF0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE4DC433D6;
        Tue, 16 Aug 2022 10:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646454;
        bh=32o1nNL7d06gMese5okE+EZ7cGlitpH//gZhUDpeihs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFoyDFbChoBR2Rf2qHoemu+N+aLC5k8ksH75EdFLafT3UKD2BNgtd+OthocOa4MyU
         jCXylc7I3oVpRS8Uc4rB42G9IN0R1wbKK/v1bdn+HU5nHle00f217ZTUJiIAqR5smG
         qBp0z70g2IjNBvrdGdq9jQDbzlIM/h8ID+aPDJA1pUJQvK6ycNWM4bD3rmnyeNjoi5
         TsGNmAT6wXUIIwM6mrm7RDv6NI8A0F4oNevYXLnrMRIYUhNpt5lnTnt4c5paxoyplD
         /IOzWYMRRCzxyQdFcGs0detBiJjyyEvWx5UdSiddGnAoTL3ADjUmVLBb6Zbqvh2+qK
         /jAcKDd/jB5eA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 23/26] net/mlx5e: Improve IPsec flow steering autogroup
Date:   Tue, 16 Aug 2022 13:38:11 +0300
Message-Id: <2a23ff0f742dfa9948c627f310c88614579c2025.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Flow steering API separates newly created rules based on their
match criteria. Right now, all IPsec tables are created with one
group and suffers from not-optimal FS performance.

Count number of different match criteria for relevant tables, and
set proper value at the table creation.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c   | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index a047b1d6a016..c6e6652f5890 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -202,7 +202,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 
 	/* Create FT */
 	ft = ipsec_ft_create(mdev, ipsec->fs->ns, MLX5E_ACCEL_FS_ESP_FT_LEVEL,
-			     MLX5E_NIC_PRIO, 1, XFRM_DEV_OFFLOAD_IN);
+			     MLX5E_NIC_PRIO, 2, XFRM_DEV_OFFLOAD_IN);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_fs_ft;
@@ -214,7 +214,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		goto err_fs;
 
 	ft = ipsec_ft_create(mdev, ipsec->fs->ns, MLX5E_ACCEL_FS_POL_FT_LEVEL,
-			     MLX5E_NIC_PRIO, 1, XFRM_DEV_OFFLOAD_IN);
+			     MLX5E_NIC_PRIO, 2, XFRM_DEV_OFFLOAD_IN);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_pol_ft;
@@ -311,13 +311,13 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx)
 	struct mlx5_flow_table *ft;
 	int err;
 
-	ft = ipsec_ft_create(mdev, tx->ns, 1, 0, 1, XFRM_DEV_OFFLOAD_OUT);
+	ft = ipsec_ft_create(mdev, tx->ns, 1, 0, 4, XFRM_DEV_OFFLOAD_OUT);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
 	tx->ft.sa = ft;
 
-	ft = ipsec_ft_create(mdev, tx->ns, 0, 0, 1, XFRM_DEV_OFFLOAD_OUT);
+	ft = ipsec_ft_create(mdev, tx->ns, 0, 0, 2, XFRM_DEV_OFFLOAD_OUT);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_pol_ft;
-- 
2.37.2

