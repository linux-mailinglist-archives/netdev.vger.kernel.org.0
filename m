Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21958426031
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhJGXKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:10:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:53016 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhJGXKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 19:10:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="207199655"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="207199655"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 16:08:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="590344304"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2021 16:08:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com
Subject: [PATCH net-next 00/12][pull request] 100GbE Intel Wired LAN Driver Updates 2021-10-07
Date:   Thu,  7 Oct 2021 16:06:08 -0700
Message-Id: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal Swiatkowski says:

The following patch series introduces basic switchdev model
support in ice driver. Implement the following blocks of
switchdev framework:
- VF port representors creation
- control plane VSI definition
- exception path (a. k. a. "slow-path") - to allow a virtual
switch or linux bridge to receive any packet that doesn't match
any hw filter
- link state management of virtual ports
- query virtual port statistics

Hardware offload support in switchdev mode is out of scope of
this patchset. Devlink interface is used to toggle between
switchdev and legacy (the default) modes of the driver.

---
Note: This series includes the use enum ice_status, however, we have
patches in our queue to remove it from the driver [1]. We are working
through the patches that precede the removal series.

[1] https://patchwork.ozlabs.org/project/intel-wired-lan/list/?series=265957

The following are changes since commit c514fbb6231483b05c97eb22587188d4c453b28e:
  ethernet: ti: cpts: Use devm_kcalloc() instead of devm_kzalloc()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Grzegorz Nitka (5):
  ice: set and release switchdev environment
  ice: introduce new type of VSI for switchdev
  ice: enable/disable switchdev when managing VFs
  ice: rebuild switchdev when resetting all VFs
  ice: switchdev slow path

Michal Swiatkowski (5):
  ice: support basic E-Switch mode control
  ice: introduce VF port representor
  ice: allow process VF opcodes in different ways
  ice: manage VSI antispoof and destination override
  ice: allow changing lan_en and lb_en on dflt rules

Wojciech Drewek (2):
  ice: Move devlink port to PF/VF struct
  ice: add port representor ethtool ops and stats

 drivers/net/ethernet/intel/Kconfig            |  14 +
 drivers/net/ethernet/intel/ice/Makefile       |   4 +-
 drivers/net/ethernet/intel/ice/ice.h          |  48 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  36 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   5 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 112 ++-
 drivers/net/ethernet/intel/ice/ice_devlink.h  |   6 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  | 657 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_eswitch.h  |  83 +++
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  55 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c     |  80 +++
 drivers/net/ethernet/intel/ice/ice_fltr.h     |   7 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  43 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      | 112 ++-
 drivers/net/ethernet/intel/ice/ice_lib.h      |  12 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  47 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     | 333 +++++++++
 drivers/net/ethernet/intel/ice/ice_repr.h     |  28 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_switch.h   |   6 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   3 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   4 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 236 ++++++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  59 ++
 25 files changed, 1899 insertions(+), 94 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_repr.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_repr.h

-- 
2.31.1

