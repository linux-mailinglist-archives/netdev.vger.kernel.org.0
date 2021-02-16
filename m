Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0480F31D246
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhBPVo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:44:29 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:61401 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhBPVo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:44:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613511866; x=1645047866;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=70pTgPudqkcV6r9RtS3PrcUAeOt0oFNkyIhOREHyv0A=;
  b=umXddGyzV3ZG9HHNk5PEn1Vx/qb7DUMjuQSu0xs6q5IeN8762VhT5sE/
   YnaX4tgWX422pHiWyouEGfaL/DaHuXd6oBBPN9RPcH150hYjGPO5h2QJD
   OhjVJsaEJOdU8KAVW/+HxJCpHN4qvMI9b24R1lTSXKL3XU9jXrDPo/4VR
   0qcmmKQBXgwAumnadwa4FVnySXEU0nXfK6abznRFu05Pbn7FE+jQjfDCe
   eWIOHy40WfFg9t1E42Ws+lgd+0lH5mRKMbouFn8OcinRNHJPUzNo/Xzuz
   uMBeNouCv1fCdiZT2LweGKFVOih9Uyxz6HNiLc2MrEsNAub+HRWWVrLgI
   w==;
IronPort-SDR: 7NuJzLrqylyvYIcRPLEixoDxGt5s+bSguWUioaqKmiFz4PRjuZssg/kfphbCVZQ/1zOejNuA0c
 r73148osYRqkoeKe0KOfukNKaNMmvG0fkD5tAaryrvjvnOFXcltqUTLjm6sZV83UhMLMyKOfkh
 FuXJL71aqkkHW8Kvh+I/s1MSTuD1RaDY/O25KErr0GYnGYd8OIqC7cqlkxj+vvkJCKzx3A/JHq
 KIvVahZxynPiQDN1lQVPl1hX+D1OCx/mD7rc8WQEPZ1YxpO4/oSQUICAKCf9XJqWyFNpCVH5Jx
 1Rs=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="44324912"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 14:43:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 14:42:59 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 16 Feb 2021 14:42:56 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jiri@resnulli.us>, <ivecera@redhat.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <rasmus.villemoes@prevas.dk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 0/8] bridge: mrp: Extend br_mrp_switchdev_*
Date:   Tue, 16 Feb 2021 22:41:57 +0100
Message-ID: <20210216214205.32385-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends MRP switchdev to allow the SW to have a better
understanding if the HW can implement the MRP functionality or it needs
to help the HW to run it. There are 3 cases:
- when HW can't implement at all the functionality.
- when HW can implement a part of the functionality but needs the SW
  implement the rest. For example if it can't detect when it stops
  receiving MRP Test frames but it can copy the MRP frames to CPU to
  allow the SW to determine this.  Another example is generating the MRP
  Test frames. If HW can't do that then the SW is used as backup.
- when HW can implement completely the functionality.

So, initially the SW tries to offload the entire functionality in HW, if
that fails it tries offload parts of the functionality in HW and use the
SW as helper and if also this fails then MRP can't run on this HW.

Based on these new calls, implement the switchdev for Ocelot driver. This
is an example where the HW can't run completely the functionality but it
can help the SW to run it, by trapping all MRP frames to CPU.

Also this patch series adds MRP support to DSA and implements the Felix
driver which just reuse the Ocelot functions. This part was just compiled
tested because I don't have any HW on which to do the actual tests.

v4:
 - remove ifdef MRP from include/net/switchdev.h
 - move MRP implementation for Ocelot in a different file such that
   Felix driver can use it.
 - extend DSA with MRP support
 - implement MRP support for Felix.
v3:
 - implement the switchdev calls needed by Ocelot driver.
v2:
 - fix typos in comments and in commit messages
 - remove some of the comments
 - move repeated code in helper function
 - fix issue when deleting a node when sw_backup was true

Horatiu Vultur (8):
  switchdev: mrp: Remove CONFIG_BRIDGE_MRP
  switchdev: mrp: Extend ring_role_mrp and in_role_mrp
  bridge: mrp: Add 'enum br_mrp_hw_support'
  bridge: mrp: Extend br_mrp_switchdev to detect better the errors
  bridge: mrp: Update br_mrp to use new return values of
    br_mrp_switchdev
  net: mscc: ocelot: Add support for MRP
  net: dsa: add MRP support
  net: dsa: felix: Add support for MRP

 drivers/net/dsa/ocelot/felix.c         |  38 ++++++
 drivers/net/ethernet/mscc/Makefile     |   1 +
 drivers/net/ethernet/mscc/ocelot.c     |  10 +-
 drivers/net/ethernet/mscc/ocelot_mrp.c | 175 +++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c |  60 +++++++++
 include/linux/dsa/ocelot.h             |   5 +
 include/net/dsa.h                      |  12 ++
 include/net/switchdev.h                |  12 +-
 include/soc/mscc/ocelot.h              |  45 +++++++
 net/bridge/br_mrp.c                    |  43 +++---
 net/bridge/br_mrp_switchdev.c          | 171 ++++++++++++++----------
 net/bridge/br_private_mrp.h            |  38 ++++--
 net/dsa/dsa_priv.h                     |  26 ++++
 net/dsa/port.c                         |  48 +++++++
 net/dsa/slave.c                        |  22 ++++
 net/dsa/switch.c                       | 105 +++++++++++++++
 net/dsa/tag_ocelot.c                   |   8 ++
 17 files changed, 715 insertions(+), 104 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_mrp.c

-- 
2.27.0

