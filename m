Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA5C391951
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhEZN5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbhEZN5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:36 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A94C061756
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:04 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h16so1618984edr.6
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1WazJaW3yUqBduwaZ6g9b034ysTaCm3Bdh3Dfvp6sHk=;
        b=kjCGUbfKHJPp7dNiXuz3QDoU9SVa8iyHIGX18o/6UE0Lcz6ZQL9by2XKDkFLlwBcpv
         tJKAsyjepQuFoU0AExYRGmKwS25Vr+KPwCNEEfJ/MedBJESjnq59oMtxKvHBUAANCE+6
         M2mB43mlNLxQf921D3pRz6j33o/oNYTzrrrDmsIqzL0uCcGKlvU+ABAQIu+QFuqBPKq9
         lnPrvC+OCN9+7QyJ444/MvyQq46Tt7+SaMyC4sJy3dE+3NL/q8KBNMOdOQH9ykhPa8lg
         Zd8TniDBmCBtJjdhO8wZ4MMbDr77NcVEAanxXKmr/JqZ8Uo3S1EgI54HncYabQC1J731
         TIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1WazJaW3yUqBduwaZ6g9b034ysTaCm3Bdh3Dfvp6sHk=;
        b=qRFPX0lt+hL3Y2N4LAOyOv5RmEwpAtfyQJbAYg6hgoNvXxhulQvzaA93oUQFdvhWaJ
         ViawfJGdxdsDNQh3uMx+lTGW/BxqyrypHpTSzKeGXok9KFUF20MnI6l8ZeEqexOlulwg
         VkrcgdUS0p+aRqbzTwX3Rmd3KDmtls3PlWuHDW7834v0aOTUHUhnNKapR64oWDTLIy2v
         Cr8mkhsu1aPbVbMAANSAB27tjPNL/ZBCsUWeMCgaClLbuE6JzQT3OKzKSECuSXUU33IM
         gXxfGa89onJuEDg+072P/9J5sVO+rl0Gc+McZvtRaiqFWW50LplQhbdBFAlZHWQPCR2B
         ANuQ==
X-Gm-Message-State: AOAM530HGXaG49YKdY6MeKY5n6eTOUSMuI8PJis/jiWimRWYsbLbrvQR
        GWtD18G+BEEURn6wCV6GP+Pulh17uQg=
X-Google-Smtp-Source: ABdhPJwlmqZOYtjmHMcR7foFED2igU7TSwVy2Q2d/KyCsV1ruR4XasCD+NGSNQ6M+huJBb64lm3cUQ==
X-Received: by 2002:a05:6402:14d2:: with SMTP id f18mr1079502edx.259.1622037362298;
        Wed, 26 May 2021 06:56:02 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k11sm10508476ejc.94.2021.05.26.06.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:56:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH v2 linux-next 11/14] net: dsa: sja1105: add support for the SJA1110 switch family
Date:   Wed, 26 May 2021 16:55:32 +0300
Message-Id: <20210526135535.2515123-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SJA1110 is basically an SJA1105 with more ports, some integrated
PHYs (100base-T1 and 100base-TX) and an embedded microcontroller which
can be disabled, and the switch core can be controlled by a host running
Linux, over SPI.

This patch contains:
- the static and dynamic config packing functions, for the tables that
  are common with SJA1105
- one more static config tables which is "unique" to the SJA1110
  (actually it is a rehash of stuff that was placed somewhere else in
  SJA1105): the PCP Remapping Table
- a reset and clock configuration procedure for the SJA1110 switch.
  This resets just the switch subsystem, and gates off the clock which
  powers on the embedded microcontroller.
- an RGMII delay configuration procedure for SJA1110, which is very
  similar to SJA1105, but different enough for us to be unable to reuse
  it (this is a pattern that repeats itself)
- some adaptations to dynamic config table entries which are no longer
  programmed in the same way. For example, to delete a VLAN, you used to
  write an entry through the dynamic reconfiguration interface with the
  desired VLAN ID, and with the VALIDENT bit set to false. Now, the VLAN
  table entries contain a TYPE_ENTRY field, which must be set to zero
  (in a backwards-incompatible way) in order for the entry to be deleted,
  or to some other entry for the VLAN to match "inner tagged" or "outer
  tagged" packets.
- a similar thing for the static config: the xMII Mode Parameters Table
  encoding for SGMII and MII (the latter just when attached to a
  100base-TX PHY) just isn't what it used to be in SJA1105. They are
  identical, except there is an extra "special" bit which needs to be
  set. Set it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105.h             |  24 +-
 drivers/net/dsa/sja1105/sja1105_clocking.c    |  91 ++++
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 321 +++++++++++-
 .../net/dsa/sja1105/sja1105_dynamic_config.h  |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c        |  55 +-
 drivers/net/dsa/sja1105/sja1105_spi.c         | 252 +++++++++
 .../net/dsa/sja1105/sja1105_static_config.c   | 483 ++++++++++++++++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  98 +++-
 8 files changed, 1313 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 867cda832e77..8bfda8c7bc1f 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -13,15 +13,12 @@
 #include <linux/mutex.h>
 #include "sja1105_static_config.h"
 
-#define SJA1105_NUM_PORTS		5
-#define SJA1105_MAX_NUM_PORTS		SJA1105_NUM_PORTS
-#define SJA1105_NUM_TC			8
 #define SJA1105ET_FDB_BIN_SIZE		4
 /* The hardware value is in multiples of 10 ms.
  * The passed parameter is in multiples of 1 ms.
  */
 #define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
-#define SJA1105_NUM_L2_POLICERS		45
+#define SJA1105_NUM_L2_POLICERS		SJA1110_MAX_L2_POLICING_COUNT
 
 typedef enum {
 	SPI_READ = 0,
@@ -99,6 +96,7 @@ struct sja1105_info {
 	int ptpegr_ts_bytes;
 	int num_cbs_shapers;
 	int max_frame_mem;
+	int num_ports;
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
@@ -309,6 +307,10 @@ extern const struct sja1105_info sja1105p_info;
 extern const struct sja1105_info sja1105q_info;
 extern const struct sja1105_info sja1105r_info;
 extern const struct sja1105_info sja1105s_info;
+extern const struct sja1105_info sja1110a_info;
+extern const struct sja1105_info sja1110b_info;
+extern const struct sja1105_info sja1110c_info;
+extern const struct sja1105_info sja1110d_info;
 
 /* From sja1105_clocking.c */
 
@@ -325,8 +327,10 @@ typedef enum {
 } sja1105_phy_interface_t;
 
 int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port);
+int sja1110_setup_rgmii_delay(const void *ctx, int port);
 int sja1105_clocking_setup_port(struct sja1105_private *priv, int port);
 int sja1105_clocking_setup(struct sja1105_private *priv);
+int sja1110_clocking_setup(struct sja1105_private *priv);
 
 /* From sja1105_ethtool.c */
 void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data);
@@ -347,6 +351,18 @@ enum sja1105_iotag {
 	SJA1105_S_TAG = 1, /* Outer VLAN header */
 };
 
+enum sja1110_vlan_type {
+	SJA1110_VLAN_INVALID = 0,
+	SJA1110_VLAN_C_TAG = 1, /* Single inner VLAN tag */
+	SJA1110_VLAN_S_TAG = 2, /* Single outer VLAN tag */
+	SJA1110_VLAN_D_TAG = 3, /* Double tagged, use outer tag for lookup */
+};
+
+enum sja1110_shaper_type {
+	SJA1110_LEAKY_BUCKET_SHAPER = 0,
+	SJA1110_CBS_SHAPER = 1,
+};
+
 u8 sja1105et_fdb_hash(struct sja1105_private *priv, const u8 *addr, u16 vid);
 int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 		      const unsigned char *addr, u16 vid);
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index ae297648611f..645edea5a81f 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -6,6 +6,7 @@
 #include "sja1105.h"
 
 #define SJA1105_SIZE_CGU_CMD	4
+#define SJA1110_BASE_TIMER_CLK	SJA1110_CGU_ADDR(0x74)
 
 /* Common structure for CFG_PAD_MIIx_RX and CFG_PAD_MIIx_TX */
 struct sja1105_cfg_pad_mii {
@@ -61,6 +62,12 @@ struct sja1105_cgu_pll_ctrl {
 	u64 pd;
 };
 
+struct sja1110_cgu_outclk {
+	u64 clksrc;
+	u64 autoblock;
+	u64 pd;
+};
+
 enum {
 	CLKSRC_MII0_TX_CLK	= 0x00,
 	CLKSRC_MII0_RX_CLK	= 0x01,
@@ -461,6 +468,35 @@ sja1105_cfg_pad_mii_id_packing(void *buf, struct sja1105_cfg_pad_mii_id *cmd,
 	sja1105_packing(buf, &cmd->txc_pd,          0,  0, size, op);
 }
 
+static void
+sja1110_cfg_pad_mii_id_packing(void *buf, struct sja1105_cfg_pad_mii_id *cmd,
+			       enum packing_op op)
+{
+	const int size = SJA1105_SIZE_CGU_CMD;
+	u64 range = 4;
+
+	/* Fields RXC_RANGE and TXC_RANGE select the input frequency range:
+	 * 0 = 2.5MHz
+	 * 1 = 25MHz
+	 * 2 = 50MHz
+	 * 3 = 125MHz
+	 * 4 = Automatically determined by port speed.
+	 * There's no point in defining a structure different than the one for
+	 * SJA1105, so just hardcode the frequency range to automatic, just as
+	 * before.
+	 */
+	sja1105_packing(buf, &cmd->rxc_stable_ovr, 26, 26, size, op);
+	sja1105_packing(buf, &cmd->rxc_delay,      25, 21, size, op);
+	sja1105_packing(buf, &range,               20, 18, size, op);
+	sja1105_packing(buf, &cmd->rxc_bypass,     17, 17, size, op);
+	sja1105_packing(buf, &cmd->rxc_pd,         16, 16, size, op);
+	sja1105_packing(buf, &cmd->txc_stable_ovr, 10, 10, size, op);
+	sja1105_packing(buf, &cmd->txc_delay,       9,  5, size, op);
+	sja1105_packing(buf, &range,                4,  2, size, op);
+	sja1105_packing(buf, &cmd->txc_bypass,      1,  1, size, op);
+	sja1105_packing(buf, &cmd->txc_pd,          0,  0, size, op);
+}
+
 /* Valid range in degrees is an integer between 73.8 and 101.7 */
 static u64 sja1105_rgmii_delay(u64 phase)
 {
@@ -519,6 +555,35 @@ int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port)
 				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
+int sja1110_setup_rgmii_delay(const void *ctx, int port)
+{
+	const struct sja1105_private *priv = ctx;
+	const struct sja1105_regs *regs = priv->info->regs;
+	struct sja1105_cfg_pad_mii_id pad_mii_id = {0};
+	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
+
+	pad_mii_id.rxc_pd = 1;
+	pad_mii_id.txc_pd = 1;
+
+	if (priv->rgmii_rx_delay[port]) {
+		pad_mii_id.rxc_delay = sja1105_rgmii_delay(90);
+		/* The "BYPASS" bit in SJA1110 is actually a "don't bypass" */
+		pad_mii_id.rxc_bypass = 1;
+		pad_mii_id.rxc_pd = 0;
+	}
+
+	if (priv->rgmii_tx_delay[port]) {
+		pad_mii_id.txc_delay = sja1105_rgmii_delay(90);
+		pad_mii_id.txc_bypass = 1;
+		pad_mii_id.txc_pd = 0;
+	}
+
+	sja1110_cfg_pad_mii_id_packing(packed_buf, &pad_mii_id, PACK);
+
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->pad_mii_id[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
+}
+
 static int sja1105_rgmii_clocking_setup(struct sja1105_private *priv, int port,
 					sja1105_mii_role_t role)
 {
@@ -755,3 +820,29 @@ int sja1105_clocking_setup(struct sja1105_private *priv)
 	}
 	return 0;
 }
+
+static void
+sja1110_cgu_outclk_packing(void *buf, struct sja1110_cgu_outclk *outclk,
+			   enum packing_op op)
+{
+	const int size = 4;
+
+	sja1105_packing(buf, &outclk->clksrc,    27, 24, size, op);
+	sja1105_packing(buf, &outclk->autoblock, 11, 11, size, op);
+	sja1105_packing(buf, &outclk->pd,         0,  0, size, op);
+}
+
+/* Power down the BASE_TIMER_CLK in order to disable the watchdog */
+int sja1110_clocking_setup(struct sja1105_private *priv)
+{
+	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
+	struct sja1110_cgu_outclk outclk_7_c = {
+		.clksrc = 0x5,
+		.pd = true,
+	};
+
+	sja1110_cgu_outclk_packing(packed_buf, &outclk_7_c, PACK);
+
+	return sja1105_xfer_buf(priv, SPI_WRITE, SJA1110_BASE_TIMER_CLK,
+				packed_buf, SJA1105_SIZE_CGU_CMD);
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index ff2742f53de3..031a4a6c76b0 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -106,6 +106,9 @@
 #define SJA1105PQRS_SIZE_VL_LOOKUP_DYN_CMD			\
 	(SJA1105_SIZE_DYN_CMD + SJA1105_SIZE_VL_LOOKUP_ENTRY)
 
+#define SJA1110_SIZE_VL_POLICING_DYN_CMD			\
+	(SJA1105_SIZE_DYN_CMD + SJA1105_SIZE_VL_POLICING_ENTRY)
+
 #define SJA1105ET_SIZE_MAC_CONFIG_DYN_ENTRY			\
 	SJA1105_SIZE_DYN_CMD
 
@@ -115,9 +118,15 @@
 #define SJA1105PQRS_SIZE_L2_LOOKUP_DYN_CMD			\
 	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY)
 
+#define SJA1110_SIZE_L2_LOOKUP_DYN_CMD				\
+	(SJA1105_SIZE_DYN_CMD + SJA1110_SIZE_L2_LOOKUP_ENTRY)
+
 #define SJA1105_SIZE_VLAN_LOOKUP_DYN_CMD			\
 	(SJA1105_SIZE_DYN_CMD + 4 + SJA1105_SIZE_VLAN_LOOKUP_ENTRY)
 
+#define SJA1110_SIZE_VLAN_LOOKUP_DYN_CMD			\
+	(SJA1105_SIZE_DYN_CMD + SJA1110_SIZE_VLAN_LOOKUP_ENTRY)
+
 #define SJA1105_SIZE_L2_FORWARDING_DYN_CMD			\
 	(SJA1105_SIZE_DYN_CMD + SJA1105_SIZE_L2_FORWARDING_ENTRY)
 
@@ -133,12 +142,18 @@
 #define SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_DYN_CMD		\
 	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_ENTRY)
 
+#define SJA1110_SIZE_L2_LOOKUP_PARAMS_DYN_CMD		\
+	(SJA1105_SIZE_DYN_CMD + SJA1110_SIZE_L2_LOOKUP_PARAMS_ENTRY)
+
 #define SJA1105ET_SIZE_GENERAL_PARAMS_DYN_CMD			\
 	SJA1105_SIZE_DYN_CMD
 
 #define SJA1105PQRS_SIZE_GENERAL_PARAMS_DYN_CMD			\
 	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY)
 
+#define SJA1110_SIZE_GENERAL_PARAMS_DYN_CMD			\
+	(SJA1105_SIZE_DYN_CMD + SJA1110_SIZE_GENERAL_PARAMS_ENTRY)
+
 #define SJA1105PQRS_SIZE_AVB_PARAMS_DYN_CMD			\
 	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY)
 
@@ -151,8 +166,17 @@
 #define SJA1105PQRS_SIZE_CBS_DYN_CMD				\
 	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_CBS_ENTRY)
 
+#define SJA1110_SIZE_XMII_PARAMS_DYN_CMD			\
+	SJA1110_SIZE_XMII_PARAMS_ENTRY
+
+#define SJA1110_SIZE_L2_POLICING_DYN_CMD			\
+	(SJA1105_SIZE_DYN_CMD + SJA1105_SIZE_L2_POLICING_ENTRY)
+
+#define SJA1110_SIZE_L2_FORWARDING_PARAMS_DYN_CMD		\
+	SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY
+
 #define SJA1105_MAX_DYN_CMD_SIZE				\
-	SJA1105PQRS_SIZE_GENERAL_PARAMS_DYN_CMD
+	SJA1110_SIZE_GENERAL_PARAMS_DYN_CMD
 
 struct sja1105_dyn_cmd {
 	bool search;
@@ -197,6 +221,19 @@ sja1105pqrs_vl_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	sja1105_packing(p, &cmd->index,    9,  0, size, op);
 }
 
+static void
+sja1110_vl_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+			      enum packing_op op)
+{
+	u8 *p = buf + SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+	sja1105_packing(p, &cmd->errors,  29, 29, size, op);
+	sja1105_packing(p, &cmd->index,   11,  0, size, op);
+}
+
 static size_t sja1105et_vl_lookup_entry_packing(void *buf, void *entry_ptr,
 						enum packing_op op)
 {
@@ -208,6 +245,18 @@ static size_t sja1105et_vl_lookup_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+static void
+sja1110_vl_policing_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				enum packing_op op)
+{
+	u8 *p = buf + SJA1105_SIZE_VL_LOOKUP_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+	sja1105_packing(p, &cmd->index,   11,  0, size, op);
+}
+
 static void
 sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				  enum packing_op op)
@@ -326,6 +375,18 @@ sja1105pqrs_dyn_l2_lookup_entry_packing(void *buf, void *entry_ptr,
 	return sja1105pqrs_l2_lookup_entry_packing(buf, entry_ptr, op);
 }
 
+static size_t sja1110_dyn_l2_lookup_entry_packing(void *buf, void *entry_ptr,
+						  enum packing_op op)
+{
+	struct sja1105_l2_lookup_entry *entry = entry_ptr;
+	u8 *cmd = buf + SJA1110_SIZE_L2_LOOKUP_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(cmd, &entry->lockeds, 28, 28, size, op);
+
+	return sja1110_l2_lookup_entry_packing(buf, entry_ptr, op);
+}
+
 static void
 sja1105et_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				enum packing_op op)
@@ -437,6 +498,39 @@ sja1105_vlan_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 			SJA1105_SIZE_VLAN_LOOKUP_ENTRY, op);
 }
 
+/* In SJA1110 there is no gap between the command and the data, yay... */
+static void
+sja1110_vlan_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				enum packing_op op)
+{
+	u8 *p = buf + SJA1110_SIZE_VLAN_LOOKUP_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+	u64 type_entry = 0;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+	sja1105_packing(p, &cmd->errors,  29, 29, size, op);
+	/* Hack: treat 'vlanid' field of struct sja1105_vlan_lookup_entry as
+	 * cmd->index.
+	 */
+	sja1105_packing(buf, &cmd->index, 38, 27,
+			SJA1110_SIZE_VLAN_LOOKUP_ENTRY, op);
+
+	/* But the VALIDENT bit has disappeared, now we are supposed to
+	 * invalidate an entry through the TYPE_ENTRY field of the entry..
+	 * This is a hack to transform the non-zero quality of the TYPE_ENTRY
+	 * field into a VALIDENT bit.
+	 */
+	if (op == PACK && !cmd->valident) {
+		sja1105_packing(buf, &type_entry, 40, 39,
+				SJA1110_SIZE_VLAN_LOOKUP_ENTRY, PACK);
+	} else if (op == UNPACK) {
+		sja1105_packing(buf, &type_entry, 40, 39,
+				SJA1110_SIZE_VLAN_LOOKUP_ENTRY, UNPACK);
+		cmd->valident = !!type_entry;
+	}
+}
+
 static void
 sja1105_l2_forwarding_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				  enum packing_op op)
@@ -450,6 +544,19 @@ sja1105_l2_forwarding_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	sja1105_packing(p, &cmd->index,    4,  0, size, op);
 }
 
+static void
+sja1110_l2_forwarding_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				  enum packing_op op)
+{
+	u8 *p = buf + SJA1105_SIZE_L2_FORWARDING_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+	sja1105_packing(p, &cmd->errors,  29, 29, size, op);
+	sja1105_packing(p, &cmd->index,    4,  0, size, op);
+}
+
 static void
 sja1105et_mac_config_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				 enum packing_op op)
@@ -504,6 +611,19 @@ sja1105pqrs_mac_config_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	sja1105_packing(p, &cmd->index,    2,  0, size, op);
 }
 
+static void
+sja1110_mac_config_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+			       enum packing_op op)
+{
+	u8 *p = buf + SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+	sja1105_packing(p, &cmd->errors,  29, 29, size, op);
+	sja1105_packing(p, &cmd->index,    3,  0, size, op);
+}
+
 static void
 sja1105et_l2_lookup_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				       enum packing_op op)
@@ -536,6 +656,18 @@ sja1105pqrs_l2_lookup_params_cmd_packing(void *buf,
 	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
 }
 
+static void
+sja1110_l2_lookup_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				     enum packing_op op)
+{
+	u8 *p = buf + SJA1110_SIZE_L2_LOOKUP_PARAMS_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+	sja1105_packing(p, &cmd->errors,  29, 29, size, op);
+}
+
 static void
 sja1105et_general_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				     enum packing_op op)
@@ -570,6 +702,18 @@ sja1105pqrs_general_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	sja1105_packing(p, &cmd->rdwrset, 28, 28, size, op);
 }
 
+static void
+sja1110_general_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				   enum packing_op op)
+{
+	u8 *p = buf + SJA1110_SIZE_GENERAL_PARAMS_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+	sja1105_packing(p, &cmd->errors,  29, 29, size, op);
+}
+
 static void
 sja1105pqrs_avb_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				   enum packing_op op)
@@ -596,6 +740,20 @@ sja1105_retagging_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	sja1105_packing(p, &cmd->index,     5,  0, size, op);
 }
 
+static void
+sja1110_retagging_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+			      enum packing_op op)
+{
+	u8 *p = buf + SJA1105_SIZE_RETAGGING_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,    31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset,  30, 30, size, op);
+	sja1105_packing(p, &cmd->errors,   29, 29, size, op);
+	sja1105_packing(p, &cmd->valident, 28, 28, size, op);
+	sja1105_packing(p, &cmd->index,     4,  0, size, op);
+}
+
 static void sja1105et_cbs_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				      enum packing_op op)
 {
@@ -635,6 +793,18 @@ static void sja1105pqrs_cbs_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	sja1105_packing(p, &cmd->index,    3,  0, size, op);
 }
 
+static void sja1110_cbs_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				    enum packing_op op)
+{
+	u8 *p = buf + SJA1105PQRS_SIZE_CBS_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+	sja1105_packing(p, &cmd->errors,  29, 29, size, op);
+	sja1105_packing(p, &cmd->index,    7,  0, size, op);
+}
+
 static size_t sja1105pqrs_cbs_entry_packing(void *buf, void *entry_ptr,
 					    enum packing_op op)
 {
@@ -650,6 +820,39 @@ static size_t sja1105pqrs_cbs_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+static size_t sja1110_cbs_entry_packing(void *buf, void *entry_ptr,
+					enum packing_op op)
+{
+	const size_t size = SJA1105PQRS_SIZE_CBS_ENTRY;
+	struct sja1105_cbs_entry *entry = entry_ptr;
+	u64 entry_type = SJA1110_CBS_SHAPER;
+
+	sja1105_packing(buf, &entry_type,       159, 159, size, op);
+	sja1105_packing(buf, &entry->credit_lo, 151, 120, size, op);
+	sja1105_packing(buf, &entry->credit_hi, 119,  88, size, op);
+	sja1105_packing(buf, &entry->send_slope, 87,  56, size, op);
+	sja1105_packing(buf, &entry->idle_slope, 55,  24, size, op);
+	return size;
+}
+
+static void sja1110_dummy_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				      enum packing_op op)
+{
+}
+
+static void
+sja1110_l2_policing_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				enum packing_op op)
+{
+	u8 *p = buf + SJA1105_SIZE_L2_POLICING_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+	sja1105_packing(p, &cmd->errors,  29, 29, size, op);
+	sja1105_packing(p, &cmd->index,    6,  0, size, op);
+}
+
 #define OP_READ		BIT(0)
 #define OP_WRITE	BIT(1)
 #define OP_DEL		BIT(2)
@@ -832,6 +1035,122 @@ const struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	},
 };
 
+/* SJA1110: Third generation */
+const struct sja1105_dynamic_table_ops sja1110_dyn_ops[BLK_IDX_MAX_DYN] = {
+	[BLK_IDX_VL_LOOKUP] = {
+		.entry_packing = sja1110_vl_lookup_entry_packing,
+		.cmd_packing = sja1110_vl_lookup_cmd_packing,
+		.access = (OP_READ | OP_WRITE | OP_VALID_ANYWAY),
+		.max_entry_count = SJA1110_MAX_VL_LOOKUP_COUNT,
+		.packed_size = SJA1105PQRS_SIZE_VL_LOOKUP_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0x124),
+	},
+	[BLK_IDX_VL_POLICING] = {
+		.entry_packing = sja1110_vl_policing_entry_packing,
+		.cmd_packing = sja1110_vl_policing_cmd_packing,
+		.access = (OP_READ | OP_WRITE | OP_VALID_ANYWAY),
+		.max_entry_count = SJA1110_MAX_VL_POLICING_COUNT,
+		.packed_size = SJA1110_SIZE_VL_POLICING_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0x310),
+	},
+	[BLK_IDX_L2_LOOKUP] = {
+		.entry_packing = sja1110_dyn_l2_lookup_entry_packing,
+		.cmd_packing = sja1105pqrs_l2_lookup_cmd_packing,
+		.access = (OP_READ | OP_WRITE | OP_DEL | OP_SEARCH),
+		.max_entry_count = SJA1105_MAX_L2_LOOKUP_COUNT,
+		.packed_size = SJA1110_SIZE_L2_LOOKUP_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0x8c),
+	},
+	[BLK_IDX_VLAN_LOOKUP] = {
+		.entry_packing = sja1110_vlan_lookup_entry_packing,
+		.cmd_packing = sja1110_vlan_lookup_cmd_packing,
+		.access = (OP_READ | OP_WRITE | OP_DEL),
+		.max_entry_count = SJA1105_MAX_VLAN_LOOKUP_COUNT,
+		.packed_size = SJA1110_SIZE_VLAN_LOOKUP_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0xb4),
+	},
+	[BLK_IDX_L2_FORWARDING] = {
+		.entry_packing = sja1110_l2_forwarding_entry_packing,
+		.cmd_packing = sja1110_l2_forwarding_cmd_packing,
+		.max_entry_count = SJA1110_MAX_L2_FORWARDING_COUNT,
+		.access = (OP_READ | OP_WRITE | OP_VALID_ANYWAY),
+		.packed_size = SJA1105_SIZE_L2_FORWARDING_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0xa8),
+	},
+	[BLK_IDX_MAC_CONFIG] = {
+		.entry_packing = sja1110_mac_config_entry_packing,
+		.cmd_packing = sja1110_mac_config_cmd_packing,
+		.max_entry_count = SJA1110_MAX_MAC_CONFIG_COUNT,
+		.access = (OP_READ | OP_WRITE | OP_VALID_ANYWAY),
+		.packed_size = SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0x134),
+	},
+	[BLK_IDX_L2_LOOKUP_PARAMS] = {
+		.entry_packing = sja1110_l2_lookup_params_entry_packing,
+		.cmd_packing = sja1110_l2_lookup_params_cmd_packing,
+		.max_entry_count = SJA1105_MAX_L2_LOOKUP_PARAMS_COUNT,
+		.access = (OP_READ | OP_WRITE | OP_VALID_ANYWAY),
+		.packed_size = SJA1110_SIZE_L2_LOOKUP_PARAMS_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0x158),
+	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.entry_packing = sja1105pqrs_avb_params_entry_packing,
+		.cmd_packing = sja1105pqrs_avb_params_cmd_packing,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+		.access = (OP_READ | OP_WRITE | OP_VALID_ANYWAY),
+		.packed_size = SJA1105PQRS_SIZE_AVB_PARAMS_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0x2000C),
+	},
+	[BLK_IDX_GENERAL_PARAMS] = {
+		.entry_packing = sja1110_general_params_entry_packing,
+		.cmd_packing = sja1110_general_params_cmd_packing,
+		.max_entry_count = SJA1105_MAX_GENERAL_PARAMS_COUNT,
+		.access = (OP_READ | OP_WRITE | OP_VALID_ANYWAY),
+		.packed_size = SJA1110_SIZE_GENERAL_PARAMS_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0xe8),
+	},
+	[BLK_IDX_RETAGGING] = {
+		.entry_packing = sja1110_retagging_entry_packing,
+		.cmd_packing = sja1110_retagging_cmd_packing,
+		.max_entry_count = SJA1105_MAX_RETAGGING_COUNT,
+		.access = (OP_READ | OP_WRITE | OP_DEL),
+		.packed_size = SJA1105_SIZE_RETAGGING_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0xdc0),
+	},
+	[BLK_IDX_CBS] = {
+		.entry_packing = sja1110_cbs_entry_packing,
+		.cmd_packing = sja1110_cbs_cmd_packing,
+		.max_entry_count = SJA1110_MAX_CBS_COUNT,
+		.access = (OP_READ | OP_WRITE | OP_VALID_ANYWAY),
+		.packed_size = SJA1105PQRS_SIZE_CBS_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0xc4),
+	},
+	[BLK_IDX_XMII_PARAMS] = {
+		.entry_packing = sja1110_xmii_params_entry_packing,
+		.cmd_packing = sja1110_dummy_cmd_packing,
+		.max_entry_count = SJA1105_MAX_XMII_PARAMS_COUNT,
+		.access = (OP_READ | OP_VALID_ANYWAY),
+		.packed_size = SJA1110_SIZE_XMII_PARAMS_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0x3c),
+	},
+	[BLK_IDX_L2_POLICING] = {
+		.entry_packing = sja1110_l2_policing_entry_packing,
+		.cmd_packing = sja1110_l2_policing_cmd_packing,
+		.max_entry_count = SJA1110_MAX_L2_POLICING_COUNT,
+		.access = (OP_READ | OP_WRITE | OP_VALID_ANYWAY),
+		.packed_size = SJA1110_SIZE_L2_POLICING_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0x2fc),
+	},
+	[BLK_IDX_L2_FORWARDING_PARAMS] = {
+		.entry_packing = sja1110_l2_forwarding_params_entry_packing,
+		.cmd_packing = sja1110_dummy_cmd_packing,
+		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
+		.access = (OP_READ | OP_VALID_ANYWAY),
+		.packed_size = SJA1110_SIZE_L2_FORWARDING_PARAMS_DYN_CMD,
+		.addr = SJA1110_SPI_ADDR(0x20000),
+	},
+};
+
 /* Provides read access to the settings through the dynamic interface
  * of the switch.
  * @blk_idx	is used as key to select from the sja1105_dynamic_table_ops.
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
index 28d4eb5efb8b..a1472f80a059 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
@@ -36,5 +36,6 @@ struct sja1105_mgmt_entry {
 
 extern const struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN];
 extern const struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN];
+extern const struct sja1105_dynamic_table_ops sja1110_dyn_ops[BLK_IDX_MAX_DYN];
 
 #endif
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 04af644bf656..5e208ca78c4f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -357,6 +357,7 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 {
 	struct sja1105_table *table;
 	struct sja1105_vlan_lookup_entry pvid = {
+		.type_entry = SJA1110_VLAN_C_TAG,
 		.ving_mirr = 0,
 		.vegr_mirr = 0,
 		.vmemb_port = 0,
@@ -469,6 +470,47 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 
 			l2fwd[ds->num_ports + i].vlan_pmap[j] = i;
 		}
+
+		l2fwd[ds->num_ports + i].type_egrpcp2outputq = true;
+	}
+
+	return 0;
+}
+
+static int sja1110_init_pcp_remapping(struct sja1105_private *priv)
+{
+	struct sja1110_pcp_remapping_entry *pcp_remap;
+	struct dsa_switch *ds = priv->ds;
+	struct sja1105_table *table;
+	int port, tc;
+
+	table = &priv->static_config.tables[BLK_IDX_PCP_REMAPPING];
+
+	/* Nothing to do for SJA1105 */
+	if (!table->ops->max_entry_count)
+		return 0;
+
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	table->entries = kcalloc(table->ops->max_entry_count,
+				 table->ops->unpacked_entry_size, GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+
+	table->entry_count = table->ops->max_entry_count;
+
+	pcp_remap = table->entries;
+
+	/* Repeat the configuration done for vlan_pmap */
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		for (tc = 0; tc < SJA1105_NUM_TC; tc++)
+			pcp_remap[port].egrpcp[tc] = tc;
 	}
 
 	return 0;
@@ -792,6 +834,9 @@ static int sja1105_static_config_load(struct sja1105_private *priv,
 	if (rc < 0)
 		return rc;
 	rc = sja1105_init_avb_params(priv);
+	if (rc < 0)
+		return rc;
+	rc = sja1110_init_pcp_remapping(priv);
 	if (rc < 0)
 		return rc;
 
@@ -2322,6 +2367,7 @@ sja1105_build_bridge_vlans(struct sja1105_private *priv,
 		new_vlan[match].vlan_bc |= BIT(v->port);
 		if (!v->untagged)
 			new_vlan[match].tag_port |= BIT(v->port);
+		new_vlan[match].type_entry = SJA1110_VLAN_C_TAG;
 	}
 
 	return 0;
@@ -2344,6 +2390,7 @@ sja1105_build_dsa_8021q_vlans(struct sja1105_private *priv,
 		new_vlan[match].vlan_bc |= BIT(v->port);
 		if (!v->untagged)
 			new_vlan[match].tag_port |= BIT(v->port);
+		new_vlan[match].type_entry = SJA1110_VLAN_C_TAG;
 	}
 
 	return 0;
@@ -2404,6 +2451,7 @@ static int sja1105_build_subvlans(struct sja1105_private *priv,
 			new_vlan[match].tag_port |= BIT(v->port);
 		/* But it's always tagged towards the CPU */
 		new_vlan[match].tag_port |= BIT(upstream);
+		new_vlan[match].type_entry = SJA1110_VLAN_C_TAG;
 
 		/* The Retagging Table generates packet *clones* with
 		 * the new VLAN. This is a very odd hardware quirk
@@ -2571,6 +2619,7 @@ sja1105_build_crosschip_subvlans(struct sja1105_private *priv,
 		if (!tmp->untagged)
 			new_vlan[match].tag_port |= BIT(tmp->port);
 		new_vlan[match].tag_port |= BIT(upstream);
+		new_vlan[match].type_entry = SJA1110_VLAN_C_TAG;
 		/* Deny egress of @rx_vid towards our front-panel port.
 		 * This will force the switch to drop it, and we'll see
 		 * only the re-retagged packets (having the original,
@@ -3712,7 +3761,7 @@ static int sja1105_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	ds->dev = dev;
-	ds->num_ports = SJA1105_MAX_NUM_PORTS;
+	ds->num_ports = priv->info->num_ports;
 	ds->ops = &sja1105_switch_ops;
 	ds->priv = priv;
 	priv->ds = ds;
@@ -3816,6 +3865,10 @@ static const struct of_device_id sja1105_dt_ids[] = {
 	{ .compatible = "nxp,sja1105q", .data = &sja1105q_info },
 	{ .compatible = "nxp,sja1105r", .data = &sja1105r_info },
 	{ .compatible = "nxp,sja1105s", .data = &sja1105s_info },
+	{ .compatible = "nxp,sja1110a", .data = &sja1110a_info },
+	{ .compatible = "nxp,sja1110b", .data = &sja1110b_info },
+	{ .compatible = "nxp,sja1110c", .data = &sja1110c_info },
+	{ .compatible = "nxp,sja1110d", .data = &sja1110d_info },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, sja1105_dt_ids);
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 786c16a77e46..187c9fbbd397 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -193,6 +193,16 @@ static int sja1105pqrs_reset_cmd(struct dsa_switch *ds)
 	return sja1105_xfer_u32(priv, SPI_WRITE, regs->rgu, &cold_reset, NULL);
 }
 
+static int sja1110_reset_cmd(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+	const struct sja1105_regs *regs = priv->info->regs;
+	u32 switch_reset = BIT(20);
+
+	/* Switch core reset */
+	return sja1105_xfer_u32(priv, SPI_WRITE, regs->rgu, &switch_reset, NULL);
+}
+
 int sja1105_inhibit_tx(const struct sja1105_private *priv,
 		       unsigned long port_bitmap, bool tx_inhibited)
 {
@@ -465,6 +475,88 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.ptpsyncts = 0x1F,
 };
 
+static struct sja1105_regs sja1110_regs = {
+	.device_id = SJA1110_SPI_ADDR(0x0),
+	.prod_id = SJA1110_ACU_ADDR(0xf00),
+	.status = SJA1110_SPI_ADDR(0x4),
+	.port_control = SJA1110_SPI_ADDR(0x50), /* actually INHIB_TX */
+	.vl_status = 0x10000,
+	.config = 0x020000,
+	.rgu = SJA1110_RGU_ADDR(0x100), /* Reset Control Register 0 */
+	/* Ports 2 and 3 are capable of xMII, but there isn't anything to
+	 * configure in the CGU/ACU for them.
+	 */
+	.pad_mii_tx = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR},
+	.pad_mii_rx = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR},
+	.pad_mii_id = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1110_ACU_ADDR(0x18), SJA1110_ACU_ADDR(0x28),
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR},
+	.rmii_pll1 = SJA1105_RSV_ADDR,
+	.cgu_idiv = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		     SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		     SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		     SJA1105_RSV_ADDR, SJA1105_RSV_ADDR},
+	.stats[MAC] = {0x200, 0x202, 0x204, 0x206, 0x208, 0x20a,
+		       0x20c, 0x20e, 0x210, 0x212, 0x214},
+	.stats[HL1] = {0x400, 0x410, 0x420, 0x430, 0x440, 0x450,
+		       0x460, 0x470, 0x480, 0x490, 0x4a0},
+	.stats[HL2] = {0x600, 0x610, 0x620, 0x630, 0x640, 0x650,
+		       0x660, 0x670, 0x680, 0x690, 0x6a0},
+	.stats[ETHER] = {0x1400, 0x1418, 0x1430, 0x1448, 0x1460, 0x1478,
+			 0x1490, 0x14a8, 0x14c0, 0x14d8, 0x14f0},
+	.mii_tx_clk = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR},
+	.mii_rx_clk = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		       SJA1105_RSV_ADDR, SJA1105_RSV_ADDR},
+	.mii_ext_tx_clk = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			   SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			   SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			   SJA1105_RSV_ADDR, SJA1105_RSV_ADDR},
+	.mii_ext_rx_clk = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			   SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			   SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			   SJA1105_RSV_ADDR, SJA1105_RSV_ADDR},
+	.rgmii_tx_clk = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			 SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			 SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			 SJA1105_RSV_ADDR, SJA1105_RSV_ADDR},
+	.rmii_ref_clk = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			 SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			 SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			 SJA1105_RSV_ADDR, SJA1105_RSV_ADDR},
+	.rmii_ext_tx_clk = {SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			    SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			    SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			    SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			    SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+			    SJA1105_RSV_ADDR},
+	.ptpschtm = SJA1110_SPI_ADDR(0x54),
+	.ptppinst = SJA1110_SPI_ADDR(0x5c),
+	.ptppindur = SJA1110_SPI_ADDR(0x64),
+	.ptp_control = SJA1110_SPI_ADDR(0x68),
+	.ptpclkval = SJA1110_SPI_ADDR(0x6c),
+	.ptpclkrate = SJA1110_SPI_ADDR(0x74),
+	.ptpclkcorp = SJA1110_SPI_ADDR(0x80),
+	.ptpsyncts = SJA1110_SPI_ADDR(0x84),
+};
+
 const struct sja1105_info sja1105e_info = {
 	.device_id		= SJA1105E_DEVICE_ID,
 	.part_no		= SJA1105ET_PART_NO,
@@ -475,6 +567,7 @@ const struct sja1105_info sja1105e_info = {
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
 	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
+	.num_ports		= SJA1105_NUM_PORTS,
 	.num_cbs_shapers	= SJA1105ET_MAX_CBS_COUNT,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
@@ -505,6 +598,7 @@ const struct sja1105_info sja1105t_info = {
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
 	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
+	.num_ports		= SJA1105_NUM_PORTS,
 	.num_cbs_shapers	= SJA1105ET_MAX_CBS_COUNT,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
@@ -535,6 +629,7 @@ const struct sja1105_info sja1105p_info = {
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
+	.num_ports		= SJA1105_NUM_PORTS,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
@@ -566,6 +661,7 @@ const struct sja1105_info sja1105q_info = {
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
+	.num_ports		= SJA1105_NUM_PORTS,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
@@ -597,6 +693,7 @@ const struct sja1105_info sja1105r_info = {
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
+	.num_ports		= SJA1105_NUM_PORTS,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
@@ -630,6 +727,7 @@ const struct sja1105_info sja1105s_info = {
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
+	.num_ports		= SJA1105_NUM_PORTS,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
@@ -650,3 +748,157 @@ const struct sja1105_info sja1105s_info = {
 	.supports_sgmii		= {false, false, false, false, true},
 	.name			= "SJA1105S",
 };
+
+const struct sja1105_info sja1110a_info = {
+	.device_id		= SJA1110_DEVICE_ID,
+	.part_no		= SJA1110A_PART_NO,
+	.static_ops		= sja1110_table_ops,
+	.dyn_ops		= sja1110_dyn_ops,
+	.regs			= &sja1110_regs,
+	.qinq_tpid		= ETH_P_8021AD,
+	.can_limit_mcast_flood	= true,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
+	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
+	.num_ports		= SJA1110_NUM_PORTS,
+	.num_cbs_shapers	= SJA1110_MAX_CBS_COUNT,
+	.setup_rgmii_delay	= sja1110_setup_rgmii_delay,
+	.reset_cmd		= sja1110_reset_cmd,
+	.fdb_add_cmd		= sja1105pqrs_fdb_add,
+	.fdb_del_cmd		= sja1105pqrs_fdb_del,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.clocking_setup		= sja1110_clocking_setup,
+	.port_speed		= {
+		[SJA1105_SPEED_AUTO] = 0,
+		[SJA1105_SPEED_10MBPS] = 4,
+		[SJA1105_SPEED_100MBPS] = 3,
+		[SJA1105_SPEED_1000MBPS] = 2,
+		[SJA1105_SPEED_2500MBPS] = 1,
+	},
+	.supports_mii		= {true, true, true, true, false,
+				   true, true, true, true, true, true},
+	.supports_rmii		= {false, false, true, true, false,
+				   false, false, false, false, false, false},
+	.supports_rgmii		= {false, false, true, true, false,
+				   false, false, false, false, false, false},
+	.supports_sgmii		= {false, true, true, true, true,
+				   false, false, false, false, false, false},
+	.supports_2500basex	= {false, false, false, true, true,
+				   false, false, false, false, false, false},
+	.name			= "SJA1110A",
+};
+
+const struct sja1105_info sja1110b_info = {
+	.device_id		= SJA1110_DEVICE_ID,
+	.part_no		= SJA1110B_PART_NO,
+	.static_ops		= sja1110_table_ops,
+	.dyn_ops		= sja1110_dyn_ops,
+	.regs			= &sja1110_regs,
+	.qinq_tpid		= ETH_P_8021AD,
+	.can_limit_mcast_flood	= true,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
+	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
+	.num_ports		= SJA1110_NUM_PORTS,
+	.num_cbs_shapers	= SJA1110_MAX_CBS_COUNT,
+	.setup_rgmii_delay	= sja1110_setup_rgmii_delay,
+	.reset_cmd		= sja1110_reset_cmd,
+	.fdb_add_cmd		= sja1105pqrs_fdb_add,
+	.fdb_del_cmd		= sja1105pqrs_fdb_del,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.clocking_setup		= sja1110_clocking_setup,
+	.port_speed		= {
+		[SJA1105_SPEED_AUTO] = 0,
+		[SJA1105_SPEED_10MBPS] = 4,
+		[SJA1105_SPEED_100MBPS] = 3,
+		[SJA1105_SPEED_1000MBPS] = 2,
+		[SJA1105_SPEED_2500MBPS] = 1,
+	},
+	.supports_mii		= {true, true, true, true, false,
+				   true, true, true, true, true, false},
+	.supports_rmii		= {false, false, true, true, false,
+				   false, false, false, false, false, false},
+	.supports_rgmii		= {false, false, true, true, false,
+				   false, false, false, false, false, false},
+	.supports_sgmii		= {false, false, false, true, true,
+				   false, false, false, false, false, false},
+	.supports_2500basex	= {false, false, false, true, true,
+				   false, false, false, false, false, false},
+	.name			= "SJA1110B",
+};
+
+const struct sja1105_info sja1110c_info = {
+	.device_id		= SJA1110_DEVICE_ID,
+	.part_no		= SJA1110C_PART_NO,
+	.static_ops		= sja1110_table_ops,
+	.dyn_ops		= sja1110_dyn_ops,
+	.regs			= &sja1110_regs,
+	.qinq_tpid		= ETH_P_8021AD,
+	.can_limit_mcast_flood	= true,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
+	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
+	.num_ports		= SJA1110_NUM_PORTS,
+	.num_cbs_shapers	= SJA1110_MAX_CBS_COUNT,
+	.setup_rgmii_delay	= sja1110_setup_rgmii_delay,
+	.reset_cmd		= sja1110_reset_cmd,
+	.fdb_add_cmd		= sja1105pqrs_fdb_add,
+	.fdb_del_cmd		= sja1105pqrs_fdb_del,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.clocking_setup		= sja1110_clocking_setup,
+	.port_speed		= {
+		[SJA1105_SPEED_AUTO] = 0,
+		[SJA1105_SPEED_10MBPS] = 4,
+		[SJA1105_SPEED_100MBPS] = 3,
+		[SJA1105_SPEED_1000MBPS] = 2,
+		[SJA1105_SPEED_2500MBPS] = 1,
+	},
+	.supports_mii		= {true, true, true, true, false,
+				   true, true, true, false, false, false},
+	.supports_rmii		= {false, false, true, true, false,
+				   false, false, false, false, false, false},
+	.supports_rgmii		= {false, false, true, true, false,
+				   false, false, false, false, false, false},
+	.supports_sgmii		= {false, false, false, false, true,
+				   false, false, false, false, false, false},
+	.supports_2500basex	= {false, false, false, false, true,
+				   false, false, false, false, false, false},
+	.name			= "SJA1110C",
+};
+
+const struct sja1105_info sja1110d_info = {
+	.device_id		= SJA1110_DEVICE_ID,
+	.part_no		= SJA1110D_PART_NO,
+	.static_ops		= sja1110_table_ops,
+	.dyn_ops		= sja1110_dyn_ops,
+	.regs			= &sja1110_regs,
+	.qinq_tpid		= ETH_P_8021AD,
+	.can_limit_mcast_flood	= true,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
+	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
+	.num_ports		= SJA1110_NUM_PORTS,
+	.num_cbs_shapers	= SJA1110_MAX_CBS_COUNT,
+	.setup_rgmii_delay	= sja1110_setup_rgmii_delay,
+	.reset_cmd		= sja1110_reset_cmd,
+	.fdb_add_cmd		= sja1105pqrs_fdb_add,
+	.fdb_del_cmd		= sja1105pqrs_fdb_del,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.clocking_setup		= sja1110_clocking_setup,
+	.port_speed		= {
+		[SJA1105_SPEED_AUTO] = 0,
+		[SJA1105_SPEED_10MBPS] = 4,
+		[SJA1105_SPEED_100MBPS] = 3,
+		[SJA1105_SPEED_1000MBPS] = 2,
+		[SJA1105_SPEED_2500MBPS] = 1,
+	},
+	.supports_mii		= {true, false, true, false, false,
+				   true, true, true, false, false, false},
+	.supports_rmii		= {false, false, true, false, false,
+				   false, false, false, false, false, false},
+	.supports_rgmii		= {false, false, true, false, false,
+				   false, false, false, false, false, false},
+	.supports_sgmii		= {false, true, true, true, true,
+				   false, false, false, false, false, false},
+	.name			= "SJA1110D",
+};
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 33f91ecbe07b..48ad984d2367 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -180,6 +180,41 @@ size_t sja1105pqrs_general_params_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_general_params_entry_packing(void *buf, void *entry_ptr,
+					    enum packing_op op)
+{
+	struct sja1105_general_params_entry *entry = entry_ptr;
+	const size_t size = SJA1110_SIZE_GENERAL_PARAMS_ENTRY;
+
+	sja1105_packing(buf, &entry->vllupformat, 447, 447, size, op);
+	sja1105_packing(buf, &entry->mirr_ptacu,  446, 446, size, op);
+	sja1105_packing(buf, &entry->switchid,    445, 442, size, op);
+	sja1105_packing(buf, &entry->hostprio,    441, 439, size, op);
+	sja1105_packing(buf, &entry->mac_fltres1, 438, 391, size, op);
+	sja1105_packing(buf, &entry->mac_fltres0, 390, 343, size, op);
+	sja1105_packing(buf, &entry->mac_flt1,    342, 295, size, op);
+	sja1105_packing(buf, &entry->mac_flt0,    294, 247, size, op);
+	sja1105_packing(buf, &entry->incl_srcpt1, 246, 246, size, op);
+	sja1105_packing(buf, &entry->incl_srcpt0, 245, 245, size, op);
+	sja1105_packing(buf, &entry->send_meta1,  244, 244, size, op);
+	sja1105_packing(buf, &entry->send_meta0,  243, 243, size, op);
+	sja1105_packing(buf, &entry->casc_port,   242, 232, size, op);
+	sja1105_packing(buf, &entry->host_port,   231, 228, size, op);
+	sja1105_packing(buf, &entry->mirr_port,   227, 224, size, op);
+	sja1105_packing(buf, &entry->vlmarker,    223, 192, size, op);
+	sja1105_packing(buf, &entry->vlmask,      191, 160, size, op);
+	sja1105_packing(buf, &entry->tpid2,       159, 144, size, op);
+	sja1105_packing(buf, &entry->ignore2stf,  143, 143, size, op);
+	sja1105_packing(buf, &entry->tpid,        142, 127, size, op);
+	sja1105_packing(buf, &entry->queue_ts,    126, 126, size, op);
+	sja1105_packing(buf, &entry->egrmirrvid,  125, 114, size, op);
+	sja1105_packing(buf, &entry->egrmirrpcp,  113, 111, size, op);
+	sja1105_packing(buf, &entry->egrmirrdei,  110, 110, size, op);
+	sja1105_packing(buf, &entry->replay_port, 109, 106, size, op);
+	sja1105_packing(buf, &entry->tte_en,       16,  16, size, op);
+	return size;
+}
+
 static size_t
 sja1105_l2_forwarding_params_entry_packing(void *buf, void *entry_ptr,
 					   enum packing_op op)
@@ -195,6 +230,20 @@ sja1105_l2_forwarding_params_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_l2_forwarding_params_entry_packing(void *buf, void *entry_ptr,
+						  enum packing_op op)
+{
+	struct sja1105_l2_forwarding_params_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY;
+	int offset, i;
+
+	sja1105_packing(buf, &entry->max_dynp, 95, 93, size, op);
+	for (i = 0, offset = 5; i < 8; i++, offset += 11)
+		sja1105_packing(buf, &entry->part_spc[i],
+				offset + 10, offset + 0, size, op);
+	return size;
+}
+
 size_t sja1105_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
 					   enum packing_op op)
 {
@@ -211,6 +260,27 @@ size_t sja1105_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
+					   enum packing_op op)
+{
+	struct sja1105_l2_forwarding_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_L2_FORWARDING_ENTRY;
+	int offset, i;
+
+	if (entry->type_egrpcp2outputq) {
+		for (i = 0, offset = 31; i < SJA1110_NUM_PORTS;
+		     i++, offset += 3) {
+			sja1105_packing(buf, &entry->vlan_pmap[i],
+					offset + 2, offset + 0, size, op);
+		}
+	} else {
+		sja1105_packing(buf, &entry->bc_domain,  63, 53, size, op);
+		sja1105_packing(buf, &entry->reach_port, 52, 42, size, op);
+		sja1105_packing(buf, &entry->fl_domain,  41, 31, size, op);
+	}
+	return size;
+}
+
 static size_t
 sja1105et_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op)
@@ -249,6 +319,28 @@ size_t sja1105pqrs_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
+					      enum packing_op op)
+{
+	struct sja1105_l2_lookup_params_entry *entry = entry_ptr;
+	const size_t size = SJA1110_SIZE_L2_LOOKUP_PARAMS_ENTRY;
+	int offset, i;
+
+	for (i = 0, offset = 70; i < SJA1110_NUM_PORTS; i++, offset += 11)
+		sja1105_packing(buf, &entry->maxaddrp[i],
+				offset + 10, offset + 0, size, op);
+	sja1105_packing(buf, &entry->maxage,         69,  55, size, op);
+	sja1105_packing(buf, &entry->start_dynspc,   54,  45, size, op);
+	sja1105_packing(buf, &entry->drpnolearn,     44,  34, size, op);
+	sja1105_packing(buf, &entry->shared_learn,   33,  33, size, op);
+	sja1105_packing(buf, &entry->no_enf_hostprt, 32,  32, size, op);
+	sja1105_packing(buf, &entry->no_mgmt_learn,  31,  31, size, op);
+	sja1105_packing(buf, &entry->use_static,     30,  30, size, op);
+	sja1105_packing(buf, &entry->owr_dyn,        29,  29, size, op);
+	sja1105_packing(buf, &entry->learn_once,     28,  28, size, op);
+	return size;
+}
+
 size_t sja1105et_l2_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op)
 {
@@ -291,6 +383,36 @@ size_t sja1105pqrs_l2_lookup_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_l2_lookup_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op)
+{
+	const size_t size = SJA1110_SIZE_L2_LOOKUP_ENTRY;
+	struct sja1105_l2_lookup_entry *entry = entry_ptr;
+
+	if (entry->lockeds) {
+		sja1105_packing(buf, &entry->trap,     168, 168, size, op);
+		sja1105_packing(buf, &entry->mirrvlan, 167, 156, size, op);
+		sja1105_packing(buf, &entry->takets,   155, 155, size, op);
+		sja1105_packing(buf, &entry->mirr,     154, 154, size, op);
+		sja1105_packing(buf, &entry->retag,    153, 153, size, op);
+	} else {
+		sja1105_packing(buf, &entry->touched,  168, 168, size, op);
+		sja1105_packing(buf, &entry->age,      167, 153, size, op);
+	}
+	sja1105_packing(buf, &entry->mask_iotag,   152, 152, size, op);
+	sja1105_packing(buf, &entry->mask_vlanid,  151, 140, size, op);
+	sja1105_packing(buf, &entry->mask_macaddr, 139,  92, size, op);
+	sja1105_packing(buf, &entry->mask_srcport,  91,  88, size, op);
+	sja1105_packing(buf, &entry->iotag,         87,  87, size, op);
+	sja1105_packing(buf, &entry->vlanid,        86,  75, size, op);
+	sja1105_packing(buf, &entry->macaddr,       74,  27, size, op);
+	sja1105_packing(buf, &entry->srcport,       26,  23, size, op);
+	sja1105_packing(buf, &entry->destports,     22,  12, size, op);
+	sja1105_packing(buf, &entry->enfport,       11,  11, size, op);
+	sja1105_packing(buf, &entry->index,         10,   1, size, op);
+	return size;
+}
+
 static size_t sja1105_l2_policing_entry_packing(void *buf, void *entry_ptr,
 						enum packing_op op)
 {
@@ -305,6 +427,20 @@ static size_t sja1105_l2_policing_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_l2_policing_entry_packing(void *buf, void *entry_ptr,
+					 enum packing_op op)
+{
+	struct sja1105_l2_policing_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_L2_POLICING_ENTRY;
+
+	sja1105_packing(buf, &entry->sharindx, 63, 57, size, op);
+	sja1105_packing(buf, &entry->smax,     56, 39, size, op);
+	sja1105_packing(buf, &entry->rate,     38, 21, size, op);
+	sja1105_packing(buf, &entry->maxlen,   20, 10, size, op);
+	sja1105_packing(buf, &entry->partition, 9,  7, size, op);
+	return size;
+}
+
 static size_t sja1105et_mac_config_entry_packing(void *buf, void *entry_ptr,
 						 enum packing_op op)
 {
@@ -373,6 +509,40 @@ size_t sja1105pqrs_mac_config_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_mac_config_entry_packing(void *buf, void *entry_ptr,
+					enum packing_op op)
+{
+	const size_t size = SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY;
+	struct sja1105_mac_config_entry *entry = entry_ptr;
+	int offset, i;
+
+	for (i = 0, offset = 104; i < 8; i++, offset += 19) {
+		sja1105_packing(buf, &entry->enabled[i],
+				offset +  0, offset +  0, size, op);
+		sja1105_packing(buf, &entry->base[i],
+				offset +  9, offset +  1, size, op);
+		sja1105_packing(buf, &entry->top[i],
+				offset + 18, offset + 10, size, op);
+	}
+	sja1105_packing(buf, &entry->speed,      98, 96, size, op);
+	sja1105_packing(buf, &entry->tp_delin,   95, 80, size, op);
+	sja1105_packing(buf, &entry->tp_delout,  79, 64, size, op);
+	sja1105_packing(buf, &entry->maxage,     63, 56, size, op);
+	sja1105_packing(buf, &entry->vlanprio,   55, 53, size, op);
+	sja1105_packing(buf, &entry->vlanid,     52, 41, size, op);
+	sja1105_packing(buf, &entry->ing_mirr,   40, 40, size, op);
+	sja1105_packing(buf, &entry->egr_mirr,   39, 39, size, op);
+	sja1105_packing(buf, &entry->drpnona664, 38, 38, size, op);
+	sja1105_packing(buf, &entry->drpdtag,    37, 37, size, op);
+	sja1105_packing(buf, &entry->drpuntag,   34, 34, size, op);
+	sja1105_packing(buf, &entry->retag,      33, 33, size, op);
+	sja1105_packing(buf, &entry->dyn_learn,  32, 32, size, op);
+	sja1105_packing(buf, &entry->egress,     31, 31, size, op);
+	sja1105_packing(buf, &entry->ingress,    30, 30, size, op);
+	sja1105_packing(buf, &entry->ifg,        10,  5, size, op);
+	return size;
+}
+
 static size_t
 sja1105_schedule_entry_points_params_entry_packing(void *buf, void *entry_ptr,
 						   enum packing_op op)
@@ -398,6 +568,19 @@ sja1105_schedule_entry_points_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+static size_t
+sja1110_schedule_entry_points_entry_packing(void *buf, void *entry_ptr,
+					    enum packing_op op)
+{
+	struct sja1105_schedule_entry_points_entry *entry = entry_ptr;
+	const size_t size = SJA1110_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY;
+
+	sja1105_packing(buf, &entry->subschindx, 63, 61, size, op);
+	sja1105_packing(buf, &entry->delta,      60, 43, size, op);
+	sja1105_packing(buf, &entry->address,    42, 31, size, op);
+	return size;
+}
+
 static size_t sja1105_schedule_params_entry_packing(void *buf, void *entry_ptr,
 						    enum packing_op op)
 {
@@ -411,6 +594,19 @@ static size_t sja1105_schedule_params_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+static size_t sja1110_schedule_params_entry_packing(void *buf, void *entry_ptr,
+						    enum packing_op op)
+{
+	struct sja1105_schedule_params_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY;
+	int offset, i;
+
+	for (i = 0, offset = 0; i < 8; i++, offset += 12)
+		sja1105_packing(buf, &entry->subscheind[i],
+				offset + 11, offset + 0, size, op);
+	return size;
+}
+
 static size_t sja1105_schedule_entry_packing(void *buf, void *entry_ptr,
 					     enum packing_op op)
 {
@@ -430,6 +626,25 @@ static size_t sja1105_schedule_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+static size_t sja1110_schedule_entry_packing(void *buf, void *entry_ptr,
+					     enum packing_op op)
+{
+	const size_t size = SJA1110_SIZE_SCHEDULE_ENTRY;
+	struct sja1105_schedule_entry *entry = entry_ptr;
+
+	sja1105_packing(buf, &entry->winstindex,  95, 84, size, op);
+	sja1105_packing(buf, &entry->winend,      83, 83, size, op);
+	sja1105_packing(buf, &entry->winst,       82, 82, size, op);
+	sja1105_packing(buf, &entry->destports,   81, 71, size, op);
+	sja1105_packing(buf, &entry->setvalid,    70, 70, size, op);
+	sja1105_packing(buf, &entry->txen,        69, 69, size, op);
+	sja1105_packing(buf, &entry->resmedia_en, 68, 68, size, op);
+	sja1105_packing(buf, &entry->resmedia,    67, 60, size, op);
+	sja1105_packing(buf, &entry->vlindex,     59, 48, size, op);
+	sja1105_packing(buf, &entry->delta,       47, 30, size, op);
+	return size;
+}
+
 static size_t
 sja1105_vl_forwarding_params_entry_packing(void *buf, void *entry_ptr,
 					   enum packing_op op)
@@ -445,6 +660,21 @@ sja1105_vl_forwarding_params_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+static size_t
+sja1110_vl_forwarding_params_entry_packing(void *buf, void *entry_ptr,
+					   enum packing_op op)
+{
+	struct sja1105_vl_forwarding_params_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_VL_FORWARDING_PARAMS_ENTRY;
+	int offset, i;
+
+	for (i = 0, offset = 8; i < 8; i++, offset += 11)
+		sja1105_packing(buf, &entry->partspc[i],
+				offset + 10, offset + 0, size, op);
+	sja1105_packing(buf, &entry->debugen, 7, 7, size, op);
+	return size;
+}
+
 static size_t sja1105_vl_forwarding_entry_packing(void *buf, void *entry_ptr,
 						  enum packing_op op)
 {
@@ -458,6 +688,19 @@ static size_t sja1105_vl_forwarding_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+static size_t sja1110_vl_forwarding_entry_packing(void *buf, void *entry_ptr,
+						  enum packing_op op)
+{
+	struct sja1105_vl_forwarding_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_VL_FORWARDING_ENTRY;
+
+	sja1105_packing(buf, &entry->type,      31, 31, size, op);
+	sja1105_packing(buf, &entry->priority,  30, 28, size, op);
+	sja1105_packing(buf, &entry->partition, 27, 25, size, op);
+	sja1105_packing(buf, &entry->destports, 24, 14, size, op);
+	return size;
+}
+
 size_t sja1105_vl_lookup_entry_packing(void *buf, void *entry_ptr,
 				       enum packing_op op)
 {
@@ -492,6 +735,41 @@ size_t sja1105_vl_lookup_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_vl_lookup_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op)
+{
+	struct sja1105_vl_lookup_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_VL_LOOKUP_ENTRY;
+
+	if (entry->format == SJA1105_VL_FORMAT_PSFP) {
+		/* Interpreting vllupformat as 0 */
+		/* XXX: vl_police ? */
+		sja1105_packing(buf, &entry->destports,
+				94, 84, size, op);
+		sja1105_packing(buf, &entry->iscritical,
+				83, 83, size, op);
+		sja1105_packing(buf, &entry->macaddr,
+				82, 35, size, op);
+		sja1105_packing(buf, &entry->vlanid,
+				34, 23, size, op);
+		sja1105_packing(buf, &entry->port,
+				22, 19, size, op);
+		sja1105_packing(buf, &entry->vlanprior,
+				18, 16, size, op);
+	} else {
+		/* Interpreting vllupformat as 1 */
+		sja1105_packing(buf, &entry->egrmirr,
+				94, 84, size, op);
+		sja1105_packing(buf, &entry->ingrmirr,
+				83, 83, size, op);
+		sja1105_packing(buf, &entry->vlid,
+				50, 35, size, op);
+		sja1105_packing(buf, &entry->port,
+				22, 19, size, op);
+	}
+	return size;
+}
+
 static size_t sja1105_vl_policing_entry_packing(void *buf, void *entry_ptr,
 						enum packing_op op)
 {
@@ -508,6 +786,22 @@ static size_t sja1105_vl_policing_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_vl_policing_entry_packing(void *buf, void *entry_ptr,
+					 enum packing_op op)
+{
+	struct sja1105_vl_policing_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_VL_POLICING_ENTRY;
+
+	sja1105_packing(buf, &entry->type,      63, 63, size, op);
+	sja1105_packing(buf, &entry->maxlen,    62, 52, size, op);
+	sja1105_packing(buf, &entry->sharindx,  51, 40, size, op);
+	if (entry->type == 0) {
+		sja1105_packing(buf, &entry->bag,    41, 28, size, op);
+		sja1105_packing(buf, &entry->jitter, 27, 18, size, op);
+	}
+	return size;
+}
+
 size_t sja1105_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op)
 {
@@ -523,6 +817,22 @@ size_t sja1105_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
+					 enum packing_op op)
+{
+	struct sja1105_vlan_lookup_entry *entry = entry_ptr;
+	const size_t size = SJA1110_SIZE_VLAN_LOOKUP_ENTRY;
+
+	sja1105_packing(buf, &entry->ving_mirr,  95, 85, size, op);
+	sja1105_packing(buf, &entry->vegr_mirr,  84, 74, size, op);
+	sja1105_packing(buf, &entry->vmemb_port, 73, 63, size, op);
+	sja1105_packing(buf, &entry->vlan_bc,    62, 52, size, op);
+	sja1105_packing(buf, &entry->tag_port,   51, 41, size, op);
+	sja1105_packing(buf, &entry->type_entry, 40, 39, size, op);
+	sja1105_packing(buf, &entry->vlanid,     38, 27, size, op);
+	return size;
+}
+
 static size_t sja1105_xmii_params_entry_packing(void *buf, void *entry_ptr,
 						enum packing_op op)
 {
@@ -539,6 +849,24 @@ static size_t sja1105_xmii_params_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_xmii_params_entry_packing(void *buf, void *entry_ptr,
+					 enum packing_op op)
+{
+	const size_t size = SJA1110_SIZE_XMII_PARAMS_ENTRY;
+	struct sja1105_xmii_params_entry *entry = entry_ptr;
+	int offset, i;
+
+	for (i = 0, offset = 20; i < SJA1110_NUM_PORTS; i++, offset += 4) {
+		sja1105_packing(buf, &entry->xmii_mode[i],
+				offset + 1, offset + 0, size, op);
+		sja1105_packing(buf, &entry->phy_mac[i],
+				offset + 2, offset + 2, size, op);
+		sja1105_packing(buf, &entry->special[i],
+				offset + 3, offset + 3, size, op);
+	}
+	return size;
+}
+
 size_t sja1105_retagging_entry_packing(void *buf, void *entry_ptr,
 				       enum packing_op op)
 {
@@ -555,6 +883,36 @@ size_t sja1105_retagging_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1110_retagging_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op)
+{
+	struct sja1105_retagging_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_RETAGGING_ENTRY;
+
+	sja1105_packing(buf, &entry->egr_port,       63, 53, size, op);
+	sja1105_packing(buf, &entry->ing_port,       52, 42, size, op);
+	sja1105_packing(buf, &entry->vlan_ing,       41, 30, size, op);
+	sja1105_packing(buf, &entry->vlan_egr,       29, 18, size, op);
+	sja1105_packing(buf, &entry->do_not_learn,   17, 17, size, op);
+	sja1105_packing(buf, &entry->use_dest_ports, 16, 16, size, op);
+	sja1105_packing(buf, &entry->destports,      15, 5, size, op);
+	return size;
+}
+
+static size_t sja1110_pcp_remapping_entry_packing(void *buf, void *entry_ptr,
+						  enum packing_op op)
+{
+	struct sja1110_pcp_remapping_entry *entry = entry_ptr;
+	const size_t size = SJA1110_SIZE_PCP_REMAPPING_ENTRY;
+	int offset, i;
+
+	for (i = 0, offset = 8; i < SJA1105_NUM_TC; i++, offset += 3)
+		sja1105_packing(buf, &entry->egrpcp[i],
+				offset + 2, offset + 0, size, op);
+
+	return size;
+}
+
 size_t sja1105_table_header_packing(void *buf, void *entry_ptr,
 				    enum packing_op op)
 {
@@ -619,6 +977,7 @@ static u64 blk_id_map[BLK_IDX_MAX] = {
 	[BLK_IDX_GENERAL_PARAMS] = BLKID_GENERAL_PARAMS,
 	[BLK_IDX_RETAGGING] = BLKID_RETAGGING,
 	[BLK_IDX_XMII_PARAMS] = BLKID_XMII_PARAMS,
+	[BLK_IDX_PCP_REMAPPING] = BLKID_PCP_REMAPPING,
 };
 
 const char *sja1105_static_config_error_msg[] = {
@@ -1400,6 +1759,130 @@ const struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
 	},
 };
 
+/* SJA1110A: Third generation */
+const struct sja1105_table_ops sja1110_table_ops[BLK_IDX_MAX] = {
+	[BLK_IDX_SCHEDULE] = {
+		.packing = sja1110_schedule_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry),
+		.packed_entry_size = SJA1110_SIZE_SCHEDULE_ENTRY,
+		.max_entry_count = SJA1110_MAX_SCHEDULE_COUNT,
+	},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {
+		.packing = sja1110_schedule_entry_points_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry_points_entry),
+		.packed_entry_size = SJA1110_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_COUNT,
+	},
+	[BLK_IDX_VL_LOOKUP] = {
+		.packing = sja1110_vl_lookup_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_lookup_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_LOOKUP_ENTRY,
+		.max_entry_count = SJA1110_MAX_VL_LOOKUP_COUNT,
+	},
+	[BLK_IDX_VL_POLICING] = {
+		.packing = sja1110_vl_policing_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_policing_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_POLICING_ENTRY,
+		.max_entry_count = SJA1110_MAX_VL_POLICING_COUNT,
+	},
+	[BLK_IDX_VL_FORWARDING] = {
+		.packing = sja1110_vl_forwarding_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_forwarding_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_FORWARDING_ENTRY,
+		.max_entry_count = SJA1110_MAX_VL_FORWARDING_COUNT,
+	},
+	[BLK_IDX_L2_LOOKUP] = {
+		.packing = sja1110_l2_lookup_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
+		.packed_entry_size = SJA1110_SIZE_L2_LOOKUP_ENTRY,
+		.max_entry_count = SJA1105_MAX_L2_LOOKUP_COUNT,
+	},
+	[BLK_IDX_L2_POLICING] = {
+		.packing = sja1110_l2_policing_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_l2_policing_entry),
+		.packed_entry_size = SJA1105_SIZE_L2_POLICING_ENTRY,
+		.max_entry_count = SJA1110_MAX_L2_POLICING_COUNT,
+	},
+	[BLK_IDX_VLAN_LOOKUP] = {
+		.packing = sja1110_vlan_lookup_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vlan_lookup_entry),
+		.packed_entry_size = SJA1110_SIZE_VLAN_LOOKUP_ENTRY,
+		.max_entry_count = SJA1105_MAX_VLAN_LOOKUP_COUNT,
+	},
+	[BLK_IDX_L2_FORWARDING] = {
+		.packing = sja1110_l2_forwarding_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_l2_forwarding_entry),
+		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_ENTRY,
+		.max_entry_count = SJA1110_MAX_L2_FORWARDING_COUNT,
+	},
+	[BLK_IDX_MAC_CONFIG] = {
+		.packing = sja1110_mac_config_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_mac_config_entry),
+		.packed_entry_size = SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY,
+		.max_entry_count = SJA1110_MAX_MAC_CONFIG_COUNT,
+	},
+	[BLK_IDX_SCHEDULE_PARAMS] = {
+		.packing = sja1110_schedule_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_params_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_PARAMS_COUNT,
+	},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {
+		.packing = sja1105_schedule_entry_points_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry_points_params_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT,
+	},
+	[BLK_IDX_VL_FORWARDING_PARAMS] = {
+		.packing = sja1110_vl_forwarding_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_forwarding_params_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_FORWARDING_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_FORWARDING_PARAMS_COUNT,
+	},
+	[BLK_IDX_L2_LOOKUP_PARAMS] = {
+		.packing = sja1110_l2_lookup_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
+		.packed_entry_size = SJA1110_SIZE_L2_LOOKUP_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_L2_LOOKUP_PARAMS_COUNT,
+	},
+	[BLK_IDX_L2_FORWARDING_PARAMS] = {
+		.packing = sja1110_l2_forwarding_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_l2_forwarding_params_entry),
+		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
+	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105pqrs_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
+	[BLK_IDX_GENERAL_PARAMS] = {
+		.packing = sja1110_general_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
+		.packed_entry_size = SJA1110_SIZE_GENERAL_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_GENERAL_PARAMS_COUNT,
+	},
+	[BLK_IDX_RETAGGING] = {
+		.packing = sja1110_retagging_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_retagging_entry),
+		.packed_entry_size = SJA1105_SIZE_RETAGGING_ENTRY,
+		.max_entry_count = SJA1105_MAX_RETAGGING_COUNT,
+	},
+	[BLK_IDX_XMII_PARAMS] = {
+		.packing = sja1110_xmii_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_xmii_params_entry),
+		.packed_entry_size = SJA1110_SIZE_XMII_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_XMII_PARAMS_COUNT,
+	},
+	[BLK_IDX_PCP_REMAPPING] = {
+		.packing = sja1110_pcp_remapping_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1110_pcp_remapping_entry),
+		.packed_entry_size = SJA1110_SIZE_PCP_REMAPPING_ENTRY,
+		.max_entry_count = SJA1110_MAX_PCP_REMAPPING_COUNT,
+	},
+};
+
 int sja1105_static_config_init(struct sja1105_static_config *config,
 			       const struct sja1105_table_ops *static_ops,
 			       u64 device_id)
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 4ddb06bd8e92..d24227f78a72 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -9,21 +9,30 @@
 #include <linux/types.h>
 #include <asm/types.h>
 
+#define SJA1105_NUM_PORTS				5
+#define SJA1110_NUM_PORTS				11
+#define SJA1105_MAX_NUM_PORTS				SJA1110_NUM_PORTS
+#define SJA1105_NUM_TC					8
+
 #define SJA1105_SIZE_SPI_MSG_HEADER			4
 #define SJA1105_SIZE_SPI_MSG_MAXLEN			(64 * 4)
 #define SJA1105_SIZE_DEVICE_ID				4
 #define SJA1105_SIZE_TABLE_HEADER			12
 #define SJA1105_SIZE_SCHEDULE_ENTRY			8
+#define SJA1110_SIZE_SCHEDULE_ENTRY			12
 #define SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY	4
+#define SJA1110_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY	8
 #define SJA1105_SIZE_VL_LOOKUP_ENTRY			12
 #define SJA1105_SIZE_VL_POLICING_ENTRY			8
 #define SJA1105_SIZE_VL_FORWARDING_ENTRY		4
 #define SJA1105_SIZE_L2_POLICING_ENTRY			8
 #define SJA1105_SIZE_VLAN_LOOKUP_ENTRY			8
+#define SJA1110_SIZE_VLAN_LOOKUP_ENTRY			12
 #define SJA1105_SIZE_L2_FORWARDING_ENTRY		8
 #define SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY		12
 #define SJA1105_SIZE_RETAGGING_ENTRY			8
 #define SJA1105_SIZE_XMII_PARAMS_ENTRY			4
+#define SJA1110_SIZE_XMII_PARAMS_ENTRY			8
 #define SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY		12
 #define SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY	4
 #define SJA1105_SIZE_VL_FORWARDING_PARAMS_ENTRY         12
@@ -34,11 +43,15 @@
 #define SJA1105ET_SIZE_AVB_PARAMS_ENTRY			12
 #define SJA1105ET_SIZE_CBS_ENTRY			16
 #define SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY		20
+#define SJA1110_SIZE_L2_LOOKUP_ENTRY			24
 #define SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY		32
 #define SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_ENTRY		16
+#define SJA1110_SIZE_L2_LOOKUP_PARAMS_ENTRY		28
 #define SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY		44
+#define SJA1110_SIZE_GENERAL_PARAMS_ENTRY		56
 #define SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY		16
 #define SJA1105PQRS_SIZE_CBS_ENTRY			20
+#define SJA1110_SIZE_PCP_REMAPPING_ENTRY		4
 
 /* UM10944.pdf Page 11, Table 2. Configuration Blocks */
 enum {
@@ -61,6 +74,7 @@ enum {
 	BLKID_GENERAL_PARAMS				= 0x11,
 	BLKID_RETAGGING					= 0x12,
 	BLKID_CBS					= 0x13,
+	BLKID_PCP_REMAPPING				= 0x1C,
 	BLKID_XMII_PARAMS				= 0x4E,
 };
 
@@ -85,6 +99,7 @@ enum sja1105_blk_idx {
 	BLK_IDX_RETAGGING,
 	BLK_IDX_CBS,
 	BLK_IDX_XMII_PARAMS,
+	BLK_IDX_PCP_REMAPPING,
 	BLK_IDX_MAX,
 	/* Fake block indices that are only valid for dynamic access */
 	BLK_IDX_MGMT_ROUTE,
@@ -93,15 +108,22 @@ enum sja1105_blk_idx {
 };
 
 #define SJA1105_MAX_SCHEDULE_COUNT			1024
+#define SJA1110_MAX_SCHEDULE_COUNT			4096
 #define SJA1105_MAX_SCHEDULE_ENTRY_POINTS_COUNT		2048
 #define SJA1105_MAX_VL_LOOKUP_COUNT			1024
+#define SJA1110_MAX_VL_LOOKUP_COUNT			4096
 #define SJA1105_MAX_VL_POLICING_COUNT			1024
+#define SJA1110_MAX_VL_POLICING_COUNT			4096
 #define SJA1105_MAX_VL_FORWARDING_COUNT			1024
+#define SJA1110_MAX_VL_FORWARDING_COUNT			4096
 #define SJA1105_MAX_L2_LOOKUP_COUNT			1024
 #define SJA1105_MAX_L2_POLICING_COUNT			45
+#define SJA1110_MAX_L2_POLICING_COUNT			110
 #define SJA1105_MAX_VLAN_LOOKUP_COUNT			4096
 #define SJA1105_MAX_L2_FORWARDING_COUNT			13
+#define SJA1110_MAX_L2_FORWARDING_COUNT			19
 #define SJA1105_MAX_MAC_CONFIG_COUNT			5
+#define SJA1110_MAX_MAC_CONFIG_COUNT			11
 #define SJA1105_MAX_SCHEDULE_PARAMS_COUNT		1
 #define SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT	1
 #define SJA1105_MAX_VL_FORWARDING_PARAMS_COUNT		1
@@ -113,8 +135,11 @@ enum sja1105_blk_idx {
 #define SJA1105_MAX_AVB_PARAMS_COUNT			1
 #define SJA1105ET_MAX_CBS_COUNT				10
 #define SJA1105PQRS_MAX_CBS_COUNT			16
+#define SJA1110_MAX_CBS_COUNT				80
+#define SJA1110_MAX_PCP_REMAPPING_COUNT			11
 
 #define SJA1105_MAX_FRAME_MEMORY			929
+#define SJA1110_MAX_FRAME_MEMORY			1820
 #define SJA1105_FRAME_MEMORY_RETAGGING_OVERHEAD		19
 #define SJA1105_VL_FRAME_MEMORY				100
 
@@ -122,12 +147,26 @@ enum sja1105_blk_idx {
 #define SJA1105T_DEVICE_ID				0x9E00030Eull
 #define SJA1105PR_DEVICE_ID				0xAF00030Eull
 #define SJA1105QS_DEVICE_ID				0xAE00030Eull
+#define SJA1110_DEVICE_ID				0xB700030Full
 
 #define SJA1105ET_PART_NO				0x9A83
 #define SJA1105P_PART_NO				0x9A84
 #define SJA1105Q_PART_NO				0x9A85
 #define SJA1105R_PART_NO				0x9A86
 #define SJA1105S_PART_NO				0x9A87
+#define SJA1110A_PART_NO				0x1110
+#define SJA1110B_PART_NO				0x1111
+#define SJA1110C_PART_NO				0x1112
+#define SJA1110D_PART_NO				0x1113
+
+#define SJA1110_ACU			0x1c4400
+#define SJA1110_RGU			0x1c6000
+#define SJA1110_CGU			0x1c6400
+
+#define SJA1110_SPI_ADDR(x)		((x) / 4)
+#define SJA1110_ACU_ADDR(x)		(SJA1110_ACU + SJA1110_SPI_ADDR(x))
+#define SJA1110_CGU_ADDR(x)		(SJA1110_CGU + SJA1110_SPI_ADDR(x))
+#define SJA1110_RGU_ADDR(x)		(SJA1110_RGU + SJA1110_SPI_ADDR(x))
 
 #define SJA1105_RSV_ADDR		0xffffffffffffffffull
 
@@ -175,6 +214,8 @@ struct sja1105_general_params_entry {
 	u64 egrmirrpcp;
 	u64 egrmirrdei;
 	u64 replay_port;
+	/* SJA1110 only */
+	u64 tte_en;
 };
 
 struct sja1105_schedule_entry_points_entry {
@@ -195,6 +236,7 @@ struct sja1105_vlan_lookup_entry {
 	u64 vlan_bc;
 	u64 tag_port;
 	u64 vlanid;
+	u64 type_entry; /* SJA1110 only */
 };
 
 struct sja1105_l2_lookup_entry {
@@ -207,11 +249,17 @@ struct sja1105_l2_lookup_entry {
 	u64 mask_iotag;
 	u64 mask_vlanid;
 	u64 mask_macaddr;
+	u64 mask_srcport;
 	u64 iotag;
+	u64 srcport;
 	u64 lockeds;
 	union {
 		/* LOCKEDS=1: Static FDB entries */
 		struct {
+			/* TSREG is deprecated in SJA1110, TRAP is supported only
+			 * in SJA1110.
+			 */
+			u64 trap;
 			u64 tsreg;
 			u64 mirrvlan;
 			u64 takets;
@@ -227,7 +275,7 @@ struct sja1105_l2_lookup_entry {
 };
 
 struct sja1105_l2_lookup_params_entry {
-	u64 maxaddrp[5];     /* P/Q/R/S only */
+	u64 maxaddrp[SJA1105_MAX_NUM_PORTS]; /* P/Q/R/S only */
 	u64 start_dynspc;    /* P/Q/R/S only */
 	u64 drpnolearn;      /* P/Q/R/S only */
 	u64 use_static;      /* P/Q/R/S only */
@@ -245,7 +293,9 @@ struct sja1105_l2_forwarding_entry {
 	u64 bc_domain;
 	u64 reach_port;
 	u64 fl_domain;
-	u64 vlan_pmap[8];
+	/* This is actually max(SJA1105_NUM_TC, SJA1105_MAX_NUM_PORTS) */
+	u64 vlan_pmap[SJA1105_MAX_NUM_PORTS];
+	bool type_egrpcp2outputq;
 };
 
 struct sja1105_l2_forwarding_params_entry {
@@ -300,8 +350,8 @@ struct sja1105_retagging_entry {
 };
 
 struct sja1105_cbs_entry {
-	u64 port;
-	u64 prio;
+	u64 port; /* Not used for SJA1110 */
+	u64 prio; /* Not used for SJA1110 */
 	u64 credit_hi;
 	u64 credit_lo;
 	u64 send_slope;
@@ -309,8 +359,19 @@ struct sja1105_cbs_entry {
 };
 
 struct sja1105_xmii_params_entry {
-	u64 phy_mac[5];
-	u64 xmii_mode[5];
+	u64 phy_mac[SJA1105_MAX_NUM_PORTS];
+	u64 xmii_mode[SJA1105_MAX_NUM_PORTS];
+	/* The SJA1110 insists being a snowflake, and requires SGMII,
+	 * 2500base-x and internal MII ports connected to the 100base-TX PHY to
+	 * set this bit. We set it unconditionally from the high-level logic,
+	 * and only sja1110_xmii_params_entry_packing writes it to the static
+	 * config. I have no better name for it than "special".
+	 */
+	u64 special[SJA1105_MAX_NUM_PORTS];
+};
+
+struct sja1110_pcp_remapping_entry {
+	u64 egrpcp[SJA1105_NUM_TC];
 };
 
 enum {
@@ -391,6 +452,7 @@ extern const struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX];
 extern const struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX];
 extern const struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX];
 extern const struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX];
+extern const struct sja1105_table_ops sja1110_table_ops[BLK_IDX_MAX];
 
 size_t sja1105_table_header_packing(void *buf, void *hdr, enum packing_op op);
 void
@@ -438,23 +500,47 @@ void sja1105_packing(void *buf, u64 *val, int start, int end,
 /* Common implementations for the static and dynamic configs */
 size_t sja1105pqrs_general_params_entry_packing(void *buf, void *entry_ptr,
 						enum packing_op op);
+size_t sja1110_general_params_entry_packing(void *buf, void *entry_ptr,
+					    enum packing_op op);
 size_t sja1105pqrs_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
 						  enum packing_op op);
+size_t sja1110_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
+					      enum packing_op op);
 size_t sja1105_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
 					   enum packing_op op);
+size_t sja1110_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
+					   enum packing_op op);
 size_t sja1105pqrs_l2_lookup_entry_packing(void *buf, void *entry_ptr,
 					   enum packing_op op);
 size_t sja1105et_l2_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op);
+size_t sja1110_l2_lookup_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op);
 size_t sja1105_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op);
+size_t sja1110_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
+					 enum packing_op op);
 size_t sja1105_retagging_entry_packing(void *buf, void *entry_ptr,
 				       enum packing_op op);
+size_t sja1110_retagging_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op);
 size_t sja1105pqrs_mac_config_entry_packing(void *buf, void *entry_ptr,
 					    enum packing_op op);
+size_t sja1110_mac_config_entry_packing(void *buf, void *entry_ptr,
+					enum packing_op op);
 size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
 					    enum packing_op op);
 size_t sja1105_vl_lookup_entry_packing(void *buf, void *entry_ptr,
 				       enum packing_op op);
+size_t sja1110_vl_lookup_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op);
+size_t sja1110_vl_policing_entry_packing(void *buf, void *entry_ptr,
+					 enum packing_op op);
+size_t sja1110_xmii_params_entry_packing(void *buf, void *entry_ptr,
+					 enum packing_op op);
+size_t sja1110_l2_policing_entry_packing(void *buf, void *entry_ptr,
+					 enum packing_op op);
+size_t sja1110_l2_forwarding_params_entry_packing(void *buf, void *entry_ptr,
+						  enum packing_op op);
 
 #endif
-- 
2.25.1

