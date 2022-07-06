Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128E35695C9
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiGFXYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbiGFXYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4C12C115
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEED961EC2
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7F1C3411C;
        Wed,  6 Jul 2022 23:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149876;
        bh=FBHIq1Qt98YHnUDmTNVX34zCxwdvSynXZrPuxI/Iktk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/zP/4yIZftjG3gi48S8lv8tHlYP+S7fTSrHy0AX1/hV8U1KxnV1DyI8SbH7R7UYm
         InQSrLuKGkWzun05HubEUm6zn3w1Aql3sXRKl60LhQebRxMVSrke8U050SNIKHegWd
         2yjjsAY59gY2Bq9+zXIJlULK/LkdUHHhTlFpxxMMTdz4oHJldQlWA3J0IjmZhMqi/n
         fswptIFIRY7EfwapYi11ohP5pahwXuWndgDtuwyAKGXGRll3BO9m1ySh09+1+zhVmF
         j2CQqWQ1QIucBfpOgLbE/It0gzt9FUb2U/KBTxltyrL9mefKXMeLk0DwPeRsDvKYAB
         FmQHWLR2A77qw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: kTLS, Introduce TLS-specific create TIS
Date:   Wed,  6 Jul 2022 16:24:18 -0700
Message-Id: <20220706232421.41269-13-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706232421.41269-1-saeed@kernel.org>
References: <20220706232421.41269-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

TLS TIS objects have a defined role in mapping and reaching the HW TLS
contexts.  Some standard TIS attributes (like LAG port affinity) are
not relevant for them.

Use a dedicated TLS TIS create function instead of the generic
mlx5e_create_tis.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index cc5cb3010e64..2cd0437666d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -39,16 +39,20 @@ u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 	return stop_room;
 }
 
+static void mlx5e_ktls_set_tisc(struct mlx5_core_dev *mdev, void *tisc)
+{
+	MLX5_SET(tisc, tisc, tls_en, 1);
+	MLX5_SET(tisc, tisc, pd, mdev->mlx5e_res.hw_objs.pdn);
+	MLX5_SET(tisc, tisc, transport_domain, mdev->mlx5e_res.hw_objs.td.tdn);
+}
+
 static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
 {
 	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
-	void *tisc;
-
-	tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
 
-	MLX5_SET(tisc, tisc, tls_en, 1);
+	mlx5e_ktls_set_tisc(mdev, MLX5_ADDR_OF(create_tis_in, in, ctx));
 
-	return mlx5e_create_tis(mdev, in, tisn);
+	return mlx5_core_create_tis(mdev, in, tisn);
 }
 
 struct mlx5e_ktls_offload_context_tx {
-- 
2.36.1

