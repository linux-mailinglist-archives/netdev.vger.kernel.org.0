Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A2563287C
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiKUPoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiKUPno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:43:44 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A1C21804;
        Mon, 21 Nov 2022 07:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669045393; x=1700581393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s0kAXQN++et7RAFesl90UyYF8t5eVUYQFEUTeK6dBO8=;
  b=w8cgzKwHsdBOyCqHeCljW9Xsi/SY7dh4GPb6ZkxJMHWjkmtNFuyXvwI9
   KHGyMEbTNpmpKFkUsNduy+F55os6EGOzGKvX7sEHvjcwjZ2LPkUMBTuL/
   sFtAv+KjpQDml9imoVpl2LNjkAztrNcN0mHz7LOACss+jwviI+7MwyMnv
   yXudHNxQlWq72Ak8bYP5V1RYtceEbv+vEOUQM4o3+1PAqahoQjPBf9Q7t
   8c+xbzAtNpcO1BiO8Ea4LRHOq0cHLAuMcmGo2pRH/H0dmCtNrXrKtd3FF
   w0CCajbl/jRGJ4MLGMY2VyBLORCdryNfwuwOwwjIbFWi+3dVfNnhvq/MP
   g==;
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="187968546"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Nov 2022 08:43:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 21 Nov 2022 08:43:04 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 21 Nov 2022 08:42:59 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next v2 7/8] net: dsa: microchip: add the transmission tstamp logic
Date:   Mon, 21 Nov 2022 21:11:49 +0530
Message-ID: <20221121154150.9573-8-arun.ramadoss@microchip.com>
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

This patch adds the routines for transmission of ptp packets. When the
ptp packets(sync, pdelay_req, pdelay_rsp) to be transmitted, the skb is
copied to global skb through port_txtstamp ioctl.
After the packet is transmitted, ISR is triggered. The time at which
packet transmitted is recorded to separate register available for each
message. This value is reconstructed to absolute time and posted to the
user application through skb complete.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c  |   2 +
 drivers/net/dsa/microchip/ksz_common.h  |   3 +
 drivers/net/dsa/microchip/ksz_ptp.c     |  86 +++++++++++++-
 drivers/net/dsa/microchip/ksz_ptp.h     |   7 ++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |   3 +
 include/linux/dsa/ksz_common.h          |  16 +++
 net/dsa/tag_ksz.c                       | 152 ++++++++++++++++++++++--
 7 files changed, 258 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 6430241fce46..411a71710161 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2459,6 +2459,7 @@ static int ksz_connect_tag_protocol(struct dsa_switch *ds,
 	struct ksz_tagger_data *tagger_data;
 
 	tagger_data = ksz_tagger_data(ds);
+	tagger_data->xmit_work_fn = ksz_port_deferred_xmit;
 	tagger_data->meta_tstamp_handler = ksz_tstamp_reconstruct;
 	tagger_data->is_ptp_twostep = ksz_is_ptp_twostep;
 
@@ -2899,6 +2900,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_ts_info            = ksz_get_ts_info,
 	.port_hwtstamp_get      = ksz_hwtstamp_get,
 	.port_hwtstamp_set      = ksz_hwtstamp_set,
+	.port_txtstamp		= ksz_port_txtstamp,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 510aff116f3e..764b6a3e5187 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -89,6 +89,7 @@ struct ksz_irq {
 struct ksz_ptp_irq {
 	struct ksz_port *port;
 	u16 ts_reg;
+	bool ts_en;
 	char name[16];
 	int irq_num;
 };
@@ -117,6 +118,8 @@ struct ksz_port {
 	u8 hwts_tx_en;
 	struct ksz_irq ptpirq;
 	struct ksz_ptp_irq ptpmsg_irq[3];
+	ktime_t tstamp_msg;
+	struct completion tstamp_msg_comp;
 #endif
 };
 
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index c9c43a98427b..5506adaac488 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -104,14 +104,25 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
 
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
+		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = 0;
+		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 0;
+		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 0;
+		prt->hwts_tx_en = HWTSTAMP_TX_OFF;
+		break;
 	case HWTSTAMP_TX_ONESTEP_P2P:
-		prt->hwts_tx_en = config->tx_type;
+		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = 0;
+		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 1;
+		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 0;
+		prt->hwts_tx_en = HWTSTAMP_TX_ONESTEP_P2P;
 		break;
 	case HWTSTAMP_TX_ON:
 		if (!is_lan937x(dev))
 			return -ERANGE;
 
-		prt->hwts_tx_en = config->tx_type;
+		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = 1;
+		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 1;
+		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 1;
+		prt->hwts_tx_en = HWTSTAMP_TX_ON;
 		break;
 	default:
 		return -ERANGE;
@@ -220,7 +231,6 @@ bool ksz_is_ptp_twostep(struct dsa_switch *ds, unsigned int port)
 	return (prt->hwts_tx_en == HWTSTAMP_TX_ON);
 }
 
-/* These are function related to the ptp clock info */
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
 {
 	u32 nanoseconds;
@@ -458,6 +468,50 @@ ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
 	return timespec64_to_ktime(ts);
 }
 
+static void ksz_ptp_txtstamp_skb(struct ksz_device *dev,
+				 struct ksz_port *prt, struct sk_buff *skb)
+{
+	struct skb_shared_hwtstamps hwtstamps = {};
+	int ret;
+
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	/* timeout must include tstamp latency, IRQ latency and time for
+	 * reading the time stamp.
+	 */
+	ret = wait_for_completion_timeout(&prt->tstamp_msg_comp,
+					  msecs_to_jiffies(100));
+	if (!ret)
+		return;
+
+	hwtstamps.hwtstamp = prt->tstamp_msg;
+	skb_complete_tx_timestamp(skb, &hwtstamps);
+}
+
+#define work_to_xmit_work(w) \
+		container_of((w), struct ksz_deferred_xmit_work, work)
+void ksz_port_deferred_xmit(struct kthread_work *work)
+{
+	struct ksz_deferred_xmit_work *xmit_work = work_to_xmit_work(work);
+	struct sk_buff *clone, *skb = xmit_work->skb;
+	struct dsa_switch *ds = xmit_work->dp->ds;
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *prt;
+
+	prt = &dev->ports[xmit_work->dp->index];
+
+	clone = KSZ_SKB_CB(skb)->clone;
+
+	reinit_completion(&prt->tstamp_msg_comp);
+
+	/* Transfer skb to the host port. */
+	dsa_enqueue_skb(skb, skb->dev);
+
+	ksz_ptp_txtstamp_skb(dev, prt, clone);
+
+	kfree(xmit_work);
+}
+
 static const struct ptp_clock_info ksz_ptp_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "Microchip Clock",
@@ -514,7 +568,29 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds)
 
 static irqreturn_t ksz_ptp_msg_thread_fn(int irq, void *dev_id)
 {
-	return IRQ_NONE;
+	struct ksz_ptp_irq *ptpmsg_irq = dev_id;
+	struct ksz_device *dev;
+	struct ksz_port *port;
+	u32 tstamp_raw;
+	ktime_t tstamp;
+	int ret;
+
+	port = ptpmsg_irq->port;
+	dev = port->ksz_dev;
+
+	if (ptpmsg_irq->ts_en) {
+		ret = ksz_read32(dev, ptpmsg_irq->ts_reg, &tstamp_raw);
+		if (ret)
+			return IRQ_NONE;
+
+		tstamp = ksz_decode_tstamp(tstamp_raw);
+
+		port->tstamp_msg = ksz_tstamp_reconstruct(dev->ds, tstamp);
+
+		complete(&port->tstamp_msg_comp);
+	}
+
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t ksz_ptp_irq_thread_fn(int irq, void *dev_id)
@@ -666,6 +742,8 @@ int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
 						REG_PTP_PORT_TX_INT_STATUS__2);
 	snprintf(ptpirq->name, sizeof(ptpirq->name), "ptp_irq-%d", p);
 
+	init_completion(&port->tstamp_msg_comp);
+
 	ptpirq->irq_num = irq_find_mapping(port->pirq.domain, PORT_SRC_PTP_INT);
 	if (ptpirq->irq_num < 0)
 		return ptpirq->irq_num;
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 46b1ccbace81..7d6786caa633 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -26,8 +26,10 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port,
 		    struct ethtool_ts_info *ts);
 int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
+void ksz_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
 int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
 void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
+void ksz_port_deferred_xmit(struct kthread_work *work);
 ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp);
 bool ksz_is_ptp_twostep(struct dsa_switch *ds, unsigned int port);
 
@@ -59,6 +61,9 @@ static inline int ksz_hwtstamp_set(struct dsa_switch *ds, int port,
 	return -EOPNOTSUPP;
 }
 
+static inline void ksz_port_txtstamp(struct dsa_switch *ds, int port,
+				     struct sk_buff *skb) {}
+
 static inline int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
 {
 	return 0;
@@ -66,6 +71,8 @@ static inline int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
 
 static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
 
+static inline void ksz_port_deferred_xmit(struct kthread_work *work) {}
+
 static inline ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
 {
 	return 0;
diff --git a/drivers/net/dsa/microchip/ksz_ptp_reg.h b/drivers/net/dsa/microchip/ksz_ptp_reg.h
index 2ae6c8b01b00..ccb87bbdfbcd 100644
--- a/drivers/net/dsa/microchip/ksz_ptp_reg.h
+++ b/drivers/net/dsa/microchip/ksz_ptp_reg.h
@@ -66,3 +66,6 @@
 #define PTP_PORT_SYNC_INT		BIT(15)
 #define PTP_PORT_XDELAY_REQ_INT		BIT(14)
 #define PTP_PORT_PDELAY_RESP_INT	BIT(13)
+#define KSZ_SYNC_MSG			2
+#define KSZ_XDREQ_MSG			1
+#define KSZ_PDRES_MSG			0
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index d71851dbeb4d..4dd4ccaa06ab 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -23,13 +23,29 @@ static inline ktime_t ksz_decode_tstamp(u32 tstamp)
 	return ns_to_ktime(ns);
 }
 
+struct ksz_deferred_xmit_work {
+	struct dsa_port *dp;
+	struct sk_buff *skb;
+	struct kthread_work work;
+};
+
 struct ksz_tagger_data {
+	void (*xmit_work_fn)(struct kthread_work *work);
 	bool (*hwtstamp_get_state)(struct dsa_switch *ds);
 	void (*hwtstamp_set_state)(struct dsa_switch *ds, bool on);
 	ktime_t (*meta_tstamp_handler)(struct dsa_switch *ds, ktime_t tstamp);
 	bool (*is_ptp_twostep)(struct dsa_switch *ds, unsigned int port);
 };
 
+struct ksz_skb_cb {
+	struct sk_buff *clone;
+	unsigned int ptp_type;
+	u8 ptp_msg_type;
+};
+
+#define KSZ_SKB_CB(skb) \
+	((struct ksz_skb_cb *)((skb)->cb))
+
 static inline struct ksz_tagger_data *
 ksz_tagger_data(struct dsa_switch *ds)
 {
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 39b27f6e26be..fa6bb6df6984 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -25,6 +25,7 @@
 struct ksz_tagger_private {
 	struct ksz_tagger_data data; /* Must be first */
 	unsigned long state;
+	struct kthread_worker *xmit_worker;
 };
 
 static struct ksz_tagger_private *
@@ -54,6 +55,7 @@ static void ksz_disconnect(struct dsa_switch *ds)
 {
 	struct ksz_tagger_private *priv = ds->tagger_data;
 
+	kthread_destroy_worker(priv->xmit_worker);
 	kfree(priv);
 	ds->tagger_data = NULL;
 }
@@ -61,12 +63,23 @@ static void ksz_disconnect(struct dsa_switch *ds)
 static int ksz_connect(struct dsa_switch *ds)
 {
 	struct ksz_tagger_data *tagger_data;
+	struct kthread_worker *xmit_worker;
 	struct ksz_tagger_private *priv;
+	int ret;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	xmit_worker = kthread_create_worker(0, "dsa%d:%d_xmit",
+					    ds->dst->index, ds->index);
+	if (IS_ERR(xmit_worker)) {
+		ret = PTR_ERR(xmit_worker);
+		kfree(priv);
+		return ret;
+	}
+
+	priv->xmit_worker = xmit_worker;
 	/* Export functions for switch driver use */
 	tagger_data = &priv->data;
 	tagger_data->hwtstamp_get_state = ksz_hwtstamp_get_state;
@@ -227,18 +240,127 @@ static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
 	ptp_header_update_correction(skb, ptp_type, ptp_hdr, correction);
 }
 
+/* Time stamp tag is only inserted if PTP is enabled in hardware. */
+static void ksz_xmit_timestamp(struct dsa_switch *ds, struct sk_buff *skb,
+			       unsigned int port)
+{
+	struct sk_buff *clone = KSZ_SKB_CB(skb)->clone;
+	struct ksz_tagger_data *tagger_data;
+	struct ptp_header *ptp_hdr;
+	unsigned int ptp_type;
+	u32 tstamp_raw = 0;
+	u8 ptp_msg_type;
+	s64 correction;
+
+	if (!clone)
+		goto out_put_tag;
+
+	/* Use cached PTP type from ksz_ptp_port_txtstamp().  */
+	ptp_type = KSZ_SKB_CB(clone)->ptp_type;
+	if (ptp_type == PTP_CLASS_NONE)
+		goto out_put_tag;
+
+	ptp_hdr = ptp_parse_header(skb, ptp_type);
+	if (!ptp_hdr)
+		goto out_put_tag;
+
+	tagger_data = ksz_tagger_data(ds);
+	if (!tagger_data->is_ptp_twostep)
+		goto out_put_tag;
+
+	if (tagger_data->is_ptp_twostep(ds, port))
+		goto out_put_tag;
+
+	ptp_msg_type = KSZ_SKB_CB(clone)->ptp_msg_type;
+	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_RESP)
+		goto out_put_tag;
+
+	correction = (s64)get_unaligned_be64(&ptp_hdr->correction);
+
+	/* For PDelay_Resp messages we will likely have a negative value in the
+	 * correction field (see ksz9477_rcv()). The switch hardware cannot
+	 * correctly update such values (produces an off by one error in the UDP
+	 * checksum), so it must be moved to the time stamp field in the tail
+	 * tag.
+	 */
+	if (correction < 0) {
+		struct timespec64 ts;
+
+		/* Move ingress time stamp from PTP header's correction field to
+		 * tail tag. Format of the correction filed is 48 bit ns + 16
+		 * bit fractional ns.
+		 */
+		ts = ns_to_timespec64(-correction >> 16);
+		tstamp_raw = ((ts.tv_sec & 3) << 30) | ts.tv_nsec;
+
+		/* Set correction field to 0 and update UDP checksum.  */
+		ptp_header_update_correction(skb, ptp_type, ptp_hdr, 0);
+	}
+
+	/* For PDelay_Resp messages, the clone is not required in
+	 * skb_complete_tx_timestamp() and should be freed here.
+	 */
+	kfree_skb(clone);
+	KSZ_SKB_CB(skb)->clone = NULL;
+
+out_put_tag:
+	put_unaligned_be32(tstamp_raw, skb_put(skb, KSZ9477_PTP_TAG_LEN));
+}
+
+/* Defer transmit if waiting for egress time stamp is required.  */
+static struct sk_buff *ksz_defer_xmit(struct dsa_port *dp, struct sk_buff *skb)
+{
+	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dp->ds);
+	struct ksz_tagger_private *priv = ksz_tagger_private(dp->ds);
+	void (*xmit_work_fn)(struct kthread_work *work);
+	struct sk_buff *clone = KSZ_SKB_CB(skb)->clone;
+	struct ksz_deferred_xmit_work *xmit_work;
+	struct kthread_worker *xmit_worker;
+
+	if (!clone)
+		return skb;  /* no deferred xmit for this packet */
+
+	xmit_work_fn = tagger_data->xmit_work_fn;
+	xmit_worker = priv->xmit_worker;
+
+	if (!xmit_work_fn || !xmit_worker)
+		return NULL;
+
+	xmit_work = kzalloc(sizeof(*xmit_work), GFP_ATOMIC);
+	if (!xmit_work)
+		return NULL;
+
+	kthread_init_work(&xmit_work->work, xmit_work_fn);
+	/* Increase refcount so the kfree_skb in dsa_slave_xmit
+	 * won't really free the packet.
+	 */
+	xmit_work->dp = dp;
+	xmit_work->skb = skb_get(skb);
+
+	kthread_queue_work(xmit_worker, &xmit_work->work);
+
+	return NULL;
+}
+
 static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ksz_tagger_private *priv;
+	struct dsa_switch *ds = dp->ds;
 	__be16 *tag;
 	u8 *addr;
 	u16 val;
 
+	priv = ksz_tagger_private(ds);
+
+	/* Tag encoding */
+	if (test_bit(KSZ_HWTS_EN, &priv->state))
+		ksz_xmit_timestamp(ds, skb, dp->index);
+
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
 		return NULL;
 
-	/* Tag encoding */
 	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -249,7 +371,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	*tag = cpu_to_be16(val);
 
-	return skb;
+	return ksz_defer_xmit(dp, skb);
 }
 
 static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
@@ -288,13 +410,20 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ksz_tagger_private *priv;
+	struct dsa_switch *ds = dp->ds;
 	u8 *addr;
 	u8 *tag;
 
+	priv = ksz_tagger_private(ds);
+
+	/* Tag encoding */
+	if (test_bit(KSZ_HWTS_EN, &priv->state))
+		ksz_xmit_timestamp(ds, skb, dp->index);
+
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
 		return NULL;
 
-	/* Tag encoding */
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -303,7 +432,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
-	return skb;
+	return ksz_defer_xmit(dp, skb);
 }
 
 static const struct dsa_device_ops ksz9893_netdev_ops = {
@@ -319,10 +448,11 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
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
@@ -346,9 +476,17 @@ static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	const struct ethhdr *hdr = eth_hdr(skb);
+	struct ksz_tagger_private *priv;
+	struct dsa_switch *ds = dp->ds;
 	__be16 *tag;
 	u16 val;
 
+	priv = ksz_tagger_private(ds);
+
+	/* Tag encoding */
+	if (test_bit(KSZ_HWTS_EN, &priv->state))
+		ksz_xmit_timestamp(ds, skb, dp->index);
+
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
 		return NULL;
 
@@ -364,7 +502,7 @@ static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 
 	put_unaligned_be16(val, tag);
 
-	return skb;
+	return ksz_defer_xmit(dp, skb);
 }
 
 static const struct dsa_device_ops lan937x_netdev_ops = {
-- 
2.36.1

