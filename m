Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E498CF5D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfHNJZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:25:08 -0400
Received: from correo.us.es ([193.147.175.20]:42608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbfHNJYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 05:24:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C54D4C40E2
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 11:24:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B57B650F3F
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 11:24:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AAC86DA7B9; Wed, 14 Aug 2019 11:24:52 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4EB41150CE;
        Wed, 14 Aug 2019 11:24:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 11:24:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5C1444265A2F;
        Wed, 14 Aug 2019 11:24:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/7] netfilter: nf_flow_table: conntrack picks up expired flows
Date:   Wed, 14 Aug 2019 11:24:37 +0200
Message-Id: <20190814092440.20087-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190814092440.20087-1-pablo@netfilter.org>
References: <20190814092440.20087-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update conntrack entry to pick up expired flows, otherwise the conntrack
entry gets stuck with the internal offload timeout (one day). The TCP
state also needs to be adjusted to ESTABLISHED state and tracking is set
to liberal mode in order to give conntrack a chance to pick up the
expired flow.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e3d797252a98..68a24471ffee 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -111,7 +111,7 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 #define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
 #define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
 
-static void flow_offload_fixup_ct_state(struct nf_conn *ct)
+static void flow_offload_fixup_ct(struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
 	unsigned int timeout;
@@ -208,6 +208,11 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
+static inline bool nf_flow_has_expired(const struct flow_offload *flow)
+{
+	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
+}
+
 static void flow_offload_del(struct nf_flowtable *flow_table,
 			     struct flow_offload *flow)
 {
@@ -223,6 +228,9 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	e = container_of(flow, struct flow_offload_entry, flow);
 	clear_bit(IPS_OFFLOAD_BIT, &e->ct->status);
 
+	if (nf_flow_has_expired(flow))
+		flow_offload_fixup_ct(e->ct);
+
 	flow_offload_free(flow);
 }
 
@@ -233,7 +241,7 @@ void flow_offload_teardown(struct flow_offload *flow)
 	flow->flags |= FLOW_OFFLOAD_TEARDOWN;
 
 	e = container_of(flow, struct flow_offload_entry, flow);
-	flow_offload_fixup_ct_state(e->ct);
+	flow_offload_fixup_ct(e->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -298,11 +306,6 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 	return err;
 }
 
-static inline bool nf_flow_has_expired(const struct flow_offload *flow)
-{
-	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
-}
-
 static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
-- 
2.11.0


