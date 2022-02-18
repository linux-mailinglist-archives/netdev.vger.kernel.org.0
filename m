Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFE54BC25E
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbiBRV4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:56:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbiBRV4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:56:11 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F71A53B61
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645221354; x=1676757354;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Yd10rRqabGqjm3UB+60L2K/28BHE+UGx9di5VNOdDXA=;
  b=cHQzJcyIBtg7nZhmLk3o8IELDNX9IjTlDKpxYqDYIsBdVi9sm0CfxL8P
   MdXfDtKBwiipVyR7v1Ftftdyzz0qRKe/ei+jVDt52Yh7DDPDnG6gCqF0I
   RaBWxSZSDelv22e0wp4DTiP/1cylShCtx9jwwfIvVFifbq0wq+UbzxN2d
   YZahRQnQp7unHCrirgyhQ6NbiU1xxRZ+sXUXDB/ndnKGtXFwyIT4X+Nx7
   8qxvpQPwO6a8V1crQAB3UGwLhVB3PSUZuae2RVHVpy92wd7H5VJUKbAl4
   Xas/XjIjwsi5rgUUkzdeK5u3R7LX/IxaKNFlHFPwVQIsxcZLnfo1AQ4Fv
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251179159"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251179159"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:55:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="626757362"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2022 13:55:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2022-02-18
Date:   Fri, 18 Feb 2022 13:55:49 -0800
Message-Id: <20220218215554.415323-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Wojciech fixes protocol matching for slow-path switchdev so that all
packets are correctly redirected.

Michal removes accidental unconditional setting of l4 port filtering
flag.

Jake adds locking to protect VF reset and removal to fix various issues
that can be encountered when they race with each other.

Tom Rix propagates an error and initializes a struct to resolve reported
Clang issues.

The following are changes since commit b352c3465bb808ab700d03f5bac2f7a6f37c5350:
  net: ll_temac: check the return value of devm_kmalloc()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Jacob Keller (1):
  ice: fix concurrent reset and removal of VFs

Michal Swiatkowski (1):
  ice: fix setting l4 port flag when adding filter

Tom Rix (2):
  ice: check the return of ice_ptp_gettimex64
  ice: initialize local variable 'tlv'

Wojciech Drewek (1):
  ice: Match on all profiles in slow-path

 drivers/net/ethernet/intel/ice/ice.h          |  1 -
 drivers/net/ethernet/intel/ice/ice_common.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 +
 .../ethernet/intel/ice/ice_protocol_type.h    |  1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  5 ++-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  4 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  4 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 42 +++++++++++--------
 9 files changed, 39 insertions(+), 23 deletions(-)

-- 
2.31.1

