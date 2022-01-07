Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22D3486F44
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344846AbiAGA6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:58:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46216 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiAGA6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0974E61EA6
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A187C36AF2;
        Fri,  7 Jan 2022 00:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517124;
        bh=+6Vpf+SnhE6CRZnSFi3YGeeWOIrErzGS1ce1YDy/WGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zhvs1pt/2mtLJ8crTqIcGGL6MMb1MoE9Z06U1yUX1b7O0a+rQCdO3SNQQkMoX2W/Z
         eg46iWe6G7knJvABcpPgy3RBCyiIMWPY3J5IlBCmOlzAAPO1H4z8FmXc6sjTGOUXqo
         sBXyAE2eVH633gfd03qQxC4VcxTQT42tFcTrBnrJgCrZKGp1nbwldsir6oD4vmLzaR
         1CTKjs4i13JrKdWK3kqHFhI0QHgEK7tHMkltkiOCZV/HFHpKQY+t5OHOjJTsCwaxPt
         GipmKNv0L20GC7G/8691ZloTrRWigOBZ0Dk1IYlg9eLOVATc5vOBgqxTbP+2frQKYQ
         wpMpw+e8qHH9g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/11] net/mlx5e: Fix nullptr on deleting mirroring rule
Date:   Thu,  6 Jan 2022 16:58:22 -0800
Message-Id: <20220107005831.78909-3-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

Deleting a Tc rule with multiple outputs, one of which is internal port,
like this one:

  tc filter del dev enp8s0f0_0 ingress protocol ip pref 5 flower \
      dst_mac 0c:42:a1:d1:d0:88 \
      src_mac e4:ea:09:08:00:02 \
      action tunnel_key  set \
          src_ip 0.0.0.0 \
          dst_ip 7.7.7.8 \
          id 8 \
          dst_port 4789 \
      action mirred egress mirror dev vxlan_sys_4789 pipe \
      action mirred egress redirect dev enp8s0f0_1

Triggers a call trace:

  BUG: kernel NULL pointer dereference, address: 0000000000000230
  RIP: 0010:del_sw_hw_rule+0x2b/0x1f0 [mlx5_core]
  Call Trace:
   tree_remove_node+0x16/0x30 [mlx5_core]
   mlx5_del_flow_rules+0x51/0x160 [mlx5_core]
   __mlx5_eswitch_del_rule+0x4b/0x170 [mlx5_core]
   mlx5e_tc_del_fdb_flow+0x295/0x550 [mlx5_core]
   mlx5e_flow_put+0x1f/0x70 [mlx5_core]
   mlx5e_delete_flower+0x286/0x390 [mlx5_core]
   tc_setup_cb_destroy+0xac/0x170
   fl_hw_destroy_filter+0x94/0xc0 [cls_flower]
   __fl_delete+0x15e/0x170 [cls_flower]
   fl_delete+0x36/0x80 [cls_flower]
   tc_del_tfilter+0x3a6/0x6e0
   rtnetlink_rcv_msg+0xe5/0x360
   ? rtnl_calcit.isra.0+0x110/0x110
   netlink_rcv_skb+0x46/0x110
   netlink_unicast+0x16b/0x200
   netlink_sendmsg+0x202/0x3d0
   sock_sendmsg+0x33/0x40
   ____sys_sendmsg+0x1c3/0x200
   ? copy_msghdr_from_user+0xd6/0x150
   ___sys_sendmsg+0x88/0xd0
   ? ___sys_recvmsg+0x88/0xc0
   ? do_futex+0x10c/0x460
   __sys_sendmsg+0x59/0xa0
   do_syscall_64+0x48/0x140
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix by disabling offloading for flows matching
esw_is_chain_src_port_rewrite() which have more than one output.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 32bc08a39925..ccb66428aeb5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -295,26 +295,28 @@ esw_setup_chain_src_port_rewrite(struct mlx5_flow_destination *dest,
 				 int *i)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
-	int j, err;
+	int err;
 
 	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SRC_REWRITE))
 		return -EOPNOTSUPP;
 
-	for (j = esw_attr->split_count; j < esw_attr->out_count; j++, (*i)++) {
-		err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain, 1, 0, *i);
-		if (err)
-			goto err_setup_chain;
+	/* flow steering cannot handle more than one dest with the same ft
+	 * in a single flow
+	 */
+	if (esw_attr->out_count - esw_attr->split_count > 1)
+		return -EOPNOTSUPP;
 
-		if (esw_attr->dests[j].pkt_reformat) {
-			flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-			flow_act->pkt_reformat = esw_attr->dests[j].pkt_reformat;
-		}
+	err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain, 1, 0, *i);
+	if (err)
+		return err;
+
+	if (esw_attr->dests[esw_attr->split_count].pkt_reformat) {
+		flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+		flow_act->pkt_reformat = esw_attr->dests[esw_attr->split_count].pkt_reformat;
 	}
-	return 0;
+	(*i)++;
 
-err_setup_chain:
-	esw_put_dest_tables_loop(esw, attr, esw_attr->split_count, j);
-	return err;
+	return 0;
 }
 
 static void esw_cleanup_chain_src_port_rewrite(struct mlx5_eswitch *esw,
-- 
2.33.1

