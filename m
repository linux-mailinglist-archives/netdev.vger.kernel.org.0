Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB27C16975D
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 12:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgBWLpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 06:45:39 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47891 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726236AbgBWLpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 06:45:38 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Feb 2020 13:45:36 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01NBjZEV006598;
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
Subject: [PATCH net-next 2/6] netfilter: flowtable: nf_flow_table_iterate() returns the number of entries
Date:   Sun, 23 Feb 2020 13:45:03 +0200
Message-Id: <1582458307-17067-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Update this iterator to return the number of entries in this flowtable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/netfilter/nf_flow_table_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index face98b..83bc456 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -319,7 +319,7 @@ struct flow_offload_tuple_rhash *
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct rhashtable_iter hti;
 	struct flow_offload *flow;
-	int err = 0;
+	int err = 0, cnt = 0;
 
 	rhashtable_walk_enter(&flow_table->rhashtable, &hti);
 	rhashtable_walk_start(&hti);
@@ -338,11 +338,12 @@ struct flow_offload_tuple_rhash *
 		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
 
 		iter(flow_table, flow, data);
+		cnt++;
 	}
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
 
-	return err;
+	return err < 0 ? err : cnt;
 }
 
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
-- 
1.8.3.1

