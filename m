Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5C846473E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346978AbhLAGkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346945AbhLAGkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9663BC061746
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:37:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DF580CE1D6C
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD761C53FD4;
        Wed,  1 Dec 2021 06:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340643;
        bh=YVA5neNvYwuCofrrNf/4zY+2i9okT2uJWDEj2cuB2eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BpLjODzoWaee+kpsE+uZtmOvMIWldzE2typMW04N8FgfEoP0jyDxAgwYd/JHFdngP
         EbaRBmfTlGpValtSKUuC+L4AefuIdsrAIPVGGpMsF9FCx+ZvFPIh+56DgVw8zBFw+L
         +dtMNq1a+seh/hKCAOcH8mLrRa6YMtNeyQDBAIqM2q3zzUPCKinwmaJIqvITtna2z7
         W+n8vHqGyyCdIIx0t9DjsTk/Z8g/6nZxh8RhJlYfhAaGSMUaFUD9OfkwxyhiD5UmRL
         r3lEfRx8IU0Vp7pl7KMYMSjoNJdX2Hi3VTlQ1NHFQnM/Wwn21xrqJ+nlY8ddIb25cC
         7mm36qciS4Sag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/13] net/mlx5: Move MODIFY_RQT command to ignore list in internal error state
Date:   Tue, 30 Nov 2021 22:37:00 -0800
Message-Id: <20211201063709.229103-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

When the device is in internal error state, command interface isn't
accessible and the driver decides which commands to fail and which
to ignore.

Move the MODIFY_RQT command to the ignore list in order to avoid
the following redundant warning messages in internal error state:

mlx5_core 0000:82:00.1: mlx5e_rss_disable:419:(pid 23754): Failed to redirect RQT 0x0 to drop RQ 0xc00848: err = -5
mlx5_core 0000:82:00.1: mlx5e_rx_res_channels_deactivate:598:(pid 23754): Failed to redirect direct RQT 0x1 to drop RQ 0xc00848 (channel 0): err = -5
mlx5_core 0000:82:00.1: mlx5e_rx_res_channels_deactivate:607:(pid 23754): Failed to redirect XSK RQT 0x19 to drop RQ 0xc00848 (channel 0): err = -5

Fixes: 43ec0f41fa73 ("net/mlx5e: Hide all implementation details of mlx5e_rx_res")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 8eaa24d865c5..a46284ca5172 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -341,6 +341,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_DEALLOC_SF:
 	case MLX5_CMD_OP_DESTROY_UCTX:
 	case MLX5_CMD_OP_DESTROY_UMEM:
+	case MLX5_CMD_OP_MODIFY_RQT:
 		return MLX5_CMD_STAT_OK;
 
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
@@ -446,7 +447,6 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_MODIFY_TIS:
 	case MLX5_CMD_OP_QUERY_TIS:
 	case MLX5_CMD_OP_CREATE_RQT:
-	case MLX5_CMD_OP_MODIFY_RQT:
 	case MLX5_CMD_OP_QUERY_RQT:
 
 	case MLX5_CMD_OP_CREATE_FLOW_TABLE:
-- 
2.31.1

