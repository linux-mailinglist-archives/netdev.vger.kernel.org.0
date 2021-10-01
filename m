Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8033541E5D9
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 03:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351392AbhJABjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 21:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhJABjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 21:39:32 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3732C06176A;
        Thu, 30 Sep 2021 18:37:48 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h15so11303849wrc.3;
        Thu, 30 Sep 2021 18:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=93BJwpGnAeeXRYE/nrJsGDYpQ8/P7VW8aqrPebnwQqE=;
        b=EJsHoRuExTjZqtD9rNMKkmBOWyqZko2OB4KfsqlSU2QpVjVoBPWnOzcxFzE8VttaMm
         3MCtDyfzkXWuzfRZ0iGNokkvw1tgXbHR3J8ykJg4KWSW23yOakM1ZDLePG4YeBxwK04T
         Yht47/+nT3CYWmj8jq/3qQDb4Ml6WLfK0Hhx0WHXoVexCR38bQvpT17C4MBc6gMmhjpL
         F9DxUqmqxCLEqC6cJVGif1616D8WhVfkEUoGpoDwBH41N+LWIPl89uGtvUCKrkhCWD7o
         Jjly+bZpdYmPG5WGGSyfA1o9+v9Q9eVg+/U3ICqk+lO40kKzGHUffq6y691NC/oGErjr
         aiCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=93BJwpGnAeeXRYE/nrJsGDYpQ8/P7VW8aqrPebnwQqE=;
        b=pEFHhkXLb7SD8rf6Lokp3lTlK9kC8cQqY/zbFAYOfgll8ZpRYcSUWd6kb0N95PRr1o
         Qi4Kuooo6PoD6CkUQobCWTfo4PB++N/NASZ6wLiA8VuwJth+VBC9FKihHwUzRTSUlAfc
         OPaFCOV40u4+/V5Ss8ITNWY4cPIo7V7/QMOLBFuL5kqd1ehI7Xjp1avN071DVcG9Pa6f
         wAtUvmLTcffsqKa9lVoIwhdwi5MoEt/s6HNzqq6QjXovI/2TkZKbIpwbpp52lj9BX2Cr
         F4xGpzYkUpN7XCgRiEzTxUlGgZ3ucAHZ4zIwYiITJ63POhSWo1LSDnY9XmOV7NI4BIMz
         fPqw==
X-Gm-Message-State: AOAM5313SrQaHg2bjGjq7cjhiLKAU+9SVSzHnpAV9VEeiAw9+S66B+NX
        FpD0ENhWu010kMd3gKG5fgc=
X-Google-Smtp-Source: ABdhPJxofZYsc8xIZUlxg4JQ3MnpMU9M1nDGYN2TN6mWWstMEU6CagLvmG4DQ4TDLEX5RGRzDVUAHA==
X-Received: by 2002:a5d:544c:: with SMTP id w12mr9566570wrv.398.1633052267073;
        Thu, 30 Sep 2021 18:37:47 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id x10sm2832431wmk.42.2021.09.30.18.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 18:37:46 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next] drivers: net: dsa: qca8k: convert to GENMASK/FIELD_PREP/FIELD_GET
Date:   Fri,  1 Oct 2021 03:37:29 +0200
Message-Id: <20211001013729.21849-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert and try to standardize bit fields using
GENMASK/FIELD_PREP/FIELD_GET macros. Rework some logic to support the
standard macro and tidy things up. No functional change intended.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---

I still need to test this in every part but I would like to have some
approval about this kind of change. Also there are tons of warning by
checkpatch about too long line... Are they accepted for headers? I can't
really find another way to workaround the problem as reducing the define
name would make them less descriptive.
Aside from that I did the conversion as carefully as possible so in
theory nothing should be broken and the conversion should be all
correct. Some real improvement by using filed macro are in the
fdb_read/fdb_write that now are much more readable.

 drivers/net/dsa/qca8k.c |  98 ++++++++++++-------------
 drivers/net/dsa/qca8k.h | 155 ++++++++++++++++++++++------------------
 2 files changed, 132 insertions(+), 121 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bda5a9bf4f52..c17fa533663a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/netdevice.h>
+#include <linux/bitfield.h>
 #include <net/dsa.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
@@ -319,18 +320,18 @@ qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 	}
 
 	/* vid - 83:72 */
-	fdb->vid = (reg[2] >> QCA8K_ATU_VID_S) & QCA8K_ATU_VID_M;
+	fdb->vid = FIELD_GET(QCA8K_ATU_VID_MASK, reg[2]);
 	/* aging - 67:64 */
-	fdb->aging = reg[2] & QCA8K_ATU_STATUS_M;
+	fdb->aging = FIELD_GET(QCA8K_ATU_STATUS_MASK, reg[2]);
 	/* portmask - 54:48 */
-	fdb->port_mask = (reg[1] >> QCA8K_ATU_PORT_S) & QCA8K_ATU_PORT_M;
+	fdb->port_mask = FIELD_GET(QCA8K_ATU_PORT_MASK, reg[1]);
 	/* mac - 47:0 */
-	fdb->mac[0] = (reg[1] >> QCA8K_ATU_ADDR0_S) & 0xff;
-	fdb->mac[1] = reg[1] & 0xff;
-	fdb->mac[2] = (reg[0] >> QCA8K_ATU_ADDR2_S) & 0xff;
-	fdb->mac[3] = (reg[0] >> QCA8K_ATU_ADDR3_S) & 0xff;
-	fdb->mac[4] = (reg[0] >> QCA8K_ATU_ADDR4_S) & 0xff;
-	fdb->mac[5] = reg[0] & 0xff;
+	fdb->mac[0] = FIELD_GET(QCA8K_ATU_ADDR0_MASK, reg[1]);
+	fdb->mac[1] = FIELD_GET(QCA8K_ATU_ADDR1_MASK, reg[1]);
+	fdb->mac[2] = FIELD_GET(QCA8K_ATU_ADDR2_MASK, reg[0]);
+	fdb->mac[3] = FIELD_GET(QCA8K_ATU_ADDR3_MASK, reg[0]);
+	fdb->mac[4] = FIELD_GET(QCA8K_ATU_ADDR4_MASK, reg[0]);
+	fdb->mac[5] = FIELD_GET(QCA8K_ATU_ADDR5_MASK, reg[0]);
 
 	return 0;
 }
@@ -343,18 +344,18 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
 	int i;
 
 	/* vid - 83:72 */
-	reg[2] = (vid & QCA8K_ATU_VID_M) << QCA8K_ATU_VID_S;
+	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
 	/* aging - 67:64 */
-	reg[2] |= aging & QCA8K_ATU_STATUS_M;
+	reg[2] |= FIELD_PREP(QCA8K_ATU_STATUS_MASK, aging);
 	/* portmask - 54:48 */
-	reg[1] = (port_mask & QCA8K_ATU_PORT_M) << QCA8K_ATU_PORT_S;
+	reg[1] = FIELD_PREP(QCA8K_ATU_PORT_MASK, port_mask);
 	/* mac - 47:0 */
-	reg[1] |= mac[0] << QCA8K_ATU_ADDR0_S;
-	reg[1] |= mac[1];
-	reg[0] |= mac[2] << QCA8K_ATU_ADDR2_S;
-	reg[0] |= mac[3] << QCA8K_ATU_ADDR3_S;
-	reg[0] |= mac[4] << QCA8K_ATU_ADDR4_S;
-	reg[0] |= mac[5];
+	reg[1] |= FIELD_PREP(QCA8K_ATU_ADDR0_MASK, mac[0]);
+	reg[1] |= FIELD_PREP(QCA8K_ATU_ADDR1_MASK, mac[1]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR2_MASK, mac[2]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR3_MASK, mac[3]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR4_MASK, mac[4]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
 
 	/* load the array into the ARL table */
 	for (i = 0; i < 3; i++)
@@ -372,7 +373,7 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 	reg |= cmd;
 	if (port >= 0) {
 		reg |= QCA8K_ATU_FUNC_PORT_EN;
-		reg |= (port & QCA8K_ATU_FUNC_PORT_M) << QCA8K_ATU_FUNC_PORT_S;
+		reg |= FIELD_PREP(QCA8K_ATU_FUNC_PORT_MASK, port);
 	}
 
 	/* Write the function register triggering the table access */
@@ -454,7 +455,7 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	/* Set the command and VLAN index */
 	reg = QCA8K_VTU_FUNC1_BUSY;
 	reg |= cmd;
-	reg |= vid << QCA8K_VTU_FUNC1_VID_S;
+	reg |= FIELD_PREP(QCA8K_VTU_FUNC1_VID_MASK, vid);
 
 	/* Write the function register triggering the table access */
 	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
@@ -500,13 +501,11 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 	if (ret < 0)
 		goto out;
 	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
-	reg &= ~(QCA8K_VTU_FUNC0_EG_MODE_MASK << QCA8K_VTU_FUNC0_EG_MODE_S(port));
+	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
 	if (untagged)
-		reg |= QCA8K_VTU_FUNC0_EG_MODE_UNTAG <<
-				QCA8K_VTU_FUNC0_EG_MODE_S(port);
+		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_UNTAG(port);
 	else
-		reg |= QCA8K_VTU_FUNC0_EG_MODE_TAG <<
-				QCA8K_VTU_FUNC0_EG_MODE_S(port);
+		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_TAG(port);
 
 	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
 	if (ret)
@@ -534,15 +533,13 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
 	if (ret < 0)
 		goto out;
-	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
-	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
-			QCA8K_VTU_FUNC0_EG_MODE_S(port);
+	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
+	reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(port);
 
 	/* Check if we're the last member to be removed */
 	del = true;
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		mask = QCA8K_VTU_FUNC0_EG_MODE_NOT;
-		mask <<= QCA8K_VTU_FUNC0_EG_MODE_S(i);
+		mask = QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(i);
 
 		if ((reg & mask) != mask) {
 			del = false;
@@ -918,7 +915,7 @@ qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
 			/* Switch regs accept value in ns, convert ps to ns */
 			val = val / 1000;
 
-		if (val > QCA8K_MAX_DELAY) {
+		if (!FIELD_FIT(QCA8K_PORT_PAD_RGMII_RX_DELAY_MASK, val)) {
 			dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
 			val = 3;
 		}
@@ -936,7 +933,7 @@ qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
 			/* Switch regs accept value in ns, convert ps to ns */
 			val = val / 1000;
 
-		if (val > QCA8K_MAX_DELAY) {
+		if (!FIELD_FIT(QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK, val)) {
 			dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
 			val = 3;
 		}
@@ -994,8 +991,8 @@ qca8k_setup(struct dsa_switch *ds)
 
 	/* Enable QCA header mode on the cpu port */
 	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
-			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
-			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
+			  FIELD_PREP(QCA8K_PORT_HDR_CTRL_TX_MASK, QCA8K_PORT_HDR_CTRL_ALL) |
+			  FIELD_PREP(QCA8K_PORT_HDR_CTRL_RX_MASK, QCA8K_PORT_HDR_CTRL_ALL));
 	if (ret) {
 		dev_err(priv->dev, "failed enabling QCA header mode");
 		return ret;
@@ -1015,10 +1012,10 @@ qca8k_setup(struct dsa_switch *ds)
 
 	/* Forward all unknown frames to CPU port for Linux processing */
 	ret = qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
-			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_S |
-			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_BC_DP_S |
-			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_MC_DP_S |
-			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_UC_DP_S);
+			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK, BIT(0)) |
+			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK, BIT(0)) |
+			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_MC_DP_MASK, BIT(0)) |
+			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_UC_DP_MASK, BIT(0)));
 	if (ret)
 		return ret;
 
@@ -1034,8 +1031,6 @@ qca8k_setup(struct dsa_switch *ds)
 
 		/* Individual user ports get connected to CPU port only */
 		if (dsa_is_user_port(ds, i)) {
-			int shift = 16 * (i % 2);
-
 			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 					QCA8K_PORT_LOOKUP_MEMBER,
 					BIT(QCA8K_CPU_PORT));
@@ -1052,8 +1047,8 @@ qca8k_setup(struct dsa_switch *ds)
 			 * default egress vid
 			 */
 			ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
-					0xfff << shift,
-					QCA8K_PORT_VID_DEF << shift);
+					QCA8K_EGREES_VLAN_PORT_MASK(i),
+					QCA8K_EGREES_VLAN_PORT(i, QCA8K_PORT_VID_DEF));
 			if (ret)
 				return ret;
 
@@ -1102,7 +1097,7 @@ qca8k_setup(struct dsa_switch *ds)
 			QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
 			QCA8K_PORT_HOL_CTRL1_WRED_EN;
 			qca8k_rmw(priv, QCA8K_REG_PORT_HOL_CTRL1(i),
-				  QCA8K_PORT_HOL_CTRL1_ING_BUF |
+				  QCA8K_PORT_HOL_CTRL1_ING_BUF_MASK |
 				  QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
 				  QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
 				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
@@ -1115,8 +1110,8 @@ qca8k_setup(struct dsa_switch *ds)
 		mask = QCA8K_GLOBAL_FC_GOL_XON_THRES(288) |
 		       QCA8K_GLOBAL_FC_GOL_XOFF_THRES(496);
 		qca8k_rmw(priv, QCA8K_REG_GLOBAL_FC_THRESH,
-			  QCA8K_GLOBAL_FC_GOL_XON_THRES_S |
-			  QCA8K_GLOBAL_FC_GOL_XOFF_THRES_S,
+			  QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK |
+			  QCA8K_GLOBAL_FC_GOL_XOFF_THRES_MASK,
 			  mask);
 	}
 
@@ -1685,11 +1680,11 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 
 	if (vlan_filtering) {
 		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-				QCA8K_PORT_LOOKUP_VLAN_MODE,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
 				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
 	} else {
 		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-				QCA8K_PORT_LOOKUP_VLAN_MODE,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
 				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
 	}
 
@@ -1713,10 +1708,9 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	}
 
 	if (pvid) {
-		int shift = 16 * (port % 2);
-
 		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-				0xfff << shift, vlan->vid << shift);
+				QCA8K_EGREES_VLAN_PORT_MASK(port),
+				QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
 		if (ret)
 			return ret;
 
@@ -1810,7 +1804,7 @@ static int qca8k_read_switch_id(struct qca8k_priv *priv)
 	if (ret < 0)
 		return -ENODEV;
 
-	id = QCA8K_MASK_CTRL_DEVICE_ID(val & QCA8K_MASK_CTRL_DEVICE_ID_MASK);
+	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
 	if (id != data->id) {
 		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
 		return -ENODEV;
@@ -1819,7 +1813,7 @@ static int qca8k_read_switch_id(struct qca8k_priv *priv)
 	priv->switch_id = id;
 
 	/* Save revision to communicate to the internal PHY driver */
-	priv->switch_revision = (val & QCA8K_MASK_CTRL_REV_ID_MASK);
+	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ed3b05ad6745..a6b1bdd06faa 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -31,18 +31,19 @@
 /* Global control registers */
 #define QCA8K_REG_MASK_CTRL				0x000
 #define   QCA8K_MASK_CTRL_REV_ID_MASK			GENMASK(7, 0)
-#define   QCA8K_MASK_CTRL_REV_ID(x)			((x) >> 0)
+#define   QCA8K_MASK_CTRL_REV_ID(x)			FIELD_GET(QCA8K_MASK_CTRL_REV_ID_MASK, x)
 #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
-#define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
+#define   QCA8K_MASK_CTRL_DEVICE_ID(x)			FIELD_GET(QCA8K_MASK_CTRL_DEVICE_ID_MASK, x)
 #define QCA8K_REG_PORT0_PAD_CTRL			0x004
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
-#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		((x) << 22)
-#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		((x) << 20)
+#define   QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK		GENMASK(23, 22)
+#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		FIELD_PREP(QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK, x)
+#define   QCA8K_PORT_PAD_RGMII_RX_DELAY_MASK		GENMASK(21, 20)
+#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		FIELD_PREP(QCA8K_PORT_PAD_RGMII_RX_DELAY_MASK, x)
 #define	  QCA8K_PORT_PAD_RGMII_TX_DELAY_EN		BIT(25)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
-#define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
 #define QCA8K_REG_PWS					0x010
 #define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
@@ -58,10 +59,12 @@
 #define   QCA8K_MDIO_MASTER_READ			BIT(27)
 #define   QCA8K_MDIO_MASTER_WRITE			0
 #define   QCA8K_MDIO_MASTER_SUP_PRE			BIT(26)
-#define   QCA8K_MDIO_MASTER_PHY_ADDR(x)			((x) << 21)
-#define   QCA8K_MDIO_MASTER_REG_ADDR(x)			((x) << 16)
-#define   QCA8K_MDIO_MASTER_DATA(x)			(x)
+#define   QCA8K_MDIO_MASTER_PHY_ADDR_MASK		GENMASK(25, 21)
+#define   QCA8K_MDIO_MASTER_PHY_ADDR(x)			FIELD_PREP(QCA8K_MDIO_MASTER_PHY_ADDR_MASK, x)
+#define   QCA8K_MDIO_MASTER_REG_ADDR_MASK		GENMASK(20, 16)
+#define   QCA8K_MDIO_MASTER_REG_ADDR(x)			FIELD_PREP(QCA8K_MDIO_MASTER_REG_ADDR_MASK, x)
 #define   QCA8K_MDIO_MASTER_DATA_MASK			GENMASK(15, 0)
+#define   QCA8K_MDIO_MASTER_DATA(x)			FIELD_PREP(QCA8K_MDIO_MASTER_DATA_MASK, x)
 #define   QCA8K_MDIO_MASTER_MAX_PORTS			5
 #define   QCA8K_MDIO_MASTER_MAX_REG			32
 #define QCA8K_GOL_MAC_ADDR0				0x60
@@ -83,9 +86,7 @@
 #define   QCA8K_PORT_STATUS_FLOW_AUTO			BIT(12)
 #define QCA8K_REG_PORT_HDR_CTRL(_i)			(0x9c + (_i * 4))
 #define   QCA8K_PORT_HDR_CTRL_RX_MASK			GENMASK(3, 2)
-#define   QCA8K_PORT_HDR_CTRL_RX_S			2
 #define   QCA8K_PORT_HDR_CTRL_TX_MASK			GENMASK(1, 0)
-#define   QCA8K_PORT_HDR_CTRL_TX_S			0
 #define   QCA8K_PORT_HDR_CTRL_ALL			2
 #define   QCA8K_PORT_HDR_CTRL_MGMT			1
 #define   QCA8K_PORT_HDR_CTRL_NONE			0
@@ -95,10 +96,11 @@
 #define   QCA8K_SGMII_EN_TX				BIT(3)
 #define   QCA8K_SGMII_EN_SD				BIT(4)
 #define   QCA8K_SGMII_CLK125M_DELAY			BIT(7)
-#define   QCA8K_SGMII_MODE_CTRL_MASK			(BIT(22) | BIT(23))
-#define   QCA8K_SGMII_MODE_CTRL_BASEX			(0 << 22)
-#define   QCA8K_SGMII_MODE_CTRL_PHY			(1 << 22)
-#define   QCA8K_SGMII_MODE_CTRL_MAC			(2 << 22)
+#define   QCA8K_SGMII_MODE_CTRL_MASK			GENMASK(23, 22)
+#define   QCAIK_SGMII_MODE_CTRL(x)			FIELD_PREP(QCA8K_SGMII_MODE_CTRL_MASK, x)
+#define   QCA8K_SGMII_MODE_CTRL_BASEX			QCAIK_SGMII_MODE_CTRL(0x0)
+#define   QCA8K_SGMII_MODE_CTRL_PHY			QCAIK_SGMII_MODE_CTRL(0x1)
+#define   QCA8K_SGMII_MODE_CTRL_MAC			QCAIK_SGMII_MODE_CTRL(0x2)
 
 /* EEE control registers */
 #define QCA8K_REG_EEE_CTRL				0x100
@@ -106,100 +108,115 @@
 
 /* ACL registers */
 #define QCA8K_REG_PORT_VLAN_CTRL0(_i)			(0x420 + (_i * 8))
-#define   QCA8K_PORT_VLAN_CVID(x)			(x << 16)
-#define   QCA8K_PORT_VLAN_SVID(x)			x
+#define   QCA8K_PORT_VLAN_CVID_MASK			GENMASK(27, 16)
+#define   QCA8K_PORT_VLAN_CVID(x)			FIELD_PREP(QCA8K_PORT_VLAN_CVID_MASK, x)
+#define   QCA8K_PORT_VLAN_SVID_MASK			GENMASK(11, 0)
+#define   QCA8K_PORT_VLAN_SVID(x)			FIELD_PREP(QCA8K_PORT_VLAN_SVID_MASK, x)
 #define QCA8K_REG_PORT_VLAN_CTRL1(_i)			(0x424 + (_i * 8))
 #define QCA8K_REG_IPV4_PRI_BASE_ADDR			0x470
 #define QCA8K_REG_IPV4_PRI_ADDR_MASK			0x474
 
 /* Lookup registers */
 #define QCA8K_REG_ATU_DATA0				0x600
-#define   QCA8K_ATU_ADDR2_S				24
-#define   QCA8K_ATU_ADDR3_S				16
-#define   QCA8K_ATU_ADDR4_S				8
+#define   QCA8K_ATU_ADDR2_MASK				GENMASK(31, 24)
+#define   QCA8K_ATU_ADDR3_MASK				GENMASK(23, 16)
+#define   QCA8K_ATU_ADDR4_MASK				GENMASK(15, 8)
+#define   QCA8K_ATU_ADDR5_MASK				GENMASK(7, 0)
 #define QCA8K_REG_ATU_DATA1				0x604
-#define   QCA8K_ATU_PORT_M				0x7f
-#define   QCA8K_ATU_PORT_S				16
-#define   QCA8K_ATU_ADDR0_S				8
+#define   QCA8K_ATU_PORT_MASK				GENMASK(22, 16)
+#define   QCA8K_ATU_ADDR0_MASK				GENMASK(15, 8)
+#define   QCA8K_ATU_ADDR1_MASK				GENMASK(7, 0)
 #define QCA8K_REG_ATU_DATA2				0x608
-#define   QCA8K_ATU_VID_M				0xfff
-#define   QCA8K_ATU_VID_S				8
-#define   QCA8K_ATU_STATUS_M				0xf
+#define   QCA8K_ATU_VID_MASK				GENMASK(19, 8)
+#define   QCA8K_ATU_STATUS_MASK				GENMASK(3, 0)
 #define   QCA8K_ATU_STATUS_STATIC			0xf
 #define QCA8K_REG_ATU_FUNC				0x60c
 #define   QCA8K_ATU_FUNC_BUSY				BIT(31)
 #define   QCA8K_ATU_FUNC_PORT_EN			BIT(14)
 #define   QCA8K_ATU_FUNC_MULTI_EN			BIT(13)
 #define   QCA8K_ATU_FUNC_FULL				BIT(12)
-#define   QCA8K_ATU_FUNC_PORT_M				0xf
-#define   QCA8K_ATU_FUNC_PORT_S				8
+#define   QCA8K_ATU_FUNC_PORT_MASK			GENMASK(11, 8)
 #define QCA8K_REG_VTU_FUNC0				0x610
 #define   QCA8K_VTU_FUNC0_VALID				BIT(20)
 #define   QCA8K_VTU_FUNC0_IVL_EN			BIT(19)
-#define   QCA8K_VTU_FUNC0_EG_MODE_S(_i)			(4 + (_i) * 2)
-#define   QCA8K_VTU_FUNC0_EG_MODE_MASK			3
-#define   QCA8K_VTU_FUNC0_EG_MODE_UNMOD			0
-#define   QCA8K_VTU_FUNC0_EG_MODE_UNTAG			1
-#define   QCA8K_VTU_FUNC0_EG_MODE_TAG			2
-#define   QCA8K_VTU_FUNC0_EG_MODE_NOT			3
+/*        QCA8K_VTU_FUNC0_EG_MODE_MASK			GENMASK(17, 4)
+ *          It does contain VLAN_MODE for each port [5:4] for port0,
+ *          [7:6] for port1 ... [17:16] for port6. Use virtual port
+ *          define to handle this.
+ */
+#define   QCA8K_VTU_FUNC0_EG_MODE_PORT_SHIFT(_i)	(4 + (_i) * 2)
+#define   QCA8K_VTU_FUNC0_EG_MODE_MASK			GENMASK(1, 0)
+#define   QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(_i)		(GENMASK(1, 0) << QCA8K_VTU_FUNC0_EG_MODE_PORT_SHIFT(_i))
+#define   QCA8K_VTU_FUNC0_EG_MODE_UNMOD			FIELD_PREP(QCA8K_VTU_FUNC0_EG_MODE_MASK, 0x0)
+#define   QCA8K_VTU_FUNC0_EG_MODE_PORT_UNMOD(_i)	(QCA8K_VTU_FUNC0_EG_MODE_UNMOD << QCA8K_VTU_FUNC0_EG_MODE_PORT_SHIFT(_i))
+#define   QCA8K_VTU_FUNC0_EG_MODE_UNTAG			FIELD_PREP(QCA8K_VTU_FUNC0_EG_MODE_MASK, 0x1)
+#define   QCA8K_VTU_FUNC0_EG_MODE_PORT_UNTAG(_i)	(QCA8K_VTU_FUNC0_EG_MODE_UNTAG << QCA8K_VTU_FUNC0_EG_MODE_PORT_SHIFT(_i))
+#define   QCA8K_VTU_FUNC0_EG_MODE_TAG			FIELD_PREP(QCA8K_VTU_FUNC0_EG_MODE_MASK, 0x2)
+#define   QCA8K_VTU_FUNC0_EG_MODE_PORT_TAG(_i)		(QCA8K_VTU_FUNC0_EG_MODE_TAG << QCA8K_VTU_FUNC0_EG_MODE_PORT_SHIFT(_i))
+#define   QCA8K_VTU_FUNC0_EG_MODE_NOT			FIELD_PREP(QCA8K_VTU_FUNC0_EG_MODE_MASK, 0x3)
+#define   QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(_i)		(QCA8K_VTU_FUNC0_EG_MODE_NOT << QCA8K_VTU_FUNC0_EG_MODE_PORT_SHIFT(_i))
 #define QCA8K_REG_VTU_FUNC1				0x614
 #define   QCA8K_VTU_FUNC1_BUSY				BIT(31)
-#define   QCA8K_VTU_FUNC1_VID_S				16
+#define   QCA8K_VTU_FUNC1_VID_MASK			GENMASK(27, 16)
 #define   QCA8K_VTU_FUNC1_FULL				BIT(4)
 #define QCA8K_REG_GLOBAL_FW_CTRL0			0x620
 #define   QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN		BIT(10)
 #define QCA8K_REG_GLOBAL_FW_CTRL1			0x624
-#define   QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_S		24
-#define   QCA8K_GLOBAL_FW_CTRL1_BC_DP_S			16
-#define   QCA8K_GLOBAL_FW_CTRL1_MC_DP_S			8
-#define   QCA8K_GLOBAL_FW_CTRL1_UC_DP_S			0
+#define   QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK		GENMASK(30, 24)
+#define   QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK		GENMASK(22, 16)
+#define   QCA8K_GLOBAL_FW_CTRL1_MC_DP_MASK		GENMASK(14, 8)
+#define   QCA8K_GLOBAL_FW_CTRL1_UC_DP_MASK		GENMASK(6, 0)
 #define QCA8K_PORT_LOOKUP_CTRL(_i)			(0x660 + (_i) * 0xc)
 #define   QCA8K_PORT_LOOKUP_MEMBER			GENMASK(6, 0)
-#define   QCA8K_PORT_LOOKUP_VLAN_MODE			GENMASK(9, 8)
-#define   QCA8K_PORT_LOOKUP_VLAN_MODE_NONE		(0 << 8)
-#define   QCA8K_PORT_LOOKUP_VLAN_MODE_FALLBACK		(1 << 8)
-#define   QCA8K_PORT_LOOKUP_VLAN_MODE_CHECK		(2 << 8)
-#define   QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE		(3 << 8)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE_MASK		GENMASK(9, 8)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE(x)		FIELD_PREP(QCA8K_PORT_LOOKUP_VLAN_MODE_MASK, x)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE_NONE		QCA8K_PORT_LOOKUP_VLAN_MODE(0x0)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE_FALLBACK		QCA8K_PORT_LOOKUP_VLAN_MODE(0x1)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE_CHECK		QCA8K_PORT_LOOKUP_VLAN_MODE(0x2)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE		QCA8K_PORT_LOOKUP_VLAN_MODE(0x3)
 #define   QCA8K_PORT_LOOKUP_STATE_MASK			GENMASK(18, 16)
-#define   QCA8K_PORT_LOOKUP_STATE_DISABLED		(0 << 16)
-#define   QCA8K_PORT_LOOKUP_STATE_BLOCKING		(1 << 16)
-#define   QCA8K_PORT_LOOKUP_STATE_LISTENING		(2 << 16)
-#define   QCA8K_PORT_LOOKUP_STATE_LEARNING		(3 << 16)
-#define   QCA8K_PORT_LOOKUP_STATE_FORWARD		(4 << 16)
-#define   QCA8K_PORT_LOOKUP_STATE			GENMASK(18, 16)
+#define   QCA8K_PORT_LOOKUP_STATE(x)			FIELD_PREP(QCA8K_PORT_LOOKUP_STATE_MASK, x)
+#define   QCA8K_PORT_LOOKUP_STATE_DISABLED		QCA8K_PORT_LOOKUP_STATE(0x0)
+#define   QCA8K_PORT_LOOKUP_STATE_BLOCKING		QCA8K_PORT_LOOKUP_STATE(0x1)
+#define   QCA8K_PORT_LOOKUP_STATE_LISTENING		QCA8K_PORT_LOOKUP_STATE(0x2)
+#define   QCA8K_PORT_LOOKUP_STATE_LEARNING		QCA8K_PORT_LOOKUP_STATE(0x3)
+#define   QCA8K_PORT_LOOKUP_STATE_FORWARD		QCA8K_PORT_LOOKUP_STATE(0x4)
 #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
 
 #define QCA8K_REG_GLOBAL_FC_THRESH			0x800
-#define   QCA8K_GLOBAL_FC_GOL_XON_THRES(x)		((x) << 16)
-#define   QCA8K_GLOBAL_FC_GOL_XON_THRES_S		GENMASK(24, 16)
-#define   QCA8K_GLOBAL_FC_GOL_XOFF_THRES(x)		((x) << 0)
-#define   QCA8K_GLOBAL_FC_GOL_XOFF_THRES_S		GENMASK(8, 0)
+#define   QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK		GENMASK(24, 16)
+#define   QCA8K_GLOBAL_FC_GOL_XON_THRES(x)		FIELD_PREP(QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK, x)
+#define   QCA8K_GLOBAL_FC_GOL_XOFF_THRES_MASK		GENMASK(8, 0)
+#define   QCA8K_GLOBAL_FC_GOL_XOFF_THRES(x)		FIELD_PREP(QCA8K_GLOBAL_FC_GOL_XOFF_THRES_MASK, x)
 
 #define QCA8K_REG_PORT_HOL_CTRL0(_i)			(0x970 + (_i) * 0x8)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0_BUF		GENMASK(3, 0)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0(x)		((x) << 0)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1_BUF		GENMASK(7, 4)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1(x)		((x) << 4)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2_BUF		GENMASK(11, 8)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2(x)		((x) << 8)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3_BUF		GENMASK(15, 12)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3(x)		((x) << 12)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4_BUF		GENMASK(19, 16)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4(x)		((x) << 16)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5_BUF		GENMASK(23, 20)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5(x)		((x) << 20)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PORT_BUF		GENMASK(29, 24)
-#define   QCA8K_PORT_HOL_CTRL0_EG_PORT(x)		((x) << 24)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0_BUF_MASK		GENMASK(3, 0)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0(x)		FIELD_PREP(QCA8K_PORT_HOL_CTRL0_EG_PRI0_BUF_MASK, x)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1_BUF_MASK		GENMASK(7, 4)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1(x)		FIELD_PREP(QCA8K_PORT_HOL_CTRL0_EG_PRI1_BUF_MASK, x)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2_BUF_MASK		GENMASK(11, 8)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2(x)		FIELD_PREP(QCA8K_PORT_HOL_CTRL0_EG_PRI2_BUF_MASK, x)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3_BUF_MASK		GENMASK(15, 12)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3(x)		FIELD_PREP(QCA8K_PORT_HOL_CTRL0_EG_PRI3_BUF_MASK, x)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4_BUF_MASK		GENMASK(19, 16)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4(x)		FIELD_PREP(QCA8K_PORT_HOL_CTRL0_EG_PRI4_BUF_MASK, x)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5_BUF_MASK		GENMASK(23, 20)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5(x)		FIELD_PREP(QCA8K_PORT_HOL_CTRL0_EG_PRI5_BUF_MASK, x)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PORT_BUF_MASK		GENMASK(29, 24)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PORT(x)		FIELD_PREP(QCA8K_PORT_HOL_CTRL0_EG_PORT_BUF_MASK, x)
 
 #define QCA8K_REG_PORT_HOL_CTRL1(_i)			(0x974 + (_i) * 0x8)
-#define   QCA8K_PORT_HOL_CTRL1_ING_BUF			GENMASK(3, 0)
-#define   QCA8K_PORT_HOL_CTRL1_ING(x)			((x) << 0)
+#define   QCA8K_PORT_HOL_CTRL1_ING_BUF_MASK		GENMASK(3, 0)
+#define   QCA8K_PORT_HOL_CTRL1_ING(x)			FIELD_PREP(QCA8K_PORT_HOL_CTRL1_ING_BUF_MASK, x)
 #define   QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN		BIT(6)
 #define   QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN		BIT(7)
 #define   QCA8K_PORT_HOL_CTRL1_WRED_EN			BIT(8)
 #define   QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN		BIT(16)
 
 /* Pkt edit registers */
+#define QCA8K_EGREES_VLAN_PORT_SHIFT(_i)		(16 * ((_i) % 2))
+#define QCA8K_EGREES_VLAN_PORT_MASK(_i)			(GENMASK(11, 0) << QCA8K_EGREES_VLAN_PORT_SHIFT(_i))
+#define QCA8K_EGREES_VLAN_PORT(_i, x)			((x) << QCA8K_EGREES_VLAN_PORT_SHIFT(_i))
 #define QCA8K_EGRESS_VLAN(x)				(0x0c70 + (4 * (x / 2)))
 
 /* L3 registers */
-- 
2.32.0

