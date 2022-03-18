Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1974B4DDD79
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbiCRQEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiCRQEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:04:34 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA096277;
        Fri, 18 Mar 2022 09:03:11 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DF8B440014;
        Fri, 18 Mar 2022 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647619389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wD9g/HyfpaihMjtAUh4hRheF6myO2JbJgNrI9rB+wpM=;
        b=niLpGNlg/f7Eb9yWFuuV4URLO5ZVaT47aeZycwYZhe0Lcti8C0jBnboCDyt7W0ER1wlmcL
        0sqXEsgx8e0aNVz2tVzZrSrIXkOCghV0IG7jd1Zln/K6F+GTt+2q732tJaHJzU8OHOk5gL
        BwPFmfG9ypg25wNhRzipwPo/JtfWDwCnaCfEsI/Ew8i10K9YXibQ87zgriYFgUR36cAXUI
        am+VmIzU4nF7tmQwWCSBlPMHB81ihV3Gl78qIMeWVAUS9PL86Syd95Q4gnet+iy6Mzsbu2
        Zhc8gTb6qpvsAl5Sr7JkJtxiZTuGvRKg+cjQwIUC4U5PKTMoIZnHPGk67fTwqw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "'Rafael J . Wysocki '" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [PATCH 0/6] introduce fwnode in the I2C subsystem
Date:   Fri, 18 Mar 2022 17:00:46 +0100
Message-Id: <20220318160059.328208-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to allow the I2C subsystem to be usable with fwnode, add
some functions to retrieve an i2c_adapter from a fwnode and use
these functions in both i2c mux and sfp. ACPI and device-tree are
handled to allow these modifications to work with both descriptions.

This series is a subset of the one that was first submitted as a larger
series to add swnode support [1]. In this one, it will be focused on
fwnode support only since it seems to have reach a consensus that
adding fwnode to subsystems makes sense.

[1] https://lore.kernel.org/netdev/YhPSkz8+BIcdb72R@smile.fi.intel.com/T/

Clément Léger (6):
  property: add fwnode_property_read_string_index()
  i2c: fwnode: add fwnode_find_i2c_adapter_by_node()
  i2c: of: use fwnode_get_i2c_adapter_by_node()
  i2c: mux: pinctrl: remove CONFIG_OF dependency and use fwnode API
  i2c: mux: add support for fwnode
  net: sfp: add support for fwnode

 drivers/base/property.c             | 48 +++++++++++++++++++++++++++++
 drivers/i2c/Makefile                |  1 +
 drivers/i2c/i2c-core-fwnode.c       | 41 ++++++++++++++++++++++++
 drivers/i2c/i2c-core-of.c           | 30 ------------------
 drivers/i2c/i2c-mux.c               | 39 +++++++++++------------
 drivers/i2c/muxes/Kconfig           |  1 -
 drivers/i2c/muxes/i2c-mux-pinctrl.c | 21 +++++++------
 drivers/net/phy/sfp.c               | 46 +++++++++------------------
 include/linux/i2c.h                 |  7 ++++-
 include/linux/property.h            |  3 ++
 10 files changed, 142 insertions(+), 95 deletions(-)
 create mode 100644 drivers/i2c/i2c-core-fwnode.c

-- 
2.34.1

