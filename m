Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5471D595A16
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiHPL14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbiHPL0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:26:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81267103608
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB1560FB1
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA9AC433D7;
        Tue, 16 Aug 2022 10:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646487;
        bh=LqRdpGHGQ3aFSJ3gl1hU/HgiVY2tr2Y1aC1u2Ndy4hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nC4XfTARSd0fmztspYyXSlYcDrL02Fk4M1EGwavuP1877axxRvdgIf5uCJ1nXu2Kn
         wNPUR0910Mr0gyddiIbB/BGyAozdxQGeiR9bxRAgrZVdY++H3qoaPdLXH6+NcWtM0U
         kn6cSzCnYZbCGEYN9YAsRwqi79T5SZ0OdoGeG29FNoZkRc8gsIFwl8SYwMTWGZ+gPu
         5jQjqBRpzj2jjDOUWGc+252zZ3ZReVpyb9Vc6GA/JkWcWgn2+f4maGdVN9jXRu4bB4
         epK3NmpbYGNfF6h4vXwtGjQDm7cbuN24hZCaMSn4CvqZeIMm1GytsJdDP/0QSdzSNf
         9ytbsr+DrjkeA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 26/26] net/mlx5e: Open mlx5 driver to accept IPsec full offload
Date:   Tue, 16 Aug 2022 13:38:14 +0300
Message-Id: <4915aeee7df79e5c8a61195ff011a9a64faa7e19.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
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

Enable configuration of IPsec full offload through XFRM state add
interface together with moving specific to IPsec full mode limitations
to specific switch-case section.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 46 +++++++++++++++----
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 6017aaabaabd..b517d105cb55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -219,11 +219,6 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		netdev_info(netdev, "Only IPv4/6 xfrm states may be offloaded\n");
 		return -EINVAL;
 	}
-	if (x->props.mode != XFRM_MODE_TRANSPORT &&
-	    x->props.mode != XFRM_MODE_TUNNEL) {
-		dev_info(&netdev->dev, "Only transport and tunnel xfrm states may be offloaded\n");
-		return -EINVAL;
-	}
 	if (x->id.proto != IPPROTO_ESP) {
 		netdev_info(netdev, "Only ESP xfrm state may be offloaded\n");
 		return -EINVAL;
@@ -257,11 +252,32 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		netdev_info(netdev, "Cannot offload xfrm states with geniv other than seqiv\n");
 		return -EINVAL;
 	}
-	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
-		netdev_info(netdev, "Unsupported xfrm offload type\n");
-		return -EINVAL;
-	}
-	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
+	switch (x->xso.type) {
+	case XFRM_DEV_OFFLOAD_CRYPTO:
+		if (!(mlx5_ipsec_device_caps(priv->mdev) &
+		      MLX5_IPSEC_CAP_CRYPTO)) {
+			netdev_info(netdev, "Crypto offload is not supported\n");
+			return -EINVAL;
+		}
+
+		if (x->props.mode != XFRM_MODE_TRANSPORT &&
+		    x->props.mode != XFRM_MODE_TUNNEL) {
+			netdev_info(netdev, "Only transport and tunnel xfrm states may be offloaded\n");
+			return -EINVAL;
+		}
+		break;
+	case XFRM_DEV_OFFLOAD_FULL:
+		if (!(mlx5_ipsec_device_caps(priv->mdev) &
+		      MLX5_IPSEC_CAP_FULL_OFFLOAD)) {
+			netdev_info(netdev, "Full offload is not supported\n");
+			return -EINVAL;
+		}
+
+		if (x->props.mode != XFRM_MODE_TRANSPORT) {
+			netdev_info(netdev, "Only transport xfrm states may be offloaded in full mode\n");
+			return -EINVAL;
+		}
+
 		if (x->replay_esn && x->replay_esn->replay_window != 32 &&
 		    x->replay_esn->replay_window != 64 &&
 		    x->replay_esn->replay_window != 128 &&
@@ -271,6 +287,16 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 				    x->replay_esn->replay_window);
 			return -EINVAL;
 		}
+
+		if (!x->props.reqid) {
+			netdev_info(netdev, "Cannot ofload without reqid\n");
+			return -EINVAL;
+		}
+		break;
+	default:
+		netdev_info(netdev, "Unsupported xfrm offload type %d\n",
+			    x->xso.type);
+		return -EINVAL;
 	}
 	return 0;
 }
-- 
2.37.2

