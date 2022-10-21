Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5C5607731
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJUMqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJUMqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:46:06 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EDD2623D1;
        Fri, 21 Oct 2022 05:46:01 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 59E2460008;
        Fri, 21 Oct 2022 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666356360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6MzwULgZkYIH+I24/ukKkCUGhKw8knvuqvLiwjgom5I=;
        b=Gi5hsBVBMvA8jhd+ONYWTE1H1ViQy3rGFj/+uCMfClcvp0bylB8kwLle4pykWTAtdSIs6t
        BfCTb5OcZ2UnadIyNa1ADog+QLdTU3IgUnyu3+eXzuRK4L1RREHxbiNSFqDCKQDDTgDm//
        sPRXlq6aVK8BdGprt4y7wsQaDFEH6c41JA6Hhh6//z9Zo6n0T3KHobD5UAzrZ5HGr+k2ii
        5ozsjL5M9oNvfRTyGm5m71NsxShIV+3Ki1eBOcyG0UR7/ec58xp9LsGF7DPu7j1inoxP68
        Tp3EkYSU9oZy7vUr8+3zthy9xHIRGvng6M/rMzibe2mOABXRXZCJ6YpvN44k0Q==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v5 0/5] [PATCH net-next v4 0/5] net: ipqess: introduce Qualcomm IPQESS driver
Date:   Fri, 21 Oct 2022 14:45:51 +0200
Message-Id: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

This is the 5th iteration of a series that introduces a new driver, for
the Qualcomm IPQESS Ethernet Controller, found on the IPQ4019.

Note that this series contains binding patches that should go through the
DT tree.

The notable aspect of this series is the introduction of an out-of-band
DSA tagger. While V1 used a custom set of sk_buff fields, and v2 to v4
used the headroom to convey the tag, this version uses skb extensions to
carry the tag.

This allows to easily identify that a skb conveys a tag or not, by
checking if the extension is here.

Other changes in the series were some rework of the napi polling loops,
and a few fixes suggested by Vlad, Andrew and Krzysztof.

Notables changes on V5 :
 - Fix caching of CHANGEUPPER events
 - Use a skb extension-based tagger
 - Rename the binding file
 - Some cleanups in the ipqess driver itself

Notables changes on V4 :
 - Cache the uses_dsa info from CHANGEUPPER events
 - Use better string handling helpers for ethtool stats
 - rename ethtool callbacks
 - Fix a binding typo

Notables changes on V3 :
 - Took into account Russell's review on the ioctl handler and the mac
   capabilities that were missing
 - Took Andrew's reviews into account by reworking the napi rx loop,
   some stray "inline" keywords, and useless warnings
 - Took Vlad's reviews into account by reworking a few macros
 - Took Christophe's review into account by removing extra GFP_ZERO
 - Took Rob's review into account by simplifying the binding

Notables changes on V2 :
 - Put the DSA tag in the skb itself instead of using skb->shinfo
 - Fixed the initialisation sequence based on Andrew's comments
 - Reworked the error paths in the init sequence
 - Add support for the clock and reset lines on that controller
 - Fixed and updated the binding

The driver itself is pretty straightforward, but has lived out-of-tree
for a while. I've done my best to clean-up some outdated API calls, but
some might remain.

This controller is somewhat special, since it's part of the IPQ4019 SoC
which also includes an QCA8K switch, and uses the IPQESS controller for
the CPU port. The switch is so tightly intergrated with the MAC that it
is connected to the MAC using an internal link (hence the fact that we
only support PHY_INTERFACE_MODE_INTERNAL), and this has some
consequences on the DSA side.

The tagging for the switch isn't done inband as most switch do, but
out-of-band, the DSA tag being included in the DMA descriptor.

This series includes a new out-of-band tagger that uses skb extensions
to convey the tag between the tagger and the MAC driver.

Thanks to the Sartura folks who worked on a base version of this driver,
and provided test hardware.

Best regards,

Maxime Chevallier

Maxime Chevallier (5):
  net: dt-bindings: Introduce the Qualcomm IPQESS Ethernet controller
  net: ipqess: introduce the Qualcomm IPQESS driver
  net: dsa: add out-of-band tagging protocol
  net: ipqess: Add out-of-band DSA tagging support
  ARM: dts: qcom: ipq4019: Add description for the IPQESS Ethernet
    controller

 .../bindings/net/qcom,ipq4019-ess-edma.yaml   |   95 ++
 MAINTAINERS                                   |    6 +
 arch/arm/boot/dts/qcom-ipq4019.dtsi           |   46 +
 drivers/net/ethernet/qualcomm/Kconfig         |   12 +
 drivers/net/ethernet/qualcomm/Makefile        |    2 +
 drivers/net/ethernet/qualcomm/ipqess/Makefile |    8 +
 drivers/net/ethernet/qualcomm/ipqess/ipqess.c | 1324 +++++++++++++++++
 drivers/net/ethernet/qualcomm/ipqess/ipqess.h |  522 +++++++
 .../ethernet/qualcomm/ipqess/ipqess_ethtool.c |  164 ++
 include/linux/dsa/oob.h                       |   17 +
 include/linux/skbuff.h                        |    3 +
 include/net/dsa.h                             |    2 +
 net/core/skbuff.c                             |   10 +
 net/dsa/Kconfig                               |    8 +
 net/dsa/Makefile                              |    1 +
 net/dsa/tag_oob.c                             |   80 +
 16 files changed, 2300 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq4019-ess-edma.yaml
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/Makefile
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.c
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.h
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess_ethtool.c
 create mode 100644 include/linux/dsa/oob.h
 create mode 100644 net/dsa/tag_oob.c

-- 
2.37.3

