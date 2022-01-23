Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BF7496F7F
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbiAWBeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235388AbiAWBd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:59 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E20C06173B;
        Sat, 22 Jan 2022 17:33:58 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id a18so49614049edj.7;
        Sat, 22 Jan 2022 17:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wr0aH6ZhDw7172FNY5g9yB4jAgu5kftZ149nACZOyvk=;
        b=afMKgKV8GT7LP56M5UGAHG+MIh/ZFyfibOFA1o1BGNYjps63YAhYgsBev3XTrxU7VF
         L6osBvWPyIkc5QbOCf9nGgc/NvaJ/sEyU8Ap36fRjFztaF29JnLyp0VybMaozTu0juhD
         T+w9R6yy+v0B34l3wGOCMVr4fQquVZu5ZgfnHd5nsSGtSyZSBIWoQeN7inRNZ+a7ZphC
         dKCQXVc7ZT+DfnPRnglNoZVktPl+G+hVpSAm03GAzIF9PGkDnwCPn2gAoOOeT40GvhJW
         Ve7YG8ifzXf3CHho7MKy06pamDZgIGJx8DL72kpH3F7RBXXL05+e0LNoq2SnYRXxae1A
         AjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wr0aH6ZhDw7172FNY5g9yB4jAgu5kftZ149nACZOyvk=;
        b=RyuZe8kbVnFxE38+Zy89EzAKFYpRujoM/g0/eF/88Qd4JbZy52whLRcCaA8Raml/D7
         6P4zoraDBSO9Q2gqNPQhwSk0qKW0jJlyfaVifCE+grWSA4y0JhTZaZNDPOo64sh9keZY
         ZU+SB9ksexQ8rgHi5wn6/TATpym6N1GTz5LcDaBcuttjCL/lLkhuAKPA1qr/dc2Q6ajX
         DkGSSrft49wJSBHvKEd0fCFIWSNlIv4f4Ll90b4PEMMAllegpoiyQXC8lyoPYuAAVm4t
         n7FIqhTHSE+PEBIo4o3V7wonVEGh1rhI77mjHyZ4aUE+H+m3SN1m9IHzDINTiTC5jNXb
         q+/w==
X-Gm-Message-State: AOAM530fA9RG3D43VuYU5O5irw6GUQKMdTBSH7E826zkmvlTtw7T+8g5
        1FXbCb68FZ8sEn/QAjxSaTA=
X-Google-Smtp-Source: ABdhPJzO67vWQSMtDam2xkx0jVGD53VuMcsWEXSfvldXxU6cNL5YnJ+5mctTuC+7FQxsUMfG+QGR/w==
X-Received: by 2002:a05:6402:185:: with SMTP id r5mr10036115edv.259.1642901637044;
        Sat, 22 Jan 2022 17:33:57 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:56 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 16/16] net: dsa: qca8k: introduce qca8k_bulk_read/write function
Date:   Sun, 23 Jan 2022 02:33:37 +0100
Message-Id: <20220123013337.20945-17-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce qca8k_bulk_read/write() function to use mgmt Ethernet way to
read/write packet in bulk. Make use of this new function in the fdb
function.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 55 ++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0183ce2d5b74..b8d063c58675 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -390,6 +390,43 @@ qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 wri
 	return qca8k_write_eth(priv, reg, &val, 4);
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
@@ -535,17 +572,13 @@ qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 static int
 qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 {
-	u32 reg[4], val;
-	int i, ret;
+	u32 reg[4];
+	int ret;
 
 	/* load the ARL table into an array */
-	for (i = 0; i < 4; i++) {
-		ret = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
-		if (ret < 0)
-			return ret;
-
-		reg[i] = val;
-	}
+	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, 12);
+	if (ret)
+		return ret;
 
 	/* vid - 83:72 */
 	fdb->vid = FIELD_GET(QCA8K_ATU_VID_MASK, reg[2]);
@@ -569,7 +602,6 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
 		u8 aging)
 {
 	u32 reg[3] = { 0 };
-	int i;
 
 	/* vid - 83:72 */
 	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
@@ -586,8 +618,7 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
 	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
 
 	/* load the array into the ARL table */
-	for (i = 0; i < 3; i++)
-		qca8k_write(priv, QCA8K_REG_ATU_DATA0 + (i * 4), reg[i]);
+	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, 12);
 }
 
 static int
-- 
2.33.1

