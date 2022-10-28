Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B842761164D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 17:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJ1Ptw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 11:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJ1Pti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 11:49:38 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BB6A465;
        Fri, 28 Oct 2022 08:49:29 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EDC3324000D;
        Fri, 28 Oct 2022 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666972168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=f23mXktPnjBIbQnylG+4fHP9q0uzvSm8Mys4clA2Wyg=;
        b=a9wF6nGSZcwRGb55YkTPYESTmNRJxwlOMLvuXH4yrMellZVomcLGHG27XIHgHjQrs9zP9N
        nxEW2FAkPXPrvpQDHm4V/mSNqvDgU8LD5iGUeGLrICrR777uqvxbZ75Eh1CSaJnSKMaxTr
        QDWzF+Y5A44uQyHKONDcW3rirm7HtVH5c/CL5qkHKt4n/FYBZb6ym0rS4Xh8RylJC+c2fH
        oK43OudHEYcx5SQEBXDz2mRDn/M9XnILWqe6wJaiXZJUsfwK7bPsj1dMOUYcgLOhVdEQ0c
        tVBg6I4GN5fjUzXqRhDtUdm4x0qdeWSh1raPJRbRUAp2BQ62i0UqWRToAGH+bg==
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
Subject: [PATCH net-next v6 0/5] net: ipqess: introduce Qualcomm IPQESS driver
Date:   Fri, 28 Oct 2022 17:49:19 +0200
Message-Id: <20221028154924.789116-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_BL_SPAMCOP_NET,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

This is the 6th iteration on the IPQESS driver, that includes a new
DSA tagger to let the MAC convey the tag to the switch through an
out-of-band medium, here using DMA descriptors.

Notables changes on V6 :
 - Cleanup unused helpers and fields in the tagger
 - Cleanup ordering in various files
 - Added more documentation on the tagger
 - Fixed the CHANGEUPPER caching
 - Cleanups in the IPQESS driver

Thanks Andrew, Vlad and Krzysztof for the reviews !

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

 .../bindings/net/qcom,ipq4019-ess-edma.yaml   |   94 ++
 Documentation/networking/dsa/dsa.rst          |   13 +-
 MAINTAINERS                                   |    8 +
 arch/arm/boot/dts/qcom-ipq4019.dtsi           |   44 +
 drivers/net/ethernet/qualcomm/Kconfig         |   12 +
 drivers/net/ethernet/qualcomm/Makefile        |    2 +
 drivers/net/ethernet/qualcomm/ipqess/Makefile |    8 +
 drivers/net/ethernet/qualcomm/ipqess/ipqess.c | 1307 +++++++++++++++++
 drivers/net/ethernet/qualcomm/ipqess/ipqess.h |  522 +++++++
 .../ethernet/qualcomm/ipqess/ipqess_ethtool.c |  164 +++
 include/linux/dsa/oob.h                       |   16 +
 include/linux/skbuff.h                        |    3 +
 include/net/dsa.h                             |    2 +
 net/core/skbuff.c                             |   10 +
 net/dsa/Kconfig                               |    9 +
 net/dsa/Makefile                              |    1 +
 net/dsa/tag_oob.c                             |   48 +
 17 files changed, 2262 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq4019-ess-edma.yaml
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/Makefile
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.c
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.h
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess_ethtool.c
 create mode 100644 include/linux/dsa/oob.h
 create mode 100644 net/dsa/tag_oob.c

-- 
2.37.3

