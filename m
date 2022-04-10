Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78124FACC8
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbiDJIb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbiDJIbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3750C593BD;
        Sun, 10 Apr 2022 01:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C79A760A77;
        Sun, 10 Apr 2022 08:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD27FC385A4;
        Sun, 10 Apr 2022 08:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579376;
        bh=dPj5F3jWU7oaJ5+jc0/mwq6ncq6WT1wcXlxp9pZv354=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yj/SmeGndQckYYqKzwFv4BzKJ1OTB7PDO6RDugtIfhWSgnzzlhPzp1exDOTDoz2Yc
         CR9apVjqjxTArBzz5By8ntXcpxf5Nry5wbkGicniR3HFpwSkCHPSFvsi64s2iCK1G9
         Yuto6N8tCZ0Kxt3pQnNJaHhon+qUMCSoO/wh5fSomXHofchjJ1Jkj4SGoYpCNhkYFn
         FpJW9QNYdCz7GIfkl+Pcder0aB2Dkfoaqy8+bHtllzAUhLCMeltUokYWUz7AG5nc7P
         TRY3ZnH23Pl9gIx8DYzIOZyQ81wFqumhQtg6bZl5OReTaEj04V3gQGCHpkOUTkDiBD
         ojuZSomnFV43A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 14/17] net/mlx5: Remove not-supported ICV length
Date:   Sun, 10 Apr 2022 11:28:32 +0300
Message-Id: <4d8103cc94fc14d1ee72b50065dec3bf98856f0f.1649578827.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649578827.git.leonro@nvidia.com>
References: <cover.1649578827.git.leonro@nvidia.com>
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

mlx5 doesn't allow to configure any AEAD ICV length other than 128,
so remove the logic that configures other unsupported values.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c | 17 +----------------
 include/linux/mlx5/mlx5_ifc.h                   |  2 --
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 1dc8588635e9..4f3ffe5a09fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -63,22 +63,7 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
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

