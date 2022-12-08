Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AC7647819
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 22:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiLHVjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 16:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiLHVjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 16:39:40 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867B6A1A7
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 13:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670535579; x=1702071579;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KD4ai2f3/mQQuci1l5YQz4WDyMQ8SbbPcNThZuy7bmY=;
  b=oDLuyZYTti+Ey5UxKUtKhwIjchM3gtIQz810RPl+RtpES0mmU1nwkGAd
   2Tg80iUTMqIL3Wv6vP2XhUa6kvqkP34anMg4OfgA/nW5gtGUYSXjYFY3T
   /HUbAN0g+gYeANsB5esRsmRl1R6e7nsbYq6b6HDj5As9bt2yu97HM5tFC
   C/vNv3ug24CiiY7ecZ7Fd4qBqAHya8DlZ6qjZuEQam5EledXM0Ip80zsc
   izZ6B3I5OSVvv7MfqAbKYT6uFWSnwRPQQegmO9iVT0Qt+S2Xa5e0uXOS9
   vVKgvq3AS+l1Uo8AxIUwK3WbceJt529cmq6prZsGLhm793uVeCr2+3yYc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="317328151"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="317328151"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:39:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="624873967"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="624873967"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 08 Dec 2022 13:39:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jacob.e.keller@intel.com, richardcochran@gmail.com,
        leon@kernel.org, saeed@kernel.org
Subject: [PATCH net-next v3 00/14][pull request] Intel Wired LAN Driver Updates 2022-12-08 (ice)
Date:   Thu,  8 Dec 2022 13:39:18 -0800
Message-Id: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob Keller says:

This series of patches primarily consists of changes to fix some corner
cases that can cause Tx timestamp failures. The issues were discovered and
reported by Siddaraju DH and primarily affect E822 hardware, though this
series also includes some improvements that affect E810 hardware as well.

The primary issue is regarding the way that E822 determines when to generate
timestamp interrupts. If the driver reads timestamp indexes which do not
have a valid timestamp, the E822 interrupt tracking logic can get stuck.
This is due to the way that E822 hardware tracks timestamp index reads
internally. I was previously unaware of this behavior as it is significantly
different in E810 hardware.

Most of the fixes target refactors to ensure that the ice driver does not
read timestamp indexes which are not valid on E822 hardware. This is done by
using the Tx timestamp ready bitmap register from the PHY. This register
indicates what timestamp indexes have outstanding timestamps waiting to be
captured.

Care must be taken in all cases where we read the timestamp registers, and
thus all flows which might have read these registers are refactored. The
ice_ptp_tx_tstamp function is modified to consolidate as much of the logic
relating to these registers as possible. It now handles discarding stale
timestamps which are old or which occurred after a PHC time update. This
replaces previously standalone thread functions like the periodic work
function and the ice_ptp_flush_tx_tracker function.

In addition, some minor cleanups noticed while writing these refactors are
included.

The remaining patches refactor the E822 implementation to remove the
"bypass" mode for timestamps. The E822 hardware has the ability to provide a
more precise timestamp by making use of measurements of the precise way that
packets flow through the hardware pipeline. These measurements are known as
"Vernier" calibration. The "bypass" mode disables many of these measurements
in favor of a faster start up time for Tx and Rx timestamping. Instead, once
these measurements were captured, the driver tries to reconfigure the PHY to
enable the vernier calibrations.

Unfortunately this recalibration does not work. Testing indicates that the
PHY simply remains in bypass mode without the increased timestamp precision.
Remove the attempt at recalibration and always use vernier mode. This has
one disadvantage that Tx and Rx timestamps cannot begin until after at least
one packet of that type goes through the hardware pipeline. Because of this,
further refactor the driver to separate Tx and Rx vernier calibration.
Complete the Tx and Rx independently, enabling the appropriate type of
timestamp as soon as the relevant packet has traversed the hardware
pipeline. This was reported by Milena Olech.

Note that although these might be considered "bug fixes", the required
changes in order to appropriately resolve these issues is large. Thus it
does not feel suitable to send this series to net.
---
v3:
- Dropped patch 'ice: disable Tx timestamps while link is down'
- Use bitmap_or function over for_each_set_bit
- Change incorrect function name (ice_ptp_tstamp_tx()) to correct one
(ice_ptp_tx_tstamp()) in patch 9 commit message

v2: https://lore.kernel.org/netdev/20221207210937.1099650-1-anthony.l.nguyen@intel.com/
- Dropped incorrect/useless locking around init in ice_ptp_tx_tstamp
- Added patch to call sychronize_irq during teardown of Tx tracker
- Renamed and refactored "ts_handled" into "more_timestamps" for clarity
- Moved all initialization of Tx tracker to before spin_lock_init
- Initialize raw_stamp to 0 and add check that it has been set

v1: https://lore.kernel.org/netdev/20221130194330.3257836-1-anthony.l.nguyen@intel.com/

The following are changes since commit bde55dd9ccda7a3f5f735d89e855691362745248:
  net: dsa: microchip: add stats64 support for ksz8 series of switches
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (10):
  ice: fix misuse of "link err" with "link status"
  ice: always call ice_ptp_link_change and make it void
  ice: handle discarding old Tx requests in ice_ptp_tx_tstamp
  ice: check Tx timestamp memory register for ready timestamps
  ice: synchronize the misc IRQ when tearing down Tx tracker
  ice: protect init and calibrating check in ice_ptp_request_ts
  ice: cleanup allocations in ice_ptp_alloc_tx_tracker
  ice: handle flushing stale Tx timestamps in ice_ptp_tx_tstamp
  ice: only check set bits in ice_ptp_flush_tx_tracker
  ice: reschedule ice_ptp_wait_for_offset_valid during reset

Karol Kolacinski (1):
  ice: Reset TS memory for all quads

Milena Olech (1):
  ice: Remove the E822 vernier "bypass" logic

Sergey Temerkhanov (1):
  ice: Use more generic names for ice_ptp_tx fields

Siddaraju DH (1):
  ice: make Tx and Rx vernier offset calibration independent

 drivers/net/ethernet/intel/ice/ice_main.c   |   9 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c    | 546 ++++++++++----------
 drivers/net/ethernet/intel/ice/ice_ptp.h    |  39 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 336 ++++++------
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h |   8 +-
 5 files changed, 463 insertions(+), 475 deletions(-)

-- 
2.35.1

