Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30D31F8AF8
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 23:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgFNVxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 17:53:12 -0400
Received: from correo.us.es ([193.147.175.20]:59914 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgFNVxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 17:53:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7198AB56F5
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 23:53:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65674DA78E
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 23:53:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5AAE6DA793; Sun, 14 Jun 2020 23:53:10 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C297DA72F;
        Sun, 14 Jun 2020 23:53:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 14 Jun 2020 23:53:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CD7FA426CCBA;
        Sun, 14 Jun 2020 23:53:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/4] netfilter: nft_set_rbtree: Don't account for expired elements on insertion
Date:   Sun, 14 Jun 2020 23:52:58 +0200
Message-Id: <20200614215301.9101-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200614215301.9101-1-pablo@netfilter.org>
References: <20200614215301.9101-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

While checking the validity of insertion in __nft_rbtree_insert(),
we currently ignore conflicting elements and intervals only if they
are not active within the next generation.

However, if we consider expired elements and intervals as
potentially conflicting and overlapping, we'll return error for
entries that should be added instead. This is particularly visible
with garbage collection intervals that are comparable with the
element timeout itself, as reported by Mike Dillinger.

Other than the simple issue of denying insertion of valid entries,
this might also result in insertion of a single element (opening or
closing) out of a given interval. With single entries (that are
inserted as intervals of size 1), this leads in turn to the creation
of new intervals. For example:

  # nft add element t s { 192.0.2.1 }
  # nft list ruleset
  [...]
     elements = { 192.0.2.1-255.255.255.255 }

Always ignore expired elements active in the next generation, while
checking for conflicts.

It might be more convenient to introduce a new macro that covers
both inactive and expired items, as this type of check also appears
quite frequently in other set back-ends. This is however beyond the
scope of this fix and can be deferred to a separate patch.

Other than the overlap detection cases introduced by commit
7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps
on insertion"), we also have to cover the original conflict check
dealing with conflicts between two intervals of size 1, which was
introduced before support for timeout was introduced. This won't
return an error to the user as -EEXIST is masked by nft if
NLM_F_EXCL is not given, but would result in a silent failure
adding the entry.

Reported-by: Mike Dillinger <miked@softtalker.com>
Cc: <stable@vger.kernel.org> # 5.6.x
Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Acked-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 62f416bc0579..b6aad3fc46c3 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -271,12 +271,14 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 			if (nft_rbtree_interval_start(new)) {
 				if (nft_rbtree_interval_end(rbe) &&
-				    nft_set_elem_active(&rbe->ext, genmask))
+				    nft_set_elem_active(&rbe->ext, genmask) &&
+				    !nft_set_elem_expired(&rbe->ext))
 					overlap = false;
 			} else {
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
-							      genmask);
+							      genmask) &&
+					  !nft_set_elem_expired(&rbe->ext);
 			}
 		} else if (d > 0) {
 			p = &parent->rb_right;
@@ -284,9 +286,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			if (nft_rbtree_interval_end(new)) {
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
-							      genmask);
+							      genmask) &&
+					  !nft_set_elem_expired(&rbe->ext);
 			} else if (nft_rbtree_interval_end(rbe) &&
-				   nft_set_elem_active(&rbe->ext, genmask)) {
+				   nft_set_elem_active(&rbe->ext, genmask) &&
+				   !nft_set_elem_expired(&rbe->ext)) {
 				overlap = true;
 			}
 		} else {
@@ -294,15 +298,18 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			    nft_rbtree_interval_start(new)) {
 				p = &parent->rb_left;
 
-				if (nft_set_elem_active(&rbe->ext, genmask))
+				if (nft_set_elem_active(&rbe->ext, genmask) &&
+				    !nft_set_elem_expired(&rbe->ext))
 					overlap = false;
 			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
 				p = &parent->rb_right;
 
-				if (nft_set_elem_active(&rbe->ext, genmask))
+				if (nft_set_elem_active(&rbe->ext, genmask) &&
+				    !nft_set_elem_expired(&rbe->ext))
 					overlap = false;
-			} else if (nft_set_elem_active(&rbe->ext, genmask)) {
+			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
+				   !nft_set_elem_expired(&rbe->ext)) {
 				*ext = &rbe->ext;
 				return -EEXIST;
 			} else {
-- 
2.20.1

