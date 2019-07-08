Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3694761D11
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbfGHKdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 06:33:20 -0400
Received: from mail.us.es ([193.147.175.20]:34344 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbfGHKcw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4774ABAE8B
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 396CA5765B
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2EF3310219C; Mon,  8 Jul 2019 12:32:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FF9B5765B;
        Mon,  8 Jul 2019 12:32:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E45BA4265A2F;
        Mon,  8 Jul 2019 12:32:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/15] bridge: add br_vlan_get_pvid_rcu()
Date:   Mon,  8 Jul 2019 12:32:31 +0200
Message-Id: <20190708103237.28061-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new function allows you to fetch bridge pvid from packet path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_vlan.c      | 19 +++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index f3fab5d0ea97..950db1dad830 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -88,6 +88,7 @@ static inline bool br_multicast_router(const struct net_device *dev)
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
 bool br_vlan_enabled(const struct net_device *dev);
 int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid);
+int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 #else
@@ -101,6 +102,11 @@ static inline int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
 	return -EINVAL;
 }
 
+static inline int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
+{
+	return -EINVAL;
+}
+
 static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 				   struct bridge_vlan_info *p_vinfo)
 {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index f47f526b4f19..8d97b91ad503 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1227,13 +1227,11 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 	}
 }
 
-int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
+static int __br_vlan_get_pvid(const struct net_device *dev,
+			      struct net_bridge_port *p, u16 *p_pvid)
 {
 	struct net_bridge_vlan_group *vg;
-	struct net_bridge_port *p;
 
-	ASSERT_RTNL();
-	p = br_port_get_check_rtnl(dev);
 	if (p)
 		vg = nbp_vlan_group(p);
 	else if (netif_is_bridge_master(dev))
@@ -1244,8 +1242,21 @@ int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
 	*p_pvid = br_get_pvid(vg);
 	return 0;
 }
+
+int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
+{
+	ASSERT_RTNL();
+
+	return __br_vlan_get_pvid(dev, br_port_get_check_rtnl(dev), p_pvid);
+}
 EXPORT_SYMBOL_GPL(br_vlan_get_pvid);
 
+int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
+{
+	return __br_vlan_get_pvid(dev, br_port_get_check_rcu(dev), p_pvid);
+}
+EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
+
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo)
 {
-- 
2.11.0

