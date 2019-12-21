Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84DBA12897E
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 15:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfLUOPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 09:15:40 -0500
Received: from smtp7.web4u.cz ([81.91.87.87]:51126 "EHLO mx-8.mail.web4u.cz"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfLUOO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 09:14:57 -0500
Received: from mx-8.mail.web4u.cz (localhost [127.0.0.1])
        by mx-8.mail.web4u.cz (Postfix) with ESMTP id 7066A203713;
        Sat, 21 Dec 2019 15:08:06 +0100 (CET)
Received: from thor.pikron.com (unknown [89.102.8.6])
        (Authenticated sender: ppisa@pikron.com)
        by mx-8.mail.web4u.cz (Postfix) with ESMTPA id 126CB203712;
        Sat, 21 Dec 2019 15:08:06 +0100 (CET)
From:   pisa@cmp.felk.cvut.cz
To:     devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net
Cc:     wg@grandegger.com, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com, Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v3 2/6] dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
Date:   Sat, 21 Dec 2019 15:07:31 +0100
Message-Id: <61533d59378822f8c808abf193b40070810d3d35.1576922226.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
X-W4U-Auth: 036c2bfc9954ad56176992ec3cd014341e01efcf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
---
 .../devicetree/bindings/net/can/ctu,ctucanfd.txt   | 61 ++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.txt

diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.txt b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.txt
new file mode 100644
index 000000000000..4cb2f04cb412
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.txt
@@ -0,0 +1,61 @@
+Memory Mapped CTU CAN FD Open-source IP Core Device Tree Bindings
+-----------------------------------------------------------------
+
+
+The core sources and documentation on project page
+
+  https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core
+  http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/Progdokum.pdf
+
+Integration in Xilinx Zynq SoC based system together with
+OpenCores SJA1000 compatible controllers
+
+  https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top
+
+Martin Jerabek's dimploma thesis with integration and testing
+framework description
+
+ https://dspace.cvut.cz/bitstream/handle/10467/80366/F3-DP-2019-Jerabek-Martin-Jerabek-thesis-2019-canfd.pdf
+
+Required properties:
+
+- compatible : should be one of "ctu,ctucanfd", "ctu,canfd-2".
+      The "canfd-2" has been reserved for older revision of the IP core.
+      The revision can be read from the IP core register as well.
+
+- reg = <(baseaddr) (size)> : specify mapping into physical address
+      space of the processor system.
+
+- interrupts : property with a value describing the interrupt source
+      required for the CTU CAN FD. For Zynq SoC system format is
+      <(is_spi) (number) (type)> where is_spi defines if it is SPI
+      (shared peripheral) interrupt, the second number is translated
+      to the vector by addition of 32 on Zynq-7000 systems and type
+      is IRQ_TYPE_LEVEL_HIGH (4) for Zynq.
+
+- clocks: phandle of reference clock (100 MHz is appropriate
+      for FPGA implementation on Zynq-7000 system).
+
+Optional properties:
+
+- clock-names: not used in actual design but if more clocks are used
+      by cores then "can_clk" would be clock source name for the clocks
+      used to define CAN time-quanta.
+
+Example when integrated to Zynq-7000 system DTS:
+
+        / {
+            /* ... */
+            amba: amba {
+                #address-cells = <1>;
+                #size-cells = <1>;
+                compatible = "simple-bus";
+
+                ctu_can_fd_0: can@43c30000 {
+                    compatible = "ctu,ctucanfd";
+                    interrupts = <0 30 4>;
+                    clocks = <&clkc 15>;
+                    reg = <0x43c30000 0x10000>;
+                };
+            };
+        };
-- 
2.11.0

