Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B87CF9CCF
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKLWQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:16:52 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39437 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKLWQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 17:16:52 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so4630272wmi.4
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 14:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DLB15s76Ats0WleoXeRXwOFcDU8VcDp8DnlG0pi+7sI=;
        b=rzeB3gwQ3uMjwQZBqYk1emt7xf2au7opo9WIYxtGSmlk+0y/9HkD3Tk6jfVQZE39rD
         yOvQujKJdQAnYrsdSv30u3rDHCzkvr7jFzgPX3ATFdB3dfNsTWpbPuw3STy0ADJGh84e
         E3NJkJbrMQsJtRfCKpNr4P48uYIVmIKSqQVBz6Ghi1R2P9tokoCgvpTpdTT5Y8960vVe
         GAwYSiPuryGofS8jqB+WPszdO8gwyRPmS5u7cUa6yaTtvPnTShBwZrSSYdVqK26v32bZ
         6sxqeYiFP5yf+nCaKVZSbQ+XmAwDNQI+jiKtpp/LZL/sKGpbwy17zRLrCEabFuSKZQJ7
         3bjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DLB15s76Ats0WleoXeRXwOFcDU8VcDp8DnlG0pi+7sI=;
        b=DNsgBmYTLaQcdFz1NEMSMol7z7ucy4ZPudHyX6P4yMYpdZNMSBdRzzZVbi2g0M+v52
         9dTshOeXOVcSlrDdgtzPmiuowCjUk1vCtgdvzfhe2rSHp/cVdHOb0XxKc0ydgxznVZCO
         isn3X8AEVez96ZTI8USMurKqy4F5SHSYAJBKixjYQgGeRgGAycCJX/BQvb2u7wDNvtWo
         ADqt9D0qNpTPbBL4rHBdi4txNs4jnIqIY7xFR+JaEVGbb/8sJj5EOB5Ixw/zEuEFIPhp
         R9s6dB2pTE4npoXnJJKAp8NB6cdmpKnUfjbKO4hKwySbsPxGWc4t1+BOZeEMz72CNALn
         gKLg==
X-Gm-Message-State: APjAAAX33xgSqkT3rRstvBwaSmnGzytXupTynlRU29xX13M9VMUWDG8A
        eNGWvnWwscutZrgCF9SZgHQ=
X-Google-Smtp-Source: APXvYqxA+FhjAF7ZW1RVq/Px4fRtaFCTsBt/zml1VVUF7XX9ndpu52O7Z12vUeK+GmyJZgPLjd2szQ==
X-Received: by 2002:a1c:7e0e:: with SMTP id z14mr6529603wmc.52.1573597009153;
        Tue, 12 Nov 2019 14:16:49 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id x7sm376907wrg.63.2019.11.12.14.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 14:16:48 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: sja1105: Simplify reset handling
Date:   Wed, 13 Nov 2019 00:16:41 +0200
Message-Id: <20191112221641.15437-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't really need 10k species of reset. Remove everything except cold
reset which is what is actually used. Too bad the hardware designers
couldn't agree to use the same bit field for rev 1 and rev 2, so the
(*reset_cmd) function pointer is there to stay.

However let's simplify the prototype and give it a struct dsa_switch (we
want to avoid forward-declarations of structures, in this case struct
sja1105_private, wherever we can).

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h     |   2 +-
 drivers/net/dsa/sja1105/sja1105_spi.c | 110 ++++----------------------
 2 files changed, 15 insertions(+), 97 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 29c7ed60cfdc..d801fc204d19 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -78,7 +78,7 @@ struct sja1105_info {
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
-	int (*reset_cmd)(const void *ctx, const void *data);
+	int (*reset_cmd)(struct dsa_switch *ds);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
 	/* Prototypes from include/net/dsa.h */
 	int (*fdb_add_cmd)(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index fca3a973764b..29b127f3bf9c 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -205,116 +205,34 @@ int sja1105_xfer_u32(const struct sja1105_private *priv,
 	return rc;
 }
 
-/* Back-ported structure from UM11040 Table 112.
- * Reset control register (addr. 100440h)
- * In the SJA1105 E/T, only warm_rst and cold_rst are
- * supported (exposed in UM10944 as rst_ctrl), but the bit
- * offsets of warm_rst and cold_rst are actually reversed.
- */
-struct sja1105_reset_cmd {
-	u64 switch_rst;
-	u64 cfg_rst;
-	u64 car_rst;
-	u64 otp_rst;
-	u64 warm_rst;
-	u64 cold_rst;
-	u64 por_rst;
-};
-
-static void
-sja1105et_reset_cmd_pack(void *buf, const struct sja1105_reset_cmd *reset)
+static int sja1105et_reset_cmd(struct dsa_switch *ds)
 {
-	const int size = SJA1105_SIZE_RESET_CMD;
-
-	memset(buf, 0, size);
-
-	sja1105_pack(buf, &reset->cold_rst, 3, 3, size);
-	sja1105_pack(buf, &reset->warm_rst, 2, 2, size);
-}
-
-static void
-sja1105pqrs_reset_cmd_pack(void *buf, const struct sja1105_reset_cmd *reset)
-{
-	const int size = SJA1105_SIZE_RESET_CMD;
-
-	memset(buf, 0, size);
-
-	sja1105_pack(buf, &reset->switch_rst, 8, 8, size);
-	sja1105_pack(buf, &reset->cfg_rst,    7, 7, size);
-	sja1105_pack(buf, &reset->car_rst,    5, 5, size);
-	sja1105_pack(buf, &reset->otp_rst,    4, 4, size);
-	sja1105_pack(buf, &reset->warm_rst,   3, 3, size);
-	sja1105_pack(buf, &reset->cold_rst,   2, 2, size);
-	sja1105_pack(buf, &reset->por_rst,    1, 1, size);
-}
-
-static int sja1105et_reset_cmd(const void *ctx, const void *data)
-{
-	const struct sja1105_private *priv = ctx;
-	const struct sja1105_reset_cmd *reset = data;
+	struct sja1105_private *priv = ds->priv;
 	const struct sja1105_regs *regs = priv->info->regs;
-	struct device *dev = priv->ds->dev;
-	u8 packed_buf[SJA1105_SIZE_RESET_CMD];
-
-	if (reset->switch_rst ||
-	    reset->cfg_rst ||
-	    reset->car_rst ||
-	    reset->otp_rst ||
-	    reset->por_rst) {
-		dev_err(dev, "Only warm and cold reset is supported "
-			"for SJA1105 E/T!\n");
-		return -EINVAL;
-	}
-
-	if (reset->warm_rst)
-		dev_dbg(dev, "Warm reset requested\n");
-	if (reset->cold_rst)
-		dev_dbg(dev, "Cold reset requested\n");
+	u8 packed_buf[SJA1105_SIZE_RESET_CMD] = {0};
+	const int size = SJA1105_SIZE_RESET_CMD;
+	u64 cold_rst = 1;
 
-	sja1105et_reset_cmd_pack(packed_buf, reset);
+	sja1105_pack(packed_buf, &cold_rst, 3, 3, size);
 
 	return sja1105_xfer_buf(priv, SPI_WRITE, regs->rgu, packed_buf,
 				SJA1105_SIZE_RESET_CMD);
 }
 
-static int sja1105pqrs_reset_cmd(const void *ctx, const void *data)
+static int sja1105pqrs_reset_cmd(struct dsa_switch *ds)
 {
-	const struct sja1105_private *priv = ctx;
-	const struct sja1105_reset_cmd *reset = data;
+	struct sja1105_private *priv = ds->priv;
 	const struct sja1105_regs *regs = priv->info->regs;
-	struct device *dev = priv->ds->dev;
-	u8 packed_buf[SJA1105_SIZE_RESET_CMD];
-
-	if (reset->switch_rst)
-		dev_dbg(dev, "Main reset for all functional modules requested\n");
-	if (reset->cfg_rst)
-		dev_dbg(dev, "Chip configuration reset requested\n");
-	if (reset->car_rst)
-		dev_dbg(dev, "Clock and reset control logic reset requested\n");
-	if (reset->otp_rst)
-		dev_dbg(dev, "OTP read cycle for reading product "
-			"config settings requested\n");
-	if (reset->warm_rst)
-		dev_dbg(dev, "Warm reset requested\n");
-	if (reset->cold_rst)
-		dev_dbg(dev, "Cold reset requested\n");
-	if (reset->por_rst)
-		dev_dbg(dev, "Power-on reset requested\n");
-
-	sja1105pqrs_reset_cmd_pack(packed_buf, reset);
+	u8 packed_buf[SJA1105_SIZE_RESET_CMD] = {0};
+	const int size = SJA1105_SIZE_RESET_CMD;
+	u64 cold_rst = 1;
+
+	sja1105_pack(packed_buf, &cold_rst, 2, 2, size);
 
 	return sja1105_xfer_buf(priv, SPI_WRITE, regs->rgu, packed_buf,
 				SJA1105_SIZE_RESET_CMD);
 }
 
-static int sja1105_cold_reset(const struct sja1105_private *priv)
-{
-	struct sja1105_reset_cmd reset = {0};
-
-	reset.cold_rst = 1;
-	return priv->info->reset_cmd(priv, &reset);
-}
-
 int sja1105_inhibit_tx(const struct sja1105_private *priv,
 		       unsigned long port_bitmap, bool tx_inhibited)
 {
@@ -459,7 +377,7 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 	usleep_range(500, 1000);
 	do {
 		/* Put the SJA1105 in programming mode */
-		rc = sja1105_cold_reset(priv);
+		rc = priv->info->reset_cmd(priv->ds);
 		if (rc < 0) {
 			dev_err(dev, "Failed to reset switch, retrying...\n");
 			continue;
-- 
2.17.1

