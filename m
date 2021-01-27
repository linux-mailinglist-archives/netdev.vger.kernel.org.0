Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEC4305A49
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 12:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbhA0LtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 06:49:02 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60832 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236644AbhA0Lqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 06:46:39 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10RBdkPY000664;
        Wed, 27 Jan 2021 03:43:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Lg4ACJanobyMbjPJ851BiNxVU7mhoa2V9h53nyl8w8U=;
 b=aNe4rsKuH0PiwhrZ4721433HyjQpzUhg/0DkKwC8y2WfBkEMFGksGXl4By5bhCWBmH4v
 ShzbbFP/hD08GFhkrBhOs3FDGRFlxn1hnqewC6hGyCAQC1OOF92nScO8KjVyQypfrRx6
 bOF22xme/Ru+EmD6cnj4/YMTRgvKddinj3a29ZyqStKfiSzB9BrKJkqDz6xMGg/ob7Ld
 ehSzQFaKz83jsv7uVwsRjnOk7j02tBtlf10kxsW9ihHfq0DP/U6P0GqGuAp+fBd+STKb
 St4wrw1zBb7rZrggSZdyWw9fkZ2F0pVcl+Luh6lX4p6LujaxypxL4jv6vV45Jb3txzk5 Hg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1ube6x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 03:43:49 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 03:43:47 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 03:43:46 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 27 Jan 2021 03:43:46 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id C2DFD3F7041;
        Wed, 27 Jan 2021 03:43:43 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v4 net-next 00/19] net: mvpp2: Add TX Flow Control support
Date:   Wed, 27 Jan 2021 13:43:16 +0200
Message-ID: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
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
  dts: marvell: add CM3 SRAM memory to cp115 ethernet device tree

Stefan Chulski (18):
  doc: marvell: add cm3-mem device tree bindings description
  net: mvpp2: add CM3 SRAM memory map
  doc: marvell: add PPv2.3 description to marvell-pp2.txt
  net: mvpp2: add PPv23 version definition
  net: mvpp2: always compare hw-version vs MVPP21
  net: mvpp2: increase BM pool size to 2048 buffers
  net: mvpp2: increase RXQ size to 1024 descriptors
  net: mvpp2: add FCA periodic timer configurations
  net: mvpp2: add FCA RXQ non occupied descriptor threshold
  net: mvpp2: add spinlock for FW FCA configuration path
  net: mvpp2: enable global flow control
  net: mvpp2: add RXQ flow control configurations
  net: mvpp2: add ethtool flow control configuration support
  net: mvpp2: add BM protection underrun feature support
  net: mvpp2: add PPv23 RX FIFO flow control
  net: mvpp2: set 802.3x GoP Flow Control mode
  net: mvpp2: limit minimum ring size to 1024 descriptors
  net: mvpp2: add TX FC firmware check

 Documentation/devicetree/bindings/net/marvell-pp2.txt |   4 +-
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi         |  10 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h            | 130 ++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c       | 564 ++++++++++++++++++--
 4 files changed, 658 insertions(+), 50 deletions(-)

-- 
1.9.1

