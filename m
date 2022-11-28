Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5147963A626
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiK1Kd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiK1Kdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:33:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94DD64F7;
        Mon, 28 Nov 2022 02:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669631607; x=1701167607;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wMKSq2q/W0rxs4b3EUijFn064uKZrYFjZjGvrT9dQCE=;
  b=csCtWppWbLJg49grSQQanmP7i1xNZAvhT/aLNRTB3Pkcnb64SAdKVwGY
   Rv5KxmocDjy1HPgvrCPJpHXX0WUQCTM673KewTjax82OldxcVHhx/kpQA
   TVsREWX6TJb2RplG6Fn1u///Z1OHb0F5fsXZOguyQtwL0BbTP7oxZjmOY
   Gpb62CgSlPT/RdfpWbVIcJABm3EQtQ2s04m/xi1i8iumfWGB0WIt1RnDE
   t3b8I0az0B9r0EtBC3/jBEJ7CuJhuXlUubTlGChjy0cEpi0kip1aBwkB7
   dKcVIDDn3UOlfdB3M+v8/0P+ukwB0vVyCFnvGdEZTC9vc5jqHM2fNIkz7
   w==;
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="185453903"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 03:33:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 03:33:23 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 28 Nov 2022 03:33:18 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v1 03/12] net: dsa: microchip: ptp: add 4 bytes in tail tag when ptp enabled
Date:   Mon, 28 Nov 2022 16:02:18 +0530
Message-ID: <20221128103227.23171-4-arun.ramadoss@microchip.com>
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

If PTP is enabled in the hardware, then 4 bytes are added in the tail
tag. When PTP is enabled and 4 bytes are not added then messages are
corrupted.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
Patch v1
- Patch is new
---
 MAINTAINERS                            |  1 +
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 drivers/net/dsa/microchip/ksz_ptp.c    | 24 +++++--
 include/linux/dsa/ksz_common.h         | 23 ++++++
 net/dsa/tag_ksz.c                      | 99 ++++++++++++++++++++++++--
 5 files changed, 136 insertions(+), 12 deletions(-)
 create mode 100644 include/linux/dsa/ksz_common.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 61fe86968111..721d2c5dfa46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13515,6 +13515,7 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
 F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 F:	drivers/net/dsa/microchip/*
+F:	include/linux/dsa/ksz_common.h
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index cd20f39a565f..4c5b35a7883c 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -105,7 +105,6 @@ struct ksz_port {
 	u8 num;
 #if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
 	u8 hwts_tx_en;
-	bool hwts_rx_en;
 #endif
 };
 
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index a41418c6adf6..184aa57a8489 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2022 Microchip Technology Inc.
  */
 
+#include <linux/dsa/ksz_common.h>
 #include <linux/kernel.h>
 #include <linux/ptp_classify.h>
 #include <linux/ptp_clock_kernel.h>
@@ -19,6 +20,16 @@
 #define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
 #define KSZ_PTP_SUBNS_BITS 32
 
+static int ksz_ptp_enable_mode(struct ksz_device *dev, bool enable)
+{
+	u16 data = 0;
+
+	if (enable)
+		data = PTP_ENABLE;
+
+	return ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_ENABLE, data);
+}
+
 /* The function is return back the capability of timestamping feature when
  * requested through ethtool -T <interface> utility
  */
@@ -47,6 +58,7 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
 
 int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 {
+	struct ksz_tagger_data *tagger_data = ksz_tagger_data(ds);
 	struct ksz_device *dev = ds->priv;
 	struct hwtstamp_config config;
 
@@ -54,7 +66,7 @@ int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 
 	config.tx_type = dev->ports[port].hwts_tx_en;
 
-	if (dev->ports[port].hwts_rx_en)
+	if (tagger_data->hwtstamp_get_state(ds))
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
 	else
 		config.rx_filter = HWTSTAMP_FILTER_NONE;
@@ -66,7 +78,9 @@ int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
 				   struct hwtstamp_config *config)
 {
+	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dev->ds);
 	struct ksz_port *prt = &dev->ports[port];
+	bool rx_on;
 
 	if (config->flags)
 		return -EINVAL;
@@ -82,14 +96,16 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
 
 	switch (config->rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
-		prt->hwts_rx_en = false;
+		rx_on = false;
 		break;
 	default:
-		prt->hwts_rx_en = true;
+		rx_on = true;
 		break;
 	}
 
-	return 0;
+	tagger_data->hwtstamp_set_state(dev->ds, rx_on);
+
+	return ksz_ptp_enable_mode(dev, rx_on);
 }
 
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
new file mode 100644
index 000000000000..62996860b887
--- /dev/null
+++ b/include/linux/dsa/ksz_common.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip switch tag common header
+ *
+ * Copyright (C) 2022 Microchip Technology Inc.
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
index 0f6ae143afc9..828af38f0598 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2017 Microchip Technology
  */
 
+#include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <net/dsa.h>
@@ -16,9 +17,66 @@
 #define LAN937X_NAME "lan937x"
 
 /* Typically only one byte is used for tail tag. */
+#define KSZ_PTP_TAG_LEN			4
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
@@ -91,10 +149,11 @@ DSA_TAG_DRIVER(ksz8795_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 
 /*
- * For Ingress (Host -> KSZ9477), 2 bytes are added before FCS.
+ * For Ingress (Host -> KSZ9477), 2/6 bytes are added before FCS.
  * ---------------------------------------------------------------------------
- * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
  * ---------------------------------------------------------------------------
+ * ts   : time stamp (Present only if PTP is enabled in the Hardware)
  * tag0 : Prioritization (not used now)
  * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x10=port5)
  *
@@ -113,6 +172,19 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
 
+/* Time stamp tag is only inserted if PTP is enabled in hardware. */
+static void ksz_xmit_timestamp(struct dsa_port *dp, struct sk_buff *skb)
+{
+	struct ksz_tagger_private *priv;
+
+	priv = ksz_tagger_private(dp->ds);
+
+	if (!test_bit(KSZ_HWTS_EN, &priv->state))
+		return;
+
+	put_unaligned_be32(0, skb_put(skb, KSZ_PTP_TAG_LEN));
+}
+
 static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
@@ -125,6 +197,8 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 		return NULL;
 
 	/* Tag encoding */
+	ksz_xmit_timestamp(dp, skb);
+
 	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -157,7 +231,9 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9477,
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
-	.needed_tailroom = KSZ9477_INGRESS_TAG_LEN,
+	.connect = ksz_connect,
+	.disconnect = ksz_disconnect,
+	.needed_tailroom = KSZ9477_INGRESS_TAG_LEN + KSZ_PTP_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(ksz9477_netdev_ops);
@@ -177,6 +253,8 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 		return NULL;
 
 	/* Tag encoding */
+	ksz_xmit_timestamp(dp, skb);
+
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -193,16 +271,19 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9893,
 	.xmit	= ksz9893_xmit,
 	.rcv	= ksz9477_rcv,
-	.needed_tailroom = KSZ_INGRESS_TAG_LEN,
+	.connect = ksz_connect,
+	.disconnect = ksz_disconnect,
+	.needed_tailroom = KSZ_INGRESS_TAG_LEN + KSZ_PTP_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893, KSZ9893_NAME);
 
-/* For xmit, 2 bytes are added before FCS.
+/* For xmit, 2/6 bytes are added before FCS.
  * ---------------------------------------------------------------------------
- * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
  * ---------------------------------------------------------------------------
+ * ts   : time stamp (Present only if PTP is enabled in the Hardware)
  * tag0 : represents tag override, lookup and valid
  * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x80=port8)
  *
@@ -231,6 +312,8 @@ static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
 		return NULL;
 
+	ksz_xmit_timestamp(dp, skb);
+
 	tag = skb_put(skb, LAN937X_EGRESS_TAG_LEN);
 
 	val = BIT(dp->index);
@@ -251,7 +334,9 @@ static const struct dsa_device_ops lan937x_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_LAN937X,
 	.xmit	= lan937x_xmit,
 	.rcv	= ksz9477_rcv,
-	.needed_tailroom = LAN937X_EGRESS_TAG_LEN,
+	.connect = ksz_connect,
+	.disconnect = ksz_disconnect,
+	.needed_tailroom = LAN937X_EGRESS_TAG_LEN + KSZ_PTP_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(lan937x_netdev_ops);
-- 
2.36.1

