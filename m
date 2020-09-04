Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA3225D48C
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgIDJTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:19:38 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:60002 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730020AbgIDJTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 05:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599211170; x=1630747170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o6duENUzbkFkp2C7Ma8T2ODsQTBHZTrbxuc1hJaheSQ=;
  b=h+w2LU1Qvw9JUaZHVfiiFMrse6sMdKQmGHVcF5/KBVamyb2vu16Oj/rK
   lraMLliTbXkyG7FbAbYYbj+evI+xuRp23gxfXgWFEZOmkN8QJR3bRvY7U
   qIOwA70P4m966Q1hJMhozJ9wSKm4VXHIKHxosDsSsJum2YKXOykzzqlq4
   9qhe1RfOkTJO6npud68nxaIKcDej42xW8JJu/u+RLGd+N6e+eViZB7GHf
   gZPzRGddtFOdn2zN9ghPv/ZT2/54zb5hOM3OjVlk47h9MiBX2Kg7lpgeg
   Qw//gFXPbJp50LYR6gF07ZIpstzUpT+WYM8kw2tsjsBRPMCnLi4/f6gAR
   w==;
IronPort-SDR: q2e3qpfgqw6aym00g6OqT9sIQtYpZG+Up60/WsH2lyF+bFE2bmAmOveq9aZkWMsXRP+OrrJsT+
 /ckVmdT9Okb1RCofS+Qk5fmXlVpH7iJI4DoAkjhwMxYtOTyxueOYjNJkSwfGoP8NAxCzOUdQT6
 ifhozmW/6uO24mYBzeA25o76fD5sLkZoxnwW0k9aWL3quRuRtbG6B/i9fiszVUA9gE17d66fWa
 zR5TZrm6Mm0tAL3MUskMW+A/K5OvuBrEeoLJvNnY5xZsN6NfJV1yPSAcx4WVzUJR/65d/ue5du
 Nqs=
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="90552474"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Sep 2020 02:19:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Sep 2020 02:18:38 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Sep 2020 02:19:22 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH RFC 7/7] bridge: cfm: Bridge port remove.
Date:   Fri, 4 Sep 2020 09:15:27 +0000
Message-ID: <20200904091527.669109-8-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is addition of CFM functionality to delete MEP instances
on a port that is removed from the bridge.
A MEP can only exist on a port that is related to a bridge.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
---
 net/bridge/br_cfm.c     | 13 +++++++++++++
 net/bridge/br_if.c      |  1 +
 net/bridge/br_private.h |  6 ++++++
 3 files changed, 20 insertions(+)

diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
index b7fed2c1d8ec..c724ce020ce3 100644
--- a/net/bridge/br_cfm.c
+++ b/net/bridge/br_cfm.c
@@ -921,3 +921,16 @@ bool br_cfm_created(struct net_bridge *br)
 {
 	return !list_empty(&br->mep_list);
 }
+
+/* Deletes the CFM instances on a specific bridge port
+ * note: called under rtnl_lock
+ */
+void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *port)
+{
+	struct br_cfm_mep *mep;
+
+	list_for_each_entry_rcu(mep, &br->mep_list, head,
+				lockdep_rtnl_is_held())
+		if (mep->create.ifindex == port->dev->ifindex)
+			mep_delete_implementation(br, mep);
+}
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a0e9a7937412..f7d2f472ae24 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -334,6 +334,7 @@ static void del_nbp(struct net_bridge_port *p)
 	spin_unlock_bh(&br->lock);
 
 	br_mrp_port_del(br, p);
+	br_cfm_port_del(br, p);
 
 	br_ifinfo_notify(RTM_DELLINK, NULL, p);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 53bcbdd21f34..5617255f0c0c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1369,6 +1369,7 @@ int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
 int br_cfm_rx_frame_process(struct net_bridge_port *p, struct sk_buff *skb);
 bool br_cfm_created(struct net_bridge *br);
+void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *p);
 int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br);
 int br_cfm_status_fill_info(struct sk_buff *skb,
 			    struct net_bridge *br,
@@ -1393,6 +1394,11 @@ static inline bool br_cfm_created(struct net_bridge *br)
 	return false;
 }
 
+static inline void br_cfm_port_del(struct net_bridge *br,
+				   struct net_bridge_port *p)
+{
+}
+
 static inline int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
 {
 	return -EOPNOTSUPP;
-- 
2.28.0

