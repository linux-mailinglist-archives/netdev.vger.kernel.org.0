Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CE74D5C98
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347254AbiCKHmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347251AbiCKHlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A4D1B7570
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3EA561E02
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14A3C340F3;
        Fri, 11 Mar 2022 07:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984449;
        bh=IyLeDJUNXJiJ+ePpIxL63WV3Ft/D/nHa8QXdl6lzJ80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBg9tJGzfurSwOWlSO9eCJ5W3U4EuvSdqGjlvijlDLSHqV6RO3tlae9zJvPxIRE+t
         8BpczPtXcK35iD8wJ4e3A//uraHQLlMj+jqCBwNDAtB5Ka3TYq/oRst0qzjxddjm9P
         iPn0BRCfSg6WbxeUPrUwwNMRvYRWcb34nHTg0KYuQInPeIAsR3lDU8eKzmMyRNiizM
         dOfoH32/DqnCHyS/bbrqyqvhiF8+WRaWE05M1okpHY/ZXNSp6tytIS6rCMiQf0DkZ9
         OySH/3xb0RrxEB0jMm8Ew1V8hv4NmaRai/llnbXlYVOJEK3NUbB/BwYjkzU0sAc3Hz
         CJVWsVcZkr9IA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: Query the maximum MCIA register read size from firmware
Date:   Thu, 10 Mar 2022 23:40:29 -0800
Message-Id: <20220311074031.645168-14-saeed@kernel.org>
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

The MCIA register supports either 12 or 32 dwords, use the correct value
by querying the capability from the MCAM register.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 8 +++++++-
 include/linux/mlx5/mlx5_ifc.h                  | 4 +++-
 include/linux/mlx5/port.h                      | 1 -
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 289b29a23418..418ab777f6e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -365,6 +365,12 @@ static void mlx5_sfp_eeprom_params_set(u16 *i2c_addr, int *page_num, u16 *offset
 	*offset -= MLX5_EEPROM_PAGE_LENGTH;
 }
 
+static int mlx5_mcia_max_bytes(struct mlx5_core_dev *dev)
+{
+	/* mcia supports either 12 dwords or 32 dwords */
+	return (MLX5_CAP_MCAM_FEATURE(dev, mcia_32dwords) ? 32 : 12) * sizeof(u32);
+}
+
 static int mlx5_query_mcia(struct mlx5_core_dev *dev,
 			   struct mlx5_module_eeprom_query_params *params, u8 *data)
 {
@@ -374,7 +380,7 @@ static int mlx5_query_mcia(struct mlx5_core_dev *dev,
 	void *ptr;
 	u16 size;
 
-	size = min_t(int, params->size, MLX5_EEPROM_MAX_BYTES);
+	size = min_t(int, params->size, mlx5_mcia_max_bytes(dev));
 
 	MLX5_SET(mcia_reg, in, l, 0);
 	MLX5_SET(mcia_reg, in, size, size);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 318fae4b3560..745107ff681d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9691,7 +9691,9 @@ struct mlx5_ifc_pcam_reg_bits {
 };
 
 struct mlx5_ifc_mcam_enhanced_features_bits {
-	u8         reserved_at_0[0x6a];
+	u8         reserved_at_0[0x5d];
+	u8         mcia_32dwords[0x1];
+	u8         reserved_at_5e[0xc];
 	u8         reset_state[0x1];
 	u8         ptpcyc2realtime_modify[0x1];
 	u8         reserved_at_6c[0x2];
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 77ea4f9c5265..402413b3e914 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -56,7 +56,6 @@ enum mlx5_an_status {
 	MLX5_AN_LINK_DOWN   = 4,
 };
 
-#define MLX5_EEPROM_MAX_BYTES			32
 #define MLX5_EEPROM_IDENTIFIER_BYTE_MASK	0x000000ff
 #define MLX5_I2C_ADDR_LOW		0x50
 #define MLX5_I2C_ADDR_HIGH		0x51
-- 
2.35.1

