Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AC16E0D78
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjDMMab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjDMMaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:30:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7D7A26A
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 05:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2124C63D9B
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3985C433EF;
        Thu, 13 Apr 2023 12:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681389015;
        bh=sW6I9mHFG7ZUP3SbjblGOuYUnNAbLFL5IneN6Lo9o2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5worpXJPMz3eEp6qLMiw+g7iIwCVXrXu/cyEkxyU0ewSYH6Q5KoN+dR66BA0q70W
         OOR6axJenl6pZHaoqpYcY5bFAkxmm8ub8QJ4fFSsn4Q6zA4YpxS5GylEHA/2FXTE/4
         50gKpJQ6ixMLGp3bDzpmf2c2FdPxqMNgfeJ87jZuFjIrTuAHx0fKf613WPfYSUaATt
         ZH5898E8lUJehYKu5qu17uQA/mJgZ3c2xJ/NCFX2L6bTPadsoUOGNp+MCxkBAE71S2
         MEx6hgYtu0OnCMCyinx8eJLel+50NjtEIzmsoKLhwGDyGSuQemp0c3dKmJv2v9LNaO
         6dUZWPw1o4jbw==
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
Subject: [PATCH net-next v1 10/10] net/mlx5e: Accept tunnel mode for IPsec packet offload
Date:   Thu, 13 Apr 2023 15:29:28 +0300
Message-Id: <03b551b18ed893d574c566204373499817e345ff.1681388425.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681388425.git.leonro@nvidia.com>
References: <cover.1681388425.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Open mlx5 driver to accept IPsec tunnel mode.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c  | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 0bda5a91bff6..5fd609d1120e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -422,6 +422,11 @@ static int mlx5e_xfrm_validate_state(struct mlx5_core_dev *mdev,
 		return -EINVAL;
 	}
 
+	if (x->props.mode != XFRM_MODE_TRANSPORT && x->props.mode != XFRM_MODE_TUNNEL) {
+		NL_SET_ERR_MSG_MOD(extack, "Only transport and tunnel xfrm states may be offloaded");
+		return -EINVAL;
+	}
+
 	switch (x->xso.type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
 		if (!(mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO)) {
@@ -429,11 +434,6 @@ static int mlx5e_xfrm_validate_state(struct mlx5_core_dev *mdev,
 			return -EINVAL;
 		}
 
-		if (x->props.mode != XFRM_MODE_TRANSPORT &&
-		    x->props.mode != XFRM_MODE_TUNNEL) {
-			NL_SET_ERR_MSG_MOD(extack, "Only transport and tunnel xfrm states may be offloaded");
-			return -EINVAL;
-		}
 		break;
 	case XFRM_DEV_OFFLOAD_PACKET:
 		if (!(mlx5_ipsec_device_caps(mdev) &
@@ -442,8 +442,9 @@ static int mlx5e_xfrm_validate_state(struct mlx5_core_dev *mdev,
 			return -EINVAL;
 		}
 
-		if (x->props.mode != XFRM_MODE_TRANSPORT) {
-			NL_SET_ERR_MSG_MOD(extack, "Only transport xfrm states may be offloaded in packet mode");
+		if (x->props.mode == XFRM_MODE_TUNNEL &&
+		    !(mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)) {
+			NL_SET_ERR_MSG_MOD(extack, "Packet offload is not supported for tunnel mode");
 			return -EINVAL;
 		}
 
-- 
2.39.2

