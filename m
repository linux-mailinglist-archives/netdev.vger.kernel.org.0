Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE62135F9A
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388291AbgAIRrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:47:14 -0500
Received: from mga17.intel.com ([192.55.52.151]:61385 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731837AbgAIRrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 12:47:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 09:47:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="254669778"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jan 2020 09:47:13 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net 0/7][pull request] Intel Wired LAN Driver Updates 2020-01-09
Date:   Thu,  9 Jan 2020 09:47:06 -0800
Message-Id: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains fixes to e1000e, igb, ixgbe, ixgbevf, i40e and iavf
drivers.

Brett fixes the validation of the virtchnl queue select bitmaps by
comparing the bitmaps against BIT(I40E_MAX_VF_QUEUES).

Radoslaw removes the limitation of only 10 filter entries for a VF and
allows use of all free RAR entries for the forwarding database, if
needed.

Cambda Zhu fixes the calculation of queue when restoring flow director
filters after resetting the adapter for ixgbe.

Manfred Rudigier fixes the SGMIISFP module discovery for 100FX/LX
modules for igb.

Stefan Assmann fixes iavf where during a VF reset event, MAC filters
were not altered, which could lead to a stale filter when an
administratively set MAC address is forced by the PF.

Adam adds the missing code to set the PHY access flag on X722 devices,
which supports accessing PHY registers with the admin queue command.

Revert a previous commit for e1000e to use "delayed work" which was
causing connections to reset unexpectedly and possible driver crashes.

The following are changes since commit 9546a0b7ce0077d827470f603f2522b845ce5954:
  tipc: fix wrong connect() return code
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 40GbE

Adam Ludkiewicz (1):
  i40e: Set PHY Access flag on X722

Brett Creeley (1):
  i40e: Fix virtchnl_queue_select bitmap validation

Cambda Zhu (1):
  ixgbe: Fix calculation of queue with VFs and flow director on
    interface flap

Jeff Kirsher (1):
  e1000e: Revert "e1000e: Make watchdog use delayed work"

Manfred Rudigier (1):
  igb: Fix SGMII SFP module discovery for 100FX/LX.

Radoslaw Tyl (1):
  ixgbevf: Remove limit of 10 entries for unicast filter list

Stefan Assmann (1):
  iavf: remove current MAC address filter on VF reset

 drivers/net/ethernet/intel/e1000e/e1000.h     |  5 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    | 54 +++++++++----------
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  5 ++
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 22 ++++++--
 drivers/net/ethernet/intel/iavf/iavf.h        |  2 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 17 ++++--
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  3 ++
 drivers/net/ethernet/intel/igb/e1000_82575.c  |  8 +--
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 37 +++++++++----
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  5 --
 11 files changed, 98 insertions(+), 62 deletions(-)

-- 
2.24.1

