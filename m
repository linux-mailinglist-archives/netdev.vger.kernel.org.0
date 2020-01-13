Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC0513914A
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgAMMrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:47:20 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:61024 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbgAMMrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 07:47:17 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: /NJ5dhXI04YBYuqtxzcSY+OYsOkFm+xai/oic5tF3spnU4w99cB3560uwJkwT2WtKKEpqbTH+o
 BtXU0wfFF3jCVHJdh3E/If4U2r8TBp9LkdCdk/qhp15JxjysTgfLi0EzMiW5MtwPPKyh7/gT/j
 Co7F+Ei/lw/TrQmY4QltcICPc2rU/ZBXdkzpFF6ADmKSecneXn4aw5GqkuRBeQf6B85sBk0ldE
 gnAQCDpCgkCwHKkWfIApsbQyLHZDHay2YwJCemwBxjkXvgtadKX5lC9b61JoZX64ruK6Ha+hsq
 J4g=
X-IronPort-AV: E=Sophos;i="5.69,429,1571727600"; 
   d="scan'208";a="63055970"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2020 05:47:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 05:47:12 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 13 Jan 2020 05:47:08 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <jakub.kicinski@netronome.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <anirudh.venkataramanan@intel.com>,
        <andrew@lunn.ch>, <dsahern@gmail.com>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next Patch v2 2/4] net: bridge: mrp: Integrate MRP into the bridge
Date:   Mon, 13 Jan 2020 13:46:18 +0100
Message-ID: <20200113124620.18657-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200113124620.18657-1-horatiu.vultur@microchip.com>
References: <20200113124620.18657-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To integrate MRP into the bridge, the bridge needs to do the following:
- notify when the link of one of the ports goes down or up, because MRP instance
  needs to react to link changes by sending MRP frames.
- notify when one of the ports are removed from the bridge or when the bridge
  is destroyed, because if the port is part of the MRP ring then MRP state
  machine should be stopped.
- add a handler to allow MRP instance to process MRP frames, if MRP is enabled.
  This is similar with STP design.
- add logic for MRP frames inside the bridge. The bridge will just detect MRP
  frames and it would forward them to the upper layer to allow to process it.
- update the logic to update non-MRP frames. If MRP is enabled, then look at
  the state of the port to decide to forward or not.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br.c         | 19 +++++++++++++++++++
 net/bridge/br_device.c  |  3 +++
 net/bridge/br_forward.c |  1 +
 net/bridge/br_if.c      | 10 ++++++++++
 net/bridge/br_input.c   | 22 ++++++++++++++++++++++
 net/bridge/br_private.h | 28 ++++++++++++++++++++++++++++
 6 files changed, 83 insertions(+)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index b6fe30e3768f..9053378ca1e4 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -94,6 +94,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 		spin_lock_bh(&br->lock);
 		if (br->dev->flags & IFF_UP) {
 			br_stp_disable_port(p);
+			br_mrp_port_link_change(p, false);
 			notified = true;
 		}
 		spin_unlock_bh(&br->lock);
@@ -103,6 +104,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 		if (netif_running(br->dev) && netif_oper_up(dev)) {
 			spin_lock_bh(&br->lock);
 			br_stp_enable_port(p);
+			br_mrp_port_link_change(p, true);
 			notified = true;
 			spin_unlock_bh(&br->lock);
 		}
@@ -308,6 +310,13 @@ static const struct stp_proto br_stp_proto = {
 	.rcv	= br_stp_rcv,
 };
 
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+static struct packet_type mrp_packet_type __read_mostly = {
+	.type = cpu_to_be16(ETH_P_MRP),
+	.func = br_mrp_recv,
+};
+#endif
+
 static int __init br_init(void)
 {
 	int err;
@@ -320,6 +329,13 @@ static int __init br_init(void)
 		return err;
 	}
 
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	/* Allow all MRP frames to be processed by the upper layer. The MRP
+	 * frames can be dropped or forward on other MRP ports
+	 */
+	dev_add_pack(&mrp_packet_type);
+#endif
+
 	err = br_fdb_init();
 	if (err)
 		goto err_out;
@@ -376,6 +392,9 @@ static int __init br_init(void)
 static void __exit br_deinit(void)
 {
 	stp_proto_unregister(&br_stp_proto);
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	dev_remove_pack(&mrp_packet_type);
+#endif
 	br_netlink_fini();
 	unregister_switchdev_notifier(&br_switchdev_notifier);
 	unregister_netdevice_notifier(&br_device_notifier);
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index fb38add21b37..29966754d86a 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -464,6 +464,9 @@ void br_dev_setup(struct net_device *dev)
 	spin_lock_init(&br->lock);
 	INIT_LIST_HEAD(&br->port_list);
 	INIT_HLIST_HEAD(&br->fdb_list);
+#ifdef CONFIG_BRIDGE_MRP
+	INIT_LIST_HEAD(&br->mrp_list);
+#endif
 	spin_lock_init(&br->hash_lock);
 
 	br->bridge_id.prio[0] = 0x80;
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 86637000f275..306425bc9899 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -27,6 +27,7 @@ static inline int should_deliver(const struct net_bridge_port *p,
 	return ((p->flags & BR_HAIRPIN_MODE) || skb->dev != p->dev) &&
 		br_allowed_egress(vg, skb) && p->state == BR_STATE_FORWARDING &&
 		nbp_switchdev_allowed_egress(p, skb) &&
+		br_mrp_allow_egress(p, skb) &&
 		!br_skb_isolated(p, skb);
 }
 
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 4fe30b182ee7..bf7a467b5f33 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -80,11 +80,13 @@ void br_port_carrier_check(struct net_bridge_port *p, bool *notified)
 			br_stp_enable_port(p);
 			*notified = true;
 		}
+		br_mrp_port_link_change(p, true);
 	} else {
 		if (p->state != BR_STATE_DISABLED) {
 			br_stp_disable_port(p);
 			*notified = true;
 		}
+		br_mrp_port_link_change(p, false);
 	}
 	spin_unlock_bh(&br->lock);
 }
@@ -331,6 +333,9 @@ static void del_nbp(struct net_bridge_port *p)
 
 	spin_lock_bh(&br->lock);
 	br_stp_disable_port(p);
+#ifdef CONFIG_BRIDGE_MRP
+	br_mrp_port_uninit(p);
+#endif
 	spin_unlock_bh(&br->lock);
 
 	br_ifinfo_notify(RTM_DELLINK, NULL, p);
@@ -373,6 +378,11 @@ void br_dev_delete(struct net_device *dev, struct list_head *head)
 		del_nbp(p);
 	}
 
+#ifdef CONFIG_BRIDGE_MRP
+	/* Remove MRP instance. This function will remove also the MRP ports */
+	br_mrp_uninit(br);
+#endif
+
 	br_recalculate_neigh_suppress_enabled(br);
 
 	br_fdb_delete_by_port(br, NULL, 0, 1);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 8944ceb47fe9..c65049586dbd 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -21,6 +21,9 @@
 #include <linux/rculist.h>
 #include "br_private.h"
 #include "br_private_tunnel.h"
+#ifdef CONFIG_BRIDGE_MRP
+#include "br_private_mrp.h"
+#endif
 
 static int
 br_netif_receive_skb(struct net *net, struct sock *sk, struct sk_buff *skb)
@@ -338,6 +341,25 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 			return RX_HANDLER_CONSUMED;
 		}
 	}
+#ifdef CONFIG_BRIDGE_MRP
+	/* If the port is part of the MRP ring and the state of the port is
+	 * disabled then all the frames must be dropped
+	 */
+	if (p->mrp_port && p->mrp_port->state == BR_MRP_PORT_STATE_DISABLED)
+		goto drop;
+
+	/* MRP frames need special processing, therefor allow the upper level
+	 * to decide what to do with the frame
+	 */
+	if (p->mrp_port && skb->protocol == ntohs(ETH_P_MRP))
+		return RX_HANDLER_PASS;
+
+	/* Frames received on a blocked port, shall be dropped, except
+	 * MRP frames and frames specified in IEEE 802.1D-2004 Table 7-10.
+	 */
+	if (p->mrp_port && p->mrp_port->state == BR_MRP_PORT_STATE_BLOCKED)
+		goto drop;
+#endif
 
 forward:
 	switch (p->state) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f540f3bdf294..0c008b3d24cc 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -285,6 +285,9 @@ struct net_bridge_port {
 	u16				backup_redirected_cnt;
 
 	struct bridge_stp_xstats	stp_xstats;
+#ifdef CONFIG_BRIDGE_MRP
+	struct br_mrp_port		*mrp_port;
+#endif
 };
 
 #define kobj_to_brport(obj)	container_of(obj, struct net_bridge_port, kobj)
@@ -424,6 +427,10 @@ struct net_bridge {
 	int offload_fwd_mark;
 #endif
 	struct hlist_head		fdb_list;
+
+#ifdef CONFIG_BRIDGE_MRP
+	struct list_head		mrp_list;
+#endif
 };
 
 struct br_input_skb_cb {
@@ -1160,6 +1167,27 @@ void br_stp_timer_init(struct net_bridge *br);
 void br_stp_port_timer_init(struct net_bridge_port *p);
 unsigned long br_timer_value(const struct timer_list *timer);
 
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+/* br_mrp.c */
+void br_mrp_uninit(struct net_bridge *br);
+void br_mrp_port_uninit(struct net_bridge_port *p);
+void br_mrp_port_link_change(struct net_bridge_port *br, bool up);
+int br_mrp_recv(struct sk_buff *skb, struct net_device *dev,
+		struct packet_type *pt, struct net_device *orig_dev);
+bool br_mrp_allow_egress(const struct net_bridge_port *p,
+			 const struct sk_buff *skb);
+#else
+static inline bool br_mrp_allow_egress(const struct net_bridge_port *p,
+				       const struct sk_buff *skb)
+{
+	return true;
+}
+
+static inline void br_mrp_port_link_change(struct net_bridge_port *br, bool up)
+{
+}
+#endif
+
 /* br.c */
 #if IS_ENABLED(CONFIG_ATM_LANE)
 extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr);
-- 
2.17.1

