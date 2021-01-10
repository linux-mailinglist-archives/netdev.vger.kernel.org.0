Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7136A2F07FF
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbhAJPda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:33:30 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35236 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726069AbhAJPd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:33:28 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AFR8Yo020540;
        Sun, 10 Jan 2021 07:30:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=54HRB3/0F9AoSN2Z0bS08I+70ZrJBxPcSQXRfKu6iLU=;
 b=Wc95La1p0TOiegWZz6e8UVisrdhneXuvE8635N7jHjy+i/6XYfy8SJy9HF3pURrGlAuN
 o4cdVHG0u5W/IIQ0uhbim9zAz4x2x5boPjDDQ3DcbNxqZwxzR8r8E3VMgekF9sonvNFv
 ShayFsb/xGSbhgKrP13j2w1ualKAHOq0U4COS80qy1okAbcKMu6lbzy1sZmgkIA5SLtr
 Rr1PhnHb0MhZj3b4qQAtk/MiBSrY1OS+2g8/dEaSKrQfoFICoxH8xFC5TZMUlUi22Z8H
 uev+Zh72FQIuYzjjphcFYYrROZ9JfMKe0yhb9+sDvezYeRh/wvOv/D3VJ1i+k83cpjhh qA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsj5en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 07:30:32 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:30:31 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:30:31 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 07:30:30 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 94FFA3F7045;
        Sun, 10 Jan 2021 07:30:27 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH RFC net-next  00/19] net: mvpp2: Add TX Flow Control support
Date:   Sun, 10 Jan 2021 17:30:04 +0200
Message-ID: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Armada hardware has a pause generation mechanism in GOP (MAC).
GOP has to generate flow control frames based on an indication
programmed in Ports Control 0 Register. There is a bit per port.
However assertion of the PortX Pause bits in the ports control 0 register
only sends a one time pause. To complement the function the GOP has
a mechanism to periodically send pause control messages based on periodic counters.
This mechanism ensures that the pause is effective as long as the Appropriate PortX Pause
is asserted.

Problem is that Packet Processor witch actually can drop packets due to lack of resources
not connected to the GOP flow control generation mechanism.
To solve this issue Armada has firmware running on CM3 CPU dedectated for Flow Control
support. Firmware monitors Packet Processor resources and asserts XON/XOFF by writing
to Ports Control 0 Register.

MSS shared memory used to communicate between CM3 firmware and MVPP2 driver.
During init MVPP2 driver informs firmware about used BM pools, RXQs and congestion and
depletion thresholds.

The pause is generated whenever congestion or depletion in resources is detected.
The back pressure is stopped when the resource reaches a sufficient level.
So the congestion/depletion and sufficient implement a hysteresis mechanism that
reduces the toggle frequency.

For buffer pools which are a depletion means that a pause frame should be generated.
For this the SW needs to poll BPPINumberOfPointers and BPPENumberOfPoint. For queues
congestion means that a pause frame should be generated. For this the SW
needs to poll OccupiedDescriptorsCounter.

Packet Processor v23 has hardware support to monitor FIFO fill level.
patch "add PPv23 version definition" to differ between v23 and v22 hardware.
Patch "add TX FC firmware check" verifies that CM3 firmware support Flow Control
monitoring.

Konstantin Porotchkin (1):
  dts: marvell: add CM3 SRAM memory to cp115 ethernet device tree

Stefan Chulski (18):
  doc: marvell: add cm3-mem device tree bindings description
  net: mvpp2: add CM3 SRAM memory map
  net: mvpp2: add PPv23 version definition
  net: mvpp2: always compare hw-version vs MVPP21
  net: mvpp2: increase BM pool size to 2048 buffers
  net: mvpp2: increase RXQ size to 1024 descriptors
  net: mvpp2: add FCA periodic timer configurations
  net: mvpp2: add FCA RXQ non occupied descriptor threshold
  net: mvpp2: add spinlock for FW FCA configuration path
  net: mvpp2: add flow control RXQ and BM pool config callbacks
  net: mvpp2: enable global flow control
  net: mvpp2: add RXQ flow control configurations
  net: mvpp2: add ethtool flow control configuration support
  net: mvpp2: add BM protection underrun feature support
  net: mvpp2: add PPv23 RX FIFO flow control
  net: mvpp2: set 802.3x GoP Flow Control mode
  net: mvpp2: add ring size validation before enabling FC
  net: mvpp2: add TX FC firmware check

 Documentation/devicetree/bindings/net/marvell-pp2.txt |   1 +
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi         |  10 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h            | 130 ++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c       | 570 +++++++++++++++++++-
 4 files changed, 669 insertions(+), 42 deletions(-)

-- 
1.9.1

