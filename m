Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D8221EA3F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgGNHjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:39:02 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:50693 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgGNHjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594712341; x=1626248341;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RmNBacgCYC3gH1oQYbu8uXXhpnAXbpfr/5u4Vf38fwA=;
  b=SBErY5tYVuCSOrLiVekykka18a/e5h1aGjKXLkoZ74ZzbrPYqVMED0J+
   e1Iz1Cri2cMQxLbVze+okcwON6MSU8FUz0Sx0osysDi6Qq/zwYjE5KUe4
   jkJhn+kj5c2qL5dSpSOwSawmlkEMnQPhWghkTPMRdPt2UhWOP3ouA+MYw
   cymK5Q8HZ+MaKnye6Fv8AyH1rC+xE+cTACT0Vruz/ZEytWD4AL6pVAdwf
   jRwsUx3la29d1IOVK/J+ltXjPSm02r44uFG8gECbDBhPQfJ09WO6UxsEc
   v0EZnQaLqbR0EzVPOpqU9fqMcuVEzzPlDlEurI+qm/tGISg77NmJ06Nnj
   g==;
IronPort-SDR: HP58hKqbjDlFzE95tiB0r0ZXdfNNJKh/ois8JDy4KJFTT2sxTqmQDS2Rat035DHD65ctOEp/sq
 ZBBJVTMPtdg5+vLcgrHlxzBP+oyMvwf+rIruWEYqIqylvbnNPP/x3MlQOhMRa4eaNxk7+etGaq
 NHF4Dny1nKipPB7QP/u6/1iWib5eJKYd/BDP5c5RNRVC0d4rwMPAK1FfNfjeiFqWeXzwr0tbfV
 F4gFA/tdOQPjaEoJDUxIpICaErabvtNSYB/qhJS4qaW21iQb45FQVdGSdzU27W1MZ/4WzRYrFF
 X9E=
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="81753242"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2020 00:39:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 00:38:28 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 14 Jul 2020 00:38:58 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 00/12] bridge: mrp: Add support for interconnect ring
Date:   Tue, 14 Jul 2020 09:34:46 +0200
Message-ID: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
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

v4:
  - always cancel delay work if the MRP instance is deleted or interconnect role
    is disabled but allow only to start to send InTest frames only if the role
    is MIM.

v3:
  - update 'br_mrp_set_in_role' to stop sending test if the role is disabled
    and don't allow to set a different interconnect port if there is already
    one.

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
 include/uapi/linux/if_bridge.h     |  58 +++
 include/uapi/linux/if_link.h       |   1 +
 include/uapi/linux/mrp_bridge.h    |  38 ++
 net/bridge/br_mrp.c                | 576 +++++++++++++++++++++++++++--
 net/bridge/br_mrp_netlink.c        | 182 ++++++++-
 net/bridge/br_mrp_switchdev.c      |  62 ++++
 net/bridge/br_netlink.c            |   3 +
 net/bridge/br_private_mrp.h        |  27 +-
 tools/include/uapi/linux/if_link.h |   1 +
 11 files changed, 951 insertions(+), 36 deletions(-)

-- 
2.27.0

