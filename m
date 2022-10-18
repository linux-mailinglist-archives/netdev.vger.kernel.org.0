Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB82602BD9
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiJRMf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJRMf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:35:57 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36EA76455
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666096556; x=1697632556;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y59pKnKQCE2ZRwII+nA+NrHLxh8VxLzHHLq+ks61PAc=;
  b=ZBgL46BVWQS9lJd1Zs8LI0uCozvQJSiO5hcYKBaVrQVFcdOm9YO5pHNn
   7AeKc2FyKattr1a4ISsISP3NMFhv2SWFXyvWvKpYS7Ngcr6aP4MJCdgZN
   en5p/YJmfSZxeEpyBVaPl6bPnoQQz0wRR8QBvnbR0nmriMvEBJ+VDTAk/
   lzHAkKKixmbeC42VVPLQeC9WIIBSFDrg0ruMnLKhuKkowsV2tgK+vP6E2
   mqzPizUpo84zYW8KLrdICReoGfmvzQgLyOgf0WwzFv+xT18fBrACO67Qw
   SZEDVrV2un3dBGZa+6aSImgIw/tsGGmKuHp478LHBmawJLW5y1lV7uBzF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="293458208"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="293458208"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:35:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="771181196"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="771181196"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:35:53 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v6 0/4] Implement devlink-rate API and extend it
Date:   Tue, 18 Oct 2022 14:35:38 +0200
Message-Id: <20221018123543.1210217-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up on:
https://lore.kernel.org/netdev/20220915134239.1935604-1-michal.wilczynski@intel.com/

This patch series implements devlink-rate for ice driver. Unfortunately
current API isn't flexible enough for our use case, so there is a need to
extend it. Some functions have been introduced to enable the driver to
export current Tx scheduling configuration.

In the previous submission I've made a mistake and didn't remove
internal review comments. To avoid confusion I don't go backwards
in my versioning and submit it as v6.

This is a re-send, because I've send the previous patch during the time
that net-next was closed.
https://lore.kernel.org/netdev/20221011090113.445485-1-michal.wilczynski@intel.com/


V6:
- replaced strncpy with strscpy
- renamed rate_vport -> rate_leaf

V5:
- removed queue support per community request
- fix division of 64bit variable with 32bit divisor by using div_u64()
- remove RDMA, ADQ exlusion as it's not necessary anymore
- changed how driver exports configuration, as queues are not supported
  anymore
- changed IDA to Xarray for unique node identification


V4:
- changed static variable counter to per port IDA to
  uniquely identify nodes

V3:
- removed shift macros, since FIELD_PREP is used
- added static_assert for struct
- removed unnecessary functions
- used tab instead of space in define

V2:
- fixed Alexandr comments
- refactored code to fix checkpatch issues
- added mutual exclusion for RDMA, DCB


Michal Wilczynski (4):
  devlink: Extend devlink-rate api with export functions and new params
  ice: Introduce new parameters in ice_sched_node
  ice: Implement devlink-rate API
  ice: Prevent DCB coexistence with Custom Tx scheduler

 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   4 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   3 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   4 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 467 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
 drivers/net/ethernet/intel/ice/ice_idc.c      |   5 +
 drivers/net/ethernet/intel/ice/ice_repr.c     |  13 +
 drivers/net/ethernet/intel/ice/ice_sched.c    |  79 ++-
 drivers/net/ethernet/intel/ice/ice_sched.h    |  25 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   8 +
 .../mellanox/mlx5/core/esw/devlink_port.c     |   4 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.h |   2 +-
 drivers/net/netdevsim/dev.c                   |  10 +-
 include/net/devlink.h                         |  21 +-
 include/uapi/linux/devlink.h                  |   3 +
 net/core/devlink.c                            | 145 +++++-
 17 files changed, 767 insertions(+), 32 deletions(-)

-- 
2.37.2

