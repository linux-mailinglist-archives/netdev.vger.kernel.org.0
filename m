Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF784E5A14
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfJZLrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:52 -0400
Received: from correo.us.es ([193.147.175.20]:46414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfJZLrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F02F8C3C60
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C81DCA0F3
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 822B3D190C; Sat, 26 Oct 2019 13:47:47 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EA2BB8005;
        Sat, 26 Oct 2019 13:47:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5E72342EE393;
        Sat, 26 Oct 2019 13:47:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 14/31] netfilter: ecache: document extension area access rules
Date:   Sat, 26 Oct 2019 13:47:16 +0200
Message-Id: <20191026114733.28111-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Once ct->ext gets free'd via kfree() rather than kfree_rcu we can't
access the extension area anymore without owning the conntrack.

This is a special case:

The worker is walking the pcpu dying list while holding dying list lock:
Neither ct nor ct->ext can be free'd until after the walk has completed.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ecache.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 6fba74b5aaf7..0d83c159671c 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -30,6 +30,7 @@
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
 #define ECACHE_RETRY_WAIT (HZ/10)
+#define ECACHE_STACK_ALLOC (256 / sizeof(void *))
 
 enum retry_state {
 	STATE_CONGESTED,
@@ -39,11 +40,11 @@ enum retry_state {
 
 static enum retry_state ecache_work_evict_list(struct ct_pcpu *pcpu)
 {
-	struct nf_conn *refs[16];
+	struct nf_conn *refs[ECACHE_STACK_ALLOC];
+	enum retry_state ret = STATE_DONE;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
 	unsigned int evicted = 0;
-	enum retry_state ret = STATE_DONE;
 
 	spin_lock(&pcpu->lock);
 
@@ -54,10 +55,22 @@ static enum retry_state ecache_work_evict_list(struct ct_pcpu *pcpu)
 		if (!nf_ct_is_confirmed(ct))
 			continue;
 
+		/* This ecache access is safe because the ct is on the
+		 * pcpu dying list and we hold the spinlock -- the entry
+		 * cannot be free'd until after the lock is released.
+		 *
+		 * This is true even if ct has a refcount of 0: the
+		 * cpu that is about to free the entry must remove it
+		 * from the dying list and needs the lock to do so.
+		 */
 		e = nf_ct_ecache_find(ct);
 		if (!e || e->state != NFCT_ECACHE_DESTROY_FAIL)
 			continue;
 
+		/* ct is in NFCT_ECACHE_DESTROY_FAIL state, this means
+		 * the worker owns this entry: the ct will remain valid
+		 * until the worker puts its ct reference.
+		 */
 		if (nf_conntrack_event(IPCT_DESTROY, ct)) {
 			ret = STATE_CONGESTED;
 			break;
-- 
2.11.0

