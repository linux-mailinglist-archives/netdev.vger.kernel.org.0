Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BC4454F05
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240900AbhKQVJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbhKQVI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:57 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C02DC06120A;
        Wed, 17 Nov 2021 13:05:34 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w1so16993049edc.6;
        Wed, 17 Nov 2021 13:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RLFHG8l3wenVTzX4laLb0bZe8AmwHHmFTy9b1c1u5XA=;
        b=G1e7H3HRCbSPoQAsbaJibBh/sUmWDl+l2UlDkPc0QokZpuDEBeWh/LW2WHDphiRkyS
         rsuhAB50AyTJJ3GHHas3zt/v3BNMoH18eBBQyUXHR/GHZfsg9Iu7kJK7s+oYtRlo2LWk
         U6cFZ8rlS2T9Kl/zLu44VXs3ly78YGyUNsCw/x0VqC/RdAP4snJD4+iJedtJVv5fPDlF
         2nSNbmI0+ip49zN2m/AOr5YeMvBHfTXjIMDtpBcIsd3sbr7Uaxu3Q5GVaKY6c0yYgkkX
         hquiRvCrB2kPU60Wj7D+jujVcDECN29bRb4mimfEJ0i1Lp1Edko98QfO0yYmfOceJCoA
         KqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RLFHG8l3wenVTzX4laLb0bZe8AmwHHmFTy9b1c1u5XA=;
        b=IDU5rThkCvsZa8BdSzkKW1/nsrl6PpRkBNZY1EW5tugmh3V8E6E6E/1lHydZSyTUmE
         nfL7NL1nyBdHdA2uO5c2p5IE49uHaKYYth51BHayFcRgMC1w3KCCz2npeA6xMVv8Lrgl
         nXW3UP19mu1nDmIPwf+EzIO1O55YoESn+VxhWzDo65QgfDkVoEHFZF0ZdwkgKTfo19U0
         mXTFjDSEYYFLeL4zbVymnogqXe6Du34Zh6MER8VyRzkrRMpgtDQlXuxdaNY20X1Rr83x
         btqTOP11fSsMFNis9gteOfA69zdwiZr2UvTI3xsZtdniZbxs7VqDU84+KhlU/Rr2cO8m
         kYRA==
X-Gm-Message-State: AOAM531q1eaGTnQO8nZcu7N157iLgxX4LOOku3xiuq8VMDHSzF66o46A
        ELMgdQCYmLVIW/YEV1Cs3ow=
X-Google-Smtp-Source: ABdhPJyhz/xZLmQcxiN76GthVJJUuo3AKQLK0A6OZAm8Sv98zipbq/yls8RgN22ZTe+n1JEqNMaf9Q==
X-Received: by 2002:a17:906:b84f:: with SMTP id ga15mr24828786ejb.4.1637183132551;
        Wed, 17 Nov 2021 13:05:32 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:32 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 15/19] net: dsa: qca8k: add LAG support
Date:   Wed, 17 Nov 2021 22:04:47 +0100
Message-Id: <20211117210451.26415-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LAG support to this switch. In Documentation this is described as
trunk mode. A max of 4 LAGs are supported and each can support up to 4
port. The only tx mode supported is Hash mode and no reference is
present for active backup or any other mode in Documentation.
When no port are present in the trunk, the trunk is disabled in the
switch.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 117 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  24 +++++++++
 2 files changed, 141 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a217c842ab45..c3234988aabf 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1312,6 +1312,9 @@ qca8k_setup(struct dsa_switch *ds)
 	ds->ageing_time_min = 7000;
 	ds->ageing_time_max = 458745000;
 
+	/* Set max number of LAGs supported */
+	ds->num_lag_ids = QCA8K_NUM_LAGS;
+
 	return 0;
 }
 
@@ -2220,6 +2223,118 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
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
+	return true;
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
+	for (i = 0; i < 4; i++) {
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
+		/* We find the member to remove */
+		break;
+	}
+
+	/* Set port in the correct port mask or disable port if in delate mode */
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
+	if (!qca8k_lag_can_offload(ds, lag, info))
+		return -EOPNOTSUPP;
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
@@ -2253,6 +2368,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
 	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
 	.get_phy_flags		= qca8k_get_phy_flags,
+	.port_lag_join		= qca8k_port_lag_join,
+	.port_lag_leave		= qca8k_port_lag_leave,
 };
 
 static int
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index e1298179d7cb..5310022569f3 100644
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
@@ -204,6 +206,28 @@
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
-- 
2.32.0

