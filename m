Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E79F4D6769
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349000AbiCKRTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350702AbiCKRTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:19:36 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993D0E38AD
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647019112; x=1678555112;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O21vfCT748XCS9dCNErXlo0X5k7r6XY6yxi/hzuYVLc=;
  b=chxapj99lpD/HbcBH/oqiypWyPUHYvYrAPI+ziZRwBl4mgm/RQ0xZ2kK
   l8hq1DOvpmA0KzOQR12pMXxaoOdu7nHJe2sA//Gae5FT7PKWM+XYq6Txb
   PISOtOJ5ziaU7VKXJuKx4e61RKhLwIf8ce84e+tHBKcZMiuGFFCEWzWp+
   osZGRDgyETlPi8e64Jaf8nLXvMvX5Tp1sO7cFvTX9RoqR+9I0MEJxFvJx
   PYqG5Cfih9j3d77gD5cBceYeEOwd+LMnrqUolmhe82asRxVidxznwwpId
   YpkLix60EIi83yaeFRprG5erWk9g7hX5q+iVamcg1USb6jArmmCVuUy8H
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="316335105"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="316335105"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 09:18:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="612215391"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 11 Mar 2022 09:18:31 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        marcin.szycik@linux.intel.com, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, jiri@resnulli.us, pablo@netfilter.org,
        laforge@gnumonks.org, xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        osmocom-net-gprs@lists.osmocom.org
Subject: [PATCH net-next v11 0/7][pull request] ice: GTP support in switchdev
Date:   Fri, 11 Mar 2022 09:18:14 -0800
Message-Id: <20220311171821.3785992-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcin Szycik says:

Add support for adding GTP-C and GTP-U filters in switchdev mode.

To create a filter for GTP, create a GTP-type netdev with ip tool, enable
hardware offload, add qdisc and add a filter in tc:

ip link add $GTP0 type gtp role <sgsn/ggsn> hsize <hsize>
ethtool -K $PF0 hw-tc-offload on
tc qdisc add dev $GTP0 ingress
tc filter add dev $GTP0 ingress prio 1 flower enc_key_id 1337 \
action mirred egress redirect dev $VF1_PR

By default, a filter for GTP-U will be added. To add a filter for GTP-C,
specify enc_dst_port = 2123, e.g.:

tc filter add dev $GTP0 ingress prio 1 flower enc_key_id 1337 \
enc_dst_port 2123 action mirred egress redirect dev $VF1_PR

Note: outer IPv6 offload is not supported yet.
Note: GTP-U with no payload offload is not supported yet.

ICE COMMS package is required to create a filter as it contains GTP
profiles.

Changes in iproute2 [1] are required to be able to add GTP netdev and use
GTP-specific options (QFI and PDU type).

[1] https://lore.kernel.org/netdev/20220211182902.11542-1-wojciech.drewek@intel.com/T
---
v2: Add more CC
v3: Fix mail thread, sorry for spam
v4: Add GTP echo response in gtp module
v5: Change patch order
v6: Add GTP echo request in gtp module
v7: Fix kernel-docs in ice
v8: Remove handling of GTP Echo Response
v9: Add sending of multicast message on GTP Echo Response, fix GTP-C dummy 
    packet selection
v10: Rebase, fixed most 80 char line limits
v11: Rebase, collect Harald's Reviewed-by on patch 3

The following are changes since commit 59d5923536ac8640f4ff20d011a4851a3c143764:
  Merge branch 'ptp-ocp-new-firmware-support'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Marcin Szycik (1):
  ice: Support GTP-U and GTP-C offload in switchdev

Michal Swiatkowski (1):
  ice: Fix FV offset searching

Wojciech Drewek (5):
  gtp: Allow to create GTP device without FDs
  gtp: Implement GTP echo response
  gtp: Implement GTP echo request
  net/sched: Allow flower to match on GTP options
  gtp: Add support for checking GTP device type

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  53 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   2 +-
 .../net/ethernet/intel/ice/ice_flex_type.h    |   6 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |  19 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 654 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_switch.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 105 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   3 +
 drivers/net/gtp.c                             | 565 +++++++++++++--
 include/net/gtp.h                             |  42 ++
 include/uapi/linux/gtp.h                      |   1 +
 include/uapi/linux/if_link.h                  |   2 +
 include/uapi/linux/if_tunnel.h                |   4 +-
 include/uapi/linux/pkt_cls.h                  |  15 +
 net/sched/cls_flower.c                        | 116 ++++
 16 files changed, 1478 insertions(+), 119 deletions(-)

-- 
2.31.1

