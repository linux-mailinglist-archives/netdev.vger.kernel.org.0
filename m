Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033446E176F
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjDMWbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjDMWbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:31:14 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DE47AB4;
        Thu, 13 Apr 2023 15:31:13 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33DMUqbK021536;
        Thu, 13 Apr 2023 17:30:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681425052;
        bh=nfApsyYB3BUy/ITs1HPtXb0cFGwPSOPtBeaWo+Jeuzk=;
        h=From:To:CC:Subject:Date;
        b=PNPlA0NHZqOF40WSspt3QOwIOM/Y6D9O1p/GLbVWwVwUEqX59l8Gj5TIQJV4I4MJP
         AGhnwFWFwe3aKJFxQwsRd+Tu+9RbJ9a/kDUZgxrHi0x7pCH6syuMF4p8jkDWDXF8Mq
         6nh3JjQJ04GCiARJp3gparEgl5Oire7vwDhJGMeE=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33DMUqtb051530
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Apr 2023 17:30:52 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 13
 Apr 2023 17:30:51 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 13 Apr 2023 17:30:51 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33DMUpa3063427;
        Thu, 13 Apr 2023 17:30:51 -0500
From:   Judith Mendez <jm@ti.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>
CC:     Nishanth Menon <nm@ti.com>, Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>
Subject: [RFC PATCH 0/5] Enable multiple MCAN on AM62x
Date:   Thu, 13 Apr 2023 17:30:46 -0500
Message-ID: <20230413223051.24455-1-jm@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On AM62x there is one MCAN in MAIN domain and two in MCU domain.
The MCANs in MCU domain were not enabled since there is no
hardware interrupt routed to A53 GIC interrupt controller.
Therefore A53 Linux cannot be interrupted by MCU MCANs.

This solution instantiates a hrtimer with 1 ms polling interval
for a MCAN when there is no hardware interrupt. This hrtimer
generates a recurring software interrupt which allows to call the
isr. The isr will check if there is pending transaction by reading
a register and proceed normally if there is.

On AM62x this series enables two MCU MCAN which will use the hrtimer
implementation. MCANs with hardware interrupt routed to A53 Linux
will continue to use the hardware interrupt as expected.

Timer polling method was tested on both classic CAN and CAN-FD
at 125 KBPS, 250 KBPS, 1 MBPS and 2.5 MBPS with 4 MBPS bitrate
switching.

Letency and CPU load benchmarks were tested on 3x MCAN on AM62x.
1 MBPS timer polling interval is the better timer polling interval
since it has comparable latency to hardware interrupt with the worse
case being 1ms + CAN frame propagation time and CPU load is not
substantial. Latency can be improved further with less than 1 ms
polling intervals, howerver it is at the cost of CPU usage since CPU
load increases at 0.5 ms and lower polling periods than 1ms.

Note that in terms of power, enabling MCU MCANs with timer-polling
implementation might have negative impact since we will have to wake
up every 1 ms whether there are CAN packets pending in the RX FIFO or
not. This might prevent the CPU from entering into deeper idle states
for extended periods of time.

This patch series depends on 'Enable CAN PHY transceiver driver':
https://lore.kernel.org/lkml/775ec9ce-7668-429c-a977-6c8995968d6e@app.fastmail.com/T/

Judith Mendez (5):
  arm64: dts: ti: Add AM62x MCAN MAIN domain transceiver overlay
  arm64: defconfig: Enable MCAN driver
  dt-binding: can: m_can: Remove required interrupt attributes
  arm64: dts: ti: Enable multiple MCAN for AM62x in MCU MCAN overlay
  can: m_can: Add hrtimer to generate software interrupt

 .../bindings/net/can/bosch,m_can.yaml         |  2 -
 arch/arm64/boot/dts/ti/Makefile               |  2 +
 .../boot/dts/ti/k3-am625-sk-mcan-main.dtso    | 35 +++++++++
 .../boot/dts/ti/k3-am625-sk-mcan-mcu.dtso     | 75 +++++++++++++++++++
 arch/arm64/configs/defconfig                  |  2 +
 drivers/net/can/m_can/m_can.c                 | 24 +++++-
 drivers/net/can/m_can/m_can.h                 |  3 +
 drivers/net/can/m_can/m_can_platform.c        |  9 ++-
 8 files changed, 146 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso
 create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso

-- 
2.17.1

