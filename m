Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0EE4D5C9F
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347268AbiCKHmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347249AbiCKHmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:42:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAA31B756A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4597061DFF
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DE1C340F3;
        Fri, 11 Mar 2022 07:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984450;
        bh=7cK3S04T4t1Q6U6OJgv+0B4UG2G0+duEQ0XIng5vY0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRLVmac7Ojmoy3YERYZP2AfVi/8YreV38YnC5CqqIwYUYUh6QWB7GIl6BUDoIVnqs
         5xL+NFvAbwXu1W785gOncM0BuCqM8671dh4CYNTQxwRMUtI1+Pw/LDBcluCb32Iboe
         4Hz7qbipuaP8pX+4q0g2MwCirFMWx//HvmPvP7meTcDD33r9Q3w4+VBQ7yxPpvYAGS
         eC4py5VO1Y1kmJ2Xr8UBmF13MhsBdRIg1McYdROI/Gfj+F4HbTGjhza47CuVHtWGsI
         7CLAh0qNrAVaH8HVya8Q3+EQSLwlzgcxEyHVRUBfBr1Bwrzi2ywLSzA0Bec9y9cUJQ
         gXVzHU5MhI4+w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Remove overzealous validations in netlink EEPROM query
Date:   Thu, 10 Mar 2022 23:40:31 -0800
Message-Id: <20220311074031.645168-16-saeed@kernel.org>
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

Unlike the legacy EEPROM callbacks, when using the netlink EEPROM query
(get_module_eeprom_by_page) the driver should not try to validate the
query parameters, but just perform the read requested by the userspace.

Recent discussion in the mailing list:
https://lore.kernel.org/netdev/20220120093051.70845141@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net/

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/port.c    | 23 -------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 493cacb4610b..e1bd54574ea5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -451,35 +451,12 @@ int mlx5_query_module_eeprom_by_page(struct mlx5_core_dev *dev,
 				     struct mlx5_module_eeprom_query_params *params,
 				     u8 *data)
 {
-	u8 module_id;
 	int err;
 
 	err = mlx5_query_module_num(dev, &params->module_number);
 	if (err)
 		return err;
 
-	err = mlx5_query_module_id(dev, params->module_number, &module_id);
-	if (err)
-		return err;
-
-	switch (module_id) {
-	case MLX5_MODULE_ID_SFP:
-		if (params->page > 0)
-			return -EINVAL;
-		break;
-	case MLX5_MODULE_ID_QSFP:
-	case MLX5_MODULE_ID_QSFP28:
-	case MLX5_MODULE_ID_QSFP_PLUS:
-		if (params->page > 3)
-			return -EINVAL;
-		break;
-	case MLX5_MODULE_ID_DSFP:
-		break;
-	default:
-		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
-		return -EINVAL;
-	}
-
 	if (params->i2c_address != MLX5_I2C_ADDR_HIGH &&
 	    params->i2c_address != MLX5_I2C_ADDR_LOW) {
 		mlx5_core_err(dev, "I2C address not recognized: 0x%x\n", params->i2c_address);
-- 
2.35.1

