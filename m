Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0601645A1FD
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbhKWL4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:56:53 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:53527 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbhKWL4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 06:56:53 -0500
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id pUMhmyepO2lVYpUMnmei4h; Tue, 23 Nov 2021 12:53:44 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Tue, 23 Nov 2021 12:53:44 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v1 0/2] fix statistics for CAN RTR and Error frames
Date:   Tue, 23 Nov 2021 20:53:31 +0900
Message-Id: <20211123115333.624335-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two common errors which are made when reporting the CAN RX
statistics:

  1. Incrementing the "normal" RX stats when receiving an Error
  frame. Error frames is an abstraction of Socket CAN and does not
  exist on the wire.

  2. Counting the length of the Remote Transmission Frames (RTR). The
  length of an RTR frame is the length of the requested frame not the
  actual payload. In reality the payload of an RTR frame is always 0
  bytes long.

This patch series fix those two issues for all CAN drivers.

Vincent Mailhol (2):
  can: do not increase rx statistics when receiving CAN error frames
  can: do not increase rx_bytes statistics for RTR frames

 drivers/net/can/at91_can.c                      |  9 ++-------
 drivers/net/can/c_can/c_can_main.c              |  8 ++------
 drivers/net/can/cc770/cc770.c                   |  6 ++----
 drivers/net/can/dev/dev.c                       |  4 ----
 drivers/net/can/dev/rx-offload.c                |  7 +++++--
 drivers/net/can/grcan.c                         |  3 ++-
 drivers/net/can/ifi_canfd/ifi_canfd.c           |  8 ++------
 drivers/net/can/janz-ican3.c                    |  3 ++-
 drivers/net/can/kvaser_pciefd.c                 |  8 ++------
 drivers/net/can/m_can/m_can.c                   | 10 ++--------
 drivers/net/can/mscan/mscan.c                   | 10 ++++++----
 drivers/net/can/pch_can.c                       |  6 ++----
 drivers/net/can/peak_canfd/peak_canfd.c         |  7 ++-----
 drivers/net/can/rcar/rcar_can.c                 |  9 +++------
 drivers/net/can/rcar/rcar_canfd.c               |  7 ++-----
 drivers/net/can/sja1000/sja1000.c               |  5 ++---
 drivers/net/can/slcan.c                         |  3 ++-
 drivers/net/can/spi/hi311x.c                    |  3 ++-
 drivers/net/can/spi/mcp251x.c                   |  3 ++-
 drivers/net/can/sun4i_can.c                     | 10 ++++------
 drivers/net/can/usb/ems_usb.c                   |  5 ++---
 drivers/net/can/usb/esd_usb2.c                  |  5 ++---
 drivers/net/can/usb/etas_es58x/es58x_core.c     |  7 -------
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c    |  2 --
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c   | 14 ++++----------
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c    |  7 ++-----
 drivers/net/can/usb/mcba_usb.c                  |  3 ++-
 drivers/net/can/usb/peak_usb/pcan_usb.c         |  5 ++---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c      | 11 ++++-------
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c     | 11 +++++------
 drivers/net/can/usb/ucan.c                      |  7 +++++--
 drivers/net/can/usb/usb_8dev.c                  | 10 ++++------
 drivers/net/can/xilinx_can.c                    | 17 ++++++-----------
 33 files changed, 86 insertions(+), 147 deletions(-)

-- 
2.32.0

