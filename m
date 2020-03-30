Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EA4198441
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgC3TWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:22:04 -0400
Received: from correo.us.es ([193.147.175.20]:48526 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgC3TWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:22:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 09741B496F
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7928FA52A
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B45C112396A; Mon, 30 Mar 2020 21:21:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E546100A63;
        Mon, 30 Mar 2020 21:21:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 21:21:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 34B7042EF4E0;
        Mon, 30 Mar 2020 21:21:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 26/28] netfilter: flowtable: add counter support in HW offload
Date:   Mon, 30 Mar 2020 21:21:34 +0200
Message-Id: <20200330192136.230459-27-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330192136.230459-1-pablo@netfilter.org>
References: <20200330192136.230459-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Store the conntrack counters to the conntrack entry in the
HW flowtable offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index a9b3b88bd0f1..d9547c3d1b85 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -9,6 +9,7 @@
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
@@ -783,6 +784,17 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
 	offload->flow->timeout = max_t(u64, offload->flow->timeout,
 				       lastused + NF_FLOW_TIMEOUT);
+
+	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
+		if (stats[0].pkts)
+			nf_ct_acct_add(offload->flow->ct,
+				       FLOW_OFFLOAD_DIR_ORIGINAL,
+				       stats[0].pkts, stats[0].bytes);
+		if (stats[1].pkts)
+			nf_ct_acct_add(offload->flow->ct,
+				       FLOW_OFFLOAD_DIR_REPLY,
+				       stats[1].pkts, stats[1].bytes);
+	}
 }
 
 static void flow_offload_work_handler(struct work_struct *work)
-- 
2.11.0

