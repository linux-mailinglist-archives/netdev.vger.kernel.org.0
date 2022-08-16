Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87AB65959F4
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiHPLYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiHPLYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:24:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628BF5E309
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:38:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4CEE7CE174E
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D10C43470;
        Tue, 16 Aug 2022 10:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646316;
        bh=jv+/YdoUNho/r29ut2lCepjJb+zIXqKRS78kxkuJxtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R66rHA+QqbX9LMUA8IsakwspkfmLXmLSTEMeDtFrKCeDhfWThknqs4qyyQM7lWWUI
         iRLyZaczOKrcoLSmPDbYonh7SYBR6cYoc7SXn3wEawDF1LNPHNePYvsr0jNTgg02zH
         +VYm1ZfQjhP3154dSUUmQQ8SzAYL5wxL4RfFt6u7v6r5er/O7lvIcfAFzt7Tc+XIL5
         neDf9m+AV5iHoe7nJYBQnHxGSZsfODARXL0xIB/x8CSgXKmr1jhQPsosCswCEO2c6E
         U7Hx922IP7zLnv9kUrg8b0iG8KKur4CmAyFyOmvEZrM4KdKO2A84tJ9lS41nQqkvL6
         4Ks/gmHsFt3mA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 05/26] net/mlx5e: Store replay window in XFRM attributes
Date:   Tue, 16 Aug 2022 13:37:53 +0300
Message-Id: <ae810bab3fe006c4ffecb98663eddf7d4a7bc66b.1660641154.git.leonro@nvidia.com>
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

As a preparation for future extension of IPsec hardware object to allow
configuration of full offload mode, extend the XFRM validator to check
replay window values.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 12 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index c182b640b80d..e811f0d18b2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -169,6 +169,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 		attrs->esn = sa_entry->esn_state.esn;
 		if (sa_entry->esn_state.overlap)
 			attrs->flags |= MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP;
+		attrs->replay_window = x->replay_esn->replay_window;
 	}
 
 	/* action */
@@ -260,6 +261,17 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		netdev_info(netdev, "Unsupported xfrm offload type\n");
 		return -EINVAL;
 	}
+	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
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
index feea909d76c6..de064c72b87d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -83,6 +83,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 	} daddr;
 
 	u8 is_ipv6;
+	u32 replay_window;
 };
 
 enum mlx5_ipsec_cap {
-- 
2.37.2

