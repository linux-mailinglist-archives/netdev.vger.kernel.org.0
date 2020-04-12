Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084401A5D8D
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 10:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgDLIqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 04:46:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37453 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725832AbgDLIqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 04:46:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Apr 2020 11:46:18 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03C8kIxe023441;
        Sun, 12 Apr 2020 11:46:18 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, davem@davemloft.net
Cc:     Jiri Pirko <jiri@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net] netfilter: flowtable: Free block_cb when being deleted
Date:   Sun, 12 Apr 2020 11:45:47 +0300
Message-Id: <20200412084547.2217-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Free block_cb memory when asked to be deleted.

Fixes: 978703f42549 ("netfilter: flowtable: Add API for registering to flow table events")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 net/netfilter/nf_flow_table_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index c0cb79495c35..4344e572b7f9 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -421,10 +421,12 @@ void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 
 	down_write(&flow_table->flow_block_lock);
 	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
-	if (block_cb)
+	if (block_cb) {
 		list_del(&block_cb->list);
-	else
+		flow_block_cb_free(block_cb);
+	} else {
 		WARN_ON(true);
+	}
 	up_write(&flow_table->flow_block_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_del_cb);
-- 
2.8.4

