Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C825132A6
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345648AbiD1LoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345601AbiD1LoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:44:11 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2897C62122;
        Thu, 28 Apr 2022 04:40:57 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1075722249;
        Thu, 28 Apr 2022 13:40:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1651146055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NhyUX8NrB9R4zw/4LqnaXeXcLnYWsky0fsM9I1Ry8ms=;
        b=bBHRS/eF+qx7+M7ubFA7WnWqkGl7OON36c98mWO3YYXffzf23bCJa6ooJviw7xreBBqncK
        rwwC9mUJ+vbyEmnkGLWBzeO2mQbQENVjOopV2uFcW7qS3Abpx2YE3EgVF3wqThRR+QVlAf
        CpettRDw7Q+HbjhEgQHvBzIWKIycPbA=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/2] net: lan966x: remove PHY reset support
Date:   Thu, 28 Apr 2022 13:40:49 +0200
Message-Id: <20220428114049.1456382-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220428114049.1456382-1-michael@walle.cc>
References: <20220428114049.1456382-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY subsystem as well as the MIIM mdio driver (in case of the
integrated PHYs) will take care of the resets. A separate reset driver
isn't needed. There is no in-tree user of this feature. Remove the
support.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 6579c7062aa5..138718f33dbd 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -937,7 +937,7 @@ static int lan966x_ram_init(struct lan966x *lan966x)
 
 static int lan966x_reset_switch(struct lan966x *lan966x)
 {
-	struct reset_control *switch_reset, *phy_reset;
+	struct reset_control *switch_reset;
 	int val = 0;
 	int ret;
 
@@ -946,13 +946,7 @@ static int lan966x_reset_switch(struct lan966x *lan966x)
 		return dev_err_probe(lan966x->dev, PTR_ERR(switch_reset),
 				     "Could not obtain switch reset");
 
-	phy_reset = devm_reset_control_get_shared(lan966x->dev, "phy");
-	if (IS_ERR(phy_reset))
-		return dev_err_probe(lan966x->dev, PTR_ERR(phy_reset),
-				     "Could not obtain phy reset\n");
-
 	reset_control_reset(switch_reset);
-	reset_control_reset(phy_reset);
 
 	lan_wr(SYS_RESET_CFG_CORE_ENA_SET(0), lan966x, SYS_RESET_CFG);
 	lan_wr(SYS_RAM_INIT_RAM_INIT_SET(1), lan966x, SYS_RAM_INIT);
-- 
2.30.2

