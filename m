Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408F041D4B7
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348821AbhI3Hvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:51:55 -0400
Received: from inva020.nxp.com ([92.121.34.13]:43414 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348701AbhI3Hvy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 03:51:54 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 325D91A17CC;
        Thu, 30 Sep 2021 09:50:11 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id ED8301A17CA;
        Thu, 30 Sep 2021 09:50:10 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 3E922183AC94;
        Thu, 30 Sep 2021 15:50:08 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com
Subject: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Date:   Thu, 30 Sep 2021 15:59:40 +0800
Message-Id: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VSC9959 hardware supports Per-Stream Filtering and Policing(PSFP).
This patch series add PSFP support on tc flower offload of ocelot
driver. Use chain 30000 to distinguish PSFP from VCAP blocks. Add gate
and police set to support PSFP in VSC9959 driver.

v5->v6 changes:
 - Modify ocelot_mact_lookup() parameters.
 - Use parameters ssid and sfid instead of streamdata in
   ocelot_mact_learn_streamdata() function.
 - Serialize STREAMDATA and MAC table write.

v4->v5 changes:
 - Add MAC table lock patch, and move stream data write in
   ocelot_mact_learn_streamdata().
 - Add two sections of VCAP policers to Seville platform.

v3->v4 changes:
 - Introduce vsc9959_psfp_sfi_table_get() function in patch where it is
   used to fix compile warning.
 - Store MAC entry type before FRER set, and recover it after FRER
   disabled.

v2->v3 changes:
 - Reorder first two patches. Export struct ocelot_mact_entry, then add
   ocelot_mact_lookup() and ocelot_mact_write() functions.
 - Add PSFP list to struct ocelot, and init it by using
   ocelot->ops->psfp_init().

v1->v2 changes:
 - Use tc flower offload of ocelot driver to support PSFP add and delete.
 - Add PSFP tables add/del functions in felix_vsc9959.c.

Vladimir Oltean (1):
  net: mscc: ocelot: serialize access to the MAC table

Xiaoliang Yang (7):
  net: mscc: ocelot: add MAC table stream learn and lookup operations
  net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
  net: mscc: ocelot: add gate and police action offload to PSFP
  net: dsa: felix: support psfp filter on vsc9959
  net: dsa: felix: add stream gate settings for psfp
  net: mscc: ocelot: use index to set vcap policer
  net: dsa: felix: use vcap policer to set flow meter for psfp

 drivers/net/dsa/ocelot/felix.c             |   4 +
 drivers/net/dsa/ocelot/felix.h             |   4 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 694 ++++++++++++++++++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   8 +
 drivers/net/ethernet/mscc/ocelot.c         | 135 +++-
 drivers/net/ethernet/mscc/ocelot.h         |  13 -
 drivers/net/ethernet/mscc/ocelot_flower.c  |  84 ++-
 drivers/net/ethernet/mscc/ocelot_vcap.c    | 103 +--
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   7 +
 include/soc/mscc/ocelot.h                  |  52 +-
 include/soc/mscc/ocelot_ana.h              |  10 +
 include/soc/mscc/ocelot_vcap.h             |   1 +
 12 files changed, 1034 insertions(+), 81 deletions(-)

-- 
2.17.1

