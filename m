Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9488674CF9
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 13:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391808AbfGYLYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 07:24:17 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:31458 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391270AbfGYLYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 07:24:17 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 12E5F41AAE;
        Thu, 25 Jul 2019 19:24:14 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net/mlx5e: Fix zero table prio set by user.
Date:   Thu, 25 Jul 2019 19:24:07 +0800
Message-Id: <1564053847-28756-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVMTUxCQkJDQ0xPTU1PSFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NC46GSo5Pzg2KlZLDQg#Tjw1
        AjFPCzlVSlVKTk1PS05IQ05PSkpKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpMQ083Bg++
X-HM-Tid: 0a6c28dfd7852086kuqy12e5f41aae
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The flow_cls_common_offload prio is zero

It leads the invalid table prio in hw.

Error: Could not process rule: Invalid argument

kernel log:
mlx5_core 0000:81:00.0: E-Switch: Failed to create FDB Table err -22 (table prio: 65535, level: 0, size: 4194304)

table_prio = (chain * FDB_MAX_PRIO) + prio - 1;
should check (chain * FDB_MAX_PRIO) + prio is not 0

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 089ae4d..64ca90f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -970,7 +970,9 @@ static int esw_add_fdb_miss_rule(struct mlx5_eswitch *esw)
 		flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
 			  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 
-	table_prio = (chain * FDB_MAX_PRIO) + prio - 1;
+	table_prio = (chain * FDB_MAX_PRIO) + prio;
+	if (table_prio)
+		table_prio = table_prio - 1;
 
 	/* create earlier levels for correct fs_core lookup when
 	 * connecting tables
-- 
1.8.3.1

