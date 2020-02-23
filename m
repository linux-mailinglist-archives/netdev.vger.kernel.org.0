Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A2116975B
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 12:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgBWLpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 06:45:38 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49047 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725980AbgBWLpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 06:45:38 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Feb 2020 13:45:36 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01NBjZEW006598;
        Sun, 23 Feb 2020 13:45:36 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 3/6] netfilter: flowtable: add cleanup callback from garbage collector
Date:   Sun, 23 Feb 2020 13:45:04 +0200
Message-Id: <1582458307-17067-4-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

This new cleanup callback is called whenever garbage collector counts
no entries in the flowtable. This patch is useful for the act_tc
infrastructure which releases the flowtable if it gets empty.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 include/net/netfilter/nf_flow_table.h | 1 +
 net/netfilter/nf_flow_table_core.c    | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index e0f709d9..ba65cf0 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -27,6 +27,7 @@ struct nf_flowtable_type {
 						  const struct flow_offload *flow,
 						  enum flow_offload_tuple_dir dir,
 						  struct nf_flow_rule *flow_rule);
+	int				(*cleanup)(struct nf_flowtable *ft);
 	void				(*free)(struct nf_flowtable *ft);
 	nf_hookfn			*hook;
 	struct module			*owner;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 83bc456..e209bbe 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -367,9 +367,15 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 static void nf_flow_offload_work_gc(struct work_struct *work)
 {
 	struct nf_flowtable *flow_table;
+	int err, cnt;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+	cnt = nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+	if (cnt == 0 && flow_table->type->cleanup) {
+		err = flow_table->type->cleanup(flow_table);
+		if (!err)
+			return;
+	}
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
-- 
1.8.3.1

