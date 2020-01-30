Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0621514DE58
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 17:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgA3QEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 11:04:54 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60211 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727332AbgA3QEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 11:04:54 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Jan 2020 18:04:47 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00UG4khf004757;
        Thu, 30 Jan 2020 18:04:47 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Majd Dibbiny <majd@mellanox.com>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/3] netfilter: flowtable: Fix hardware flush order on nf_flow_table_cleanup
Date:   Thu, 30 Jan 2020 18:04:35 +0200
Message-Id: <1580400277-6305-2-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1580400277-6305-1-git-send-email-paulb@mellanox.com>
References: <1580400277-6305-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On netdev down event, nf_flow_table_cleanup() is called for the relevant
device and it cleans all the tables that are on that device.
If one of those tables has hardware offload flag,
nf_flow_table_iterate_cleanup flushes hardware and then runs the gc.
But the gc can queue more hardware work, which will take time to execute.

Instead first add the work, then flush it, to execute it now.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/netfilter/nf_flow_table_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7e91989..14a069c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -529,9 +529,9 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
 					  struct net_device *dev)
 {
-	nf_flow_table_offload_flush(flowtable);
 	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
 	flush_delayed_work(&flowtable->gc_work);
+	nf_flow_table_offload_flush(flowtable);
 }
 
 void nf_flow_table_cleanup(struct net_device *dev)
-- 
1.8.3.1

