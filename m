Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC12732507
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfFBVkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:40:42 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52783 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfFBVkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:40:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so1904937wms.2;
        Sun, 02 Jun 2019 14:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JAJJC53OdZd9CCFAUVaux5cZ7pz85GNtd3gECarKrSY=;
        b=gcS5m3Yejm5+0UW4Ui+2vVq7j6MlGhTa150mdm3EffF8kN/Hup4HcMZXEFQSrGfbIJ
         MMdhth5W30Hl+PWmohK80GN1qRrgTDT5T7k7V91llN5Xaj0nLCGEZjXWzkmXhy40vwGI
         lL5pxL4qgzDvnQ3zo8a8TuJdpOrrfE5PEf+OTldlfF8rsu2H8csQE/fJjBde1iv3N5j6
         w2oJ0E7zMjnPLxKwUqCyB3B2PORrSdGSP7jljs7tDWk6kn6++6Y51eE9kV+4A3DfohRf
         6dQJrf6gLrG4fKobyUS07KOG57VTB9xaEBy6Tyls+2104y8BpWGbWWIxdh5QBSw3i6mt
         XKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JAJJC53OdZd9CCFAUVaux5cZ7pz85GNtd3gECarKrSY=;
        b=t9s4wyWQIdCPKfMwVcJhCLSPFk7AwyLFn6Nq57Oa4crodX/sQ0wlubiqtnce/fZeNf
         /4zLO6q4FqJ8hVWVx9kG3RZZswKfm37MnEgOls7TmjkIYDZ6hyI2ylzJVADzW6DU2Kr6
         3NQ5WwoatOpeueiFeiI+Znxdub93DoY/NyFEWiol9XPBQVAKOO4tNP3bb0elOKQX2bhn
         hA/f2lMCMC6DWH4xZNe+Mm59z52f3IlvEXxUNFa/WfjraEsbdZXHdQUcza84OOQ1vCM/
         WSaEqvdoITn3Ih+XAOF3jhHdWJOQARvA4HzE7r3ZefyLJ758VzBLGo70YLSxtN6JAMj5
         /U+Q==
X-Gm-Message-State: APjAAAWHfMuRjsNd/+m/CiPV6cJFKkYpO96hY98giFrAiISU9qzXE9L6
        wguXXdDjeO6nXcn8zsFHadA=
X-Google-Smtp-Source: APXvYqwZ27GvPk/cBC1IKBfgSea0ueLtkHMif+U0Ilq1rc+fp8KerHTWxRmjyEWw/0Gbf10tgRLWpA==
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr12429561wmj.41.1559511632951;
        Sun, 02 Jun 2019 14:40:32 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 65sm26486793wro.85.2019.06.02.14.40.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:40:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 09/10] net: dsa: sja1105: Add support for PTP timestamping
Date:   Mon,  3 Jun 2019 00:39:25 +0300
Message-Id: <20190602213926.2290-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602213926.2290-1-olteanv@gmail.com>
References: <20190602213926.2290-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On RX, timestamping is done by programming the switch to send "meta"
follow-up Ethernet frames (which contain partial RX timestamps) after
each link-local frame that was trapped to the CPU port through MAC
filtering. This includes PTP frames.

Meta frame reception relies on the hardware keeping its promise that it
will send no other traffic towards the CPU port between a link-local
frame and a meta frame.  Otherwise there is no other way to associate
the meta frame with the link-local frame it's holding a timestamp of.
The receive function is made stateful, and buffers a timestampable frame
until its meta frame arrives, then merges the two, drops the meta and
releases the link-local frame up the stack.

On TX, timestamping is performed synchronously from the port_deferred_xmit
worker thread.  In management routes, the switch is requested to take
egress timestamps (again partial), which are reconstructed and appended
to a clone of the skb that was just sent.  The cloning is done by DSA and
we retrieve the pointer from the structure that DSA keeps in skb->cb.
Then these clones are enqueued to the socket's error queue for
application-level processing.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:

- Made cyclecounter_reconstruct driver-specific
  (sja1105_tstamp_reconstruct).

- Reimplemented sja1105_rcv_meta_state_machine to buffer a timestampable
  skb until its meta frame arrives, and then push the cached skb up the
  stack while dropping the meta (simplification suggested by Richard
  Cochran).

- Replaced the per-port RX timestamping data structures with a global
  one.

 drivers/net/dsa/sja1105/sja1105.h             |  11 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 257 +++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_ptp.c         | 110 +++++++-
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  17 ++
 drivers/net/dsa/sja1105/sja1105_spi.c         |  14 +
 .../net/dsa/sja1105/sja1105_static_config.c   |  59 ++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  10 +
 include/linux/dsa/sja1105.h                   |  34 +++
 net/dsa/tag_sja1105.c                         | 186 ++++++++++++-
 10 files changed, 692 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 3c6296203c21..0fc6fe9ada87 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -33,6 +33,7 @@ struct sja1105_regs {
 	u64 ptpclk;
 	u64 ptpclkrate;
 	u64 ptptsclk;
+	u64 ptpegr_ts[SJA1105_NUM_PORTS];
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
 	u64 cgu_idiv[SJA1105_NUM_PORTS];
 	u64 rgmii_pad_mii_tx[SJA1105_NUM_PORTS];
@@ -56,6 +57,15 @@ struct sja1105_info {
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
@@ -93,6 +103,7 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	struct sja1105_tagger_data tagger_data;
 };
 
 #include "sja1105_dynamic_config.h"
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 352bb6e89297..56c83b9d52e4 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -378,6 +378,7 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.addr = 0x38,
 	},
 	[BLK_IDX_L2_FORWARDING_PARAMS] = {0},
+	[BLK_IDX_AVB_PARAMS] = {0},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.entry_packing = sja1105et_general_params_entry_packing,
 		.cmd_packing = sja1105et_general_params_cmd_packing,
@@ -441,6 +442,7 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.addr = 0x38,
 	},
 	[BLK_IDX_L2_FORWARDING_PARAMS] = {0},
+	[BLK_IDX_AVB_PARAMS] = {0},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.entry_packing = sja1105et_general_params_entry_packing,
 		.cmd_packing = sja1105et_general_params_cmd_packing,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 7d433291933c..b7af9479ab5a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -508,6 +508,39 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
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
@@ -546,6 +579,9 @@ static int sja1105_static_config_load(struct sja1105_private *priv,
 	if (rc < 0)
 		return rc;
 	rc = sja1105_init_general_params(priv);
+	if (rc < 0)
+		return rc;
+	rc = sja1105_init_avb_params(priv, false);
 	if (rc < 0)
 		return rc;
 
@@ -1562,8 +1598,16 @@ static int sja1105_setup(struct dsa_switch *ds)
 	return sja1105_setup_8021q_tagging(ds, true);
 }
 
+static void sja1105_teardown(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
+	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
+}
+
 static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
-			     struct sk_buff *skb)
+			     struct sk_buff *skb, bool takets)
 {
 	struct sja1105_mgmt_entry mgmt_route = {0};
 	struct sja1105_private *priv = ds->priv;
@@ -1576,6 +1620,8 @@ static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
 	mgmt_route.macaddr = ether_addr_to_u64(hdr->h_dest);
 	mgmt_route.destports = BIT(port);
 	mgmt_route.enfport = 1;
+	mgmt_route.tsreg = 0;
+	mgmt_route.takets = takets;
 
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MGMT_ROUTE,
 					  slot, &mgmt_route, true);
@@ -1627,7 +1673,11 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_port *sp = &priv->ports[port];
+	struct skb_shared_hwtstamps shwt = {0};
 	int slot = sp->mgmt_slot;
+	struct sk_buff *clone;
+	u64 now, ts;
+	int rc;
 
 	/* The tragic fact about the switch having 4x2 slots for installing
 	 * management routes is that all of them except one are actually
@@ -1645,8 +1695,36 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 	 */
 	mutex_lock(&priv->mgmt_lock);
 
-	sja1105_mgmt_xmit(ds, port, slot, skb);
+	/* The clone, if there, was made by dsa_skb_tx_timestamp */
+	clone = DSA_SKB_CB(skb)->clone;
 
+	sja1105_mgmt_xmit(ds, port, slot, skb, !!clone);
+
+	if (!clone)
+		goto out;
+
+	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	mutex_lock(&priv->ptp_lock);
+
+	now = priv->tstamp_cc.read(&priv->tstamp_cc);
+
+	rc = sja1105_ptpegr_ts_poll(priv, slot, &ts);
+	if (rc < 0) {
+		dev_err(ds->dev, "xmit: timed out polling for tstamp\n");
+		kfree_skb(clone);
+		goto out_unlock_ptp;
+	}
+
+	ts = sja1105_tstamp_reconstruct(priv, now, ts);
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
@@ -1675,9 +1753,174 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 	return sja1105_static_config_reload(priv);
 }
 
+/* Caller must hold priv->tagger_data.meta_lock */
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
+	/* Initialize the meta state machine to a known state */
+	if (priv->tagger_data.stampable_skb) {
+		kfree_skb(priv->tagger_data.stampable_skb);
+		priv->tagger_data.stampable_skb = NULL;
+	}
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
+	int rc;
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
+	if (rx_on != priv->tagger_data.hwts_rx_en) {
+		spin_lock(&priv->tagger_data.meta_lock);
+		rc = sja1105_change_rxtstamping(priv, rx_on);
+		spin_unlock(&priv->tagger_data.meta_lock);
+		if (rc < 0) {
+			dev_err(ds->dev,
+				"Failed to change RX timestamping: %d\n", rc);
+			return -EFAULT;
+		}
+		priv->tagger_data.hwts_rx_en = rx_on;
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
+	if (priv->tagger_data.hwts_rx_en)
+		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+	else
+		config.rx_filter = HWTSTAMP_FILTER_NONE;
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
+#define to_tagger(d) \
+	container_of((d), struct sja1105_tagger_data, rxtstamp_work)
+#define to_sja1105(d) \
+	container_of((d), struct sja1105_private, tagger_data)
+
+static void sja1105_rxtstamp_work(struct work_struct *work)
+{
+	struct sja1105_tagger_data *data = to_tagger(work);
+	struct sja1105_private *priv = to_sja1105(data);
+	struct sk_buff *skb;
+	u64 now;
+
+	mutex_lock(&priv->ptp_lock);
+
+	now = priv->tstamp_cc.read(&priv->tstamp_cc);
+
+	while ((skb = skb_dequeue(&data->skb_rxtstamp_queue)) != NULL) {
+		struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
+		u64 ts;
+
+		*shwt = (struct skb_shared_hwtstamps) {0};
+
+		ts = SJA1105_SKB_CB(skb)->meta_tstamp;
+		ts = sja1105_tstamp_reconstruct(priv, now, ts);
+		ts = timecounter_cyc2time(&priv->tstamp_tc, ts);
+
+		shwt->hwtstamp = ns_to_ktime(ts);
+		netif_rx_ni(skb);
+	}
+
+	mutex_unlock(&priv->ptp_lock);
+}
+
+/* Called from dsa_skb_defer_rx_timestamp */
+bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb, unsigned int type)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_tagger_data *data = &priv->tagger_data;
+
+	if (!data->hwts_rx_en)
+		return false;
+
+	if (!sja1105_is_link_local(skb))
+		return false;
+
+	/* We need to read the full PTP clock to reconstruct the Rx
+	 * timestamp. For that we need a sleepable context.
+	 */
+	skb_queue_tail(&data->skb_rxtstamp_queue, skb);
+	schedule_work(&data->rxtstamp_work);
+	return true;
+}
+
+/* Called from dsa_skb_tx_timestamp. This callback is just to make DSA clone
+ * the skb and have it available in DSA_SKB_CB in the .port_deferred_xmit
+ * callback, where we will timestamp it synchronously.
+ */
+bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb, unsigned int type)
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
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
+	.teardown		= sja1105_teardown,
 	.set_ageing_time	= sja1105_set_ageing_time,
 	.phylink_validate	= sja1105_phylink_validate,
 	.phylink_mac_config	= sja1105_mac_config,
@@ -1699,6 +1942,10 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
 	.port_deferred_xmit	= sja1105_port_deferred_xmit,
+	.port_hwtstamp_get	= sja1105_hwtstamp_get,
+	.port_hwtstamp_set	= sja1105_hwtstamp_set,
+	.port_rxtstamp		= sja1105_port_rxtstamp,
+	.port_txtstamp		= sja1105_port_txtstamp,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
@@ -1739,6 +1986,7 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
 
 static int sja1105_probe(struct spi_device *spi)
 {
+	struct sja1105_tagger_data *tagger_data;
 	struct device *dev = &spi->dev;
 	struct sja1105_private *priv;
 	struct dsa_switch *ds;
@@ -1793,12 +2041,17 @@ static int sja1105_probe(struct spi_device *spi)
 	ds->priv = priv;
 	priv->ds = ds;
 
+	tagger_data = &priv->tagger_data;
+	skb_queue_head_init(&tagger_data->skb_rxtstamp_queue);
+	INIT_WORK(&tagger_data->rxtstamp_work, sja1105_rxtstamp_work);
+
 	/* Connections between dsa_port and sja1105_port */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
 		struct sja1105_port *sp = &priv->ports[i];
 
 		ds->ports[i].priv = sp;
 		sp->dp = &ds->ports[i];
+		sp->data = tagger_data;
 	}
 	mutex_init(&priv->mgmt_lock);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 5ffc985ad89a..c7ce1edd8471 100644
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
@@ -110,6 +112,110 @@ int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
 					   buf, SJA1105_SIZE_PTP_CMD);
 }
 
+/* The switch returns partial timestamps (24 bits for SJA1105 E/T, which wrap
+ * around in 0.135 seconds, and 32 bits for P/Q/R/S, wrapping around in 34.35
+ * seconds).
+ *
+ * This receives the RX or TX MAC timestamps, provided by hardware as
+ * the lower bits of the cycle counter, sampled at the time the timestamp was
+ * collected.
+ *
+ * To reconstruct into a full 64-bit-wide timestamp, the cycle counter is
+ * read and the high-order bits are filled in.
+ *
+ * Must be called within one wraparound period of the partial timestamp since
+ * it was generated by the MAC.
+ */
+u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv, u64 now,
+			       u64 ts_partial)
+{
+	u64 partial_tstamp_mask = CYCLECOUNTER_MASK(priv->info->ptp_ts_bits);
+	u64 ts_reconstructed;
+
+	ts_reconstructed = (now & ~partial_tstamp_mask) | ts_partial;
+
+	/* Check lower bits of current cycle counter against the timestamp.
+	 * If the current cycle counter is lower than the partial timestamp,
+	 * then wraparound surely occurred and must be accounted for.
+	 */
+	if ((now & partial_tstamp_mask) <= ts_partial)
+		ts_reconstructed -= (partial_tstamp_mask + 1);
+
+	return ts_reconstructed;
+}
+
+/* Reads the SPI interface for an egress timestamp generated by the switch
+ * for frames sent using management routes.
+ *
+ * SJA1105 E/T layout of the 4-byte SPI payload:
+ *
+ * 31    23    15    7     0
+ * |     |     |     |     |
+ * +-----+-----+-----+     ^
+ *          ^              |
+ *          |              |
+ *  24-bit timestamp   Update bit
+ *
+ *
+ * SJA1105 P/Q/R/S layout of the 8-byte SPI payload:
+ *
+ * 31    23    15    7     0     63    55    47    39    32
+ * |     |     |     |     |     |     |     |     |     |
+ *                         ^     +-----+-----+-----+-----+
+ *                         |                 ^
+ *                         |                 |
+ *                    Update bit    32-bit timestamp
+ *
+ * Notice that the update bit is in the same place.
+ * To have common code for E/T and P/Q/R/S for reading the timestamp,
+ * we need to juggle with the offset and the bit indices.
+ */
+int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	int tstamp_bit_start, tstamp_bit_end;
+	int timeout = 10;
+	u8 packed_buf[8];
+	u64 update;
+	int rc;
+
+	do {
+		rc = sja1105_spi_send_packed_buf(priv, SPI_READ,
+						 regs->ptpegr_ts[port],
+						 packed_buf,
+						 priv->info->ptpegr_ts_bytes);
+		if (rc < 0)
+			return rc;
+
+		sja1105_unpack(packed_buf, &update, 0, 0,
+			       priv->info->ptpegr_ts_bytes);
+		if (update)
+			break;
+
+		usleep_range(10, 50);
+	} while (--timeout);
+
+	if (!timeout)
+		return -ETIMEDOUT;
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
+	*ts = 0;
+
+	sja1105_unpack(packed_buf, ts, tstamp_bit_start, tstamp_bit_end,
+		       priv->info->ptpegr_ts_bytes);
+
+	return 0;
+}
+
 int sja1105_ptp_reset(struct sja1105_private *priv)
 {
 	struct dsa_switch *ds = priv->ds;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 137ffbb0a233..af456b0a4d27 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -10,6 +10,8 @@ int sja1105_ptp_clock_register(struct sja1105_private *priv);
 
 void sja1105_ptp_clock_unregister(struct sja1105_private *priv);
 
+int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts);
+
 int sja1105et_ptp_cmd(const void *ctx, const void *data);
 
 int sja1105pqrs_ptp_cmd(const void *ctx, const void *data);
@@ -17,6 +19,9 @@ int sja1105pqrs_ptp_cmd(const void *ctx, const void *data);
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *ts);
 
+u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv, u64 now,
+			       u64 ts_partial);
+
 int sja1105_ptp_reset(struct sja1105_private *priv);
 
 #else
@@ -31,6 +36,18 @@ static inline void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
 	return;
 }
 
+static inline int
+sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
+{
+	return 0;
+}
+
+static inline u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv,
+					     u64 now, u64 ts_partial)
+{
+	return 0;
+}
+
 static inline int sja1105_ptp_reset(struct sja1105_private *priv)
 {
 	return 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index d226996881b8..a71b16c5ae5d 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -512,6 +512,7 @@ static struct sja1105_regs sja1105et_regs = {
 	.rgmii_tx_clk = {0x100016, 0x10001D, 0x100024, 0x10002B, 0x100032},
 	.rmii_ref_clk = {0x100015, 0x10001C, 0x100023, 0x10002A, 0x100031},
 	.rmii_ext_tx_clk = {0x100018, 0x10001F, 0x100026, 0x10002D, 0x100034},
+	.ptpegr_ts = {0xC0, 0xC2, 0xC4, 0xC6, 0xC8},
 	.ptp_control = 0x17,
 	.ptpclk = 0x18, /* Spans 0x18 to 0x19 */
 	.ptpclkrate = 0x1A,
@@ -542,6 +543,7 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.rmii_ref_clk = {0x100015, 0x10001B, 0x100021, 0x100027, 0x10002D},
 	.rmii_ext_tx_clk = {0x100017, 0x10001D, 0x100023, 0x100029, 0x10002F},
 	.qlevel = {0x604, 0x614, 0x624, 0x634, 0x644},
+	.ptpegr_ts = {0xC0, 0xC4, 0xC8, 0xCC, 0xD0},
 	.ptp_control = 0x18,
 	.ptpclk = 0x19,
 	.ptpclkrate = 0x1B,
@@ -553,6 +555,8 @@ struct sja1105_info sja1105e_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105e_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
+	.ptp_ts_bits		= 24,
+	.ptpegr_ts_bytes	= 4,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
@@ -565,6 +569,8 @@ struct sja1105_info sja1105t_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105t_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
+	.ptp_ts_bits		= 24,
+	.ptpegr_ts_bytes	= 4,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
@@ -577,6 +583,8 @@ struct sja1105_info sja1105p_info = {
 	.part_no		= SJA1105P_PART_NO,
 	.static_ops		= sja1105p_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
@@ -589,6 +597,8 @@ struct sja1105_info sja1105q_info = {
 	.part_no		= SJA1105Q_PART_NO,
 	.static_ops		= sja1105q_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
@@ -601,6 +611,8 @@ struct sja1105_info sja1105r_info = {
 	.part_no		= SJA1105R_PART_NO,
 	.static_ops		= sja1105r_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
@@ -614,6 +626,8 @@ struct sja1105_info sja1105s_info = {
 	.static_ops		= sja1105s_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.regs			= &sja1105pqrs_regs,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 6d65a7b09395..242f001c59fe 100644
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
@@ -423,6 +445,7 @@ static u64 blk_id_map[BLK_IDX_MAX] = {
 	[BLK_IDX_MAC_CONFIG] = BLKID_MAC_CONFIG,
 	[BLK_IDX_L2_LOOKUP_PARAMS] = BLKID_L2_LOOKUP_PARAMS,
 	[BLK_IDX_L2_FORWARDING_PARAMS] = BLKID_L2_FORWARDING_PARAMS,
+	[BLK_IDX_AVB_PARAMS] = BLKID_AVB_PARAMS,
 	[BLK_IDX_GENERAL_PARAMS] = BLKID_GENERAL_PARAMS,
 	[BLK_IDX_XMII_PARAMS] = BLKID_XMII_PARAMS,
 };
@@ -624,6 +647,12 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
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
@@ -682,6 +711,12 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
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
@@ -740,6 +775,12 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
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
@@ -798,6 +839,12 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
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
@@ -856,6 +903,12 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
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
@@ -914,6 +967,12 @@ struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
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
index d513b1c91b98..a9586d0b4b3b 100644
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
 
@@ -179,6 +184,11 @@ struct sja1105_l2_policing_entry {
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
index d64e56d6c521..794ee76aae56 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -12,6 +12,7 @@
 #include <net/dsa.h>
 
 #define ETH_P_SJA1105				ETH_P_DSA_8021Q
+#define ETH_P_SJA1105_META			0x0008
 
 /* IEEE 802.3 Annex 57A: Slow Protocols PDUs (01:80:C2:xx:xx:xx) */
 #define SJA1105_LINKLOCAL_FILTER_A		0x0180C2000000ull
@@ -20,8 +21,41 @@
 #define SJA1105_LINKLOCAL_FILTER_B		0x011B19000000ull
 #define SJA1105_LINKLOCAL_FILTER_B_MASK		0xFFFFFF000000ull
 
+/* Source and Destination MAC of follow-up meta frames.
+ * Whereas the choice of SMAC only affects the unique identification of the
+ * switch as sender of meta frames, the DMAC must be an address that is present
+ * in the DSA master port's multicast MAC filter.
+ * 01-80-C2-00-00-0E is a good choice for this, as all profiles of IEEE 1588
+ * over L2 use this address for some purpose already.
+ */
+#define SJA1105_META_SMAC			0x222222222222ull
+#define SJA1105_META_DMAC			0x0180C200000Eull
+
+/* Global tagger data: each struct sja1105_port has a reference to
+ * the structure defined in struct sja1105_private.
+ */
+struct sja1105_tagger_data {
+	struct sk_buff_head skb_rxtstamp_queue;
+	struct work_struct rxtstamp_work;
+	struct sk_buff *stampable_skb;
+	/* Protects concurrent access to the meta state machine
+	 * from taggers running on multiple ports on SMP systems
+	 */
+	spinlock_t meta_lock;
+	bool hwts_rx_en;
+};
+
+struct sja1105_skb_cb {
+	u32 meta_tstamp;
+};
+
+#define SJA1105_SKB_CB(skb) \
+	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
+
 struct sja1105_port {
+	struct sja1105_tagger_data *data;
 	struct dsa_port *dp;
+	bool hwts_tx_en;
 	int mgmt_slot;
 };
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index e0903028d1cd..aac48b42f210 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -7,12 +7,59 @@
 #include <linux/packing.h>
 #include "dsa_priv.h"
 
+struct sja1105_meta {
+	u64 tstamp;
+	u64 dmac_byte_4;
+	u64 dmac_byte_3;
+	u64 source_port;
+	u64 switch_id;
+};
+
+static void sja1105_meta_unpack(const struct sk_buff *skb,
+				struct sja1105_meta *meta)
+{
+	u8 *buf = skb_mac_header(skb) + ETH_HLEN;
+
+	/* UM10944.pdf section 4.2.17 AVB Parameters:
+	 * Structure of the meta-data follow-up frame.
+	 * It is in network byte order, so there are no quirks
+	 * while unpacking the meta frame.
+	 *
+	 * Also SJA1105 E/T only populates bits 23:0 of the timestamp
+	 * whereas P/Q/R/S does 32 bits. Since the structure is the
+	 * same and the E/T puts zeroes in the high-order byte, use
+	 * a unified unpacking command for both device series.
+	 */
+	packing(buf,     &meta->tstamp,     31, 0, 4, UNPACK, 0);
+	packing(buf + 4, &meta->dmac_byte_4, 7, 0, 1, UNPACK, 0);
+	packing(buf + 5, &meta->dmac_byte_3, 7, 0, 1, UNPACK, 0);
+	packing(buf + 6, &meta->source_port, 7, 0, 1, UNPACK, 0);
+	packing(buf + 7, &meta->switch_id,   7, 0, 1, UNPACK, 0);
+}
+
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
+	if (ntohs(hdr->h_proto) != ETH_P_SJA1105_META)
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
+	if (sja1105_is_meta_frame(skb))
+		return true;
 	if (sja1105_is_link_local(skb))
 		return true;
 	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr))
@@ -47,18 +94,140 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 }
 
+static void sja1105_transfer_meta(struct sk_buff *skb,
+				  const struct sja1105_meta *meta)
+{
+	struct ethhdr *hdr = eth_hdr(skb);
+
+	hdr->h_dest[3] = meta->dmac_byte_3;
+	hdr->h_dest[4] = meta->dmac_byte_4;
+	SJA1105_SKB_CB(skb)->meta_tstamp = meta->tstamp;
+}
+
+/* This is a simple state machine which follows the hardware mechanism of
+ * generating RX timestamps:
+ *
+ * After each timestampable skb (all traffic for which send_meta1 and
+ * send_meta0 is true, aka all MAC-filtered link-local traffic) a meta frame
+ * containing a partial timestamp is immediately generated by the switch and
+ * sent as a follow-up to the link-local frame on the CPU port.
+ *
+ * The meta frames have no unique identifier (such as sequence number) by which
+ * one may pair them to the correct timestampable frame.
+ * Instead, the switch has internal logic that ensures no frames are sent on
+ * the CPU port between a link-local timestampable frame and its corresponding
+ * meta follow-up. It also ensures strict ordering between ports (lower ports
+ * have higher priority towards the CPU port). For this reason, a per-port
+ * data structure is not needed/desirable.
+ *
+ * This function pairs the link-local frame with its partial timestamp from the
+ * meta follow-up frame. The full timestamp will be reconstructed later in a
+ * work queue.
+ */
+static struct sk_buff
+*sja1105_rcv_meta_state_machine(struct sk_buff *skb,
+				struct sja1105_meta *meta,
+				bool is_link_local,
+				bool is_meta)
+{
+	struct sja1105_port *sp;
+	struct dsa_port *dp;
+
+	dp = dsa_slave_to_port(skb->dev);
+	sp = dp->priv;
+
+	/* Step 1: A timestampable frame was received.
+	 * Buffer it until we get its meta frame.
+	 */
+	if (is_link_local && sp->data->hwts_rx_en) {
+		spin_lock(&sp->data->meta_lock);
+		/* Was this a link-local frame instead of the meta
+		 * that we were expecting?
+		 */
+		if (sp->data->stampable_skb) {
+			dev_err_ratelimited(dp->ds->dev,
+					    "Expected meta frame, is %12llx "
+					    "in the DSA master multicast filter?\n",
+					    SJA1105_META_DMAC);
+		}
+
+		/* Hold a reference to avoid dsa_switch_rcv
+		 * from freeing the skb.
+		 */
+		sp->data->stampable_skb = skb_get(skb);
+		spin_unlock(&sp->data->meta_lock);
+
+		/* Tell DSA we got nothing */
+		return NULL;
+
+	/* Step 2: The meta frame arrived.
+	 * Time to take the stampable skb out of the closet, annotate it
+	 * with the partial timestamp, and pretend that we received it
+	 * just now (basically masquerade the buffered frame as the meta
+	 * frame, which serves no further purpose).
+	 */
+	} else if (is_meta) {
+		struct sk_buff *stampable_skb;
+
+		spin_lock(&sp->data->meta_lock);
+
+		stampable_skb = sp->data->stampable_skb;
+		sp->data->stampable_skb = NULL;
+
+		/* Was this a meta frame instead of the link-local
+		 * that we were expecting?
+		 */
+		if (!stampable_skb) {
+			dev_err_ratelimited(dp->ds->dev,
+					    "Unexpected meta frame\n");
+			spin_unlock(&sp->data->meta_lock);
+			return NULL;
+		}
+
+		if (stampable_skb->dev != skb->dev) {
+			dev_err_ratelimited(dp->ds->dev,
+					    "Meta frame on wrong port\n");
+			spin_unlock(&sp->data->meta_lock);
+			return NULL;
+		}
+
+		/* Free the meta frame and give DSA the buffered stampable_skb
+		 * for further processing up the network stack.
+		 */
+		kfree_skb(skb);
+
+		skb = skb_copy(stampable_skb, GFP_ATOMIC);
+		if (!skb) {
+			dev_err_ratelimited(dp->ds->dev,
+					    "Failed to copy stampable skb\n");
+			return NULL;
+		}
+		sja1105_transfer_meta(skb, meta);
+		/* The cached copy will be freed now */
+		skb_unref(stampable_skb);
+
+		spin_unlock(&sp->data->meta_lock);
+	}
+
+	return skb;
+}
+
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
 {
-	struct ethhdr *hdr = eth_hdr(skb);
-	u64 source_port, switch_id;
+	struct sja1105_meta meta = {0};
+	int source_port, switch_id;
 	struct sk_buff *nskb;
 	u16 tpid, vid, tci;
+	bool is_link_local;
 	bool is_tagged;
+	bool is_meta;
 
 	nskb = dsa_8021q_rcv(skb, netdev, pt, &tpid, &tci);
 	is_tagged = (nskb && tpid == ETH_P_SJA1105);
+	is_link_local = sja1105_is_link_local(skb);
+	is_meta = sja1105_is_meta_frame(skb);
 
 	skb->offload_fwd_mark = 1;
 
@@ -68,7 +237,9 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		source_port = dsa_8021q_rx_source_port(vid);
 		switch_id = dsa_8021q_rx_switch_id(vid);
 		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
-	} else if (sja1105_is_link_local(skb)) {
+	} else if (is_link_local) {
+		struct ethhdr *hdr = eth_hdr(skb);
+
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
 		 * the incl_srcpt options.
@@ -78,6 +249,12 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		/* Clear the DMAC bytes that were mangled by the switch */
 		hdr->h_dest[3] = 0;
 		hdr->h_dest[4] = 0;
+	} else if (is_meta) {
+		sja1105_meta_unpack(skb, &meta);
+		source_port = meta.source_port;
+		switch_id = meta.switch_id;
+	} else {
+		return NULL;
 	}
 
 	skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
@@ -92,7 +269,8 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	if (is_tagged)
 		skb = dsa_8021q_remove_header(skb);
 
-	return skb;
+	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
+					      is_meta);
 }
 
 static struct dsa_device_ops sja1105_netdev_ops = {
-- 
2.17.1

