Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AE367271C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjARSgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjARSgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54BF58971
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F6F9B81EA0
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FC6C433F0;
        Wed, 18 Jan 2023 18:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066968;
        bh=lVaefuWBHGY6BUj/L7v09vf3blSClJR61NBSRzyYaVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiptl7HcFkQN1Vu9w4VInN63eciLxJBUzR4COEzHZNDQqOK1Y31iO//GyBhdwqXUY
         YwfKnsY7jaCqFq+xj6Dyp/2uJOEvNWNn6p2zK/6GcO4ZA+NOnK44FtsIAE7I76HmlK
         BvgfXDvDnflR/thuXAVvmmjOedK5g63a7jQBDN1g2iQCMBfmYFeJC7E/b8LRp2hp4C
         LyJSvz20VE/TNurGzqB2Nl4X4X6x54plW86a2/95MY6vz8DWqcXdD2/LkhgTeoe4Gm
         0VYClxIUGWWsQJeQaaTDO6HzZsFqDZe2hIDHSzSDt+yn91VkSxuDfNqh9DYvR7E/fs
         PDGSNSIqXyshw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: [net-next 01/15] net/mlx5e: Suppress Send WQEBB room warning for PAGE_SIZE >= 16KB
Date:   Wed, 18 Jan 2023 10:35:48 -0800
Message-Id: <20230118183602.124323-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Send WQEBB size is 64 bytes and the max number of WQEBBs for an SQ is 255.
For 16KB pages and greater, there is always sufficient spaces for all
WQEBBs of an SQ. Cast mlx5e_get_max_sq_wqebbs(mdev) to u16. Prevents
-Wtautological-constant-out-of-range-compare warnings from occurring when
PAGE_SIZE >= 16KB.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 853f312cd757..5578f92f7e0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -445,7 +445,7 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 
 static inline u16 mlx5e_stop_room_for_wqe(struct mlx5_core_dev *mdev, u16 wqe_size)
 {
-	WARN_ON_ONCE(PAGE_SIZE / MLX5_SEND_WQE_BB < mlx5e_get_max_sq_wqebbs(mdev));
+	WARN_ON_ONCE(PAGE_SIZE / MLX5_SEND_WQE_BB < (u16)mlx5e_get_max_sq_wqebbs(mdev));
 
 	/* A WQE must not cross the page boundary, hence two conditions:
 	 * 1. Its size must not exceed the page size.
-- 
2.39.0

