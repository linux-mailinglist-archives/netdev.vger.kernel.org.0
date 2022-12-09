Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0AB647E7E
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiLIH1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiLIH0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:26:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F44A43AE9;
        Thu,  8 Dec 2022 23:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670570775; x=1702106775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uBhOP+CV0SLp16Bq89xUDnHGyfl9ZE2CO9hzyWThusw=;
  b=D3JM6JPebVm+nne/HNJ/tjyJLxPJNJLgkGNEsSf19cSoUZwYL0rx0Y/F
   +T32wknE73dCqxM1hPY6GAJZaTC5S3b1ujutRzvNJ1ABuoyEW6Oh8jNK1
   sePcRoyxMovfLoaZICzdDiTkyhwwcro65mX7kibr/P6kcBoJUEACz4vvm
   2z/KsEmeht6IWHOo2wua81paSjh9URZfxjBInfcvW5jy1JwWdW183E3+G
   HtJoVHllQsPLUS7uC99ZGYoYwmsqXPqqOHG1r6BBsiMkCt0Gl9PmD7p9N
   Owb3Jf43yKyHeoBOn//u7QJt4L1MglQiSjaDN5/nlA47q1+lHb8ZI0t1w
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="192360046"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 00:26:15 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 00:26:14 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 00:26:08 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v3 07/13] net: dsa: microchip: ptp: add packet reception timestamping
Date:   Fri, 9 Dec 2022 12:54:31 +0530
Message-ID: <20221209072437.18373-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221209072437.18373-1-arun.ramadoss@microchip.com>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
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

Rx Timestamping is done through 4 additional bytes in tail tag.
Whenever the ptp packet is received, the 4 byte hardware time stamped
value is added before 1 byte tail tag. Also, bit 7 in tail tag indicates
it as PTP frame. This 4 byte value is extracted from the tail tag and
reconstructed to absolute time and assigned to skb hwtstamp.
If the packet received in PDelay_Resp, then partial ingress timestamp
is subtracted from the correction field. Since user space tools expects
to be done in hardware.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

---
v2 - v3
- Replaced tagger_data->meta_timestamper handler with port_rxtstamp
routine

v1 - v2
- Checkpatch warning line limit to 80chars

RFC v2 -> Patch v1
- Fixed compilation issue
---
 drivers/net/dsa/microchip/ksz_common.c |  1 +
 drivers/net/dsa/microchip/ksz_ptp.c    | 63 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h    |  4 ++
 include/linux/dsa/ksz_common.h         | 21 +++++++++
 net/dsa/tag_ksz.c                      | 25 +++++++---
 5 files changed, 108 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 1611f8f5cd6c..127fdbc25141 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2992,6 +2992,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_ts_info            = ksz_get_ts_info,
 	.port_hwtstamp_get      = ksz_hwtstamp_get,
 	.port_hwtstamp_set      = ksz_hwtstamp_set,
+	.port_rxtstamp		= ksz_port_rxtstamp,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index a7b015ac2734..e9c2442eec71 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -169,6 +169,69 @@ int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config));
 }
 
+static ktime_t ksz_tstamp_reconstruct(struct ksz_device *dev, ktime_t tstamp)
+{
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
+bool ksz_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
+		       unsigned int type)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	struct ksz_device *dev = ds->priv;
+	struct ptp_header *ptp_hdr;
+	u8 ptp_msg_type;
+	ktime_t tstamp;
+	s64 correction;
+
+	tstamp = KSZ_SKB_CB(skb)->tstamp;
+	memset(hwtstamps, 0, sizeof(*hwtstamps));
+	hwtstamps->hwtstamp = ksz_tstamp_reconstruct(dev, tstamp);
+
+	ptp_hdr = ptp_parse_header(skb, type);
+	if (!ptp_hdr)
+		goto out;
+
+	ptp_msg_type = ptp_get_msgtype(ptp_hdr, type);
+	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_REQ)
+		goto out;
+
+	/* Only subtract the partial time stamp from the correction field.  When
+	 * the hardware adds the egress time stamp to the correction field of
+	 * the PDelay_Resp message on tx, also only the partial time stamp will
+	 * be added.
+	 */
+	correction = (s64)get_unaligned_be64(&ptp_hdr->correction);
+	correction -= ktime_to_ns(tstamp) << 16;
+
+	ptp_header_update_correction(skb, type, ptp_hdr, correction);
+
+out:
+	return 0;
+}
+
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
 {
 	u32 nanoseconds;
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 7c5679372705..9bb8fb059ac2 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -30,6 +30,8 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port,
 		    struct ethtool_ts_info *ts);
 int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
+bool ksz_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
+		       unsigned int type);
 int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
 void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
 
@@ -60,6 +62,8 @@ static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
 
 #define ksz_hwtstamp_set NULL
 
+#define ksz_port_rxtstamp NULL
+
 #endif	/* End of CONFIG_NET_DSA_MICROCHIP_KSZ_PTP */
 
 #endif
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index d2a54161be97..a256b08d837d 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -9,10 +9,31 @@
 
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
 };
 
+struct ksz_skb_cb {
+	u32 tstamp;
+};
+
+#define KSZ_SKB_CB(skb) \
+	((struct ksz_skb_cb *)((skb)->cb))
+
 static inline struct ksz_tagger_data *
 ksz_tagger_data(struct dsa_switch *ds)
 {
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 420a12853676..6603eaa234d2 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -151,10 +151,11 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
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
@@ -166,6 +167,15 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
 
+static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag)
+{
+	u8 *tstamp_raw = tag - KSZ_PTP_TAG_LEN;
+	ktime_t tstamp;
+
+	tstamp = ksz_decode_tstamp(get_unaligned_be32(tstamp_raw));
+	KSZ_SKB_CB(skb)->tstamp = tstamp;
+}
+
 /* Time stamp tag *needs* to be inserted if PTP is enabled in hardware.
  * Regardless of Whether it is a PTP frame or not.
  */
@@ -216,8 +226,10 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
 
 	/* Extra 4-bytes PTP timestamp */
-	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
-		len += KSZ9477_PTP_TAG_LEN;
+	if (tag[0] & KSZ9477_PTP_TAG_INDICATION) {
+		ksz_rcv_timestamp(skb, tag);
+		len += KSZ_PTP_TAG_LEN;
+	}
 
 	return ksz_common_rcv(skb, dev, port, len);
 }
@@ -284,10 +296,11 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893, KSZ9893_NAME);
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

