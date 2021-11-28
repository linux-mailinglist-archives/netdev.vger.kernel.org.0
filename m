Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC65460624
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357357AbhK1MnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:43:02 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:55341 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357356AbhK1MlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 07:41:02 -0500
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id rJR2meSen2lVYrJR7mr5Na; Sun, 28 Nov 2021 13:37:45 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sun, 28 Nov 2021 13:37:45 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 0/5] fix statistics and payload issues for error
Date:   Sun, 28 Nov 2021 21:37:29 +0900
Message-Id: <20211128123734.1049786-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Important: this patch series depends on below patch:
https://lore.kernel.org/linux-can/20211123111654.621610-1-mailhol.vincent@wanadoo.fr/T/#u

There are some common errors which are made when updating the network
statistics or processing the CAN payload:

  1. Incrementing the "normal" stats when generating or sending a CAN
  error message frame. Error message frames are an abstraction of
  Socket CAN and do not exist on the wire. The first patch of this
  series fixes the RX stats for 22 different drivers, the second one
  fixes the TX stasts for the kvaser driver (N.B. only this driver is
  capable of sending error on the bus).

  2. Copying the payload of RTR frames: RTR frames have no payload and
  the data buffer only contains garbage. The DLC/length should not be
  used to do a memory copy. The third patch of this series address
  this issue for 3 different drivers.

  3. Counting the length of the Remote Transmission Frames (RTR). The
  length of an RTR frame is the length of the requested frame not the
  actual payload. In reality the payload of an RTR frame is always 0
  bytes long. The fourth patch of this series fixes the RX stats for
  27 different drivers and the fifth one fixes the TX stats for 25
  different ones.


* Changelog *

v2 -> v3:

  * Fix an issue in the fourth patch ("do not increase rx_bytes
    statistics for RTR frames"). In ucan_rx_can_msg() of the ucan
    driver, the changes in v2 made no sense. Reverted it to v1.


v1 -> v2:

  * can_rx_offload_napi_poll: v1 used CAN_ERR_MASK instead of
    CAN_ERR_FLAG. Fixed the issue.

  * use correct vocabulary. The correct term to designate the Socket
    CAN specific error skb is "error message frames" not "error
    frames". "error frames" is used in the standard and has a
    different meaning.

  * better factorize code for the rx RTR frames. Most of the driver
    already has a switch to check if the frame is a RTR. Moved the
    instruction to increase net_device_stats:rx_bytes inside the else
    branch of those switches whenever possible (for some drivers with
    some complex logic, putting and additional RTR check was easier).

  * add a patch which prevent drivers to copy the payload of RTR
    frames.

  * add a patch to cover the tx RTR frames (the fifth patch of
    v2). The tx RTR frames issue was supposedly covered by the
    can_get_echo_skb() function which returns the correct length for
    drivers to increase their stats. However, the reality is that most
    of the drivers do not check this value and instead use a local
    copy of the length/dlc.


Vincent Mailhol (5):
  can: do not increase rx statistics when generating a CAN rx error
    message frame
  can: kvaser_usb: do not increase tx statistics when sending error
    message frames
  can: do not copy the payload of RTR frames
  can: do not increase rx_bytes statistics for RTR frames
  can: do not increase tx_bytes statistics for RTR frames

 drivers/net/can/at91_can.c                    | 18 ++---
 drivers/net/can/c_can/c_can.h                 |  1 -
 drivers/net/can/c_can/c_can_main.c            | 16 +---
 drivers/net/can/cc770/cc770.c                 | 16 ++--
 drivers/net/can/dev/dev.c                     |  4 -
 drivers/net/can/dev/rx-offload.c              |  7 +-
 drivers/net/can/grcan.c                       |  6 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c         | 11 +--
 drivers/net/can/janz-ican3.c                  |  6 +-
 drivers/net/can/kvaser_pciefd.c               | 16 ++--
 drivers/net/can/m_can/m_can.c                 | 13 +---
 drivers/net/can/mscan/mscan.c                 | 14 ++--
 drivers/net/can/pch_can.c                     | 33 ++++----
 drivers/net/can/peak_canfd/peak_canfd.c       | 14 ++--
 drivers/net/can/rcar/rcar_can.c               | 22 +++---
 drivers/net/can/rcar/rcar_canfd.c             | 13 +---
 drivers/net/can/sja1000/sja1000.c             | 11 +--
 drivers/net/can/slcan.c                       |  7 +-
 drivers/net/can/softing/softing_main.c        |  8 +-
 drivers/net/can/spi/hi311x.c                  | 31 ++++----
 drivers/net/can/spi/mcp251x.c                 | 31 ++++----
 drivers/net/can/sun4i_can.c                   | 22 +++---
 drivers/net/can/usb/ems_usb.c                 | 14 ++--
 drivers/net/can/usb/esd_usb2.c                | 13 ++--
 drivers/net/can/usb/etas_es58x/es58x_core.c   |  7 --
 drivers/net/can/usb/gs_usb.c                  |  7 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  5 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  |  4 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 78 +++++++++----------
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 20 ++---
 drivers/net/can/usb/mcba_usb.c                | 23 +++---
 drivers/net/can/usb/peak_usb/pcan_usb.c       |  9 +--
 drivers/net/can/usb/peak_usb/pcan_usb_core.c  | 20 +++--
 drivers/net/can/usb/peak_usb/pcan_usb_core.h  |  1 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c    | 11 +--
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c   | 12 +--
 drivers/net/can/usb/ucan.c                    | 17 ++--
 drivers/net/can/usb/usb_8dev.c                | 17 ++--
 drivers/net/can/vcan.c                        |  7 +-
 drivers/net/can/vxcan.c                       |  2 +-
 drivers/net/can/xilinx_can.c                  | 19 ++---
 include/linux/can/skb.h                       |  5 +-
 42 files changed, 258 insertions(+), 353 deletions(-)


base-commit: 4cc19cc269921210f3da65e4b038ad987835b342
-- 
2.32.0

