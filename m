Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F93397E1E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFBBjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhFBBjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 21:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E57B7613D6;
        Wed,  2 Jun 2021 01:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622597853;
        bh=9SxytobkgeNl7qIabI0qnRcnfQljhbl2t9keREljCpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNT8rCM5Kwd46KF6p3VNzv1kNVlPuRYWoJ68zHP8Q5oTc5F3jEIX8QuIQV9MtEe4O
         5jF3/aw/+n1YjxR97wkrnutF5ff4p4/PZr8jGRAP8puhwVNDXDQToNGBjFfQzuQrOx
         mFml/Kt0um8BIRLsmZ7G18eycjG4pCPw5dANtEtsLOS5tpbFpLIdINrDFz/8g/P+TH
         jQUaE87rkXjd72yGUhMLkrY8cXaaH8/swpxHwLeemdSKVmtWf6S3dToMPPT+aQ/ZNR
         QC9sBhVsTW3v376S0eaTZec0ikhCH4jomtfdQqyE2SONGXofQG8CNqjPm5mUiP2Osr
         039QI0SyhwzDw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/8] net/mlx5: Check firmware sync reset requested is set before trying to abort it
Date:   Tue,  1 Jun 2021 18:37:18 -0700
Message-Id: <20210602013723.1142650-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602013723.1142650-1-saeed@kernel.org>
References: <20210602013723.1142650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

In case driver sent NACK to firmware on sync reset request, it will get
sync reset abort event while it didn't set sync reset requested mode.
Thus, on abort sync reset event handler, driver should check reset
requested is set before trying to stop sync reset poll.

Fixes: 7dd6df329d4c ("net/mlx5: Handle sync reset abort event")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index d5d57630015f..106b50e42b46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -349,6 +349,9 @@ static void mlx5_sync_reset_abort_event(struct work_struct *work)
 						      reset_abort_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
 
+	if (!test_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags))
+		return;
+
 	mlx5_sync_reset_clear_reset_requested(dev, true);
 	mlx5_core_warn(dev, "PCI Sync FW Update Reset Aborted.\n");
 }
-- 
2.31.1

