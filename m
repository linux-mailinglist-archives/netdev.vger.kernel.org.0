Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B487817A8E2
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 16:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCEPei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 10:34:38 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39046 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726413AbgCEPeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 10:34:37 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Mar 2020 17:34:35 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 025FYYsV010824;
        Thu, 5 Mar 2020 17:34:35 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload 07/13] net/mlx5: E-Switch, Add support for offloading rules with no in_port
Date:   Thu,  5 Mar 2020 17:34:22 +0200
Message-Id: <1583422468-8456-8-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
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
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 3f644c2..c7a09d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -379,6 +379,7 @@ enum {
 enum {
 	MLX5_ESW_ATTR_FLAG_VLAN_HANDLED  = BIT(0),
 	MLX5_ESW_ATTR_FLAG_SLOW_PATH     = BIT(1),
+	MLX5_ESW_ATTR_FLAG_NO_IN_PORT    = BIT(2),
 };
 
 struct mlx5_esw_flow_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a867d7f..87aab7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -197,7 +197,8 @@ struct mlx5_flow_handle *
 		i++;
 	}
 
-	mlx5_eswitch_set_rule_source_port(esw, spec, attr);
+	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_NO_IN_PORT))
+		mlx5_eswitch_set_rule_source_port(esw, spec, attr);
 
 	if (attr->outer_match_level != MLX5_MATCH_NONE)
 		spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
-- 
1.8.3.1

