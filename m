Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CDE5A28E0
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 15:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343723AbiHZNzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 09:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiHZNzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 09:55:00 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AE1275FC;
        Fri, 26 Aug 2022 06:54:57 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 176AA240008;
        Fri, 26 Aug 2022 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661522096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YIEtOKyE2S1rP4xNAtZiRn4s6t1T6XAkiZfnPLjfWu4=;
        b=UvEUK/zYB+YqlMCN5VJVtpW+6MXVn731QA2TuZ+0RYWYpkd6AtzbfFxttccnrUxbr2cKyl
        4h06ix7+3+DOzZVAk2E0RZSFsOh4gMzS97l4Q8lo81xF+/n6J9G76uLcJzx9pubyS+g7vG
        6FhG7bgAJBkvFvRZ9P1FkvzQvq2fnX+SLLjW2dNSlCoprHXl01YJURpNM1p8YcHwWqe1/O
        8Iu0VMcsG5lwA7yZe/6x2O2XTnwHmeCWf8xqDwW2DNMVzR4/R7J1Xa31dPhMxV/ZCOrRf0
        6+FVan+2xUqP/DP8+tY7udWW3jjCD6rFVUrUmuUKHIB9AJ29U+c32FVCsicCuQ==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH net-next 0/5] net: altera: tse: phylink conversion
Date:   Fri, 26 Aug 2022 15:54:46 +0200
Message-Id: <20220826135451.526756-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is a rework of a previous series [1], and as Russell stated,
it needed work :)

The Altera TSE can be built with a SGMII/1000BaseX PCS, allowing to use
SFP ports with this MAC, which is the end goal of adding phylink support
and a proper PCS driver.

The PCS itself can either be mapped in the MAC's register space, in that
case, it's accessed through 32 bits registers, with the higher 16 bits
always 0. Alternatively, it can sit on its own register space, exposing
16 bits registers, some of which ressemble the standard PHY registers.

To tackle that rework, several things needs updating, starting by the DT
binding, since we add support for a new register range for the PCS.

Hence, the first patch of the series is a conversion to YAML of the
existing binding.

Then, patch 2 does a bit of simple cleanup to the TSE driver, using nice
reverse xmas tree definitions.

Patch 3 adds the actual PCS driver, as a standalone driver. Some future
series will then reuse that PCS driver from the dwmac-socfpga driver,
which implements support for this exact PCS too, allowing to share the
code nicely.

Patch 4 is then a phylink conversion of the altera_tse driver, to use
this new PCS driver.

Finally, patch 5 updates the newly converted DT binding to support the
pcs register range.

This series contains bits and pieces for this conversion, please tell me if
you want me to send it as individual patches.

Thanks,

Maxime

[1] : https://lore.kernel.org/netdev/20220823140517.3091239-1-maxime.chevallier@bootlin.com/

Maxime Chevallier (5):
  dt-bindings: net: Convert Altera TSE bindings to yaml
  net: altera: tse: cosmetic change to use reverse xmas tree ordering
  net: pcs: add new PCS driver for altera TSE PCS
  net: altera: tse: convert to phylink
  dt-bindings: net: altera: tse: add an optional pcs register range

 .../devicetree/bindings/net/altera_tse.txt    | 113 -----
 .../devicetree/bindings/net/altr,tse.yaml     | 162 +++++++
 MAINTAINERS                                   |   7 +
 arch/arm/boot/dts/Makefile                    |   3 +-
 drivers/net/ethernet/altera/Kconfig           |   2 +
 drivers/net/ethernet/altera/altera_tse.h      |  19 +-
 .../net/ethernet/altera/altera_tse_ethtool.c  |  22 +-
 drivers/net/ethernet/altera/altera_tse_main.c | 453 +++++-------------
 drivers/net/pcs/Kconfig                       |   6 +
 drivers/net/pcs/Makefile                      |   1 +
 drivers/net/pcs/pcs-altera-tse.c              | 162 +++++++
 include/linux/pcs-altera-tse.h                |  17 +
 12 files changed, 519 insertions(+), 448 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/altera_tse.txt
 create mode 100644 Documentation/devicetree/bindings/net/altr,tse.yaml
 create mode 100644 drivers/net/pcs/pcs-altera-tse.c
 create mode 100644 include/linux/pcs-altera-tse.h

-- 
2.37.2

