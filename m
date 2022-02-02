Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331C64A68F4
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243186AbiBBAEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243174AbiBBAE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:29 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5C1C061401;
        Tue,  1 Feb 2022 16:04:28 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id jx6so59819231ejb.0;
        Tue, 01 Feb 2022 16:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V7BGRkfJBtKAdhh65B65CRfb3wWKV/CszDGsa2iyoYI=;
        b=Iemqsp6emFNa//j7isMjnPBg4OOfCSh6gWhuQevIsEZE6rtYis5uekSIeRek6ulT/B
         bpQbmkIHy1BRQTsxMFifmdOTNL+MM8a38DFoMN8L+FwoJoWzZp3EKYkmy2e9xTe+fTvu
         81arKEbOd4Zolu3zCDnht3AtVqcN/SViapcXPIXqkIR3x5ccglqeyN47nh62sxddC2g6
         /KseezqLo9ezWd6cDzFzDnmhO0QW/1hURBVe9dR+A7q6r9IDpyHoVVfHw7bZP3jnbmoN
         tj2sXgBZaeUNvbtaHvzcHqptJ6+kKnbM59H+ag5ZHaBqHMYWTzBNfKbNEz289Q4uLB77
         mjWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V7BGRkfJBtKAdhh65B65CRfb3wWKV/CszDGsa2iyoYI=;
        b=N5zISTPyN8YeOR7skoTZfN4sMssbMT4PbEfXY147sFEdDQY+fqFlZSEbhD6NoDbM9r
         hC2yYc8innvgPAfsNnW0I8jfnjxCs3RKBwV5+iG36fySrMPqvB8Er5PWEN7ePhxXEfJg
         8YjIFQlmsSS/LxFL0NhWY2spuNxtOYh8akevypKnvX0FLWx6Hk00KhwWywbfvlgrkwi2
         cZxTPblZ5Y0nhmNxuALqVv4IbymI1u2ENmrSSCkqdkfjhYozexrtr9t6KWgjyfOTQAUF
         weq/aIBqAmPTh9ituaJdqWpYFGRaYFmaQhiUdUFOnxZjwDudaxu5fXqumG8WK2e8dFsw
         l8bA==
X-Gm-Message-State: AOAM531ISFNIBRXYwln/W8aBCbc5C2sChKMwlxORAPoHxQouQjuusyWy
        /073Z2M/k4TE1HPDxvQ6mvM=
X-Google-Smtp-Source: ABdhPJyMbiRhG8TCatUErKsh418uq+F3apd1FeMXgrAQy09PhK9vZdyppNTeT1Vz20sZEvUJ6N1rdA==
X-Received: by 2002:a17:907:7412:: with SMTP id gj18mr23641885ejc.381.1643760267359;
        Tue, 01 Feb 2022 16:04:27 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:27 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 11/16] net: dsa: qca8k: add support for mib autocast in Ethernet packet
Date:   Wed,  2 Feb 2022 01:03:30 +0100
Message-Id: <20220202000335.19296-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 106 +++++++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h |  17 ++++++-
 2 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index e3a215f04559..199cf4f761c0 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -830,7 +830,10 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
+				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
+				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_FLUSH) |
+				 QCA8K_MIB_BUSY);
 	if (ret)
 		goto exit;
 
@@ -1901,6 +1904,97 @@ qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
 			ETH_GSTRING_LEN);
 }
 
+static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	const struct qca8k_match_data *match_data;
+	struct qca8k_mib_eth_data *mib_eth_data;
+	struct qca8k_priv *priv = ds->priv;
+	const struct qca8k_mib_desc *mib;
+	struct mib_ethhdr *mib_ethhdr;
+	int i, mib_len, offset = 0;
+	u64 *data;
+	u8 port;
+
+	mib_ethhdr = (struct mib_ethhdr *)skb_mac_header(skb);
+	mib_eth_data = &priv->mib_eth_data;
+
+	/* The switch autocast every port. Ignore other packet and
+	 * parse only the requested one.
+	 */
+	port = FIELD_GET(QCA_HDR_RECV_SOURCE_PORT, ntohs(mib_ethhdr->hdr));
+	if (port != mib_eth_data->req_port)
+		goto exit;
+
+	match_data = device_get_match_data(priv->dev);
+	data = mib_eth_data->data;
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
+	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
+		complete(&mib_eth_data->rw_done);
+}
+
+static int
+qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct qca8k_mib_eth_data *mib_eth_data;
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	mib_eth_data = &priv->mib_eth_data;
+
+	mutex_lock(&mib_eth_data->mutex);
+
+	reinit_completion(&mib_eth_data->rw_done);
+
+	mib_eth_data->req_port = dp->index;
+	mib_eth_data->data = data;
+	refcount_set(&mib_eth_data->port_parsed, QCA8K_NUM_PORTS);
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
+	ret = wait_for_completion_timeout(&mib_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
+
+exit:
+	mutex_unlock(&mib_eth_data->mutex);
+
+	return ret;
+}
+
 static void
 qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 			uint64_t *data)
@@ -1912,6 +2006,10 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	u32 hi = 0;
 	int ret;
 
+	if (priv->mgmt_master &&
+	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
+		return;
+
 	match_data = of_device_get_match_data(priv->dev);
 
 	for (i = 0; i < match_data->mib_count; i++) {
@@ -2593,9 +2691,11 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 		return;
 
 	mutex_lock(&priv->mgmt_eth_data.mutex);
+	mutex_lock(&priv->mib_eth_data.mutex);
 
 	priv->mgmt_master = operational ? (struct net_device *)master : NULL;
 
+	mutex_unlock(&priv->mib_eth_data.mutex);
 	mutex_unlock(&priv->mgmt_eth_data.mutex);
 }
 
@@ -2609,6 +2709,7 @@ static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
 		tagger_data = ds->tagger_data;
 
 		tagger_data->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
+		tagger_data->mib_autocast_handler = qca8k_mib_autocast_handler;
 
 		break;
 	default:
@@ -2737,6 +2838,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	mutex_init(&priv->mgmt_eth_data.mutex);
 	init_completion(&priv->mgmt_eth_data.rw_done);
 
+	mutex_init(&priv->mib_eth_data.mutex);
+	init_completion(&priv->mib_eth_data.rw_done);
+
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
 	priv->ds->priv = priv;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 75c28689a652..2d7d084db089 100644
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
@@ -340,6 +346,14 @@ struct qca8k_mgmt_eth_data {
 	u32 data[4];
 };
 
+struct qca8k_mib_eth_data {
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
 	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
 	struct qca8k_mgmt_eth_data mgmt_eth_data;
+	struct qca8k_mib_eth_data mib_eth_data;
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

