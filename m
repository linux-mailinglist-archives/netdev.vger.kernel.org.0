Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B4836BE32
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbhD0EMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:12:40 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46360 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234471AbhD0EMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 00:12:34 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7A9481A18B7;
        Tue, 27 Apr 2021 06:11:50 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 394981A0934;
        Tue, 27 Apr 2021 06:11:44 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id B824D40313;
        Tue, 27 Apr 2021 06:11:36 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next, v3, 7/7] net: mscc: ocelot: support PTP Sync one-step timestamping
Date:   Tue, 27 Apr 2021 12:22:03 +0800
Message-Id: <20210427042203.26258-8-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210427042203.26258-1-yangbo.lu@nxp.com>
References: <20210427042203.26258-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although HWTSTAMP_TX_ONESTEP_SYNC existed in ioctl for hardware timestamp
configuration, the PTP Sync one-step timestamping had never been supported.

This patch is to truely support it.

- ocelot_port_txtstamp_request()
  This function handles tx timestamp request by storing
  ptp_cmd(tx timestamp type) in OCELOT_SKB_CB(skb)->ptp_cmd,
  and additionally for two-step timestamp storing ts_id in
  OCELOT_SKB_CB(clone)->ptp_cmd.

- ocelot_ptp_rew_op()
  During xmit, this function is called to get rew_op (rewriter option) by
  checking skb->cb for tx timestamp request, and configure to transmitting.

Non-onestep-Sync packet with one-step timestamp request falls back to use
two-step timestamp.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
Changes for v2:
	- Utilized OCELOT_SKB_CB(skb)->ptp_cmd for timestamp type.
	- Fixed build issue.
	- Returned u32 for ocelot_ptp_rew_op, and kept only skb
	  argument.
Changes for v3:
	- None.
---
 drivers/net/ethernet/mscc/ocelot.c     | 53 ++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c |  8 ++--
 include/soc/mscc/ocelot.h              |  8 +++-
 net/dsa/Kconfig                        |  2 +
 net/dsa/tag_ocelot.c                   | 27 ++-----------
 net/dsa/tag_ocelot_8021q.c             | 41 ++++++--------------
 6 files changed, 81 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 3ff4cce1ce7d..0c4283319d7f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -6,6 +6,7 @@
  */
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
+#include <linux/ptp_classify.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
@@ -546,6 +547,46 @@ static void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 	spin_unlock(&ocelot_port->ts_id_lock);
 }
 
+u32 ocelot_ptp_rew_op(struct sk_buff *skb)
+{
+	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
+	u8 ptp_cmd = OCELOT_SKB_CB(skb)->ptp_cmd;
+	u32 rew_op = 0;
+
+	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP && clone) {
+		rew_op = ptp_cmd;
+		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
+	} else if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
+		rew_op = ptp_cmd;
+	}
+
+	return rew_op;
+}
+EXPORT_SYMBOL(ocelot_ptp_rew_op);
+
+static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb)
+{
+	struct ptp_header *hdr;
+	unsigned int ptp_class;
+	u8 msgtype, twostep;
+
+	ptp_class = ptp_classify_raw(skb);
+	if (ptp_class == PTP_CLASS_NONE)
+		return false;
+
+	hdr = ptp_parse_header(skb, ptp_class);
+	if (!hdr)
+		return false;
+
+	msgtype = ptp_get_msgtype(hdr, ptp_class);
+	twostep = hdr->flag_field[0] & 0x2;
+
+	if (msgtype == PTP_MSGTYPE_SYNC && twostep == 0)
+		return true;
+
+	return false;
+}
+
 int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 				 struct sk_buff *skb,
 				 struct sk_buff **clone)
@@ -553,12 +594,24 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 ptp_cmd = ocelot_port->ptp_cmd;
 
+	/* Store ptp_cmd in OCELOT_SKB_CB(skb)->ptp_cmd */
+	if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
+		if (ocelot_ptp_is_onestep_sync(skb)) {
+			OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
+			return 0;
+		}
+
+		/* Fall back to two-step timestamping */
+		ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
+	}
+
 	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
 		*clone = skb_clone_sk(skb);
 		if (!(*clone))
 			return -ENOMEM;
 
 		ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
+		OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e99c8fb3cb15..aad33d22c33f 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -514,10 +514,10 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 			return NETDEV_TX_OK;
 		}
 
-		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
-			rew_op = ocelot_port->ptp_cmd;
-			rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
-		}
+		if (clone)
+			OCELOT_SKB_CB(skb)->clone = clone;
+
+		rew_op = ocelot_ptp_rew_op(skb);
 	}
 
 	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index f7632519cb9c..2f5ce4d4fdbf 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -691,6 +691,7 @@ struct ocelot_policer {
 
 struct ocelot_skb_cb {
 	struct sk_buff *clone;
+	u8 ptp_cmd;
 	u8 ts_id;
 };
 
@@ -748,15 +749,16 @@ u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 			      u32 val, u32 reg, u32 offset);
 
-/* Packet I/O */
 #if IS_ENABLED(CONFIG_MSCC_OCELOT_SWITCH_LIB)
 
+/* Packet I/O */
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
+u32 ocelot_ptp_rew_op(struct sk_buff *skb);
 #else
 
 static inline bool ocelot_can_inject(struct ocelot *ocelot, int grp)
@@ -780,6 +782,10 @@ static inline void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
 {
 }
 
+static inline u32 ocelot_ptp_rew_op(struct sk_buff *skb)
+{
+	return 0;
+}
 #endif
 
 /* Hardware initialization */
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index cbc2bd643ab2..5baba7021427 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -111,6 +111,8 @@ config NET_DSA_TAG_RTL4_A
 
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches, using NPI port"
+	depends on MSCC_OCELOT_SWITCH_LIB || \
+		   (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
 	select PACKING
 	help
 	  Say Y or M if you want to enable NPI tagging for the Ocelot switches
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 1100a16f1032..91f0fd1242cd 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -5,33 +5,14 @@
 #include <soc/mscc/ocelot.h>
 #include "dsa_priv.h"
 
-static void ocelot_xmit_ptp(struct dsa_port *dp, void *injection,
-			    struct sk_buff *clone)
-{
-	struct ocelot *ocelot = dp->ds->priv;
-	struct ocelot_port *ocelot_port;
-	u64 rew_op;
-
-	ocelot_port = ocelot->ports[dp->index];
-	rew_op = ocelot_port->ptp_cmd;
-
-	/* Retrieve timestamp ID populated inside OCELOT_SKB_CB(clone)->ts_id
-	 * by ocelot_port_add_txtstamp_skb
-	 */
-	if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
-		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
-
-	ocelot_ifh_set_rew_op(injection, rew_op);
-}
-
 static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
 			       __be32 ifh_prefix, void **ifh)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
 	struct dsa_switch *ds = dp->ds;
 	void *injection;
 	__be32 *prefix;
+	u32 rew_op = 0;
 
 	injection = skb_push(skb, OCELOT_TAG_LEN);
 	prefix = skb_push(skb, OCELOT_SHORT_PREFIX_LEN);
@@ -42,9 +23,9 @@ static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
 	ocelot_ifh_set_src(injection, ds->num_ports);
 	ocelot_ifh_set_qos_class(injection, skb->priority);
 
-	/* TX timestamping was requested */
-	if (clone)
-		ocelot_xmit_ptp(dp, injection, clone);
+	rew_op = ocelot_ptp_rew_op(skb);
+	if (rew_op)
+		ocelot_ifh_set_rew_op(injection, rew_op);
 
 	*ifh = injection;
 }
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index a001a7e3f575..62a93303bd63 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -13,32 +13,6 @@
 #include <soc/mscc/ocelot_ptp.h>
 #include "dsa_priv.h"
 
-static struct sk_buff *ocelot_xmit_ptp(struct dsa_port *dp,
-				       struct sk_buff *skb,
-				       struct sk_buff *clone)
-{
-	struct ocelot *ocelot = dp->ds->priv;
-	struct ocelot_port *ocelot_port;
-	int port = dp->index;
-	u32 rew_op;
-
-	if (!ocelot_can_inject(ocelot, 0))
-		return NULL;
-
-	ocelot_port = ocelot->ports[port];
-	rew_op = ocelot_port->ptp_cmd;
-
-	/* Retrieve timestamp ID populated inside OCELOT_SKB_CB(clone)->ts_id
-	 * by ocelot_port_add_txtstamp_skb
-	 */
-	if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
-		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
-
-	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
-
-	return NULL;
-}
-
 static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
@@ -46,11 +20,18 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
-	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
+	struct ocelot *ocelot = dp->ds->priv;
+	int port = dp->index;
+	u32 rew_op = 0;
+
+	rew_op = ocelot_ptp_rew_op(skb);
+	if (rew_op) {
+		if (!ocelot_can_inject(ocelot, 0))
+			return NULL;
 
-	/* TX timestamping was requested, so inject through MMIO */
-	if (clone)
-		return ocelot_xmit_ptp(dp, skb, clone);
+		ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
+		return NULL;
+	}
 
 	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
 			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
-- 
2.25.1

