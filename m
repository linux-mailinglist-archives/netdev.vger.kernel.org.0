Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F072228D7
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgGPRRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbgGPRRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 13:17:33 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5846BC061755;
        Thu, 16 Jul 2020 10:17:33 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id E1900140A85;
        Thu, 16 Jul 2020 19:17:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1594919851; bh=XOAfNxH04Dfv8nWGDodRl3W9aRo3avZUgZgHgn5hpn4=;
        h=From:To:Date;
        b=kUvNiNFvr235PstZgBkhO+fqGWxiiaUdRMn8KfQa9MBotIBOF1KG4SkdDmJV7Xjqq
         HySlUuwxNcos160kngDFQyR17PehN9c1BI+5pLbwFNt+EpxA6Jn58IvUIdwexb1X17
         PONsZn+A/BZ4Tk+f5C5cxDFWOC2watM+/tMrR13I=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     linux-leds@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC leds + net-next 0/3] Add support for LEDs on Marvell PHYs
Date:   Thu, 16 Jul 2020 19:17:27 +0200
Message-Id: <20200716171730.13227-1-marek.behun@nic.cz>
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

Hello,

this RFC series should apply on both net-next/master and Pavel's
linux-leds/for-master tree.

This adds support for LED's connected to some Marvell PHYs.

LEDs are specified via device-tree. Example:

ethernet-phy@1 {
	reg = <1>;

	leds {
		led@0 {
			reg = <0>;
			color = <LED_COLOR_ID_GREEN>;
			function = LED_FUNCTION_LINK;
			linux,default-trigger = "hw:1000/100/10/nolink";
		};

		led@1 {
			reg = <1>;
			color = <LED_COLOR_ID_YELLOW>;
			function = LED_FUNCTION_ACTIVITY;
			linux,default-trigger = "hw:act/noact";
		};
	};
};

Since Marvell PHYs can control the LEDs themselves in various modes,
we need to be able to switch between them or disable them.

This is achieved by extending the LED trigger API with LED-private triggers.
The proposal for this is based on work by Ondrej and Pavel, but after writing
this support for Marvell PHYs I am not very happy how this turned out:
- this LED-private triggers API works by registering triggers with specific
  private trigger type. If this trigger type is defined for a trigger, only
  those LEDs will be able to set this trigger which also have this trigger type.
  (Both structs led_classdev and led_trigger have member trigger_type)
- on Marvell PHYs each LED can have up to 8 different triggers
- currently the driver supports up to 6 LEDs, since at least 88E1340 support
  6 LEDs
- almost every LED supports some mode which is not supported by at least one
  other LED
- this leads to the following dillema:
  1. either we support one trigger type across the driver, but then the
     /sys/class/leds/<LED>/trigger file will also list HW triggers not
     supported by this specific LED,
  2. or we add 6 trigger types, each different one LED, and register up to
     8 HW triggers for each trigger type, which results in up to 48 triggers
     per this driver.
  In this proposal alternative 1 is taken and when unsupported HW trigger
  is requested by writing to /sys/class/leds/<LED>/trigger file, the write
  system call returns -EOPNOTSUPP.
- therefore I think that this is not the correct way how to implement
  LED-private triggers, and instead an approach as desribed in [1].
  What do you people think?

Marek

Marek Behún (3):
  leds: trigger: add support for LED-private device triggers
  leds: trigger: return error value if .activate() failed
  net: phy: marvell: add support for PHY LEDs via LED class

 drivers/leds/led-triggers.c |  32 ++--
 drivers/net/phy/Kconfig     |   7 +
 drivers/net/phy/marvell.c   | 307 +++++++++++++++++++++++++++++++++++-
 include/linux/leds.h        |  10 ++
 4 files changed, 346 insertions(+), 10 deletions(-)

-- 
2.26.2

