Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F252B3813
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 19:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgKOSwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 13:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbgKOSwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 13:52:47 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88524C0613D1;
        Sun, 15 Nov 2020 10:52:47 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id o21so21333153ejb.3;
        Sun, 15 Nov 2020 10:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tHdUr6fpSlLoSsUqR0Zir33G0bTUJp5jRkYS8g8PmZ4=;
        b=gpxkUd9/dkkmdPKleMJPJB7kz4sRjVV2Kbrn5gknEKHMn5AUENOqWfDyjgSVW8Znyc
         nXym0OOIPPzhN+2yD13xZml484CFC78x3EUny6jl/158IHyggecUVTPEtAwQ2WQJmL9a
         XmeLMZaU05WLhq7T0Eom23BgZVFiHc5gceEI9bivE+NG8mMFC73VDZJjKh3NLO/bNhyV
         XEY9SKuMwQ+uNGrb7pZunyOqsx2c0dWM6Va3N999+t7ydLkiT1hUSoI0KcEiKPXPc0Yx
         VvNhq4ZW9kVFAzfbSBx5xQPsZUCaWxWANma6xEdGXcNzPwKJErf0JhhGh6mUZQXFj1pg
         ImZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tHdUr6fpSlLoSsUqR0Zir33G0bTUJp5jRkYS8g8PmZ4=;
        b=EHfpAwiqhrfjt5ggBsVsRzi7e12Mf0Rtr6Bdd+9OU80fNlxKNRzI9csK/CrNtW5ljq
         B+L6wmkxbeEkH6hxHwEIXfb0Vz3mMXTXGakJmeczptKu1gjqzMJK1Trxp+5hec3cRqdQ
         cIXWVNF5JR0+aJwniJnxXuz9e8FahXGznEXLvmMZkGoSx7aqb7off12ByGqhX2mvWRhR
         sAHZPUeFYviW4xNNde5FXXBqYfw/v7S3UPbksJnrtMsFbZnLA/3mxBGK9/KV5hyvkWSN
         ZG4BSDtvdxvP5VIr4EjVH0xhhdgNt7vY7BmQIAO++HsAZCAjlPKmyGCeOv0nOsckBDS6
         RSVQ==
X-Gm-Message-State: AOAM530NbBOxCZqGvJPcjel7WSiA61bDQgP4p4B5c5dj1JJFoCluoMvS
        ECYO92I2zO+gIQgyOoP54DU=
X-Google-Smtp-Source: ABdhPJyHIgNVBDu5Qb0c7Vx73M2CSe28Ex8GelfAj7Js4a86q4b4sH62ljU4CgOTkE62qWh8l/p3oA==
X-Received: by 2002:a17:906:a88:: with SMTP id y8mr12421672ejf.469.1605466366301;
        Sun, 15 Nov 2020 10:52:46 -0800 (PST)
Received: from localhost.localdomain (p4fc3ea77.dip0.t-ipconnect.de. [79.195.234.119])
        by smtp.googlemail.com with ESMTPSA id i13sm9233520ejv.84.2020.11.15.10.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 10:52:45 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com, andrew@lunn.ch,
        f.fainelli@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 4/5] net: stmmac: dwmac-meson8b: move RGMII delays into a separate function
Date:   Sun, 15 Nov 2020 19:52:09 +0100
Message-Id: <20201115185210.573739-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
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

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 03fce678b9f5..353fe0f53620 100644
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
@@ -431,6 +438,10 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
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
2.29.2

