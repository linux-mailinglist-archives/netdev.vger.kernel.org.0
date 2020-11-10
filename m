Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC24D2AD36F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731945AbgKJKTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:19:12 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:16036 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730651AbgKJKTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:19:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1605003543;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=YUWZR0B2I2C2edConHSv63AwcI81KpLFVO2tp66LmGs=;
        b=Z0WbqsM+5q10CTW5eu8XWcXgesCA3qpUU0h6OEl39KO4CEeM/NnwtXex89Ei98FIX8
        zZeAo71VXArwIUCA6+vundS+fpHIZe0LPei0f/CMOYq2ujtSJHxrRNdhZyv2UTpEA8Fk
        6pDQ6/FUz5UjXfoXAfJsIMvgKNBQHOPzOon8ZXs7uNOd0KVRV2Wkj7XJh5XRCc+NrGIw
        mA/fjfOqjE0IU4EwW2KurbhWEQh7MLflNSOO/MLgG5/HbdzF1B05PTq+Mh8VW2OjrTeo
        tmwkKP1xlaAySb52bny3xLESzLdRG3Xf/Elvh0pYpz1pM0qIRTE2DyiwjqUIGIzcNo2Y
        PNmQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJywjsi+/Fw=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwAAAJ0AQa
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 10 Nov 2020 11:19:00 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v6 0/8] Introduce optional DLC element for Classic CAN
Date:   Tue, 10 Nov 2020 11:18:44 +0100
Message-Id: <20201110101852.1973-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce improved DLC handling for Classic CAN with introduces a new
element 'len8_dlc' to the struct can_frame and additionally rename
the 'can_dlc' element to 'len' as it represents a plain payload length.

Before implementing the CAN_CTRLMODE_CC_LEN8_DLC handling on driver level
this patch set cleans up and renames the relevant code.

No functional changes.

This patch set is based on kernel/git/netdev/net-next.git

Changes in v2:
  - rephrase commit message of patch 4 about can_dlc replacement

Changes in v3:
  - remove unnecessarily introduced u8 cast in flexcan.c

Changes in v4:
  - adopt phrasing suggestions from Vincent Mailhol
  - separate and extend CAN documentation (Documentation/networking/can.rst)
  - add new patches for len8_dlc handling for CAN drivers
      - add new helpers in include/linux/can/dev.h
      - add len8_dlc support for various CAN USB adapters as reference

Changes in v5:
  - rename CAN FD related can_len2dlc and can_dlc2len helpers so that they
    fit to the renamed can_cc_dlc2len helper for Classical CAN
    (suggested by Vincent Mailhol)

Changes in v6: (only patch 7 & 8)
  - rework helpers to access Classical CAN DLC values
  - move CAN_CTRLMODE_CC_LEN8_DLC at the end of ctrlmode_supported defs

Oliver Hartkopp (8):
  can: add optional DLC element to Classical CAN frame structure
  can: rename get_can_dlc() macro with can_cc_dlc2len()
  can: remove obsolete get_canfd_dlc() macro
  can: replace can_dlc as variable/element for payload length
  can: rename CAN FD related can_len2dlc and can_dlc2len helpers
  can: update documentation for DLC usage in Classical CAN
  can-dev: introduce helpers to access Classical CAN DLC values
  can-dev: add len8_dlc support for various CAN USB adapters

 Documentation/networking/can.rst              | 70 ++++++++++++++-----
 drivers/net/can/at91_can.c                    | 14 ++--
 drivers/net/can/c_can/c_can.c                 | 20 +++---
 drivers/net/can/cc770/cc770.c                 | 14 ++--
 drivers/net/can/dev.c                         | 16 ++---
 drivers/net/can/flexcan.c                     |  6 +-
 drivers/net/can/grcan.c                       | 10 +--
 drivers/net/can/ifi_canfd/ifi_canfd.c         | 10 +--
 drivers/net/can/janz-ican3.c                  | 20 +++---
 drivers/net/can/kvaser_pciefd.c               | 10 +--
 drivers/net/can/m_can/m_can.c                 | 12 ++--
 drivers/net/can/mscan/mscan.c                 | 20 +++---
 drivers/net/can/pch_can.c                     | 14 ++--
 drivers/net/can/peak_canfd/peak_canfd.c       | 16 ++---
 drivers/net/can/rcar/rcar_can.c               | 14 ++--
 drivers/net/can/rcar/rcar_canfd.c             | 12 ++--
 drivers/net/can/rx-offload.c                  |  2 +-
 drivers/net/can/sja1000/sja1000.c             | 10 +--
 drivers/net/can/slcan.c                       | 32 ++++-----
 drivers/net/can/softing/softing_fw.c          |  2 +-
 drivers/net/can/softing/softing_main.c        | 14 ++--
 drivers/net/can/spi/hi311x.c                  | 20 +++---
 drivers/net/can/spi/mcp251x.c                 | 20 +++---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 10 +--
 drivers/net/can/sun4i_can.c                   | 10 +--
 drivers/net/can/ti_hecc.c                     |  8 +--
 drivers/net/can/usb/ems_usb.c                 | 16 ++---
 drivers/net/can/usb/esd_usb2.c                | 16 ++---
 drivers/net/can/usb/gs_usb.c                  | 17 ++---
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  |  2 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 24 +++----
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 22 +++---
 drivers/net/can/usb/mcba_usb.c                | 10 +--
 drivers/net/can/usb/peak_usb/pcan_usb.c       | 18 ++---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c    | 29 +++++---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c   | 14 ++--
 drivers/net/can/usb/ucan.c                    | 20 +++---
 drivers/net/can/usb/usb_8dev.c                | 20 +++---
 drivers/net/can/xilinx_can.c                  | 16 ++---
 include/linux/can/dev.h                       | 41 +++++++++--
 include/linux/can/dev/peak_canfd.h            |  2 +-
 include/uapi/linux/can.h                      | 38 ++++++----
 include/uapi/linux/can/netlink.h              |  1 +
 net/can/af_can.c                              |  2 +-
 net/can/gw.c                                  |  2 +-
 net/can/j1939/main.c                          |  4 +-
 46 files changed, 403 insertions(+), 317 deletions(-)

-- 
2.28.0

