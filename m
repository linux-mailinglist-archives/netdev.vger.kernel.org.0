Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63161D1B56
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389659AbgEMQl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:41:56 -0400
Received: from correo.us.es ([193.147.175.20]:53980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389423AbgEMQlx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 12:41:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB60727F8BB
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 18:41:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE7955C02C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 18:41:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AAAA5D2D04; Wed, 13 May 2020 18:41:51 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9770F615A4;
        Wed, 13 May 2020 18:41:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 13 May 2020 18:41:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 43EC042EF4E1;
        Wed, 13 May 2020 18:41:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com
Subject: [PATCH 1/8 net] netfilter: nf_flowtable: expose nf_flow_table_gc_cleanup()
Date:   Wed, 13 May 2020 18:41:33 +0200
Message-Id: <20200513164140.7956-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200513164140.7956-1-pablo@netfilter.org>
References: <20200513164140.7956-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function schedules the flow teardown state and it forces a gc run.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 2 ++
 net/netfilter/nf_flow_table_core.c    | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 6bf69652f57d..15e21044e611 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -174,6 +174,8 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
+void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
+			      struct net_device *dev);
 void nf_flow_table_cleanup(struct net_device *dev);
 
 int nf_flow_table_init(struct nf_flowtable *flow_table);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4344e572b7f9..86aeee638ca4 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -586,8 +586,8 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 		flow_offload_teardown(flow);
 }
 
-static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
-					  struct net_device *dev)
+void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
+			      struct net_device *dev)
 {
 	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
 	flush_delayed_work(&flowtable->gc_work);
@@ -600,7 +600,7 @@ void nf_flow_table_cleanup(struct net_device *dev)
 
 	mutex_lock(&flowtable_lock);
 	list_for_each_entry(flowtable, &flowtables, list)
-		nf_flow_table_iterate_cleanup(flowtable, dev);
+		nf_flow_table_gc_cleanup(flowtable, dev);
 	mutex_unlock(&flowtable_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
-- 
2.20.1

