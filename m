Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D039D6ED5AE
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjDXTyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbjDXTyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:54:33 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7E061B8;
        Mon, 24 Apr 2023 12:54:30 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33OJs2tg070547;
        Mon, 24 Apr 2023 14:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682366042;
        bh=CRNaEU+3hTqrHp9DO8zng7/FDGdFX/kjnkPhKcwTJP4=;
        h=From:To:CC:Subject:Date;
        b=LbTSF6twPIOl3q4bpC7qQN+iHIk0JiOZAndsuWeOwOPNwOwGJgg75+1REznjVZ5Vo
         f7huDq8vhjPfg/jNCufSxUEApnq1dsWRIz560LQCs+lTOlISicW2gUjwqIuxuR15Qy
         JhNJKETUd3SvN+8XRZQ37ERz+TTOavTduC/NEAhE=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33OJs2ku095033
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Apr 2023 14:54:02 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 24
 Apr 2023 14:54:02 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 24 Apr 2023 14:54:02 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33OJs23F009344;
        Mon, 24 Apr 2023 14:54:02 -0500
From:   Judith Mendez <jm@ti.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v2 0/4] Enable multiple MCAN on AM62x
Date:   Mon, 24 Apr 2023 14:53:58 -0500
Message-ID: <20230424195402.516-1-jm@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
for MCAN device when there is no hardware interrupt and there is
poll-interval property in DTB MCAN node. The hrtimer generates a
recurring software interrupt which allows to call the isr. The isr
will check if there is pending transaction by reading a register
and proceed normally if there is.

On AM62x, this series enables two MCU MCAN which will use the hrtimer
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
load increases at 0.5 ms.

Note that in terms of power, enabling MCU MCANs with timer-polling
implementation might have negative impact since we will have to wake
up every 1 ms whether there are CAN packets pending in the RX FIFO or
not. This might prevent the CPU from entering into deeper idle states
for extended periods of time.

This patch series depends on 'Enable CAN PHY transceiver driver':
https://lore.kernel.org/lkml/775ec9ce-7668-429c-a977-6c8995968d6e@app.fastmail.com/T/

Previously sent an RFC:
https://lore.kernel.org/linux-can/52a37e51-4143-9017-42ee-8d17c67028e3@ti.com/T/#t

Changes since v1:
- Add poll-interval property to bindings and MCAN DTB node
- Add functionality to check for 'poll-interval' property in MCAN node 
- Bindings: add an example using poll-interval
- Add 'polling' flag in driver to check if device is using polling method
- Check for both timer polling and hardware interrupt case, default to
hardware interrupt method
- Change ns_to_ktime() to ms_to_ktime()

Judith Mendez (4):
  can: m_can: Add hrtimer to generate software interrupt
  dt-bindings: net: can: Add poll-interval for MCAN
  arm64: dts: ti: Add AM62x MCAN MAIN domain transceiver overlay
  arm64: dts: ti: Enable MCU MCANs for AM62x

 .../bindings/net/can/bosch,m_can.yaml         | 26 ++++++++-
 arch/arm64/boot/dts/ti/Makefile               |  2 +
 arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi       | 24 ++++++++
 .../boot/dts/ti/k3-am625-sk-mcan-main.dtso    | 35 ++++++++++++
 .../boot/dts/ti/k3-am625-sk-mcan-mcu.dtso     | 57 +++++++++++++++++++
 drivers/net/can/m_can/m_can.c                 | 30 ++++++++--
 drivers/net/can/m_can/m_can.h                 |  5 ++
 drivers/net/can/m_can/m_can_platform.c        | 31 +++++++++-
 8 files changed, 200 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso
 create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso

-- 
2.17.1

