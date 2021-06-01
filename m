Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9011B396A6F
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhFAAxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231714AbhFAAxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E606124B;
        Tue,  1 Jun 2021 00:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508720;
        bh=y8mZX9crz1d7qe1PfUZcRMNKRjOU8vw8R55fjN2gsWM=;
        h=From:To:Cc:Subject:Date:From;
        b=lEWF+e5VZSgE03d6tuj9x/xG14ilY9zx5GWZZPDwu+lGjqe73v3yuzcURqlrSwviX
         2Yv1p3VHWDDxGkNkF0AAySEJmwiqcbJCxkPEwa2OAcicWaEMUm2agz9SIoIXQx6HJO
         Xj4Q0lCm/Ef7WUCR2vCuz6gGXv91NBaPRc8m6h2gVBJ/NvNLXUJ5ixlByE1EiJ7FUc
         YVulp4Da77RfO1K772F03yQVk7eyoO0FNhFerFcUNShBxWwwu51AJqxpum4zs9D6eg
         BBLKLePlQJiIy+AA3iLbk/O9Ym6Se5XsTGimtywUES4l7rd2YO7zIyDBvuueZ3Tvtf
         8SsA4a1zZ0alw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     linux-leds@vger.kernel.org
Cc:     netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH leds v2 00/10] Add support for offloading netdev trigger to HW + example implementation for Turris Omnia
Date:   Tue,  1 Jun 2021 02:51:45 +0200
Message-Id: <20210601005155.27997-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is v2 of series adding support for offloading LED triggers to HW.
The netdev trigger is the first user and leds-turris-omnia is the first
example implementation.

A video comparing SW (left LED) vs HW (right LED) netdev trigger on
Omnia
  https://secure.nic.cz/files/mbehun/omnia-wan-netdev-trig-offload.mp4

Changes since v1:
- changed typo in doc
- the netdev trigger data structure now lives in
  include/linux/ledtrig-netdev.h instead of ledtrig.h, as suggested by
  Andrew. Also the structure is always defined, no guard against
  CONFIG_LEDS_TRIGGER_NETDEV
- we do not export netdev_led_trigger variable. The trigger_offload()
  method can look at led_cdev->trigger->name to see which trigger it
  should try to offload, i.e. compare the string to "netdev"
- netdev trigger is being offloaded only if link is up, and at least one
  of the rx, tx parameters are set. No need to offload otherwise
- a patch is added that moves setting flag LED_UNREGISTERING in
  led_classdev_unregister() before unsetting trigger. This makes it
  possible for the trigger_offload() method to determine whether the
  offloading is being disabled because the LED is being unregistered.
  The driver may put the LED into HW triggering mode in this case, to
  achieve behaviour as was before the driver was loaded
- an example implementation for offloading the netdev trigger for the
  WAN LED on Turris Omnia is added. LAN LEDs are not yet supported

Changes since RFC:
- split the patch adding HW offloading support to netdev trigger into
  several separate patches (suggested by Pavel):
  1. move trigger data structure to include/linux/ledtrig.h
  2. support HW offloading
  3. change spinlock to mutex
- fixed bug where the .offloaded variable was not set to false when
  offloading was disabled (suggested by Pavel)
- removed the code saving one call to set_baseline_state() on the
  NETDEV_CHANGE event. It is not needed, the trigger_offload() method
  can handle this situation on its own (suggested by Pavel)
- documentation now explicitly says that when offloading is being
  disabled, the function must return 0 (no error) (suggested by Pavel)

Marek Behún (10):
  leds: trigger: netdev: don't explicitly zero kzalloced data
  leds: trigger: add API for HW offloading of triggers
  leds: trigger: netdev: move trigger data structure to global include
    dir
  leds: trigger: netdev: support HW offloading
  leds: trigger: netdev: change spinlock to mutex
  leds: core: inform trigger that it's deactivation is due to LED
    removal
  leds: turris-omnia: refactor sw mode setting code into separate
    function
  leds: turris-omnia: refactor brightness setting function
  leds: turris-omnia: initialize each multicolor LED to white color
  leds: turris-omnia: support offloading netdev trigger for WAN LED

 Documentation/leds/leds-class.rst     |  22 ++
 drivers/leds/Kconfig                  |   3 +
 drivers/leds/led-class.c              |   4 +-
 drivers/leds/led-triggers.c           |   1 +
 drivers/leds/leds-turris-omnia.c      | 284 ++++++++++++++++++++++++--
 drivers/leds/trigger/ledtrig-netdev.c |  56 ++---
 include/linux/leds.h                  |  29 +++
 include/linux/ledtrig-netdev.h        |  34 +++
 8 files changed, 377 insertions(+), 56 deletions(-)
 create mode 100644 include/linux/ledtrig-netdev.h

-- 
2.26.3

