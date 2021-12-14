Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CC2474D04
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbhLNVKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237835AbhLNVKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C72C06173E;
        Tue, 14 Dec 2021 13:10:40 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z7so6382365edc.11;
        Tue, 14 Dec 2021 13:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vJbJi1ThV7bAHbvegZ0HHH0c+JkZByFP3chmDOiUsak=;
        b=B9qqtezTK5GF1NkuWB+1a2i5IbubS+fi/mE6dqJ0wAUgBYEWF54x3l5oyZZ3L4dOQK
         POAlIDzk1saGbLgK8GYQpvBuiarPt5YRlClHmOgF9DDCEerJmEhaHpetdIG4PKWaZjUe
         70y81e+VBMPrcmjQeKcXgkus39vDK/iPqwBQR23Dsl5+6XP5h2eU/SvuR5FDHgen2rol
         ZPKq0AMQ9o8JEbTfg9F5sTw0H0P69MVulgHxpHbfCTx0KraR/39Yz9PVBBpQ4cf6hy5l
         wBkfDjBtjfGVoCtw7bewEq3KTGrzPzH9DpISBnDJFIcpLa1WMhPDwGtREAubNuJ087rd
         9w+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vJbJi1ThV7bAHbvegZ0HHH0c+JkZByFP3chmDOiUsak=;
        b=kNx0tsUjj581tNXsnVVHvl/VtExj9WqBN42g12YOM+Y/uqaX9PCcxcMvF085i7Glra
         +rbb6AQiUmvIrkMGkAtNXjAGXyzVEdqpV82dckNWR9W4/b28t8T4LuiTlBVRKFJxkVzp
         0r6DTsInIDTVtumjoTefsmo0yaGp1levo2RVjPmiY4WrpAuMNgCgmbxKV87bAKoxMrHR
         ovJNQF63WK/vj11yMl0hFy1cdhC0GTormVo3Nh6Wpik+PJACQ5X8JDLu9jVJBJHImp0T
         R7Tdt01RIhDXFVuLZZjAvSkan7IKFUHu1lyyaxDvLWYscbtlF73pWGI3JIw0ecDjUkk9
         iq9g==
X-Gm-Message-State: AOAM533qGpwl4/iL429iHfga4m8R5n5UHGD5rPO6id4zMV/08AcJaeVK
        t7KGegjxKDpCqq7udI6w5B4=
X-Google-Smtp-Source: ABdhPJy0Oj+CcHyhsTEqMuvoxnY7mu0ACJySlEhFlnperkBk9EU2FqUFRl/Nt5PZq50kf71YJBQGFw==
X-Received: by 2002:a17:906:314f:: with SMTP id e15mr8263747eje.658.1639516238540;
        Tue, 14 Dec 2021 13:10:38 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:38 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 12/16] net: dsa: qca8k: add support for mdio read/write in Ethernet packet
Date:   Tue, 14 Dec 2021 22:10:07 +0100
Message-Id: <20211214211011.24850-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add qca8k side support for mdio read/write in Ethernet packet.
qca8k supports some specially crafted Ethernet packet that can be used
for mdio read/write instead of the legacy method uart/internal mdio.
This add support for the qca8k side to craft the packet and enqueue it.
Each port and the qca8k_priv have a special struct to put data in it.
The completion API is used to wait for the packet to be received back
with the requested data.

The various steps are:
1. Craft the special packet with the qca hdr set to mdio read/write
   mode.
2. Set the lock in the dedicated mdio struct.
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

Locking is added to qca8k_master_change() to make sure no mdio Ethernet
are in progress.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 192 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  13 +++
 2 files changed, 205 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index f317f527dd6d..b35ba26a0696 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -20,6 +20,7 @@
 #include <linux/phylink.h>
 #include <linux/gpio/consumer.h>
 #include <linux/etherdevice.h>
+#include <linux/dsa/tag_qca.h>
 
 #include "qca8k.h"
 
@@ -170,6 +171,158 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 	return regmap_update_bits(priv->regmap, reg, mask, write_val);
 }
 
+static void qca8k_rw_reg_ack_handler(struct dsa_port *dp, struct sk_buff *skb)
+{
+	struct qca8k_mdio_hdr_data *mdio_hdr_data;
+	struct qca8k_priv *priv = dp->ds->priv;
+	struct mdio_ethhdr *mdio_ethhdr;
+	u8 len, cmd;
+
+	mdio_ethhdr = (struct mdio_ethhdr *)skb_mac_header(skb);
+	mdio_hdr_data = &priv->mdio_hdr_data;
+
+	cmd = FIELD_GET(QCA_HDR_MDIO_CMD, mdio_ethhdr->command);
+	len = FIELD_GET(QCA_HDR_MDIO_LENGTH, mdio_ethhdr->command);
+
+	/* Make sure the seq match the requested packet */
+	if (mdio_ethhdr->seq == mdio_hdr_data->seq)
+		mdio_hdr_data->ack = true;
+
+	if (cmd == MDIO_READ) {
+		mdio_hdr_data->data[0] = mdio_ethhdr->mdio_data;
+
+		/* Get the rest of the 12 byte of data */
+		if (len > QCA_HDR_MDIO_DATA1_LEN)
+			memcpy(mdio_hdr_data->data + 1, skb->data,
+			       QCA_HDR_MDIO_DATA2_LEN);
+	}
+
+	complete(&mdio_hdr_data->rw_done);
+}
+
+static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
+					       int seq_num, int priority)
+{
+	struct mdio_ethhdr *mdio_ethhdr;
+	struct sk_buff *skb;
+	u16 hdr;
+
+	skb = dev_alloc_skb(QCA_HDR_MDIO_PKG_LEN);
+
+	skb_reset_mac_header(skb);
+	skb_set_network_header(skb, skb->len);
+
+	mdio_ethhdr = skb_push(skb, QCA_HDR_MDIO_HEADER_LEN + QCA_HDR_LEN);
+
+	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_PRIORITY, priority);
+	hdr |= QCA_HDR_XMIT_FROM_CPU;
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
+
+	mdio_ethhdr->seq = FIELD_PREP(QCA_HDR_MDIO_SEQ_NUM, seq_num);
+
+	mdio_ethhdr->command = FIELD_PREP(QCA_HDR_MDIO_ADDR, reg);
+	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_LENGTH, 4);
+	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_CMD, cmd);
+	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_CHECK_CODE, MDIO_CHECK_CODE_VAL);
+
+	if (cmd == MDIO_WRITE)
+		mdio_ethhdr->mdio_data = *val;
+
+	mdio_ethhdr->hdr = htons(hdr);
+
+	skb_put_zero(skb, QCA_HDR_MDIO_DATA2_LEN);
+	skb_put_zero(skb, QCA_HDR_MDIO_PADDING_LEN);
+
+	return skb;
+}
+
+static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
+{
+	struct qca8k_mdio_hdr_data *mdio_hdr_data = &priv->mdio_hdr_data;
+	struct sk_buff *skb;
+	bool ack;
+	int ret;
+
+	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
+	skb->dev = (struct net_device *)priv->master;
+
+	mutex_lock(&mdio_hdr_data->mutex);
+
+	reinit_completion(&mdio_hdr_data->rw_done);
+	mdio_hdr_data->seq = 200;
+	mdio_hdr_data->ack = false;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&mdio_hdr_data->rw_done,
+					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
+
+	*val = mdio_hdr_data->data[0];
+	ack = mdio_hdr_data->ack;
+
+	mutex_unlock(&mdio_hdr_data->mutex);
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
+	struct qca8k_mdio_hdr_data *mdio_hdr_data = &priv->mdio_hdr_data;
+	struct sk_buff *skb;
+	bool ack;
+	int ret;
+
+	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
+	skb->dev = (struct net_device *)priv->master;
+
+	mutex_lock(&mdio_hdr_data->mutex);
+
+	reinit_completion(&mdio_hdr_data->rw_done);
+	mdio_hdr_data->ack = false;
+	mdio_hdr_data->seq = 200;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&mdio_hdr_data->rw_done,
+					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
+
+	ack = mdio_hdr_data->ack;
+
+	mutex_unlock(&mdio_hdr_data->mutex);
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
@@ -178,6 +331,9 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 	u16 r1, r2, page;
 	int ret;
 
+	if (priv->master && !qca8k_read_eth(priv, reg, val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -201,6 +357,9 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	u16 r1, r2, page;
 	int ret;
 
+	if (priv->master && !qca8k_write_eth(priv, reg, val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -225,6 +384,10 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	u32 val;
 	int ret;
 
+	if (priv->master &&
+	    !qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -2394,10 +2557,38 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 	if (dp->index != 0)
 		return;
 
+	mutex_lock(&priv->mdio_hdr_data.mutex);
+
 	if (operational)
 		priv->master = master;
 	else
 		priv->master = NULL;
+
+	mutex_unlock(&priv->mdio_hdr_data.mutex);
+}
+
+static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
+				      enum dsa_tag_protocol proto)
+{
+	struct qca8k_priv *qca8k_priv = ds->priv;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_QCA:
+		struct tag_qca_priv *priv;
+
+		priv = ds->tagger_data;
+
+		mutex_init(&qca8k_priv->mdio_hdr_data.mutex);
+		init_completion(&qca8k_priv->mdio_hdr_data.rw_done);
+
+		priv->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
 }
 
 static const struct dsa_switch_ops qca8k_switch_ops = {
@@ -2436,6 +2627,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_lag_join		= qca8k_port_lag_join,
 	.port_lag_leave		= qca8k_port_lag_leave,
 	.master_state_change	= qca8k_master_change,
+	.connect_tag_protocol	= qca8k_connect_tag_protocol,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 6edd6adc3063..dbe8c74c9793 100644
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
 
+struct qca8k_mdio_hdr_data {
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
 	const struct net_device *master; /* Track if mdio/mib Ethernet is available */
+	struct qca8k_mdio_hdr_data mdio_hdr_data;
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

