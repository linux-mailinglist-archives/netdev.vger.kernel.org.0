Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D004C0B6B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbiBWFKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiBWFKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:10:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3A25F4DC;
        Tue, 22 Feb 2022 21:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B57D060C51;
        Wed, 23 Feb 2022 05:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25B5C340F4;
        Wed, 23 Feb 2022 05:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645593011;
        bh=QDPPmVXPHInsejevg3RYHIQX/gQP4aASDaADIrdxBk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRIFUwSB0Qfz/077mK87f8aljDaNJjgWZ/43lzuloVV8TLt3St87Rnwgsxrl8wZ7/
         DXgpAyEtqcmgg5jZMa2os0t3Tl1FdpoYamJ0x2PRZqY3SvCVZn1UyalHa7CjmtG75h
         aszqBI5UKvm08R6/cFKweBdVnabhXlSooGUK3mIXU4ZD6tbhB9qYuGUZt206MP/qK/
         hVxB+xg20rp2rXVt5jqjsD24fNEJlmOkdzFrz49Lu4gDA5y/yzGyZslSTzBWLeCGcR
         +oyj5FcKQ4ZyVWVD/n1ZrmmisOcVXmJ73Mi+g9wF5M9ATOmHvAJWHnQH/jtjD9NfZ1
         A6IwG6hZMnvTg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [mlx5-next 02/17] net/mlx5: Add ability to insert to specific flow group
Date:   Tue, 22 Feb 2022 21:09:17 -0800
Message-Id: <20220223050932.244668-3-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223050932.244668-1-saeed@kernel.org>
References: <20220223050932.244668-1-saeed@kernel.org>
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

From: Mark Bloch <mbloch@nvidia.com>

If the flow table isn't an autogroup the upper driver has to create the
flow groups explicitly. This information can't later be used when
creating rules to insert into a specific flow group. Allow such use case.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 9 ++++++++-
 include/linux/mlx5/fs.h                           | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index b628917e38e4..ebb7960ec62b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1696,6 +1696,7 @@ static void free_match_list(struct match_list *head, bool ft_locked)
 static int build_match_list(struct match_list *match_head,
 			    struct mlx5_flow_table *ft,
 			    const struct mlx5_flow_spec *spec,
+			    struct mlx5_flow_group *fg,
 			    bool ft_locked)
 {
 	struct rhlist_head *tmp, *list;
@@ -1710,6 +1711,9 @@ static int build_match_list(struct match_list *match_head,
 	rhl_for_each_entry_rcu(g, tmp, list, hash) {
 		struct match_list *curr_match;
 
+		if (fg && fg != g)
+			continue;
+
 		if (unlikely(!tree_get_node(&g->node)))
 			continue;
 
@@ -1889,6 +1893,9 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 	if (!check_valid_spec(spec))
 		return ERR_PTR(-EINVAL);
 
+	if (flow_act->fg && ft->autogroup.active)
+		return ERR_PTR(-EINVAL);
+
 	for (i = 0; i < dest_num; i++) {
 		if (!dest_is_valid(&dest[i], flow_act, ft))
 			return ERR_PTR(-EINVAL);
@@ -1898,7 +1905,7 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 	version = atomic_read(&ft->node.version);
 
 	/* Collect all fgs which has a matching match_criteria */
-	err = build_match_list(&match_head, ft, spec, take_write);
+	err = build_match_list(&match_head, ft, spec, flow_act->fg, take_write);
 	if (err) {
 		if (take_write)
 			up_write_ref_node(&ft->node, false);
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index b1aad14689e3..e3bfed68b08a 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -224,6 +224,7 @@ struct mlx5_flow_act {
 	u32 flags;
 	struct mlx5_fs_vlan vlan[MLX5_FS_VLAN_DEPTH];
 	struct ib_counters *counters;
+	struct mlx5_flow_group *fg;
 };
 
 #define MLX5_DECLARE_FLOW_ACT(name) \
-- 
2.35.1

