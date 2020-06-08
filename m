Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636C51F2C81
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733034AbgFIAY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730398AbgFHXRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D53E02086A;
        Mon,  8 Jun 2020 23:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658225;
        bh=y7B7DXueva7KEtGBWWvMlKUUR6TEa+EXPVc0K1XHINU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/PeyiTR1SituUNyymXUZWzqo8xT7da1nUFZ3hZvoxLBi1g6A9RRddYUhFC0ppdKn
         mqzDqm0j8t7aL2+DltF0XoYgYsi8uYCU2G4JbqFPntaDRV35jZnQgWBIJ327zSjAjk
         TP+cRXcjNujQerRFHRY2ea5T8Ls1DyxNujK8pUHc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 239/606] net/mlx5: Fix cleaning unmanaged flow tables
Date:   Mon,  8 Jun 2020 19:06:04 -0400
Message-Id: <20200608231211.3363633-239-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

[ Upstream commit aee37f3d940ca732df71c3df49347bccaafc0b24 ]

Unmanaged flow tables doesn't have a parent and tree_put_node()
assume there is always a parent if cleaning is needed. fix that.

Fixes: 5281a0c90919 ("net/mlx5: fs_core: Introduce unmanaged flow tables")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 9dc24241dc91..cdc566768a07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -323,14 +323,13 @@ static void tree_put_node(struct fs_node *node, bool locked)
 		if (node->del_hw_func)
 			node->del_hw_func(node);
 		if (parent_node) {
-			/* Only root namespace doesn't have parent and we just
-			 * need to free its node.
-			 */
 			down_write_ref_node(parent_node, locked);
 			list_del_init(&node->list);
 			if (node->del_sw_func)
 				node->del_sw_func(node);
 			up_write_ref_node(parent_node, locked);
+		} else if (node->del_sw_func) {
+			node->del_sw_func(node);
 		} else {
 			kfree(node);
 		}
@@ -447,8 +446,10 @@ static void del_sw_flow_table(struct fs_node *node)
 	fs_get_obj(ft, node);
 
 	rhltable_destroy(&ft->fgs_hash);
-	fs_get_obj(prio, ft->node.parent);
-	prio->num_ft--;
+	if (ft->node.parent) {
+		fs_get_obj(prio, ft->node.parent);
+		prio->num_ft--;
+	}
 	kfree(ft);
 }
 
-- 
2.25.1

