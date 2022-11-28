Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B691D63A624
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiK1Kdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiK1KdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:33:19 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE99165BF;
        Mon, 28 Nov 2022 02:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669631595; x=1701167595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0jWyCeJ8WBlrBWXB2TOdnjMx3E3TGNkmMzFIqVKoNmA=;
  b=g4rI7Gsedncb9kPuFjYwTPcYFzBntTZTOy4jvUdxT3FcoiyEkyMyfIHv
   z6mk6ofMpU9jw+EqelQKkfx63c/xepaGCO208LvDqaAHxRi28zU45jceX
   pwPamR8a5Eu1n638tRnCzx338OannrKUv6PR5c9Ncb9x73j833GGNX9wb
   NrvN4oIw2zNH2r+r4jK3+HUE6TGwwdASA/KCfi1+7YkGrC7IbxGuMzDAu
   dvp90FeoWia7UOhhPJzhEXS1qb6/Y10wHXCgF54Bymm2gma29J2NCmr0w
   uKYi8SgV7539Jio3Hju4+ufBuOVf/eX7uo9MWpNibQ+YNJBXEEFLVlP8P
   g==;
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="125375559"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 03:33:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 03:33:13 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 28 Nov 2022 03:33:07 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v1 02/12] net: dsa: microchip: ptp: Initial hardware time stamping support
Date:   Mon, 28 Nov 2022 16:02:17 +0530
Message-ID: <20221128103227.23171-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221128103227.23171-1-arun.ramadoss@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

This patch adds the routine for get_ts_info, hwstamp_get, set. This enables
the PTP support towards userspace applications such as linuxptp.
Tx timestamping can be enabled per port and Rx timestamping enabled
globally.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

---
RFC v2 -> Patch v1
- moved tagger set and get function to separate patch
- Removed unnecessary comments
---
 drivers/net/dsa/microchip/ksz_common.c |  2 +
 drivers/net/dsa/microchip/ksz_common.h |  4 ++
 drivers/net/dsa/microchip/ksz_ptp.c    | 77 +++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_ptp.h    | 14 +++++
 4 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 2d09cd141db6..7b85b258270c 100644
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
index 5a6bfd42c6f9..cd20f39a565f 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -103,6 +103,10 @@ struct ksz_port {
 	struct ksz_device *ksz_dev;
 	struct ksz_irq pirq;
 	u8 num;
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
+	u8 hwts_tx_en;
+	bool hwts_rx_en;
+#endif
 };
 
 struct ksz_device {
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index c737635ca266..a41418c6adf6 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -36,15 +36,88 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
 			      SOF_TIMESTAMPING_RX_HARDWARE |
 			      SOF_TIMESTAMPING_RAW_HARDWARE;
 
-	ts->tx_types = BIT(HWTSTAMP_TX_OFF);
+	ts->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ONESTEP_P2P);
 
-	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
+	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
 
 	ts->phc_index = ptp_clock_index(ptp_data->clock);
 
 	return 0;
 }
 
+int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct ksz_device *dev = ds->priv;
+	struct hwtstamp_config config;
+
+	config.flags = 0;
+
+	config.tx_type = dev->ports[port].hwts_tx_en;
+
+	if (dev->ports[port].hwts_rx_en)
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
+	struct ksz_port *prt = &dev->ports[port];
+
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_OFF:
+	case HWTSTAMP_TX_ONESTEP_P2P:
+		prt->hwts_tx_en = config->tx_type;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		prt->hwts_rx_en = false;
+		break;
+	default:
+		prt->hwts_rx_en = true;
+		break;
+	}
+
+	return 0;
+}
+
+int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_ptp_data *ptp_data;
+	struct hwtstamp_config config;
+	int ret;
+
+	ptp_data = &dev->ptp_data;
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
+	ret = copy_to_user(ifr->ifr_data, &config, sizeof(config));
+
+error_return:
+	mutex_unlock(&ptp_data->lock);
+	return ret;
+}
+
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
 {
 	u32 nanoseconds;
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index ea9fa46caa01..17f455c3b2c5 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -23,6 +23,8 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds);
 
 int ksz_get_ts_info(struct dsa_switch *ds, int port,
 		    struct ethtool_ts_info *ts);
+int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
+int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
 
 #else
 
@@ -40,6 +42,18 @@ static inline void ksz_ptp_clock_unregister(struct dsa_switch *ds) { }
 
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
 #endif	/* End of CONFIG_NET_DSA_MICROCHIP_KSZ_PTP */
 
 #endif
-- 
2.36.1

