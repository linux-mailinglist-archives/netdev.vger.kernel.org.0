Return-Path: <netdev+bounces-2776-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE42703ED4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:49:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 982AE280DDA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2794719E6D;
	Mon, 15 May 2023 20:47:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1529D19E5D
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:47:35 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EC17EDD
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:47:32 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pyf6R-0004qP-3l
	for netdev@vger.kernel.org; Mon, 15 May 2023 22:47:31 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id E723D1C5C55
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:47:28 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id D6E6B1C5C1A;
	Mon, 15 May 2023 20:47:25 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 89e44e20;
	Mon, 15 May 2023 20:47:24 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 9/9] ARM: dts: stm32: add CAN support on stm32f746
Date: Mon, 15 May 2023 22:47:22 +0200
Message-Id: <20230515204722.1000957-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230515204722.1000957-1-mkl@pengutronix.de>
References: <20230515204722.1000957-1-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

Add support for bxcan (Basic eXtended CAN controller) to STM32F746. The
chip contains three CAN peripherals, CAN1 and CAN2 in dual peripheral
configuration and CAN3 in single peripheral configuration:
- Dual CAN peripheral configuration:
  * CAN1: Primary bxCAN for managing the communication between a secondary
    bxCAN and the 512-byte SRAM memory.
  * CAN2: Secondary bxCAN with no direct access to the SRAM memory.
  This means that the two bxCAN cells share the 512-byte SRAM memory and
  CAN2 can't be used without enabling CAN1.
- Single CAN peripheral configuration:
  * CAN3: Primary bxCAN with dedicated Memory Access Controller unit and
    512-byte SRAM memory.

 -------------------------------------------------------------------------
| features | CAN1              | CAN2               | CAN 3               |
 -------------------------------------------------------------------------
| SRAM     | 512-byte shared between CAN1 & CAN2    | 512-byte            |
 -------------------------------------------------------------------------
| Filters  | 26 filters shared between CAN1 & CAN2  | 14 filters          |
 -------------------------------------------------------------------------

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://lore.kernel.org/all/20230427204540.3126234-6-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/arm/boot/dts/stm32f746.dtsi | 47 ++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm/boot/dts/stm32f746.dtsi b/arch/arm/boot/dts/stm32f746.dtsi
index dc868e6da40e..973698bc9ef4 100644
--- a/arch/arm/boot/dts/stm32f746.dtsi
+++ b/arch/arm/boot/dts/stm32f746.dtsi
@@ -257,6 +257,23 @@ rtc: rtc@40002800 {
 			status = "disabled";
 		};
 
+		can3: can@40003400 {
+			compatible = "st,stm32f4-bxcan";
+			reg = <0x40003400 0x200>;
+			interrupts = <104>, <105>, <106>, <107>;
+			interrupt-names = "tx", "rx0", "rx1", "sce";
+			resets = <&rcc STM32F7_APB1_RESET(CAN3)>;
+			clocks = <&rcc 0 STM32F7_APB1_CLOCK(CAN3)>;
+			st,gcan = <&gcan3>;
+			status = "disabled";
+		};
+
+		gcan3: gcan@40003600 {
+			compatible = "st,stm32f4-gcan", "syscon";
+			reg = <0x40003600 0x200>;
+			clocks = <&rcc 0 STM32F7_APB1_CLOCK(CAN3)>;
+		};
+
 		usart2: serial@40004400 {
 			compatible = "st,stm32f7-uart";
 			reg = <0x40004400 0x400>;
@@ -337,6 +354,36 @@ i2c4: i2c@40006000 {
 			status = "disabled";
 		};
 
+		can1: can@40006400 {
+			compatible = "st,stm32f4-bxcan";
+			reg = <0x40006400 0x200>;
+			interrupts = <19>, <20>, <21>, <22>;
+			interrupt-names = "tx", "rx0", "rx1", "sce";
+			resets = <&rcc STM32F7_APB1_RESET(CAN1)>;
+			clocks = <&rcc 0 STM32F7_APB1_CLOCK(CAN1)>;
+			st,can-primary;
+			st,gcan = <&gcan1>;
+			status = "disabled";
+		};
+
+		gcan1: gcan@40006600 {
+			compatible = "st,stm32f4-gcan", "syscon";
+			reg = <0x40006600 0x200>;
+			clocks = <&rcc 0 STM32F7_APB1_CLOCK(CAN1)>;
+		};
+
+		can2: can@40006800 {
+			compatible = "st,stm32f4-bxcan";
+			reg = <0x40006800 0x200>;
+			interrupts = <63>, <64>, <65>, <66>;
+			interrupt-names = "tx", "rx0", "rx1", "sce";
+			resets = <&rcc STM32F7_APB1_RESET(CAN2)>;
+			clocks = <&rcc 0 STM32F7_APB1_CLOCK(CAN2)>;
+			st,can-secondary;
+			st,gcan = <&gcan1>;
+			status = "disabled";
+		};
+
 		cec: cec@40006c00 {
 			compatible = "st,stm32-cec";
 			reg = <0x40006C00 0x400>;
-- 
2.39.2



