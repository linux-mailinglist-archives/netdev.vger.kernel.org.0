Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0925724FCBE
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 13:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgHXLkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 07:40:00 -0400
Received: from correo.us.es ([193.147.175.20]:41730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbgHXLjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 07:39:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 909D681A0E
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:39:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F285BFC5F3
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:39:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5341DEBAF2; Mon, 24 Aug 2020 13:39:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F09ADA874;
        Mon, 24 Aug 2020 13:39:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 24 Aug 2020 13:39:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7321F42EE38E;
        Mon, 24 Aug 2020 13:39:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/6] netfilter: nft_set_rbtree: Detect partial overlap with start endpoint match
Date:   Mon, 24 Aug 2020 13:39:38 +0200
Message-Id: <20200824113941.25423-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200824113941.25423-1-pablo@netfilter.org>
References: <20200824113941.25423-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Getting creative with nft and omitting the interval_overlap()
check from the set_overlap() function, without omitting
set_overlap() altogether, led to the observation of a partial
overlap that wasn't detected, and would actually result in
replacement of the end element of an existing interval.

This is due to the fact that we'll return -EEXIST on a matching,
pre-existing start element, instead of -ENOTEMPTY, and the error
is cleared by API if NLM_F_EXCL is not given. At this point, we
can insert a matching start, and duplicate the end element as long
as we don't end up into other intervals.

For instance, inserting interval 0 - 2 with an existing 0 - 3
interval would result in a single 0 - 2 interval, and a dangling
'3' end element. This is because nft will proceed after inserting
the '0' start element as no error is reported, and no further
conflicting intervals are detected on insertion of the end element.

This needs a different approach as it's a local condition that can
be detected by looking for duplicate ends coming from left and
right, separately. Track those and directly report -ENOTEMPTY on
duplicated end elements for a matching start.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 27668f4e44ea..217ab3644c25 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -218,11 +218,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_set_ext **ext)
 {
+	bool overlap = false, dup_end_left = false, dup_end_right = false;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *parent, **p;
-	bool overlap = false;
 	int d;
 
 	/* Detect overlaps as we descend the tree. Set the flag in these cases:
@@ -262,6 +262,20 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 *
 	 * which always happen as last step and imply that no further
 	 * overlapping is possible.
+	 *
+	 * Another special case comes from the fact that start elements matching
+	 * an already existing start element are allowed: insertion is not
+	 * performed but we return -EEXIST in that case, and the error will be
+	 * cleared by the caller if NLM_F_EXCL is not present in the request.
+	 * This way, request for insertion of an exact overlap isn't reported as
+	 * error to userspace if not desired.
+	 *
+	 * However, if the existing start matches a pre-existing start, but the
+	 * end element doesn't match the corresponding pre-existing end element,
+	 * we need to report a partial overlap. This is a local condition that
+	 * can be noticed without need for a tracking flag, by checking for a
+	 * local duplicated end for a corresponding start, from left and right,
+	 * separately.
 	 */
 
 	parent = NULL;
@@ -281,19 +295,35 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				    !nft_set_elem_expired(&rbe->ext) && !*p)
 					overlap = false;
 			} else {
+				if (dup_end_left && !*p)
+					return -ENOTEMPTY;
+
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
 							      genmask) &&
 					  !nft_set_elem_expired(&rbe->ext);
+
+				if (overlap) {
+					dup_end_right = true;
+					continue;
+				}
 			}
 		} else if (d > 0) {
 			p = &parent->rb_right;
 
 			if (nft_rbtree_interval_end(new)) {
+				if (dup_end_right && !*p)
+					return -ENOTEMPTY;
+
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
 							      genmask) &&
 					  !nft_set_elem_expired(&rbe->ext);
+
+				if (overlap) {
+					dup_end_left = true;
+					continue;
+				}
 			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
 				   !nft_set_elem_expired(&rbe->ext)) {
 				overlap = nft_rbtree_interval_end(rbe);
@@ -321,6 +351,8 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				p = &parent->rb_left;
 			}
 		}
+
+		dup_end_left = dup_end_right = false;
 	}
 
 	if (overlap)
-- 
2.20.1

