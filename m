Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C1F1C6F48
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgEFL0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:26:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38472 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727802AbgEFL0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:26:34 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 6 May 2020 14:26:32 +0300
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 046BQWek017451;
        Wed, 6 May 2020 14:26:32 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH net] netfilter: flowtable: Add pending bit for offload work
Date:   Wed,  6 May 2020 14:24:39 +0300
Message-Id: <1588764279-12166-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gc step can queue offloaded flow del work or stats work.
Those work items can race each other and a flow could be freed
before the stats work is executed and querying it.
To avoid that, add a pending bit that if a work exists for a flow
don't queue another work for it.
This will also avoid adding multiple stats works in case stats work
didn't complete but gc step started again.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 include/net/netfilter/nf_flow_table.h | 1 +
 net/netfilter/nf_flow_table_offload.c | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 6bf6965..c54a7f7 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -127,6 +127,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_REFRESH,
+	NF_FLOW_HW_PENDING,
 };
 
 enum flow_offload_type {
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b9d5ecc..731d738 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -817,6 +817,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 			WARN_ON_ONCE(1);
 	}
 
+	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
 	kfree(offload);
 }
 
@@ -831,9 +832,14 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 {
 	struct flow_offload_work *offload;
 
+	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
+		return NULL;
+
 	offload = kmalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
-	if (!offload)
+	if (!offload) {
+		clear_bit(NF_FLOW_HW_PENDING, &flow->flags);
 		return NULL;
+	}
 
 	offload->cmd = cmd;
 	offload->flow = flow;
-- 
1.8.3.1

