Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6835FA49
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352331AbhDNSHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352131AbhDNSGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF4F611AD;
        Wed, 14 Apr 2021 18:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423578;
        bh=sKuR+rJ4IRJZcQDSgbkci2cAffADDuo6nYHvWjTfOM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYEaexKkh8+iXhTeNirs3Iv12ImGYwek3PR2jHQgSvtRKMA15ou9BytyhNhVxqy4f
         lwX0wG+ZHm7pbDGaAdvCcYhfH6gstbQeYnANL0unA9epfADxX7HM93X4FBNuWO8f8B
         VFPNuZ8bAlVlE2k6uPk10QW+UjRN5+zyT9tylHPSDqZ4L3sadFe8hJgW5tRahci5vn
         UV4brTeW8LMKNzfDH7j0OSl8qTDmHip3uohw2ITNdyWbHdyFeQg2FvQFvzZtizrd/Y
         wAC3X0IOHPq/EQ6a1JgHYmyJVfgLAci9AE6xOUhxult3ryJ4Al4XuKDzqZIpziDH8A
         vytkREfJsTQMA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Colin Ian King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 12/16] net/mlx5: Fix bit-wise and with zero
Date:   Wed, 14 Apr 2021 11:06:01 -0700
Message-Id: <20210414180605.111070-13-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The bit-wise and of the action field with MLX5_ACCEL_ESP_ACTION_DECRYPT
is incorrect as MLX5_ACCEL_ESP_ACTION_DECRYPT is zero and not intended
to be a bit-flag. Fix this by using the == operator as was originally
intended.

Addresses-Coverity: ("Logically dead code")
Fixes: 7dfee4b1d79e ("net/mlx5: IPsec, Refactor SA handle creation and destruction")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index d43a05e77f67..0b19293cdd74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -850,7 +850,7 @@ mlx5_fpga_ipsec_release_sa_ctx(struct mlx5_fpga_ipsec_sa_ctx *sa_ctx)
 		return;
 	}
 
-	if (sa_ctx->fpga_xfrm->accel_xfrm.attrs.action &
+	if (sa_ctx->fpga_xfrm->accel_xfrm.attrs.action ==
 	    MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		ida_free(&fipsec->halloc, sa_ctx->sa_handle);
 
-- 
2.30.2

