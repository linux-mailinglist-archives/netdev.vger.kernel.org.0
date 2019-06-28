Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D2E59D55
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfF1N4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:56:18 -0400
Received: from packetmixer.de ([79.140.42.25]:53066 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfF1N4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:56:13 -0400
Received: from kero.packetmixer.de (p4FD57BD9.dip0.t-ipconnect.de [79.213.123.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 2A5E362074;
        Fri, 28 Jun 2019 15:56:08 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 07/10] batman-adv: mcast: avoid redundant multicast TT entries with bridges
Date:   Fri, 28 Jun 2019 15:56:01 +0200
Message-Id: <20190628135604.11581-8-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190628135604.11581-1-sw@simonwunderlich.de>
References: <20190628135604.11581-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

When a bridge is added on top of bat0 we set the WANT_ALL_UNSNOOPABLES
flag. Which means we sign up for all traffic for ff02::1/128 and
224.0.0.0/24.

When the node itself had IPv6 enabled or joined a group in 224.0.0.0/24
itself then so far this would result in a multicast TT entry which is
redundant to the WANT_ALL_UNSNOOPABLES.

With this patch such redundant TT entries are avoided.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/multicast.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index ca9e2e67bdc6..d4e7474022e3 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -230,6 +230,10 @@ batadv_mcast_mla_softif_get_ipv4(struct net_device *dev,
 
 	for (pmc = rcu_dereference(in_dev->mc_list); pmc;
 	     pmc = rcu_dereference(pmc->next_rcu)) {
+		if (flags->tvlv_flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES &&
+		    ipv4_is_local_multicast(pmc->multiaddr))
+			continue;
+
 		ip_eth_mc_map(pmc->multiaddr, mcast_addr);
 
 		if (batadv_mcast_mla_is_duplicate(mcast_addr, mcast_list))
@@ -293,6 +297,10 @@ batadv_mcast_mla_softif_get_ipv6(struct net_device *dev,
 		    IPV6_ADDR_SCOPE_LINKLOCAL)
 			continue;
 
+		if (flags->tvlv_flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES &&
+		    ipv6_addr_is_ll_all_nodes(&pmc6->mca_addr))
+			continue;
+
 		ipv6_eth_mc_map(&pmc6->mca_addr, mcast_addr);
 
 		if (batadv_mcast_mla_is_duplicate(mcast_addr, mcast_list))
@@ -413,9 +421,8 @@ static int batadv_mcast_mla_bridge_get(struct net_device *dev,
 				       struct batadv_mcast_mla_flags *flags)
 {
 	struct list_head bridge_mcast_list = LIST_HEAD_INIT(bridge_mcast_list);
-	bool all_ipv4 = flags->tvlv_flags & BATADV_MCAST_WANT_ALL_IPV4;
-	bool all_ipv6 = flags->tvlv_flags & BATADV_MCAST_WANT_ALL_IPV6;
 	struct br_ip_list *br_ip_entry, *tmp;
+	u8 tvlv_flags = flags->tvlv_flags;
 	struct batadv_hw_addr *new;
 	u8 mcast_addr[ETH_ALEN];
 	int ret;
@@ -428,11 +435,25 @@ static int batadv_mcast_mla_bridge_get(struct net_device *dev,
 		goto out;
 
 	list_for_each_entry(br_ip_entry, &bridge_mcast_list, list) {
-		if (all_ipv4 && br_ip_entry->addr.proto == htons(ETH_P_IP))
-			continue;
+		if (br_ip_entry->addr.proto == htons(ETH_P_IP)) {
+			if (tvlv_flags & BATADV_MCAST_WANT_ALL_IPV4)
+				continue;
 
-		if (all_ipv6 && br_ip_entry->addr.proto == htons(ETH_P_IPV6))
-			continue;
+			if (tvlv_flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES &&
+			    ipv4_is_local_multicast(br_ip_entry->addr.u.ip4))
+				continue;
+		}
+
+#if IS_ENABLED(CONFIG_IPV6)
+		if (br_ip_entry->addr.proto == htons(ETH_P_IPV6)) {
+			if (tvlv_flags & BATADV_MCAST_WANT_ALL_IPV6)
+				continue;
+
+			if (tvlv_flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES &&
+			    ipv6_addr_is_ll_all_nodes(&br_ip_entry->addr.u.ip6))
+				continue;
+		}
+#endif
 
 		batadv_mcast_mla_br_addr_cpy(mcast_addr, &br_ip_entry->addr);
 		if (batadv_mcast_mla_is_duplicate(mcast_addr, mcast_list))
-- 
2.11.0

