Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B08768E511
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBHAhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjBHAhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A3640BDA
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F1C8B81B86
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38EFC433EF;
        Wed,  8 Feb 2023 00:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816646;
        bh=2wtxo9vAvDwzyBxBLMw9EoO5Ooae5KORvD8/18cXK78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwztxv4GHkLqbpaKXEk5Bc0rISWGxeIhyC9pchYKrgtMGbWa0W4UDM2SPBFCJiib8
         00jNeArGA9WKAuqS1E7Zms1rcxDmAef6TGDIPphw2wppJgE40jz8+VNO/CcCMg4y+O
         JVTOzV57sZPVLQqBfJVaeM3CR2Xt2gi0EzrpFSYjSoo62+n7myMXRp7cNIWZdyYo5Z
         W/Cqyq/7Nc47DeeHykzY3XGj6dbtq19LSEbUHoG+Ccm+ojMvjezF9+ZOC01psVhaEY
         xczcK2itqrgnoXwpmZShLbI7o1mx0qJC0sNiDbT9qA+MEIoEJ2u7lzKBsNQ3IIlEDT
         OyaGLzbUJtKwg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 09/15] net/mlx5: Fix memory leak in error flow of port set buffer
Date:   Tue,  7 Feb 2023 16:37:06 -0800
Message-Id: <20230208003712.68386-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
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

From: Maher Sanalla <msanalla@nvidia.com>

In the cited commit, shared buffer updates were added whenever
port buffer gets updated.

However, in case the shared buffer update fails, exiting early from
port_set_buffer() is performed without freeing previously-allocated memory.

Fix it by jumping to out label where memory is freed before returning
with error.

Fixes: a440030d8946 ("net/mlx5e: Update shared buffer along with device buffer changes")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 57f4b1b50421..7ac1ad9c46de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -314,11 +314,11 @@ static int port_set_buffer(struct mlx5e_priv *priv,
 	err = port_update_shared_buffer(priv->mdev, current_headroom_size,
 					new_headroom_size);
 	if (err)
-		return err;
+		goto out;
 
 	err = port_update_pool_cfg(priv->mdev, port_buffer);
 	if (err)
-		return err;
+		goto out;
 
 	err = mlx5e_port_set_pbmc(mdev, in);
 out:
-- 
2.39.1

