Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84D31FA69D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgFPDU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:20:29 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:38586 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgFPDU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:20:28 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 77CE641EFB;
        Tue, 16 Jun 2020 11:19:42 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org, vladbu@mellanox.com
Subject: [PATCH net v3 2/4] flow_offload: fix incorrect cb_priv check for flow_block_cb
Date:   Tue, 16 Jun 2020 11:19:38 +0800
Message-Id: <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUtOS0tLS09JQkpOSE9ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdMjULOBw4MwMpFzQ0DhMeITIxTjocVlZVSktPSihJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ngg6TTo*KTgrPzYfKCxCCStK
        EDQwC0xVSlVKTkJJSUxMTkNJTUNKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9ISEg3Bg++
X-HM-Tid: 0a72bb23c2aa2086kuqy77ce641efb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the function __flow_block_indr_cleanup, The match stataments
this->cb_priv == cb_priv is always false, the flow_block_cb->cb_priv
is totally different data with the flow_indr_dev->cb_priv.

Store the representor cb_priv to the flow_block_cb->indr.cb_priv in
the driver.

Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 1 +
 include/net/flow_offload.h                          | 1 +
 net/core/flow_offload.c                             | 2 +-
 5 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index ef7f6bc..042c285 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1918,6 +1918,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
 
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &bnxt_block_cb_list);
+		block_cb->indr.cb_priv = bp;
 		break;
 	case FLOW_BLOCK_UNBIND:
 		cb_priv = bnxt_tc_indr_block_cb_lookup(bp, netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index a62bcf0..187f84c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -447,7 +447,7 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 		}
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &mlx5e_block_cb_list);
-
+		block_cb->indr.cb_priv = rpriv;
 		return 0;
 	case FLOW_BLOCK_UNBIND:
 		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 28de905..ca2f01a 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1687,6 +1687,7 @@ void nfp_flower_setup_indr_tc_release(void *cb_priv)
 
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &nfp_block_cb_list);
+		block_cb->indr.cb_priv = app;
 		return 0;
 	case FLOW_BLOCK_UNBIND:
 		cb_priv = nfp_flower_indr_block_cb_priv_lookup(app, netdev);
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3a2d6b4..ef4d8b0 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -450,6 +450,7 @@ struct flow_block_indr {
 	struct net_device		*dev;
 	enum flow_block_binder_type	binder_type;
 	void				*data;
+	void				*cb_priv;
 	void				(*cleanup)(struct flow_block_cb *block_cb);
 };
 
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index b288d2f..6614351 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -380,7 +380,7 @@ static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
 
 	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
 		if (this->release == release &&
-		    this->cb_priv == cb_priv) {
+		    this->indr.cb_priv == cb_priv) {
 			list_move(&this->indr.list, cleanup_list);
 			return;
 		}
-- 
1.8.3.1

