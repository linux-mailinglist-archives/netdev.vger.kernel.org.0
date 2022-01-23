Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B6D496F78
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiAWBeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbiAWBdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:53 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9507C061744;
        Sat, 22 Jan 2022 17:33:52 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id k25so11064970ejp.5;
        Sat, 22 Jan 2022 17:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZD7QyBub+AdOkmoqQa9t2qAl185yUI0pq6mcW4891Yo=;
        b=WcIoxRfiFXzQtFH48sK+4B/y8Fh6nwk/cAfbbEFZ4eOAjmytsZ5KRcb4+OUUf+unGA
         hYCBwZuWFNWqc13mz+C8UYGqxJxO4iljQA7n87OYODAFSr7SPW//0Buu0RkebLjbWBaR
         c9PQLUu8soxxHJomF2GzygZ7FYIqJbvbCy7ge2CKRZGTyqv/6UjXRW2XwctJP7bmS+jg
         YMHTm1mMFNXuaM0mLFgd4VKaUKxbJn2BuRKhsMz/CuPazzToOv1ON+OKOAVTST1KnZlf
         dWkpjO4A9F3nxT5r2YXoVM76WGVGuN2KlNiHtVfn6JQY3VPF+W7uc+gMgC8XCwj0prbz
         XQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZD7QyBub+AdOkmoqQa9t2qAl185yUI0pq6mcW4891Yo=;
        b=yhA5pATbWOnK/5TxbcWPe5PSWIUXHLisqa75m213ilYt4gUnqYVmtBHi/yYHL4V0Tx
         ZVHg/7OhvILvHcA7IuATgzbo4FZzREpVvAqm+tt0lGbUIm4FZpklF23si4JBRuTdMDQV
         NjdwXGwMDBC2E/EgHxriCt3gPLidpKpzstINZt/kyUUMNYpA5TS55Zil8ABRoN/HAGQ9
         KstWRq6ND7ZRM6oPiD+Q5Z4jjiqacskfahNymZVcIo1J4vtW/NhfHLWV+gMvag6vpOcQ
         kXPzFwJzPQgHPMm6ou6du544MPpmPmJ/C58GaZ24ADfawyLxCBFnhET5wK17/fRn+tTl
         zLVQ==
X-Gm-Message-State: AOAM533SG6gkhYeNJ08kWFAN5b72thWDHYdCiSXZyI2dOV4RpNrLDtBx
        1oHekqPTVddSEcIUC2mr9n8=
X-Google-Smtp-Source: ABdhPJxuYF87dX9NG5MlSSElgxpw2Lq6G1UztDFjTuuUyxQ0Y0W/1I7a+wAj2YWTXrUgXgKWlrX6AQ==
X-Received: by 2002:a17:907:1c12:: with SMTP id nc18mr882965ejc.47.1642901631211;
        Sat, 22 Jan 2022 17:33:51 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:50 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 10/16] net: dsa: qca8k: add support for mgmt read/write in Ethernet packet
Date:   Sun, 23 Jan 2022 02:33:31 +0100
Message-Id: <20220123013337.20945-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add qca8k side support for mgmt read/write in Ethernet packet.
qca8k supports some specially crafted Ethernet packet that can be used
for mgmt read/write instead of the legacy method uart/internal mdio.
This add support for the qca8k side to craft the packet and enqueue it.
Each port and the qca8k_priv have a special struct to put data in it.
The completion API is used to wait for the packet to be received back
with the requested data.

The various steps are:
1. Craft the special packet with the qca hdr set to mgmt read/write
   mode.
2. Set the lock in the dedicated mgmt struct.
3. Reinit the completion.
4. Enqueue the packet.
5. Wait the packet to be received.
6. Use the data set by the tagger to complete the mdio operation.

If the completion timeouts or the ack value is not true, the legacy
mdio way is used.

It has to be considered that in the initial setup mdio is still used and
mdio is still used until DSA is ready to accept and tag packet.

tag_proto_connect() is used to fill the required handler for the tagger
to correctly parse and elaborate the special Ethernet mdio packet.

Locking is added to qca8k_master_change() to make sure no mgmt Ethernet
are in progress.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 206 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  13 +++
 2 files changed, 219 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 4bc5064414b5..35711d010eb4 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -20,6 +20,7 @@
 #include <linux/phylink.h>
 #include <linux/gpio/consumer.h>
 #include <linux/etherdevice.h>
+#include <linux/dsa/tag_qca.h>
 
 #include "qca8k.h"
 
@@ -170,6 +171,174 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 	return regmap_update_bits(priv->regmap, reg, mask, write_val);
 }
 
+static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	struct qca8k_mgmt_hdr_data *mgmt_hdr_data;
+	struct qca8k_priv *priv = ds->priv;
+	struct mgmt_ethhdr *mgmt_ethhdr;
+	u8 len, cmd;
+
+	mgmt_ethhdr = (struct mgmt_ethhdr *)skb_mac_header(skb);
+	mgmt_hdr_data = &priv->mgmt_hdr_data;
+
+	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
+	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
+
+	/* Make sure the seq match the requested packet */
+	if (mgmt_ethhdr->seq == mgmt_hdr_data->seq)
+		mgmt_hdr_data->ack = true;
+
+	if (cmd == MDIO_READ) {
+		mgmt_hdr_data->data[0] = mgmt_ethhdr->mdio_data;
+
+		/* Get the rest of the 12 byte of data */
+		if (len > QCA_HDR_MGMT_DATA1_LEN)
+			memcpy(mgmt_hdr_data->data + 1, skb->data,
+			       QCA_HDR_MGMT_DATA2_LEN);
+	}
+
+	complete(&mgmt_hdr_data->rw_done);
+}
+
+static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
+					       int seq_num, int priority)
+{
+	struct mgmt_ethhdr *mgmt_ethhdr;
+	struct sk_buff *skb;
+	u16 hdr;
+
+	skb = dev_alloc_skb(QCA_HDR_MGMT_PKG_LEN);
+	if (!skb)
+		return NULL;
+
+	skb_reset_mac_header(skb);
+	skb_set_network_header(skb, skb->len);
+
+	mgmt_ethhdr = skb_push(skb, QCA_HDR_MGMT_HEADER_LEN + QCA_HDR_LEN);
+
+	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_PRIORITY, priority);
+	hdr |= QCA_HDR_XMIT_FROM_CPU;
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
+
+	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
+
+	mgmt_ethhdr->command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
+	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, 4);
+	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
+	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
+					   QCA_HDR_MGMT_CHECK_CODE_VAL);
+
+	if (cmd == MDIO_WRITE)
+		mgmt_ethhdr->mdio_data = *val;
+
+	mgmt_ethhdr->hdr = htons(hdr);
+
+	skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
+
+	return skb;
+}
+
+static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
+{
+	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
+	struct sk_buff *skb;
+	bool ack;
+	int ret;
+
+	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
+	if (!skb)
+		return -ENOMEM;
+
+	mutex_lock(&mgmt_hdr_data->mutex);
+
+	/* Recheck mgmt_master under lock to make sure it's operational */
+	if (!priv->mgmt_master)
+		return -EINVAL;
+
+	skb->dev = (struct net_device *)priv->mgmt_master;
+
+	reinit_completion(&mgmt_hdr_data->rw_done);
+	mgmt_hdr_data->seq = 200;
+	mgmt_hdr_data->ack = false;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&mgmt_hdr_data->rw_done,
+					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
+
+	*val = mgmt_hdr_data->data[0];
+	ack = mgmt_hdr_data->ack;
+
+	mutex_unlock(&mgmt_hdr_data->mutex);
+
+	if (ret <= 0)
+		return -ETIMEDOUT;
+
+	if (!ack)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 val)
+{
+	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
+	struct sk_buff *skb;
+	bool ack;
+	int ret;
+
+	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
+	if (!skb)
+		return -ENOMEM;
+
+	mutex_lock(&mgmt_hdr_data->mutex);
+
+	/* Recheck mgmt_master under lock to make sure it's operational */
+	if (!priv->mgmt_master)
+		return -EINVAL;
+
+	skb->dev = (struct net_device *)priv->mgmt_master;
+
+	reinit_completion(&mgmt_hdr_data->rw_done);
+	mgmt_hdr_data->ack = false;
+	mgmt_hdr_data->seq = 200;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&mgmt_hdr_data->rw_done,
+					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
+
+	ack = mgmt_hdr_data->ack;
+
+	mutex_unlock(&mgmt_hdr_data->mutex);
+
+	if (ret <= 0)
+		return -ETIMEDOUT;
+
+	if (!ack)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int
+qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
+{
+	u32 val = 0;
+	int ret;
+
+	ret = qca8k_read_eth(priv, reg, &val);
+	if (ret)
+		return ret;
+
+	val &= ~mask;
+	val |= write_val;
+
+	return qca8k_write_eth(priv, reg, val);
+}
+
 static int
 qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
@@ -178,6 +347,9 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 	u16 r1, r2, page;
 	int ret;
 
+	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -201,6 +373,9 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	u16 r1, r2, page;
 	int ret;
 
+	if (priv->mgmt_master && !qca8k_write_eth(priv, reg, val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -225,6 +400,10 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	u32 val;
 	int ret;
 
+	if (priv->mgmt_master &&
+	    !qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -2394,10 +2573,33 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 	if (dp->index != 0)
 		return;
 
+	mutex_lock(&priv->mgmt_hdr_data.mutex);
+
 	if (operational)
 		priv->mgmt_master = master;
 	else
 		priv->mgmt_master = NULL;
+
+	mutex_unlock(&priv->mgmt_hdr_data.mutex);
+}
+
+static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
+				      enum dsa_tag_protocol proto)
+{
+	struct qca_tagger_data *tagger_data;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_QCA:
+		tagger_data = ds->tagger_data;
+
+		tagger_data->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
 }
 
 static const struct dsa_switch_ops qca8k_switch_ops = {
@@ -2436,6 +2638,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_lag_join		= qca8k_port_lag_join,
 	.port_lag_leave		= qca8k_port_lag_leave,
 	.master_state_change	= qca8k_master_change,
+	.connect_tag_protocol	= qca8k_connect_tag_protocol,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
@@ -2515,6 +2718,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (!priv->ds)
 		return -ENOMEM;
 
+	mutex_init(&priv->mgmt_hdr_data.mutex);
+	init_completion(&priv->mgmt_hdr_data.rw_done);
+
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
 	priv->ds->priv = priv;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 9437369c60ca..a358a67044d3 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -11,6 +11,10 @@
 #include <linux/delay.h>
 #include <linux/regmap.h>
 #include <linux/gpio.h>
+#include <linux/dsa/tag_qca.h>
+
+#define QCA8K_ETHERNET_MDIO_PRIORITY			7
+#define QCA8K_ETHERNET_TIMEOUT				100
 
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_NUM_CPU_PORTS				2
@@ -328,6 +332,14 @@ enum {
 	QCA8K_CPU_PORT6,
 };
 
+struct qca8k_mgmt_hdr_data {
+	struct completion rw_done;
+	struct mutex mutex; /* Enforce one mdio read/write at time */
+	bool ack;
+	u32 seq;
+	u32 data[4];
+};
+
 struct qca8k_ports_config {
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
@@ -354,6 +366,7 @@ struct qca8k_priv {
 	struct gpio_desc *reset_gpio;
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
 	const struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
+	struct qca8k_mgmt_hdr_data mgmt_hdr_data;
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

