Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5024141984
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgARUPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:15:02 -0500
Received: from correo.us.es ([193.147.175.20]:48422 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbgARUOa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4CA392EFEAB
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D1BCDA701
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 32CF5DA712; Sat, 18 Jan 2020 21:14:29 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30CEADA701;
        Sat, 18 Jan 2020 21:14:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0BB7641E4800;
        Sat, 18 Jan 2020 21:14:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/21] netfilter: hashlimit: do not use indirect calls during gc
Date:   Sat, 18 Jan 2020 21:14:05 +0100
Message-Id: <20200118201417.334111-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

no need, just use a simple boolean to indicate we want to reap all
entries.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index ced3fc8fad7c..bccd47cd7190 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -357,21 +357,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	return 0;
 }
 
-static bool select_all(const struct xt_hashlimit_htable *ht,
-		       const struct dsthash_ent *he)
-{
-	return true;
-}
-
-static bool select_gc(const struct xt_hashlimit_htable *ht,
-		      const struct dsthash_ent *he)
-{
-	return time_after_eq(jiffies, he->expires);
-}
-
-static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
-			bool (*select)(const struct xt_hashlimit_htable *ht,
-				      const struct dsthash_ent *he))
+static void htable_selective_cleanup(struct xt_hashlimit_htable *ht, bool select_all)
 {
 	unsigned int i;
 
@@ -381,7 +367,7 @@ static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
 
 		spin_lock_bh(&ht->lock);
 		hlist_for_each_entry_safe(dh, n, &ht->hash[i], node) {
-			if ((*select)(ht, dh))
+			if (time_after_eq(jiffies, dh->expires) || select_all)
 				dsthash_free(ht, dh);
 		}
 		spin_unlock_bh(&ht->lock);
@@ -395,7 +381,7 @@ static void htable_gc(struct work_struct *work)
 
 	ht = container_of(work, struct xt_hashlimit_htable, gc_work.work);
 
-	htable_selective_cleanup(ht, select_gc);
+	htable_selective_cleanup(ht, false);
 
 	queue_delayed_work(system_power_efficient_wq,
 			   &ht->gc_work, msecs_to_jiffies(ht->cfg.gc_interval));
@@ -419,7 +405,7 @@ static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 {
 	cancel_delayed_work_sync(&hinfo->gc_work);
 	htable_remove_proc_entry(hinfo);
-	htable_selective_cleanup(hinfo, select_all);
+	htable_selective_cleanup(hinfo, true);
 	kfree(hinfo->name);
 	vfree(hinfo);
 }
-- 
2.11.0

