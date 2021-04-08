Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54047358EE5
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhDHVBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:01:23 -0400
Received: from polaris.svanheule.net ([84.16.241.116]:60012 "EHLO
        polaris.svanheule.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbhDHVBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 17:01:19 -0400
Received: from terra.local.svanheule.net (unknown [IPv6:2a02:a03f:eaff:9f01:6fea:16c6:2e86:c69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id D173F1ECD38;
        Thu,  8 Apr 2021 22:52:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1617915165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sG03pRQrsSv16JasG5fXBdpoORWxuYvG5/eb22d+2KY=;
        b=p66tD7p82IwvsJh81iGfIwzdgVgsz0HbrvfkXoojdsFWA/nxpYSTSsOaJ6xs1iRQt8z52v
        00AKQFOkaOwxZNKgMon+nxrCvpcIpERTUG1N/OhGpcc3yY7DdcOJjghOmMQe+cTzBfCe5L
        N/CNnVHwpl1wWpzeXFZxOD4masedh5KryAqXO6h1KhbSpHPFjVSCHGzzAPBoWjssjBNHoO
        CwjeZ1JgEBC5G9/Yxq7xPHgsyljVPirjKyDFNINsaRPKblN8J9oSPWKzF3FhiTtIj1+NGG
        /N61FFXRbyvCXjg9i7U7JziZEWib7HYxPvuGLDnKLsI8qfaNKhhLrKufhFxCeA==
From:   Sander Vanheule <sander@svanheule.net>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     bert@biot.com, Sander Vanheule <sander@svanheule.net>
Subject: [RFC PATCH 0/2] MIIM regmap and RTL8231 GPIO expander support
Date:   Thu,  8 Apr 2021 22:52:33 +0200
Message-Id: <cover.1617914861.git.sander@svanheule.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8231 GPIO and LED expander can be configured for use as an MIIM or I2C
bus device. To provide uniform data access between these two modes, the regmap
interface is used. Since no regmap interface exists for MIIM busses, a basic
implementation is provided.

Currently outstanding questions:
- The REGMAP_MIIM symbol should depend on MDIO_DEVICE (or a better suited,
  related symbol), but this results in circular Kconfig dependencies:
    drivers/of/Kconfig:69:error: recursive dependency detected!
    drivers/of/Kconfig:69:	symbol OF_IRQ depends on IRQ_DOMAIN
    kernel/irq/Kconfig:59:	symbol IRQ_DOMAIN is selected by REGMAP
    drivers/base/regmap/Kconfig:7:	symbol REGMAP default is visible depending on REGMAP_MIIM
    drivers/base/regmap/Kconfig:39:	symbol REGMAP_MIIM depends on MDIO_DEVICE
    drivers/net/mdio/Kconfig:6:	symbol MDIO_DEVICE is selected by PHYLIB
    drivers/net/phy/Kconfig:16:	symbol PHYLIB is selected by ARC_EMAC_CORE
    drivers/net/ethernet/arc/Kconfig:19:	symbol ARC_EMAC_CORE is selected by ARC_EMAC
    drivers/net/ethernet/arc/Kconfig:25:	symbol ARC_EMAC depends on OF_IRQ
  Suggestions on how to resolve this are welcome.

- Providing no compatible for an MDIO child node is considered to be equivalent
  to a c22 ethernet phy, so one must be provided. However, this node is then
  not automatically probed. Is it okay to provide a binding without a driver?
  If some code is required, where should this be put?
  Current devicetree structure:
    mdio-bus {
        compatible = "vendor,mdio";
        ...

        expander0: expander@0 {
            /*
             * Provide compatible for working registration of mdio device.
             * Device probing happens in gpio1 node.
             */
            compatible = "realtek,rtl8231-expander";
            reg = <0>;
        };

    };
    gpio1 : ext_gpio {
        compatible = "realtek,rtl8231-mdio";
        gpio-controller;
        ...
    };

- MFD driver:
  The RTL8231 is not just a GPIO expander, but also a pin controller and LED
  matrix controller. Regmap initialisation could probably be moved to a parent
  MFD, with gpio, led, and pinctrl cells. Is this a hard requirement if only a
  GPIO controller is provided?

Sander Vanheule (2):
  regmap: add miim bus support
  gpio: Add Realtek RTL8231 support

 drivers/base/regmap/Kconfig       |   6 +-
 drivers/base/regmap/Makefile      |   1 +
 drivers/base/regmap/regmap-miim.c |  58 +++++
 drivers/gpio/Kconfig              |   9 +
 drivers/gpio/Makefile             |   1 +
 drivers/gpio/gpio-rtl8231.c       | 404 ++++++++++++++++++++++++++++++
 include/linux/regmap.h            |  36 +++
 7 files changed, 514 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/regmap/regmap-miim.c
 create mode 100644 drivers/gpio/gpio-rtl8231.c

-- 
2.30.2

