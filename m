Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DCB427E5C
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhJJB6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhJJB6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:19 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29FEC061769;
        Sat,  9 Oct 2021 18:56:20 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b8so51927976edk.2;
        Sat, 09 Oct 2021 18:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RquP4AmniefGHe5H1mUC7SsdZ/7Asb+THzH67+x1DGQ=;
        b=qQdCvxUZJHDxfiMXK7y78OyynKQZxFDrDF9dC9rYpxc1PlCvoSZdh+4wXjMmIM+lRQ
         N0biY717aistGMz1hqjobz/2uAX03Vnal9noGNreG7LRJYTV5ob3EhlS4sj/yFwCeDC9
         O4SmcOizRrLBKD5yz5fC3R4miw6ty3lusGG5yMVzfN5nolhCSuHq1t9jew7SC1XOurKI
         +2rBAiFwXUYiFIruHP+VDK7csdVIYZQRISyUpEsd9BXuC31V0aaiBykdIkRbMu2C2RMJ
         5TdtyggZzFGstO4d9CYv0kF93sFwTxXJG3O0kN9R3KTuPhEQfPwYd2HtOk28UN03oVTM
         RBoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RquP4AmniefGHe5H1mUC7SsdZ/7Asb+THzH67+x1DGQ=;
        b=rArIULOtVEV6VLbViLu3gpM8rjUyZnNlJT9vek5wRspWOnBgD0jlNfgDdDG277V3f0
         i6dnvaLb9KeHod7k24uJktQnUXvEfD3Min3J7DM7qaSC34iKm8ITSQUz96PavbdhIrNg
         KLWxj5s1umdXl0jjdGB0JNhvBOLT/KJQLW67hqNdQgXKog3F9iEENxocN/WaMJgrf4LE
         Zc7ugLh3RRiSacjyL+huEd/lf8/f0BjKIjIb3UmWSGWO1/7AScHsmZl+B8degA4b4iW9
         20zwQEGp7KwFQkYQ7ZkQBVlLEkDTyQ2CXX6fy7Jx/clNFfw152kJBhWJ/Lej5O5g3xRh
         1ICA==
X-Gm-Message-State: AOAM530LNGMRvVM/OHd4LQzYTKglgquHwgBw/bRL9pSnIQt3KBwvCrkv
        dELcsECnAagR4RruuneoDAII6yYo/Vo=
X-Google-Smtp-Source: ABdhPJwiNDRjGWVkRgOUd0iSfYQK4cwLpmLF0fFVWgJ8wRyDc+bWSL738ye+I/lMfHfS3pMLNY0sbA==
X-Received: by 2002:a17:907:2bc2:: with SMTP id gv2mr15025822ejc.433.1633830979130;
        Sat, 09 Oct 2021 18:56:19 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:18 -0700 (PDT)
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
Subject: [net-next PATCH v3 09/13] drivers: net: dsa: qca8k: add support for pws config reg
Date:   Sun, 10 Oct 2021 03:55:59 +0200
Message-Id: <20211010015603.24483-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
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
index b73b92ebd72e..3e2274cb82cd 100644
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

