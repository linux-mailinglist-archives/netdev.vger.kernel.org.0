Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D0BD4AD7
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 01:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfJKXSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 19:18:32 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56070 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfJKXSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 19:18:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id a6so11857064wma.5
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 16:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NRn48FoNhvrjRaix0j4zcWfuAP78lfRT62q1x55TZXI=;
        b=arQ9xRTiYQnRzzmbGs/GCPyD7i8+NTY8mjFdotyoM+MFMT8EJVQHowujcCTBW6mUzG
         0Mzu3yRFCKKPhGEZKugQ8c2FoMRBACgKwPwZR+yJgeQckaSSU4DgkgtXq814Z568xkAe
         6x2GZ9xOVFcTTCaEojvR/bxw98KFnpQeKzRwolAibNWY40S2LSgiP1aEeqwdkBZOrAwr
         WM5YIqnxE14CoPSjCMzyS+IkwjKXiSXoJMwXaptp3FCuhzABLtXfeBwIM06FlfX5Io0O
         ZaC+ZEDvUbhYIqFEg84MGwktNZheoV7ZrqkAAzsu/9j7SSAcVjfRWP3k/0PU/zCB1SVY
         phdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NRn48FoNhvrjRaix0j4zcWfuAP78lfRT62q1x55TZXI=;
        b=rH1/f8Q0RS1X2cKLYAowX/sn8qKDsbm4E9f9fN0WrXoBda63G6QRqbA1eYeBmpYRsj
         ugmRscfG9qXTXgpbDDW9E3Udk9O8ktJvvQpF24rWDx7+iHxV/0kBlq/VcDb9qLIjBvSJ
         MMfENB+9/4Bvh+JCSZbaS3GrmTLiCvBEPr+ds5a7vcUny41C4UP7YSaK2KR3TkYyJCdq
         wuofRgJHQ6F7DymRBC7o9aTeARIP8GWBBcwNdgPvntf+euMfVPndBjlymaj5f0LqEILE
         X5AH8PfBUuHv4G5Ezszt2zUkLhxW1h4+cajO6c+1Ap6GG8fJfR0cHH0s4hLjQDwtQZHn
         baNw==
X-Gm-Message-State: APjAAAUiuihrBn3WgqVUbActZtKc4CG07fsAItcTIFhds6xS+fdH5rBO
        UgxMbuXgbThvYYG4ojWJPLE=
X-Google-Smtp-Source: APXvYqyWDpnvKT2C1iswxUPQDGAG9wpwJIkDvQZ3MRA699MDh/Q2XDdVojX/XBY6DzFsflavNWtqCg==
X-Received: by 2002:a1c:3884:: with SMTP id f126mr4969496wma.162.1570835907543;
        Fri, 11 Oct 2019 16:18:27 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id 207sm17425853wme.17.2019.10.11.16.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 16:18:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/4] net: dsa: sja1105: Move PTP data to its own private structure
Date:   Sat, 12 Oct 2019 02:18:15 +0300
Message-Id: <20191011231816.7888-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011231816.7888-1-olteanv@gmail.com>
References: <20191011231816.7888-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a non-functional change with 2 goals (both for the case when
CONFIG_NET_DSA_SJA1105_PTP is not enabled):

- Reduce the size of the sja1105_private structure.
- Make the PTP code more self-contained.

Leaving priv->ptp_data.lock to be initialized in sja1105_main.c is not a
leftover: it will be used in a future patch "net: dsa: sja1105: Restore
PTP time after switch reset".

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  13 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 231 +----------------
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 332 +++++++++++++++++++++----
 drivers/net/dsa/sja1105/sja1105_ptp.h  |  55 +++-
 4 files changed, 335 insertions(+), 296 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 7ae655670bab..cb619225cd46 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -21,6 +21,7 @@
 #define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
 
 #include "sja1105_tas.h"
+#include "sja1105_ptp.h"
 
 /* Keeps the different addresses between E/T and P/Q/R/S */
 struct sja1105_regs {
@@ -91,26 +92,16 @@ struct sja1105_private {
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
-	struct ptp_clock_info ptp_caps;
-	struct ptp_clock *clock;
-	/* The cycle counter translates the PTP timestamps (based on
-	 * a free-running counter) into a software time domain.
-	 */
-	struct cyclecounter tstamp_cc;
-	struct timecounter tstamp_tc;
-	struct delayed_work refresh_work;
-	/* Serializes all operations on the cycle counter */
-	struct mutex ptp_lock;
 	/* Serializes transmission of management frames so that
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
 	struct sja1105_tagger_data tagger_data;
+	struct sja1105_ptp_data ptp_data;
 	struct sja1105_tas_data tas_data;
 };
 
 #include "sja1105_dynamic_config.h"
-#include "sja1105_ptp.h"
 
 struct sja1105_spi_message {
 	u64 access;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 586974687ba2..2ffe642cf54b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -506,39 +506,6 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	return 0;
 }
 
-static int sja1105_init_avb_params(struct sja1105_private *priv,
-				   bool on)
-{
-	struct sja1105_avb_params_entry *avb;
-	struct sja1105_table *table;
-
-	table = &priv->static_config.tables[BLK_IDX_AVB_PARAMS];
-
-	/* Discard previous AVB Parameters Table */
-	if (table->entry_count) {
-		kfree(table->entries);
-		table->entry_count = 0;
-	}
-
-	/* Configure the reception of meta frames only if requested */
-	if (!on)
-		return 0;
-
-	table->entries = kcalloc(SJA1105_MAX_AVB_PARAMS_COUNT,
-				 table->ops->unpacked_entry_size, GFP_KERNEL);
-	if (!table->entries)
-		return -ENOMEM;
-
-	table->entry_count = SJA1105_MAX_AVB_PARAMS_COUNT;
-
-	avb = table->entries;
-
-	avb->destmeta = SJA1105_META_DMAC;
-	avb->srcmeta  = SJA1105_META_SMAC;
-
-	return 0;
-}
-
 static int sja1105_static_config_load(struct sja1105_private *priv,
 				      struct sja1105_dt_port *ports)
 {
@@ -577,9 +544,6 @@ static int sja1105_static_config_load(struct sja1105_private *priv,
 	if (rc < 0)
 		return rc;
 	rc = sja1105_init_general_params(priv);
-	if (rc < 0)
-		return rc;
-	rc = sja1105_init_avb_params(priv, false);
 	if (rc < 0)
 		return rc;
 
@@ -1728,8 +1692,6 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	struct sja1105_private *priv = ds->priv;
 
 	sja1105_tas_teardown(ds);
-	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
-	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
 	sja1105_ptp_clock_unregister(ds);
 	sja1105_static_config_free(&priv->static_config);
 }
@@ -1816,11 +1778,8 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_port *sp = &priv->ports[port];
-	struct skb_shared_hwtstamps shwt = {0};
 	int slot = sp->mgmt_slot;
 	struct sk_buff *clone;
-	u64 now, ts;
-	int rc;
 
 	/* The tragic fact about the switch having 4x2 slots for installing
 	 * management routes is that all of them except one are actually
@@ -1846,27 +1805,8 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 	if (!clone)
 		goto out;
 
-	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
-
-	mutex_lock(&priv->ptp_lock);
-
-	now = priv->tstamp_cc.read(&priv->tstamp_cc);
-
-	rc = sja1105_ptpegr_ts_poll(ds, slot, &ts);
-	if (rc < 0) {
-		dev_err(ds->dev, "xmit: timed out polling for tstamp\n");
-		kfree_skb(clone);
-		goto out_unlock_ptp;
-	}
-
-	ts = sja1105_tstamp_reconstruct(ds, now, ts);
-	ts = timecounter_cyc2time(&priv->tstamp_tc, ts);
-
-	shwt.hwtstamp = ns_to_ktime(ts);
-	skb_complete_tx_timestamp(clone, &shwt);
+	sja1105_ptp_txtstamp_skb(ds, slot, clone);
 
-out_unlock_ptp:
-	mutex_unlock(&priv->ptp_lock);
 out:
 	mutex_unlock(&priv->mgmt_lock);
 	return NETDEV_TX_OK;
@@ -1896,171 +1836,6 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 	return sja1105_static_config_reload(priv);
 }
 
-/* Must be called only with priv->tagger_data.state bit
- * SJA1105_HWTS_RX_EN cleared
- */
-static int sja1105_change_rxtstamping(struct sja1105_private *priv,
-				      bool on)
-{
-	struct sja1105_general_params_entry *general_params;
-	struct sja1105_table *table;
-	int rc;
-
-	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
-	general_params = table->entries;
-	general_params->send_meta1 = on;
-	general_params->send_meta0 = on;
-
-	rc = sja1105_init_avb_params(priv, on);
-	if (rc < 0)
-		return rc;
-
-	/* Initialize the meta state machine to a known state */
-	if (priv->tagger_data.stampable_skb) {
-		kfree_skb(priv->tagger_data.stampable_skb);
-		priv->tagger_data.stampable_skb = NULL;
-	}
-
-	return sja1105_static_config_reload(priv);
-}
-
-static int sja1105_hwtstamp_set(struct dsa_switch *ds, int port,
-				struct ifreq *ifr)
-{
-	struct sja1105_private *priv = ds->priv;
-	struct hwtstamp_config config;
-	bool rx_on;
-	int rc;
-
-	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
-		return -EFAULT;
-
-	switch (config.tx_type) {
-	case HWTSTAMP_TX_OFF:
-		priv->ports[port].hwts_tx_en = false;
-		break;
-	case HWTSTAMP_TX_ON:
-		priv->ports[port].hwts_tx_en = true;
-		break;
-	default:
-		return -ERANGE;
-	}
-
-	switch (config.rx_filter) {
-	case HWTSTAMP_FILTER_NONE:
-		rx_on = false;
-		break;
-	default:
-		rx_on = true;
-		break;
-	}
-
-	if (rx_on != test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state)) {
-		clear_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
-
-		rc = sja1105_change_rxtstamping(priv, rx_on);
-		if (rc < 0) {
-			dev_err(ds->dev,
-				"Failed to change RX timestamping: %d\n", rc);
-			return rc;
-		}
-		if (rx_on)
-			set_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
-	}
-
-	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
-		return -EFAULT;
-	return 0;
-}
-
-static int sja1105_hwtstamp_get(struct dsa_switch *ds, int port,
-				struct ifreq *ifr)
-{
-	struct sja1105_private *priv = ds->priv;
-	struct hwtstamp_config config;
-
-	config.flags = 0;
-	if (priv->ports[port].hwts_tx_en)
-		config.tx_type = HWTSTAMP_TX_ON;
-	else
-		config.tx_type = HWTSTAMP_TX_OFF;
-	if (test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state))
-		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
-	else
-		config.rx_filter = HWTSTAMP_FILTER_NONE;
-
-	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
-		-EFAULT : 0;
-}
-
-#define to_tagger(d) \
-	container_of((d), struct sja1105_tagger_data, rxtstamp_work)
-#define to_sja1105(d) \
-	container_of((d), struct sja1105_private, tagger_data)
-
-static void sja1105_rxtstamp_work(struct work_struct *work)
-{
-	struct sja1105_tagger_data *data = to_tagger(work);
-	struct sja1105_private *priv = to_sja1105(data);
-	struct dsa_switch *ds = priv->ds;
-	struct sk_buff *skb;
-	u64 now;
-
-	mutex_lock(&priv->ptp_lock);
-
-	while ((skb = skb_dequeue(&data->skb_rxtstamp_queue)) != NULL) {
-		struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
-		u64 ts;
-
-		now = priv->tstamp_cc.read(&priv->tstamp_cc);
-
-		*shwt = (struct skb_shared_hwtstamps) {0};
-
-		ts = SJA1105_SKB_CB(skb)->meta_tstamp;
-		ts = sja1105_tstamp_reconstruct(ds, now, ts);
-		ts = timecounter_cyc2time(&priv->tstamp_tc, ts);
-
-		shwt->hwtstamp = ns_to_ktime(ts);
-		netif_rx_ni(skb);
-	}
-
-	mutex_unlock(&priv->ptp_lock);
-}
-
-/* Called from dsa_skb_defer_rx_timestamp */
-static bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
-				  struct sk_buff *skb, unsigned int type)
-{
-	struct sja1105_private *priv = ds->priv;
-	struct sja1105_tagger_data *data = &priv->tagger_data;
-
-	if (!test_bit(SJA1105_HWTS_RX_EN, &data->state))
-		return false;
-
-	/* We need to read the full PTP clock to reconstruct the Rx
-	 * timestamp. For that we need a sleepable context.
-	 */
-	skb_queue_tail(&data->skb_rxtstamp_queue, skb);
-	schedule_work(&data->rxtstamp_work);
-	return true;
-}
-
-/* Called from dsa_skb_tx_timestamp. This callback is just to make DSA clone
- * the skb and have it available in DSA_SKB_CB in the .port_deferred_xmit
- * callback, where we will timestamp it synchronously.
- */
-static bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
-				  struct sk_buff *skb, unsigned int type)
-{
-	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port *sp = &priv->ports[port];
-
-	if (!sp->hwts_tx_en)
-		return false;
-
-	return true;
-}
-
 static int sja1105_port_setup_tc(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type,
 				 void *type_data)
@@ -2281,9 +2056,6 @@ static int sja1105_probe(struct spi_device *spi)
 	priv->ds = ds;
 
 	tagger_data = &priv->tagger_data;
-	skb_queue_head_init(&tagger_data->skb_rxtstamp_queue);
-	INIT_WORK(&tagger_data->rxtstamp_work, sja1105_rxtstamp_work);
-	spin_lock_init(&tagger_data->meta_lock);
 
 	/* Connections between dsa_port and sja1105_port */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
@@ -2293,6 +2065,7 @@ static int sja1105_probe(struct spi_device *spi)
 		sp->dp = &ds->ports[i];
 		sp->data = tagger_data;
 	}
+	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->mgmt_lock);
 
 	sja1105_tas_setup(ds);
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index d9cae68d544c..625411f59627 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -50,21 +50,155 @@
 #define SJA1105_CC_MULT_NUM		(1 << 9)
 #define SJA1105_CC_MULT_DEM		15625
 
-#define ptp_to_sja1105(d) container_of((d), struct sja1105_private, ptp_caps)
-#define cc_to_sja1105(d) container_of((d), struct sja1105_private, tstamp_cc)
-#define dw_to_sja1105(d) container_of((d), struct sja1105_private, refresh_work)
+#define ptp_caps_to_data(d) \
+		container_of((d), struct sja1105_ptp_data, caps)
+#define cc_to_ptp_data(d) \
+		container_of((d), struct sja1105_ptp_data, tstamp_cc)
+#define dw_to_ptp_data(d) \
+		container_of((d), struct sja1105_ptp_data, refresh_work)
+#define ptp_data_to_sja1105(d) \
+		container_of((d), struct sja1105_private, ptp_data)
 
 struct sja1105_ptp_cmd {
 	u64 resptp;       /* reset */
 };
 
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
+/* Must be called only with priv->tagger_data.state bit
+ * SJA1105_HWTS_RX_EN cleared
+ */
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
+int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
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
+	if (rx_on != test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state)) {
+		clear_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
+
+		rc = sja1105_change_rxtstamping(priv, rx_on);
+		if (rc < 0) {
+			dev_err(ds->dev,
+				"Failed to change RX timestamping: %d\n", rc);
+			return rc;
+		}
+		if (rx_on)
+			set_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
+	}
+
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+	return 0;
+}
+
+int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct hwtstamp_config config;
+
+	config.flags = 0;
+	if (priv->ports[port].hwts_tx_en)
+		config.tx_type = HWTSTAMP_TX_ON;
+	else
+		config.tx_type = HWTSTAMP_TX_OFF;
+	if (test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state))
+		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+	else
+		config.rx_filter = HWTSTAMP_FILTER_NONE;
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *info)
 {
 	struct sja1105_private *priv = ds->priv;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
 	/* Called during cleanup */
-	if (!priv->clock)
+	if (!ptp_data->clock)
 		return -ENODEV;
 
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
@@ -74,7 +208,7 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			 (1 << HWTSTAMP_TX_ON);
 	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
 			   (1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT);
-	info->phc_index = ptp_clock_index(priv->clock);
+	info->phc_index = ptp_clock_index(ptp_data->clock);
 	return 0;
 }
 
@@ -126,8 +260,8 @@ int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds, const void *data)
  * Must be called within one wraparound period of the partial timestamp since
  * it was generated by the MAC.
  */
-u64 sja1105_tstamp_reconstruct(struct dsa_switch *ds, u64 now,
-			       u64 ts_partial)
+static u64 sja1105_tstamp_reconstruct(struct dsa_switch *ds, u64 now,
+				      u64 ts_partial)
 {
 	struct sja1105_private *priv = ds->priv;
 	u64 partial_tstamp_mask = CYCLECOUNTER_MASK(priv->info->ptp_ts_bits);
@@ -171,7 +305,7 @@ u64 sja1105_tstamp_reconstruct(struct dsa_switch *ds, u64 now,
  * To have common code for E/T and P/Q/R/S for reading the timestamp,
  * we need to juggle with the offset and the bit indices.
  */
-int sja1105_ptpegr_ts_poll(struct dsa_switch *ds, int port, u64 *ts)
+static int sja1105_ptpegr_ts_poll(struct dsa_switch *ds, int port, u64 *ts)
 {
 	struct sja1105_private *priv = ds->priv;
 	const struct sja1105_regs *regs = priv->info->regs;
@@ -216,22 +350,91 @@ int sja1105_ptpegr_ts_poll(struct dsa_switch *ds, int port, u64 *ts)
 	return 0;
 }
 
+#define rxtstamp_to_tagger(d) \
+	container_of((d), struct sja1105_tagger_data, rxtstamp_work)
+#define tagger_to_sja1105(d) \
+	container_of((d), struct sja1105_private, tagger_data)
+
+static void sja1105_rxtstamp_work(struct work_struct *work)
+{
+	struct sja1105_tagger_data *tagger_data = rxtstamp_to_tagger(work);
+	struct sja1105_private *priv = tagger_to_sja1105(tagger_data);
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+	struct dsa_switch *ds = priv->ds;
+	struct sk_buff *skb;
+
+	mutex_lock(&ptp_data->lock);
+
+	while ((skb = skb_dequeue(&tagger_data->skb_rxtstamp_queue)) != NULL) {
+		struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
+		u64 now, ts;
+
+		now = ptp_data->tstamp_cc.read(&ptp_data->tstamp_cc);
+
+		*shwt = (struct skb_shared_hwtstamps) {0};
+
+		ts = SJA1105_SKB_CB(skb)->meta_tstamp;
+		ts = sja1105_tstamp_reconstruct(ds, now, ts);
+		ts = timecounter_cyc2time(&ptp_data->tstamp_tc, ts);
+
+		shwt->hwtstamp = ns_to_ktime(ts);
+		netif_rx_ni(skb);
+	}
+
+	mutex_unlock(&ptp_data->lock);
+}
+
+/* Called from dsa_skb_defer_rx_timestamp */
+bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb, unsigned int type)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
+
+	if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
+		return false;
+
+	/* We need to read the full PTP clock to reconstruct the Rx
+	 * timestamp. For that we need a sleepable context.
+	 */
+	skb_queue_tail(&tagger_data->skb_rxtstamp_queue, skb);
+	schedule_work(&tagger_data->rxtstamp_work);
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
 int sja1105_ptp_reset(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	struct sja1105_ptp_cmd cmd = {0};
 	int rc;
 
-	mutex_lock(&priv->ptp_lock);
+	mutex_lock(&ptp_data->lock);
 
 	cmd.resptp = 1;
 	dev_dbg(ds->dev, "Resetting PTP clock\n");
 	rc = priv->info->ptp_cmd(ds, &cmd);
 
-	timecounter_init(&priv->tstamp_tc, &priv->tstamp_cc,
+	timecounter_init(&ptp_data->tstamp_tc, &ptp_data->tstamp_cc,
 			 ktime_to_ns(ktime_get_real()));
 
-	mutex_unlock(&priv->ptp_lock);
+	mutex_unlock(&ptp_data->lock);
 
 	return rc;
 }
@@ -239,12 +442,12 @@ int sja1105_ptp_reset(struct dsa_switch *ds)
 static int sja1105_ptp_gettime(struct ptp_clock_info *ptp,
 			       struct timespec64 *ts)
 {
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
 	u64 ns;
 
-	mutex_lock(&priv->ptp_lock);
-	ns = timecounter_read(&priv->tstamp_tc);
-	mutex_unlock(&priv->ptp_lock);
+	mutex_lock(&ptp_data->lock);
+	ns = timecounter_read(&ptp_data->tstamp_tc);
+	mutex_unlock(&ptp_data->lock);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -254,25 +457,25 @@ static int sja1105_ptp_gettime(struct ptp_clock_info *ptp,
 static int sja1105_ptp_settime(struct ptp_clock_info *ptp,
 			       const struct timespec64 *ts)
 {
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
 	u64 ns = timespec64_to_ns(ts);
 
-	mutex_lock(&priv->ptp_lock);
-	timecounter_init(&priv->tstamp_tc, &priv->tstamp_cc, ns);
-	mutex_unlock(&priv->ptp_lock);
+	mutex_lock(&ptp_data->lock);
+	timecounter_init(&ptp_data->tstamp_tc, &ptp_data->tstamp_cc, ns);
+	mutex_unlock(&ptp_data->lock);
 
 	return 0;
 }
 
 static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
 	s64 clkrate;
 
 	clkrate = (s64)scaled_ppm * SJA1105_CC_MULT_NUM;
 	clkrate = div_s64(clkrate, SJA1105_CC_MULT_DEM);
 
-	mutex_lock(&priv->ptp_lock);
+	mutex_lock(&ptp_data->lock);
 
 	/* Force a readout to update the timer *before* changing its frequency.
 	 *
@@ -300,29 +503,30 @@ static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	 * instead of a compound function made of two segments (one at the old
 	 * and the other at the new rate) - introducing some inaccuracy.
 	 */
-	timecounter_read(&priv->tstamp_tc);
+	timecounter_read(&ptp_data->tstamp_tc);
 
-	priv->tstamp_cc.mult = SJA1105_CC_MULT + clkrate;
+	ptp_data->tstamp_cc.mult = SJA1105_CC_MULT + clkrate;
 
-	mutex_unlock(&priv->ptp_lock);
+	mutex_unlock(&ptp_data->lock);
 
 	return 0;
 }
 
 static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
 
-	mutex_lock(&priv->ptp_lock);
-	timecounter_adjtime(&priv->tstamp_tc, delta);
-	mutex_unlock(&priv->ptp_lock);
+	mutex_lock(&ptp_data->lock);
+	timecounter_adjtime(&ptp_data->tstamp_tc, delta);
+	mutex_unlock(&ptp_data->lock);
 
 	return 0;
 }
 
 static u64 sja1105_ptptsclk_read(const struct cyclecounter *cc)
 {
-	struct sja1105_private *priv = cc_to_sja1105(cc);
+	struct sja1105_ptp_data *ptp_data = cc_to_ptp_data(cc);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
 	const struct sja1105_regs *regs = priv->info->regs;
 	u64 ptptsclk = 0;
 	int rc;
@@ -338,26 +542,29 @@ static u64 sja1105_ptptsclk_read(const struct cyclecounter *cc)
 static void sja1105_ptp_overflow_check(struct work_struct *work)
 {
 	struct delayed_work *dw = to_delayed_work(work);
-	struct sja1105_private *priv = dw_to_sja1105(dw);
+	struct sja1105_ptp_data *ptp_data = dw_to_ptp_data(dw);
 	struct timespec64 ts;
 
-	sja1105_ptp_gettime(&priv->ptp_caps, &ts);
+	sja1105_ptp_gettime(&ptp_data->caps, &ts);
 
-	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
+	schedule_delayed_work(&ptp_data->refresh_work,
+			      SJA1105_REFRESH_INTERVAL);
 }
 
 int sja1105_ptp_clock_register(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
+	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
 	/* Set up the cycle counter */
-	priv->tstamp_cc = (struct cyclecounter) {
+	ptp_data->tstamp_cc = (struct cyclecounter) {
 		.read		= sja1105_ptptsclk_read,
 		.mask		= CYCLECOUNTER_MASK(64),
 		.shift		= SJA1105_CC_SHIFT,
 		.mult		= SJA1105_CC_MULT,
 	};
-	priv->ptp_caps = (struct ptp_clock_info) {
+	ptp_data->caps = (struct ptp_clock_info) {
 		.owner		= THIS_MODULE,
 		.name		= "SJA1105 PHC",
 		.adjfine	= sja1105_ptp_adjfine,
@@ -367,14 +574,16 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 		.max_adj	= SJA1105_MAX_ADJ_PPB,
 	};
 
-	mutex_init(&priv->ptp_lock);
+	skb_queue_head_init(&tagger_data->skb_rxtstamp_queue);
+	INIT_WORK(&tagger_data->rxtstamp_work, sja1105_rxtstamp_work);
+	spin_lock_init(&tagger_data->meta_lock);
 
-	priv->clock = ptp_clock_register(&priv->ptp_caps, ds->dev);
-	if (IS_ERR_OR_NULL(priv->clock))
-		return PTR_ERR(priv->clock);
+	ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);
+	if (IS_ERR_OR_NULL(ptp_data->clock))
+		return PTR_ERR(ptp_data->clock);
 
-	INIT_DELAYED_WORK(&priv->refresh_work, sja1105_ptp_overflow_check);
-	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
+	INIT_DELAYED_WORK(&ptp_data->refresh_work, sja1105_ptp_overflow_check);
+	schedule_delayed_work(&ptp_data->refresh_work, SJA1105_REFRESH_INTERVAL);
 
 	return sja1105_ptp_reset(ds);
 }
@@ -382,11 +591,46 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
-	if (IS_ERR_OR_NULL(priv->clock))
+	if (IS_ERR_OR_NULL(ptp_data->clock))
 		return;
 
-	cancel_delayed_work_sync(&priv->refresh_work);
-	ptp_clock_unregister(priv->clock);
-	priv->clock = NULL;
+	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
+	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
+	cancel_delayed_work_sync(&ptp_data->refresh_work);
+	ptp_clock_unregister(ptp_data->clock);
+	ptp_data->clock = NULL;
+}
+
+void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
+			      struct sk_buff *skb)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+	struct skb_shared_hwtstamps shwt = {0};
+	u64 now, ts;
+	int rc;
+
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	mutex_lock(&ptp_data->lock);
+
+	now = ptp_data->tstamp_cc.read(&ptp_data->tstamp_cc);
+
+	rc = sja1105_ptpegr_ts_poll(ds, slot, &ts);
+	if (rc < 0) {
+		dev_err(ds->dev, "timed out polling for tstamp\n");
+		kfree_skb(skb);
+		goto out;
+	}
+
+	ts = sja1105_tstamp_reconstruct(ds, now, ts);
+	ts = timecounter_cyc2time(&ptp_data->tstamp_tc, ts);
+
+	shwt.hwtstamp = ns_to_ktime(ts);
+	skb_complete_tx_timestamp(skb, &shwt);
+
+out:
+	mutex_unlock(&ptp_data->lock);
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 65d3d51da9ad..0b6b0e262a02 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -6,12 +6,23 @@
 
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
 
+struct sja1105_ptp_data {
+	struct ptp_clock_info caps;
+	struct ptp_clock *clock;
+	/* The cycle counter translates the PTP timestamps (based on
+	 * a free-running counter) into a software time domain.
+	 */
+	struct cyclecounter tstamp_cc;
+	struct timecounter tstamp_tc;
+	struct delayed_work refresh_work;
+	/* Serializes all operations on the cycle counter */
+	struct mutex lock;
+};
+
 int sja1105_ptp_clock_register(struct dsa_switch *ds);
 
 void sja1105_ptp_clock_unregister(struct dsa_switch *ds);
 
-int sja1105_ptpegr_ts_poll(struct dsa_switch *ds, int port, u64 *ts);
-
 int sja1105et_ptp_cmd(const struct dsa_switch *ds, const void *data);
 
 int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds, const void *data);
@@ -19,12 +30,31 @@ int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds, const void *data);
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *ts);
 
-u64 sja1105_tstamp_reconstruct(struct dsa_switch *ds, u64 now, u64 ts_partial);
+void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
+			      struct sk_buff *clone);
 
 int sja1105_ptp_reset(struct dsa_switch *ds);
 
+bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb, unsigned int type);
+
+bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb, unsigned int type);
+
+int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
+
+int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
+
 #else
 
+/* Structures cannot be empty in C. Bah!
+ * Keep the mutex as the only element, which is a bit more difficult to
+ * refactor out of sja1105_main.c anyway.
+ */
+struct sja1105_ptp_data {
+	struct mutex lock;
+};
+
 static inline int sja1105_ptp_clock_register(struct dsa_switch *ds)
 {
 	return 0;
@@ -32,16 +62,9 @@ static inline int sja1105_ptp_clock_register(struct dsa_switch *ds)
 
 static inline void sja1105_ptp_clock_unregister(struct dsa_switch *ds) { }
 
-static inline int
-sja1105_ptpegr_ts_poll(struct dsa_switch *ds, int port, u64 *ts)
+static inline void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
+					    struct sk_buff *clone)
 {
-	return 0;
-}
-
-static inline u64 sja1105_tstamp_reconstruct(struct dsa_switch *ds,
-					     u64 now, u64 ts_partial)
-{
-	return 0;
 }
 
 static inline int sja1105_ptp_reset(struct dsa_switch *ds)
@@ -55,6 +78,14 @@ static inline int sja1105_ptp_reset(struct dsa_switch *ds)
 
 #define sja1105_get_ts_info NULL
 
+#define sja1105_port_rxtstamp NULL
+
+#define sja1105_port_txtstamp NULL
+
+#define sja1105_hwtstamp_get NULL
+
+#define sja1105_hwtstamp_set NULL
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP) */
 
 #endif /* _SJA1105_PTP_H */
-- 
2.17.1

