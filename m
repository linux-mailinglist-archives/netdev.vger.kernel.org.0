Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBFF2B2EFE
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgKNReS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgKNReS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 12:34:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5C0C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 09:34:18 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kdzRI-0000mY-Ne; Sat, 14 Nov 2020 18:34:16 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-11-14
Date:   Sat, 14 Nov 2020 18:33:44 +0100
Message-Id: <20201114173358.2058600-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

here's a pull request for net/master consisting of 15 patches for net/master.

Anant Thazhemadam contributed two patches for the AF_CAN that prevent potential
access of uninitialized member in can_rcv() and canfd_rcv().

The next patch is by Alejandro Concepcion Rodriguez and changes can_restart()
to use the correct function to push a skb into the networking stack from
process context.

Zhang Qilong's patch fixes a memory leak in the error path of the ti_hecc's
probe function.

A patch by me fixes mcba_usb_start_xmit() function in the mcba_usb driver, to
first fill the skb and then pass it to can_put_echo_skb().

Colin Ian King's patch fixes a potential integer overflow on shift in the
peak_usb driver.

The next two patches target the flexcan driver, a patch by me adds the missing
"req_bit" to the stop mode property comment (which was broken during net-next
for v5.10). Zhang Qilong's patch fixes the failure handling of
pm_runtime_get_sync().

The next seven patches target the m_can driver including the tcan4x5x spi
driver glue code. Enric Balletbo i Serra's patch for the tcan4x5x Kconfig fix
the REGMAP_SPI dependency handling. A patch by me for the tcan4x5x driver's
probe() function adds missing error handling to for devm_regmap_init(), and in
tcan4x5x_can_remove() the order of deregistration is fixed. Wu Bo's patch for
the m_can driver fixes the state change handling in
m_can_handle_state_change(). Two patches by Dan Murphy first introduce
m_can_class_free_dev() and then make use of it to fix the freeing of the can
device. A patch by Faiz Abbas add a missing shutdown of the CAN controller in
the m_can_stop() function.

regards,
Marc

---

The following changes since commit ceb736e1d45c253f5e86b185ca9b497cdd43063f:

  ipv6: Fix error path to cancel the meseage (2020-11-13 18:20:00 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.10-20201114

for you to fetch changes up to 9a7e716d475eb29213117d2e501b841050c4b511:

  can: m_can: m_can_stop(): set device to software init mode before closing (2020-11-14 18:21:51 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.10-20201114

----------------------------------------------------------------
Alejandro Concepcion Rodriguez (1):
      can: dev: can_restart(): post buffer from the right context

Anant Thazhemadam (2):
      can: af_can: prevent potential access of uninitialized member in can_rcv()
      can: af_can: prevent potential access of uninitialized member in canfd_rcv()

Colin Ian King (1):
      can: peak_usb: fix potential integer overflow on shift of a int

Dan Murphy (2):
      can: m_can: m_can_class_free_dev(): introduce new function
      can: m_can: Fix freeing of can device from peripherials

Enric Balletbo i Serra (1):
      can: tcan4x5x: replace depends on REGMAP_SPI with depends on SPI

Faiz Abbas (1):
      can: m_can: m_can_stop(): set device to software init mode before closing

Marc Kleine-Budde (4):
      can: mcba_usb: mcba_usb_start_xmit(): first fill skb, then pass to can_put_echo_skb()
      can: flexcan: flexcan_setup_stop_mode(): add missing "req_bit" to stop mode property comment
      can: tcan4x5x: tcan4x5x_can_probe(): add missing error checking for devm_regmap_init()
      can: tcan4x5x: tcan4x5x_can_remove(): fix order of deregistration

Wu Bo (1):
      can: m_can: m_can_handle_state_change(): fix state change

Zhang Qilong (2):
      can: ti_hecc: Fix memleak in ti_hecc_probe
      can: flexcan: fix failure handling of pm_runtime_get_sync()

 drivers/net/can/dev.c                        |  2 +-
 drivers/net/can/flexcan.c                    | 10 +++++---
 drivers/net/can/m_can/Kconfig                |  3 ++-
 drivers/net/can/m_can/m_can.c                | 16 ++++++++----
 drivers/net/can/m_can/m_can.h                |  1 +
 drivers/net/can/m_can/m_can_platform.c       | 23 +++++++++++------
 drivers/net/can/m_can/tcan4x5x.c             | 32 ++++++++++++++++-------
 drivers/net/can/ti_hecc.c                    | 13 ++++++----
 drivers/net/can/usb/mcba_usb.c               |  4 +--
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |  4 +--
 net/can/af_can.c                             | 38 ++++++++++++++++++++--------
 11 files changed, 100 insertions(+), 46 deletions(-)

