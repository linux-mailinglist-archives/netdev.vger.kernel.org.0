Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5AC38E735
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhEXNQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbhEXNQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:16:16 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3597C06138A
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:47 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l1so41735840ejb.6
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b8ufLZLGeD7r6pYd/D3NLvhppdovFX0IZtWBx8C7mk4=;
        b=HKC1ZIKMy2i+ZzGpn50kAiwS4u1yY/1ua4dSHUsv7asZslhDnHGm9HT2Pb8qF04xi2
         e33wGmxSl7Ji6hz5fW0h9SDxu2nXxJ3HN3mD+hPbd9YCWG8O0nLkHeXMwLc0WlSl4RbA
         Q96tHuITQD+K/RXi7BO1Hpegm7ymk93CRP7jmmCQZF+W2MfFlLy2EpuwIbgTYbkMMlh2
         KIFYPF+789X1ikPHFVV7dNVePEjkawdph3n38/EOrwOeDuTXHHhwgBpTBlA4RsvgbZeq
         AlikIb0/FYwkbyFWn2PRl59r0MsahCTS8UWwRt3f/2MkBPQJg2mPTz6w25OrCXwcsTmv
         1M0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b8ufLZLGeD7r6pYd/D3NLvhppdovFX0IZtWBx8C7mk4=;
        b=n+xyVcxiHXZTdw8sE8upl64B0/MwriyXKbTt8B42ExL4J/0t1ikjqpulsnrOHp0o9S
         gBdVqlTI7iFAjZwGLlEy+7WsagUVxXFzE/CttzKqlOS+Ca/U0OuMMd6uudqXzGKTJ4bO
         usAGq25xSG5KrOsabqOwBC5iow5SmyN6rLrxI9DaWknnphbk0hxiHBsnGBSj//PX1Rca
         YhnW1etH/M08I0SKdM3nu9SVWWvzToUHTJq8knZff+AGxfXVcXGkDKq/pTTrgywrJ1Cf
         v6sNXlF3Woji7EVTzWSgnoGJW7Qb9B8ngR7jo9FcWshnJvFZBWRO3ktHK49k6b20Yd0r
         zFtA==
X-Gm-Message-State: AOAM5318H4OiY2F5FcvzSHBbD52GCSbAyp6bj4iVHgPK152WbuzDWMTj
        +8TS6PUAumV0CPTcOkjCL1DUaVUp3jY=
X-Google-Smtp-Source: ABdhPJxbBxiwR7QAxO2fX25Mz5O6dhxsXhrXav0KCZAbsjXOBsBTvri7xVGWqEEZ0JB56bfqmpaFcQ==
X-Received: by 2002:a17:907:1b19:: with SMTP id mp25mr22952742ejc.154.1621862086414;
        Mon, 24 May 2021 06:14:46 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm8009139ejz.24.2021.05.24.06.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:14:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 5/9] net: dsa: sja1105: skip CGU configuration if it's unnecessary
Date:   Mon, 24 May 2021 16:14:17 +0300
Message-Id: <20210524131421.1030789-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524131421.1030789-1-olteanv@gmail.com>
References: <20210524131421.1030789-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are two distinct code paths which enter sja1105_clocking.c, one
through sja1105_clocking_setup() and the other through
sja1105_clocking_setup_port():

sja1105_static_config_reload      sja1105_setup
              |                         |
              |      +------------------+
              |      |
              v      v
   sja1105_clocking_setup               sja1105_adjust_port_config
                 |                                   |
                 v                                   |
      sja1105_clocking_setup_port <------------------+

As opposed to SJA1105, the SJA1110 does not need any configuration of
the Clock Generation Unit in order for xMII ports to work. Just RGMII
internal delays need to be configured, and that is done inside
sja1105_clocking_setup_port for the RGMII ports.

So this patch introduces the concept of a "reserved address", which the
CGU configuration functions from sja1105_clocking.c must check before
proceeding to do anything. The SJA1110 will have reserved addresses for
the CGU PLLs for MII/RMII/RGMII.

Additionally, make sja1105_clocking_setup() a function pointer so it can
be overridden by the SJA1110. Even though nothing port-related needs to
be done in the CGU, there are some operations such as disabling the
watchdog clock which are unique to the SJA1110.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h             |  1 +
 drivers/net/dsa/sja1105/sja1105_clocking.c    | 33 +++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_main.c        |  4 +--
 drivers/net/dsa/sja1105/sja1105_spi.c         |  6 ++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  2 ++
 5 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 3737a3b38863..47cad24e6af0 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -109,6 +109,7 @@ struct sja1105_info {
 			   const unsigned char *addr, u16 vid);
 	void (*ptp_cmd_packing)(u8 *buf, struct sja1105_ptp_cmd *cmd,
 				enum packing_op op);
+	int (*clocking_setup)(struct sja1105_private *priv);
 	const char *name;
 };
 
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index f54b4d03a002..4697ac064abc 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -110,6 +110,9 @@ static int sja1105_cgu_idiv_config(struct sja1105_private *priv, int port,
 	struct sja1105_cgu_idiv idiv;
 	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
 
+	if (regs->cgu_idiv[port] == SJA1105_RSV_ADDR)
+		return 0;
+
 	if (enabled && factor != 1 && factor != 10) {
 		dev_err(dev, "idiv factor must be 1 or 10\n");
 		return -ERANGE;
@@ -159,6 +162,9 @@ static int sja1105_cgu_mii_tx_clk_config(struct sja1105_private *priv,
 	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
 	int clksrc;
 
+	if (regs->mii_tx_clk[port] == SJA1105_RSV_ADDR)
+		return 0;
+
 	if (role == XMII_MAC)
 		clksrc = mac_clk_sources[port];
 	else
@@ -188,6 +194,9 @@ sja1105_cgu_mii_rx_clk_config(struct sja1105_private *priv, int port)
 		CLKSRC_MII4_RX_CLK,
 	};
 
+	if (regs->mii_rx_clk[port] == SJA1105_RSV_ADDR)
+		return 0;
+
 	/* Payload for packed_buf */
 	mii_rx_clk.clksrc    = clk_sources[port];
 	mii_rx_clk.autoblock = 1;  /* Autoblock clk while changing clksrc */
@@ -212,6 +221,9 @@ sja1105_cgu_mii_ext_tx_clk_config(struct sja1105_private *priv, int port)
 		CLKSRC_IDIV4,
 	};
 
+	if (regs->mii_ext_tx_clk[port] == SJA1105_RSV_ADDR)
+		return 0;
+
 	/* Payload for packed_buf */
 	mii_ext_tx_clk.clksrc    = clk_sources[port];
 	mii_ext_tx_clk.autoblock = 1; /* Autoblock clk while changing clksrc */
@@ -236,6 +248,9 @@ sja1105_cgu_mii_ext_rx_clk_config(struct sja1105_private *priv, int port)
 		CLKSRC_IDIV4,
 	};
 
+	if (regs->mii_ext_rx_clk[port] == SJA1105_RSV_ADDR)
+		return 0;
+
 	/* Payload for packed_buf */
 	mii_ext_rx_clk.clksrc    = clk_sources[port];
 	mii_ext_rx_clk.autoblock = 1; /* Autoblock clk while changing clksrc */
@@ -320,6 +335,9 @@ static int sja1105_cgu_rgmii_tx_clk_config(struct sja1105_private *priv,
 	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
 	int clksrc;
 
+	if (regs->rgmii_tx_clk[port] == SJA1105_RSV_ADDR)
+		return 0;
+
 	if (speed == SJA1105_SPEED_1000MBPS) {
 		clksrc = CLKSRC_PLL0;
 	} else {
@@ -368,6 +386,9 @@ static int sja1105_rgmii_cfg_pad_tx_config(struct sja1105_private *priv,
 	struct sja1105_cfg_pad_mii pad_mii_tx = {0};
 	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
 
+	if (regs->pad_mii_tx[port] == SJA1105_RSV_ADDR)
+		return 0;
+
 	/* Payload */
 	pad_mii_tx.d32_os    = 3; /* TXD[3:2] output stage: */
 				  /*          high noise/high speed */
@@ -394,6 +415,9 @@ static int sja1105_cfg_pad_rx_config(struct sja1105_private *priv, int port)
 	struct sja1105_cfg_pad_mii pad_mii_rx = {0};
 	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
 
+	if (regs->pad_mii_rx[port] == SJA1105_RSV_ADDR)
+		return 0;
+
 	/* Payload */
 	pad_mii_rx.d32_ih    = 0; /* RXD[3:2] input stage hysteresis: */
 				  /*          non-Schmitt (default) */
@@ -572,6 +596,9 @@ static int sja1105_cgu_rmii_ref_clk_config(struct sja1105_private *priv,
 		CLKSRC_MII4_TX_CLK,
 	};
 
+	if (regs->rmii_ref_clk[port] == SJA1105_RSV_ADDR)
+		return 0;
+
 	/* Payload for packed_buf */
 	ref_clk.clksrc    = clk_sources[port];
 	ref_clk.autoblock = 1;      /* Autoblock clk while changing clksrc */
@@ -589,6 +616,9 @@ sja1105_cgu_rmii_ext_tx_clk_config(struct sja1105_private *priv, int port)
 	struct sja1105_cgu_mii_ctrl ext_tx_clk;
 	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
 
+	if (regs->rmii_ext_tx_clk[port] == SJA1105_RSV_ADDR)
+		return 0;
+
 	/* Payload for packed_buf */
 	ext_tx_clk.clksrc    = CLKSRC_PLL1;
 	ext_tx_clk.autoblock = 1;   /* Autoblock clk while changing clksrc */
@@ -607,6 +637,9 @@ static int sja1105_cgu_rmii_pll_config(struct sja1105_private *priv)
 	struct device *dev = priv->ds->dev;
 	int rc;
 
+	if (regs->rmii_pll1 == SJA1105_RSV_ADDR)
+		return 0;
+
 	/* PLL1 must be enabled and output 50 Mhz.
 	 * This is done by writing first 0x0A010941 to
 	 * the PLL_1_C register and then deasserting
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4a81b1b1cef3..1d2fcfa0f48f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1938,7 +1938,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	 * For these interfaces there is no dynamic configuration
 	 * needed, since PLLs have same settings at all speeds.
 	 */
-	rc = sja1105_clocking_setup(priv);
+	rc = priv->info->clocking_setup(priv);
 	if (rc < 0)
 		goto out;
 
@@ -3017,7 +3017,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 		return rc;
 	}
 	/* Configure the CGU (PHY link modes and speeds) */
-	rc = sja1105_clocking_setup(priv);
+	rc = priv->info->clocking_setup(priv);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to configure MII clocking: %d\n", rc);
 		return rc;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index f22340e77fd5..c08aa6fbd85d 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -489,6 +489,7 @@ const struct sja1105_info sja1105e_info = {
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
+	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105E",
 };
@@ -507,6 +508,7 @@ const struct sja1105_info sja1105t_info = {
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
+	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105T",
 };
@@ -526,6 +528,7 @@ const struct sja1105_info sja1105p_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105P",
 };
@@ -545,6 +548,7 @@ const struct sja1105_info sja1105q_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105Q",
 };
@@ -564,6 +568,7 @@ const struct sja1105_info sja1105r_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105R",
 };
@@ -584,5 +589,6 @@ const struct sja1105_info sja1105s_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.clocking_setup		= sja1105_clocking_setup,
 	.name			= "SJA1105S",
 };
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 779eb6840f05..9bc783a2bbea 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -129,6 +129,8 @@ enum sja1105_blk_idx {
 #define SJA1105R_PART_NO				0x9A86
 #define SJA1105S_PART_NO				0x9A87
 
+#define SJA1105_RSV_ADDR		0xffffffffffffffffull
+
 struct sja1105_schedule_entry {
 	u64 winstindex;
 	u64 winend;
-- 
2.25.1

