Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6405D663917
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjAJGMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjAJGLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:11:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DC93D9DD
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1868CB81114
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B88C433EF;
        Tue, 10 Jan 2023 06:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331103;
        bh=KdrP9hdzMCDTkb9FpdBJ7TmIAHXJS5tmlzL3K+ILpvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORY56y0AJmKGbbnMrZgY0D1UTZHBtH0/7BZknLhsd8bxc/IKcnXCQFBLPr8K7Chy/
         8u+YCjKUu/iHJTOJ9uJwCzdwMwHzkA/d9qvWVRucZs+JPJ0AIC6ghQ7T6HLoDNT1Lr
         dM1f9PDOb8hhpGyVWXr+oSqYpFGROVp/c8jizAjXfxMCubTIBdWt+ZRuWEpbtjxo84
         M+TQLy1g2Oog6NCQDAw2rbGslmdluL8On96yCOlX9I0LpNowe1dlbefdZarqfYCRiu
         P1kItOEzi9BPJP7TQ9hCRW0TUv58SUoe+FCFUQpnwuC0o+Gi32e+j7dM7wc4JkX3BU
         A1aNzGbVaepKg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net 07/16] net/mlx5e: IPoIB, Block PKEY interfaces with less rx queues than parent
Date:   Mon,  9 Jan 2023 22:11:14 -0800
Message-Id: <20230110061123.338427-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

From: Dragos Tatulea <dtatulea@nvidia.com>

A user is able to configure an arbitrary number of rx queues when
creating an interface via netlink. This doesn't work for child PKEY
interfaces because the child interface uses the parent receive channels.

Although the child shares the parent's receive channels, the number of
rx queues is important for the channel_stats array: the parent's rx
channel index is used to access the child's channel_stats. So the array
has to be at least as large as the parent's rx queue size for the
counting to work correctly and to prevent out of bound accesses.

This patch checks for the mentioned scenario and returns an error when
trying to create the interface. The error is propagated to the user.

Fixes: be98737a4faa ("net/mlx5e: Use dynamic per-channel allocations in stats")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c   | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 28795fb6bccc..03e681297937 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -168,6 +168,15 @@ static int mlx5i_pkey_dev_init(struct net_device *dev)
 		return -EINVAL;
 	}
 
+	if (dev->num_rx_queues < parent_dev->real_num_rx_queues) {
+		mlx5_core_warn(priv->mdev,
+			       "failed to create child device with rx queues [%d] less than parent's [%d]\n",
+			       dev->num_rx_queues,
+			       parent_dev->real_num_rx_queues);
+		mlx5i_parent_put(dev);
+		return -EINVAL;
+	}
+
 	/* Get QPN to netdevice hash table from parent */
 	parent_ipriv = netdev_priv(parent_dev);
 	ipriv->qpn_htbl = parent_ipriv->qpn_htbl;
-- 
2.39.0

