Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA16410C9D
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhISR00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:26:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:39250 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhISR0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 13:26:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10112"; a="210266256"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="210266256"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2021 10:24:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="531936508"
Received: from ccgwwan-adlp2.iind.intel.com ([10.224.174.127])
  by fmsmga004.fm.intel.com with ESMTP; 19 Sep 2021 10:24:56 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V2 net-next 0/6] net: wwan: iosm: fw flashing & cd collection
Date:   Sun, 19 Sep 2021 22:54:24 +0530
Message-Id: <20210919172424.25764-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series brings-in support for M.2 7560 Device firmware flashing &
coredump collection using devlink.
- Driver Registers with Devlink framework.
- Register devlink params callback for configuring device params
  required in flashing or coredump flow.
- Implements devlink ops flash_update callback that programs modem
  firmware.
- Creates region & snapshot required for device coredump log collection.

On early detection of device in boot rom stage. Driver registers with
Devlink framework and establish transport channel for PSI (Primary Signed
Image) injection. Once PSI is injected to device, the device execution
stage details are read to determine whether device is in flash or
exception mode. The collected information is reported to devlink user
space application & based on this informationi, application proceeds with
either modem firmware flashing or coredump collection.

Refer to iosm devlink documentation for details on Devlink Params, flash
update and coredump collection command usage.

Note: Patches are interdependent. Need to apply complete patch series for
compilation.

Changes since v1:
  * Break down single patch into multiple patches.
  * IOSM Driver devlink documentation.
  * Fixes NULL parameter deference in ipc_devlink_flash_update() reported
    by smatch static checker.
  * Fixes memory leak in ipc_devlink_create_region().
  * Use kmemdup instead of kzalloc and memcpy in ipc_flash_boot_psi().
  * Fixes linux-net build error.

M Chetan Kumar (6):
  net: wwan: iosm: devlink registration
  net: wwan: iosm: fw flashing support
  net: wwan: iosm: coredump collection support
  net: wwan: iosm: transport layer support for fw flashing/cd
  net: wwan: iosm: devlink fw flashing & cd collection documentation
  net: wwan: iosm: fw flashing & cd collection infrastructure changes

 Documentation/networking/devlink/index.rst |   1 +
 Documentation/networking/devlink/iosm.rst  | 182 +++++++
 drivers/net/wwan/Kconfig                   |   1 +
 drivers/net/wwan/iosm/Makefile             |   5 +-
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c  |   6 +-
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h  |   1 +
 drivers/net/wwan/iosm/iosm_ipc_coredump.c  | 110 ++++
 drivers/net/wwan/iosm/iosm_ipc_coredump.h  |  75 +++
 drivers/net/wwan/iosm/iosm_ipc_devlink.c   | 363 +++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_devlink.h   | 207 ++++++++
 drivers/net/wwan/iosm/iosm_ipc_flash.c     | 561 +++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_flash.h     | 271 ++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.c      | 103 +++-
 drivers/net/wwan/iosm/iosm_ipc_imem.h      |  18 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c  | 317 ++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h  |  49 +-
 16 files changed, 2239 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/networking/devlink/iosm.rst
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_coredump.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_coredump.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_devlink.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_devlink.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_flash.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_flash.h

-- 
2.25.1

