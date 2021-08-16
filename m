Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F893EDF38
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhHPVTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233521AbhHPVTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 026B66108B;
        Mon, 16 Aug 2021 21:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629148747;
        bh=rBqjeNK4uwVvPk8/wEACYF6qM/iFoDNVLrgkrYwsmko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCTOG2Zm+kW3JTa3d6jNcfdi8W+/VFo/wdLCfCssjRScquXw7yvpgsu3wJlYbYP+s
         FFk7S/hoG+Rqvb0YbFxEmDpvLDmuoHIQj7nM4h2BDBVTPDz5Z9Hr2sp03jPBia/eMG
         BTjkxLjQkyux/r8i0oQR64jWgychawedwlbkUonRtRRPT25UPwgELA4U0a037XoPgc
         XkzgZY/Uj4qFd6htpah8uaJ/JQVAq3quoHKppoqRPUJm0tdfyD0bPZS0guCMdceAXc
         C9H/W1XiBi5FvD2EThUPHEizz3Ymf63Kf6mxwYiuouWZMCny9+r5kS38bH+bM2aFx0
         ibmd6HRsXrZWg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/17] net/mlx5: Bridge, release bridge in same function where it is taken
Date:   Mon, 16 Aug 2021 14:18:42 -0700
Message-Id: <20210816211847.526937-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816211847.526937-1-saeed@kernel.org>
References: <20210816211847.526937-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Refactor mlx5_esw_bridge_vport_link() to release the bridge instance if
mlx5_esw_bridge_vport_init() returned an error instead of relying on it to
release the bridge. This improves the design because object instance is
taken and released in same layer and simplifies following patches that add
more logic to mlx5_esw_bridge_vport_link().

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 69a3630818d7..4bca480e3e7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1042,10 +1042,8 @@ static int mlx5_esw_bridge_vport_init(struct mlx5_esw_bridge_offloads *br_offloa
 	int err;
 
 	port = kvzalloc(sizeof(*port), GFP_KERNEL);
-	if (!port) {
-		err = -ENOMEM;
-		goto err_port_alloc;
-	}
+	if (!port)
+		return -ENOMEM;
 
 	port->vport_num = vport->vport;
 	xa_init(&port->vlans);
@@ -1062,8 +1060,6 @@ static int mlx5_esw_bridge_vport_init(struct mlx5_esw_bridge_offloads *br_offloa
 
 err_port_insert:
 	kvfree(port);
-err_port_alloc:
-	mlx5_esw_bridge_put(br_offloads, bridge);
 	return err;
 }
 
@@ -1108,8 +1104,14 @@ int mlx5_esw_bridge_vport_link(int ifindex, struct mlx5_esw_bridge_offloads *br_
 	}
 
 	err = mlx5_esw_bridge_vport_init(br_offloads, bridge, vport);
-	if (err)
+	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Error initializing port");
+		goto err_vport;
+	}
+	return 0;
+
+err_vport:
+	mlx5_esw_bridge_put(br_offloads, bridge);
 	return err;
 }
 
-- 
2.31.1

