Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4D019015C
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgCWWyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:54:01 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:48260 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgCWWxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 18:53:08 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02NMquNZ112993;
        Mon, 23 Mar 2020 17:52:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585003976;
        bh=ODdbyHqndP5tMn1Y7dSVqZZwdLCJtpnUZLLEgVY0LcI=;
        h=From:To:CC:Subject:Date;
        b=rnn7XpDXOQPg2VMkVGS5PyLtdMFZxoWfm2NhnEDWxc9DCOMcmQhBodA+vARq3Td1w
         IcmwP9wuHwGx0MmSwriZhkU/gHz922G79KX2/2Z2Akr1/7P5kyhBWP053vPNEa4JN+
         KT63/xRRRlV+mipG8pAKinWPcnFQL8U9YGxnQLNE=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02NMqun8049914
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 23 Mar 2020 17:52:56 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 23
 Mar 2020 17:52:56 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 23 Mar 2020 17:52:56 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02NMqteJ079160;
        Mon, 23 Mar 2020 17:52:55 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <robh@kernel.org>, Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v6 00/11] net: ethernet: ti: add networking support for k3 am65x/j721e soc
Date:   Tue, 24 Mar 2020 00:52:43 +0200
Message-ID: <20200323225254.12759-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

This v6 series adds basic networking support support TI K3 AM654x/J721E SoC which
have integrated Gigabit Ethernet MAC (Media Access Controller) into device MCU
domain and named MCU_CPSW0 (CPSW2G NUSS).

Formally TRMs refer CPSW2G NUSS as two-port Gigabit Ethernet Switch subsystem
with port 0 being the CPPI DMA host port and port 1 being the external Ethernet
port, but for 1 external port device it's just Port 0 <-> ALE <-> Port 1 and it's
rather device with HW filtering capabilities then actually switching device.
It's expected to have similar devices, but with more external ports.

The new Host port 0 Communications Port Programming Interface (CPPI5) is
operating by TI AM654x/J721E NAVSS Unified DMA Peripheral Root Complex (UDMA-P)
controller [1].

The CPSW2G contains below modules for which existing code is re-used:
 - MAC SL: cpsw_sl.c
 - Address Lookup Engine (ALE): cpsw_ale.c, basically compatible with K2 66AK2E/G
 - Management Data Input/Output interface (MDIO): davinci_mdio.c, fully 
   compatible with TI AM3/4/5 devices

Basic features supported by CPSW2G NUSS driver:
 - VLAN support, 802.1Q compliant, Auto add port VLAN for untagged frames on
   ingress, Auto VLAN removal on egress and auto pad to minimum frame size.
 - multicast filtering
 - promisc mode
 - TX multiq support in Round Robin or Fixed priority modes
 - RX checksum offload for non-fragmented IPv4/IPv6 TCP/UDP packets
 - TX checksum offload support for IPv4/IPv6 TCP/UDP packets (J721E only).

Features under development:
 - Support for IEEE 1588 Clock Synchronization. The CPSW2G NUSS includes new
   version of Common Platform Time Sync (CPTS)
 - tc-mqprio: priority level Quality Of Service (QOS) support (802.1p)
 - tc-cbs: Support for Audio/Video Bridging (P802.1Qav/D6.0) HW shapers
 - tc-taprio: IEEE 802.1Qbv/D2.2 Enhancements for Scheduled Traffic
 - frame preemption: IEEE P902.3br/D2.0 Interspersing Express Traffic, 802.1Qbu
 - extended ALE features: classifier/policers, auto-aging

Patches 1-6 are intended for netdev, Patches 7-11 are intended for K3 Platform
tree and provided here for testing purposes.

Changes in v6:
 - fixed comments from Rob Herring <robh@kernel.org> and added his Reviewed-by.
 - added Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Changes in v5:
 - renamed files k3-udma-desc-pool.*  k3-udma-desc-pool to k3-cppi-desc-pool.*,
   and API to k3_cppi_desc_pool_* as requested by Peter Ujfalusi <peter.ujfalusi@ti.com>
 - fixed copy-paste err in am65_cpsw_nuss_ndo_slave_set_rx_mode() which blocked
   recieving of mcast frames.
 - added Tested-by: Murali Karicheri <m-karicheri2@ti.com> 

Changes in v4:
 - fixed minor comments from Jakub Kicinski <kuba@kernel.org>
 - dependencies resolved: required phy-rmii-sel changes [2] queued for merge
   except one [3] which is included in this series with Kishon's ask.

Changes in v3:
 - add ARM64 defconfig changes for testing purposes
 - fixed DT yaml definition
 - fixed comments from Jakub Kicinski <kuba@kernel.org>

Changes in v2:
 - fixed DT yaml definition
 - fixed comments from David Miller

v5: https://patchwork.ozlabs.org/cover/1258295/
v4: https://patchwork.ozlabs.org/cover/1256092/
v3: https://patchwork.ozlabs.org/cover/1254568/
v2: https://patchwork.ozlabs.org/cover/1250674/
v1: https://lwn.net/Articles/813087/

TRMs:
 AM654: http://www.ti.com/lit/ug/spruid7e/spruid7e.pdf
 J721E: http://www.ti.com/lit/ug/spruil1a/spruil1a.pdf

Preliminary documentation can be found at:
 http://software-dl.ti.com/processor-sdk-linux/esd/docs/latest/linux/Foundational_Components/Kernel/Kernel_Drivers/Network/K3_CPSW2g.html

[1] https://lwn.net/Articles/808030/
[2] https://lkml.org/lkml/2020/2/22/100
[3] https://lkml.org/lkml/2020/3/3/724

Grygorii Strashko (11):
  phy: ti: gmii-sel: simplify config dependencies between net drivers
    and gmii phy
  net: ethernet: ti: ale: fix seeing unreg mcast packets with promisc
    and allmulti disabled
  net: ethernet: ti: ale: add support for mac-only mode
  net: ethernet: ti: ale: am65: add support for default thread cfg
  dt-binding: ti: am65x: document mcu cpsw nuss
  net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver
  arm64: dts: ti: k3-am65-mcu: add cpsw nuss node
  arm64: dts: k3-am654-base-board: add mcu cpsw nuss pinmux and phy defs
  arm64: dts: ti: k3-j721e-mcu: add mcu cpsw nuss node
  arm64: dts: ti: k3-j721e-common-proc-board: add mcu cpsw nuss pinmux
    and phy defs
  arm64: defconfig: ti: k3: enable dma and networking

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  225 ++
 arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi       |   49 +
 arch/arm64/boot/dts/ti/k3-am65.dtsi           |    1 +
 .../arm64/boot/dts/ti/k3-am654-base-board.dts |   42 +
 .../dts/ti/k3-j721e-common-proc-board.dts     |   43 +
 .../boot/dts/ti/k3-j721e-mcu-wakeup.dtsi      |   49 +
 arch/arm64/boot/dts/ti/k3-j721e.dtsi          |    1 +
 arch/arm64/configs/defconfig                  |    3 +
 drivers/net/ethernet/ti/Kconfig               |   20 +-
 drivers/net/ethernet/ti/Makefile              |    3 +
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c   |  747 +++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 1965 +++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h      |  142 ++
 drivers/net/ethernet/ti/cpsw_ale.c            |   38 +
 drivers/net/ethernet/ti/cpsw_ale.h            |    4 +
 drivers/net/ethernet/ti/k3-cppi-desc-pool.c   |  126 ++
 drivers/net/ethernet/ti/k3-cppi-desc-pool.h   |   30 +
 drivers/phy/ti/Kconfig                        |    3 -
 18 files changed, 3486 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-ethtool.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-nuss.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-nuss.h
 create mode 100644 drivers/net/ethernet/ti/k3-cppi-desc-pool.c
 create mode 100644 drivers/net/ethernet/ti/k3-cppi-desc-pool.h

-- 
2.17.1

