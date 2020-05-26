Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205F71B9075
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgDZNXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 09:23:50 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:33733 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgDZNXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 09:23:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587907428; x=1619443428;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=wBLVVkoMyYA1If2FwuXPTpEkdXUY2hGxV/FwWuEIMPc=;
  b=gvfXYTboW+3g76XDXHnlBbr/n/AEE3IFnF9eXuVK3UhO85BLaDa6dNmx
   c2xNuvvqsTxSWRh2i9BaGvm1PMiNgqVPPjpa5B6a/HZr5SclmtDAVl9OY
   6WXGFmiEvDz1U3qfWnNh4U17qF/bDTZyfrgTJEZscUCZc39vrIMzrOu60
   uc979wfD/vtPArdXgjml57KzGZVNYak1Vy3sT3hleQHq+F26Md3dz48Xr
   D/vxzCyPLYVNvwigAGZ4orTpxOH71vX+fUmVTbrHQ6FoHUQ2K5h8c+R4p
   I/ikVXdXF7gS+kei7MIekhd/KcPatm1nCK1noHXRvZs5dFLWely+JsGf+
   g==;
IronPort-SDR: 29mCBfxMzQpr2W5cIe5MppxAkhtOq+TeiICTLtYGnNdlBQlzQoFy7i4dUiJUtEkerSr4kq1b/8
 UDxSp5Mq+SLKGvSyoz3f/A3xkHNy/zgcJVGF+Tov0cSBs2+eNlHrpjaQcXWrqDy7oqNle3fjBJ
 q3bxKO5j9Kd9fPR4h1hkpNn1saRQo0VFH/MGuFAzI1BGKviOlc51JhaGcck4fZZ6fp2uSiqLGM
 7wzPW/WOTDEHAoHK1X/tQ/tU1OVJMD/Nl4nGDjsxP6HaK3TpoxbTgnurhFUOVXCNPCCJEs6vmI
 pXI=
X-IronPort-AV: E=Sophos;i="5.73,320,1583218800"; 
   d="scan'208";a="74586820"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2020 06:23:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Apr 2020 06:23:47 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Sun, 26 Apr 2020 06:23:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 00/11] net: bridge: mrp: Add support for Media Redundancy Protocol(MRP)
Date:   Sun, 26 Apr 2020 15:21:57 +0200
Message-ID: <20200426132208.3232-1-horatiu.vultur@microchip.com>
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

Based on the previous RFC[1][2][3][4][5], and patches[6][7][8], the MRP state
machine and all the timers were moved to userspace, except for the timers used
to generate MRP Test frames.  In this way the userspace doesn't know and should
not know if the HW or the kernel will generate the MRP Test frames. The
following changes were added to the bridge to support the MRP:
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

The userspace application that is using the new netlink can be found here[9].

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
[6] https://www.spinics.net/lists/netdev/msg645378.html
[7] https://www.spinics.net/lists/kernel/msg3484685.html
[8] https://www.spinics.net/lists/netdev/msg646202.html
[9] https://github.com/microchip-ung/mrp/tree/patch-v9

-v4:
  - fix comments in br_mrp.c
  - use skb_header_pointer to get br_mrp_tlv_hdr
  - fix line over 80 characters

-v3:
  - fix unused variables

-v2:
  - drop patch 4
  - add port flag BR_MRP_LOST_CONT;
  - another fix for bisectability

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

Horatiu Vultur (11):
  bridge: uapi: mrp: Add mrp attributes.
  bridge: mrp: Update Kconfig
  bridge: mrp: Extend bridge interface
  net: bridge: Add port attribute IFLA_BRPORT_MRP_RING_OPEN
  bridge: mrp: Add MRP interface.
  switchdev: mrp: Extend switchdev API to offload MRP
  bridge: switchdev: mrp: Implement MRP API for switchdev
  bridge: mrp: Connect MRP API with the switchdev API
  bridge: mrp: Implement netlink interface to configure MRP
  bridge: mrp: Integrate MRP into the bridge
  net: bridge: Add checks for enabling the STP.

 include/linux/if_bridge.h          |   2 +
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
 net/bridge/br_mrp.c                | 559 +++++++++++++++++++++++++++++
 net/bridge/br_mrp_netlink.c        | 120 +++++++
 net/bridge/br_mrp_switchdev.c      | 140 ++++++++
 net/bridge/br_netlink.c            |  12 +-
 net/bridge/br_private.h            |  38 +-
 net/bridge/br_private_mrp.h        |  63 ++++
 net/bridge/br_stp.c                |   6 +
 net/bridge/br_stp_if.c             |  11 +-
 net/bridge/br_sysfs_br.c           |   4 +-
 tools/include/uapi/linux/if_link.h |   1 +
 22 files changed, 1163 insertions(+), 8 deletions(-)
 create mode 100644 include/uapi/linux/mrp_bridge.h
 create mode 100644 net/bridge/br_mrp.c
 create mode 100644 net/bridge/br_mrp_netlink.c
 create mode 100644 net/bridge/br_mrp_switchdev.c
 create mode 100644 net/bridge/br_private_mrp.h

-- 
2.17.1

