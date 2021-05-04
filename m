Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C71373258
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhEDWaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbhEDWab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8FCC061574;
        Tue,  4 May 2021 15:29:34 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id u13so9599067edd.3;
        Tue, 04 May 2021 15:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mQeRCWGjNS7QKe+aRZ5Aot7ryiDOlNcdutUT2dImvjg=;
        b=hc5j5nMDDu2uSyojcFudhV1asQ4abOOps/RdGamr+X9PWg4Z/dVjSO1d+B/HHCD1rP
         h9iRCEowOzx/iW+qsV1DwcmT5YpRHMpT1n/qffjGQyliIntToJdKsS7YictuQ7YFVo3u
         dg6TBLVz+oHhx3Q4M9O2MZhYmb+8yQlcf8OaEDRUZgGGsaz2AiNriFNc15HIQzeeVAIz
         iyVt9U0AS2bbxHwwcaUciZdZFcoMHaOyxKJBuMqwNvNnvyMwdlCMzlD9uqyJgxvhg6b/
         SQGiYpps6NMp41ZUEmVFTVQS/6phQG+rivUv5kK+AEADrYbArX6if65gSq+8m2qi32R3
         NaSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mQeRCWGjNS7QKe+aRZ5Aot7ryiDOlNcdutUT2dImvjg=;
        b=RNfvl2D08AW1v4XKeQKZk4S2tjM2XJyBfOGaMsHY0HIzjkzOLJqZIm+c0DxlAgkfkr
         wVIb8Z/3lwXBN/eNqs3qEy21zxBB9fCfyLuzvWHR10DLuQ5D8DqvUJ+zp+fwnexh+EHl
         I5zxFNqc9ty4BbboAHQzWzxxZiTCTMiieKVhKfIqAx7XzURxuTeCTwg53WNmjexIaEFA
         qkgXBLEwY60MX+5Z3kehiy9nF2FkJX8z0jW4l0UlZfAuAf5AYMkl/aByRuIwCkpos4Ov
         0AsZAdtUlwXwI3ISgGbNxG3LAvusdwlxzCfMlSJBOgONlcSZ3XUIE71Zq0RmJuKlZKxo
         9Ovg==
X-Gm-Message-State: AOAM531YFvvcIWzhE9Q1JbJaLY7dyPdoNJlTdzi4RlyvDu5hGa9aKtil
        y9X4C/B4/sZ2bMPhvmwJr14=
X-Google-Smtp-Source: ABdhPJzAr/GOe7Qq/Pl1sT1xGiRAXK08d25YjuLOdS0CUQayNrqMDrS73s4h0EoBIVBxt2mABAA1Rg==
X-Received: by 2002:aa7:dd41:: with SMTP id o1mr12645104edw.361.1620167373139;
        Tue, 04 May 2021 15:29:33 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:32 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 07/20] net: dsa: qca8k: handle error with qca8k_rmw operation
Date:   Wed,  5 May 2021 00:29:01 +0200
Message-Id: <20210504222915.17206-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k_rmw can fail. Rework any user to handle error values and
correctly return.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 130 +++++++++++++++++++++++++---------------
 1 file changed, 83 insertions(+), 47 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 899bf93118eb..33875ad58d59 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -190,12 +190,13 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 static u32
 qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
-	u32 ret;
+	int ret;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	ret = qca8k_set_page(priv->bus, page);
 	if (ret < 0)
@@ -207,21 +208,32 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, ret);
 
 exit:
-	mutex_unlock(&priv->bus->mdio_lock);
-
+	mutex_unlock(&bus->mdio_lock);
 	return ret;
 }
 
-static void
+static int
 qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
 {
-	qca8k_rmw(priv, reg, 0, val);
+	int ret;
+
+	ret = qca8k_rmw(priv, reg, 0, val);
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
-static void
+static int
 qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
 {
-	qca8k_rmw(priv, reg, val, 0);
+	int ret;
+
+	ret = qca8k_rmw(priv, reg, val, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 static int
@@ -572,13 +584,17 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
 
 	ret = qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
 	if (ret)
 		goto exit;
 
-	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+	if (ret)
+		goto exit;
 
 	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
 
@@ -754,9 +770,8 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 		 * a dt-overlay and driver reload changed the configuration
 		 */
 
-		qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
-				QCA8K_MDIO_MASTER_EN);
-		return 0;
+		return qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+				       QCA8K_MDIO_MASTER_EN);
 	}
 
 	priv->ops.phy_read = qca8k_phy_read;
@@ -789,8 +804,12 @@ qca8k_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Enable CPU Port */
-	qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
-		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
+			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	if (ret) {
+		pr_err("failed enabling CPU port");
+		return ret;
+	}
 
 	/* Enable MIB counters */
 	ret = qca8k_mib_init(priv);
@@ -807,9 +826,12 @@ qca8k_setup(struct dsa_switch *ds)
 	}
 
 	/* Disable forwarding by default on all ports */
-	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-			  QCA8K_PORT_LOOKUP_MEMBER, 0);
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+				QCA8K_PORT_LOOKUP_MEMBER, 0);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Disable MAC by default on all ports */
 	for (i = 1; i < QCA8K_NUM_PORTS; i++)
@@ -828,28 +850,37 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
-				  QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
+					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			if (ret < 0)
+				return ret;
 		}
 
 		/* Individual user ports get connected to CPU port only */
 		if (dsa_is_user_port(ds, i)) {
 			int shift = 16 * (i % 2);
 
-			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-				  QCA8K_PORT_LOOKUP_MEMBER,
-				  BIT(QCA8K_CPU_PORT));
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+					QCA8K_PORT_LOOKUP_MEMBER,
+					BIT(QCA8K_CPU_PORT));
+			if (ret < 0)
+				return ret;
 
 			/* Enable ARP Auto-learning by default */
-			qca8k_reg_set(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-				      QCA8K_PORT_LOOKUP_LEARN);
+			ret = qca8k_reg_set(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+					    QCA8K_PORT_LOOKUP_LEARN);
+			if (ret)
+				return ret;
 
 			/* For port based vlans to work we need to set the
 			 * default egress vid
 			 */
-			qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
-				  0xfff << shift,
-				  QCA8K_PORT_VID_DEF << shift);
+			ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
+					0xfff << shift,
+					QCA8K_PORT_VID_DEF << shift);
+			if (ret < 0)
+				return ret;
+
 			ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
 					  QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
 					  QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
@@ -1241,7 +1272,7 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask = BIT(QCA8K_CPU_PORT);
-	int i;
+	int i, ret;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_to_port(ds, i)->bridge_dev != br)
@@ -1249,17 +1280,20 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 		/* Add this port to the portvlan mask of the other ports
 		 * in the bridge
 		 */
-		qca8k_reg_set(priv,
-			      QCA8K_PORT_LOOKUP_CTRL(i),
-			      BIT(port));
+		ret = qca8k_reg_set(priv,
+				    QCA8K_PORT_LOOKUP_CTRL(i),
+				    BIT(port));
+		if (ret)
+			return ret;
 		if (i != port)
 			port_mask |= BIT(i);
 	}
+
 	/* Add all other ports to this ports portvlan mask */
-	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, port_mask);
+	ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+			QCA8K_PORT_LOOKUP_MEMBER, port_mask);
 
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 static void
@@ -1396,18 +1430,19 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			  struct netlink_ext_ack *extack)
 {
 	struct qca8k_priv *priv = ds->priv;
+	int ret;
 
 	if (vlan_filtering) {
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			  QCA8K_PORT_LOOKUP_VLAN_MODE,
-			  QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
 	} else {
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			  QCA8K_PORT_LOOKUP_VLAN_MODE,
-			  QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
 	}
 
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 static int
@@ -1429,16 +1464,17 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	if (pvid) {
 		int shift = 16 * (port % 2);
 
-		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-			  0xfff << shift, vlan->vid << shift);
+		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
+				0xfff << shift, vlan->vid << shift);
+		if (ret < 0)
+			return ret;
+
 		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
 				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
 				  QCA8K_PORT_VLAN_SVID(vlan->vid));
-		if (ret)
-			return ret;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int
-- 
2.30.2

