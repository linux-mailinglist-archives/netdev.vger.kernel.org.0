Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673AD1035F2
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 09:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfKTIXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 03:23:48 -0500
Received: from inva020.nxp.com ([92.121.34.13]:42488 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbfKTIXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 03:23:46 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 24A481A04D8;
        Wed, 20 Nov 2019 09:23:44 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E9A2A1A04AB;
        Wed, 20 Nov 2019 09:23:38 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 8F533402D0;
        Wed, 20 Nov 2019 16:23:32 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 5/5] net: dsa: ocelot: add hardware timestamping support for Felix
Date:   Wed, 20 Nov 2019 16:23:18 +0800
Message-Id: <20191120082318.3909-6-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120082318.3909-1-yangbo.lu@nxp.com>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to reuse ocelot functions as possible to enable PTP
clock and to support hardware timestamping on Felix.
On TX path, timestamping works on packet which requires timestamp.
The injection header will be configured accordingly, and skb clone
requires timestamp will be added into a list. The TX timestamp
is final handled in threaded interrupt handler when PTP timestamp
FIFO is ready.
On RX path, timestamping is always working. The RX timestamp could
be got from extraction header.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 89 ++++++++++++++++++++++++++++++++++++++++++
 net/dsa/tag_ocelot.c           | 14 ++++++-
 2 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ce3637b..167e415 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -3,6 +3,7 @@
  */
 #include <uapi/linux/if_bridge.h>
 #include <soc/mscc/ocelot.h>
+#include <linux/packing.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/of.h>
@@ -303,6 +304,62 @@ static void felix_teardown(struct dsa_switch *ds)
 	ocelot_deinit(ocelot);
 }
 
+static int felix_hwtstamp_get(struct dsa_switch *ds, int port,
+			      struct ifreq *ifr)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_hwstamp_get(ocelot, port, ifr);
+}
+
+static int felix_hwtstamp_set(struct dsa_switch *ds, int port,
+			      struct ifreq *ifr)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_hwstamp_set(ocelot, port, ifr);
+}
+
+static bool felix_rxtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb, unsigned int type)
+{
+	struct skb_shared_hwtstamps *shhwtstamps;
+	struct ocelot *ocelot = ds->priv;
+	u8 *extraction = skb->data - ETH_HLEN - OCELOT_TAG_LEN;
+	u32 tstamp_lo, tstamp_hi;
+	struct timespec64 ts;
+	u64 tstamp, val;
+
+	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
+	tstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
+
+	packing(extraction, &val,  116, 85, OCELOT_TAG_LEN, UNPACK, 0);
+	tstamp_lo = (u32)val;
+
+	tstamp_hi = tstamp >> 32;
+	if ((tstamp & 0xffffffff) < tstamp_lo)
+		tstamp_hi--;
+
+	tstamp = ((u64)tstamp_hi << 32) | tstamp_lo;
+
+	shhwtstamps = skb_hwtstamps(skb);
+	memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
+	shhwtstamps->hwtstamp = tstamp;
+	return false;
+}
+
+bool felix_txtstamp(struct dsa_switch *ds, int port,
+		    struct sk_buff *clone, unsigned int type)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	if (!ocelot_port_add_txtstamp_skb(ocelot_port, clone))
+		return true;
+
+	return false;
+}
+
 static const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol	= felix_get_tag_protocol,
 	.setup			= felix_setup,
@@ -325,12 +382,33 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.port_vlan_filtering	= felix_vlan_filtering,
 	.port_vlan_add		= felix_vlan_add,
 	.port_vlan_del		= felix_vlan_del,
+	.port_hwtstamp_get	= felix_hwtstamp_get,
+	.port_hwtstamp_set	= felix_hwtstamp_set,
+	.port_rxtstamp		= felix_rxtstamp,
+	.port_txtstamp		= felix_txtstamp,
 };
 
 static struct felix_info *felix_instance_tbl[] = {
 	[FELIX_INSTANCE_VSC9959] = &felix_info_vsc9959,
 };
 
+static irqreturn_t felix_irq_handler(int irq, void *data)
+{
+	struct ocelot *ocelot = (struct ocelot *)data;
+
+	/* The INTB interrupt is used for both PTP TX timestamp interrupt
+	 * and preemption status change interrupt on each port.
+	 *
+	 * - Get txtstamp if have
+	 * - TODO: handle preemption. Without handling it, driver may get
+	 *   interrupt storm.
+	 */
+
+	ocelot_get_txtstamp(ocelot);
+
+	return IRQ_HANDLED;
+}
+
 static int felix_pci_probe(struct pci_dev *pdev,
 			   const struct pci_device_id *id)
 {
@@ -372,6 +450,16 @@ static int felix_pci_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
+	err = devm_request_threaded_irq(&pdev->dev, pdev->irq, NULL,
+					&felix_irq_handler, IRQF_ONESHOT,
+					"felix-intb", ocelot);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to request irq\n");
+		goto err_alloc_irq;
+	}
+
+	ocelot->ptp = 1;
+
 	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
 	if (!ds) {
 		err = -ENOMEM;
@@ -396,6 +484,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 err_register_ds:
 	kfree(ds);
 err_alloc_ds:
+err_alloc_irq:
 err_alloc_felix:
 	kfree(felix);
 err_dma:
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 078d479..8e3e728 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -137,9 +137,11 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u64 bypass, dest, src, qos_class;
+	u64 bypass, dest, src, qos_class, rew_op;
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 *injection;
 
 	if (unlikely(skb_cow_head(skb, OCELOT_TAG_LEN) < 0)) {
@@ -161,6 +163,16 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	packing(injection, &src,       46,  43, OCELOT_TAG_LEN, PACK, 0);
 	packing(injection, &qos_class, 19,  17, OCELOT_TAG_LEN, PACK, 0);
 
+	if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+		rew_op = ocelot_port->ptp_cmd;
+		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+			rew_op |= (ocelot_port->ts_id  % 4) << 3;
+			ocelot_port->ts_id++;
+		}
+
+		packing(injection, &rew_op, 125, 117, OCELOT_TAG_LEN, PACK, 0);
+	}
+
 	return skb;
 }
 
-- 
2.7.4

