Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AAC33DE74
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhCPUPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:15:25 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:60742 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhCPUPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 16:15:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615925710; x=1647461710;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wA+Du8m8Qh4/LSugkq9GbwzM02giXPr7Er3/bQpvtqQ=;
  b=rmXqxgMOjgl1Jb1Y/Ffjw7qO+828/K+g/qo5yc3WQz6t8I6HsMbSY1YG
   x7fNIVrqqjjkhzL92snU8lpOve6v3YnGKCuhYApNMfKaMVGS1AVBBltlE
   bQAmWakZlx2om4PDUUA9Kp3yJ4DXm0Oe9DPbNvIKThq127VqNxkAWQPWY
   PknslTVqUl3IkZh2P7/7MDeIogO/JL++/hj/xTLgzA6vdUcbr0mT+bzXs
   HacYp5eztniEjPLjF+SXhU/TYo4EqGDgLtoc8IdA0/A4cZODxWBuRPvcg
   5mNi1OoEvcZfxKmBfxQAMprGo3gF+a3O+m/3myuHsnZ+cdJzUGgLnU6ON
   g==;
IronPort-SDR: YP3ae1PLCCgBeGpgshajD+t5pU386CmyGKZ8IM4pz8pJ14fM4dq3v7eWZnBzoR3gLHiqHgnoSe
 fHJgFN48b3U/cux5PH+qspGLxepIkJyDvUdTAO+0O4BLI9dcsmuXQgA1P4M9cUBo95tFI+ilKj
 ID871YfdlFv9PO+SXZpU0QKc5MTBw1Veef5mg5hvW4cj3EMteqXMIbZkgmKK1jSfbokFuT45IX
 CBPpQ9JMhZmWwO3Sc8EKyuFSL/PLm+vdNVI1jWj9Z/CoUJmj4VPKgcBRGzaTVYF/yT9Lp0BzRB
 rxI=
X-IronPort-AV: E=Sophos;i="5.81,254,1610434800"; 
   d="scan'208";a="110230390"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2021 13:15:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 13:15:07 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 16 Mar 2021 13:15:05 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/3] net: ocelot: Extend MRP
Date:   Tue, 16 Mar 2021 21:10:16 +0100
Message-ID: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends the current support of MRP in Ocelot driver.
Currently the forwarding of the frames happened in SW because all frames
were trapped to CPU. With this patch the MRP frames will be forward in HW.

v1 -> v2:
 - create a patch series instead of single patch
 - rename ocelot_mrp_find_port to ocelot_mrp_find_partner_port
 - rename PGID_MRP to PGID_BLACKHOLE
 - use GFP_KERNEL instead of GFP_ATOMIC
 - fix other whitespace issues

Horatiu Vultur (3):
  net: ocelot: Add PGID_BLACKHOLE
  net: ocelot: Extend MRP
  net: ocelot: Remove ocelot_xfh_get_cpuq

 drivers/net/ethernet/mscc/ocelot.c     |  12 +-
 drivers/net/ethernet/mscc/ocelot_mrp.c | 233 +++++++++++++++++--------
 include/linux/dsa/ocelot.h             |   5 -
 include/soc/mscc/ocelot.h              |  12 +-
 net/dsa/tag_ocelot.c                   |   8 -
 5 files changed, 167 insertions(+), 103 deletions(-)

-- 
2.30.1

