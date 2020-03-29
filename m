Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48FD8196B8F
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 09:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgC2G4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 02:56:31 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:35408 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgC2G4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 02:56:30 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 792B541107;
        Sun, 29 Mar 2020 14:56:00 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com, paulb@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net/mlx5e: avoid check the hw_stats of flow_action for FT flow
Date:   Sun, 29 Mar 2020 14:56:00 +0800
Message-Id: <1585464960-6204-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPTUhCQkJCQ01NT0NOTVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nww6Ojo5EDgyNBA6NjY*KgEw
        SiwwFD1VSlVKTkNOT01PQk1LTkxIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpOTEw3Bg++
X-HM-Tid: 0a71251365fb2086kuqy792b541107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The hw_stats in flow_action can't be supported in nftable
flowtables. This check will lead the nft flowtable offload
failed. So don't check the hw_stats of flow_action for FT
flow.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 901b5fa..4666015 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3703,7 +3703,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
-	if (!flow_action_hw_stats_check(flow_action, extack,
+	if (!ft_flow &&
+	    !flow_action_hw_stats_check(flow_action, extack,
 					FLOW_ACTION_HW_STATS_DELAYED_BIT))
 		return -EOPNOTSUPP;
 
-- 
1.8.3.1

