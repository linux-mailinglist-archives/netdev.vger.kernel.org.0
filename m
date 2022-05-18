Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1B252B4F9
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbiERIXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiERIXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:23:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF221078A8
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 01:23:33 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrExn-0004R1-0u; Wed, 18 May 2022 10:23:23 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nrExm-0032pC-NS; Wed, 18 May 2022 10:23:21 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nrExj-00GXTV-RY; Wed, 18 May 2022 10:23:19 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 00/10] RTW88: Add support for USB variants
Date:   Wed, 18 May 2022 10:23:08 +0200
Message-Id: <20220518082318.3898514-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the USB chip variants to the RTW88 driver.

The first patches in the series consolidate the locking in the driver.
The rtw88 driver protects the register accesses with spinlocks which
naturally don't cope well with the asynchronous nature of USB. It turned
out though that in most cases where additional locks are taken the
global driver mutex is acquired anyway which makes them mostly
unnecessary. The exception is the debugfs code which depends on the
additional locks. This is changed to acquire the global driver mutex as
well, so the additional locks can be removed.  I verified the callstacks
leading to the different locks with a cscope based shell script, so I am
pretty confident that I haven't missed any pathes. Nevertheless please
have a careful look, please.

Another problem to address is that the driver uses
ieee80211_iterate_stations_atomic() and
ieee80211_iterate_active_interfaces_atomic() and does register accesses
in the iterator. This doesn't work with USB, so iteration is done in two
steps now: The ieee80211_iterate_*_atomic() functions are only used to
collect the stations/interfaces on a list which is then iterated over
non-atomically in the second step. The implementation for this is
basically the one suggested by Ping-Ke here:
https://lore.kernel.org/lkml/423f474e15c948eda4db5bc9a50fd391@realtek.com/

The USB driver code itself is based on
https://github.com/ulli-kroll/rtw88-usb.git.  The most significant
change to that code base is likely the TX queue handling.  It seems the
PCI versions of the RTW88 chips have eight differently prioritized TX
queues whereas the USB variants only have one to three queues (one per
bulk endpoint).  The original code base first mapped the TX packets
coming into the driver onto eight TX queues which were then re-mapped
again to the existing endpoints. As the eight TX queues do not
physically exist on the USB variants I changed that to map the incoming
TX packets directly onto the bulk endpoints.

I tested this series on the RTW8822CU only. I don't have access to any
of the other chips supported by the RTW88 driver, so testing feedback
would be greatly appreciated.

This is my first excursion to the Linux wireless world, so please review
carefully :)

Sascha


Sascha Hauer (10):
  rtw88: Call rtw_fw_beacon_filter_config() with rtwdev->mutex held
  rtw88: Drop rf_lock
  rtw88: Drop h2c.lock
  rtw88: Drop coex mutex
  rtw88: Do not access registers while atomic
  rtw88: Add common USB chip support
  rtw88: Add rtw8723du chipset support
  rtw88: Add rtw8821cu chipset support
  rtw88: Add rtw8822bu chipset support
  rtw88: Add rtw8822cu chipset support

 drivers/net/wireless/realtek/rtw88/Kconfig    |   47 +
 drivers/net/wireless/realtek/rtw88/Makefile   |   14 +
 drivers/net/wireless/realtek/rtw88/coex.c     |    3 +-
 drivers/net/wireless/realtek/rtw88/debug.c    |   15 +
 drivers/net/wireless/realtek/rtw88/fw.c       |   13 +-
 drivers/net/wireless/realtek/rtw88/hci.h      |    9 +-
 drivers/net/wireless/realtek/rtw88/mac.c      |    3 +
 drivers/net/wireless/realtek/rtw88/mac80211.c |    2 +-
 drivers/net/wireless/realtek/rtw88/main.c     |    9 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   11 +-
 drivers/net/wireless/realtek/rtw88/phy.c      |    6 +-
 drivers/net/wireless/realtek/rtw88/ps.c       |    2 +-
 drivers/net/wireless/realtek/rtw88/reg.h      |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c |   19 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.h |    1 +
 .../net/wireless/realtek/rtw88/rtw8723du.c    |   40 +
 .../net/wireless/realtek/rtw88/rtw8723du.h    |   13 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |   23 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.h |   21 +
 .../net/wireless/realtek/rtw88/rtw8821cu.c    |   69 ++
 .../net/wireless/realtek/rtw88/rtw8821cu.h    |   15 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |   19 +
 .../net/wireless/realtek/rtw88/rtw8822bu.c    |   62 +
 .../net/wireless/realtek/rtw88/rtw8822bu.h    |   15 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |   24 +
 .../net/wireless/realtek/rtw88/rtw8822cu.c    |   40 +
 .../net/wireless/realtek/rtw88/rtw8822cu.h    |   15 +
 drivers/net/wireless/realtek/rtw88/tx.h       |   31 +
 drivers/net/wireless/realtek/rtw88/usb.c      | 1051 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/usb.h      |  109 ++
 drivers/net/wireless/realtek/rtw88/util.c     |   92 ++
 drivers/net/wireless/realtek/rtw88/util.h     |   12 +-
 32 files changed, 1770 insertions(+), 36 deletions(-)
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

