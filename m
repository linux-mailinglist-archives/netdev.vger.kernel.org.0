Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C83E16033F
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgBPKBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:01:47 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52964 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727592AbgBPKBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:46 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:39 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1cdx007834;
        Sun, 16 Feb 2020 12:01:39 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next v3 03/16] net: sched: Change the block's chain list to an rcu list
Date:   Sun, 16 Feb 2020 12:01:23 +0200
Message-Id: <1581847296-19194-4-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow lookup of a block's chain under atomic context.

Co-developed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 Changelog:
   v2->v3
       Split from v2 first patch

 net/sched/cls_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 0a29747..79c4503 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -22,6 +22,7 @@
 #include <linux/idr.h>
 #include <linux/rhashtable.h>
 #include <linux/jhash.h>
+#include <linux/rculist.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -354,7 +355,7 @@ static struct tcf_chain *tcf_chain_create(struct tcf_block *block,
 	chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 	if (!chain)
 		return NULL;
-	list_add_tail(&chain->list, &block->chain_list);
+	list_add_tail_rcu(&chain->list, &block->chain_list);
 	mutex_init(&chain->filter_chain_lock);
 	chain->block = block;
 	chain->index = chain_index;
@@ -394,7 +395,7 @@ static bool tcf_chain_detach(struct tcf_chain *chain)
 
 	ASSERT_BLOCK_LOCKED(block);
 
-	list_del(&chain->list);
+	list_del_rcu(&chain->list);
 	if (!chain->index)
 		block->chain0.chain = NULL;
 
-- 
1.8.3.1

