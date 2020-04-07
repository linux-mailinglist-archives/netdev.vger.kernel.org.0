Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EA81A1836
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 00:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgDGW3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 18:29:45 -0400
Received: from correo.us.es ([193.147.175.20]:53134 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgDGW3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 18:29:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BF0F7F2DE0
        for <netdev@vger.kernel.org>; Wed,  8 Apr 2020 00:29:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACBF14EA8F
        for <netdev@vger.kernel.org>; Wed,  8 Apr 2020 00:29:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A1F41DA8E6; Wed,  8 Apr 2020 00:29:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA85BDA3C4;
        Wed,  8 Apr 2020 00:29:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Apr 2020 00:29:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 85F574251480;
        Wed,  8 Apr 2020 00:29:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/7] netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion
Date:   Wed,  8 Apr 2020 00:29:30 +0200
Message-Id: <20200407222936.206295-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200407222936.206295-1-pablo@netfilter.org>
References: <20200407222936.206295-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Case a1. for overlap detection in __nft_rbtree_insert() is not a valid
one: start-after-start is not needed to detect any type of interval
overlap and it actually results in a false positive if, while
descending the tree, this is the only step we hit after starting from
the root.

This introduced a regression, as reported by Pablo, in Python tests
cases ip/ip.t and ip/numgen.t:

  ip/ip.t: ERROR: line 124: add rule ip test-ip4 input ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter: This rule should not have failed.
  ip/numgen.t: ERROR: line 7: add rule ip test-ip4 pre dnat to numgen inc mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200}: This rule should not have failed.

Drop case a1. and renumber others, so that they are a bit clearer. In
order for these diagrams to be readily understandable, a bigger rework
is probably needed, such as an ASCII art of the actual rbtree (instead
of a flattened version).

Shell script test sets/0044interval_overlap_0 should cover all
possible cases for false negatives, so I consider that test case still
sufficient after this change.

v2: Fix comments for cases a3. and b3.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 3a5552e14f75..3ffef454d469 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -218,27 +218,26 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 	/* Detect overlaps as we descend the tree. Set the flag in these cases:
 	 *
-	 * a1. |__ _ _?  >|__ _ _  (insert start after existing start)
-	 * a2. _ _ __>|  ?_ _ __|  (insert end before existing end)
-	 * a3. _ _ ___|  ?_ _ _>|  (insert end after existing end)
-	 * a4. >|__ _ _   _ _ __|  (insert start before existing end)
+	 * a1. _ _ __>|  ?_ _ __|  (insert end before existing end)
+	 * a2. _ _ ___|  ?_ _ _>|  (insert end after existing end)
+	 * a3. _ _ ___? >|_ _ __|  (insert start before existing end)
 	 *
 	 * and clear it later on, as we eventually reach the points indicated by
 	 * '?' above, in the cases described below. We'll always meet these
 	 * later, locally, due to tree ordering, and overlaps for the intervals
 	 * that are the closest together are always evaluated last.
 	 *
-	 * b1. |__ _ _!  >|__ _ _  (insert start after existing end)
-	 * b2. _ _ __>|  !_ _ __|  (insert end before existing start)
-	 * b3. !_____>|            (insert end after existing start)
+	 * b1. _ _ __>|  !_ _ __|  (insert end before existing start)
+	 * b2. _ _ ___|  !_ _ _>|  (insert end after existing start)
+	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end)
 	 *
-	 * Case a4. resolves to b1.:
+	 * Case a3. resolves to b3.:
 	 * - if the inserted start element is the leftmost, because the '0'
 	 *   element in the tree serves as end element
 	 * - otherwise, if an existing end is found. Note that end elements are
 	 *   always inserted after corresponding start elements.
 	 *
-	 * For a new, rightmost pair of elements, we'll hit cases b1. and b3.,
+	 * For a new, rightmost pair of elements, we'll hit cases b3. and b2.,
 	 * in that order.
 	 *
 	 * The flag is also cleared in two special cases:
@@ -262,9 +261,9 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			p = &parent->rb_left;
 
 			if (nft_rbtree_interval_start(new)) {
-				overlap = nft_rbtree_interval_start(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask);
+				if (nft_rbtree_interval_end(rbe) &&
+				    nft_set_elem_active(&rbe->ext, genmask))
+					overlap = false;
 			} else {
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
-- 
2.11.0

