Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8311435FE53
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbhDNXQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233751AbhDNXQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69F9561164;
        Wed, 14 Apr 2021 23:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442172;
        bh=JXJ7Phxlq5Y0V6d13IaOndGBSr0U/DH10cNw1o7t8tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dY1+ji1a44xN4tSpu90p9YM6GhcpSG+z2MPqiCRK0qV+wvoy7wr35KehKqClu2UGL
         smsaSnd3u7ewQZkOVuXHmLxBMmSXCxguSwGrXV6vCnVbQvcjRAofLAlGGbkD1ZKrz1
         l7uNvcGVN1WqC8AJCbZWCbHq7ORcFckUcXLLIZMgXNH0e/JKPWWgDcwt+UldhK5WiR
         XCZq7EirgwSAM8qxYaKaNokQFGD0KPpjqQ0Kwq1QFMsv1dObwK0MWf4INU0b7uxn+I
         WwqI7GCSl4X6Fb9Ck5oe5yRPAQlHE3bpwKtIQc4Q57Y5fpoRZrOD5STD8O4uiCL/4N
         T6nNWlz8HIDNQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/3] net/mlx5e: Fix setting of RS FEC mode
Date:   Wed, 14 Apr 2021 16:16:09 -0700
Message-Id: <20210414231610.136376-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414231610.136376-1-saeed@kernel.org>
References: <20210414231610.136376-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Change register setting from bit number to bit mask.

Fixes: b5ede32d3329 ("net/mlx5e: Add support for FEC modes based on 50G per lane links")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 23 ++++---------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 308fd279669e..89510cac46c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -387,21 +387,6 @@ enum mlx5e_fec_supported_link_mode {
 			*_policy = MLX5_GET(pplm_reg, _buf, fec_override_admin_##link);	\
 	} while (0)
 
-#define MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(buf, policy, write, link)			\
-	do {										\
-		unsigned long policy_long;						\
-		u16 *__policy = &(policy);						\
-		bool _write = (write);							\
-											\
-		policy_long = *__policy;						\
-		if (_write && *__policy)						\
-			*__policy = find_first_bit(&policy_long,			\
-						   sizeof(policy_long) * BITS_PER_BYTE);\
-		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(buf, *__policy, _write, link);		\
-		if (!_write && *__policy)						\
-			*__policy = 1 << *__policy;					\
-	} while (0)
-
 /* get/set FEC admin field for a given speed */
 static int mlx5e_fec_admin_field(u32 *pplm, u16 *fec_policy, bool write,
 				 enum mlx5e_fec_supported_link_mode link_mode)
@@ -423,16 +408,16 @@ static int mlx5e_fec_admin_field(u32 *pplm, u16 *fec_policy, bool write,
 		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 100g);
 		break;
 	case MLX5E_FEC_SUPPORTED_LINK_MODE_50G_1X:
-		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 50g_1x);
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 50g_1x);
 		break;
 	case MLX5E_FEC_SUPPORTED_LINK_MODE_100G_2X:
-		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 100g_2x);
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 100g_2x);
 		break;
 	case MLX5E_FEC_SUPPORTED_LINK_MODE_200G_4X:
-		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 200g_4x);
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 200g_4x);
 		break;
 	case MLX5E_FEC_SUPPORTED_LINK_MODE_400G_8X:
-		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 400g_8x);
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 400g_8x);
 		break;
 	default:
 		return -EINVAL;
-- 
2.30.2

