Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B363C1A797B
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439100AbgDNL2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:28:22 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:39025 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439072AbgDNL1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 07:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586863661; x=1618399661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=AAktRsGo1nOyB9XwgW0b2ZZuoEurSDp9VgnnFBebWBg=;
  b=YXVQIEeN2NdSqtID5m5YqfXYvzrRMniXmfYkgcpvu6HIuiaQnpFJFkAm
   zhNnwBktN5T1hKBptFH0v8fquA/MkoBIEf9LGmnmzrZKMOCq18nit2iwp
   M3p3P77kCOMic1NqPe+MRlXkqQT+miYZdzGztJe1sXFUZn7f0e5QGvapp
   fnZHUUFkY6z8nIBTi6mCAb/rUZsvezBJrM2weH+g9tSAofj+fgM9UfG4r
   qnD9wzFbkkQr2EFtT5YeISR8BSg7BUaLjiaPsr3P/FAOW3plw6P7N8Wf6
   NUx/aqQglcU8/ONsjLTpUSpn0R7sYG8MQlHJkci1AnxszL70dEQ/cuXf0
   A==;
IronPort-SDR: 4ZjutON7erWUO1fBoDa8Dw4AA+M7jD3fRYVVhUn1HFlhZ6PdqcWiTrgkJspnN7EGOAmjADoP/r
 KyIhTqWK81jH36LJoWh68rl98fHOfykMbScijLYIRGm+K0s7u2K7uJ2qKSLjptj16ZTxcF6RIp
 sweq2LurWviTiQG6cTA40psnLYXXQmTBjby8BD3qkuVke1zBIJVJ+IqP6qUMuw0xounYGljrRZ
 LIjgRbjVbFr2yl5bVdj5F5YEL11OU1+gr+EbrV43L7azSyBOTZBvzzh/puKCCXqNJUdTjTjjSx
 xjU=
X-IronPort-AV: E=Sophos;i="5.72,382,1580799600"; 
   d="scan'208";a="73265533"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2020 04:27:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Apr 2020 04:27:37 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 14 Apr 2020 04:27:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v5 9/9] bridge: mrp: Integrate MRP into the bridge
Date:   Tue, 14 Apr 2020 13:26:18 +0200
Message-ID: <20200414112618.3644-10-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414112618.3644-1-horatiu.vultur@microchip.com>
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To integrate MRP into the bridge, the bridge needs to do the following:
- add new flag(BR_MPP_AWARE) to the net bridge ports, this bit will be set when
  the port is added to an MRP instance. In this way it knows if the frame was
  received on MRP ring port
- detect if the MRP frame was received on MRP ring port in that case it would be
  processed otherwise just forward it as usual.
- enable parsing of MRP
- before whenever the bridge was set up, it would set all the ports in
  forwarding state. Add an extra check to not set ports in forwarding state if
  the port is an MRP ring port. The reason of this change is that if the MRP
  instance initially sets the port in blocked state by setting the bridge up it
  would overwrite this setting.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/linux/if_bridge.h |  1 +
 net/bridge/br_device.c    |  3 +++
 net/bridge/br_if.c        |  2 ++
 net/bridge/br_input.c     |  3 +++
 net/bridge/br_netlink.c   |  5 +++++
 net/bridge/br_private.h   | 35 +++++++++++++++++++++++++++++++++++
 net/bridge/br_stp.c       |  6 ++++++
 net/bridge/br_stp_if.c    |  5 +++++
 8 files changed, 60 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 9e57c4411734..10baa9efdae8 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -47,6 +47,7 @@ struct br_ip_list {
 #define BR_BCAST_FLOOD		BIT(14)
 #define BR_NEIGH_SUPPRESS	BIT(15)
 #define BR_ISOLATED		BIT(16)
+#define BR_MRP_AWARE		BIT(17)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
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
index 43dab4066f91..8826fcd1eb76 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -669,6 +669,11 @@ static int br_afspec(struct net_bridge *br,
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
index 1f97703a52ff..5835828320b6 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -428,6 +428,10 @@ struct net_bridge {
 	int offload_fwd_mark;
 #endif
 	struct hlist_head		fdb_list;
+
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	struct list_head		__rcu mrp_list;
+#endif
 };
 
 struct br_input_skb_cb {
@@ -1304,6 +1308,37 @@ unsigned long br_timer_value(const struct timer_list *timer);
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
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 1f14b8455345..3e88be7aa269 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -36,6 +36,12 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 	};
 	int err;
 
+	/* Don't change the state of the ports if they are driven by a different
+	 * protocol.
+	 */
+	if (p->flags & BR_MRP_AWARE)
+		return;
+
 	p->state = state;
 	err = switchdev_port_attr_set(p->dev, &attr);
 	if (err && err != -EOPNOTSUPP)
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index d174d3a566aa..542b212d5033 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -200,6 +200,11 @@ void br_stp_set_enabled(struct net_bridge *br, unsigned long val)
 {
 	ASSERT_RTNL();
 
+	if (br_mrp_enabled(br)) {
+		br_warn(br, "STP can't be enabled if MRP is already enabled\n");
+		return;
+	}
+
 	if (val) {
 		if (br->stp_enabled == BR_NO_STP)
 			br_stp_start(br);
-- 
2.17.1

