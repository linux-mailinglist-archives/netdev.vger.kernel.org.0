Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7482F40303C
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 23:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348629AbhIGVZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 17:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348226AbhIGVZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 17:25:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 376DD610C9;
        Tue,  7 Sep 2021 21:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049868;
        bh=PAjkbyu15bkNT/69g6APeG9o5VRLRWREkwk28axDThI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhAu1AlY9b79I/ieEJPOI/dvltwgfPEt/a3HJDMzROmikM/6NChZ4eqtWu3RtaCRY
         4SZ+FXezxhBopTWVSaMciLeayPnk7Wy1MgC4xP55GFt2PC2Kdm+pXQjBhvwwuNybSq
         D2jwG4lfD9gwWTdGeK7znkLyvNY6WNDogdmSBrbA4HST9xia4FS8TYKvMlvP3T5cho
         KI80TxUatuI3Pty6VhW8P2O56xqr3xDd4EXlHNJN1hh8htMr0IJ5iKlie5mzyaScGf
         5uvQ6IOkKeWBJ+IEOwKuPWyFuAJOnIpyDWgA4YW4Wv3nX8YQpKk+cqQstacaAjPjj0
         4lKiaxOwTHeFA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/7] net/mlx5: Bridge, fix uninitialized variable usage
Date:   Tue,  7 Sep 2021 14:24:14 -0700
Message-Id: <20210907212420.28529-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210907212420.28529-1-saeed@kernel.org>
References: <20210907212420.28529-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

In some conditions variable 'err' is not assigned with value in
mlx5_esw_bridge_port_obj_attr_set() and mlx5_esw_bridge_port_changeupper()
functions after recent changes to support LAG. Initialize the variable with
zero value in both cases.

Reported-by: Colin King <colin.king@canonical.com>
Reported-by: Tim Gardner <tim.gardner@canonical.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
CC: linux-kernel@vger.kernel.org
Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 0c38c2e319be..b5ddaa82755f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -137,7 +137,7 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 	u16 vport_num, esw_owner_vhca_id;
 	struct netlink_ext_ack *extack;
 	int ifindex = upper->ifindex;
-	int err;
+	int err = 0;
 
 	if (!netif_is_bridge_master(upper))
 		return 0;
@@ -244,7 +244,7 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 	struct netlink_ext_ack *extack = switchdev_notifier_info_to_extack(&port_attr_info->info);
 	const struct switchdev_attr *attr = port_attr_info->attr;
 	u16 vport_num, esw_owner_vhca_id;
-	int err;
+	int err = 0;
 
 	if (!mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
 							     &esw_owner_vhca_id))
-- 
2.31.1

