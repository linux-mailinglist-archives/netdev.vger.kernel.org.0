Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD51A1F6083
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 05:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgFKDaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 23:30:23 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:49611 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgFKDaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 23:30:22 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id D620A41ED5;
        Thu, 11 Jun 2020 11:30:19 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org
Subject: [PATCH net 1/2] flow_offload: fix incorrect cb_priv check for flow_block_cb
Date:   Thu, 11 Jun 2020 11:30:16 +0800
Message-Id: <1591846217-3514-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIS0hCQkJCS0tDSkxDTFlXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWRcyNQs4HD9IPTATNwsePR4iMg8QOhxWVlVJTUtIQyhJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MlE6USo5Tzg2IzABLzNDHgwK
        TQFPFA1VSlVKTkJKQ09NSUpCQkNIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlITk83Bg++
X-HM-Tid: 0a72a16db07d2086kuqyd620a41ed5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The cb_priv in the flow_indr_dev_unregister get from the driver
is the same as cb_priv of flow_indr_dev. But it  always isn't
the same as cb_priv of flow_block_cb which leads miss cleanup operation.

For mlx5e example the cb_priv of flow_indr_dev is the mlx5e_rep_priv
which related to real hw device and the cb_priv of flow_block_cb is
the indr_priv which related to indr tunnel device.

Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/core/flow_offload.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 0cfc35e..5ceb2d1 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -372,14 +372,13 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 }
 EXPORT_SYMBOL(flow_indr_dev_register);
 
-static void __flow_block_indr_cleanup(flow_setup_cb_t *setup_cb, void *cb_priv,
+static void __flow_block_indr_cleanup(flow_setup_cb_t *setup_cb,
 				      struct list_head *cleanup_list)
 {
 	struct flow_block_cb *this, *next;
 
 	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
-		if (this->cb == setup_cb &&
-		    this->cb_priv == cb_priv) {
+		if (this->cb == setup_cb) {
 			list_move(&this->indr.list, cleanup_list);
 			return;
 		}
@@ -418,7 +417,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 		return;
 	}
 
-	__flow_block_indr_cleanup(setup_cb, cb_priv, &cleanup_list);
+	__flow_block_indr_cleanup(setup_cb, &cleanup_list);
 	mutex_unlock(&flow_indr_block_lock);
 
 	flow_block_indr_notify(&cleanup_list);
-- 
1.8.3.1

