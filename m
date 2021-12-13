Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B2D47291F
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242176AbhLMKSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:18:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39257 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240929AbhLMKPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:15:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639390522; x=1670926522;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/HkjVWPq1fJHYY0KDZj1tXRPQsrneOA3XW4Fxk0+VNg=;
  b=xJLjqeSAq4rP4hjiHe6g9XsISVewKBaE64AwyAOAbqqnFvxQbVQa80m5
   avjMmJ/qZdwchYQn5sW1HQZ8FT+SuusA3rCBRy4uRGxdtNHSbyUVFVdN2
   Y3C8MIOT2tqfgRahHWI5MHoH19deNTqdbB3h08icgtfq1H74OXwnT5Rtg
   hvRp1UBr1E050ggGYoYQoyz6kTZrMVLk2MXUuLFOYXQfHMRKajzr80RUK
   z4f93jr0RtN55Qz4ZfmefGiNrJR78Mcv+4JaaNbUTUSf1kKFBp7IzBPsT
   j8UitxutWzD24HS9bkxMNu7jhwl0b+Tw46c3rx1ssFBw7vXfYjSG3Wlqk
   w==;
IronPort-SDR: 5ckZZrfVuIDwDB2NPLSis/frYepcHg4OUPIRmE5isn6lNQkU/29HI4jdlQ93ZlbGXdmDBInyAB
 Mc2ZQMjbU5ABzNwpEe476TZ1dMMweFaqyik8p2HepxiSqCDGQ42Ajs+clie1fiFcN1tAXI5C4v
 jEN2/dRj/eD/j1ku2pmiE6UPDkILLWeATKTpbbGUq/4BfJgTLP8oNUbuNk2OYSEYdSM+4lmsAs
 y3s/Ns1oaZSPbJkTf/88eFNZPJJtEcuEpkMbaFSTn/pIK3qu8+qRdpg6AQutLE5Et90QkvNRtS
 IiMcPzWRdq2rbHljVeoRItD3
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="155251648"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 03:15:21 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 03:15:17 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 13 Dec 2021 03:15:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 08/10] net: lan966x: Extend switchdev with vlan support
Date:   Mon, 13 Dec 2021 11:14:30 +0100
Message-ID: <20211213101432.2668820-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
References: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the switchdev calls SWITCHDEV_OBJ_ID_PORT_VLAN and
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_switchdev.c     | 117 ++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 3f6d361ad65b..062b9fc80e7d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -72,6 +72,11 @@ static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
 		lan966x_port_ageing_set(port, attr->u.ageing_time);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		lan966x_vlan_port_set_vlan_aware(port, attr->u.vlan_filtering);
+		lan966x_vlan_port_apply(port);
+		lan966x_vlan_cpu_set_vlan_aware(port);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -343,6 +348,112 @@ static int lan966x_switchdev_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static int lan966x_handle_port_vlan_add(struct net_device *dev,
+					struct notifier_block *nb,
+					const struct switchdev_obj_port_vlan *v)
+{
+	struct lan966x_port *port;
+	struct lan966x *lan966x;
+
+	/* When adding a port to a vlan, we get a callback for the port but
+	 * also for the bridge. When get the callback for the bridge just bail
+	 * out. Then when the bridge is added to the vlan, then we get a
+	 * callback here but in this case the flags has set:
+	 * BRIDGE_VLAN_INFO_BRENTRY. In this case it means that the CPU
+	 * port is added to the vlan, so the broadcast frames and unicast frames
+	 * with dmac of the bridge should be foward to CPU.
+	 */
+	if (netif_is_bridge_master(dev) &&
+	    !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
+		return 0;
+
+	lan966x = container_of(nb, struct lan966x, switchdev_blocking_nb);
+
+	/* In case the port gets called */
+	if (!(netif_is_bridge_master(dev))) {
+		if (!lan966x_netdevice_check(dev))
+			return -EOPNOTSUPP;
+
+		port = netdev_priv(dev);
+		return lan966x_vlan_port_add_vlan(port, v->vid,
+						  v->flags & BRIDGE_VLAN_INFO_PVID,
+						  v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+	}
+
+	/* In case the bridge gets called */
+	if (netif_is_bridge_master(dev))
+		return lan966x_vlan_cpu_add_vlan(lan966x, dev, v->vid);
+
+	return 0;
+}
+
+static int lan966x_handle_port_obj_add(struct net_device *dev,
+				       struct notifier_block *nb,
+				       struct switchdev_notifier_port_obj_info *info)
+{
+	const struct switchdev_obj *obj = info->obj;
+	int err;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = lan966x_handle_port_vlan_add(dev, nb,
+						   SWITCHDEV_OBJ_PORT_VLAN(obj));
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
+static int lan966x_handle_port_vlan_del(struct net_device *dev,
+					struct notifier_block *nb,
+					const struct switchdev_obj_port_vlan *v)
+{
+	struct lan966x_port *port;
+	struct lan966x *lan966x;
+
+	lan966x = container_of(nb, struct lan966x, switchdev_blocking_nb);
+
+	/* In case the physical port gets called */
+	if (!netif_is_bridge_master(dev)) {
+		if (!lan966x_netdevice_check(dev))
+			return -EOPNOTSUPP;
+
+		port = netdev_priv(dev);
+		return lan966x_vlan_port_del_vlan(port, v->vid);
+	}
+
+	/* In case the bridge gets called */
+	if (netif_is_bridge_master(dev))
+		return lan966x_vlan_cpu_del_vlan(lan966x, dev, v->vid);
+
+	return 0;
+}
+
+static int lan966x_handle_port_obj_del(struct net_device *dev,
+				       struct notifier_block *nb,
+				       struct switchdev_notifier_port_obj_info *info)
+{
+	const struct switchdev_obj *obj = info->obj;
+	int err;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = lan966x_handle_port_vlan_del(dev, nb,
+						   SWITCHDEV_OBJ_PORT_VLAN(obj));
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
 static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
 					    unsigned long event,
 					    void *ptr)
@@ -351,6 +462,12 @@ static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
 	int err;
 
 	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = lan966x_handle_port_obj_add(dev, nb, ptr);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = lan966x_handle_port_obj_del(dev, nb, ptr);
+		return notifier_from_errno(err);
 	case SWITCHDEV_PORT_ATTR_SET:
 		err = switchdev_handle_port_attr_set(dev, ptr,
 						     lan966x_netdevice_check,
-- 
2.33.0

