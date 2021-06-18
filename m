Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59303ACA6F
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 13:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhFRLzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 07:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbhFRLzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 07:55:16 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C777C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 04:53:06 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c7so7334494edn.6
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 04:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YBShVnkPYASfgmGSYQo0t3ieFdTz8UoHBsEnQb9bMkY=;
        b=Y14f+FxG4gQxLrRcjbwZvTFcij6BxpCSb7gxE6c8PVnLEOkhT8+0W+6Xv+Z75oavZT
         OTVGQl/Jc9QAm3BLf6zHTx/RvMclEOq2Ml8CtNNmowHQ9bknmcHdIrdJGfysV2ua87li
         EhPW358hOhOUkWUkobpftfyAJSv8nORJy3hicimdAAsAE6IJlarnMSLChr/H/OLSacBi
         IU4ntDlKKjjhtfOa0rJZnKOpWJA2lAMUa5044O7VyQWBMVLgAW5z/RwNFFXD+Q6ydCnX
         LYdk0tRDoxSweu+Hpg4BtGrtobjyrabfxVSNlVazvhcLK4nBVdZaJtS4nGaTjp5Ezq/h
         XZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YBShVnkPYASfgmGSYQo0t3ieFdTz8UoHBsEnQb9bMkY=;
        b=DaoncwgnHPoJZadWSDDiaBlMZZrpxanXLWmBJz8Jr2hh5Tx8OL0Xfn5afTMn1bWaRf
         ZotpxuDR1nvgkaiHCc8UrSmV1apVK/2S7EQ6wd9vhkwuKnkgxhWWmLvp97PFvkQm5SE8
         SLfNr+Z6lWgNmb2c1w7PjtyJo3tmQTr2P0DSSCnqTrbAvT2e8pzfT8OnWqUimudDuUnv
         tit/TD2Gq4uYd9ypW6BW35TCGbLYxn2GFeV6e4mWBFdbesW5UHbgXA4q16U9An0mPJrZ
         4DoYxi23DXhAT2LJRqzd2OJY1SSimI6fmfUAOmSKH6WuxMUlf4mra04LLNw6+90MaBrX
         u5Pw==
X-Gm-Message-State: AOAM530iXIYdPN64HfmgmUfsGnx5wPqP6s4n/wLVeVF6swF7I7UV7sQ0
        j3IQqIqyxF5gbvLjrlW0QZo=
X-Google-Smtp-Source: ABdhPJyg1nfUOGg0PbheanvYG98//aOFQKC4kAx1TKmrTaGRVA0v6xNuExC/P6L6rK2Q7KgsMAC4hQ==
X-Received: by 2002:aa7:de1a:: with SMTP id h26mr4377841edv.176.1624017185110;
        Fri, 18 Jun 2021 04:53:05 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id h19sm949425ejy.82.2021.06.18.04.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 04:53:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: sja1105: properly power down the microcontroller clock for SJA1110
Date:   Fri, 18 Jun 2021 14:52:54 +0300
Message-Id: <20210618115254.2830880-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It turns out that powering down the BASE_TIMER_CLK does not turn off the
microcontroller, just its timers, including the one for the watchdog.
So the embedded microcontroller is still running, and potentially still
doing things.

To prevent unwanted interference, we should power down the BASE_MCSS_CLK
as well (MCSS = microcontroller subsystem).

The trouble is that currently we turn off the BASE_TIMER_CLK for SJA1110
from the .clocking_setup() method, mostly because this is a Clock
Generation Unit (CGU) setting which was traditionally configured in that
method for SJA1105. But in SJA1105, the CGU was used for bringing up the
port clocks at the proper speeds, and in SJA1110 it's not (but rather
for initial configuration), so it's best that we rebrand the
sja1110_clocking_setup() method into what it really is - an implementation
of the .disable_microcontroller() method.

Since disabling the microcontroller only needs to be done once, at probe
time, we can choose the best place to do that as being in sja1105_setup(),
before we upload the static config to the device. This guarantees that
the static config being used by the switch afterwards is really ours.

Note that the procedure to upload a static config necessarily resets the
switch. This already did not reset the microcontroller, only the switch
core, so since the .disable_microcontroller() method is guaranteed to be
called by that point, if it's disabled, it remains disabled. Add a
comment to make that clear.

With the code movement for SJA1110 from .clocking_setup() to
.disable_microcontroller(), both methods are optional and are guarded by
"if" conditions.

Tested by enabling in the device tree the rev-mii switch port 0 that
goes towards the microcontroller, and flashing a firmware that would
have networking. Without this patch, the microcontroller can be pinged,
with this patch it cannot.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h          |  3 +-
 drivers/net/dsa/sja1105/sja1105_clocking.c | 20 ++++++++++++--
 drivers/net/dsa/sja1105/sja1105_main.c     | 32 +++++++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_spi.c      | 14 ++++++----
 4 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 39124726bdd9..221c7abdef0e 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -136,6 +136,7 @@ struct sja1105_info {
 	int (*clocking_setup)(struct sja1105_private *priv);
 	int (*pcs_mdio_read)(struct mii_bus *bus, int phy, int reg);
 	int (*pcs_mdio_write)(struct mii_bus *bus, int phy, int reg, u16 val);
+	int (*disable_microcontroller)(struct sja1105_private *priv);
 	const char *name;
 	bool supports_mii[SJA1105_MAX_NUM_PORTS];
 	bool supports_rmii[SJA1105_MAX_NUM_PORTS];
@@ -363,7 +364,7 @@ int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port);
 int sja1110_setup_rgmii_delay(const void *ctx, int port);
 int sja1105_clocking_setup_port(struct sja1105_private *priv, int port);
 int sja1105_clocking_setup(struct sja1105_private *priv);
-int sja1110_clocking_setup(struct sja1105_private *priv);
+int sja1110_disable_microcontroller(struct sja1105_private *priv);
 
 /* From sja1105_ethtool.c */
 void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data);
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 645edea5a81f..387a1f2f161c 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -6,6 +6,7 @@
 #include "sja1105.h"
 
 #define SJA1105_SIZE_CGU_CMD	4
+#define SJA1110_BASE_MCSS_CLK	SJA1110_CGU_ADDR(0x70)
 #define SJA1110_BASE_TIMER_CLK	SJA1110_CGU_ADDR(0x74)
 
 /* Common structure for CFG_PAD_MIIx_RX and CFG_PAD_MIIx_TX */
@@ -832,17 +833,30 @@ sja1110_cgu_outclk_packing(void *buf, struct sja1110_cgu_outclk *outclk,
 	sja1105_packing(buf, &outclk->pd,         0,  0, size, op);
 }
 
-/* Power down the BASE_TIMER_CLK in order to disable the watchdog */
-int sja1110_clocking_setup(struct sja1105_private *priv)
+int sja1110_disable_microcontroller(struct sja1105_private *priv)
 {
 	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
+	struct sja1110_cgu_outclk outclk_6_c = {
+		.clksrc = 0x3,
+		.pd = true,
+	};
 	struct sja1110_cgu_outclk outclk_7_c = {
 		.clksrc = 0x5,
 		.pd = true,
 	};
+	int rc;
 
+	/* Power down the BASE_TIMER_CLK to disable the watchdog timer */
 	sja1110_cgu_outclk_packing(packed_buf, &outclk_7_c, PACK);
 
-	return sja1105_xfer_buf(priv, SPI_WRITE, SJA1110_BASE_TIMER_CLK,
+	rc = sja1105_xfer_buf(priv, SPI_WRITE, SJA1110_BASE_TIMER_CLK,
+			      packed_buf, SJA1105_SIZE_CGU_CMD);
+	if (rc)
+		return rc;
+
+	/* Power down the BASE_MCSS_CLOCK to gate the microcontroller off */
+	sja1110_cgu_outclk_packing(packed_buf, &outclk_6_c, PACK);
+
+	return sja1105_xfer_buf(priv, SPI_WRITE, SJA1110_BASE_MCSS_CLK,
 				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8e5cdf93c23b..57ccd4548911 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1922,9 +1922,11 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	 * For these interfaces there is no dynamic configuration
 	 * needed, since PLLs have same settings at all speeds.
 	 */
-	rc = priv->info->clocking_setup(priv);
-	if (rc < 0)
-		goto out;
+	if (priv->info->clocking_setup) {
+		rc = priv->info->clocking_setup(priv);
+		if (rc < 0)
+			goto out;
+	}
 
 	for (i = 0; i < ds->num_ports; i++) {
 		struct dw_xpcs *xpcs = priv->xpcs[i];
@@ -3032,18 +3034,34 @@ static int sja1105_setup(struct dsa_switch *ds)
 		goto out_ptp_clock_unregister;
 	}
 
+	if (priv->info->disable_microcontroller) {
+		rc = priv->info->disable_microcontroller(priv);
+		if (rc < 0) {
+			dev_err(ds->dev,
+				"Failed to disable microcontroller: %pe\n",
+				ERR_PTR(rc));
+			goto out_mdiobus_unregister;
+		}
+	}
+
 	/* Create and send configuration down to device */
 	rc = sja1105_static_config_load(priv);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to load static config: %d\n", rc);
 		goto out_mdiobus_unregister;
 	}
+
 	/* Configure the CGU (PHY link modes and speeds) */
-	rc = priv->info->clocking_setup(priv);
-	if (rc < 0) {
-		dev_err(ds->dev, "Failed to configure MII clocking: %d\n", rc);
-		goto out_static_config_free;
+	if (priv->info->clocking_setup) {
+		rc = priv->info->clocking_setup(priv);
+		if (rc < 0) {
+			dev_err(ds->dev,
+				"Failed to configure MII clocking: %pe\n",
+				ERR_PTR(rc));
+			goto out_static_config_free;
+		}
 	}
+
 	/* On SJA1105, VLAN filtering per se is always enabled in hardware.
 	 * The only thing we can do to disable it is lie about what the 802.1Q
 	 * EtherType is.
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 4aed16d23f21..08cc5dbf2fa6 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -199,7 +199,11 @@ static int sja1110_reset_cmd(struct dsa_switch *ds)
 	const struct sja1105_regs *regs = priv->info->regs;
 	u32 switch_reset = BIT(20);
 
-	/* Switch core reset */
+	/* Only reset the switch core.
+	 * A full cold reset would re-enable the BASE_MCSS_CLOCK PLL which
+	 * would turn on the microcontroller, potentially letting it execute
+	 * code which could interfere with our configuration.
+	 */
 	return sja1105_xfer_u32(priv, SPI_WRITE, regs->rgu, &switch_reset, NULL);
 }
 
@@ -796,7 +800,7 @@ const struct sja1105_info sja1110a_info = {
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
 	.txtstamp		= sja1110_txtstamp,
-	.clocking_setup		= sja1110_clocking_setup,
+	.disable_microcontroller = sja1110_disable_microcontroller,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
@@ -847,7 +851,7 @@ const struct sja1105_info sja1110b_info = {
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
 	.txtstamp		= sja1110_txtstamp,
-	.clocking_setup		= sja1110_clocking_setup,
+	.disable_microcontroller = sja1110_disable_microcontroller,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
@@ -898,7 +902,7 @@ const struct sja1105_info sja1110c_info = {
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
 	.txtstamp		= sja1110_txtstamp,
-	.clocking_setup		= sja1110_clocking_setup,
+	.disable_microcontroller = sja1110_disable_microcontroller,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
@@ -949,7 +953,7 @@ const struct sja1105_info sja1110d_info = {
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.rxtstamp		= sja1110_rxtstamp,
 	.txtstamp		= sja1110_txtstamp,
-	.clocking_setup		= sja1110_clocking_setup,
+	.disable_microcontroller = sja1110_disable_microcontroller,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
-- 
2.25.1

