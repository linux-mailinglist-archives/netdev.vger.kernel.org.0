Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44A022CB51
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGXQqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbgGXQqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:46:06 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8E4C0619E4;
        Fri, 24 Jul 2020 09:46:06 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 0E8FB140801;
        Fri, 24 Jul 2020 18:46:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595609164; bh=uVEK4+lNEwNHSkbt4FwgcwamVpjAjW9xrSCBYvsp+fU=;
        h=From:To:Date;
        b=ODIqmaFrBnepS5Ewc5sPX8LbJbZF9jV0HzWrF6sj74qVeThg0sfnxINPFQX4IcoMd
         wA9vybKY8uvLq/lfdMVaoyPsEPXTebXNnnLF0DfFdihRSnNDfN0rsizFHzPJ9L4LZi
         7g8MmCnLPQ5I/KzGmdUT8IUmHnN9cZ/IFl8PySnk=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC leds + net-next v3 0/2] Add support for LEDs on Marvell PHYs
Date:   Fri, 24 Jul 2020 18:46:01 +0200
Message-Id: <20200724164603.29148-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this is v3 of my RFC adding support for LEDs connected to Marvell PHYs.

Please note that if you want to test this, you still need to first apply
the patch adding the LED private triggers support from Pavel's tree.
https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-leds.git/commit/?h=for-next&id=93690cdf3060c61dfce813121d0bfc055e7fa30d

Changes since v2:
- to share code with other drivers which may want to also offer PHY HW
  control of LEDs some of the code was refactored and now resides in
  phy_hw_led_mode.c. This code is compiled in when config option
  LED_TRIGGER_PHY_HW is enabled. Drivers wanting to offer PHY HW control
  of LEDs should depend on this option.
- the "hw-control" trigger is renamed to "phydev-hw-mode" and is
  registered by the code in phy_hw_led_mode.c
- the "hw_control" sysfs file is renamed to "hw_mode"
- struct phy_driver is extended by three methods to support PHY HW LED
  control
- I renamed the various HW control modes offeret by Marvell PHYs to
  conform to other Linux mode names, for example the "1000/100/10/else"
  mode was renamed to "1Gbps/100Mbps/10Mbps", or "recv/else" was renamed
  to "rx" (this is the name of the mode in netdev trigger).

Marek

Marek Behún (2):
  net: phy: add API for LEDs controlled by PHY HW
  net: phy: marvell: add support for PHY LEDs via LED class

 drivers/net/phy/Kconfig           |  10 +
 drivers/net/phy/Makefile          |   1 +
 drivers/net/phy/marvell.c         | 364 ++++++++++++++++++++++++++++++
 drivers/net/phy/phy_hw_led_mode.c |  96 ++++++++
 include/linux/phy.h               |  15 ++
 5 files changed, 486 insertions(+)
 create mode 100644 drivers/net/phy/phy_hw_led_mode.c

-- 
2.26.2

