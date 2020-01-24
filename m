Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE5148BE0
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 17:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389996AbgAXQT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 11:19:58 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:25661 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387730AbgAXQT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 11:19:57 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: VSPTccWq1rIi8LY78/CKRQ05upZrJVWLQTSfCVKiGQOOuUmSFvj1nl3obxhMrkAso2fIaY5lfG
 /+bn8jtvlxEV102fwNQ5Uud2z4sj76kFXmYsmFEaVUARmmKZtpSJqBX8lA93zE0KpeSqlfJhnW
 NEFWx4DmFqlo1LwxjnsIRYYt9Q67hE17eVo+hFLzA/L0ZkzaWFhIV4cRdQx5ed3ULffwE4/Aa1
 QVZglerGLqHwFqadV1FliDNL9aGK3egCTkkxKXkzwYZJW8AP7uQxlnVHccDk51N39EbeBqBPvV
 e2k=
X-IronPort-AV: E=Sophos;i="5.70,358,1574146800"; 
   d="scan'208";a="19442"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2020 09:19:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Jan 2020 09:19:56 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 24 Jan 2020 09:19:53 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v3 09/10] net: bridge: mrp: Integrate MRP into the bridge
Date:   Fri, 24 Jan 2020 17:18:27 +0100
Message-ID: <20200124161828.12206-10-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200124161828.12206-1-horatiu.vultur@microchip.com>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To integrate MRP into the bridge, the bridge needs to do the following:
- initialized and destroy the generic netlink used by MRP
- detect if the MRP frame was received on a port that is part of a MRP ring. In
  case it was not, then forward the frame as usual, otherwise redirect the frame
  to the upper layer.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br.c         | 11 +++++++++++
 net/bridge/br_device.c  |  3 +++
 net/bridge/br_if.c      |  6 ++++++
 net/bridge/br_input.c   | 14 ++++++++++++++
 net/bridge/br_private.h | 14 ++++++++++++++
 5 files changed, 48 insertions(+)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index b6fe30e3768f..d5e556eed4ba 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -344,6 +344,12 @@ static int __init br_init(void)
 	if (err)
 		goto err_out5;
 
+#ifdef CONFIG_BRIDGE_MRP
+	err = br_mrp_netlink_init();
+	if (err)
+		goto err_out6;
+#endif
+
 	brioctl_set(br_ioctl_deviceless_stub);
 
 #if IS_ENABLED(CONFIG_ATM_LANE)
@@ -358,6 +364,11 @@ static int __init br_init(void)
 
 	return 0;
 
+#ifdef CONFIG_BRIDGE_MRP
+err_out6:
+	br_netlink_fini();
+#endif
+
 err_out5:
 	unregister_switchdev_notifier(&br_switchdev_notifier);
 err_out4:
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
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 4fe30b182ee7..9b8bb41c0574 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -331,6 +331,9 @@ static void del_nbp(struct net_bridge_port *p)
 
 	spin_lock_bh(&br->lock);
 	br_stp_disable_port(p);
+#ifdef CONFIG_BRIDGE_MRP
+	p->mrp_aware = false;
+#endif
 	spin_unlock_bh(&br->lock);
 
 	br_ifinfo_notify(RTM_DELLINK, NULL, p);
@@ -427,6 +430,9 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
 	p->port_no = index;
 	p->flags = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
 	br_init_port(p);
+#ifdef CONFIG_BRIDGE_MRP
+	p->mrp_aware = false;
+#endif
 	br_set_state(p, BR_STATE_DISABLED);
 	br_stp_port_timer_init(p);
 	err = br_multicast_add_port(p);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 8944ceb47fe9..de7066b077e2 100644
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
@@ -338,6 +341,17 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 			return RX_HANDLER_CONSUMED;
 		}
 	}
+#ifdef CONFIG_BRIDGE_MRP
+	/* If there is no MRP instance do normal forwarding */
+	if (!p->mrp_aware)
+		goto forward;
+
+	if (skb->protocol == htons(ETH_P_MRP))
+		return RX_HANDLER_PASS;
+
+	if (p->state == BR_STATE_BLOCKING)
+		goto drop;
+#endif
 
 forward:
 	switch (p->state) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f540f3bdf294..a5d01a394f54 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -285,6 +285,10 @@ struct net_bridge_port {
 	u16				backup_redirected_cnt;
 
 	struct bridge_stp_xstats	stp_xstats;
+
+#ifdef CONFIG_BRIDGE_MRP
+	bool				mrp_aware;
+#endif
 };
 
 #define kobj_to_brport(obj)	container_of(obj, struct net_bridge_port, kobj)
@@ -424,6 +428,10 @@ struct net_bridge {
 	int offload_fwd_mark;
 #endif
 	struct hlist_head		fdb_list;
+
+#ifdef CONFIG_BRIDGE_MRP
+	struct list_head		mrp_list;
+#endif
 };
 
 struct br_input_skb_cb {
@@ -1165,6 +1173,12 @@ unsigned long br_timer_value(const struct timer_list *timer);
 extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr);
 #endif
 
+/* br_mrp.c */
+#ifdef CONFIG_BRIDGE_MRP
+int br_mrp_netlink_init(void);
+void br_mrp_netlink_uninit(void);
+#endif
+
 /* br_netlink.c */
 extern struct rtnl_link_ops br_link_ops;
 int br_netlink_init(void);
-- 
2.17.1

