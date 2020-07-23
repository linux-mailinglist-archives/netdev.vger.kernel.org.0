Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC34E22BA53
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgGWXr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:43317 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgGWXrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:25 -0400
IronPort-SDR: Hn6UMDAzHOxmGyp5XYlhPhajtUYpOFacupRc0b9mFxjqMtJBhiV20xsfBze5Nh3tP3V1h3p95O
 N/Qx18TVOIHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235515427"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235515427"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:25 -0700
IronPort-SDR: 0WUvjWago77q9dkEJeXsLUFyquEcDswKHYPg7O8pLFFQBKOF578legWLKL1CPAzxT+5jb514GT
 JYS/Hwfm1phA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742280"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2020-07-23
Date:   Thu, 23 Jul 2020 16:47:05 -0700
Message-Id: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jake refactors ice_discover_caps() to reduce the number of AdminQ calls
made. Splits ice_parse_caps() to separate functions to update function
and device capabilities separately to allow for updating outside of
initialization.

Akeem adds power management support.

Paul G refactors FC and FEC code to aid in restoring of PHY settings
on media insertion. Implements lenient mode and link override support.
Adds link debug info and formats existing debug info to be more
readable. Adds support to check and report additional autoneg
capabilities. Implements the capability to detect media cage in order to
differentiate AUI types as Direct Attach or backplane.

Bruce implements Total Port Shutdown for devices that support it.

Lev renames low_power_ctrl field to lower_power_ctrl_an to be more
descriptive of the field.

Doug reports AOC types as media type fiber.

Paul S adds code to handle 1G SGMII PHY type.

The following are changes since commit 15be4ea3f07034a50eee2db6f3fefd2bec582170:
  Merge branch 'l2tp-further-checkpatch-pl-cleanups'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (1):
  ice: Add advanced power mgmt for WoL

Bruce Allan (1):
  ice: support Total Port Shutdown on devices that support it

Doug Dziggel (1):
  ice: Report AOC PHY Types as Fiber

Jacob Keller (3):
  ice: refactor ice_discover_caps to avoid need to retry
  ice: split ice_parse_caps into separate functions
  ice: split ice_discover_caps into two functions

Lev Faerman (1):
  ice: Rename low_power_ctrl

Paul Greenwalt (7):
  ice: refactor FC functions
  ice: move auto FEC checks into ice_cfg_phy_fec()
  ice: restore PHY settings on media insertion
  ice: add link lenient and default override support
  ice: add ice_aq_get_phy_caps() debug logs
  ice: update reporting of autoneg capabilities
  ice: add AQC get link topology handle support

Paul M Stillwell Jr (1):
  ice: add 1G SGMII PHY type

 drivers/net/ethernet/intel/ice/ice.h          |   11 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   67 +-
 drivers/net/ethernet/intel/ice/ice_common.c   | 1229 +++++++++++++----
 drivers/net/ethernet/intel/ice/ice_common.h   |   24 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  740 ++++++----
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    9 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   24 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |    2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  774 ++++++++++-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |    5 +-
 drivers/net/ethernet/intel/ice/ice_nvm.h      |    4 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   57 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   25 -
 13 files changed, 2323 insertions(+), 648 deletions(-)

-- 
2.26.2

