Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416FB40303E
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 23:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348815AbhIGVZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 17:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348373AbhIGVZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 17:25:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53CC761090;
        Tue,  7 Sep 2021 21:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049870;
        bh=xfKb0TFSt7+jKKF/ohyaySpSk7pyyTIJ+oDaVr2ZNgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljj/lDL+RbRSwr3yGCI7SM+Ah5J6E1YaBKIkauxzUplMETWX1WMjHqzTJRqb62NsQ
         pccFCU+E5RhMCGXHWzaP0az+smR4BYXll2Mx76FH+So3QMG8cUfLchbbTwoCF8VIOd
         de5nSP1OW9ocQWOSIZ5T6N3KH3zwB7bwutoINqLeXipVJTJRPFGJukRl2RKExHoxP2
         o6UKhJwxp9k58+1doIKQPFhgnS6VvYqfrNw6vFlMLHSPrVPWyLnP/fTGPpTric/vWi
         avLuGrGxrJrgZaGImvhvxhWi2CsmwasKBJ1geQKCWbWWsbyo/vhb2u8f8DQlnmHnFq
         TFJd75VVaOGPg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/7] net/mlx5: Fix potential sleeping in atomic context
Date:   Tue,  7 Sep 2021 14:24:18 -0700
Message-Id: <20210907212420.28529-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210907212420.28529-1-saeed@kernel.org>
References: <20210907212420.28529-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Fixes the below flow of sleeping in atomic context by releasing
the RCU lock before calling to free_match_list.

build_match_list() <- disables preempt
-> free_match_list()
   -> tree_put_node()
      -> down_write_ref_node() <- take write lock

Fixes: 693c6883bbc4 ("net/mlx5: Add hash table for flow groups in flow table")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 9fe8e3c204d6..fe501ba88bea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1682,14 +1682,13 @@ static int build_match_list(struct match_list *match_head,
 
 		curr_match = kmalloc(sizeof(*curr_match), GFP_ATOMIC);
 		if (!curr_match) {
+			rcu_read_unlock();
 			free_match_list(match_head, ft_locked);
-			err = -ENOMEM;
-			goto out;
+			return -ENOMEM;
 		}
 		curr_match->g = g;
 		list_add_tail(&curr_match->list, &match_head->list);
 	}
-out:
 	rcu_read_unlock();
 	return err;
 }
-- 
2.31.1

