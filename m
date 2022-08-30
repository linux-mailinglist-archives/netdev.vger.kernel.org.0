Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6A15A5FEC
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiH3J4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiH3J4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:56:12 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D523ECD8;
        Tue, 30 Aug 2022 02:55:56 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0847B1BF209;
        Tue, 30 Aug 2022 09:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661853353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fNe7O3XpPrKWPRiBDZbqoQEmh7mC5aGWDTgnBM7l0Y4=;
        b=X2eVFd1qvXvmNmg0+jyQHr4YkkmSfTlnrgKIXOpOJB/PPGW4SWQ9TB5gJxjYAntLFQWIXF
        49cRvnWRdg/WeH3pnthiGwuOhHqGHjTFj/+sMKXrpYXccAiONmldTIOEnr8I0AOKU5Pjom
        YFktlpPIZOO/8cJDutCi+tSMz2rnKtydUW4AckPeMqwpFZiQMsLp090DPj8uCBkOaY+J71
        ceYhgbv8VQDTzyUiJ3inR/ezCuymXbgzHghEsonA99TS9an9jwCpmKV65aMV3WsKaY661x
        kj6VqQ2c2ox521TZ80+I4hbzz3DH2GhmL+fL2tKVAuznw6UqKIY9Ynh1wEInaA==
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
Subject: [PATCH net-next v2 0/5] net: altera: tse: phylink conversion
Date:   Tue, 30 Aug 2022 11:55:44 +0200
Message-Id: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
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

This is V2 of a series converting the Altera TSE driver to phylink,
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
 .../devicetree/bindings/net/altr,tse.yaml     | 183 +++++++
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/altera/Kconfig           |   2 +
 drivers/net/ethernet/altera/altera_tse.h      |  19 +-
 .../net/ethernet/altera/altera_tse_ethtool.c  |  22 +-
 drivers/net/ethernet/altera/altera_tse_main.c | 453 +++++-------------
 drivers/net/pcs/Kconfig                       |   6 +
 drivers/net/pcs/Makefile                      |   1 +
 drivers/net/pcs/pcs-altera-tse.c              | 171 +++++++
 include/linux/pcs-altera-tse.h                |  17 +
 11 files changed, 547 insertions(+), 447 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/altera_tse.txt
 create mode 100644 Documentation/devicetree/bindings/net/altr,tse.yaml
 create mode 100644 drivers/net/pcs/pcs-altera-tse.c
 create mode 100644 include/linux/pcs-altera-tse.h

-- 
2.37.2

