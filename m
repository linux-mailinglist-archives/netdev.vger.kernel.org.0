Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F3C474E1F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbhLNWpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbhLNWog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:36 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D7FC061747;
        Tue, 14 Dec 2021 14:44:36 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t5so68003631edd.0;
        Tue, 14 Dec 2021 14:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S512LTgy5xGLeOLFRV+SrFz9c3b/WhxCle94KC/wZ9M=;
        b=HyW/OHJsxQ5yKVN9JD2uu9uVDtDJbp5C0DPkdTQNmfE3GomX9BqHQgq2kDiAOQWCUn
         tae4MZFbmoU6MKegVzbpxvlium/kvjCgP4Nz//3LNM08ljTmC42MrB9fgBaR9gALrciP
         GwFKl/V1arj1hJSusCgWkM1eoIdaM9JoE4HTpCM2WLvG17xUqWo3cspypDOCF7aOqZDm
         nZwfiJzi/SuyI4yiCTllzoEra9dhCbdoyguOglzIwBfQ5vku94AI67PHQRJVJTas1ISd
         erkU4dlN5gYiQ2bWuFrwfJx/Il33RcoR9edAxHcFs07VC1mViPaNitzzp2wQJT+lczrx
         /NcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S512LTgy5xGLeOLFRV+SrFz9c3b/WhxCle94KC/wZ9M=;
        b=CEwAbkWphhODffGdqIM/RC4fGPEEjJQ35cev2Ydmsy4ZbizE8i4+mytKSXB8RHXkQe
         kHCgXytuE/bK4eyTFpWdzYvePxT0FUyViK+FhwWYdy/J+6vTN5q2sKJg6QiVRWhp1vk7
         Z99rdOoWH4tFvANCBuAeZbArYDhNfeWua2HdBqe+ehFC3vCnq53aDINk3CLwqYbzvIrj
         UhDc+HBqzSS0pfmDKArVNhaVcyn+aVDcx7u+alwSNI7P3bzhyxmXDmg5mGWoTxYgTOn3
         g/b0KnKwayzSMPGTqT8goERDKV/e3EA8EoYrvDCCixKoAy+QSLtgd4kb2ky2VhkNZy3z
         ASCg==
X-Gm-Message-State: AOAM5305xHbktQiH8F9L1Y2mb5vF9o4B+3eEg57OtE+SlycHFrLXhyOF
        dxbIjiWKlFNdCQ7w+TfToLE=
X-Google-Smtp-Source: ABdhPJxVkfVuIzDzDBAJIfoFjlAkmKty9ooWUCchPb4tj0faiEqkdBUfiMzezneTcRnr/ostfnhpow==
X-Received: by 2002:aa7:cd9a:: with SMTP id x26mr11362174edv.159.1639521874438;
        Tue, 14 Dec 2021 14:44:34 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:34 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v6 14/16] net: dsa: qca8k: add support for phy read/write with mdio Ethernet
Date:   Tue, 14 Dec 2021 23:44:07 +0100
Message-Id: <20211214224409.5770-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
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
index 15f265c6ef02..b08db31933e0 100644
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

