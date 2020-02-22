Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E00168FF7
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 16:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgBVP6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 10:58:02 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:53910 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbgBVP6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 10:58:02 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01MFvwsC093862;
        Sat, 22 Feb 2020 09:57:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582387078;
        bh=v87TnDRp0wK5FaNfJZnw3Yr4DuxA5/1VOdOrtkVSA9k=;
        h=From:To:CC:Subject:Date;
        b=hs3f5jzWWjI/sTvA00wxvaQ6jc3u/grJAMWEH6+mUthL3vn2RfpyD2nnqZNeCNsDD
         SGb+B/2YAT9OowB5xw8AISO52L2PNOGRtvWyKMDjmLJCKu+qZ5SomXhe0WFaypRAYH
         VsOlqPDbMI6OImfIZ0UrNAdW7cLSROj6nJ0EzXLA=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01MFvwDE067715
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 22 Feb 2020 09:57:58 -0600
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 22
 Feb 2020 09:57:58 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 22 Feb 2020 09:57:58 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01MFvvtq110592;
        Sat, 22 Feb 2020 09:57:57 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Roger Quadros <rogerq@ti.com>, Tero Kristo <t-kristo@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
CC:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 0/9] net: ethernet: ti: add networking support for k3 am65x/j721e soc
Date:   Sat, 22 Feb 2020 17:57:43 +0200
Message-ID: <20200222155752.22021-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

This series adds basic networking support support TI K3 AM654x/J721E SoC which
have integrated Gigabit Ethernet MAC (Media Access Controller) into device MCU
domain and named MCU_CPSW0 (CPSW2G NUSS).

Formally TRMs refere CPSW2G NUSS as two-port Gigabit Ethernet Switch subsystem
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
   comaptible with TI AM3/4/5 devices

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

This series depends on:
 [for-next PATCH 0/5] phy: ti: gmii-sel: add support for am654x/j721e soc
 https://lkml.org/lkml/2020/2/22/100

TRMs:
 AM654: http://www.ti.com/lit/ug/spruid7e/spruid7e.pdf
 J721E: http://www.ti.com/lit/ug/spruil1a/spruil1a.pdf

Preliminary documentation can be found at:
 http://software-dl.ti.com/processor-sdk-linux/esd/docs/latest/linux/Foundational_Components/Kernel/Kernel_Drivers/Network/K3_CPSW2g.html

[1] https://lwn.net/Articles/808030/

Grygorii Strashko (9):
  net: ethernet: ti: ale: fix seeing unreg mcast packets with promisc
    and allmulti disabled
  net: ethernet: ti: ale: add support for mac-only mode
  net: ethernet: ti: ale: am65: add support for default thread cfg
  dt-binding: ti: am65x: document mcu cpsw nuss
  net: ethernet: ti: introduce am65x/j721e gigabit eth switch subsystem
    driver
  arm64: dts: ti: k3-am65-mcu: add cpsw nuss node
  arm64: dts: k3-am654-base-board: add mcu cpsw nuss pinmux and phy defs
  arm64: dts: ti: k3-j721e-mcu: add mcu cpsw nuss node
  arm64: dts: ti: k3-j721e-common-proc-board: add mcu cpsw nuss pinmux
    and phy defs

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  226 ++
 arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi       |   49 +
 arch/arm64/boot/dts/ti/k3-am65.dtsi           |    1 +
 .../arm64/boot/dts/ti/k3-am654-base-board.dts |   42 +
 .../dts/ti/k3-j721e-common-proc-board.dts     |   43 +
 .../boot/dts/ti/k3-j721e-mcu-wakeup.dtsi      |   49 +
 arch/arm64/boot/dts/ti/k3-j721e.dtsi          |    1 +
 drivers/net/ethernet/ti/Kconfig               |   19 +-
 drivers/net/ethernet/ti/Makefile              |    3 +
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c   |  761 +++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 1985 +++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h      |  143 ++
 drivers/net/ethernet/ti/cpsw_ale.c            |   38 +
 drivers/net/ethernet/ti/cpsw_ale.h            |    4 +
 drivers/net/ethernet/ti/k3-udma-desc-pool.c   |  126 ++
 drivers/net/ethernet/ti/k3-udma-desc-pool.h   |   30 +
 16 files changed, 3518 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-ethtool.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-nuss.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-nuss.h
 create mode 100644 drivers/net/ethernet/ti/k3-udma-desc-pool.c
 create mode 100644 drivers/net/ethernet/ti/k3-udma-desc-pool.h

-- 
2.17.1

