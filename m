Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C4C43A513
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhJYU5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233451AbhJYU5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51A126105A;
        Mon, 25 Oct 2021 20:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195277;
        bh=CzWOctWdvIInWj02Uj6XKx0HLTOll9lOo+n7QXX6NUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lv9Lp8o+lGc5GaAx2LJS6AAjWF0SrESpQ0YF2kX0UcQ3NQ2HFZ2T+e2hGntG+Gw/d
         ttdW9lZKyQWfYN9fJDpCssHaZfDj8qdrWj5Sm4qCFo5ZbYzjsKRNNtZ7dc40YUndnt
         9bZncYuK/ZtJSvI3JzI8o0wQJDS6souEDKNZcGOEf7SafMo9t+7d4mgOUon464+J7m
         1taDvSduvJ1ypX0Vt+joRROF60b516TTdjSPXDDh8xsgtDiuPNaCfDdohFTGI+IW0L
         qLUAM6XHb1VDBFPTRahOkLfBT3MYlNqew0dGKUgVLdTFlIYjyKMc+FqFRou1weWVgL
         yQuK1t9SQaFgQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/14] net/mlx5: Bridge, support replacing existing FDB entry
Date:   Mon, 25 Oct 2021 13:54:26 -0700
Message-Id: <20211025205431.365080-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

The SWITCHDEV_FDB_ADD_TO_DEVICE is used for both adding new and replacing
existing entry. Implement support for replacing existing FDB entries in
mlx5 offload code.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 33d1d2ed4cd6..f690f430f40f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1160,6 +1160,10 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, u16 esw_ow
 			return ERR_CAST(vlan);
 	}
 
+	entry = mlx5_esw_bridge_fdb_lookup(bridge, addr, vid);
+	if (entry)
+		mlx5_esw_bridge_fdb_entry_notify_and_cleanup(entry, bridge);
+
 	entry = kvzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return ERR_PTR(-ENOMEM);
-- 
2.31.1

