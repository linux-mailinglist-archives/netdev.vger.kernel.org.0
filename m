Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFDA6DC37E
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjDJGTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjDJGTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:19:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F9240E0
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 23:19:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EF8D61172
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0491BC433EF;
        Mon, 10 Apr 2023 06:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681107574;
        bh=Pl8D+HIR0GBc445VbBcaIkI1U9YgsN8IVBtJ4TWGmkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7lP0saukjLBCCZfvxaLsAaZ24ABU52mYuR6GYq/ZHBvw+WO4tRUutpCXdMBwfFA6
         fN1wfrPp2hMAh3dwu+2rmltxtptVeRbRWUOqwtND/OAmBO7qEysK14GE8cJxj+kBe+
         hPcFQ0LaEfjjFvaU/m8DrN8dQ8zoJbWPSl4Cx9OSusAb/x1eWoNu3AdF6q/2UNjr6B
         6MV5z3YmLd6fL7d+UvVm1u8xhMw1rmcPVGVTsuO9gEVC9jJ7zidyU9HH5lWPqRporU
         JSt/174uB+N38op0q/PtenVk5aca4cHUzkXh3DJ/k+O8t0z1uaMujEbzeyYBmRKyxd
         wcmrT4c3ehYDQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 02/10] net/mlx5e: Check IPsec packet offload tunnel capabilities
Date:   Mon, 10 Apr 2023 09:19:04 +0300
Message-Id: <e3b42fa8ccd8e1d1cfda9c8d34a198b43c9d7769.1681106636.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681106636.git.leonro@nvidia.com>
References: <cover.1681106636.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Validate tunnel mode support for IPsec packet offload.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h    | 1 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c    | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 52890d7dce6b..bb89e18b17b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -107,6 +107,7 @@ enum mlx5_ipsec_cap {
 	MLX5_IPSEC_CAP_PACKET_OFFLOAD	= 1 << 2,
 	MLX5_IPSEC_CAP_ROCE             = 1 << 3,
 	MLX5_IPSEC_CAP_PRIO             = 1 << 4,
+	MLX5_IPSEC_CAP_TUNNEL           = 1 << 5,
 };
 
 struct mlx5e_priv;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 5fddb86bb35e..df90e19066bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -48,6 +48,12 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 		if (MLX5_CAP_FLOWTABLE_NIC_TX(mdev, ignore_flow_level) &&
 		    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ignore_flow_level))
 			caps |= MLX5_IPSEC_CAP_PRIO;
+
+		if (MLX5_CAP_FLOWTABLE_NIC_TX(mdev,
+					      reformat_l2_to_l3_esp_tunnel) &&
+		    MLX5_CAP_FLOWTABLE_NIC_RX(mdev,
+					      reformat_l3_esp_tunnel_to_l2))
+			caps |= MLX5_IPSEC_CAP_TUNNEL;
 	}
 
 	if (mlx5_get_roce_state(mdev) &&
-- 
2.39.2

