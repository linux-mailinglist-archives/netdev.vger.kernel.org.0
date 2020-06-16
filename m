Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987AF1FA69E
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgFPDVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:21:14 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:42618 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFPDVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:21:14 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 3776341901;
        Tue, 16 Jun 2020 11:19:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org, vladbu@mellanox.com
Subject: [PATCH net v3 4/4] flow_offload: fix the list_del corruption in the driver list
Date:   Tue, 16 Jun 2020 11:19:40 +0800
Message-Id: <1592277580-5524-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUtOS0tLS09JQkpOSE9ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXMjULOBw4FQ0BDys0DhMeIyNCSTocVlZVTUxNQihJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OAw6FTo5OTgzFTY2KC0qCTcd
        DksaCwtVSlVKTkJJSUxMTkNIT0tDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlCSUI3Bg++
X-HM-Tid: 0a72bb23c5d32086kuqy3776341901
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
 net/netfilter/nf_flow_table_offload.c | 1 +
 net/netfilter/nf_tables_offload.c     | 1 +
 net/sched/cls_api.c                   | 1 +
 3 files changed, 3 insertions(+)

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
index 185fc82..c7cf1cd 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -296,6 +296,7 @@ static void nft_indr_block_cleanup(struct flow_block_cb *block_cb)
 	nft_flow_block_offload_init(&bo, dev_net(dev), FLOW_BLOCK_UNBIND,
 				    basechain, &extack);
 	mutex_lock(&net->nft.commit_mutex);
+	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
 	nft_flow_offload_unbind(&bo, basechain);
 	mutex_unlock(&net->nft.commit_mutex);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 86c3937..faa78b7 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -652,6 +652,7 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 			       &block->flow_block, tcf_block_shared(block),
 			       &extack);
 	down_write(&block->cb_lock);
+	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
 	up_write(&block->cb_lock);
 	rtnl_lock();
-- 
1.8.3.1

