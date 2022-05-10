Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A96C521549
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241754AbiEJM2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241687AbiEJMZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:25:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4366091365;
        Tue, 10 May 2022 05:22:02 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 12/17] netfilter: nfnetlink: allow to detect if ctnetlink listeners exist
Date:   Tue, 10 May 2022 14:21:45 +0200
Message-Id: <20220510122150.92533-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220510122150.92533-1-pablo@netfilter.org>
References: <20220510122150.92533-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

At this time, every new conntrack gets the 'event cache extension'
enabled for it.

This is because the 'net.netfilter.nf_conntrack_events' sysctl defaults
to 1.

Changing the default to 0 means that commands that rely on the event
notification extension, e.g. 'conntrack -E' or conntrackd, stop working.

We COULD detect if there is a listener by means of
'nfnetlink_has_listeners()' and only add the extension if this is true.

The downside is a dependency from conntrack module to nfnetlink module.

This adds a different way: inc/dec a counter whenever a ctnetlink group
is being (un)subscribed and toggle a flag in struct net.

Next patches will take advantage of this and will only add the event
extension if the flag is set.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/conntrack.h |  1 +
 net/netfilter/nfnetlink.c     | 40 ++++++++++++++++++++++++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index a71cfd4e2f21..0677cd3de034 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -95,6 +95,7 @@ struct nf_ip_net {
 
 struct netns_ct {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
+	bool ctnetlink_has_listener;
 	bool ecache_dwork_pending;
 #endif
 	u8			sysctl_log_invalid; /* Log invalid packets */
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7e2c8dd01408..ad3bbe34ca88 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -45,6 +45,7 @@ MODULE_DESCRIPTION("Netfilter messages via netlink socket");
 static unsigned int nfnetlink_pernet_id __read_mostly;
 
 struct nfnl_net {
+	unsigned int ctnetlink_listeners;
 	struct sock *nfnl;
 };
 
@@ -654,7 +655,6 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 		netlink_rcv_skb(skb, nfnetlink_rcv_msg);
 }
 
-#ifdef CONFIG_MODULES
 static int nfnetlink_bind(struct net *net, int group)
 {
 	const struct nfnetlink_subsystem *ss;
@@ -670,9 +670,44 @@ static int nfnetlink_bind(struct net *net, int group)
 	rcu_read_unlock();
 	if (!ss)
 		request_module_nowait("nfnetlink-subsys-%d", type);
+
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	if (type == NFNL_SUBSYS_CTNETLINK) {
+		struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+
+		if (WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == UINT_MAX)) {
+			nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
+			return -EOVERFLOW;
+		}
+
+		nfnlnet->ctnetlink_listeners++;
+		if (nfnlnet->ctnetlink_listeners == 1)
+			WRITE_ONCE(net->ct.ctnetlink_has_listener, true);
+		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
+	}
+#endif
 	return 0;
 }
+
+static void nfnetlink_unbind(struct net *net, int group)
+{
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	int type = nfnl_group2type[group];
+
+	if (type == NFNL_SUBSYS_CTNETLINK) {
+		struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+		WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == 0);
+		nfnlnet->ctnetlink_listeners--;
+		if (nfnlnet->ctnetlink_listeners == 0)
+			WRITE_ONCE(net->ct.ctnetlink_has_listener, false);
+		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
+	}
 #endif
+}
 
 static int __net_init nfnetlink_net_init(struct net *net)
 {
@@ -680,9 +715,8 @@ static int __net_init nfnetlink_net_init(struct net *net)
 	struct netlink_kernel_cfg cfg = {
 		.groups	= NFNLGRP_MAX,
 		.input	= nfnetlink_rcv,
-#ifdef CONFIG_MODULES
 		.bind	= nfnetlink_bind,
-#endif
+		.unbind	= nfnetlink_unbind,
 	};
 
 	nfnlnet->nfnl = netlink_kernel_create(net, NETLINK_NETFILTER, &cfg);
-- 
2.30.2

