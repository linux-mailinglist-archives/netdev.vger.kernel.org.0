Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21B3506891
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350593AbiDSKRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350646AbiDSKR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:17:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C2D2C661
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9312860EBA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805FFC385A7;
        Tue, 19 Apr 2022 10:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363282;
        bh=pUVdYTTyhzU+nT5kEEb5zUh2QFv9fSm9K9sCQbHOeE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyRk73wDbExBqNzZgks68n+GCxbaG5nMuSoFGaV9Ksm9bO0GyzL4FrCjE//g3vJIl
         dih/WlwtRol0TWo85oQJaB9EJmJ1z05aQ5m8JLXPpNPJ5YggOyxyFLo+zEIkh9Rs9+
         SNL5GsEIeS5YIYNfGrk7ghMZxdSVvT4pRfFr6+hsGxt5aJHl7VHhvPi+tgfv0ni7Yv
         hXkq4KuAgzFAPSRGqyUL25ReWOiR3WXjRJO9+Y/Wl0I2t9J4UPRijYqvADPnP6vaJm
         fxfOrDmIU+BSrkGAYyhP+wP6tNbUTA7mUKCeZFx0/9b2E2o3lGZgbW4aro6oDuZsFP
         39Xj61fMFxNdA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 12/17] net/mlx5: Don't advertise IPsec netdev support for non-IPsec device
Date:   Tue, 19 Apr 2022 13:13:48 +0300
Message-Id: <4691277a248afd7f8663ac677081b4f55c54553a.1650363043.git.leonro@nvidia.com>
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
index 81c9831ad286..28729b1cc6e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -454,6 +454,9 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
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

