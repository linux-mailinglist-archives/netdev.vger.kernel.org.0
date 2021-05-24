Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622F238F62B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 01:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhEXXYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhEXXYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:24:00 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C560BC06138A
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j10so16332313edw.8
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RoqY4DlDuQqg0fpduGy/ClYSGl+Ajb6Xfl8o0SjmeoI=;
        b=c3CIWEzYEhRxHZFUzn6EkNVzS+XFuEZBIn55SFggU0Vuf+xBJOmo2mMTafbCVolQTQ
         zk2FuuvNWjFRhfy8nEceoPyeU3kGUQUpScXPAd3qf3VOl0+jRmTYQRgvvKTiFl+v3X0Z
         YG7/V/Js2Q7z3Tfis30D/IBwfTk1xA+zQd414puTPQD4jk6uzru6WPv/SlQ7PYUDrUNP
         hR3bew00DuIWGnoc3bJQWKJLySffcfrc1fv7JjINYHRiBmWRa6ehrJp8bUs8VdAzH7cv
         /L/TUvuQoaG1O5qQi7BWBRn8rYphB07wjHsNXe6Py5FIJld991yrkjzU5EQ9dq6J68FW
         HR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RoqY4DlDuQqg0fpduGy/ClYSGl+Ajb6Xfl8o0SjmeoI=;
        b=PnOuAINzg15RMWDCuNMV90hTkSSxE8h5BCCYKyGmBkriVwl4fzuVYycuSQmO7P8rkA
         6F0JStEXY/elBzJXtqL6psMmWbmTRT8ME4Z0VLbXl0cQ5CZVc7ZJZTrQf2CDrb111oJD
         h/XNqqFhNsIquOpMwAU1izwJkxiCFpNxcNB9OMTpZHVvfzggMCLm/aoSnFKSkwSsjTkm
         C/gqp44LoANqLD5xHYYoW9ImbQ3N1b8WCPdG6Hyo4nm3gQi52/HtGfU1lyDgso1ugFTS
         kfmoHmpi9y72vThibTgGFQZFHRcp/b/RKhXiYZEoSDtQCPiWAQ2BFW9nEiYDQeGYIw8i
         gxyw==
X-Gm-Message-State: AOAM533j4CLM5RLSzdhWSjpPqADfxZCXTJKtEwOwfIO+GCyET7nZ6G5/
        z+9kHTwpGYPApFLAVljc6bE=
X-Google-Smtp-Source: ABdhPJyp3oglXDIxFicXkBu/F+lgX6JeFnfR6oYhLzWIq+csg1RYCQqBHLqn0v0vam11hFMjSgQctA==
X-Received: by 2002:aa7:d50e:: with SMTP id y14mr27955184edq.346.1621898550448;
        Mon, 24 May 2021 16:22:30 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id di7sm9922746edb.34.2021.05.24.16.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:22:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 02/13] net: dsa: sja1105: allow SGMII PCS configuration to be per port
Date:   Tue, 25 May 2021 02:22:03 +0300
Message-Id: <20210524232214.1378937-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524232214.1378937-1-olteanv@gmail.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1105 R and S switches have 1 SGMII port (port 4). Because there
is only one such port, there is no "port" parameter in the configuration
code for the SGMII PCS.

However, the SJA1110 can have up to 4 SGMII ports, each with its own
SGMII register map. So we need to generalize the logic.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 75 +++++++++++++++-----------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b6a8ac3a0430..1a49cfce9611 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -898,36 +898,43 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
 	return rc;
 }
 
-static int sja1105_sgmii_read(struct sja1105_private *priv, int pcs_reg)
+static int sja1105_sgmii_read(struct sja1105_private *priv, int port,
+			      int pcs_reg)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 	u32 val;
 	int rc;
 
-	rc = sja1105_xfer_u32(priv, SPI_READ, regs->sgmii + pcs_reg, &val,
-			      NULL);
+	if (port != SJA1105_SGMII_PORT)
+		return -ENODEV;
+
+	rc = sja1105_xfer_u32(priv, SPI_READ, regs->sgmii + pcs_reg,
+			      &val, NULL);
 	if (rc < 0)
 		return rc;
 
 	return val;
 }
 
-static int sja1105_sgmii_write(struct sja1105_private *priv, int pcs_reg,
-			       u16 pcs_val)
+static int sja1105_sgmii_write(struct sja1105_private *priv, int port,
+			       int pcs_reg, u16 pcs_val)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 	u32 val = pcs_val;
 	int rc;
 
-	rc = sja1105_xfer_u32(priv, SPI_WRITE, regs->sgmii + pcs_reg, &val,
-			      NULL);
+	if (port != SJA1105_SGMII_PORT)
+		return -ENODEV;
+
+	rc = sja1105_xfer_u32(priv, SPI_WRITE, regs->sgmii + pcs_reg,
+			      &val, NULL);
 	if (rc < 0)
 		return rc;
 
 	return val;
 }
 
-static void sja1105_sgmii_pcs_config(struct sja1105_private *priv,
+static void sja1105_sgmii_pcs_config(struct sja1105_private *priv, int port,
 				     bool an_enabled, bool an_master)
 {
 	u16 ac = SJA1105_AC_AUTONEG_MODE_SGMII;
@@ -936,27 +943,29 @@ static void sja1105_sgmii_pcs_config(struct sja1105_private *priv,
 	 * stop the clock during LPI mode, make the MAC reconfigure
 	 * autonomously after PCS autoneg is done, flush the internal FIFOs.
 	 */
-	sja1105_sgmii_write(priv, SJA1105_DC1, SJA1105_DC1_EN_VSMMD1 |
-					       SJA1105_DC1_CLOCK_STOP_EN |
-					       SJA1105_DC1_MAC_AUTO_SW |
-					       SJA1105_DC1_INIT);
+	sja1105_sgmii_write(priv, port, SJA1105_DC1,
+			    SJA1105_DC1_EN_VSMMD1 |
+			    SJA1105_DC1_CLOCK_STOP_EN |
+			    SJA1105_DC1_MAC_AUTO_SW |
+			    SJA1105_DC1_INIT);
 	/* DIGITAL_CONTROL_2: No polarity inversion for TX and RX lanes */
-	sja1105_sgmii_write(priv, SJA1105_DC2, SJA1105_DC2_TX_POL_INV_DISABLE);
+	sja1105_sgmii_write(priv, port, SJA1105_DC2,
+			    SJA1105_DC2_TX_POL_INV_DISABLE);
 	/* AUTONEG_CONTROL: Use SGMII autoneg */
 	if (an_master)
 		ac |= SJA1105_AC_PHY_MODE | SJA1105_AC_SGMII_LINK;
-	sja1105_sgmii_write(priv, SJA1105_AC, ac);
+	sja1105_sgmii_write(priv, port, SJA1105_AC, ac);
 	/* BASIC_CONTROL: enable in-band AN now, if requested. Otherwise,
 	 * sja1105_sgmii_pcs_force_speed must be called later for the link
 	 * to become operational.
 	 */
 	if (an_enabled)
-		sja1105_sgmii_write(priv, MII_BMCR,
+		sja1105_sgmii_write(priv, port, MII_BMCR,
 				    BMCR_ANENABLE | BMCR_ANRESTART);
 }
 
 static void sja1105_sgmii_pcs_force_speed(struct sja1105_private *priv,
-					  int speed)
+					  int port, int speed)
 {
 	int pcs_speed;
 
@@ -974,7 +983,7 @@ static void sja1105_sgmii_pcs_force_speed(struct sja1105_private *priv,
 		dev_err(priv->ds->dev, "Invalid speed %d\n", speed);
 		return;
 	}
-	sja1105_sgmii_write(priv, MII_BMCR, pcs_speed | BMCR_FULLDPLX);
+	sja1105_sgmii_write(priv, port, MII_BMCR, pcs_speed | BMCR_FULLDPLX);
 }
 
 /* Convert link speed from SJA1105 to ethtool encoding */
@@ -1115,7 +1124,8 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 	}
 
 	if (is_sgmii)
-		sja1105_sgmii_pcs_config(priv, phylink_autoneg_inband(mode),
+		sja1105_sgmii_pcs_config(priv, port,
+					 phylink_autoneg_inband(mode),
 					 false);
 }
 
@@ -1138,7 +1148,7 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 	sja1105_adjust_port_config(priv, port, speed);
 
 	if (sja1105_supports_sgmii(priv, port) && !phylink_autoneg_inband(mode))
-		sja1105_sgmii_pcs_force_speed(priv, speed);
+		sja1105_sgmii_pcs_force_speed(priv, port, speed);
 
 	sja1105_inhibit_tx(priv, BIT(port), false);
 }
@@ -1191,7 +1201,7 @@ static int sja1105_mac_pcs_get_state(struct dsa_switch *ds, int port,
 	int ais;
 
 	/* Read the vendor-specific AUTONEG_INTR_STATUS register */
-	ais = sja1105_sgmii_read(priv, SJA1105_AIS);
+	ais = sja1105_sgmii_read(priv, port, SJA1105_AIS);
 	if (ais < 0)
 		return ais;
 
@@ -1873,11 +1883,11 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	struct ptp_system_timestamp ptp_sts_before;
 	struct ptp_system_timestamp ptp_sts_after;
 	int speed_mbps[SJA1105_MAX_NUM_PORTS];
+	u16 bmcr[SJA1105_MAX_NUM_PORTS] = {0};
 	struct sja1105_mac_config_entry *mac;
 	struct dsa_switch *ds = priv->ds;
 	s64 t1, t2, t3, t4;
 	s64 t12, t34;
-	u16 bmcr = 0;
 	int rc, i;
 	s64 now;
 
@@ -1893,10 +1903,10 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	for (i = 0; i < ds->num_ports; i++) {
 		speed_mbps[i] = sja1105_speed[mac[i].speed];
 		mac[i].speed = SJA1105_SPEED_AUTO;
-	}
 
-	if (sja1105_supports_sgmii(priv, SJA1105_SGMII_PORT))
-		bmcr = sja1105_sgmii_read(priv, MII_BMCR);
+		if (sja1105_supports_sgmii(priv, i))
+			bmcr[i] = sja1105_sgmii_read(priv, i, MII_BMCR);
+	}
 
 	/* No PTP operations can run right now */
 	mutex_lock(&priv->ptp_data.lock);
@@ -1943,27 +1953,30 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		goto out;
 
 	for (i = 0; i < ds->num_ports; i++) {
+		bool an_enabled;
+
 		rc = sja1105_adjust_port_config(priv, i, speed_mbps[i]);
 		if (rc < 0)
 			goto out;
-	}
 
-	if (sja1105_supports_sgmii(priv, SJA1105_SGMII_PORT)) {
-		bool an_enabled = !!(bmcr & BMCR_ANENABLE);
+		if (!sja1105_supports_sgmii(priv, i))
+			continue;
+
+		an_enabled = !!(bmcr[i] & BMCR_ANENABLE);
 
-		sja1105_sgmii_pcs_config(priv, an_enabled, false);
+		sja1105_sgmii_pcs_config(priv, i, an_enabled, false);
 
 		if (!an_enabled) {
 			int speed = SPEED_UNKNOWN;
 
-			if (bmcr & BMCR_SPEED1000)
+			if (bmcr[i] & BMCR_SPEED1000)
 				speed = SPEED_1000;
-			else if (bmcr & BMCR_SPEED100)
+			else if (bmcr[i] & BMCR_SPEED100)
 				speed = SPEED_100;
 			else
 				speed = SPEED_10;
 
-			sja1105_sgmii_pcs_force_speed(priv, speed);
+			sja1105_sgmii_pcs_force_speed(priv, i, speed);
 		}
 	}
 
-- 
2.25.1

