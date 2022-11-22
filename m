Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1621A63334F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiKVC3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiKVC2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:28:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3E52B638
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B74961542
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F038FC433D7;
        Tue, 22 Nov 2022 02:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084114;
        bh=cndmhdKtUnOpVKJ1L7RnoGdNtxYasa4C/gImAlsUEms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdS0cJT6Bh/mrk+OZbeEkvPKYmL7EGjw1H2QdxRvQ0PlDIFwjxzheLC/b42X+OaFr
         ksBBluT3wJHkUjfHsLYLbxB1ppZ+Fypjz9zmrnlcKS/FC+SLY4FgykClpEE7jRPB0J
         xuiqS+Pi5ydqK0x9RHRFbtkDFvzPkgobn7UXTEZ+x1jUr4HACziKYFUJRly8PcVy/m
         ypW9TWL62Wzkt0IjSxskW5wOf2rR4UNQOcOyMCUBa8fEOdgSd2mTFlTp58TdAoHEoF
         w/QM+aAJyofkcEoNp5vKG6f8IDs0jqvh2yEObUS2laF4HGiNVCLse/L6+IclEJEMEB
         7bbCg0tp4CBHg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net 11/14] net/mlx5e: Remove leftovers from old XSK queues enumeration
Date:   Mon, 21 Nov 2022 18:25:56 -0800
Message-Id: <20221122022559.89459-12-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122022559.89459-1-saeed@kernel.org>
References: <20221122022559.89459-1-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

Before the cited commit, for N channels, a dedicated set of N queues was
created to support XSK, in indices [N, 2N-1], doubling the number of
queues.

In addition, changing the number of channels was prohibited, as it would
shift the indices.

Remove these two leftovers, as we moved XSK to a new queueing scheme,
starting from index 0.

Fixes: 3db4c85cde7a ("net/mlx5e: xsk: Use queue indices starting from 0 for XSK queues")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c   | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 24aa25da482b..1728e197558d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -35,7 +35,6 @@
 #include "en.h"
 #include "en/port.h"
 #include "en/params.h"
-#include "en/xsk/pool.h"
 #include "en/ptp.h"
 #include "lib/clock.h"
 #include "en/fs_ethtool.h"
@@ -412,15 +411,8 @@ void mlx5e_ethtool_get_channels(struct mlx5e_priv *priv,
 				struct ethtool_channels *ch)
 {
 	mutex_lock(&priv->state_lock);
-
 	ch->max_combined   = priv->max_nch;
 	ch->combined_count = priv->channels.params.num_channels;
-	if (priv->xsk.refcnt) {
-		/* The upper half are XSK queues. */
-		ch->max_combined *= 2;
-		ch->combined_count *= 2;
-	}
-
 	mutex_unlock(&priv->state_lock);
 }
 
@@ -454,16 +446,6 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	mutex_lock(&priv->state_lock);
 
-	/* Don't allow changing the number of channels if there is an active
-	 * XSK, because the numeration of the XSK and regular RQs will change.
-	 */
-	if (priv->xsk.refcnt) {
-		err = -EINVAL;
-		netdev_err(priv->netdev, "%s: AF_XDP is active, cannot change the number of channels\n",
-			   __func__);
-		goto out;
-	}
-
 	/* Don't allow changing the number of channels if HTB offload is active,
 	 * because the numeration of the QoS SQs will change, while per-queue
 	 * qdiscs are attached.
-- 
2.38.1

