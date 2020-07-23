Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B65B22B57B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgGWSNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgGWSNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:13:22 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EEDC0619DC;
        Thu, 23 Jul 2020 11:13:22 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 465F414095F;
        Thu, 23 Jul 2020 20:13:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595528000; bh=rtASGdLvDrbQsydf5qpS4cE/gpinx1PykETCA3yanMQ=;
        h=From:To:Date;
        b=iYT0D/NVq7H6fwgB5MlLkOyEyYxArNwUA0vNhiH0kZqx4eQE2MYQ5rsd+3VjFBh0K
         bhMVUfLQc2pYeay95fEXN0aAaT1PXP/59jTKsnW5oas2KpdrAQ492XiM0V3DD+k1mE
         /D5+Y2VLotUlC4IZ2iXn9HEAzZa2XF49dDPMENng=
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
Subject: [PATCH RFC leds + net-next v2 0/1] Add support for LEDs on Marvell PHYs
Date:   Thu, 23 Jul 2020 20:13:18 +0200
Message-Id: <20200723181319.15988-1-marek.behun@nic.cz>
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

this is v2 of my RFC adding support for LEDs connected to Marvell PHYs.

The LED subsystem patches are not contained:
- the patch adding support for LED private triggers is already accepted
  in Pavel Machek's for-next tree.
  If you want to try this patch on top of net-next, please also apply
  https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-leds.git/commit/?h=for-next&id=93690cdf3060c61dfce813121d0bfc055e7fa30d
- the other led-trigger patch is not needed in this version of the RFC

The main difference from v1 is that only one trigger, named
"hw-control", is added to the /sys/class/leds/<LED>/trigger file.

When this trigger is activated, another file called "hw_control" is
created in the /sys/class/leds/<LED>/ directory. This file lists
available HW control modes for this LED in the same way the trigger
file does for triggers.

Example:

  # cd /sys/class/leds/eth0\:green\:link/
  # cat trigger
  [none] hw-control timer oneshot heartbeat ...
  # echo hw-control >trigger
  # cat trigger
  none [hw-control] timer oneshot heartbeat ...
  # cat hw_control
  link/nolink link/act/nolink 1000/100/10/nolink act/noact
  blink-act/noact transmit/notransmit copperlink/else [1000/else]
  force-hi-z force-blink
  # echo 1000/100/10/nolink >hw_control
  # cat hw_control
  link/nolink link/act/nolink [1000/100/10/nolink] act/noact
  blink-act/noact transmit/notransmit copperlink/else 1000/else
  force-hi-z force-blink

The benefit here is that only one trigger is registered via LED API.
I guess there are other PHY drivers which too support HW controlled
blinking modes. So of this way of controlling PHY LED HW controlled
modes is accepted, the code creating the hw-control trigger and
hw_control file should be made into library code so that it can be
reused.

What do you think?

Marek

Marek Behún (1):
  net: phy: marvell: add support for PHY LEDs via LED class

 drivers/net/phy/Kconfig   |   7 +
 drivers/net/phy/marvell.c | 423 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 429 insertions(+), 1 deletion(-)

-- 
2.26.2

