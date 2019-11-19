Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33CFE102F2E
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfKSWTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:19:40 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34570 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfKSWTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:19:39 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJUOc027114;
        Tue, 19 Nov 2019 16:19:30 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574201970;
        bh=OVWUr6H7+NPhAQ36hNSfkkjB63CECP6SOAGTnl6UXkU=;
        h=From:To:CC:Subject:Date;
        b=YtZAX1y7+6lwJDILgKOIjsKBgt4rpnVSWOHz+Ky9wSfeNBD2HCfBd3mmu4NBAIPlp
         sQe2+PkZl7Ci1SsCWhkg12uhwjc9ash14ZRZrsdFaSab8dg5uIpDInR4kZbXymxuPb
         T7SAEHNQMrH0i183I0iKkx/xn8cAVs4aK8OXvseg=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAJMJUZI017826
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 Nov 2019 16:19:30 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 16:19:27 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 16:19:27 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJQNU084737;
        Tue, 19 Nov 2019 16:19:27 -0600
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
Subject: [PATCH v7 net-next 00/13] net: ethernet: ti: introduce new cpsw switchdev based driver
Date:   Wed, 20 Nov 2019 00:19:12 +0200
Message-ID: <20191119221925.28426-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Thank you All for review of v6.

There are no significant changes in this version, just fixed comments to v6.

--- v6
The major change in this version is DT bindings conversation to json-schema, and
fixed other comments to v5. Also added patch to clean up ALE on init and netif
restart.

--- v5
The major part of work done in this iteration is rebasing on top of net-next
with XDP series from Ivan Khoronzhuk [3], and enable XDP support in the new
CPSW switchdev driver (it was little bit painful ;(). There are mostly no
functional changes in new CPSW driver, just few fixes, sync with old driver
and cleanups/optimizations. So, I've kept rest of cover letter unchanged.

---
This series originally based on work [1][2] done by
Ilias Apalodimas <ilias.apalodimas@linaro.org>.

This the RFC v5 which introduces new CPSW switchdev based driver which is 
operating in dual-emac mode by default, thus working as 2 individual
network interfaces. The Switch mode can be enabled by configuring devlink driver
parameter "switch_mode" to 1/true:
	devlink dev param set platform/48484000.switch \
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

patches #1 - 5: preparation patches which also moves common code to cpsw_priv.c
patches #6 - 9: Introduce TI CPSW switch driver based on switchdev and new
 DT bindings
patch #10: new CPSW switchdev driver documentation
patch #11: adds DT nodes for new CPSW switchdev driver added for DRA7 SoC
patch #12: adds DT nodes for new cpsw switchdev driver for am571x-idk board
patch #13: enables build of TI CPSW driver

Most of the contents of the previous cover-letter have been added in
new driver documentation, so please refer to that for configuration,
testing and future work.

These patches can be found at (branch contains some additional patches required
for testing on top of net-next):
 https://github.com/grygoriyS/linux.git
 branch: lkml-5.4-switch-tbd-v7

changes in v7:
 - patch 2: added check for devm_kmalloc_array() return value
 - patch 6: fixed comments

changes in v6: https://lkml.org/lkml/2019/11/9/108
 - DT bindings converted to json-schema
 - netdev initialization is split on creation and registration.
   The netdevs registration happens now at the end of the pobe.
 - reworked cpsw_set_pauseparam() to use PHYlib APIs.
 - other comments for v5 fixed

v5: https://patchwork.kernel.org/cover/11208785/
 - rebase on top of net-next with XDP series from Ivan Khoronzhuk [3],
   and enable XDP support in the new CPSW switchdev driver
   cpsw driver (tested XDP_DROP only)
 - sync with old cpsw driver
 - implement comments from  Ivan Khoronzhuk and Rob Herring
 - fixed "NETDEV WATCHDOG: .." warning after interface after interface UP/DOWN,
   missed TX wake in cpsw_adjust_link()

v4: https://patchwork.kernel.org/cover/11010523/
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

[1] https://patchwork.ozlabs.org/cover/929367/
[2] https://patches.linaro.org/cover/136709/
[3] https://patchwork.kernel.org/cover/11035813/

Grygorii Strashko (9):
  net: ethernet: ti: ale: clean ale tbl on init and intf restart
  net: ethernet: ti: cpsw: allow untagged traffic on host port
  net: ethernet: ti: cpsw: resolve build deps of cpsw drivers
  net: ethernet: ti: cpsw: move set of common functions in cpsw_priv
  dt-bindings: net: ti: add new cpsw switch driver bindings
  phy: ti: phy-gmii-sel: dependency from ti cpsw-switchdev driver
  ARM: dts: dra7: add dt nodes for new cpsw switch dev driver
  ARM: dts: am571x-idk: enable for new cpsw switch dev driver
  arm: omap2plus_defconfig: enable new cpsw switchdev driver

Ilias Apalodimas (4):
  net: ethernet: ti: ale: modify vlan/mdb api for switchdev
  net: ethernet: ti: introduce cpsw  switchdev based driver part 1 -
    dual-emac
  net: ethernet: ti: introduce cpsw switchdev based driver part 2 -
    switch
  Documentation: networking: add cpsw switchdev based driver
    documentation

 .../bindings/net/ti,cpsw-switch.yaml          |  240 ++
 .../device_drivers/ti/cpsw_switchdev.txt      |  210 ++
 .../devlink-params-ti-cpsw-switch.txt         |   10 +
 arch/arm/boot/dts/am571x-idk.dts              |   27 +
 arch/arm/boot/dts/am572x-idk.dts              |    5 +
 arch/arm/boot/dts/am574x-idk.dts              |    5 +
 arch/arm/boot/dts/am57xx-idk-common.dtsi      |    5 -
 arch/arm/boot/dts/dra7-l4.dtsi                |   52 +
 arch/arm/configs/omap2plus_defconfig          |    1 +
 drivers/net/ethernet/ti/Kconfig               |   19 +-
 drivers/net/ethernet/ti/Makefile              |    2 +
 drivers/net/ethernet/ti/cpsw.c                | 1374 +----------
 drivers/net/ethernet/ti/cpsw_ale.c            |  150 +-
 drivers/net/ethernet/ti/cpsw_ale.h            |   11 +
 drivers/net/ethernet/ti/cpsw_new.c            | 2048 +++++++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.c           | 1246 +++++++++-
 drivers/net/ethernet/ti/cpsw_priv.h           |   79 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  589 +++++
 drivers/net/ethernet/ti/cpsw_switchdev.h      |   15 +
 drivers/phy/ti/Kconfig                        |    4 +-
 20 files changed, 4752 insertions(+), 1340 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
 create mode 100644 Documentation/networking/device_drivers/ti/cpsw_switchdev.txt
 create mode 100644 Documentation/networking/devlink-params-ti-cpsw-switch.txt
 create mode 100644 drivers/net/ethernet/ti/cpsw_new.c
 create mode 100644 drivers/net/ethernet/ti/cpsw_switchdev.c
 create mode 100644 drivers/net/ethernet/ti/cpsw_switchdev.h

-- 
2.17.1

