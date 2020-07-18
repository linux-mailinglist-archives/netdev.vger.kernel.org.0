Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE89224A5A
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 11:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgGRJgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 05:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgGRJgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 05:36:06 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E61C0619D2;
        Sat, 18 Jul 2020 02:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:Sender:
        Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n6M3uYaBBg3QJs5py08kUgJ96GD6TYoEDaL5MAkdxpM=; b=GYATEf+nD/m0g+elAyFMX9QgjZ
        VQ9wcfVZbrCgGaq1UkTUMxQ14H7yG+DKNj4dqlEhZ4sAtwh06KKcGCZJOskOUmNQryrC3aU4ipRQR
        lvNA2kFl/kJYCdQ1VHlj5HEvSoMkfldqeFmx5SJQFPa10HSbMY+GI+6Oj3hSIfdd8/nfLV4/4akfF
        2PFsmlV7lA8wq3GfzUW6kM72/bK4yVDlA160FOjnkUf3t6rAmMjeZy/SJYZqlen0o2NvKkuaGF7RN
        pXMfKrl5cbLyXS85W/P1TbG7zYA8SCscfxXjyPoEmEbkg5ZEoF4uYH4nE7D3xiEY7IzSnZShWwYpw
        YQriHf+g==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jwjG8-0003OJ-03; Sat, 18 Jul 2020 10:35:56 +0100
Date:   Sat, 18 Jul 2020 10:35:55 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: qca8k: implement the port MTU callbacks
Message-ID: <20200718093555.GA12912@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switch has a single max frame size configuration register, so we
track the requested MTU for each port and apply the largest.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/dsa/qca8k.c | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  3 +++
 2 files changed, 41 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 4acad5fa0c84..3690f02aea3a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -670,6 +670,12 @@ qca8k_setup(struct dsa_switch *ds)
 		}
 	}
 
+	/* Setup our port MTUs to match power on defaults */
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
+	}
+	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
+
 	/* Flush the FDB table */
 	qca8k_fdb_flush(priv);
 
@@ -1098,6 +1104,36 @@ qca8k_port_disable(struct dsa_switch *ds, int port)
 	priv->port_sts[port].enabled = 0;
 }
 
+static int
+qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int i, mtu;
+
+	if ((new_mtu < ETH_MIN_MTU) || (new_mtu > QCA8K_MAX_MTU)) {
+		return -EINVAL;
+	}
+
+	priv->port_mtu[port] = new_mtu;
+
+	mtu = 0;
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		if (priv->port_mtu[port] > mtu)
+			mtu = priv->port_mtu[port];
+	}
+
+	/* Include L2 header / FCS length */
+	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
+
+	return 0;
+}
+
+static int
+qca8k_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return QCA8K_MAX_MTU;
+}
+
 static int
 qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 		      u16 port_mask, u16 vid)
@@ -1174,6 +1210,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.set_mac_eee		= qca8k_set_mac_eee,
 	.port_enable		= qca8k_port_enable,
 	.port_disable		= qca8k_port_disable,
+	.port_change_mtu	= qca8k_port_change_mtu,
+	.port_max_mtu		= qca8k_port_max_mtu,
 	.port_stp_state_set	= qca8k_port_stp_state_set,
 	.port_bridge_join	= qca8k_port_bridge_join,
 	.port_bridge_leave	= qca8k_port_bridge_leave,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 10ef2bca2cde..31439396401c 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -13,6 +13,7 @@
 #include <linux/gpio.h>
 
 #define QCA8K_NUM_PORTS					7
+#define QCA8K_MAX_MTU					9000
 
 #define PHY_ID_QCA8337					0x004dd036
 #define QCA8K_ID_QCA8337				0x13
@@ -58,6 +59,7 @@
 #define   QCA8K_MDIO_MASTER_MAX_REG			32
 #define QCA8K_GOL_MAC_ADDR0				0x60
 #define QCA8K_GOL_MAC_ADDR1				0x64
+#define QCA8K_MAX_FRAME_SIZE				0x78
 #define QCA8K_REG_PORT_STATUS(_i)			(0x07c + (_i) * 4)
 #define   QCA8K_PORT_STATUS_SPEED			GENMASK(1, 0)
 #define   QCA8K_PORT_STATUS_SPEED_10			0
@@ -189,6 +191,7 @@ struct qca8k_priv {
 	struct device *dev;
 	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
+	unsigned int port_mtu[QCA8K_NUM_PORTS];
 };
 
 struct qca8k_mib_desc {
-- 
2.27.0

