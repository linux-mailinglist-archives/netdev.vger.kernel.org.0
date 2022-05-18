Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0BC52B271
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiERGfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiERGey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:34:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D32DE2770
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:34:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F385B81E93
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9E1C385A5;
        Wed, 18 May 2022 06:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652855685;
        bh=Q4Pydytx5pLCwEAe7NFOvE/zojtq4yAbK1/5d77ZK4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6O/8CB402PLsQDg8lCD37RIrm5MZ7k9OmQzPMFCfDnBBu30eOGOzJ+232jlig/RX
         KFgWR6FCpoRgeGkzZ7nllwvjZjZFbDpD5rjc8oUwfhCnBmXvamEWaM9HMqO+T21d2o
         EubgXUa4Uorv0Qx2gYaAm3wSAx0BZWcS/1+NkE61/gi4BeBbBnFojC+fx9//Wsmq99
         y0+w1UIJQaM7RnIgPSrS/heE1dzIHZDFvVsrpr4MZJ07trSx3ouAmOO2dN0t+L0z/W
         dE2410o1NebH6Y38ARWcOfqZIG9I7OyJKTNRNvmYJ+kLfcRjrI9qEETafFYi3KOHHD
         Don5xUSJs/Rrw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/11] net/mlx5e: Properly block LRO when XDP is enabled
Date:   Tue, 17 May 2022 23:34:22 -0700
Message-Id: <20220518063427.123758-7-saeed@kernel.org>
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

LRO is incompatible and mutually exclusive with XDP. However, the needed
checks are only made when enabling XDP. If LRO is enabled when XDP is
already active, the command will succeed, and XDP will be skipped in the
data path, although still enabled.

This commit fixes the bug by checking the XDP status in
mlx5e_fix_features and disabling LRO if XDP is enabled.

Fixes: 86994156c736 ("net/mlx5e: XDP fast RX drop bpf programs support")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 999241961714..3969916cfafe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3900,6 +3900,13 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		}
 	}
 
+	if (params->xdp_prog) {
+		if (features & NETIF_F_LRO) {
+			netdev_warn(netdev, "LRO is incompatible with XDP\n");
+			features &= ~NETIF_F_LRO;
+		}
+	}
+
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
 		features &= ~NETIF_F_RXHASH;
 		if (netdev->features & NETIF_F_RXHASH)
-- 
2.36.1

