Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE507219CBF
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 12:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGIKBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 06:01:33 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:42139 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgGIKBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 06:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594288891; x=1625824891;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fuqrA3hBx0oUTK0Wob6y9NOyZ1ajsJ7JRJ0RnMkhdjo=;
  b=CqcyMsT35MTjV4QodYuegZ12fdhoTLMi4HL9MtXoNo0zlf1nGFY2El7w
   Y56oiBfHBn7V4pO6dcIZ7Nx2VIVadsnmlvEsIyBBtiBf1v/w8YxQ5k3Gj
   70zSwCQAYqJSfT0m2qH2f9mPeyjpxdMDEB1MpSNWIe+A2/bHX457NBj4y
   mF6h+EWJLEGVJujmCHEkGbR+aKLz29wDQdO1y99rJILcuaVebDeM0FNYI
   SL37q/tqrTRsVC2qJxri7rppjtmErlO31H0IKiJzmkIuNRX1i00V1ej+P
   3Fj7rvZPb4moAYHAItG4qsH0jts8oM0KnDrEYOpgRtnZYcp4iLltXCAT1
   Q==;
IronPort-SDR: 64psNRRJhtW3KqC9wHTgA3Wgo1LJBlHL8RpkY1y+xlNEVkbVG7CPJdElzikMpknXaRgHB+xqNx
 IxEcpaqyIqFzgD3dAs1jozH681udk11GNr0BdlByVYS9ez/8gouoK1i6F6tlsdAKoYcrQH+BXh
 FhEplFBUAwyZQHXQcPpkQ8wtXPa3CWc1NAua28GCf3CcKPQgDeXGBS5yCexTM9BOYyJPWxogzP
 upa33CGIwWBNfpDxmY9EeBJM2l27is+/bNjC+YwziGj67mEqmLunD0woq9xKPk5Cv5wSqeYiPs
 vGU=
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="scan'208";a="79261621"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jul 2020 03:01:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 9 Jul 2020 03:01:04 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 9 Jul 2020 03:01:27 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 00/12] bridge: mrp: Add support for interconnect ring
Date:   Thu, 9 Jul 2020 12:00:28 +0200
Message-ID: <20200709100040.554623-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends existing MRP to add support for interconnect ring.  An
interconnect ring is a ring that connects 2 rings. In this way is possible to
connect multiple rings. Each interconnect ring is form of 4 nodes, in which 3
have the role MIC(Media Redundancy Interconnect Client) and one has the role
MIM(Media Redundancy Interconnect Manager). All these nodes need to have the
same ID and the ID needs to be unique between multiple interconnect rings. And 2
nodes needs to be part of one ring and the other 2 nodes needs to be part of the
other ring that is connected.

                 +---------+
                 |         |
      +----------|   MRM   |---------------+
      |          |         |               |
      |          +---------+               |
      |                                    |
      |                                    |
      |                                    |
+--------------+                  +-----------------+
|              |                  |                 |
|  MRC/MIC     |------------------|    MRC/MIM      |
|              |                  |                 |
+--------------+                  +-----------------+
      |                                     |
      |Interconnect port                    |Interconnect port
      |                                     |
      |                                     |
+--------------+                  +-----------------+
|              |                  |                 |
|  MRC/MIC     |----------------- |   MRC/MIC       |
|              |                  |                 |
+--------------+                  +-----------------+
      |                                     |
      |                                     |
      |          +---------+                |
      |          |         |                |
      +----------|  MRM    |----------------+
                 |         |
                 +---------+

Each node in a ring needs to have one of the following ring roles, MRM or MRC.
And it can also have an interconnect role like MIM or MIC if it is part of an
interconnect ring. In the figure above the MRM doesn't have any interconnect
role but the MRC from the top ring have the interconnect roles MIC respectively
MIM. Therefore it is not possible for a node to have only an interconnect role.

There are 2 ways for interconnect ring to detect when is open or closed:
1. To use CCM frames on the interconnect port to detect when the interconnect
   link goes down/up. This mode is called LC-mode.
2. To send InTest frames on all 3 ports(2 ring ports and 1 interconnect port)
   and detect when these frames are received back. This mode is called RC-mode.

This patch series adds support only for RC-mode. Where MIM sends InTest frames
on all 3 ports and detects when it receives back the InTest. When it receives
the InTest it means that the ring is closed so it would set the interconnect
port in blocking state. If it stops receiving the InTest frames then it would
set the port in forwarding state and it would send InTopo frames. These InTopo
frames will be received by MRM nodes and process them. And then the MRM will
send Topo frames in the rings so each client will clear its FDB.

v2:
  - rearrange structures not to contain holes
  - stop sending MRP_InTest frames when the MRP instance is deleted

Horatiu Vultur (12):
  switchdev: mrp: Extend switchdev API for MRP Interconnect
  bridge: uapi: mrp: Extend MRP attributes for MRP interconnect
  bridge: mrp: Extend bridge interface
  bridge: mrp: Extend br_mrp for MRP interconnect
  bridge: mrp: Rename br_mrp_port_open to br_mrp_ring_port_open
  bridge: mrp: Add br_mrp_in_port_open function
  bridge: switchdev: mrp: Extend MRP API for switchdev for MRP
    Interconnect
  bridge: mrp: Implement the MRP Interconnect API
  bridge: mrp: Extend MRP netlink interface for configuring MRP
    interconnect
  bridge: uapi: mrp: Extend MRP_INFO attributes for interconnect status
  bridge: mrp: Extend br_mrp_fill_info
  net: bridge: Add port attribute IFLA_BRPORT_MRP_IN_OPEN

 include/linux/if_bridge.h          |   1 +
 include/net/switchdev.h            |  38 ++
 include/uapi/linux/if_bridge.h     |  58 ++++
 include/uapi/linux/if_link.h       |   1 +
 include/uapi/linux/mrp_bridge.h    |  38 ++
 net/bridge/br_mrp.c                | 537 +++++++++++++++++++++++++++--
 net/bridge/br_mrp_netlink.c        | 182 +++++++++-
 net/bridge/br_mrp_switchdev.c      |  62 ++++
 net/bridge/br_netlink.c            |   3 +
 net/bridge/br_private_mrp.h        |  27 +-
 tools/include/uapi/linux/if_link.h |   1 +
 11 files changed, 912 insertions(+), 36 deletions(-)

-- 
2.27.0

