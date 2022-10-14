Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0BF5FF15F
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiJNP3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiJNP3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:29:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2043C1D5869;
        Fri, 14 Oct 2022 08:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1665761371; x=1697297371;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n94UfcLFyhyFfsXtdP6iBggIHqYSJYVNV6N2/pYkpEg=;
  b=W9RNDZQTNdcHTQMbWxNJpo9A5C6++sR77bmcK/F3rlct7tywgVGsnqwT
   CJ2h3c19X3zhEPkcPn4AWgK64DtQE9Y7IYZCbSHhnPI1srOs2sWH6nYnm
   OXytYFyRMhdzrIKklakaxUMf3Tuz5QmPLnnxSIApPaAZ82A3YBczWZHZo
   vhjr9E75Pn+Bksb22xVcruAF4W+EJt7SUrmMmDRe1eR8aZvnBlUZoDnlX
   dy3KVZfZ7se2VtK9Q9/r/VwmDzLpcmMF1rOvBnkuU5gJ00Yra3OksGgLB
   PH8J+wa+EQemQU8i7sgfJXS2qWY3atbHnHbqSoGkK6nSBM5+rYKcuhEcu
   A==;
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="195427833"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2022 08:29:29 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 14 Oct 2022 08:29:29 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 14 Oct 2022 08:29:24 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next 2/6] net: dsa: microchip: Initial hardware time stamping support
Date:   Fri, 14 Oct 2022 20:58:53 +0530
Message-ID: <20221014152857.32645-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221014152857.32645-1-arun.ramadoss@microchip.com>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the routine for get_ts_info, hwstamp_get, set. This enables
the PTP support towards userspace applications such as linuxptp.
Tx timestamping can be enabled per port and Rx timestamping enabled
globally.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c |   2 +
 drivers/net/dsa/microchip/ksz_common.h |   3 +
 drivers/net/dsa/microchip/ksz_ptp.c    | 111 ++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_ptp.h    |  14 ++++
 include/linux/dsa/ksz_common.h         |  23 +++++
 net/dsa/tag_ksz.c                      |  59 +++++++++++++
 6 files changed, 210 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/dsa/ksz_common.h

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 084563e80660..d8ec5b641b89 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2843,6 +2843,8 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 	.get_ts_info            = ksz_get_ts_info,
+	.port_hwtstamp_get      = ksz_hwtstamp_get,
+	.port_hwtstamp_set      = ksz_hwtstamp_set,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f936a4100423..0e5f02d3992e 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -104,6 +104,9 @@ struct ksz_port {
 	struct ksz_device *ksz_dev;
 	struct ksz_irq pirq;
 	u8 num;
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
+	bool hwts_tx_en;
+#endif
 };
 
 struct ksz_device {
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 0ead0e097ed5..5199840377aa 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2021-2022 Microchip Technology Inc.
  */
 
+#include <linux/dsa/ksz_common.h>
 #include <linux/kernel.h>
 #include <linux/ptp_classify.h>
 #include <linux/ptp_clock_kernel.h>
@@ -21,6 +22,17 @@
 #define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
 #define KSZ_PTP_SUBNS_BITS 32  /* Number of bits in sub-nanoseconds counter */
 
+static int ksz_ptp_enable_mode(struct ksz_device *dev, bool enable)
+{
+	u16 data = 0;
+
+	/* Enable PTP mode */
+	if (enable)
+		data = PTP_ENABLE;
+
+	return ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_ENABLE, data);
+}
+
 /* The function is return back the capability of timestamping feature when
  * requested through ethtool -T <interface> utility
  */
@@ -33,15 +45,110 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
 			      SOF_TIMESTAMPING_RX_HARDWARE |
 			      SOF_TIMESTAMPING_RAW_HARDWARE;
 
-	ts->tx_types = (1 << HWTSTAMP_TX_OFF);
+	ts->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
 
-	ts->rx_filters = (1 << HWTSTAMP_FILTER_NONE);
+	ts->rx_filters =
+		(1 << HWTSTAMP_FILTER_NONE) | (1 << HWTSTAMP_FILTER_ALL);
 
 	ts->phc_index = ptp_clock_index(ptp_data->clock);
 
 	return 0;
 }
 
+int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct ksz_tagger_data *tagger_data = ksz_tagger_data(ds);
+	struct ksz_device *dev = ds->priv;
+	struct hwtstamp_config config;
+
+	config.flags = 0;
+
+	if (dev->ports[port].hwts_tx_en)
+		config.tx_type = HWTSTAMP_TX_ON;
+	else
+		config.tx_type = HWTSTAMP_TX_OFF;
+
+	if (tagger_data->hwtstamp_get_state(ds))
+		config.rx_filter = HWTSTAMP_FILTER_ALL;
+	else
+		config.rx_filter = HWTSTAMP_FILTER_NONE;
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
+static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
+				   struct hwtstamp_config *config)
+{
+	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dev->ds);
+	struct ksz_port *prt = &dev->ports[port];
+	bool rx_on;
+
+	/* reserved for future extensions */
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_OFF:
+		prt->hwts_tx_en = false;
+		break;
+	case HWTSTAMP_TX_ON:
+		prt->hwts_tx_en = true;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		rx_on = false;
+		break;
+	default:
+		rx_on = true;
+		break;
+	}
+
+	if (rx_on != tagger_data->hwtstamp_get_state(dev->ds)) {
+		int ret;
+
+		tagger_data->hwtstamp_set_state(dev->ds, false);
+
+		ret = ksz_ptp_enable_mode(dev, rx_on);
+		if (ret)
+			return ret;
+
+		if (rx_on)
+			tagger_data->hwtstamp_set_state(dev->ds, true);
+	}
+
+	return 0;
+}
+
+int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+	struct hwtstamp_config config;
+	int ret;
+
+	mutex_lock(&ptp_data->lock);
+
+	ret = copy_from_user(&config, ifr->ifr_data, sizeof(config));
+	if (ret)
+		goto error_return;
+
+	ret = ksz_set_hwtstamp_config(dev, port, &config);
+	if (ret)
+		goto error_return;
+
+	/* Save the chosen configuration to be returned later. */
+	ret = copy_to_user(ifr->ifr_data, &config, sizeof(config));
+
+error_return:
+	mutex_unlock(&ptp_data->lock);
+	return ret;
+}
+
 /* These are function related to the ptp clock info */
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
 {
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index ac53b0df2733..4c024cc9d935 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -21,6 +21,8 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds);
 
 int ksz_get_ts_info(struct dsa_switch *ds, int port,
 		    struct ethtool_ts_info *ts);
+int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
+int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
 
 #else
 
@@ -38,6 +40,18 @@ static inline void ksz_ptp_clock_unregister(struct dsa_switch *ds) { }
 
 #define ksz_get_ts_info NULL
 
+static inline int ksz_hwtstamp_get(struct dsa_switch *ds, int port,
+				   struct ifreq *ifr)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ksz_hwtstamp_set(struct dsa_switch *ds, int port,
+				   struct ifreq *ifr)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif	/* End of CONFIG_NET_DSA_MICROCHIOP_KSZ_PTP */
 
 #endif
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
new file mode 100644
index 000000000000..8903bce4753b
--- /dev/null
+++ b/include/linux/dsa/ksz_common.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip switch tag common header
+ *
+ * Copyright (C) 2021-2022 Microchip Technology Inc.
+ */
+
+#ifndef _NET_DSA_KSZ_COMMON_H_
+#define _NET_DSA_KSZ_COMMON_H_
+
+#include <net/dsa.h>
+
+struct ksz_tagger_data {
+	bool (*hwtstamp_get_state)(struct dsa_switch *ds);
+	void (*hwtstamp_set_state)(struct dsa_switch *ds, bool on);
+};
+
+static inline struct ksz_tagger_data *
+ksz_tagger_data(struct dsa_switch *ds)
+{
+	return ds->tagger_data;
+}
+
+#endif /* _NET_DSA_KSZ_COMMON_H_ */
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 38fa19c1e2d5..ca1261b04fe7 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2017 Microchip Technology
  */
 
+#include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <net/dsa.h>
@@ -13,6 +14,62 @@
 #define KSZ_EGRESS_TAG_LEN		1
 #define KSZ_INGRESS_TAG_LEN		1
 
+#define KSZ_HWTS_EN  0
+
+struct ksz_tagger_private {
+	struct ksz_tagger_data data; /* Must be first */
+	unsigned long state;
+};
+
+static struct ksz_tagger_private *
+ksz_tagger_private(struct dsa_switch *ds)
+{
+	return ds->tagger_data;
+}
+
+static bool ksz_hwtstamp_get_state(struct dsa_switch *ds)
+{
+	struct ksz_tagger_private *priv = ksz_tagger_private(ds);
+
+	return test_bit(KSZ_HWTS_EN, &priv->state);
+}
+
+static void ksz_hwtstamp_set_state(struct dsa_switch *ds, bool on)
+{
+	struct ksz_tagger_private *priv = ksz_tagger_private(ds);
+
+	if (on)
+		set_bit(KSZ_HWTS_EN, &priv->state);
+	else
+		clear_bit(KSZ_HWTS_EN, &priv->state);
+}
+
+static void ksz_disconnect(struct dsa_switch *ds)
+{
+	struct ksz_tagger_private *priv = ds->tagger_data;
+
+	kfree(priv);
+	ds->tagger_data = NULL;
+}
+
+static int ksz_connect(struct dsa_switch *ds)
+{
+	struct ksz_tagger_data *tagger_data;
+	struct ksz_tagger_private *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	/* Export functions for switch driver use */
+	tagger_data = &priv->data;
+	tagger_data->hwtstamp_get_state = ksz_hwtstamp_get_state;
+	tagger_data->hwtstamp_set_state = ksz_hwtstamp_set_state;
+	ds->tagger_data = priv;
+
+	return 0;
+}
+
 static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 				      struct net_device *dev,
 				      unsigned int port, unsigned int len)
@@ -245,6 +302,8 @@ static const struct dsa_device_ops lan937x_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_LAN937X,
 	.xmit	= lan937x_xmit,
 	.rcv	= ksz9477_rcv,
+	.connect = ksz_connect,
+	.disconnect = ksz_disconnect,
 	.needed_tailroom = LAN937X_EGRESS_TAG_LEN,
 };
 
-- 
2.36.1

