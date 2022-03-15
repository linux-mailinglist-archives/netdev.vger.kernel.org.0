Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A944DA53D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240292AbiCOWXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiCOWXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:23:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7005C649
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647382917; x=1678918917;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OtsyHVbpND8S/nm3lYSe3+jnOXWmThbL8tO6ZPsL4bQ=;
  b=ZTJ/Bt9yQNBLTtDwj07uO/ZhXxEQVoki80aXQdGEgR9ZDEl/GIqpfR45
   52JoTYlaD6k6L2MKQrTFF3yaorCvHYoZrMYOHtiRDkGnkZ0mbY7JQOM0x
   W/jvm5a/U+YER14+zXlL434Qou1c3pTdPX9YkB7ABe4z//OwyMiLsVAt5
   RHVJBVFKVDzlkKiQ32Z+Gy+7s0umbUdd3Z5fbXGtDrfESOfPHhFEaCBNG
   aqQkY8/PsgJLmFoNXXM6SqsApn5fSZI/54Xe14wSot3ENgfvQgtxSuMTE
   fMg+EqKjO9L/uuT5zkeQc8QOwpMJvWRI8CX7WGbEM3a0QIvxeViBoS7D1
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255264542"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="255264542"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:21:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690362198"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 15:21:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
Subject: [PATCH net-next 00/14][pull request] 100GbE Intel Wired LAN Driver Updates 2022-03-15
Date:   Tue, 15 Mar 2022 15:22:06 -0700
Message-Id: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob Keller says:

The ice_sriov.c file now houses almost all of the virtualization code in the
ice driver. This includes both Single Root specific implementation as well
as generic functionality such as the virtchnl interface.

We are planning to implement support for Scalable IOV in the ice driver in
the future. This implementation will want to use the generic functionality
in ice_sriov.c

Rather than dump the Scalable IOV code into ice_sriov.c, we will want to
implement it in a separate file, ice_siov.c

To help with this, refactor the code in ice_sriov.c and split the generic
functionality out into separate files.

Reorganize code to make the non-implementation specific bits into new files
with the following general guidelines:

* ice_vf_lib.[ch]

Basic VF structures and accessors. This is where scheme-independent
code will reside.

* ice_virtchnl.[ch]

Virtchnl message handling. This is where the bulk of the logic for
processing messages from VFs using the virtchnl messaging scheme will
reside. This is separated from ice_vf_lib.c because it is somewhat
distinct and stand alone.

* ice_sriov.[ch]

Single Root IOV implementation, including initialization and the
routines for interacting with SR-IOV based netdev operations.

* (future) ice_siov.[ch]

Scalable IOV implementation.

The end goal is to make it easier to re-use the generic parts of the
virtualization logic while keeping separate the concerns of the Single Root
implementation.

In addition to the pure code moves, this series has a reset refactor which
clean up the functionality to make it easier to reuse the reset code. A new
ops table is introduced to make the VF reset logic more generic. The Single
Root specific details are implemented in ice_sriov.c. A future series
implementing Scalable IOV support will use this ops table to allow re-use of
the reset logic which is now in ice_vf_lib.c

The following are changes since commit c84d86a0295c24487db5b7db1a61d9c0eddfbb66:
  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (14):
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

 drivers/net/ethernet/intel/ice/Makefile       |    4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |    8 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 5718 +-----------
 drivers/net/ethernet/intel/ice/ice_sriov.h    |  273 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 1029 +++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  290 +
 .../ethernet/intel/ice/ice_vf_lib_private.h   |   40 +
 .../intel/ice/{ice_sriov.c => ice_virtchnl.c} | 8170 ++++++-----------
 drivers/net/ethernet/intel/ice/ice_virtchnl.h |   82 +
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |    1 +
 .../ethernet/intel/ice/ice_virtchnl_fdir.h    |    1 +
 11 files changed, 4598 insertions(+), 11018 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_lib.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_lib.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
 copy drivers/net/ethernet/intel/ice/{ice_sriov.c => ice_virtchnl.c} (58%)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl.h

-- 
2.31.1

