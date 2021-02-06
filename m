Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D67B311EBA
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 17:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhBFQrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 11:47:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50112 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230194AbhBFQrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 11:47:03 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 116GkCvO024398;
        Sat, 6 Feb 2021 08:46:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=p7LIXipTBOIhUQ64UgfKYEgES92zLGVjk5ZaAQiralQ=;
 b=Sg36fEujPb3umyn3NUoW9igKiNPxUrS5djFRYBvRdhQcLCQYGcXfAK89Kq1/qJGk7TAC
 YAZLGXffzOcWAgloidr8qDrXRu+z0Z8g25ge+jxAr1QPDC9DWiymXeHYncchXO8r9GG2
 u3x2rcHtmnoRdjjgy6Ckj23OYAFZXw4YbHM6fhFcm10ITRKJZenQ09pj4cCDrny/8zpN
 bH/x7dV4k6F/xcr9DZfcyIjLsLr/0uLlv3tmr1xVYULf5ZDEQODD44GFqkXuQzu3IuW8
 zLOsWFe08TpFUtrXpYGYFEoZVzluPSWc0NAx4l2dHFoLK8ishdI2zylN8o7BNhPolnxE Ow== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq09w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Feb 2021 08:46:12 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:46:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 6 Feb 2021 08:46:09 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 168893F7040;
        Sat,  6 Feb 2021 08:46:06 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v8 net-next 00/15] net: mvpp2: Add TX Flow Control support
Date:   Sat, 6 Feb 2021 18:45:46 +0200
Message-ID: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-06_06:2021-02-05,2021-02-06 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Armada hardware has a pause generation mechanism in GOP (MAC).
The GOP generate flow control frames based on an indication programmed in Ports Control 0 Register. There is a bit per port.
However assertion of the PortX Pause bits in the ports control 0 register only sends a one time pause.
To complement the function the GOP has a mechanism to periodically send pause control messages based on periodic counters.
This mechanism ensures that the pause is effective as long as the Appropriate PortX Pause is asserted.

Problem is that Packet Processor that actually can drop packets due to lack of resources not connected to the GOP flow control generation mechanism.
To solve this issue Armada has firmware running on CM3 CPU dedicated for Flow Control support.
Firmware monitors Packet Processor resources and asserts XON/XOFF by writing to Ports Control 0 Register.

MSS shared SRAM memory used to communicate between CM3 firmware and PP2 driver.
During init PP2 driver informs firmware about used BM pools, RXQs, congestion and depletion thresholds.

The pause frames are generated whenever congestion or depletion in resources is detected.
The back pressure is stopped when the resource reaches a sufficient level.
So the congestion/depletion and sufficient level implement a hysteresis that reduces the XON/XOFF toggle frequency.

Packet Processor v23 hardware introduces support for RX FIFO fill level monitor.
Patch "add PPv23 version definition" to differ between v23 and v22 hardware.
Patch "add TX FC firmware check" verifies that CM3 firmware supports Flow Control monitoring.

v7 --> v8
- Reorder "always compare hw-version vs MVPP21" and "add PPv23 version definition" commits
- Typo fixes
- Remove condition fix from "add RXQ flow control configurations"

v6 --> v7
- Reduce patch set from 18 to 15 patches
 - Documentation change combined into a single patch
 - RXQ and BM size change combined into a single patch
 - Ring size change check moved into "add RXQ flow control configurations" commit

v5 --> v6
- No change

v4 --> v5
- Add missed Signed-off
- Fix warnings in patches 3 and 12
- Add revision requirement to warning message
- Move mss_spinlock into RXQ flow control configurations patch
- Improve FCA RXQ non occupied descriptor threshold commit message

v3 --> v4
- Remove RFC tag

v2 --> v3
- Remove inline functions
- Add PPv2.3 description into marvell-pp2.txt
- Improve mvpp2_interrupts_mask/unmask procedure
- Improve FC enable/disable procedure
- Add priv->sram_pool check
- Remove gen_pool_destroy call
- Reduce Flow Control timer to x100 faster

v1 --> v2
- Add memory requirements information
- Add EPROBE_DEFER if of_gen_pool_get return NULL
- Move Flow control configuration to mvpp2_mac_link_up callback
- Add firmware version info with Flow control support

Konstantin Porotchkin (1):
  dts: marvell: add CM3 SRAM memory to cp11x ethernet device tree

Stefan Chulski (14):
  doc: marvell: add cm3-mem and PPv2.3 description
  net: mvpp2: add CM3 SRAM memory map
  net: mvpp2: always compare hw-version vs MVPP21
  net: mvpp2: add PPv23 version definition
  net: mvpp2: increase BM pool and RXQ size
  net: mvpp2: add FCA periodic timer configurations
  net: mvpp2: add FCA RXQ non occupied descriptor threshold
  net: mvpp2: enable global flow control
  net: mvpp2: add RXQ flow control configurations
  net: mvpp2: add ethtool flow control configuration support
  net: mvpp2: add BM protection underrun feature support
  net: mvpp2: add PPv23 RX FIFO flow control
  net: mvpp2: set 802.3x GoP Flow Control mode
  net: mvpp2: add TX FC firmware check

 Documentation/devicetree/bindings/net/marvell-pp2.txt |   4 +-
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi         |  10 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h            | 128 ++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c       | 563 ++++++++++++++++++--
 4 files changed, 655 insertions(+), 50 deletions(-)

-- 
1.9.1

