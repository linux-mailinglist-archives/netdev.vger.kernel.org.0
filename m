Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DDD3D9E29
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbhG2HOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhG2HOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:14:09 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B49C061757;
        Thu, 29 Jul 2021 00:14:06 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627542844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6NBEq9A0leD1jsSV7D9e3zdeAhhipPh5l8QwfHDQhX8=;
        b=C2uyR5b/FgTpXdNTg7RKW74otxbi93osI77vd1Xb+N0CSnUrw1dLwFJJUsUJSYYDdjdB6i
        a83sCPIh8eeR6WwI07rYq6bh10qw14DHaqubwFFcI5Ps7Cd3ZAHylqeNQs9wKnssMq6blo
        SG2igjmFxUoxsuKC1hxhZ4+MVOlf74Q=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] net: convert fib_treeref from int to refcount_t
Date:   Thu, 29 Jul 2021 15:13:50 +0800
Message-Id: <20210729071350.28919-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t type should be used instead of int when fib_treeref is used as
a reference counter,and avoid use-after-free risks.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/net/dn_fib.h     | 2 +-
 include/net/ip_fib.h     | 2 +-
 net/decnet/dn_fib.c      | 6 +++---
 net/ipv4/fib_semantics.c | 8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/dn_fib.h b/include/net/dn_fib.h
index ccc6e9df178b..ddd6565957b3 100644
--- a/include/net/dn_fib.h
+++ b/include/net/dn_fib.h
@@ -29,7 +29,7 @@ struct dn_fib_nh {
 struct dn_fib_info {
 	struct dn_fib_info	*fib_next;
 	struct dn_fib_info	*fib_prev;
-	int 			fib_treeref;
+	refcount_t		fib_treeref;
 	refcount_t		fib_clntref;
 	int			fib_dead;
 	unsigned int		fib_flags;
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 3ab2563b1a23..21c5386d4a6d 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -133,7 +133,7 @@ struct fib_info {
 	struct hlist_node	fib_lhash;
 	struct list_head	nh_list;
 	struct net		*fib_net;
-	int			fib_treeref;
+	refcount_t		fib_treeref;
 	refcount_t		fib_clntref;
 	unsigned int		fib_flags;
 	unsigned char		fib_dead;
diff --git a/net/decnet/dn_fib.c b/net/decnet/dn_fib.c
index 77fbf8e9df4b..387a7e81dd00 100644
--- a/net/decnet/dn_fib.c
+++ b/net/decnet/dn_fib.c
@@ -102,7 +102,7 @@ void dn_fib_free_info(struct dn_fib_info *fi)
 void dn_fib_release_info(struct dn_fib_info *fi)
 {
 	spin_lock(&dn_fib_info_lock);
-	if (fi && --fi->fib_treeref == 0) {
+	if (fi && refcount_dec_and_test(&fi->fib_treeref)) {
 		if (fi->fib_next)
 			fi->fib_next->fib_prev = fi->fib_prev;
 		if (fi->fib_prev)
@@ -385,11 +385,11 @@ struct dn_fib_info *dn_fib_create_info(const struct rtmsg *r, struct nlattr *att
 	if ((ofi = dn_fib_find_info(fi)) != NULL) {
 		fi->fib_dead = 1;
 		dn_fib_free_info(fi);
-		ofi->fib_treeref++;
+		refcount_inc(&ofi->fib_treeref);
 		return ofi;
 	}
 
-	fi->fib_treeref++;
+	refcount_inc(&fi->fib_treeref);
 	refcount_set(&fi->fib_clntref, 1);
 	spin_lock(&dn_fib_info_lock);
 	fi->fib_next = dn_fib_info_list;
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4c0c33e4710d..fa19f4cdf3a4 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -260,7 +260,7 @@ EXPORT_SYMBOL_GPL(free_fib_info);
 void fib_release_info(struct fib_info *fi)
 {
 	spin_lock_bh(&fib_info_lock);
-	if (fi && --fi->fib_treeref == 0) {
+	if (fi && refcount_dec_and_test(&fi->fib_treeref)) {
 		hlist_del(&fi->fib_hash);
 		if (fi->fib_prefsrc)
 			hlist_del(&fi->fib_lhash);
@@ -1373,7 +1373,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		if (!cfg->fc_mx) {
 			fi = fib_find_info_nh(net, cfg);
 			if (fi) {
-				fi->fib_treeref++;
+				refcount_inc(&fi->fib_treeref);
 				return fi;
 			}
 		}
@@ -1547,11 +1547,11 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	if (ofi) {
 		fi->fib_dead = 1;
 		free_fib_info(fi);
-		ofi->fib_treeref++;
+		refcount_inc(&ofi->fib_treeref);
 		return ofi;
 	}
 
-	fi->fib_treeref++;
+	refcount_inc(&fi->fib_treeref);
 	refcount_set(&fi->fib_clntref, 1);
 	spin_lock_bh(&fib_info_lock);
 	hlist_add_head(&fi->fib_hash,
-- 
2.32.0

