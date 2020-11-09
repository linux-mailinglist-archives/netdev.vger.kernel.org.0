Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07D12ABFF7
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbgKIPhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:37:18 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.22]:9693 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgKIPhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:37:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604936234;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=aYALwDSvZccYv0EdUz0eQbCo0KvLmSghgC4ARnpCv3g=;
        b=ps02FxtxN6wRatB4B3WuKyDz6at/jqDISqlYslIA8e675p/l7kJyPJ9H3NfDtxmdrw
        FnKw6IgCDDofOl2sFWInS9zSuvggd7oICKJddocD8ifzS72scyOar82CmWwz/Bj//uqy
        QItKRY4ldUQvQxkMinNb6dRQXjhHGUfyG3AbfMYCcqJJUBWl3yu01APa/j53CvUk4qcl
        37oKzNfTLDmV/WQIcENuZ64kCZXkvTpG0eCx7mIv1P6lcRKhTXWGP+O2ksj8oa1NM0HO
        xX+gDoEdQEgnfxXCxAWJY+c/6oIaRZUFmSFZBRm5+BCptbsx79vZJP+LCj9i0DXQFU27
        h+aQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0lu8GW272ZqqIaA=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwA9FbC85W
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 9 Nov 2020 16:37:12 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v5 0/8] Introduce optional DLC element for Classic CAN
Date:   Mon,  9 Nov 2020 16:36:49 +0100
Message-Id: <20201109153657.17897-1-socketcan@hartkopp.net>
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
 drivers/net/can/usb/gs_usb.c                  | 20 +++---
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  |  2 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 24 +++----
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 22 +++---
 drivers/net/can/usb/mcba_usb.c                | 10 +--
 drivers/net/can/usb/peak_usb/pcan_usb.c       | 20 +++---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c    | 29 +++++---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c   | 14 ++--
 drivers/net/can/usb/ucan.c                    | 20 +++---
 drivers/net/can/usb/usb_8dev.c                | 21 +++---
 drivers/net/can/xilinx_can.c                  | 16 ++---
 include/linux/can/dev.h                       | 32 +++++++--
 include/linux/can/dev/peak_canfd.h            |  2 +-
 include/uapi/linux/can.h                      | 38 ++++++----
 include/uapi/linux/can/netlink.h              |  1 +
 net/can/af_can.c                              |  2 +-
 net/can/gw.c                                  |  2 +-
 net/can/j1939/main.c                          |  4 +-
 46 files changed, 400 insertions(+), 317 deletions(-)

-- 
2.28.0

