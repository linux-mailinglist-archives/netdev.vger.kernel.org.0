Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE844A6903
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243180AbiBBAE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243116AbiBBAEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:47 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C12C061758;
        Tue,  1 Feb 2022 16:04:38 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a8so59189690ejc.8;
        Tue, 01 Feb 2022 16:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=USR1Io0hJiFiGA+5muEeBM5of0zwK52quduqa9SF9yU=;
        b=naOWCTyDCInxxyPLF0VfiKMFWhDLuEYUMt0cRuqjL++5KfWuXUY6Q47AMhUy+XFsDQ
         m2QbF5dU5ZzOWRqj0uxeOM/e/3m9MWUBIlaUEckDLUP10JH5di+ZXijXM7LyiB7hOno8
         L/XV4Xj3eSPcsb4ocekT3/G/eoAnIyG+h6zUg440qEauwjFroIk7MVf9GHxaMUNBu4Wj
         zT8TrqAw6ePTgvYOZynipKudjMQYXYn33ZdLzBA5V7zJi32q1ufuMBQ/GtM1fdJpd9FQ
         jCQkAru4EEyO4YNwG2RZQjyjCkGd0xzKUdCCyD8jnAP6scFQw3KGL9pkTduaGAaVKxaf
         FIAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=USR1Io0hJiFiGA+5muEeBM5of0zwK52quduqa9SF9yU=;
        b=lnYRNPYKd17ZqYtSddx6lbzfcpXP4sscBrFZShlfdYbYUB8HfJ+oc9ILP/c1dAn9rb
         RU3dZd7Vn1EjT2A08PTx1VaevjJMmLZjPHX7U+qqhaabXSkCN+snwCGnu/QB3as34PB1
         5qIT/0Mq8MGppHu31k3BiiwR2IZ5OxyTFcrfXNBFgwIKdp96Uv2IiFlnH54/Zn9yRLkU
         2v3igvulKJSjKJy8fvRTdtqJGV3Afz1IVIyvOMLpalvdULDZrKAt1vFJOJWQQ1k5xaPU
         cXbt0YfYuMWGxvWTzeAg3ZsSMv4Fu33/QLNnvVtPVRiJVcieHq6yXSisrIVq+OeX/pzC
         x3FQ==
X-Gm-Message-State: AOAM530YjaGQNaRIKS1IPpqiJwg8g0kdpGpymck/R9jPR738baop0cWa
        qG9Cz6+ETmGfMrowrmHj74Y=
X-Google-Smtp-Source: ABdhPJzpch5bJEdgdUCz78q/UEKLLVMy4rA7D2YcBMfzsFu2asWQB7//UlIOJlbvwAHzzFTmWx1XyQ==
X-Received: by 2002:a17:907:8a0b:: with SMTP id sc11mr22180570ejc.310.1643760277246;
        Tue, 01 Feb 2022 16:04:37 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:36 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 16/16] net: dsa: qca8k: introduce qca8k_bulk_read/write function
Date:   Wed,  2 Feb 2022 01:03:35 +0100
Message-Id: <20220202000335.19296-17-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce qca8k_bulk_read/write() function to use mgmt Ethernet way to
read/write packet in bulk. Make use of this new function in the fdb
function and while at it reduce the reg for fdb_read from 4 to 3 as the
max bit for the ARL(fdb) table is 83 bits.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 55 ++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a1b76dcd2eb6..52ec2800dd89 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -411,6 +411,43 @@ qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 wri
 	return qca8k_write_eth(priv, reg, &val, sizeof(val));
 }
 
+static int
+qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
+{
+	int i, count = len / sizeof(u32), ret;
+
+	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val, len))
+		return 0;
+
+	for (i = 0; i < count; i++) {
+		ret = regmap_read(priv->regmap, reg + (i * 4), val + i);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
+{
+	int i, count = len / sizeof(u32), ret;
+	u32 tmp;
+
+	if (priv->mgmt_master && !qca8k_write_eth(priv, reg, val, len))
+		return 0;
+
+	for (i = 0; i < count; i++) {
+		tmp = val[i];
+
+		ret = regmap_write(priv->regmap, reg + (i * 4), tmp);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int
 qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
@@ -546,17 +583,13 @@ qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 static int
 qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 {
-	u32 reg[4], val;
-	int i, ret;
+	u32 reg[3];
+	int ret;
 
 	/* load the ARL table into an array */
-	for (i = 0; i < 4; i++) {
-		ret = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
-		if (ret < 0)
-			return ret;
-
-		reg[i] = val;
-	}
+	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
+	if (ret)
+		return ret;
 
 	/* vid - 83:72 */
 	fdb->vid = FIELD_GET(QCA8K_ATU_VID_MASK, reg[2]);
@@ -580,7 +613,6 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
 		u8 aging)
 {
 	u32 reg[3] = { 0 };
-	int i;
 
 	/* vid - 83:72 */
 	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
@@ -597,8 +629,7 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
 	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
 
 	/* load the array into the ARL table */
-	for (i = 0; i < 3; i++)
-		qca8k_write(priv, QCA8K_REG_ATU_DATA0 + (i * 4), reg[i]);
+	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
 }
 
 static int
-- 
2.33.1

