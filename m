Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85E968C8E6
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjBFVsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBFVsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:48:54 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A519A10A94
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720132; x=1707256132;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0EYA6R7FiyhtVqWR0yS3Q6ZLu5mxs/XjCLOTAkm5mtM=;
  b=dKgXC/c9MbIIPJsHMqRAHL9igvkaBpw5BMC55TaN6NM1i1M0GBrFUaKS
   6l3tscOyPLKAn9yHGT1pl/kAiKlmL8amzkoJ96VDTh8LwuMRmNmmN0bZ1
   IXN83MT6w98JTmPWGDrs+33OLWZQrgw3asBLeDegscdrXaS0taX3ng4Ea
   7woETo4wRh6CKe6+8cwypY1arMPkahhW0DVIwDDX6AemZ7hTgRVB1V1Mu
   uT6pfq5R1QqYjCeWHzSLtUkQpSKDfZrMsnlujS/cxe6xYNGca9KWxocU2
   jljwFd996+kXfM0iTWipm/M8X/1qZTBYVvLbGY3jOZRLpWhmBD9Ra9xUu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338084"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338084"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576177"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576177"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:32 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
Subject: [PATCH net-next 00/13][pull request] ice: various virtualization cleanups
Date:   Mon,  6 Feb 2023 13:48:00 -0800
Message-Id: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob Keller says:

This series contains a variety of refactors and cleanups in the VF code for
the ice driver. Its primary focus is cleanup and simplification of the VF
operations and addition of a few new operations that will be required by
Scalable IOV, as well as some other refactors needed for the handling of VF
subfunctions.

The following are changes since commit c21adf256f8dcfbc07436d45be4ba2edf7a6f463:
  Merge branch 'tuntap-socket-uid'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Brett Creeley (1):
  ice: Add more usage of existing function ice_get_vf_vsi(vf)

Jacob Keller (12):
  ice: fix function comment referring to ice_vsi_alloc
  ice: drop unnecessary VF parameter from several VSI functions
  ice: refactor VSI setup to use parameter structure
  ice: move vsi_type assignment from ice_vsi_alloc to ice_vsi_cfg
  ice: move ice_vf_vsi_release into ice_vf_lib.c
  ice: Pull common tasks into ice_vf_post_vsi_rebuild
  ice: add a function to initialize vf entry
  ice: introduce ice_vf_init_host_cfg function
  ice: convert vf_ops .vsi_rebuild to .create_vsi
  ice: introduce clear_reset_state operation
  ice: introduce .irq_close VF operation
  ice: remove unnecessary virtchnl_ether_addr struct use

 drivers/net/ethernet/intel/ice/ice_eswitch.c  |  26 ++-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 138 +++++++------
 drivers/net/ethernet/intel/ice/ice_lib.h      |  52 ++++-
 drivers/net/ethernet/intel/ice/ice_main.c     |  42 +++-
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 133 +++++--------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 181 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  12 +-
 .../ethernet/intel/ice/ice_vf_lib_private.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  24 +--
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |   8 +-
 10 files changed, 406 insertions(+), 213 deletions(-)

-- 
2.38.1

