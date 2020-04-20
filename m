Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBC21B0F6F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgDTPLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:11:41 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:38932 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgDTPLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587395500; x=1618931500;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=s3zQXyGmklidFX59symdn4Qk7S18R1EzO24cUdDxYl0=;
  b=qpYH9t9yvf8FrIeX7VwOtBhLm/dzg8GfVxTdSOLPolvMQL1Nl8x7Kcai
   Qv92P6jCBCmRRXV5c6g5+OoyggNkeUi+cKrwzmJLLfFlUapBJ7aT6c7JS
   YDz5pj66zK+uI+Y3zd1FFWV+rzm5/agiIgdGmX6iyRZhxPR1JcKGLWpDv
   UOpdCy2o+gVivXCwVbg2BVrvuLfHbO1S9/1bkNlBCDG8VbWvqvTBki+vo
   u6NIS60WKiOOwOPUalTFZl3kL4E3JsDBuVXmpgjILIGarHCwAQeM5PaAe
   zPRdWoiLr+mRrQXucYeD89bPKNX6rvOtTPSLlApqMUrlIAM+HipVu6zSh
   Q==;
IronPort-SDR: q2ZpVZlh1iXMbaXRUk1oL5rNmob3Uo9PiUrrjZohVNAfgo+F6zE0AWUq9F7Qiigp4JPxlGtH0L
 6vpqt5xJTkjbJT3OrOju1BcxHngD1LcaNPuXEDkcxQzFCi5UelqQDStyW1+WvV0eLCkYyJw89X
 WdbzHjxr3f6zJGPwrwxm/4L28Mob6qx0RrOKLtG2DP1ujyckCmWL2yiuI32daz1yCCDYW0+Nj7
 yIoLqjvlD8cz2YEUlAnuUxG7LG/FMqdAZ7VD1P3DIZ2PZDlpswhukSFJH8Wo3euJIuPzyWHz9g
 vFI=
X-IronPort-AV: E=Sophos;i="5.72,406,1580799600"; 
   d="scan'208";a="72755047"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2020 08:11:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Apr 2020 08:11:39 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 20 Apr 2020 08:11:08 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 00/13] net: bridge: mrp: Add support for Media Redundancy Protocol(MRP)
Date:   Mon, 20 Apr 2020 17:09:34 +0200
Message-ID: <20200420150947.30974-1-horatiu.vultur@microchip.com>
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

Based on the previous RFC[1][2][3][4][5], the MRP state machine and all the
timers were moved to userspace, except for the timers used to generate MRP Test
frames.  In this way the userspace doesn't know and should not know if the HW or
the kernel will generate the MRP Test frames. The following changes were added
to the bridge to support the MRP:
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

The userspace application that is using the new netlink can be found here[6].

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
[5] https://www.spinics.net/lists/netdev/msg643991.html
[6] https://github.com/microchip-ung/mrp/tree/patch-v6

-v1:
  - fix bisectability issues
  - in case of errors use extack

-RFC v5:
  - use nla_parse_nested
  - rework the usage of the rcu in br_mrp
  - reorder patches
  - few other small issues raised by Nikolay

-RFC v4:
  - extend existing netlink interface to add mrp support
  - use rcu locks

-RFC v3:
  - move MRP state machine in userspace
  - create generic netlink interface for configuring the HW using switchdev API

-RFC v2:
  - extend switchdev API to offload to HW

Horatiu Vultur (13):
  bridge: uapi: mrp: Add mrp attributes.
  net: bridge: Add port attribute IFLA_BRPORT_MRP_RING_OPEN
  bridge: mrp: Update Kconfig
  bridge: mrp: Expose function br_mrp_port_open
  bridge: mrp: Add MRP interface.
  bridge: mrp: Extend bridge interface
  switchdev: mrp: Extend switchdev API to offload MRP
  bridge: switchdev: mrp: Implement MRP API for switchdev
  bridge: mrp: Connect MRP API with the switchev API
  bridge: mrp: Implement netlink interface to configure MRP
  bridge: mrp: Update Makefile
  bridge: mrp: Integrate MRP into the bridge
  net: bridge: Add checks for enabling the STP.

 include/linux/if_bridge.h          |   1 +
 include/linux/mrp_bridge.h         |  27 ++
 include/net/switchdev.h            |  62 ++++
 include/uapi/linux/if_bridge.h     |  42 +++
 include/uapi/linux/if_ether.h      |   1 +
 include/uapi/linux/if_link.h       |   1 +
 include/uapi/linux/mrp_bridge.h    |  84 +++++
 net/bridge/Kconfig                 |  12 +
 net/bridge/Makefile                |   2 +
 net/bridge/br_device.c             |   3 +
 net/bridge/br_if.c                 |   2 +
 net/bridge/br_input.c              |   3 +
 net/bridge/br_ioctl.c              |   3 +-
 net/bridge/br_mrp.c                | 551 +++++++++++++++++++++++++++++
 net/bridge/br_mrp_netlink.c        | 117 ++++++
 net/bridge/br_mrp_switchdev.c      | 141 ++++++++
 net/bridge/br_netlink.c            |  15 +-
 net/bridge/br_private.h            |  42 ++-
 net/bridge/br_private_mrp.h        |  60 ++++
 net/bridge/br_stp.c                |   6 +
 net/bridge/br_stp_if.c             |  11 +-
 net/bridge/br_sysfs_br.c           |   4 +-
 tools/include/uapi/linux/if_link.h |   1 +
 23 files changed, 1183 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/mrp_bridge.h
 create mode 100644 include/uapi/linux/mrp_bridge.h
 create mode 100644 net/bridge/br_mrp.c
 create mode 100644 net/bridge/br_mrp_netlink.c
 create mode 100644 net/bridge/br_mrp_switchdev.c
 create mode 100644 net/bridge/br_private_mrp.h

-- 
2.17.1

