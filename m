Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1658D602BE1
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiJRMhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJRMhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:37:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B4DABF3E
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666096660; x=1697632660;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y59pKnKQCE2ZRwII+nA+NrHLxh8VxLzHHLq+ks61PAc=;
  b=f+SofxgMJ6zLwEIxVBw7/CIQpEa/U/v4OP9maFdi4kAsgGKcXjyCaBgj
   1kAkgmiYcrTP61S5eIvitdQBxR23vrV3W8TDzr4EH14EmFLMPjh1Zn2/s
   xaVrPdRO87zXR+mzlpN98vWywo9IL1hEZutb3E1LSXEq0Qhc5okFhO0hL
   SXE6zCAoJiJsq/KPhLQOD+LjTjl0FSIeyT6n1RbEAYce1tBQ4n+TRAy+k
   4ZgzDB3PbRUtFPPKXK3Q5AG84EL72ZRCxeGN1TsCdSWKGFb6FSx7cYI1C
   po3JRWFszWpJrUy/fnj+YyHhitJSr/4haEzu1ufe0YDb3uF9YwBjmQrlj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="370288619"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="370288619"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:37:39 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="957751982"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="957751982"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:37:37 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v6 0/4] Implement devlink-rate API and extend it
Date:   Tue, 18 Oct 2022 14:37:28 +0200
Message-Id: <20221018123728.1210262-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

