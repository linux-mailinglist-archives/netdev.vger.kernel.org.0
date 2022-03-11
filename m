Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947E14D5C93
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347251AbiCKHmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347256AbiCKHlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920471B7602
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EA30B82A7B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8B8C340F6;
        Fri, 11 Mar 2022 07:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984450;
        bh=6gCvQ5hiYvX59VZBdrzr8awBGb4thLTnggd5lHIVvB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmrlRQCXqVBniseii2K5YogGXYFVN/JQn6jN/B1s5UuAGuMWbWD7nopWSJ4gNYdG4
         /ETIr8aAYnlQR7TW7V8uJscHvVR6V7yEBnTEuClnsBLKugbqM+eoSPDEx+dQ3Ltnxf
         j+KnI2jUtnP+fk7n671IyV3/wlXKFE6UW0sgpkkNeFzrbVT2TR0wXN1rrmXoWOdZno
         HeDTcF8lqFvYRWKMOuGXSFw23xk4aXRSFbZWFWl78huCKWw77hiOiE/NtYQX54oYde
         hpbbdW3EWp4c/YnUXfX4JZ9U2kJrLNTuNjsQxZA2Y0jDZA7lJ2hsn3GYPnaEhcI2JY
         3XrO5T8CKEMyA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: Parse module mapping using mlx5_ifc
Date:   Thu, 10 Mar 2022 23:40:30 -0800
Message-Id: <20220311074031.645168-15-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311074031.645168-1-saeed@kernel.org>
References: <20220311074031.645168-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

The assumption that the first byte in the module mapping dword is the
module number shouldn't be hard-coded in the driver, but come from
mlx5_ifc structs.

While at it, fix the incorrect width for the 'rx_lane' and 'tx_lane'
fields.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 6 +++---
 include/linux/mlx5/mlx5_ifc.h                  | 8 ++++----
 include/linux/mlx5/port.h                      | 1 -
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 418ab777f6e8..493cacb4610b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -275,7 +275,6 @@ static int mlx5_query_module_num(struct mlx5_core_dev *dev, int *module_num)
 {
 	u32 in[MLX5_ST_SZ_DW(pmlp_reg)] = {0};
 	u32 out[MLX5_ST_SZ_DW(pmlp_reg)];
-	int module_mapping;
 	int err;
 
 	MLX5_SET(pmlp_reg, in, local_port, 1);
@@ -284,8 +283,9 @@ static int mlx5_query_module_num(struct mlx5_core_dev *dev, int *module_num)
 	if (err)
 		return err;
 
-	module_mapping = MLX5_GET(pmlp_reg, out, lane0_module_mapping);
-	*module_num = module_mapping & MLX5_EEPROM_IDENTIFIER_BYTE_MASK;
+	*module_num = MLX5_GET(lane_2_module_mapping,
+			       MLX5_ADDR_OF(pmlp_reg, out, lane0_module_mapping),
+			       module);
 
 	return 0;
 }
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 745107ff681d..91b7f730ed91 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9888,10 +9888,10 @@ struct mlx5_ifc_pcmr_reg_bits {
 };
 
 struct mlx5_ifc_lane_2_module_mapping_bits {
-	u8         reserved_at_0[0x6];
-	u8         rx_lane[0x2];
-	u8         reserved_at_8[0x6];
-	u8         tx_lane[0x2];
+	u8         reserved_at_0[0x4];
+	u8         rx_lane[0x4];
+	u8         reserved_at_8[0x4];
+	u8         tx_lane[0x4];
 	u8         reserved_at_10[0x8];
 	u8         module[0x8];
 };
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 402413b3e914..28a928b0684b 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -56,7 +56,6 @@ enum mlx5_an_status {
 	MLX5_AN_LINK_DOWN   = 4,
 };
 
-#define MLX5_EEPROM_IDENTIFIER_BYTE_MASK	0x000000ff
 #define MLX5_I2C_ADDR_LOW		0x50
 #define MLX5_I2C_ADDR_HIGH		0x51
 #define MLX5_EEPROM_PAGE_LENGTH		256
-- 
2.35.1

