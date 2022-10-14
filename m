Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AF75FF163
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiJNPaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbiJNPaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:30:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0845072A;
        Fri, 14 Oct 2022 08:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1665761398; x=1697297398;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eHwa9IHXeES+Nm+coFOclTeWUmZ0mOGsc7ZsoZdPrAQ=;
  b=JCLx8SgLE6Kp1MrjJTN3rAJRSa8G+Ih+zSooSq2nQ4Toe7byGZ9uryS9
   /h3Gb9wBOZwwJvp/UhXfOQ7gxlpNKP5qQ+3Nk5Ra5NZURZ4PFm/01yjlM
   Ps4C0Em7t968dC5dtQ5AdzhMxE1Us+RDZFEYivLzt516Uy2sy46Ok56Kt
   jaBD8zYLYnXi+pcATzsB2fsNbYkiQZ52l7R0AT5C1IihJKbD011QnHnQ/
   QCeKrgm1ZiBMAHigcY1b/sSwzdkPstHxEYRreRqe5FFHpdynBKWa0Hb7h
   TBQiyUacoaKecQ9JkUaU7ZPPuU5mDJWuxsPrKQH9rIB+95LQhQaeyT31q
   A==;
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="184851413"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2022 08:29:57 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 14 Oct 2022 08:29:57 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 14 Oct 2022 08:29:52 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next 6/6] net: dsa: microchip: add the transmission tstamp logic
Date:   Fri, 14 Oct 2022 20:58:57 +0530
Message-ID: <20221014152857.32645-7-arun.ramadoss@microchip.com>
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

This patch adds the routines for transmission of ptp packets. When the
ptp packets(sync, pdelay_req, pdelay_rsp) to be transmitted, the skb is
copied to global skb through port_txtstamp ioctl.
After the packet is transmitted, ISR is triggered. The time at which
packet transmitted is recorded to separate register available for each
message. This value is reconstructed to absolute time and posted to the
user application through skb complete.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c |   2 +
 drivers/net/dsa/microchip/ksz_ptp.c    | 104 ++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_ptp.h    |   9 +++
 include/linux/dsa/ksz_common.h         |  15 ++++
 net/dsa/tag_ksz.c                      |  67 +++++++++++++++-
 5 files changed, 193 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 388731959b23..47232a08ed94 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2432,6 +2432,7 @@ static int ksz_connect_tag_protocol(struct dsa_switch *ds,
 	struct ksz_tagger_data *tagger_data;
 
 	tagger_data = ksz_tagger_data(ds);
+	tagger_data->xmit_work_fn = ksz_port_deferred_xmit;
 	tagger_data->meta_tstamp_handler = ksz_tstamp_reconstruct;
 
 	return 0;
@@ -2868,6 +2869,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_ts_info            = ksz_get_ts_info,
 	.port_hwtstamp_get      = ksz_hwtstamp_get,
 	.port_hwtstamp_set      = ksz_hwtstamp_set,
+	.port_txtstamp		= ksz_port_txtstamp,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 5ae6eedb6b39..d11a490a6c87 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -163,6 +163,46 @@ int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
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
+	case PTP_MSGTYPE_PDELAY_REQ:
+	case PTP_MSGTYPE_PDELAY_RESP:
+	case PTP_MSGTYPE_SYNC:
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
+	KSZ_SKB_CB(skb)->clone = clone;
+}
+
 /* These are function related to the ptp clock info */
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
 {
@@ -397,6 +437,49 @@ ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
 	return timespec64_to_ktime(ts);
 }
 
+static void ksz_ptp_txtstamp_skb(struct ksz_device *dev,
+				 struct ksz_port *prt, struct sk_buff *skb)
+{
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+	struct skb_shared_hwtstamps hwtstamps = {};
+	int ret;
+
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	/* timeout must include tstamp latency, IRQ latency and time for
+	 * reading the time stamp.
+	 */
+	ret = wait_for_completion_timeout(&ptp_data->tstamp_msg_comp,
+					  msecs_to_jiffies(100));
+	if (!ret)
+		return;
+
+	hwtstamps.hwtstamp = ptp_data->tstamp_msg;
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
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+
+	clone = KSZ_SKB_CB(skb)->clone;
+
+	reinit_completion(&ptp_data->tstamp_msg_comp);
+
+	/* Transfer skb to the host port. */
+	dsa_enqueue_skb(skb, skb->dev);
+
+	ksz_ptp_txtstamp_skb(dev, dev->ports, clone);
+
+	kfree(xmit_work);
+}
+
 static const struct ptp_clock_info ksz_ptp_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "Microchip Clock",
@@ -433,6 +516,8 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 	if (ret)
 		goto error_unregister_clock;
 
+	init_completion(&ptp_data->tstamp_msg_comp);
+
 	return 0;
 
 error_unregister_clock:
@@ -453,7 +538,24 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds)
 
 static irqreturn_t ksz_ptp_msg_thread_fn(int irq, void *dev_id)
 {
-	return IRQ_NONE;
+	struct ksz_ptp_irq *ptpmsg_irq = dev_id;
+	struct ksz_device *dev = ptpmsg_irq->dev;
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+	u32 tstamp_raw;
+	ktime_t tstamp;
+	int ret;
+
+	ret = ksz_read32(dev, ptpmsg_irq->ts_reg, &tstamp_raw);
+	if (ret)
+		return IRQ_NONE;
+
+	tstamp = ksz_decode_tstamp(tstamp_raw);
+
+	ptp_data->tstamp_msg = ksz_tstamp_reconstruct(dev->ds, tstamp);
+
+	complete(&ptp_data->tstamp_msg_comp);
+
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t ksz_ptp_irq_thread_fn(int irq, void *dev_id)
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 9589909ab7d5..b2035a0bcbb2 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -13,6 +13,8 @@ struct ksz_ptp_data {
 	struct ptp_clock *clock;
 	/* Serializes all operations on the PTP hardware clock */
 	struct mutex lock;
+	ktime_t tstamp_msg;
+	struct completion tstamp_msg_comp;
 	/* lock for accessing the clock_time */
 	spinlock_t clock_lock;
 	struct timespec64 clock_time;
@@ -26,8 +28,10 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port,
 		    struct ethtool_ts_info *ts);
 int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
+void ksz_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
 int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
 void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
+void ksz_port_deferred_xmit(struct kthread_work *work);
 ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp);
 
 #else
@@ -58,6 +62,9 @@ static inline int ksz_hwtstamp_set(struct dsa_switch *ds, int port,
 	return -EOPNOTSUPP;
 }
 
+static inline void ksz_port_txtstamp(struct dsa_switch *ds, int port,
+				     struct sk_buff *skb) {}
+
 static inline int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
 {
 	return 0;
@@ -65,6 +72,8 @@ static inline int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
 
 static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
 
+static inline void ksz_port_deferred_xmit(struct kthread_work *work) {}
+
 static inline ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
 {
 	return 0;
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index 82edd7228b3c..15550fd88692 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -23,12 +23,27 @@ static inline ktime_t ksz_decode_tstamp(u32 tstamp)
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
 };
 
+struct ksz_skb_cb {
+	struct sk_buff *clone;
+	unsigned int ptp_type;
+};
+
+#define KSZ_SKB_CB(skb) \
+	((struct ksz_skb_cb *)((skb)->cb))
+
 static inline struct ksz_tagger_data *
 ksz_tagger_data(struct dsa_switch *ds)
 {
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 937a3e70b471..582add3398d3 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -19,6 +19,7 @@
 struct ksz_tagger_private {
 	struct ksz_tagger_data data; /* Must be first */
 	unsigned long state;
+	struct kthread_worker *xmit_worker;
 };
 
 static struct ksz_tagger_private *
@@ -48,6 +49,7 @@ static void ksz_disconnect(struct dsa_switch *ds)
 {
 	struct ksz_tagger_private *priv = ds->tagger_data;
 
+	kthread_destroy_worker(priv->xmit_worker);
 	kfree(priv);
 	ds->tagger_data = NULL;
 }
@@ -55,12 +57,23 @@ static void ksz_disconnect(struct dsa_switch *ds)
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
@@ -271,10 +284,11 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
 
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
@@ -293,14 +307,61 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
 #define LAN937X_TAIL_TAG_VALID			BIT(13)
 #define LAN937X_TAIL_TAG_PORT_MASK		7
 
+static void lan937x_xmit_timestamp(struct sk_buff *skb)
+{
+	put_unaligned_be32(0, skb_put(skb, KSZ9477_PTP_TAG_LEN));
+}
+
+static struct sk_buff *lan937x_defer_xmit(struct dsa_port *dp,
+					  struct sk_buff *skb)
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
 static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	const struct ethhdr *hdr = eth_hdr(skb);
+	struct ksz_tagger_private *priv;
 	__be16 *tag;
 	u16 val;
 
+	priv = ksz_tagger_private(dp->ds);
+
+	/* Tag encoding */
+	if (test_bit(KSZ_HWTS_EN, &priv->state))
+		lan937x_xmit_timestamp(skb);
+
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
 		return NULL;
 
@@ -316,7 +377,7 @@ static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 
 	put_unaligned_be16(val, tag);
 
-	return skb;
+	return lan937x_defer_xmit(dp, skb);
 }
 
 static const struct dsa_device_ops lan937x_netdev_ops = {
-- 
2.36.1

