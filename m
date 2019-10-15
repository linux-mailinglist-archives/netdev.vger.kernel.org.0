Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295F1D7033
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 09:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfJOHdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 03:33:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42146 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbfJOHdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 03:33:06 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 8084D25BE09;
        Tue, 15 Oct 2019 18:32:54 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 7448AE2077B; Tue, 15 Oct 2019 09:32:52 +0200 (CEST)
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 2/6] ipvs: batch __ip_vs_cleanup
Date:   Tue, 15 Oct 2019 09:32:08 +0200
Message-Id: <20191015073212.19394-3-horms@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191015073212.19394-1-horms@verge.net.au>
References: <20191015073212.19394-1-horms@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

It's better to batch __ip_vs_cleanup to speedup ipvs
connections dismantle.

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 include/net/ip_vs.h             |  2 +-
 net/netfilter/ipvs/ip_vs_core.c | 28 ++++++++++++++++------------
 net/netfilter/ipvs/ip_vs_ctl.c  | 12 +++++++++---
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 3759167f91f5..93e7a252993d 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1324,7 +1324,7 @@ void ip_vs_protocol_net_cleanup(struct netns_ipvs *ipvs);
 void ip_vs_control_net_cleanup(struct netns_ipvs *ipvs);
 void ip_vs_estimator_net_cleanup(struct netns_ipvs *ipvs);
 void ip_vs_sync_net_cleanup(struct netns_ipvs *ipvs);
-void ip_vs_service_net_cleanup(struct netns_ipvs *ipvs);
+void ip_vs_service_nets_cleanup(struct list_head *net_list);
 
 /* IPVS application functions
  * (from ip_vs_app.c)
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 8b80ab794a92..93cfb47823d1 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2402,18 +2402,22 @@ static int __net_init __ip_vs_init(struct net *net)
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
@@ -2442,7 +2446,7 @@ static void __net_exit __ip_vs_dev_cleanup(struct net *net)
 
 static struct pernet_operations ipvs_core_ops = {
 	.init = __ip_vs_init,
-	.exit = __ip_vs_cleanup,
+	.exit_batch = __ip_vs_cleanup_batch,
 	.id   = &ip_vs_net_id,
 	.size = sizeof(struct netns_ipvs),
 };
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 8b48e7ce1c2c..153c77b5c4f5 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1607,14 +1607,20 @@ static int ip_vs_flush(struct netns_ipvs *ipvs, bool cleanup)
 
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
2.11.0

