Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9531D702F
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 09:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfJOHdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 03:33:04 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42146 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbfJOHdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 03:33:02 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 85F9725BE27;
        Tue, 15 Oct 2019 18:32:54 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 79B65E207B4; Tue, 15 Oct 2019 09:32:52 +0200 (CEST)
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 3/6] ipvs: batch __ip_vs_dev_cleanup
Date:   Tue, 15 Oct 2019 09:32:09 +0200
Message-Id: <20191015073212.19394-4-horms@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191015073212.19394-1-horms@verge.net.au>
References: <20191015073212.19394-1-horms@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

It's better to batch __ip_vs_cleanup to speedup ipvs
devices dismantle.

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_core.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 93cfb47823d1..512259f579d7 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2433,14 +2433,19 @@ static int __net_init __ip_vs_dev_init(struct net *net)
 	return ret;
 }
 
-static void __net_exit __ip_vs_dev_cleanup(struct net *net)
+static void __net_exit __ip_vs_dev_cleanup_batch(struct list_head *net_list)
 {
-	struct netns_ipvs *ipvs = net_ipvs(net);
+	struct netns_ipvs *ipvs;
+	struct net *net;
+
 	EnterFunction(2);
-	nf_unregister_net_hooks(net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
-	ipvs->enable = 0;	/* Disable packet reception */
-	smp_wmb();
-	ip_vs_sync_net_cleanup(ipvs);
+	list_for_each_entry(net, net_list, exit_list) {
+		ipvs = net_ipvs(net);
+		nf_unregister_net_hooks(net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
+		ipvs->enable = 0;	/* Disable packet reception */
+		smp_wmb();
+		ip_vs_sync_net_cleanup(ipvs);
+	}
 	LeaveFunction(2);
 }
 
@@ -2453,7 +2458,7 @@ static struct pernet_operations ipvs_core_ops = {
 
 static struct pernet_operations ipvs_core_dev_ops = {
 	.init = __ip_vs_dev_init,
-	.exit = __ip_vs_dev_cleanup,
+	.exit_batch = __ip_vs_dev_cleanup_batch,
 };
 
 /*
-- 
2.11.0

