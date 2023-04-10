Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256236DC381
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjDJGUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDJGUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:20:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845814695
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 23:19:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 037FC6178A
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FFBC433EF;
        Mon, 10 Apr 2023 06:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681107594;
        bh=/3soQ+SzPa26BA9yjC+L/uZXeiQz7QLmiq6hv0S9VN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6boMnqxtLzrjCbh2cEOevKyfb9ylTkulvj4RswFn/1bRkas+XbFaR89vG0GiS3rp
         2eit26zkaCCzWjOXnO2U8VrmlEXwUmWiDrE5aJt/LPru0yYUtBI7BJ3HrCaUn8x+Al
         TS/5Bufg6coVS9r5Ls4fj75DUf0YTxz83L3N1knoaWYt8i2GJqEbALKgtA4THpsc1d
         g3Nel9E4BXZDmEv9RBR97SQ/2zjV+dunEJBX1mAGfgu8j8ZHKYJrH6i/zN/z6ELFvO
         ZXext5Qqbudu7uFF+lbcQ3ACG4TnMUScPhvvNlXz0R9xFTRn2Iu/qInYtysdWT0NiC
         yl1W411eRcucQ==
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
Subject: [PATCH net-next 10/10] net/mlx5e: Accept tunnel mode for IPsec packet offload
Date:   Mon, 10 Apr 2023 09:19:12 +0300
Message-Id: <46b6e7fdbc597ce9965d88b4a663abd06264d035.1681106636.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681106636.git.leonro@nvidia.com>
References: <cover.1681106636.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
index e95004ac7a20..03fbbf84a1ae 100644
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

