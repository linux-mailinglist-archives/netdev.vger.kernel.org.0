Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEC76CFE62
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjC3IeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjC3Idt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:33:49 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DC55FF7;
        Thu, 30 Mar 2023 01:33:45 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1B490C0003;
        Thu, 30 Mar 2023 08:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680165223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GFEsas8UkqdPDVCrhrnKj+uilFYdoYnYWmClhqduO1w=;
        b=cZLzF/BPJD9zYYUWaC83zrXwuX77tAxKxkmbgv7lHMP1S6GhvvCE8JYTDS9NBP3mXrRZw0
        0AlzT4vCo/dXfjwwF8UZMFM2JCqakh8+E3b3fQ/Hfz9byE4JX2Y6dOu5dN46E1tlIzcHkh
        rxzlTH8IpUTFVo8J+3X11JGbd5ubN0YlwzAiT/KSKhD1tJoXaGrrzoAfe/bzLpcPQg44WO
        bt73gR+cldqXzOBOrLrEr0CKpX5RoMniyZePNekjrvEdsSxU4TzTOV9Tz1zTwh1KCTUa3i
        mzz8SjR8oD22T6eZi+wECcSiYrxJfcSrcVKthLIjohnzfYy+6EJeSJaz6LPZIg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        =?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next 1/2] net: dsa: rzn1-a5psw: enable DPBU for CPU port and fix STP states
Date:   Thu, 30 Mar 2023 10:34:07 +0200
Message-Id: <20230330083408.63136-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230330083408.63136-1-clement.leger@bootlin.com>
References: <20230330083408.63136-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current there were actually two problems which made the STP support non
working. First, the BPDU were disabled on the CPU port which means BDPUs
were actually dropped internally to the switch. TO fix that, simply enable
BPDUs at management port level. Then, the a5psw_port_stp_set_state()
should  have actually received BPDU while in LEARNING mode which was not
the case. Additionally, the BLOCKEN bit does not actually forbid
sending forwarded frames from that port. To fix this, add
a5psw_port_tx_enable() function which allows to disable TX. However, while
its name suggest that TX is totally disabled, it is not and can still
allows to send BPDUs even if disabled. This can be done by using forced
forwarding with the switch tagging mecanism but keeping "filtering"
disabled (which is already the case). Which these fixes, STP support is now
functional.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/dsa/rzn1_a5psw.c | 53 +++++++++++++++++++++++++++++-------
 drivers/net/dsa/rzn1_a5psw.h |  4 ++-
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 919027cf2012..bbc1424ed416 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -120,6 +120,22 @@ static void a5psw_port_mgmtfwd_set(struct a5psw *a5psw, int port, bool enable)
 	a5psw_port_pattern_set(a5psw, port, A5PSW_PATTERN_MGMTFWD, enable);
 }
 
+static void a5psw_port_tx_enable(struct a5psw *a5psw, int port, bool enable)
+{
+	u32 mask = A5PSW_PORT_ENA_TX(port);
+	u32 reg = enable ? mask : 0;
+
+	/* Even though the port TX is disabled through TXENA bit in the
+	 * PORT_ENA register it can still send BPDUs. This depends on the tag
+	 * configuration added when sending packets from the CPU port to the
+	 * switch port. Indeed, when using forced forwarding without filtering,
+	 * even disabled port will be able to send packets that are tagged. This
+	 * allows to implement STP support when ports are in a state were
+	 * forwarding traffic should be stopped but BPDUs should still be sent.
+	 */
+	a5psw_reg_rmw(a5psw, A5PSW_CMD_CFG(port), mask, reg);
+}
+
 static void a5psw_port_enable_set(struct a5psw *a5psw, int port, bool enable)
 {
 	u32 port_ena = 0;
@@ -292,6 +308,18 @@ static int a5psw_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
 	return 0;
 }
 
+static void a5psw_port_learning_set(struct a5psw *a5psw, int port,
+				    bool learning, bool blocked)
+{
+	u32 mask = A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(port);
+	u32 reg = 0;
+
+	reg |= !learning ? A5PSW_INPUT_LEARN_DIS(port) : 0;
+	reg |= blocked ? A5PSW_INPUT_LEARN_BLOCK(port) : 0;
+
+	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
+}
+
 static void a5psw_flooding_set_resolution(struct a5psw *a5psw, int port,
 					  bool set)
 {
@@ -344,28 +372,33 @@ static void a5psw_port_bridge_leave(struct dsa_switch *ds, int port,
 
 static void a5psw_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
-	u32 mask = A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(port);
 	struct a5psw *a5psw = ds->priv;
-	u32 reg = 0;
+	bool learn, block;
 
 	switch (state) {
 	case BR_STATE_DISABLED:
 	case BR_STATE_BLOCKING:
-		reg |= A5PSW_INPUT_LEARN_DIS(port);
-		reg |= A5PSW_INPUT_LEARN_BLOCK(port);
-		break;
 	case BR_STATE_LISTENING:
-		reg |= A5PSW_INPUT_LEARN_DIS(port);
+		block = true;
+		learn = false;
+		a5psw_port_tx_enable(a5psw, port, false);
 		break;
 	case BR_STATE_LEARNING:
-		reg |= A5PSW_INPUT_LEARN_BLOCK(port);
+		block = true;
+		learn = true;
+		a5psw_port_tx_enable(a5psw, port, false);
 		break;
 	case BR_STATE_FORWARDING:
-	default:
+		block = false;
+		learn = true;
+		a5psw_port_tx_enable(a5psw, port, true);
 		break;
+	default:
+		dev_err(ds->dev, "invalid STP state: %d\n", state);
+		return;
 	}
 
-	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
+	a5psw_port_learning_set(a5psw, port, learn, block);
 }
 
 static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
@@ -673,7 +706,7 @@ static int a5psw_setup(struct dsa_switch *ds)
 	}
 
 	/* Configure management port */
-	reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_DISCARD;
+	reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_ENABLE;
 	a5psw_reg_writel(a5psw, A5PSW_MGMT_CFG, reg);
 
 	/* Set pattern 0 to forward all frame to mgmt port */
diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
index c67abd49c013..04d9486dbd21 100644
--- a/drivers/net/dsa/rzn1_a5psw.h
+++ b/drivers/net/dsa/rzn1_a5psw.h
@@ -19,6 +19,8 @@
 #define A5PSW_PORT_OFFSET(port)		(0x400 * (port))
 
 #define A5PSW_PORT_ENA			0x8
+#define A5PSW_PORT_ENA_TX_SHIFT		0
+#define A5PSW_PORT_ENA_TX(port)		BIT(port)
 #define A5PSW_PORT_ENA_RX_SHIFT		16
 #define A5PSW_PORT_ENA_TX_RX(port)	(BIT((port) + A5PSW_PORT_ENA_RX_SHIFT) | \
 					 BIT(port))
@@ -36,7 +38,7 @@
 #define A5PSW_INPUT_LEARN_BLOCK(p)	BIT(p)
 
 #define A5PSW_MGMT_CFG			0x20
-#define A5PSW_MGMT_CFG_DISCARD		BIT(7)
+#define A5PSW_MGMT_CFG_ENABLE		BIT(6)
 
 #define A5PSW_MODE_CFG			0x24
 #define A5PSW_MODE_STATS_RESET		BIT(31)
-- 
2.39.2

