Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80F1179C54
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbgCDXVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:21:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:59250 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387931AbgCDXVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 18:21:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 15:21:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244094607"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 15:21:37 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/16][pull request] 100GbE Intel Wired LAN Driver Updates 2020-03-04
Date:   Wed,  4 Mar 2020 15:21:20 -0800
Message-Id: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice and iavf drivers.

Cleaned up unnecessary parenthesis, which was pointed out by Sergei
Shtylyov.

Mitch updates the iavf and ice drivers to expand the limitation on the
number of queues that the driver can support to account for the newer
800-series capabilities.

Brett cleans up the error messages for both SR-IOV and non SR-IOV use
cases.  Fixed the logic when the ice driver is removed and a bare-metal
VF is passing traffic, which was causing a transmit hang on the VF.
Updated the ice driver to display "Link detected" field via ethtool,
when the driver is in safe mode.  Updated ice driver to properly set
VLAN pruning when transmit anti-spoof is off.

Tony adds support for tunnel offloads in the ice driver.

Avinash fixed a corner case in DCB, when switching from IEEE to CEE
mode, the DCBX mode does not get properly updated.

Dave updates the logic when switching from software DCB to firmware DCB
to renegotiate DCBX to ensure the firmware agent has up to date
information about the DCB settings of the link partner.

Lukasz increases the PF's mailbox receive queue size to the maximum to
prevent potential bottleneck or slow down occurring from the PF's
mailbox receive queue being full.

Bruce updates the ice driver to use strscpy() instead of strlcpy().
Cleaned up variable names that were not very descriptive with names that
had more meaning.

Anirudh replaces the use of ENOTSUPP with EOPNOTSUPP in the ice driver.

Jake fixed up a function header comment to properly reflect the variable
size and use.

The following are changes since commit e7c298854a04cf1d0b8d125e4dc5d14d7c2aba4c:
  Merge branch 'PCI-Add-and-use-constant-PCI_STATUS_ERROR_BITS-and-helper-pci_status_get_and_clear_errors'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Use EOPNOTSUPP instead of ENOTSUPP

Avinash JD (1):
  ice: Fix corner case when switching from IEEE to CEE

Brett Creeley (4):
  ice: Improve clarity of prints and variables
  ice: Fix removing driver while bare-metal VFs pass traffic
  ice: Display Link detected via Ethtool in safe mode
  ice: Correct setting VLAN pruning

Bruce Allan (2):
  ice: fix use of deprecated strlcpy()
  ice: use variable name more descriptive than type

Dave Ertman (1):
  ice: renegotiate link after FW DCB on

Jacob Keller (1):
  ice: fix incorrect size description of ice_get_nvm_version

Jeff Kirsher (1):
  ice: Cleanup unneeded parenthesis

Lukasz Czapnik (1):
  ice: Increase mailbox receive queue length to maximum

Mitch Williams (2):
  iavf: Enable support for up to 16 queues
  ice: allow bigger VFs

Tony Nguyen (2):
  ice: Add support for tunnel offloads
  ice: Fix format specifier

 drivers/net/ethernet/intel/iavf/iavf.h        |   2 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  20 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |   2 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  27 -
 drivers/net/ethernet/intel/ice/ice.h          |  11 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  23 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  60 ++-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 477 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   5 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |  32 ++
 drivers/net/ethernet/intel/ice/ice_flow.c     |  44 +-
 drivers/net/ethernet/intel/ice/ice_flow.h     |   3 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  25 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 243 ++++-----
 drivers/net/ethernet/intel/ice/ice_lib.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 123 ++++-
 .../ethernet/intel/ice/ice_protocol_type.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |  20 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 126 ++++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   3 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  21 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 330 ++++++------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  15 +-
 drivers/net/ethernet/intel/ice/ice_xsk.h      |   4 +-
 26 files changed, 1216 insertions(+), 412 deletions(-)

-- 
2.24.1

