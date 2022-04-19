Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9529506890
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350604AbiDSKRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350712AbiDSKRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:17:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8176EA18B
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A9E3B815D8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516DDC385A5;
        Tue, 19 Apr 2022 10:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363289;
        bh=Xc7AVgxaOyXzO7SUoxSwgODdwCH9tGwQ6N0xMsFz5L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7EyFUmAPeTwxDCxO+Dl0MTZslCH75UAusD8Xmuh9P3osVmxsb6hjIG4cc3WD0YHx
         JK+6C/wXAUJTJCISSUgzX+6aPAOvOgpItPmEhv/OvvgQwPkEo8dNnmSdTFDPeb1j43
         EzelXig83ACOL4sGz06ij12Sk510dgLzFf2uiealVoL0Q0OVK9M2PghD9HgGv4r/j1
         hqmyRvU6NG7GKaOFVWOuXYp6ustaIsE1PxbmUq1+S5+IX8Bc+OEgRr140wwz/MJWof
         QTtOotzUJtTDUoMF+9G0ySSPC+Cm11JBsqBU/rQoGixr1B2p1rhRNwMWgntaZaaqGf
         tngU7nvYrTyyw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 14/17] net/mlx5: Remove not-supported ICV length
Date:   Tue, 19 Apr 2022 13:13:50 +0300
Message-Id: <880da9f1f485f2e542e62be7c30b531672e7aaa3.1650363043.git.leonro@nvidia.com>
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

mlx5 doesn't allow to configure any AEAD ICV length other than 128,
so remove the logic that configures other unsupported values.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c | 17 +----------------
 include/linux/mlx5/mlx5_ifc.h                   |  2 --
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index b44bce3f4ef1..91ec8b8bf1ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -62,22 +62,7 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 	salt_p = MLX5_ADDR_OF(ipsec_obj, obj, salt);
 	memcpy(salt_p, &aes_gcm->salt, sizeof(aes_gcm->salt));
 
-	switch (aes_gcm->icv_len) {
-	case 64:
-		MLX5_SET(ipsec_obj, obj, icv_length,
-			 MLX5_IPSEC_OBJECT_ICV_LEN_8B);
-		break;
-	case 96:
-		MLX5_SET(ipsec_obj, obj, icv_length,
-			 MLX5_IPSEC_OBJECT_ICV_LEN_12B);
-		break;
-	case 128:
-		MLX5_SET(ipsec_obj, obj, icv_length,
-			 MLX5_IPSEC_OBJECT_ICV_LEN_16B);
-		break;
-	default:
-		return -EINVAL;
-	}
+	MLX5_SET(ipsec_obj, obj, icv_length, MLX5_IPSEC_OBJECT_ICV_LEN_16B);
 	salt_iv_p = MLX5_ADDR_OF(ipsec_obj, obj, implicit_iv);
 	memcpy(salt_iv_p, &aes_gcm->seq_iv, sizeof(aes_gcm->seq_iv));
 	/* esn */
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 7d2d0ba82144..1fa4ade54c76 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11383,8 +11383,6 @@ enum {
 
 enum {
 	MLX5_IPSEC_OBJECT_ICV_LEN_16B,
-	MLX5_IPSEC_OBJECT_ICV_LEN_12B,
-	MLX5_IPSEC_OBJECT_ICV_LEN_8B,
 };
 
 struct mlx5_ifc_ipsec_obj_bits {
-- 
2.35.1

