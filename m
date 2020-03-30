Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF3E197162
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgC3Ahv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:37:51 -0400
Received: from correo.us.es ([193.147.175.20]:57136 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbgC3AhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8008CEF43C
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72937100A4E
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 683E7100A48; Mon, 30 Mar 2020 02:37:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77E5C100A55;
        Mon, 30 Mar 2020 02:37:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5153942EF42A;
        Mon, 30 Mar 2020 02:37:22 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 20/26] netfilter: nf_queue: prefer nf_queue_entry_free
Date:   Mon, 30 Mar 2020 02:37:02 +0200
Message-Id: <20200330003708.54017-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Instead of dropping refs+kfree, use the helper added in previous patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_queue.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index aadccdd117f0..bbd1209694b8 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -155,18 +155,16 @@ static void nf_ip6_saveroute(const struct sk_buff *skb,
 static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		      unsigned int index, unsigned int queuenum)
 {
-	int status = -ENOENT;
 	struct nf_queue_entry *entry = NULL;
 	const struct nf_queue_handler *qh;
 	struct net *net = state->net;
 	unsigned int route_key_size;
+	int status;
 
 	/* QUEUE == DROP if no one is waiting, to be safe. */
 	qh = rcu_dereference(net->nf.queue_handler);
-	if (!qh) {
-		status = -ESRCH;
-		goto err;
-	}
+	if (!qh)
+		return -ESRCH;
 
 	switch (state->pf) {
 	case AF_INET:
@@ -181,14 +179,12 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 	}
 
 	entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
-	if (!entry) {
-		status = -ENOMEM;
-		goto err;
-	}
+	if (!entry)
+		return -ENOMEM;
 
 	if (skb_dst(skb) && !skb_dst_force(skb)) {
-		status = -ENETDOWN;
-		goto err;
+		kfree(entry);
+		return -ENETDOWN;
 	}
 
 	*entry = (struct nf_queue_entry) {
@@ -212,17 +208,12 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 	}
 
 	status = qh->outfn(entry, queuenum);
-
 	if (status < 0) {
-		nf_queue_entry_release_refs(entry);
-		goto err;
+		nf_queue_entry_free(entry);
+		return status;
 	}
 
 	return 0;
-
-err:
-	kfree(entry);
-	return status;
 }
 
 /* Packets leaving via this function must come back through nf_reinject(). */
-- 
2.11.0

