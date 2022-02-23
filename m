Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CFA4C195E
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243166AbiBWRFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242244AbiBWRFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159BD51E7C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7D7760FCA
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AEFC340EB;
        Wed, 23 Feb 2022 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645635882;
        bh=5HlVWd8sdoBmV6RaN5F0WJ8X6P9zT60QHBI3eEFAqnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8rLrdXnQnFqhSiMy5Z7y2nbEAq/73gg6RM0WxCPhlZeFlBZEovICpdYI00ma8PZz
         bsqe+clmDdOv5adBr6EHrArXsMC4o2Qsel8UZuT1039pLsA5ZPNYpmMTslKB9BdpjI
         GLJXQfkWc9AocTMo+M3TGmk+3v3ci9hATk92x7wHgvVTaH3z4GgW/P/XQ7t7ZOuUf8
         jcPEPY6lqnPKqQ9R5OBDcPaKkOFkCxYY5mCK64tGFjoXwm87OMBZ0kThGPmofKVTmn
         osJiZ9TM+KETRHPbcgyd96dh1pbGXjSY7QIB3uTsdKwVWBfehUWcR0guh4pYOTFN5V
         CYMVfGWCvT9+A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/19] net/mlx5e: Fix wrong return value on ioctl EEPROM query failure
Date:   Wed, 23 Feb 2022 09:04:21 -0800
Message-Id: <20220223170430.295595-11-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223170430.295595-1-saeed@kernel.org>
References: <20220223170430.295595-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

The ioctl EEPROM query wrongly returns success on read failures, fix
that by returning the appropriate error code.

Fixes: bb64143eee8c ("net/mlx5e: Add ethtool support for dump module EEPROM")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 57d755db1cf5..6e80585d731f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1792,7 +1792,7 @@ static int mlx5e_get_module_eeprom(struct net_device *netdev,
 		if (size_read < 0) {
 			netdev_err(priv->netdev, "%s: mlx5_query_eeprom failed:0x%x\n",
 				   __func__, size_read);
-			return 0;
+			return size_read;
 		}
 
 		i += size_read;
-- 
2.35.1

