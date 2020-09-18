Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF94270347
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIRR2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgIRR2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:51 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A77A21741;
        Fri, 18 Sep 2020 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450130;
        bh=4ed06FbmY58v9iTZNH3gwlGgljOiCW8lXRsNvNu9WpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAFtdI/NU3tahg8SedoOalHZii47BVaBunaJbF1I3FtrpOt3wOmGZC627Snfkhl7q
         e5zHNNJlh79jEEU5bUQRT7Q8kST+rC6vjrrWIS28F5i0GNeRdrjbrX13VVHkSHClq1
         Z+zkSUMSdiC9bgLXhzbvi3PjLz3TjTyjpxxPAa0k=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/15] net/mlx5: Fix FTE cleanup
Date:   Fri, 18 Sep 2020 10:28:25 -0700
Message-Id: <20200918172839.310037-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Currently, when an FTE is allocated, its refcount is decreased to 0
with the purpose it will not be a stand alone steering object and every
rule (destination) of the FTE would increase the refcount.
When mlx5_cleanup_fs is called while not all rules were deleted by the
steering users, it hit refcount underflow on the FTE once clean_tree
calls to tree_remove_node after the deleted rules already decreased
the refcount to 0.

FTE is no longer destroyed implicitly when the last rule (destination)
is deleted. mlx5_del_flow_rules avoids it by increasing the refcount on
the FTE and destroy it explicitly after all rules were deleted. So we
can avoid the refcount underflow by making FTE as stand alone object.
In addition need to set del_hw_func to FTE so the HW object will be
destroyed when the FTE is deleted from the cleanup_tree flow.

refcount_t: underflow; use-after-free.
WARNING: CPU: 2 PID: 15715 at lib/refcount.c:28 refcount_warn_saturate+0xd9/0xe0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Call Trace:
 tree_put_node+0xf2/0x140 [mlx5_core]
 clean_tree+0x4e/0xf0 [mlx5_core]
 clean_tree+0x4e/0xf0 [mlx5_core]
 clean_tree+0x4e/0xf0 [mlx5_core]
 clean_tree+0x5f/0xf0 [mlx5_core]
 clean_tree+0x4e/0xf0 [mlx5_core]
 clean_tree+0x5f/0xf0 [mlx5_core]
 mlx5_cleanup_fs+0x26/0x270 [mlx5_core]
 mlx5_unload+0x2e/0xa0 [mlx5_core]
 mlx5_unload_one+0x51/0x120 [mlx5_core]
 mlx5_devlink_reload_down+0x51/0x90 [mlx5_core]
 devlink_reload+0x39/0x120
 ? devlink_nl_cmd_reload+0x43/0x220
 genl_rcv_msg+0x1e4/0x420
 ? genl_family_rcv_msg_attrs_parse+0x100/0x100
 netlink_rcv_skb+0x47/0x110
 genl_rcv+0x24/0x40
 netlink_unicast+0x217/0x2f0
 netlink_sendmsg+0x30f/0x430
 sock_sendmsg+0x30/0x40
 __sys_sendto+0x10e/0x140
 ? handle_mm_fault+0xc4/0x1f0
 ? do_page_fault+0x33f/0x630
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0x48/0x130
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 718ce4d601db ("net/mlx5: Consolidate update FTE for all removal changes")
Fixes: bd71b08ec2ee ("net/mlx5: Support multiple updates of steering rules in parallel")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 9ccec5f8b92a..75fa44eee434 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -654,7 +654,7 @@ static struct fs_fte *alloc_fte(struct mlx5_flow_table *ft,
 	fte->action = *flow_act;
 	fte->flow_context = spec->flow_context;
 
-	tree_init_node(&fte->node, NULL, del_sw_fte);
+	tree_init_node(&fte->node, del_hw_fte, del_sw_fte);
 
 	return fte;
 }
@@ -1792,7 +1792,6 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		up_write_ref_node(&g->node, false);
 		rule = add_rule_fg(g, spec, flow_act, dest, dest_num, fte);
 		up_write_ref_node(&fte->node, false);
-		tree_put_node(&fte->node, false);
 		return rule;
 	}
 	rule = ERR_PTR(-ENOENT);
@@ -1891,7 +1890,6 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 	up_write_ref_node(&g->node, false);
 	rule = add_rule_fg(g, spec, flow_act, dest, dest_num, fte);
 	up_write_ref_node(&fte->node, false);
-	tree_put_node(&fte->node, false);
 	tree_put_node(&g->node, false);
 	return rule;
 
@@ -2001,7 +1999,9 @@ void mlx5_del_flow_rules(struct mlx5_flow_handle *handle)
 		up_write_ref_node(&fte->node, false);
 	} else {
 		del_hw_fte(&fte->node);
-		up_write(&fte->node.lock);
+		/* Avoid double call to del_hw_fte */
+		fte->node.del_hw_func = NULL;
+		up_write_ref_node(&fte->node, false);
 		tree_put_node(&fte->node, false);
 	}
 	kfree(handle);
-- 
2.26.2

