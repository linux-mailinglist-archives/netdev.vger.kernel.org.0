Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C7C368AA6
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbhDWBtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240316AbhDWBsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:47 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF550C06134D;
        Thu, 22 Apr 2021 18:48:06 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id w3so71654369ejc.4;
        Thu, 22 Apr 2021 18:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ta/24bWMmOyYH0LkZJ/c9X9HhCw4uvrp/JaOe0WLGx8=;
        b=dnePvmwmfnfjGtaXok0oA+2WEP5op+gEC1ZQBQHoZTvLhzs183bxibVEI7Cf/8+0EY
         ero1M7J8QiJon23nWQ0SM11QtIOFXlxtsEI12XyyoxrY4vyyx9nsdB65gMrt6eBBVuyQ
         AH0V+FE0DVd4dgmFFN6rpu33dTRiPWruR9Z25j2OSYGbyGzh99FgkvVHopTzmyjvPyG2
         ABTgprwozoi5wB+0fXWcyepunKhuokLgumeWCXAPxmO1vD3mvSqnGcEZAhKHY24tTYbc
         +83rFjtm8wS251NRPCNf6u45hthvBVEodTdRg4rKghJyotivgcHmnDDFu+V9EIIaxz+C
         3Qbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ta/24bWMmOyYH0LkZJ/c9X9HhCw4uvrp/JaOe0WLGx8=;
        b=NxZVif3At4tm5/O6jPErCfIOx5eal6B1iHTy35QxFDttEr8tIxzGSgf71A8habPpVa
         /7fX4qoKvHEMVlJ+TQQ89/ilkcZMpLiqJmTl1YzXUyCJ30T/WLxvFf7mkK5G97kh1Hl9
         D4tNxrK/ofnehDCZthuSnhC6OavsOA75CproSuRZlcsofKv/BuD3/8TOcJvUc51CCF1j
         t1iBgt6fm6lQUCLHxXlMIMfTX9FDtKsmiFFdhTc1Qvb7Ea8/YfmtJVrIwINRssMu3UVS
         Q9nWQlMO8dEsUt9V041ShTa39L/xIA6eRZNGYdeu2kUhcneukJ1uekf/ysjZ+eI/PKCs
         U0zw==
X-Gm-Message-State: AOAM530O4ex8WVxYy7ahyiKvgrx6cBiHc003jPVKspFUtV2oyZRtx8mU
        RpuZ+Ox7aJMCPHUrU6x6Vs8=
X-Google-Smtp-Source: ABdhPJyIn5/kU+wl5mDo1jaJpqVilJxwzjagRUYrR5rhBIUrOAmQHAl/vISyfimWOeJ9QP6+Rmasig==
X-Received: by 2002:a17:907:215a:: with SMTP id rk26mr1614122ejb.225.1619142485653;
        Thu, 22 Apr 2021 18:48:05 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:48:05 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] drivers: net: dsa: qca8k: add support for switch rev
Date:   Fri, 23 Apr 2021 03:47:35 +0200
Message-Id: <20210423014741.11858-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k switch require some special debug value to be set based on the
switch revision. Rework the switch id read function to also read the
chip revision and make it accessible to the switch data.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 17 ++++++++++++-----
 drivers/net/dsa/qca8k.h |  7 +++++--
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d469620e9344..20b507a35191 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1459,12 +1459,22 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
 };
 
+static u8 qca8k_read_switch_id(struct qca8k_priv *priv)
+{
+	u32 val;
+
+	val = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
+
+	priv->switch_revision = (val & QCA8K_MASK_CTRL_REV_ID_MASK);
+
+	return QCA8K_MASK_CTRL_DEVICE_ID(val & QCA8K_MASK_CTRL_DEVICE_ID_MASK);
+}
+
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
 	const struct qca8k_match_data *data;
 	struct qca8k_priv *priv;
-	u32 id;
 
 	/* allocate the private data struct so that we can probe the switches
 	 * ID register
@@ -1496,10 +1506,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		return -ENODEV;
 
 	/* read the switches ID register */
-	id = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
-	id >>= QCA8K_MASK_CTRL_ID_S;
-	id &= QCA8K_MASK_CTRL_ID_M;
-	if (id != data->id)
+	if (qca8k_read_switch_id(priv) != data->id)
 		return -ENODEV;
 
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 308d8410fdb6..dbd54d870a30 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -28,8 +28,10 @@
 
 /* Global control registers */
 #define QCA8K_REG_MASK_CTRL				0x000
-#define   QCA8K_MASK_CTRL_ID_M				0xff
-#define   QCA8K_MASK_CTRL_ID_S				8
+#define   QCA8K_MASK_CTRL_REV_ID_MASK			GENMASK(7, 0)
+#define   QCA8K_MASK_CTRL_REV_ID(x)			((x) >> 0)
+#define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
+#define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
 #define QCA8K_REG_PORT0_PAD_CTRL			0x004
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
@@ -247,6 +249,7 @@ struct qca8k_match_data {
 };
 
 struct qca8k_priv {
+	u8 switch_revision;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.30.2

