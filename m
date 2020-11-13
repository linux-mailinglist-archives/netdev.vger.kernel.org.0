Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0442B2762
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgKMVpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:45:01 -0500
Received: from mga06.intel.com ([134.134.136.31]:18954 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgKMVoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:44:55 -0500
IronPort-SDR: 0HjiweyYO8Hgv7EcHDVyiPXWNF8CwSHcRawZiZ5fNPSTtraPpXqUzWeo8HWvM9cuhQeA5JzVgp
 X0McG5d4+BlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232153122"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232153122"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:44:54 -0800
IronPort-SDR: mwre/1kXjainfbatyrl8zvIbsanKdkQ+jF37pJMsoLZbxnGzBdEC0CtAooAvzFK0ckeeZrFe/Y
 ecgVjUovB0WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="532715805"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 13 Nov 2020 13:44:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [net-next v3 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2020-11-13
Date:   Fri, 13 Nov 2020 13:44:14 -0800
Message-Id: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Bruce changes the allocation of ice_flow_prof_params from stack to heap to
avoid excessive stack usage. Corrects a misleading comment and silences a
sparse warning that is not a problem.

Tony renames Flow Director functions to be more generic as their use
is expanded.

Real implements ACL filtering. This expands support of network flow
classification rules for the ethtool ntuple command. ACL filtering will
allow for an ip or port field's optional mask to be specified.

Paul allows for HW initialization to continue if PHY abilities cannot
be obtained.

Jeb removes bypassing FW link override and reading Option ROM and
netlist information for non-E810 devices as this is now available on
other devices.

Nick removes vlan_ena field as this information can be gathered by
checking num_vlan.

Jake combines format strings and debug prints to the same line.

Simon adds a space to fix string concatenation.

v3: Fix email address for DaveM and fix character in cover letter
v2: Expand on commit message for patch 3 to show example usage/commands.
    Reduce number of defensive checks being done.

For now, we'd like to keep these ice_status error codes in the driver as
there are cases where specific codes may translate to specific cases that
must be handled. There is little equivalency between them and POSIX
standard error codes so these cases can be lost by changing them. We are
careful to turn everything into POSIX standard error codes before passing
it to the kernel.

We do understand your feedback on the refactoring pain. We will look into
this in the future.

The following are changes since commit e1d9d7b91302593d1951fcb12feddda6fb58a3c0:
  Merge https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Bruce Allan (3):
  ice: cleanup stack hog
  ice: cleanup misleading comment
  ice: silence static analysis warning

Jacob Keller (1):
  ice: join format strings to same line as ice_debug

Jeb Cramer (2):
  ice: Enable Support for FW Override (E82X)
  ice: Remove gate to OROM init

Nick Nunley (1):
  ice: Remove vlan_ena from vsi structure

Paul M Stillwell Jr (1):
  ice: don't always return an error for Get PHY Abilities AQ command

Real Valiquette (5):
  ice: initialize ACL table
  ice: initialize ACL scenario
  ice: create flow profile
  ice: create ACL entry
  ice: program ACL entry

Simon Perron Caissy (1):
  ice: Add space to unknown speed

Tony Nguyen (1):
  ice: rename shared Flow Director functions

 drivers/net/ethernet/intel/ice/Makefile       |    3 +
 drivers/net/ethernet/intel/ice/ice.h          |   26 +-
 drivers/net/ethernet/intel/ice/ice_acl.c      |  482 +++++++
 drivers/net/ethernet/intel/ice/ice_acl.h      |  188 +++
 drivers/net/ethernet/intel/ice/ice_acl_ctrl.c | 1145 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_acl_main.c |  328 +++++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  400 +++++-
 drivers/net/ethernet/intel/ice/ice_common.c   |  108 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c |   42 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |    8 +-
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  448 ++++--
 drivers/net/ethernet/intel/ice/ice_fdir.c     |   15 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h     |    5 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   40 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |    7 +
 drivers/net/ethernet/intel/ice/ice_flow.c     | 1253 ++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_flow.h     |   38 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |    3 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   10 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   70 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |   61 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |   21 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   15 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |    5 +
 24 files changed, 4355 insertions(+), 366 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl_main.c

-- 
2.26.2

