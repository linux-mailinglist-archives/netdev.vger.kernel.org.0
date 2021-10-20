Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F555435664
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 01:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhJTXVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 19:21:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:7592 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhJTXVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 19:21:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="228775792"
X-IronPort-AV: E=Sophos;i="5.87,168,1631602800"; 
   d="scan'208";a="228775792"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 16:18:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,168,1631602800"; 
   d="scan'208";a="483921295"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 20 Oct 2021 16:18:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sudheer.mogilappagari@intel.com, sridhar.samudrala@intel.com,
        amritha.nambiar@intel.com
Subject: [PATCH net-next 0/3][pull request] 100GbE Intel Wired LAN Driver Updates 2021-10-20
Date:   Wed, 20 Oct 2021 16:17:00 -0700
Message-Id: <20211020231703.3642650-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sudheer Mogilappagari says:

This series introduces initial support for Application Device Queues(ADQ)
in ice driver. ADQ provides traffic isolation for application flows in
hardware and ability to steer traffic to a given traffic class. This
helps in aligning NIC queues to application threads.

Traffic classes are configured using mqprio framework of tc command
and mapped to HW channels(VSIs) in the driver. The queue set of each
traffic class is managed by corresponding VSI. Each traffic channel
can be configured with bandwidth rate-limiting limits and is offloaded
to the hardware through the mqprio framework by specifying the mode
option as 'channel' and shaper option as 'bw_rlimit'.

Next, the flows of application can be steered into a given traffic class
using "tc filter" command. The option "skip_sw hw_tc x" indicates 
hw-offload of filtering and steering filtered traffic into specified TC.
Non-matching traffic flows through TC0.

When channel configuration are removed queue configuration is set to
default and filters configured on individual traffic classes are deleted.

example:
$ ethtool -K eth0 hw-tc-offload on

Configure 3 traffic classes and map priority 0,1,2 to TC0, TC1 and TC2
respectively. TC0 has 2 queues from offset 0 & TC1 has 8 queues from
offset 2 and TC2 has 4 queues from offset 10. Enable hardware offload
of channels.

$ tc qdisc add dev eth0 root mqprio num_tc 3 map 0 1 2 queues \
        2@0 8@2 4@10 hw 1 mode channel

$ tc qdisc show dev eth0
qdisc mqprio 8001: root  tc 2 map 0 1 2 0 0 0 0 0 0 0 0 0 0 0 0 0
             queues:(0:1) (2:9) (10:13)
             mode:channel


Configure two filters to match based on dst ipaddr, dst tcp port and
redirect to TC1 and TC2.
$ tc qdisc add dev eth0 clsact

$ tc filter add dev eth0 protocol ip ingress prio 1 flower\
  dst_ip 192.168.1.1/32 ip_proto tcp dst_port 80\
  skip_sw hw_tc 1
$ tc filter add dev eth0 protocol ip ingress prio 1 flower\
  dst_ip 192.168.1.1/32 ip_proto tcp dst_port 5001\
  skip_sw hw_tc 2

$ tc filter show dev eth0 ingress

Delete traffic classes configuration:
$ sudo tc qdisc del dev eth0 root

---
The following are changes since commit 2641b62d2fab52648e34cdc6994b2eacde2d27c1:
  phy: micrel: ksz8041nl: do not use power down mode
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Kiran Patil (3):
  ice: Add infrastructure for mqprio support via ndo_setup_tc
  ice: enable ndo_setup_tc support for mqprio_qdisc
  ice: Add tc-flower filter support for channel

 drivers/net/ethernet/intel/ice/ice.h          | 108 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  34 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 201 ++--
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  10 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  10 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 384 ++++++-
 drivers/net/ethernet/intel/ice/ice_lib.h      |  12 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 970 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_sched.c    |  68 +-
 drivers/net/ethernet/intel/ice/ice_sched.h    |   2 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 119 +++
 drivers/net/ethernet/intel/ice/ice_switch.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 217 +++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  22 +
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   7 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   4 +-
 18 files changed, 2021 insertions(+), 154 deletions(-)

-- 
2.31.1

