Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC6A305779
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbhA0JzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:55:11 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55015 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235319AbhA0Jw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:52:56 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l4h22-00083a-PD
        for netdev@vger.kernel.org; Wed, 27 Jan 2021 10:22:34 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3DDC85CF0E7
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:22:32 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7BF565CF0CC;
        Wed, 27 Jan 2021 09:22:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4fdf02df;
        Wed, 27 Jan 2021 09:22:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-01-27
Date:   Wed, 27 Jan 2021 10:22:15 +0100
Message-Id: <20210127092227.2775573-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 12 patches for net-next/master.

The first two patches are by me and fix typos on the CAN gw protocol and the
flexcan driver.

The next patch is by Vincent Mailhol and targets the CAN driver infrastructure,
it exports the function that converts the CAN state into a human readable
string.

A patch by me, which target the CAN driver infrastructure, too, makes the
calculation in can_fd_len2dlc() more readable.

A patch by Tom Rix fixes a checkpatch warning in the mcba_usb driver.

The next seven patches target the mcp251xfd driver. Su Yanjun's patch replaces
several hardcoded assumptions when calling regmap, by using
regmap_get_val_bytes(). The remaining patches are by me. First an open coded
check is replaced by an existing helper function, then in the TX path the
padding for CAN-FD frames is cleaned up. The next two patches clean up the RTR
frame handling in the RX and TX path. Then support for len8_dlc is added. The
last patch adds BQL support.

regards,
Marc

---

The following changes since commit 6626a0266566c5aea16178c5e6cd7fc4db3f2f56:

  Merge branch 'net-usbnet-convert-to-new-tasklet-api' (2021-01-26 18:04:28 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.12-20210127

for you to fetch changes up to 4162e18e949ba520d5116ac0323500355479a00e:

  can: mcp251xfd: add BQL support (2021-01-27 10:01:47 +0100)

----------------------------------------------------------------
linux-can-next-for-5.12-20210127

----------------------------------------------------------------
Marc Kleine-Budde (9):
      can: gw: fix typo
      can: flexcan: fix typos
      can: length: can_fd_len2dlc(): make legnth calculation readable again
      can: mcp251xfd: mcp251xfd_start_xmit(): use mcp251xfd_get_tx_free() to check TX is is full
      can: mcp251xfd: mcp251xfd_tx_obj_from_skb(): clean up padding of CAN-FD frames
      can: mcp251xfd: mcp251xfd_hw_rx_obj_to_skb(): don't copy data for RTR CAN frames in RX-path
      can: mcp251xfd: mcp251xfd_tx_obj_from_skb(): don't copy data for RTR CAN frames in TX-path
      can: mcp251xfd: add len8_dlc support
      can: mcp251xfd: add BQL support

Su Yanjun (1):
      can: mcp251xfd: replace sizeof(u32) with val_bytes in regmap

Tom Rix (1):
      can: mcba_usb: remove h from printk format specifier

Vincent Mailhol (1):
      can: dev: export can_get_state_str() function

 drivers/net/can/dev/dev.c                      |  3 +-
 drivers/net/can/dev/length.c                   |  7 ++-
 drivers/net/can/flexcan.c                      |  4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 79 ++++++++++++++++++--------
 drivers/net/can/usb/mcba_usb.c                 |  6 +-
 include/linux/can/dev.h                        |  1 +
 net/can/gw.c                                   |  2 +-
 7 files changed, 70 insertions(+), 32 deletions(-)


