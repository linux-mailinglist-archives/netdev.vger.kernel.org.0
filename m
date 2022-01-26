Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A797049D203
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 19:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244191AbiAZSrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 13:47:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:15642 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232915AbiAZSrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 13:47:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643222853; x=1674758853;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TQOjJRw4GSNEHhEbpovjpLCE+1+6qAcVr7yv4IL6oY4=;
  b=RH7gStZh4Mg2ZIGURvZWfNQ/N5dJlthG4xPkBdw5lT9GnvFZlajWBv+f
   DnNMJnxeHUk0Voobklk/PsHRarNOStzglF23CcHqQqHGg9LPjflj/fFXq
   GyAbxT4hfItSugEVEqmuUYzH7iG+W6mpZFj5yNA8zxQGZOCAuqPGOo6pD
   Rn3HG3RUj+HW3Gh7sRWhaDhw3Eg4lgxcaUWBrp3lsY/C9xQy+ek9/+Nlh
   tNE+ZF4zRS6OP5q2TP0E1n/fT83df7n8/cMYDtlZcpBmO1yo7hII3ufFs
   zlBAXEwlIQqdkkJtBpbwv/J67mM0/QBxGYaYKwQbcLBny5VvkF8lKiCx8
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="246840762"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="246840762"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 10:47:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="767220866"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jan 2022 10:47:32 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20QIlVdY000727;
        Wed, 26 Jan 2022 18:47:31 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [RFC PATCH net-next 0/5] ice: GTP support in switchdev
Date:   Wed, 26 Jan 2022 19:43:53 +0100
Message-Id: <20220126184358.6505-1-marcin.szycik@linux.intel.com>
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
GTP-specific options (QFI and PDU type). This will be submitted separately.

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

