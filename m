Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A096D8321
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjDEQK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjDEQKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:10:54 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6098659C;
        Wed,  5 Apr 2023 09:10:49 -0700 (PDT)
Received: from jupiter.universe (dyndsl-091-248-212-122.ewe-ip-backbone.de [91.248.212.122])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id C41F56603101;
        Wed,  5 Apr 2023 17:10:47 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680711047;
        bh=O0OERdh8YQllL/WUi4nWvlzY8+V5Fv1hvisy2ugrnhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbxXH31kvJ+rymvSpUIGGj1exJoQutsqaeLZcu701DEv+NQ7wP4UW7nVEyD04xuFp
         NkypRVHronXrDyCFhgdNiXm90w7sdnmP01aDBPD4iRtRPG9ZvfM8w6SNzcwyv93Oxc
         3rbxyPq2DJz9qIDdV5sx4fanYq5qk9mUw2nlZOjoGSlaI+gGUF9kniOpQPLnTfJY4h
         Ze/4h+X8VQR0EpEugKxeUzD7F7+2NTVRFUELRksEIvcrB6dYM90r4D2A4lbK3Tj6Tj
         MaG1hwYcQ6q+dDf2TGsN0eLMEfZB34PlL4Brk6VMlUYWhGmoLqsXdKt68lNLWORwPg
         gvBQ8c+gnGdeg==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 4482B4807E3; Wed,  5 Apr 2023 18:10:45 +0200 (CEST)
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
Subject: [PATCHv2 2/2] net: ethernet: stmmac: dwmac-rk: fix optional phy regulator handling
Date:   Wed,  5 Apr 2023 18:10:43 +0200
Message-Id: <20230405161043.46190-3-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405161043.46190-1-sebastian.reichel@collabora.com>
References: <20230405161043.46190-1-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Fixes: 2e12f536635f8 ("net: stmmac: dwmac-rk: Use standard devicetree property for phy regulator")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 6fdad0f10d6f..d9deba110d4b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1656,14 +1656,11 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
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

