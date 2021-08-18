Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916183EFB59
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238534AbhHRGKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:10:49 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48030 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239156AbhHRGJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 02:09:08 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DA8341A48C8;
        Wed, 18 Aug 2021 08:08:31 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A1B231A48D7;
        Wed, 18 Aug 2021 08:08:31 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 8920D183ACDC;
        Wed, 18 Aug 2021 14:08:29 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com
Subject: [RFC v2 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Date:   Wed, 18 Aug 2021 14:19:14 +0800
Message-Id: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VSC9959 hardware supports Per-Stream Filtering and Policing(PSFP).
This patch series add PSFP support on tc flower offload of ocelot
driver. Use chain 30000 to distinguish PSFP from VCAP blocks. Add gate
and police set to support PSFP in VSC9959 driver.

v1->v2 changes:
- Use tc flower offload of ocelot driver to support PSFP add and delete.
- Add PSFP tables add/del functions in felix_vsc9959.c.
- Use list_for_each_entry to simplify the code.
- Fix PSFP tables add/del issue.

Vladimir Oltean (1):
  net: mscc: ocelot: add MAC table write and lookup operations

Xiaoliang Yang (7):
  net: mscc: ocelot: export MAC table lookup and write
  net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
  net: mscc: ocelot: add gate and police action offload to PSFP
  net: dsa: felix: support psfp filter on vsc9959
  net: dsa: felix: add stream gate settings for psfp
  net: mscc: ocelot: use index to set vcap policer
  net: dsa: felix: use vcap policer to set flow meter for psfp

 drivers/net/dsa/ocelot/felix.c             |   2 +
 drivers/net/dsa/ocelot/felix.h             |  10 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 692 ++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot.c         |  53 +-
 drivers/net/ethernet/mscc/ocelot.h         |  13 -
 drivers/net/ethernet/mscc/ocelot_flower.c  |  74 ++-
 drivers/net/ethernet/mscc/ocelot_vcap.c    | 103 +--
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   7 +
 include/soc/mscc/ocelot.h                  |  39 +-
 include/soc/mscc/ocelot_ana.h              |  10 +
 include/soc/mscc/ocelot_vcap.h             |   1 +
 11 files changed, 932 insertions(+), 72 deletions(-)

-- 
2.17.1

