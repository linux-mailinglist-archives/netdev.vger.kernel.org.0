Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BBA2D294
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 01:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfE1X6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:58:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50701 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfE1X6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:58:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id f204so305359wme.0;
        Tue, 28 May 2019 16:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LqNO2pT2xky7rgUUNF9AtE2Z7EE2MdtuOxpltorxyoQ=;
        b=CFAfjmh18sqPfPR698TZY6631d8InqUOqQ2pIU6FQxA4LngBAZZzX/2eYKTCIEg+ZL
         s8erkBWNVfKF3vTfjT8wGg+iMXZNvys3v0h9JGZUuv/8NM9ZMXBFgAuM61eVbaBiPrJ+
         DtBezL9D2w3VsViyWTiupcK3QxslnSFFFE4jjqi1l0g+mNPXxj+mccCy97X7C8HRYKM4
         9Nri1/Xty5TP7/lxoqP4747lZWAMQC5JE3jmIyK8xvKZUP8XCjzMlWcdWkclX8wery+y
         +3c3+GxrmhcC+UjA5A6Trql2NwF6Zd8Oqyfa5exr3KY8TPKJdeyzZK2nvfUahMLq3YoZ
         1zGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LqNO2pT2xky7rgUUNF9AtE2Z7EE2MdtuOxpltorxyoQ=;
        b=UnhioM+LJnJMgxewUdJdvRHxakK56eq8QdCeaGz28k19SBGdT4sleU0s3ydghfolfg
         cR5MEp3YXc12Yt18UfP7+GHuNBWqCx8tayy5O817b75krffVeYrlDeuXO1NTJ5QLLR3K
         lcqYNNJTFjiQKxeRCjORFsPr/RQLVmQBUGBkExEUizqNg3MJah7lIqFL2cdE1NUT7wG8
         /haUH1PT2BCoSupDTjBXtGW2MpVtOnIe1vcXJg1xNQmDw4WlZ2unyVO0mpixmi+hb5vc
         8CYUwSbFyKinVNJ55PzM8IMA9XZ9+Sb1nDz+wberqh1LyfpcpenkviQI3lxizHEjZzGE
         TyEg==
X-Gm-Message-State: APjAAAXTM/XTkCkSSI9SQdxINBzWQjYeKv0XZKlsWV9/5i0UCfZRaObI
        VwORP4WSfVx+z7K1jc95f4Y=
X-Google-Smtp-Source: APXvYqyDquOYJgsXpjie9h73C7l8PMyutjhK8mMj6iAV07Mn9CL42qh4WVzBAgILsuP2k7GMm9WvHA==
X-Received: by 2002:a1c:c8:: with SMTP id 191mr4980823wma.6.1559087912315;
        Tue, 28 May 2019 16:58:32 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f3sm1207505wre.93.2019.05.28.16.58.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 16:58:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 4/5] net: dsa: sja1105: Add support for PTP timestamping
Date:   Wed, 29 May 2019 02:56:26 +0300
Message-Id: <20190528235627.1315-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528235627.1315-1-olteanv@gmail.com>
References: <20190528235627.1315-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On RX, timestamping is done by programming the switch to send "meta"
follow-up Ethernet frames after each link-local frame that was trapped
to the CPU port through MAC filtering. This includes PTP frames. These
meta frames contain partial timestamps that are processed in a worker
thread and then the link-local traffic is released back on its path up
the network stack once the timestamps are in place.

Meta frame reception relies on the hardware keeping its promise that it
will send no other traffic towards the CPU port between a link-local
frame and a meta frame. The receive function is made stateful while
expecting for the meta frame to arrive, and a last_stampable_skb pointer
is kept. Otherwise there is no other way to associate the meta frame
with the link-local frame it's holding a timestamp of.

On TX, timestamping is performed synchronously from the port_deferred_xmit
worker thread. In management routes, the switch is requested to take
egress timestamps (again partial), which are reconstructed and appended
to a clone of the skb that was just sent. The cloning is done by DSA and
we retrieve the pointer from the structure that DSA keeps in skb->cb.
Then these clones are enqueued to the socket's error queue for
application-level processing.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h             |  13 +-
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 263 +++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_ptp.c         |  68 ++++-
 drivers/net/dsa/sja1105/sja1105_ptp.h         |   8 +
 drivers/net/dsa/sja1105/sja1105_spi.c         |  16 +-
 .../net/dsa/sja1105/sja1105_static_config.c   |  59 ++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  10 +
 include/linux/dsa/sja1105.h                   |  15 +
 net/dsa/tag_sja1105.c                         | 135 ++++++++-
 10 files changed, 580 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index e0252e6f65ed..f03432bd0e36 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -33,7 +33,7 @@ struct sja1105_regs {
 	u64 ptpclk;
 	u64 ptpclkrate;
 	u64 ptptsclk;
-	u64 ptpegr_ts;
+	u64 ptpegr_ts[SJA1105_NUM_PORTS];
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
 	u64 cgu_idiv[SJA1105_NUM_PORTS];
 	u64 rgmii_pad_mii_tx[SJA1105_NUM_PORTS];
@@ -57,6 +57,15 @@ struct sja1105_info {
 	 * switch core and device_id)
 	 */
 	u64 part_no;
+	/* E/T and P/Q/R/S have partial timestamps of different sizes.
+	 * They must be reconstructed on both families anyway to get the full
+	 * 64-bit values back.
+	 */
+	int ptp_ts_bits;
+	/* Also SPI commands are of different sizes to retrieve
+	 * the egress timestamps.
+	 */
+	int ptpegr_ts_bytes;
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
@@ -89,6 +98,8 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	/* RX timestamping flag is global */
+	bool hwts_rx_en;
 };
 
 #include "sja1105_dynamic_config.h"
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index e73ab28bf632..6f0e9d180f3e 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -293,6 +293,7 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.addr = 0x38,
 	},
 	[BLK_IDX_L2_FORWARDING_PARAMS] = {0},
+	[BLK_IDX_AVB_PARAMS] = {0},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.entry_packing = sja1105et_general_params_entry_packing,
 		.cmd_packing = sja1105et_general_params_cmd_packing,
@@ -348,6 +349,7 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.addr = 0x38,
 	},
 	[BLK_IDX_L2_FORWARDING_PARAMS] = {0},
+	[BLK_IDX_AVB_PARAMS] = {0},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.entry_packing = sja1105et_general_params_entry_packing,
 		.cmd_packing = sja1105et_general_params_cmd_packing,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8bce1af13d53..ce516615536d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -499,6 +499,39 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	return 0;
 }
 
+static int sja1105_init_avb_params(struct sja1105_private *priv,
+				   bool on)
+{
+	struct sja1105_avb_params_entry *avb;
+	struct sja1105_table *table;
+
+	table = &priv->static_config.tables[BLK_IDX_AVB_PARAMS];
+
+	/* Discard previous AVB Parameters Table */
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	/* Configure the reception of meta frames only if requested */
+	if (!on)
+		return 0;
+
+	table->entries = kcalloc(SJA1105_MAX_AVB_PARAMS_COUNT,
+				 table->ops->unpacked_entry_size, GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+
+	table->entry_count = SJA1105_MAX_AVB_PARAMS_COUNT;
+
+	avb = table->entries;
+
+	avb->destmeta = SJA1105_META_DMAC;
+	avb->srcmeta  = SJA1105_META_SMAC;
+
+	return 0;
+}
+
 static int sja1105_static_config_load(struct sja1105_private *priv,
 				      struct sja1105_dt_port *ports)
 {
@@ -537,6 +570,9 @@ static int sja1105_static_config_load(struct sja1105_private *priv,
 	if (rc < 0)
 		return rc;
 	rc = sja1105_init_general_params(priv);
+	if (rc < 0)
+		return rc;
+	rc = sja1105_init_avb_params(priv, false);
 	if (rc < 0)
 		return rc;
 
@@ -1407,7 +1443,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 }
 
 static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
-			     struct sk_buff *skb)
+			     struct sk_buff *skb, bool takets)
 {
 	struct sja1105_mgmt_entry mgmt_route = {0};
 	struct sja1105_private *priv = ds->priv;
@@ -1420,6 +1456,8 @@ static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
 	mgmt_route.macaddr = ether_addr_to_u64(hdr->h_dest);
 	mgmt_route.destports = BIT(port);
 	mgmt_route.enfport = 1;
+	mgmt_route.tsreg = 0;
+	mgmt_route.takets = takets;
 
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MGMT_ROUTE,
 					  slot, &mgmt_route, true);
@@ -1469,7 +1507,12 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_port *sp = &priv->ports[port];
+	struct skb_shared_hwtstamps shwt = {0};
 	int slot = sp->mgmt_slot;
+	struct sk_buff *clone;
+	int timeout = 10;
+	int rc;
+	u64 ts;
 
 	/* The tragic fact about the switch having 4x2 slots for installing
 	 * management routes is that all of them except one are actually
@@ -1487,8 +1530,39 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 	 */
 	mutex_lock(&priv->mgmt_lock);
 
-	sja1105_mgmt_xmit(ds, port, slot, skb);
+	/* The clone, if there, was made by dsa_skb_tx_timestamp */
+	clone = DSA_SKB_CB(skb)->clone;
+
+	sja1105_mgmt_xmit(ds, port, slot, skb, !!clone);
+
+	if (!clone)
+		goto out;
+
+	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
 
+	mutex_lock(&priv->ptp_lock);
+
+	do {
+		rc = sja1105_ptpegr_ts_poll(priv, slot, &ts);
+		if (rc < 0 && rc != -EAGAIN) {
+			dev_err(ds->dev, "xmit: failed to poll for tstamp\n");
+			kfree_skb(clone);
+			goto out_unlock_ptp;
+		}
+		usleep_range(10, 50);
+	} while (rc == -EAGAIN && --timeout);
+
+	if (!timeout)
+		dev_err(priv->ds->dev, "xmit: timed out polling for ts\n");
+
+	ts = timecounter_cyc2time(&priv->tstamp_tc, ts);
+
+	shwt.hwtstamp = ns_to_ktime(ts);
+	skb_complete_tx_timestamp(clone, &shwt);
+
+out_unlock_ptp:
+	mutex_unlock(&priv->ptp_lock);
+out:
 	mutex_unlock(&priv->mgmt_lock);
 	return NETDEV_TX_OK;
 }
@@ -1517,6 +1591,184 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 	return sja1105_static_config_reload(priv);
 }
 
+static int sja1105_change_rxtstamping(struct sja1105_private *priv,
+				      bool on)
+{
+	struct sja1105_general_params_entry *general_params;
+	struct sja1105_table *table;
+	int rc;
+
+	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
+	general_params = table->entries;
+	general_params->send_meta1 = on;
+	general_params->send_meta0 = on;
+
+	rc = sja1105_init_avb_params(priv, on);
+	if (rc < 0)
+		return rc;
+
+	return sja1105_static_config_reload(priv);
+}
+
+static int sja1105_hwtstamp_set(struct dsa_switch *ds, int port,
+				struct ifreq *ifr)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct hwtstamp_config config;
+	bool rx_on;
+	int rc, i;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	switch (config.tx_type) {
+	case HWTSTAMP_TX_OFF:
+		priv->ports[port].hwts_tx_en = false;
+		break;
+	case HWTSTAMP_TX_ON:
+		priv->ports[port].hwts_tx_en = true;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		rx_on = false;
+		break;
+	default:
+		rx_on = true;
+		break;
+	}
+
+	if (rx_on != priv->hwts_rx_en) {
+		rc = sja1105_change_rxtstamping(priv, rx_on);
+		if (rc < 0) {
+			dev_err(ds->dev,
+				"Failed to change RX timestamping: %d\n", rc);
+			return -EFAULT;
+		}
+		priv->hwts_rx_en = rx_on;
+		/* Duplicate the setting to struct sja1105_port for
+		 * access from the tagger code
+		 */
+		for (i = 0; i < SJA1105_NUM_PORTS; i++)
+			priv->ports[i].hwts_rx_en = rx_on;
+	}
+
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+	return 0;
+}
+
+static int sja1105_hwtstamp_get(struct dsa_switch *ds, int port,
+				struct ifreq *ifr)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct hwtstamp_config config;
+
+	config.flags = 0;
+	if (priv->ports[port].hwts_tx_en)
+		config.tx_type = HWTSTAMP_TX_ON;
+	else
+		config.tx_type = HWTSTAMP_TX_OFF;
+	if (priv->hwts_rx_en)
+		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+	else
+		config.rx_filter = HWTSTAMP_FILTER_NONE;
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
+static void sja1105_port_rxtstamp_work(struct work_struct *work)
+{
+	struct sja1105_port *sp = container_of(work, struct sja1105_port,
+					       rxtstamp_work);
+	struct dsa_switch *ds = sp->dp->ds;
+	struct sja1105_private *priv = ds->priv;
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&sp->skb_rxtstamp_queue)) != NULL) {
+		struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
+		struct sja1105_skb_cb *cb = SJA1105_SKB_CB(skb);
+		int timeout = 10;
+		u64 ts;
+
+		*shwt = (struct skb_shared_hwtstamps) {0};
+
+		do {
+			if (test_bit(SJA1105_STATE_META_ARRIVED, &cb->state))
+				break;
+			usleep_range(10, 50);
+		} while (--timeout);
+
+		if (!timeout) {
+			dev_err_ratelimited(ds->dev,
+					    "timed out waiting for meta frame\n");
+			goto rcv_anyway;
+		}
+
+		mutex_lock(&priv->ptp_lock);
+
+		ts = cyclecounter_reconstruct(&priv->tstamp_cc,
+					      cb->meta_tstamp);
+		ts = timecounter_cyc2time(&priv->tstamp_tc, ts);
+
+		mutex_unlock(&priv->ptp_lock);
+
+		shwt->hwtstamp = ns_to_ktime(ts);
+rcv_anyway:
+		netif_rx_ni(skb);
+	}
+}
+
+/* Called from dsa_skb_defer_rx_timestamp */
+bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_port *sp = &priv->ports[port];
+
+	if (!priv->hwts_rx_en)
+		return false;
+
+	/* We need to read the full PTP clock to reconstruct the Rx
+	 * timestamp. For that we need a sleepable context.
+	 * Furthermore, we should enqueue the skb for timestamp
+	 * reconstruction only once its meta frame came.
+	 * A reference to this skb is also held in sp->last_stampable_skb.
+	 */
+	skb_queue_tail(&sp->skb_rxtstamp_queue, skb);
+	schedule_work(&sp->rxtstamp_work);
+	return true;
+}
+
+/* Called from dsa_skb_tx_timestamp. This callback is just to make DSA clone
+ * the skb and have it available in DSA_SKB_CB in the .port_deferred_xmit
+ * callback, where we will timestamp it synchronously.
+ */
+bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_port *sp = &priv->ports[port];
+
+	if (!sp->hwts_tx_en)
+		return false;
+
+	return true;
+}
+
+static void sja1105_port_disable(struct dsa_switch *ds, int port)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_port *sp = &priv->ports[port];
+
+	cancel_work_sync(&sp->rxtstamp_work);
+	skb_queue_purge(&sp->skb_rxtstamp_queue);
+}
+
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
@@ -1527,6 +1779,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
 	.get_ts_info		= sja1105_get_ts_info,
+	.port_disable		= sja1105_port_disable,
 	.port_fdb_dump		= sja1105_fdb_dump,
 	.port_fdb_add		= sja1105_fdb_add,
 	.port_fdb_del		= sja1105_fdb_del,
@@ -1541,6 +1794,10 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
 	.port_deferred_xmit	= sja1105_port_deferred_xmit,
+	.port_hwtstamp_get	= sja1105_hwtstamp_get,
+	.port_hwtstamp_set	= sja1105_hwtstamp_set,
+	.port_rxtstamp		= sja1105_port_rxtstamp,
+	.port_txtstamp		= sja1105_port_txtstamp,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
@@ -1641,6 +1898,8 @@ static int sja1105_probe(struct spi_device *spi)
 
 		ds->ports[i].priv = sp;
 		sp->dp = &ds->ports[i];
+		skb_queue_head_init(&sp->skb_rxtstamp_queue);
+		INIT_WORK(&sp->rxtstamp_work, sja1105_port_rxtstamp_work);
 	}
 	mutex_init(&priv->mgmt_lock);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 9c7f5d6a7e3c..ae3cad7d1ba1 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -70,8 +70,10 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
 				SOF_TIMESTAMPING_RAW_HARDWARE;
-	info->tx_types = (1 << HWTSTAMP_TX_OFF);
-	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE);
+	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
+			 (1 << HWTSTAMP_TX_ON);
+	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
+			   (1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT);
 	info->phc_index = ptp_clock_index(priv->clock);
 	return 0;
 }
@@ -110,6 +112,67 @@ int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
 					   buf, SJA1105_SIZE_PTP_CMD);
 }
 
+int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	int tstamp_bit_start, tstamp_bit_end;
+	u8 packed_buf[8];
+	u64 ts_partial;
+	u64 update;
+	int rc;
+
+	rc = sja1105_spi_send_packed_buf(priv, SPI_READ, regs->ptpegr_ts[port],
+					 packed_buf,
+					 priv->info->ptpegr_ts_bytes);
+	if (rc < 0)
+		return rc;
+
+	/* SJA1105 E/T layout of the 4-byte SPI payload:
+	 *
+	 * 31    23    15    7     0
+	 * |     |     |     |     |
+	 * +-----+-----+-----+     ^
+	 *          ^              |
+	 *          |              |
+	 *  24-bit timestamp   Update bit
+	 *
+	 *
+	 * SJA1105 P/Q/R/S layout of the 8-byte SPI payload:
+	 *
+	 * 31    23    15    7     0     63    55    47    39    32
+	 * |     |     |     |     |     |     |     |     |     |
+	 *                         ^     +-----+-----+-----+-----+
+	 *                         |                 ^
+	 *                         |                 |
+	 *                    Update bit    32-bit timestamp
+	 *
+	 * Notice that the update bit is in the same place.
+	 * To have common code for E/T and P/Q/R/S for reading the timestamp,
+	 * we need to juggle with the offset and the bit indices.
+	 */
+	sja1105_unpack(packed_buf, &update, 0, 0, priv->info->ptpegr_ts_bytes);
+	if (!update)
+		/* No update. Keep trying, you'll make it someday. */
+		return -EAGAIN;
+
+	/* Point the end bit to the second 32-bit word on P/Q/R/S,
+	 * no-op on E/T.
+	 */
+	tstamp_bit_end = (priv->info->ptpegr_ts_bytes - 4) * 8;
+	/* Shift the 24-bit timestamp on E/T to be collected from 31:8.
+	 * No-op on P/Q/R/S.
+	 */
+	tstamp_bit_end += 32 - priv->info->ptp_ts_bits;
+	tstamp_bit_start = tstamp_bit_end + priv->info->ptp_ts_bits - 1;
+
+	sja1105_unpack(packed_buf, &ts_partial, tstamp_bit_start,
+		       tstamp_bit_end, priv->info->ptpegr_ts_bytes);
+
+	*ts = cyclecounter_reconstruct(&priv->tstamp_cc, ts_partial);
+
+	return 0;
+}
+
 static int sja1105_ptp_reset(struct sja1105_private *priv)
 {
 	struct dsa_switch *ds = priv->ds;
@@ -251,6 +314,7 @@ static int sja1105_ptp_init(struct sja1105_private *priv)
 	/* Set up the cycle counter */
 	priv->tstamp_cc = (struct cyclecounter) {
 		.read = sja1105_ptptsclk_read,
+		.partial_tstamp_mask = partial_tstamp_mask,
 		.mask = CYCLECOUNTER_MASK(64),
 		.shift = SJA1105_CC_SHIFT,
 		.mult = SJA1105_CC_MULT,
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index d2c6cf273500..626292962cb2 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -10,6 +10,8 @@ int sja1105_ptp_clock_register(struct sja1105_private *priv);
 
 void sja1105_ptp_clock_unregister(struct sja1105_private *priv);
 
+int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts);
+
 int sja1105et_ptp_cmd(const void *ctx, const void *data);
 
 int sja1105pqrs_ptp_cmd(const void *ctx, const void *data);
@@ -29,6 +31,12 @@ static inline void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
 	return;
 }
 
+static inline int
+sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
+{
+	return 0;
+}
+
 #define sja1105et_ptp_cmd NULL
 
 #define sja1105pqrs_ptp_cmd NULL
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index f30ac8326c98..0c51548f90fa 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -507,7 +507,7 @@ static struct sja1105_regs sja1105et_regs = {
 	.rgmii_tx_clk = {0x100016, 0x10001D, 0x100024, 0x10002B, 0x100032},
 	.rmii_ref_clk = {0x100015, 0x10001C, 0x100023, 0x10002A, 0x100031},
 	.rmii_ext_tx_clk = {0x100018, 0x10001F, 0x100026, 0x10002D, 0x100034},
-	.ptpegr_ts = 0xC0,
+	.ptpegr_ts = {0xC0, 0xC2, 0xC4, 0xC6, 0xC8},
 	.ptp_control = 0x17,
 	.ptpclk = 0x18, /* Spans 0x18 to 0x19 */
 	.ptpclkrate = 0x1A,
@@ -538,7 +538,7 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.rmii_ref_clk = {0x100015, 0x10001B, 0x100021, 0x100027, 0x10002D},
 	.rmii_ext_tx_clk = {0x100017, 0x10001D, 0x100023, 0x100029, 0x10002F},
 	.qlevel = {0x604, 0x614, 0x624, 0x634, 0x644},
-	.ptpegr_ts = 0xC0,
+	.ptpegr_ts = {0xC0, 0xC4, 0xC8, 0xCC, 0xD0},
 	.ptp_control = 0x18,
 	.ptpclk = 0x19,
 	.ptpclkrate = 0x1B,
@@ -550,6 +550,8 @@ struct sja1105_info sja1105e_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105e_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
+	.ptp_ts_bits		= 24,
+	.ptpegr_ts_bytes	= 4,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.ptp_cmd		= sja1105et_ptp_cmd,
 	.regs			= &sja1105et_regs,
@@ -560,6 +562,8 @@ struct sja1105_info sja1105t_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105t_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
+	.ptp_ts_bits		= 24,
+	.ptpegr_ts_bytes	= 4,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.ptp_cmd		= sja1105et_ptp_cmd,
 	.regs			= &sja1105et_regs,
@@ -570,6 +574,8 @@ struct sja1105_info sja1105p_info = {
 	.part_no		= SJA1105P_PART_NO,
 	.static_ops		= sja1105p_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.ptp_cmd		= sja1105pqrs_ptp_cmd,
 	.regs			= &sja1105pqrs_regs,
@@ -580,6 +586,8 @@ struct sja1105_info sja1105q_info = {
 	.part_no		= SJA1105Q_PART_NO,
 	.static_ops		= sja1105q_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.ptp_cmd		= sja1105pqrs_ptp_cmd,
 	.regs			= &sja1105pqrs_regs,
@@ -590,6 +598,8 @@ struct sja1105_info sja1105r_info = {
 	.part_no		= SJA1105R_PART_NO,
 	.static_ops		= sja1105r_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.ptp_cmd		= sja1105pqrs_ptp_cmd,
 	.regs			= &sja1105pqrs_regs,
@@ -601,6 +611,8 @@ struct sja1105_info sja1105s_info = {
 	.static_ops		= sja1105s_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.regs			= &sja1105pqrs_regs,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.ptp_cmd		= sja1105pqrs_ptp_cmd,
 	.name			= "SJA1105S",
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index b3c992b0abb0..63ea0471badf 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -91,6 +91,28 @@ u32 sja1105_crc32(const void *buf, size_t len)
 	return ~crc;
 }
 
+static size_t sja1105et_avb_params_entry_packing(void *buf, void *entry_ptr,
+						 enum packing_op op)
+{
+	const size_t size = SJA1105ET_SIZE_AVB_PARAMS_ENTRY;
+	struct sja1105_avb_params_entry *entry = entry_ptr;
+
+	sja1105_packing(buf, &entry->destmeta, 95, 48, size, op);
+	sja1105_packing(buf, &entry->srcmeta,  47,  0, size, op);
+	return size;
+}
+
+static size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
+						   enum packing_op op)
+{
+	const size_t size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY;
+	struct sja1105_avb_params_entry *entry = entry_ptr;
+
+	sja1105_packing(buf, &entry->destmeta,   125,  78, size, op);
+	sja1105_packing(buf, &entry->srcmeta,     77,  30, size, op);
+	return size;
+}
+
 static size_t sja1105et_general_params_entry_packing(void *buf, void *entry_ptr,
 						     enum packing_op op)
 {
@@ -413,6 +435,7 @@ static u64 blk_id_map[BLK_IDX_MAX] = {
 	[BLK_IDX_MAC_CONFIG] = BLKID_MAC_CONFIG,
 	[BLK_IDX_L2_LOOKUP_PARAMS] = BLKID_L2_LOOKUP_PARAMS,
 	[BLK_IDX_L2_FORWARDING_PARAMS] = BLKID_L2_FORWARDING_PARAMS,
+	[BLK_IDX_AVB_PARAMS] = BLKID_AVB_PARAMS,
 	[BLK_IDX_GENERAL_PARAMS] = BLKID_GENERAL_PARAMS,
 	[BLK_IDX_XMII_PARAMS] = BLKID_XMII_PARAMS,
 };
@@ -614,6 +637,12 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105et_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105ET_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105et_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
@@ -672,6 +701,12 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105et_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105ET_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105et_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
@@ -730,6 +765,12 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105pqrs_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105pqrs_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
@@ -788,6 +829,12 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105pqrs_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105pqrs_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
@@ -846,6 +893,12 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105pqrs_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105pqrs_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
@@ -904,6 +957,12 @@ struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105pqrs_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105pqrs_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 069ca8fd059c..2c1d7d04e22e 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -20,10 +20,12 @@
 #define SJA1105ET_SIZE_MAC_CONFIG_ENTRY			28
 #define SJA1105ET_SIZE_L2_LOOKUP_PARAMS_ENTRY		4
 #define SJA1105ET_SIZE_GENERAL_PARAMS_ENTRY		40
+#define SJA1105ET_SIZE_AVB_PARAMS_ENTRY			12
 #define SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY		20
 #define SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY		32
 #define SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_ENTRY		16
 #define SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY		44
+#define SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY		16
 
 /* UM10944.pdf Page 11, Table 2. Configuration Blocks */
 enum {
@@ -34,6 +36,7 @@ enum {
 	BLKID_MAC_CONFIG				= 0x09,
 	BLKID_L2_LOOKUP_PARAMS				= 0x0D,
 	BLKID_L2_FORWARDING_PARAMS			= 0x0E,
+	BLKID_AVB_PARAMS				= 0x10,
 	BLKID_GENERAL_PARAMS				= 0x11,
 	BLKID_XMII_PARAMS				= 0x4E,
 };
@@ -46,6 +49,7 @@ enum sja1105_blk_idx {
 	BLK_IDX_MAC_CONFIG,
 	BLK_IDX_L2_LOOKUP_PARAMS,
 	BLK_IDX_L2_FORWARDING_PARAMS,
+	BLK_IDX_AVB_PARAMS,
 	BLK_IDX_GENERAL_PARAMS,
 	BLK_IDX_XMII_PARAMS,
 	BLK_IDX_MAX,
@@ -64,6 +68,7 @@ enum sja1105_blk_idx {
 #define SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT		1
 #define SJA1105_MAX_GENERAL_PARAMS_COUNT		1
 #define SJA1105_MAX_XMII_PARAMS_COUNT			1
+#define SJA1105_MAX_AVB_PARAMS_COUNT			1
 
 #define SJA1105_MAX_FRAME_MEMORY			929
 
@@ -153,6 +158,11 @@ struct sja1105_l2_policing_entry {
 	u64 partition;
 };
 
+struct sja1105_avb_params_entry {
+	u64 destmeta;
+	u64 srcmeta;
+};
+
 struct sja1105_mac_config_entry {
 	u64 top[8];
 	u64 base[8];
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 603a02e5a8cb..b306529636b4 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -20,13 +20,22 @@
 #define SJA1105_LINKLOCAL_FILTER_B		0x011B19000000ull
 #define SJA1105_LINKLOCAL_FILTER_B_MASK		0xFFFFFF000000ull
 
+/* Source and Destination MAC of follow-up meta frames */
+#define SJA1105_META_SMAC			0x222222222222ull
+#define SJA1105_META_DMAC			0x222222222222ull
+
+#define SJA1105_STATE_META_ARRIVED		0
+
 enum sja1105_frame_type {
 	SJA1105_FRAME_TYPE_NORMAL = 0,
 	SJA1105_FRAME_TYPE_LINK_LOCAL,
+	SJA1105_FRAME_TYPE_META,
 };
 
 struct sja1105_skb_cb {
 	enum sja1105_frame_type type;
+	unsigned long state;
+	u32 meta_tstamp;
 };
 
 #define SJA1105_SKB_CB(skb) \
@@ -35,6 +44,12 @@ struct sja1105_skb_cb {
 struct sja1105_port {
 	struct dsa_port *dp;
 	int mgmt_slot;
+	bool hwts_tx_en;
+	bool hwts_rx_en;
+	bool expect_meta;
+	struct work_struct rxtstamp_work;
+	struct sk_buff *last_stampable_skb;
+	struct sk_buff_head skb_rxtstamp_queue;
 };
 
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 969402c7dbf1..7c2ff5381dd0 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -22,12 +22,31 @@ static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 	return false;
 }
 
+static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
+{
+	const struct ethhdr *hdr = eth_hdr(skb);
+	u64 smac = ether_addr_to_u64(hdr->h_source);
+	u64 dmac = ether_addr_to_u64(hdr->h_dest);
+
+	if (smac != SJA1105_META_SMAC)
+		return false;
+	if (dmac != SJA1105_META_DMAC)
+		return false;
+	if (hdr->h_proto != ETH_P_IP)
+		return false;
+	return true;
+}
+
 /* This is the first time the tagger sees the frame on RX.
  * Figure out if we can decode it, and if we can, annotate skb->cb with how we
  * plan to do that, so we don't need to check again in the rcv function.
  */
 static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 {
+	if (sja1105_is_meta_frame(skb)) {
+		SJA1105_SKB_CB(skb)->type = SJA1105_FRAME_TYPE_META;
+		return true;
+	}
 	if (sja1105_is_link_local(skb)) {
 		SJA1105_SKB_CB(skb)->type = SJA1105_FRAME_TYPE_LINK_LOCAL;
 		return true;
@@ -39,6 +58,16 @@ static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 	return false;
 }
 
+/* Since this function is called both on ingress and on egress, we can't rely
+ * on the SJA1105_SKB_CB(skb)->type which we only populate on ingress. So we
+ * have to perform the link-local check again.
+ */
+static bool sja1105_can_tstamp(const struct sk_buff *skb,
+			       struct net_device *dev)
+{
+	return sja1105_is_link_local(skb);
+}
+
 static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
@@ -66,6 +95,85 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 }
 
+/* This is a simple state machine (the state is kept in the private structure
+ * of struct dsa_port) which follows the hardware mechanism of generating RX
+ * timestamps: after each timestampable skb (all traffic for which send_meta1
+ * and send_meta0 is true, therefore all MAC-filtered link-local traffic) a
+ * meta frame containing a partial timestamp is immediately generated by the
+ * switch and sent as a follow-up to the link-local frame on the CPU port.
+ * This function pairs the link-local frame with its partial timestamp from the
+ * meta follow-up frame. The full timestamp will be reconstructed in a delayed
+ * work context.
+ */
+static struct sk_buff *sja1105_rcv_meta_state_machine(struct sk_buff *skb)
+{
+	struct sja1105_port *sp;
+	struct dsa_port *dp;
+
+	dp = dsa_slave_to_port(skb->dev);
+	sp = dp->priv;
+
+	if (SJA1105_SKB_CB(skb)->type == SJA1105_FRAME_TYPE_META) {
+		struct sja1105_skb_cb *cb;
+
+		/* Was this a meta frame instead of the link-local
+		 * that we were expecting?
+		 */
+		if (!sp->expect_meta) {
+			/* If timestamping is not enabled on this port and
+			 * we're still receiving meta frames, it must have been
+			 * requested on other ports. But since the send_meta
+			 * setting is global for the switch, receiving a meta
+			 * frame at this point is not really unexpected, but
+			 * nonetheless useless. So just discard it and don't
+			 * print anything to the user in that case.
+			 */
+			if (sp->hwts_rx_en)
+				dev_err_ratelimited(dp->ds->dev,
+						    "Unexpected meta frame\n");
+			return NULL;
+		}
+
+		sp->expect_meta = false;
+		/* Copy the timestamp from the meta frame
+		 * into the cached skb.
+		 */
+		cb = SJA1105_SKB_CB(sp->last_stampable_skb);
+		cb->meta_tstamp = SJA1105_SKB_CB(skb)->meta_tstamp;
+		set_bit(SJA1105_STATE_META_ARRIVED, &cb->state);
+		skb_unref(sp->last_stampable_skb);
+		sp->last_stampable_skb = NULL;
+		/* Drop the meta frame from further processing up the stack */
+		return NULL;
+	} else if ((SJA1105_SKB_CB(skb)->type ==
+		    SJA1105_FRAME_TYPE_LINK_LOCAL) && sp->hwts_rx_en) {
+		/* Was this a link-local frame instead of the meta
+		 * that we were expecting?
+		 */
+		if (sp->expect_meta) {
+			dev_err_ratelimited(dp->ds->dev,
+					    "Expected meta frame\n");
+			skb_unref(sp->last_stampable_skb);
+			sp->last_stampable_skb = NULL;
+		}
+
+		sp->expect_meta = true;
+		/* Hold a reference so that we avoid the
+		 * sja1105_port_rxtstamp_work freeing it from under our feet.
+		 */
+		sp->last_stampable_skb = skb_get(skb);
+		/* Let this frame be forwarded on the switch port, queued by
+		 * dsa_skb_defer_rx_timestamp and reinjected in the stack by
+		 * sja1105_port_rxtstamp_work once we also receive the meta
+		 * frame.
+		 */
+		clear_bit(SJA1105_STATE_META_ARRIVED,
+			 &SJA1105_SKB_CB(skb)->state);
+	}
+
+	return skb;
+}
+
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
@@ -75,6 +183,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	struct sk_buff *nskb;
 	u16 tpid, vid, tci;
 	bool is_tagged;
+	u64 tstamp;
 
 	nskb = dsa_8021q_rcv(skb, netdev, pt, &tpid, &tci);
 	is_tagged = (nskb && tpid == ETH_P_SJA1105);
@@ -84,7 +193,28 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	skb->offload_fwd_mark = 1;
 
-	if (SJA1105_SKB_CB(skb)->type == SJA1105_FRAME_TYPE_LINK_LOCAL) {
+	if (SJA1105_SKB_CB(skb)->type == SJA1105_FRAME_TYPE_META) {
+		u8 *meta = skb_mac_header(skb) + ETH_HLEN;
+
+		/* UM10944.pdf section 4.2.17 AVB Parameters:
+		 * Structure of the meta-data follow-up frame.
+		 * It is in network byte order, so there are no quirks
+		 * while unpacking the meta frame.
+		 *
+		 * Also SJA1105 E/T only populates bits 23:0 of the timestamp
+		 * whereas P/Q/R/S does 32 bits. Since the structure is the
+		 * same and the E/T puts zeroes in the high-order byte, use
+		 * a unified unpacking command for both device series.
+		 */
+		packing(meta,     &tstamp,     31, 0, 4, UNPACK, 0);
+		packing(meta + 6, &source_port, 7, 0, 1, UNPACK, 0);
+		packing(meta + 7, &switch_id,   7, 0, 1, UNPACK, 0);
+		if (is_tagged)
+			dump_stack();
+
+		SJA1105_SKB_CB(skb)->meta_tstamp = tstamp;
+
+	} else if (SJA1105_SKB_CB(skb)->type == SJA1105_FRAME_TYPE_LINK_LOCAL) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
 		 * the incl_srcpt options.
@@ -113,7 +243,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - VLAN_HLEN,
 			ETH_HLEN - VLAN_HLEN);
 
-	return skb;
+	return sja1105_rcv_meta_state_machine(skb);
 }
 
 static struct dsa_device_ops sja1105_netdev_ops = {
@@ -122,6 +252,7 @@ static struct dsa_device_ops sja1105_netdev_ops = {
 	.xmit = sja1105_xmit,
 	.rcv = sja1105_rcv,
 	.filter = sja1105_filter,
+	.can_tstamp = sja1105_can_tstamp,
 	.overhead = VLAN_HLEN,
 };
 
-- 
2.17.1

