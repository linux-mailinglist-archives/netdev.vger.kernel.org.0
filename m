Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B2F4EEAC
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfFUSOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:14:14 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37632 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfFUSON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:14:13 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5LIDO9b093884;
        Fri, 21 Jun 2019 13:13:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561140804;
        bh=tb5A5ehXhFlHKqGEjrLhCvWDs+f6NTPxYCOYamFA4Qc=;
        h=From:To:CC:Subject:Date;
        b=OBRUDDm98e9kCBwCKav5HQiDBDP+FbzAk0iwLAjG6iS5Gu9vgLiwkGYg+KVBOeH1j
         Hw9S5/0e4ZiAv0oy5DerUSSNpRhRY+oeJEYCj1NI0PA71d3UTiGTYxQzZqb41UZAnd
         Zrui44JkZwSy6Izmme2YgDj1WS8wo62mI+JQBrm8=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5LIDOvd002604
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Jun 2019 13:13:24 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 21
 Jun 2019 13:13:24 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 21 Jun 2019 13:13:23 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5LIDMs7113027;
        Fri, 21 Jun 2019 13:13:23 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v4 net-next 00/11] net: ethernet: ti: introduce new cpsw switchdev based driver
Date:   Fri, 21 Jun 2019 21:13:03 +0300
Message-ID: <20190621181314.20778-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This series based on work [1][2] done by Ilias Apalodimas <ilias.apalodimas@linaro.org>.

This the RFC v4 which introduces new CPSW switchdev based driver which is 
operating in dual-emac mode by default, thus working as 2 individual
network interfaces. The Switch mode can be enabled by configuring devlink driver
parameter "switch_mode" to 1/true:
	devlink dev param set platform/48484000.ethernet_switch \
	name switch_mode value 1 cmode runtime
This can be done regardless of the state of Port's netdev devices - UP/DOWN, but
Port's netdev devices have to be in UP before joining the bridge to avoid
overwriting of bridge configuration as CPSW switch driver completely reloads its
configuration when first Port changes its state to UP.
When the both interfaces joined the bridge - CPSW switch driver will start
marking packets with offload_fwd_mark flag unless "ale_bypass=0".
All configuration is implemented via switchdev API. 

The previous solution of tracking both Ports joined the bridge
(from netdevice_notifier) proved to be not correct as changing CPSW switch
driver mode required cleanup of ALE table and CPSW settings which happens
while second Port is joined bridge and as result configuration loaded
by bridge for the first Port became corrupted.

The introduction of the new CPSW switchdev based driver (cpsw_new.c) is split
on two parts: Part 1 - basic dual-emac driver; Part 2 switchdev support.
Such approach has simplified code development and testing alot. And, I hope, 
it will help with better review.

patches #1 - 4: preparation patches which also moves common code to cpsw_priv.c
patches #5 - 8: Introduce TI CPSW switch driver based on switchdev and new
 DT bindings
patch #9: CPSW switchdev driver documentation
patch #10: DT nodes for new CPSW switchdev driver added for DRA7/am571x-idk as
and example.
patch #11: enables build of TI CPSW driver

Most of the contents of the previous cover-letter have been added in
new driver documentation, so please refer to that for configuration,
testing and future work.

These patches can be found at:
 git@git.ti.com:~gragst/ti-linux-kernel/gragsts-ti-linux-kernel.git
 branch: lkml-5.1-switch-tbd-v2

[1] https://patchwork.ozlabs.org/cover/929367/
[2] https://patches.linaro.org/cover/136709/

Changes in v4:
 - finished split of common CPSW code
 - added devlink support
 - changed CPSW mode configuration approach: from netdevice_notifier to devlink
   parameter
 - refactor and clean up ALE changes which allows to modify VLANs/MDBs entries
 - added missed support for port QDISC_CBS and QDISC_MQPRIO
 - the CPSW is split on two parts: basic dual_mac driver and switchdev support
 - added missed callback .ndo_get_port_parent_id()
 - reworked ingress frames marking in switch mode (offload_fwd_mark)
 - applied comments from Andrew Lunn

v3: https://lwn.net/Articles/786677/
Changes in v3:
- alot of work done to split properly common code between legacy and switchdev
  CPSW drivers and clean up code
- CPSW switchdev interface updated to the current LKML switchdev interface
- actually new CPSW switchdev based driver introduced
- optimized dual_mac mode in new driver. Main change is that in promiscuous
mode P0_UNI_FLOOD (both ports) is enabled in addition to ALLMULTI (current
port) instead of ALE_BYPASS.  So, port in non promiscuous mode will keep
possibility of mcast and vlan filtering.
- changed bridge join sequnce: now switch mode will be enabled only when
both ports joined the bridge. CPSW will be switched to dual_mac mode if any
port leave bridge. ALE table is completly cleared and then refiled while
switching to switch mode - this simplidies code a lot, but introduces some
limitation to bridge setup sequence:
 ip link add name br0 type bridge
 ip link set dev br0 type bridge ageing_time 1000
 ip link set dev br0 type bridge vlan_filtering 0 <- disable
 echo 0 > /sys/class/net/br0/bridge/default_vlan

 ip link set dev sw0p1 up <- add ports
 ip link set dev sw0p2 up
 ip link set dev sw0p1 master br0
 ip link set dev sw0p2 master br0

 echo 1 > /sys/class/net/br0/bridge/default_vlan <- enable
 ip link set dev br0 type bridge vlan_filtering 1
 bridge vlan add dev br0 vid 1 pvid untagged self
- STP tested with vlan_filtering 1/0. To make STP work I've had to set
  NO_SA_UPDATE for all slave ports (see comment in code). It also required to
  statically register STP mcast address {0x01, 0x80, 0xc2, 0x0, 0x0, 0x0};
- allowed build both TI_CPSW and TI_CPSW_SWITCHDEV drivers
- PTP can be enabled on both ports in dual_mac mode

Grygorii Strashko (7):
  net: ethernet: ti: cpsw: allow untagged traffic on host port
  net: ethernet: ti: cpsw: resolve build deps of cpsw drivers
  net: ethernet: ti: cpsw: move set of common functions in cpsw_priv
  dt-bindings: net: ti: add new cpsw switch driver bindings
  phy: ti: phy-gmii-sel: dependency from ti cpsw-switchdev driver
  ARM: dts: am57xx-idk: add dt nodes for new cpsw switch dev driver
  arm: omap2plus_defconfig: enable CONFIG_TI_CPSW_SWITCHDEV

Ilias Apalodimas (4):
  net: ethernet: ti: cpsw: ale: modify vlan/mdb api for switchdev
  net: ethernet: ti: introduce cpsw  switchdev based driver part 1 -
    dual-emac
  net: ethernet: ti: introduce cpsw switchdev based driver part 2 -
    switch
  Documentation: networking: add cpsw switchdev based driver
    documentation

 .../bindings/net/ti,cpsw-switch.txt           |  147 ++
 .../device_drivers/ti/cpsw_switchdev.txt      |  207 ++
 arch/arm/boot/dts/am571x-idk.dts              |   28 +
 arch/arm/boot/dts/am572x-idk.dts              |    5 +
 arch/arm/boot/dts/am574x-idk.dts              |    5 +
 arch/arm/boot/dts/am57xx-idk-common.dtsi      |    2 +-
 arch/arm/boot/dts/dra7-l4.dtsi                |   53 +
 arch/arm/configs/omap2plus_defconfig          |    1 +
 drivers/net/ethernet/ti/Kconfig               |   19 +-
 drivers/net/ethernet/ti/Makefile              |    2 +
 drivers/net/ethernet/ti/cpsw.c                |  978 +--------
 drivers/net/ethernet/ti/cpsw_ale.c            |  146 +-
 drivers/net/ethernet/ti/cpsw_ale.h            |   11 +
 drivers/net/ethernet/ti/cpsw_new.c            | 1913 +++++++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.c           |  977 ++++++++-
 drivers/net/ethernet/ti/cpsw_priv.h           |   47 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  589 +++++
 drivers/net/ethernet/ti/cpsw_switchdev.h      |   15 +
 drivers/phy/ti/Kconfig                        |    4 +-
 19 files changed, 4157 insertions(+), 992 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,cpsw-switch.txt
 create mode 100644 Documentation/networking/device_drivers/ti/cpsw_switchdev.txt
 create mode 100644 drivers/net/ethernet/ti/cpsw_new.c
 create mode 100644 drivers/net/ethernet/ti/cpsw_switchdev.c
 create mode 100644 drivers/net/ethernet/ti/cpsw_switchdev.h

-- 
2.17.1

