Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD5A3A37D2
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFJX3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhFJX3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:29:04 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947C2C0617AE
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:26:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id h24so1681912ejy.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z1U9ZrmyPCyzwpDSrnx1UvFvJVk+rrmOuINXczFJEpk=;
        b=R0sHwBMANPp2Zyi27nPcPn1gVvXMKaE1MrDbRQXAyDCahbeNfJb18yKOrpDWSZlAAR
         9hlrUUFJsTeV7tvErUKRP0lfh2J3SfSnvF2xLbAl2kPAake7kVGvc0zoMQDcaCoY24XS
         wrdyFjuQWVxPMdgwkGtA7uKHe1HtLW6e0HxlGwWYCgnU3yArIVr0eQS+QhTdIxAp3ik9
         gztJVjKe/laqsuoAPxV6MWcQO3F2AgZJItFs6jvxLJak8PdS4BCUTj5KG0UjIkoOH8A7
         Lralmi0RGdkfgHbE47xeur+kQg3V3FdCDzSuXsBC5+U6W1lSy6rZoM/uSjKEI2x4Giqu
         3wxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z1U9ZrmyPCyzwpDSrnx1UvFvJVk+rrmOuINXczFJEpk=;
        b=WImXP0lOGtX1o8BJ2aSdOzcNOIO+BGC/nlp1rEFJ2LyGuztcKaTyYPNzFqbro77RAS
         4BJhakdM07bsTSa/Yp8t5dO8SRQFEXQRf5bPqQxW0O9uodPJcdYf/AjixPlV8SKoaP7B
         MDL7YoOTt4msVsTB0FZVSpXcMPI7PtOvkbqo7iD44ZoXtjyNob/nqg9mi6HYo1+OJmT5
         sr3mlfeg4cRVPm349m/2EDoYVDoUeYjvEriQtG4sZ8hTefmGDPkd/pc+MjhfWqHLJtWe
         bmteeikdQB9d0c6ndcYVxdK1nf2j8firQjOk2scpEFrxfp98gsvR7T5Ia2GOL+xZwoHx
         JoKA==
X-Gm-Message-State: AOAM533zI2M1JW+YdYBALaeHVE0pH3omjXMRHXGyPFgP+sFDOo8e1UYi
        XMOufU8TrhH1dDAA1BmJibU=
X-Google-Smtp-Source: ABdhPJwvau8LsFoCoexeU26yk+QUVjaA8jMpL6C88P1TJPmc8luuBzb44WZL2Zei7qyV+WUCS23bjQ==
X-Received: by 2002:a17:907:2cf6:: with SMTP id hz22mr843346ejc.320.1623367612109;
        Thu, 10 Jun 2021 16:26:52 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id j22sm1534187ejt.11.2021.06.10.16.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:26:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 10/10] net: dsa: sja1105: implement TX timestamping for SJA1110
Date:   Fri, 11 Jun 2021 02:26:29 +0300
Message-Id: <20210610232629.1948053-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610232629.1948053-1-olteanv@gmail.com>
References: <20210610232629.1948053-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The TX timestamping procedure for SJA1105 is a bit unconventional
because the transmit procedure itself is unconventional.

Control packets (and therefore PTP as well) are transmitted to a
specific port in SJA1105 using "management routes" which must be written
over SPI to the switch. These are one-shot rules that match by
destination MAC address on traffic coming from the CPU port, and select
the precise destination port for that packet. So to transmit a packet
from NET_TX softirq context, we actually need to defer to a process
context so that we can perform that SPI write before we send the packet.
The DSA master dev_queue_xmit() runs in process context, and we poll
until the switch confirms it took the TX timestamp, then we annotate the
skb clone with that TX timestamp. This is why the sja1105 driver does
not need an skb queue for TX timestamping.

But the SJA1110 is a bit (not much!) more conventional, and you can
request 2-step TX timestamping through the DSA header, as well as give
the switch a cookie (timestamp ID) which it will give back to you when
it has the timestamp. So now we do need a queue for keeping the skb
clones until their TX timestamps become available.

The interesting part is that the metadata frames from SJA1105 haven't
disappeared completely. On SJA1105 they were used as follow-ups which
contained RX timestamps, but on SJA1110 they are actually TX completion
packets, which contain a variable (up to 32) array of timestamps.
Why an array? Because:
- not only is the TX timestamp on the egress port being communicated,
  but also the RX timestamp on the CPU port. Nice, but we don't care
  about that, so we ignore it.
- because a packet could be multicast to multiple egress ports, each
  port takes its own timestamp, and the TX completion packet contains
  the individual timestamps on each port.

This is unconventional because switches typically have a timestamping
FIFO and raise an interrupt, but this one doesn't. So the tagger needs
to detect and parse meta frames, and call into the main switch driver,
which pairs the timestamps with the skbs in the TX timestamping queue
which are waiting for one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: export the sja1110_process_meta_tstamp symbol to avoid build
        errors as module

 drivers/net/dsa/sja1105/sja1105.h     |  1 +
 drivers/net/dsa/sja1105/sja1105_ptp.c | 69 +++++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_ptp.h |  7 +++
 drivers/net/dsa/sja1105/sja1105_spi.c |  4 ++
 include/linux/dsa/sja1105.h           | 23 +++++++++
 net/dsa/tag_sja1105.c                 | 52 ++++++++++++++++++++
 6 files changed, 156 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index f1bf290cc8a4..39124726bdd9 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -132,6 +132,7 @@ struct sja1105_info {
 	void (*ptp_cmd_packing)(u8 *buf, struct sja1105_ptp_cmd *cmd,
 				enum packing_op op);
 	bool (*rxtstamp)(struct dsa_switch *ds, int port, struct sk_buff *skb);
+	void (*txtstamp)(struct dsa_switch *ds, int port, struct sk_buff *skb);
 	int (*clocking_setup)(struct sja1105_private *priv);
 	int (*pcs_mdio_read)(struct mii_bus *bus, int phy, int reg);
 	int (*pcs_mdio_write)(struct mii_bus *bus, int phy, int reg, u16 val);
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 62fe05b4cb60..691f6dd7e669 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -79,6 +79,7 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 		priv->tagger_data.stampable_skb = NULL;
 	}
 	ptp_cancel_worker_sync(ptp_data->clock);
+	skb_queue_purge(&ptp_data->skb_txtstamp_queue);
 	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 
 	return sja1105_static_config_reload(priv, SJA1105_RX_HWTSTAMPING);
@@ -451,6 +452,67 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 	return priv->info->rxtstamp(ds, port, skb);
 }
 
+void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port, u8 ts_id,
+				 enum sja1110_meta_tstamp dir, u64 tstamp)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+	struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
+	struct skb_shared_hwtstamps shwt = {0};
+
+	/* We don't care about RX timestamps on the CPU port */
+	if (dir == SJA1110_META_TSTAMP_RX)
+		return;
+
+	spin_lock(&ptp_data->skb_txtstamp_queue.lock);
+
+	skb_queue_walk_safe(&ptp_data->skb_txtstamp_queue, skb, skb_tmp) {
+		if (SJA1105_SKB_CB(skb)->ts_id != ts_id)
+			continue;
+
+		__skb_unlink(skb, &ptp_data->skb_txtstamp_queue);
+		skb_match = skb;
+
+		break;
+	}
+
+	spin_unlock(&ptp_data->skb_txtstamp_queue.lock);
+
+	if (WARN_ON(!skb_match))
+		return;
+
+	shwt.hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(tstamp));
+	skb_complete_tx_timestamp(skb_match, &shwt);
+}
+EXPORT_SYMBOL_GPL(sja1110_process_meta_tstamp);
+
+/* In addition to cloning the skb which is done by the common
+ * sja1105_port_txtstamp, we need to generate a timestamp ID and save the
+ * packet to the TX timestamping queue.
+ */
+void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
+{
+	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+	struct sja1105_port *sp = &priv->ports[port];
+	u8 ts_id;
+
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	spin_lock(&sp->data->meta_lock);
+
+	ts_id = sp->data->ts_id;
+	/* Deal automatically with 8-bit wraparound */
+	sp->data->ts_id++;
+
+	SJA1105_SKB_CB(clone)->ts_id = ts_id;
+
+	spin_unlock(&sp->data->meta_lock);
+
+	skb_queue_tail(&ptp_data->skb_txtstamp_queue, clone);
+}
+
 /* Called from dsa_skb_tx_timestamp. This callback is just to clone
  * the skb and have it available in SJA1105_SKB_CB in the .port_deferred_xmit
  * callback, where we will timestamp it synchronously.
@@ -469,6 +531,9 @@ void sja1105_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 		return;
 
 	SJA1105_SKB_CB(skb)->clone = clone;
+
+	if (priv->info->txtstamp)
+		priv->info->txtstamp(ds, port, skb);
 }
 
 static int sja1105_ptp_reset(struct dsa_switch *ds)
@@ -885,7 +950,10 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 		.n_per_out	= 1,
 	};
 
+	/* Only used on SJA1105 */
 	skb_queue_head_init(&ptp_data->skb_rxtstamp_queue);
+	/* Only used on SJA1110 */
+	skb_queue_head_init(&ptp_data->skb_txtstamp_queue);
 	spin_lock_init(&tagger_data->meta_lock);
 
 	ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);
@@ -910,6 +978,7 @@ void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 
 	del_timer_sync(&ptp_data->extts_timer);
 	ptp_cancel_worker_sync(ptp_data->clock);
+	skb_queue_purge(&ptp_data->skb_txtstamp_queue);
 	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 	ptp_clock_unregister(ptp_data->clock);
 	ptp_data->clock = NULL;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index bf0c4f1dfed7..3c874bb4c17b 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -75,7 +75,12 @@ struct sja1105_ptp_cmd {
 
 struct sja1105_ptp_data {
 	struct timer_list extts_timer;
+	/* Used only on SJA1105 to reconstruct partial timestamps */
 	struct sk_buff_head skb_rxtstamp_queue;
+	/* Used on SJA1110 where meta frames are generated only for
+	 * 2-step TX timestamps
+	 */
+	struct sk_buff_head skb_txtstamp_queue;
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
 	struct sja1105_ptp_cmd cmd;
@@ -124,6 +129,7 @@ int sja1105_ptp_commit(struct dsa_switch *ds, struct sja1105_ptp_cmd *cmd,
 
 bool sja1105_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
 bool sja1110_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
+void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
 
 #else
 
@@ -189,6 +195,7 @@ static inline int sja1105_ptp_commit(struct dsa_switch *ds,
 
 #define sja1105_rxtstamp NULL
 #define sja1110_rxtstamp NULL
+#define sja1110_txtstamp NULL
 
 #endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP) */
 
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 47b2b5451ba0..7c493c6a839d 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -795,6 +795,7 @@ const struct sja1105_info sja1110a_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
+	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
@@ -845,6 +846,7 @@ const struct sja1105_info sja1110b_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
+	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
@@ -895,6 +897,7 @@ const struct sja1105_info sja1110c_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
+	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
@@ -945,6 +948,7 @@ const struct sja1105_info sja1110d_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
+	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index b02cf7b515ae..b6089b88314c 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -45,11 +45,14 @@ struct sja1105_tagger_data {
 	 */
 	spinlock_t meta_lock;
 	unsigned long state;
+	u8 ts_id;
 };
 
 struct sja1105_skb_cb {
 	struct sk_buff *clone;
 	u64 tstamp;
+	/* Only valid for packets cloned for 2-step TX timestamping */
+	u8 ts_id;
 };
 
 #define SJA1105_SKB_CB(skb) \
@@ -66,4 +69,24 @@ struct sja1105_port {
 	u16 xmit_tpid;
 };
 
+enum sja1110_meta_tstamp {
+	SJA1110_META_TSTAMP_TX = 0,
+	SJA1110_META_TSTAMP_RX = 1,
+};
+
+#if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
+
+void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port, u8 ts_id,
+				 enum sja1110_meta_tstamp dir, u64 tstamp);
+
+#else
+
+static inline void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
+					       u8 ts_id, enum sja1110_meta_tstamp dir,
+					       u64 tstamp)
+{
+}
+
+#endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP) */
+
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 37e1d64e07c6..9c2df9ece01b 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -25,6 +25,9 @@
 #define SJA1110_RX_TRAILER_SWITCH_ID(x)		(((x) & GENMASK(7, 4)) >> 4)
 #define SJA1110_RX_TRAILER_SRC_PORT(x)		((x) & GENMASK(3, 0))
 
+/* Meta frame format (for 2-step TX timestamps) */
+#define SJA1110_RX_HEADER_N_TS(x)		(((x) & GENMASK(8, 4)) >> 4)
+
 /* TX header */
 #define SJA1110_TX_HEADER_UPDATE_TC		BIT(14)
 #define SJA1110_TX_HEADER_TAKE_TS		BIT(13)
@@ -43,6 +46,8 @@
 #define SJA1110_TX_TRAILER_SWITCHID(x)		(((x) << 12) & GENMASK(15, 12))
 #define SJA1110_TX_TRAILER_DESTPORTS(x)		(((x) << 1) & GENMASK(11, 1))
 
+#define SJA1110_META_TSTAMP_SIZE		10
+
 #define SJA1110_HEADER_LEN			4
 #define SJA1110_RX_TRAILER_LEN			13
 #define SJA1110_TX_TRAILER_LEN			4
@@ -184,6 +189,7 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
+	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
@@ -221,6 +227,12 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 	*tx_trailer = cpu_to_be32(SJA1110_TX_TRAILER_PRIO(pcp) |
 				  SJA1110_TX_TRAILER_SWITCHID(dp->ds->index) |
 				  SJA1110_TX_TRAILER_DESTPORTS(BIT(dp->index)));
+	if (clone) {
+		u8 ts_id = SJA1105_SKB_CB(clone)->ts_id;
+
+		*tx_header |= htons(SJA1110_TX_HEADER_TAKE_TS);
+		*tx_trailer |= cpu_to_be32(SJA1110_TX_TRAILER_TSTAMP_ID(ts_id));
+	}
 
 	return skb;
 }
@@ -423,6 +435,43 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 					      is_meta);
 }
 
+static struct sk_buff *sja1110_rcv_meta(struct sk_buff *skb, u16 rx_header)
+{
+	int switch_id = SJA1110_RX_HEADER_SWITCH_ID(rx_header);
+	int n_ts = SJA1110_RX_HEADER_N_TS(rx_header);
+	struct net_device *master = skb->dev;
+	struct dsa_port *cpu_dp;
+	u8 *buf = skb->data + 2;
+	struct dsa_switch *ds;
+	int i;
+
+	cpu_dp = master->dsa_ptr;
+	ds = dsa_switch_find(cpu_dp->dst->index, switch_id);
+	if (!ds) {
+		net_err_ratelimited("%s: cannot find switch id %d\n",
+				    master->name, switch_id);
+		return NULL;
+	}
+
+	for (i = 0; i <= n_ts; i++) {
+		u8 ts_id, source_port, dir;
+		u64 tstamp;
+
+		ts_id = buf[0];
+		source_port = (buf[1] & GENMASK(7, 4)) >> 4;
+		dir = (buf[1] & BIT(3)) >> 3;
+		tstamp = be64_to_cpu(*(__be64 *)(buf + 2));
+
+		sja1110_process_meta_tstamp(ds, source_port, ts_id, dir,
+					    tstamp);
+
+		buf += SJA1110_META_TSTAMP_SIZE;
+	}
+
+	/* Discard the meta frame, we've consumed the timestamps it contained */
+	return NULL;
+}
+
 static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 							    int *source_port,
 							    int *switch_id)
@@ -439,6 +488,9 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 	 */
 	rx_header = ntohs(*(__be16 *)skb->data);
 
+	if (rx_header & SJA1110_RX_HEADER_IS_METADATA)
+		return sja1110_rcv_meta(skb, rx_header);
+
 	/* Timestamp frame, we have a trailer */
 	if (rx_header & SJA1110_RX_HEADER_HAS_TRAILER) {
 		int start_of_padding = SJA1110_RX_HEADER_TRAILER_POS(rx_header);
-- 
2.25.1

