Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1170F474D11
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbhLNVLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237849AbhLNVKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:42 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BAEC06173E;
        Tue, 14 Dec 2021 13:10:42 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z7so6382645edc.11;
        Tue, 14 Dec 2021 13:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eFxmuNVGBkJNCSH4HEgBOjoNb0GVzZB4YMokwUXUCBc=;
        b=IyZwbVsz3FSxeFm6gF6JaImqUvbF8ekyw0Zjq+ySJ30bGozhg5nT1FkP9wYNjtuB3I
         As1+s7S1UhU29kUouqT6pJKLuQfyUwrVZsWwaG7LxpZ4xPw+lsOpKzR3/eVw+CZ/8/rU
         aTJzNXcKCMdMbSQFMQ8ZfrPkMDx868dm3P8jbyBdfVk8WCSW7MzWCiZSRbsvDgOqDUYi
         rjDmVnk6SwiVJPILIg+DmOi1IMK6ugdXvvqXQNTnX8xsgm7QbEzJKFqXHk14lIz3Jkn2
         5C1dM9N8yL5SY4guUYKiCK94y1jR9kUEHAYs16hTLzm4rK2Fz36QQsCJ0CaOyEdgsVgj
         c3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eFxmuNVGBkJNCSH4HEgBOjoNb0GVzZB4YMokwUXUCBc=;
        b=MAGB/cjmF5cQMdpJWv3MvSndgWtacr+h2l6hQvIn/V13YB6Uybur7P6ZbvraE26lrc
         vOgEmCDB3I+93svWoprNRbgOLOQBn071xkjVMftkcOi9uSojF1TBeuG9Bzi9dqpeXny7
         DdrAex28mUjq1kynzC1ywT0nqcSLuQ3CcvxjIR7dZ8ocLJuZbGfLMybyLo3YQ08dalsK
         c+7MwV7cQr0J5Y4ZuciZtR4TuM1yOsLKabsrofzeYT5ZMURpCRmJLa7nRLlwLojNHlCG
         Mmkj/a/i62aAjqOT09L5j6BURol08nZntnYwUwDumPKVgZkGQhr9kWOqB81WsYZwjC4L
         z5DA==
X-Gm-Message-State: AOAM531/wF1UMeCSL9Kn/iTpUrQ2r3lD9SQwc9BPxZ+se4Y1ca6/UEdV
        w1fjvA3J3Z6VPltkYUFAMOyDIpzaIs+aoQ==
X-Google-Smtp-Source: ABdhPJz5BDmkP2e2XqJQi8PxBGR4+M4OMe3hMmc5amEB0a+rHeo85ACUtImJYTtn6OHY8r/Psnj2bg==
X-Received: by 2002:a17:906:19c8:: with SMTP id h8mr8303667ejd.725.1639516240542;
        Tue, 14 Dec 2021 13:10:40 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:40 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 14/16] net: dsa: qca8k: add support for phy read/write with mdio Ethernet
Date:   Tue, 14 Dec 2021 22:10:09 +0100
Message-Id: <20211214211011.24850-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use mdio Ethernet also for phy read/write if availabale. Use a different
seq number to make sure we receive the correct packet.
On any error, we fallback to the legacy mdio read/write.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 177 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |   1 +
 2 files changed, 178 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 429a1a2caede..a3de23d82809 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -832,6 +832,152 @@ qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
 		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
 }
 
+static int
+qca8k_mdio_eth_busy_wait(struct qca8k_mdio_hdr_data *phy_hdr_data,
+			 struct sk_buff *read_skb, u32 *val)
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
+qca8k_mdio_eth_command(struct qca8k_priv *priv, bool read, int phy,
+		       int regnum, u16 data)
+{
+	struct sk_buff *write_skb, *clear_skb, *read_skb;
+	const struct net_device *dev = priv->master;
+	struct qca8k_mdio_hdr_data *phy_hdr_data;
+	u32 write_val, clear_val = 0, val;
+	int seq_num = 400;
+	int ret, ret1;
+	bool ack;
+
+	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
+		return -EINVAL;
+
+	phy_hdr_data = &priv->mdio_hdr_data;
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
+	write_skb->dev = (struct net_device *)dev;
+	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
+					    &clear_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
+	clear_skb->dev = (struct net_device *)dev;
+	read_skb = qca8k_alloc_mdio_header(MDIO_READ, QCA8K_MDIO_MASTER_CTRL,
+					   &clear_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
+	read_skb->dev = (struct net_device *)dev;
+
+	/* Actually start the request:
+	 * 1. Send mdio master packet
+	 * 2. Busy Wait for mdio master command
+	 * 3. Get the data if we are reading
+	 * 4. Reset the mdio master (even with error)
+	 */
+	mutex_lock(&phy_hdr_data->mutex);
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
+	ret = read_poll_timeout(qca8k_mdio_eth_busy_wait, ret1,
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
@@ -954,6 +1100,14 @@ qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 da
 {
 	struct qca8k_priv *priv = slave_bus->priv;
 	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->master) {
+		ret = qca8k_mdio_eth_command(priv, false, phy, regnum, data);
+		if (!ret)
+			return 0;
+	}
 
 	return qca8k_mdio_write(bus, phy, regnum, data);
 }
@@ -963,6 +1117,14 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 {
 	struct qca8k_priv *priv = slave_bus->priv;
 	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->master) {
+		ret = qca8k_mdio_eth_command(priv, true, phy, regnum, 0);
+		if (ret >= 0)
+			return ret;
+	}
 
 	return qca8k_mdio_read(bus, phy, regnum);
 }
@@ -971,6 +1133,7 @@ static int
 qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 {
 	struct qca8k_priv *priv = ds->priv;
+	int ret;
 
 	/* Check if the legacy mapping should be used and the
 	 * port is not correctly mapped to the right PHY in the
@@ -979,6 +1142,13 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 	if (priv->legacy_phy_port_mapping)
 		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->master) {
+		ret = qca8k_mdio_eth_command(priv, true, port, regnum, 0);
+		if (!ret)
+			return ret;
+	}
+
 	return qca8k_mdio_write(priv->bus, port, regnum, data);
 }
 
@@ -995,6 +1165,13 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
 	if (priv->legacy_phy_port_mapping)
 		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->master) {
+		ret = qca8k_mdio_eth_command(priv, true, port, regnum, 0);
+		if (ret >= 0)
+			return ret;
+	}
+
 	ret = qca8k_mdio_read(priv->bus, port, regnum);
 
 	if (ret < 0)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 4aca07db0192..203220efa5c0 100644
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

