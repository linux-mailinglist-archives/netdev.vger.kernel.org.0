Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858CEBFE70
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 07:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbfI0FEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 01:04:55 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:2983 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfI0FEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 01:04:54 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.19]) by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee55d8d963cffc-3ac18; Fri, 27 Sep 2019 12:55:24 +0800 (CST)
X-RM-TRANSID: 2ee55d8d963cffc-3ac18
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea5d8d963bc64-9fd87;
        Fri, 27 Sep 2019 12:55:24 +0800 (CST)
X-RM-TRANSID: 2eea5d8d963bc64-9fd87
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH v2 2/2] ipvs: batch __ip_vs_dev_cleanup
Date:   Fri, 27 Sep 2019 12:54:51 +0800
Message-Id: <1569560091-20553-3-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569560091-20553-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1569560091-20553-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's better to batch __ip_vs_cleanup to speedup ipvs
devices dismantle.

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
v2: remove unused pointer list
---
 net/netfilter/ipvs/ip_vs_core.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 93cfb47..512259f 100644
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
 
@@ -2453,7 +2458,7 @@ static void __net_exit __ip_vs_dev_cleanup(struct net *net)
 
 static struct pernet_operations ipvs_core_dev_ops = {
 	.init = __ip_vs_dev_init,
-	.exit = __ip_vs_dev_cleanup,
+	.exit_batch = __ip_vs_dev_cleanup_batch,
 };
 
 /*
-- 
1.8.3.1



