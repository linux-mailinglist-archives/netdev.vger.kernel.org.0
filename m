Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1244249D1
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239948AbhJFWip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239571AbhJFWia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:30 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542A2C06176C;
        Wed,  6 Oct 2021 15:36:37 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id f4so10386399edr.8;
        Wed, 06 Oct 2021 15:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lh3n5gNNkOfmSIQB5C0BpnciYQhDQm9z56p74RkS9X0=;
        b=Kw70yq7T/64yWgpBt5j/Lh4pR0CnZXJNHV+7LGmX23TKiz6RFKS787QvWuF84243gh
         2J+7Fy4U22OVHPITC/7RLCqdvibM71/o9pUwuO95iOfjU8bA3solEzvoX422XEgSf5Ah
         apaxpNTrqpU+Fu+hmRxtU7dpzWu7a990VyUTm56okroGC2FUGibttKxKnHIVTrOvu7j2
         y8LE3cVEBhbQ/Djx1IbWHTQNqTUUiVLSuINpFc6wBvCvcrj/dvJoy9nKhRKuyiVJQGxY
         MQuvqwWWTugFB21MHEEgI+dpjv5NgMfkt2yQCQviZQCiSnTsqyJgHLCOyWbUAf5A4BWi
         cEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lh3n5gNNkOfmSIQB5C0BpnciYQhDQm9z56p74RkS9X0=;
        b=UYYrW0sa+rlp+2lznomNjc78ezEwKShaWUxkjrLJWSJHBxPxpj1zhqED2HowdRFI4R
         IWF+y8JMTzW6Tjdy3UX8IkA6SEI2Je8fxaAP0gF1gW3LY2DzQYqZimkSU6sTl1JwOVfP
         KWFDrjF7MA71xEqlYHHQaoNfkZpk4pFQ7nN6iPuh5Zl6zueyu3bJZYXyAxYQb0woyCvg
         1RD4roSU/m5xtjREdY4e0LhiJeIARn2ZRzt8YJcaMcZtdGkVWr2ntSW/9fzUkIhYOBLz
         81bbX3KAMvag7suGqsyvWazHTDi+x/xQpZDGpWd5hAFfad71OHUL30ZkT5flxtO7FUOj
         Fdpg==
X-Gm-Message-State: AOAM533M0/ZIa6ASLVihKiKz/KOvcoQd+lq5UvOqDYe4lq1g+p/JItjE
        AqxSQ/fvz0ZhEsW1d2v7284=
X-Google-Smtp-Source: ABdhPJxFDskmT1ltMkLrdJEH9hN+cvIhli/FGUt9xF+TBz1rcBuIr662DlQ3KMjw0BHUocPrs4+83Q==
X-Received: by 2002:aa7:d890:: with SMTP id u16mr1187909edq.367.1633559795826;
        Wed, 06 Oct 2021 15:36:35 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:35 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH 07/13] net: dsa: qca8k: add support for mac6_exchange, sgmii falling edge
Date:   Thu,  7 Oct 2021 00:35:57 +0200
Message-Id: <20211006223603.18858-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some device set the switch to exchange the mac0 port with mac6 port. Add
support for this in the qca8k driver. Also add support for SGMII rx/tx
clock falling edge. This is only present for pad0, pad5 and pad6 have
these bit reserved from Documentation.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 drivers/net/dsa/qca8k.c | 33 +++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  3 +++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 5bce7ac4dea7..3a040a3ed58e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -973,6 +973,34 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 	return ret;
 }
 
+static int
+qca8k_setup_port0_pad_ctrl_reg(struct qca8k_priv *priv)
+{
+	struct device_node *node = priv->dev->of_node;
+	u32 mask = 0;
+	int ret = 0;
+
+	/* Swap MAC0-MAC6 */
+	if (of_property_read_bool(node, "qca,mac6-exchange"))
+		mask |= QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG;
+
+	/* SGMII Clock phase configuration */
+	if (of_property_read_bool(node, "qca,sgmii-rxclk-falling-edge"))
+		mask |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
+
+	if (of_property_read_bool(node, "qca,sgmii-txclk-falling-edge"))
+		mask |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
+
+	if (mask)
+		ret = qca8k_rmw(priv, QCA8K_REG_PORT0_PAD_CTRL,
+				QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG |
+				QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
+				QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
+				mask);
+
+	return ret;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -1006,6 +1034,11 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	/* Configure additional PORT0_PAD_CTRL properties */
+	ret = qca8k_setup_port0_pad_ctrl_reg(priv);
+	if (ret)
+		return ret;
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index fc7db94cc0c9..3fded69a6839 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -35,6 +35,9 @@
 #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
 #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
 #define QCA8K_REG_PORT0_PAD_CTRL			0x004
+#define   QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG		BIT(31)
+#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
+#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
-- 
2.32.0

