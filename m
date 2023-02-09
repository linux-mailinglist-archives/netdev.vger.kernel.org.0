Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6A0690C99
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjBIPOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjBIPO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:14:28 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2199F60E60;
        Thu,  9 Feb 2023 07:14:21 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C3FEA10000E;
        Thu,  9 Feb 2023 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675955660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1zV1VFrWVhQ6vhXF/fCLwcz9IjHBuYzryMaqXBU05Vo=;
        b=mg31+fwmnqE8u7cGEi/QGe/SMl4+BaYKkpQi1C+HTGPppCfF+Fha0WJeq4chwPPf2489cK
        2zMxvzC6h+MfgiCzZEBddNfqlAo0C5/EcRXdb+fqm89SdLoxwZ0gFn1jHBP4/B5jBsApVK
        DokxQO5wmtMmkBJJ30Z4uZUnRmZmIP3opk9DRGl10MawKt37a4xL7RBgOqjOJPAqCoKChQ
        1W2UE3sxFea/w39bZ5kTSPnoHicRv+Gei5bvsQKM+0pHu7d8EO2pcyPOUGTnd6WJNgTsrG
        msyjEBkI3aUeXQ9Z4S82IPRPmXfJgYlXJZbRVuKucSIFlptwK2SvpsWEJbuA1g==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next v3 1/6] net: pcs: rzn1-miic: add pcs_early_setup() function
Date:   Thu,  9 Feb 2023 16:16:27 +0100
Message-Id: <20230209151632.275883-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209151632.275883-1-clement.leger@bootlin.com>
References: <20230209151632.275883-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using this PCS with the stmmac IP, if the pcs is not configured and
enabled before setting up stmmac hardware, driver setup will fail due to
the lack of input RGMII RX clock. Add pcs_early_setup() function which
allows to configure the MIIC converter based on the "phy-mode" that is
described in the device-tree.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/pcs/pcs-rzn1-miic.c | 12 ++++++++++++
 include/linux/pcs-rzn1-miic.h   |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-miic.c
index c1424119e821..e2eaf789c4d2 100644
--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -288,6 +288,18 @@ static const struct phylink_pcs_ops miic_phylink_ops = {
 	.pcs_link_up = miic_link_up,
 };
 
+int miic_early_setup(struct phylink_pcs *pcs, struct device *dev)
+{
+	int interface;
+
+	interface = device_get_phy_mode(dev);
+	if (interface < 0)
+		return interface;
+
+	return miic_config(pcs, 0, interface, NULL, false);
+}
+EXPORT_SYMBOL(miic_early_setup);
+
 struct phylink_pcs *miic_create(struct device *dev, struct device_node *np)
 {
 	struct platform_device *pdev;
diff --git a/include/linux/pcs-rzn1-miic.h b/include/linux/pcs-rzn1-miic.h
index 56d12b21365d..84d7130b4b78 100644
--- a/include/linux/pcs-rzn1-miic.h
+++ b/include/linux/pcs-rzn1-miic.h
@@ -9,8 +9,11 @@
 #define __LINUX_PCS_MIIC_H
 
 struct phylink;
+struct phylink_pcs;
 struct device_node;
 
+int miic_early_setup(struct phylink_pcs *pcs, struct device *dev);
+
 struct phylink_pcs *miic_create(struct device *dev, struct device_node *np);
 
 void miic_destroy(struct phylink_pcs *pcs);
-- 
2.39.0

