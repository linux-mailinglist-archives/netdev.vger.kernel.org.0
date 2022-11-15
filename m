Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA16629634
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiKOKsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiKOKso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:48:44 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5C510FE0
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668509321; x=1700045321;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eTCWESO+SqdLpgLhDDEnOIAbUv0/LK4O/2Og0yZ71Us=;
  b=GTABadC2SGdAfT+C05gFTei3af8gHEKBnkH5ZU+weBfhVzmqyVORah3+
   NBTskOWnhet0ekG1ZaDPAi+HyH0YNYpdXEbBj9TWD8CNLRBZNeIwAj7Es
   En7diEHvlrBSL/Hm1Qwkti1aYM9SWYcF6vMQKds2RVSYsABDV9iZ3XDZ4
   MneVJk07DAeMV3S2DaivTDSh/n+qs3GeSXEeJmKYtTkNHeSLaNJSUB/Qq
   9calvA4Z6TUn+rSMsPmhrjsAFvrKdSMZVtPb67B1D2RtLr6hwjPhVpsjQ
   13o3JQeP4/YAgoydFsXYhpOjvjz+Ev3KAvMBRs9I1yygnup0ahTcq/0lW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="313371145"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="313371145"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:48:40 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="633193360"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="633193360"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:48:38 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v12 00/11] Implement devlink-rate API and extend it
Date:   Tue, 15 Nov 2022 11:48:14 +0100
Message-Id: <20221115104825.172668-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
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

V12:
 - fixed warnings
 - added comment about conversion from bytes/s to kilobits/s

V11:
 - updated documentation in ice.rst to clarify how new parameters
   are used, and describe in more detail how and when the hierarchy
   is exported/deleted, and how mutual exclusivity with DCB/ADQ
   works
 - added documentation of new parameters in devlink-port.rst
 - refactored ice_set_object_tx_priority, ice_set_object_tx_max,
   ice_set_object_tx_weight, ice_set_object_tx_share to avoid
   code duplication

V10:
 - changed attributes type from u16 to u32 as they are padded to u32
   anyway
 - changed NL_SET_ERR_MSG_MOD to NL_SET_ERR_MSG_ATTR as it points to
   a problem with specific attribute
 - fixed function parameter not described
 - added documentation in ice.rst

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

Michal Wilczynski (11):
  devlink: Introduce new attribute 'tx_priority' to devlink-rate
  devlink: Introduce new attribute 'tx_weight' to devlink-rate
  devlink: Enable creation of the devlink-rate nodes from the driver
  devlink: Allow for devlink-rate nodes parent reassignment
  devlink: Allow to set up parent in devl_rate_leaf_create()
  ice: Introduce new parameters in ice_sched_node
  ice: Add an option to pre-allocate memory for ice_sched_node
  ice: Implement devlink-rate API
  ice: Prevent ADQ, DCB coexistence with Custom Tx scheduler
  ice: Add documentation for devlink-rate implementation
  Documentation: Add documentation for new devlink-rate attributes

 .../networking/devlink/devlink-port.rst       |  33 +-
 Documentation/networking/devlink/ice.rst      | 115 ++++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   4 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   7 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   7 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 502 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h  |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   6 +
 drivers/net/ethernet/intel/ice/ice_repr.c     |  18 +
 drivers/net/ethernet/intel/ice/ice_sched.c    | 104 +++-
 drivers/net/ethernet/intel/ice/ice_sched.h    |  31 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   9 +
 .../mellanox/mlx5/core/esw/devlink_port.c     |   4 +-
 drivers/net/netdevsim/dev.c                   |   2 +-
 include/net/devlink.h                         |  18 +-
 include/uapi/linux/devlink.h                  |   3 +
 net/core/devlink.c                            | 130 ++++-
 18 files changed, 970 insertions(+), 28 deletions(-)

-- 
2.37.2

