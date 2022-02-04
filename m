Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AFD4A9D26
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 17:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376661AbiBDQxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 11:53:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:43031 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233477AbiBDQxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 11:53:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643993616; x=1675529616;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=j0yrzhNYl+3Xk6BQ/jan/jbaJvgQOjpybmd2S65loq4=;
  b=VtsT6M0MfRRAYCIR7JlrcoqwBJoqAnJzb5Nwg6E+mXL7eHKh1Lu4XD9A
   3xmmL6EOFPt76wiBjxd2AoSV80c24XxX7kA2pH7CFbg0+ZFcY7hO+BKmX
   kRqtC2mkEZiQKX5M6UarHOdjopylDc73s2hoh9Usx2ZCUNFdbaYOfNrx/
   5ft2OXXEGD4q0XKOnTtkEkQO5ngpz61OZHH0IuX0mNhisPRIqtYUj9Cl/
   NRTOrXAc/CUe6Tcu8n9BOPMyybh5FNZRh55I2f4Fx81GHgFrjWxnIxoRh
   XD5vB0Rk8IWjYt4p/G0d3Ux4cv7W4/4RNcuCWwTkVMPHflCXQbusnjw+C
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="272901012"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="272901012"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 08:53:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="483666755"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 04 Feb 2022 08:53:34 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 214GrWMB026603;
        Fri, 4 Feb 2022 16:53:32 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [RFC PATCH net-next v4 0/6] ice: GTP support in switchdev
Date:   Fri,  4 Feb 2022 17:49:29 +0100
Message-Id: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
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
---
v2: Adding more CC
v3: Fixed mail thread, sorry for spam
v4: Added GTP echo response in gtp driver

Marcin Szycik (1):
  ice: Support GTP-U and GTP-C offload in switchdev

Michal Swiatkowski (1):
  ice: Fix FV offset searching

Wojciech Drewek (4):
  gtp: Allow to create GTP device without FDs
  gtp: Add support for checking GTP device type
  net/sched: Allow flower to match on GTP options
  gtp: Implement GTP echo response

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  46 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   2 +-
 .../net/ethernet/intel/ice/ice_flex_type.h    |   6 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |  19 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 630 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_switch.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 105 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   3 +
 drivers/net/gtp.c                             | 286 +++++++-
 include/net/gtp.h                             |  42 ++
 include/uapi/linux/if_link.h                  |   1 +
 include/uapi/linux/if_tunnel.h                |   4 +-
 include/uapi/linux/pkt_cls.h                  |  15 +
 net/sched/cls_flower.c                        | 116 ++++
 15 files changed, 1195 insertions(+), 90 deletions(-)

-- 
2.31.1

