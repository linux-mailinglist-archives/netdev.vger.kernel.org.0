Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911CD1A798A
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439041AbgDNL1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:27:15 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:18260 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438988AbgDNL1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 07:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586863631; x=1618399631;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=FuYPDzhAp4AkJuDESIBbxHtSPd32PmaudYkGVipmWWU=;
  b=qcoQumLJD9dEaLzbWbVNmg/NOvze3oDezsgF2ZtXtK/kztxWgxilx0/A
   CDCHpmxuoJ0+65XVPm/o6e/VED6Hoq7AAB88FGlVBMQEXGavcgu2fwAu3
   97Z6BINGlmoqZd1bMDEx3ixLW0TygbsuIPguUra+40lA0ULwdtZYYCdC/
   b8XzU1jtlc6AgrTdXb0/ibVru3lP4fqkpBf1EG8LmjDMMn1I5l7CkmIiL
   EFpKeK3d1STMSEHSq5CaM2esgvl/s3F3AbCecyzzGwTFYdQP8W8FtLSCc
   GOFfXOMLmuDqzcV5kpeh33hO8rYgf62LEbXG4olntIyVjcCshgtY9ih7F
   w==;
IronPort-SDR: 3Haq7MpF9Bv8ERNY8ht+UQagAkRURtOTUxXpxcfloT2KEMXkGDMREpktYCgkTL4uEeu28kUR7m
 wYgtGjJ6l1Taaj3sEbJ5BKbJyos3zeJCw1tygj/sUghwYpGNZtk667DqQ9YeMcSMy6Zfz2gw6B
 oO50x/IDqgcv2OhWSgBYLW2XDTRq0wNlPSNb0KxJoQMJSW/62J20qgyDXtBYwXxCUahAklgZGm
 lHBHJhsFG23THxDWuhDqYGpu75Ckw/III7SD+UzA50pqU32xN1pB0YTeS9D3p7MwoVHXS8dYPH
 ThA=
X-IronPort-AV: E=Sophos;i="5.72,382,1580799600"; 
   d="scan'208";a="75809053"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2020 04:27:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Apr 2020 04:26:57 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 14 Apr 2020 04:27:08 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v5 0/9] net: bridge: mrp: Add support for Media Redundancy Protocol(MRP)
Date:   Tue, 14 Apr 2020 13:26:09 +0200
Message-ID: <20200414112618.3644-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Media Redundancy Protocol is a data network protocol standardized by
International Electrotechnical Commission as IEC 62439-2. It allows rings of
Ethernet switches to overcome any single failure with recovery time faster than
STP. It is primarily used in Industrial Ethernet applications.

Based on the previous RFC[1][2][3][4], the MRP state machine and all the timers
were moved to userspace, except for the timers used to generate MRP Test frames.
In this way the userspace doesn't know and should not know if the HW or the
kernel will generate the MRP Test frames. The following changes were added to
the bridge to support the MRP:
- the existing netlink interface was extended with MRP support,
- allow to detect when a MRP frame was received on a MRP ring port
- allow MRP instance to forward/terminate MRP frames
- generate MRP Test frames in case the HW doesn't have support for this

To be able to offload MRP support to HW, the switchdev API  was extend.

With these changes the userspace doesn't do the following because already the
kernel/HW will do:
- doesn't need to forward/terminate MRP frames
- doesn't need to generate MRP Test frames
- doesn't need to detect when the ring is open/closed.

The userspace application that is using the new netlink can be found here[5].

The current implementation both in kernel and userspace supports only 2 roles:
  MRM - this one is responsible to send MRP_Test and MRP_Topo frames on both
  ring ports. It needs to process MRP_Test to know if the ring is open or
  closed. This operation is desired to be offloaded to the HW because it
  requires to generate and process up to 4000 frames per second. Whenever it
  detects that the ring is open it sends MRP_Topo frames to notify all MRC about
  changes in the topology. MRM needs also to process MRP_LinkChange frames,
  these frames are generated by the MRC. When the ring is open then the state
  of both ports is to forward frames and when the ring is closed then the
  secondary port is blocked.

  MRC - this one is responsible to forward MRP frames between the ring ports.
  In case one of the ring ports gets a link down or up, then MRC will generate
  a MRP_LinkChange frames. This node should also process MRP_Topo frames and to
  clear its FDB when it receives this frame.

 Userspace
               Deamon +----------+ Client
                +
                |
 +--------------|-----------------------------------------+
  Kernel        |
                + Netlink

                |                              + Interrupt
                |                              |
 +--------------|------------------------------|----------+
  HW            | Switchdev                    |
                +                              |

The user interacts using the client (called 'mrp'), the client talks to the
deamon (called 'mrp_server'), which talks with the kernel using netlink. The
kernel will try to offload the requests to the HW via switchdev API.

If this will be accepted then in the future the netlink interface can be
expended with multiple attributes which are required by different roles of the
MRP. Like Media Redundancy Automanager(MRA), Media Interconnect Manager(MIM) and
Media Interconnect Client(MIC).

[1] https://www.spinics.net/lists/netdev/msg623647.html
[2] https://www.spinics.net/lists/netdev/msg624378.html
[3] https://www.spinics.net/lists/netdev/msg627500.html
[4] https://www.spinics.net/lists/netdev/msg641005.html
[5] https://github.com/microchip-ung/mrp/tree/patch-v5

-v5:
  - use nla_parse_nested
  - rework the usage of the rcu in br_mrp
  - reorder patches
  - few other small issues raised by Nikolay

-v4:
  - extend existing netlink interface to add mrp support
  - use rcu locks

-v3:
  - move MRP state machine in userspace
  - create generic netlink interface for configuring the HW using switchdev API

-v2:
  - extend switchdev API to offload to HW

Horatiu Vultur (9):
  bridge: uapi: mrp: Add mrp attributes.
  bridge: mrp: Update Kconfig and Makefile
  bridge: mrp: Expose function br_mrp_port_open
  bridge: mrp: Add MRP interface.
  switchdev: mrp: Extend switchdev API to offload MRP
  bridge: switchdev: mrp: Implement MRP API for switchdev
  bridge: mrp: Connect MRP API with the switchev API
  bridge: mrp: Implement netlink interface to configure MRP
  bridge: mrp: Integrate MRP into the bridge

 include/linux/if_bridge.h       |   1 +
 include/linux/mrp_bridge.h      |  24 ++
 include/net/switchdev.h         |  62 ++++
 include/uapi/linux/if_bridge.h  |  43 +++
 include/uapi/linux/if_ether.h   |   1 +
 include/uapi/linux/mrp_bridge.h |  84 +++++
 net/bridge/Kconfig              |  12 +
 net/bridge/Makefile             |   2 +
 net/bridge/br_device.c          |   3 +
 net/bridge/br_if.c              |   2 +
 net/bridge/br_input.c           |   3 +
 net/bridge/br_mrp.c             | 559 ++++++++++++++++++++++++++++++++
 net/bridge/br_mrp_netlink.c     | 164 ++++++++++
 net/bridge/br_mrp_switchdev.c   | 144 ++++++++
 net/bridge/br_netlink.c         |   5 +
 net/bridge/br_private.h         |  35 ++
 net/bridge/br_private_mrp.h     |  61 ++++
 net/bridge/br_stp.c             |   6 +
 net/bridge/br_stp_if.c          |   5 +
 19 files changed, 1216 insertions(+)
 create mode 100644 include/linux/mrp_bridge.h
 create mode 100644 include/uapi/linux/mrp_bridge.h
 create mode 100644 net/bridge/br_mrp.c
 create mode 100644 net/bridge/br_mrp_netlink.c
 create mode 100644 net/bridge/br_mrp_switchdev.c
 create mode 100644 net/bridge/br_private_mrp.h

-- 
2.17.1

