Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2071239AD
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfLQWTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:19:51 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56214 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfLQWTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:19:48 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so54819wmj.5
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BuUO9aj8KVviGPgjVxsmaCXlT3tTo7z53TMFvlOD+Ps=;
        b=jAMCKEoAryoHFa+jGsatj7sMmIPTzPoA09NKgtQJzFIeVEmztGDUXm2Q+FBVbFJQj9
         YEhzCtyvKXg4QZtjYsfD9GRksZdA0gdlqMrgzZygU1FVtHG3D4hhTt1WNBlpF05BV4Pv
         2x8MoVqQqj8HD3PgKFs1EAlEQAJ44uUBd9QtxBKpSP279FnerckbqUlGP+/7TEq+GPMQ
         gLO253PImdCXYrsoVvsJf04O2wUV8S3f9fiBgHqUGk9CEAJwrXr1eCCCSPQVLOczw5+Y
         X4tNP1+VX2fowZ5r+I2EYo0EUqmtm04D0+nrsKUZvLs2PjeSPjfuUsrZagZ0MkP9bsfk
         P5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BuUO9aj8KVviGPgjVxsmaCXlT3tTo7z53TMFvlOD+Ps=;
        b=icXXWXKOiJzm425vXovtCFw7cXmx/yh6ofd5sqFlTLXr3xsashfi1nDp3bcIDDicc+
         AKn8btD31efnGNqUpoMrcgdRWek1WbgUYhtnJn059mR+aAbFGe+3iOGe+gsevnK+L3/u
         9aVeCMjrx/zDdhHBmVlLfmBleKyfy6/J2blnDUpteoO1rjHjVeOJor+wihfKyux/N1ts
         qJ6IDeL2dIXNCtwX5987QBmOjwaQZ9yRZ3DBoehV9/P3OqWR9hzJ1bjODEjrJWudLJgw
         wElW4ex85cnhtAfo7IgNzEN5WXMmRvLUngJJ/SgKsXCfEKPJWYcsm0oDPcoxeQA0kr2R
         ilHA==
X-Gm-Message-State: APjAAAVniH9mL4ND/9lrfC80Ajc247sTpIvuxsAfIqIV7ZquPuN8geeS
        5UyPWK09mbkcniHL+2tZnM4=
X-Google-Smtp-Source: APXvYqw7ikg6Uvwoap6gHXB44G2z3tNpyyWVcrFl2f6ZsH+rKFcc94NCXVWKFuxn18fdI0A0Vnp7Cw==
X-Received: by 2002:a1c:9903:: with SMTP id b3mr7754329wme.139.1576621186763;
        Tue, 17 Dec 2019 14:19:46 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id e6sm196808wru.44.2019.12.17.14.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:19:46 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 6/8] net: mscc: ocelot: make phy_mode a member of the common struct ocelot_port
Date:   Wed, 18 Dec 2019 00:18:29 +0200
Message-Id: <20191217221831.10923-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191217221831.10923-1-olteanv@gmail.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Ocelot switchdev driver and the Felix DSA one need it for different
reasons. Felix (or at least the VSC9959 instantiation in NXP LS1028A) is
integrated with the traditional NXP Layerscape PCS design which does not
support runtime configuration of SerDes protocol. So it needs to
pre-validate the phy-mode from the device tree and prevent PHYLINK from
attempting to change it. For this, it needs to cache it in a private
variable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c       | 7 ++++---
 drivers/net/ethernet/mscc/ocelot.h       | 1 -
 drivers/net/ethernet/mscc/ocelot_board.c | 4 ++--
 include/soc/mscc/ocelot.h                | 2 ++
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 985b46d7e3d1..86d543ab1ab9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -500,13 +500,14 @@ EXPORT_SYMBOL(ocelot_port_enable);
 static int ocelot_port_open(struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 	int err;
 
 	if (priv->serdes) {
 		err = phy_set_mode_ext(priv->serdes, PHY_MODE_ETHERNET,
-				       priv->phy_mode);
+				       ocelot_port->phy_mode);
 		if (err) {
 			netdev_err(dev, "Could not set mode of SerDes\n");
 			return err;
@@ -514,7 +515,7 @@ static int ocelot_port_open(struct net_device *dev)
 	}
 
 	err = phy_connect_direct(dev, priv->phy, &ocelot_port_adjust_link,
-				 priv->phy_mode);
+				 ocelot_port->phy_mode);
 	if (err) {
 		netdev_err(dev, "Could not attach to PHY\n");
 		return err;
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index c259114c48fd..7b77d44ed7cf 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -68,7 +68,6 @@ struct ocelot_port_private {
 
 	u8 vlan_aware;
 
-	phy_interface_t phy_mode;
 	struct phy *serdes;
 
 	struct ocelot_port_tc tc;
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 2da8eee27e98..b38820849faa 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -402,9 +402,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 		of_get_phy_mode(portnp, &phy_mode);
 
-		priv->phy_mode = phy_mode;
+		ocelot_port->phy_mode = phy_mode;
 
-		switch (priv->phy_mode) {
+		switch (ocelot_port->phy_mode) {
 		case PHY_INTERFACE_MODE_NA:
 			continue;
 		case PHY_INTERFACE_MODE_SGMII:
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 64cbbbe74a36..068f96b1a83e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -420,6 +420,8 @@ struct ocelot_port {
 	u8				ptp_cmd;
 	struct sk_buff_head		tx_skbs;
 	u8				ts_id;
+
+	phy_interface_t			phy_mode;
 };
 
 struct ocelot {
-- 
2.7.4

