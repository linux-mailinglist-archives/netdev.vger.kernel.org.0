Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3871D16A5
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388462AbgEMN6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:58:49 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:40430 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387608AbgEMN6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 09:58:48 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 528A53F1C16;
        Wed, 13 May 2020 15:58:45 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1jYruH-0002AG-7t; Wed, 13 May 2020 15:58:45 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next] netns: enable to inherit devconf from current netns
Date:   Wed, 13 May 2020 15:58:43 +0200
Message-Id: <20200513135843.8242-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal is to be able to inherit the initial devconf parameters from the
current netns, ie the netns where this new netns has been created.

This is useful in a containers environment where /proc/sys is read only.
For example, if a pod is created with specifics devconf parameters and has
the capability to create netns, the user expects to get the same parameters
than his 'init_net', which is not the real init_net in this case.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 Documentation/admin-guide/sysctl/net.rst |  4 +++-
 net/core/sysctl_net_core.c               |  4 +++-
 net/ipv4/devinet.c                       | 23 ++++++++++++++++++-----
 net/ipv6/addrconf.c                      | 23 ++++++++++++++++++++---
 4 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 2ad1b77a7182..42cd04bca548 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -339,7 +339,9 @@ settings from init_net and for IPv6 we reset all settings to default.
 
 If set to 1, both IPv4 and IPv6 settings are forced to inherit from
 current ones in init_net. If set to 2, both IPv4 and IPv6 settings are
-forced to reset to their default values.
+forced to reset to their default values. If set to 3, both IPv4 and IPv6
+settings are forced to inherit from current ones in the netns where this
+new netns has been created.
 
 Default : 0  (for compatibility reasons)
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 0ddb13a6282b..b109cc8a6dd8 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -23,6 +23,7 @@
 #include <net/pkt_sched.h>
 
 static int two __maybe_unused = 2;
+static int three = 3;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
@@ -39,6 +40,7 @@ EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
  *     IPv6: reset all settings to default
  * 1 - Both inherit all current settings from init_net
  * 2 - Both reset all settings to default
+ * 3 - Both inherit all settings from current netns
  */
 int sysctl_devconf_inherit_init_net __read_mostly;
 EXPORT_SYMBOL(sysctl_devconf_inherit_init_net);
@@ -553,7 +555,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= &three,
 	},
 	{
 		.procname	= "high_order_alloc_disable",
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index fc94f82f82c7..f048d0a188b7 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2666,11 +2666,24 @@ static __net_init int devinet_init_net(struct net *net)
 	tbl[0].extra2 = net;
 #endif
 
-	if ((!IS_ENABLED(CONFIG_SYSCTL) ||
-	     sysctl_devconf_inherit_init_net != 2) &&
-	    !net_eq(net, &init_net)) {
-		memcpy(all, init_net.ipv4.devconf_all, sizeof(ipv4_devconf));
-		memcpy(dflt, init_net.ipv4.devconf_dflt, sizeof(ipv4_devconf_dflt));
+	if (!net_eq(net, &init_net)) {
+		if (IS_ENABLED(CONFIG_SYSCTL) &&
+		    sysctl_devconf_inherit_init_net == 3) {
+			/* copy from the current netns */
+			memcpy(all, current->nsproxy->net_ns->ipv4.devconf_all,
+			       sizeof(ipv4_devconf));
+			memcpy(dflt,
+			       current->nsproxy->net_ns->ipv4.devconf_dflt,
+			       sizeof(ipv4_devconf_dflt));
+		} else if (!IS_ENABLED(CONFIG_SYSCTL) ||
+			   sysctl_devconf_inherit_init_net != 2) {
+			/* inherit == 0 or 1: copy from init_net */
+			memcpy(all, init_net.ipv4.devconf_all,
+			       sizeof(ipv4_devconf));
+			memcpy(dflt, init_net.ipv4.devconf_dflt,
+			       sizeof(ipv4_devconf_dflt));
+		}
+		/* else inherit == 2: use compiled values */
 	}
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index fd885f06c4ed..ab7e839753ae 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6991,9 +6991,26 @@ static int __net_init addrconf_init_net(struct net *net)
 		goto err_alloc_dflt;
 
 	if (IS_ENABLED(CONFIG_SYSCTL) &&
-	    sysctl_devconf_inherit_init_net == 1 && !net_eq(net, &init_net)) {
-		memcpy(all, init_net.ipv6.devconf_all, sizeof(ipv6_devconf));
-		memcpy(dflt, init_net.ipv6.devconf_dflt, sizeof(ipv6_devconf_dflt));
+	    !net_eq(net, &init_net)) {
+		switch (sysctl_devconf_inherit_init_net) {
+		case 1:  /* copy from init_net */
+			memcpy(all, init_net.ipv6.devconf_all,
+			       sizeof(ipv6_devconf));
+			memcpy(dflt, init_net.ipv6.devconf_dflt,
+			       sizeof(ipv6_devconf_dflt));
+			break;
+		case 3: /* copy from the current netns */
+			memcpy(all, current->nsproxy->net_ns->ipv6.devconf_all,
+			       sizeof(ipv6_devconf));
+			memcpy(dflt,
+			       current->nsproxy->net_ns->ipv6.devconf_dflt,
+			       sizeof(ipv6_devconf_dflt));
+			break;
+		case 0:
+		case 2:
+			/* use compiled values */
+			break;
+		}
 	}
 
 	/* these will be inherited by all namespaces */
-- 
2.26.2

