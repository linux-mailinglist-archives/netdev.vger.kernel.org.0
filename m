Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DC065AD17
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 06:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjABFG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 00:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjABFGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 00:06:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE3AC28;
        Sun,  1 Jan 2023 21:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672635967; x=1704171967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0udMVPME6WpisXTQkgjIwfBIfnpIGKXyIXlCgDgmGFk=;
  b=O9x+BX7GTL2b/iewu2+ccQYFKQgCMwdTvH7MGMxZwtPijPi7fnHVTE3K
   SKYwmRtmRPdlvKFdVyLt218wv+dh2SQbzsx9YQFND6+mYeLFHZycIBr2L
   AS4PD7N+chT6EbLOqLNyAZv2a0YI+jZzmdyiT3yeIRkghfofhWC4KmsZE
   pcmoZKUle9CzUXjkOpdUeINOBXHQEwMef8zk4CV6IS4z9jj9iE+gBl5sc
   RZN7gEaRdapuaIQUhVwJ0kkKLj3CQxHyqWX0dx30vjiVc7qZlSRBJRkjS
   ZgjB938RMpoocxoJUBmeCEQvtcZv/7jI12GAYqtBf8FWupNSwM8Kml9Yi
   A==;
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="190347393"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jan 2023 22:06:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 1 Jan 2023 22:06:04 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Sun, 1 Jan 2023 22:05:58 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>,
        <jacob.e.keller@intel.com>
Subject: [Patch net-next v6 03/13] net: dsa: microchip: ptp: add 4 bytes in tail tag when ptp enabled
Date:   Mon, 2 Jan 2023 10:34:49 +0530
Message-ID: <20230102050459.31023-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230102050459.31023-1-arun.ramadoss@microchip.com>
References: <20230102050459.31023-1-arun.ramadoss@microchip.com>
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

When the PTP is enabled in hardware bit 6 of PTP_MSG_CONF1 register, the
transmit frame needs additional 4 bytes before the tail tag. It is
needed for all the transmission packets irrespective of PTP packets or
not.
The 4-byte timestamp field is 0 for frames other than Pdelay_Resp. For
the one-step Pdelay_Resp, the switch needs the receive timestamp of the
Pdelay_Req message so that it can put the turnaround time in the
correction field.
Since PTP has to be enabled for both Transmission and reception
timestamping, driver needs to track of the tx and rx setting of the all
the user ports in the switch.
Two flags hw_tx_en and hw_rx_en are added in ksz_port to track the
timestampping setting of each port. When any one of ports has tx or rx
timestampping enabled, bit 6 of PTP_MSG_CONF1 is set and it is indicated
to tag_ksz.c through tagger bytes. This flag adds 4 additional bytes to
the tail tag.  When tx and rx timestamping of all the ports are disabled,
then 4 bytes are not added.

Testing using hwstamp -i <interface>

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com> # mostly api
---
v1 - v2
- check patch warning for line exceeding 80
- Removed the tagger_get_state function
- Added the 4 additional bytes to tail tag based on the all the ports tx
and rx timestamping

Patch v1
- Patch is new
---
 MAINTAINERS                            |  1 +
 drivers/net/dsa/microchip/ksz_common.h |  2 +
 drivers/net/dsa/microchip/ksz_ptp.c    | 34 ++++++++-
 include/linux/dsa/ksz_common.h         | 22 ++++++
 net/dsa/tag_ksz.c                      | 95 ++++++++++++++++++++++++--
 5 files changed, 145 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/dsa/ksz_common.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f0b7181e60a..b5bdee564e34 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13709,6 +13709,7 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
 F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 F:	drivers/net/dsa/microchip/*
+F:	include/linux/dsa/ksz_common.h
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a5ce7ec30ba2..641aca78ef05 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -104,6 +104,8 @@ struct ksz_port {
 	u8 num;
 #if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
 	struct hwtstamp_config tstamp_config;
+	bool hwts_tx_en;
+	bool hwts_rx_en;
 #endif
 };
 
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 280200b37012..8be03095e061 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2022 Microchip Technology Inc.
  */
 
+#include <linux/dsa/ksz_common.h>
 #include <linux/kernel.h>
 #include <linux/ptp_classify.h>
 #include <linux/ptp_clock_kernel.h>
@@ -24,6 +25,27 @@
 #define KSZ_PTP_INC_NS 40ULL  /* HW clock is incremented every 40 ns (by 40) */
 #define KSZ_PTP_SUBNS_BITS 32
 
+static int ksz_ptp_enable_mode(struct ksz_device *dev)
+{
+	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dev->ds);
+	struct ksz_port *prt;
+	struct dsa_port *dp;
+	bool tag_en = false;
+
+	dsa_switch_for_each_user_port(dp, dev->ds) {
+		prt = &dev->ports[dp->index];
+		if (prt->hwts_tx_en || prt->hwts_rx_en) {
+			tag_en = true;
+			break;
+		}
+	}
+
+	tagger_data->hwtstamp_set_state(dev->ds, tag_en);
+
+	return ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_ENABLE,
+			 tag_en ? PTP_ENABLE : 0);
+}
+
 /* The function is return back the capability of timestamping feature when
  * requested through ethtool -T <interface> utility
  */
@@ -67,6 +89,7 @@ int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 }
 
 static int ksz_set_hwtstamp_config(struct ksz_device *dev,
+				   struct ksz_port *prt,
 				   struct hwtstamp_config *config)
 {
 	if (config->flags)
@@ -74,7 +97,10 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
 
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
+		prt->hwts_tx_en = false;
+		break;
 	case HWTSTAMP_TX_ONESTEP_P2P:
+		prt->hwts_tx_en = true;
 		break;
 	default:
 		return -ERANGE;
@@ -82,25 +108,29 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
 
 	switch (config->rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
+		prt->hwts_rx_en = false;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+		prt->hwts_rx_en = true;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
 		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+		prt->hwts_rx_en = true;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		prt->hwts_rx_en = true;
 		break;
 	default:
 		config->rx_filter = HWTSTAMP_FILTER_NONE;
 		return -ERANGE;
 	}
 
-	return 0;
+	return ksz_ptp_enable_mode(dev);
 }
 
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
@@ -116,7 +146,7 @@ int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 	if (ret)
 		return ret;
 
-	ret = ksz_set_hwtstamp_config(dev, &config);
+	ret = ksz_set_hwtstamp_config(dev, prt, &config);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
new file mode 100644
index 000000000000..d2a54161be97
--- /dev/null
+++ b/include/linux/dsa/ksz_common.h
@@ -0,0 +1,22 @@
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
index 080e5c369f5b..420a12853676 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2017 Microchip Technology
  */
 
+#include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <net/dsa.h>
@@ -16,9 +17,58 @@
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
+	tagger_data->hwtstamp_set_state = ksz_hwtstamp_set_state;
+	ds->tagger_data = priv;
+
+	return 0;
+}
+
 static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 				      struct net_device *dev,
 				      unsigned int port, unsigned int len)
@@ -92,10 +142,12 @@ DSA_TAG_DRIVER(ksz8795_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 
 /*
- * For Ingress (Host -> KSZ9477), 2 bytes are added before FCS.
+ * For Ingress (Host -> KSZ9477), 2/6 bytes are added before FCS.
  * ---------------------------------------------------------------------------
- * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|tag1(1byte)|
+ * FCS(4bytes)
  * ---------------------------------------------------------------------------
+ * ts   : time stamp (Present only if PTP is enabled in the Hardware)
  * tag0 : Prioritization (not used now)
  * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x10=port5)
  *
@@ -114,6 +166,21 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
 
+/* Time stamp tag *needs* to be inserted if PTP is enabled in hardware.
+ * Regardless of Whether it is a PTP frame or not.
+ */
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
@@ -126,6 +193,8 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 		return NULL;
 
 	/* Tag encoding */
+	ksz_xmit_timestamp(dp, skb);
+
 	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -158,7 +227,9 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9477,
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
-	.needed_tailroom = KSZ9477_INGRESS_TAG_LEN,
+	.connect = ksz_connect,
+	.disconnect = ksz_disconnect,
+	.needed_tailroom = KSZ9477_INGRESS_TAG_LEN + KSZ_PTP_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(ksz9477_netdev_ops);
@@ -178,6 +249,8 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 		return NULL;
 
 	/* Tag encoding */
+	ksz_xmit_timestamp(dp, skb);
+
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -194,16 +267,20 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
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
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|tag1(1byte)|
+ * FCS(4bytes)
  * ---------------------------------------------------------------------------
+ * ts   : time stamp (Present only if PTP is enabled in the Hardware)
  * tag0 : represents tag override, lookup and valid
  * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x80=port8)
  *
@@ -232,6 +309,8 @@ static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
 		return NULL;
 
+	ksz_xmit_timestamp(dp, skb);
+
 	tag = skb_put(skb, LAN937X_EGRESS_TAG_LEN);
 
 	val = BIT(dp->index);
@@ -252,7 +331,9 @@ static const struct dsa_device_ops lan937x_netdev_ops = {
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

