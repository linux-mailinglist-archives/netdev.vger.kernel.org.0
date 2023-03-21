Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295FC6C3C78
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCUVLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCUVLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:11:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041D257D2A
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 14:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87CC161E66
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 21:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4073C4339B;
        Tue, 21 Mar 2023 21:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679433098;
        bh=pIhC+wN//VpouPQGilyH5C1ONH0jjEIyD6jJQQyaz1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mf/HccwMV/Doa7hHUiEKGWC3PJh/vRKXwSYoLq9pJnnecmnkBv7uMVl2NHWuCX+qP
         sr1scZ+FagW7oTBemRC908270HCjogjVoIhVs42HCw9dTkWUAsVzy6qhMqlJuyx6KX
         AjXHrIFUiWHV6Ne0ZEe7nf252nT5Qs+HsbsEzBgGcI9x/RG0zFZOT0D2RTvveXG0E2
         zohpPP/pzI44B5YjxBX9WXecnqWdHhHspfyxduFIXU6QLT2lMh9m2W0vjTp4EhXg/Y
         DRgGGq7haJEzti/JqMo4W3lGOybsxbsMkPYMEW8uYy9/XzUjCkutJPpeSRoUHGXE/Q
         aLR35za71YgXQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gavin Li <gavinl@nvidia.com>,
        Gavi Teitz <gavi@nvidia.com>
Subject: [net 1/7] net/mlx5e: Set uplink rep as NETNS_LOCAL
Date:   Tue, 21 Mar 2023 14:11:29 -0700
Message-Id: <20230321211135.47711-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321211135.47711-1-saeed@kernel.org>
References: <20230321211135.47711-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>

Previously, NETNS_LOCAL was not set for uplink representors, inconsistent
with VF representors, and allowed the uplink representor to be moved
between net namespaces and separated from the VF representors it shares
the core device with. Such usage would break the isolation model of
namespaces, as devices in different namespaces would have access to
shared memory.

To solve this issue, set NETNS_LOCAL for uplink representors if eswitch is
in switchdev mode.

Fixes: 7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a7f2ab22cc40..7ca7e9b57607 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4150,8 +4150,12 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		}
 	}
 
-	if (mlx5e_is_uplink_rep(priv))
+	if (mlx5e_is_uplink_rep(priv)) {
 		features = mlx5e_fix_uplink_rep_features(netdev, features);
+		features |= NETIF_F_NETNS_LOCAL;
+	} else {
+		features &= ~NETIF_F_NETNS_LOCAL;
+	}
 
 	mutex_unlock(&priv->state_lock);
 
-- 
2.39.2

