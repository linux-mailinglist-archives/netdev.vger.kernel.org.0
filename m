Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F95C690C92
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjBIPOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjBIPOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:14:18 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01B232523;
        Thu,  9 Feb 2023 07:14:16 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5DDF2100004;
        Thu,  9 Feb 2023 15:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675955654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YVOvYQa9qOIWTUDpJqNiGlDU/+I5voPK1qjEvEaieaY=;
        b=Y7+wp6Xw0fNNsld9rdLaqiHWFAYyK3efTcjSVW0j0yaKHFk0EUmpSzre8SqIgEh+tj1fkn
        l/v9rbwzPUv6+Gxtgim0bKbjjnIh5RVRU1E8kJeg8f4wrieipoJ75fp8bn9vsB0yIDELL2
        I71Vqc9nU5nT1l+XCNJp9aWBhsSlqJLr6yyaLKQLP4YeA4TyfFZDuyQUuP9xCAjyJyRNyB
        j2Mn0YerZl36xgXbgHPKAgfbYO7BxvSyWfQ+z5aPbqIvHzV1LKOyQTAc0Xaxm+HUJzW/sw
        QXbzZYm/3yGpm1l7rz4cFRQotcY6+TuxU8VGDMH9HMXKFRXvngjvcvLMexvjrA==
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
Subject: [PATCH net-next v3 0/6] net: stmmac: add renesas,rzn1-gmac support
Date:   Thu,  9 Feb 2023 16:16:26 +0100
Message-Id: <20230209151632.275883-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rzn1-gmac instance is connected to a PCS (MIIC). In order to use
this pcs, add support in the sttmac driver to set a generic phylink pcs
device instead of the xpcs only. Moreover, it adds support to provide
a phylink pcs device from the stmmac platform data and use it with the
driver. It also adds the bindings and the new rzn1-gmac driver that
retrieve this pcs from the device-tree.

---
V3:
 - Sort out the bindings compatible

V2:
 - Remove patch that moves phylink_start() earlier in init
 - Add miic_early_qsetup()  which allows initializing some miic port
   earlier to provide a RX clock to stmmac IP
 - Call miic_early_setup() in rzn1 stmmac driver
 - Fix bindings

Clément Léger (6):
  net: pcs: rzn1-miic: add pcs_early_setup() function
  net: stmmac: add support to use a generic phylink_pcs as PCS
  net: stmmac: add support to provide pcs from platform data
  dt-bindings: net: renesas,rzn1-gmac: Document RZ/N1 GMAC support
  net: stmmac: add support for RZ/N1 GMAC
  ARM: dts: r9a06g032: describe GMAC1

 .../bindings/net/renesas,rzn1-gmac.yaml       |  67 ++++++++++
 arch/arm/boot/dts/r9a06g032.dtsi              |  18 +++
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  11 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-rzn1.c  | 120 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   1 +
 drivers/net/pcs/pcs-rzn1-miic.c               |  12 ++
 include/linux/pcs-rzn1-miic.h                 |   3 +
 include/linux/stmmac.h                        |   1 +
 11 files changed, 240 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c

-- 
2.39.0

