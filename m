Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CB61F767A
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 12:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgFLKIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 06:08:36 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:19791 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgFLKIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 06:08:36 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 819FE410B0;
        Fri, 12 Jun 2020 18:08:31 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org, vladbu@mellanox.com
Subject: [PATCH net 2/2] flow_offload: fix the list_del corruption in the driver list
Date:   Fri, 12 Jun 2020 18:08:30 +0800
Message-Id: <1591956510-15051-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591956510-15051-1-git-send-email-wenxu@ucloud.cn>
References: <1591956510-15051-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJCS0tLS0tLQk5ITUxZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdMjULOBw4IwEpEB0tNDUeEg89DjocVlZVSk1KQihJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OhQ6Cww4GDg1CTAIHxIILAED
        FU4KCipVSlVKTkJKQk5NTkpKTU9MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9OS0g3Bg++
X-HM-Tid: 0a72a8009b432086kuqy819fe410b0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When a indr device add in offload success. After the representor
go away. All the flow_block_cb cleanup but miss del form driver
list.

Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 1 -
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 1 -
 net/netfilter/nf_flow_table_offload.c               | 1 +
 net/netfilter/nf_tables_offload.c                   | 1 +
 net/sched/cls_api.c                                 | 1 +
 6 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 042c285..536c381 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1932,7 +1932,6 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
 			return -ENOENT;
 
 		flow_block_cb_remove(block_cb, f);
-		list_del(&block_cb->driver_list);
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 187f84c..cf53c21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -459,7 +459,6 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 			return -ENOENT;
 
 		flow_block_cb_remove(block_cb, f);
-		list_del(&block_cb->driver_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index ca2f01a..c3965af 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1701,7 +1701,6 @@ void nfp_flower_setup_indr_tc_release(void *cb_priv)
 			return -ENOENT;
 
 		flow_block_cb_remove(block_cb, f);
-		list_del(&block_cb->driver_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 62651e6..5fff1e0 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -950,6 +950,7 @@ static void nf_flow_table_indr_cleanup(struct flow_block_cb *block_cb)
 	nf_flow_table_gc_cleanup(flowtable, dev);
 	down_write(&flowtable->flow_block_lock);
 	list_del(&block_cb->list);
+	list_del(&block_cb->driver_list);
 	flow_block_cb_free(block_cb);
 	up_write(&flowtable->flow_block_lock);
 }
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 185fc82..e2f54d8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -226,6 +226,7 @@ static int nft_flow_offload_unbind(struct flow_block_offload *bo,
 
 	list_for_each_entry_safe(block_cb, next, &bo->cb_list, list) {
 		list_del(&block_cb->list);
+		list_del(&block_cb->driver_list);
 		flow_block_cb_free(block_cb);
 	}
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a00a203..f00fcaf 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1487,6 +1487,7 @@ static void tcf_block_unbind(struct tcf_block *block,
 					    tcf_block_offload_in_use(block),
 					    NULL);
 		list_del(&block_cb->list);
+		list_del(&block_cb->driver_list);
 		flow_block_cb_free(block_cb);
 		if (!bo->unlocked_driver_cb)
 			block->lockeddevcnt--;
-- 
1.8.3.1

