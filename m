Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8146785AB
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjAWTB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbjAWTB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:01:26 -0500
X-Greylist: delayed 302 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Jan 2023 11:01:25 PST
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8151BF3
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:01:25 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:6083:1fd7:ba05:ea8d])
        by xavier.telenet-ops.be with bizsmtp
        id CJwJ2900D4604Ck01JwJmt; Mon, 23 Jan 2023 19:56:21 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zG-0076KK-IZ;
        Mon, 23 Jan 2023 19:56:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zO-00EkhF-Fa;
        Mon, 23 Jan 2023 19:56:18 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 04/12] can: rcar_canfd: Fix R-Car V3U CAN mode selection
Date:   Mon, 23 Jan 2023 19:56:06 +0100
Message-Id: <388ddf312917eb9f6cc460a481f68402a876f9b5.1674499048.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674499048.git.geert+renesas@glider.be>
References: <cover.1674499048.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding support for R-Car V3U, the Global FD Configuration register
(CFDGFDCFG) and the Channel-specific CAN-FD Configuration Registers
(CFDCmFDCFG) were mixed up.  Use the correct register, and apply the
selected CAN mode to all available channels.

Annotate the corresponding register bits, to make it clear they do
not exist on older variants.

Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0 SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Currently the selected CAN mode is a global setting (controlled through
the "renesas,no-can-fd" DT property), but the variant on R-Car V3U and
later seems to support configuring this per-channel.  Whether
"renesas,no-can-fd" can be made channel-specific is still to be seen, as
the driver performs some global configuration based on the selected CAN
mode.
---
 drivers/net/can/rcar/rcar_canfd.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index f6fa7157b99b07da..88de17d0bd79d627 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -197,8 +197,8 @@
 #define RCANFD_DCFG_DBRP(x)		(((x) & 0xff) << 0)
 
 /* RSCFDnCFDCmFDCFG */
-#define RCANFD_FDCFG_CLOE		BIT(30)
-#define RCANFD_FDCFG_FDOE		BIT(28)
+#define RCANFD_V3U_FDCFG_CLOE		BIT(30)
+#define RCANFD_V3U_FDCFG_FDOE		BIT(28)
 #define RCANFD_FDCFG_TDCE		BIT(9)
 #define RCANFD_FDCFG_TDCOC		BIT(8)
 #define RCANFD_FDCFG_TDCO(x)		(((x) & 0x7f) >> 16)
@@ -429,8 +429,8 @@
 #define RCANFD_C_RPGACC(r)		(0x1900 + (0x04 * (r)))
 
 /* R-Car V3U Classical and CAN FD mode specific register map */
-#define RCANFD_V3U_CFDCFG		(0x1314)
 #define RCANFD_V3U_DCFG(m)		(0x1400 + (0x20 * (m)))
+#define RCANFD_V3U_FDCFG(m)		(0x1404 + (0x20 * (m)))
 
 #define RCANFD_V3U_GAFL_OFFSET		(0x1800)
 
@@ -689,12 +689,13 @@ static void rcar_canfd_tx_failure_cleanup(struct net_device *ndev)
 static void rcar_canfd_set_mode(struct rcar_canfd_global *gpriv)
 {
 	if (is_v3u(gpriv)) {
-		if (gpriv->fdmode)
-			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_CFDCFG,
-					   RCANFD_FDCFG_FDOE);
-		else
-			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_CFDCFG,
-					   RCANFD_FDCFG_CLOE);
+		u32 ch, val = gpriv->fdmode ? RCANFD_V3U_FDCFG_FDOE
+					    : RCANFD_V3U_FDCFG_CLOE;
+
+		for_each_set_bit(ch, &gpriv->channels_mask,
+				 gpriv->info->max_channels)
+			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_FDCFG(ch),
+					   val);
 	} else {
 		if (gpriv->fdmode)
 			rcar_canfd_set_bit(gpriv->base, RCANFD_GRMCFG,
-- 
2.34.1

