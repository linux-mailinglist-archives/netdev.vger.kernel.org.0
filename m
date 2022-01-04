Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728E1483FAB
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiADKQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:16:43 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:54822 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiADKQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:16:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641291402; x=1672827402;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jYwHEUohWlHA9ZfzkZKjxiGu0qgbRV+D2EaTz+wS6zg=;
  b=xJ/bWcJgb5+fpDT6gBDbQLiQqW3sllcIwOwK7kfSrPFZ5tjNEJbM+5tK
   1++UwNVXw8YLNRjcvtMo3IkJGLUQuQ9YjsQ+mxdSRIF1OZmdbiGSji8sQ
   PZbMEHhLe/FdutHaVhjS64pRmSqBz1ySChL/zh5gogYy7pztdk+l8HtR9
   6YoBO5Ow3yx6SoCfeve3fWy0JDkpNsCDETHOpyrTVgP1MMeHwNJ8lc4Cf
   HPOflvF1TGjMhW2TuNrtMdZpcp4XZxXVRKzWs0vtUiJnDVGhdcBEFEdWk
   Rdv6Sh8SKRTOXfytQi01QhwhUqlN6gs/YQwzDMCMOR0l+gQPBEFzm5Hd2
   Q==;
IronPort-SDR: KexvFnxP8Sp4qs9WiDZzZabu/VcGBzvJK1JirmyTtVL9dsn/H+mKaepk23H6hLJEKJEK2+c1Yg
 FTW1hu3EmtScf/nv21oSSpdO1HhE/gmJEXpGzDtiCaUvfEpkume9tRNqLAIh6vv9vVsJCoSRN4
 1bOorX10t4GNPmkzdjA3r/LiFnIXNnpZoo8N1x5G8beJbEOFaZDUwYbkw6EvwFNnxyt0YIs/ZN
 iVrmp5Pumh6ZgpkEppBRqVm/hUaQ03JNaqGeAlgtk7T9Eauil4rpMu3tvK/BSQ7GexH6/UWkJ8
 PDgXmlKjPL4JiRLXfJRlyA1W
X-IronPort-AV: E=Sophos;i="5.88,260,1635231600"; 
   d="scan'208";a="81362558"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2022 03:16:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 03:16:41 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 4 Jan 2022 03:16:39 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/3] net: lan966x: Extend switchdev with mdb support
Date:   Tue, 4 Jan 2022 11:18:46 +0100
Message-ID: <20220104101849.229195-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends lan966x with mdb support by implementing
the switchdev callbacks: SWITCHDEV_OBJ_ID_PORT_MDB and
SWITCHDEV_OBJ_ID_HOST_MDB.
It adds support for both ipv4/ipv6 entries and l2 entries.

v1->v2:
- rename lan966x_mac_learn_impl to __lan966x_mac_learn
- rename lan966x_mac_cpu_copy to lan966x_mac_ip_learn
- fix grammar and typos in comments and commit messages
- add reference counter for entries that copy frames to CPU

Horatiu Vultur (3):
  net: lan966x: Add function lan966x_mac_ip_learn()
  net: lan966x: Add PGID_FIRST and PGID_LAST
  net: lan966x: Extend switchdev with mdb support

 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_mac.c  |  33 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  24 +-
 .../ethernet/microchip/lan966x/lan966x_mdb.c  | 487 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h |   6 +
 .../microchip/lan966x/lan966x_switchdev.c     |   8 +
 .../ethernet/microchip/lan966x/lan966x_vlan.c |   7 +-
 8 files changed, 560 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c

-- 
2.33.0

