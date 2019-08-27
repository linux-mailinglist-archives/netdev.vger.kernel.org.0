Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E419F057
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbfH0Qie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:38:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:7283 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbfH0Qie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876326"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2019-08-26
Date:   Tue, 27 Aug 2019 09:38:17 -0700
Message-Id: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Usha fixes the statistics reported on 4 port NICs which were reporting
the incorrect statistics due to using the incorrect port identifier.

Victor fixes an issue when trying to traverse to the first node of a
requested layer by adding a sibling head pointer for each layer per
traffic class.

Anirudh cleans up the locking and logic for enabling and disabling
VSI's to make it more consistent.  Updates the driver to do dynamic
allocation of queue management bitmaps and arrays, rather than
statically allocating them which consumes more memory than required.
Refactor the logic in ice_ena_msix_range() for clarity and add
additional checks for when requested resources exceed what is available.

Jesse updates the debugging print statements to make it more useful when
dealing with link and PHY related issues.

Krzysztof adds a local variable to the VSI rebuild path to improve
readability.

Akeem limits the reporting of MDD events from VFs so that the kernel
log is not clogged up with MDD events which are duplicate or potentially
false positives.  Fixed a reset issue that would result in the system
getting into a state that could only be resolved by a reboot by
testing if the VF is in a disabled state during a reset.

Michal adds a check to avoid trying to access memory that has not be
allocated by checking the number of queue pairs.

Jake fixes a static analysis warning due to a cast of a u8 to unsigned
long, so just update ice_is_tc_ena() to take a unsigned long so that a
cast is not necessary.

Colin Ian King fixes a potential infinite loop where a u8 is being
compared to an int.

Maciej refactors the queue handling functions that work on queue arrays
so that the logic can be done for a single queue.

Paul adds support for VFs to enable and disable single queues.

Henry fixed the order of operations in ice_remove() which was trying to
use adminq operations that were already disabled.

The following are changes since commit d00ee466a07eb9182ad3caf6140c7ebb527b4c64:
  nfp: add AMDA0058 boards to firmware list
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (2):
  ice: Don't clog kernel debug log with VF MDD events errors
  ice: Fix VF configuration issues due to reset

Anirudh Venkataramanan (3):
  ice: Sanitize ice_ena_vsi and ice_dis_vsi
  ice: Alloc queue management bitmaps and arrays dynamically
  ice: Rework ice_ena_msix_range

Colin Ian King (1):
  ice: fix potential infinite loop

Henry Tieman (1):
  ice: fix adminq calls during remove

Jacob Keller (1):
  ice: fix ice_is_tc_ena

Jesse Brandeburg (1):
  ice: shorten local and add debug prints

Krzysztof Kazimierczak (1):
  ice: Introduce a local variable for a VSI in the rebuild path

Maciej Fijalkowski (1):
  ice: add support for enabling/disabling single queues

Michal Swiatkowski (1):
  ice: add validation in OP_CONFIG_VSI_QUEUES VF message

Paul Greenwalt (1):
  ice: add support for virtchnl_queue_select.[tx|rx]_queues bitmap

Usha Ketineni (1):
  ice: Fix ethtool port and PFC stats for 4x25G cards

Victor Raj (1):
  ice: added sibling head to parse nodes

 drivers/net/ethernet/intel/ice/ice.h          |  12 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  63 ++-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  13 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 398 +++++++++++-------
 drivers/net/ethernet/intel/ice/ice_lib.h      |  28 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 205 +++++----
 drivers/net/ethernet/intel/ice/ice_sched.c    |  57 +--
 drivers/net/ethernet/intel/ice/ice_type.h     |   6 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 279 ++++++++----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  14 +-
 10 files changed, 688 insertions(+), 387 deletions(-)

-- 
2.21.0

