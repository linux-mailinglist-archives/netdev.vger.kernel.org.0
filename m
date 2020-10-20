Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6752935CB
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405148AbgJTHch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:32:37 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36512 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405114AbgJTHcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:32:36 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8A9BE1A06C3;
        Tue, 20 Oct 2020 09:32:34 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A7AAE1A03AC;
        Tue, 20 Oct 2020 09:32:26 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 5A1E740243;
        Tue, 20 Oct 2020 09:32:16 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: [PATCH v1 net-next 0/5] net: dsa: felix: psfp support on
Date:   Tue, 20 Oct 2020 15:23:16 +0800
Message-Id: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add gate and police action for tc flower offload to
support Per-Stream Filtering and Policing(PSFP), which is defined in
IEEE802.1Qci.

There is also a TC flower offload to set up VCAPs on ocelot driver.
Because VCAPs use chain 10000-21255, we set chain 30000 to offload to
gate and police action to run PSFP module.

example:
	> tc qdisc add dev swp0 clsact
	> tc filter add dev swp0 ingress chain 0 pref 49152 flower \
		skip_sw action goto chain 30000
	> tc filter add dev swp0 ingress chain 30000 protocol 802.1Q \
		flower skip_sw dst_mac  42:01:3E:72:2F:6B vlan_id 1 \
		action gate index 1 base-time 0 \
			sched-entry OPEN 6000 3 -1 \
		action police index 1 rate 10Mbit burst 10000

Xiaoliang Yang (5):
  net: mscc: ocelot: add and export MAC table lookup operations
  net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
  net: dsa: felix: add gate action offload based on tc flower
  net: mscc: ocelot: use index to set vcap policer
  net: dsa: felix: add police action for tc flower offload

 drivers/net/dsa/ocelot/Makefile           |   3 +-
 drivers/net/dsa/ocelot/felix.c            |  25 +
 drivers/net/dsa/ocelot/felix.h            |  18 +
 drivers/net/dsa/ocelot/felix_flower.c     | 683 ++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix_vsc9959.c    |  14 +-
 drivers/net/ethernet/mscc/ocelot.c        |  33 +-
 drivers/net/ethernet/mscc/ocelot.h        |  13 -
 drivers/net/ethernet/mscc/ocelot_flower.c |  19 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 107 ++--
 include/soc/mscc/ocelot.h                 |  43 +-
 include/soc/mscc/ocelot_ana.h             |  10 +
 11 files changed, 903 insertions(+), 65 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_flower.c

-- 
2.17.1

