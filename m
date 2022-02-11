Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4DE4B2C4C
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352378AbiBKR6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:58:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352358AbiBKR6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:58:03 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774D82C9
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644602282; x=1676138282;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hJKWL/lbdS8uxlBmg5iK4br47XcvzYNEI4eMXfQbFh0=;
  b=n8lMeTvO7Udd8YPSf9j0fRMMuuT84gzFPjkjVnlIqG4tU4oGjr26u3c+
   +ATs5nKpTyutQcT23Jc21Jpf6EucQ+DXHLEClRlavuho4QgaXMrOvMJTc
   0PB0R44QYmlUM/4V5f2uFUn5yFdJ1eGUQKOXnAmTc6t/swZY68NUoV5u8
   GCRQcQ3QJFe38+4aA7BpCxhPf2ibn6BIG/Xp0OtzbiBIgsUBNEAc1Fabn
   eZ2/wAmZjHuHJCHUasmO8u+saSGv/mIui6UXKRO7WDPa6tF+Ln5bmDVag
   8CUn/3Xx7JzsAAfkL5+NRW75aDG87Ih+M7rugcKLkZZrSYEgha4bWK4UB
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10255"; a="274337341"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="274337341"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 09:58:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="500850157"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 11 Feb 2022 09:57:59 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 21BHvwtN017216;
        Fri, 11 Feb 2022 17:57:58 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [PATCH net-next v5 0/6] ice: GTP support in switchdev
Date:   Fri, 11 Feb 2022 18:54:05 +0100
Message-Id: <20220211175405.7651-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Note: IPv6 offload is not supported yet.
Note: GTP-U with no payload offload is not supported yet.

ICE COMMS package is required to create a filter as it contains GTP
profiles.

Changes in iproute2 are required to be able to add GTP netdev and use
GTP-specific options (QFI and PDU type). This patchset will be submitted
separately.
---
v2: Adding more CC
v3: Fixed mail thread, sorry for spam
v4: Added GTP echo response in gtp driver
v5: Change patch order

Marcin Szycik (1):
  ice: Support GTP-U and GTP-C offload in switchdev

Michal Swiatkowski (1):
  ice: Fix FV offset searching

Wojciech Drewek (4):
  gtp: Allow to create GTP device without FDs
  gtp: Implement GTP echo response
  net/sched: Allow flower to match on GTP options
  gtp: Add support for checking GTP device type

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  46 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   2 +-
 .../net/ethernet/intel/ice/ice_flex_type.h    |   6 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |  19 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 630 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_switch.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 105 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   3 +
 drivers/net/gtp.c                             | 518 ++++++++++----
 include/net/gtp.h                             |  42 ++
 include/uapi/linux/if_link.h                  |   2 +
 include/uapi/linux/if_tunnel.h                |   4 +-
 include/uapi/linux/pkt_cls.h                  |  15 +
 net/sched/cls_flower.c                        | 116 ++++
 15 files changed, 1314 insertions(+), 204 deletions(-)

-- 
2.31.1

