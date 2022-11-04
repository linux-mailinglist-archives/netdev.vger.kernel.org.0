Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7141619A08
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiKDOdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbiKDOdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:33:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14FD4AF12
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667572278; x=1699108278;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HxYeWWb2hDoH54Un9aVv74vrJvoYPUY3i74FJOXqm2o=;
  b=AAJtMu9YqBxLQhT9wSddUoMgrfoaJs8rVm8ESd3o8Bw1PDvOG5O5Alk+
   pqQgTnnBzloBcnt5weo2f06sDgPKgf4hoRX8WTJPEp4ColtjbePdeikgT
   8GKkF+EIfMcSqGX/DvK7ylzwGllud1ddI0xjTJPPdomyeYWIEc34D/ds0
   hSZix2C0xkX1B/zR5aMJdtw8qGKMcBukg5X4pfLj8NXZr39Thee5vCcGT
   4EQzJfdT81+DF1e1Z8MAbjRdbIfCAHVBbz5nxakDrHNveP6gxgbjK0Ih7
   frSYLX+inno+kmQ//3AR5jonHm74yIbTlDAPB56uOEVIYgVZ6u8gH08OH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="311719196"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="311719196"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:18 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="777730161"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="777730161"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:15 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v9 0/9] Implement devlink-rate API and extend it
Date:   Fri,  4 Nov 2022 15:30:53 +0100
Message-Id: <20221104143102.1120076-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series implements devlink-rate for ice driver. Unfortunately
current API isn't flexible enough for our use case, so there is a need to
extend it. Some functions have been introduced to enable the driver to
export current Tx scheduling configuration.

Pasting justification for this series from commit implementing devlink-rate
in ice driver(that is a part of this series):

There is a need to support modification of Tx scheduler tree, in the
ice driver. This will allow user to control Tx settings of each node in
the internal hierarchy of nodes. As a result user will be able to use
Hierarchy QoS implemented entirely in the hardware.

This patch implemenents devlink-rate API. It also exports initial
default hierarchy. It's mostly dictated by the fact that the tree
can't be removed entirely, all we can do is enable the user to modify
it. For example root node shouldn't ever be removed, also nodes that
have children are off-limits.

Example initial tree with 2 VF's:

[root@fedora ~]# devlink port function rate show
pci/0000:4b:00.0/node_27: type node parent node_26
pci/0000:4b:00.0/node_26: type node parent node_0
pci/0000:4b:00.0/node_34: type node parent node_33
pci/0000:4b:00.0/node_33: type node parent node_32
pci/0000:4b:00.0/node_32: type node parent node_16
pci/0000:4b:00.0/node_19: type node parent node_18
pci/0000:4b:00.0/node_18: type node parent node_17
pci/0000:4b:00.0/node_17: type node parent node_16
pci/0000:4b:00.0/node_21: type node parent node_20
pci/0000:4b:00.0/node_20: type node parent node_3
pci/0000:4b:00.0/node_14: type node parent node_5
pci/0000:4b:00.0/node_5: type node parent node_3
pci/0000:4b:00.0/node_13: type node parent node_4
pci/0000:4b:00.0/node_12: type node parent node_4
pci/0000:4b:00.0/node_11: type node parent node_4
pci/0000:4b:00.0/node_10: type node parent node_4
pci/0000:4b:00.0/node_9: type node parent node_4
pci/0000:4b:00.0/node_8: type node parent node_4
pci/0000:4b:00.0/node_7: type node parent node_4
pci/0000:4b:00.0/node_6: type node parent node_4
pci/0000:4b:00.0/node_4: type node parent node_3
pci/0000:4b:00.0/node_3: type node parent node_16
pci/0000:4b:00.0/node_16: type node parent node_15
pci/0000:4b:00.0/node_15: type node parent node_0
pci/0000:4b:00.0/node_2: type node parent node_1
pci/0000:4b:00.0/node_1: type node parent node_0
pci/0000:4b:00.0/node_0: type node
pci/0000:4b:00.0/1: type leaf parent node_27
pci/0000:4b:00.0/2: type leaf parent node_27


Let me visualize part of the tree:

                        +---------+
                        |  node_0 |
                        +---------+
                             |
                        +----v----+
                        | node_26 |
                        +----+----+
                             |
                        +----v----+
                        | node_27 |
                        +----+----+
                             |
                    |-----------------|
               +----v----+       +----v----+
               |   VF 1  |       |   VF 2  |
               +----+----+       +----+----+

So at this point there is a couple things that can be done.
For example we could only assign parameters to VF's.

[root@fedora ~]# devlink port function rate set pci/0000:4b:00.0/1 \
                 tx_max 5Gbps

This would cap the VF 1 BW to 5Gbps.

But let's say you would like to create a completely new branch.
This can be done like this:

[root@fedora ~]# devlink port function rate add \
                 pci/0000:4b:00.0/node_custom parent node_0
[root@fedora ~]# devlink port function rate add \
                 pci/0000:4b:00.0/node_custom_1 parent node_custom
[root@fedora ~]# devlink port function rate set \
                 pci/0000:4b:00.0/1 parent node_custom_1

This creates a completely new branch and reassigns VF 1 to it.

A number of parameters is supported per each node: tx_max, tx_share,
tx_priority and tx_weight.


V9:
 - changed misleading name from 'parameter' to 'attribute'
 - removed mechanism referring for kernel object by string,
   now it's referring to them as pointers
 - removed limiting name size in devl_rate_node_create()
 - removed commit that allowed for change of priv in set_parent
   callback
 - added commit that allows for pre-allocation of ice_sched
   elements


V8:
- address minor formatting issues
- fix memory leak
- address warnings

V7:
- split into smaller commits
- paste justification for this series to cover letter

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


Michal Wilczynski (9):
  devlink: Introduce new attribute 'tx_priority' to devlink-rate
  devlink: Introduce new attribute 'tx_weight' to devlink-rate
  devlink: Enable creation of the devlink-rate nodes from the driver
  devlink: Allow for devlink-rate nodes parent reassignment
  devlink: Allow to set up parent in devl_rate_leaf_create()
  ice: Introduce new parameters in ice_sched_node
  ice: Add an option to pre-allocate memory for ice_sched_node
  ice: Implement devlink-rate API
  ice: Prevent ADQ, DCB coexistence with Custom Tx scheduler

 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   4 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   7 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   4 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 483 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
 drivers/net/ethernet/intel/ice/ice_repr.c     |  13 +
 drivers/net/ethernet/intel/ice/ice_sched.c    | 101 +++-
 drivers/net/ethernet/intel/ice/ice_sched.h    |  31 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   9 +
 .../mellanox/mlx5/core/esw/devlink_port.c     |  14 +-
 drivers/net/netdevsim/dev.c                   |   9 +-
 include/net/devlink.h                         |  18 +-
 include/uapi/linux/devlink.h                  |   3 +
 net/core/devlink.c                            | 133 ++++-
 15 files changed, 799 insertions(+), 34 deletions(-)

-- 
2.37.2

