Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAC64EF465
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348922AbiDAOvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349068AbiDAOp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:45:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B012993C4;
        Fri,  1 Apr 2022 07:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BB2C60A53;
        Fri,  1 Apr 2022 14:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4AFC3410F;
        Fri,  1 Apr 2022 14:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823721;
        bh=sQyD0WvxCJXwMP79jC9b51qZAMNLQWS+fvG1GiZTs6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VscSwgHa3mfGgdKVcK/bcVGPcS9Dgcdw0jdova7qSNE+AoCFhHI6RiZsQJW9meQxq
         +lIcodwon1IuthRawFCl1qG++ConISP2xx4gILfIygPvvF4RFxQbOKoDF+OfQVHgFP
         EdkMggHpWzDXQA34AnpYx7XKxJUVGEHtp8+OHhMMiNY4H5hZw/Y6VDnB3IiBlGhXcp
         /EYyPd3m5D8+pmdmaBc0ryX97XxlfQpDHrlVzoxGproBgI0aUucEHk6U3/z+YZDkWm
         IBOObxJ6KGZfDs9NhrT47i/BXuix7p+ljxE1hz8yp5URLcyqX8COhW/brSXPcEFa0R
         A1b5T+oXJO13g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 051/109] net/mlx5e: Disable TX queues before registering the netdev
Date:   Fri,  1 Apr 2022 10:31:58 -0400
Message-Id: <20220401143256.1950537-51-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit d08c6e2a4d0308a7922d7ef3b1b3af45d4096aad ]

Normally, the queues are disabled when the channels are deactivated, and
enabled when the channels are activated. However, on register, the
channels are not active, but the queues are enabled by default. This
change fixes it, preventing mlx5e_xmit from running when the channels
are deactivated in the beginning.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 22de7327c5a8..4730d6c14aeb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5223,6 +5223,7 @@ mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *prof
 	}
 
 	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
 	dev_net_set(netdev, mlx5_core_net(mdev));
 
 	return netdev;
-- 
2.34.1

