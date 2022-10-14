Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B475FF165
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiJNPa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiJNPaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:30:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7B636BE2;
        Fri, 14 Oct 2022 08:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1665761393; x=1697297393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jK8z94O3baWwUdnBW8BYIUHIgd+YLU3a+lUHwKmvqNQ=;
  b=C5ZD1EJe7k40LbEqNZoNealGnf0vwj8Ohs02tEnQrhBzt5RW4Tci/hym
   HmLoGU4BbvYn77O3P+2OIsUWfTBuYI7S5wp1pfupP7N5GgJEknk6vC8bh
   S0PLuygO3bBOWTPCS1QSqZFd9Qx5CNxRLfMn+rMRODvXgv95bqgPrUoWQ
   nWxulfe1g9lR/eQE+9WO60TGpp1H3KdySGPWkLWrow27OpWnwwkKbRbuM
   ppLCUAsRCd5fb4GaCtLZctone5ShQxyvH3GATbuBnaEgogPd615bR9GGT
   49LnXvD5pD0ukDL9sL5z9XifUU2MZY9Rwei69xiVz6FZ/EfZq8Y4BLqlR
   A==;
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="184851379"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2022 08:29:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 14 Oct 2022 08:29:50 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 14 Oct 2022 08:29:45 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next 5/6] net: dsa: microchip: Adding the ptp packet reception logic
Date:   Fri, 14 Oct 2022 20:58:56 +0530
Message-ID: <20221014152857.32645-6-arun.ramadoss@microchip.com>
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

This patch adds the routines for timestamping received ptp packets.
Whenever the ptp packet is received, the 4 byte hardware time stamped
value is append to its packet. This 4 byte value is extracted from the
tail tag and reconstructed to absolute time and assigned to skb
hwtstamp.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 12 +++++++++++
 drivers/net/dsa/microchip/ksz_ptp.c    | 25 +++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h    |  6 ++++++
 include/linux/dsa/ksz_common.h         | 15 +++++++++++++
 net/dsa/tag_ksz.c                      | 30 ++++++++++++++++++++++----
 5 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 0c0fdb7b7879..388731959b23 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2426,6 +2426,17 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
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
@@ -2819,6 +2830,7 @@ static int ksz_switch_detect(struct ksz_device *dev)
 
 static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_tag_protocol	= ksz_get_tag_protocol,
+	.connect_tag_protocol   = ksz_connect_tag_protocol,
 	.get_phy_flags		= ksz_get_phy_flags,
 	.setup			= ksz_setup,
 	.teardown		= ksz_teardown,
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 2cae543f7e0b..5ae6eedb6b39 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -372,6 +372,31 @@ static int ksz_ptp_start_clock(struct ksz_device *dev)
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
index 7e5d374d2acf..9589909ab7d5 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -28,6 +28,7 @@ int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
 void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
+ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp);
 
 #else
 
@@ -64,6 +65,11 @@ static inline int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
 
 static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
 
+static inline ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
+{
+	return 0;
+}
+
 #endif	/* End of CONFIG_NET_DSA_MICROCHIOP_KSZ_PTP */
 
 #endif
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index 8903bce4753b..82edd7228b3c 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -9,9 +9,24 @@
 
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
 };
 
 static inline struct ksz_tagger_data *
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index ca1261b04fe7..937a3e70b471 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -164,6 +164,25 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795);
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
 
+static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
+			      struct net_device *dev, unsigned int port)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	u8 *tstamp_raw = tag - KSZ9477_PTP_TAG_LEN;
+	struct dsa_switch *ds = dev->dsa_ptr->ds;
+	struct ksz_tagger_data *tagger_data;
+	ktime_t tstamp;
+
+	tagger_data = ksz_tagger_data(ds);
+	if (!tagger_data->meta_tstamp_handler)
+		return;
+
+	/* convert time stamp and write to skb */
+	tstamp = ksz_decode_tstamp(get_unaligned_be32(tstamp_raw));
+	memset(hwtstamps, 0, sizeof(*hwtstamps));
+	hwtstamps->hwtstamp = tagger_data->meta_tstamp_handler(ds, tstamp);
+}
+
 static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
@@ -197,8 +216,10 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
 
 	/* Extra 4-bytes PTP timestamp */
-	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
+	if (tag[0] & KSZ9477_PTP_TAG_INDICATION) {
+		ksz_rcv_timestamp(skb, tag, dev, port);
 		len += KSZ9477_PTP_TAG_LEN;
+	}
 
 	return ksz_common_rcv(skb, dev, port, len);
 }
@@ -257,10 +278,11 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
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
@@ -304,7 +326,7 @@ static const struct dsa_device_ops lan937x_netdev_ops = {
 	.rcv	= ksz9477_rcv,
 	.connect = ksz_connect,
 	.disconnect = ksz_disconnect,
-	.needed_tailroom = LAN937X_EGRESS_TAG_LEN,
+	.needed_tailroom = LAN937X_EGRESS_TAG_LEN + KSZ9477_PTP_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(lan937x_netdev_ops);
-- 
2.36.1

