Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E93B4280A5
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhJJLSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhJJLSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:06 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1C2C061570;
        Sun, 10 Oct 2021 04:16:08 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a25so39497474edx.8;
        Sun, 10 Oct 2021 04:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bT3uYmIpBBUPuoKRyduVCWixAeUcB9/KN+Kcgh/0JR4=;
        b=cUCoPVFcwezu8zmFzuP4dWiJ5JEUXSPOBiQJs4tIyUCG3I9zDXDHGs9v19MkAR0bWN
         2R1dGHX08NDQnGjZpbf56WquzDS+icDDZnPLrihPQgKf/5WyBY8RME1GSMu2tmBgouyK
         ssVI7AhGu6J/BJStGJiNOB1CJp4Lj5cAl+fEvCnfmHXC8EhfKS6vPFjprxsv8CR4DhqW
         WhvbwuzG9NL73AY3/TyyGVnK1vqDqLxOtR5j1lYK4oypMjEOv6I0/2+cehYPqs8f0osg
         6so9DmC4rhRtMGqH6HWmDzY947TgxdAFP+Wa0FlwbT6P2kez4ujfBuGkHxmf7NN3cBY7
         FGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bT3uYmIpBBUPuoKRyduVCWixAeUcB9/KN+Kcgh/0JR4=;
        b=4qcBX+jz5BxfCKMa/tqTP5ACbX9cLIlB7Ge+3WDfAvrshRm/XC6IZ18105Xc70sYks
         VW2LFhi9DaXFbM/pehokLexRm8AE5u5uRVs+WGUD1BbDKzhv1JJfnrtdjgD/cMYnUHr5
         SwjG3LDeOjdWmWis1YTFFksj5tbh1V0ZLqfRTLfGi6RatcSsCKUXv06AOWacaayW8Qzj
         Lj07WqjQFEbszHesn8vk84MlEvHKL57iqSH7IWEfaalw1I0cxBs94SjfZPIMlFE3MUpU
         X93ngKcNplkciRJZ7Bc1rkH/P24fXnDA9jVpbeT/WOL+KSim2RerFwV+nY6B6ltmMBTN
         an8A==
X-Gm-Message-State: AOAM531BZDJM6P2b2ytmidY2K2sJSt3mjXYBBv0pJB/kceC8pOeqelEN
        8BdactSrs2eYh37FKQ2k7B8=
X-Google-Smtp-Source: ABdhPJwOF9sZYW/2iI63++nuViBFWbzgKRPXuZT4Ij5PlYYiLEItP5z922zUkFXjstmBS/yrxrWufQ==
X-Received: by 2002:a17:906:5ac7:: with SMTP id x7mr18518641ejs.42.1633864566584;
        Sun, 10 Oct 2021 04:16:06 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:06 -0700 (PDT)
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
Subject: [net-next PATCH v4 01/13] net: dsa: qca8k: add mac_power_sel support
Date:   Sun, 10 Oct 2021 13:15:44 +0200
Message-Id: <20211010111556.30447-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing mac power sel support needed for ipq8064/5 SoC that require
1.8v for the internal regulator port instead of the default 1.5v.
If other device needs this, consider adding a dedicated binding to
support this.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 31 +++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  5 +++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bda5a9bf4f52..a892b897cd0d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -950,6 +950,33 @@ qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
 	return 0;
 }
 
+static int
+qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
+{
+	u32 mask = 0;
+	int ret = 0;
+
+	/* SoC specific settings for ipq8064.
+	 * If more device require this consider adding
+	 * a dedicated binding.
+	 */
+	if (of_machine_is_compatible("qcom,ipq8064"))
+		mask |= QCA8K_MAC_PWR_RGMII0_1_8V;
+
+	/* SoC specific settings for ipq8065 */
+	if (of_machine_is_compatible("qcom,ipq8065"))
+		mask |= QCA8K_MAC_PWR_RGMII1_1_8V;
+
+	if (mask) {
+		ret = qca8k_rmw(priv, QCA8K_REG_MAC_PWR_SEL,
+				QCA8K_MAC_PWR_RGMII0_1_8V |
+				QCA8K_MAC_PWR_RGMII1_1_8V,
+				mask);
+	}
+
+	return ret;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -979,6 +1006,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_mac_pwr_sel(priv);
+	if (ret)
+		return ret;
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ed3b05ad6745..fc7db94cc0c9 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -100,6 +100,11 @@
 #define   QCA8K_SGMII_MODE_CTRL_PHY			(1 << 22)
 #define   QCA8K_SGMII_MODE_CTRL_MAC			(2 << 22)
 
+/* MAC_PWR_SEL registers */
+#define QCA8K_REG_MAC_PWR_SEL				0x0e4
+#define   QCA8K_MAC_PWR_RGMII1_1_8V			BIT(18)
+#define   QCA8K_MAC_PWR_RGMII0_1_8V			BIT(19)
+
 /* EEE control registers */
 #define QCA8K_REG_EEE_CTRL				0x100
 #define  QCA8K_REG_EEE_CTRL_LPI_EN(_i)			((_i + 1) * 2)
-- 
2.32.0

