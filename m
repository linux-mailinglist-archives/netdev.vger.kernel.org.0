Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D12C68E663
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjBHDDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjBHDDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:03:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB6A410AA
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 19:03:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81310B81BA3
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDB9C433D2;
        Wed,  8 Feb 2023 03:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675825393;
        bh=eGnjj4fMcXOZHLcs+Li2aDuUtVoKAq4Vuo/oNU9Ybt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBhwHVKMOcXrIAjQSgwwOkWS19iuDMlCbnZ9LSCj5eXMTv/kiuRY8yycXd6xHwNeD
         3Bvpk4vS/2qilk/Njqn66fuOiKIZk3E8YZezXZm1cD+/BGXcA5M/ZfbaXKc9FRHTA1
         c0kINUj/gaYQ5vOxU3p4FVmIRAByQP9JRCnxWTfbfZkV5PdYAb4Qz5AtHIMCylngZF
         xa0h3QS6fwEEgPQOuUly5etB7GFMzhGJGxo58CaR08LIAwjeQMhDWbwvoCD2N8juge
         mgJWZz0jgW6PKhLNwbMEdMc3dO6j+HPx+ThL7BsiNcP9FLQRVjXhOD6ElIv+lZPyni
         I/qOHUhKuMRTQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Amir Tzin <amirtz@nvidia.com>, Maor Dickman <maord@nvidia.com>
Subject: [net 04/10] net/mlx5e: Fix crash unsetting rx-vlan-filter in switchdev mode
Date:   Tue,  7 Feb 2023 19:02:56 -0800
Message-Id: <20230208030302.95378-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208030302.95378-1-saeed@kernel.org>
References: <20230208030302.95378-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amir Tzin <amirtz@nvidia.com>

Moving to switchdev mode with rx-vlan-filter on and then setting it off
causes the kernel to crash since fs->vlan is freed during nic profile
cleanup flow.

RX VLAN filtering is not supported in switchdev mode so unset it when
changing to switchdev and restore its value when switching back to
legacy.

trace:
[] RIP: 0010:mlx5e_disable_cvlan_filter+0x43/0x70
[] set_feature_cvlan_filter+0x37/0x40 [mlx5_core]
[] mlx5e_handle_feature+0x3a/0x60 [mlx5_core]
[] mlx5e_set_features+0x6d/0x160 [mlx5_core]
[] __netdev_update_features+0x288/0xa70
[] ethnl_set_features+0x309/0x380
[] ? __nla_parse+0x21/0x30
[] genl_family_rcv_msg_doit.isra.17+0x110/0x150
[] genl_rcv_msg+0x112/0x260
[] ? features_reply_size+0xe0/0xe0
[] ? genl_family_rcv_msg_doit.isra.17+0x150/0x150
[] netlink_rcv_skb+0x4e/0x100
[] genl_rcv+0x24/0x40
[] netlink_unicast+0x1ab/0x290
[] netlink_sendmsg+0x257/0x4f0
[] sock_sendmsg+0x5c/0x70

Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 1892ccb889b3..7cd36f4ac3ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -443,7 +443,7 @@ void mlx5e_enable_cvlan_filter(struct mlx5e_flow_steering *fs, bool promisc)
 
 void mlx5e_disable_cvlan_filter(struct mlx5e_flow_steering *fs, bool promisc)
 {
-	if (fs->vlan->cvlan_filter_disabled)
+	if (!fs->vlan || fs->vlan->cvlan_filter_disabled)
 		return;
 
 	fs->vlan->cvlan_filter_disabled = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f8b5e5993f35..6c24f33a5ea5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4018,6 +4018,10 @@ static netdev_features_t mlx5e_fix_uplink_rep_features(struct net_device *netdev
 	if (netdev->features & NETIF_F_GRO_HW)
 		netdev_warn(netdev, "Disabling HW_GRO, not supported in switchdev mode\n");
 
+	features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	if (netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		netdev_warn(netdev, "Disabling HW_VLAN CTAG FILTERING, not supported in switchdev mode\n");
+
 	return features;
 }
 
-- 
2.39.1

