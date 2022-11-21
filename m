Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEB7632872
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbiKUPnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiKUPm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:42:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADEC9FD5;
        Mon, 21 Nov 2022 07:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669045367; x=1700581367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2/mXNQ798YfB8i1GOwnDOGQ4szNhlzwfH3mTpOh1dRs=;
  b=hTcE4JK9iIdQt5i5NGowz7u8zH5n96EefDTM8iGKrQ0/N0u8IkvQuVNI
   h1UPO5L8+oyNLsikZ7wT9XSkDYrlS2NjYxqJVqdcbLpwgsOMwk2OY+kUT
   w/S4/idcbKiiLGkzBC5xVVsPULwoj5RE8p3FZn6VPhRBcSZOcW+KTyeeU
   nnw4XthlwX6DJipRbUigBtz0Q5xD68s5NyRmf/YABr3ZhaRLDXpof0waK
   zSt7JpXC3SThMES6y4zN3ARPciQfBnj55fQvlYigLMHSrdr4En2lpqBds
   j/cDtdPqqGV6HOhAOIi9f6RniDJc99WJ3LdYZYAFviDRhEtwFNH/4goTE
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="184501140"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Nov 2022 08:42:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 21 Nov 2022 08:42:34 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 21 Nov 2022 08:42:30 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial hardware time stamping support
Date:   Mon, 21 Nov 2022 21:11:45 +0530
Message-ID: <20221121154150.9573-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221121154150.9573-1-arun.ramadoss@microchip.com>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the routine for get_ts_info, hwstamp_get, set. This enables
the PTP support towards userspace applications such as linuxptp.
Tx timestamping can be enabled per port and Rx timestamping enabled
globally.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c |   2 +
 drivers/net/dsa/microchip/ksz_common.h |   3 +
 drivers/net/dsa/microchip/ksz_ptp.c    | 115 ++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_ptp.h    |  14 +++
 include/linux/dsa/ksz_common.h         |  23 +++++
 net/dsa/tag_ksz.c                      |  63 ++++++++++++++
 6 files changed, 218 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/dsa/ksz_common.h

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index eb77eca0dcb2..0abbb2ebcd00 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2873,6 +2873,8 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 	.get_ts_info            = ksz_get_ts_info,
+	.port_hwtstamp_get      = ksz_hwtstamp_get,
+	.port_hwtstamp_set      = ksz_hwtstamp_set,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 767f17d2c75d..605d0a295288 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -104,6 +104,9 @@ struct ksz_port {
 	struct ksz_device *ksz_dev;
 	struct ksz_irq pirq;
 	u8 num;
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
+	u8 hwts_tx_en;
+#endif
 };
 
 struct ksz_device {
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index cad0c6087419..1b2880d013ed 100644
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
@@ -33,15 +45,114 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
 			      SOF_TIMESTAMPING_RX_HARDWARE |
 			      SOF_TIMESTAMPING_RAW_HARDWARE;
 
-	ts->tx_types = (1 << HWTSTAMP_TX_OFF);
+	ts->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ONESTEP_P2P);
+
+	if (is_lan937x(dev))
+		ts->tx_types |= (1 << HWTSTAMP_TX_ON);
 
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
+	config.tx_type = dev->ports[port].hwts_tx_en;
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
+	case HWTSTAMP_TX_ONESTEP_P2P:
+		prt->hwts_tx_en = config->tx_type;
+		break;
+	case HWTSTAMP_TX_ON:
+		if (!is_lan937x(dev))
+			return -ERANGE;
+
+		prt->hwts_tx_en = config->tx_type;
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
index 37db5156f9a3..6a909a300c13 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2017 Microchip Technology
  */
 
+#include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <net/dsa.h>
@@ -18,6 +19,62 @@
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
@@ -156,6 +213,8 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9477,
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
+	.connect = ksz_connect,
+	.disconnect = ksz_disconnect,
 	.needed_tailroom = KSZ9477_INGRESS_TAG_LEN,
 };
 
@@ -192,6 +251,8 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9893,
 	.xmit	= ksz9893_xmit,
 	.rcv	= ksz9477_rcv,
+	.connect = ksz_connect,
+	.disconnect = ksz_disconnect,
 	.needed_tailroom = KSZ_INGRESS_TAG_LEN,
 };
 
@@ -250,6 +311,8 @@ static const struct dsa_device_ops lan937x_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_LAN937X,
 	.xmit	= lan937x_xmit,
 	.rcv	= ksz9477_rcv,
+	.connect = ksz_connect,
+	.disconnect = ksz_disconnect,
 	.needed_tailroom = LAN937X_EGRESS_TAG_LEN,
 };
 
-- 
2.36.1

