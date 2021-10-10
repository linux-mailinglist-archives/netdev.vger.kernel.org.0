Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524334280C3
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhJJLSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhJJLSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:21 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71CCC061765;
        Sun, 10 Oct 2021 04:16:16 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g8so55475913edt.7;
        Sun, 10 Oct 2021 04:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hDlBaZldt3xpz+aRXljE8FTlXEFrNK+skJNYv1YSFdk=;
        b=FlNn3gj38qo8eBHTkSOHzagx4cfNve6589yYKH1sHaB70kzYs+GibOPBA+3lnLc6vv
         jDxmu9jDLJDF21yoZdShHaMR5JKHcdCNhzSv8HbvZs2m1nFlHiQZJI+o50UxJM2jusCT
         ZutWp7zFA8Jc4RD7PNZiOrds8jojKsFHi74jFLPAfUazR/7vLVY51YzgfHdZzz6MbiP+
         DfHp+XCt1RUcprz5r7ZzF4vfJikAMQkNCQH6JLVT11laksD4jefYy79ghoZX5iryldz7
         KTuhqar4/Z0TX6WnfLj9gw/Rw1fSMCpa+jjXiU20eBvNYRE3Jh3Sr6plFvUS5bS3ErUJ
         pWYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hDlBaZldt3xpz+aRXljE8FTlXEFrNK+skJNYv1YSFdk=;
        b=5tLGtaYhTMxKTWd2sAFDz4Oh9oFZOq8vLKshHGi4eFR/GS74vVTghth3wITjAkX6n5
         YQA47MN4FQXv8eyBUHWzSak+D0wHFPksrNvqq5MZxCtG4wxMlA+MQgMbYn7lRi8l1vAu
         GDtvURgrAWqfIv03c6HdqnvMTQpiwd6fJWYZQiCjOFTWirbMePmUjlrqeZR6Qy+0TFrV
         5lDonwX5WdCvnOigc25WM5DSfxByShqTUjXpzTJAVYOrsLM98tQ1gk3dvT0x3jrCQg8H
         ykIpNor7M2B4cJHjLFTtHm7xNt3n2CGyP8o9s5a11h20ex9JlLS2zJ2jX8kf6jUXhw/l
         bS2A==
X-Gm-Message-State: AOAM533OexmmfP+rt9Nu/SP8xN33rbpikr6Ce2/5iOKdYMD3seOgwwz2
        jORcnv2xDDPlHvm55D2y2vk=
X-Google-Smtp-Source: ABdhPJyK9AwZ3NYqsMFAK2KVLiSZeAf1uuLePs6/nl3QIJyHbc5ceLZb1dD6OXdTQjKjH0L8IlmZAQ==
X-Received: by 2002:a17:906:2ccf:: with SMTP id r15mr17472968ejr.182.1633864575163;
        Sun, 10 Oct 2021 04:16:15 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:14 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v4 09/13] drivers: net: dsa: qca8k: add support for pws config reg
Date:   Sun, 10 Oct 2021 13:15:52 +0200
Message-Id: <20211010111556.30447-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some qca8327 switch require to force the ignore of power on sel
strapping. Some switch require to set the led open drain mode in regs
instead of using strapping. While most of the device implements this
using the correct way using pin strapping, there are still some broken
device that require to be set using sw regs.
Introduce a new binding and support these special configuration.
As led open drain require to ignore pin strapping to work, the probe
fails with EINVAL error with incorrect configuration.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  6 ++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index afdfbcbbdb52..5091837cb969 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -931,6 +931,41 @@ static int qca8k_find_cpu_port(struct dsa_switch *ds)
 	return -EINVAL;
 }
 
+static int
+qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
+{
+	struct device_node *node = priv->dev->of_node;
+	u32 val = 0;
+	int ret;
+
+	/* QCA8327 require to set to the correct mode.
+	 * His bigger brother QCA8328 have the 172 pin layout.
+	 * Should be applied by default but we set this just to make sure.
+	 */
+	if (priv->switch_id == QCA8K_ID_QCA8327) {
+		ret = qca8k_rmw(priv, QCA8K_REG_PWS, QCA8327_PWS_PACKAGE148_EN,
+				QCA8327_PWS_PACKAGE148_EN);
+		if (ret)
+			return ret;
+	}
+
+	if (of_property_read_bool(node, "qca,ignore-power-on-sel"))
+		val |= QCA8K_PWS_POWER_ON_SEL;
+
+	if (of_property_read_bool(node, "qca,led-open-drain")) {
+		if (!(val & QCA8K_PWS_POWER_ON_SEL)) {
+			dev_err(priv->dev, "qca,led-open-drain require qca,ignore-power-on-sel to be set.");
+			return -EINVAL;
+		}
+
+		val |= QCA8K_PWS_LED_OPEN_EN_CSR;
+	}
+
+	return qca8k_rmw(priv, QCA8K_REG_PWS,
+			QCA8K_PWS_LED_OPEN_EN_CSR | QCA8K_PWS_POWER_ON_SEL,
+			val);
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -957,6 +992,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_of_pws_reg(priv);
+	if (ret)
+		return ret;
+
 	ret = qca8k_setup_mac_pwr_sel(priv);
 	if (ret)
 		return ret;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index a790b27bc310..535a4515e7b9 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -46,6 +46,12 @@
 #define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
 #define QCA8K_REG_PWS					0x010
+#define   QCA8K_PWS_POWER_ON_SEL			BIT(31)
+/* This reg is only valid for QCA832x and toggle the package
+ * type from 176 pin (by default) to 148 pin used on QCA8327
+ */
+#define   QCA8327_PWS_PACKAGE148_EN			BIT(30)
+#define   QCA8K_PWS_LED_OPEN_EN_CSR			BIT(24)
 #define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
 #define QCA8K_REG_MODULE_EN				0x030
 #define   QCA8K_MODULE_EN_MIB				BIT(0)
-- 
2.32.0

