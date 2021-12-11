Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FCC4715F3
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhLKT6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbhLKT6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:30 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E89AC0617A1;
        Sat, 11 Dec 2021 11:58:29 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id l25so40423577eda.11;
        Sat, 11 Dec 2021 11:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aUH9zRckSoOkbw2tv4xR9ZLdUtn3mOCNC8Hdz+zJiUU=;
        b=NRzzwjGopwTDixJPQKapx5hBAnpRWbPfXD3p/rOyZqFo1BjcV8GHzZLMD52Oyiju5i
         DIKsOFNz6H7OpLrE040kxMSP0a3V5cGhnNZ6g8S0NUMMjFoAmfZuCgpmP1cj8Ufs70Cw
         k9Gj+JQLP8rMwifJR+/LDIclsXMUEJGNkyGtqHJx8w/u3eS3Ac0tS13kx1HE+uCKDeZL
         zUsxslD3KhsxbRvGqS0CnPPQFjR03cTiDmA08unNvxVaODClscFL2rdCOxBMlkAqsZgr
         ZfxYNoTqZBLldJVHPzRyMnVMLw/MC80hFjsjWscmaOVr58J3LtZiVhcifugPLfu+I3DS
         weTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aUH9zRckSoOkbw2tv4xR9ZLdUtn3mOCNC8Hdz+zJiUU=;
        b=AlMi9Ine1wTjEw4ZPPySoFhNfkJheh3Pqzq7/6K4Sj9dE35H6+O7W0XK6JgpS0ermF
         fw08xfMaDxXgMl8L+8MTuDW+cMD8GXkxfTGLyLdiXSu8S8XCo0/VE7i9OkVc+4KUXbod
         NI1H1kxVw/ACpMfi/gTZ1k4H/3Gn+8yIpWqLLYLA1up0SeQgc7voiZYHUoW2idTrTQZq
         IEzDXW4NV62lERl5zSxE9UDZIM8qXQigeDQnjDpK5FCeIZwKX5BJYYD4p1Grx4KGt99A
         pgg7mxkCu3EzeIewcWjixC4d0HghFv2yF1QpqW203IdkXTvMzM7dmDQjkY2ug+StiGsK
         IF/Q==
X-Gm-Message-State: AOAM533MFXh7SdWLV91gg+oIFOS4ndbWzrOCWtl+ogUTsokzSYSxZlYH
        MpdHLoqWgRtJOd2m2IElhxY=
X-Google-Smtp-Source: ABdhPJyqGxwG9xOwnzgMO7A82pSaY/SmD64GS2TLV38dGFba+5cBhXoOUen17lk3TJYvm+Io/2l4aQ==
X-Received: by 2002:a05:6402:34f:: with SMTP id r15mr48844165edw.80.1639252707966;
        Sat, 11 Dec 2021 11:58:27 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:27 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 14/15] net: dsa: qca8k: add support for phy read/write with mdio Ethernet
Date:   Sat, 11 Dec 2021 20:57:57 +0100
Message-Id: <20211211195758.28962-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 150 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 624df3b0fd9f..375a1d34e46f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -831,6 +831,125 @@ qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
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
+	struct net_device *dev = dsa_to_port(priv->ds, 0)->master;
+	struct sk_buff *write_skb, *clear_skb, *read_skb;
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
+					    &write_val, seq_num);
+	write_skb->dev = dev;
+	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
+					    &clear_val, seq_num);
+	clear_skb->dev = dev;
+	read_skb = qca8k_alloc_mdio_header(MDIO_READ, QCA8K_MDIO_MASTER_CTRL,
+					   &clear_val, seq_num);
+	read_skb->dev = dev;
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
+	if (ret < 0 && ret1 < 0)
+		ret = ret1;
+
+	if (read)
+		ret = phy_hdr_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
+
+exit:
+	dev_queue_xmit(clear_skb);
+
+	mutex_unlock(&phy_hdr_data->mutex);
+
+	kfree_skb(read_skb);
+
+	return ret;
+}
+
 static u32
 qca8k_port_to_phy(int port)
 {
@@ -953,6 +1072,14 @@ qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 da
 {
 	struct qca8k_priv *priv = slave_bus->priv;
 	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->master_oper) {
+		ret = qca8k_mdio_eth_command(priv, false, phy, regnum, data);
+		if (!ret)
+			return 0;
+	}
 
 	return qca8k_mdio_write(bus, phy, regnum, data);
 }
@@ -962,6 +1089,14 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 {
 	struct qca8k_priv *priv = slave_bus->priv;
 	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->master_oper) {
+		ret = qca8k_mdio_eth_command(priv, true, phy, regnum, 0);
+		if (ret >= 0)
+			return ret;
+	}
 
 	return qca8k_mdio_read(bus, phy, regnum);
 }
@@ -970,6 +1105,7 @@ static int
 qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 {
 	struct qca8k_priv *priv = ds->priv;
+	int ret;
 
 	/* Check if the legacy mapping should be used and the
 	 * port is not correctly mapped to the right PHY in the
@@ -978,6 +1114,13 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 	if (priv->legacy_phy_port_mapping)
 		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->master_oper) {
+		ret = qca8k_mdio_eth_command(priv, true, port, regnum, 0);
+		if (!ret)
+			return ret;
+	}
+
 	return qca8k_mdio_write(priv->bus, port, regnum, data);
 }
 
@@ -994,6 +1137,13 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
 	if (priv->legacy_phy_port_mapping)
 		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
+	/* Use mdio Ethernet when available, fallback to legacy one on error */
+	if (priv->master_oper) {
+		ret = qca8k_mdio_eth_command(priv, true, port, regnum, 0);
+		if (ret >= 0)
+			return ret;
+	}
+
 	ret = qca8k_mdio_read(priv->bus, port, regnum);
 
 	if (ret < 0)
-- 
2.32.0

