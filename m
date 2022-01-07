Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9109E486ED6
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344294AbiAGAaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344193AbiAGAaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4362C034002
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 510C061DE7
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24EFC36AE0;
        Fri,  7 Jan 2022 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515416;
        bh=CXF7YgN8rWIh/A1lHmUGgrLsHdmZvBV5WpSSbmPnT3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aR88AQt6OOIoNS29Kie0M4i/9ewXFwBBjY3wf6CQkKu/rR+8zRgYQVVz42GJsD2g9
         4KSi4Ee7Ax0L3v+JqjvKAT+4jKTOfK01PGCwuBzydHid1GU9m4LshQatpI8GbaEnCR
         pkpkD+PB7qKrNjtFZp4MhY/tE+r8N+ro3YNfV/WQ+o+xWbcEE6db0/kDBZZlxiw2eq
         TfgECoOLxwF4we9vNijAXkiwwpi2L1uPTqusT7qFMJpyXMNhODGzrLA8MvQTgI7AwR
         NxJDC/P/ipXxlvqjbTaJje3gaMTVuQGY0SXZrKkdDFxBN1sUvQrdZ3V29gQUO6peb7
         qX2FTfkmlL+JQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 12/15] net/mlx5e: Refactor set_pflag_cqe_based_moder
Date:   Thu,  6 Jan 2022 16:29:53 -0800
Message-Id: <20220107002956.74849-13-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Rearrange the code and use cqe_mode_to_period_mode() helper.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 536fcb2c5e90..57d755db1cf5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1883,24 +1883,19 @@ static int set_pflag_cqe_based_moder(struct net_device *netdev, bool enable,
 				     bool is_rx_cq)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5e_params new_params;
-	bool mode_changed;
 	u8 cq_period_mode, current_cq_period_mode;
+	struct mlx5e_params new_params;
+
+	if (enable && !MLX5_CAP_GEN(priv->mdev, cq_period_start_from_cqe))
+		return -EOPNOTSUPP;
+
+	cq_period_mode = cqe_mode_to_period_mode(enable);
 
-	cq_period_mode = enable ?
-		MLX5_CQ_PERIOD_MODE_START_FROM_CQE :
-		MLX5_CQ_PERIOD_MODE_START_FROM_EQE;
 	current_cq_period_mode = is_rx_cq ?
 		priv->channels.params.rx_cq_moderation.cq_period_mode :
 		priv->channels.params.tx_cq_moderation.cq_period_mode;
-	mode_changed = cq_period_mode != current_cq_period_mode;
-
-	if (cq_period_mode == MLX5_CQ_PERIOD_MODE_START_FROM_CQE &&
-	    !MLX5_CAP_GEN(mdev, cq_period_start_from_cqe))
-		return -EOPNOTSUPP;
 
-	if (!mode_changed)
+	if (cq_period_mode == current_cq_period_mode)
 		return 0;
 
 	new_params = priv->channels.params;
-- 
2.33.1

