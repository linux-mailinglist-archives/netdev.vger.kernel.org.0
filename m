Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B1C2EB5D7
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbhAEXG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbhAEXGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9541F23104;
        Tue,  5 Jan 2021 23:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887913;
        bh=8SOapg8JpqSpJ6bmp4jsC3CkkF2lHQadknYjtpasf4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acPAe2H1TTAT4x05xoFuI2/CNr3ky/tqOsi3f8Sr9xFKXuECBkqTBc9mvFPbpk+Ky
         vKIvuplmARL7eDr6d5L7AKWJ3D42pToRRBHwfkOUuqPEsQM3evxSIsSsHFCICodnul
         rrnz2rStn824h68pc2/pUMP4xK5PI15FCN3gYU/aHSQ5fN/fr+PodbMdSBHgBZEifP
         7ELEeucI6MZP84GGaEHijN847J8YuIRhfXN8LfusK5ZX5JmL2LAUtvpLs25+p7YfuL
         7WoG1PttfiKtpD2B3w2Q0WU0Gwfs/ob9f+Kxp4LOkFYs84tUilM7JQiMwaIGw3X3xv
         h+P0vD89lcF7w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/16] net/mlx5: DR, Add STE setters and getters per-device API
Date:   Tue,  5 Jan 2021 15:03:28 -0800
Message-Id: <20210105230333.239456-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Extend the STE context struct with various per-device
setters and getters.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h    | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 0773dad59f93..53bb42978e84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -76,6 +76,7 @@ u16 mlx5dr_ste_conv_bit_to_byte_mask(u8 *bit_mask);
 				 struct mlx5dr_match_param *mask))
 
 struct mlx5dr_ste_ctx {
+	/* Builders */
 	void DR_STE_CTX_BUILDER(eth_l2_src_dst);
 	void DR_STE_CTX_BUILDER(eth_l3_ipv6_src);
 	void DR_STE_CTX_BUILDER(eth_l3_ipv6_dst);
@@ -96,6 +97,17 @@ struct mlx5dr_ste_ctx {
 	void DR_STE_CTX_BUILDER(register_0);
 	void DR_STE_CTX_BUILDER(register_1);
 	void DR_STE_CTX_BUILDER(src_gvmi_qpn);
+
+	/* Getters and Setters */
+	void (*ste_init)(u8 *hw_ste_p, u16 lu_type,
+			 u8 entry_type, u16 gvmi);
+	void (*set_next_lu_type)(u8 *hw_ste_p, u16 lu_type);
+	u16  (*get_next_lu_type)(u8 *hw_ste_p);
+	void (*set_miss_addr)(u8 *hw_ste_p, u64 miss_addr);
+	u64  (*get_miss_addr)(u8 *hw_ste_p);
+	void (*set_hit_addr)(u8 *hw_ste_p, u64 icm_addr, u32 ht_size);
+	void (*set_byte_mask)(u8 *hw_ste_p, u16 byte_mask);
+	u16  (*get_byte_mask)(u8 *hw_ste_p);
 };
 
 extern struct mlx5dr_ste_ctx ste_ctx_v0;
-- 
2.26.2

