Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F3E3E8C63
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236347AbhHKItr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:49:47 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44064 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236369AbhHKItn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:49:43 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9AA6960069;
        Wed, 11 Aug 2021 10:48:36 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/10] netfilter: remove xt pernet data
Date:   Wed, 11 Aug 2021 10:49:03 +0200
Message-Id: <20210811084908.14744-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210811084908.14744-1-pablo@netfilter.org>
References: <20210811084908.14744-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

clusterip is now handled via net_generic.

NOTRACK is tiny compared to rest of xt_CT feature set, even the existing
deprecation warning is bigger than the actual functionality.

Just remove the warning, its not worth keeping/adding a net_generic one.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/net_namespace.h  |  2 --
 include/net/netns/x_tables.h | 12 ------------
 net/netfilter/xt_CT.c        | 11 -----------
 3 files changed, 25 deletions(-)
 delete mode 100644 include/net/netns/x_tables.h

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index cc54750dd3db..bb5fa5914032 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -23,7 +23,6 @@
 #include <net/netns/ieee802154_6lowpan.h>
 #include <net/netns/sctp.h>
 #include <net/netns/netfilter.h>
-#include <net/netns/x_tables.h>
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 #include <net/netns/conntrack.h>
 #endif
@@ -133,7 +132,6 @@ struct net {
 #endif
 #ifdef CONFIG_NETFILTER
 	struct netns_nf		nf;
-	struct netns_xt		xt;
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	struct netns_ct		ct;
 #endif
diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
deleted file mode 100644
index d02316ec2906..000000000000
--- a/include/net/netns/x_tables.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __NETNS_X_TABLES_H
-#define __NETNS_X_TABLES_H
-
-#include <linux/list.h>
-#include <linux/netfilter_defs.h>
-
-struct netns_xt {
-	bool notrack_deprecated_warning;
-	bool clusterip_deprecated_warning;
-};
-#endif
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 12404d221026..0a913ce07425 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -351,21 +351,10 @@ notrack_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-static int notrack_chk(const struct xt_tgchk_param *par)
-{
-	if (!par->net->xt.notrack_deprecated_warning) {
-		pr_info("netfilter: NOTRACK target is deprecated, "
-			"use CT instead or upgrade iptables\n");
-		par->net->xt.notrack_deprecated_warning = true;
-	}
-	return 0;
-}
-
 static struct xt_target notrack_tg_reg __read_mostly = {
 	.name		= "NOTRACK",
 	.revision	= 0,
 	.family		= NFPROTO_UNSPEC,
-	.checkentry	= notrack_chk,
 	.target		= notrack_tg,
 	.table		= "raw",
 	.me		= THIS_MODULE,
-- 
2.20.1

