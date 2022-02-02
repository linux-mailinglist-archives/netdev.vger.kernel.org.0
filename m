Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1044A68F3
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243128AbiBBAEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243148AbiBBAE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:27 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179EFC06173B;
        Tue,  1 Feb 2022 16:04:27 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id w25so37115068edt.7;
        Tue, 01 Feb 2022 16:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Zju0Qjh7jitXlHsu4Hx1ODeu32wY6zBMHzs4Hw62Eo=;
        b=jr861tBbsoPe2ky8eTVGThc6KdqF4L/MhD8NMHFxyGo1Gj8YsYAvmFEfeWll+Akp48
         am1O/hPatE2doyy5iABEutQVwOXuGiXIxEarMHKkDf55diKjo7ykauwDvFV4YODe8Lt6
         9+SLZ0tdCeU8sL3eLQgFFbPOMzzMfnr9m4gzDzAQxgUdOjYXM9nZi5Fnwe2Vls5VxU4k
         cccmBm+jFljCHDnnVXfF+cbyO7sfJv+qURi5Esq2ELuyl94EEg0F7eRaB8J5OO3jN1Cz
         NEXjYvKFjGLTOlvwdAy27M67miySqHkKH4fAPBJoVrg3O9TZZctAVXy57aby1987RRRi
         WflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Zju0Qjh7jitXlHsu4Hx1ODeu32wY6zBMHzs4Hw62Eo=;
        b=kJZHGmcwnIRJCU2451kE0Nrm2nvraLp8Au+kLzz26GBLIdGvkAzOfQ/Z69xZdHSpmX
         sPIokS6ryCmj8ds9JaynHfzR7dtgvI67cF9aERc9VBwY3SAb4p9THDsjDmck1mcEdhwg
         iMztXOY2z2EADTjLjXXHgk/268XwO3MW2rgfAD/5wCg9BZ9RNh0PFNuLyENRPN2kkhPk
         3sREci48KsnLlxO+mvS71336cHF7ySwKkmF4gZlLVq4wsn0kgYVrCGGZYOTlXqJTYt8H
         zvt18lo5QfWloyQdvUO497bSt7fvpkpmqvGYsGp+Sgh6hV+dJwk1giEpwMturY6R1uHs
         Rghg==
X-Gm-Message-State: AOAM530wGdoVynjBjXlmvry3sBpiDah7G/0amUNRSrhv9OgHZZBpZill
        4M86l4wLxkyvhWphEkgodZ0=
X-Google-Smtp-Source: ABdhPJxpcOjPRHmqEDUjcrfYrApsw6+4EZV3gDQY0/dJ7rzazvLurJAOVQLbHz4t4WUwF6v+VcaPRw==
X-Received: by 2002:aa7:cdc5:: with SMTP id h5mr27811834edw.293.1643760265521;
        Tue, 01 Feb 2022 16:04:25 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:25 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 10/16] net: dsa: qca8k: add support for mgmt read/write in Ethernet packet
Date:   Wed,  2 Feb 2022 01:03:29 +0100
Message-Id: <20220202000335.19296-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
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
3. Increment the seq number and set it in the mgmt pkt
4. Reinit the completion.
5. Enqueue the packet.
6. Wait the packet to be received.
7. Use the data set by the tagger to complete the mdio operation.

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
 drivers/net/dsa/qca8k.c | 225 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  13 +++
 2 files changed, 238 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ec062b9a918d..e3a215f04559 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -20,6 +20,7 @@
 #include <linux/phylink.h>
 #include <linux/gpio/consumer.h>
 #include <linux/etherdevice.h>
+#include <linux/dsa/tag_qca.h>
 
 #include "qca8k.h"
 
@@ -170,6 +171,194 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 	return regmap_update_bits(priv->regmap, reg, mask, write_val);
 }
 
+static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	struct qca8k_mgmt_eth_data *mgmt_eth_data;
+	struct qca8k_priv *priv = ds->priv;
+	struct qca_mgmt_ethhdr *mgmt_ethhdr;
+	u8 len, cmd;
+
+	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
+	mgmt_eth_data = &priv->mgmt_eth_data;
+
+	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
+	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
+
+	/* Make sure the seq match the requested packet */
+	if (mgmt_ethhdr->seq == mgmt_eth_data->seq)
+		mgmt_eth_data->ack = true;
+
+	if (cmd == MDIO_READ) {
+		mgmt_eth_data->data[0] = mgmt_ethhdr->mdio_data;
+
+		/* Get the rest of the 12 byte of data */
+		if (len > QCA_HDR_MGMT_DATA1_LEN)
+			memcpy(mgmt_eth_data->data + 1, skb->data,
+			       QCA_HDR_MGMT_DATA2_LEN);
+	}
+
+	complete(&mgmt_eth_data->rw_done);
+}
+
+static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
+					       int priority)
+{
+	struct qca_mgmt_ethhdr *mgmt_ethhdr;
+	struct sk_buff *skb;
+	u16 hdr;
+
+	skb = dev_alloc_skb(QCA_HDR_MGMT_PKT_LEN);
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
+static void qca8k_mdio_header_fill_seq_num(struct sk_buff *skb, u32 seq_num)
+{
+	struct qca_mgmt_ethhdr *mgmt_ethhdr;
+
+	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb->data;
+	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
+}
+
+static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
+{
+	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
+	struct sk_buff *skb;
+	bool ack;
+	int ret;
+
+	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
+				      QCA8K_ETHERNET_MDIO_PRIORITY);
+	if (!skb)
+		return -ENOMEM;
+
+	mutex_lock(&mgmt_eth_data->mutex);
+
+	/* Check mgmt_master if is operational */
+	if (!priv->mgmt_master) {
+		kfree_skb(skb);
+		mutex_unlock(&mgmt_eth_data->mutex);
+		return -EINVAL;
+	}
+
+	skb->dev = priv->mgmt_master;
+
+	reinit_completion(&mgmt_eth_data->rw_done);
+
+	/* Increment seq_num and set it in the mdio pkt */
+	mgmt_eth_data->seq++;
+	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
+	mgmt_eth_data->ack = false;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
+					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
+
+	*val = mgmt_eth_data->data[0];
+	ack = mgmt_eth_data->ack;
+
+	mutex_unlock(&mgmt_eth_data->mutex);
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
+	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
+	struct sk_buff *skb;
+	bool ack;
+	int ret;
+
+	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val,
+				      QCA8K_ETHERNET_MDIO_PRIORITY);
+	if (!skb)
+		return -ENOMEM;
+
+	mutex_lock(&mgmt_eth_data->mutex);
+
+	/* Check mgmt_master if is operational */
+	if (!priv->mgmt_master) {
+		kfree_skb(skb);
+		mutex_unlock(&mgmt_eth_data->mutex);
+		return -EINVAL;
+	}
+
+	skb->dev = priv->mgmt_master;
+
+	reinit_completion(&mgmt_eth_data->rw_done);
+
+	/* Increment seq_num and set it in the mdio pkt */
+	mgmt_eth_data->seq++;
+	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
+	mgmt_eth_data->ack = false;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
+					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
+
+	ack = mgmt_eth_data->ack;
+
+	mutex_unlock(&mgmt_eth_data->mutex);
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
@@ -178,6 +367,9 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 	u16 r1, r2, page;
 	int ret;
 
+	if (!qca8k_read_eth(priv, reg, val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -201,6 +393,9 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	u16 r1, r2, page;
 	int ret;
 
+	if (!qca8k_write_eth(priv, reg, val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -225,6 +420,9 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	u32 val;
 	int ret;
 
+	if (!qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -2394,7 +2592,30 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 	if (dp->index != 0)
 		return;
 
+	mutex_lock(&priv->mgmt_eth_data.mutex);
+
 	priv->mgmt_master = operational ? (struct net_device *)master : NULL;
+
+	mutex_unlock(&priv->mgmt_eth_data.mutex);
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
@@ -2433,6 +2654,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_lag_join		= qca8k_port_lag_join,
 	.port_lag_leave		= qca8k_port_lag_leave,
 	.master_state_change	= qca8k_master_change,
+	.connect_tag_protocol	= qca8k_connect_tag_protocol,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
@@ -2512,6 +2734,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (!priv->ds)
 		return -ENOMEM;
 
+	mutex_init(&priv->mgmt_eth_data.mutex);
+	init_completion(&priv->mgmt_eth_data.rw_done);
+
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
 	priv->ds->priv = priv;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index b81aad98a116..75c28689a652 100644
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
 
+struct qca8k_mgmt_eth_data {
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
 	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
+	struct qca8k_mgmt_eth_data mgmt_eth_data;
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

