Return-Path: <netdev+bounces-2050-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE2F700178
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:27:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A73C01C21113
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 07:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08ECE748C;
	Fri, 12 May 2023 07:27:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16C68F77
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:27:04 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9019C2100;
	Fri, 12 May 2023 00:27:01 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id BC13440009;
	Fri, 12 May 2023 07:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1683876420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e7DWsb2bbWPMA2AP2i+pXEq6IQCsDHi3ExOEOjVPOZU=;
	b=m9n5tt+Z/tF7gWxhHI4SmPyVa6WagQF81cpc1jEOVqQnXKKO0WgHUSQUfAIRK4Jvw0hu5C
	aEFk9C97Jp1zY84PruTHMMrZx68A200kguRtwslh5ydoig3SoqYwXaOVwSJSprD40tVkPR
	AkCBsJBRH0h1tWG7Rd+ZJ8Y5j3Bk+yDbkOJJuMyyPny7VVrphRVGUKrDLhFEGj2TB2UB00
	3qdPyz11LwyqcsUPtLA3ZAOTyafCldhn/la5zPHJFZjM6ms5+DclCsg2fnn/z+w/NF1GU0
	5m2Ngj5ryEH6NDSU9nNtbc80j04NgI+7JrxcsEHKKlqOJSMameJuOa3KO5Aa5A==
From: alexis.lothore@bootlin.com
To: andrew@lunn.ch,
	f.fainelli@gmail.com,
	olteanv@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: linux-renesas-soc@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	herve.codina@bootlin.com,
	miquel.raynal@bootlin.com,
	milan.stevanovic@se.com,
	jimmy.lalande@se.com,
	pascal.eberhard@se.com
Subject: [PATCH net v3 2/3] net: dsa: rzn1-a5psw: fix STP states handling
Date: Fri, 12 May 2023 09:27:11 +0200
Message-Id: <20230512072712.82694-3-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512072712.82694-1-alexis.lothore@bootlin.com>
References: <20230512072712.82694-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

stp_set_state() should actually allow receiving BPDU while in LEARNING
mode which is not the case. Additionally, the BLOCKEN bit does not
actually forbid sending forwarded frames from that port. To fix this, add
a5psw_port_tx_enable() function which allows to disable TX. However, while
its name suggest that TX is totally disabled, it is not and can still
allow to send BPDUs even if disabled. This can be done by using forced
forwarding with the switch tagging mechanism but keeping "filtering"
disabled (which is already the case in the rzn1-a5sw tag driver). With
these fixes, STP support is now functional.

Fixes: 888cdb892b61 ("net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
Changes since v2:
- move A5PSW_MGMT_CFG_ENABLE definition to previous commit
- fix reverse christmas tree ordering in a5psw_port_stp_state_set
---
 drivers/net/dsa/rzn1_a5psw.c | 57 ++++++++++++++++++++++++++++++------
 drivers/net/dsa/rzn1_a5psw.h |  1 +
 2 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 8a419e2ffe2a..e2549cb31d00 100644
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
+	 * PORT_ENA register, it can still send BPDUs. This depends on the tag
+	 * configuration added when sending packets from the CPU port to the
+	 * switch port. Indeed, when using forced forwarding without filtering,
+	 * even disabled ports will be able to send packets that are tagged.
+	 * This allows to implement STP support when ports are in a state where
+	 * forwarding traffic should be stopped but BPDUs should still be sent.
+	 */
+	a5psw_reg_rmw(a5psw, A5PSW_PORT_ENA, mask, reg);
+}
+
 static void a5psw_port_enable_set(struct a5psw *a5psw, int port, bool enable)
 {
 	u32 port_ena = 0;
@@ -292,6 +308,22 @@ static int a5psw_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
 	return 0;
 }
 
+static void a5psw_port_learning_set(struct a5psw *a5psw, int port, bool learn)
+{
+	u32 mask = A5PSW_INPUT_LEARN_DIS(port);
+	u32 reg = !learn ? mask : 0;
+
+	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
+}
+
+static void a5psw_port_rx_block_set(struct a5psw *a5psw, int port, bool block)
+{
+	u32 mask = A5PSW_INPUT_LEARN_BLOCK(port);
+	u32 reg = block ? mask : 0;
+
+	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
+}
+
 static void a5psw_flooding_set_resolution(struct a5psw *a5psw, int port,
 					  bool set)
 {
@@ -344,28 +376,35 @@ static void a5psw_port_bridge_leave(struct dsa_switch *ds, int port,
 
 static void a5psw_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
-	u32 mask = A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(port);
+	bool learning_enabled, rx_enabled, tx_enabled;
 	struct a5psw *a5psw = ds->priv;
-	u32 reg = 0;
 
 	switch (state) {
 	case BR_STATE_DISABLED:
 	case BR_STATE_BLOCKING:
-		reg |= A5PSW_INPUT_LEARN_DIS(port);
-		reg |= A5PSW_INPUT_LEARN_BLOCK(port);
-		break;
 	case BR_STATE_LISTENING:
-		reg |= A5PSW_INPUT_LEARN_DIS(port);
+		rx_enabled = false;
+		tx_enabled = false;
+		learning_enabled = false;
 		break;
 	case BR_STATE_LEARNING:
-		reg |= A5PSW_INPUT_LEARN_BLOCK(port);
+		rx_enabled = false;
+		tx_enabled = false;
+		learning_enabled = true;
 		break;
 	case BR_STATE_FORWARDING:
-	default:
+		rx_enabled = true;
+		tx_enabled = true;
+		learning_enabled = true;
 		break;
+	default:
+		dev_err(ds->dev, "invalid STP state: %d\n", state);
+		return;
 	}
 
-	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
+	a5psw_port_learning_set(a5psw, port, learning_enabled);
+	a5psw_port_rx_block_set(a5psw, port, !rx_enabled);
+	a5psw_port_tx_enable(a5psw, port, tx_enabled);
 }
 
 static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
index b4fbf453ff74..b869192eef3f 100644
--- a/drivers/net/dsa/rzn1_a5psw.h
+++ b/drivers/net/dsa/rzn1_a5psw.h
@@ -19,6 +19,7 @@
 #define A5PSW_PORT_OFFSET(port)		(0x400 * (port))
 
 #define A5PSW_PORT_ENA			0x8
+#define A5PSW_PORT_ENA_TX(port)		BIT(port)
 #define A5PSW_PORT_ENA_RX_SHIFT		16
 #define A5PSW_PORT_ENA_TX_RX(port)	(BIT((port) + A5PSW_PORT_ENA_RX_SHIFT) | \
 					 BIT(port))
-- 
2.40.1


