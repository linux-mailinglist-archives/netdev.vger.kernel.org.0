Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4479956424E
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiGBTE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiGBTE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23C99FE6
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B2B361009
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2CAC34114;
        Sat,  2 Jul 2022 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788662;
        bh=3soJmCJASKSCZTg9s1elNH66wYrZVSwGCi9T+opLlS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTVrWWG8fXlP7ISX8sMSMh+d5Q3oICsqlg3DV1KLavr9yy5KDWBDIN6Fm75igZnjb
         7tkH0yAaZMo6o+tduTov/kdceln+nNI2cO7OaXZMb/+NMUag0/RLS54j9eujPGFbbT
         PtlKSSiURmT8QJjW6kdcb6iGApNNkZhS33gyTX14KDkcFAwZlQmpoYqFKMIcoETmRA
         cFRTZ+T6e0YxBiafXh925cRvJ9SOBknxnDS0pcE5wn6ha73sMd0plgYXTTQ4Zda1z/
         pA+6R56YBe0btwoEw/DDhoP6+wq3aKMq3DmMJfuBzBLVI6V93kEehFg0rQSSWYan4K
         2fKBtId6OI/Ew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net-next v2 02/15] net/mlx5: delete dead code in mlx5_esw_unlock()
Date:   Sat,  2 Jul 2022 12:02:00 -0700
Message-Id: <20220702190213.80858-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702190213.80858-1-saeed@kernel.org>
References: <20220702190213.80858-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

Smatch complains about this function:

    drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:2000 mlx5_esw_unlock()
    warn: inconsistent returns '&esw->mode_lock'.

Before commit ec2fa47d7b98 ("net/mlx5: Lag, use lag lock") there
used to be a matching mlx5_esw_lock() function and the lock and
unlock functions were symmetric.  But now we take the lock
unconditionally and must unlock unconditionally as well.

As near as I can tell this is dead code and can just be deleted.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 719ef26d23c0..3e662e389be4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1995,8 +1995,6 @@ int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
  */
 void mlx5_esw_unlock(struct mlx5_eswitch *esw)
 {
-	if (!mlx5_esw_allowed(esw))
-		return;
 	up_write(&esw->mode_lock);
 }
 
-- 
2.36.1

