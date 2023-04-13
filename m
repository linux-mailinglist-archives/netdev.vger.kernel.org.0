Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C1B6E0D73
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjDMMaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjDMM35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:29:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CE093D6
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 05:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D7A463CA0
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E6FC433A0;
        Thu, 13 Apr 2023 12:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681388994;
        bh=hSg5IXhXxTiwB9P+xvI/7K/RWm7Dlvspk+t0Edzgr+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4f9GWffee73d+Ux2X5xdYKgVMJgOz/AxztoXyB3bksISDwAFG7nLp49Wf23x4yaz
         PfDwnmvRosQ5+hZOxvLEEzRLNQ9Ul/mVvb2wHMi1HEblfun4JeiIXOgWN4RpL1bxcp
         8HzFMOqShrM6gwCcPy8srWUbwyqfrnqfDhvpjvJBbV6sRkYSvEaegAZIiCJnd4CdoF
         Jr76qVrVFxSSLmYwA3p5dcgWXX7IxBbdOOhNLMejViCkZujMswFF5tWFlhKF+3rHAk
         4B3bnTmjKI71Hq9v7y/9VB/almAVrgs7NTkLL0qhxa3aYDwc0xJaAPXhw/lExAd2Tm
         zong8qQkaK78w==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v1 02/10] net/mlx5e: Check IPsec packet offload tunnel capabilities
Date:   Thu, 13 Apr 2023 15:29:20 +0300
Message-Id: <9bc295c93c47710ba69a030c31cce861464164ef.1681388425.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681388425.git.leonro@nvidia.com>
References: <cover.1681388425.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Validate tunnel mode support for IPsec packet offload.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
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

