Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E11A028A
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgDGAEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728208AbgDGACr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40E2A2080C;
        Tue,  7 Apr 2020 00:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217766;
        bh=ewKaz7VLHOf9HNs60KfzVpxH3IxyiCDrULONC5NIVjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqnuL6s6Zl06zmuFKD7NdifO3Mk2jGL2bN7OPqNpWqlzIqaICwtWn3aG9QRi0XLi7
         FLpmL7kYdiUQj3u0KcTvb4TQ9cE3cW7mKjSMxGOizxsoyCwhm7LnQDIZvL4WuVajZC
         9zvqJyuC8fCtFA8MvXtV/3MrFosH03O+43R6pnBY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/13] netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
Date:   Mon,  6 Apr 2020 20:02:30 -0400
Message-Id: <20200407000234.17088-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000234.17088-1-sashal@kernel.org>
References: <20200407000234.17088-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 6f7c9caf017be8ab0fe3b99509580d0793bf0833 ]

Replace negations of nft_rbtree_interval_end() with a new helper,
nft_rbtree_interval_start(), wherever this helps to visualise the
problem at hand, that is, for all the occurrences except for the
comparison against given flags in __nft_rbtree_get().

This gets especially useful in the next patch.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 0221510328d4f..84d317418d184 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -36,6 +36,11 @@ static bool nft_rbtree_interval_end(const struct nft_rbtree_elem *rbe)
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
@@ -67,7 +72,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 			if (interval &&
 			    nft_rbtree_equal(set, this, interval) &&
 			    nft_rbtree_interval_end(rbe) &&
-			    !nft_rbtree_interval_end(interval))
+			    nft_rbtree_interval_start(interval))
 				continue;
 			interval = rbe;
 		} else if (d > 0)
@@ -92,7 +97,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_rbtree_interval_end(interval)) {
+	    nft_rbtree_interval_start(interval)) {
 		*ext = &interval->ext;
 		return true;
 	}
@@ -221,9 +226,9 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
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
@@ -314,10 +319,10 @@ static void *nft_rbtree_deactivate(const struct net *net,
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
2.20.1

