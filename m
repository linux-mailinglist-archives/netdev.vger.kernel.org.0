Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC653DF860
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhHCXUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhHCXUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23EF260F93;
        Tue,  3 Aug 2021 23:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032820;
        bh=CKn/KvEeyZAMuD+iFiH3gFauEveHmSMXEL5LWTioEbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6eXw/E7p6Ij0lxShllsqHoBbFM3/hiGROIRM2adIiIkdeNJgOIJgSTthlygfxJVm
         ioa0yfwArIxq+fexGzcqOeuo6JT3o4vyc5jZMXgtW62z2E4nwjC2GHMEj5tYiU7vxk
         nHAsgvI+5KU5xF0qyxijFIJpi4NaBjbq3HDEJKCocz/Zi0yzIO6TxYEg6kgWNor3g6
         3liyiJUEbFSja5be6sPo/SGHLtivN4+EnjSVTHgszsuHi/D1ur6xxOnNZEUFjnl4fQ
         XvzfzHo2wW+3lwt+vSeX86q3GrJhr8tIvEbRLUqU1sVbZgBvbKNIYk3gv0mW1xEM3H
         4l4gjMqJJHc6w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Ariel Levkovich <lariel@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH mlx5-next 06/14] net/mlx5: E-Switch, set flow source for send to uplink rule
Date:   Tue,  3 Aug 2021 16:19:51 -0700
Message-Id: <20210803231959.26513-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Set the flow source param to local vport for the uplink rep
send-to-vport rule.

This will comply with the recent changes in SW steering that
use the flow source as an indication for the rule type - rx or tx.

Since the uplink send-to-vport rule is forwarding traffic to the wire
it has to indicate that it is an sx rule and can't use the any port
value in the flow source.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 12567002997f..1735be77e1fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -963,6 +963,9 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
+	if (rep->vport == MLX5_VPORT_UPLINK)
+		spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
+
 	flow_rule = mlx5_add_flow_rules(on_esw->fdb_table.offloads.slow_fdb,
 					spec, &flow_act, &dest, 1);
 	if (IS_ERR(flow_rule))
-- 
2.31.1

