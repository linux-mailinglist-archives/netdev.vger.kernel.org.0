Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C153B506881
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350585AbiDSKRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350568AbiDSKRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:17:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF762657D
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AB41B815D1
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983B4C385A7;
        Tue, 19 Apr 2022 10:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363266;
        bh=miOfMWF46TvcJNsKpDDTIJk++be6ROtIFEmwJ80HLWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpSRlGD+hD9fMpBJEircuHNd8Zp1epJ5ylDwzXpn9FuonyK3av4Xyr9FiFRWgWD+i
         UK8w6+viKvVz/cd5C1R31OhrBtaZS1VSrNIQsZGrG895kSqejddKYKfW72x/GXjMlV
         7jugxUtJaNYE2S7V3nu50emgq3pEVgOyFztazQP1PhF4yLpT4N1GJbWAVSg25Ww+DR
         ptb5UNpvxmH549R2vfvvCZaqm58EOPFcJYJyL0zQuE+6adibs0adBzxSrI1gFj+lvH
         hfAhcKGa1R9r0VBLVINteeZhmVSvgxxOp+0DJyO5Ny2eQpvPeZMaIIn/RsSrfS1KYr
         6iomhO5MwHylg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 08/17] net/mlx5: Remove indirections from esp functions
Date:   Tue, 19 Apr 2022 13:13:44 +0300
Message-Id: <27e097f3cb8f89f83e017001991485169b72b5d9.1650363043.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1650363043.git.leonro@nvidia.com>
References: <cover.1650363043.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This change cleanups the mlx5 esp interface.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mlx5/core/en_accel/ipsec_offload.c        | 47 +++++--------------
 1 file changed, 12 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 6c03ce8aba92..a7bd31d10bd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -61,9 +61,9 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
-static struct mlx5_accel_esp_xfrm *
-mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
-				   const struct mlx5_accel_esp_xfrm_attrs *attrs)
+struct mlx5_accel_esp_xfrm *
+mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
+			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
 
@@ -74,10 +74,11 @@ mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
 	memcpy(&mxfrm->accel_xfrm.attrs, attrs,
 	       sizeof(mxfrm->accel_xfrm.attrs));
 
+	mxfrm->accel_xfrm.mdev = mdev;
 	return &mxfrm->accel_xfrm;
 }
 
-static void mlx5_ipsec_offload_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
+void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
 {
 	struct mlx5_ipsec_esp_xfrm *mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm,
 							 accel_xfrm);
@@ -275,14 +276,13 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
-static void mlx5_ipsec_offload_esp_modify_xfrm(
-	struct mlx5_accel_esp_xfrm *xfrm,
-	const struct mlx5_accel_esp_xfrm_attrs *attrs)
+void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+				const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
 	struct mlx5_core_dev *mdev = xfrm->mdev;
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
-	int err = 0;
+	int err;
 
 	mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
 
@@ -294,8 +294,10 @@ static void mlx5_ipsec_offload_esp_modify_xfrm(
 				    &ipsec_attrs,
 				    mxfrm->sa_ctx->ipsec_obj_id);
 
-	if (!err)
-		memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
+	if (err)
+		return;
+
+	memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
 }
 
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
@@ -321,28 +323,3 @@ void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context)
 {
 	mlx5_ipsec_offload_delete_sa_ctx(context);
 }
-
-struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	struct mlx5_accel_esp_xfrm *xfrm;
-
-	xfrm = mlx5_ipsec_offload_esp_create_xfrm(mdev, attrs);
-	if (IS_ERR(xfrm))
-		return xfrm;
-
-	xfrm->mdev = mdev;
-	return xfrm;
-}
-
-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
-{
-	mlx5_ipsec_offload_esp_destroy_xfrm(xfrm);
-}
-
-void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-				const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	mlx5_ipsec_offload_esp_modify_xfrm(xfrm, attrs);
-}
-- 
2.35.1

