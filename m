Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EE829A8EB
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437219AbgJ0KEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:04:16 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:34850 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411294AbgJ0KEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:04:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1603793054; x=1635329054;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f7mhXRoSJu/byey8hhjFwfYfaY2ar+qTEyEgWFGPu/Q=;
  b=nQDTzEjTb3vLNqeGv/qnuBOEAwdzwNWfjEePuOpCYmhabrwAvk6rb4+r
   Dl8ckSXvFuPh5BxNX0ut/8evbGqGGnwmaa2u6CDZaU2PsqJn2FWh/2uhE
   v9Cwj4a/Ii+Nei4SYWXKhXeKtUloch/ak7O64uUQosDjcqJgAKAD9y/zC
   DXl0/T2q8rqdppB0UP/cNWSAP40I9Qk9hYvTbYqWYlc4vu9OPyNUeJ1UL
   Ga7Q3mbrUdBEnoyCyQUSD7BjEr5CdT8u8nAB6Rj+3FcuG0e1Mbc/qd8N3
   z5QzCjQYJ36L7Qi795TUiQkBpI/wSQFsh5zIystykPUofVs4KaJptVkGO
   A==;
IronPort-SDR: PUYIE4ZtooF/uJtrbjxXbxMfeJ3rPDiZ2REo0l977m82l5OzxjF2f81e1Slph9cbAsEgOYDCGZ
 7sE+W+Q63vMnm4L8U2obdP79xFocnOc9Pf9GOUvcOrnJWTvtYqKTjc0khf7FggoQpyZ1LhdLLT
 dClMFISxgWV/Tg79tWvsPGNxX+tfCeFVJyUT/QxbqXFLlx0KOqxE2IlAYB+aJzsOiAJST2Avqn
 rUSd2rUQJG9froe9wTrlU4liw9ZcAXIiQCHZGiLzv4lTsc1XC6IIE1WGTvf/6nWrt1zF/PK0hu
 UMY=
X-IronPort-AV: E=Sophos;i="5.77,423,1596524400"; 
   d="scan'208";a="94040326"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2020 03:04:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 27 Oct 2020 03:04:13 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 27 Oct 2020 03:04:11 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v7 00/10] net: bridge: cfm: Add support for Connectivity Fault Management(CFM)
Date:   Tue, 27 Oct 2020 10:02:41 +0000
Message-ID: <20201027100251.3241719-1-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Connectivity Fault Management (CFM) is defined in 802.1Q
section 12.14.

Connectivity Fault Management (CFM) comprises capabilities for
detecting, verifying, and isolating connectivity failures in Virtual
Bridged Networks. These capabilities can be used in networks
operated by multiple independent organizations, each with restricted
management access to each other’s equipment.

CFM functions are partitioned as follows:
    — Path discovery
    — Fault detection
    — Fault verification and isolation
    — Fault notification
    — Fault recovery

The primary CFM protocol shims are called Maintenance Points (MPs).
A MP can be either a MEP or a MHF.
The MEP:
    -It is the Maintenance association End Point
     described in 802.1Q section 19.2.
    -It is created on a specific level (1-7) and is assuring
     that no CFM frames are passing through this MEP on lower levels.
    -It initiates and terminates/validates CFM frames on its level.
    -It can only exist on a port that is related to a bridge.
The MHF:
    -It is the Maintenance Domain Intermediate Point
     (MIP) Half Function (MHF) described in 802.1Q section 19.3.
    -It is created on a specific level (1-7).
    -It is extracting/injecting certain CFM frame on this level.
    -It can only exist on a port that is related to a bridge.
    -Currently not supported.

There are defined the following CFM protocol functions:
    -Continuity Check
    -Loopback. Currently not supported.
    -Linktrace. Currently not supported.

This CFM component supports create/delete of MEP instances and
configuration of the different CFM protocols. Also status information
can be fetched and delivered through notification due to defect
status change.

The user interacts with CFM using the 'cfm' user space client
program, the client talks with the kernel using netlink.

Any notification emitted by CFM from the kernel can be monitored in
user space by starting 'cfm_server' program.

Currently this 'cfm' and 'cfm_server' programs are standalone placed
in a cfm repository https://github.com/microchip-ung/cfm but it is
considered to integrate this into 'iproute2'.

v1 -> v2
    Added the CFM switchdev interface and also added utilization by
    calling the interface from the kernel CFM implementation trying
    to offload CFM functionality to HW. This offload (CFM driver) is
    currently not implemented.
    
    Corrections based on RCF comments:
        -The single CFM kernel implementation Patch is broken up into
         three patches.
        -Changed the list of MEP instances from list_head to
         hlist_head.
        -Removed unnecessary RCU list traversing.
        -Solved RCU unlocking problem.
        -Removed unnecessary comments.
        -Added ASSERT_RTNL() where required.
        -Shaping up on error messages.
        -Correction NETLINK br_fill_ifinfo() to be able to handle
         'filter_mask' with multiple flags asserted.

v2 -> v3
    -The switchdev definition and utilization has been removed as
     there was no switchdev implementation.
    -Some compiling issues are fixed as Reported-by:
     kernel test robot <lkp@intel.com>.

v3 -> v4
    -Fixed potential crash during hlist walk where elements are
     removed.
    -Giving all commits unique titles.
    -NETLINK implementation split into three commits.
    -Commit "bridge: cfm: Bridge port remove" is merged with
     commit "bridge: cfm: Kernel space implementation of CFM. MEP
     create/delete."

v4 -> v5
    -Reordered members in struct net_bridge to bring member
     frame_type_list to the first cache line.
    -Helper functions nla_get_mac() and nla_get_maid() are removed.
    -The NLA_POLICY_NESTED() macro is used to initialize the
     br_cfm_policy array.
    -Fixed reverse xmas tree.

v5 -> v6
    -Fixed that the SKB buffer was not freed during error handling return.
    -Removed unused struct definition.
    -Changed bool to u8 bitfields for space save.
    -Utilizing the NETLINK policy validation feature.

v6 -> v7
    -Removed check of parameters in br_cfm_mep_config_set() and
     br_cfm_cc_peer_mep_add() in first commit of MEP implementation
     (Patch 4 out of 10)

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Henrik Bjoernlund <henrik.bjoernlund@microchip.com>

Henrik Bjoernlund (10):
  net: bridge: extend the process of special frames
  bridge: cfm: Add BRIDGE_CFM to Kconfig.
  bridge: uapi: cfm: Added EtherType used by the CFM protocol.
  bridge: cfm: Kernel space implementation of CFM. MEP create/delete.
  bridge: cfm: Kernel space implementation of CFM. CCM frame TX added.
  bridge: cfm: Kernel space implementation of CFM. CCM frame RX added.
  bridge: cfm: Netlink SET configuration Interface.
  bridge: cfm: Netlink GET configuration Interface.
  bridge: cfm: Netlink GET status Interface.
  bridge: cfm: Netlink Notifications.

 include/uapi/linux/cfm_bridge.h |  64 +++
 include/uapi/linux/if_bridge.h  | 125 +++++
 include/uapi/linux/if_ether.h   |   1 +
 include/uapi/linux/rtnetlink.h  |   2 +
 net/bridge/Kconfig              |  11 +
 net/bridge/Makefile             |   2 +
 net/bridge/br_cfm.c             | 867 ++++++++++++++++++++++++++++++++
 net/bridge/br_cfm_netlink.c     | 726 ++++++++++++++++++++++++++
 net/bridge/br_device.c          |   4 +
 net/bridge/br_if.c              |   1 +
 net/bridge/br_input.c           |  33 +-
 net/bridge/br_mrp.c             |  19 +-
 net/bridge/br_netlink.c         | 115 ++++-
 net/bridge/br_private.h         |  77 ++-
 net/bridge/br_private_cfm.h     | 147 ++++++
 15 files changed, 2171 insertions(+), 23 deletions(-)
 create mode 100644 include/uapi/linux/cfm_bridge.h
 create mode 100644 net/bridge/br_cfm.c
 create mode 100644 net/bridge/br_cfm_netlink.c
 create mode 100644 net/bridge/br_private_cfm.h

-- 
2.28.0

