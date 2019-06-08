Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025EB39F7F
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfFHMF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37170 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbfFHMF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14so4658871wrr.4;
        Sat, 08 Jun 2019 05:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JMjK9rP0f+NDXHBF5qPMF4qLrV4RupeqMj55TuBUHrc=;
        b=e/lhLHKSAEHUULEqbJdZ72MDUg1xVIO9PnW95SWZ7NcaGQ3nrwu0zeWvkTCW9BQGQU
         CltaD7hHYdgSjEXbQcEkAHKK9int+NL244zAOVr/YUEHlvV+o+DhG3lsUZdJHjQ59REg
         4VkcDa56H/SA5I1p72Y4PiamtxKPPta5WqPIvNXzxarTWlWsShcw/VhwtPR9X8B/NzcE
         80o8iANO6J+kvcCApSmixFrglas0gPpQzzhzoUbcG4YO/1M5nTXAQAstsWEXt41R2BC0
         vP+PcQlW44Wezf517Z28rwNf2C9tPIz+5fZMjMdWEtG5mIzKMET7VatjPXsHCJAl9P39
         UJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JMjK9rP0f+NDXHBF5qPMF4qLrV4RupeqMj55TuBUHrc=;
        b=TY1ouYLx8W7AfEfhquKzcn5P1Cr32t6kfY+SlzthRdZENaeP+3RFmjd+ZOHwAWxxIs
         8+KYCiwnD+9/tE2v5msXBHAEJx137H+jxkxoIhqs8vU6g1EEWPNQ5viK/ba8BeebWHKQ
         Mx3d1/Mdrv8XYA3gR/ZsiUpCiiMG3on8vXyqkLeHYXomUueMJN+iLKbR/oy3Ziy+MV6f
         dLLcSNNW/8Njrrs8HzaV7RID1hoNu+mBGNwnJG/HwCI8MwkynUNDdbct515AhrYJXb6q
         pjvh2j7oAvAb3TiUZjeD4/5tvMJ3Cp8MbtJ85xlgCzc6VyvppqIC9aXdWclXjCfa7Nbp
         ExMQ==
X-Gm-Message-State: APjAAAVtMjPZEssEnUca2eaG53c+BhBTn62adZu6pKvszh+k2esM/dxT
        6IULmPVF3C7abkan5pS0D9w=
X-Google-Smtp-Source: APXvYqyLXw2d7xSQfjTh1Vo+yxWlr4faSGZVRY0VwJ0Eebu51JLuOSGkd8sAVJ3sPVQO/bi3pNSjkg==
X-Received: by 2002:adf:ec4c:: with SMTP id w12mr18753146wrn.160.1559995552743;
        Sat, 08 Jun 2019 05:05:52 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 16/17] net: dsa: sja1105: Add a state machine for RX timestamping
Date:   Sat,  8 Jun 2019 15:04:42 +0300
Message-Id: <20190608120443.21889-17-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Meta frame reception relies on the hardware keeping its promise that it
will send no other traffic towards the CPU port between a link-local
frame and a meta frame.  Otherwise there is no other way to associate
the meta frame with the link-local frame it's holding a timestamp of.
The receive function is made stateful, and buffers a timestampable frame
until its meta frame arrives, then merges the two, drops the meta and
releases the link-local frame up the stack.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:

None.

Changes in v3:

None.

Changes in v2:

None.

 drivers/net/dsa/sja1105/sja1105_main.c |  62 +++++++++++++
 include/linux/dsa/sja1105.h            |   7 ++
 net/dsa/tag_sja1105.c                  | 121 ++++++++++++++++++++++++-
 3 files changed, 189 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2b804eeca390..8963b21b3061 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1600,6 +1600,14 @@ static int sja1105_setup(struct dsa_switch *ds)
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
 			     struct sk_buff *skb, bool takets)
 {
@@ -1747,6 +1755,57 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 	return sja1105_static_config_reload(priv);
 }
 
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
+	/* We need to read the full PTP clock to reconstruct the Rx
+	 * timestamp. For that we need a sleepable context.
+	 */
+	skb_queue_tail(&data->skb_rxtstamp_queue, skb);
+	schedule_work(&data->rxtstamp_work);
+	return true;
+}
+
 /* Called from dsa_skb_tx_timestamp. This callback is just to make DSA clone
  * the skb and have it available in DSA_SKB_CB in the .port_deferred_xmit
  * callback, where we will timestamp it synchronously.
@@ -1766,6 +1825,7 @@ bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
+	.teardown		= sja1105_teardown,
 	.set_ageing_time	= sja1105_set_ageing_time,
 	.phylink_validate	= sja1105_phylink_validate,
 	.phylink_mac_config	= sja1105_mac_config,
@@ -1787,6 +1847,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
 	.port_deferred_xmit	= sja1105_port_deferred_xmit,
+	.port_rxtstamp		= sja1105_port_rxtstamp,
 	.port_txtstamp		= sja1105_port_txtstamp,
 };
 
@@ -1885,6 +1946,7 @@ static int sja1105_probe(struct spi_device *spi)
 
 	tagger_data = &priv->tagger_data;
 	skb_queue_head_init(&tagger_data->skb_rxtstamp_queue);
+	INIT_WORK(&tagger_data->rxtstamp_work, sja1105_rxtstamp_work);
 
 	/* Connections between dsa_port and sja1105_port */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 2c4fce4eaf0d..79435cfc20eb 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -45,6 +45,13 @@ struct sja1105_tagger_data {
 	bool hwts_rx_en;
 };
 
+struct sja1105_skb_cb {
+	u32 meta_tstamp;
+};
+
+#define SJA1105_SKB_CB(skb) \
+	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
+
 struct sja1105_port {
 	struct sja1105_tagger_data *data;
 	struct dsa_port *dp;
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 5b51e96130c7..1d96c9d4a8e9 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -110,6 +110,124 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
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
@@ -167,7 +285,8 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	if (is_tagged)
 		skb = dsa_8021q_remove_header(skb);
 
-	return skb;
+	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
+					      is_meta);
 }
 
 static struct dsa_device_ops sja1105_netdev_ops = {
-- 
2.17.1

