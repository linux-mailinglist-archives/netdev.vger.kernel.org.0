Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC83C66BBD8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjAPKha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjAPKh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:37:27 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6E74EEB;
        Mon, 16 Jan 2023 02:37:24 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D331A1BF20C;
        Mon, 16 Jan 2023 10:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673865443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iuogAIwpArvmHJjJhEa0zf0j5PCkZDBGtycwVIelMX8=;
        b=CEhOE2qh+5jjLZr3yM8AnWuKjQL21XfBx2BU/akJuNd5H5Qld2ukY9uV2vsZYedWeZF2Pk
        ZkBScwq/jK/2rnV+ioVHfb70cF9a0TBkD5d6UeTy5aiv7iZ7iL7aXsdomFhUXGcgFP4BPh
        uPRGALpCDZnm6f+8GD9nDQAVSRnMeULNN0K99nnVq4yPZ+qw6w6aoeHgC04jxqhi5DOQg/
        KrABaPJmOblW7Vaif6Dx3Tbg23fpguN0heuzjx32dVhL3Z5H31c/QD0BHx2njYuvD6KxxW
        zeU6IGyGL9+WhfeWlplRXaZiiGpy9iKBnuUu0jyXlm9ymsssh86wYYQbbqJnUA==
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
Subject: [PATCH net-next 0/6] net: stmmac: add renesas,rzn1-gmac support
Date:   Mon, 16 Jan 2023 11:39:20 +0100
Message-Id: <20230116103926.276869-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
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

The rzn1-gmac instance is connected to a PCS (MIIC). In order to use
this pcs, add support in the sttmac driver to set a generic phylink pcs
device instead of the xpcs only. Moreover, it adds support to provide
a phylink pcs device from the stmmac platform data and use it with the
driver. It also adds the bindings and the new rzn1-gmac driver that
retrieve this pcs from the device-tree.

Clément Léger (6):
  net: stmmac: add support to use a generic phylink_pcs as PCS
  net: stmmac: add support to provide pcs from platform data
  net: stmmac: start phylink before setting up hardware
  dt-bindings: net: renesas,rzn1-gmac: Document RZ/N1 GMAC support
  net: stmmac: add support for RZ/N1 GMAC
  ARM: dts: r9a06g032: describe GMAC1

 .../bindings/net/renesas,rzn1-gmac.yaml       |  71 +++++++++++
 arch/arm/boot/dts/r9a06g032.dtsi              |  18 +++
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  11 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-rzn1.c  | 113 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  15 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   1 +
 include/linux/stmmac.h                        |   1 +
 9 files changed, 228 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c

-- 
2.39.0

