Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443F24CD939
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbiCDQlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiCDQlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:41:55 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ED515F611
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 08:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646412067; x=1677948067;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gXUtyNq+tQ5eEQe4KT2irXcFI7ZLoWT79V4KnWbrRlo=;
  b=Kz19PXF20jCn2qN0DY12ytdsC3/OHLFYJEKT7rLA7+hrtXpWdnXJGmww
   gxOo8SlzjgdG/e8+8RgUowwrx14j7zZOxoQfj/FUpQ0MjVLtM9m0GfN4d
   RBSLv8IHOsUs+CalIkpjTxTRfXUkHF3UXqZjdAIUMfcvX6ZS501v/2XE+
   Qz14pEy/r3ye8YbYIoAPu4V35tAfHbAlrdIiNcAoUw6GHSkNKFPM+rr2E
   UOEFdjewi5ArmOPPB93S3SGabCwg0Gaaaz1vo0Syol7rH1nu0XPVtZczq
   R6Xs8W6EkNljgtiMhwl8yub34u1h5C4paw4UllhsN6Fnuy19qXRbQ2ahO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="317241321"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="317241321"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 08:41:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="509028436"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 04 Mar 2022 08:41:03 -0800
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 224Gf12G020994;
        Fri, 4 Mar 2022 16:41:01 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, jiri@resnulli.us,
        osmocom-net-gprs@lists.osmocom.org,
        intel-wired-lan@lists.osuosl.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [PATCH net-next v10 0/7] ice: GTP support in switchdev
Date:   Fri,  4 Mar 2022 17:40:41 +0100
Message-Id: <20220304164048.476900-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 drivers/net/ethernet/intel/ice/ice_switch.c   | 643 ++++++++++++++++--
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
 16 files changed, 1473 insertions(+), 113 deletions(-)

-- 
2.35.1

