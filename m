Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091E434E5E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbfFDRI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:08:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39863 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbfFDRIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:24 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so834305wma.4;
        Tue, 04 Jun 2019 10:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rsA+CALbqiUuyR1hoRhMOx2rHPp6nivNVf4ZB/dZTSY=;
        b=Ai8tr+nubGMTXohvI3i9Phf66G+KyN5d0HwwAeTvcHZPYJLy1cug4vDWk1Vkq322JZ
         MUv5dXOoCdZXa+N+I/zUDGHDvS5sZiVe89zSpc9KXKAt6h/s69+2nnyzXxwLN00cg0Vk
         sL4+ldpzpHsT3y2AwxCmyQ85IutJAOb31iUP5ZuP56FS1tE6cyHRSWlfH3unhJvsaEo3
         iHCdfC1kmLLsaj0HVANjhI2BQSROZ73a6g3jJUmD/3Uls42EI8aS3/pxtMK+xBMVIbGw
         P/aYONL/xjPdXR9zXKNK6Bp8jnbT9Ta/LJ5ZoV0yuayKHqCh9C16M0PRUrQD6UdBpwzU
         YodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rsA+CALbqiUuyR1hoRhMOx2rHPp6nivNVf4ZB/dZTSY=;
        b=YT2b3H+KVquItq7kjQCRF5+ExZT2JXhYf4Ql2yAnH24Zz6AChtI/5f3azVvFn78F6L
         WcYKHP5Yd2TTmnJpnw90lO8VKuDZOuMZ8Y4OPQVci8uqMC8RBcnPQE9w9wACvgpgbN9R
         Ry2JmvKWqJOHc7SEdfUJisGN3lCxmcz0GG+0nKEzBhBWKtQHibfPIzxRT60LyeNAmwxf
         gn/C3+BcPPfneHo3ijk0YZsfgCXRU0JtbchKnFoTMc1IdslHkjio2axDChEPdWpwL6pA
         3COl4JlmMOjnl3foekc4aTsy5WuzbcRA6U2I86kqjR+Cpvn0FLciY/dtW+am5z4bFows
         ofhg==
X-Gm-Message-State: APjAAAW+wc9MNcvl7VN7rvF6Di8HOoEcKwfO5KnxfZNzqJ/SRBPhTsNP
        QNR2G6UdA3iE4kaXwZvc8uc=
X-Google-Smtp-Source: APXvYqziuzbkijdPKmoYuwDEdW3coEGahJINRUMdqHtKjyRitCCkHSwjusWkNIJvxHf1dbIp8SOVBQ==
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr1570167wmi.14.1559668101099;
        Tue, 04 Jun 2019 10:08:21 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 16/17] net: dsa: sja1105: Add a state machine for RX timestamping
Date:   Tue,  4 Jun 2019 20:07:55 +0300
Message-Id: <20190604170756.14338-17-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
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
Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 drivers/net/dsa/sja1105/sja1105_main.c |  65 +++++++++++++
 include/linux/dsa/sja1105.h            |   7 ++
 net/dsa/tag_sja1105.c                  | 121 ++++++++++++++++++++++++-
 3 files changed, 192 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index fceca0e5984f..46a851f54b83 100644
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
@@ -1747,6 +1755,60 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
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
 /* Called from dsa_skb_tx_timestamp. This callback is just to make DSA clone
  * the skb and have it available in DSA_SKB_CB in the .port_deferred_xmit
  * callback, where we will timestamp it synchronously.
@@ -1766,6 +1828,7 @@ bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
+	.teardown		= sja1105_teardown,
 	.set_ageing_time	= sja1105_set_ageing_time,
 	.phylink_validate	= sja1105_phylink_validate,
 	.phylink_mac_config	= sja1105_mac_config,
@@ -1787,6 +1850,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
 	.port_deferred_xmit	= sja1105_port_deferred_xmit,
+	.port_rxtstamp		= sja1105_port_rxtstamp,
 	.port_txtstamp		= sja1105_port_txtstamp,
 };
 
@@ -1885,6 +1949,7 @@ static int sja1105_probe(struct spi_device *spi)
 
 	tagger_data = &priv->tagger_data;
 	skb_queue_head_init(&tagger_data->skb_rxtstamp_queue);
+	INIT_WORK(&tagger_data->rxtstamp_work, sja1105_rxtstamp_work);
 
 	/* Connections between dsa_port and sja1105_port */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index b83f6e428e5d..794ee76aae56 100644
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
index 6ec9a32dda62..aac48b42f210 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -94,6 +94,124 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
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
@@ -151,7 +269,8 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	if (is_tagged)
 		skb = dsa_8021q_remove_header(skb);
 
-	return skb;
+	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
+					      is_meta);
 }
 
 static struct dsa_device_ops sja1105_netdev_ops = {
-- 
2.17.1

