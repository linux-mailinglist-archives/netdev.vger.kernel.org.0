Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA92527FD54
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731908AbgJAKcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:32:36 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:19704 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAKcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:32:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601548355; x=1633084355;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=B+cZ+YKhyj76Cw7z6hfMYxOafQMHU9geMzZI4cikeuw=;
  b=k7rlCqnCup+FXjNTxtBM6j9xW64byOi195MVcONwY4bELCsLcO0tyD0l
   EQUd0c3opdm5jwg+G20a27SZBKdRc6+RR0lkvqqbmZ4QygPJxt1GtbVH3
   A7vsSbRl8uKBDjnaHMH7hGfoxfdIpEowSWXbkRn52lEQgHiUFU3wCn9UW
   XLZRUR94qcedCuvH2JuaRaj859/TC3iFyKdvWKur3MGxhtF/ZwwwyCvMw
   uaMEUsKkvlnNz3PjDAA+GyVdU2N6d0HLQNpg552GV9uWSozkCbxtX8Av8
   7yapNu7D/jL1xGZebGrxXD9NCB6heRrokXCaKGRXwNn1lY6eCTpr17rlj
   g==;
IronPort-SDR: +9pihxinvIWvX7rsoTz5kC31fjglc8AsiMduKSppPaldKRhpp3dE6Fa8O9bEjpwj92PVBY++Er
 lL25pHSamimK6PqgRRSp0pObJoz12pyudy35ylGFDICA03R+/igTkK6e6d9J7gFdebP4Jf623E
 6ZWr9JhRD8iGJ8y2MDMvUYz36tedgAA1aIXIIP1P4gXml+Eg/NR44t39Rt293zmnGCqMcUJY5d
 UYfguHbnFKx5nNNVR2lBxjEgMhRx/vgFGfyO/Vx1cUxqrGW4a8WWSEKCQkq91uVcFFXP4Fi7r3
 k8o=
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="28360871"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Oct 2020 03:32:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 03:32:09 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 1 Oct 2020 03:32:07 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [net-next v2 00/11] net: bridge: cfm: Add support for Connectivity Fault Management(CFM)
Date:   Thu, 1 Oct 2020 10:30:08 +0000
Message-ID: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Connectivity Fault Management (CFM) is defined in 802.1Q section 12.14.

Connectivity Fault Management (CFM) comprises capabilities for detecting, verifying,
and isolating connectivity failures in Virtual Bridged Networks.
These capabilities can be used in networks operated by multiple independent organizations,
each with restricted management access to each other’s equipment.

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

This CFM component supports create/delete of MEP instances and configuration of
the different CFM protocols. Also status information can be fetched and delivered
through notification due to defect status change.

The CFM component is trying to offload CFM functionality to HW by calling the
switchdev interface.

The user interacts with CFM using the 'cfm' user space client program,
the client talks with the kernel using netlink. The kernel will try to
offload the requests to the HW via switchdev API (not implemented yet).

Any notification emitted by CFM from the kernel can be monitored in user space
by starting 'cfm_server' program.

Currently this 'cfm' and 'cfm_server' programs are standalone placed in a cfm
repository https://github.com/microchip-ung/cfm but it is considered to integrate
this into 'iproute2'.

v1 -> v2
    Added the CFM switchdev interface and also added utilization by calling the
    interface from the kernel CFM implementation trying to offload CFM functionality
    to HW. This offload (CFM driver) is currently not implemented.
    
    Corrections based on RCF comments:
        -The single CFM kernel implementation Patch is broken up into three patches.
        -Changed the list of MEP instances from list_head to hlist_head.
        -Removed unnecessary RCU list traversing.
        -Solved RCU unlocking problem.
        -Removed unnecessary comments.
        -Added ASSERT_RTNL() where required.
        -Shaping up on error messages.
        -Correction NETLINK br_fill_ifinfo() to be able to handle 'filter_mask'
         with multiple flags asserted.

Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>

Henrik Bjoernlund (11):
  net: bridge: extend the process of special frames
  bridge: cfm: Add BRIDGE_CFM to Kconfig.
  bridge: uapi: cfm: Added EtherType used by the CFM protocol.
  bridge: cfm: Kernel space implementation of CFM.
  bridge: cfm: Kernel space implementation of CFM.
  bridge: cfm: Kernel space implementation of CFM.
  bridge: cfm: Netlink Interface.
  bridge: cfm: Netlink Notifications.
  bridge: cfm: Bridge port remove.
  bridge: switchdev: cfm: switchdev interface implementation
  bridge: cfm: Added CFM switchdev utilization.

 include/linux/if_bridge.h       |   13 +
 include/net/switchdev.h         |  115 ++++
 include/uapi/linux/cfm_bridge.h |   70 ++
 include/uapi/linux/if_bridge.h  |  125 ++++
 include/uapi/linux/if_ether.h   |    1 +
 include/uapi/linux/rtnetlink.h  |    2 +
 net/bridge/Kconfig              |   11 +
 net/bridge/Makefile             |    2 +
 net/bridge/br_cfm.c             | 1092 +++++++++++++++++++++++++++++++
 net/bridge/br_cfm_netlink.c     |  728 +++++++++++++++++++++
 net/bridge/br_cfm_switchdev.c   |  203 ++++++
 net/bridge/br_device.c          |    4 +
 net/bridge/br_if.c              |    1 +
 net/bridge/br_input.c           |   31 +-
 net/bridge/br_mrp.c             |   19 +-
 net/bridge/br_netlink.c         |  138 +++-
 net/bridge/br_private.h         |   76 ++-
 net/bridge/br_private_cfm.h     |  208 ++++++
 net/switchdev/switchdev.c       |   54 ++
 19 files changed, 2858 insertions(+), 35 deletions(-)
 create mode 100644 include/uapi/linux/cfm_bridge.h
 create mode 100644 net/bridge/br_cfm.c
 create mode 100644 net/bridge/br_cfm_netlink.c
 create mode 100644 net/bridge/br_cfm_switchdev.c
 create mode 100644 net/bridge/br_private_cfm.h

-- 
2.28.0

