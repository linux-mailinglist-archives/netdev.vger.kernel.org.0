Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFE03380B5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhCKWiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230397AbhCKWhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC32864F94;
        Thu, 11 Mar 2021 22:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502261;
        bh=wd4kKlrWLi0wrZXjuF66I8Nbe8CHxvaM2wdGlIXFAas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtzjdOSnHrurq5A5WjPqiMiW14NJWKueHBSB8ud3/DUx+hiSKtIUnI38tvNHTr2G+
         9dEB6BfVKYGwKC2PRTZNV1/2ILYaJNWtOWwzZzkljgok7bsA5c0UWdrV540N5cx9i0
         qc2vMgGawN0AP/R/YLkCYdl6dL4PMGHMrUZ8iISLKDfBZm7u9YWm1Up1xKs9z3DGJR
         o8QqkLUTQLidIEet1smKGbcAcSA0JbncxH82VmVp1FIzoyGJhh6M2H1XmY5KhLlsfT
         LT5XHRVZlUn3HBoYworEUsjYqN8ghSnKrnqHai5KjJuKV2BkfNHZEAX9TpztdprinC
         LoghpLyKulSZw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: Avoid unnecessary operation
Date:   Thu, 11 Mar 2021 14:37:22 -0800
Message-Id: <20210311223723.361301-15-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

fs_get_obj retrieves the container of fs_parent_node just to pass the
same value as &fs_ns->node. Just pass fs_parent_node to
init_root_tree_recursive() to get exactly the same effect.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 66ad599bd488..f5517ea2f6be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2395,14 +2395,12 @@ static int init_root_tree(struct mlx5_flow_steering *steering,
 			  struct init_tree_node *init_node,
 			  struct fs_node *fs_parent_node)
 {
-	int i;
-	struct mlx5_flow_namespace *fs_ns;
 	int err;
+	int i;
 
-	fs_get_obj(fs_ns, fs_parent_node);
 	for (i = 0; i < init_node->ar_size; i++) {
 		err = init_root_tree_recursive(steering, &init_node->children[i],
-					       &fs_ns->node,
+					       fs_parent_node,
 					       init_node, i);
 		if (err)
 			return err;
-- 
2.29.2

