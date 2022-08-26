Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637BB5A273A
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245573AbiHZL4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239937AbiHZL4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:56:20 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C346D563;
        Fri, 26 Aug 2022 04:56:14 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 7FE0783CA;
        Fri, 26 Aug 2022 13:56:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661514972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZKrwgi7/hIQ+plSmPIijraxN7GjbIh/xtpYdqsbEkzg=;
        b=Aa79R5lOpLRfnVBbTy686ct+KxEHr8CTdlrkr4NVdc/gIEBWrgPiQTRDut6wQ/ezeQ05tw
        XcVWPt8CDZMIwB0iPQ1Mhg4CZe0BGsFmRB5/KzMO9WoBDtCbLXY1N6VpnHFakzWg1uzl1X
        fCmnpSIc8OK0YfyWs6xVpXvi/06YQH9cfQiEV/+aKnykx9Ri5Ky7bVMfs0ifmseDv+DXSb
        AfBsCjPosPX2rZeYNT0OCt6dEdXahZjkbCPTqHLvc9B8eAdiNKJL2orSKwOdH7wfjguKmS
        vz4d1jKCsMuYfdi3BS8DfUClCuWmMHTZgqdYx6NunYQp7zibMAEHJ5o1rqREOA==
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH 1/3] reset: microchip-sparx5: issue a reset on startup
Date:   Fri, 26 Aug 2022 13:56:05 +0200
Message-Id: <20220826115607.1148489-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826115607.1148489-1-michael@walle.cc>
References: <20220826115607.1148489-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Originally this was used in by the switch core driver to issue a reset.
But it turns out, this isn't just a switch core reset but instead it
will reset almost the complete SoC.

Instead of adding almost all devices of the SoC a shared reset line,
issue the reset once early on startup. Keep the reset controller for
backwards compatibility, but make the actual reset a noop.

Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/reset/reset-microchip-sparx5.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/reset/reset-microchip-sparx5.c b/drivers/reset/reset-microchip-sparx5.c
index 00b612a0effa..f3528dd1d084 100644
--- a/drivers/reset/reset-microchip-sparx5.c
+++ b/drivers/reset/reset-microchip-sparx5.c
@@ -33,11 +33,8 @@ static struct regmap_config sparx5_reset_regmap_config = {
 	.reg_stride	= 4,
 };
 
-static int sparx5_switch_reset(struct reset_controller_dev *rcdev,
-			       unsigned long id)
+static int sparx5_switch_reset(struct mchp_reset_context *ctx)
 {
-	struct mchp_reset_context *ctx =
-		container_of(rcdev, struct mchp_reset_context, rcdev);
 	u32 val;
 
 	/* Make sure the core is PROTECTED from reset */
@@ -54,8 +51,14 @@ static int sparx5_switch_reset(struct reset_controller_dev *rcdev,
 					1, 100);
 }
 
+static int sparx5_reset_noop(struct reset_controller_dev *rcdev,
+			     unsigned long id)
+{
+	return 0;
+}
+
 static const struct reset_control_ops sparx5_reset_ops = {
-	.reset = sparx5_switch_reset,
+	.reset = sparx5_reset_noop,
 };
 
 static int mchp_sparx5_map_syscon(struct platform_device *pdev, char *name,
@@ -122,6 +125,11 @@ static int mchp_sparx5_reset_probe(struct platform_device *pdev)
 	ctx->rcdev.of_node = dn;
 	ctx->props = device_get_match_data(&pdev->dev);
 
+	/* Issue the reset very early, our actual reset callback is a noop. */
+	err = sparx5_switch_reset(ctx);
+	if (err)
+		return err;
+
 	return devm_reset_controller_register(&pdev->dev, &ctx->rcdev);
 }
 
@@ -163,6 +171,10 @@ static int __init mchp_sparx5_reset_init(void)
 	return platform_driver_register(&mchp_sparx5_reset_driver);
 }
 
+/*
+ * Because this is a global reset, keep this postcore_initcall() to issue the
+ * reset as early as possible during the kernel startup.
+ */
 postcore_initcall(mchp_sparx5_reset_init);
 
 MODULE_DESCRIPTION("Microchip Sparx5 switch reset driver");
-- 
2.30.2

