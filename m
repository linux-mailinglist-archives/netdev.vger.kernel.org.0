Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F86C649C20
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiLLK2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiLLK1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:27:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D199F007;
        Mon, 12 Dec 2022 02:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670840856; x=1702376856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Rf2dUVUWRFdYHuwbmTUWUPOitJzxN4qaf/xQoXemA0=;
  b=L+bX5RQUZgdcph9i8w715ko9ZxDAx8L8h3+4dHkZEtnbmndP0WxPOG+Q
   IcPk4gTda7iITQ0Pn/pcmnlj9qWJIeWvl+NPjsjruLPAU7VU+WFZ/rFjL
   pooeNyGdcNpcEQvBWzG68al5CgQzRlH99QYW623lJrIwyGtIhrw5dMSto
   DO7kSgJBrVWAAVmuzV59G87FF9x3IuYyH/akCJgtE2MqKzAhH27Sdmroq
   x1Zftgop/Wu6uy+MzAan57k34PXJ1MmICJobJbuT33hCnIZj0AigZwcX8
   TNH9c8TpP3pjUDy3W9IKsjjPTa4WQhHv/w59GRqht00HLTNWPjHtVY3cT
   w==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="187686611"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 03:27:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 03:27:18 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 03:27:12 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v4 02/13] net: dsa: microchip: ptp: Initial hardware time stamping support
Date:   Mon, 12 Dec 2022 15:56:28 +0530
Message-ID: <20221212102639.24415-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212102639.24415-1-arun.ramadoss@microchip.com>
References: <20221212102639.24415-1-arun.ramadoss@microchip.com>
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

From: Christian Eggers <ceggers@arri.de>

This patch adds the routine for get_ts_info, hwstamp_get, set. This enables
the PTP support towards userspace applications such as linuxptp.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
v1 -> v2
- Declared the ksz_hwtstamp_get/set to NULL as macro if ptp is not
enabled
- Removed mutex lock in hwtstamp_set()

RFC v2 -> Patch v1
- moved tagger set and get function to separate patch
- Removed unnecessary comments
---
 drivers/net/dsa/microchip/ksz_common.c |   3 +
 drivers/net/dsa/microchip/ksz_common.h |   3 +
 drivers/net/dsa/microchip/ksz_ptp.c    | 101 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h    |  11 +++
 4 files changed, 118 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index a1282347fdc6..81da650b70fb 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2978,6 +2978,9 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_pause_stats	= ksz_get_pause_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
+	.get_ts_info            = ksz_get_ts_info,
+	.port_hwtstamp_get      = ksz_hwtstamp_get,
+	.port_hwtstamp_set      = ksz_hwtstamp_set,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 23ed7fa72a3c..a5ce7ec30ba2 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -102,6 +102,9 @@ struct ksz_port {
 	struct ksz_device *ksz_dev;
 	struct ksz_irq pirq;
 	u8 num;
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
+	struct hwtstamp_config tstamp_config;
+#endif
 };
 
 struct ksz_device {
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 2da9b2ec0c40..34cc6d92c4c8 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -24,6 +24,107 @@
 #define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
 #define KSZ_PTP_SUBNS_BITS 32
 
+/* The function is return back the capability of timestamping feature when
+ * requested through ethtool -T <interface> utility
+ */
+int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
+{
+	struct ksz_device *dev	= ds->priv;
+	struct ksz_ptp_data *ptp_data;
+
+	ptp_data = &dev->ptp_data;
+
+	if (!ptp_data->clock)
+		return -ENODEV;
+
+	ts->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+			      SOF_TIMESTAMPING_RX_HARDWARE |
+			      SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	ts->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ONESTEP_P2P);
+
+	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			 BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+			 BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			 BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	ts->phc_index = ptp_clock_index(ptp_data->clock);
+
+	return 0;
+}
+
+int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct ksz_device *dev = ds->priv;
+	struct hwtstamp_config *config;
+	struct ksz_port *prt;
+
+	prt = &dev->ports[port];
+	config = &prt->tstamp_config;
+
+	return copy_to_user(ifr->ifr_data, config, sizeof(*config)) ?
+		-EFAULT : 0;
+}
+
+static int ksz_set_hwtstamp_config(struct ksz_device *dev,
+				   struct hwtstamp_config *config)
+{
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_OFF:
+	case HWTSTAMP_TX_ONESTEP_P2P:
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+	default:
+		config->rx_filter = HWTSTAMP_FILTER_NONE;
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct ksz_device *dev = ds->priv;
+	struct hwtstamp_config config;
+	struct ksz_port *prt;
+	int ret;
+
+	prt = &dev->ports[port];
+
+	ret = copy_from_user(&config, ifr->ifr_data, sizeof(config));
+	if (ret)
+		return ret;
+
+	ret = ksz_set_hwtstamp_config(dev, &config);
+	if (ret)
+		return ret;
+
+	memcpy(&prt->tstamp_config, &config, sizeof(config));
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config));
+}
+
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
 {
 	u32 nanoseconds;
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 8930047da764..7bb3fde2dd14 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -23,6 +23,11 @@ int ksz_ptp_clock_register(struct dsa_switch *ds);
 
 void ksz_ptp_clock_unregister(struct dsa_switch *ds);
 
+int ksz_get_ts_info(struct dsa_switch *ds, int port,
+		    struct ethtool_ts_info *ts);
+int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
+int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
+
 #else
 
 struct ksz_ptp_data {
@@ -37,6 +42,12 @@ static inline int ksz_ptp_clock_register(struct dsa_switch *ds)
 
 static inline void ksz_ptp_clock_unregister(struct dsa_switch *ds) { }
 
+#define ksz_get_ts_info NULL
+
+#define ksz_hwtstamp_get NULL
+
+#define ksz_hwtstamp_set NULL
+
 #endif	/* End of CONFIG_NET_DSA_MICROCHIP_KSZ_PTP */
 
 #endif
-- 
2.36.1

