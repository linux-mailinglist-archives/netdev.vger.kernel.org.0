Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412E517C914
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 00:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCFXro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 18:47:44 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43964 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgCFXro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 18:47:44 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 026Nlddr099804;
        Fri, 6 Mar 2020 17:47:39 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583538459;
        bh=ZQXz6SL7X1fiB1jRFJj+IvnVskcIliu4fHSt0jNN+f4=;
        h=From:To:CC:Subject:Date;
        b=CuV5YGiJxJD3eVd4CO1WjmtAF8jCRdQSetr8MbFRBNCVwresX+7DEpOu5OQX7DCq9
         w49b9Qu08BDfZrHZq21+vE38kPQtWqAAyySp9lgYIr2EUDZ+E0OfErWtsmKjeYaA3A
         y6kD/GKH0c3+akNUzpAko5w8IyCqlpsbe+0rXtcc=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 026NldVQ002732
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Mar 2020 17:47:39 -0600
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Mar
 2020 17:47:39 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Mar 2020 17:47:39 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 026NlcoV002278;
        Fri, 6 Mar 2020 17:47:38 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Rob Herring <robh+dt@kernel.org>, Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 0/9] net: ethernet: ti: add networking support for k3 am65x/j721e soc
Date:   Sat, 7 Mar 2020 01:47:25 +0200
Message-ID: <20200306234734.15014-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

This v2 series adds basic networking support support TI K3 AM654x/J721E SoC which
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

This series depends on:
 [for-next PATCH 0/5] phy: ti: gmii-sel: add support for am654x/j721e soc
 https://lkml.org/lkml/2020/2/22/100

Patches 1-5 are intended for netdev, Patches 6-9 are intended for K# Platform
tree and provided here for testing purposes.

Changes:
 - fixed DT yaml definition
 - fixed comments from David Miller

v1: https://lwn.net/Articles/813087/

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
  net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver
  arm64: dts: ti: k3-am65-mcu: add cpsw nuss node
  arm64: dts: k3-am654-base-board: add mcu cpsw nuss pinmux and phy defs
  arm64: dts: ti: k3-j721e-mcu: add mcu cpsw nuss node
  arm64: dts: ti: k3-j721e-common-proc-board: add mcu cpsw nuss pinmux
    and phy defs

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  225 ++
 arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi       |   49 +
 arch/arm64/boot/dts/ti/k3-am65.dtsi           |    1 +
 .../arm64/boot/dts/ti/k3-am654-base-board.dts |   42 +
 .../dts/ti/k3-j721e-common-proc-board.dts     |   43 +
 .../boot/dts/ti/k3-j721e-mcu-wakeup.dtsi      |   49 +
 arch/arm64/boot/dts/ti/k3-j721e.dtsi          |    1 +
 drivers/net/ethernet/ti/Kconfig               |   19 +-
 drivers/net/ethernet/ti/Makefile              |    3 +
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c   |  763 +++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 1991 +++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h      |  143 ++
 drivers/net/ethernet/ti/cpsw_ale.c            |   38 +
 drivers/net/ethernet/ti/cpsw_ale.h            |    4 +
 drivers/net/ethernet/ti/k3-udma-desc-pool.c   |  126 ++
 drivers/net/ethernet/ti/k3-udma-desc-pool.h   |   30 +
 16 files changed, 3525 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-ethtool.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-nuss.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-nuss.h
 create mode 100644 drivers/net/ethernet/ti/k3-udma-desc-pool.c
 create mode 100644 drivers/net/ethernet/ti/k3-udma-desc-pool.h

-- 
2.17.1

