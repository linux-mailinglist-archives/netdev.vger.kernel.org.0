Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED4CE5A3D
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfJZLrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:48 -0400
Received: from correo.us.es ([193.147.175.20]:46426 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbfJZLrs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18A028C3C46
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08263DA840
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 073B1DA801; Sat, 26 Oct 2019 13:47:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E98FB7FFE;
        Sat, 26 Oct 2019 13:47:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D153242EE395;
        Sat, 26 Oct 2019 13:47:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/31] ipvs: batch __ip_vs_cleanup
Date:   Sat, 26 Oct 2019 13:47:11 +0200
Message-Id: <20191026114733.28111-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
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

