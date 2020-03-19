Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E5518B084
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 10:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgCSJwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 05:52:33 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38638 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725768AbgCSJwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 05:52:33 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 Mar 2020 11:52:27 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02J9qR8N027392;
        Thu, 19 Mar 2020 11:52:27 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH net] netfilter: flowtable: Fix flushing of offloaded flows on free
Date:   Thu, 19 Mar 2020 11:52:25 +0200
Message-Id: <1584611545-926-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Freeing a flowtable with offloaded flows, the flow are deleted from
hardware but are not deleted from the flow table, leaking them,
and leaving their offload bit on.

Add a second pass of the disabled gc to delete the these flows from
the flow table before freeing it.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/netfilter/nf_flow_table_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8af28e1..70ebeba 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -554,6 +554,9 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	nf_flow_table_offload_flush(flow_table);
+	if (nf_flowtable_hw_offload(flow_table))
+		nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step,
+				      flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
-- 
1.8.3.1

