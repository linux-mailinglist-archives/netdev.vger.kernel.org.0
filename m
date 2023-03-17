Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E756BF000
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCQRm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjCQRmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:42:53 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FA731BDF;
        Fri, 17 Mar 2023 10:42:50 -0700 (PDT)
Received: from jupiter.universe (dyndsl-091-248-191-142.ewe-ip-backbone.de [91.248.191.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id DD3F666030C6;
        Fri, 17 Mar 2023 17:42:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1679074969;
        bh=jAfwTMiBYZ9JmHPeHDLPoQkj/I4GmFopx/XoUWYNTok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZyaalmUWg7i9X+DtwzcwFjLyI3BOe6Ifqh+n79qvr+/W5lAs7oEM8ODadZNy7EgB
         N+6LPcQphz2d0IDDpLTWywduBD9NvGCRyjJL5tcf1cTYAuwm7bIb3ed9HU47rpT14O
         0bdAMovcGI+hjsve/iRCFV94a8XCX2opYT670ExgmZsoqZnLz5/co3+TJuMZbKPtF7
         WAuoWgmEDNW6tqMg2i3otXjdYp8feIxyxaJQ34buEGvPNlz7vs6UleOz7fm76EjGer
         ccKs5uC2nggghK/GQayLmezOUm3h2hoRNIDK98yzVXecFe8DI+ZGKQFkjmpsvYgCfz
         DXurHO2WqmNNw==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 433334807E3; Fri, 17 Mar 2023 18:42:46 +0100 (CET)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCHv1 2/2] net: ethernet: stmmac: dwmac-rk: fix optional phy regulator handling
Date:   Fri, 17 Mar 2023 18:42:43 +0100
Message-Id: <20230317174243.61500-3-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317174243.61500-1-sebastian.reichel@collabora.com>
References: <20230317174243.61500-1-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The usual devm_regulator_get() call already handles "optional"
regulators by returning a valid dummy and printing a warning
that the dummy regulator should be described properly. This
code open coded the same behaviour, but masked any errors that
are not -EPROBE_DEFER and is quite noisy.

This change effectively unmasks and propagates regulators errors
not involving -ENODEV, downgrades the error print to warning level
if no regulator is specified and captures the probe defer message
for /sys/kernel/debug/devices_deferred.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 126812cd17e6..01de0174fa18 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1680,14 +1680,11 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 		}
 	}
 
-	bsp_priv->regulator = devm_regulator_get_optional(dev, "phy");
+	bsp_priv->regulator = devm_regulator_get(dev, "phy");
 	if (IS_ERR(bsp_priv->regulator)) {
-		if (PTR_ERR(bsp_priv->regulator) == -EPROBE_DEFER) {
-			dev_err(dev, "phy regulator is not available yet, deferred probing\n");
-			return ERR_PTR(-EPROBE_DEFER);
-		}
-		dev_err(dev, "no regulator found\n");
-		bsp_priv->regulator = NULL;
+		ret = PTR_ERR(bsp_priv->regulator);
+		dev_err_probe(dev, ret, "failed to get phy regulator\n");
+		return ERR_PTR(ret);
 	}
 
 	ret = of_property_read_string(dev->of_node, "clock_in_out", &strings);
-- 
2.39.2

