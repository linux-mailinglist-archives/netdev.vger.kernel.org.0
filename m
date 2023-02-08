Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D4D68E662
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBHDDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBHDDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:03:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D5E23C43
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 19:03:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68811B81B9F
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126B5C4339B;
        Wed,  8 Feb 2023 03:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675825392;
        bh=uQr9Lp5+1CvWVEU1dMl1fFRGg3xXXZL6MgfpUzmXUqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/JPtvSlgaUG6DFU7kEpPIt3N0Colmyn9zkC663FkzAz8XKsEGQE5R3oAZsuvjTNJ
         gtMJvtxX7080zXUMaDl1YQ6QmT0l10hGBA2HhKMimx3nhDB7ivhTldWLOueh4jDXA1
         dgTkb7n0ehEyAaUGIrb8kyBfS/Q6RWOBVLjEvmHhlvj+ALIEscUY46LswEgtKsAVSe
         iK1CB7r/jT2AGswwCZTX0fiszeq7Ht/KuHFbo3U9sqTKGuC+t80G0PifTBr7MNoNSX
         RKukr2FzFBghfNr+Ax3968RV2QNlkcnXSuJlepgIf9hUVwBshdFVzNkKNzAgnqh9Ie
         K66bDfoAO24mQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net 03/10] net/mlx5: Bridge, fix ageing of peer FDB entries
Date:   Tue,  7 Feb 2023 19:02:55 -0800
Message-Id: <20230208030302.95378-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208030302.95378-1-saeed@kernel.org>
References: <20230208030302.95378-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

SWITCHDEV_FDB_ADD_TO_BRIDGE event handler that updates FDB entry 'lastuse'
field is only executed for eswitch that owns the entry. However, if peer
entry processed packets at least once it will have hardware counter 'used'
value greater than entry 'lastuse' from that point on, which will cause FDB
entry not being aged out.

Process the event on all eswitch instances.

Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c | 4 ----
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c    | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 8099a21e674c..ce85b48d327d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -438,10 +438,6 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
 
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
-		/* only handle the event on native eswtich of representor */
-		if (!mlx5_esw_bridge_is_local(dev, rep, esw))
-			break;
-
 		fdb_info = container_of(info,
 					struct switchdev_notifier_fdb_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index b176648d1343..3cdcb0e0b20f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1715,7 +1715,7 @@ void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16
 	struct mlx5_esw_bridge *bridge;
 
 	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port || port->flags & MLX5_ESW_BRIDGE_PORT_FLAG_PEER)
+	if (!port)
 		return;
 
 	bridge = port->bridge;
-- 
2.39.1

