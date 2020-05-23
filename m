Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025E91DF435
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387516AbgEWCvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:37983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387481AbgEWCvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:12 -0400
IronPort-SDR: tufebH0mLDy29NDvb17n43/sWmhyuezDdX1tnJRkToFLSVvMabpgYMKoTgZX4OnBe/EMCKHk/2
 ekm/It6HvZKQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:11 -0700
IronPort-SDR: cB6cqq+rcSm86Hl9KPfWEM5L2y8AKZUg4xJSZll4KZlC7IUzLi0ND5AULJEkVP8QZZv7E7BEvb
 /YH1p6O6Wzxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291056"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/17][pull request] 1GbE Intel Wired LAN Driver Updates 2020-05-22
Date:   Fri, 22 May 2020 19:50:52 -0700
Message-Id: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e, igc and igb.

Many of the patches in this series are fixes, but many of the igc fixes
are based on the recent filter rule handling Andre has been working,
which will not backport to earlier/stable kernels.  The remaining fixes
for e1000e and igb have CC'd stable where applicable.

Andre continue with his refactoring of the filter rule code to help with
reducing the complexity, in multiple patches.  Fix the inconsistent size
of a struct field.  Fixed an issue where filter rules stay active in the
hardware, even after it was deleted, so make sure to disable the filter
rule before deleting.  Fixed an issue with NFC rules which were dropping
valid multicast MAC address.  Fixed how the NFC rules are restored after
the NIC is reset or brought up, so that they are restored in the same order
they were initially setup in.  Fix a potential memory leak when the
driver is unloaded and the NFC rules are not flushed from memory
properly.  Fixed how NFC rule validation handles when a request to
overwrite an existing rule.  Changed the locking around the NFC rule API
calls from spin_locks to mutex locks to avoid unnecessary busy waiting
on lock contention.

Sasha clean up more unused code in the igc driver.

Kai-Heng Feng from Canonical provides three fixes, first has igb report
the speed and duplex as unknown when in runtime suspend.  Fixed e1000e
to pass up the error when disabling ULP mode.  Fixed e1000e performance
by disabling TSO by default for certain MACs.

Vitaly disables S0ix entry and exit flows for ME systems.

The following are changes since commit 593532668f635d19d207510e0fbb5c2250f56b6f:
  Revert "net: mvneta: speed down the PHY, if WoL used, to save energy"
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Andre Guedes (12):
  igc: Refactor igc_ethtool_add_nfc_rule()
  igc: Fix 'sw_idx' type in struct igc_nfc_rule
  igc: Fix locking issue when retrieving NFC rules
  igc: Fix NFC rule overwrite cases
  igc: Fix NFC rules with multicast addresses
  igc: Fix NFC rules restoration
  igc: Refactor igc_ethtool_update_nfc_rule()
  igc: Fix NFC rules leak when driver is unloaded
  igc: Fix NFC rule validation
  igc: Change return type from igc_disable_nfc_rule()
  igc: Change adapter->nfc_rule_lock to mutex
  igc: Remove igc_nfc_rule_exit()

Kai-Heng Feng (3):
  igb: Report speed and duplex as unknown when device is runtime
    suspended
  e1000e: Warn if disabling ULP failed
  e1000e: Disable TSO for buffer overrun workaround

Sasha Neftin (1):
  igc: Remove unused descriptor's flags

Vitaly Lifshits (1):
  e1000e: disable s0ix entry and exit flows for ME systems

 drivers/net/ethernet/intel/e1000e/ich8lan.c  |   6 +-
 drivers/net/ethernet/intel/e1000e/netdev.c   |  49 +++-
 drivers/net/ethernet/intel/igb/igb_ethtool.c |   3 +-
 drivers/net/ethernet/intel/igc/igc.h         |  26 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |   4 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 294 ++++++++-----------
 drivers/net/ethernet/intel/igc/igc_main.c    | 246 ++++++++++++----
 7 files changed, 362 insertions(+), 266 deletions(-)

-- 
2.26.2

