Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778A935E718
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbhDMTbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345927AbhDMTaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77110613C8;
        Tue, 13 Apr 2021 19:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342235;
        bh=sKuR+rJ4IRJZcQDSgbkci2cAffADDuo6nYHvWjTfOM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mztPtryqE7FEQb0Yj5+60Q75zTZab+Ye03Bd+ZNInft99U+H4vsxGd/DxvQxxFVdg
         dzZALRA3RZ5+NOZ8S7nmQDFIcL97Uq67Uh8A2flxc1l3ImMAURpYttnPmdZhcED5Xl
         0zbV154J1v10jy1JU5IfQRT7z15lW4eidgQt3/9cSiQIRPA28JSXVAbKIAS1om4SkI
         2oTg663O/TVV7Tmdt3TEM0JxCMPFBA0AQxIG9TyTT/oj8LH+hXEsAN2fjF6fQPbrtE
         EPN08rkiQcIV4YZ8L6iBg/5WPLuPeeh4A4vKCqNj0M2nAv1R5IR5vq1V3H3I6Y+Z6R
         pS6PkNBxiLjMA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Colin Ian King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/16] net/mlx5: Fix bit-wise and with zero
Date:   Tue, 13 Apr 2021 12:30:02 -0700
Message-Id: <20210413193006.21650-13-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
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

