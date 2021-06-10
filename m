Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5EC3A2274
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhFJDAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhFJDAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FABD61421;
        Thu, 10 Jun 2021 02:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293901;
        bh=Pvs/19emSbj6JDljfhqYV/LgCdylfvGx49DzHuTK3SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnI4esfdDD9L+KI+MjO8J47G/R1brzYPMWKbxeoG1sp9mEJo0JbQSv8DU5Kpfs+Fw
         N+6yK4sxokLsZwb+Vi/D9ErrESyhi0dC9UyuvnCY3RGgadHBgIB/mrD3qpZ1CAMHVk
         fr28pxY0q6tynAqvbXM9VtvVkBjAAF7vmbMuCpTQbHBpL3PKgwBEQjCjBu9vgF7O98
         v/np5Pll6C2qsYW75+UZKv6S6X7a57/Cydo5971MUybJeL6HxnEM095I6ncKPFWlJH
         i0bAP/kGWgMlV8w5LJFbxC4BEx0WhLzQaPiZk6Tjx3z5bcnrgxNLFeFMOb9kBlUCvj
         pUACmwz3JCwBA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/16] net/mlx5: DR, Support EMD tag in modify header for STEv1
Date:   Wed,  9 Jun 2021 19:58:04 -0700
Message-Id: <20210610025814.274607-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add support for EMD tag in modify header set/copy actions
on device that supports STEv1.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c  | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index b4dae628e716..42668de01abc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -116,6 +116,8 @@ enum {
 	DR_STE_V1_ACTION_MDFY_FLD_IPV6_SRC_OUT_3	= 0x4f,
 	DR_STE_V1_ACTION_MDFY_FLD_TCP_MISC_0		= 0x5e,
 	DR_STE_V1_ACTION_MDFY_FLD_TCP_MISC_1		= 0x5f,
+	DR_STE_V1_ACTION_MDFY_FLD_CFG_HDR_0_0		= 0x6f,
+	DR_STE_V1_ACTION_MDFY_FLD_CFG_HDR_0_1		= 0x70,
 	DR_STE_V1_ACTION_MDFY_FLD_METADATA_2_CQE	= 0x7b,
 	DR_STE_V1_ACTION_MDFY_FLD_GNRL_PURPOSE		= 0x7c,
 	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_2		= 0x8c,
@@ -246,6 +248,12 @@ static const struct mlx5dr_ste_action_modify_field dr_ste_v1_action_modify_field
 	[MLX5_ACTION_IN_FIELD_OUT_FIRST_VID] = {
 		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L2_OUT_2, .start = 0, .end = 15,
 	},
+	[MLX5_ACTION_IN_FIELD_OUT_EMD_31_0] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_CFG_HDR_0_1, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_EMD_47_32] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_CFG_HDR_0_0, .start = 0, .end = 15,
+	},
 };
 
 static void dr_ste_v1_set_entry_type(u8 *hw_ste_p, u8 entry_type)
-- 
2.31.1

