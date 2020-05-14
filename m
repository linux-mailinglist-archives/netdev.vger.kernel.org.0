Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77F01D2F69
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgENMT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:19:26 -0400
Received: from correo.us.es ([193.147.175.20]:54298 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgENMTY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 08:19:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 411B415AEAD
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:19:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31EB0DA71A
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:19:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2F804DA709; Thu, 14 May 2020 14:19:22 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B704DA709;
        Thu, 14 May 2020 14:19:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 May 2020 14:19:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EAE5042EF42A;
        Thu, 14 May 2020 14:19:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 6/6] netfilter: nft_set_rbtree: Add missing expired checks
Date:   Thu, 14 May 2020 14:19:13 +0200
Message-Id: <20200514121913.24519-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514121913.24519-1-pablo@netfilter.org>
References: <20200514121913.24519-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Expired intervals would still match and be dumped to user space until
garbage collection wiped them out. Make sure they stop matching and
disappear (from users' perspective) as soon as they expire.

Fixes: 8d8540c4f5e03 ("netfilter: nft_set_rbtree: add timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 3ffef454d469..62f416bc0579 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -79,6 +79,10 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 				parent = rcu_dereference_raw(parent->rb_left);
 				continue;
 			}
+
+			if (nft_set_elem_expired(&rbe->ext))
+				return false;
+
 			if (nft_rbtree_interval_end(rbe)) {
 				if (nft_set_is_anonymous(set))
 					return false;
@@ -94,6 +98,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    nft_rbtree_interval_start(interval)) {
 		*ext = &interval->ext;
 		return true;
@@ -154,6 +159,9 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 				continue;
 			}
 
+			if (nft_set_elem_expired(&rbe->ext))
+				return false;
+
 			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
 			    (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END) ==
 			    (flags & NFT_SET_ELEM_INTERVAL_END)) {
@@ -170,6 +178,7 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    ((!nft_rbtree_interval_end(interval) &&
 	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
 	     (nft_rbtree_interval_end(interval) &&
@@ -418,6 +427,8 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
+		if (nft_set_elem_expired(&rbe->ext))
+			goto cont;
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
-- 
2.20.1

