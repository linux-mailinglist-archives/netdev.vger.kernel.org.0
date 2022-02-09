Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CB54AFF9B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbiBIV50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:57:26 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbiBIV5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D60E00E596
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644443834; x=1675979834;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XHIQkCOpt4cYEpad8pq86vDbdYuElPd6Fqy5lAr3n30=;
  b=EzZg+97bVJfm7OdcyfqeeZgYZqArq0Oyq2BSfO4r5dJ9ReK/0guhbxXe
   S1gYfSs0zSD8il/vqYgXNgiGFTpsqx8SpHEK/zeeiV0fZCjUFOAGyJ7ZV
   OtO6LzhhZLLhxBC8MtafmdH68olinRIKpAWnTIcEuAOH1MlymMP398WSL
   HpGhlnJyKfZ2m6d49k5uIdSyPIjN9oOyi2ki8Zm9Q7od5MBH2gvSmQnJQ
   qezgQKFubHNZ2GGjEdBAJzaH0J5XCJpa6KAesMnAIpJKUnWhc/2ki0Ced
   r52OI+TeDBwz6fmAUr2AklChoIt77faCNKYF9NvZEaF88Xe61hpGfsBrR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249104084"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249104084"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 13:57:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="601790463"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2022 13:57:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/14][pull request] 100GbE Intel Wired LAN Driver Updates 2022-02-09
Date:   Wed,  9 Feb 2022 13:56:52 -0800
Message-Id: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Brett adds support for QinQ. This begins with code refactoring and
re-organization of VLAN configuration functions to allow for
introduction of VSI VLAN ops to enable setting and calling of
respective operations based on device support of single or double
VLANs. Implementations are added for outer VLAN support.

To support QinQ, the device must be set to double VLAN mode (DVM).
In order for this to occur, the DDP package and NVM must also support
DVM. Functions to determine compatibility and properly configure the
device are added as well as setting the proper bits to advertise and
utilize the proper offloads. Support for VIRTCHNL_VF_OFFLOAD_VLAN_V2
is also included to allow for VF to negotiate and utilize this
functionality.

The following are changes since commit 1710b52d7c135e83ee00ed38afacc1079cbe71f5:
  net: usb: smsc95xx: add generic selftest support
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Brett Creeley (14):
  ice: Refactor spoofcheck configuration functions
  ice: Add helper function for adding VLAN 0
  ice: Add new VSI VLAN ops
  ice: Introduce ice_vlan struct
  ice: Refactor vf->port_vlan_info to use ice_vlan
  ice: Use the proto argument for VLAN ops
  ice: Adjust naming for inner VLAN operations
  ice: Add outer_vlan_ops and VSI specific VLAN ops implementations
  ice: Add hot path support for 802.1Q and 802.1ad VLAN offloads
  ice: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2
  ice: Support configuring the device to Double VLAN Mode
  ice: Advertise 802.1ad VLAN filtering and offloads for PF netdev
  ice: Add support for 802.1ad port VLANs VF
  ice: Add ability for PF admin to enable VF VLAN pruning

 drivers/net/ethernet/intel/ice/Makefile       |   12 +-
 drivers/net/ethernet/intel/ice/ice.h          |    4 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  255 ++-
 drivers/net/ethernet/intel/ice/ice_base.c     |   19 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   49 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |    3 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |    8 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |    9 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |    9 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  291 ++-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   13 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |   40 +
 drivers/net/ethernet/intel/ice/ice_fltr.c     |   37 +-
 drivers/net/ethernet/intel/ice/ice_fltr.h     |   10 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |    2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  380 ++--
 drivers/net/ethernet/intel/ice/ice_lib.h      |   17 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  322 +++-
 drivers/net/ethernet/intel/ice/ice_osdep.h    |    1 +
 .../ethernet/intel/ice/ice_pf_vsi_vlan_ops.c  |   38 +
 .../ethernet/intel/ice/ice_pf_vsi_vlan_ops.h  |   13 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |   80 +
 drivers/net/ethernet/intel/ice/ice_switch.h   |   24 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   28 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |    3 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |    9 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |   30 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   19 +
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  |  202 +++
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.h  |   19 +
 .../intel/ice/ice_virtchnl_allowlist.c        |   10 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 1605 ++++++++++++++---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   17 +-
 drivers/net/ethernet/intel/ice/ice_vlan.h     |   18 +
 .../net/ethernet/intel/ice/ice_vlan_mode.c    |  439 +++++
 .../net/ethernet/intel/ice/ice_vlan_mode.h    |   13 +
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c |  707 ++++++++
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.h |   32 +
 .../net/ethernet/intel/ice/ice_vsi_vlan_ops.c |  103 ++
 .../net/ethernet/intel/ice/ice_vsi_vlan_ops.h |   29 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      |    6 +-
 41 files changed, 4193 insertions(+), 732 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vlan.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vlan_mode.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vlan_mode.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h

-- 
2.31.1

