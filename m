Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD4F67AFF
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 17:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfGMPia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 11:38:30 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:2141 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfGMPia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 11:38:30 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.5]) by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee85d29f77052c-3a621; Sat, 13 Jul 2019 23:23:28 +0800 (CST)
X-RM-TRANSID: 2ee85d29f77052c-3a621
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee35d29f76f5a8-83a47;
        Sat, 13 Jul 2019 23:23:28 +0800 (CST)
X-RM-TRANSID: 2ee35d29f76f5a8-83a47
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [net-next 2/2] ipvs: batch __ip_vs_dev_cleanup
Date:   Sat, 13 Jul 2019 23:19:46 +0800
Message-Id: <1563031186-2101-3-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1563031186-2101-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1563031186-2101-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's better to batch __ip_vs_cleanup to speedup ipvs
devices dismantle.

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index b4d79b7..58af24a 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2434,14 +2434,20 @@ static int __net_init __ip_vs_dev_init(struct net *net)
 	return ret;
 }
 
-static void __net_exit __ip_vs_dev_cleanup(struct net *net)
+static void __net_exit __ip_vs_dev_cleanup_batch(struct list_head *net_list)
 {
-	struct netns_ipvs *ipvs = net_ipvs(net);
+	struct netns_ipvs *ipvs;
+	struct net *net;
+	LIST_HEAD(list);
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
 
@@ -2454,7 +2460,7 @@ static void __net_exit __ip_vs_dev_cleanup(struct net *net)
 
 static struct pernet_operations ipvs_core_dev_ops = {
 	.init = __ip_vs_dev_init,
-	.exit = __ip_vs_dev_cleanup,
+	.exit_batch = __ip_vs_dev_cleanup_batch,
 };
 
 /*
-- 
1.8.3.1



