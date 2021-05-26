Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F3E391E95
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbhEZSDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233378AbhEZSDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 14:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FC15611C2;
        Wed, 26 May 2021 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622052091;
        bh=spI6wnpdljd5in/X7+N2RYCH//J+BMXhffbP7RA4Ijs=;
        h=From:To:Cc:Subject:Date:From;
        b=PVuXLDjra+WjF1t2uvohTK74BwG6t7WjTWT8mMXEDyDUIy3BH0eztPdRXn+/JFSti
         Vz0CzUdzbNLuEzlwf8Fem0ANTod8ybtAz8H7iRDnBHCBVr/aTtLrERfEMeoRN8lh4s
         Ettqa4bQOeU35MvjnyZlgB/RmuLC2G7spj20xQzZA/bGS/fwKTg4bvefypMPsOfbm9
         xPlwXY4cM5I2EFHeBJZ2rdc7/Y47lE13ASpRaQcKfaz5CJK3U7d8B0KQPOokodK/p4
         oi5Pfr5Ejq553HfxFQhi7o2w4nWOw8TaGZB1R+FFyOaSkCaS+uoRXzSv8cFJpQxmpC
         exEl4NE9stwZw==
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
Subject: [PATCH leds v1 0/5] Add support for offloading netdev trigger to HW
Date:   Wed, 26 May 2021 20:00:15 +0200
Message-Id: <20210526180020.13557-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am sending the first non-RFC version of the series adding support
for offloading LED triggers to HW, with the netdev trigger being the
first user.

I have addressed the issues with the RFC version from October.

This version only implements the offloading API and adds support for
offloading to the netdev trigger. In the RFC I also added one user of
this API (Marvell ethernet PHY driver). I plan to continue the work on
those patches once the offloading API is finally merged.

Also, there is now other possible user for this API: leds-nuc driver
by Mauro.

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

Marek Behún (5):
  leds: trigger: netdev: don't explicitly zero kzalloced data
  leds: trigger: add API for HW offloading of triggers
  leds: trigger: netdev: move trigger data structure to global include
    dir
  leds: trigger: netdev: support HW offloading
  leds: trigger: netdev: change spinlock to mutex

 Documentation/leds/leds-class.rst     | 22 +++++++++++++
 drivers/leds/led-triggers.c           |  1 +
 drivers/leds/trigger/ledtrig-netdev.c | 47 ++++++++-------------------
 include/linux/leds.h                  | 29 +++++++++++++++++
 include/linux/ledtrig.h               | 40 +++++++++++++++++++++++
 5 files changed, 105 insertions(+), 34 deletions(-)
 create mode 100644 include/linux/ledtrig.h

-- 
2.26.3

