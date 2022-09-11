Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4522F5B51FC
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 01:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiIKXlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 19:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIKXlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 19:41:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4772716A
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 16:41:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1F6FB80AE9
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 23:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5854DC433B5;
        Sun, 11 Sep 2022 23:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662939691;
        bh=nosfAFh3LgJ6ZdIHu+YvxFaDr+3ibze7vvwYn09giEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjK6aUcv0coHi6ys6JYFiM0Jv+Lur2jDG0ffWCitrPHcAjKRky7vcwoisghH5TYVn
         b3kkOt1cTLCPcxgFF421vAOgsAskqwt0bV6x07EOgqBt4C6k303O6IT/1GqGHubeDA
         QaJF7m9JeWhDI8wvrkG4c23sdbh3MYUuDky4cLta695dPusa4NQe3sjv7qppuVd9Rd
         uUH7+qhbC7Gkub45tvjWm/zBxeDHtdUCZ2Hgq/HY0W226Vw/X/UZCobIWFVSu58gJe
         4o59xUMn3tXaUZw8YqgCBQEw2nSJ7t7/kC//yXkZUiA1zli4tbZBk42Kp3yZh1zorx
         nzA/UM62PHxLg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 04/10] net/mlx5e: Fix MACsec initial packet number
Date:   Mon, 12 Sep 2022 00:40:53 +0100
Message-Id: <20220911234059.98624-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220911234059.98624-1-saeed@kernel.org>
References: <20220911234059.98624-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Currently when creating MACsec object, next_pn which represents
the initial packet number (PN) is considered only in TX flow.
The above causes mismatch between TX and RX initial PN which
is reflected in packet drops.
Fix by considering next_pn in RX flow too.

Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 7cbccc76798c..006c3bad69a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -107,12 +107,11 @@ static int mlx5e_macsec_create_object(struct mlx5_core_dev *mdev,
 	MLX5_SET64(macsec_offload_obj, obj, sci, (__force u64)(attrs->sci));
 	MLX5_SET(macsec_offload_obj, obj, aso_return_reg, MLX5_MACSEC_ASO_REG_C_4_5);
 	MLX5_SET(macsec_offload_obj, obj, macsec_aso_access_pd, attrs->aso_pdn);
+	MLX5_SET(macsec_aso, aso_ctx, mode_parameter, attrs->next_pn);
 
 	MLX5_SET(macsec_aso, aso_ctx, valid, 0x1);
-	if (is_tx) {
+	if (is_tx)
 		MLX5_SET(macsec_aso, aso_ctx, mode, MLX5_MACSEC_ASO_INC_SN);
-		MLX5_SET(macsec_aso, aso_ctx, mode_parameter, attrs->next_pn);
-	}
 
 	/* general object fields set */
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
-- 
2.37.3

