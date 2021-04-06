Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0171B3553C7
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344231AbhDFMXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:23:34 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34432 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344004AbhDFMWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:07 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BA70B63E66;
        Tue,  6 Apr 2021 14:21:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 28/28] net: remove obsolete members from struct net
Date:   Tue,  6 Apr 2021 14:21:33 +0200
Message-Id: <20210406122133.1644-29-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

all have been moved to generic_net infra. On x86_64, this reduces
struct net size from 70 to 63 cache lines (4480 to 4032 byte).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/net_namespace.h   | 9 ---------
 include/net/netns/conntrack.h | 4 ----
 include/net/netns/netfilter.h | 6 ------
 include/net/netns/nftables.h  | 7 -------
 include/net/netns/x_tables.h  | 1 -
 5 files changed, 27 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index dcaee24a4d87..fdb16dc33703 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -142,15 +142,6 @@ struct net {
 #if defined(CONFIG_NF_TABLES) || defined(CONFIG_NF_TABLES_MODULE)
 	struct netns_nftables	nft;
 #endif
-#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
-	struct netns_nf_frag	nf_frag;
-	struct ctl_table_header *nf_frag_frags_hdr;
-#endif
-	struct sock		*nfnl;
-	struct sock		*nfnl_stash;
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
-	struct list_head	nfct_timeout_list;
-#endif
 #endif
 #ifdef CONFIG_WEXT_CORE
 	struct sk_buff_head	wext_nlevents;
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 806454e767bf..e5f664d69ead 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -96,13 +96,9 @@ struct netns_ct {
 	atomic_t		count;
 	unsigned int		expect_count;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	struct delayed_work ecache_dwork;
 	bool ecache_dwork_pending;
 #endif
 	bool			auto_assign_helper_warned;
-#ifdef CONFIG_SYSCTL
-	struct ctl_table_header	*sysctl_header;
-#endif
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
 	int			sysctl_events;
 	int			sysctl_acct;
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index ca043342c0eb..15e2b13fb0c0 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -28,11 +28,5 @@ struct netns_nf {
 #if IS_ENABLED(CONFIG_DECNET)
 	struct nf_hook_entries __rcu *hooks_decnet[NF_DN_NUMHOOKS];
 #endif
-#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
-	bool			defrag_ipv4;
-#endif
-#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
-	bool			defrag_ipv6;
-#endif
 };
 #endif
diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 6c0806bd8d1e..8c77832d0240 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -5,14 +5,7 @@
 #include <linux/list.h>
 
 struct netns_nftables {
-	struct list_head	tables;
-	struct list_head	commit_list;
-	struct list_head	module_list;
-	struct list_head	notify_list;
-	struct mutex		commit_mutex;
-	unsigned int		base_seq;
 	u8			gencursor;
-	u8			validate_state;
 };
 
 #endif
diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index 9bc5a12fdbb0..83c8ea2e87a6 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -8,7 +8,6 @@
 struct ebt_table;
 
 struct netns_xt {
-	struct list_head tables[NFPROTO_NUMPROTO];
 	bool notrack_deprecated_warning;
 	bool clusterip_deprecated_warning;
 #if defined(CONFIG_BRIDGE_NF_EBTABLES) || \
-- 
2.30.2

