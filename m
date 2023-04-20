Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6A66E872C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjDTBKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjDTBKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:10:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5048246B2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDD6064444
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC9FC433EF;
        Thu, 20 Apr 2023 01:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953011;
        bh=cW72OyrP7LC6E5ZheoqQPt8yEq+y8jteUV2SRLipE6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOnQTAvsK+M6fhhKKtzvCfsFOxQZYPyUf/7GwrYb+N3kI8w8kIDS02FncdlqD+FhY
         ifGJMKIsnht03r1aVNfdH3Pq9oWL4SZB2HFhRzj52mMvfwp9ITfPiMotb4Qv2p2vaP
         p6izrtjJTNI9eWlh8qngl8Uk7HkGZz0frx3ZajTUwQaUn1NKIHOx/OQk+hXEJfpaBU
         hFM+7t5dTYeE5Oq9SM0WWnZHGJER9weezSGcbzlbREiEux3pj1PeMt8qW4LjAXiuf/
         GORT5YWYFx4VINBgzqp7Z7hKnn1CBbWbTiiW+DjgOB9dw+BTXW99p7zoA84V5sAPLT
         YtK7Y2CYqbJnA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net 01/10] net/mlx5e: Don't clone flow post action attributes second time
Date:   Wed, 19 Apr 2023 18:09:50 -0700
Message-Id: <20230420010959.276760-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420010959.276760-1-saeed@kernel.org>
References: <20230420010959.276760-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

The code already clones post action attributes in
mlx5e_clone_flow_attr_for_post_act(). Creating another copy in
mlx5e_tc_post_act_add() is a erroneous leftover from original
implementation. Instead, assign handle->attribute to post_attr provided by
the caller. Note that cloning the attribute second time is not just
wasteful but also causes issues like second copy not being properly updated
in neigh update code which leads to following use-after-free:

Feb 21 09:02:00 c-237-177-40-045 kernel: BUG: KASAN: use-after-free in mlx5_cmd_set_fte+0x200d/0x24c0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_report+0xbb/0x1a0
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_stack+0x1e/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_set_track+0x21/0x30
Feb 21 09:02:00 c-237-177-40-045 kernel:  __kasan_kmalloc+0x7a/0x90
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_stack+0x1e/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_set_track+0x21/0x30
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_free_info+0x2a/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  ____kasan_slab_free+0x11a/0x1b0
Feb 21 09:02:00 c-237-177-40-045 kernel: page dumped because: kasan: bad access detected
Feb 21 09:02:00 c-237-177-40-045 kernel: mlx5_core 0000:08:00.0: mlx5_cmd_out_err:803:(pid 8833): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad resource state(0x9), syndrome (0xf2ff71), err(-22)
Feb 21 09:02:00 c-237-177-40-045 kernel: mlx5_core 0000:08:00.0 enp8s0f0: Failed to add post action rule
Feb 21 09:02:00 c-237-177-40-045 kernel: mlx5_core 0000:08:00.0: mlx5e_tc_encap_flows_add:190:(pid 8833): Failed to update flow post acts, -22
Feb 21 09:02:00 c-237-177-40-045 kernel: Call Trace:
Feb 21 09:02:00 c-237-177-40-045 kernel:  <TASK>
Feb 21 09:02:00 c-237-177-40-045 kernel:  dump_stack_lvl+0x57/0x7d
Feb 21 09:02:00 c-237-177-40-045 kernel:  print_report+0x170/0x471
Feb 21 09:02:00 c-237-177-40-045 kernel:  ? mlx5_cmd_set_fte+0x200d/0x24c0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_report+0xbb/0x1a0
Feb 21 09:02:00 c-237-177-40-045 kernel:  ? mlx5_cmd_set_fte+0x200d/0x24c0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5_cmd_set_fte+0x200d/0x24c0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  ? __module_address.part.0+0x62/0x200
Feb 21 09:02:00 c-237-177-40-045 kernel:  ? mlx5_cmd_stub_create_flow_table+0xd0/0xd0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  ? __raw_spin_lock_init+0x3b/0x110
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5_cmd_create_fte+0x80/0xb0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  add_rule_fg+0xe80/0x19c0 [mlx5_core]
--
Feb 21 09:02:00 c-237-177-40-045 kernel: Allocated by task 13476:
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_stack+0x1e/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_set_track+0x21/0x30
Feb 21 09:02:00 c-237-177-40-045 kernel:  __kasan_kmalloc+0x7a/0x90
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5_packet_reformat_alloc+0x7b/0x230 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_tc_tun_create_header_ipv4+0x977/0xf10 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_attach_encap+0x15b4/0x1e10 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  post_process_attr+0x305/0xa30 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_tc_add_fdb_flow+0x4c0/0xcf0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  __mlx5e_add_fdb_flow+0x7cf/0xe90 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_configure_flower+0xcaa/0x4b90 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_rep_setup_tc_cls_flower+0x99/0x1b0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_rep_setup_tc_cb+0x133/0x1e0 [mlx5_core]
--
Feb 21 09:02:00 c-237-177-40-045 kernel: Freed by task 8833:
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_stack+0x1e/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_set_track+0x21/0x30
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_free_info+0x2a/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  ____kasan_slab_free+0x11a/0x1b0
Feb 21 09:02:00 c-237-177-40-045 kernel:  __kmem_cache_free+0x1de/0x400
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5_packet_reformat_dealloc+0xad/0x100 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_tc_encap_flows_del+0x3c0/0x500 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_rep_update_flows+0x40c/0xa80 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_rep_neigh_update+0x473/0x7a0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  process_one_work+0x7c2/0x1310
Feb 21 09:02:00 c-237-177-40-045 kernel:  worker_thread+0x59d/0xec0
Feb 21 09:02:00 c-237-177-40-045 kernel:  kthread+0x28f/0x330

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/post_act.c  | 11 ++---------
 .../net/ethernet/mellanox/mlx5/core/en/tc/post_act.h  |  2 +-
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index 4e48946c4c2a..0290e0dea539 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -106,22 +106,17 @@ mlx5e_tc_post_act_offload(struct mlx5e_post_act *post_act,
 }
 
 struct mlx5e_post_act_handle *
-mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *attr)
+mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *post_attr)
 {
-	u32 attr_sz = ns_to_attr_sz(post_act->ns_type);
 	struct mlx5e_post_act_handle *handle;
-	struct mlx5_flow_attr *post_attr;
 	int err;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	post_attr = mlx5_alloc_flow_attr(post_act->ns_type);
-	if (!handle || !post_attr) {
-		kfree(post_attr);
+	if (!handle) {
 		kfree(handle);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	memcpy(post_attr, attr, attr_sz);
 	post_attr->chain = 0;
 	post_attr->prio = 0;
 	post_attr->ft = post_act->ft;
@@ -145,7 +140,6 @@ mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *at
 	return handle;
 
 err_xarray:
-	kfree(post_attr);
 	kfree(handle);
 	return ERR_PTR(err);
 }
@@ -164,7 +158,6 @@ mlx5e_tc_post_act_del(struct mlx5e_post_act *post_act, struct mlx5e_post_act_han
 	if (!IS_ERR_OR_NULL(handle->rule))
 		mlx5e_tc_post_act_unoffload(post_act, handle);
 	xa_erase(&post_act->ids, handle->id);
-	kfree(handle->attr);
 	kfree(handle);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
index f476774c0b75..40b8df184af5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
@@ -19,7 +19,7 @@ void
 mlx5e_tc_post_act_destroy(struct mlx5e_post_act *post_act);
 
 struct mlx5e_post_act_handle *
-mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *attr);
+mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *post_attr);
 
 void
 mlx5e_tc_post_act_del(struct mlx5e_post_act *post_act, struct mlx5e_post_act_handle *handle);
-- 
2.39.2

