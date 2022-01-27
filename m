Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E85049E2FE
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbiA0NAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:00:34 -0500
Received: from mga07.intel.com ([134.134.136.100]:3511 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241464AbiA0NAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 08:00:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643288432; x=1674824432;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qqdElTsE7YN3NAR2wcrpbAjmNUND3PYPv0QA94UzEAg=;
  b=mdcsKjyexc8wto4ud7DixRw38vur0ftAyY8Fa7ddZZ8bavUtUanT/IXx
   BVk8vnUTqdNvOmE/q58Ocf3PPPrm7qPcvHauTWqCwTS5foGT0xPdLxle0
   LJ+NKRa6RogmDdXw9qnqe7M32bpMJ/J1O0nJ6jG8i0Rcj+utnOw/RdFo2
   JPIVMNEZCaqF5hxALipq2QFVdc5bShXm8zYna9U8UTiZ7LT49EloxqwvJ
   yIUC1Qh1tyyLqLpQ1RQEvMfMbf5LyONnMmS28C5C1zMmrFlf8DKj1SMRF
   PnaXxCNR2zvOji1WjUN8dgQnpNYUvQpeSqye7yn2o6RLhIxh6+2xrIGhZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="310154024"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="310154024"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 05:00:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="495715633"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 27 Jan 2022 05:00:18 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RD0Dfg020316;
        Thu, 27 Jan 2022 13:00:13 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [RFC PATCH net-next v2 0/5] ice: GTP support in switchdev
Date:   Thu, 27 Jan 2022 13:55:25 +0100
Message-Id: <20220127125525.125805-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

v2: Adding more CC

Marcin Szycik (1):
  ice: Support GTP-U and GTP-C offload in switchdev

Michal Swiatkowski (1):
  ice: Fix FV offset searching

Wojciech Drewek (3):
  gtp: Allow to create GTP device without FDs
  gtp: Add support for checking GTP device type
  net/sched: Allow flower to match on GTP options

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  46 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   2 +-
 .../net/ethernet/intel/ice/ice_flex_type.h    |   6 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |  19 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 630 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_switch.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 105 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   3 +
 drivers/net/gtp.c                             |  74 +-
 include/net/gtp.h                             |  11 +
 include/uapi/linux/if_tunnel.h                |   4 +-
 include/uapi/linux/pkt_cls.h                  |  15 +
 net/sched/cls_flower.c                        | 116 ++++
 14 files changed, 967 insertions(+), 74 deletions(-)

-- 
2.31.1

