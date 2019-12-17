Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D47122BB2
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfLQMdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:33:51 -0500
Received: from mga18.intel.com ([134.134.136.126]:47966 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbfLQMdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 07:33:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 04:33:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,325,1571727600"; 
   d="scan'208";a="389811678"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 04:33:46 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 641FE12A; Tue, 17 Dec 2019 14:33:45 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mario.Limonciello@dell.com,
        Anthony Wong <anthony.wong@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Kellner <ckellner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] thunderbolt: Add support for USB4
Date:   Tue, 17 Dec 2019 15:33:36 +0300
Message-Id: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

USB4 is the public specification of Thunderbolt 3 protocol and can be
downloaded here:

  https://www.usb.org/sites/default/files/USB4%20Specification_1.zip

USB4 is about tunneling different protocols over a single cable (in the
same way as Thunderbolt). The current USB4 spec supports PCIe, Display Port
and USB 3.x, and also software based protocols such as networking between
domains (hosts).

So far PCs have been using firmware based Connection Manager (FW CM, ICM)
and Apple systems have been using software based one (SW CM, ECM). A
Connection Manager is the entity that handles creation of different tunnel
types through the USB4 (and Thunderbolt) fabric. With USB4 the plan is to
have software based Connection Manager everywhere but some early systems
will come with firmware based connection manager.

Current Linux Thunderbolt driver supports both "modes" and can detect which
one to use dynamically.

This series extends the Linux Thunderbolt driver to support USB4 compliant
hosts and devices (this applies to both firmware and software based
connection managers). USB4 Features enabled by this series include:

  - PCIe tunneling
  - Display Port tunneling
  - USB 3.x tunneling
  - P2P networking (implemented in drivers/net/thunderbolt.c)
  - Host and device NVM firmware upgrade

Power management support is still work in progress. It will be submitted
later on once properly tested.

The previous versions of the series can be seen here:

  v1: https://lore.kernel.org/linux-usb/20191023112154.64235-1-mika.westerberg@linux.intel.com/
  RFC: https://lore.kernel.org/lkml/20191001113830.13028-1-mika.westerberg@linux.intel.com/

Changes from v1:

  * Rebased on top of v5.5-rc2.
  * Add a new patch to populate PG field in hotplug ack packet.
  * Rename the networking driver Kconfig symbol to CONFIG_USB4_NET to
    follow the driver itself (CONFIG_USB4).

Changes from the RFC version:

  * Spelled out what are ICM, and SW CM (and ECM)
  * Log warning in tb_switch_add() instead of the caller
  * Use Lukas' suggestion in port walk helper macro and also drop
    tb_switch_for_each_remote_port() and tb_switch_for_each_connected_port()
  * Rework icm.c::add_switch() so that we don't need to pass huge amount of
    parameters to it
  * Add rx/tx versions of link width/speed attributes following convention
    used in USB bus (with the exception that we provide rx_speed and
    tx_speed as well).
  * Spell out DROM and try to clarify what linking in patch [11/25] means.
  * Add a new patch that expands controller name in existing tb_switch_is_xy()
    functions and do the same for tb_switch_is_ar()/tr().
  * Move register name conversion pathes up in the series so that we can
    apply them for v5.5 already.
  * Update changelog of patch [14/25] so that it only mentions Titan Ridge.
  * Rename CONFIG_THUNDERBOLT to CONFIG_USB4, this should be more future
    proof.
  * Check if TMU is enabled in tb_switch_tmu_enable().
  * Use "usb3" and "USB3" in USB 3.x tunneling functionality instead of
    plain "usb".
  * Reword documentation patch [25/25] according to received comments.
  * Introduce icm_firmware_running().

Mika Westerberg (6):
  thunderbolt: Make tb_find_port() available to other files
  thunderbolt: Call tb_eeprom_get_drom_offset() from tb_eeprom_read_n()
  thunderbolt: Populate PG field in hot plug acknowledgment packet
  thunderbolt: Add initial support for USB4
  thunderbolt: Update Kconfig entries to USB4
  thunderbolt: Update documentation with the USB4 information

Rajmohan Mani (3):
  thunderbolt: Make tb_switch_find_cap() available to other files
  thunderbolt: Add support for Time Management Unit
  thunderbolt: Add support for USB 3.x tunnels

 Documentation/admin-guide/thunderbolt.rst |  30 +-
 drivers/Makefile                          |   2 +-
 drivers/net/Kconfig                       |  10 +-
 drivers/net/Makefile                      |   2 +-
 drivers/thunderbolt/Kconfig               |  11 +-
 drivers/thunderbolt/Makefile              |   4 +-
 drivers/thunderbolt/cap.c                 |  11 +-
 drivers/thunderbolt/ctl.c                 |  19 +-
 drivers/thunderbolt/ctl.h                 |   3 +-
 drivers/thunderbolt/eeprom.c              | 137 ++--
 drivers/thunderbolt/nhi.c                 |   3 +
 drivers/thunderbolt/nhi.h                 |   2 +
 drivers/thunderbolt/switch.c              | 439 ++++++++++---
 drivers/thunderbolt/tb.c                  | 227 +++++--
 drivers/thunderbolt/tb.h                  | 101 +++
 drivers/thunderbolt/tb_msgs.h             |   6 +-
 drivers/thunderbolt/tb_regs.h             |  65 +-
 drivers/thunderbolt/tmu.c                 | 383 +++++++++++
 drivers/thunderbolt/tunnel.c              | 169 ++++-
 drivers/thunderbolt/tunnel.h              |   9 +
 drivers/thunderbolt/usb4.c                | 764 ++++++++++++++++++++++
 drivers/thunderbolt/xdomain.c             |   6 +
 22 files changed, 2167 insertions(+), 236 deletions(-)
 create mode 100644 drivers/thunderbolt/tmu.c
 create mode 100644 drivers/thunderbolt/usb4.c

-- 
2.24.0

