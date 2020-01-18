Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B405141970
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgARUO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:28 -0500
Received: from correo.us.es ([193.147.175.20]:48418 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgARUO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2E1302EFEAC
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2006DDA712
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 15D81DA70F; Sat, 18 Jan 2020 21:14:26 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10B6DDA703;
        Sat, 18 Jan 2020 21:14:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DE24441E4800;
        Sat, 18 Jan 2020 21:14:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/21] netfilter: flowtable: add nf_flow_offload_work_alloc()
Date:   Sat, 18 Jan 2020 21:14:00 +0100
Message-Id: <20200118201417.334111-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper function to allocate and initialize flow offload work and use
it to consolidate existing code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 38 ++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b879e673953f..d161623107a1 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -748,21 +748,35 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 	schedule_work(&nf_flow_offload_work);
 }
 
-void nf_flow_offload_add(struct nf_flowtable *flowtable,
-			 struct flow_offload *flow)
+static struct flow_offload_work *
+nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
+			   struct flow_offload *flow, unsigned int cmd)
 {
 	struct flow_offload_work *offload;
 
 	offload = kmalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
 	if (!offload)
-		return;
+		return NULL;
 
-	offload->cmd = FLOW_CLS_REPLACE;
+	offload->cmd = cmd;
 	offload->flow = flow;
 	offload->priority = flowtable->priority;
 	offload->flowtable = flowtable;
-	flow->flags |= FLOW_OFFLOAD_HW;
 
+	return offload;
+}
+
+
+void nf_flow_offload_add(struct nf_flowtable *flowtable,
+			 struct flow_offload *flow)
+{
+	struct flow_offload_work *offload;
+
+	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
+	if (!offload)
+		return;
+
+	flow->flags |= FLOW_OFFLOAD_HW;
 	flow_offload_queue_work(offload);
 }
 
@@ -771,15 +785,11 @@ void nf_flow_offload_del(struct nf_flowtable *flowtable,
 {
 	struct flow_offload_work *offload;
 
-	offload = kzalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
+	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_DESTROY);
 	if (!offload)
 		return;
 
-	offload->cmd = FLOW_CLS_DESTROY;
-	offload->flow = flow;
-	offload->flow->flags |= FLOW_OFFLOAD_HW_DYING;
-	offload->flowtable = flowtable;
-
+	flow->flags |= FLOW_OFFLOAD_HW_DYING;
 	flow_offload_queue_work(offload);
 }
 
@@ -793,14 +803,10 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10))
 		return;
 
-	offload = kzalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
+	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_STATS);
 	if (!offload)
 		return;
 
-	offload->cmd = FLOW_CLS_STATS;
-	offload->flow = flow;
-	offload->flowtable = flowtable;
-
 	flow_offload_queue_work(offload);
 }
 
-- 
2.11.0

