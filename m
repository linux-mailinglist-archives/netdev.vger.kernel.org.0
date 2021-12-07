Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6398646BBA6
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhLGMvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:51:41 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:44522 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhLGMvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 07:51:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638881290; x=1670417290;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GSFl0lxwG+rAhUfPmFgFPzlH18s+gJG17lbveWkb5O4=;
  b=YrdMjZhfex0b+4/fcTzjBYpaHBRHO/k8VpNUDR92ufFeSwC+SFQeQqE+
   ibrhdIAbKXcl6o4Y212oU3PX178DFDmxKbob1sNJD9iKLgqtoaQ8byO5k
   jnueQFEvH6zLWGaAo088h6KPs5mKufbzpcpNMTn3imrQrKE5JQR50AMUQ
   LwwIvUPAly9YESxef/IRnigVOOGJkVh/7JnwwG8wz7DQ/8xaetLjNVbVN
   IqaJD2ZKUzO9VC2ToH3H++0mIV2x1/LxckviElwEgbOyCc0zMz/ekg0IA
   4V3guCYla/ihO166d9FPwbW41gOLrTDBwRCAQ4xZeUJwDyPi/f/sMa8ME
   g==;
IronPort-SDR: PY0Rq9FXp4oYrPJhXNN6S5qtnUyKT27SAYFp8X4LyTIS3UxKuJqBqZq8nBwx27TYRQKiBz9iN+
 d2NWMndyivjd3Wwo8VEmu06d7hneYCmJ+0VvSqqVpV0X0i9J0achpwYY4wEdENR+3J/VsK+58X
 uT9/f6joLkdgWTk6FOuTsGJgR+4KWBnWFM73+Ky9yn5owPHeYPVjCVQrI2ZpfFY/vEIENoaRWd
 BrnDVYW//gct/ONIKS2iASBcqtbC/uZ8iLKFhGooyc850gEJLMO1GbPHobkio5ab7UB68qJvXr
 IGnpo4zlnuEGqnTebMJ7/0Wl
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="78754888"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2021 05:48:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 7 Dec 2021 05:48:09 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 7 Dec 2021 05:48:07 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/6] net: lan966x: Add switchdev and vlan support
Date:   Tue, 7 Dec 2021 13:48:32 +0100
Message-ID: <20211207124838.2215451-1-horatiu.vultur@microchip.com>
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
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 352 ++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  99 +++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  72 ++-
 .../ethernet/microchip/lan966x/lan966x_regs.h | 129 +++++
 .../microchip/lan966x/lan966x_switchdev.c     | 544 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_vlan.c | 439 ++++++++++++++
 8 files changed, 1625 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c

-- 
2.33.0

