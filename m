Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609DD7795D
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 17:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbfG0PAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 11:00:07 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:11396 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfG0PAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 11:00:07 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id BC35E41009;
        Sat, 27 Jul 2019 22:59:55 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org, saeedm@mellanox.com
Subject: [PATCH net] net/mlx5e: Fix unnecessary flow_block_cb_is_busy call
Date:   Sat, 27 Jul 2019 22:59:55 +0800
Message-Id: <1564239595-23786-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPSkpCQkJCT0tDTElKQllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OVE6DQw5Ljg9KkoaLjIhDUo0
        TDUaCQ1VSlVKTk1PSUhCTkJOQ09KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpOSUk3Bg++
X-HM-Tid: 0a6c33f209012086kuqybc35e41009
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When call flow_block_cb_is_busy. The indr_priv is guaranteed to
NULL ptr. So there is no need to call flow_bock_cb_is_busy.

Fixes: 0d4fd02e7199 ("net: flow_offload: add flow_block_cb_is_busy() and use it")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 7f747cb..496d303 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -722,10 +722,6 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
 		if (indr_priv)
 			return -EEXIST;
 
-		if (flow_block_cb_is_busy(mlx5e_rep_indr_setup_block_cb,
-					  indr_priv, &mlx5e_block_cb_list))
-			return -EBUSY;
-
 		indr_priv = kmalloc(sizeof(*indr_priv), GFP_KERNEL);
 		if (!indr_priv)
 			return -ENOMEM;
-- 
1.8.3.1

