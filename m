Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F01C3553C5
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344222AbhDFMXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:23:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34448 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343999AbhDFMWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:06 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B83C163E64;
        Tue,  6 Apr 2021 14:21:38 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 26/28] netfilter: conntrack: move sysctl pointer to net_generic infra
Date:   Tue,  6 Apr 2021 14:21:31 +0200
Message-Id: <20210406122133.1644-27-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No need to keep this in struct net, place it in the net_generic data.
The sysctl pointer is removed from struct net in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h    |  3 +++
 net/netfilter/nf_conntrack_standalone.c | 10 ++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 439379ca9ffa..ef405a134307 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -47,6 +47,9 @@ struct nf_conntrack_net {
 	unsigned int users4;
 	unsigned int users6;
 	unsigned int users_bridge;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header	*sysctl_header;
+#endif
 };
 
 #include <linux/types.h>
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0ee702d374b0..3f2cc7b04b20 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1027,6 +1027,7 @@ static void nf_conntrack_standalone_init_gre_sysctl(struct net *net,
 
 static int nf_conntrack_standalone_init_sysctl(struct net *net)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 	struct nf_udp_net *un = nf_udp_pernet(net);
 	struct ctl_table *table;
 
@@ -1072,8 +1073,8 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
 	}
 
-	net->ct.sysctl_header = register_net_sysctl(net, "net/netfilter", table);
-	if (!net->ct.sysctl_header)
+	cnet->sysctl_header = register_net_sysctl(net, "net/netfilter", table);
+	if (!cnet->sysctl_header)
 		goto out_unregister_netfilter;
 
 	return 0;
@@ -1085,10 +1086,11 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 
 static void nf_conntrack_standalone_fini_sysctl(struct net *net)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 	struct ctl_table *table;
 
-	table = net->ct.sysctl_header->ctl_table_arg;
-	unregister_net_sysctl_table(net->ct.sysctl_header);
+	table = cnet->sysctl_header->ctl_table_arg;
+	unregister_net_sysctl_table(cnet->sysctl_header);
 	kfree(table);
 }
 #else
-- 
2.30.2

