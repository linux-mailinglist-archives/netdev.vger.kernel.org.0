Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0C3282A72
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 13:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgJDLaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 07:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDLaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 07:30:19 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986A1C0613CF;
        Sun,  4 Oct 2020 04:30:18 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601811017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WeiktvDMuTunNYPWzgeTC5JdiNN4VKRKY/KIDxEMIQE=;
        b=QRCfeHpy3vlq1zPEd3C6UdtcwKAzQvuojdN+7KEaxgmx2oiJ1DIKQrj/qc/Ww0tbhrr/br
        0Y9FzX2ilQt2CcukzSU1bCvKaLCG95AJlFELhpd6NbRetV9sTn7qjhmMkxXjwa9kaMPovO
        5kZOk2N5Vss0YCT/mPiczG4EZyjUVZqaoMGVLtjBlRxf2J+teXOg4PVG4+yGm3/BOxmwym
        SoznlWcvmR94UiSYbl1dW7/Olqv33EbWuaMuYGUACPJ20HMLAIg9rjwH88LakoIhXU3XK9
        EXfHIwqZwUXJLFN3AnvwVqZQTpwqgiWYqbZNhvE/S8hgwxH5oMQHb4bS1H+VrA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601811017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WeiktvDMuTunNYPWzgeTC5JdiNN4VKRKY/KIDxEMIQE=;
        b=rqRaswClfQzCuL3FgsLn6AAbijuND+RMHCusuXcxl0dOBezgoMqTUmzAzcH+HhruImbX/x
        EUWOKnxDGj2umYDQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for hardware timestamping
Date:   Sun,  4 Oct 2020 13:29:08 +0200
Message-Id: <20201004112911.25085-5-kurt@linutronix.de>
In-Reply-To: <20201004112911.25085-1-kurt@linutronix.de>
References: <20201004112911.25085-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>

The switch has the ability to take hardware generated time stamps per port for
PTPv2 event messages in Rx and Tx direction. That is useful for achieving needed
time synchronization precision for TSN devices/switches. So add support for it.

There are two directions:

 * RX

   The switch has a single register per port to capture a timestamp. That
   mechanism is not used due to correlation problems. If the software processing
   is too slow and a PTPv2 event message is received before the previous one has
   been processed, false timestamps will be captured. Therefore, the switch can
   do "inline" timestamping which means it can insert the nanoseconds part of
   the timestamp directly into the PTPv2 event message. The reserved field (4
   bytes) is leveraged for that. This might not be in accordance with (older)
   PTP standards, but is the only way to get reliable results.

 * TX

   In Tx direction there is no correlation problem, because the software and the
   driver has to ensure that only one event message is "on the fly". However,
   the switch provides also a mechanism to check whether a timestamp is
   lost. That can only happen when a timestamp is read and at this point another
   message is timestamped. So, that lost bit is checked just in case to indicate
   to the user that the driver or the software is somewhat buggy.

Signed-off-by: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/dsa/hirschmann/Makefile           |   1 +
 drivers/net/dsa/hirschmann/hellcreek.c        |  15 +
 drivers/net/dsa/hirschmann/hellcreek.h        |  25 +
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   | 479 ++++++++++++++++++
 .../net/dsa/hirschmann/hellcreek_hwtstamp.h   |  58 +++
 drivers/net/dsa/hirschmann/hellcreek_ptp.c    |  48 +-
 drivers/net/dsa/hirschmann/hellcreek_ptp.h    |   4 +
 7 files changed, 616 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h

diff --git a/drivers/net/dsa/hirschmann/Makefile b/drivers/net/dsa/hirschmann/Makefile
index 39de02a03640..f4075c2998b5 100644
--- a/drivers/net/dsa/hirschmann/Makefile
+++ b/drivers/net/dsa/hirschmann/Makefile
@@ -2,3 +2,4 @@
 obj-$(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)	+= hellcreek_sw.o
 hellcreek_sw-objs := hellcreek.o
 hellcreek_sw-objs += hellcreek_ptp.o
+hellcreek_sw-objs += hellcreek_hwtstamp.o
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 3e1040039a96..e9ec9dcca0d8 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -25,6 +25,7 @@
 
 #include "hellcreek.h"
 #include "hellcreek_ptp.h"
+#include "hellcreek_hwtstamp.h"
 
 static const struct hellcreek_counter hellcreek_counter[] = {
 	{ 0x00, "RxFiltered", },
@@ -1191,6 +1192,11 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.port_bridge_leave   = hellcreek_port_bridge_leave,
 	.port_stp_state_set  = hellcreek_port_stp_state_set,
 	.phylink_validate    = hellcreek_phylink_validate,
+	.port_hwtstamp_set   = hellcreek_port_hwtstamp_set,
+	.port_hwtstamp_get   = hellcreek_port_hwtstamp_get,
+	.port_txtstamp	     = hellcreek_port_txtstamp,
+	.port_rxtstamp	     = hellcreek_port_rxtstamp,
+	.get_ts_info	     = hellcreek_get_ts_info,
 };
 
 static int hellcreek_probe(struct platform_device *pdev)
@@ -1302,10 +1308,18 @@ static int hellcreek_probe(struct platform_device *pdev)
 		goto err_ptp_setup;
 	}
 
+	ret = hellcreek_hwtstamp_setup(hellcreek);
+	if (ret) {
+		dev_err(dev, "Failed to setup hardware timestamping!\n");
+		goto err_tstamp_setup;
+	}
+
 	platform_set_drvdata(pdev, hellcreek);
 
 	return 0;
 
+err_tstamp_setup:
+	hellcreek_ptp_free(hellcreek);
 err_ptp_setup:
 	dsa_unregister_switch(hellcreek->ds);
 
@@ -1316,6 +1330,7 @@ static int hellcreek_remove(struct platform_device *pdev)
 {
 	struct hellcreek *hellcreek = platform_get_drvdata(pdev);
 
+	hellcreek_hwtstamp_free(hellcreek);
 	hellcreek_ptp_free(hellcreek);
 	dsa_unregister_switch(hellcreek->ds);
 	platform_set_drvdata(pdev, NULL);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index 0c95577b81ad..0b42c15736ce 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -213,6 +213,28 @@ struct hellcreek_counter {
 
 struct hellcreek;
 
+/* State flags for hellcreek_port_hwtstamp::state */
+enum {
+	HELLCREEK_HWTSTAMP_ENABLED,
+	HELLCREEK_HWTSTAMP_TX_IN_PROGRESS,
+};
+
+/* A structure to hold hardware timestamping information per port */
+struct hellcreek_port_hwtstamp {
+	/* Timestamping state */
+	unsigned long state;
+
+	/* Resources for receive timestamping */
+	struct sk_buff_head rx_queue; /* For synchronization messages */
+
+	/* Resources for transmit timestamping */
+	unsigned long tx_tstamp_start;
+	struct sk_buff *tx_skb;
+
+	/* Current timestamp configuration */
+	struct hwtstamp_config tstamp_config;
+};
+
 struct hellcreek_port {
 	struct hellcreek *hellcreek;
 	struct list_head vlan_list;
@@ -221,6 +243,9 @@ struct hellcreek_port {
 	int vlan_filtering;	/* Is VLAN filtering activated */
 	u16 ptcfg;		/* ptcfg shadow */
 	u64 *counter_values;
+
+	/* Per-port timestamping resources */
+	struct hellcreek_port_hwtstamp port_hwtstamp;
 };
 
 struct hellcreek_fdb_entry {
diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
new file mode 100644
index 000000000000..69dd9a2e8bb6
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
@@ -0,0 +1,479 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * DSA driver for:
+ * Hirschmann Hellcreek TSN switch.
+ *
+ * Copyright (C) 2019,2020 Hochschule Offenburg
+ * Copyright (C) 2019,2020 Linutronix GmbH
+ * Authors: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
+ *	    Kurt Kanzenbach <kurt@linutronix.de>
+ */
+
+#include <linux/ptp_classify.h>
+
+#include "hellcreek.h"
+#include "hellcreek_hwtstamp.h"
+#include "hellcreek_ptp.h"
+
+int hellcreek_get_ts_info(struct dsa_switch *ds, int port,
+			  struct ethtool_ts_info *info)
+{
+	struct hellcreek *hellcreek = ds->priv;
+
+	info->phc_index = hellcreek->ptp_clock ?
+		ptp_clock_index(hellcreek->ptp_clock) : -1;
+	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	/* enabled tx timestamping */
+	info->tx_types = BIT(HWTSTAMP_TX_ON);
+
+	/* L2 & L4 PTPv2 event rx messages are timestamped */
+	info->rx_filters = BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	return 0;
+}
+
+/* Enabling/disabling TX and RX HW timestamping for different PTP messages is
+ * not available in the switch. Thus, this function only serves as a check if
+ * the user requested what is actually available or not
+ */
+static int hellcreek_set_hwtstamp_config(struct hellcreek *hellcreek, int port,
+					 struct hwtstamp_config *config)
+{
+	struct hellcreek_port_hwtstamp *ps =
+		&hellcreek->ports[port].port_hwtstamp;
+	bool tx_tstamp_enable = false;
+	bool rx_tstamp_enable = false;
+
+	/* Interaction with the timestamp hardware is prevented here.  It is
+	 * enabled when this config function ends successfully
+	 */
+	clear_bit_unlock(HELLCREEK_HWTSTAMP_ENABLED, &ps->state);
+
+	/* Reserved for future extensions */
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_ON:
+		tx_tstamp_enable = true;
+		break;
+
+	/* TX HW timestamping can't be disabled on the switch */
+	case HWTSTAMP_TX_OFF:
+		config->tx_type = HWTSTAMP_TX_ON;
+		break;
+
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	/* RX HW timestamping can't be disabled on the switch */
+	case HWTSTAMP_FILTER_NONE:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		rx_tstamp_enable = true;
+		break;
+
+	/* RX HW timestamping can't be enabled for all messages on the switch */
+	case HWTSTAMP_FILTER_ALL:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+
+	default:
+		return -ERANGE;
+	}
+
+	if (!tx_tstamp_enable)
+		return -ERANGE;
+
+	if (!rx_tstamp_enable)
+		return -ERANGE;
+
+	/* If this point is reached, then the requested hwtstamp config is
+	 * compatible with the hwtstamp offered by the switch.  Therefore,
+	 * enable the interaction with the HW timestamping
+	 */
+	set_bit(HELLCREEK_HWTSTAMP_ENABLED, &ps->state);
+
+	return 0;
+}
+
+int hellcreek_port_hwtstamp_set(struct dsa_switch *ds, int port,
+				struct ifreq *ifr)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port_hwtstamp *ps;
+	struct hwtstamp_config config;
+	int err;
+
+	ps = &hellcreek->ports[port].port_hwtstamp;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	err = hellcreek_set_hwtstamp_config(hellcreek, port, &config);
+	if (err)
+		return err;
+
+	/* Save the chosen configuration to be returned later */
+	memcpy(&ps->tstamp_config, &config, sizeof(config));
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
+int hellcreek_port_hwtstamp_get(struct dsa_switch *ds, int port,
+				struct ifreq *ifr)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port_hwtstamp *ps;
+	struct hwtstamp_config *config;
+
+	ps = &hellcreek->ports[port].port_hwtstamp;
+	config = &ps->tstamp_config;
+
+	return copy_to_user(ifr->ifr_data, config, sizeof(*config)) ?
+		-EFAULT : 0;
+}
+
+/* Returns a pointer to the PTP header if the caller should time stamp, or NULL
+ * if the caller should not.
+ */
+static struct ptp_header *hellcreek_should_tstamp(struct hellcreek *hellcreek,
+						  int port, struct sk_buff *skb,
+						  unsigned int type)
+{
+	struct hellcreek_port_hwtstamp *ps =
+		&hellcreek->ports[port].port_hwtstamp;
+	struct ptp_header *hdr;
+
+	hdr = ptp_parse_header(skb, type);
+	if (!hdr)
+		return NULL;
+
+	if (!test_bit(HELLCREEK_HWTSTAMP_ENABLED, &ps->state))
+		return NULL;
+
+	return hdr;
+}
+
+static u64 hellcreek_get_reserved_field(const struct ptp_header *hdr)
+{
+	return be32_to_cpu(hdr->reserved2);
+}
+
+static void hellcreek_clear_reserved_field(struct ptp_header *hdr)
+{
+	hdr->reserved2 = 0;
+}
+
+static int hellcreek_ptp_hwtstamp_available(struct hellcreek *hellcreek,
+					    unsigned int ts_reg)
+{
+	u16 status;
+
+	status = hellcreek_ptp_read(hellcreek, ts_reg);
+
+	if (status & PR_TS_STATUS_TS_LOST)
+		dev_err(hellcreek->dev,
+			"Tx time stamp lost! This should never happen!\n");
+
+	/* If hwtstamp is not available, this means the previous hwtstamp was
+	 * successfully read, and the one we need is not yet available
+	 */
+	return (status & PR_TS_STATUS_TS_AVAIL) ? 1 : 0;
+}
+
+/* Get nanoseconds timestamp from timestamping unit */
+static u64 hellcreek_ptp_hwtstamp_read(struct hellcreek *hellcreek,
+				       unsigned int ts_reg)
+{
+	u16 nsl, nsh;
+
+	nsh = hellcreek_ptp_read(hellcreek, ts_reg);
+	nsh = hellcreek_ptp_read(hellcreek, ts_reg);
+	nsh = hellcreek_ptp_read(hellcreek, ts_reg);
+	nsh = hellcreek_ptp_read(hellcreek, ts_reg);
+	nsl = hellcreek_ptp_read(hellcreek, ts_reg);
+
+	return (u64)nsl | ((u64)nsh << 16);
+}
+
+static int hellcreek_txtstamp_work(struct hellcreek *hellcreek,
+				   struct hellcreek_port_hwtstamp *ps, int port)
+{
+	struct skb_shared_hwtstamps shhwtstamps;
+	unsigned int status_reg, data_reg;
+	struct sk_buff *tmp_skb;
+	int ts_status;
+	u64 ns = 0;
+
+	if (!ps->tx_skb)
+		return 0;
+
+	switch (port) {
+	case 2:
+		status_reg = PR_TS_TX_P1_STATUS_C;
+		data_reg   = PR_TS_TX_P1_DATA_C;
+		break;
+	case 3:
+		status_reg = PR_TS_TX_P2_STATUS_C;
+		data_reg   = PR_TS_TX_P2_DATA_C;
+		break;
+	default:
+		dev_err(hellcreek->dev, "Wrong port for timestamping!\n");
+		return 0;
+	}
+
+	ts_status = hellcreek_ptp_hwtstamp_available(hellcreek, status_reg);
+
+	/* Not available yet? */
+	if (ts_status == 0) {
+		/* Check whether the operation of reading the tx timestamp has
+		 * exceeded its allowed period
+		 */
+		if (time_is_before_jiffies(ps->tx_tstamp_start +
+					   TX_TSTAMP_TIMEOUT)) {
+			dev_err(hellcreek->dev,
+				"Timeout while waiting for Tx timestamp!\n");
+			goto free_and_clear_skb;
+		}
+
+		/* The timestamp should be available quickly, while getting it
+		 * in high priority. Restart the work
+		 */
+		return 1;
+	}
+
+	mutex_lock(&hellcreek->ptp_lock);
+	ns  = hellcreek_ptp_hwtstamp_read(hellcreek, data_reg);
+	ns += hellcreek_ptp_gettime_seconds(hellcreek, ns);
+	mutex_unlock(&hellcreek->ptp_lock);
+
+	/* Now we have the timestamp in nanoseconds, store it in the correct
+	 * structure in order to send it to the user
+	 */
+	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+	shhwtstamps.hwtstamp = ns_to_ktime(ns);
+
+	tmp_skb = ps->tx_skb;
+	ps->tx_skb = NULL;
+
+	/* skb_complete_tx_timestamp() frees up the client to make another
+	 * timestampable transmit.  We have to be ready for it by clearing the
+	 * ps->tx_skb "flag" beforehand
+	 */
+	clear_bit_unlock(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS, &ps->state);
+
+	/* Deliver a clone of the original outgoing tx_skb with tx hwtstamp */
+	skb_complete_tx_timestamp(tmp_skb, &shhwtstamps);
+
+	return 0;
+
+free_and_clear_skb:
+	dev_kfree_skb_any(ps->tx_skb);
+	ps->tx_skb = NULL;
+	clear_bit_unlock(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS, &ps->state);
+
+	return 0;
+}
+
+static void hellcreek_get_rxts(struct hellcreek *hellcreek,
+			       struct hellcreek_port_hwtstamp *ps,
+			       struct sk_buff *skb, struct sk_buff_head *rxq,
+			       int port)
+{
+	struct skb_shared_hwtstamps *shwt;
+	struct sk_buff_head received;
+	unsigned long flags;
+
+	/* The latched timestamp belongs to one of the received frames. */
+	__skb_queue_head_init(&received);
+
+	/* Lock & disable interrupts */
+	spin_lock_irqsave(&rxq->lock, flags);
+
+	/* Add the reception queue "rxq" to the "received" queue an reintialize
+	 * "rxq".  From now on, we deal with "received" not with "rxq"
+	 */
+	skb_queue_splice_tail_init(rxq, &received);
+
+	spin_unlock_irqrestore(&rxq->lock, flags);
+
+	for (; skb; skb = __skb_dequeue(&received)) {
+		struct ptp_header *hdr;
+		unsigned int type;
+		u64 ns;
+
+		/* Get nanoseconds from ptp packet */
+		type = SKB_PTP_TYPE(skb);
+		hdr  = ptp_parse_header(skb, type);
+		ns   = hellcreek_get_reserved_field(hdr);
+		hellcreek_clear_reserved_field(hdr);
+
+		/* Add seconds part */
+		mutex_lock(&hellcreek->ptp_lock);
+		ns += hellcreek_ptp_gettime_seconds(hellcreek, ns);
+		mutex_unlock(&hellcreek->ptp_lock);
+
+		/* Save time stamp */
+		shwt = skb_hwtstamps(skb);
+		memset(shwt, 0, sizeof(*shwt));
+		shwt->hwtstamp = ns_to_ktime(ns);
+		netif_rx_ni(skb);
+	}
+}
+
+static void hellcreek_rxtstamp_work(struct hellcreek *hellcreek,
+				    struct hellcreek_port_hwtstamp *ps,
+				    int port)
+{
+	struct sk_buff *skb;
+
+	skb = skb_dequeue(&ps->rx_queue);
+	if (skb)
+		hellcreek_get_rxts(hellcreek, ps, skb, &ps->rx_queue, port);
+}
+
+long hellcreek_hwtstamp_work(struct ptp_clock_info *ptp)
+{
+	struct hellcreek *hellcreek = ptp_to_hellcreek(ptp);
+	struct dsa_switch *ds = hellcreek->ds;
+	int i, restart = 0;
+
+	for (i = 0; i < ds->num_ports; i++) {
+		struct hellcreek_port_hwtstamp *ps;
+
+		if (!dsa_is_user_port(ds, i))
+			continue;
+
+		ps = &hellcreek->ports[i].port_hwtstamp;
+
+		if (test_bit(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS, &ps->state))
+			restart |= hellcreek_txtstamp_work(hellcreek, ps, i);
+
+		hellcreek_rxtstamp_work(hellcreek, ps, i);
+	}
+
+	return restart ? 1 : -1;
+}
+
+bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
+			     struct sk_buff *clone, unsigned int type)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port_hwtstamp *ps;
+	struct ptp_header *hdr;
+
+	ps = &hellcreek->ports[port].port_hwtstamp;
+
+	/* Check if the driver is expected to do HW timestamping */
+	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
+		return false;
+
+	/* Make sure the message is a PTP message that needs to be timestamped
+	 * and the interaction with the HW timestamping is enabled. If not, stop
+	 * here
+	 */
+	hdr = hellcreek_should_tstamp(hellcreek, port, clone, type);
+	if (!hdr)
+		return false;
+
+	if (test_and_set_bit_lock(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS,
+				  &ps->state))
+		return false;
+
+	ps->tx_skb = clone;
+
+	/* store the number of ticks occurred since system start-up till this
+	 * moment
+	 */
+	ps->tx_tstamp_start = jiffies;
+
+	ptp_schedule_worker(hellcreek->ptp_clock, 0);
+
+	return true;
+}
+
+bool hellcreek_port_rxtstamp(struct dsa_switch *ds, int port,
+			     struct sk_buff *skb, unsigned int type)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port_hwtstamp *ps;
+	struct ptp_header *hdr;
+
+	ps = &hellcreek->ports[port].port_hwtstamp;
+
+	/* This check only fails if the user did not initialize hardware
+	 * timestamping beforehand.
+	 */
+	if (ps->tstamp_config.rx_filter != HWTSTAMP_FILTER_PTP_V2_EVENT)
+		return false;
+
+	/* Make sure the message is a PTP message that needs to be timestamped
+	 * and the interaction with the HW timestamping is enabled. If not, stop
+	 * here
+	 */
+	hdr = hellcreek_should_tstamp(hellcreek, port, skb, type);
+	if (!hdr)
+		return false;
+
+	SKB_PTP_TYPE(skb) = type;
+
+	skb_queue_tail(&ps->rx_queue, skb);
+
+	ptp_schedule_worker(hellcreek->ptp_clock, 0);
+
+	return true;
+}
+
+static void hellcreek_hwtstamp_port_setup(struct hellcreek *hellcreek, int port)
+{
+	struct hellcreek_port_hwtstamp *ps =
+		&hellcreek->ports[port].port_hwtstamp;
+
+	skb_queue_head_init(&ps->rx_queue);
+}
+
+int hellcreek_hwtstamp_setup(struct hellcreek *hellcreek)
+{
+	struct dsa_switch *ds = hellcreek->ds;
+	int i;
+
+	/* Initialize timestamping ports. */
+	for (i = 0; i < ds->num_ports; ++i) {
+		if (!dsa_is_user_port(ds, i))
+			continue;
+
+		hellcreek_hwtstamp_port_setup(hellcreek, i);
+	}
+
+	/* Select the synchronized clock as the source timekeeper for the
+	 * timestamps and enable inline timestamping.
+	 */
+	hellcreek_ptp_write(hellcreek, PR_SETTINGS_C_TS_SRC_TK_MASK |
+			    PR_SETTINGS_C_RES3TS,
+			    PR_SETTINGS_C);
+
+	return 0;
+}
+
+void hellcreek_hwtstamp_free(struct hellcreek *hellcreek)
+{
+	/* Nothing todo */
+}
diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
new file mode 100644
index 000000000000..c0745ffa1ebb
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * DSA driver for:
+ * Hirschmann Hellcreek TSN switch.
+ *
+ * Copyright (C) 2019,2020 Hochschule Offenburg
+ * Copyright (C) 2019,2020 Linutronix GmbH
+ * Authors: Kurt Kanzenbach <kurt@linutronix.de>
+ *	    Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
+ */
+
+#ifndef _HELLCREEK_HWTSTAMP_H_
+#define _HELLCREEK_HWTSTAMP_H_
+
+#include <net/dsa.h>
+#include "hellcreek.h"
+
+/* Timestamp Register */
+#define PR_TS_RX_P1_STATUS_C	(0x1d * 2)
+#define PR_TS_RX_P1_DATA_C	(0x1e * 2)
+#define PR_TS_TX_P1_STATUS_C	(0x1f * 2)
+#define PR_TS_TX_P1_DATA_C	(0x20 * 2)
+#define PR_TS_RX_P2_STATUS_C	(0x25 * 2)
+#define PR_TS_RX_P2_DATA_C	(0x26 * 2)
+#define PR_TS_TX_P2_STATUS_C	(0x27 * 2)
+#define PR_TS_TX_P2_DATA_C	(0x28 * 2)
+
+#define PR_TS_STATUS_TS_AVAIL	BIT(2)
+#define PR_TS_STATUS_TS_LOST	BIT(3)
+
+#define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
+
+/* TX_TSTAMP_TIMEOUT: This limits the time spent polling for a TX
+ * timestamp. When working properly, hardware will produce a timestamp
+ * within 1ms. Software may enounter delays, so the timeout is set
+ * accordingly.
+ */
+#define TX_TSTAMP_TIMEOUT	msecs_to_jiffies(40)
+
+int hellcreek_port_hwtstamp_set(struct dsa_switch *ds, int port,
+				struct ifreq *ifr);
+int hellcreek_port_hwtstamp_get(struct dsa_switch *ds, int port,
+				struct ifreq *ifr);
+
+bool hellcreek_port_rxtstamp(struct dsa_switch *ds, int port,
+			     struct sk_buff *clone, unsigned int type);
+bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
+			     struct sk_buff *clone, unsigned int type);
+
+int hellcreek_get_ts_info(struct dsa_switch *ds, int port,
+			  struct ethtool_ts_info *info);
+
+long hellcreek_hwtstamp_work(struct ptp_clock_info *ptp);
+
+int hellcreek_hwtstamp_setup(struct hellcreek *chip);
+void hellcreek_hwtstamp_free(struct hellcreek *chip);
+
+#endif /* _HELLCREEK_HWTSTAMP_H_ */
diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
index 856fcb9ba3c6..12ad956abd5c 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -12,14 +12,15 @@
 #include <linux/ptp_clock_kernel.h>
 #include "hellcreek.h"
 #include "hellcreek_ptp.h"
+#include "hellcreek_hwtstamp.h"
 
-static u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int offset)
+u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int offset)
 {
 	return readw(hellcreek->ptp_base + offset);
 }
 
-static void hellcreek_ptp_write(struct hellcreek *hellcreek, u16 data,
-				unsigned int offset)
+void hellcreek_ptp_write(struct hellcreek *hellcreek, u16 data,
+			 unsigned int offset)
 {
 	writew(data, hellcreek->ptp_base + offset);
 }
@@ -61,6 +62,24 @@ static u64 __hellcreek_ptp_gettime(struct hellcreek *hellcreek)
 	return ns;
 }
 
+/* Retrieve the seconds parts in nanoseconds for a packet timestamped with @ns.
+ * There has to be a check whether an overflow occurred between the packet
+ * arrival and now. If so use the correct seconds (-1) for calculating the
+ * packet arrival time.
+ */
+u64 hellcreek_ptp_gettime_seconds(struct hellcreek *hellcreek, u64 ns)
+{
+	u64 s;
+
+	__hellcreek_ptp_gettime(hellcreek);
+	if (hellcreek->last_ts > ns)
+		s = hellcreek->seconds * NSEC_PER_SEC;
+	else
+		s = (hellcreek->seconds - 1) * NSEC_PER_SEC;
+
+	return s;
+}
+
 static int hellcreek_ptp_gettime(struct ptp_clock_info *ptp,
 				 struct timespec64 *ts)
 {
@@ -238,17 +257,18 @@ int hellcreek_ptp_setup(struct hellcreek *hellcreek)
 	 * accumulator_overflow_rate shall not exceed 62.5 MHz (which adjusts
 	 * the nominal frequency by 6.25%)
 	 */
-	hellcreek->ptp_clock_info.max_adj   = 62500000;
-	hellcreek->ptp_clock_info.n_alarm   = 0;
-	hellcreek->ptp_clock_info.n_pins    = 0;
-	hellcreek->ptp_clock_info.n_ext_ts  = 0;
-	hellcreek->ptp_clock_info.n_per_out = 0;
-	hellcreek->ptp_clock_info.pps	    = 0;
-	hellcreek->ptp_clock_info.adjfine   = hellcreek_ptp_adjfine;
-	hellcreek->ptp_clock_info.adjtime   = hellcreek_ptp_adjtime;
-	hellcreek->ptp_clock_info.gettime64 = hellcreek_ptp_gettime;
-	hellcreek->ptp_clock_info.settime64 = hellcreek_ptp_settime;
-	hellcreek->ptp_clock_info.enable    = hellcreek_ptp_enable;
+	hellcreek->ptp_clock_info.max_adj     = 62500000;
+	hellcreek->ptp_clock_info.n_alarm     = 0;
+	hellcreek->ptp_clock_info.n_pins      = 0;
+	hellcreek->ptp_clock_info.n_ext_ts    = 0;
+	hellcreek->ptp_clock_info.n_per_out   = 0;
+	hellcreek->ptp_clock_info.pps	      = 0;
+	hellcreek->ptp_clock_info.adjfine     = hellcreek_ptp_adjfine;
+	hellcreek->ptp_clock_info.adjtime     = hellcreek_ptp_adjtime;
+	hellcreek->ptp_clock_info.gettime64   = hellcreek_ptp_gettime;
+	hellcreek->ptp_clock_info.settime64   = hellcreek_ptp_settime;
+	hellcreek->ptp_clock_info.enable      = hellcreek_ptp_enable;
+	hellcreek->ptp_clock_info.do_aux_work = hellcreek_hwtstamp_work;
 
 	hellcreek->ptp_clock = ptp_clock_register(&hellcreek->ptp_clock_info,
 						  hellcreek->dev);
diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.h b/drivers/net/dsa/hirschmann/hellcreek_ptp.h
index 2dd8aaa532d0..e0eca1f4a494 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.h
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.h
@@ -59,6 +59,10 @@
 
 int hellcreek_ptp_setup(struct hellcreek *hellcreek);
 void hellcreek_ptp_free(struct hellcreek *hellcreek);
+u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int offset);
+void hellcreek_ptp_write(struct hellcreek *hellcreek, u16 data,
+			 unsigned int offset);
+u64 hellcreek_ptp_gettime_seconds(struct hellcreek *hellcreek, u64 ns);
 
 #define ptp_to_hellcreek(ptp)					\
 	container_of(ptp, struct hellcreek, ptp_clock_info)
-- 
2.20.1

