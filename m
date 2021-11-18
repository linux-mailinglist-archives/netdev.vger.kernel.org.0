Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0555D45587B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245447AbhKRKDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:03:04 -0500
Received: from inva021.nxp.com ([92.121.34.21]:59492 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245421AbhKRKCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 05:02:52 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 83A862033CA;
        Thu, 18 Nov 2021 10:59:49 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 48E212033C4;
        Thu, 18 Nov 2021 10:59:49 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id E33F5183AD05;
        Thu, 18 Nov 2021 17:59:46 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, po.liu@nxp.com, leoyang.li@nxp.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com, vladimir.oltean@nxp.com,
        kuba@kernel.org, mingkai.hu@nxp.com
Subject: [PATCH v7 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Date:   Thu, 18 Nov 2021 18:11:56 +0800
Message-Id: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VSC9959 hardware supports Per-Stream Filtering and Policing(PSFP).
This patch series add PSFP support on tc flower offload of ocelot
driver. Use chain 30000 to distinguish PSFP from VCAP blocks. Add gate
and police set to support PSFP in VSC9959 driver.

v6-v7 changes:
 - Add a patch to restrict psfp rules on ingress port.
 - Using stats.drops to show the packet count discarded by the rule.

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

v2->v3 changes:
 - Reorder first two patches. Export struct ocelot_mact_entry, then add
   ocelot_mact_lookup() and ocelot_mact_write() functions.
 - Add PSFP list to struct ocelot, and init it by using
   ocelot->ops->psfp_init().

v1->v2 changes:
 - Use tc flower offload of ocelot driver to support PSFP add and delete.
 - Add PSFP tables add/del functions in felix_vsc9959.c.

Xiaoliang Yang (8):
  net: mscc: ocelot: add MAC table stream learn and lookup operations
  net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
  net: mscc: ocelot: add gate and police action offload to PSFP
  net: dsa: felix: support psfp filter on vsc9959
  net: dsa: felix: add stream gate settings for psfp
  net: mscc: ocelot: use index to set vcap policer
  net: dsa: felix: use vcap policer to set flow meter for psfp
  net: dsa: felix: restrict psfp rules on ingress port

 drivers/net/dsa/ocelot/felix.c             |   4 +
 drivers/net/dsa/ocelot/felix.h             |   4 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 819 ++++++++++++++++++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   8 +
 drivers/net/ethernet/mscc/ocelot.c         |  84 ++-
 drivers/net/ethernet/mscc/ocelot.h         |  13 -
 drivers/net/ethernet/mscc/ocelot_flower.c  |  84 ++-
 drivers/net/ethernet/mscc/ocelot_vcap.c    | 103 ++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   7 +
 include/soc/mscc/ocelot.h                  |  50 +-
 include/soc/mscc/ocelot_ana.h              |  10 +
 include/soc/mscc/ocelot_vcap.h             |   1 +
 12 files changed, 1115 insertions(+), 72 deletions(-)

-- 
2.17.1

