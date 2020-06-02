Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDB41EB51F
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgFBFX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:23:59 -0400
Received: from inva020.nxp.com ([92.121.34.13]:44040 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbgFBFX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 01:23:59 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 21F421A0B6E;
        Tue,  2 Jun 2020 07:23:57 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8E1551A0A5A;
        Tue,  2 Jun 2020 07:23:47 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 9A8BB402E4;
        Tue,  2 Jun 2020 13:23:35 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Subject: [PATCH v2 net-next 00/10] net: ocelot: VCAP IS1 and ES0 support
Date:   Tue,  2 Jun 2020 13:18:18 +0800
Message-Id: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series patches adds support for VCAP IS1 and ES0 module, each VCAP
correspond to a flow chain to offload.

VCAP IS1 supports FLOW_ACTION_VLAN_MANGLE action to filter MAC, IP,
VLAN, protocol, and TCP/UDP ports keys and retag vlian tag,
FLOW_ACTION_PRIORITY action to classify packages to different Qos in hw.

VCAP ES0 supports FLOW_ACTION_VLAN_PUSH action to filter vlan keys
and push a specific vlan tag to frames.

Changes since v1->v2:
 - Use different chain to assign rules to different hardware VCAP, and
   use action goto chain to express flow order.
 - Add FLOW_ACTION_PRIORITY to add Qos classification on VCAP IS1.
 - Multiple actions support.
 - Fix some code issues.

Vladimir Oltean (3):
  net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
  net: mscc: ocelot: generalize existing code for VCAP
  net: dsa: tag_ocelot: use VLAN information from tagging header when
    available

Xiaoliang Yang (7):
  net: mscc: ocelot: allocated rules to different hardware VCAP TCAMs by
    chain index
  net: mscc: ocelot: change vcap to be compatible with full and quad
    entry
  net: mscc: ocelot: VCAP IS1 support
  net: mscc: ocelot: VCAP ES0 support
  net: mscc: ocelot: multiple actions support
  net: ocelot: return error if rule is not found
  net: dsa: felix: correct VCAP IS2 keys offset

 drivers/net/dsa/ocelot/felix.c            |   2 -
 drivers/net/dsa/ocelot/felix.h            |   2 -
 drivers/net/dsa/ocelot/felix_vsc9959.c    | 202 +++++-
 drivers/net/ethernet/mscc/ocelot.c        |  11 +
 drivers/net/ethernet/mscc/ocelot_ace.c    | 729 ++++++++++++++++------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  26 +-
 drivers/net/ethernet/mscc/ocelot_board.c  |   5 +-
 drivers/net/ethernet/mscc/ocelot_flower.c |  95 ++-
 drivers/net/ethernet/mscc/ocelot_io.c     |  17 +
 drivers/net/ethernet/mscc/ocelot_regs.c   |  21 +-
 drivers/net/ethernet/mscc/ocelot_s2.h     |  64 --
 include/soc/mscc/ocelot.h                 |  39 +-
 include/soc/mscc/ocelot_vcap.h            | 199 +++++-
 net/dsa/tag_ocelot.c                      |  29 +
 14 files changed, 1105 insertions(+), 336 deletions(-)
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h

-- 
2.17.1

