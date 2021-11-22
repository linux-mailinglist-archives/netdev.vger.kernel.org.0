Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FB2459148
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239956AbhKVP1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239925AbhKVP1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:27:31 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AB7C06174A;
        Mon, 22 Nov 2021 07:24:24 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id t5so78951685edd.0;
        Mon, 22 Nov 2021 07:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i7asl7LlsOD6C6dosOKTocUVyT73eN0SSoYJM1bMlSw=;
        b=QRYUYxp05azLODHTPPid5gLDFAB7kYAjqCzjfVava8t2B+2tQdy5VYf+7usQJc0fcs
         HNicyU0kTZ2Hxf/HUAr4G4Wdm8jaDJCjX1wJNEy69n+GG+v5Hrm8YWVTxSK99hj/BD/n
         kpzAD9EzOyAsVlkfdXAT4eaXV8gkEsrd6CW1LTBe0RY6vfJSt8HiWXWCqUTpdV8Rvc9f
         10xmq5a+2KAJVPgU2+Rvvs5JPXipdxb6ulyD/XBvR5/3oAElZzZlpJTtYqgGWitnWszD
         PAJGc+rVwG+QrKTiBJecte9PmsdUro86rgQNap8WChEVGVPzMjIjWe+WMVN7ZFE6V11t
         iBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i7asl7LlsOD6C6dosOKTocUVyT73eN0SSoYJM1bMlSw=;
        b=VeDpmVDPfoL/4kUHbiYYwhMsrcfq5IZLVu/3gK/Az/QlNWxVRIOTxDSqtlnakrZGiQ
         wTCzkfH1jBt6e7VwTdPHcxqllMQV011rRHv9rKR8b1usk9E667pUZ9o+bVON30ZXo1Mb
         kxIIc/vPyqOGwWROdssygBkrWzNQT0YKkmTAMj6HOMaIjpjlWRftQ5x/WcenEL91nMuI
         ovAA7/FtOVS4Kxs0Zg4j++Dez9Ho8/b8cu50K8qNynHd4v3Mll2MiuP2GXz0TOUyS63j
         Lix1HnqZv7b8I/aU/miyzWEuGPTXATs1hyclNdOwy8rvR6harjoLlqZoGKGeray076z+
         cNsw==
X-Gm-Message-State: AOAM533xCct/NXmyVmWMOswrkiIHH3vLV10gPS+zh+TRJSIIlaOaia1G
        KUqxfFa9j2S+dHYJaClxCB8=
X-Google-Smtp-Source: ABdhPJzmO1o7TuuTvY1oJOfvfZXLZnxroO8oYo83MiiTKGQ6uVzFIbs98tHinb/5FLBqAEhjhGs0RQ==
X-Received: by 2002:a05:6402:2d9:: with SMTP id b25mr66652974edx.383.1637594659093;
        Mon, 22 Nov 2021 07:24:19 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id sb19sm3995307ejc.120.2021.11.22.07.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:24:18 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 5/9] net: dsa: qca8k: initial conversion to regmap helper
Date:   Mon, 22 Nov 2021 16:23:44 +0100
Message-Id: <20211122152348.6634-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122152348.6634-1-ansuelsmth@gmail.com>
References: <20211122152348.6634-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert any qca8k set/clear/pool to regmap helper and add
missing config to regmap_config struct.
Read/write/rmw operation are reworked to use the regmap helper
internally to keep the delta of this patch low. These additional
function will then be dropped when the code split will be proposed.

Ipq40xx SoC have the internal switch based on the qca8k regmap but use
mmio for read/write/rmw operation instead of mdio.
In preparation for the support of this internal switch, convert the
driver to regmap API to later split the driver to common and specific
code. The overhead introduced by the use of regamp API is marginal as the
internal mdio will bypass it by using its direct access and regmap will be
used only by configuration functions or fdb access.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 107 ++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 60 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index f63a43291636..d64a9af186be 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -10,6 +10,7 @@
 #include <linux/phy.h>
 #include <linux/netdevice.h>
 #include <linux/bitfield.h>
+#include <linux/regmap.h>
 #include <net/dsa.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
@@ -152,6 +153,25 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 static int
 qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
 {
+	return regmap_read(priv->regmap, reg, val);
+}
+
+static int
+qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
+{
+	return regmap_write(priv->regmap, reg, val);
+}
+
+static int
+qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
+{
+	return regmap_update_bits(priv->regmap, reg, mask, write_val);
+}
+
+static int
+qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
@@ -172,8 +192,9 @@ qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
 }
 
 static int
-qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
+qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 {
+	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
@@ -194,8 +215,9 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 }
 
 static int
-qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
+qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
 {
+	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
@@ -223,34 +245,6 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 	return ret;
 }
 
-static int
-qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
-{
-	return qca8k_rmw(priv, reg, 0, val);
-}
-
-static int
-qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
-{
-	return qca8k_rmw(priv, reg, val, 0);
-}
-
-static int
-qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
-
-	return qca8k_read(priv, reg, val);
-}
-
-static int
-qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
-
-	return qca8k_write(priv, reg, val);
-}
-
 static const struct regmap_range qca8k_readable_ranges[] = {
 	regmap_reg_range(0x0000, 0x00e4), /* Global control */
 	regmap_reg_range(0x0100, 0x0168), /* EEE control */
@@ -282,26 +276,19 @@ static struct regmap_config qca8k_regmap_config = {
 	.max_register = 0x16ac, /* end MIB - Port6 range */
 	.reg_read = qca8k_regmap_read,
 	.reg_write = qca8k_regmap_write,
+	.reg_update_bits = qca8k_regmap_update_bits,
 	.rd_table = &qca8k_readable_table,
+	.disable_locking = true, /* Locking is handled by qca8k read/write */
+	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
 };
 
 static int
 qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 {
-	int ret, ret1;
 	u32 val;
 
-	ret = read_poll_timeout(qca8k_read, ret1, !(val & mask),
-				0, QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
-				priv, reg, &val);
-
-	/* Check if qca8k_read has failed for a different reason
-	 * before returning -ETIMEDOUT
-	 */
-	if (ret < 0 && ret1 < 0)
-		return ret1;
-
-	return ret;
+	return regmap_read_poll_timeout(priv->regmap, reg, val, !(val & mask), 0,
+				       QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC);
 }
 
 static int
@@ -568,7 +555,7 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
 	if (ret)
 		goto exit;
 
@@ -576,7 +563,7 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	if (ret)
 		goto exit;
 
-	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
 	if (ret)
 		goto exit;
 
@@ -597,9 +584,9 @@ qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
 		mask |= QCA8K_PORT_STATUS_LINK_AUTO;
 
 	if (enable)
-		qca8k_reg_set(priv, QCA8K_REG_PORT_STATUS(port), mask);
+		regmap_set_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
 	else
-		qca8k_reg_clear(priv, QCA8K_REG_PORT_STATUS(port), mask);
+		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
 }
 
 static u32
@@ -861,8 +848,8 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 		 * a dt-overlay and driver reload changed the configuration
 		 */
 
-		return qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
-				       QCA8K_MDIO_MASTER_EN);
+		return regmap_clear_bits(priv->regmap, QCA8K_MDIO_MASTER_CTRL,
+					 QCA8K_MDIO_MASTER_EN);
 	}
 
 	/* Check if the devicetree declare the port:phy mapping */
@@ -1099,16 +1086,16 @@ qca8k_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Make sure MAC06 is disabled */
-	ret = qca8k_reg_clear(priv, QCA8K_REG_PORT0_PAD_CTRL,
-			      QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
+	ret = regmap_clear_bits(priv->regmap, QCA8K_REG_PORT0_PAD_CTRL,
+				QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
 	if (ret) {
 		dev_err(priv->dev, "failed disabling MAC06 exchange");
 		return ret;
 	}
 
 	/* Enable CPU Port */
-	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
-			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	ret = regmap_set_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
+			      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
 	if (ret) {
 		dev_err(priv->dev, "failed enabling CPU port");
 		return ret;
@@ -1176,8 +1163,8 @@ qca8k_setup(struct dsa_switch *ds)
 				return ret;
 
 			/* Enable ARP Auto-learning by default */
-			ret = qca8k_reg_set(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-					    QCA8K_PORT_LOOKUP_LEARN);
+			ret = regmap_set_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(i),
+					      QCA8K_PORT_LOOKUP_LEARN);
 			if (ret)
 				return ret;
 
@@ -1741,9 +1728,9 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 		/* Add this port to the portvlan mask of the other ports
 		 * in the bridge
 		 */
-		ret = qca8k_reg_set(priv,
-				    QCA8K_PORT_LOOKUP_CTRL(i),
-				    BIT(port));
+		ret = regmap_set_bits(priv->regmap,
+				      QCA8K_PORT_LOOKUP_CTRL(i),
+				      BIT(port));
 		if (ret)
 			return ret;
 		if (i != port)
@@ -1773,9 +1760,9 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 		/* Remove this port to the portvlan mask of the other ports
 		 * in the bridge
 		 */
-		qca8k_reg_clear(priv,
-				QCA8K_PORT_LOOKUP_CTRL(i),
-				BIT(port));
+		regmap_clear_bits(priv->regmap,
+				  QCA8K_PORT_LOOKUP_CTRL(i),
+				  BIT(port));
 	}
 
 	/* Set the cpu port to be the only one in the portvlan mask of
-- 
2.32.0

