Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25696EA13D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjDUBvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjDUBvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:51:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011645599
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:51:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 827F1611EC
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CD0C433D2;
        Fri, 21 Apr 2023 01:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041873;
        bh=fvAfF3l+gcm2vLcjIEcmtvzIUnXvGOqPTRP4dbjasQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIv93RaYRwXmEKneGfkDisfZqxVzD9Bbl2V6QauQyeUvXU5yjUpncjnaSBwUKOJuf
         v1tEXAfmkrnLYkl8vVYTFt6XhC124avOZBuUOJvKfjoIRgnGbH6haTE9hsvT/OPGS9
         xcVkGvnvPKkP45iG4grPJ6C/XBls8tv9y5s7epXFQKWQJG3uTHpOavFrSc6EW4bcoH
         IptneV6iaqcXbBbK6fDG4eG5Fcn24M5u9alBBlKmK9nL628b41cvA/VUWbhVExeH8z
         mqW4YaK7yFkHLsjuM8I5dOvB7QaDQZHXhfW3Cdv6aqbQJhIERXX8ripFpe3Un66fa8
         X5lm1BzkQ/Izg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net V2 02/10] net/mlx5e: Release the label when replacing existing ct entry
Date:   Thu, 20 Apr 2023 18:50:49 -0700
Message-Id: <20230421015057.355468-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421015057.355468-1-saeed@kernel.org>
References: <20230421015057.355468-1-saeed@kernel.org>
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

Cited commit doesn't release the label mapping when replacing existing ct
entry which leads to following memleak report:

unreferenced object 0xffff8881854cf280 (size 96):
  comm "kworker/u48:74", pid 23093, jiffies 4296664564 (age 175.944s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002722d368>] __kmalloc+0x4b/0x1c0
    [<00000000cc44e18f>] mapping_add+0x6e8/0xc90 [mlx5_core]
    [<000000003ad942a7>] mlx5_get_label_mapping+0x66/0xe0 [mlx5_core]
    [<00000000266308ac>] mlx5_tc_ct_entry_create_mod_hdr+0x1c4/0xf50 [mlx5_core]
    [<000000009a768b4f>] mlx5_tc_ct_entry_add_rule+0x16f/0xaf0 [mlx5_core]
    [<00000000a178f3e5>] mlx5_tc_ct_block_flow_offload_add+0x10cb/0x1f90 [mlx5_core]
    [<000000007b46c496>] mlx5_tc_ct_block_flow_offload+0x14a/0x630 [mlx5_core]
    [<00000000a9a18ac5>] nf_flow_offload_tuple+0x1a3/0x390 [nf_flow_table]
    [<00000000d0881951>] flow_offload_work_handler+0x257/0xd30 [nf_flow_table]
    [<000000009e4935a4>] process_one_work+0x7c2/0x13e0
    [<00000000f5cd36a7>] worker_thread+0x59d/0xec0
    [<00000000baed1daf>] kthread+0x28f/0x330
    [<0000000063d282a4>] ret_from_fork+0x1f/0x30

Fix the issue by correctly releasing the label mapping.

Fixes: 94ceffb48eac ("net/mlx5e: Implement CT entry update")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 314983bc6f08..ee49bd2461e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -920,6 +920,7 @@ mlx5_tc_ct_entry_replace_rule(struct mlx5_tc_ct_priv *ct_priv,
 	zone_rule->rule = rule;
 	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, old_attr, zone_rule->mh);
 	zone_rule->mh = mh;
+	mlx5_put_label_mapping(ct_priv, old_attr->ct_attr.ct_labels_id);
 
 	kfree(old_attr);
 	kvfree(spec);
-- 
2.39.2

