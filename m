Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9623C643FA0
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiLFJRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234775AbiLFJQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:16:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C16220D0;
        Tue,  6 Dec 2022 01:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670318170; x=1701854170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ecrji5uCWrkNK69EOmTNj7B1zBCRiPXsZCDK3ABXBEM=;
  b=tvPdO0oHE7Kx+Ujq3Bu+WWh77ByiYcgW6V7kBR+sajhZi9l06e2ljtjN
   XYpxyclYCttaqSrccaKunTQLoyWzBDirKhB/VIGccaZewF26F5DOnH+i9
   oVdyCn10agsm7eqjpaJxH5kUjsJIIba0wVfO0wlRhMKskqfv/6ac8GBCg
   IPAR1BnJFfn2fhL0j94hH08/jVTNS0GXJ1ljqkAXj1NImxFwU9NxkvEsk
   QePJmnOcrMA0fVxaKkpsIGoqDrSKYUKCghd4lGH500qbKi6A7BnUWuijw
   1Yw3k+G/3IOj2Bog5Z/HK5VZnpAeYxjphGzb5l1N3rPPhr/TFOY2OIxCd
   A==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="190235708"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 02:16:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 02:16:05 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 02:15:59 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v2 07/13] net: dsa: microchip: ptp: add packet reception timestamping
Date:   Tue, 6 Dec 2022 14:44:22 +0530
Message-ID: <20221206091428.28285-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221206091428.28285-1-arun.ramadoss@microchip.com>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
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

This patch adds the routines for timestamping received ptp packets.
Whenever the ptp packet is received, the 4 byte hardware time stamped
value is append to its packet. This 4 byte value is extracted from the
tail tag and reconstructed to absolute time and assigned to skb
hwtstamp.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

---
v1 - v2
- Checkpatch warning line limit to 80chars

RFC v2 -> Patch v1
- Fixed compilation issue
---
 drivers/net/dsa/microchip/ksz_common.c | 13 +++++
 drivers/net/dsa/microchip/ksz_ptp.c    | 28 +++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h    |  3 ++
 include/linux/dsa/ksz_common.h         | 15 ++++++
 net/dsa/tag_ksz.c                      | 68 +++++++++++++++++++++++---
 5 files changed, 121 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9bfd7dd5cd31..306bdc1469d2 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2017-2019 Microchip Technology Inc.
  */
 
+#include <linux/dsa/ksz_common.h>
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/gpio/consumer.h>
@@ -2453,6 +2454,17 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 	return proto;
 }
 
+static int ksz_connect_tag_protocol(struct dsa_switch *ds,
+				    enum dsa_tag_protocol proto)
+{
+	struct ksz_tagger_data *tagger_data;
+
+	tagger_data = ksz_tagger_data(ds);
+	tagger_data->meta_tstamp_handler = ksz_tstamp_reconstruct;
+
+	return 0;
+}
+
 static int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
 				   bool flag, struct netlink_ext_ack *extack)
 {
@@ -2849,6 +2861,7 @@ static int ksz_switch_detect(struct ksz_device *dev)
 
 static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_tag_protocol	= ksz_get_tag_protocol,
+	.connect_tag_protocol   = ksz_connect_tag_protocol,
 	.get_phy_flags		= ksz_get_phy_flags,
 	.setup			= ksz_setup,
 	.teardown		= ksz_teardown,
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index abb89a36bf2d..d848549d1517 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -370,6 +370,34 @@ static int ksz_ptp_start_clock(struct ksz_device *dev)
 	return 0;
 }
 
+ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
+{
+	struct ksz_device *dev = ds->priv;
+	struct timespec64 ptp_clock_time;
+	struct ksz_ptp_data *ptp_data;
+	struct timespec64 diff;
+	struct timespec64 ts;
+
+	ptp_data = &dev->ptp_data;
+	ts = ktime_to_timespec64(tstamp);
+
+	spin_lock_bh(&ptp_data->clock_lock);
+	ptp_clock_time = ptp_data->clock_time;
+	spin_unlock_bh(&ptp_data->clock_lock);
+
+	/* calculate full time from partial time stamp */
+	ts.tv_sec = (ptp_clock_time.tv_sec & ~3) | ts.tv_sec;
+
+	/* find nearest possible point in time */
+	diff = timespec64_sub(ts, ptp_clock_time);
+	if (diff.tv_sec > 2)
+		ts.tv_sec -= 4;
+	else if (diff.tv_sec < -2)
+		ts.tv_sec += 4;
+
+	return timespec64_to_ktime(ts);
+}
+
 int ksz_ptp_clock_register(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 7c5679372705..d5ec4c842401 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -32,6 +32,7 @@ int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
 void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
+ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp);
 
 #else
 
@@ -60,6 +61,8 @@ static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
 
 #define ksz_hwtstamp_set NULL
 
+#define ksz_tstamp_reconstruct NULL
+
 #endif	/* End of CONFIG_NET_DSA_MICROCHIP_KSZ_PTP */
 
 #endif
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index d2a54161be97..019c13a8d89a 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -9,8 +9,23 @@
 
 #include <net/dsa.h>
 
+/* All time stamps from the KSZ consist of 2 bits for seconds and 30 bits for
+ * nanoseconds. This is NOT the same as 32 bits for nanoseconds.
+ */
+#define KSZ_TSTAMP_SEC_MASK  GENMASK(31, 30)
+#define KSZ_TSTAMP_NSEC_MASK GENMASK(29, 0)
+
+static inline ktime_t ksz_decode_tstamp(u32 tstamp)
+{
+	u64 ns = FIELD_GET(KSZ_TSTAMP_SEC_MASK, tstamp) * NSEC_PER_SEC +
+		 FIELD_GET(KSZ_TSTAMP_NSEC_MASK, tstamp);
+
+	return ns_to_ktime(ns);
+}
+
 struct ksz_tagger_data {
 	void (*hwtstamp_set_state)(struct dsa_switch *ds, bool on);
+	ktime_t (*meta_tstamp_handler)(struct dsa_switch *ds, ktime_t tstamp);
 };
 
 static inline struct ksz_tagger_data *
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index eb906f0b09aa..8936ba715627 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -7,6 +7,7 @@
 #include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
+#include <linux/ptp_classify.h>
 #include <net/dsa.h>
 
 #include "tag.h"
@@ -150,10 +151,11 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
  * tag0 : Prioritization (not used now)
  * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x10=port5)
  *
- * For Egress (KSZ9477 -> Host), 1 byte is added before FCS.
+ * For Egress (KSZ9477 -> Host), 1/5 bytes is added before FCS.
  * ---------------------------------------------------------------------------
- * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|FCS(4bytes)
  * ---------------------------------------------------------------------------
+ * ts   : time stamp (Present only if bit 7 of tag0 is set)
  * tag0 : zero-based value represents port
  *	  (eg, 0x00=port1, 0x02=port3, 0x06=port7)
  */
@@ -165,6 +167,57 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
 
+static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
+			      struct net_device *dev, unsigned int port)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	struct dsa_switch *ds = dev->dsa_ptr->ds;
+	u8 *tstamp_raw = tag - KSZ_PTP_TAG_LEN;
+	struct ksz_tagger_data *tagger_data;
+	struct ptp_header *ptp_hdr;
+	unsigned int ptp_type;
+	u8 ptp_msg_type;
+	ktime_t tstamp;
+	s64 correction;
+
+	tagger_data = ksz_tagger_data(ds);
+	if (!tagger_data->meta_tstamp_handler)
+		return;
+
+	/* convert time stamp and write to skb */
+	tstamp = ksz_decode_tstamp(get_unaligned_be32(tstamp_raw));
+	memset(hwtstamps, 0, sizeof(*hwtstamps));
+	hwtstamps->hwtstamp = tagger_data->meta_tstamp_handler(ds, tstamp);
+
+	if (skb_headroom(skb) < ETH_HLEN)
+		return;
+
+	__skb_push(skb, ETH_HLEN);
+	ptp_type = ptp_classify_raw(skb);
+	__skb_pull(skb, ETH_HLEN);
+
+	if (ptp_type == PTP_CLASS_NONE)
+		return;
+
+	ptp_hdr = ptp_parse_header(skb, ptp_type);
+	if (!ptp_hdr)
+		return;
+
+	ptp_msg_type = ptp_get_msgtype(ptp_hdr, ptp_type);
+	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_REQ)
+		return;
+
+	/* Only subtract the partial time stamp from the correction field.  When
+	 * the hardware adds the egress time stamp to the correction field of
+	 * the PDelay_Resp message on tx, also only the partial time stamp will
+	 * be added.
+	 */
+	correction = (s64)get_unaligned_be64(&ptp_hdr->correction);
+	correction -= ktime_to_ns(tstamp) << 16;
+
+	ptp_header_update_correction(skb, ptp_type, ptp_hdr, correction);
+}
+
 /* Time stamp tag *needs* to be inserted if PTP is enabled in hardware.
  * Regardless of Whether it is a PTP frame or not.
  */
@@ -215,8 +268,10 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
 
 	/* Extra 4-bytes PTP timestamp */
-	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
-		len += KSZ9477_PTP_TAG_LEN;
+	if (tag[0] & KSZ9477_PTP_TAG_INDICATION) {
+		ksz_rcv_timestamp(skb, tag, dev, port);
+		len += KSZ_PTP_TAG_LEN;
+	}
 
 	return ksz_common_rcv(skb, dev, port, len);
 }
@@ -283,10 +338,11 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893, KSZ9893_NAME);
  * tag0 : represents tag override, lookup and valid
  * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x80=port8)
  *
- * For rcv, 1 byte is added before FCS.
+ * For rcv, 1/5 bytes is added before FCS.
  * ---------------------------------------------------------------------------
- * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|FCS(4bytes)
  * ---------------------------------------------------------------------------
+ * ts   : time stamp (Present only if bit 7 of tag0 is set)
  * tag0 : zero-based value represents port
  *	  (eg, 0x00=port1, 0x02=port3, 0x07=port8)
  */
-- 
2.36.1

