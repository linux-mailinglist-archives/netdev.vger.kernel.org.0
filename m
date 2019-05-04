Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4119413C56
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfEDXyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:54:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:17449 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfEDXya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 19:54:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 16:49:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="139994638"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2019 16:49:29 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2019-05-04
Date:   Sat,  4 May 2019 16:49:14 -0700
Message-Id: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Jesse updated the driver to make more functions consistent in their use
of a local variable for vsi->back.  Updates the driver to use bit fields
when possible to avoid wasting lots of storage space to store single bit
values.  Optimized the driver to be more memory efficient by moving
structure members around that are not in are hot path.

Michal updates the driver to disable the VF if malicious device driver
(MDD) event is detected by the hardware.  Adds checks to validate the
messages coming from the VF driver.  Tightens up the sniffing of the
driver so that transmit traffic so that VF's cannot see what is on other
VSIs.

Tony fixed the driver so that receive stripping state won't change every
time transmit insertion is changed.  Cleanup the __always_unused
attribute, now that the variable is being used.  Fixed the function
which evaluates setting of features to ensure that can evaluate and set
multiple features in a single function call.

Akeem fixes the driver so that we do not attempt to remove a VLAN filter
that does not exist.  Adds support for adding a ethertype based filter
rule on VSI and describe it in a very long run-on sentence. :-)

Bruce cleans up static analysis warnings by removing a local variable
initialization that is not needed.

Brett makes the allocate/deallocate more consistent in all the driver
flows for VSI q_vectors.  In addition, makes setting/getting coalesce
settings more consistent throughout the driver.

The following are changes since commit a734d1f4c2fc962ef4daa179e216df84a8ec5f84:
  net: openvswitch: return an error instead of doing BUG_ON()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (2):
  ice: Don't remove VLAN filters that were never programmed
  ice: Add function to program ethertype based filter rule on VSIs

Brett Creeley (2):
  ice: Always free/allocate q_vectors
  ice: Refactor getting/setting coalesce

Bruce Allan (2):
  ice: Do not unnecessarily initialize local variable
  ice: Suppress false-positive style issues reported by static analyzer

Jesse Brandeburg (3):
  ice: Use pf instead of vsi-back
  ice: Use bitfields where possible
  ice: Use more efficient structures

Michal Swiatkowski (3):
  ice: Fix for allowing too many MDD events on VF
  ice: Add more validation in ice_vc_cfg_irq_map_msg
  ice: Disable sniffing VF traffic on PF

Tony Nguyen (3):
  ice: Preserve VLAN Rx stripping settings
  ice: Remove __always_unused attribute
  ice: Separate if conditions for ice_set_features()

 drivers/net/ethernet/intel/ice/ice.h          |   4 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 154 ++++++++------
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 191 ++++++++++++------
 drivers/net/ethernet/intel/ice/ice_main.c     |  47 ++---
 drivers/net/ethernet/intel/ice/ice_switch.c   |  59 ++++++
 drivers/net/ethernet/intel/ice/ice_switch.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   1 +
 drivers/net/ethernet/intel/ice/ice_type.h     |  10 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  38 ++--
 12 files changed, 339 insertions(+), 179 deletions(-)

-- 
2.20.1

