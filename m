Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E81946E5D0
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhLIJts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:49:48 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51024 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhLIJtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:49:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639043175; x=1670579175;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H9emzqfCJxabt8C/rJJT+w9pGDpoWbI4jlQ6KX7mAp8=;
  b=Q4xNSRXLnqEd68jZaKTgiwkIE3VukwtT7L0qMj8O6FdMkBtU8t6icFPP
   eIScTMCOLITOBTaepxTCdUsvcmAQWHWFTKjgUOY8rLbsSttyPC8Js3FHM
   M+tZ5PqMTK/k8zCCBM9UrhhN17jmScwaofbL4/cV+5pV/lVE9Kzh12RPn
   US3NnHtswmGGSijmeMIEfSyKX26mwtRk0H51a7FsXBO3EsJt/IDUpFU0f
   eixtrTV1GvOC1wuWCHfkR+ZEBu5w/eadW+23UUFE4sqh6jc1hFFmGgfIh
   CrT6fFhy8IByHa57qysKGDN6IJbFRjv9swqzrEdv2YOQP9FrU6W9J2v/Q
   g==;
IronPort-SDR: GA//ScbG5It7MG7JrqmiMeV5lQzi0odZsDDEAUlLpdWRrRckBqTeqB1lu+6Egcm9IUlk3Bumka
 N4lGR65DeqTfEyWEHrP4dGA1V8844mVVcs1vkqQU2fXonVAhzuHUwhZmqM3rgCnvLfFRcCsERv
 Dlm1dcqlxDUy2mpRmQtw7+GyfU6k30p8L/Kga/5SDkZmYnVWig/CtxxzPtP/LCHLg/+PNEhtZc
 NzzlpomkCxFVprwVRNVN7j2AoZOb3HRd5wIPPicijiEAtXv5PYyn8+KN+JGmtP9AsE3n4Y7DSK
 xLTSwcRXs7oEmsUi3oihG0Yj
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="141832160"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2021 02:46:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 9 Dec 2021 02:46:13 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 9 Dec 2021 02:46:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/6] net: lan966x: Add switchdev and vlan support
Date:   Thu, 9 Dec 2021 10:46:09 +0100
Message-ID: <20211209094615.329379-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends lan966x with switchdev and vlan support.
The first patches just adds new registers and extend the MAC table to
handle the interrupts when a new address is learn/forget.
The last 2 patches adds the vlan and the switchdev support.

v2->v3:
- separate the PVID used when the port is in host mode or vlan unaware
- fix issue when the port was leaving the bridge

v1->v2:
- when allocating entries for the mac table use kzalloc instead of
  devm_kzalloc
- also use GFP_KERNEL instead of GFP_ATOMIC, because is never called
  in atomic context
- when deleting an mac table entry, the order of operations was wrong
- if ana irq is enabled make sure it gets disabled when the driver is
  removed

Horatiu Vultur (6):
  net: lan966x: Add registers that are used for switch and vlan
    functionality
  dt-bindings: net: lan966x: Extend with the analyzer interrupt
  net: lan966x: add support for interrupts from analyzer
  net: lan966x: More MAC table functionality
  net: lan966x: Add vlan support
  net: lan966x: Add switchdev support

 .../net/microchip,lan966x-switch.yaml         |   2 +
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 352 +++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  99 +++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  73 ++-
 .../ethernet/microchip/lan966x/lan966x_regs.h | 129 +++++
 .../microchip/lan966x/lan966x_switchdev.c     | 548 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_vlan.c | 446 ++++++++++++++
 8 files changed, 1637 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c

-- 
2.33.0

