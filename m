Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BC3496F76
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbiAWBeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbiAWBdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:55 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C38C061749;
        Sat, 22 Jan 2022 17:33:53 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id n10so34096397edv.2;
        Sat, 22 Jan 2022 17:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rx+3wekJGsiHOwoI51rmOfYwMSDDxUNUhTfsZc80BKE=;
        b=j6T4ba43DyJd2iXWjWhLH0HFjawaa/oAfbw8s6wOMw+GR+9w+bUhtXxKfH0rFN2e7t
         w6R/fTMXpfJ9V1yORy86AoWhVY7nZE39bczkJhrk7NIX8NDFwH1/qhmbsd0ylGiprU0Z
         pI3PBM/HPmNmkA5t5e9XlxGj7mZIxbknIRpt1ixLQ713+mdfY31rgm3K9FY6ZmsxtMl3
         s3Me9I1IIa4D5nZVj4x7dyQJOM2utcnKa9OMJh1jtE0835D30vOYjScmHMEEVMwA4Bzq
         /HCglGIIoebS4YUZ9q/7WCefgX12rqqcz+Z6J/Rtw6sF5pZCgOAjjikcDwKJL7X9oID7
         GgmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rx+3wekJGsiHOwoI51rmOfYwMSDDxUNUhTfsZc80BKE=;
        b=tI++qBPuLnsKnpquJKg235QVSvE9rZYVpOJv4je2Klo/HGoeH+uhz2O80KZS7ySFTx
         nJcuT0PON2TwDEjzKWAAGqUFqc5vjzBvuhd7yIBeXFKvYkvljwa43cbJEAiz9k68hgtz
         xDNLGHzkVzq+WYBgtiGPEZ7MxvIfs3GwvVp+ueo0hSAbIM0RpsRwBKp29m1G3C84Kwvu
         5CGF4SfrdLhQfTigs1SSjjIkD9QyYHkHuasFCly7N2ycCTNTk7nkeSH2vcSuh2wzh0nS
         wOWXlinxQmGCteKgYALLNEJx7yPJ70KMllzs8xA9O29242abC90HK2snCF2FrxEqXsjz
         qwZA==
X-Gm-Message-State: AOAM530Qb0OgUWyV6HP9kUOn2CIdpj1h5FoDAwFbgPqctndgZSFhVsuG
        uMQm+Qs+5dNv/oqqCpShyRY=
X-Google-Smtp-Source: ABdhPJzoXU6qlLbvc+VJnh0bfp3yLbO9muRx7X1rHRN/CRKeT/7z3T5f79rs8LRER1aNxqqhwZJ+Nw==
X-Received: by 2002:a05:6402:2917:: with SMTP id ee23mr8464819edb.309.1642901632166;
        Sat, 22 Jan 2022 17:33:52 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:51 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 11/16] net: dsa: qca8k: add support for mib autocast in Ethernet packet
Date:   Sun, 23 Jan 2022 02:33:32 +0100
Message-Id: <20220123013337.20945-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch can autocast MIB counter using Ethernet packet.
Add support for this and provide a handler for the tagger.
The switch will send packet with MIB counter for each port, the switch
will use completion API to wait for the correct packet to be received
and will complete the task only when each packet is received.
Although the handler will drop all the other packet, we still have to
consume each MIB packet to complete the request. This is done to prevent
mixed data with concurrent ethtool request.

connect_tag_protocol() is used to add the handler to the tag_qca tagger,
master_state_change() use the MIB lock to make sure no MIB Ethernet is
in progress.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 108 +++++++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h |  17 ++++++-
 2 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 35711d010eb4..f51a6d8993ff 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -811,7 +811,10 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
+				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
+				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_FLUSH) |
+				 QCA8K_MIB_BUSY);
 	if (ret)
 		goto exit;
 
@@ -1882,6 +1885,97 @@ qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
 			ETH_GSTRING_LEN);
 }
 
+static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	const struct qca8k_match_data *match_data;
+	struct qca8k_mib_hdr_data *mib_hdr_data;
+	struct qca8k_priv *priv = ds->priv;
+	const struct qca8k_mib_desc *mib;
+	struct mib_ethhdr *mib_ethhdr;
+	int i, mib_len, offset = 0;
+	u64 *data;
+	u8 port;
+
+	mib_ethhdr = (struct mib_ethhdr *)skb_mac_header(skb);
+	mib_hdr_data = &priv->mib_hdr_data;
+
+	/* The switch autocast every port. Ignore other packet and
+	 * parse only the requested one.
+	 */
+	port = FIELD_GET(QCA_HDR_RECV_SOURCE_PORT, ntohs(mib_ethhdr->hdr));
+	if (port != mib_hdr_data->req_port)
+		goto exit;
+
+	match_data = device_get_match_data(priv->dev);
+	data = mib_hdr_data->data;
+
+	for (i = 0; i < match_data->mib_count; i++) {
+		mib = &ar8327_mib[i];
+
+		/* First 3 mib are present in the skb head */
+		if (i < 3) {
+			data[i] = mib_ethhdr->data[i];
+			continue;
+		}
+
+		mib_len = sizeof(uint32_t);
+
+		/* Some mib are 64 bit wide */
+		if (mib->size == 2)
+			mib_len = sizeof(uint64_t);
+
+		/* Copy the mib value from packet to the */
+		memcpy(data + i, skb->data + offset, mib_len);
+
+		/* Set the offset for the next mib */
+		offset += mib_len;
+	}
+
+exit:
+	/* Complete on receiving all the mib packet */
+	if (refcount_dec_and_test(&mib_hdr_data->port_parsed))
+		complete(&mib_hdr_data->rw_done);
+}
+
+static int
+qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct qca8k_mib_hdr_data *mib_hdr_data;
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	mib_hdr_data = &priv->mib_hdr_data;
+
+	mutex_lock(&mib_hdr_data->mutex);
+
+	reinit_completion(&mib_hdr_data->rw_done);
+
+	mib_hdr_data->req_port = dp->index;
+	mib_hdr_data->data = data;
+	refcount_set(&mib_hdr_data->port_parsed, QCA8K_NUM_PORTS);
+
+	mutex_lock(&priv->reg_mutex);
+
+	/* Send mib autocast request */
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
+				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
+				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_CAST) |
+				 QCA8K_MIB_BUSY);
+
+	mutex_unlock(&priv->reg_mutex);
+
+	if (ret)
+		goto exit;
+
+	ret = wait_for_completion_timeout(&mib_hdr_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
+
+exit:
+	mutex_unlock(&mib_hdr_data->mutex);
+
+	return ret;
+}
+
 static void
 qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 			uint64_t *data)
@@ -1893,6 +1987,10 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	u32 hi = 0;
 	int ret;
 
+	if (priv->mgmt_master &&
+	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
+		return;
+
 	match_data = of_device_get_match_data(priv->dev);
 
 	for (i = 0; i < match_data->mib_count; i++) {
@@ -2573,7 +2671,8 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 	if (dp->index != 0)
 		return;
 
-	mutex_lock(&priv->mgmt_hdr_data.mutex);
+	mutex_unlock(&priv->mgmt_hdr_data.mutex);
+	mutex_lock(&priv->mib_hdr_data.mutex);
 
 	if (operational)
 		priv->mgmt_master = master;
@@ -2581,6 +2680,7 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 		priv->mgmt_master = NULL;
 
 	mutex_unlock(&priv->mgmt_hdr_data.mutex);
+	mutex_unlock(&priv->mib_hdr_data.mutex);
 }
 
 static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
@@ -2593,6 +2693,7 @@ static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
 		tagger_data = ds->tagger_data;
 
 		tagger_data->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
+		tagger_data->mib_autocast_handler = qca8k_mib_autocast_handler;
 
 		break;
 	default:
@@ -2721,6 +2822,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	mutex_init(&priv->mgmt_hdr_data.mutex);
 	init_completion(&priv->mgmt_hdr_data.rw_done);
 
+	mutex_init(&priv->mib_hdr_data.mutex);
+	init_completion(&priv->mib_hdr_data.rw_done);
+
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
 	priv->ds->priv = priv;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index a358a67044d3..dc1365542aa3 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -67,7 +67,7 @@
 #define QCA8K_REG_MODULE_EN				0x030
 #define   QCA8K_MODULE_EN_MIB				BIT(0)
 #define QCA8K_REG_MIB					0x034
-#define   QCA8K_MIB_FLUSH				BIT(24)
+#define   QCA8K_MIB_FUNC				GENMASK(26, 24)
 #define   QCA8K_MIB_CPU_KEEP				BIT(20)
 #define   QCA8K_MIB_BUSY				BIT(17)
 #define QCA8K_MDIO_MASTER_CTRL				0x3c
@@ -317,6 +317,12 @@ enum qca8k_vlan_cmd {
 	QCA8K_VLAN_READ = 6,
 };
 
+enum qca8k_mid_cmd {
+	QCA8K_MIB_FLUSH = 1,
+	QCA8K_MIB_FLUSH_PORT = 2,
+	QCA8K_MIB_CAST = 3,
+};
+
 struct ar8xxx_port_status {
 	int enabled;
 };
@@ -340,6 +346,14 @@ struct qca8k_mgmt_hdr_data {
 	u32 data[4];
 };
 
+struct qca8k_mib_hdr_data {
+	struct completion rw_done;
+	struct mutex mutex; /* Process one command at time */
+	refcount_t port_parsed; /* Counter to track parsed port */
+	u8 req_port;
+	u64 *data; /* pointer to ethtool data */
+};
+
 struct qca8k_ports_config {
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
@@ -367,6 +381,7 @@ struct qca8k_priv {
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
 	const struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
 	struct qca8k_mgmt_hdr_data mgmt_hdr_data;
+	struct qca8k_mib_hdr_data mib_hdr_data;
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

