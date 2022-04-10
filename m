Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8390B4FACD2
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbiDJIbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbiDJIbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A112E59A60;
        Sun, 10 Apr 2022 01:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3978D60EFB;
        Sun, 10 Apr 2022 08:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD4AC385A1;
        Sun, 10 Apr 2022 08:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579368;
        bh=owWdIWuokrxjg0T79v/prUJcPlyqUt06p9sx7A9FukM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edR7gz8RFbSlYgOQK3CCT7VWOpAUdZ/I3w7TC28mfiTuX18Rxk481agT+GyIOx00O
         s0CYSqRnNGYYR7whjjRRbQnpvLmSW+QkhudCMN9g5cBsgNpQ/U3VcmL04JqLRLVK2g
         wXf/79elpqkrc7mYTE/0jaMz1f9NIeG+p3RX61IYhloqPy6fdc8IVjOXHrKQdTB793
         Q85PQXN2oZ2UBssYCy1GdAd4U3kYAt3EJq8fjdnxLE6yW/i7YIkSe4tk/fkRjHOAqW
         E6imRpefyti9EHx6awUMMUc+4fh9pTvAmnz0FMURIuuFRGWNQef+rheNCLy0gUBI3V
         goyZ5Du8jhAPg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 12/17] net/mlx5: Don't advertise IPsec netdev support for non-IPsec device
Date:   Sun, 10 Apr 2022 11:28:30 +0300
Message-Id: <822ef440370ca5f6b48816d0dd70cd3bd4ecb192.1649578827.git.leonro@nvidia.com>
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

Device that lacks proper IPsec capabilities won't pass mlx5e_ipsec_init()
later, so no need to advertise HW netdev offload support for something that
isn't going to work anyway.

Fixes: 8ad893e516a7 ("net/mlx5e: Remove dependency in IPsec initialization flows")
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 815c77953a1a..6f93d749b21a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -453,6 +453,9 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct net_device *netdev = priv->netdev;
 
+	if (!mlx5_ipsec_device_caps(mdev))
+		return;
+
 	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
 	    !MLX5_CAP_ETH(mdev, swp)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP and SWP offload not supported\n");
-- 
2.35.1

