Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C96013A7E
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfEDN7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:59:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35866 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfEDN7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:59:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id a10so1546420wme.1
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SBBTnnBuL8kKQlDekVzJmVKPErfeIIHUK+7d67VDqW8=;
        b=nWuEazsotyxrcc+kgaWfqxo9w4jVPCa7AoHgFMfo14qmUPHvmHmyT7AcJDKokEASD3
         7kPEuERfqIYuxJJrATVq2kYF/W+5c1ijmdcKg/K9hB4km3J0jwZD9pZLZEFnZAmTKDEc
         Hks2VdbFY02xxUfLuyq8GsYA61+lPA/1tjEfh+uRN1kGFnv5AG/2qvGsAehc6qTbtBIg
         xSWwfN/BdMJNmSO+7vIBJ443cO6c5uogVhNmUsjo2HbeJRSqkwyCFKvm1oYmwYEd5i0X
         9LM3EcAyyHae5EmLH7c+DpNqp4k9QQkyKd1Gs+IDWnSTuPb/QJNMfnv4cwGoQRlgXvjR
         vQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SBBTnnBuL8kKQlDekVzJmVKPErfeIIHUK+7d67VDqW8=;
        b=n1p9ylY77hqg8SnKdCuFvHqpu7P4lzJs2CFrHWP+FD7jSUmkDCOwfcJaQWiNpvgTg6
         NUs3E4Hz9tJboLrKPChxdHXXLydbTnAvg6/psKhTSTmLh2i1MRjliL37mDLZgz/BkGj7
         7xrsxI0otVHHzLnTgzOw5Ipqpr5MxaWb976znBcOrfNh8jBPoDc2tbOrsVmFZMNdjHbC
         l9/teAYORY4EoqTpTS4PhWI+D5b98ZGkUDi194Qd42BDWF6xrX80HWXpg+Og+aW0p5sq
         G3gogrxk+Q3Mo9SVTvZxKw6tq2SbRNa1XWfTMRH+86Chw1IZHdypvSFN1+wCnwG/jjI+
         5jOA==
X-Gm-Message-State: APjAAAXpK2iFox+xzSfDesnJnU5RkAXogUzVIdZR1s7j0jm/GMVS1pYS
        Jke/Ry7gdkIT2xQhW9rrflo=
X-Google-Smtp-Source: APXvYqwtmwo1qvbeNe8xP4zOzYpTGTJxM3/u7Tdkr6jvG/DLVyjqw0ugxH8AueCVeVJ3S7ImmBqVuA==
X-Received: by 2002:a7b:ca42:: with SMTP id m2mr10170194wml.35.1556978386768;
        Sat, 04 May 2019 06:59:46 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s16sm5085940wrg.71.2019.05.04.06.59.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:59:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 2/9] net: dsa: Optional VLAN-based port separation for switches without tagging
Date:   Sat,  4 May 2019 16:59:12 +0300
Message-Id: <20190504135919.23185-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504135919.23185-1-olteanv@gmail.com>
References: <20190504135919.23185-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides generic DSA code for using VLAN (802.1Q) tags for
the same purpose as a dedicated switch tag for injection/extraction.
It is based on the discussions and interest that has been so far
expressed in https://www.spinics.net/lists/netdev/msg556125.html.

Unlike all other DSA-supported tagging protocols, CONFIG_NET_DSA_TAG_8021Q
does not offer a complete solution for drivers (nor can it). Instead, it
provides generic code that driver can opt into calling:
- dsa_8021q_xmit: Inserts a VLAN header with the specified contents.
  Can be called from another tagging protocol's xmit function.
  Currently the LAN9303 driver is inserting headers that are simply
  802.1Q with custom fields, so this is an opportunity for code reuse.
- dsa_8021q_rcv: Retrieves the TPID and TCI from a VLAN-tagged skb.
  Removing the VLAN header is left as a decision for the caller to make.
- dsa_port_setup_8021q_tagging: For each user port, installs an Rx VID
  and a Tx VID, for proper untagged traffic identification on ingress
  and steering on egress. Also sets up the VLAN trunk on the upstream
  (CPU or DSA) port. Drivers are intentionally left to call this
  function explicitly, depending on the context and hardware support.
  The expected switch behavior and VLAN semantics should not be violated
  under any conditions. That is, after calling
  dsa_port_setup_8021q_tagging, the hardware should still pass all
  ingress traffic, be it tagged or untagged.

For uniformity with the other tagging protocols, a module for the
dsa_8021q_netdev_ops structure is registered, but the typical usage is
to set up another tagging protocol which selects CONFIG_NET_DSA_TAG_8021Q,
and calls the API from tag_8021q.h. Null function definitions are also
provided so that a "depends on" is not forced in the Kconfig.

This tagging protocol only works when switch ports are standalone, or
when they are added to a VLAN-unaware bridge. It will probably remain
this way for the reasons below.

When added to a bridge that has vlan_filtering 1, the bridge core will
install its own VLANs and reset the pvids through switchdev. For the
bridge core, switchdev is a write-only pipe. All VLAN-related state is
kept in the bridge core and nothing is read from DSA/switchdev or from
the driver. So the bridge core will break this port separation because
it will install the vlan_default_pvid into all switchdev ports.

Even if we could teach the bridge driver about switchdev preference of a
certain vlan_default_pvid (task difficult in itself since the current
setting is per-bridge but we would need it per-port), there would still
exist many other challenges.

Firstly, in the DSA rcv callback, a driver would have to perform an
iterative reverse lookup to find the correct switch port. That is
because the port is a bridge slave, so its Rx VID (port PVID) is subject
to user configuration. How would we ensure that the user doesn't reset
the pvid to a different value (which would make an O(1) translation
impossible), or to a non-unique value within this DSA switch tree (which
would make any translation impossible)?

Finally, not all switch ports are equal in DSA, and that makes it
difficult for the bridge to be completely aware of this anyway.
The CPU port needs to transmit tagged packets (VLAN trunk) in order for
the DSA rcv code to be able to decode source information.
But the bridge code has absolutely no idea which switch port is the CPU
port, if nothing else then just because there is no netdevice registered
by DSA for the CPU port.
Also DSA does not currently allow the user to specify that they want the
CPU port to do VLAN trunking anyway. VLANs are added to the CPU port
using the same flags as they were added on the user port.

So the VLANs installed by dsa_port_setup_8021q_tagging per driver
request should remain private from the bridge's and user's perspective,
and should not alter the VLAN semantics observed by the user.

In the current implementation a VLAN range ending at 4095 (VLAN_N_VID)
is reserved for this purpose. Each port receives a unique Rx VLAN and a
unique Tx VLAN. Separate VLANs are needed for Rx and Tx because they
serve different purposes: on Rx the switch must process traffic as
untagged and process it with a port-based VLAN, but with care not to
hinder bridging. On the other hand, the Tx VLAN is where the
reachability restrictions are imposed, since by tagging frames in the
xmit callback we are telling the switch onto which port to steer the
frame.

Some general guidance on how this support might be employed for
real-life hardware (some comments made by Florian Fainelli):

- If the hardware supports VLAN tag stacking, it should somehow back
  up its private VLAN settings when the bridge tries to override them.
  Then the driver could re-apply them as outer tags. Dedicating an outer
  tag per bridge device would allow identical inner tag VID numbers to
  co-exist, yet preserve broadcast domain isolation.

- If the switch cannot handle VLAN tag stacking, it should disable this
  port separation when added as slave to a vlan_filtering bridge, in
  that case having reduced functionality.

- Drivers for old switches that don't support the entire VLAN_N_VID
  range will need to rework the current range selection mechanism.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
  - None.

 include/linux/dsa/8021q.h |  76 +++++++++++++
 include/net/dsa.h         |   2 +
 net/dsa/Kconfig           |  11 ++
 net/dsa/Makefile          |   1 +
 net/dsa/tag_8021q.c       | 222 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 312 insertions(+)
 create mode 100644 include/linux/dsa/8021q.h
 create mode 100644 net/dsa/tag_8021q.c

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
new file mode 100644
index 000000000000..3911e0586478
--- /dev/null
+++ b/include/linux/dsa/8021q.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+
+#ifndef _NET_DSA_8021Q_H
+#define _NET_DSA_8021Q_H
+
+#include <linux/types.h>
+
+struct dsa_switch;
+struct sk_buff;
+struct net_device;
+struct packet_type;
+
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q)
+
+int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
+				 bool enabled);
+
+struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
+			       u16 tpid, u16 tci);
+
+struct sk_buff *dsa_8021q_rcv(struct sk_buff *skb, struct net_device *netdev,
+			      struct packet_type *pt, u16 *tpid, u16 *tci);
+
+u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
+
+u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
+
+int dsa_8021q_rx_switch_id(u16 vid);
+
+int dsa_8021q_rx_source_port(u16 vid);
+
+#else
+
+int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
+				 bool enabled)
+{
+	return 0;
+}
+
+struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
+			       u16 tpid, u16 tci)
+{
+	return NULL;
+}
+
+struct sk_buff *dsa_8021q_rcv(struct sk_buff *skb, struct net_device *netdev,
+			      struct packet_type *pt, u16 *tpid, u16 *tci)
+{
+	return NULL;
+}
+
+u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port)
+{
+	return 0;
+}
+
+u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
+{
+	return 0;
+}
+
+int dsa_8021q_rx_switch_id(u16 vid)
+{
+	return 0;
+}
+
+int dsa_8021q_rx_source_port(u16 vid)
+{
+	return 0;
+}
+
+#endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q) */
+
+#endif /* _NET_DSA_8021Q_H */
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 18db7b8e7a8e..69f3714f42ba 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -42,6 +42,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_MTK_VALUE			9
 #define DSA_TAG_PROTO_QCA_VALUE			10
 #define DSA_TAG_PROTO_TRAILER_VALUE		11
+#define DSA_TAG_PROTO_8021Q_VALUE		12
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -56,6 +57,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_MTK		= DSA_TAG_PROTO_MTK_VALUE,
 	DSA_TAG_PROTO_QCA		= DSA_TAG_PROTO_QCA_VALUE,
 	DSA_TAG_PROTO_TRAILER		= DSA_TAG_PROTO_TRAILER_VALUE,
+	DSA_TAG_PROTO_8021Q		= DSA_TAG_PROTO_8021Q_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index c0734028c7dc..fc15a7e1a6df 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -17,6 +17,17 @@ menuconfig NET_DSA
 
 if NET_DSA
 
+# tagging formats
+config NET_DSA_TAG_8021Q
+	tristate "Tag driver for switches using custom 802.1Q VLAN headers"
+	select VLAN_8021Q
+	help
+	  Unlike the other tagging protocols, the 802.1Q config option simply
+	  provides helpers for other tagging implementations that might rely on
+	  VLAN in one way or another. It is not a complete solution.
+
+	  Drivers which use these helpers should select this as dependency.
+
 config NET_DSA_TAG_BRCM_COMMON
 	tristate
 	default n
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 8a737b6ee94c..e97c794ec57b 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_NET_DSA) += dsa_core.o
 dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o
 
 # tagging formats
+obj-$(CONFIG_NET_DSA_TAG_8021Q) += tag_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
 obj-$(CONFIG_NET_DSA_TAG_DSA) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_EDSA) += tag_edsa.o
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
new file mode 100644
index 000000000000..8ae48c7e1e76
--- /dev/null
+++ b/net/dsa/tag_8021q.c
@@ -0,0 +1,222 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+ *
+ * This module is not a complete tagger implementation. It only provides
+ * primitives for taggers that rely on 802.1Q VLAN tags to use. The
+ * dsa_8021q_netdev_ops is registered for API compliance and not used
+ * directly by callers.
+ */
+#include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
+
+#include "dsa_priv.h"
+
+/* Allocating two VLAN tags per port - one for the RX VID and
+ * the other for the TX VID - see below
+ */
+#define DSA_8021Q_VID_RANGE	(DSA_MAX_SWITCHES * DSA_MAX_PORTS)
+#define DSA_8021Q_VID_BASE	(VLAN_N_VID - 2 * DSA_8021Q_VID_RANGE - 1)
+#define DSA_8021Q_RX_VID_BASE	(DSA_8021Q_VID_BASE)
+#define DSA_8021Q_TX_VID_BASE	(DSA_8021Q_VID_BASE + DSA_8021Q_VID_RANGE)
+
+/* Returns the VID to be inserted into the frame from xmit for switch steering
+ * instructions on egress. Encodes switch ID and port ID.
+ */
+u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port)
+{
+	return DSA_8021Q_TX_VID_BASE + (DSA_MAX_PORTS * ds->index) + port;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_tx_vid);
+
+/* Returns the VID that will be installed as pvid for this switch port, sent as
+ * tagged egress towards the CPU port and decoded by the rcv function.
+ */
+u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
+{
+	return DSA_8021Q_RX_VID_BASE + (DSA_MAX_PORTS * ds->index) + port;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid);
+
+/* Returns the decoded switch ID from the RX VID. */
+int dsa_8021q_rx_switch_id(u16 vid)
+{
+	return ((vid - DSA_8021Q_RX_VID_BASE) / DSA_MAX_PORTS);
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_rx_switch_id);
+
+/* Returns the decoded port ID from the RX VID. */
+int dsa_8021q_rx_source_port(u16 vid)
+{
+	return ((vid - DSA_8021Q_RX_VID_BASE) % DSA_MAX_PORTS);
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
+
+/* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
+ * front-panel switch port (here swp0).
+ *
+ * Port identification through VLAN (802.1Q) tags has different requirements
+ * for it to work effectively:
+ *  - On RX (ingress from network): each front-panel port must have a pvid
+ *    that uniquely identifies it, and the egress of this pvid must be tagged
+ *    towards the CPU port, so that software can recover the source port based
+ *    on the VID in the frame. But this would only work for standalone ports;
+ *    if bridged, this VLAN setup would break autonomous forwarding and would
+ *    force all switched traffic to pass through the CPU. So we must also make
+ *    the other front-panel ports members of this VID we're adding, albeit
+ *    we're not making it their PVID (they'll still have their own).
+ *    By the way - just because we're installing the same VID in multiple
+ *    switch ports doesn't mean that they'll start to talk to one another, even
+ *    while not bridged: the final forwarding decision is still an AND between
+ *    the L2 forwarding information (which is limiting forwarding in this case)
+ *    and the VLAN-based restrictions (of which there are none in this case,
+ *    since all ports are members).
+ *  - On TX (ingress from CPU and towards network) we are faced with a problem.
+ *    If we were to tag traffic (from within DSA) with the port's pvid, all
+ *    would be well, assuming the switch ports were standalone. Frames would
+ *    have no choice but to be directed towards the correct front-panel port.
+ *    But because we also want the RX VLAN to not break bridging, then
+ *    inevitably that means that we have to give them a choice (of what
+ *    front-panel port to go out on), and therefore we cannot steer traffic
+ *    based on the RX VID. So what we do is simply install one more VID on the
+ *    front-panel and CPU ports, and profit off of the fact that steering will
+ *    work just by virtue of the fact that there is only one other port that's
+ *    a member of the VID we're tagging the traffic with - the desired one.
+ *
+ * So at the end, each front-panel port will have one RX VID (also the PVID),
+ * the RX VID of all other front-panel ports, and one TX VID. Whereas the CPU
+ * port will have the RX and TX VIDs of all front-panel ports, and on top of
+ * that, is also tagged-input and tagged-output (VLAN trunk).
+ *
+ *               CPU port                               CPU port
+ * +-------------+-----+-------------+    +-------------+-----+-------------+
+ * |  RX VID     |     |             |    |  TX VID     |     |             |
+ * |  of swp0    |     |             |    |  of swp0    |     |             |
+ * |             +-----+             |    |             +-----+             |
+ * |                ^ T              |    |                | Tagged         |
+ * |                |                |    |                | ingress        |
+ * |    +-------+---+---+-------+    |    |    +-----------+                |
+ * |    |       |       |       |    |    |    | Untagged                   |
+ * |    |     U v     U v     U v    |    |    v egress                     |
+ * | +-----+ +-----+ +-----+ +-----+ |    | +-----+ +-----+ +-----+ +-----+ |
+ * | |     | |     | |     | |     | |    | |     | |     | |     | |     | |
+ * | |PVID | |     | |     | |     | |    | |     | |     | |     | |     | |
+ * +-+-----+-+-----+-+-----+-+-----+-+    +-+-----+-+-----+-+-----+-+-----+-+
+ *   swp0    swp1    swp2    swp3           swp0    swp1    swp2    swp3
+ */
+int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
+{
+	int upstream = dsa_upstream_port(ds, port);
+	struct dsa_port *dp = &ds->ports[port];
+	struct dsa_port *upstream_dp = &ds->ports[upstream];
+	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	int i, err;
+
+	/* The CPU port is implicitly configured by
+	 * configuring the front-panel ports
+	 */
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
+	/* Add this user port's RX VID to the membership list of all others
+	 * (including itself). This is so that bridging will not be hindered.
+	 * L2 forwarding rules still take precedence when there are no VLAN
+	 * restrictions, so there are no concerns about leaking traffic.
+	 */
+	for (i = 0; i < ds->num_ports; i++) {
+		struct dsa_port *other_dp = &ds->ports[i];
+		u16 flags;
+
+		if (i == upstream)
+			/* CPU port needs to see this port's RX VID
+			 * as tagged egress.
+			 */
+			flags = 0;
+		else if (i == port)
+			/* The RX VID is pvid on this port */
+			flags = BRIDGE_VLAN_INFO_UNTAGGED |
+				BRIDGE_VLAN_INFO_PVID;
+		else
+			/* The RX VID is a regular VLAN on all others */
+			flags = BRIDGE_VLAN_INFO_UNTAGGED;
+
+		if (enabled)
+			err = dsa_port_vid_add(other_dp, rx_vid, flags);
+		else
+			err = dsa_port_vid_del(other_dp, rx_vid);
+		if (err) {
+			dev_err(ds->dev, "Failed to apply RX VID %d to port %d: %d\n",
+				rx_vid, port, err);
+			return err;
+		}
+	}
+	/* Finally apply the TX VID on this port and on the CPU port */
+	if (enabled)
+		err = dsa_port_vid_add(dp, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED);
+	else
+		err = dsa_port_vid_del(dp, tx_vid);
+	if (err) {
+		dev_err(ds->dev, "Failed to apply TX VID %d on port %d: %d\n",
+			tx_vid, port, err);
+		return err;
+	}
+	if (enabled)
+		err = dsa_port_vid_add(upstream_dp, tx_vid, 0);
+	else
+		err = dsa_port_vid_del(upstream_dp, tx_vid);
+	if (err) {
+		dev_err(ds->dev, "Failed to apply TX VID %d on port %d: %d\n",
+			tx_vid, upstream, err);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
+
+struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
+			       u16 tpid, u16 tci)
+{
+	/* skb->data points at skb_mac_header, which
+	 * is fine for vlan_insert_tag.
+	 */
+	return vlan_insert_tag(skb, htons(tpid), tci);
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_xmit);
+
+struct sk_buff *dsa_8021q_rcv(struct sk_buff *skb, struct net_device *netdev,
+			      struct packet_type *pt, u16 *tpid, u16 *tci)
+{
+	struct vlan_ethhdr *tag;
+
+	if (unlikely(!pskb_may_pull(skb, VLAN_HLEN)))
+		return NULL;
+
+	tag = vlan_eth_hdr(skb);
+	*tpid = ntohs(tag->h_vlan_proto);
+	*tci = ntohs(tag->h_vlan_TCI);
+
+	/* skb->data points in the middle of the VLAN tag,
+	 * after tpid and before tci. This is because so far,
+	 * ETH_HLEN (DMAC, SMAC, EtherType) bytes were pulled.
+	 * There are 2 bytes of VLAN tag left in skb->data, and upper
+	 * layers expect the 'real' EtherType to be consumed as well.
+	 * Coincidentally, a VLAN header is also of the same size as
+	 * the number of bytes that need to be pulled.
+	 */
+	skb_pull_rcsum(skb, VLAN_HLEN);
+
+	return skb;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_rcv);
+
+static const struct dsa_device_ops dsa_8021q_netdev_ops = {
+	.name		= "8021q",
+	.proto		= DSA_TAG_PROTO_8021Q,
+	.overhead	= VLAN_HLEN,
+};
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_8021Q);
+
+module_dsa_tag_driver(dsa_8021q_netdev_ops);
-- 
2.17.1

