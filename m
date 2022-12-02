Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B202C640EEB
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbiLBULW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbiLBULR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0643DF4E95
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A80E0B8228D
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1576C433C1;
        Fri,  2 Dec 2022 20:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011868;
        bh=DkDh/Nj5EH6cjDbVROQy87TUgU5jqCpfnQV39Ds1a4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfkRQuVU2152QqOyLYudwB5dx4vqh4pcpnuX5Qrc0YkmhRc41FUfN8SB8+iE5TOV2
         2edcOctZsoc15+QtdsXyahWaMqdhMLPKrj1+3ORLGOAI4nLMRV1jKxTPr2D+7zXE9k
         U6z7tiT7n3QF/3Vd6WllkTtoOauZY0mMZwIBe+NMw6uMaz9pTugxZEOEr102xIF0L2
         uUfdEecIg8aM5WJkmCCjOtZ4Ywr0K4sYO5Uw7Atb/mIvhrlcnt2DnNtxFcXkcNTIUA
         AUvgd+GCd316wzEzC4DC3flcPS7JNLjSeyEUDSj9OqGzsi9exONr//wP6TcTa2pWUo
         ri6MrOizy0Fng==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 04/16] net/mlx5e: Store replay window in XFRM attributes
Date:   Fri,  2 Dec 2022 22:10:25 +0200
Message-Id: <f8e8106f4056e763d6ee7c49bd3d4534ca0d86bb.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
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

As a preparation for future extension of IPsec hardware object to allow
configuration of packet offload mode, extend the XFRM validator to check
replay window values.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 12 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index e6411533f911..734b486db5d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -166,6 +166,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 		attrs->esn = sa_entry->esn_state.esn;
 		if (sa_entry->esn_state.overlap)
 			attrs->flags |= MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP;
+		attrs->replay_window = x->replay_esn->replay_window;
 	}
 
 	/* action */
@@ -257,6 +258,17 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		netdev_info(netdev, "Unsupported xfrm offload type\n");
 		return -EINVAL;
 	}
+	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
+		if (x->replay_esn && x->replay_esn->replay_window != 32 &&
+		    x->replay_esn->replay_window != 64 &&
+		    x->replay_esn->replay_window != 128 &&
+		    x->replay_esn->replay_window != 256) {
+			netdev_info(netdev,
+				    "Unsupported replay window size %u\n",
+				    x->replay_esn->replay_window);
+			return -EINVAL;
+		}
+	}
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index fa052a89c4dd..6fe55675bee9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -83,6 +83,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 	} daddr;
 
 	u8 is_ipv6;
+	u32 replay_window;
 };
 
 enum mlx5_ipsec_cap {
-- 
2.38.1

