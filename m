Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2AF4DDD93
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbiCRQFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbiCRQFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:05:06 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB72E43A6;
        Fri, 18 Mar 2022 09:03:22 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CEBE14001F;
        Fri, 18 Mar 2022 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647619401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wD9g/HyfpaihMjtAUh4hRheF6myO2JbJgNrI9rB+wpM=;
        b=L0Y/tZtk7DLghzqVAQiSQahZGme4qAf5hNmEzNo2cEBQR29IfIEonYV0hKqsyu0R+aXz0E
        iq+GEPXNc7XmLfOlk2oF52AoDvnvtZOarWn2XoS4DEnAXiiAWoHgVoPYcTkOA8Kjq7ztFy
        6OebfisSCUOZWzjwULVrymk8D69OtYm01Vybu89AJoZ+JDl+jL22pC+tpZmFDSaVSZqMky
        evqQOuq7VortooI60sg0NIKxoZU6F7uOKQ5MBoF8maKm1vNh0IziBGYadL6QHNh3CsJuS5
        1q6ZKslpIFzz+8xUksTyJ7wHPXhaOMVs2WiyVTXiem8tJonRRV+yttFSdCVtcA==
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
Date:   Fri, 18 Mar 2022 17:00:53 +0100
Message-Id: <20220318160059.328208-8-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220318160059.328208-1-clement.leger@bootlin.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

