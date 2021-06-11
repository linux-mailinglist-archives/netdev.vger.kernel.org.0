Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C393A491E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhFKTEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:04:54 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:46736 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhFKTEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:04:53 -0400
Received: by mail-ej1-f52.google.com with SMTP id he7so5966420ejc.13
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eJcz0wPaazfMbj58ItsXoBlVakEJe2uKL9C8eaaPgM4=;
        b=c3YG2wATDL6GORgs4wrs0aQUV1vbXouDcvQmdHHsAoPNBxnBPDJ/53/D9y0oDOM2cY
         QtIzGMIipcescylmzALkjdbsr/qSUhzE3x6qFxhsuAQFA8VBEeLnWMzAgmxMXYfnaFD/
         1xtD3K1uFHr7W64BpK3nsY1T59m+etfkEszerZQkvEOwv6iL0hyBYfzs685+d6N0gkE7
         jY1fb/2q2PmJwic0aoKYQHEFd0AIu30Ny+lUeM8ql/2d6/ZUTd3EXGNFrgCZDpc65Ata
         43ME9dq9SuaHJhw67FaYKThgqMmUBAkrLhP6dIvNzkq4lIMtjPW36uHS+5p3FFa7Cm1H
         5bHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eJcz0wPaazfMbj58ItsXoBlVakEJe2uKL9C8eaaPgM4=;
        b=URhJ1wrYjWWwBckcB44/a043tqF7ozQyKO7ey0R2ZyqrERxEaMGiotYmTEBjW64drO
         PnUk6B+0kI0p7J3svWKM5078fmGBPpNYsJhNpjfpNmfee4/Ik6+/mRC6XhmBNZ3AW9Gh
         /Mcl6GTijseuad6cLyA+jvNjrlWPHzxZ5R+CTmp+oHWKFOKz9D9Vyx8ceJXzEWX8mvze
         v9zRQ9CPjyE+nT2NZvaXZlgJLB0tSvhXD3ekBSdZW1T5aHedJ2I9SJ4TSgapJFkxZZc3
         DIc8U/zDZpweQjItKVbHaPqTM5ffthgX3hv5Q1Ms4HEfbabpl4W2ULJfRGTPoaf8GTWw
         3vBg==
X-Gm-Message-State: AOAM530poamdyBQwNSv9e9DejgirEWtBQ/kVO7NEYK7KEeXLZTLoR8ew
        2T1tblcuasbGwtRxzcX9sJA=
X-Google-Smtp-Source: ABdhPJygKvKHB9jTe4PogiHYaec/xdcQ2zyz7ntSdoIVYrIFzZdHnC+eTn7H+mSbWfwvX6Fwku56xw==
X-Received: by 2002:a17:906:fa93:: with SMTP id lt19mr5106018ejb.54.1623438114298;
        Fri, 11 Jun 2021 12:01:54 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c19sm2922016edw.10.2021.06.11.12.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:01:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 10/10] net: dsa: sja1105: implement TX timestamping for SJA1110
Date:   Fri, 11 Jun 2021 22:01:31 +0300
Message-Id: <20210611190131.2362911-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611190131.2362911-1-olteanv@gmail.com>
References: <20210611190131.2362911-1-olteanv@gmail.com>
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
v2->v3: context change due to rebase
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
index 201bca282884..5f3449351668 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -131,6 +131,7 @@ struct sja1105_info {
 	void (*ptp_cmd_packing)(u8 *buf, struct sja1105_ptp_cmd *cmd,
 				enum packing_op op);
 	bool (*rxtstamp)(struct dsa_switch *ds, int port, struct sk_buff *skb);
+	void (*txtstamp)(struct dsa_switch *ds, int port, struct sk_buff *skb);
 	int (*clocking_setup)(struct sja1105_private *priv);
 	const char *name;
 	bool supports_mii[SJA1105_MAX_NUM_PORTS];
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
index f7dd86271891..32d00212423c 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -788,6 +788,7 @@ const struct sja1105_info sja1110a_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
+	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -836,6 +837,7 @@ const struct sja1105_info sja1110b_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
+	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -884,6 +886,7 @@ const struct sja1105_info sja1110c_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
+	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -932,6 +935,7 @@ const struct sja1105_info sja1110d_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
+	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
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

