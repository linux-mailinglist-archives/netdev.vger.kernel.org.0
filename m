Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52BEB67AFB
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 17:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfGMPgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 11:36:08 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:56807 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbfGMPgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 11:36:08 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jul 2019 11:33:32 EDT
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app11-12011 (RichMail) with SMTP id 2eeb5d29f76a5ff-3a720; Sat, 13 Jul 2019 23:23:22 +0800 (CST)
X-RM-TRANSID: 2eeb5d29f76a5ff-3a720
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee25d29f7698ba-83e2a;
        Sat, 13 Jul 2019 23:23:22 +0800 (CST)
X-RM-TRANSID: 2ee25d29f7698ba-83e2a
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [net-next 1/2] ipvs: batch __ip_vs_cleanup
Date:   Sat, 13 Jul 2019 23:19:45 +0800
Message-Id: <1563031186-2101-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1563031186-2101-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1563031186-2101-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's better to batch __ip_vs_cleanup to speedup ipvs
connections dismantle.

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 include/net/ip_vs.h             |  2 +-
 net/netfilter/ipvs/ip_vs_core.c | 29 +++++++++++++++++------------
 net/netfilter/ipvs/ip_vs_ctl.c  | 13 ++++++++++---
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 3759167..93e7a25 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1324,7 +1324,7 @@ static inline void ip_vs_control_del(struct ip_vs_conn *cp)
 void ip_vs_control_net_cleanup(struct netns_ipvs *ipvs);
 void ip_vs_estimator_net_cleanup(struct netns_ipvs *ipvs);
 void ip_vs_sync_net_cleanup(struct netns_ipvs *ipvs);
-void ip_vs_service_net_cleanup(struct netns_ipvs *ipvs);
+void ip_vs_service_nets_cleanup(struct list_head *net_list);
 
 /* IPVS application functions
  * (from ip_vs_app.c)
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 46f06f9..b4d79b7 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2402,18 +2402,23 @@ static int __net_init __ip_vs_init(struct net *net)
 	return -ENOMEM;
 }
 
-static void __net_exit __ip_vs_cleanup(struct net *net)
+static void __net_exit __ip_vs_cleanup_batch(struct list_head *net_list)
 {
-	struct netns_ipvs *ipvs = net_ipvs(net);
-
-	ip_vs_service_net_cleanup(ipvs);	/* ip_vs_flush() with locks */
-	ip_vs_conn_net_cleanup(ipvs);
-	ip_vs_app_net_cleanup(ipvs);
-	ip_vs_protocol_net_cleanup(ipvs);
-	ip_vs_control_net_cleanup(ipvs);
-	ip_vs_estimator_net_cleanup(ipvs);
-	IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
-	net->ipvs = NULL;
+	struct netns_ipvs *ipvs;
+	struct net *net;
+	LIST_HEAD(list);
+
+	ip_vs_service_nets_cleanup(net_list);	/* ip_vs_flush() with locks */
+	list_for_each_entry(net, net_list, exit_list) {
+		ipvs = net_ipvs(net);
+		ip_vs_conn_net_cleanup(ipvs);
+		ip_vs_app_net_cleanup(ipvs);
+		ip_vs_protocol_net_cleanup(ipvs);
+		ip_vs_control_net_cleanup(ipvs);
+		ip_vs_estimator_net_cleanup(ipvs);
+		IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
+		net->ipvs = NULL;
+	}
 }
 
 static int __net_init __ip_vs_dev_init(struct net *net)
@@ -2442,7 +2447,7 @@ static void __net_exit __ip_vs_dev_cleanup(struct net *net)
 
 static struct pernet_operations ipvs_core_ops = {
 	.init = __ip_vs_init,
-	.exit = __ip_vs_cleanup,
+	.exit_batch = __ip_vs_cleanup_batch,
 	.id   = &ip_vs_net_id,
 	.size = sizeof(struct netns_ipvs),
 };
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 07e0967..c8e652b 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1607,14 +1607,21 @@ static int ip_vs_flush(struct netns_ipvs *ipvs, bool cleanup)
 
 /*
  *	Delete service by {netns} in the service table.
- *	Called by __ip_vs_cleanup()
+ *	Called by __ip_vs_batch_cleanup()
  */
-void ip_vs_service_net_cleanup(struct netns_ipvs *ipvs)
+void ip_vs_service_nets_cleanup(struct list_head *net_list)
 {
+	struct netns_ipvs *ipvs;
+	struct net *net;
+	LIST_HEAD(list);
+
 	EnterFunction(2);
 	/* Check for "full" addressed entries */
 	mutex_lock(&__ip_vs_mutex);
-	ip_vs_flush(ipvs, true);
+	list_for_each_entry(net, net_list, exit_list) {
+		ipvs = net_ipvs(net);
+		ip_vs_flush(ipvs, true);
+	}
 	mutex_unlock(&__ip_vs_mutex);
 	LeaveFunction(2);
 }
-- 
1.8.3.1



