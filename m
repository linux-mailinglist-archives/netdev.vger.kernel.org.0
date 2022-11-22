Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09A9633F73
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiKVOxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbiKVOxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:53:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A24A167EB
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:52:53 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oxUdc-0006Ld-4v; Tue, 22 Nov 2022 15:52:40 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1oxUdX-005s7M-HJ; Tue, 22 Nov 2022 15:52:36 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1oxUdX-00H3kU-I2; Tue, 22 Nov 2022 15:52:35 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v3 00/11] RTW88: Add support for USB variants
Date:   Tue, 22 Nov 2022 15:52:15 +0100
Message-Id: <20221122145226.4065843-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third round of adding support for the USB variants to the
RTW88 driver. There are a few changes to the last version which make it
worth looking at this version.

First of all RTL8723du and RTL8821cu are tested working now. The issue
here was that the txdesc checksum calculation was wrong. I found the
correct calculation in various downstream drivers found on github.

The second big issue was that TX packet aggregation was wrong. When
aggregating packets each packet start has to be aligned to eight bytes.
The necessary alignment was added to the total URB length before
checking if there is another packet to aggregate, so the URB length
included that padding after the last packet, which is wrong.  Fixing
this makes the driver work much more reliably.

I added all people to Cc: who showed interest in this driver and I want
to welcome you for testing and reviewing.

Sascha


Sascha Hauer (11):
  rtw88: print firmware type in info message
  rtw88: Call rtw_fw_beacon_filter_config() with rtwdev->mutex held
  rtw88: Drop rf_lock
  rtw88: Drop h2c.lock
  rtw88: Drop coex mutex
  rtw88: iterate over vif/sta list non-atomically
  rtw88: Add common USB chip support
  rtw88: Add rtw8821cu chipset support
  rtw88: Add rtw8822bu chipset support
  rtw88: Add rtw8822cu chipset support
  rtw88: Add rtw8723du chipset support

 drivers/net/wireless/realtek/rtw88/Kconfig    |  47 +
 drivers/net/wireless/realtek/rtw88/Makefile   |  14 +
 drivers/net/wireless/realtek/rtw88/coex.c     |   3 +-
 drivers/net/wireless/realtek/rtw88/debug.c    |  15 +
 drivers/net/wireless/realtek/rtw88/fw.c       |  13 +-
 drivers/net/wireless/realtek/rtw88/hci.h      |   9 +-
 drivers/net/wireless/realtek/rtw88/mac.c      |   3 +
 drivers/net/wireless/realtek/rtw88/mac80211.c |   2 +-
 drivers/net/wireless/realtek/rtw88/main.c     |  12 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  12 +-
 drivers/net/wireless/realtek/rtw88/phy.c      |   6 +-
 drivers/net/wireless/realtek/rtw88/ps.c       |   2 +-
 drivers/net/wireless/realtek/rtw88/reg.h      |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c |  28 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.h |  13 +-
 .../net/wireless/realtek/rtw88/rtw8723du.c    |  36 +
 .../net/wireless/realtek/rtw88/rtw8723du.h    |  10 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |  18 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.h |  21 +
 .../net/wireless/realtek/rtw88/rtw8821cu.c    |  50 +
 .../net/wireless/realtek/rtw88/rtw8821cu.h    |  10 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |  19 +
 .../net/wireless/realtek/rtw88/rtw8822bu.c    |  90 ++
 .../net/wireless/realtek/rtw88/rtw8822bu.h    |  10 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |  24 +
 .../net/wireless/realtek/rtw88/rtw8822cu.c    |  44 +
 .../net/wireless/realtek/rtw88/rtw8822cu.h    |  10 +
 drivers/net/wireless/realtek/rtw88/tx.h       |  31 +
 drivers/net/wireless/realtek/rtw88/usb.c      | 918 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/usb.h      | 107 ++
 drivers/net/wireless/realtek/rtw88/util.c     | 103 ++
 drivers/net/wireless/realtek/rtw88/util.h     |  12 +-
 32 files changed, 1655 insertions(+), 38 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723du.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723du.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cu.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bu.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h

-- 
2.30.2

