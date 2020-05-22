Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D351DDBCB
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgEVALK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:11:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:41697 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730071AbgEVALK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:11:10 -0400
IronPort-SDR: fX9eydgb1SW++u1rhXOe++xcJSMtTfsdbzUpSSR4SsmYr9rFf+PJaiGD/fAxzuUR5XFfd+Sht3
 E8cTEcqLe0xQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:11:09 -0700
IronPort-SDR: mlFeehRM/gkfc/dPj1IukxKDUbL1Bf6s/B1nxD29kh/L3CDWhP0yT5taI+Dp2ohHxi4cBDLXXd
 X6LuK3REaVEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254133920"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2020 17:11:09 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 00/15][pull request] 1GbE Intel Wired LAN Driver Updates 2020-05-21
Date:   Thu, 21 May 2020 17:10:53 -0700
Message-Id: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc and e1000.

Andre cleans up code that was left over from the igb driver that handled
MAC address filters based on the source address, which is not currently
supported.  Simplifies the MAC address filtering code and prepare the
igc driver for future source address support.  Updated the MAC address
filter internal APIs to support filters based on source address.  Added
support for Network Flow Classification (NFC) rules based on source MAC
address.  Cleaned up the 'cookie' field which is not used anywhere in
the code and cleaned up a wrapper function that was not needed.
Simplified the filtering code for readability and aligned the ethtool
functions, so that function names were consistent.

Alex provides a fix for e1000 to resolve a deadlock issue when NAPI is
being disabled.

Sasha does additional cleanup of the igc driver of dead code that is not
used or needed.

v2: Fix the function header comment in patch 3 of the series, based on
    the feedback from Jakub Kicinski.

The following are changes since commit de1b99ef2aa1e982c86b15853e013c6e3dbc1e7a:
  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Alexander Duyck (1):
  e1000: Do not perform reset in reset_task if we are already down

Andre Guedes (11):
  igc: Remove IGC_MAC_STATE_SRC_ADDR flag
  igc: Remove mac_table from igc_adapter
  igc: Add support for source address filters in core
  igc: Enable NFC rules based source MAC address
  igc: Remove unused field from igc_nfc_filter
  igc: Get rid of igc_max_channels()
  igc: Cleanup _get|set_rxnfc ethtool ops
  igc: Early return in igc_get_ethtool_nfc_entry()
  igc: Add 'igc_ethtool_' prefix to functions in igc_ethtool.c
  igc: Align terms used in NFC support code
  igc: Change byte order in struct igc_nfc_filter

Sasha Neftin (3):
  igc: Remove obsolete circuit breaker registers
  igc: Remove header redirection register
  igc: Remove per queue good transmited counter register

 drivers/net/ethernet/intel/e1000/e1000_main.c |  18 +-
 drivers/net/ethernet/intel/igc/igc.h          |  69 +--
 drivers/net/ethernet/intel/igc/igc_defines.h  |   3 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c  | 468 +++++++++---------
 drivers/net/ethernet/intel/igc/igc_mac.c      |   4 -
 drivers/net/ethernet/intel/igc/igc_main.c     | 162 +++---
 drivers/net/ethernet/intel/igc/igc_regs.h     |  11 -
 7 files changed, 342 insertions(+), 393 deletions(-)

-- 
2.26.2

