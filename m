Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC18632879
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbiKUPnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiKUPnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:43:07 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4FAB1F6;
        Mon, 21 Nov 2022 07:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669045381; x=1700581381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NeyX9fJf4+o90P1pDbzmykY7qysuHWK3uM4J0i/oV/8=;
  b=TU7zfFX5Xy8A+hV1F7if+QZ362hfCa/sOCkBYsVkmV1t4XbP0aDcJ7EU
   p+HCQh37ybJP1Y69j3NtqqsGhF9Qjrd+cNjUgzK4QW6ZOr2/4Z9lSniAF
   2qnXKM+CNjJEAYBDedmY3212cQKDglUrfn+H7yHWhCpoIiFbAYoPKVJxJ
   ir04wETAEHwJ5ycwrLF/IMbOdc4Ed8K5tP2sR1ajAF4mOwnZ2opusctOc
   hLB1mx+yKi3KVnx2/mFzr0PcZ5u4xtIC5B5Zg70i7VGrj6hmt1S+q5Q6e
   AsvtCIlpbPXd/A8ByEdCMBatq/vT3vbZ4RBjHuv0eYCuxtC060ksHc70I
   w==;
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="189874767"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Nov 2022 08:43:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 21 Nov 2022 08:42:57 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 21 Nov 2022 08:42:52 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next v2 6/8] net: dsa: microchip: Adding the ptp packet reception logic
Date:   Mon, 21 Nov 2022 21:11:48 +0530
Message-ID: <20221121154150.9573-7-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221121154150.9573-1-arun.ramadoss@microchip.com>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the routines for timestamping received ptp packets.
Whenever the ptp packet is received, the 4 byte hardware time stamped
value is append to its packet. This 4 byte value is extracted from the
tail tag and reconstructed to absolute time and assigned to skb
hwtstamp.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 13 +++++
 drivers/net/dsa/microchip/ksz_ptp.c    | 78 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h    | 12 ++++
 include/linux/dsa/ksz_common.h         | 16 ++++++
 net/dsa/tag_ksz.c                      | 73 ++++++++++++++++++++++--
 5 files changed, 186 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index c0b9b406fca8..6430241fce46 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2453,6 +2453,18 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 	return proto;
 }
 
+static int ksz_connect_tag_protocol(struct dsa_switch *ds,
+				    enum dsa_tag_protocol proto)
+{
+	struct ksz_tagger_data *tagger_data;
+
+	tagger_data = ksz_tagger_data(ds);
+	tagger_data->meta_tstamp_handler = ksz_tstamp_reconstruct;
+	tagger_data->is_ptp_twostep = ksz_is_ptp_twostep;
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
index 4b46cdc1c3bb..c9c43a98427b 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -167,6 +167,59 @@ int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 	return ret;
 }
 
+void ksz_port_txtstamp(struct dsa_switch *ds, int port,
+		       struct sk_buff *skb)
+{
+	struct ksz_device *dev	= ds->priv;
+	struct ksz_port *prt = &dev->ports[port];
+	struct ptp_header *hdr;
+	struct sk_buff *clone;
+	unsigned int type;
+	u8 ptp_msg_type;
+
+	if (!prt->hwts_tx_en)
+		return;
+
+	type = ptp_classify_raw(skb);
+	if (type == PTP_CLASS_NONE)
+		return;
+
+	hdr = ptp_parse_header(skb, type);
+	if (!hdr)
+		return;
+
+	ptp_msg_type = ptp_get_msgtype(hdr, type);
+
+	switch (ptp_msg_type) {
+	case PTP_MSGTYPE_SYNC:
+		if (prt->hwts_tx_en == HWTSTAMP_TX_ONESTEP_P2P)
+			return;
+	case PTP_MSGTYPE_PDELAY_REQ:
+	case PTP_MSGTYPE_PDELAY_RESP:
+		break;
+
+	default:
+		return;
+	}
+
+	clone = skb_clone_sk(skb);
+	if (!clone)
+		return;
+
+	/* caching the value to be used in later */
+	KSZ_SKB_CB(skb)->clone = clone;
+	KSZ_SKB_CB(clone)->ptp_type = type;
+	KSZ_SKB_CB(clone)->ptp_msg_type = ptp_msg_type;
+}
+
+bool ksz_is_ptp_twostep(struct dsa_switch *ds, unsigned int port)
+{
+	struct ksz_device *dev	= ds->priv;
+	struct ksz_port *prt = &dev->ports[port];
+
+	return (prt->hwts_tx_en == HWTSTAMP_TX_ON);
+}
+
 /* These are function related to the ptp clock info */
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
 {
@@ -380,6 +433,31 @@ static int ksz_ptp_start_clock(struct ksz_device *dev)
 	return 0;
 }
 
+ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+	struct timespec64 ts = ktime_to_timespec64(tstamp);
+	struct timespec64 ptp_clock_time;
+	struct timespec64 diff;
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
 static const struct ptp_clock_info ksz_ptp_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "Microchip Clock",
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 7e5d374d2acf..46b1ccbace81 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -28,6 +28,8 @@ int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
 void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
+ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp);
+bool ksz_is_ptp_twostep(struct dsa_switch *ds, unsigned int port);
 
 #else
 
@@ -64,6 +66,16 @@ static inline int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
 
 static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
 
+static inline ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
+{
+	return 0;
+}
+
+bool ksz_is_ptp_twostep(struct dsa_switch *ds, unsigned int port)
+{
+	return 0;
+}
+
 #endif	/* End of CONFIG_NET_DSA_MICROCHIOP_KSZ_PTP */
 
 #endif
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index 8903bce4753b..d71851dbeb4d 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -9,9 +9,25 @@
 
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
 	bool (*hwtstamp_get_state)(struct dsa_switch *ds);
 	void (*hwtstamp_set_state)(struct dsa_switch *ds, bool on);
+	ktime_t (*meta_tstamp_handler)(struct dsa_switch *ds, ktime_t tstamp);
+	bool (*is_ptp_twostep)(struct dsa_switch *ds, unsigned int port);
 };
 
 static inline struct ksz_tagger_data *
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 6a909a300c13..39b27f6e26be 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -7,6 +7,7 @@
 #include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
+#include <linux/ptp_classify.h>
 #include <net/dsa.h>
 #include "dsa_priv.h"
 
@@ -169,6 +170,63 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
 
+static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
+			      struct net_device *dev, unsigned int port)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	u8 *tstamp_raw = tag - KSZ9477_PTP_TAG_LEN;
+	struct dsa_switch *ds = dev->dsa_ptr->ds;
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
+	if (!tagger_data->is_ptp_twostep)
+		return;
+
+	if (tagger_data->is_ptp_twostep(ds, port))
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
 static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
@@ -202,8 +260,10 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
 
 	/* Extra 4-bytes PTP timestamp */
-	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
+	if (tag[0] & KSZ9477_PTP_TAG_INDICATION) {
+		ksz_rcv_timestamp(skb, tag, dev, port);
 		len += KSZ9477_PTP_TAG_LEN;
+	}
 
 	return ksz_common_rcv(skb, dev, port, len);
 }
@@ -215,7 +275,7 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.rcv	= ksz9477_rcv,
 	.connect = ksz_connect,
 	.disconnect = ksz_disconnect,
-	.needed_tailroom = KSZ9477_INGRESS_TAG_LEN,
+	.needed_tailroom = KSZ9477_INGRESS_TAG_LEN + KSZ9477_PTP_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(ksz9477_netdev_ops);
@@ -253,7 +313,7 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 	.rcv	= ksz9477_rcv,
 	.connect = ksz_connect,
 	.disconnect = ksz_disconnect,
-	.needed_tailroom = KSZ_INGRESS_TAG_LEN,
+	.needed_tailroom = KSZ_INGRESS_TAG_LEN + KSZ9477_PTP_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
@@ -266,10 +326,11 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893, KSZ9893_NAME);
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
@@ -313,7 +374,7 @@ static const struct dsa_device_ops lan937x_netdev_ops = {
 	.rcv	= ksz9477_rcv,
 	.connect = ksz_connect,
 	.disconnect = ksz_disconnect,
-	.needed_tailroom = LAN937X_EGRESS_TAG_LEN,
+	.needed_tailroom = LAN937X_EGRESS_TAG_LEN + KSZ9477_PTP_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(lan937x_netdev_ops);
-- 
2.36.1

