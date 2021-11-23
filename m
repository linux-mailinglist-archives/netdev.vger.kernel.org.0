Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF159459A4F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 03:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhKWDCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 22:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbhKWDCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 22:02:39 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF57C06173E;
        Mon, 22 Nov 2021 18:59:31 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id y13so85459569edd.13;
        Mon, 22 Nov 2021 18:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GBrjM/aS1kbDz4WE/LvJrPxGRtVY4r4diSjFzfBIUK0=;
        b=MgjryQxFMyZLz9gokRImTvMhe6KRcpmf8s4XZ5llzQF5pAJo8WI9dcTEiLCfmrk0Kz
         IbiEzu7htTx6IH9cMDrvLDRcMgaZen2/gDLeikiHYZB65LF/+c2ut+04uhAlz+C3KFTM
         FY+y44R/vEwy4Nfe2rNqYcsiEvKK68R+QGvtbdOwlU5O+3hNKO9IcvJ6bpgxAwJkm5gy
         u0EslCXYLpZimpxqFERv0QIEZ6qdujPtMrkKN6PcT9u5lX8vt0Eu7MN7ICsnHFz51nFI
         DSL1H+miNPfomDqbBdZZGNUYEeFYvjGPg5/i3E7Qs6pZLN7O3nKewjZG1ZYcZUNiXMeW
         +nWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GBrjM/aS1kbDz4WE/LvJrPxGRtVY4r4diSjFzfBIUK0=;
        b=SGwGJym0KGlXTsxfgBqP3IozKNUypLr0kmstCF2bTv2G9j2mJr1nihCHxTqJQKJohf
         wAP6p3kAcfSoqNKSTvXwA+fn9qcC+9q+hAjBB9gSVc0upDcC1vD6Gs87oPsrHv5DBSGz
         lIetHigZ2ksQX6HcyUFLOUbQUD83EwL537InJ8QF5B1hPOpF0QvVugeB5VDdrTwsud50
         FHCRKRnTjlFVcaLgaTXZEbPfuRYEXK2FOAT0x/m9m8uNNKJJqucYKDuuJT5zVPsPyI+e
         VzEqcU9KUzgnOWxpl7ZYOqTks03FPPx3GLCt52i+6P2TNFVtTGMSavMYSLBh8HbKz8so
         Hhjw==
X-Gm-Message-State: AOAM533lo7B+nz/o2fi0fPst/bsXYitQ3B0OflOsSJIZ+7zESZA/Wv6/
        qzU6zUeZL56+Nlqn17dMMRY=
X-Google-Smtp-Source: ABdhPJx+Ljpy1Ig9e6FOUnnXFl1bfB/VMDgJuQEkH6eMywJ4ib9DY3yLG5elUDlKoEdddGAyfWSdaQ==
X-Received: by 2002:a50:ff10:: with SMTP id a16mr3305644edu.275.1637636369790;
        Mon, 22 Nov 2021 18:59:29 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id dy4sm4870718edb.92.2021.11.22.18.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 18:59:29 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 2/2] net: dsa: qca8k: add LAG support
Date:   Tue, 23 Nov 2021 03:59:11 +0100
Message-Id: <20211123025911.20987-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123025911.20987-1-ansuelsmth@gmail.com>
References: <20211123025911.20987-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LAG support to this switch. In Documentation this is described as
trunk mode. A max of 4 LAGs are supported and each can support up to 4
port. The current tx mode supported is Hash mode with both L2 and L2+3
mode.
When no port are present in the trunk, the trunk is disabled in the
switch.
When a port is disconnected, the traffic is redirected to the other
available port.
The hash mode is global and each LAG require to have the same hash mode
set. To change the hash mode when multiple LAG are configured, it's
required to remove each LAG and set the desired hash mode to the last.
An error is printed when it's asked to set a not supported hadh mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 177 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  33 ++++++++
 2 files changed, 210 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bd9d756f4001..6516df08a5d5 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1336,6 +1336,9 @@ qca8k_setup(struct dsa_switch *ds)
 	ds->ageing_time_min = 7000;
 	ds->ageing_time_max = 458745000;
 
+	/* Set max number of LAGs supported */
+	ds->num_lag_ids = QCA8K_NUM_LAGS;
+
 	return 0;
 }
 
@@ -2203,6 +2206,178 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 	return DSA_TAG_PROTO_QCA;
 }
 
+static bool
+qca8k_lag_can_offload(struct dsa_switch *ds,
+		      struct net_device *lag,
+		      struct netdev_lag_upper_info *info)
+{
+	struct dsa_port *dp;
+	int id, members = 0;
+
+	id = dsa_lag_id(ds->dst, lag);
+	if (id < 0 || id >= ds->num_lag_ids)
+		return false;
+
+	dsa_lag_foreach_port(dp, ds->dst, lag)
+		/* Includes the port joining the LAG */
+		members++;
+
+	if (members > QCA8K_NUM_PORTS_FOR_LAG)
+		return false;
+
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return false;
+
+	if (info->hash_type != NETDEV_LAG_HASH_L2 ||
+	    info->hash_type != NETDEV_LAG_HASH_L23)
+		return false;
+
+	return true;
+}
+
+static int
+qca8k_lag_setup_hash(struct dsa_switch *ds,
+		     struct net_device *lag,
+		     struct netdev_lag_upper_info *info)
+{
+	struct qca8k_priv *priv = ds->priv;
+	bool unique_lag = true;
+	int i, id;
+	u32 hash;
+
+	id = dsa_lag_id(ds->dst, lag);
+
+	switch (info->hash_type) {
+	case NETDEV_LAG_HASH_L23:
+		hash |= QCA8K_TRUNK_HASH_SIP_EN;
+		hash |= QCA8K_TRUNK_HASH_DIP_EN;
+		fallthrough;
+	case NETDEV_LAG_HASH_L2:
+		hash |= QCA8K_TRUNK_HASH_SA_EN;
+		hash |= QCA8K_TRUNK_HASH_DA_EN;
+		break;
+	default: /* We should NEVER reach this */
+		return -EOPNOTSUPP;
+	}
+
+	/* Check if we are the unique configured LAG */
+	dsa_lags_foreach_id(i, ds->dst)
+		if (i != id && dsa_lag_dev(ds->dst, i)) {
+			unique_lag = false;
+			break;
+		}
+
+	/* Hash Mode is global. Make sure the same Hash Mode
+	 * is set to all the 4 possible lag.
+	 * If we are the unique LAG we can set whatever hash
+	 * mode we want.
+	 * To change hash mode it's needed to remove all LAG
+	 * and change the mode with the latest.
+	 */
+	if (unique_lag) {
+		priv->lag_hash_mode = hash;
+	} else if (priv->lag_hash_mode != hash) {
+		netdev_err(lag, "Error: Mismateched Hash Mode across different lag is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	return regmap_update_bits(priv->regmap, QCA8K_TRUNK_HASH_EN_CTRL,
+				  QCA8K_TRUNK_HASH_MASK, hash);
+}
+
+static int
+qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
+			  struct net_device *lag, bool delete)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret, id, i;
+	u32 val;
+
+	id = dsa_lag_id(ds->dst, lag);
+
+	/* Read current port member */
+	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
+	if (ret)
+		return ret;
+
+	/* Shift val to the correct trunk */
+	val >>= QCA8K_REG_GOL_TRUNK_SHIFT(id);
+	val &= QCA8K_REG_GOL_TRUNK_MEMBER_MASK;
+	if (delete)
+		val &= ~BIT(port);
+	else
+		val |= BIT(port);
+
+	/* Update port member. With empty portmap disable trunk */
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0,
+				 QCA8K_REG_GOL_TRUNK_MEMBER(id) |
+				 QCA8K_REG_GOL_TRUNK_EN(id),
+				 !val << QCA8K_REG_GOL_TRUNK_SHIFT(id) |
+				 val << QCA8K_REG_GOL_TRUNK_SHIFT(id));
+
+	/* Search empty member if adding or port on deleting */
+	for (i = 0; i < QCA8K_NUM_PORTS_FOR_LAG; i++) {
+		ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id), &val);
+		if (ret)
+			return ret;
+
+		val >>= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i);
+		val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_MASK;
+
+		if (delete) {
+			/* If port flagged to be disabled assume this member is
+			 * empty
+			 */
+			if (val != QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
+				continue;
+
+			val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT_MASK;
+			if (val != port)
+				continue;
+		} else {
+			/* If port flagged to be enabled assume this member is
+			 * already set
+			 */
+			if (val == QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
+				continue;
+		}
+
+		/* We have found the member to add/remove */
+		break;
+	}
+
+	/* Set port in the correct port mask or disable port if in delete mode */
+	return regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id),
+				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN(id, i) |
+				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT(id, i),
+				  !delete << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i) |
+				  port << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i));
+}
+
+static int
+qca8k_port_lag_join(struct dsa_switch *ds, int port,
+		    struct net_device *lag,
+		    struct netdev_lag_upper_info *info)
+{
+	int ret;
+
+	if (!qca8k_lag_can_offload(ds, lag, info))
+		return -EOPNOTSUPP;
+
+	ret = qca8k_lag_setup_hash(ds, lag, info);
+	if (ret)
+		return ret;
+
+	return qca8k_lag_refresh_portmap(ds, port, lag, false);
+}
+
+static int
+qca8k_port_lag_leave(struct dsa_switch *ds, int port,
+		     struct net_device *lag)
+{
+	return qca8k_lag_refresh_portmap(ds, port, lag, true);
+}
+
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
@@ -2236,6 +2411,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
 	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
 	.get_phy_flags		= qca8k_get_phy_flags,
+	.port_lag_join		= qca8k_port_lag_join,
+	.port_lag_leave		= qca8k_port_lag_leave,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 7c87a968c010..ab4a417b25a9 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -15,6 +15,8 @@
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_NUM_CPU_PORTS				2
 #define QCA8K_MAX_MTU					9000
+#define QCA8K_NUM_LAGS					4
+#define QCA8K_NUM_PORTS_FOR_LAG				4
 
 #define PHY_ID_QCA8327					0x004dd034
 #define QCA8K_ID_QCA8327				0x12
@@ -122,6 +124,14 @@
 #define QCA8K_REG_EEE_CTRL				0x100
 #define  QCA8K_REG_EEE_CTRL_LPI_EN(_i)			((_i + 1) * 2)
 
+/* TRUNK_HASH_EN registers */
+#define QCA8K_TRUNK_HASH_EN_CTRL			0x270
+#define   QCA8K_TRUNK_HASH_SIP_EN			BIT(3)
+#define   QCA8K_TRUNK_HASH_DIP_EN			BIT(2)
+#define   QCA8K_TRUNK_HASH_SA_EN			BIT(1)
+#define   QCA8K_TRUNK_HASH_DA_EN			BIT(0)
+#define   QCA8K_TRUNK_HASH_MASK				GENMASK(3, 0)
+
 /* ACL registers */
 #define QCA8K_REG_PORT_VLAN_CTRL0(_i)			(0x420 + (_i * 8))
 #define   QCA8K_PORT_VLAN_CVID_MASK			GENMASK(27, 16)
@@ -204,6 +214,28 @@
 #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
 #define   QCA8K_PORT_LOOKUP_ING_MIRROR_EN		BIT(25)
 
+#define QCA8K_REG_GOL_TRUNK_CTRL0			0x700
+/* 4 max trunk first
+ * first 6 bit for member bitmap
+ * 7th bit is to enable trunk port
+ */
+#define QCA8K_REG_GOL_TRUNK_SHIFT(_i)			((_i) * 8)
+#define QCA8K_REG_GOL_TRUNK_EN_MASK			BIT(7)
+#define QCA8K_REG_GOL_TRUNK_EN(_i)			(QCA8K_REG_GOL_TRUNK_EN_MASK << QCA8K_REG_GOL_TRUNK_SHIFT(_i))
+#define QCA8K_REG_GOL_TRUNK_MEMBER_MASK			GENMASK(6, 0)
+#define QCA8K_REG_GOL_TRUNK_MEMBER(_i)			(QCA8K_REG_GOL_TRUNK_MEMBER_MASK << QCA8K_REG_GOL_TRUNK_SHIFT(_i))
+/* 0x704 for TRUNK 0-1 --- 0x708 for TRUNK 2-3 */
+#define QCA8K_REG_GOL_TRUNK_CTRL(_i)			(0x704 + (((_i) / 2) * 4))
+#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_MASK		GENMASK(3, 0)
+#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK		BIT(3)
+#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT_MASK		GENMASK(2, 0)
+#define QCA8K_REG_GOL_TRUNK_ID_SHIFT(_i)		(((_i) / 2) * 16)
+#define QCA8K_REG_GOL_MEM_ID_SHIFT(_i)			((_i) * 4)
+/* Complex shift: FIRST shift for port THEN shift for trunk */
+#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(_i, _j)	(QCA8K_REG_GOL_MEM_ID_SHIFT(_j) + QCA8K_REG_GOL_TRUNK_ID_SHIFT(_i))
+#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN(_i, _j)	(QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(_i, _j))
+#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT(_i, _j)	(QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT_MASK << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(_i, _j))
+
 #define QCA8K_REG_GLOBAL_FC_THRESH			0x800
 #define   QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK		GENMASK(24, 16)
 #define   QCA8K_GLOBAL_FC_GOL_XON_THRES(x)		FIELD_PREP(QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK, x)
@@ -309,6 +341,7 @@ struct qca8k_priv {
 	u8 switch_revision;
 	u8 mirror_rx;
 	u8 mirror_tx;
+	u8 lag_hash_mode;
 	bool legacy_phy_port_mapping;
 	struct qca8k_ports_config ports_config;
 	struct regmap *regmap;
-- 
2.32.0

