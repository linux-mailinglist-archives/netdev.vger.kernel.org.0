Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A94F4B6382
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiBOGcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:32:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbiBOGcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:32:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2A7AF1D6
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6553861521
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75696C340F1;
        Tue, 15 Feb 2022 06:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906758;
        bh=n3TUZlf5R5dmc5EZ7PJTc+UHE7S+I5FODPfJpQMhBbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AL6n64Pv19kRO+x8zmi/5TMeWNR6Pjb2s77FRLfb/fDRDwy6oBry4Gnh0M58yj0jT
         4bvVdh9ao95b6GIjhxJoXlrnztVMPYvp3JJIfIjul5L9F1KMvw0m+GsmSOO8iFQZ0K
         K7wp0FM/xj0srCekIMnQNKCv1AYhw5Bc5tucO0AL0EED2nzi4hUNGiSWYTkLlF6X/L
         j9Orz1H3qIlsqqX5XZThYXjMgVckuuA5pLRmnIyjEmXf8r9T9f9RIM+twTTNIjMUzy
         wNgopRhA4UdvOR90zp/+gujvjtHx0QQi0c63EGNplFfNa3sNAe2LKoyMhbU3wIKZih
         B+If4lXXBBuog==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Disable TX queues before registering the netdev
Date:   Mon, 14 Feb 2022 22:32:19 -0800
Message-Id: <20220215063229.737960-6-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215063229.737960-1-saeed@kernel.org>
References: <20220215063229.737960-1-saeed@kernel.org>
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

Normally, the queues are disabled when the channels are deactivated, and
enabled when the channels are activated. However, on register, the
channels are not active, but the queues are enabled by default. This
change fixes it, preventing mlx5e_xmit from running when the channels
are deactivated in the beginning.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8507ebec1266..d84d9cdbdbd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5359,6 +5359,7 @@ mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *prof
 	}
 
 	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
 	dev_net_set(netdev, mlx5_core_net(mdev));
 
 	return netdev;
-- 
2.34.1

