Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456053559B4
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346633AbhDFQyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:54:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40238 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346631AbhDFQyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 12:54:01 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lToxX-00086R-4j; Tue, 06 Apr 2021 16:53:47 +0000
From:   Colin King <colin.king@canonical.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Raed Salem <raeds@nvidia.com>, Huy Nguyen <huyn@mellanox.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5: Fix bit-wise and with zero
Date:   Tue,  6 Apr 2021 17:53:46 +0100
Message-Id: <20210406165346.430535-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
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

