Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFBF1AE63F
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730825AbgDQTvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730449AbgDQTvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 15:51:06 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56790C061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:51:05 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k13so3189876wrw.7
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RsQ8jp4gj8c+nE7uZoBGTzNtc3e3EhxAESwQHrI6u1c=;
        b=GN1u16aMcV38YulT3dt9E7UXMAKJLQgXE+N2MJrwvpGOXptUYi1Yw/mH4korkZWw+t
         ZtqHv3rpNZTkaIt8RVADvXwi6+PvM0YG5Qp2OSvqRsU8HkXFbIFzNdcnsbtmuhc2m/ip
         V+RkKJiY55Pomi8LRLrc93u67m1omfULA3uN5FCfxOCeCEObs5uLuMUb2N+LKdNm7zvw
         LCUBJgzzvVW5Zx+hPF/WwKtAQazn5CsuJ59GmA9KefXfjSVs0+KKuF7QqBCFX6bjckHI
         ezEv1NUznNZYFZLqJhWlOa0fukDF0cLWznDISqKk54JNzoCoT3WV/zdGZYVf8Fv6Pr/f
         HGUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RsQ8jp4gj8c+nE7uZoBGTzNtc3e3EhxAESwQHrI6u1c=;
        b=Atnjlpo+0BC966ZMuX8UEP/NO1Y6gsX3PrZfiD92mPeyB/ViwqXzmLEbt6abz7AS0E
         P2nOMnUS7g18/+7RM22OIHy6sX0UhkfJSbhkqs+iJA15CPmaLGAbtaHguS6di89LpcEU
         DaPMPPDKkcSht1DsP2NblqelS39r19c9CJjjMCLL/ROR1KVPXnc9zlttfSmnigo3JGHj
         LXmO6H54N258uWUu92JCMRW/AIdPWJHWt3vzCUZ/j5OVjuePeU60TCypRrjdLyDq/Gex
         yCBJfe0pe5Exh/hBCrUq3LxeaYqXtIOGy0i9rtGhS1VJWxQgXX2TtxxuPbCxXwwZgWaX
         g4Tg==
X-Gm-Message-State: AGi0PuZ7C4Mrs5xvsZOsq209bME5dpNcPPXvu484+g+xxmsWEyVxtLkC
        fF3H31jJMqihnyVqKMT8f3I=
X-Google-Smtp-Source: APiQypKDbevUoyjFh3n0cc+edD7Ok6RQZQL5Utw3RzbPUkt2WBzXrT3Dcw4I3f+Mh63inSshGBEYdg==
X-Received: by 2002:adf:e711:: with SMTP id c17mr4033339wrm.334.1587153064045;
        Fri, 17 Apr 2020 12:51:04 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id a24sm8767843wmb.24.2020.04.17.12.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 12:51:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: sja1105: enable internal pull-down for RX_DV/CRS_DV/RX_CTL and RX_ER
Date:   Fri, 17 Apr 2020 22:50:52 +0300
Message-Id: <20200417195052.22537-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some boards do not have the RX_ER MII signal connected. Normally in such
situation, those pins would be grounded, but then again, some boards
left it electrically floating.

When sending traffic to those switch ports, one can see that the
N_SOFERR statistics counter is incrementing once per each packet. The
user manual states for this counter that it may count the number of
frames "that have the MII error input being asserted prior to or
up to the SOF delimiter byte". So the switch MAC is sampling an
electrically floating signal, and preventing proper traffic reception
because of that.

As a workaround, enable the internal weak pull-downs on the input pads
for the MII control signals. This way, a floating signal would be
internally tied to ground.

The logic levels of signals which _are_ externally driven should not be
bothered by this 40-50 KOhm internal resistor. So it is not an issue to
enable the internal pull-down unconditionally, irrespective of PHY
interface type (MII, RMII, RGMII, SGMII) and of board layout.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h          |  1 +
 drivers/net/dsa/sja1105/sja1105_clocking.c | 58 +++++++++++++++++++---
 drivers/net/dsa/sja1105/sja1105_spi.c      |  2 +
 3 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 8b60dbd567f2..2f62942692ec 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -49,6 +49,7 @@ struct sja1105_regs {
 	u64 ptpschtm;
 	u64 ptpegr_ts[SJA1105_NUM_PORTS];
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
+	u64 pad_mii_rx[SJA1105_NUM_PORTS];
 	u64 pad_mii_id[SJA1105_NUM_PORTS];
 	u64 cgu_idiv[SJA1105_NUM_PORTS];
 	u64 mii_tx_clk[SJA1105_NUM_PORTS];
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 0fdc2d55fff6..2a9b8a6a5306 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -7,12 +7,16 @@
 
 #define SJA1105_SIZE_CGU_CMD	4
 
-struct sja1105_cfg_pad_mii_tx {
+/* Common structure for CFG_PAD_MIIx_RX and CFG_PAD_MIIx_TX */
+struct sja1105_cfg_pad_mii {
 	u64 d32_os;
+	u64 d32_ih;
 	u64 d32_ipud;
+	u64 d10_ih;
 	u64 d10_os;
 	u64 d10_ipud;
 	u64 ctrl_os;
+	u64 ctrl_ih;
 	u64 ctrl_ipud;
 	u64 clk_os;
 	u64 clk_ih;
@@ -338,16 +342,19 @@ static int sja1105_cgu_rgmii_tx_clk_config(struct sja1105_private *priv,
 
 /* AGU */
 static void
-sja1105_cfg_pad_mii_tx_packing(void *buf, struct sja1105_cfg_pad_mii_tx *cmd,
-			       enum packing_op op)
+sja1105_cfg_pad_mii_packing(void *buf, struct sja1105_cfg_pad_mii *cmd,
+			    enum packing_op op)
 {
 	const int size = 4;
 
 	sja1105_packing(buf, &cmd->d32_os,   28, 27, size, op);
+	sja1105_packing(buf, &cmd->d32_ih,   26, 26, size, op);
 	sja1105_packing(buf, &cmd->d32_ipud, 25, 24, size, op);
 	sja1105_packing(buf, &cmd->d10_os,   20, 19, size, op);
+	sja1105_packing(buf, &cmd->d10_ih,   18, 18, size, op);
 	sja1105_packing(buf, &cmd->d10_ipud, 17, 16, size, op);
 	sja1105_packing(buf, &cmd->ctrl_os,  12, 11, size, op);
+	sja1105_packing(buf, &cmd->ctrl_ih,  10, 10, size, op);
 	sja1105_packing(buf, &cmd->ctrl_ipud, 9,  8, size, op);
 	sja1105_packing(buf, &cmd->clk_os,    4,  3, size, op);
 	sja1105_packing(buf, &cmd->clk_ih,    2,  2, size, op);
@@ -358,7 +365,7 @@ static int sja1105_rgmii_cfg_pad_tx_config(struct sja1105_private *priv,
 					   int port)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
-	struct sja1105_cfg_pad_mii_tx pad_mii_tx;
+	struct sja1105_cfg_pad_mii pad_mii_tx = {0};
 	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
 
 	/* Payload */
@@ -375,12 +382,45 @@ static int sja1105_rgmii_cfg_pad_tx_config(struct sja1105_private *priv,
 	pad_mii_tx.clk_os    = 3; /* TX_CLK output stage */
 	pad_mii_tx.clk_ih    = 0; /* TX_CLK input hysteresis (default) */
 	pad_mii_tx.clk_ipud  = 2; /* TX_CLK input stage (default) */
-	sja1105_cfg_pad_mii_tx_packing(packed_buf, &pad_mii_tx, PACK);
+	sja1105_cfg_pad_mii_packing(packed_buf, &pad_mii_tx, PACK);
 
 	return sja1105_xfer_buf(priv, SPI_WRITE, regs->pad_mii_tx[port],
 				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
+static int sja1105_cfg_pad_rx_config(struct sja1105_private *priv, int port)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	struct sja1105_cfg_pad_mii pad_mii_rx = {0};
+	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
+
+	/* Payload */
+	pad_mii_rx.d32_ih    = 0; /* RXD[3:2] input stage hysteresis: */
+				  /*          non-Schmitt (default) */
+	pad_mii_rx.d32_ipud  = 2; /* RXD[3:2] input weak pull-up/down */
+				  /*          plain input (default) */
+	pad_mii_rx.d10_ih    = 0; /* RXD[1:0] input stage hysteresis: */
+				  /*          non-Schmitt (default) */
+	pad_mii_rx.d10_ipud  = 2; /* RXD[1:0] input weak pull-up/down */
+				  /*          plain input (default) */
+	pad_mii_rx.ctrl_ih   = 0; /* RX_DV/CRS_DV/RX_CTL and RX_ER */
+				  /* input stage hysteresis: */
+				  /* non-Schmitt (default) */
+	pad_mii_rx.ctrl_ipud = 3; /* RX_DV/CRS_DV/RX_CTL and RX_ER */
+				  /* input stage weak pull-up/down: */
+				  /* pull-down */
+	pad_mii_rx.clk_os    = 2; /* RX_CLK/RXC output stage: */
+				  /* medium noise/fast speed (default) */
+	pad_mii_rx.clk_ih    = 0; /* RX_CLK/RXC input hysteresis: */
+				  /* non-Schmitt (default) */
+	pad_mii_rx.clk_ipud  = 2; /* RX_CLK/RXC input pull-up/down: */
+				  /* plain input (default) */
+	sja1105_cfg_pad_mii_packing(packed_buf, &pad_mii_rx, PACK);
+
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->pad_mii_rx[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
+}
+
 static void
 sja1105_cfg_pad_mii_id_packing(void *buf, struct sja1105_cfg_pad_mii_id *cmd,
 			       enum packing_op op)
@@ -669,10 +709,14 @@ int sja1105_clocking_setup_port(struct sja1105_private *priv, int port)
 			phy_mode);
 		return -EINVAL;
 	}
-	if (rc)
+	if (rc) {
 		dev_err(dev, "Clocking setup for port %d failed: %d\n",
 			port, rc);
-	return rc;
+		return rc;
+	}
+
+	/* Internally pull down the RX_DV/CRS_DV/RX_CTL and RX_ER inputs */
+	return sja1105_cfg_pad_rx_config(priv, port);
 }
 
 int sja1105_clocking_setup(struct sja1105_private *priv)
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 04bdb72ae6b6..43f14a5c2718 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -443,6 +443,7 @@ static struct sja1105_regs sja1105et_regs = {
 	.rgu = 0x100440,
 	/* UM10944.pdf, Table 86, ACU Register overview */
 	.pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
+	.pad_mii_rx = {0x100801, 0x100803, 0x100805, 0x100807, 0x100809},
 	.rmii_pll1 = 0x10000A,
 	.cgu_idiv = {0x10000B, 0x10000C, 0x10000D, 0x10000E, 0x10000F},
 	.mac = {0x200, 0x202, 0x204, 0x206, 0x208},
@@ -475,6 +476,7 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.rgu = 0x100440,
 	/* UM10944.pdf, Table 86, ACU Register overview */
 	.pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
+	.pad_mii_rx = {0x100801, 0x100803, 0x100805, 0x100807, 0x100809},
 	.pad_mii_id = {0x100810, 0x100811, 0x100812, 0x100813, 0x100814},
 	.sgmii = 0x1F0000,
 	.rmii_pll1 = 0x10000A,
-- 
2.17.1

