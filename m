Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD434A68FA
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243221AbiBBAEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243175AbiBBAEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:31 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7B9C061714;
        Tue,  1 Feb 2022 16:04:30 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id j2so58642647ejk.6;
        Tue, 01 Feb 2022 16:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IZQKNxhvaSbHhD6tI1orgzLCmFBHOnHLtHOZFRqFIlE=;
        b=OLwpt5kkAhonyM6o0NWpTwCa8Zr3QQjfr/K+O8x51pebBPG7sKPYVeaWgWO7Z5ia96
         ptNIfPiS55YLjBvDKIJ/eaYqIidWnUttru0Mu1qR9HkV1V8ymDAx51ThPwGaVfSfdk3G
         6eAD5DgWvryGjCJPoggd63+jbtGWJL+RSiuDTVG+kOksTopNDfeWmgpghaUpMzQYFzML
         Y7zr3cquBRms4asSCMJ73MBxz2XJWFu9NB/zqvjHTCIzI7cL94LHnNRO/I2ZyP3DpSYu
         v2rG9U66sw1j2DWNukhOiux71D8o9P8yIbhDnZpEsaZ/dHjnVmNiHiG3Y7nelFZPjJAF
         Z/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IZQKNxhvaSbHhD6tI1orgzLCmFBHOnHLtHOZFRqFIlE=;
        b=xrUQdCTwpoSHwpvDRi2/KeIs6GsjjVGEIot0g6n2vFIdAK3ImjtMt7J69Xp18FFp7G
         vMg+AxMNmpMByKCWrR7vk1UnVGUE0XTxBq7Knj3QSSzLhoyDh5NzGmGXaxuSxFH6MaZe
         r8MTEWCJWFraAaLLz9uXoE6cPX6Zf6b2rUH8Hou5VZ2KVoZ7+IGu0lYQqzvz/9or0xtW
         T6ImYCLFBR1046jB7qO0GsZNsu3rXwXH7SzAjpHodUjNURCidq4BzJ0M6bF15uDbLY3F
         fmzF7apNY5YDIvRT70BpoYiO5BTPP5voQMqDy9nXgJAT6ntFe76tacPL6ZbDGQl2pBai
         8L2g==
X-Gm-Message-State: AOAM530MqtPlmb4r6nJ9vo+16aGX2tfhgIw7hSy1st1ex7UdbS4ntNUF
        AQplt0/5kGAxsCSRXdBQ4mg=
X-Google-Smtp-Source: ABdhPJyhrENXfATOrmAHlQjIe6QecAYUYd+i3GQunyMW2afrrsQJZejvzku2UeCfQxN8z3L0Hjn8pQ==
X-Received: by 2002:a17:907:7d8e:: with SMTP id oz14mr14841915ejc.764.1643760269199;
        Tue, 01 Feb 2022 16:04:29 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:28 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 12/16] net: dsa: qca8k: add support for phy read/write with mgmt Ethernet
Date:   Wed,  2 Feb 2022 01:03:31 +0100
Message-Id: <20220202000335.19296-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 216 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |   1 +
 2 files changed, 217 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 199cf4f761c0..0ce5b7ca0b7f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -867,6 +867,199 @@ qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
 		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
 }
 
+static int
+qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
+			struct sk_buff *read_skb, u32 *val)
+{
+	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
+	bool ack;
+	int ret;
+
+	reinit_completion(&mgmt_eth_data->rw_done);
+
+	/* Increment seq_num and set it in the copy pkt */
+	mgmt_eth_data->seq++;
+	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
+	mgmt_eth_data->ack = false;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
+					  QCA8K_ETHERNET_TIMEOUT);
+
+	ack = mgmt_eth_data->ack;
+
+	if (ret <= 0)
+		return -ETIMEDOUT;
+
+	if (!ack)
+		return -EINVAL;
+
+	*val = mgmt_eth_data->data[0];
+
+	return 0;
+}
+
+static int
+qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
+		      int regnum, u16 data)
+{
+	struct sk_buff *write_skb, *clear_skb, *read_skb;
+	struct qca8k_mgmt_eth_data *mgmt_eth_data;
+	u32 write_val, clear_val = 0, val;
+	struct net_device *mgmt_master;
+	int ret, ret1;
+	bool ack;
+
+	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
+		return -EINVAL;
+
+	mgmt_eth_data = &priv->mgmt_eth_data;
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
+					    &write_val, QCA8K_ETHERNET_PHY_PRIORITY);
+	if (!write_skb)
+		return -ENOMEM;
+
+	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
+					    &clear_val, QCA8K_ETHERNET_PHY_PRIORITY);
+	if (!write_skb) {
+		ret = -ENOMEM;
+		goto err_clear_skb;
+	}
+
+	read_skb = qca8k_alloc_mdio_header(MDIO_READ, QCA8K_MDIO_MASTER_CTRL,
+					   &clear_val, QCA8K_ETHERNET_PHY_PRIORITY);
+	if (!write_skb) {
+		ret = -ENOMEM;
+		goto err_read_skb;
+	}
+
+	/* Actually start the request:
+	 * 1. Send mdio master packet
+	 * 2. Busy Wait for mdio master command
+	 * 3. Get the data if we are reading
+	 * 4. Reset the mdio master (even with error)
+	 */
+	mutex_lock(&mgmt_eth_data->mutex);
+
+	/* Check if mgmt_master is operational */
+	mgmt_master = priv->mgmt_master;
+	if (!mgmt_master) {
+		mutex_unlock(&mgmt_eth_data->mutex);
+		ret = -EINVAL;
+		goto err_mgmt_master;
+	}
+
+	read_skb->dev = mgmt_master;
+	clear_skb->dev = mgmt_master;
+	write_skb->dev = mgmt_master;
+
+	reinit_completion(&mgmt_eth_data->rw_done);
+
+	/* Increment seq_num and set it in the write pkt */
+	mgmt_eth_data->seq++;
+	qca8k_mdio_header_fill_seq_num(write_skb, mgmt_eth_data->seq);
+	mgmt_eth_data->ack = false;
+
+	dev_queue_xmit(write_skb);
+
+	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
+					  QCA8K_ETHERNET_TIMEOUT);
+
+	ack = mgmt_eth_data->ack;
+
+	if (ret <= 0) {
+		ret = -ETIMEDOUT;
+		kfree_skb(read_skb);
+		goto exit;
+	}
+
+	if (!ack) {
+		ret = -EINVAL;
+		kfree_skb(read_skb);
+		goto exit;
+	}
+
+	ret = read_poll_timeout(qca8k_phy_eth_busy_wait, ret1,
+				!(val & QCA8K_MDIO_MASTER_BUSY), 0,
+				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
+				mgmt_eth_data, read_skb, &val);
+
+	if (ret < 0 && ret1 < 0) {
+		ret = ret1;
+		goto exit;
+	}
+
+	if (read) {
+		reinit_completion(&mgmt_eth_data->rw_done);
+
+		/* Increment seq_num and set it in the read pkt */
+		mgmt_eth_data->seq++;
+		qca8k_mdio_header_fill_seq_num(read_skb, mgmt_eth_data->seq);
+		mgmt_eth_data->ack = false;
+
+		dev_queue_xmit(read_skb);
+
+		ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
+						  QCA8K_ETHERNET_TIMEOUT);
+
+		ack = mgmt_eth_data->ack;
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
+		ret = mgmt_eth_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
+	} else {
+		kfree_skb(read_skb);
+	}
+exit:
+	reinit_completion(&mgmt_eth_data->rw_done);
+
+	/* Increment seq_num and set it in the clear pkt */
+	mgmt_eth_data->seq++;
+	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
+	mgmt_eth_data->ack = false;
+
+	dev_queue_xmit(clear_skb);
+
+	wait_for_completion_timeout(&mgmt_eth_data->rw_done,
+				    QCA8K_ETHERNET_TIMEOUT);
+
+	mutex_unlock(&mgmt_eth_data->mutex);
+
+	return ret;
+
+	/* Error handling before lock */
+err_mgmt_master:
+	kfree_skb(read_skb);
+err_read_skb:
+	kfree_skb(clear_skb);
+err_clear_skb:
+	kfree_skb(write_skb);
+
+	return ret;
+}
+
 static u32
 qca8k_port_to_phy(int port)
 {
@@ -989,6 +1182,12 @@ qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 da
 {
 	struct qca8k_priv *priv = slave_bus->priv;
 	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	ret = qca8k_phy_eth_command(priv, false, phy, regnum, data);
+	if (!ret)
+		return 0;
 
 	return qca8k_mdio_write(bus, phy, regnum, data);
 }
@@ -998,6 +1197,12 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 {
 	struct qca8k_priv *priv = slave_bus->priv;
 	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	ret = qca8k_phy_eth_command(priv, true, phy, regnum, 0);
+	if (ret >= 0)
+		return ret;
 
 	return qca8k_mdio_read(bus, phy, regnum);
 }
@@ -1006,6 +1211,7 @@ static int
 qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 {
 	struct qca8k_priv *priv = ds->priv;
+	int ret;
 
 	/* Check if the legacy mapping should be used and the
 	 * port is not correctly mapped to the right PHY in the
@@ -1014,6 +1220,11 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 	if (priv->legacy_phy_port_mapping)
 		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	ret = qca8k_phy_eth_command(priv, false, port, regnum, 0);
+	if (!ret)
+		return ret;
+
 	return qca8k_mdio_write(priv->bus, port, regnum, data);
 }
 
@@ -1030,6 +1241,11 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
 	if (priv->legacy_phy_port_mapping)
 		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	ret = qca8k_phy_eth_command(priv, true, port, regnum, 0);
+	if (ret >= 0)
+		return ret;
+
 	ret = qca8k_mdio_read(priv->bus, port, regnum);
 
 	if (ret < 0)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 2d7d084db089..c6f6abd2108e 100644
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

