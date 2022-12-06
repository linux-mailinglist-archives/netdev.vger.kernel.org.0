Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53C2643FAE
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbiLFJS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiLFJRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:17:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BB1222AC;
        Tue,  6 Dec 2022 01:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670318183; x=1701854183;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LRNGn9DZR2uZAg6cMK38SABt2UdBNWK/4sGKb0fRedc=;
  b=hTUi5GyDcKHrvh5dFrYAN89CDb2OBHiFjicYhdgqjsGmseEyWDfS3lbd
   qyaKqchKefLTk5syHeEJ6dO4jQ4UlCGPEwEqLcEkp1/rMt7yd5W7MtEpX
   XZ4PwJITCM40V4+ZYuMv6ekadRLFzM1gEKxYU4kl0DykoE44kd9z8t6IA
   OywU3lip+XjFhB+vqy63e1hvBLiBjkajDiWg7RXnr/ircP3BOzPA20GZT
   g3rVPOCrevBBiVnju3wNqtbTTJCORyMVEGevjny/ODVNvbRuf5W5dBxWp
   s5vAFMPl1SSVxVjqbtUIaICboJDOer9qJWld2nBgCWsCo0WiLnykbi596
   A==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="202772975"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 02:16:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 02:16:16 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 02:16:10 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v2 08/13] net: dsa: microchip: ptp: add packet transmission timestamping
Date:   Tue, 6 Dec 2022 14:44:23 +0530
Message-ID: <20221206091428.28285-9-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221206091428.28285-1-arun.ramadoss@microchip.com>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
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

This patch adds the routines for transmission of ptp packets. When the
ptp pdelay_req packet to be transmitted, it uses the deferred xmit
worker to schedule the packets.
During irq_setup, interrupt for Sync, Pdelay_req and Pdelay_rsp are
enabled. So interrupt is triggered for all three packets. But for
p2p1step, we require only time stamp of Pdelay_req packet. Hence to
avoid posting of the completion from ISR routine for Sync and
Pdelay_resp packets, ts_en flag is introduced. This controls which
packets need to processed for timestamp.
After the packet is transmitted, ISR is triggered. The time at which
packet transmitted is recorded to separate register.
This value is reconstructed to absolute time and posted to the user
application through socket error queue.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
v1 -> v2
- Declared the deferred xmit and ksz_port_txtstamp function as null in
ptp disabled case

RFC v2 -> Patch v1
- separated the pdelay_rsp message correction update in different patch
---
 drivers/net/dsa/microchip/ksz_common.c |   2 +
 drivers/net/dsa/microchip/ksz_common.h |   3 +
 drivers/net/dsa/microchip/ksz_ptp.c    | 116 ++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_ptp.h    |   6 ++
 include/linux/dsa/ksz_common.h         |  14 +++
 net/dsa/tag_ksz.c                      |  54 +++++++++++-
 6 files changed, 191 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 306bdc1469d2..3b578a4a33de 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2460,6 +2460,7 @@ static int ksz_connect_tag_protocol(struct dsa_switch *ds,
 	struct ksz_tagger_data *tagger_data;
 
 	tagger_data = ksz_tagger_data(ds);
+	tagger_data->xmit_work_fn = ksz_port_deferred_xmit;
 	tagger_data->meta_tstamp_handler = ksz_tstamp_reconstruct;
 
 	return 0;
@@ -2899,6 +2900,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_ts_info            = ksz_get_ts_info,
 	.port_hwtstamp_get      = ksz_hwtstamp_get,
 	.port_hwtstamp_set      = ksz_hwtstamp_set,
+	.port_txtstamp		= ksz_port_txtstamp,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 3dac6d52a002..379967711f25 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -87,6 +87,7 @@ struct ksz_irq {
 struct ksz_ptp_irq {
 	struct ksz_port *port;
 	u16 ts_reg;
+	bool ts_en;
 	char name[16];
 	int irq_num;
 };
@@ -117,6 +118,8 @@ struct ksz_port {
 	bool hwts_rx_en;
 	struct ksz_irq ptpirq;
 	struct ksz_ptp_irq ptpmsg_irq[3];
+	ktime_t tstamp_msg;
+	struct completion tstamp_msg_comp;
 #endif
 };
 
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index d848549d1517..dcecc08a8d42 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -111,9 +111,15 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
 
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
+		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = 0;
+		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 0;
+		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 0;
 		prt->hwts_tx_en = false;
 		break;
 	case HWTSTAMP_TX_ONESTEP_P2P:
+		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = 0;
+		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 1;
+		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 0;
 		prt->hwts_tx_en = true;
 		break;
 	default:
@@ -169,6 +175,47 @@ int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config));
 }
 
+void ksz_port_txtstamp(struct dsa_switch *ds, int port,
+		       struct sk_buff *skb)
+{
+	struct ksz_device *dev	= ds->priv;
+	struct ptp_header *hdr;
+	struct sk_buff *clone;
+	struct ksz_port *prt;
+	unsigned int type;
+	u8 ptp_msg_type;
+
+	prt = &dev->ports[port];
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
+}
+
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
 {
 	u32 nanoseconds;
@@ -398,6 +445,49 @@ ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
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
+	dsa_enqueue_skb(skb, skb->dev);
+
+	ksz_ptp_txtstamp_skb(dev, prt, clone);
+
+	kfree(xmit_work);
+}
+
 int ksz_ptp_clock_register(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
@@ -446,7 +536,29 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds)
 
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
@@ -597,6 +709,8 @@ int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
 						REG_PTP_PORT_TX_INT_STATUS__2);
 	snprintf(ptpirq->name, sizeof(ptpirq->name), "ptp_irq-%d", p);
 
+	init_completion(&port->tstamp_msg_comp);
+
 	ptpirq->irq_num = irq_find_mapping(port->pirq.domain, PORT_SRC_PTP_INT);
 	if (ptpirq->irq_num < 0)
 		return ptpirq->irq_num;
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index d5ec4c842401..a42253c8080f 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -30,8 +30,10 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port,
 		    struct ethtool_ts_info *ts);
 int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
+void ksz_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
 int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
 void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
+void ksz_port_deferred_xmit(struct kthread_work *work);
 ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp);
 
 #else
@@ -63,6 +65,10 @@ static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
 
 #define ksz_tstamp_reconstruct NULL
 
+#define ksz_port_txtstamp NULL
+
+#define ksz_port_deferred_xmit NULL
+
 #endif	/* End of CONFIG_NET_DSA_MICROCHIP_KSZ_PTP */
 
 #endif
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index 019c13a8d89a..55ee714a9a13 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -23,11 +23,25 @@ static inline ktime_t ksz_decode_tstamp(u32 tstamp)
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
 	void (*hwtstamp_set_state)(struct dsa_switch *ds, bool on);
 	ktime_t (*meta_tstamp_handler)(struct dsa_switch *ds, ktime_t tstamp);
 };
 
+struct ksz_skb_cb {
+	struct sk_buff *clone;
+};
+
+#define KSZ_SKB_CB(skb) \
+	((struct ksz_skb_cb *)((skb)->cb))
+
 static inline struct ksz_tagger_data *
 ksz_tagger_data(struct dsa_switch *ds)
 {
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 8936ba715627..cdca1f15fc6f 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -27,6 +27,7 @@
 struct ksz_tagger_private {
 	struct ksz_tagger_data data; /* Must be first */
 	unsigned long state;
+	struct kthread_worker *xmit_worker;
 };
 
 static struct ksz_tagger_private *
@@ -49,6 +50,7 @@ static void ksz_disconnect(struct dsa_switch *ds)
 {
 	struct ksz_tagger_private *priv = ds->tagger_data;
 
+	kthread_destroy_worker(priv->xmit_worker);
 	kfree(priv);
 	ds->tagger_data = NULL;
 }
@@ -56,12 +58,23 @@ static void ksz_disconnect(struct dsa_switch *ds)
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
 	tagger_data->hwtstamp_set_state = ksz_hwtstamp_set_state;
@@ -233,6 +246,41 @@ static void ksz_xmit_timestamp(struct dsa_port *dp, struct sk_buff *skb)
 	put_unaligned_be32(0, skb_put(skb, KSZ_PTP_TAG_LEN));
 }
 
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
@@ -257,7 +305,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	*tag = cpu_to_be16(val);
 
-	return skb;
+	return ksz_defer_xmit(dp, skb);
 }
 
 static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
@@ -313,7 +361,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
-	return skb;
+	return ksz_defer_xmit(dp, skb);
 }
 
 static const struct dsa_device_ops ksz9893_netdev_ops = {
@@ -378,7 +426,7 @@ static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 
 	put_unaligned_be16(val, tag);
 
-	return skb;
+	return ksz_defer_xmit(dp, skb);
 }
 
 static const struct dsa_device_ops lan937x_netdev_ops = {
-- 
2.36.1

