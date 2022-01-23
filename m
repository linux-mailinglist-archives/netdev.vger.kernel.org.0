Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1DF496F77
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbiAWBeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbiAWBdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:55 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899BCC06174E;
        Sat, 22 Jan 2022 17:33:54 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id me13so11158719ejb.12;
        Sat, 22 Jan 2022 17:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ibOThFTH1OowTHawPEwM965WZFmhVW87OFPYcjfEZk=;
        b=csy2HAJTrnowVENntnhd/z5SPuXCEo/XmTqn+TFb87IBpCZA8PMcxO4jKDitn7CvJg
         Qy/gROISDkJxG4usvxrAwJKGseB1m6EEQ3oqY4Na/8slb4qQ9yfWSGQRNHNz7vH4IJ7o
         ZOf+j9iTcxBlP046q/KMYYsDHK03nXJAVfto3qyRW1QYfPgU3hxBDZ2G/Lf7WbZdn2gT
         NEFmC00E2Eix3v85xXTFtCz2+UwBvDweTxNCLaq6088WpD71Po99zDxcseRFAuBhZau9
         UcSeV8L4xlzo7cpliwpuwyDB/cZIc+6T/7pgMrXZQo7AjsH1YorAEmHEfhLh+3QqQauo
         UE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ibOThFTH1OowTHawPEwM965WZFmhVW87OFPYcjfEZk=;
        b=5v++oOmCmmtXc5BhY8ovSgyyExhXRJF0FuvpsxoWq0QkwzQoR/9ph3We1IdXmsTUbZ
         XA3YdulGSdM7R0EPHvd3QmMr7o7b4oIwOXpUFgKoSCFuBx6XMjv29S/njLzUmYZtN1XA
         QXkP1/iZUVUHt2JQFxS91auH0XwUR7lbOGMKDEFtAwfC4Z6ycioyEclqA45kq4ySDheZ
         Jx1YKhCSYJc2HrUKSCFfWx2kmzSfz1wpx6dWfIi5zwrW9s5cdPfnA+wz+idH2mptrztP
         jb3sR0JeNS+LhwTlmFXTqAMdQR9xaDi/Alfw/httkSLC5CfGvjpHN7L+H6iAVieBjaI0
         oHpA==
X-Gm-Message-State: AOAM530LKgIrV0GRivP53w4gcpmLwP+PvU3KEMPqBQdvI2P1FEWN6zR0
        L6FOMQYQ24Ems7ML8fKkbmU=
X-Google-Smtp-Source: ABdhPJxnk1B69CCZRfoK1ywreoU+Rospyl9e0De/sKrLnW/xRGL7Gg1eMnb0T1NC2Cu+/dCzZ81y/Q==
X-Received: by 2002:a17:907:6d01:: with SMTP id sa1mr8165150ejc.517.1642901633098;
        Sat, 22 Jan 2022 17:33:53 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:52 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 12/16] net: dsa: qca8k: add support for phy read/write with mgmt Ethernet
Date:   Sun, 23 Jan 2022 02:33:33 +0100
Message-Id: <20220123013337.20945-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use mgmt Ethernet also for phy read/write if availabale. Use a different
seq number to make sure we receive the correct packet.
On any error, we fallback to the legacy mdio read/write.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 191 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |   1 +
 2 files changed, 192 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index f51a6d8993ff..e7bc0770bae9 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -848,6 +848,166 @@ qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
 		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
 }
 
+static int
+qca8k_phy_eth_busy_wait(struct qca8k_mgmt_hdr_data *phy_hdr_data,
+			struct sk_buff *read_skb, u32 *val)
+{
+	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
+	bool ack;
+	int ret;
+
+	reinit_completion(&phy_hdr_data->rw_done);
+	phy_hdr_data->seq = 400;
+	phy_hdr_data->ack = false;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&phy_hdr_data->rw_done,
+					  QCA8K_ETHERNET_TIMEOUT);
+
+	ack = phy_hdr_data->ack;
+
+	if (ret <= 0)
+		return -ETIMEDOUT;
+
+	if (!ack)
+		return -EINVAL;
+
+	*val = phy_hdr_data->data[0];
+
+	return 0;
+}
+
+static int
+qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
+		      int regnum, u16 data)
+{
+	struct sk_buff *write_skb, *clear_skb, *read_skb;
+	struct qca8k_mgmt_hdr_data *phy_hdr_data;
+	const struct net_device *mgmt_master;
+	u32 write_val, clear_val = 0, val;
+	int seq_num = 400;
+	int ret, ret1;
+	bool ack;
+
+	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
+		return -EINVAL;
+
+	phy_hdr_data = &priv->mgmt_hdr_data;
+
+	write_val = QCA8K_MDIO_MASTER_BUSY | QCA8K_MDIO_MASTER_EN |
+		    QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
+		    QCA8K_MDIO_MASTER_REG_ADDR(regnum);
+
+	if (read) {
+		write_val |= QCA8K_MDIO_MASTER_READ;
+	} else {
+		write_val |= QCA8K_MDIO_MASTER_WRITE;
+		write_val |= QCA8K_MDIO_MASTER_DATA(data);
+	}
+
+	/* Prealloc all the needed skb before the lock */
+	write_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
+					    &write_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
+	if (!write_skb)
+		return -ENOMEM;
+
+	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
+					    &clear_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
+	if (!write_skb)
+		return -ENOMEM;
+
+	read_skb = qca8k_alloc_mdio_header(MDIO_READ, QCA8K_MDIO_MASTER_CTRL,
+					   &clear_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
+	if (!write_skb)
+		return -ENOMEM;
+
+	/* Actually start the request:
+	 * 1. Send mdio master packet
+	 * 2. Busy Wait for mdio master command
+	 * 3. Get the data if we are reading
+	 * 4. Reset the mdio master (even with error)
+	 */
+	mutex_lock(&phy_hdr_data->mutex);
+
+	/* Recheck mgmt_master under lock to make sure it's operational */
+	mgmt_master = priv->mgmt_master;
+	if (!mgmt_master)
+		return -EINVAL;
+
+	read_skb->dev = (struct net_device *)mgmt_master;
+	clear_skb->dev = (struct net_device *)mgmt_master;
+	write_skb->dev = (struct net_device *)mgmt_master;
+
+	reinit_completion(&phy_hdr_data->rw_done);
+	phy_hdr_data->ack = false;
+	phy_hdr_data->seq = seq_num;
+
+	dev_queue_xmit(write_skb);
+
+	ret = wait_for_completion_timeout(&phy_hdr_data->rw_done,
+					  QCA8K_ETHERNET_TIMEOUT);
+
+	ack = phy_hdr_data->ack;
+
+	if (ret <= 0) {
+		ret = -ETIMEDOUT;
+		goto exit;
+	}
+
+	if (!ack) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	ret = read_poll_timeout(qca8k_phy_eth_busy_wait, ret1,
+				!(val & QCA8K_MDIO_MASTER_BUSY), 0,
+				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
+				phy_hdr_data, read_skb, &val);
+
+	if (ret < 0 && ret1 < 0) {
+		ret = ret1;
+		goto exit;
+	}
+
+	if (read) {
+		reinit_completion(&phy_hdr_data->rw_done);
+		phy_hdr_data->ack = false;
+
+		dev_queue_xmit(read_skb);
+
+		ret = wait_for_completion_timeout(&phy_hdr_data->rw_done,
+						  QCA8K_ETHERNET_TIMEOUT);
+
+		ack = phy_hdr_data->ack;
+
+		if (ret <= 0) {
+			ret = -ETIMEDOUT;
+			goto exit;
+		}
+
+		if (!ack) {
+			ret = -EINVAL;
+			goto exit;
+		}
+
+		ret = phy_hdr_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
+	}
+
+exit:
+	reinit_completion(&phy_hdr_data->rw_done);
+	phy_hdr_data->ack = false;
+
+	dev_queue_xmit(clear_skb);
+
+	wait_for_completion_timeout(&phy_hdr_data->rw_done,
+				    QCA8K_ETHERNET_TIMEOUT);
+
+	mutex_unlock(&phy_hdr_data->mutex);
+
+	return ret;
+}
+
 static u32
 qca8k_port_to_phy(int port)
 {
@@ -970,6 +1130,14 @@ qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 da
 {
 	struct qca8k_priv *priv = slave_bus->priv;
 	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->mgmt_master) {
+		ret = qca8k_phy_eth_command(priv, false, phy, regnum, data);
+		if (!ret)
+			return 0;
+	}
 
 	return qca8k_mdio_write(bus, phy, regnum, data);
 }
@@ -979,6 +1147,14 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 {
 	struct qca8k_priv *priv = slave_bus->priv;
 	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->mgmt_master) {
+		ret = qca8k_phy_eth_command(priv, true, phy, regnum, 0);
+		if (ret >= 0)
+			return ret;
+	}
 
 	return qca8k_mdio_read(bus, phy, regnum);
 }
@@ -987,6 +1163,7 @@ static int
 qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 {
 	struct qca8k_priv *priv = ds->priv;
+	int ret;
 
 	/* Check if the legacy mapping should be used and the
 	 * port is not correctly mapped to the right PHY in the
@@ -995,6 +1172,13 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 	if (priv->legacy_phy_port_mapping)
 		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->mgmt_master) {
+		ret = qca8k_phy_eth_command(priv, true, port, regnum, 0);
+		if (!ret)
+			return ret;
+	}
+
 	return qca8k_mdio_write(priv->bus, port, regnum, data);
 }
 
@@ -1011,6 +1195,13 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
 	if (priv->legacy_phy_port_mapping)
 		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->mgmt_master) {
+		ret = qca8k_phy_eth_command(priv, true, port, regnum, 0);
+		if (ret >= 0)
+			return ret;
+	}
+
 	ret = qca8k_mdio_read(priv->bus, port, regnum);
 
 	if (ret < 0)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index dc1365542aa3..952217db2047 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -14,6 +14,7 @@
 #include <linux/dsa/tag_qca.h>
 
 #define QCA8K_ETHERNET_MDIO_PRIORITY			7
+#define QCA8K_ETHERNET_PHY_PRIORITY			6
 #define QCA8K_ETHERNET_TIMEOUT				100
 
 #define QCA8K_NUM_PORTS					7
-- 
2.33.1

