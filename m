Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276EA426137
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243177AbhJHAZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242802AbhJHAZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:10 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF23BC061779;
        Thu,  7 Oct 2021 17:23:13 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id v18so29884115edc.11;
        Thu, 07 Oct 2021 17:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9uS71E8R2dcbKXKSJMiz2qaBGN/UiL7YlhIAGtErbh4=;
        b=TvnBELhUFH7M074UI9ELiFkQzKjPmp+Z2dbbLI/k0E76Fqscg6wLkgdf8FSZ7aomqf
         rF27yUI4jnW2WCAfRRMaloL4sZ/AkA6KajIQINc/i7qOhC4jHUc3THeD4pv0XXfTDqlg
         zOTkPoyC6Yp0HpYUyw/9ERgADm7l+H0h3VZJBVgT8DoRjCEeTlZ9LswMQ6LfOddQ90Uh
         LHeiPuNz4QCW3o8Bn8PUWeQrS/NZRU+PAPqZOZSa8lcVxWJkBAtj0ddXUxL7PTDl4+i+
         bsOg6hLzqb8DPBG4ltkYMfm3WAuW8EkOXcojZga90pGlPaQlU1/lAm/nIUGONdH85SR0
         R0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9uS71E8R2dcbKXKSJMiz2qaBGN/UiL7YlhIAGtErbh4=;
        b=bJxvVo4SEnzssPhsB34sKvueoMr4HoDsIIbbZeYe6ADM+pwm771cIlTaEcZTTNKNbl
         kqI4vNu0G1Da86cZnX52RlLD7zjGZmgmHNTkgJv35wrjKP7+w5lInvRPJLXthqel2Jls
         iLtPhJRqf50VrwFpTwWI0NUWhweLYq0MtX+kxJNM7VtXQnh0k5FcOR7E34y2lE/0tvU9
         FnSpJR7aeK3ffTpvNDnMHn9iz8WEbl+k0KyGc7STZGygOCJtDUinjErJPPSzPWLeDu8i
         ZjYbuQVXzbeQUrM38dM39Y/K0QYHna9YFkLKXL86rKBYzIzkJRo+k8vlvaFYCEtDs1Pz
         nqRg==
X-Gm-Message-State: AOAM5335hFYJXWVN/JFsG5p+B7kIMz3lbiZ8JK23ecHtk3fnFSoEyc4b
        aNPZSDH4mNFhbRMPqG1JdGE=
X-Google-Smtp-Source: ABdhPJz2QVbpshW8m/ONmVawn2kizV1P4AIa3BMZJunQkiVPMdAQ8ydpfTitq3YYCaBGQ5V1I0YHfw==
X-Received: by 2002:a17:906:480a:: with SMTP id w10mr165033ejq.262.1633652592162;
        Thu, 07 Oct 2021 17:23:12 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:11 -0700 (PDT)
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
Subject: [net-next PATCH v2 12/15] drivers: net: dsa: qca8k: add support for pws config reg
Date:   Fri,  8 Oct 2021 02:22:22 +0200
Message-Id: <20211008002225.2426-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
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
index 8917bb154e8f..0dc921cfb8c6 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -939,6 +939,41 @@ qca8k_setup_port0_pad_ctrl_reg(struct qca8k_priv *priv)
 	return ret;
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
@@ -964,6 +999,10 @@ qca8k_setup(struct dsa_switch *ds)
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
index a36ef43e3847..2c98b133ec4f 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -48,6 +48,12 @@
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

