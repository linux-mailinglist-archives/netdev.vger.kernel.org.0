Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3CB1DE034
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgEVG4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:18659 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728134AbgEVG4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:09 -0400
IronPort-SDR: uLb60MTtLtzptAm/jidR3Qsc7uJb977jvKdGEe0mG5u/XzMwREpRs7F+eu0afxO/slV300fvms
 LweRnLV8eJSQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:08 -0700
IronPort-SDR: IMUHilfy2dQWuIV1a5Zu8nm0cWKkgs8lZILluUGL8RURaJJmKzgFW/MhBiJ7uxElV4oODowUNl
 xsnUeEFJR9ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017730"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:08 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/17][pull request] 100GbE Intel Wired LAN Driver Updates 2020-05-21
Date:   Thu, 21 May 2020 23:55:50 -0700
Message-Id: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.  Several of the changes
are fixes, which could be backported to stable, of which, only one was
marked for stable because of the memory leak potential.

Jake exposes the information in the flash memory used for link
management, which is called the netlist module.

Henry and Tony add support for tunnel offloads.

Brett adds promiscuous support in VF's which is based on VF trust and
the new vf-true-promisc flag.

Avinash fixes an issue where a transmit timeout for a queue that belongs
to a PFC enabled TC is not a true transmit timeout, but because the PFC
is in action.

Dave fixes the check for contiguous TCs to allow for various UP2TC
mapping configurations.  Also fixed an issue when changing the pause
parameters would could multiple link drop/down's in succession, which in
turn caused the firmware to not generate a link interrupt for the driver
to respond to.

Anirudh (Ani) fixed a potential race condition in probe/open due to a
bit being cleared too early.

Lihong updates an error message to make it more meaningful instead of
just printing out the numerical value of the status/error code.  Also
fixed an incorrect return value if deleting a filter does not find a
match to delete or when adding a filter that already exists.

Karol fixes casting issues and precision loss in the driver.

Jesse make the sign usage more consistent in the driver by making sure
all instances of vf_id are unsigned, since it can never be negative.

Eric fixes a potential memory leak in ice_add_prof_id_vsig() where was
not cleaning up resources properly when an error occurs.

Michal to help organize the filtering code in the driver, refactor the
code into a separate file and add functions to prepare the filter
information.

Bruce cleaned up a conditional statement that always resulted in true
and provided a comment to make it more obvious.  Also cleaned up
redundant code checks.

Tony helps with potential namespace issues by renaming a 'ice' specific
function with the driver name prepended.

The following are changes since commit 2a330b533462bea0967e723ff12787daa5a608f8:
  Merge branch 'provide-KAPI-for-SQI'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Fix probe/open race condition

Avinash JD (1):
  ice: Don't reset and rebuild for Tx timeout on PFC enabled queue

Brett Creeley (1):
  ice: Add VF promiscuous support

Bruce Allan (3):
  ice: remove unnecessary expression that is always true
  ice: remove unnecessary check
  ice: remove unnecessary backslash

Dave Ertman (2):
  ice: Fix check for contiguous TCs
  ice: only drop link once when setting pauseparams

Eric Joyner (1):
  ice: Fix resource leak on early exit from function

Jacob Keller (1):
  ice: report netlist version in .info_get

Jesse Brandeburg (1):
  ice: cleanup vf_id signedness

Karol Kolacinski (1):
  ice: Fix casting issues

Lihong Yang (2):
  ice: Provide more meaningful error message
  ice: Fix check for removing/adding mac filters

Michal Swiatkowski (1):
  ice: refactor filter functions

Tony Nguyen (2):
  ice: Add support for tunnel offloads
  ice: Rename build_ctob to ice_build_ctob

 Documentation/networking/devlink/ice.rst      |  11 +
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |  19 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  29 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  32 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   2 +
 drivers/net/ethernet/intel/ice/ice_controlq.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  77 ++-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  23 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  23 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  85 +--
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 539 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   5 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |  33 ++
 drivers/net/ethernet/intel/ice/ice_flow.c     |  36 +-
 drivers/net/ethernet/intel/ice/ice_flow.h     |   3 +
 drivers/net/ethernet/intel/ice/ice_fltr.c     | 397 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_fltr.h     |  39 ++
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   1 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  25 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 340 +++--------
 drivers/net/ethernet/intel/ice/ice_lib.h      |   9 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 385 ++++++++++---
 drivers/net/ethernet/intel/ice/ice_nvm.c      |  86 +++
 .../ethernet/intel/ice/ice_protocol_type.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_sched.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  12 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 154 ++++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   3 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  27 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |   4 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |  21 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 281 +++++++--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   8 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   4 +-
 35 files changed, 2213 insertions(+), 506 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fltr.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fltr.h

-- 
2.26.2

