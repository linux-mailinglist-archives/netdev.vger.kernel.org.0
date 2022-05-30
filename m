Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C3D537F5E
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbiE3NwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiE3Ntm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:49:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F0EA888F;
        Mon, 30 May 2022 06:34:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30C1C60E9B;
        Mon, 30 May 2022 13:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD73C385B8;
        Mon, 30 May 2022 13:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917689;
        bh=T9ddK/VDvhMSsfvf3k5nl4oJXUGGQQ7iH45F3BjDN2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7Z65Woo7QHHdbYvoyH6Lx6izwDVA1fvG7b2nb5F1VALqcmdRgwSlp6hXiWXBZ21V
         fuuHHRM1YNi6RSsmrra8ouRPj8R0QPG8tD+8UzJ1aITzvzSO6r+8Af2XxNAGUWK94+
         IfKNXe336dvlYvoU2QMULiTz8Gwdf0c7Tsik99pf44pgOBsgZMvZmbkRhei4sn/k5W
         6lTIlsS77pvTvbxEJwR7WsO75oB9aCSLB1sL9mWl8AXbyMqZJ1AT3PIGie4qOX5rHz
         5rTFfppctFEMXb8EtNTaK41c/LHruvAi39c13ArcffnGDOO7I/f2c3zLJ9fUuQWhpP
         RrWgYBaSX9xTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bloch <mbloch@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 064/135] net/mlx5: fs, delete the FTE when there are no rules attached to it
Date:   Mon, 30 May 2022 09:30:22 -0400
Message-Id: <20220530133133.1931716-64-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 7b0c6338597613f465d131bd939a51844a00455a ]

When an FTE has no children is means all the rules where removed
and the FTE can be deleted regardless of the dests_size value.
While dests_size should be 0 when there are no children
be extra careful not to leak memory or get firmware syndrome
if the proper bookkeeping of dests_size wasn't done.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index b6f58d16d145..298c614c631b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2064,16 +2064,16 @@ void mlx5_del_flow_rules(struct mlx5_flow_handle *handle)
 	down_write_ref_node(&fte->node, false);
 	for (i = handle->num_rules - 1; i >= 0; i--)
 		tree_remove_node(&handle->rule[i]->node, true);
-	if (fte->dests_size) {
-		if (fte->modify_mask)
-			modify_fte(fte);
-		up_write_ref_node(&fte->node, false);
-	} else if (list_empty(&fte->node.children)) {
+	if (list_empty(&fte->node.children)) {
 		del_hw_fte(&fte->node);
 		/* Avoid double call to del_hw_fte */
 		fte->node.del_hw_func = NULL;
 		up_write_ref_node(&fte->node, false);
 		tree_put_node(&fte->node, false);
+	} else if (fte->dests_size) {
+		if (fte->modify_mask)
+			modify_fte(fte);
+		up_write_ref_node(&fte->node, false);
 	} else {
 		up_write_ref_node(&fte->node, false);
 	}
-- 
2.35.1

