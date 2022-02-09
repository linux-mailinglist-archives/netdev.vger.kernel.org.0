Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FB84AF6FB
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbiBIQlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbiBIQlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:41:15 -0500
X-Greylist: delayed 150 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 08:41:16 PST
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78057C0613C9;
        Wed,  9 Feb 2022 08:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644424696;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=paf8bp2YG3/UX15MLBjJRxnaq8BK/tSEpFV9WBr5GIU=;
    b=FhW4VB60MKRmNKt+HrnHdH6uORCar9Kl4OX+7ud7U5Ml5WSLN2tl3Jc9TMTt//xCew
    wlaV5B/kH4GJ68178/wdieR6kMwrlqq8bLJTwgkTPbIp28K1FgQAJSBkS1YgvxrKWVfA
    zyL9rxzfXPQUK0ajK7RHZAtI2w0i73wDjSM02mofz1ix0IsUA4IwnC6+HPQxr3257YB7
    wwK3MknVQIwfTsqst/ETkkwjrTAxBItMUXkZod3d+I74lmYuVQc8gbLkgdq1XR5sJCk6
    RmKmI9PWYp8O+lYVVyhvdnVdQhLUJaEuP2AeHZtizpQGI199njTxSLYq/zBZlkmPY7KZ
    uTOQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR82dfdzLc5sE="
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.39.0 DYNA|AUTH)
    with ESMTPSA id ufcb0fy19GcG7bu
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 9 Feb 2022 17:38:16 +0100 (CET)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH v3 1/4] can: rcar_canfd: Add support for r8a779a0 SoC
Date:   Wed,  9 Feb 2022 17:38:03 +0100
Message-Id: <20220209163806.18618-2-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220209163806.18618-1-uli+renesas@fpond.eu>
References: <20220209163806.18618-1-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds support for the CANFD IP variant in the V3U SoC.

Differences to controllers in other SoCs are limited to an increase in
the number of channels from two to eight, an absence of dedicated
registers for "classic" CAN mode, and a number of differences in magic
numbers (register offsets and layouts).

Inspired by BSP patch by Kazuya Mizuguchi.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
---
 drivers/net/can/rcar/rcar_canfd.c | 219 ++++++++++++++++++++----------
 1 file changed, 146 insertions(+), 73 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index b7dc1c32875f..3ad3a6f6a1dd 100644
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
@@ -86,20 +88,24 @@ enum rcanfd_chip_id {
 #define RCANFD_GERFL_MES		BIT(1)
 #define RCANFD_GERFL_DEF		BIT(0)
 
-#define RCANFD_GERFL_ERR(gpriv, x)	((x) & (RCANFD_GERFL_EEF1 |\
-					RCANFD_GERFL_EEF0 | RCANFD_GERFL_MES |\
-					(gpriv->fdmode ?\
-					 RCANFD_GERFL_CMPOF : 0)))
+#define RCANFD_GERFL_ERR(x)		((x) & (reg_v3u(gpriv, RCANFD_GERFL_EEF0_7, \
+					RCANFD_GERFL_EEF0 | RCANFD_GERFL_EEF1) | \
+					RCANFD_GERFL_MES | ((gpriv)->fdmode ? \
+					RCANFD_GERFL_CMPOF : 0)))
 
 /* AFL Rx rules registers */
 
 /* RSCFDnCFDGAFLCFG0 / RSCFDnGAFLCFG0 */
-#define RCANFD_GAFLCFG_SETRNC(n, x)	(((x) & 0xff) << (24 - n * 8))
-#define RCANFD_GAFLCFG_GETRNC(n, x)	(((x) >> (24 - n * 8)) & 0xff)
+#define RCANFD_GAFLCFG_SETRNC(n, x)	(((x) & reg_v3u(gpriv, 0x1ff, 0xff)) << \
+					 (reg_v3u(gpriv, 16, 24) - \
+					  (n) * reg_v3u(gpriv, 16, 8)))
+#define RCANFD_GAFLCFG_GETRNC(n, x)	(((x) >> (reg_v3u(gpriv, 16, 24) - \
+						  (n) * reg_v3u(gpriv, 16, 8))) & \
+					 reg_v3u(gpriv, 0x1ff, 0xff))
 
 /* RSCFDnCFDGAFLECTR / RSCFDnGAFLECTR */
 #define RCANFD_GAFLECTR_AFLDAE		BIT(8)
-#define RCANFD_GAFLECTR_AFLPN(x)	((x) & 0x1f)
+#define RCANFD_GAFLECTR_AFLPN(x)	((x) & reg_v3u(gpriv, 0x7f, 0x1f))
 
 /* RSCFDnCFDGAFLIDj / RSCFDnGAFLIDj */
 #define RCANFD_GAFLID_GAFLLB		BIT(29)
@@ -116,9 +122,12 @@ enum rcanfd_chip_id {
 #define RCANFD_CFG_BRP(x)		(((x) & 0x3ff) << 0)
 
 /* RSCFDnCFDCmNCFG - CAN FD only */
-#define RCANFD_NCFG_NTSEG2(x)		(((x) & 0x1f) << 24)
-#define RCANFD_NCFG_NTSEG1(x)		(((x) & 0x7f) << 16)
-#define RCANFD_NCFG_NSJW(x)		(((x) & 0x1f) << 11)
+#define RCANFD_NCFG_NTSEG2(x)		(((x) & reg_v3u(gpriv, 0x7f, 0x1f)) << \
+					 reg_v3u(gpriv, 25, 24))
+#define RCANFD_NCFG_NTSEG1(x)		(((x) & reg_v3u(gpriv, 0xff, 0x7f)) << \
+					 reg_v3u(gpriv, 17, 16))
+#define RCANFD_NCFG_NSJW(x)		(((x) & reg_v3u(gpriv, 0x7f, 0x1f)) << \
+					 reg_v3u(gpriv, 10, 11))
 #define RCANFD_NCFG_NBRP(x)		(((x) & 0x3ff) << 0)
 
 /* RSCFDnCFDCmCTR / RSCFDnCmCTR */
@@ -180,11 +189,15 @@ enum rcanfd_chip_id {
 
 /* RSCFDnCFDCmDCFG */
 #define RCANFD_DCFG_DSJW(x)		(((x) & 0x7) << 24)
-#define RCANFD_DCFG_DTSEG2(x)		(((x) & 0x7) << 20)
-#define RCANFD_DCFG_DTSEG1(x)		(((x) & 0xf) << 16)
+#define RCANFD_DCFG_DTSEG2(x)		(((x) & reg_v3u(gpriv, 0x0f, 0x7)) << \
+					 reg_v3u(gpriv, 16, 20))
+#define RCANFD_DCFG_DTSEG1(x)		(((x) & reg_v3u(gpriv, 0x1f, 0xf)) << \
+					 reg_v3u(gpriv, 8, 16))
 #define RCANFD_DCFG_DBRP(x)		(((x) & 0xff) << 0)
 
 /* RSCFDnCFDCmFDCFG */
+#define RCANFD_FDCFG_CLOE		BIT(30)
+#define RCANFD_FDCFG_FDOE		BIT(28)
 #define RCANFD_FDCFG_TDCE		BIT(9)
 #define RCANFD_FDCFG_TDCOC		BIT(8)
 #define RCANFD_FDCFG_TDCO(x)		(((x) & 0x7f) >> 16)
@@ -219,10 +232,10 @@ enum rcanfd_chip_id {
 /* Common FIFO bits */
 
 /* RSCFDnCFDCFCCk */
-#define RCANFD_CFCC_CFTML(x)		(((x) & 0xf) << 20)
-#define RCANFD_CFCC_CFM(x)		(((x) & 0x3) << 16)
+#define RCANFD_CFCC_CFTML(x)		(((x) & 0xf) << reg_v3u(gpriv, 16, 20))
+#define RCANFD_CFCC_CFM(x)		(((x) & 0x3) << reg_v3u(gpriv,  8, 16))
 #define RCANFD_CFCC_CFIM		BIT(12)
-#define RCANFD_CFCC_CFDC(x)		(((x) & 0x7) << 8)
+#define RCANFD_CFCC_CFDC(x)		(((x) & 0x7) << reg_v3u(gpriv, 21,  8))
 #define RCANFD_CFCC_CFPLS(x)		(((x) & 0x7) << 4)
 #define RCANFD_CFCC_CFTXIE		BIT(2)
 #define RCANFD_CFCC_CFE			BIT(0)
@@ -282,33 +295,32 @@ enum rcanfd_chip_id {
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
+#define RCANFD_RFCC(x)			(reg_v3u(gpriv, 0x00c0, 0x00b8) + \
+					 (0x04 * (x)))
 /* RSCFDnCFDRFSTSx / RSCFDnRFSTSx */
-#define RCANFD_RFSTS(x)			(0x00d8 + (0x04 * (x)))
+#define RCANFD_RFSTS(x)			(RCANFD_RFCC(x) + 0x20)
 /* RSCFDnCFDRFPCTRx / RSCFDnRFPCTRx */
-#define RCANFD_RFPCTR(x)		(0x00f8 + (0x04 * (x)))
+#define RCANFD_RFPCTR(x)		(RCANFD_RFCC(x) + 0x40)
 
 /* Common FIFO Control registers */
 
 /* RSCFDnCFDCFCCx / RSCFDnCFCCx */
-#define RCANFD_CFCC(ch, idx)		(0x0118 + (0x0c * (ch)) + \
-					 (0x04 * (idx)))
+#define RCANFD_CFCC(ch, idx)		(reg_v3u(gpriv, 0x0120, 0x0118) + \
+					 (0x0c * (ch)) + (0x04 * (idx)))
 /* RSCFDnCFDCFSTSx / RSCFDnCFSTSx */
-#define RCANFD_CFSTS(ch, idx)		(0x0178 + (0x0c * (ch)) + \
-					 (0x04 * (idx)))
+#define RCANFD_CFSTS(ch, idx)		(reg_v3u(gpriv, 0x01e0, 0x0178) + \
+					 (0x0c * (ch)) + (0x04 * (idx)))
 /* RSCFDnCFDCFPCTRx / RSCFDnCFPCTRx */
-#define RCANFD_CFPCTR(ch, idx)		(0x01d8 + (0x0c * (ch)) + \
-					 (0x04 * (idx)))
+#define RCANFD_CFPCTR(ch, idx)		(reg_v3u(gpriv, 0x0240, 0x01d8) + \
+					 (0x0c * (ch)) + (0x04 * (idx)))
 
 /* RSCFDnCFDFESTS / RSCFDnFESTS */
 #define RCANFD_FESTS			(0x0238)
@@ -415,6 +427,12 @@ enum rcanfd_chip_id {
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
@@ -434,7 +452,7 @@ enum rcanfd_chip_id {
 #define RCANFD_F_RMDF(q, b)		(0x200c + (0x04 * (b)) + (0x20 * (q)))
 
 /* RSCFDnCFDRFXXx -> RCANFD_F_RFXX(x) */
-#define RCANFD_F_RFOFFSET		(0x3000)
+#define RCANFD_F_RFOFFSET		reg_v3u(gpriv, 0x6000, 0x3000)
 #define RCANFD_F_RFID(x)		(RCANFD_F_RFOFFSET + (0x80 * (x)))
 #define RCANFD_F_RFPTR(x)		(RCANFD_F_RFOFFSET + 0x04 + \
 					 (0x80 * (x)))
@@ -444,7 +462,7 @@ enum rcanfd_chip_id {
 					 (0x80 * (x)) + (0x04 * (df)))
 
 /* RSCFDnCFDCFXXk -> RCANFD_F_CFXX(ch, k) */
-#define RCANFD_F_CFOFFSET		(0x3400)
+#define RCANFD_F_CFOFFSET		reg_v3u(gpriv, 0x6400, 0x3400)
 #define RCANFD_F_CFID(ch, idx)		(RCANFD_F_CFOFFSET + (0x180 * (ch)) + \
 					 (0x80 * (idx)))
 #define RCANFD_F_CFPTR(ch, idx)		(RCANFD_F_CFOFFSET + 0x04 + \
@@ -470,7 +488,7 @@ enum rcanfd_chip_id {
 #define RCANFD_FIFO_DEPTH		8	/* Tx FIFO depth */
 #define RCANFD_NAPI_WEIGHT		8	/* Rx poll quota */
 
-#define RCANFD_NUM_CHANNELS		2	/* Two channels max */
+#define RCANFD_NUM_CHANNELS		8	/* Eight channels max */
 #define RCANFD_CHANNELS_MASK		BIT((RCANFD_NUM_CHANNELS) - 1)
 
 #define RCANFD_GAFL_PAGENUM(entry)	((entry) / 16)
@@ -521,6 +539,7 @@ struct rcar_canfd_global {
 	struct reset_control *rstc1;
 	struct reset_control *rstc2;
 	enum rcanfd_chip_id chip_id;
+	u32 max_channels;
 };
 
 /* CAN FD mode nominal rate constants */
@@ -563,6 +582,17 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
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
@@ -628,6 +658,25 @@ static void rcar_canfd_tx_failure_cleanup(struct net_device *ndev)
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
@@ -660,15 +709,10 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
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
 
@@ -709,7 +753,7 @@ static void rcar_canfd_configure_controller(struct rcar_canfd_global *gpriv)
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCFG, cfg);
 
 	/* Channel configuration settings */
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_set_bit(gpriv->base, RCANFD_CCTR(ch),
 				   RCANFD_CCTR_ERRD);
 		rcar_canfd_update_bit(gpriv->base, RCANFD_CCTR(ch),
@@ -729,7 +773,7 @@ static void rcar_canfd_configure_afl_rules(struct rcar_canfd_global *gpriv,
 		start = 0; /* Channel 0 always starts from 0th rule */
 	} else {
 		/* Get number of Channel 0 rules and adjust */
-		cfg = rcar_canfd_read(gpriv->base, RCANFD_GAFLCFG0);
+		cfg = rcar_canfd_read(gpriv->base, RCANFD_GAFLCFG(ch));
 		start = RCANFD_GAFLCFG_GETRNC(0, cfg);
 	}
 
@@ -740,12 +784,16 @@ static void rcar_canfd_configure_afl_rules(struct rcar_canfd_global *gpriv,
 			    RCANFD_GAFLECTR_AFLDAE));
 
 	/* Write number of rules for channel */
-	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLCFG0,
+	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLCFG(ch),
 			   RCANFD_GAFLCFG_SETRNC(ch, num_rules));
-	if (gpriv->fdmode)
-		offset = RCANFD_F_GAFL_OFFSET;
-	else
-		offset = RCANFD_C_GAFL_OFFSET;
+	if (is_v3u(gpriv)) {
+		offset = RCANFD_V3U_GAFL_OFFSET;
+	} else {
+		if (gpriv->fdmode)
+			offset = RCANFD_F_GAFL_OFFSET;
+		else
+			offset = RCANFD_C_GAFL_OFFSET;
+	}
 
 	/* Accept all IDs */
 	rcar_canfd_write(gpriv->base, RCANFD_GAFLID(offset, start), 0);
@@ -754,8 +802,8 @@ static void rcar_canfd_configure_afl_rules(struct rcar_canfd_global *gpriv,
 	/* Any data length accepted */
 	rcar_canfd_write(gpriv->base, RCANFD_GAFLP0(offset, start), 0);
 	/* Place the msg in corresponding Rx FIFO entry */
-	rcar_canfd_write(gpriv->base, RCANFD_GAFLP1(offset, start),
-			 RCANFD_GAFLP1_GAFLFDP(ridx));
+	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLP1(offset, start),
+			   RCANFD_GAFLP1_GAFLFDP(ridx));
 
 	/* Disable write access to page */
 	rcar_canfd_clear_bit(gpriv->base,
@@ -1038,6 +1086,7 @@ static void rcar_canfd_error(struct net_device *ndev, u32 cerfl,
 static void rcar_canfd_tx_done(struct net_device *ndev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(ndev);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	struct net_device_stats *stats = &ndev->stats;
 	u32 sts;
 	unsigned long flags;
@@ -1082,7 +1131,7 @@ static void rcar_canfd_handle_global_err(struct rcar_canfd_global *gpriv, u32 ch
 
 	/* Handle global error interrupts */
 	gerfl = rcar_canfd_read(priv->base, RCANFD_GERFL);
-	if (unlikely(RCANFD_GERFL_ERR(gpriv, gerfl)))
+	if (unlikely(RCANFD_GERFL_ERR(gerfl)))
 		rcar_canfd_global_error(ndev);
 }
 
@@ -1091,7 +1140,7 @@ static irqreturn_t rcar_canfd_global_err_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	u32 ch;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
 		rcar_canfd_handle_global_err(gpriv, ch);
 
 	return IRQ_HANDLED;
@@ -1121,7 +1170,7 @@ static irqreturn_t rcar_canfd_global_receive_fifo_interrupt(int irq, void *dev_i
 	struct rcar_canfd_global *gpriv = dev_id;
 	u32 ch;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
 		rcar_canfd_handle_global_receive(gpriv, ch);
 
 	return IRQ_HANDLED;
@@ -1135,7 +1184,7 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 	/* Global error interrupts still indicate a condition specific
 	 * to a channel. RxFIFO interrupt is a global interrupt.
 	 */
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_handle_global_err(gpriv, ch);
 		rcar_canfd_handle_global_receive(gpriv, ch);
 	}
@@ -1191,7 +1240,7 @@ static irqreturn_t rcar_canfd_channel_tx_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	u32 ch;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
 		rcar_canfd_handle_channel_tx(gpriv, ch);
 
 	return IRQ_HANDLED;
@@ -1223,7 +1272,7 @@ static irqreturn_t rcar_canfd_channel_err_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	u32 ch;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
 		rcar_canfd_handle_channel_err(gpriv, ch);
 
 	return IRQ_HANDLED;
@@ -1235,7 +1284,7 @@ static irqreturn_t rcar_canfd_channel_interrupt(int irq, void *dev_id)
 	u32 ch;
 
 	/* Common FIFO is a per channel resource */
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_handle_channel_err(gpriv, ch);
 		rcar_canfd_handle_channel_tx(gpriv, ch);
 	}
@@ -1246,6 +1295,7 @@ static irqreturn_t rcar_canfd_channel_interrupt(int irq, void *dev_id)
 static void rcar_canfd_set_bittiming(struct net_device *dev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(dev);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	const struct can_bittiming *bt = &priv->can.bittiming;
 	const struct can_bittiming *dbt = &priv->can.data_bittiming;
 	u16 brp, sjw, tseg1, tseg2;
@@ -1281,8 +1331,17 @@ static void rcar_canfd_set_bittiming(struct net_device *dev)
 			   brp, sjw, tseg1, tseg2);
 	} else {
 		/* Classical CAN only mode */
-		cfg = (RCANFD_CFG_TSEG1(tseg1) | RCANFD_CFG_BRP(brp) |
-			RCANFD_CFG_SJW(sjw) | RCANFD_CFG_TSEG2(tseg2));
+		if (is_v3u(gpriv)) {
+			cfg = (RCANFD_NCFG_NTSEG1(tseg1) |
+			       RCANFD_NCFG_NBRP(brp) |
+			       RCANFD_NCFG_NSJW(sjw) |
+			       RCANFD_NCFG_NTSEG2(tseg2));
+		} else {
+			cfg = (RCANFD_CFG_TSEG1(tseg1) |
+			       RCANFD_CFG_BRP(brp) |
+			       RCANFD_CFG_SJW(sjw) |
+			       RCANFD_CFG_TSEG2(tseg2));
+		}
 
 		rcar_canfd_write(priv->base, RCANFD_CCFG(ch), cfg);
 		netdev_dbg(priv->ndev,
@@ -1294,6 +1353,7 @@ static void rcar_canfd_set_bittiming(struct net_device *dev)
 static int rcar_canfd_start(struct net_device *ndev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(ndev);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	int err = -EOPNOTSUPP;
 	u32 sts, ch = priv->channel;
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
@@ -1365,6 +1425,7 @@ static int rcar_canfd_open(struct net_device *ndev)
 static void rcar_canfd_stop(struct net_device *ndev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(ndev);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	int err;
 	u32 sts, ch = priv->channel;
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
@@ -1408,6 +1469,7 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 					 struct net_device *ndev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(ndev);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
 	u32 sts = 0, id, dlc;
 	unsigned long flags;
@@ -1428,7 +1490,7 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 
 	dlc = RCANFD_CFPTR_CFDLC(can_fd_len2dlc(cf->len));
 
-	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) || is_v3u(gpriv)) {
 		rcar_canfd_write(priv->base,
 				 RCANFD_F_CFID(ch, RCANFD_CFFIFO_IDX), id);
 		rcar_canfd_write(priv->base,
@@ -1480,18 +1542,21 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
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
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) || is_v3u(gpriv)) {
 		id = rcar_canfd_read(priv->base, RCANFD_F_RFID(ridx));
 		dlc = rcar_canfd_read(priv->base, RCANFD_F_RFPTR(ridx));
 
 		sts = rcar_canfd_read(priv->base, RCANFD_F_RFFDSTS(ridx));
-		if (sts & RCANFD_RFFDSTS_RFFDF)
+
+		if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) &&
+		    sts & RCANFD_RFFDSTS_RFFDF)
 			skb = alloc_canfd_skb(priv->ndev, &cf);
 		else
 			skb = alloc_can_skb(priv->ndev,
@@ -1535,6 +1600,8 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 		cf->len = can_cc_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 		if (id & RCANFD_RFID_RFRTR)
 			cf->can_id |= CAN_RTR_FLAG;
+		else if (is_v3u(gpriv))
+			rcar_canfd_get_data(priv, cf, RCANFD_F_RFDF(ridx, 0));
 		else
 			rcar_canfd_get_data(priv, cf, RCANFD_C_RFDF(ridx, 0));
 	}
@@ -1556,6 +1623,7 @@ static int rcar_canfd_rx_poll(struct napi_struct *napi, int quota)
 {
 	struct rcar_canfd_channel *priv =
 		container_of(napi, struct rcar_canfd_channel, napi);
+	struct rcar_canfd_global *gpriv = priv->gpriv;
 	int num_pkts;
 	u32 sts;
 	u32 ch = priv->channel;
@@ -1756,21 +1824,24 @@ static int rcar_canfd_probe(struct platform_device *pdev)
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
@@ -1806,6 +1877,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->channels_mask = channels_mask;
 	gpriv->fdmode = fdmode;
 	gpriv->chip_id = chip_id;
+	gpriv->max_channels = max_channels;
 
 	if (gpriv->chip_id == RENESAS_RZG2L) {
 		gpriv->rstc1 = devm_reset_control_get_exclusive(&pdev->dev, "rstp_n");
@@ -1847,7 +1919,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	}
 	fcan_freq = clk_get_rate(gpriv->can_clk);
 
-	if (gpriv->fcan == RCANFD_CANFDCLK && gpriv->chip_id == RENESAS_RCAR_GEN3)
+	if (gpriv->fcan == RCANFD_CANFDCLK && gpriv->chip_id != RENESAS_RZG2L)
 		/* CANFD clock is further divided by (1/2) within the IP */
 		fcan_freq /= 2;
 
@@ -1859,7 +1931,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->base = addr;
 
 	/* Request IRQ that's common for both channels */
-	if (gpriv->chip_id == RENESAS_RCAR_GEN3) {
+	if (gpriv->chip_id != RENESAS_RZG2L) {
 		err = devm_request_irq(&pdev->dev, ch_irq,
 				       rcar_canfd_channel_interrupt, 0,
 				       "canfd.ch_int", gpriv);
@@ -1925,7 +1997,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	rcar_canfd_configure_controller(gpriv);
 
 	/* Configure per channel attributes */
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, max_channels) {
 		/* Configure Channel's Rx fifo */
 		rcar_canfd_configure_rx(gpriv, ch);
 
@@ -1951,7 +2023,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		goto fail_mode;
 	}
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, max_channels) {
 		err = rcar_canfd_channel_probe(gpriv, ch, fcan_freq);
 		if (err)
 			goto fail_channel;
@@ -1963,7 +2035,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	return 0;
 
 fail_channel:
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+	for_each_set_bit(ch, &gpriv->channels_mask, max_channels)
 		rcar_canfd_channel_remove(gpriv, ch);
 fail_mode:
 	rcar_canfd_disable_global_interrupts(gpriv);
@@ -1984,7 +2056,7 @@ static int rcar_canfd_remove(struct platform_device *pdev)
 	rcar_canfd_reset_controller(gpriv);
 	rcar_canfd_disable_global_interrupts(gpriv);
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_disable_channel_interrupts(gpriv->ch[ch]);
 		rcar_canfd_channel_remove(gpriv, ch);
 	}
@@ -2014,6 +2086,7 @@ static SIMPLE_DEV_PM_OPS(rcar_canfd_pm_ops, rcar_canfd_suspend,
 static const __maybe_unused struct of_device_id rcar_canfd_of_table[] = {
 	{ .compatible = "renesas,rcar-gen3-canfd", .data = (void *)RENESAS_RCAR_GEN3 },
 	{ .compatible = "renesas,rzg2l-canfd", .data = (void *)RENESAS_RZG2L },
+	{ .compatible = "renesas,r8a779a0-canfd", .data = (void *)RENESAS_R8A779A0 },
 	{ }
 };
 
-- 
2.20.1

