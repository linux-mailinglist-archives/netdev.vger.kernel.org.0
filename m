Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CFB1B9090
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 15:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgDZNYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 09:24:39 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:26160 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgDZNYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 09:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587907456; x=1619443456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NrvwqP3FokjZmNw4C4XLRV/01OvK9XJKFgcTLvtia/4=;
  b=Vz8xW5ahWsDp3h0AZ0/iCMWHAlDudwZDbHZgwfflJmA0icQYPVEBENyS
   bIyg1l94xWZfGHwNE7o6d+EwbAhhKVF1J53UtoqNSAlKo9OZ4c6c2uxTo
   DwoJssCoEWcizEd9Qmqv0LDlwJI3tabYFYCFVwniiKmZTJyIyd3kxczrb
   hugmsjglc4wscG/9EnZnjS4yxkPjgov71gT0T4heKwzLAQbUOAc9I2IMM
   ahXcErHOaW9ktbWaFjopeczM19j1Rv5oYeqYejfZWucjf6Ryu45MEcsYa
   BNQjEEEHLAPMoBwQhWeBdU2CraRHjCtCrMDi3k+WGk3iXxQzMPx8CEfvR
   Q==;
IronPort-SDR: uVlEAE/yJ6UBZpqaOVVKwFlUtGT5vOo86XWwaqSkceU5QM4QsiutkwpI06OPvN6bYKncOfwxsj
 2IlI2VvCvUlV9otSMOPPtW4FUgkGX2aMZQVDbFQKnrVe75chaaFktVgJw8V2xaZnbqZwkrpJex
 ZJAiiHsxTPA42AWSD+FwjAWEmi1HOIxIsWcMLsaqHWklLuOiHUVvMF7VVYsBd3bvRD4EegSpax
 /XlUrF3pirQ2GjtKtX/vEX523xzXL4mndtlBgeZJukFg+3QeGewN5tZXFczgrqRvQsb+0spaU5
 Tfc=
X-IronPort-AV: E=Sophos;i="5.73,320,1583218800"; 
   d="scan'208";a="73367266"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2020 06:24:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Apr 2020 06:24:16 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Sun, 26 Apr 2020 06:24:13 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 10/11] bridge: mrp: Integrate MRP into the bridge
Date:   Sun, 26 Apr 2020 15:22:07 +0200
Message-ID: <20200426132208.3232-11-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426132208.3232-1-horatiu.vultur@microchip.com>
References: <20200426132208.3232-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To integrate MRP into the bridge, the bridge needs to do the following:
- detect if the MRP frame was received on MRP ring port in that case it would be
  processed otherwise just forward it as usual.
- enable parsing of MRP
- before whenever the bridge was set up, it would set all the ports in
  forwarding state. Add an extra check to not set ports in forwarding state if
  the port is an MRP ring port. The reason of this change is that if the MRP
  instance initially sets the port in blocked state by setting the bridge up it
  would overwrite this setting.

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_device.c  |  3 +++
 net/bridge/br_if.c      |  2 ++
 net/bridge/br_input.c   |  3 +++
 net/bridge/br_netlink.c |  5 +++++
 net/bridge/br_private.h | 31 +++++++++++++++++++++++++++++++
 5 files changed, 44 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 0e3dbc5f3c34..8ec1362588af 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -463,6 +463,9 @@ void br_dev_setup(struct net_device *dev)
 	spin_lock_init(&br->lock);
 	INIT_LIST_HEAD(&br->port_list);
 	INIT_HLIST_HEAD(&br->fdb_list);
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	INIT_LIST_HEAD(&br->mrp_list);
+#endif
 	spin_lock_init(&br->hash_lock);
 
 	br->bridge_id.prio[0] = 0x80;
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 4fe30b182ee7..ca685c0cdf95 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -333,6 +333,8 @@ static void del_nbp(struct net_bridge_port *p)
 	br_stp_disable_port(p);
 	spin_unlock_bh(&br->lock);
 
+	br_mrp_port_del(br, p);
+
 	br_ifinfo_notify(RTM_DELLINK, NULL, p);
 
 	list_del_rcu(&p->list);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index fcc260840028..d5c34f36f0f4 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -342,6 +342,9 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 		}
 	}
 
+	if (unlikely(br_mrp_process(p, skb)))
+		return RX_HANDLER_PASS;
+
 forward:
 	switch (p->state) {
 	case BR_STATE_FORWARDING:
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 4084f1ef8641..1a5e681a626a 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -672,6 +672,11 @@ static int br_afspec(struct net_bridge *br,
 			if (err)
 				return err;
 			break;
+		case IFLA_BRIDGE_MRP:
+			err = br_mrp_parse(br, p, attr, cmd, extack);
+			if (err)
+				return err;
+			break;
 		}
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 835a70f8d3ea..5835828320b6 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1308,6 +1308,37 @@ unsigned long br_timer_value(const struct timer_list *timer);
 extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr);
 #endif
 
+/* br_mrp.c */
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
+		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
+int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
+bool br_mrp_enabled(struct net_bridge *br);
+void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p);
+#else
+static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
+			       struct nlattr *attr, int cmd,
+			       struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline bool br_mrp_enabled(struct net_bridge *br)
+{
+	return 0;
+}
+
+static inline void br_mrp_port_del(struct net_bridge *br,
+				   struct net_bridge_port *p)
+{
+}
+#endif
+
 /* br_netlink.c */
 extern struct rtnl_link_ops br_link_ops;
 int br_netlink_init(void);
-- 
2.17.1

