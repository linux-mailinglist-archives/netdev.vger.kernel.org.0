Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AED545B6A4
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241381AbhKXInz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:43:55 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38037 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbhKXInz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:43:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637743245; x=1669279245;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dvQyXqTtQ/LED1YLEl2VYVhtTVZbwMDcEkGNOoTq4+0=;
  b=m+b8306Zq6YLUtQiBjt9aTUpDWKB44XyaoLaZVmqqaXowr/ry1r2sEs7
   I6TlozwTzYBqqcyDhsaeCQD0+bVX3frZ+iw7oFJIDKj9/WLjEroufYwPb
   E+yQZ4JZxqNEB4DxT3oK2gtgmlAhUOUZdrAvWuEbj9Lu2yNR2wNslwZyz
   dUS4z1wGDcrKmHy9rP6/6e76pMlQaJzARO7KILtenDKAWZt1wK3/sokWk
   fi9bGmNAvR+Ybid8izPPmHkF/SyDf1Z6KSD6m2Z98l1Hl6M2anbelexSa
   bLqNawO7LE10211ytIRbLIXbgqRtZ1g7IKPxPYOP9byYk9ZxC4+DTBEES
   A==;
IronPort-SDR: Q7szaPY6RUBEad8GeKjihqq9P5mZeLiZm8DvkDnOq+EZA7PBLcOt8Gb6G/bFjZuBpb5aID3j+m
 pgMN4Ep4c8hwCKVKOX1cWL32eMI3yPKzuilU/ot9heE8tTJPHGGv8Fek6Drm8LzY/bfSpozi7V
 QZ6kP+jXzYBsyh2eIU+69KO+s8PLu18P3iF70cuYsOO2egA7JJSF30HiMPbXd4wgoEO+6KyT5d
 2Enuic4BXuCBmuQmHb80Xxm3/MFzGYf0c6nzkDY4JOaGQzhV5SV6lSQL7/L694eijqyn0+7yFI
 DRlWWa54omrg/3k3QCEvkZMI
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="137575612"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2021 01:40:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 24 Nov 2021 01:40:44 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 24 Nov 2021 01:40:42 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/6] net: lan966x: Add lan966x switch driver
Date:   Wed, 24 Nov 2021 09:39:09 +0100
Message-ID: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add support for Microchip lan966x driver

The lan966x switch is a multi-port Gigabit AVB/TSN Ethernet Switch with
two integrated 10/100/1000Base-T PHYs. In addition to the integrated PHYs,
it supports up to 2RGMII/RMII, up to 3BASE-X/SERDES/2.5GBASE-X and up to
2 Quad-SGMII/Quad-USGMII interfaces.

Initially it adds support only for the ports to behave as simple
NIC cards. In the future patches it would be extended with other
functionality like Switchdev, PTP, Frame DMA, VCAP, etc.

v2->v3:
- fix compiling issues for x86
- fix resource management in first patch

v1->v2:
- add new patch for MAINTAINERS
- add functions lan966x_mac_cpu_learn/forget
- fix build issues with second patch
- fix the reset of the switch, return error if there is no reset controller
- start to use phylink_mii_c22_pcs_decode_state and
  phylink_mii_c22_pcs_encode_advertisement do remove duplicate code


Horatiu Vultur (6):
  dt-bindings: net: lan966x: Add lan966x-switch bindings
  net: lan966x: add the basic lan966x driver
  net: lan966x: add port module support
  net: lan966x: add mactable support
  net: lan966x: add ethtool configuration and statistics
  net: lan966x: Update MAINTAINERS to include lan966x driver

 .../net/microchip,lan966x-switch.yaml         | 149 +++
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/microchip/Kconfig        |   1 +
 drivers/net/ethernet/microchip/Makefile       |   1 +
 .../net/ethernet/microchip/lan966x/Kconfig    |   7 +
 .../net/ethernet/microchip/lan966x/Makefile   |   9 +
 .../microchip/lan966x/lan966x_ethtool.c       | 664 ++++++++++++
 .../ethernet/microchip/lan966x/lan966x_ifh.h  | 173 ++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 101 ++
 .../ethernet/microchip/lan966x/lan966x_main.c | 943 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h | 201 ++++
 .../microchip/lan966x/lan966x_phylink.c       |  96 ++
 .../ethernet/microchip/lan966x/lan966x_port.c | 422 ++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 730 ++++++++++++++
 14 files changed, 3504 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Makefile
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_port.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_regs.h

-- 
2.33.0

