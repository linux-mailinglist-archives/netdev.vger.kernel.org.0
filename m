Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11BC191CC8
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgCXWdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:33:11 -0400
Received: from correo.us.es ([193.147.175.20]:34628 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbgCXWcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 18:32:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 43BF7FB377
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 23:31:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31C81DA38F
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 23:31:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2681EDA3C3; Tue, 24 Mar 2020 23:31:53 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52E38DA390;
        Tue, 24 Mar 2020 23:31:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 24 Mar 2020 23:31:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2BA8B42EF42B;
        Tue, 24 Mar 2020 23:31:51 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/7] netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
Date:   Tue, 24 Mar 2020 23:32:16 +0100
Message-Id: <20200324223220.12119-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200324223220.12119-1-pablo@netfilter.org>
References: <20200324223220.12119-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Replace negations of nft_rbtree_interval_end() with a new helper,
nft_rbtree_interval_start(), wherever this helps to visualise the
problem at hand, that is, for all the occurrences except for the
comparison against given flags in __nft_rbtree_get().

This gets especially useful in the next patch.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 5000b938ab1e..85572b2a6051 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -33,6 +33,11 @@ static bool nft_rbtree_interval_end(const struct nft_rbtree_elem *rbe)
 	       (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END);
 }
 
+static bool nft_rbtree_interval_start(const struct nft_rbtree_elem *rbe)
+{
+	return !nft_rbtree_interval_end(rbe);
+}
+
 static bool nft_rbtree_equal(const struct nft_set *set, const void *this,
 			     const struct nft_rbtree_elem *interval)
 {
@@ -64,7 +69,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 			if (interval &&
 			    nft_rbtree_equal(set, this, interval) &&
 			    nft_rbtree_interval_end(rbe) &&
-			    !nft_rbtree_interval_end(interval))
+			    nft_rbtree_interval_start(interval))
 				continue;
 			interval = rbe;
 		} else if (d > 0)
@@ -89,7 +94,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_rbtree_interval_end(interval)) {
+	    nft_rbtree_interval_start(interval)) {
 		*ext = &interval->ext;
 		return true;
 	}
@@ -224,9 +229,9 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			p = &parent->rb_right;
 		else {
 			if (nft_rbtree_interval_end(rbe) &&
-			    !nft_rbtree_interval_end(new)) {
+			    nft_rbtree_interval_start(new)) {
 				p = &parent->rb_left;
-			} else if (!nft_rbtree_interval_end(rbe) &&
+			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
 				p = &parent->rb_right;
 			} else if (nft_set_elem_active(&rbe->ext, genmask)) {
@@ -317,10 +322,10 @@ static void *nft_rbtree_deactivate(const struct net *net,
 			parent = parent->rb_right;
 		else {
 			if (nft_rbtree_interval_end(rbe) &&
-			    !nft_rbtree_interval_end(this)) {
+			    nft_rbtree_interval_start(this)) {
 				parent = parent->rb_left;
 				continue;
-			} else if (!nft_rbtree_interval_end(rbe) &&
+			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(this)) {
 				parent = parent->rb_right;
 				continue;
-- 
2.11.0

