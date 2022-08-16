Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D0D5959FB
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiHPLZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiHPLYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:24:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FBFCD52D
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:38:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBA67B8169E
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18691C433C1;
        Tue, 16 Aug 2022 10:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646328;
        bh=UTXzR5oNk0lEJHBT5h3zfjuT4P6GnTsXO0gVBh+hb3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZ+cYz26pTM5d6fkUX29fxH0mth13DfJPJZI8Z+hQG4uX5XssbkRQStEbZlt/d638
         GTpJqJpvJ3DnLr2jqSxZrSxPzol2BaZO7TOWcjWlmACxZ05CO3uCo/z1rA86PlrCHg
         SsOFu/GwSL7V3tkQ9wv07oDJL+8m0AP5bfymgbGEnl0eXTEcs9HP0txZ5KdbAYs8us
         NLLPMEkU1cOAdnxD6/aIGTpWTZRwNvNHd/4PexmQ5EJFBhX0hV9lh1fdtV2k9JIgMy
         3277sWaJ94W3CoVOW8LQsbsTx9a/M7X1AjhQBoq0vG1bi3tXJT/Tvku4uh3p7rQQE3
         UC3lVYgd77U5g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 04/26] net/mlx5e: Advertise IPsec full offload support
Date:   Tue, 16 Aug 2022 13:37:52 +0300
Message-Id: <c8ea82c205fa8ac6d10bf0a9e38c75e67cfe99c3.1660641154.git.leonro@nvidia.com>
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

Add needed capabilities check to determine if device supports IPsec
full offload mode.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |  1 +
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c        | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 16bcceec16c4..feea909d76c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -88,6 +88,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 enum mlx5_ipsec_cap {
 	MLX5_IPSEC_CAP_CRYPTO		= 1 << 0,
 	MLX5_IPSEC_CAP_ESN		= 1 << 1,
+	MLX5_IPSEC_CAP_FULL_OFFLOAD	= 1 << 2,
 };
 
 struct mlx5e_priv;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 792724ce7336..e93775eb40b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -1,12 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2017, Mellanox Technologies inc. All rights reserved. */
 
+#include <linux/mlx5/eswitch.h>
 #include "mlx5_core.h"
 #include "ipsec.h"
 #include "lib/mlx5.h"
 
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 {
+	bool esw_encap;
 	u32 caps = 0;
 
 	if (!MLX5_CAP_GEN(mdev, ipsec_offload))
@@ -31,6 +33,14 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 	    MLX5_CAP_ETH(mdev, insert_trailer) && MLX5_CAP_ETH(mdev, swp))
 		caps |= MLX5_IPSEC_CAP_CRYPTO;
 
+	esw_encap = mlx5_eswitch_get_encap_mode(mdev) !=
+		    DEVLINK_ESWITCH_ENCAP_MODE_NONE;
+	if (!esw_encap && MLX5_CAP_IPSEC(mdev, ipsec_full_offload) &&
+	    MLX5_CAP_FLOWTABLE_NIC_TX(mdev, reformat_add_esp_trasport) &&
+	    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, reformat_del_esp_trasport) &&
+	    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, decap))
+		caps |= MLX5_IPSEC_CAP_FULL_OFFLOAD;
+
 	if (!caps)
 		return 0;
 
-- 
2.37.2

