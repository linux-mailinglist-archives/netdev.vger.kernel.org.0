Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1853E52B27D
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiERGfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiERGez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C1AE7320
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:34:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A28D0B81E99
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44139C385AA;
        Wed, 18 May 2022 06:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652855686;
        bh=jnYiqRk62h+M+0VkaqKxjXVMOnuc3xDlpExaQA4QSrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wk3PdCyXtBNy10hZ6KrjFr12kqqi7rL1cXRwlWbNYuabNKO6jHQP5nM67Gj4zWX8w
         NzHjEfr5ACziQLFfTGM3rW/2c26fETJvacII7SuiJT8ZGYsEQLjgFigpahAVJYCT0y
         Zikei9RG1qQugqAD4YOxcI/d0l495I1/NZ9CoHW3rTYBWmi5WnsDvlpOQyUKGCbRSi
         wyWAJ3+DxDcb9Q6Y1dY6mW9PCSMajaDiA3k0FNkIPs+tDHR1EKlagFHHC1D3lnIArV
         4PcaLjfztZPUKETzg9wZKsMEXZcKpyd/M6TH0FYWa90BvP25rAfTkseADDyb3PEVy5
         1hs9PuI4JPW6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/11] net/mlx5e: Properly block HW GRO when XDP is enabled
Date:   Tue, 17 May 2022 23:34:23 -0700
Message-Id: <20220518063427.123758-8-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518063427.123758-1-saeed@kernel.org>
References: <20220518063427.123758-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

HW GRO is incompatible and mutually exclusive with XDP and XSK. However,
the needed checks are only made when enabling XDP. If HW GRO is enabled
when XDP is already active, the command will succeed, and XDP will be
skipped in the data path, although still enabled.

This commit fixes the bug by checking the XDP and XSK status in
mlx5e_fix_features and disabling HW GRO if XDP is enabled.

Fixes: 83439f3c37aa ("net/mlx5e: Add HW-GRO offload")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3969916cfafe..6afd07901a10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3905,6 +3905,18 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 			netdev_warn(netdev, "LRO is incompatible with XDP\n");
 			features &= ~NETIF_F_LRO;
 		}
+		if (features & NETIF_F_GRO_HW) {
+			netdev_warn(netdev, "HW GRO is incompatible with XDP\n");
+			features &= ~NETIF_F_GRO_HW;
+		}
+	}
+
+	if (priv->xsk.refcnt) {
+		if (features & NETIF_F_GRO_HW) {
+			netdev_warn(netdev, "HW GRO is incompatible with AF_XDP (%u XSKs are active)\n",
+				    priv->xsk.refcnt);
+			features &= ~NETIF_F_GRO_HW;
+		}
 	}
 
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
-- 
2.36.1

