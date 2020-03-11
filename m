Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC26181B61
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgCKOeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 10:34:24 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59582 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729910AbgCKOeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:34:06 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Mar 2020 16:34:00 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02BEXxtV016507;
        Wed, 11 Mar 2020 16:34:00 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v3 09/15] net/mlx5: E-Switch, Add support for offloading rules with no in_port
Date:   Wed, 11 Mar 2020 16:33:52 +0200
Message-Id: <1583937238-21511-10-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FTEs in global tables may match on packets from multiple in_ports.
Provide the capability to omit the in_port match condition.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index dae0f3e..6254bb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -391,6 +391,7 @@ enum {
 enum {
 	MLX5_ESW_ATTR_FLAG_VLAN_HANDLED  = BIT(0),
 	MLX5_ESW_ATTR_FLAG_SLOW_PATH     = BIT(1),
+	MLX5_ESW_ATTR_FLAG_NO_IN_PORT    = BIT(2),
 };
 
 struct mlx5_esw_flow_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8bfab5d..21ac813 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -388,7 +388,9 @@ struct mlx5_flow_handle *
 							attr->prio, 0);
 		else
 			fdb = attr->fdb;
-		mlx5_eswitch_set_rule_source_port(esw, spec, attr);
+
+		if (!(attr->flags & MLX5_ESW_ATTR_FLAG_NO_IN_PORT))
+			mlx5_eswitch_set_rule_source_port(esw, spec, attr);
 	}
 	if (IS_ERR(fdb)) {
 		rule = ERR_CAST(fdb);
-- 
1.8.3.1

