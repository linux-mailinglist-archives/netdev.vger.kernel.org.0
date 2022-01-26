Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BAC49C73F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239758AbiAZKPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239743AbiAZKO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:14:56 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0D2C061744
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:14:56 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id z4so6894495lft.3
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=USujqVpdZsW/z2MKg24tG7SlZmyGeevlaGFebRua/vY=;
        b=b7gK/BdRk280w03vgWCel/KJX7+Dvu/EYaj2bq+tscRGg0ofFIyo3nBt3p39xGT0B6
         MPmLq5MbPYcOX1M9eOhokTTwsOrRntnqzo/RqnmRnYKWA7fuaATI08NoMVCtvdsWRV6h
         3Mwc79weYJXRVoGUcgWx90Y1AEVCJAhXroAtSUFSfUKnWeKaNUMFgoYn5mL28bsde39K
         jS4LkINHWxYv5DhJa4mp82f/Qe/I0cmffe9k19aZWA2ZaKLGgfxnzKbM929Ts/vPScyC
         g1Squ0IGF1aLdZbT4RLdQJdUdGdrBfWLz6vahTx/lyFxDfwN3zk5LTbJXNs1Tq2foDyg
         XKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=USujqVpdZsW/z2MKg24tG7SlZmyGeevlaGFebRua/vY=;
        b=GdpfJdJcSOOxl1Q0riyfUqk+iJF/4C1/doQUId/5Qm5b5YzSRSkKaMDyjVtRmrUu3p
         /2so6eKDDHimZ7Duiu2WTxBiUe/yRO7wHV6HY8bn3+3OgMdcWFaRhZUccFeCJVkG19r6
         REDVOosqkRCmOutA43w8cwRgWgpU3nrW3C4pS616jTiRXbg0wcQ6L/R0w1hygprr7ErP
         gcL4c9E9JJVK9InEnTddJa2FJlMsOkvoGhbhJ4flZEfhrY+p+aEMRqcQmxcWmUBSqmH8
         Ou/BOH5/5LLDFFZCMoVJbZCs8ZWODnALiV2JFrz7ZB36PQwOiFfUp7+2dccl83CsrGGz
         FOaA==
X-Gm-Message-State: AOAM530CJqqxvtjuXaHtc8k6dUoLgvFv4iCdli7xKaGUvUksmdQEITUN
        h830xPp9kJwVa89lI1topAFFxw==
X-Google-Smtp-Source: ABdhPJxAK4WzXolZalsQAmdWpvIAX6/9bQpBndcyHYEapRU5xriuKXtvrDvnZjU4j/ySkLHcOvgubw==
X-Received: by 2002:a05:6512:2247:: with SMTP id i7mr9650934lfu.295.1643192094394;
        Wed, 26 Jan 2022 02:14:54 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id h13sm1351906lfv.100.2022.01.26.02.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 02:14:53 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net/fsl: xgmac_mdio: Support setting the MDC frequency
Date:   Wed, 26 Jan 2022 11:14:31 +0100
Message-Id: <20220126101432.822818-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126101432.822818-1-tobias@waldekranz.com>
References: <20220126101432.822818-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the standard "clock-frequency" attribute to set the generated
MDC frequency. If not specified, the driver will leave the divisor
bits untouched.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 35 ++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 18bf2370d45a..2199f8f4ff68 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -14,6 +14,7 @@
 
 #include <linux/acpi.h>
 #include <linux/acpi_mdio.h>
+#include <linux/clk.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mdio.h>
@@ -36,7 +37,7 @@ struct tgec_mdio_controller {
 } __packed;
 
 #define MDIO_STAT_ENC		BIT(6)
-#define MDIO_STAT_CLKDIV(x)	(((x>>1) & 0xff) << 8)
+#define MDIO_STAT_CLKDIV(x)	(((x) & 0x1ff) << 7)
 #define MDIO_STAT_BSY		BIT(0)
 #define MDIO_STAT_RD_ER		BIT(1)
 #define MDIO_STAT_PRE_DIS	BIT(5)
@@ -51,6 +52,8 @@ struct tgec_mdio_controller {
 
 struct mdio_fsl_priv {
 	struct	tgec_mdio_controller __iomem *mdio_base;
+	struct clk *enet_clk;
+	u32	mdc_freq;
 	bool	is_little_endian;
 	bool	has_a009885;
 	bool	has_a011043;
@@ -255,6 +258,34 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	return ret;
 }
 
+static void xgmac_mdio_set_mdc_freq(struct mii_bus *bus)
+{
+	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
+	struct device *dev = bus->parent;
+	u32 mdio_stat, div;
+
+	if (device_property_read_u32(dev, "clock-frequency", &priv->mdc_freq))
+		return;
+
+	priv->enet_clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(priv->enet_clk)) {
+		dev_err(dev, "Input clock unknown, not changing MDC frequency");
+		return;
+	}
+
+	div = ((clk_get_rate(priv->enet_clk) / priv->mdc_freq) - 1) / 2;
+	if (div < 5 || div > 0x1ff) {
+		dev_err(dev, "Requested MDC frequecy is out of range, ignoring");
+		return;
+	}
+
+	mdio_stat = xgmac_read32(&regs->mdio_stat, priv->is_little_endian);
+	mdio_stat &= ~MDIO_STAT_CLKDIV(0x1ff);
+	mdio_stat |= MDIO_STAT_CLKDIV(div);
+	xgmac_write32(mdio_stat, &regs->mdio_stat, priv->is_little_endian);
+}
+
 static void xgmac_mdio_set_suppress_preamble(struct mii_bus *bus)
 {
 	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
@@ -319,6 +350,8 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 
 	xgmac_mdio_set_suppress_preamble(bus);
 
+	xgmac_mdio_set_mdc_freq(bus);
+
 	fwnode = pdev->dev.fwnode;
 	if (is_of_node(fwnode))
 		ret = of_mdiobus_register(bus, to_of_node(fwnode));
-- 
2.25.1

