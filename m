Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A4C486F47
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344870AbiAGA6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344882AbiAGA6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DDCC061212
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:58:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 263D161E7A
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1E2C36AE5;
        Fri,  7 Jan 2022 00:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517126;
        bh=IqghzpUpSQ8FPNiSdnq1ROZBWc0uwFaKqWMHwANlsQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDcoLhe9XiiO3WIdNrtCcP8VKoIAHiqAPdlp6zPVrvWDiwNRdIu8Z1rOXlU4NZY+x
         p+6HFUGibwIdyZPdDvVVI6ozisE42dggaJqEjUt2ZBwEwdhA7I7specJVVFnmB0aWr
         XqPL1Zq7Wdz1ldRoCKUK7g3Bah851M+dbVNDBS5Pi71daknIJUkA3E1M4T6Pt1apY0
         Wm9ggzuzB6E9O7cSZKLjrlCwU+xZReQvfp3svuPJkm+1yrRrq+15VZ69be+u+RGPt5
         2J0K65P4DKSkFMoiepTCKDlnXU65UCNsKrS4gmQfJerIdVYy/CVKe6OPErtI4lsYfs
         ZPb13pxD4kz0g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/11] Revert "net/mlx5e: Block offload of outer header csum for GRE tunnel"
Date:   Thu,  6 Jan 2022 16:58:26 -0800
Message-Id: <20220107005831.78909-7-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

This reverts commit 54e1217b90486c94b26f24dcee1ee5ef5372f832.

Although the NIC doesn't support offload of outer header CSUM, using
gso_partial_features allows offloading the tunnel's segmentation. The
driver relies on the stack CSUM calculation of the outer header. For
this, NETIF_F_GSO_GRE_CSUM must be a member of the device's features.

Fixes: 54e1217b9048 ("net/mlx5e: Block offload of outer header csum for GRE tunnel")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index de8acd3217c1..d92b82cdfd4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4799,9 +4799,12 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
-		netdev->hw_features     |= NETIF_F_GSO_GRE;
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE;
+		netdev->hw_features     |= NETIF_F_GSO_GRE |
+					   NETIF_F_GSO_GRE_CSUM;
+		netdev->hw_enc_features |= NETIF_F_GSO_GRE |
+					   NETIF_F_GSO_GRE_CSUM;
+		netdev->gso_partial_features |= NETIF_F_GSO_GRE |
+						NETIF_F_GSO_GRE_CSUM;
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
-- 
2.33.1

