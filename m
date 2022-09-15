Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD585B9C2B
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiIONnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiIONnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:43:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967F885F80
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663249432; x=1694785432;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MoNBTL/8UzTa+ns85Z6YkPJikJoABDDFiDiuk+qGU0g=;
  b=B6wKiEiO1/xpHpXGt8kClp1n4Vm5Xr3F2GODVDRunhr9bZzEEUxqjFFQ
   zDrrdLfqS8BgM3szFZH/ekIsuA6B7aLKhWSyx6ek59H0jfEH677+3TLEF
   Fq2lXuHQeX9UjPpQ/zg4pNF+T7Lf89Q4Y6CPkupEwcfRutY6zptZhORpo
   vS/mRH3b3i1i6ZyRtRz+lHhdodq4WN0599eTWtxTzkwFI2JJsDpCpdMkq
   jgOidGGjoBxuZjM5QSrqU6388Dd77r4emVqnkaSbxsM3RNRsR7wZIk2Hg
   AezY5toUWM1+IzXl3zFAwFKz7VJK+sJhKeu4qwvG8ur7KSwVgzCXKDyCi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="279099994"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="279099994"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:43:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="617278923"
Received: from unknown (HELO DCG-LAB-MODULE2.gar.corp.intel.com) ([10.123.220.6])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:43:45 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [RFC PATCH net-next v4 0/6] Implement devlink-rate API and extend it
Date:   Thu, 15 Sep 2022 15:42:33 +0200
Message-Id: <20220915134239.1935604-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series implements devlink-rate for ice driver. Unfortunately
current API isn't flexible enough for our use case, so there is a need to
extend it. New object type 'queue' is being introduced, and more functions
has been changed to non-static, to enable the driver to export current
Tx scheduling configuration.

This patch series is a follow up for this thread:
https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/T/#u

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


Ben Shelton (1):
  ice: Add function for move/reconfigure TxQ AQ command

Michal Wilczynski (5):
  devlink: Extend devlink-rate api with queues and new parameters
  ice: Introduce new parameters in ice_sched_node
  ice: Implement devlink-rate API
  ice: Export Tx scheduler configuration to devlink-rate
  ice: Prevent ADQ, DCB and RDMA coexistence with Custom Tx scheduler

 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  41 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  75 ++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   8 +
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   4 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 598 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
 drivers/net/ethernet/intel/ice/ice_idc.c      |   5 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   2 +
 drivers/net/ethernet/intel/ice/ice_sched.c    |  81 ++-
 drivers/net/ethernet/intel/ice/ice_sched.h    |  27 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   7 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  10 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   6 +-
 .../mellanox/mlx5/core/esw/devlink_port.c     |   8 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |  12 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.h |  10 +-
 drivers/net/netdevsim/dev.c                   |  32 +-
 include/net/devlink.h                         |  56 +-
 include/uapi/linux/devlink.h                  |   8 +-
 net/core/devlink.c                            | 407 ++++++++++--
 21 files changed, 1284 insertions(+), 117 deletions(-)

-- 
2.35.1

