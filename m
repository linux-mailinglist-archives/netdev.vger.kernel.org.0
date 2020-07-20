Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A33226C96
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbgGTQ6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:58:15 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42102 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729534AbgGTQ6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:58:11 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06KGw58x038594;
        Mon, 20 Jul 2020 11:58:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595264285;
        bh=LP23S45iwxQ40tzcicniReYqoZyurYXPuOrpIU8+gsE=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=nLp4YaHQ1bMce2MAY2JslXbF24PHYEP0qehhKj2JvTg74/Iha95IZ2lz+m8KARcjP
         JhVE3oKEC+ri11vnTI1rvIVNomuI3CoJXCN7bcnDPrvhFXpGZFpXRPgd2Ga34Eh1Zq
         NHHBmKXvUzxC5P+nshpEtcc5xvKvUne6R6n8WGTM=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06KGw5ec118391;
        Mon, 20 Jul 2020 11:58:05 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 20
 Jul 2020 11:58:04 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 20 Jul 2020 11:58:04 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06KGw3B4041101;
        Mon, 20 Jul 2020 11:58:04 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next v4 PATCH 1/7] hsr: enhance netlink socket interface to support PRP
Date:   Mon, 20 Jul 2020 12:57:57 -0400
Message-ID: <20200720165803.17793-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200720165803.17793-1-m-karicheri2@ti.com>
References: <20200720165803.17793-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parallel Redundancy Protocol (PRP) is another redundancy protocol
introduced by IEC 63439 standard. It is similar to HSR in many
aspects:-

 - Use a pair of Ethernet interfaces to created the PRP device
 - Use a 6 byte redundancy protocol part (RCT, Redundancy Check
   Trailer) similar to HSR Tag.
 - Has Link Redundancy Entity (LRE) that works with RCT to implement
   redundancy.

Key difference is that the protocol unit is a trailer instead of a
prefix as in HSR. That makes it inter-operable with tradition network
components such as bridges/switches which treat it as pad bytes,
whereas HSR nodes requires some kind of translators (Called redbox) to
talk to regular network devices. This features allows regular linux box
to be converted to a DAN-P box. DAN-P stands for Dual Attached Node - PRP
similar to DAN-H (Dual Attached Node - HSR).

Add a comment at the header/source code to explicitly state that the
driver files also handles PRP protocol as well.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 include/uapi/linux/hsr_netlink.h |  2 +-
 include/uapi/linux/if_link.h     | 12 +++++++++-
 net/hsr/Kconfig                  | 37 ++++++++++++++++++++-----------
 net/hsr/hsr_debugfs.c            |  2 +-
 net/hsr/hsr_device.c             |  7 ++++--
 net/hsr/hsr_device.h             |  2 ++
 net/hsr/hsr_forward.c            |  2 ++
 net/hsr/hsr_forward.h            |  2 ++
 net/hsr/hsr_framereg.c           |  1 +
 net/hsr/hsr_framereg.h           |  2 ++
 net/hsr/hsr_main.c               |  2 ++
 net/hsr/hsr_main.h               | 11 ++++++++-
 net/hsr/hsr_netlink.c            | 38 ++++++++++++++++++++++++++------
 net/hsr/hsr_netlink.h            |  2 ++
 net/hsr/hsr_slave.c              |  2 ++
 net/hsr/hsr_slave.h              |  2 ++
 16 files changed, 100 insertions(+), 26 deletions(-)

diff --git a/include/uapi/linux/hsr_netlink.h b/include/uapi/linux/hsr_netlink.h
index c218ef9c35dd..d540ea9bbef4 100644
--- a/include/uapi/linux/hsr_netlink.h
+++ b/include/uapi/linux/hsr_netlink.h
@@ -17,7 +17,7 @@
 /* Generic Netlink HSR family definition
  */
 
-/* attributes */
+/* attributes for HSR or PRP node */
 enum {
 	HSR_A_UNSPEC,
 	HSR_A_NODE_ADDR,
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 26842ffd0501..2ead061e3fc2 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -908,7 +908,14 @@ enum {
 #define IFLA_IPOIB_MAX (__IFLA_IPOIB_MAX - 1)
 
 
-/* HSR section */
+/* HSR/PRP section, both uses same interface */
+
+/* Different redundancy protocols for hsr device */
+enum {
+	HSR_PROTOCOL_HSR,
+	HSR_PROTOCOL_PRP,
+	HSR_PROTOCOL_MAX,
+};
 
 enum {
 	IFLA_HSR_UNSPEC,
@@ -918,6 +925,9 @@ enum {
 	IFLA_HSR_SUPERVISION_ADDR,	/* Supervision frame multicast addr */
 	IFLA_HSR_SEQ_NR,
 	IFLA_HSR_VERSION,		/* HSR version */
+	IFLA_HSR_PROTOCOL,		/* Indicate different protocol than
+					 * HSR. For example PRP.
+					 */
 	__IFLA_HSR_MAX,
 };
 
diff --git a/net/hsr/Kconfig b/net/hsr/Kconfig
index 8095b034e76e..e2e396870230 100644
--- a/net/hsr/Kconfig
+++ b/net/hsr/Kconfig
@@ -4,24 +4,35 @@
 #
 
 config HSR
-	tristate "High-availability Seamless Redundancy (HSR)"
-	help
+	tristate "High-availability Seamless Redundancy (HSR & PRP)"
+	---help---
+	  This enables IEC 62439 defined High-availability Seamless
+	  Redundancy (HSR) and Parallel Redundancy Protocol (PRP).
+
 	  If you say Y here, then your Linux box will be able to act as a
-	  DANH ("Doubly attached node implementing HSR"). For this to work,
-	  your Linux box needs (at least) two physical Ethernet interfaces,
-	  and it must be connected as a node in a ring network together with
-	  other HSR capable nodes.
+	  DANH ("Doubly attached node implementing HSR") or DANP ("Doubly
+	  attached node implementing PRP"). For this to work, your Linux box
+	  needs (at least) two physical Ethernet interfaces.
+
+	  For DANH, it must be connected as a node in a ring network together
+	  with other HSR capable nodes. All Ethernet frames sent over the hsr
+	  device will be sent in both directions on the ring (over both slave
+	  ports), giving a redundant, instant fail-over network. Each HSR node
+	  in the ring acts like a bridge for HSR frames, but filters frames
+	  that have been forwarded earlier.
 
-	  All Ethernet frames sent over the hsr device will be sent in both
-	  directions on the ring (over both slave ports), giving a redundant,
-	  instant fail-over network. Each HSR node in the ring acts like a
-	  bridge for HSR frames, but filters frames that have been forwarded
-	  earlier.
+	  For DANP, it must be connected as a node connecting to two
+	  separate networks over the two slave interfaces. Like HSR, Ethernet
+	  frames sent over the prp device will be sent to both networks giving
+	  a redundant, instant fail-over network. Unlike HSR, PRP networks
+	  can have Singly Attached Nodes (SAN) such as PC, printer, bridges
+	  etc and will be able to communicate with DANP nodes.
 
 	  This code is a "best effort" to comply with the HSR standard as
 	  described in IEC 62439-3:2010 (HSRv0) and IEC 62439-3:2012 (HSRv1),
-	  but no compliancy tests have been made. Use iproute2 to select
-	  the version you desire.
+	  and PRP standard described in IEC 62439-4:2012 (PRP), but no
+	  compliancy tests have been made. Use iproute2 to select the protocol
+	  you would like to use.
 
 	  You need to perform any and all necessary tests yourself before
 	  relying on this code in a safety critical system!
diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index 9787ef11ca71..c1932c0a15be 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -1,5 +1,5 @@
 /*
- * hsr_debugfs code
+ * debugfs code for HSR & PRP
  * Copyright (C) 2019 Texas Instruments Incorporated
  *
  * Author(s):
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 8a927b647829..40ac45123a62 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -3,9 +3,8 @@
  *
  * Author(s):
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
- *
  * This file contains device methods for creating, using and destroying
- * virtual HSR devices.
+ * virtual HSR or PRP devices.
  */
 
 #include <linux/netdevice.h>
@@ -427,6 +426,10 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
 	ether_addr_copy(hsr_dev->dev_addr, slave[0]->dev_addr);
 
+	/* currently PRP is not supported */
+	if (protocol_version == PRP_V1)
+		return -EPROTONOSUPPORT;
+
 	/* Make sure we recognize frames from ourselves in hsr_rcv() */
 	res = hsr_create_self_node(hsr, hsr_dev->dev_addr,
 				   slave[1]->dev_addr);
diff --git a/net/hsr/hsr_device.h b/net/hsr/hsr_device.h
index b8f9262ed101..868373822ee4 100644
--- a/net/hsr/hsr_device.h
+++ b/net/hsr/hsr_device.h
@@ -3,6 +3,8 @@
  *
  * Author(s):
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ *
+ * include file for HSR and PRP.
  */
 
 #ifndef __HSR_DEVICE_H
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 1ea17752fffc..2f29ebc85eda 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -3,6 +3,8 @@
  *
  * Author(s):
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ *
+ * Frame router for HSR and PRP.
  */
 
 #include "hsr_forward.h"
diff --git a/net/hsr/hsr_forward.h b/net/hsr/hsr_forward.h
index 51a69295566c..b2a6fa319d94 100644
--- a/net/hsr/hsr_forward.h
+++ b/net/hsr/hsr_forward.h
@@ -3,6 +3,8 @@
  *
  * Author(s):
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ *
+ * include file for HSR and PRP.
  */
 
 #ifndef __HSR_FORWARD_H
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 530de24b1fb5..13b2190e6556 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -8,6 +8,7 @@
  * interface. A frame is identified by its source MAC address and its HSR
  * sequence number. This code keeps track of senders and their sequence numbers
  * to allow filtering of duplicate frames, and to detect HSR ring errors.
+ * Same code handles filtering of duplicates for PRP as well.
  */
 
 #include <linux/if_ether.h>
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index 0f0fa12b4329..c06447780d05 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -3,6 +3,8 @@
  *
  * Author(s):
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ *
+ * include file for HSR and PRP.
  */
 
 #ifndef __HSR_FRAMEREG_H
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index 144da15f0a81..2fd1976e5b1c 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -3,6 +3,8 @@
  *
  * Author(s):
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ *
+ * Event handling for HSR and PRP devices.
  */
 
 #include <linux/netdevice.h>
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index f74193465bf5..8cf10d67d5f9 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -3,6 +3,8 @@
  *
  * Author(s):
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ *
+ * include file for HSR and PRP.
  */
 
 #ifndef __HSR_PRIVATE_H
@@ -131,6 +133,13 @@ struct hsr_port {
 	enum hsr_port_type	type;
 };
 
+/* used by driver internally to differentiate various protocols */
+enum hsr_version {
+	HSR_V0 = 0,
+	HSR_V1,
+	PRP_V1,
+};
+
 struct hsr_priv {
 	struct rcu_head		rcu_head;
 	struct list_head	ports;
@@ -141,7 +150,7 @@ struct hsr_priv {
 	int announce_count;
 	u16 sequence_nr;
 	u16 sup_sequence_nr;	/* For HSRv1 separate seq_nr for supervision */
-	u8 prot_version;	/* Indicate if HSRv0 or HSRv1. */
+	enum hsr_version prot_version;	/* Indicate if HSRv0, HSRv1 or PRPv1 */
 	spinlock_t seqnr_lock;	/* locking for sequence_nr */
 	spinlock_t list_lock;	/* locking for node list */
 	unsigned char		sup_multicast_addr[ETH_ALEN];
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 6e14b7d22639..06c3cd988760 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -4,7 +4,7 @@
  * Author(s):
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
  *
- * Routines for handling Netlink messages for HSR.
+ * Routines for handling Netlink messages for HSR and PRP.
  */
 
 #include "hsr_netlink.h"
@@ -22,6 +22,7 @@ static const struct nla_policy hsr_policy[IFLA_HSR_MAX + 1] = {
 	[IFLA_HSR_VERSION]	= { .type = NLA_U8 },
 	[IFLA_HSR_SUPERVISION_ADDR]	= { .len = ETH_ALEN },
 	[IFLA_HSR_SEQ_NR]		= { .type = NLA_U16 },
+	[IFLA_HSR_PROTOCOL]		= { .type = NLA_U8 },
 };
 
 /* Here, it seems a netdevice has already been allocated for us, and the
@@ -31,8 +32,10 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 		       struct nlattr *tb[], struct nlattr *data[],
 		       struct netlink_ext_ack *extack)
 {
+	enum hsr_version proto_version;
+	unsigned char multicast_spec;
+	u8 proto = HSR_PROTOCOL_HSR;
 	struct net_device *link[2];
-	unsigned char multicast_spec, hsr_version;
 
 	if (!data) {
 		NL_SET_ERR_MSG_MOD(extack, "No slave devices specified");
@@ -69,18 +72,34 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 	else
 		multicast_spec = nla_get_u8(data[IFLA_HSR_MULTICAST_SPEC]);
 
+	if (data[IFLA_HSR_PROTOCOL])
+		proto = nla_get_u8(data[IFLA_HSR_PROTOCOL]);
+
+	if (proto >= HSR_PROTOCOL_MAX) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported protocol\n");
+		return -EINVAL;
+	}
+
 	if (!data[IFLA_HSR_VERSION]) {
-		hsr_version = 0;
+		proto_version = HSR_V0;
 	} else {
-		hsr_version = nla_get_u8(data[IFLA_HSR_VERSION]);
-		if (hsr_version > 1) {
+		if (proto == HSR_PROTOCOL_PRP) {
+			NL_SET_ERR_MSG_MOD(extack, "PRP version unsupported\n");
+			return -EINVAL;
+		}
+
+		proto_version = nla_get_u8(data[IFLA_HSR_VERSION]);
+		if (proto_version > HSR_V1) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Only versions 0..1 are supported");
+					   "Only HSR version 0/1 supported\n");
 			return -EINVAL;
 		}
 	}
 
-	return hsr_dev_finalize(dev, link, multicast_spec, hsr_version, extack);
+	if (proto == HSR_PROTOCOL_PRP)
+		proto_version = PRP_V1;
+
+	return hsr_dev_finalize(dev, link, multicast_spec, proto_version, extack);
 }
 
 static void hsr_dellink(struct net_device *dev, struct list_head *head)
@@ -102,6 +121,7 @@ static void hsr_dellink(struct net_device *dev, struct list_head *head)
 static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct hsr_priv *hsr = netdev_priv(dev);
+	u8 proto = HSR_PROTOCOL_HSR;
 	struct hsr_port *port;
 
 	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_A);
@@ -120,6 +140,10 @@ static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 		    hsr->sup_multicast_addr) ||
 	    nla_put_u16(skb, IFLA_HSR_SEQ_NR, hsr->sequence_nr))
 		goto nla_put_failure;
+	if (hsr->prot_version == PRP_V1)
+		proto = HSR_PROTOCOL_PRP;
+	if (nla_put_u8(skb, IFLA_HSR_PROTOCOL, proto))
+		goto nla_put_failure;
 
 	return 0;
 
diff --git a/net/hsr/hsr_netlink.h b/net/hsr/hsr_netlink.h
index 1121bb192a18..501552d9753b 100644
--- a/net/hsr/hsr_netlink.h
+++ b/net/hsr/hsr_netlink.h
@@ -3,6 +3,8 @@
  *
  * Author(s):
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ *
+ * include file for HSR and PRP.
  */
 
 #ifndef __HSR_NETLINK_H
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 25b6ffba26cd..b5c0834de338 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -3,6 +3,8 @@
  *
  * Author(s):
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ *
+ * Frame handler other utility functions for HSR and PRP.
  */
 
 #include "hsr_slave.h"
diff --git a/net/hsr/hsr_slave.h b/net/hsr/hsr_slave.h
index 8953ea279ce9..9708a4f0ec09 100644
--- a/net/hsr/hsr_slave.h
+++ b/net/hsr/hsr_slave.h
@@ -2,6 +2,8 @@
 /* Copyright 2011-2014 Autronica Fire and Security AS
  *
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ *
+ * include file for HSR and PRP.
  */
 
 #ifndef __HSR_SLAVE_H
-- 
2.17.1

