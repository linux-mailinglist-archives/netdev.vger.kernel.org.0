Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAD568F2FA
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjBHQQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbjBHQQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:16:15 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188134C6D7;
        Wed,  8 Feb 2023 08:16:13 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9D82CC0003;
        Wed,  8 Feb 2023 16:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675872972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b9a0BUOmJvO4NqAYLgTOEStjmY5WJ4dpiZkzCdgTveY=;
        b=BAzdbG4INcRb0mvSn9AhLsD7dI6qI2r5u6n35QdYtZMp3cy9q4rsd1xVlnt23xCxuZNkZg
        aSXgCXm5MB+PU7YVlSghVuNGtzkP3jJFGzVPYI7iXboJsRSlUQcIHdQUboEXBJJGmfG690
        uylXR7KhxzgOmnCy7YN+ZA9xTr7PYUJb7A4DKrjGpShZlpKPr5p9XMzRIqzQ3LBAC0U5K8
        BavMYRNOhIY9XJnAhZFKa8lkWyPXCBL3mKwAKLiPCp+pFKWHmj70j636lklG8IZD/zlwXS
        gyj+sFTVednbBBkDzEEIZa+bGT8pr7zS39h7FE/NNDZ7K6Pf4erkkRY9F05Ksg==
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
Subject: [PATCH net-next v3 2/3] net: dsa: rzn1-a5psw: add support for .port_bridge_flags
Date:   Wed,  8 Feb 2023 17:17:48 +0100
Message-Id: <20230208161749.331965-3-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230208161749.331965-1-clement.leger@bootlin.com>
References: <20230208161749.331965-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/net/dsa/rzn1_a5psw.c | 45 ++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 8b7d4a371f8b..0ce3948952db 100644
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

