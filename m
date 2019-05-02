Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C29C115FE
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfEBJGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:47592 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfEBJGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615327"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2019-05-02
Date:   Thu,  2 May 2019 02:06:05 -0700
Message-Id: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Anirudh introduces the framework to store queue specific information in
the VSI queue contexts.  This will allow future changes to update the
structure to hold queue specific information.

Akeem adds additional check so that if there is no queue to disable when
attempting to disable a queue, return a configuration error without
acquiring the lock.  Fixed an issue with non-trusted VFs being able to
add more than the permitted number of VLANs.

Bruce removes unreachable code and updated the function to return void
since it would never return anything but success.

Brett provides most of the changes in the series, starting with reducing
the scope of the error variable used and improved the debug message if
we fail to configure the receive queue.  Updates the driver to use a
macro instead of using the same 'for' loop throughout the driver which
helps with readability.  Fixed an issue where users were led to believe
they could set rx-usecs-high value, yet the changes to this value would
not stick because it was not yet implemented to allow changes to this
value, so implement the missing code to change the value.  Found we had
unnecessary wait when disabling queues, so remove it.  I,proved a
wasteful addition operation in our hot path by adding a member to the
ice_q_vector structure and the necessary changes to use the member which
stores the calculated vector hardware index.  Refactored the link event
flow to make it cleaner and more clear.

Maciej updates the array index when stopping transmit rings, so that
process every ring the VSI, not just the rings in a given transmit
class.

Paul adds support for setting 52 byte RSS hash keys.

Md Fahad cleaned up a runtime change to the PFINT_OICR_ENA register,
since the interrupt handlers will handle resetting the bit, if
necessary.

Tony adds a missing PHY type, which was causing warning message about an
unrecognized PHY.

The following are changes since commit f76c4b571feea8eb03184d8ba0ee45f98fff47ff:
  Merge branch 'net-mvpp2-cls-Add-classification'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (2):
  ice: Return configuration error without queue to disable
  ice: Fix issue when adding more than allowed VLANs

Anirudh Venkataramanan (1):
  ice: Create framework for VSI queue context

Brett Creeley (7):
  ice: Reduce scope of variable in ice_vsi_cfg_rxqs
  ice: Use ice_for_each_q_vector macro where possible
  ice: Add ability to update rx-usecs-high
  ice: Remove unnecessary wait when disabling/enabling Rx queues
  ice: Add reg_idx variable in ice_q_vector structure
  ice: Refactor link event flow
  ice: Use dev_err when ice_cfg_vsi_lan fails

Bruce Allan (1):
  ice: Resolve static analysis reported issue

Maciej Fijalkowski (1):
  ice: Validate ring existence and its q_vector per VSI

Md Fahad Iqbal Polash (1):
  ice: Remove runtime change of PFINT_OICR_ENA register

Paul Greenwalt (1):
  ice: Add 52 byte RSS hash key support

Tony Nguyen (1):
  ice: Add missing PHY type to link settings

 drivers/net/ethernet/intel/ice/ice.h          |  23 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  91 +++++--
 drivers/net/ethernet/intel/ice/ice_common.h   |  11 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  32 ++-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 248 ++++++++++++------
 drivers/net/ethernet/intel/ice/ice_lib.h      |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 129 ++++-----
 drivers/net/ethernet/intel/ice/ice_sched.c    |  54 +++-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  22 ++
 drivers/net/ethernet/intel/ice/ice_switch.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   1 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  30 +--
 14 files changed, 448 insertions(+), 208 deletions(-)

-- 
2.20.1

