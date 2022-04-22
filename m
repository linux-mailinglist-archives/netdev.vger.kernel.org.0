Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB7550BFBD
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiDVSMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237276AbiDVSGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 14:06:47 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3855DE49EE;
        Fri, 22 Apr 2022 11:03:48 -0700 (PDT)
Received: from relay2-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::222])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 9BFA3C1EAB;
        Fri, 22 Apr 2022 18:03:30 +0000 (UTC)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9D3B140004;
        Fri, 22 Apr 2022 18:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650650591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DzFYMdqiUbF9fkv7pZJyHpakFyvM1o8fMoCSIs24IhI=;
        b=RGvD/NEBQqLT/SR04JDPMP/MpuR40CZoxYwPDS/m1/julhFNlmXsZMWK/wwoXBpMnUXz98
        iwmD98uPcM1m2u+EvaRCGz7mIbu+3ZfhF0yLWjaGENudt90TaWLhSevlOFduTUlO8UJqva
        ASh13xDJ4Ood7hCa/QYKKo20gl9VEKa4+z6auIKXxhkGYVrmYQIHomzae8yL7IEm8FENOu
        DQ3x0KWanLSz6v6eEv7NHStsdHifXkufpIQxK1oBJfXwkTus0zVjUms7z2BAcd2Wt9jIV3
        gE56JdI5XEFjbgMGT8OmPY4QpUSOnQ5Vif9xuyvRbCa+lXMTTj5hnpPNV4AM7w==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
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
Subject: [PATCH net-next 0/5] net: ipqess: introduce Qualcomm IPQESS driver
Date:   Fri, 22 Apr 2022 20:03:00 +0200
Message-Id: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

This series introduces a new driver, for the Qualcomm IPQESS Ethernet
Controller, found on the IPQ4019.

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

So, this series also includes a new DSA tagging protocol, that sets the
DSA port index into skb->shinfo, so that the MAC driver can use it to
build the descriptor. This is definitely unusual, so I'l very openned to
suggestions, comments and reviews on the tagging side of this series.

Thanks to the Sartura folks who worked on a base version of this driver,
and provided test hardware.

Best regards,

Maxime Chevallier

Maxime Chevallier (5):
  net: ipqess: introduce the Qualcomm IPQESS driver
  net: dsa: add out-of-band tagging protocol
  net: ipqess: Add out-of-band DSA tagging support
  net: dt-bindings: Introduce the Qualcomm IPQESS Ethernet controller
  ARM: dts: qcom: ipq4019: Add description for the IPQESS Ethernet
    controller

 .../devicetree/bindings/net/qcom,ipqess.yaml  |   94 ++
 MAINTAINERS                                   |    6 +
 arch/arm/boot/dts/qcom-ipq4019.dtsi           |   42 +
 drivers/net/ethernet/qualcomm/Kconfig         |   11 +
 drivers/net/ethernet/qualcomm/Makefile        |    2 +
 drivers/net/ethernet/qualcomm/ipqess/Makefile |    8 +
 drivers/net/ethernet/qualcomm/ipqess/ipqess.c | 1258 +++++++++++++++++
 drivers/net/ethernet/qualcomm/ipqess/ipqess.h |  515 +++++++
 .../ethernet/qualcomm/ipqess/ipqess_ethtool.c |  168 +++
 include/linux/skbuff.h                        |    7 +
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    7 +
 net/dsa/Makefile                              |    1 +
 net/dsa/tag_oob.c                             |   45 +
 14 files changed, 2166 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipqess.yaml
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/Makefile
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.c
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.h
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess_ethtool.c
 create mode 100644 net/dsa/tag_oob.c

-- 
2.35.1

