Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767F26B9BAB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCNQfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjCNQes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:34:48 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4D79B2C8;
        Tue, 14 Mar 2023 09:34:36 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F1EC5100015;
        Tue, 14 Mar 2023 16:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678811675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ib/mOXHYH3Do6zNpWmBQIKneKPV3vlWtkcbraPhLrAg=;
        b=ih5vssL02L5TJGe1puUEuS45ApxJCkgWpDrdKKwo3ZhoBbYGXma9Tcze0iLwiCCvNCk8bs
        pXMp8PDBrRVQ42l3FGgG0ubSfIYJ5vfbLsQ03YGwTK0qxuBGqeQZm6KqoV/Eeyf/NpOjGH
        QqEr6HClriLceSw5QvZiRnq1tbEuxQgQTqaKBYa/Wg2Ezcbx/j3fBBefFya2K2K8CavadV
        pINOeZdxhvO24skOBdaNHxipxHZ76Mh6CcpyC6gD3Nd4V5dLXTOQU8V8+wjFS3ADd6w+63
        mvrTACxsxC1AwoqJg6aBjJ2dtYek6WbP4X2cVd3yK1mqKN1/X0aNdCDMZUCEaw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND net-next v4 2/3] net: dsa: rzn1-a5psw: add support for .port_bridge_flags
Date:   Tue, 14 Mar 2023 17:36:50 +0100
Message-Id: <20230314163651.242259-3-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314163651.242259-1-clement.leger@bootlin.com>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running vlan test (bridge_vlan_aware/unaware.sh), there were some
failure due to the lack .port_bridge_flag function to disable port
flooding. Implement this operation for BR_LEARNING, BR_FLOOD,
BR_MCAST_FLOOD and BR_BCAST_FLOOD.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/rzn1_a5psw.c | 45 ++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 7dcca15e0b11..5059b2814cdd 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -342,6 +342,49 @@ static void a5psw_port_bridge_leave(struct dsa_switch *ds, int port,
 		a5psw->br_dev = NULL;
 }
 
+static int a5psw_port_pre_bridge_flags(struct dsa_switch *ds, int port,
+				       struct switchdev_brport_flags flags,
+				       struct netlink_ext_ack *extack)
+{
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_BCAST_FLOOD))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int
+a5psw_port_bridge_flags(struct dsa_switch *ds, int port,
+			struct switchdev_brport_flags flags,
+			struct netlink_ext_ack *extack)
+{
+	struct a5psw *a5psw = ds->priv;
+	u32 val;
+
+	if (flags.mask & BR_LEARNING) {
+		val = flags.val & BR_LEARNING ? 0 : A5PSW_INPUT_LEARN_DIS(port);
+		a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN,
+			      A5PSW_INPUT_LEARN_DIS(port), val);
+	}
+
+	if (flags.mask & BR_FLOOD) {
+		val = flags.val & BR_FLOOD ? BIT(port) : 0;
+		a5psw_reg_rmw(a5psw, A5PSW_UCAST_DEF_MASK, BIT(port), val);
+	}
+
+	if (flags.mask & BR_MCAST_FLOOD) {
+		val = flags.val & BR_MCAST_FLOOD ? BIT(port) : 0;
+		a5psw_reg_rmw(a5psw, A5PSW_MCAST_DEF_MASK, BIT(port), val);
+	}
+
+	if (flags.mask & BR_BCAST_FLOOD) {
+		val = flags.val & BR_BCAST_FLOOD ? BIT(port) : 0;
+		a5psw_reg_rmw(a5psw, A5PSW_BCAST_DEF_MASK, BIT(port), val);
+	}
+
+	return 0;
+}
+
 static void a5psw_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
 	u32 mask = A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(port);
@@ -754,6 +797,8 @@ static const struct dsa_switch_ops a5psw_switch_ops = {
 	.set_ageing_time = a5psw_set_ageing_time,
 	.port_bridge_join = a5psw_port_bridge_join,
 	.port_bridge_leave = a5psw_port_bridge_leave,
+	.port_pre_bridge_flags = a5psw_port_pre_bridge_flags,
+	.port_bridge_flags = a5psw_port_bridge_flags,
 	.port_stp_state_set = a5psw_port_stp_state_set,
 	.port_fast_age = a5psw_port_fast_age,
 	.port_fdb_add = a5psw_port_fdb_add,
-- 
2.39.0

