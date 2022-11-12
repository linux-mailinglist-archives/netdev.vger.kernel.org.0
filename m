Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D25B6268CA
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbiKLKWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiKLKV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:21:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0704C140B9
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:21:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B4F1B80749
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9CEC433D6;
        Sat, 12 Nov 2022 10:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248513;
        bh=mJ1fSdix+K7+oeBQE8cn3/UDtPYS6QRecYCbprRPp2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=If6Q4dJT9WGMAQo8bdPqPfGeHtX7mf3Bs6RpM8jYum1kJdFWoKVvaoZkAmiUDCIpT
         /yUNaiZi9zjgvNNonyWmoWqa+nQcKWLO2brL5g1b0v1vV9THuz1IGTlqR0mlQFHA1d
         AVxWzVdMaj2HNcY/pfU5SNaYZbcZ7eD9dcLqgKvwzf4K1QIojmH+evLMedVhuhponu
         0W2YptiRHQdIBgQnzWWAUqkWxJfKlXGduIWwSPzCnbnXvDv4+6ITit1Jhv8H4/xmjE
         zsHlOITDBBXuuDGpWkZ+wC4Wxb/R2E10AsJy5k7ukU3ejnLigiYRnraYlksT+vKzZM
         uRVKtcjSbwfCw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Bridge, Use debug instead of warn if entry doesn't exists
Date:   Sat, 12 Nov 2022 02:21:33 -0800
Message-Id: <20221112102147.496378-2-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

There is no need for the warn if entry already removed.
Use debug print like in the update flow.
Also update the messages so user can identify if the it's
from the update flow or remove flow.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 4fbff7bcc155..b176648d1343 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1722,7 +1722,7 @@ void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16
 	entry = mlx5_esw_bridge_fdb_lookup(bridge, fdb_info->addr, fdb_info->vid);
 	if (!entry) {
 		esw_debug(br_offloads->esw->dev,
-			  "FDB entry with specified key not found (MAC=%pM,vid=%u,vport=%u)\n",
+			  "FDB update entry with specified key not found (MAC=%pM,vid=%u,vport=%u)\n",
 			  fdb_info->addr, fdb_info->vid, vport_num);
 		return;
 	}
@@ -1775,9 +1775,9 @@ void mlx5_esw_bridge_fdb_remove(struct net_device *dev, u16 vport_num, u16 esw_o
 	bridge = port->bridge;
 	entry = mlx5_esw_bridge_fdb_lookup(bridge, fdb_info->addr, fdb_info->vid);
 	if (!entry) {
-		esw_warn(esw->dev,
-			 "FDB entry with specified key not found (MAC=%pM,vid=%u,vport=%u)\n",
-			 fdb_info->addr, fdb_info->vid, vport_num);
+		esw_debug(esw->dev,
+			  "FDB remove entry with specified key not found (MAC=%pM,vid=%u,vport=%u)\n",
+			  fdb_info->addr, fdb_info->vid, vport_num);
 		return;
 	}
 
-- 
2.38.1

