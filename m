Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B26E5AAA09
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 10:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbiIBIcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 04:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbiIBIcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 04:32:17 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB182C0BE9;
        Fri,  2 Sep 2022 01:32:13 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2C910C000D;
        Fri,  2 Sep 2022 08:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662107532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ss5Njgejn8S6zVNK73ckz7rzGoGVEnyMlp4C2rUR5LA=;
        b=QlxmRcMA5f9gisCI/Ub/b/DGVscsrkjyLmgqG3LNr86o511yrfJ5lFCqzhMdBkBTsUSE+U
        xausUaEsLCqsMyFcVS8EV5Buiwsk8VTk+wrjzTJOqUPIn0fbcoFVZxf0T/NUjf5LGa73Hj
        1KxRx/ekXR6y8Xbeei/vLzfr9Jhxt36dA6EHarVkDjL/6ApswuSbhRWup1uJJuUPDkCIXz
        G36cN6sheETfMOL/b5Bhfld1oQbK3PBp7W6SUAtSDL4K2xW7y7gg20zz1ltawk7Q+luWkO
        iDgf0Fdremy7ModK/enB/rywmKwSZ61A0dVyVs1BKtA8EQwumbRtAPs4sZJ/Qg==
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
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v4 0/5] net: altera: tse: phylink conversion
Date:   Fri,  2 Sep 2022 10:32:00 +0200
Message-Id: <20220902083205.483438-1-maxime.chevallier@bootlin.com>
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

This is V4 of a series converting the Altera TSE driver to phylink,
introducing a new PCS driver along the way.

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

V4 Changes:
 - Add missing MODULE_* macros to the TSE PCS driver

V3 Changes:
 - YAML binding conversion changes and PCS addition changes thanks to
   Krzysztof's reviews

V2 Changes :
 - Fixed the binding after the YAML conversion
 - Added a pcs_validate() callback
 - Introduced a comment to justify a soft reset for the PCS



Maxime Chevallier (5):
  dt-bindings: net: Convert Altera TSE bindings to yaml
  net: altera: tse: cosmetic change to use reverse xmas tree ordering
  net: pcs: add new PCS driver for altera TSE PCS
  net: altera: tse: convert to phylink
  dt-bindings: net: altera: tse: add an optional pcs register range

 .../devicetree/bindings/net/altera_tse.txt    | 113 -----
 .../devicetree/bindings/net/altr,tse.yaml     | 168 +++++++
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/altera/Kconfig           |   2 +
 drivers/net/ethernet/altera/altera_tse.h      |  19 +-
 .../net/ethernet/altera/altera_tse_ethtool.c  |  22 +-
 drivers/net/ethernet/altera/altera_tse_main.c | 453 +++++-------------
 drivers/net/pcs/Kconfig                       |   6 +
 drivers/net/pcs/Makefile                      |   1 +
 drivers/net/pcs/pcs-altera-tse.c              | 175 +++++++
 include/linux/pcs-altera-tse.h                |  17 +
 11 files changed, 536 insertions(+), 447 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/altera_tse.txt
 create mode 100644 Documentation/devicetree/bindings/net/altr,tse.yaml
 create mode 100644 drivers/net/pcs/pcs-altera-tse.c
 create mode 100644 include/linux/pcs-altera-tse.h

-- 
2.37.2

