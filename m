Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65882C40E6
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfJATSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:18:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37177 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfJATSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:18:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id f22so4453472wmc.2
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 12:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RXr9d1YoyCl6P8j0bc5r/fbtGG841JrZYQqz0ZqW7bw=;
        b=ADj3z7tPiAilZw7WzOPRtPnOnjPiO3X09QiPMOzFW2RqMJz1UDVZEq8l6bgFTc/Ip2
         Aqr4GBWjCfOzj3vMAIcCIczNp29MQMOV+jwqELINBvygux0yPgEKKxV/zHTMhEqjzyOo
         FXJ75NeyfPKGdC0j9Nep+5mxchJLeoQ3wDKF9VYbSMc28qHtw4DLt9kNI/PVj1PDA5Ws
         uJfpVJgHu0Wk/lXEh0rsh9ecqweLAqQ0u5K/aOnLmkxLk1xwtueR9QjDUDdz/Gk3rZnf
         7kj4AQ9XGBKaDmaXD8QoNMMoztiA10y6nvf04EwxIrYqgxVOPUcumoAYBmygZFkV1coL
         NzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RXr9d1YoyCl6P8j0bc5r/fbtGG841JrZYQqz0ZqW7bw=;
        b=iH/oiGthJfF8mw6rKyvUbY2o8dG8FLxGSmBT3BXB96sZNbQqgRePeBzTGUVtI0HR53
         THD9kjQejJOTut/kRr1mYgWCcFiRvhp0dazEb+IClu2wtJQo3S9piUO8UwhguJaLVU9r
         WoRkaBELEC/D6TWM9yZJsoHB8ltJ1/1HrGd4ujviXSNTP1ShTBzSouZ0h6Ecidbz5CHu
         +JoETf123tSWRLxbJdJxhdHYOtKynMG9WIKgJv9H38aJ9kRt+i/6pFkmqbJDhpYkxKW8
         CJ0S2kJXeRmL03ke9mH4hB/qOokXUuDDnX/HG7r4kmsj4KKG9LPH7V3C05hrpUTy8Y1f
         uGhQ==
X-Gm-Message-State: APjAAAVCN1kMNBIsC5kJBy9PrxCdWjBF7JscdY9k+JNpkkFhFMO9TRC2
        mK4xZ+ZNlRI7fNwl8NcK3FQ=
X-Google-Smtp-Source: APXvYqzA5loUfftTYixWwFUxbsXZ+pQ6D8/xkwUaM6dkg6lKJeRYd3UYZORZu5fHWSiS6/V60B0jKw==
X-Received: by 2002:a1c:544e:: with SMTP id p14mr4826432wmi.72.1569957509013;
        Tue, 01 Oct 2019 12:18:29 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id e6sm15214299wrp.91.2019.10.01.12.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:18:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: sja1105: Rename sja1105_spi_send_packed_buf to sja1105_xfer_buf
Date:   Tue,  1 Oct 2019 22:18:01 +0300
Message-Id: <20191001191801.9130-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191001191801.9130-1-olteanv@gmail.com>
References: <20191001191801.9130-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The most commonly called function in the driver is long due for a
rename. The "packed" word is redundant (it doesn't make sense to
transfer an unpacked structure, since that is in CPU endianness yadda
yadda), and the "spi" word is also redundant since argument 2 of the
function is SPI_READ or SPI_WRITE.

As for the sja1105_spi_send_long_packed_buf function, it is only being
used from sja1105_spi.c, so remove its global prototype.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h             |  9 +--
 drivers/net/dsa/sja1105/sja1105_clocking.c    | 63 ++++++++-----------
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 12 ++--
 drivers/net/dsa/sja1105/sja1105_ethtool.c     | 16 ++---
 drivers/net/dsa/sja1105/sja1105_main.c        |  4 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c         | 14 ++---
 drivers/net/dsa/sja1105/sja1105_spi.c         | 39 ++++++------
 7 files changed, 69 insertions(+), 88 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index cba0beb87d9c..8681ff9d1a76 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -127,16 +127,13 @@ typedef enum {
 int sja1105_static_config_reload(struct sja1105_private *priv);
 
 /* From sja1105_spi.c */
-int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
-				sja1105_spi_rw_mode_t rw, u64 reg_addr,
-				void *packed_buf, size_t size_bytes);
+int sja1105_xfer_buf(const struct sja1105_private *priv,
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr,
+		     void *packed_buf, size_t size_bytes);
 int sja1105_xfer_u32(const struct sja1105_private *priv,
 		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u32 *value);
 int sja1105_xfer_u64(const struct sja1105_private *priv,
 		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u64 *value);
-int sja1105_spi_send_long_packed_buf(const struct sja1105_private *priv,
-				     sja1105_spi_rw_mode_t rw, u64 base_addr,
-				     void *packed_buf, u64 buf_len);
 int sja1105_static_config_upload(struct sja1105_private *priv);
 int sja1105_inhibit_tx(const struct sja1105_private *priv,
 		       unsigned long port_bitmap, bool tx_inhibited);
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 2903f5dbd182..9082e52b55e9 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -118,9 +118,8 @@ static int sja1105_cgu_idiv_config(struct sja1105_private *priv, int port,
 	idiv.pd        = enabled ? 0 : 1; /* Power down? */
 	sja1105_cgu_idiv_packing(packed_buf, &idiv, PACK);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->cgu_idiv[port], packed_buf,
-					   SJA1105_SIZE_CGU_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->cgu_idiv[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
 static void
@@ -167,9 +166,8 @@ static int sja1105_cgu_mii_tx_clk_config(struct sja1105_private *priv,
 	mii_tx_clk.pd        = 0;  /* Power Down off => enabled */
 	sja1105_cgu_mii_control_packing(packed_buf, &mii_tx_clk, PACK);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->mii_tx_clk[port], packed_buf,
-					   SJA1105_SIZE_CGU_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->mii_tx_clk[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
 static int
@@ -192,9 +190,8 @@ sja1105_cgu_mii_rx_clk_config(struct sja1105_private *priv, int port)
 	mii_rx_clk.pd        = 0;  /* Power Down off => enabled */
 	sja1105_cgu_mii_control_packing(packed_buf, &mii_rx_clk, PACK);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->mii_rx_clk[port], packed_buf,
-					   SJA1105_SIZE_CGU_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->mii_rx_clk[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
 static int
@@ -217,9 +214,8 @@ sja1105_cgu_mii_ext_tx_clk_config(struct sja1105_private *priv, int port)
 	mii_ext_tx_clk.pd        = 0; /* Power Down off => enabled */
 	sja1105_cgu_mii_control_packing(packed_buf, &mii_ext_tx_clk, PACK);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->mii_ext_tx_clk[port],
-					   packed_buf, SJA1105_SIZE_CGU_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->mii_ext_tx_clk[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
 static int
@@ -242,9 +238,8 @@ sja1105_cgu_mii_ext_rx_clk_config(struct sja1105_private *priv, int port)
 	mii_ext_rx_clk.pd        = 0; /* Power Down off => enabled */
 	sja1105_cgu_mii_control_packing(packed_buf, &mii_ext_rx_clk, PACK);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->mii_ext_rx_clk[port],
-					   packed_buf, SJA1105_SIZE_CGU_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->mii_ext_rx_clk[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
 static int sja1105_mii_clocking_setup(struct sja1105_private *priv, int port,
@@ -337,9 +332,8 @@ static int sja1105_cgu_rgmii_tx_clk_config(struct sja1105_private *priv,
 	txc.pd = 0;
 	sja1105_cgu_mii_control_packing(packed_buf, &txc, PACK);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->rgmii_tx_clk[port],
-					   packed_buf, SJA1105_SIZE_CGU_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->rgmii_tx_clk[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
 /* AGU */
@@ -383,9 +377,8 @@ static int sja1105_rgmii_cfg_pad_tx_config(struct sja1105_private *priv,
 	pad_mii_tx.clk_ipud  = 2; /* TX_CLK input stage (default) */
 	sja1105_cfg_pad_mii_tx_packing(packed_buf, &pad_mii_tx, PACK);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->pad_mii_tx[port],
-					   packed_buf, SJA1105_SIZE_CGU_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->pad_mii_tx[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
 static void
@@ -442,9 +435,8 @@ int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port)
 	pad_mii_id.txc_pd = 1;
 	sja1105_cfg_pad_mii_id_packing(packed_buf, &pad_mii_id, PACK);
 
-	rc = sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					 regs->pad_mii_id[port],
-					 packed_buf, SJA1105_SIZE_CGU_CMD);
+	rc = sja1105_xfer_buf(priv, SPI_WRITE, regs->pad_mii_id[port],
+			      packed_buf, SJA1105_SIZE_CGU_CMD);
 	if (rc < 0)
 		return rc;
 
@@ -459,9 +451,8 @@ int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port)
 	}
 	sja1105_cfg_pad_mii_id_packing(packed_buf, &pad_mii_id, PACK);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->pad_mii_id[port],
-					   packed_buf, SJA1105_SIZE_CGU_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->pad_mii_id[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
 static int sja1105_rgmii_clocking_setup(struct sja1105_private *priv, int port,
@@ -547,9 +538,8 @@ static int sja1105_cgu_rmii_ref_clk_config(struct sja1105_private *priv,
 	ref_clk.pd        = 0;      /* Power Down off => enabled */
 	sja1105_cgu_mii_control_packing(packed_buf, &ref_clk, PACK);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->rmii_ref_clk[port],
-					   packed_buf, SJA1105_SIZE_CGU_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->rmii_ref_clk[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
 static int
@@ -565,9 +555,8 @@ sja1105_cgu_rmii_ext_tx_clk_config(struct sja1105_private *priv, int port)
 	ext_tx_clk.pd        = 0;   /* Power Down off => enabled */
 	sja1105_cgu_mii_control_packing(packed_buf, &ext_tx_clk, PACK);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->rmii_ext_tx_clk[port],
-					   packed_buf, SJA1105_SIZE_CGU_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->rmii_ext_tx_clk[port],
+				packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
 static int sja1105_cgu_rmii_pll_config(struct sja1105_private *priv)
@@ -595,8 +584,8 @@ static int sja1105_cgu_rmii_pll_config(struct sja1105_private *priv)
 	pll.pd        = 0x1;
 
 	sja1105_cgu_pll_control_packing(packed_buf, &pll, PACK);
-	rc = sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->rmii_pll1,
-					 packed_buf, SJA1105_SIZE_CGU_CMD);
+	rc = sja1105_xfer_buf(priv, SPI_WRITE, regs->rmii_pll1, packed_buf,
+			      SJA1105_SIZE_CGU_CMD);
 	if (rc < 0) {
 		dev_err(dev, "failed to configure PLL1 for 50MHz\n");
 		return rc;
@@ -606,8 +595,8 @@ static int sja1105_cgu_rmii_pll_config(struct sja1105_private *priv)
 	pll.pd = 0x0;
 
 	sja1105_cgu_pll_control_packing(packed_buf, &pll, PACK);
-	rc = sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->rmii_pll1,
-					 packed_buf, SJA1105_SIZE_CGU_CMD);
+	rc = sja1105_xfer_buf(priv, SPI_WRITE, regs->rmii_pll1, packed_buf,
+			      SJA1105_SIZE_CGU_CMD);
 	if (rc < 0) {
 		dev_err(dev, "failed to enable PLL1\n");
 		return rc;
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 91da430045ff..25381bd65ed7 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -686,8 +686,8 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 		ops->entry_packing(packed_buf, entry, PACK);
 
 	/* Send SPI write operation: read config table entry */
-	rc = sja1105_spi_send_packed_buf(priv, SPI_WRITE, ops->addr,
-					 packed_buf, ops->packed_size);
+	rc = sja1105_xfer_buf(priv, SPI_WRITE, ops->addr, packed_buf,
+			      ops->packed_size);
 	if (rc < 0)
 		return rc;
 
@@ -698,8 +698,8 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 		memset(packed_buf, 0, ops->packed_size);
 
 		/* Retrieve the read operation's result */
-		rc = sja1105_spi_send_packed_buf(priv, SPI_READ, ops->addr,
-						 packed_buf, ops->packed_size);
+		rc = sja1105_xfer_buf(priv, SPI_READ, ops->addr, packed_buf,
+				      ops->packed_size);
 		if (rc < 0)
 			return rc;
 
@@ -771,8 +771,8 @@ int sja1105_dynamic_config_write(struct sja1105_private *priv,
 		ops->entry_packing(packed_buf, entry, PACK);
 
 	/* Send SPI write operation: read config table entry */
-	rc = sja1105_spi_send_packed_buf(priv, SPI_WRITE, ops->addr,
-					 packed_buf, ops->packed_size);
+	rc = sja1105_xfer_buf(priv, SPI_WRITE, ops->addr, packed_buf,
+			      ops->packed_size);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
index ab581a28cd41..064301cc7d5b 100644
--- a/drivers/net/dsa/sja1105/sja1105_ethtool.c
+++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
@@ -167,8 +167,8 @@ static int sja1105_port_status_get_mac(struct sja1105_private *priv,
 	int rc;
 
 	/* MAC area */
-	rc = sja1105_spi_send_packed_buf(priv, SPI_READ, regs->mac[port],
-					 packed_buf, SJA1105_SIZE_MAC_AREA);
+	rc = sja1105_xfer_buf(priv, SPI_READ, regs->mac[port], packed_buf,
+			      SJA1105_SIZE_MAC_AREA);
 	if (rc < 0)
 		return rc;
 
@@ -185,8 +185,8 @@ static int sja1105_port_status_get_hl1(struct sja1105_private *priv,
 	u8 packed_buf[SJA1105_SIZE_HL1_AREA] = {0};
 	int rc;
 
-	rc = sja1105_spi_send_packed_buf(priv, SPI_READ, regs->mac_hl1[port],
-					 packed_buf, SJA1105_SIZE_HL1_AREA);
+	rc = sja1105_xfer_buf(priv, SPI_READ, regs->mac_hl1[port], packed_buf,
+			      SJA1105_SIZE_HL1_AREA);
 	if (rc < 0)
 		return rc;
 
@@ -203,8 +203,8 @@ static int sja1105_port_status_get_hl2(struct sja1105_private *priv,
 	u8 packed_buf[SJA1105_SIZE_QLEVEL_AREA] = {0};
 	int rc;
 
-	rc = sja1105_spi_send_packed_buf(priv, SPI_READ, regs->mac_hl2[port],
-					 packed_buf, SJA1105_SIZE_HL2_AREA);
+	rc = sja1105_xfer_buf(priv, SPI_READ, regs->mac_hl2[port], packed_buf,
+			      SJA1105_SIZE_HL2_AREA);
 	if (rc < 0)
 		return rc;
 
@@ -215,8 +215,8 @@ static int sja1105_port_status_get_hl2(struct sja1105_private *priv,
 	    priv->info->device_id == SJA1105T_DEVICE_ID)
 		return 0;
 
-	rc = sja1105_spi_send_packed_buf(priv, SPI_READ, regs->qlevel[port],
-					 packed_buf, SJA1105_SIZE_QLEVEL_AREA);
+	rc = sja1105_xfer_buf(priv, SPI_READ, regs->qlevel[port], packed_buf,
+			      SJA1105_SIZE_QLEVEL_AREA);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b95c7163ea5e..6c18083e0a1e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2126,8 +2126,8 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
 		return -ENODEV;
 	}
 
-	rc = sja1105_spi_send_packed_buf(priv, SPI_READ, regs->prod_id,
-					 prod_id, SJA1105_SIZE_DEVICE_ID);
+	rc = sja1105_xfer_buf(priv, SPI_READ, regs->prod_id, prod_id,
+			      SJA1105_SIZE_DEVICE_ID);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 42cc698fcc90..0df1bbec475a 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -91,8 +91,8 @@ int sja1105et_ptp_cmd(const void *ctx, const void *data)
 	sja1105_pack(buf, &valid,           31, 31, size);
 	sja1105_pack(buf, &cmd->resptp,      2,  2, size);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->ptp_control,
-					   buf, SJA1105_SIZE_PTP_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->ptp_control, buf,
+				SJA1105_SIZE_PTP_CMD);
 }
 
 int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
@@ -108,8 +108,8 @@ int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
 	sja1105_pack(buf, &valid,           31, 31, size);
 	sja1105_pack(buf, &cmd->resptp,      3,  3, size);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->ptp_control,
-					   buf, SJA1105_SIZE_PTP_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->ptp_control, buf,
+				SJA1105_SIZE_PTP_CMD);
 }
 
 /* The switch returns partial timestamps (24 bits for SJA1105 E/T, which wrap
@@ -180,10 +180,8 @@ int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
 	int rc;
 
 	do {
-		rc = sja1105_spi_send_packed_buf(priv, SPI_READ,
-						 regs->ptpegr_ts[port],
-						 packed_buf,
-						 priv->info->ptpegr_ts_bytes);
+		rc = sja1105_xfer_buf(priv, SPI_READ, regs->ptpegr_ts[port],
+				      packed_buf, priv->info->ptpegr_ts_bytes);
 		if (rc < 0)
 			return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index a05d746510c0..4688467c6d18 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -63,11 +63,11 @@ sja1105_spi_message_pack(void *buf, const struct sja1105_spi_message *msg)
  *
  * This function should only be called if it is priorly known that
  * @size_bytes is smaller than SIZE_SPI_MSG_MAXLEN. Larger packed buffers
- * are chunked in smaller pieces by sja1105_spi_send_long_packed_buf below.
+ * are chunked in smaller pieces by sja1105_xfer_long_buf below.
  */
-int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
-				sja1105_spi_rw_mode_t rw, u64 reg_addr,
-				void *packed_buf, size_t size_bytes)
+int sja1105_xfer_buf(const struct sja1105_private *priv,
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr,
+		     void *packed_buf, size_t size_bytes)
 {
 	u8 tx_buf[SJA1105_SIZE_SPI_TRANSFER_MAX] = {0};
 	u8 rx_buf[SJA1105_SIZE_SPI_TRANSFER_MAX] = {0};
@@ -118,7 +118,7 @@ int sja1105_xfer_u64(const struct sja1105_private *priv,
 	if (rw == SPI_WRITE)
 		sja1105_pack(packed_buf, value, 63, 0, 8);
 
-	rc = sja1105_spi_send_packed_buf(priv, rw, reg_addr, packed_buf, 8);
+	rc = sja1105_xfer_buf(priv, rw, reg_addr, packed_buf, 8);
 
 	if (rw == SPI_READ)
 		sja1105_unpack(packed_buf, value, 63, 0, 8);
@@ -142,7 +142,7 @@ int sja1105_xfer_u32(const struct sja1105_private *priv,
 		sja1105_pack(packed_buf, &tmp, 31, 0, 4);
 	}
 
-	rc = sja1105_spi_send_packed_buf(priv, rw, reg_addr, packed_buf, 4);
+	rc = sja1105_xfer_buf(priv, rw, reg_addr, packed_buf, 4);
 
 	if (rw == SPI_READ) {
 		sja1105_unpack(packed_buf, &tmp, 31, 0, 4);
@@ -156,9 +156,9 @@ int sja1105_xfer_u32(const struct sja1105_private *priv,
  * must be sent/received. Splitting the buffer into chunks and assembling
  * those into SPI messages is done automatically by this function.
  */
-int sja1105_spi_send_long_packed_buf(const struct sja1105_private *priv,
-				     sja1105_spi_rw_mode_t rw, u64 base_addr,
-				     void *packed_buf, u64 buf_len)
+int sja1105_xfer_long_buf(const struct sja1105_private *priv,
+			  sja1105_spi_rw_mode_t rw, u64 base_addr,
+			  void *packed_buf, u64 buf_len)
 {
 	struct chunk {
 		void *buf_ptr;
@@ -174,8 +174,8 @@ int sja1105_spi_send_long_packed_buf(const struct sja1105_private *priv,
 	chunk.len = min_t(int, buf_len, SJA1105_SIZE_SPI_MSG_MAXLEN);
 
 	while (chunk.len) {
-		rc = sja1105_spi_send_packed_buf(priv, rw, chunk.spi_address,
-						 chunk.buf_ptr, chunk.len);
+		rc = sja1105_xfer_buf(priv, rw, chunk.spi_address,
+				      chunk.buf_ptr, chunk.len);
 		if (rc < 0)
 			return rc;
 
@@ -257,8 +257,8 @@ static int sja1105et_reset_cmd(const void *ctx, const void *data)
 
 	sja1105et_reset_cmd_pack(packed_buf, reset);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->rgu,
-					   packed_buf, SJA1105_SIZE_RESET_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->rgu, packed_buf,
+				SJA1105_SIZE_RESET_CMD);
 }
 
 static int sja1105pqrs_reset_cmd(const void *ctx, const void *data)
@@ -287,8 +287,8 @@ static int sja1105pqrs_reset_cmd(const void *ctx, const void *data)
 
 	sja1105pqrs_reset_cmd_pack(packed_buf, reset);
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->rgu,
-					   packed_buf, SJA1105_SIZE_RESET_CMD);
+	return sja1105_xfer_buf(priv, SPI_WRITE, regs->rgu, packed_buf,
+				SJA1105_SIZE_RESET_CMD);
 }
 
 static int sja1105_cold_reset(const struct sja1105_private *priv)
@@ -355,9 +355,7 @@ static int sja1105_status_get(struct sja1105_private *priv,
 	u8 packed_buf[4];
 	int rc;
 
-	rc = sja1105_spi_send_packed_buf(priv, SPI_READ,
-					 regs->status,
-					 packed_buf, 4);
+	rc = sja1105_xfer_buf(priv, SPI_READ, regs->status, packed_buf, 4);
 	if (rc < 0)
 		return rc;
 
@@ -453,9 +451,8 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 		/* Wait for the switch to come out of reset */
 		usleep_range(1000, 5000);
 		/* Upload the static config to the device */
-		rc = sja1105_spi_send_long_packed_buf(priv, SPI_WRITE,
-						      regs->config,
-						      config_buf, buf_len);
+		rc = sja1105_xfer_long_buf(priv, SPI_WRITE, regs->config,
+					   config_buf, buf_len);
 		if (rc < 0) {
 			dev_err(dev, "Failed to upload config, retrying...\n");
 			continue;
-- 
2.17.1

