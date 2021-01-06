Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084532EBEFE
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbhAFNpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbhAFNo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:44:56 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5E2C06135A;
        Wed,  6 Jan 2021 05:44:15 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id r7so2482490wrc.5;
        Wed, 06 Jan 2021 05:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H67hk0w4ys0VqaA1k6VYHauyrs1Tid6EBAgBVNleLKw=;
        b=pL3TiFkqml/XvwxwhXS10/0I2GPoOWjmakHKQDoQ11VYdzVlW2RSnefsaM2lVLzuUw
         T5ZbW4lX1hkvcHoDhJnKgr4dlhWl9bxrUFgmS7/QFJ5/rTfNJpULQDaotzzCML08yRWw
         VRIdXHnI8zSoB+AIaD62P/4ZasflPjZDvs5LtKKmJP6yZR3dcoxSxraJ/Ol3X5ioKg9g
         rIgzSEifS7RVUWM7FJsMPzODaoi9GMOM8/caKz+DyQpWV0+nmqKkWKU6+qbLh2fR4Ben
         XvWv7+11tU3mwSouItNworqtpJmBp50hCALWm286Po/eTeLvJjwpKNCZ2ghjfAmxHr/M
         eoZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H67hk0w4ys0VqaA1k6VYHauyrs1Tid6EBAgBVNleLKw=;
        b=nDw0dQsRyyrjq7H3AM9qf7HUdpQ+CWQcEfrjrIL6syYPA0iquuwm+POoGqoiwKzJk7
         lz7+nRONbdCdeeq6f169wXxzBS123rc9MBufHfNr3h/Ed6WFGO55OQRopsEM3uEsFAio
         U0HXbrxToEc690mAQ7+h97B37uANHAYqK1cSEc2Od4kqeDSGwBtfNA9b+iDlG9qcxy2q
         yotCMuVvpOjrm9HuzZ7LMwSPlnhe2BJhS43nObooNF9/xIrhr31oGLqXzKUpFbiwIm74
         49YaQgPZKLLuaHBEfFtf/k60KjRDwLoA6Fc3AfKKdjfLRrnMbBGAIKH+kxWJ7NYNRQ3u
         ARFw==
X-Gm-Message-State: AOAM533ZTY8Nkgy6LFWW2bn7eGwz/DeESsDiYk8kNPL/hB0iRKqJnx8u
        QORQ/mo9+eh8AfqLvY+h1X4=
X-Google-Smtp-Source: ABdhPJwuMOd5HX3ytI8B8k6S2VFPE75+6o+a1kYBKmClhtuUmJs5R876PF3xfiLiaTWcToydhbi9LA==
X-Received: by 2002:adf:b78d:: with SMTP id s13mr4436321wre.344.1609940654115;
        Wed, 06 Jan 2021 05:44:14 -0800 (PST)
Received: from localhost.localdomain (p200300f13711ec00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3711:ec00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id f14sm3085351wme.14.2021.01.06.05.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:44:13 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        narmstrong@baylibre.com, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 4/5] net: stmmac: dwmac-meson8b: move RGMII delays into a separate function
Date:   Wed,  6 Jan 2021 14:42:50 +0100
Message-Id: <20210106134251.45264-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210106134251.45264-1-martin.blumenstingl@googlemail.com>
References: <20210106134251.45264-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer SoCs starting with the Amlogic Meson G12A have more a precise
RGMII RX delay configuration register. This means more complexity in the
code. Extract the existing RGMII delay configuration code into a
separate function to make it easier to read/understand even when adding
more logic in the future.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index d2be3a7bd8fd..4937432ac70d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -268,7 +268,7 @@ static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
 	return 0;
 }
 
-static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
+static int meson8b_init_rgmii_delays(struct meson8b_dwmac *dwmac)
 {
 	u32 tx_dly_config, rx_dly_config, delay_config;
 	int ret;
@@ -323,6 +323,13 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 				PRG_ETH0_ADJ_DELAY | PRG_ETH0_ADJ_SKEW,
 				delay_config);
 
+	return 0;
+}
+
+static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
+{
+	int ret;
+
 	if (phy_interface_mode_is_rgmii(dwmac->phy_mode)) {
 		/* only relevant for RMII mode -> disable in RGMII mode */
 		meson8b_dwmac_mask_bits(dwmac, PRG_ETH0,
@@ -430,6 +437,10 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 		goto err_remove_config_dt;
 	}
 
+	ret = meson8b_init_rgmii_delays(dwmac);
+	if (ret)
+		goto err_remove_config_dt;
+
 	ret = meson8b_init_rgmii_tx_clk(dwmac);
 	if (ret)
 		goto err_remove_config_dt;
-- 
2.30.0

