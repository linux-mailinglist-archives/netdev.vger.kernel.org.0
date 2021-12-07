Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108EA46BE8F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbhLGPDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238449AbhLGPDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:03:32 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02F8C061746;
        Tue,  7 Dec 2021 07:00:01 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g14so57486305edb.8;
        Tue, 07 Dec 2021 07:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sgF1GjgjLYfBNK2uREUijWD5sV4B6CTOh9jAIHXCnVE=;
        b=cWP8v6/tWmVHMLGk4PdpmUocp5aw3axZXiO311XkGxQulvBWsYVUdgV672HrEVBXhZ
         vBRHEXrn3qVJTsU+dyuMZS403G4ChnVOeRKloFROPBIitK9gBpHMslH/1vby3LELo4Qp
         lfwjT3ru64u0VaN8XfJGYpqYmj3kAZDzXqeT8ELG/9F5ipX8BqRLxf/G33i7Dj6blcYe
         Hh8EIPkfH0zxV/iDjcp8IcRGDcfGx/9sXjrYHJI+JzTte5Kz4aC87+mTgUzKD7i4wYBL
         wklxM648BDQWRs7yPIqBn/UPDpWDXXsC2nfdNbrvr/ATwBLsHC47fm4GWMYqkMBzDQ0I
         NrIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sgF1GjgjLYfBNK2uREUijWD5sV4B6CTOh9jAIHXCnVE=;
        b=fGvtuw7Mex8m1+6BHjiZQgryhqm66XRD1rcbrVdtPLCL+F9hZRHgvtdmz8mizOoCc9
         XF/OZR66EJ7zyyX6sGLX8AraXtFlsqPnb3QQj1+oG9H9kMa4jExXkBXeAql/Bcfu3FGR
         OJeQmARJBg8WMYm15iJMFYx5VjQiqQMzmoKJ3i5lxmgGbhkKnb5G/RDQZswm2vnJlQNw
         UT5Cjj+Pp3V27JVMWf1oFOHQcXiaQSKLEFTulaeiI1bBir/I8x+0dgYRO3XO78Ri+siT
         caYySrXcsKamaS/AlxXVbcWvMJjPwvbFwhzK8gBGFL6KG1wZTKoznQICIz1RM2REx0ia
         f7Gw==
X-Gm-Message-State: AOAM531ZqMN0QyG746zk3xPPmYCI6su2HOrxEE3rM8OuVHj3C3XnQ0bD
        9sTVNr31d6OLQZPNPcE6gVPmZijzIG8=
X-Google-Smtp-Source: ABdhPJzfnr0PXcHHjK6Lt8FE1f1TVILiDwxKvNOYYZOuASiPdRU6xMc1YFLQjaO1+YM9ejQKxKvV0w==
X-Received: by 2002:a17:906:d550:: with SMTP id cr16mr54181036ejc.544.1638889196715;
        Tue, 07 Dec 2021 06:59:56 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id i10sm9131821ejw.48.2021.12.07.06.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:59:56 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH 4/6] net: dsa: qca8k: Add support for mdio read/write in Ethernet packet
Date:   Tue,  7 Dec 2021 15:59:40 +0100
Message-Id: <20211207145942.7444-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207145942.7444-1-ansuelsmth@gmail.com>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
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

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c     | 156 +++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h     |   5 ++
 include/linux/dsa/tag_qca.h |  13 +++
 3 files changed, 172 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 96a7fbf8700c..d2c6139be9ac 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -20,6 +20,7 @@
 #include <linux/phylink.h>
 #include <linux/gpio/consumer.h>
 #include <linux/etherdevice.h>
+#include <linux/dsa/tag_qca.h>
 
 #include "qca8k.h"
 
@@ -170,6 +171,128 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 	return regmap_update_bits(priv->regmap, reg, mask, write_val);
 }
 
+static struct sk_buff *qca8k_alloc_mdio_header(struct qca8k_port_tag *header, enum mdio_cmd cmd,
+					       u32 reg, u32 *val)
+{
+	struct mdio_ethhdr *mdio_ethhdr;
+	struct sk_buff *skb;
+	u16 hdr;
+
+	skb = dev_alloc_skb(QCA_HDR_MDIO_PKG_LEN);
+
+	prefetchw(skb->data);
+
+	skb_reset_mac_header(skb);
+	skb_set_network_header(skb, skb->len);
+
+	mdio_ethhdr = skb_push(skb, QCA_HDR_MDIO_HEADER_LEN + QCA_HDR_LEN);
+
+	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
+	hdr |= QCA_HDR_XMIT_FROM_CPU;
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
+
+	mdio_ethhdr->seq = FIELD_PREP(QCA_HDR_MDIO_SEQ_NUM, 200);
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
+	struct qca8k_port_tag *header = priv->header_mdio;
+	struct sk_buff *skb;
+	bool ack;
+	int ret;
+
+	skb = qca8k_alloc_mdio_header(header, MDIO_READ, reg, 0);
+	skb->dev = dsa_to_port(priv->ds, 0)->master;
+
+	mutex_lock(&header->mdio_mutex);
+
+	reinit_completion(&header->rw_done);
+	header->seq = 200;
+	header->ack = false;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&header->rw_done, QCA8K_MDIO_RW_ETHERNET);
+
+	*val = header->data[0];
+	ack = header->ack;
+
+	mutex_unlock(&header->mdio_mutex);
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
+	struct qca8k_port_tag *header = priv->header_mdio;
+	struct sk_buff *skb;
+	bool ack;
+	int ret;
+
+	skb = qca8k_alloc_mdio_header(header, MDIO_WRITE, reg, &val);
+	skb->dev = dsa_to_port(priv->ds, 0)->master;
+
+	mutex_lock(&header->mdio_mutex);
+
+	dev_queue_xmit(skb);
+
+	reinit_completion(&header->rw_done);
+	header->ack = false;
+	header->seq = 200;
+
+	ret = wait_for_completion_timeout(&header->rw_done, QCA8K_MDIO_RW_ETHERNET);
+
+	ack = header->ack;
+
+	mutex_unlock(&header->mdio_mutex);
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
@@ -178,6 +301,10 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 	u16 r1, r2, page;
 	int ret;
 
+	if (priv->atheros_header_ready)
+		if (!qca8k_read_eth(priv, reg, val))
+			return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -201,6 +328,10 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	u16 r1, r2, page;
 	int ret;
 
+	if (priv->atheros_header_ready)
+		if (!qca8k_write_eth(priv, reg, val))
+			return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -225,6 +356,10 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	u32 val;
 	int ret;
 
+	if (priv->atheros_header_ready)
+		if (!qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
+			return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -1223,8 +1358,13 @@ qca8k_setup(struct dsa_switch *ds)
 	 * Configure specific switch configuration for ports
 	 */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		struct dsa_port *dp = dsa_to_port(ds, i);
+
+		/* Set the header_mdio to be accessible by the qca tagger */
+		dp->priv = priv->header_mdio;
+
 		/* CPU port gets connected to all user ports of the switch */
-		if (dsa_is_cpu_port(ds, i)) {
+		if (dsa_port_is_cpu(dp)) {
 			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 			if (ret)
@@ -1232,7 +1372,7 @@ qca8k_setup(struct dsa_switch *ds)
 		}
 
 		/* Individual user ports get connected to CPU port only */
-		if (dsa_is_user_port(ds, i)) {
+		if (dsa_port_is_user(dp)) {
 			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 					QCA8K_PORT_LOOKUP_MEMBER,
 					BIT(cpu_port));
@@ -1684,6 +1824,9 @@ qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
 	reg |= QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
 
 	qca8k_write(priv, QCA8K_REG_PORT_STATUS(port), reg);
+
+	if (dsa_is_cpu_port(ds, port))
+		priv->atheros_header_ready = true;
 }
 
 static void
@@ -2452,6 +2595,7 @@ static int qca8k_read_switch_id(struct qca8k_priv *priv)
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
+	struct qca8k_port_tag *header_mdio;
 	struct qca8k_priv *priv;
 	int ret;
 
@@ -2462,6 +2606,13 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (!priv)
 		return -ENOMEM;
 
+	header_mdio = devm_kzalloc(&mdiodev->dev, sizeof(*header_mdio), GFP_KERNEL);
+	if (!header_mdio)
+		return -ENOMEM;
+
+	mutex_init(&header_mdio->mdio_mutex);
+	init_completion(&header_mdio->rw_done);
+
 	priv->bus = mdiodev->bus;
 	priv->dev = &mdiodev->dev;
 
@@ -2501,6 +2652,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	priv->ds->priv = priv;
 	priv->ops = qca8k_switch_ops;
 	priv->ds->ops = &priv->ops;
+	priv->header_mdio = header_mdio;
 	mutex_init(&priv->reg_mutex);
 	dev_set_drvdata(&mdiodev->dev, priv);
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ab4a417b25a9..149bc4280856 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -11,6 +11,9 @@
 #include <linux/delay.h>
 #include <linux/regmap.h>
 #include <linux/gpio.h>
+#include <linux/dsa/tag_qca.h>
+
+#define QCA8K_MDIO_RW_ETHERNET				100
 
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_NUM_CPU_PORTS				2
@@ -342,6 +345,7 @@ struct qca8k_priv {
 	u8 mirror_rx;
 	u8 mirror_tx;
 	u8 lag_hash_mode;
+	bool atheros_header_ready;
 	bool legacy_phy_port_mapping;
 	struct qca8k_ports_config ports_config;
 	struct regmap *regmap;
@@ -353,6 +357,7 @@ struct qca8k_priv {
 	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
+	struct qca8k_port_tag *header_mdio;
 };
 
 struct qca8k_mib_desc {
diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 578a4aeafd92..a45a973865c3 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -59,4 +59,17 @@ struct mdio_ethhdr {
 	u16 hdr;		/* qca hdr */
 } __packed;
 
+enum mdio_cmd {
+	MDIO_WRITE = 0x0,
+	MDIO_READ
+};
+
+struct qca8k_port_tag {
+	struct completion rw_done;
+	struct mutex mdio_mutex; /* Enforce one mdio read/write at time */
+	bool ack;
+	u32 seq;
+	u32 data[4];
+};
+
 #endif /* __TAG_QCA_H */
-- 
2.32.0

