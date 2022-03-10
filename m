Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E39A4D4A63
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243369AbiCJObr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343976AbiCJObe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2792DEAC83
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:15 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJmz-0005ue-Eg
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:13 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7969747DA1
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9BAC447D91;
        Thu, 10 Mar 2022 14:29:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 21f78e7a;
        Thu, 10 Mar 2022 14:29:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Ulrich Hecht <uli+renesas@fpond.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/29] can: rcar_canfd: Add support for r8a779a0 SoC
Date:   Thu, 10 Mar 2022 15:28:42 +0100
Message-Id: <20220310142903.341658-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310142903.341658-1-mkl@pengutronix.de>
References: <20220310142903.341658-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ulrich Hecht <uli+renesas@fpond.eu>

Adds support for the CANFD IP variant in the V3U SoC.

Differences to controllers in other SoCs are limited to an increase in
the number of channels from two to eight, an absence of dedicated
registers for "classic" CAN mode, and a number of differences in magic
numbers (register offsets and layouts).

Inspired by BSP patch by Kazuya Mizuguchi.

Link: https://lore.kernel.org/all/20220309162609.3726306-2-uli+renesas@fpond.eu
Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 353 ++++++++++++++++++------------
 1 file changed, 217 insertions(+), 136 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index acd74725831f..1e121e04208c 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -44,6 +44,7 @@
 enum rcanfd_chip_id {
 	RENESAS_RCAR_GEN3 = 0,
 	RENESAS_RZG2L,
+	RENESAS_R8A779A0,
 };
 
 /* Global register bits */
@@ -79,6 +80,7 @@ enum rcanfd_chip_id {
 #define RCANFD_GSTS_GNOPM		(BIT(0) | BIT(1) | BIT(2) | BIT(3))
 
 /* RSCFDnCFDGERFL / RSCFDnGERFL */
+#define RCANFD_GERFL_EEF0_7		GENMASK(23, 16)
 #define RCANFD_GERFL_EEF1		BIT(17)
 #define RCANFD_GERFL_EEF0		BIT(16)
 #define RCANFD_GERFL_CMPOF		BIT(3)	/* CAN FD only */
@@ -86,20 +88,26 @@ enum rcanfd_chip_id {
 #define RCANFD_GERFL_MES		BIT(1)
 #define RCANFD_GERFL_DEF		BIT(0)
 
-#define RCANFD_GERFL_ERR(gpriv, x)	((x) & (RCANFD_GERFL_EEF1 |\
-					RCANFD_GERFL_EEF0 | RCANFD_GERFL_MES |\
-					(gpriv->fdmode ?\
-					 RCANFD_GERFL_CMPOF : 0)))
+#define RCANFD_GERFL_ERR(gpriv, x) \
+	((x) & (reg_v3u(gpriv, RCANFD_GERFL_EEF0_7, \
+			RCANFD_GERFL_EEF0 | RCANFD_GERFL_EEF1) | \
+		RCANFD_GERFL_MES | \
+		((gpriv)->fdmode ? RCANFD_GERFL_CMPOF : 0)))
 
 /* AFL Rx rules registers */
 
 /* RSCFDnCFDGAFLCFG0 / RSCFDnGAFLCFG0 */
-#define RCANFD_GAFLCFG_SETRNC(n, x)	(((x) & 0xff) << (24 - n * 8))
-#define RCANFD_GAFLCFG_GETRNC(n, x)	(((x) >> (24 - n * 8)) & 0xff)
+#define RCANFD_GAFLCFG_SETRNC(gpriv, n, x) \
+	(((x) & reg_v3u(gpriv, 0x1ff, 0xff)) << \
+	 (reg_v3u(gpriv, 16, 24) - (n) * reg_v3u(gpriv, 16, 8)))
+
+#define RCANFD_GAFLCFG_GETRNC(gpriv, n, x) \
+	(((x) >> (reg_v3u(gpriv, 16, 24) - (n) * reg_v3u(gpriv, 16, 8))) & \
+	 reg_v3u(gpriv, 0x1ff, 0xff))
 
 /* RSCFDnCFDGAFLECTR / RSCFDnGAFLECTR */
 #define RCANFD_GAFLECTR_AFLDAE		BIT(8)
-#define RCANFD_GAFLECTR_AFLPN(x)	((x) & 0x1f)
+#define RCANFD_GAFLECTR_AFLPN(gpriv, x)	((x) & reg_v3u(gpriv, 0x7f, 0x1f))
 
 /* RSCFDnCFDGAFLIDj / RSCFDnGAFLIDj */
 #define RCANFD_GAFLID_GAFLLB		BIT(29)
@@ -116,9 +124,15 @@ enum rcanfd_chip_id {
 #define RCANFD_CFG_BRP(x)		(((x) & 0x3ff) << 0)
 
 /* RSCFDnCFDCmNCFG - CAN FD only */
-#define RCANFD_NCFG_NTSEG2(x)		(((x) & 0x1f) << 24)
-#define RCANFD_NCFG_NTSEG1(x)		(((x) & 0x7f) << 16)
-#define RCANFD_NCFG_NSJW(x)		(((x) & 0x1f) << 11)
+#define RCANFD_NCFG_NTSEG2(gpriv, x) \
+	(((x) & reg_v3u(gpriv, 0x7f, 0x1f)) << reg_v3u(gpriv, 25, 24))
+
+#define RCANFD_NCFG_NTSEG1(gpriv, x) \
+	(((x) & reg_v3u(gpriv, 0xff, 0x7f)) << reg_v3u(gpriv, 17, 16))
+
+#define RCANFD_NCFG_NSJW(gpriv, x) \
+	(((x) & reg_v3u(gpriv, 0x7f, 0x1f)) << reg_v3u(gpriv, 10, 11))
+
 #define RCANFD_NCFG_NBRP(x)		(((x) & 0x3ff) << 0)
 
 /* RSCFDnCFDCmCTR / RSCFDnCmCTR */
@@ -180,11 +194,18 @@ enum rcanfd_chip_id {
 
 /* RSCFDnCFDCmDCFG */
 #define RCANFD_DCFG_DSJW(x)		(((x) & 0x7) << 24)
-#define RCANFD_DCFG_DTSEG2(x)		(((x) & 0x7) << 20)
-#define RCANFD_DCFG_DTSEG1(x)		(((x) & 0xf) << 16)
+
+#define RCANFD_DCFG_DTSEG2(gpriv, x) \
+	(((x) & reg_v3u(gpriv, 0x0f, 0x7)) << reg_v3u(gpriv, 16, 20))
+
+#define RCANFD_DCFG_DTSEG1(gpriv, x) \
+	(((x) & reg_v3u(gpriv, 0x1f, 0xf)) << reg_v3u(gpriv, 8, 16))
+
 #define RCANFD_DCFG_DBRP(x)		(((x) & 0xff) << 0)
 
 /* RSCFDnCFDCmFDCFG */
+#define RCANFD_FDCFG_CLOE		BIT(30)
+#define RCANFD_FDCFG_FDOE		BIT(28)
 #define RCANFD_FDCFG_TDCE		BIT(9)
 #define RCANFD_FDCFG_TDCOC		BIT(8)
 #define RCANFD_FDCFG_TDCO(x)		(((x) & 0x7f) >> 16)
@@ -219,10 +240,10 @@ enum rcanfd_chip_id {
 /* Common FIFO bits */
 
 /* RSCFDnCFDCFCCk */
-#define RCANFD_CFCC_CFTML(x)		(((x) & 0xf) << 20)
-#define RCANFD_CFCC_CFM(x)		(((x) & 0x3) << 16)
+#define RCANFD_CFCC_CFTML(gpriv, x)	(((x) & 0xf) << reg_v3u(gpriv, 16, 20))
+#define RCANFD_CFCC_CFM(gpriv, x)	(((x) & 0x3) << reg_v3u(gpriv,  8, 16))
 #define RCANFD_CFCC_CFIM		BIT(12)
-#define RCANFD_CFCC_CFDC(x)		(((x) & 0x7) << 8)
+#define RCANFD_CFCC_CFDC(gpriv, x)	(((x) & 0x7) << reg_v3u(gpriv, 21,  8))
 #define RCANFD_CFCC_CFPLS(x)		(((x) & 0x7) << 4)
 #define RCANFD_CFCC_CFTXIE		BIT(2)
 #define RCANFD_CFCC_CFE			BIT(0)
@@ -282,33 +303,31 @@ enum rcanfd_chip_id {
 #define RCANFD_GTSC			(0x0094)
 /* RSCFDnCFDGAFLECTR / RSCFDnGAFLECTR */
 #define RCANFD_GAFLECTR			(0x0098)
-/* RSCFDnCFDGAFLCFG0 / RSCFDnGAFLCFG0 */
-#define RCANFD_GAFLCFG0			(0x009c)
-/* RSCFDnCFDGAFLCFG1 / RSCFDnGAFLCFG1 */
-#define RCANFD_GAFLCFG1			(0x00a0)
+/* RSCFDnCFDGAFLCFG / RSCFDnGAFLCFG */
+#define RCANFD_GAFLCFG(ch)		(0x009c + (0x04 * ((ch) / 2)))
 /* RSCFDnCFDRMNB / RSCFDnRMNB */
 #define RCANFD_RMNB			(0x00a4)
 /* RSCFDnCFDRMND / RSCFDnRMND */
 #define RCANFD_RMND(y)			(0x00a8 + (0x04 * (y)))
 
 /* RSCFDnCFDRFCCx / RSCFDnRFCCx */
-#define RCANFD_RFCC(x)			(0x00b8 + (0x04 * (x)))
+#define RCANFD_RFCC(gpriv, x)		(reg_v3u(gpriv, 0x00c0, 0x00b8) + (0x04 * (x)))
 /* RSCFDnCFDRFSTSx / RSCFDnRFSTSx */
-#define RCANFD_RFSTS(x)			(0x00d8 + (0x04 * (x)))
+#define RCANFD_RFSTS(gpriv, x)		(RCANFD_RFCC(gpriv, x) + 0x20)
 /* RSCFDnCFDRFPCTRx / RSCFDnRFPCTRx */
-#define RCANFD_RFPCTR(x)		(0x00f8 + (0x04 * (x)))
+#define RCANFD_RFPCTR(gpriv, x)		(RCANFD_RFCC(gpriv, x) + 0x40)
 
 /* Common FIFO Control registers */
 
 /* RSCFDnCFDCFCCx / RSCFDnCFCCx */
-#define RCANFD_CFCC(ch, idx)		(0x0118 + (0x0c * (ch)) + \
-					 (0x04 * (idx)))
+#define RCANFD_CFCC(gpriv, ch, idx) \
+	(reg_v3u(gpriv, 0x0120, 0x0118) + (0x0c * (ch)) + (0x04 * (idx)))
 /* RSCFDnCFDCFSTSx / RSCFDnCFSTSx */
-#define RCANFD_CFSTS(ch, idx)		(0x0178 + (0x0c * (ch)) + \
-					 (0x04 * (idx)))
+#define RCANFD_CFSTS(gpriv, ch, idx) \
+	(reg_v3u(gpriv, 0x01e0, 0x0178) + (0x0c * (ch)) + (0x04 * (idx)))
 /* RSCFDnCFDCFPCTRx / RSCFDnCFPCTRx */
-#define RCANFD_CFPCTR(ch, idx)		(0x01d8 + (0x0c * (ch)) + \
-					 (0x04 * (idx)))
+#define RCANFD_CFPCTR(gpriv, ch, idx) \
+	(reg_v3u(gpriv, 0x0240, 0x01d8) + (0x0c * (ch)) + (0x04 * (idx)))
 
 /* RSCFDnCFDFESTS / RSCFDnFESTS */
 #define RCANFD_FESTS			(0x0238)
@@ -387,22 +406,23 @@ enum rcanfd_chip_id {
 #define RCANFD_C_RMDF1(q)		(0x060c + (0x10 * (q)))
 
 /* RSCFDnRFXXx -> RCANFD_C_RFXX(x) */
-#define RCANFD_C_RFOFFSET		(0x0e00)
-#define RCANFD_C_RFID(x)		(RCANFD_C_RFOFFSET + (0x10 * (x)))
-#define RCANFD_C_RFPTR(x)		(RCANFD_C_RFOFFSET + 0x04 + \
-					 (0x10 * (x)))
-#define RCANFD_C_RFDF(x, df)		(RCANFD_C_RFOFFSET + 0x08 + \
-					 (0x10 * (x)) + (0x04 * (df)))
+#define RCANFD_C_RFOFFSET	(0x0e00)
+#define RCANFD_C_RFID(x)	(RCANFD_C_RFOFFSET + (0x10 * (x)))
+#define RCANFD_C_RFPTR(x)	(RCANFD_C_RFOFFSET + 0x04 + (0x10 * (x)))
+#define RCANFD_C_RFDF(x, df) \
+		(RCANFD_C_RFOFFSET + 0x08 + (0x10 * (x)) + (0x04 * (df)))
 
 /* RSCFDnCFXXk -> RCANFD_C_CFXX(ch, k) */
 #define RCANFD_C_CFOFFSET		(0x0e80)
-#define RCANFD_C_CFID(ch, idx)		(RCANFD_C_CFOFFSET + (0x30 * (ch)) + \
-					 (0x10 * (idx)))
-#define RCANFD_C_CFPTR(ch, idx)		(RCANFD_C_CFOFFSET + 0x04 + \
-					 (0x30 * (ch)) + (0x10 * (idx)))
-#define RCANFD_C_CFDF(ch, idx, df)	(RCANFD_C_CFOFFSET + 0x08 + \
-					 (0x30 * (ch)) + (0x10 * (idx)) + \
-					 (0x04 * (df)))
+
+#define RCANFD_C_CFID(ch, idx) \
+	(RCANFD_C_CFOFFSET + (0x30 * (ch)) + (0x10 * (idx)))
+
+#define RCANFD_C_CFPTR(ch, idx)	\
+	(RCANFD_C_CFOFFSET + 0x04 + (0x30 * (ch)) + (0x10 * (idx)))
+
+#define RCANFD_C_CFDF(ch, idx, df) \
+	(RCANFD_C_CFOFFSET + 0x08 + (0x30 * (ch)) + (0x10 * (idx)) + (0x04 * (df)))
 
 /* RSCFDnTMXXp -> RCANFD_C_TMXX(p) */
 #define RCANFD_C_TMID(p)		(0x1000 + (0x10 * (p)))
@@ -415,6 +435,12 @@ enum rcanfd_chip_id {
 /* RSCFDnRPGACCr */
 #define RCANFD_C_RPGACC(r)		(0x1900 + (0x04 * (r)))
 
+/* R-Car V3U Classical and CAN FD mode specific register map */
+#define RCANFD_V3U_CFDCFG		(0x1314)
+#define RCANFD_V3U_DCFG(m)		(0x1400 + (0x20 * (m)))
+
+#define RCANFD_V3U_GAFL_OFFSET		(0x1800)
+
 /* CAN FD mode specific register map */
 
 /* RSCFDnCFDCmXXX -> RCANFD_F_XXX(m) */
@@ -434,26 +460,28 @@ enum rcanfd_chip_id {
 #define RCANFD_F_RMDF(q, b)		(0x200c + (0x04 * (b)) + (0x20 * (q)))
 
 /* RSCFDnCFDRFXXx -> RCANFD_F_RFXX(x) */
-#define RCANFD_F_RFOFFSET		(0x3000)
-#define RCANFD_F_RFID(x)		(RCANFD_F_RFOFFSET + (0x80 * (x)))
-#define RCANFD_F_RFPTR(x)		(RCANFD_F_RFOFFSET + 0x04 + \
-					 (0x80 * (x)))
-#define RCANFD_F_RFFDSTS(x)		(RCANFD_F_RFOFFSET + 0x08 + \
-					 (0x80 * (x)))
-#define RCANFD_F_RFDF(x, df)		(RCANFD_F_RFOFFSET + 0x0c + \
-					 (0x80 * (x)) + (0x04 * (df)))
+#define RCANFD_F_RFOFFSET(gpriv)	reg_v3u(gpriv, 0x6000, 0x3000)
+#define RCANFD_F_RFID(gpriv, x)		(RCANFD_F_RFOFFSET(gpriv) + (0x80 * (x)))
+#define RCANFD_F_RFPTR(gpriv, x)	(RCANFD_F_RFOFFSET(gpriv) + 0x04 + (0x80 * (x)))
+#define RCANFD_F_RFFDSTS(gpriv, x)	(RCANFD_F_RFOFFSET(gpriv) + 0x08 + (0x80 * (x)))
+#define RCANFD_F_RFDF(gpriv, x, df) \
+	(RCANFD_F_RFOFFSET(gpriv) + 0x0c + (0x80 * (x)) + (0x04 * (df)))
 
 /* RSCFDnCFDCFXXk -> RCANFD_F_CFXX(ch, k) */
-#define RCANFD_F_CFOFFSET		(0x3400)
-#define RCANFD_F_CFID(ch, idx)		(RCANFD_F_CFOFFSET + (0x180 * (ch)) + \
-					 (0x80 * (idx)))
-#define RCANFD_F_CFPTR(ch, idx)		(RCANFD_F_CFOFFSET + 0x04 + \
-					 (0x180 * (ch)) + (0x80 * (idx)))
-#define RCANFD_F_CFFDCSTS(ch, idx)	(RCANFD_F_CFOFFSET + 0x08 + \
-					 (0x180 * (ch)) + (0x80 * (idx)))
-#define RCANFD_F_CFDF(ch, idx, df)	(RCANFD_F_CFOFFSET + 0x0c + \
-					 (0x180 * (ch)) + (0x80 * (idx)) + \
-					 (0x04 * (df)))
+#define RCANFD_F_CFOFFSET(gpriv)	reg_v3u(gpriv, 0x6400, 0x3400)
+
+#define RCANFD_F_CFID(gpriv, ch, idx) \
+	(RCANFD_F_CFOFFSET(gpriv) + (0x180 * (ch)) + (0x80 * (idx)))
+
+#define RCANFD_F_CFPTR(gpriv, ch, idx) \
+	(RCANFD_F_CFOFFSET(gpriv) + 0x04 + (0x180 * (ch)) + (0x80 * (idx)))
+
+#define RCANFD_F_CFFDCSTS(gpriv, ch, idx) \
+	(RCANFD_F_CFOFFSET(gpriv) + 0x08 + (0x180 * (ch)) + (0x80 * (idx)))
+
+#define RCANFD_F_CFDF(gpriv, ch, idx, df) \
+	(RCANFD_F_CFOFFSET(gpriv) + 0x0c + (0x180 * (ch)) + (0x80 * (idx)) + \
+	 (0x04 * (df)))
 
 /* RSCFDnCFDTMXXp -> RCANFD_F_TMXX(p) */
 #define RCANFD_F_TMID(p)		(0x4000 + (0x20 * (p)))
@@ -470,7 +498,7 @@ enum rcanfd_chip_id {
 #define RCANFD_FIFO_DEPTH		8	/* Tx FIFO depth */
 #define RCANFD_NAPI_WEIGHT		8	/* Rx poll quota */
 
-#define RCANFD_NUM_CHANNELS		2	/* Two channels max */
+#define RCANFD_NUM_CHANNELS		8	/* Eight channels max */
 #define RCANFD_CHANNELS_MASK		BIT((RCANFD_NUM_CHANNELS) - 1)
 
 #define RCANFD_GAFL_PAGENUM(entry)	((entry) / 16)
@@ -521,6 +549,7 @@ struct rcar_canfd_global {
 	struct reset_control *rstc1;
 	struct reset_control *rstc2;
 	enum rcanfd_chip_id chip_id;
+	u32 max_channels;
 };
 
 /* CAN FD mode nominal rate constants */
@@ -563,6 +592,17 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
 };
 
 /* Helper functions */
+static inline bool is_v3u(struct rcar_canfd_global *gpriv)
+{
+	return gpriv->chip_id == RENESAS_R8A779A0;
+}
+
+static inline u32 reg_v3u(struct rcar_canfd_global *gpriv,
+			  u32 v3u, u32 not_v3u)
+{
+	return is_v3u(gpriv) ? v3u : not_v3u;
+}
+
 static inline void rcar_canfd_update(u32 mask, u32 val, u32 __iomem *reg)
 {
 	u32 data = readl(reg);
@@ -628,6 +668,25 @@ static void rcar_canfd_tx_failure_cleanup(struct net_device *ndev)
 		can_free_echo_skb(ndev, i, NULL);
 }
 
+static void rcar_canfd_set_mode(struct rcar_canfd_global *gpriv)
+{
+	if (is_v3u(gpriv)) {
+		if (gpriv->fdmode)
+			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_CFDCFG,
+					   RCANFD_FDCFG_FDOE);
+		else
+			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_CFDCFG,
+					   RCANFD_FDCFG_CLOE);
+	} else {
+		if (gpriv->fdmode)
+			rcar_canfd_set_bit(gpriv->base, RCANFD_GRMCFG,
+					   RCANFD_GRMCFG_RCMC);
+		else
+			rcar_canfd_clear_bit(gpriv->base, RCANFD_GRMCFG,
+					     RCANFD_GRMCFG_RCMC);
+	}
+}
+
 static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
 {
 	u32 sts, ch;
@@ -660,15 +719,10 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
 	rcar_canfd_write(gpriv->base, RCANFD_GERFL, 0x0);
 
 	/* Set the controller into appropriate mode */
-	if (gpriv->fdmode)
-		rcar_canfd_set_bit(gpriv->base, RCANFD_GRMCFG,
-				   RCANFD_GRMCFG_RCMC);
-	else
-		rcar_canfd_clear_bit(gpriv->base, RCANFD_GRMCFG,
-				     RCANFD_GRMCFG_RCMC);
+	rcar_canfd_set_mode(gpriv);
 
 	/* Transition all Channels to reset mode */
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_clear_bit(gpriv->base,
 				     RCANFD_CCTR(ch), RCANFD_CCTR_CSLPR);
 
@@ -709,7 +763,7 @@ static void rcar_canfd_configure_controller(struct rcar_canfd_global *gpriv)
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCFG, cfg);
 
 	/* Channel configuration settings */
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_set_bit(gpriv->base, RCANFD_CCTR(ch),
 				   RCANFD_CCTR_ERRD);
 		rcar_canfd_update_bit(gpriv->base, RCANFD_CCTR(ch),
@@ -729,20 +783,22 @@ static void rcar_canfd_configure_afl_rules(struct rcar_canfd_global *gpriv,
 		start = 0; /* Channel 0 always starts from 0th rule */
 	} else {
 		/* Get number of Channel 0 rules and adjust */
-		cfg = rcar_canfd_read(gpriv->base, RCANFD_GAFLCFG0);
-		start = RCANFD_GAFLCFG_GETRNC(0, cfg);
+		cfg = rcar_canfd_read(gpriv->base, RCANFD_GAFLCFG(ch));
+		start = RCANFD_GAFLCFG_GETRNC(gpriv, 0, cfg);
 	}
 
 	/* Enable write access to entry */
 	page = RCANFD_GAFL_PAGENUM(start);
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLECTR,
-			   (RCANFD_GAFLECTR_AFLPN(page) |
+			   (RCANFD_GAFLECTR_AFLPN(gpriv, page) |
 			    RCANFD_GAFLECTR_AFLDAE));
 
 	/* Write number of rules for channel */
-	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLCFG0,
-			   RCANFD_GAFLCFG_SETRNC(ch, num_rules));
-	if (gpriv->fdmode)
+	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLCFG(ch),
+			   RCANFD_GAFLCFG_SETRNC(gpriv, ch, num_rules));
+	if (is_v3u(gpriv))
+		offset = RCANFD_V3U_GAFL_OFFSET;
+	else if (gpriv->fdmode)
 		offset = RCANFD_F_GAFL_OFFSET;
 	else
 		offset = RCANFD_C_GAFL_OFFSET;
@@ -754,8 +810,8 @@ static void rcar_canfd_configure_afl_rules(struct rcar_canfd_global *gpriv,
 	/* Any data length accepted */
 	rcar_canfd_write(gpriv->base, RCANFD_GAFLP0(offset, start), 0);
 	/* Place the msg in corresponding Rx FIFO entry */
-	rcar_canfd_write(gpriv->base, RCANFD_GAFLP1(offset, start),
-			 RCANFD_GAFLP1_GAFLFDP(ridx));
+	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLP1(offset, start),
+			   RCANFD_GAFLP1_GAFLFDP(ridx));
 
 	/* Disable write access to page */
 	rcar_canfd_clear_bit(gpriv->base,
@@ -779,7 +835,7 @@ static void rcar_canfd_configure_rx(struct rcar_canfd_global *gpriv, u32 ch)
 
 	cfg = (RCANFD_RFCC_RFIM | RCANFD_RFCC_RFDC(rfdc) |
 		RCANFD_RFCC_RFPLS(rfpls) | RCANFD_RFCC_RFIE);
-	rcar_canfd_write(gpriv->base, RCANFD_RFCC(ridx), cfg);
+	rcar_canfd_write(gpriv->base, RCANFD_RFCC(gpriv, ridx), cfg);
 }
 
 static void rcar_canfd_configure_tx(struct rcar_canfd_global *gpriv, u32 ch)
@@ -801,15 +857,15 @@ static void rcar_canfd_configure_tx(struct rcar_canfd_global *gpriv, u32 ch)
 	else
 		cfpls = 0;	/* b000 - Max 8 bytes payload */
 
-	cfg = (RCANFD_CFCC_CFTML(cftml) | RCANFD_CFCC_CFM(cfm) |
-		RCANFD_CFCC_CFIM | RCANFD_CFCC_CFDC(cfdc) |
+	cfg = (RCANFD_CFCC_CFTML(gpriv, cftml) | RCANFD_CFCC_CFM(gpriv, cfm) |
+		RCANFD_CFCC_CFIM | RCANFD_CFCC_CFDC(gpriv, cfdc) |
 		RCANFD_CFCC_CFPLS(cfpls) | RCANFD_CFCC_CFTXIE);
-	rcar_canfd_write(gpriv->base, RCANFD_CFCC(ch, RCANFD_CFFIFO_IDX), cfg);
+	rcar_canfd_write(gpriv->base, RCANFD_CFCC(gpriv, ch, RCANFD_CFFIFO_IDX), cfg);
 
 	if (gpriv->fdmode)
 		/* Clear FD mode specific control/status register */
 		rcar_canfd_write(gpriv->base,
-				 RCANFD_F_CFFDCSTS(ch, RCANFD_CFFIFO_IDX), 0);
+				 RCANFD_F_CFFDCSTS(gpriv, ch, RCANFD_CFFIFO_IDX), 0);
 }
 
 static void rcar_canfd_enable_global_interrupts(struct rcar_canfd_global *gpriv)
@@ -890,20 +946,20 @@ static void rcar_canfd_global_error(struct net_device *ndev)
 	}
 	if (gerfl & RCANFD_GERFL_MES) {
 		sts = rcar_canfd_read(priv->base,
-				      RCANFD_CFSTS(ch, RCANFD_CFFIFO_IDX));
+				      RCANFD_CFSTS(gpriv, ch, RCANFD_CFFIFO_IDX));
 		if (sts & RCANFD_CFSTS_CFMLT) {
 			netdev_dbg(ndev, "Tx Message Lost flag\n");
 			stats->tx_dropped++;
 			rcar_canfd_write(priv->base,
-					 RCANFD_CFSTS(ch, RCANFD_CFFIFO_IDX),
+					 RCANFD_CFSTS(gpriv, ch, RCANFD_CFFIFO_IDX),
 					 sts & ~RCANFD_CFSTS_CFMLT);
 		}
 
-		sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
+		sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(gpriv, ridx));
 		if (sts & RCANFD_RFSTS_RFMLT) {
 			netdev_dbg(ndev, "Rx Message Lost flag\n");
 			stats->rx_dropped++;
-			rcar_canfd_write(priv->base, RCANFD_RFSTS(ridx),
+			rcar_canfd_write(priv->base, RCANFD_RFSTS(gpriv, ridx),
 					 sts & ~RCANFD_RFSTS_RFMLT);
 		}
 	}
@@ -1038,6 +1094,7 @@ static void rcar_canfd_error(struct net_device *ndev, u32 cerfl,
 static void rcar_canfd_tx_done(struct net_device *ndev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(ndev);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	struct net_device_stats *stats = &ndev->stats;
 	u32 sts;
 	unsigned long flags;
@@ -1053,7 +1110,7 @@ static void rcar_canfd_tx_done(struct net_device *ndev)
 		spin_lock_irqsave(&priv->tx_lock, flags);
 		priv->tx_tail++;
 		sts = rcar_canfd_read(priv->base,
-				      RCANFD_CFSTS(ch, RCANFD_CFFIFO_IDX));
+				      RCANFD_CFSTS(gpriv, ch, RCANFD_CFFIFO_IDX));
 		unsent = RCANFD_CFSTS_CFMC(sts);
 
 		/* Wake producer only when there is room */
@@ -1069,7 +1126,7 @@ static void rcar_canfd_tx_done(struct net_device *ndev)
 	} while (1);
 
 	/* Clear interrupt */
-	rcar_canfd_write(priv->base, RCANFD_CFSTS(ch, RCANFD_CFFIFO_IDX),
+	rcar_canfd_write(priv->base, RCANFD_CFSTS(gpriv, ch, RCANFD_CFFIFO_IDX),
 			 sts & ~RCANFD_CFSTS_CFTXIF);
 	can_led_event(ndev, CAN_LED_EVENT_TX);
 }
@@ -1091,7 +1148,7 @@ static irqreturn_t rcar_canfd_global_err_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	u32 ch;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
 		rcar_canfd_handle_global_err(gpriv, ch);
 
 	return IRQ_HANDLED;
@@ -1104,12 +1161,12 @@ static void rcar_canfd_handle_global_receive(struct rcar_canfd_global *gpriv, u3
 	u32 sts;
 
 	/* Handle Rx interrupts */
-	sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
+	sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(gpriv, ridx));
 	if (likely(sts & RCANFD_RFSTS_RFIF)) {
 		if (napi_schedule_prep(&priv->napi)) {
 			/* Disable Rx FIFO interrupts */
 			rcar_canfd_clear_bit(priv->base,
-					     RCANFD_RFCC(ridx),
+					     RCANFD_RFCC(gpriv, ridx),
 					     RCANFD_RFCC_RFIE);
 			__napi_schedule(&priv->napi);
 		}
@@ -1121,7 +1178,7 @@ static irqreturn_t rcar_canfd_global_receive_fifo_interrupt(int irq, void *dev_i
 	struct rcar_canfd_global *gpriv = dev_id;
 	u32 ch;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
 		rcar_canfd_handle_global_receive(gpriv, ch);
 
 	return IRQ_HANDLED;
@@ -1135,7 +1192,7 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 	/* Global error interrupts still indicate a condition specific
 	 * to a channel. RxFIFO interrupt is a global interrupt.
 	 */
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_handle_global_err(gpriv, ch);
 		rcar_canfd_handle_global_receive(gpriv, ch);
 	}
@@ -1181,7 +1238,7 @@ static void rcar_canfd_handle_channel_tx(struct rcar_canfd_global *gpriv, u32 ch
 
 	/* Handle Tx interrupts */
 	sts = rcar_canfd_read(priv->base,
-			      RCANFD_CFSTS(ch, RCANFD_CFFIFO_IDX));
+			      RCANFD_CFSTS(gpriv, ch, RCANFD_CFFIFO_IDX));
 	if (likely(sts & RCANFD_CFSTS_CFTXIF))
 		rcar_canfd_tx_done(ndev);
 }
@@ -1191,7 +1248,7 @@ static irqreturn_t rcar_canfd_channel_tx_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	u32 ch;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
 		rcar_canfd_handle_channel_tx(gpriv, ch);
 
 	return IRQ_HANDLED;
@@ -1223,7 +1280,7 @@ static irqreturn_t rcar_canfd_channel_err_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	u32 ch;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
 		rcar_canfd_handle_channel_err(gpriv, ch);
 
 	return IRQ_HANDLED;
@@ -1235,7 +1292,7 @@ static irqreturn_t rcar_canfd_channel_interrupt(int irq, void *dev_id)
 	u32 ch;
 
 	/* Common FIFO is a per channel resource */
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_handle_channel_err(gpriv, ch);
 		rcar_canfd_handle_channel_tx(gpriv, ch);
 	}
@@ -1246,6 +1303,7 @@ static irqreturn_t rcar_canfd_channel_interrupt(int irq, void *dev_id)
 static void rcar_canfd_set_bittiming(struct net_device *dev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(dev);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	const struct can_bittiming *bt = &priv->can.bittiming;
 	const struct can_bittiming *dbt = &priv->can.data_bittiming;
 	u16 brp, sjw, tseg1, tseg2;
@@ -1260,8 +1318,8 @@ static void rcar_canfd_set_bittiming(struct net_device *dev)
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 		/* CAN FD only mode */
-		cfg = (RCANFD_NCFG_NTSEG1(tseg1) | RCANFD_NCFG_NBRP(brp) |
-		       RCANFD_NCFG_NSJW(sjw) | RCANFD_NCFG_NTSEG2(tseg2));
+		cfg = (RCANFD_NCFG_NTSEG1(gpriv, tseg1) | RCANFD_NCFG_NBRP(brp) |
+		       RCANFD_NCFG_NSJW(gpriv, sjw) | RCANFD_NCFG_NTSEG2(gpriv, tseg2));
 
 		rcar_canfd_write(priv->base, RCANFD_CCFG(ch), cfg);
 		netdev_dbg(priv->ndev, "nrate: brp %u, sjw %u, tseg1 %u, tseg2 %u\n",
@@ -1273,16 +1331,25 @@ static void rcar_canfd_set_bittiming(struct net_device *dev)
 		tseg1 = dbt->prop_seg + dbt->phase_seg1 - 1;
 		tseg2 = dbt->phase_seg2 - 1;
 
-		cfg = (RCANFD_DCFG_DTSEG1(tseg1) | RCANFD_DCFG_DBRP(brp) |
-		       RCANFD_DCFG_DSJW(sjw) | RCANFD_DCFG_DTSEG2(tseg2));
+		cfg = (RCANFD_DCFG_DTSEG1(gpriv, tseg1) | RCANFD_DCFG_DBRP(brp) |
+		       RCANFD_DCFG_DSJW(sjw) | RCANFD_DCFG_DTSEG2(gpriv, tseg2));
 
 		rcar_canfd_write(priv->base, RCANFD_F_DCFG(ch), cfg);
 		netdev_dbg(priv->ndev, "drate: brp %u, sjw %u, tseg1 %u, tseg2 %u\n",
 			   brp, sjw, tseg1, tseg2);
 	} else {
 		/* Classical CAN only mode */
-		cfg = (RCANFD_CFG_TSEG1(tseg1) | RCANFD_CFG_BRP(brp) |
-			RCANFD_CFG_SJW(sjw) | RCANFD_CFG_TSEG2(tseg2));
+		if (is_v3u(gpriv)) {
+			cfg = (RCANFD_NCFG_NTSEG1(gpriv, tseg1) |
+			       RCANFD_NCFG_NBRP(brp) |
+			       RCANFD_NCFG_NSJW(gpriv, sjw) |
+			       RCANFD_NCFG_NTSEG2(gpriv, tseg2));
+		} else {
+			cfg = (RCANFD_CFG_TSEG1(tseg1) |
+			       RCANFD_CFG_BRP(brp) |
+			       RCANFD_CFG_SJW(sjw) |
+			       RCANFD_CFG_TSEG2(tseg2));
+		}
 
 		rcar_canfd_write(priv->base, RCANFD_CCFG(ch), cfg);
 		netdev_dbg(priv->ndev,
@@ -1294,6 +1361,7 @@ static void rcar_canfd_set_bittiming(struct net_device *dev)
 static int rcar_canfd_start(struct net_device *ndev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(ndev);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	int err = -EOPNOTSUPP;
 	u32 sts, ch = priv->channel;
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
@@ -1315,9 +1383,9 @@ static int rcar_canfd_start(struct net_device *ndev)
 	}
 
 	/* Enable Common & Rx FIFO */
-	rcar_canfd_set_bit(priv->base, RCANFD_CFCC(ch, RCANFD_CFFIFO_IDX),
+	rcar_canfd_set_bit(priv->base, RCANFD_CFCC(gpriv, ch, RCANFD_CFFIFO_IDX),
 			   RCANFD_CFCC_CFE);
-	rcar_canfd_set_bit(priv->base, RCANFD_RFCC(ridx), RCANFD_RFCC_RFE);
+	rcar_canfd_set_bit(priv->base, RCANFD_RFCC(gpriv, ridx), RCANFD_RFCC_RFE);
 
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 	return 0;
@@ -1365,6 +1433,7 @@ static int rcar_canfd_open(struct net_device *ndev)
 static void rcar_canfd_stop(struct net_device *ndev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(ndev);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	int err;
 	u32 sts, ch = priv->channel;
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
@@ -1382,9 +1451,9 @@ static void rcar_canfd_stop(struct net_device *ndev)
 	rcar_canfd_disable_channel_interrupts(priv);
 
 	/* Disable Common & Rx FIFO */
-	rcar_canfd_clear_bit(priv->base, RCANFD_CFCC(ch, RCANFD_CFFIFO_IDX),
+	rcar_canfd_clear_bit(priv->base, RCANFD_CFCC(gpriv, ch, RCANFD_CFFIFO_IDX),
 			     RCANFD_CFCC_CFE);
-	rcar_canfd_clear_bit(priv->base, RCANFD_RFCC(ridx), RCANFD_RFCC_RFE);
+	rcar_canfd_clear_bit(priv->base, RCANFD_RFCC(gpriv, ridx), RCANFD_RFCC_RFE);
 
 	/* Set the state as STOPPED */
 	priv->can.state = CAN_STATE_STOPPED;
@@ -1408,6 +1477,7 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 					 struct net_device *ndev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(ndev);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
 	u32 sts = 0, id, dlc;
 	unsigned long flags;
@@ -1428,11 +1498,11 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 
 	dlc = RCANFD_CFPTR_CFDLC(can_fd_len2dlc(cf->len));
 
-	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) || is_v3u(gpriv)) {
 		rcar_canfd_write(priv->base,
-				 RCANFD_F_CFID(ch, RCANFD_CFFIFO_IDX), id);
+				 RCANFD_F_CFID(gpriv, ch, RCANFD_CFFIFO_IDX), id);
 		rcar_canfd_write(priv->base,
-				 RCANFD_F_CFPTR(ch, RCANFD_CFFIFO_IDX), dlc);
+				 RCANFD_F_CFPTR(gpriv, ch, RCANFD_CFFIFO_IDX), dlc);
 
 		if (can_is_canfd_skb(skb)) {
 			/* CAN FD frame format */
@@ -1445,10 +1515,10 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 		}
 
 		rcar_canfd_write(priv->base,
-				 RCANFD_F_CFFDCSTS(ch, RCANFD_CFFIFO_IDX), sts);
+				 RCANFD_F_CFFDCSTS(gpriv, ch, RCANFD_CFFIFO_IDX), sts);
 
 		rcar_canfd_put_data(priv, cf,
-				    RCANFD_F_CFDF(ch, RCANFD_CFFIFO_IDX, 0));
+				    RCANFD_F_CFDF(gpriv, ch, RCANFD_CFFIFO_IDX, 0));
 	} else {
 		rcar_canfd_write(priv->base,
 				 RCANFD_C_CFID(ch, RCANFD_CFFIFO_IDX), id);
@@ -1471,7 +1541,7 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 	 * pointer for the Common FIFO
 	 */
 	rcar_canfd_write(priv->base,
-			 RCANFD_CFPCTR(ch, RCANFD_CFFIFO_IDX), 0xff);
+			 RCANFD_CFPCTR(gpriv, ch, RCANFD_CFFIFO_IDX), 0xff);
 
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 	return NETDEV_TX_OK;
@@ -1480,18 +1550,21 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 {
 	struct net_device_stats *stats = &priv->ndev->stats;
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	struct canfd_frame *cf;
 	struct sk_buff *skb;
 	u32 sts = 0, id, dlc;
 	u32 ch = priv->channel;
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
 
-	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
-		id = rcar_canfd_read(priv->base, RCANFD_F_RFID(ridx));
-		dlc = rcar_canfd_read(priv->base, RCANFD_F_RFPTR(ridx));
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) || is_v3u(gpriv)) {
+		id = rcar_canfd_read(priv->base, RCANFD_F_RFID(gpriv, ridx));
+		dlc = rcar_canfd_read(priv->base, RCANFD_F_RFPTR(gpriv, ridx));
 
-		sts = rcar_canfd_read(priv->base, RCANFD_F_RFFDSTS(ridx));
-		if (sts & RCANFD_RFFDSTS_RFFDF)
+		sts = rcar_canfd_read(priv->base, RCANFD_F_RFFDSTS(gpriv, ridx));
+
+		if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) &&
+		    sts & RCANFD_RFFDSTS_RFFDF)
 			skb = alloc_canfd_skb(priv->ndev, &cf);
 		else
 			skb = alloc_can_skb(priv->ndev,
@@ -1529,12 +1602,14 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 			if (sts & RCANFD_RFFDSTS_RFBRS)
 				cf->flags |= CANFD_BRS;
 
-			rcar_canfd_get_data(priv, cf, RCANFD_F_RFDF(ridx, 0));
+			rcar_canfd_get_data(priv, cf, RCANFD_F_RFDF(gpriv, ridx, 0));
 		}
 	} else {
 		cf->len = can_cc_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 		if (id & RCANFD_RFID_RFRTR)
 			cf->can_id |= CAN_RTR_FLAG;
+		else if (is_v3u(gpriv))
+			rcar_canfd_get_data(priv, cf, RCANFD_F_RFDF(gpriv, ridx, 0));
 		else
 			rcar_canfd_get_data(priv, cf, RCANFD_C_RFDF(ridx, 0));
 	}
@@ -1542,7 +1617,7 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 	/* Write 0xff to RFPC to increment the CPU-side
 	 * pointer of the Rx FIFO
 	 */
-	rcar_canfd_write(priv->base, RCANFD_RFPCTR(ridx), 0xff);
+	rcar_canfd_write(priv->base, RCANFD_RFPCTR(gpriv, ridx), 0xff);
 
 	can_led_event(priv->ndev, CAN_LED_EVENT_RX);
 
@@ -1556,13 +1631,14 @@ static int rcar_canfd_rx_poll(struct napi_struct *napi, int quota)
 {
 	struct rcar_canfd_channel *priv =
 		container_of(napi, struct rcar_canfd_channel, napi);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	int num_pkts;
 	u32 sts;
 	u32 ch = priv->channel;
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
 
 	for (num_pkts = 0; num_pkts < quota; num_pkts++) {
-		sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
+		sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(gpriv, ridx));
 		/* Check FIFO empty condition */
 		if (sts & RCANFD_RFSTS_RFEMP)
 			break;
@@ -1571,7 +1647,7 @@ static int rcar_canfd_rx_poll(struct napi_struct *napi, int quota)
 
 		/* Clear interrupt bit */
 		if (sts & RCANFD_RFSTS_RFIF)
-			rcar_canfd_write(priv->base, RCANFD_RFSTS(ridx),
+			rcar_canfd_write(priv->base, RCANFD_RFSTS(gpriv, ridx),
 					 sts & ~RCANFD_RFSTS_RFIF);
 	}
 
@@ -1579,7 +1655,7 @@ static int rcar_canfd_rx_poll(struct napi_struct *napi, int quota)
 	if (num_pkts < quota) {
 		if (napi_complete_done(napi, num_pkts)) {
 			/* Enable Rx FIFO interrupts */
-			rcar_canfd_set_bit(priv->base, RCANFD_RFCC(ridx),
+			rcar_canfd_set_bit(priv->base, RCANFD_RFCC(gpriv, ridx),
 					   RCANFD_RFCC_RFIE);
 		}
 	}
@@ -1756,21 +1832,24 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	int g_err_irq, g_recc_irq;
 	bool fdmode = true;			/* CAN FD only mode - default */
 	enum rcanfd_chip_id chip_id;
+	int max_channels;
+	char name[9] = "channelX";
+	int i;
 
 	chip_id = (uintptr_t)of_device_get_match_data(&pdev->dev);
+	max_channels = chip_id == RENESAS_R8A779A0 ? 8 : 2;
 
 	if (of_property_read_bool(pdev->dev.of_node, "renesas,no-can-fd"))
 		fdmode = false;			/* Classical CAN only mode */
 
-	of_child = of_get_child_by_name(pdev->dev.of_node, "channel0");
-	if (of_child && of_device_is_available(of_child))
-		channels_mask |= BIT(0);	/* Channel 0 */
-
-	of_child = of_get_child_by_name(pdev->dev.of_node, "channel1");
-	if (of_child && of_device_is_available(of_child))
-		channels_mask |= BIT(1);	/* Channel 1 */
+	for (i = 0; i < max_channels; ++i) {
+		name[7] = '0' + i;
+		of_child = of_get_child_by_name(pdev->dev.of_node, name);
+		if (of_child && of_device_is_available(of_child))
+			channels_mask |= BIT(i);
+	}
 
-	if (chip_id == RENESAS_RCAR_GEN3) {
+	if (chip_id != RENESAS_RZG2L) {
 		ch_irq = platform_get_irq_byname_optional(pdev, "ch_int");
 		if (ch_irq < 0) {
 			/* For backward compatibility get irq by index */
@@ -1806,6 +1885,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->channels_mask = channels_mask;
 	gpriv->fdmode = fdmode;
 	gpriv->chip_id = chip_id;
+	gpriv->max_channels = max_channels;
 
 	if (gpriv->chip_id == RENESAS_RZG2L) {
 		gpriv->rstc1 = devm_reset_control_get_exclusive(&pdev->dev, "rstp_n");
@@ -1847,7 +1927,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	}
 	fcan_freq = clk_get_rate(gpriv->can_clk);
 
-	if (gpriv->fcan == RCANFD_CANFDCLK && gpriv->chip_id == RENESAS_RCAR_GEN3)
+	if (gpriv->fcan == RCANFD_CANFDCLK && gpriv->chip_id != RENESAS_RZG2L)
 		/* CANFD clock is further divided by (1/2) within the IP */
 		fcan_freq /= 2;
 
@@ -1859,7 +1939,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->base = addr;
 
 	/* Request IRQ that's common for both channels */
-	if (gpriv->chip_id == RENESAS_RCAR_GEN3) {
+	if (gpriv->chip_id != RENESAS_RZG2L) {
 		err = devm_request_irq(&pdev->dev, ch_irq,
 				       rcar_canfd_channel_interrupt, 0,
 				       "canfd.ch_int", gpriv);
@@ -1925,7 +2005,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	rcar_canfd_configure_controller(gpriv);
 
 	/* Configure per channel attributes */
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, max_channels) {
 		/* Configure Channel's Rx fifo */
 		rcar_canfd_configure_rx(gpriv, ch);
 
@@ -1951,7 +2031,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		goto fail_mode;
 	}
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, max_channels) {
 		err = rcar_canfd_channel_probe(gpriv, ch, fcan_freq);
 		if (err)
 			goto fail_channel;
@@ -1963,7 +2043,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	return 0;
 
 fail_channel:
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+	for_each_set_bit(ch, &gpriv->channels_mask, max_channels)
 		rcar_canfd_channel_remove(gpriv, ch);
 fail_mode:
 	rcar_canfd_disable_global_interrupts(gpriv);
@@ -1984,7 +2064,7 @@ static int rcar_canfd_remove(struct platform_device *pdev)
 	rcar_canfd_reset_controller(gpriv);
 	rcar_canfd_disable_global_interrupts(gpriv);
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_disable_channel_interrupts(gpriv->ch[ch]);
 		rcar_canfd_channel_remove(gpriv, ch);
 	}
@@ -2014,6 +2094,7 @@ static SIMPLE_DEV_PM_OPS(rcar_canfd_pm_ops, rcar_canfd_suspend,
 static const __maybe_unused struct of_device_id rcar_canfd_of_table[] = {
 	{ .compatible = "renesas,rcar-gen3-canfd", .data = (void *)RENESAS_RCAR_GEN3 },
 	{ .compatible = "renesas,rzg2l-canfd", .data = (void *)RENESAS_RZG2L },
+	{ .compatible = "renesas,r8a779a0-canfd", .data = (void *)RENESAS_R8A779A0 },
 	{ }
 };
 
-- 
2.35.1


