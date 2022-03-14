Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33FCB4D8B5B
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241807AbiCNSLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiCNSLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39FE11171
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281394; x=1678817394;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NPy2NfJwp88uTQi0DvrN3cioCvNTz5T6d21lOmwhvVE=;
  b=E8i/TIJfMFR4cgaHvpL/NDP5aBnWQuiIl5h/hNkyGBP4bIKMPdsNzZLk
   21K/TLEZhVh6Fpad7Ak+3G0X7LNaWeFN3ZutaR6piYXvL4ijUqsJLm8Gv
   XptE3qVLvosE4HNm48o5FzNFpy8StFpplWWulpwerXUQRRhUuoWCjwuCE
   K3UfuH4Nl34P7BZV6k6h7nqLc0196ryN74S/3veC+EJdGPzO3lNuizwfj
   9BsdM+BjlNZKP2pR/xzRbbHU0ZxIOsxp+cacszDGuflugRMoEDBF1krWC
   pB4szQH4SrXMEE7PrAPsvc7zHdNrNTjuGSpI7ezDNhh1CIua6o9liaveJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275337"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275337"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:09:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297444"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:09:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
Subject: [PATCH net-next 00/25][pull request] 100GbE Intel Wired LAN Driver Updates 2022-03-14
Date:   Mon, 14 Mar 2022 11:09:51 -0700
Message-Id: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob Keller says:

The ice_virtchnl_pf.c file has become a single place for a lot of
virtualization functionality. This includes most of the virtchnl message
handling, integration with kernel hooks like the .ndo operations, reset
logic, and more.

We are planning in the future to implement and support Scalable IOV in the
ice driver. To do this, much (but not all) of the code in ice_virtchnl_pf.c
will want to be reused.

Rather than dump all of the Scalable IOV implementation into
ice_virtchnl_pf.c it makes sense to house it in a separate file. But that
still leaves all of the Single Root IOV code littered among more generic
logic.

This series reorganizes code to make the non-implementation specific bits
into new files with the following general guidelines:

 * ice_vf_lib.[ch]

   Basic VF structures and accessors. This is where scheme-independent
   code will reside.

 * ice_virtchnl.[ch]

   Virtchnl message handling. This is where the bulk of the logic for
   processing messages from VFs using the virtchnl messaging scheme will
   reside. This is separated from ice_vf_lib.c because it is distinct
   and has a bulk of the processing code.

 * ice_sriov.[ch]

   Single Root IOV implementation, including initialization and the
   routines for interacting with SR-IOV based netdev operations.

 * (future) ice_siov.[ch]

   Scalable IOV implementation.

The goal is to make it easier to re-use parts of the virtualization logic
while separating concerns such as Single Root specific implementation
details.

In addition, this series has several minor cleanups and refactors we've
accumulated during this development cycle which help prepare the ice driver
for the Scalable IOV implementation.

This series builds on top of the recent hash table refactor work.

The following are changes since commit 5e7350e8a618ebfea0713b30986976fcbb90b8bb:
  Merge branch 'dpaa2-mac-protocol-change'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (25):
  ice: rename ice_sriov.c to ice_vf_mbx.c
  ice: rename ice_virtchnl_pf.c to ice_sriov.c
  ice: remove circular header dependencies on ice.h
  ice: convert vf->vc_ops to a const pointer
  ice: remove unused definitions from ice_sriov.h
  ice: rename ICE_MAX_VF_COUNT to avoid confusion
  ice: refactor spoofchk control code in ice_sriov.c
  ice: move ice_set_vf_port_vlan near other .ndo ops
  ice: cleanup error logging for ice_ena_vfs
  ice: log an error message when eswitch fails to configure
  ice: use ice_is_vf_trusted helper function
  ice: introduce ice_vf_lib.c, ice_vf_lib.h, and ice_vf_lib_private.h
  ice: fix incorrect dev_dbg print mistaking 'i' for vf->vf_id
  ice: introduce VF operations structure for reset flows
  ice: fix a long line warning in ice_reset_vf
  ice: move reset functionality into ice_vf_lib.c
  ice: drop is_vflr parameter from ice_reset_all_vfs
  ice: make ice_reset_all_vfs void
  ice: convert ice_reset_vf to standard error codes
  ice: convert ice_reset_vf to take flags
  ice: introduce ICE_VF_RESET_NOTIFY flag
  ice: introduce ICE_VF_RESET_LOCK flag
  ice: cleanup long lines in ice_sriov.c
  ice: introduce ice_virtchnl.c and ice_virtchnl.h
  ice: remove PF pointer from ice_check_vf_init

 drivers/net/ethernet/intel/ice/Makefile       |    6 +-
 drivers/net/ethernet/intel/ice/ice.h          |    5 +-
 drivers/net/ethernet/intel/ice/ice_arfs.h     |    3 +
 drivers/net/ethernet/intel/ice/ice_base.c     |    2 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |    4 +-
 drivers/net/ethernet/intel/ice/ice_dcb.h      |    1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |    1 +
 drivers/net/ethernet/intel/ice/ice_flow.c     |    1 +
 drivers/net/ethernet/intel/ice/ice_flow.h     |    2 +
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |    1 -
 drivers/net/ethernet/intel/ice/ice_main.c     |   25 +-
 drivers/net/ethernet/intel/ice/ice_osdep.h    |   11 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |    6 +-
 drivers/net/ethernet/intel/ice/ice_repr.h     |    1 -
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 2205 ++++-
 drivers/net/ethernet/intel/ice/ice_sriov.h    |  163 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 1029 +++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  290 +
 .../ethernet/intel/ice/ice_vf_lib_private.h   |   40 +
 .../intel/ice/{ice_sriov.c => ice_vf_mbx.c}   |    2 +-
 .../intel/ice/{ice_sriov.h => ice_vf_mbx.h}   |    6 +-
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  |    2 +-
 .../ice/{ice_virtchnl_pf.c => ice_virtchnl.c} | 8086 ++++++-----------
 drivers/net/ethernet/intel/ice/ice_virtchnl.h |   82 +
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |    1 +
 .../ethernet/intel/ice/ice_virtchnl_fdir.h    |    1 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  437 -
 drivers/net/ethernet/intel/ice/ice_xsk.h      |    1 -
 29 files changed, 6057 insertions(+), 6358 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_lib.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_lib.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
 copy drivers/net/ethernet/intel/ice/{ice_sriov.c => ice_vf_mbx.c} (99%)
 copy drivers/net/ethernet/intel/ice/{ice_sriov.h => ice_vf_mbx.h} (95%)
 rename drivers/net/ethernet/intel/ice/{ice_virtchnl_pf.c => ice_virtchnl.c} (57%)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl.h
 delete mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h

-- 
2.31.1

