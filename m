Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C710397C19
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhFAWIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39558 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbhFAWIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:19 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E9D6B641C5;
        Wed,  2 Jun 2021 00:05:29 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 03/16] netfilter: add and use nft_set_do_lookup helper
Date:   Wed,  2 Jun 2021 00:06:16 +0200
Message-Id: <20210601220629.18307-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Followup patch will add a CONFIG_RETPOLINE wrapper to avoid
the ops->lookup() indirection cost for retpoline builds.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h | 7 +++++++
 net/netfilter/nft_lookup.c             | 4 ++--
 net/netfilter/nft_objref.c             | 4 ++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index fd10a7862fdc..5eb699454490 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -88,6 +88,13 @@ extern const struct nft_set_type nft_set_bitmap_type;
 extern const struct nft_set_type nft_set_pipapo_type;
 extern const struct nft_set_type nft_set_pipapo_avx2_type;
 
+static inline bool
+nft_set_do_lookup(const struct net *net, const struct nft_set *set,
+		  const u32 *key, const struct nft_set_ext **ext)
+{
+	return set->ops->lookup(net, set, key, ext);
+}
+
 struct nft_expr;
 struct nft_regs;
 struct nft_pktinfo;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index a479f8a1270c..1a8581879af5 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -33,8 +33,8 @@ void nft_lookup_eval(const struct nft_expr *expr,
 	const struct net *net = nft_net(pkt);
 	bool found;
 
-	found = set->ops->lookup(net, set, &regs->data[priv->sreg], &ext) ^
-				 priv->invert;
+	found =	nft_set_do_lookup(net, set, &regs->data[priv->sreg], &ext) ^
+				  priv->invert;
 	if (!found) {
 		ext = nft_set_catchall_lookup(net, set);
 		if (!ext) {
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 7e47edee88ee..94b2327e71dc 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -9,7 +9,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 
 #define nft_objref_priv(expr)	*((struct nft_object **)nft_expr_priv(expr))
 
@@ -110,7 +110,7 @@ static void nft_objref_map_eval(const struct nft_expr *expr,
 	struct nft_object *obj;
 	bool found;
 
-	found = set->ops->lookup(net, set, &regs->data[priv->sreg], &ext);
+	found = nft_set_do_lookup(net, set, &regs->data[priv->sreg], &ext);
 	if (!found) {
 		ext = nft_set_catchall_lookup(net, set);
 		if (!ext) {
-- 
2.30.2

