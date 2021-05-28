Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4830D3942A0
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbhE1Mhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:37:33 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:15551 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236429AbhE1Mgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622205297; x=1653741297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Zx0Jbby+jCbraMWzga2f3MrXYzM+EC1VMAUUgs/qKM=;
  b=WbdFrRuLjs5flratnK0qbAq1nr4Zdjr/IOuKAORVTi94Xa5KY5rwMdaU
   mgPdu2oAIr0LGJDOFDfHRKFBkoR0TP2sMDLI7SSAifmyyMDtZZeT+Mljm
   /O6XMZRFJxSFyOP+MMkSpHV23vKawebYTQCV9eF8UOqSYPEH3pDKN/a3v
   IINznlEbt5PnHOe1Qo34tQwKFWSlpi2dlK5J3YhLfBq5DGOklzhSk0T4b
   os4Oy1altBZbpGxsPJQsaXGuX6qhy7auZ159ikIEZXFZ3MScbgNQdUxpk
   aWqYseoKwu+XTxyus5SZ5m5mWSbJnOzYnMog8mmAMgLkwBbpjlJEpJqMB
   g==;
IronPort-SDR: 4Dkoluc0N+KER0DEBUWJjI/wl0yoOkCiHezl5et5lAiDmZWISF92j9a3IUaX2S3dixxs6WFvSt
 XinABILfbs0RMZP1o586GOp1Yes6sEjSflCpp20UEOmPTc4NMLmKjO+t1+Ihik2ms3cNeWxjw+
 DvHF9joTgetfEPsEu4QQGfHjYmaAAV7jZLJi1MbN+jeR0ZmU8QfsiP1wfX0kCC06QVk8tsXdll
 DzPPX6YVHor5F37OP4slJr2CP8jswL89uMV/yPGHDdExCXeuu26y19XfmsrmZ7wcxDYX6tkw3F
 jSs=
X-IronPort-AV: E=Sophos;i="5.83,229,1616482800"; 
   d="scan'208";a="122757506"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 May 2021 05:34:57 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 05:34:54 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 28 May 2021 05:34:51 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v2 07/10] net: sparx5: add switching support
Date:   Fri, 28 May 2021 14:34:16 +0200
Message-ID: <20210528123419.1142290-8-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528123419.1142290-1-steen.hegelund@microchip.com>
References: <20210528123419.1142290-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds SwitchDev support by hardware offloading the
software bridge.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   3 +-
 .../microchip/sparx5/sparx5_mactable.c        |   3 +
 .../ethernet/microchip/sparx5/sparx5_main.c   |  13 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  11 +
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  10 +
 .../ethernet/microchip/sparx5/sparx5_packet.c |   6 +
 .../microchip/sparx5/sparx5_switchdev.c       | 508 ++++++++++++++++++
 7 files changed, 552 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index 81685c3f428e..d2788e8b7798 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -6,4 +6,5 @@
 obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
- sparx5_netdev.o sparx5_port.o sparx5_phylink.o sparx5_mactable.o sparx5_vlan.o
+ sparx5_netdev.o sparx5_port.o sparx5_phylink.o sparx5_mactable.o sparx5_vlan.o \
+ sparx5_switchdev.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index 6c5e04eccaa3..0443f66b5550 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -371,6 +371,9 @@ static void sparx5_mact_handle_entry(struct sparx5 *sparx5,
 	if (port >= SPX5_PORTS)
 		return;
 
+	if (!test_bit(port, sparx5->bridge_mask))
+		return;
+
 	mutex_lock(&sparx5->mact_lock);
 	list_for_each_entry(mact_entry, &sparx5->mact_entries, list) {
 		if (mact_entry->vid == vid &&
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index fb3618be8e5d..8121f0b1c0ea 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -633,6 +633,7 @@ static int sparx5_start(struct sparx5 *sparx5)
 		return err;
 
 	sparx5_board_init(sparx5);
+	err = sparx5_register_notifier_blocks(sparx5);
 
 	/* Start register based INJ/XTR */
 	err = -ENXIO;
@@ -652,7 +653,14 @@ static int sparx5_start(struct sparx5 *sparx5)
 
 static void sparx5_cleanup_ports(struct sparx5 *sparx5)
 {
-	/* Port cleanup to be added in later patches */
+	int idx;
+
+	for (idx = 0; idx < SPX5_PORTS; ++idx) {
+		struct sparx5_port *port = sparx5->ports[idx];
+
+		if (port && port->ndev)
+			sparx5_destroy_netdev(sparx5, port);
+	}
 }
 
 static int mchp_sparx5_probe(struct platform_device *pdev)
@@ -820,6 +828,9 @@ static int mchp_sparx5_remove(struct platform_device *pdev)
 		sparx5->xtr_irq = -ENXIO;
 	}
 	sparx5_cleanup_ports(sparx5);
+	/* Unregister netdevs */
+	sparx5_unregister_notifier_blocks(sparx5);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index d82700614abf..e427adad4555 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -133,9 +133,16 @@ struct sparx5 {
 	/* port structures are in net device */
 	struct sparx5_port *ports[SPX5_PORTS];
 	enum sparx5_core_clockfreq coreclock;
+	/* Notifiers */
+	struct notifier_block netdevice_nb;
+	struct notifier_block switchdev_nb;
+	struct notifier_block switchdev_blocking_nb;
 	/* Switch state */
 	u8 base_mac[ETH_ALEN];
+	/* Associated bridge device (when bridged) */
+	struct net_device *hw_bridge_dev;
 	/* Bridged interfaces */
+	DECLARE_BITMAP(bridge_mask, SPX5_PORTS);
 	DECLARE_BITMAP(bridge_fwd_mask, SPX5_PORTS);
 	DECLARE_BITMAP(bridge_lrn_mask, SPX5_PORTS);
 	DECLARE_BITMAP(vlan_mask[VLAN_N_VID], SPX5_PORTS);
@@ -151,6 +158,10 @@ struct sparx5 {
 	int xtr_irq;
 };
 
+/* sparx5_switchdev.c */
+int sparx5_register_notifier_blocks(struct sparx5 *sparx5);
+void sparx5_unregister_notifier_blocks(struct sparx5 *sparx5);
+
 /* sparx5_packet.c */
 irqreturn_t sparx5_xtr_handler(int irq, void *_priv);
 int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 73fb9efb5284..145f65dfde96 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -117,6 +117,15 @@ static int sparx5_port_stop(struct net_device *ndev)
 	return 0;
 }
 
+static void sparx5_set_rx_mode(struct net_device *dev)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	if (!test_bit(port->portno, sparx5->bridge_mask))
+		__dev_mc_sync(dev, sparx5_mc_sync, sparx5_mc_unsync);
+}
+
 static int sparx5_port_get_phys_port_name(struct net_device *dev,
 					  char *buf, size_t len)
 {
@@ -167,6 +176,7 @@ static const struct net_device_ops sparx5_port_netdev_ops = {
 	.ndo_open               = sparx5_port_open,
 	.ndo_stop               = sparx5_port_stop,
 	.ndo_start_xmit         = sparx5_port_xmit_impl,
+	.ndo_set_rx_mode        = sparx5_set_rx_mode,
 	.ndo_get_phys_port_name = sparx5_port_get_phys_port_name,
 	.ndo_set_mac_address    = sparx5_set_mac_address,
 	.ndo_validate_addr      = eth_validate_addr,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 2c4106a87fac..f3bca7fcb874 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -143,6 +143,12 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 	}
 #endif
 
+	/* Everything we see on an interface that is in the HW bridge
+	 * has already been forwarded
+	 */
+	if (test_bit(port->portno, sparx5->bridge_mask))
+		skb->offload_fwd_mark = 1;
+
 	/* Finish up skb */
 	skb_put(skb, byte_cnt - ETH_FCS_LEN);
 	eth_skb_pad(skb);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
new file mode 100644
index 000000000000..19c7cb795b4b
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -0,0 +1,508 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/if_bridge.h>
+#include <net/switchdev.h>
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+static struct workqueue_struct *sparx5_owq;
+
+struct sparx5_switchdev_event_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct net_device *dev;
+	unsigned long event;
+};
+
+static void sparx5_port_attr_bridge_flags(struct sparx5_port *port,
+					  struct switchdev_brport_flags flags)
+{
+	if (flags.mask & BR_MCAST_FLOOD)
+		sparx5_pgid_update_mask(port, PGID_MC_FLOOD, true);
+}
+
+static void sparx5_attr_stp_state_set(struct sparx5_port *port,
+				      u8 state)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	if (!test_bit(port->portno, sparx5->bridge_mask)) {
+		netdev_err(port->ndev,
+			   "Controlling non-bridged port %d?\n", port->portno);
+		return;
+	}
+
+	switch (state) {
+	case BR_STATE_FORWARDING:
+		set_bit(port->portno, sparx5->bridge_fwd_mask);
+		fallthrough;
+	case BR_STATE_LEARNING:
+		set_bit(port->portno, sparx5->bridge_lrn_mask);
+		break;
+
+	default:
+		/* All other states treated as blocking */
+		clear_bit(port->portno, sparx5->bridge_fwd_mask);
+		clear_bit(port->portno, sparx5->bridge_lrn_mask);
+		break;
+	}
+
+	/* apply the bridge_fwd_mask to all the ports */
+	sparx5_update_fwd(sparx5);
+}
+
+static void sparx5_port_attr_ageing_set(struct sparx5_port *port,
+					unsigned long ageing_clock_t)
+{
+	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
+	u32 ageing_time = jiffies_to_msecs(ageing_jiffies);
+
+	sparx5_set_ageing(port->sparx5, ageing_time);
+}
+
+static int sparx5_port_attr_set(struct net_device *dev,
+				const struct switchdev_attr *attr,
+				struct netlink_ext_ack *extack)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		sparx5_port_attr_bridge_flags(port, attr->u.brport_flags);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		sparx5_attr_stp_state_set(port, attr->u.stp_state);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		sparx5_port_attr_ageing_set(port, attr->u.ageing_time);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		port->vlan_aware = attr->u.vlan_filtering;
+		sparx5_vlan_port_apply(port->sparx5, port);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int sparx5_port_bridge_join(struct sparx5_port *port,
+				   struct net_device *bridge)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
+		/* First bridged port */
+		sparx5->hw_bridge_dev = bridge;
+	else
+		if (sparx5->hw_bridge_dev != bridge)
+			/* This is adding the port to a second bridge, this is
+			 * unsupported
+			 */
+			return -ENODEV;
+
+	set_bit(port->portno, sparx5->bridge_mask);
+
+	/* Port enters in bridge mode therefor don't need to copy to CPU
+	 * frames for multicast in case the bridge is not requesting them
+	 */
+	__dev_mc_unsync(port->ndev, sparx5_mc_unsync);
+
+	return 0;
+}
+
+static void sparx5_port_bridge_leave(struct sparx5_port *port,
+				     struct net_device *bridge)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	clear_bit(port->portno, sparx5->bridge_mask);
+	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
+		sparx5->hw_bridge_dev = NULL;
+
+	/* Clear bridge vlan settings before updating the port settings */
+	port->vlan_aware = 0;
+	port->pvid = NULL_VID;
+	port->vid = NULL_VID;
+
+	/* Port enters in host more therefore restore mc list */
+	__dev_mc_sync(port->ndev, sparx5_mc_sync, sparx5_mc_unsync);
+}
+
+static int sparx5_port_changeupper(struct net_device *dev,
+				   struct netdev_notifier_changeupper_info *info)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	int err = 0;
+
+	if (netif_is_bridge_master(info->upper_dev)) {
+		if (info->linking)
+			err = sparx5_port_bridge_join(port, info->upper_dev);
+		else
+			sparx5_port_bridge_leave(port, info->upper_dev);
+
+		sparx5_vlan_port_apply(port->sparx5, port);
+	}
+
+	return err;
+}
+
+static int sparx5_port_add_addr(struct net_device *dev, bool up)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+	u16 vid = port->pvid;
+
+	if (up)
+		sparx5_mact_learn(sparx5, PGID_CPU, port->ndev->dev_addr, vid);
+	else
+		sparx5_mact_forget(sparx5, port->ndev->dev_addr, vid);
+
+	return 0;
+}
+
+static int sparx5_netdevice_port_event(struct net_device *dev,
+				       struct notifier_block *nb,
+				       unsigned long event, void *ptr)
+{
+	int err = 0;
+
+	if (!sparx5_netdevice_check(dev))
+		return 0;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		err = sparx5_port_changeupper(dev, ptr);
+		break;
+	case NETDEV_PRE_UP:
+		err = sparx5_port_add_addr(dev, true);
+		break;
+	case NETDEV_DOWN:
+		err = sparx5_port_add_addr(dev, false);
+		break;
+	}
+
+	return err;
+}
+
+static int sparx5_netdevice_event(struct notifier_block *nb,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	int ret = 0;
+
+	ret = sparx5_netdevice_port_event(dev, nb, event, ptr);
+
+	return notifier_from_errno(ret);
+}
+
+static void sparx5_switchdev_bridge_fdb_event_work(struct work_struct *work)
+{
+	struct sparx5_switchdev_event_work *switchdev_work =
+		container_of(work, struct sparx5_switchdev_event_work, work);
+	struct net_device *dev = switchdev_work->dev;
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct sparx5_port *port;
+	struct sparx5 *sparx5;
+
+	rtnl_lock();
+	if (!sparx5_netdevice_check(dev))
+		goto out;
+
+	port = netdev_priv(dev);
+	sparx5 = port->sparx5;
+
+	fdb_info = &switchdev_work->fdb_info;
+
+	switch (switchdev_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		if (!fdb_info->added_by_user)
+			break;
+		sparx5_add_mact_entry(sparx5, port, fdb_info->addr,
+				      fdb_info->vid);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (!fdb_info->added_by_user)
+			break;
+		sparx5_del_mact_entry(sparx5, fdb_info->addr, fdb_info->vid);
+		break;
+	}
+
+out:
+	rtnl_unlock();
+	kfree(switchdev_work->fdb_info.addr);
+	kfree(switchdev_work);
+	dev_put(dev);
+}
+
+static void sparx5_schedule_work(struct work_struct *work)
+{
+	queue_work(sparx5_owq, work);
+}
+
+static int sparx5_switchdev_event(struct notifier_block *unused,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct sparx5_switchdev_event_work *switchdev_work;
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct switchdev_notifier_info *info = ptr;
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     sparx5_netdevice_check,
+						     sparx5_port_attr_set);
+		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		fallthrough;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+		if (!switchdev_work)
+			return NOTIFY_BAD;
+
+		switchdev_work->dev = dev;
+		switchdev_work->event = event;
+
+		fdb_info = container_of(info,
+					struct switchdev_notifier_fdb_info,
+					info);
+		INIT_WORK(&switchdev_work->work,
+			  sparx5_switchdev_bridge_fdb_event_work);
+		memcpy(&switchdev_work->fdb_info, ptr,
+		       sizeof(switchdev_work->fdb_info));
+		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+		if (!switchdev_work->fdb_info.addr)
+			goto err_addr_alloc;
+
+		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+				fdb_info->addr);
+		dev_hold(dev);
+
+		sparx5_schedule_work(&switchdev_work->work);
+		break;
+	}
+
+	return NOTIFY_DONE;
+err_addr_alloc:
+	kfree(switchdev_work);
+	return NOTIFY_BAD;
+}
+
+static void sparx5_sync_port_dev_addr(struct sparx5 *sparx5,
+				      struct sparx5_port *port,
+				      u16 vid, bool add)
+{
+	if (!port ||
+	    !test_bit(port->portno, sparx5->bridge_mask))
+		return; /* Skip null/host interfaces */
+
+	/* Bridge connects to vid? */
+	if (add) {
+		/* Add port MAC address from the VLAN */
+		sparx5_mact_learn(sparx5, PGID_CPU,
+				  port->ndev->dev_addr, vid);
+	} else {
+		/* Control port addr visibility depending on
+		 * port VLAN connectivity.
+		 */
+		if (test_bit(port->portno, sparx5->vlan_mask[vid]))
+			sparx5_mact_learn(sparx5, PGID_CPU,
+					  port->ndev->dev_addr, vid);
+		else
+			sparx5_mact_forget(sparx5,
+					   port->ndev->dev_addr, vid);
+	}
+}
+
+static void sparx5_sync_bridge_dev_addr(struct net_device *dev,
+					struct sparx5 *sparx5,
+					u16 vid, bool add)
+{
+	int i;
+
+	/* First, handle bridge address'es */
+	if (add) {
+		sparx5_mact_learn(sparx5, PGID_CPU, dev->dev_addr,
+				  vid);
+		sparx5_mact_learn(sparx5, PGID_BCAST, dev->broadcast,
+				  vid);
+	} else {
+		sparx5_mact_forget(sparx5, dev->dev_addr, vid);
+		sparx5_mact_forget(sparx5, dev->broadcast, vid);
+	}
+
+	/* Now look at bridged ports */
+	for (i = 0; i < SPX5_PORTS; i++)
+		sparx5_sync_port_dev_addr(sparx5, sparx5->ports[i], vid, add);
+}
+
+static int sparx5_handle_port_vlan_add(struct net_device *dev,
+				       struct notifier_block *nb,
+				       const struct switchdev_obj_port_vlan *v)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+
+	if (netif_is_bridge_master(dev)) {
+		if (v->flags & BRIDGE_VLAN_INFO_BRENTRY) {
+			struct sparx5 *sparx5 =
+				container_of(nb, struct sparx5,
+					     switchdev_blocking_nb);
+
+			sparx5_sync_bridge_dev_addr(dev, sparx5, v->vid, true);
+		}
+		return 0;
+	}
+
+	if (!sparx5_netdevice_check(dev))
+		return -EOPNOTSUPP;
+
+	return sparx5_vlan_vid_add(port, v->vid,
+				  v->flags & BRIDGE_VLAN_INFO_PVID,
+				  v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+}
+
+static int sparx5_handle_port_obj_add(struct net_device *dev,
+				      struct notifier_block *nb,
+				      struct switchdev_notifier_port_obj_info *info)
+{
+	const struct switchdev_obj *obj = info->obj;
+	int err;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = sparx5_handle_port_vlan_add(dev, nb,
+						  SWITCHDEV_OBJ_PORT_VLAN(obj));
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	info->handled = true;
+	return err;
+}
+
+static int sparx5_handle_port_vlan_del(struct net_device *dev,
+				       struct notifier_block *nb,
+				       u16 vid)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	int ret;
+
+	/* Master bridge? */
+	if (netif_is_bridge_master(dev)) {
+		struct sparx5 *sparx5 =
+			container_of(nb, struct sparx5,
+				     switchdev_blocking_nb);
+
+		sparx5_sync_bridge_dev_addr(dev, sparx5, vid, false);
+		return 0;
+	}
+
+	if (!sparx5_netdevice_check(dev))
+		return -EOPNOTSUPP;
+
+	ret = sparx5_vlan_vid_del(port, vid);
+	if (ret)
+		return ret;
+
+	/* Delete the port MAC address with the matching VLAN information */
+	sparx5_mact_forget(port->sparx5, port->ndev->dev_addr, vid);
+
+	return 0;
+}
+
+static int sparx5_handle_port_obj_del(struct net_device *dev,
+				      struct notifier_block *nb,
+				      struct switchdev_notifier_port_obj_info *info)
+{
+	const struct switchdev_obj *obj = info->obj;
+	int err;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = sparx5_handle_port_vlan_del(dev, nb,
+						  SWITCHDEV_OBJ_PORT_VLAN(obj)->vid);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	info->handled = true;
+	return err;
+}
+
+static int sparx5_switchdev_blocking_event(struct notifier_block *nb,
+					   unsigned long event,
+					   void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = sparx5_handle_port_obj_add(dev, nb, ptr);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = sparx5_handle_port_obj_del(dev, nb, ptr);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     sparx5_netdevice_check,
+						     sparx5_port_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	return NOTIFY_DONE;
+}
+
+int sparx5_register_notifier_blocks(struct sparx5 *s5)
+{
+	int err;
+
+	s5->netdevice_nb.notifier_call = sparx5_netdevice_event;
+	err = register_netdevice_notifier(&s5->netdevice_nb);
+	if (err)
+		return err;
+
+	s5->switchdev_nb.notifier_call = sparx5_switchdev_event;
+	err = register_switchdev_notifier(&s5->switchdev_nb);
+	if (err)
+		goto err_switchdev_nb;
+
+	s5->switchdev_blocking_nb.notifier_call = sparx5_switchdev_blocking_event;
+	err = register_switchdev_blocking_notifier(&s5->switchdev_blocking_nb);
+	if (err)
+		goto err_switchdev_blocking_nb;
+
+	sparx5_owq = alloc_ordered_workqueue("sparx5_order", 0);
+	if (!sparx5_owq)
+		goto err_switchdev_blocking_nb;
+
+	return 0;
+
+err_switchdev_blocking_nb:
+	unregister_switchdev_notifier(&s5->switchdev_nb);
+err_switchdev_nb:
+	unregister_netdevice_notifier(&s5->netdevice_nb);
+
+	return err;
+}
+
+void sparx5_unregister_notifier_blocks(struct sparx5 *s5)
+{
+	destroy_workqueue(sparx5_owq);
+
+	unregister_switchdev_blocking_notifier(&s5->switchdev_blocking_nb);
+	unregister_switchdev_notifier(&s5->switchdev_nb);
+	unregister_netdevice_notifier(&s5->netdevice_nb);
+}
-- 
2.31.1

