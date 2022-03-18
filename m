Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3214DE2F5
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240888AbiCRUyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237255AbiCRUyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF25FDF47
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BEE560CA0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4BFC340F3;
        Fri, 18 Mar 2022 20:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636796;
        bh=6VkgdcoaDx13hSgLW0sXX4QQBOG5rag/ZDUYekCAUFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKQPRaZSAp9wqSSdF0NF1bE/H5sv4Trm37b4QNhA3v6aHMSRi3K2R09+EHDZ2R87U
         8IZbdMaXPQNLtDL1Ony3//b+tfaiO4fPPDtLBNz3I+HBiOVPYORE8KCdDkX0dl4FuK
         Hd7GZoxU4kC9CWapn+Hncy4g2auJlWMOeSv1WvKr/RDwaF1wlGg79398eqZzmhvPqt
         MbX/Oy2zfXkv3pgm1InpqZRgUMRMkRsbt5OBMQ0/mOIZxuCEndZUJwqHeixjfJ4q3g
         Jp8IWogmtZx+KRmdo6Y4DO4lgXh8voA0XB0U0KI/YB4ECdph9CxNaFbBYrzma4/jTi
         LvMKPVpd5OQEg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Remove MLX5E_XDP_TX_DS_COUNT
Date:   Fri, 18 Mar 2022 13:52:46 -0700
Message-Id: <20220318205248.33367-14-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

After introducing multi-buffer XDP_TX, the MLX5E_XDP_TX_DS_COUNT define
became misleading. It's no longer the DS count of an XDP_TX WQE, this
WQE can be longer because of fragments.

As this define is only used at one place in mlx5e_open_xdpsq(), it's
also not very useful anymore. This commit removes the define and puts
the calculation of ds_count for prefilled single-fragment WQEs inline.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h  | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 4868fa1b82d1..287e17911251 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -38,7 +38,6 @@
 #include "en/txrx.h"
 
 #define MLX5E_XDP_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
-#define MLX5E_XDP_TX_DS_COUNT (MLX5E_TX_WQE_EMPTY_DS_COUNT + 1 /* SG DS */)
 
 #define MLX5E_XDP_INLINE_WQE_MAX_DS_CNT 16
 #define MLX5E_XDP_INLINE_WQE_SZ_THRSD \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3256d2c375c3..2f1dedc721d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1681,7 +1681,7 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	mlx5e_set_xmit_fp(sq, param->is_mpw);
 
 	if (!param->is_mpw && !test_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state)) {
-		unsigned int ds_cnt = MLX5E_XDP_TX_DS_COUNT;
+		unsigned int ds_cnt = MLX5E_TX_WQE_EMPTY_DS_COUNT + 1;
 		unsigned int inline_hdr_sz = 0;
 		int i;
 
-- 
2.35.1

