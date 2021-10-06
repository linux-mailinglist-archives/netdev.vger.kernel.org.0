Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827A64249E0
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbhJFWjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239871AbhJFWif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:35 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9646EC061766;
        Wed,  6 Oct 2021 15:36:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r18so15509211edv.12;
        Wed, 06 Oct 2021 15:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FFCx313Z9GQlAP/ahwXmpC+e4yyEdzEZEyW2K6sJHgk=;
        b=pgfCgl+D8v3YEFhQJfFu8XQNcfjqUQ4lpgNNe8bctg2GCbLgLpSKe1UuSIKOLe/mdt
         BasASX5sOVgAfmtZL05MF7/NiM/UrPV8vPJ1wNhikpY/NQP3Mn8nHHbXmaIWJRVQ3maO
         4svU/JWBRj0+XgMJtncjYhTZq0WOYe3S4uO5UwdFt/7mx22onvbkeMczUU8nwmyeAyrk
         KYj+pfwxL5YmjCEiZMjZGgBL2oiU3xiDJze92w5LhIQD7RetprNLvZtgMdZCa6kgXdkW
         6AZ3Sr87VaNxSQA7YGg8nuiN7D7mOzWC+49jv2n8AXj08+V+022tHMl160ZHeM3zggsH
         7ygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FFCx313Z9GQlAP/ahwXmpC+e4yyEdzEZEyW2K6sJHgk=;
        b=QhV5rWDsnuecLOwLVBVJsSAyU9F5ddpfU1cd2Ni2HdRV5WVRety0BfE+vjI5w7pRQp
         h4pYF5lCAdiB+Dy5rVt7+ZEU4hGH6fZe6/NYy1wMWPcNzuIQgtk3WbYlxOID4higFIPD
         PWKhSDOdqVHmp/V+3177+D6L8+RpFXScFpFvXdUNHFRSt1kKt+l1hdOczIfY8noPBfCe
         AcK+U4/iaZl17ES6MidaKdonkFZPiCPPFaotxjvYS/fyR85bq5GALL/OnsQtMmJmZ5/7
         OKamCZ6bHAfeDvXmBcCJwzvlPBvmqHIoOHPMtihPVjfgoya+0SjxHFN2gFFsnhPKfN45
         mCfw==
X-Gm-Message-State: AOAM530tKsqLtqqnRUE88RYws8VAY/rngK5fORUoxCAZqhSPsxWrBciI
        0mX4dQQzWh24N8GnqvQc8sQ=
X-Google-Smtp-Source: ABdhPJxRg5/r7Om3l3xHIc+HYBoftXVTx1yB58E/sRzig1RImYRleVizeX1mngJxOAUSCSMZxrf7lg==
X-Received: by 2002:a05:6402:34cb:: with SMTP id w11mr1157255edc.263.1633559801090;
        Wed, 06 Oct 2021 15:36:41 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:40 -0700 (PDT)
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
Subject: [net-next PATCH 12/13] drivers: net: dsa: qca8k: add support for pws config reg
Date:   Thu,  7 Oct 2021 00:36:02 +0200
Message-Id: <20211006223603.18858-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some qca8327 switch require the power_on_sel enabled for the pws_reg or
sets the led to open drain.
Also qca8327 switch have a special mode to declare reduced 48pin layout.
This special mode is only present in qca8327 as qca8337 have a different
pws_reg table.
Introduce a new binding and support these special configuration.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 26 ++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  3 +++
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 01b05dfeae2b..209f8d3c9ea8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1014,6 +1014,28 @@ qca8k_setup_port0_pad_ctrl_reg(struct qca8k_priv *priv)
 	return ret;
 }
 
+static int
+qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
+{
+	struct device_node *node = priv->dev->of_node;
+	u32 val = 0;
+
+	if (priv->switch_id == QCA8K_ID_QCA8327)
+		if (of_property_read_bool(node, "qca,package48"))
+			val |= QCA8327_PWS_PACKAGE48_EN;
+
+	if (of_property_read_bool(node, "qca,power-on-sel"))
+		val |= QCA8K_PWS_POWER_ON_SEL;
+
+	if (of_property_read_bool(node, "qca,led-open-drain"))
+		/* POWER_ON_SEL needs to be set when configuring led to open drain */
+		val |= QCA8K_PWS_LED_OPEN_EN_CSR | QCA8K_PWS_POWER_ON_SEL;
+
+	return qca8k_rmw(priv, QCA8K_REG_PWS,
+			QCA8K_PWS_LED_OPEN_EN_CSR | QCA8K_PWS_POWER_ON_SEL,
+			val);
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -1039,6 +1061,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_of_pws_reg(priv);
+	if (ret)
+		return ret;
+
 	ret = qca8k_setup_of_rgmii_delay(priv);
 	if (ret)
 		return ret;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 3fded69a6839..90f4616c33f1 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -48,6 +48,9 @@
 #define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
 #define QCA8K_REG_PWS					0x010
+#define   QCA8K_PWS_POWER_ON_SEL			BIT(31)
+#define   QCA8327_PWS_PACKAGE48_EN			BIT(30)
+#define   QCA8K_PWS_LED_OPEN_EN_CSR			BIT(24)
 #define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
 #define QCA8K_REG_MODULE_EN				0x030
 #define   QCA8K_MODULE_EN_MIB				BIT(0)
-- 
2.32.0

