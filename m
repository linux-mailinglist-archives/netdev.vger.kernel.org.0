Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962AA6794F4
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbjAXKNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbjAXKNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:13:43 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300AD41B6A
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 02:13:36 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id r2so13338937wrv.7
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 02:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S8taYkiDRhxwSj2khSrYXtScgLWDxF1GD5X3Ip5sSGs=;
        b=LLp84wiadrhwgCkt5Iy//WkgeSBuROH6t0YeHNNNAtMvdohLlAiDAEDkQPNjfHsmOa
         SnQ0Hqj7fFh3RIR5ryXAvuJ0MXz2o3AGYojvwuFBQduvyX/fuU/CEGjXqQfOeXvm+B2N
         38hUhIMVdjhF5Nde8peUn0fcZMHn89MyndOYvmVILwVapZkIIxp9Y/31L8hlcaXu1c3D
         FVnhP2FqR8jz8PfwwArxgb2uEFfXPo+3gwiHeIxg6C4RfRd9K8uhnGtl99WC50CBqpI2
         fUKxyd6/aSmt4uHQl5nWmHv218zWtiUOPfENRl1AQNL9E5m3KmwTPCG21C6QBzfoRdtL
         t/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8taYkiDRhxwSj2khSrYXtScgLWDxF1GD5X3Ip5sSGs=;
        b=ETwis18IZj3aepQJHIL8aMiwBQUF9JCO9bGM1Sa50uANPdZ6nLlL7ccEl+1+3J+YL8
         e7Ub66dNvS0mQFWBTvWJqV2Hxchv+nboolrlJRNIzvBLBHvbQFiUq3s8zJ4XxG+kLP/f
         1BqkZI14lIxswwjkGjV8fTy8m4Jza+xBedX0Jy9eXsUM8JVmPl6aGqn/TUFjIvDXNwcX
         sKjZYQwckVOi/5HKAoC6cjSIkaEzf8a2Q7cQ/H3DPpdYZeoaimWQpGmLmqgmXXFQW4D7
         rnBMJrI7TqU8cTDzgNMTNxKo42YdBjd1AMWzS4ub5e75t5HKZYaiC8FxzXb+dlnj8s1b
         g+eA==
X-Gm-Message-State: AO0yUKX/lTs/95tXiuVPXSk1Im7zm5dOffuS7lJCF7iqItiJtwe9eg1P
        1MBActFH0d6QO4SF0KPPw/qcyT2MOm3xZk72
X-Google-Smtp-Source: AK7set+aTxPF4ny5RRAONgayCfTl2kwcaYwdQh9zSQY+aRfErh7XOu1AKwZIhC13TWp5Gcty+g3RPQ==
X-Received: by 2002:adf:fa09:0:b0:2bf:ac2c:4489 with SMTP id m9-20020adffa09000000b002bfac2c4489mr2351847wrr.54.1674555214568;
        Tue, 24 Jan 2023 02:13:34 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r1-20020a0560001b8100b002bfae16ee2fsm1452595wru.111.2023.01.24.02.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 02:13:34 -0800 (PST)
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Qi Duan <qi.duan@amlogic.com>
Subject: [PATCH v2 net] net: mdio-mux-meson-g12a: force internal PHY off on mux switch
Date:   Tue, 24 Jan 2023 11:11:57 +0100
Message-Id: <20230124101157.232234-1-jbrunet@baylibre.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Force the internal PHY off then on when switching to the internal path.
This fixes problems where the PHY ID is not properly set.

Fixes: 7090425104db ("net: phy: add amlogic g12a mdio mux support")
Suggested-by: Qi Duan <qi.duan@amlogic.com>
Co-developed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
---

Changes since v1:
 - Fix variable position for reverse Xmas tree requirement.

The initial discussion about this change can be found here:
https://lore.kernel.org/all/1j4jslwen5.fsf@starbuckisacylon.baylibre.com/

 drivers/net/mdio/mdio-mux-meson-g12a.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-meson-g12a.c b/drivers/net/mdio/mdio-mux-meson-g12a.c
index 4a2e94faf57e..c4542ecf5623 100644
--- a/drivers/net/mdio/mdio-mux-meson-g12a.c
+++ b/drivers/net/mdio/mdio-mux-meson-g12a.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/device.h>
@@ -150,6 +151,7 @@ static const struct clk_ops g12a_ephy_pll_ops = {
 
 static int g12a_enable_internal_mdio(struct g12a_mdio_mux *priv)
 {
+	u32 value;
 	int ret;
 
 	/* Enable the phy clock */
@@ -163,18 +165,25 @@ static int g12a_enable_internal_mdio(struct g12a_mdio_mux *priv)
 
 	/* Initialize ephy control */
 	writel(EPHY_G12A_ID, priv->regs + ETH_PHY_CNTL0);
-	writel(FIELD_PREP(PHY_CNTL1_ST_MODE, 3) |
-	       FIELD_PREP(PHY_CNTL1_ST_PHYADD, EPHY_DFLT_ADD) |
-	       FIELD_PREP(PHY_CNTL1_MII_MODE, EPHY_MODE_RMII) |
-	       PHY_CNTL1_CLK_EN |
-	       PHY_CNTL1_CLKFREQ |
-	       PHY_CNTL1_PHY_ENB,
-	       priv->regs + ETH_PHY_CNTL1);
+
+	/* Make sure we get a 0 -> 1 transition on the enable bit */
+	value = FIELD_PREP(PHY_CNTL1_ST_MODE, 3) |
+		FIELD_PREP(PHY_CNTL1_ST_PHYADD, EPHY_DFLT_ADD) |
+		FIELD_PREP(PHY_CNTL1_MII_MODE, EPHY_MODE_RMII) |
+		PHY_CNTL1_CLK_EN |
+		PHY_CNTL1_CLKFREQ;
+	writel(value, priv->regs + ETH_PHY_CNTL1);
 	writel(PHY_CNTL2_USE_INTERNAL |
 	       PHY_CNTL2_SMI_SRC_MAC |
 	       PHY_CNTL2_RX_CLK_EPHY,
 	       priv->regs + ETH_PHY_CNTL2);
 
+	value |= PHY_CNTL1_PHY_ENB;
+	writel(value, priv->regs + ETH_PHY_CNTL1);
+
+	/* The phy needs a bit of time to power up */
+	mdelay(10);
+
 	return 0;
 }
 
-- 
2.39.0

