Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7901AE4FF
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbgDQSmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:42:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:56864 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbgDQSmx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 14:42:53 -0400
IronPort-SDR: lwUZQbyHdvbkCQq9D7QCEiiWuNhxT8MMcmdpnlLyueYxu18uauJYbYQbAyOH7NWVVZn1IQ1PHc
 +Ad89ZgtEtbw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:42:52 -0700
IronPort-SDR: qjvv9HSPWRsARiyBGJJ1H3Mo2rJrP4MP18x5NHQoT8qwTCHsnROCmLd9j9CgN5MwDvhdwQrYt5
 G7QF+sZDJhxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="254294353"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 11:42:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver Updates 2020-04-17
Date:   Fri, 17 Apr 2020 11:42:37 -0700
Message-Id: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e and igc only.

Sasha adds partial generic segmentation offload (GSO partial) support to
the igc driver.  Also added support for translating taprio schedules
into i225 cycles in igc.  Did clean up of dead code or unused defines in
the igc driver.  Refactored the code to avoid forward declarations where
possible.  Enables the NETIF_F_HW_TC flag for igc by default.

Vinicius adds support for ETF offloading using the similar approach that
taprio offload used.

Kees Cook fixes a clang warning in the e1000e driver by moving the
declared variable either into the switch case that uses the variable or
lift them up into the main function body, to help the compiler.

Andre fixed some register overwriting when dumping registers via ethtool
for igc driver.  Also fixed support for ethtool Network Flow
Classification (NFC) queue redirection by adding the missing code needed
to enable the queue selection feature from Receive Address High (RAH)
register.  Cleans up code to remove the code bits designed to support
tc-flower filters, since this client part does not support it.

The following are changes since commit 2fcd80144b93ff90836a44f2054b4d82133d3a85:
  Merge tag 'tag-chrome-platform-fixes-for-v5.7-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/chrome-platform/linux
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Andre Guedes (4):
  igc: Fix overwrites when dumping registers
  igc: Fix NFC queue redirection support
  igc: Remove dead code related to flower filter
  igc: Fix default MAC address filter override

Kees Cook (1):
  e1000: Distribute switch variables for initialization

Sasha Neftin (7):
  igc: Add GSO partial support
  igc: Remove unused MDIC_DEST mask
  igc: Remove unused CTRL_EXT_LINK_MODE_MASK
  igc: Remove forward declaration
  igc: Fix double definition
  igc: Enable NETIF_F_HW_TC flag
  igc: Remove copper fiber switch control

Vinicius Costa Gomes (2):
  igc: Add support for taprio offloading
  igc: Add support for ETF offloading

 drivers/net/ethernet/intel/e1000/e1000_main.c |   4 +-
 drivers/net/ethernet/intel/igc/Makefile       |   2 +-
 drivers/net/ethernet/intel/igc/igc.h          | 389 +++++++++---------
 drivers/net/ethernet/intel/igc/igc_defines.h  |  24 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |  11 +-
 drivers/net/ethernet/intel/igc/igc_main.c     | 219 +++++++++-
 drivers/net/ethernet/intel/igc/igc_regs.h     |  12 +
 drivers/net/ethernet/intel/igc/igc_tsn.c      | 157 +++++++
 drivers/net/ethernet/intel/igc/igc_tsn.h      |   9 +
 9 files changed, 605 insertions(+), 222 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/igc/igc_tsn.c
 create mode 100644 drivers/net/ethernet/intel/igc/igc_tsn.h

-- 
2.25.2

