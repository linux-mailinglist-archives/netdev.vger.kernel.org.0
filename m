Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5799148A068
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 20:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244614AbiAJTsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 14:48:24 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44508 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244491AbiAJTsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 14:48:24 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 26AE662BD8;
        Mon, 10 Jan 2022 20:45:32 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        jwiedmann.dev@gmail.com
Subject: [PATCH net-next] netfilter: nf_tables: typo NULL check in _clone() function
Date:   Mon, 10 Jan 2022 20:48:17 +0100
Message-Id: <20220110194817.53481-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This should check for NULL in case memory allocation fails.

Reported-by: Julian Wiedmann <jwiedmann.dev@gmail.com>
Fixes: 3b9e2ea6c11b ("netfilter: nft_limit: move stateful fields out of expression data")
Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
Fixes: 33a24de37e81 ("netfilter: nft_last: move stateful fields out of expression data")
Fixes: ed0a0c60f0e5 ("netfilter: nft_quota: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Please, directly apply to net-next, thanks

 net/netfilter/nft_connlimit.c | 2 +-
 net/netfilter/nft_last.c      | 2 +-
 net/netfilter/nft_limit.c     | 2 +-
 net/netfilter/nft_quota.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 58dcafe8bf79..7d00a1452b1d 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -206,7 +206,7 @@ static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
 
 	priv_dst->list = kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
-	if (priv_dst->list)
+	if (!priv_dst->list)
 		return -ENOMEM;
 
 	nf_conncount_list_init(priv_dst->list);
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 5ee33d0ccd4e..4f745a409d34 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -106,7 +106,7 @@ static int nft_last_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_last_priv *priv_dst = nft_expr_priv(dst);
 
 	priv_dst->last = kzalloc(sizeof(*priv_dst->last), GFP_ATOMIC);
-	if (priv_dst->last)
+	if (!priv_dst->last)
 		return -ENOMEM;
 
 	return 0;
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index f04be5be73a0..c4f308460dd1 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -145,7 +145,7 @@ static int nft_limit_clone(struct nft_limit_priv *priv_dst,
 	priv_dst->invert = priv_src->invert;
 
 	priv_dst->limit = kmalloc(sizeof(*priv_dst->limit), GFP_ATOMIC);
-	if (priv_dst->limit)
+	if (!priv_dst->limit)
 		return -ENOMEM;
 
 	spin_lock_init(&priv_dst->limit->lock);
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 0484aef74273..f394a0b562f6 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -237,7 +237,7 @@ static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_quota *priv_dst = nft_expr_priv(dst);
 
 	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
-	if (priv_dst->consumed)
+	if (!priv_dst->consumed)
 		return -ENOMEM;
 
 	atomic64_set(priv_dst->consumed, 0);
-- 
2.30.2

