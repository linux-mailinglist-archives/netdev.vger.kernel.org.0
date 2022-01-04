Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B797484497
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiADPba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:31:30 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:42895 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiADPba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:31:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641310290; x=1672846290;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=D+nNloB9Ju1xXoW173i1Md8Bk6VNvrMQj8pmRK55e30=;
  b=Rt9yupnPvEBDgadq3WzCESFqNjNo545c9ueWj1P+RnjBweVeeNCK1A+D
   nBW8MDLLFzE2I3WKR0756VcVwfrf4FTNK/dfv0M8JI8T03KAWZsSzi4gL
   TAs6TsIJKARVLjCYk4FyaX7rdjbDiZl0zV7sx/ch08c7ZrvUH3wXaxHuG
   D6GBlLoPLFiPcntOhSWDl2Tdk3HPlLmaxXPcG+9/AJEuGVR+CmvmeRftP
   1LC3i0m7GAhrUj4Rc/UZVpnCnEDqM/B36duGJpP1EEPpY/VXItmATnaxV
   /Oq1lPsT+lpnBGIAg+2W8lr58SrUF4zatF6tny88J6DoffNriQ0vVCHqw
   g==;
IronPort-SDR: C78Bk5j/BjvmFJ4Uu7pVZ3s8X5x80zn9Gmf/+68u5UdLZuL3wXgSZr6InyRP8Km5pQd1tWoOMJ
 LKC79QCrGwrPPrGgPjpPIPUVWFfONvGXQLEnEzc7diizbbAd2GNrJ+40kR2gDk+n23/es8eRxp
 f5Io9l0MyNWUoI9yHsSJX3BqlQzh5Nl7cfG+t2+HVIt578J2RQeuSZDGCiKF9LVaADw3K8DNUl
 /KuguQ3K+e1c2/nHJ1b+Vi6zg9e+4b8D/8wmSH5MxpPmdT0YE6dKVnKRO8ZE0yKRbcK6i1y/gh
 dBs2Rx/JFNaCrS2FNV9cOlBL
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="157467708"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2022 08:31:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 08:31:28 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 4 Jan 2022 08:31:26 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/3] net: lan966x: Extend switchdev with mdb support
Date:   Tue, 4 Jan 2022 16:33:35 +0100
Message-ID: <20220104153338.425250-1-horatiu.vultur@microchip.com>
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

v2->v3:
- rename PGID_FIRST and PGID_LAST to PGID_GP_START and PGID_GP_END
- don't forget and relearn an entry for the CPU if there are more
  references to the cpu.

v1->v2:
- rename lan966x_mac_learn_impl to __lan966x_mac_learn
- rename lan966x_mac_cpu_copy to lan966x_mac_ip_learn
- fix grammar and typos in comments and commit messages
- add reference counter for entries that copy frames to CPU

Horatiu Vultur (3):
  net: lan966x: Add function lan966x_mac_ip_learn()
  net: lan966x: Add PGID_GP_START and PGID_GP_END
  net: lan966x: Extend switchdev with mdb support

 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_mac.c  |  36 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  26 +-
 .../ethernet/microchip/lan966x/lan966x_mdb.c  | 506 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h |   6 +
 .../microchip/lan966x/lan966x_switchdev.c     |   8 +
 .../ethernet/microchip/lan966x/lan966x_vlan.c |   7 +-
 8 files changed, 584 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c

-- 
2.33.0

