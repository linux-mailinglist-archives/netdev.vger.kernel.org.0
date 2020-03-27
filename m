Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BFB1953D1
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgC0JWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:22:42 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:2539 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbgC0JWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:22:41 -0400
IronPort-SDR: HMqslWEYw8OcDa8S/4MzCb8BBYhWv1ki/fR3TfFHA4MRFFPRfz8UJVEkMKU69SM4HF6DhJODTb
 IerDro44VqlL6maTagGgFguWKH5uHeM8bYGSg+pXuE4yx5OVdxd6tY4pNNUdyP8qlqGib13xfh
 lXsss30/DZ9Ff/lC6RphjNdc28qJWuU/xzM1FI+DqEri6UwwgL55VZ7SuQT7TSzx0yMuvjuBqK
 TAmPSz2W3ZLA9gAqYqwcoeTuVGx1VqAUfloheBJihDGRAWAuwufiSZaLxSfcY4EUrhgmhoyrQD
 UGQ=
X-IronPort-AV: E=Sophos;i="5.72,311,1580799600"; 
   d="scan'208";a="68596770"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Mar 2020 02:22:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 27 Mar 2020 02:22:39 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 27 Mar 2020 02:22:37 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <nikolay@cumulusnetworks.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v4 8/9] bridge: mrp: Integrate MRP into the bridge
Date:   Fri, 27 Mar 2020 10:21:25 +0100
Message-ID: <20200327092126.15407-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327092126.15407-1-horatiu.vultur@microchip.com>
References: <20200327092126.15407-1-horatiu.vultur@microchip.com>
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
 net/bridge/br_input.c     |  3 +++
 net/bridge/br_netlink.c   |  5 +++++
 net/bridge/br_private.h   | 22 ++++++++++++++++++++++
 net/bridge/br_stp.c       |  6 ++++++
 6 files changed, 40 insertions(+)

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
index 43dab4066f91..77bc96745be6 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -669,6 +669,11 @@ static int br_afspec(struct net_bridge *br,
 			if (err)
 				return err;
 			break;
+		case IFLA_BRIDGE_MRP:
+			err = br_mrp_parse(br, p, attr, cmd);
+			if (err)
+				return err;
+			break;
 		}
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1f97703a52ff..38894f2cf98f 100644
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
@@ -1304,6 +1308,24 @@ unsigned long br_timer_value(const struct timer_list *timer);
 extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr);
 #endif
 
+/* br_mrp.c */
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
+		 struct nlattr *attr, int cmd);
+int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
+#else
+static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
+			       struct nlattr *attr, int cmd)
+{
+	return -1;
+}
+
+static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
+{
+	return -1;
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
-- 
2.17.1

