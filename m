Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DE568F2F7
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjBHQQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjBHQQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:16:13 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ED34ABD3;
        Wed,  8 Feb 2023 08:16:11 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6A561C0015;
        Wed,  8 Feb 2023 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675872970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yID+HSZHZsFysNyH5E4J8FFNrJg4SULKzIRkEIsJkjo=;
        b=V0dyJ6xV95G4v8DK1kLp+o+f4nrm7+1Ri1yludU30jCCpU7AmInKwuhgiSbei+ynruqHfS
        x/fz5NFnRVJ4MT3OkJqw6h8sIuK6vMvvhOH4AJEOiKTcSumtnYlWYFyLR97SpbKj1kgxps
        Osu8Hvssd/K6RwN/c+oZKMKuQ9Rz+fs5L+NTXbwNEuJ872Y5QB28Im8mjNnu9MWu8UNQ/y
        no+h+GPc8nTy+9khqz8Y5lNQ7Rim+PFtvL2BftcekYVd6lGEUq1zKwblLqYligRy9QA5vb
        UlImIJoEv702TC1FC+gFLbX94PURE5Xvp3toAaLFDjhouANHzmyhl/MEqFma9Q==
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
Subject: [PATCH net-next v3 1/3] net: dsa: rzn1-a5psw: use a5psw_reg_rmw() to modify flooding resolution
Date:   Wed,  8 Feb 2023 17:17:47 +0100
Message-Id: <20230208161749.331965-2-clement.leger@bootlin.com>
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

.port_bridge_flags will be added and allows to modify the flood mask
independently for each port. Keeping the existing bridged_ports write
in a5psw_flooding_set_resolution() would potentially messed up this.
Use a read-modify-write to set that value and move bridged_ports
handling in bridge_port_join/leave.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/dsa/rzn1_a5psw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 919027cf2012..8b7d4a371f8b 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -299,13 +299,9 @@ static void a5psw_flooding_set_resolution(struct a5psw *a5psw, int port,
 			A5PSW_MCAST_DEF_MASK};
 	int i;
 
-	if (set)
-		a5psw->bridged_ports |= BIT(port);
-	else
-		a5psw->bridged_ports &= ~BIT(port);
-
 	for (i = 0; i < ARRAY_SIZE(offsets); i++)
-		a5psw_reg_writel(a5psw, offsets[i], a5psw->bridged_ports);
+		a5psw_reg_rmw(a5psw, offsets[i], BIT(port),
+			      set ? BIT(port) : 0);
 }
 
 static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
@@ -326,6 +322,8 @@ static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
 	a5psw_flooding_set_resolution(a5psw, port, true);
 	a5psw_port_mgmtfwd_set(a5psw, port, false);
 
+	a5psw->bridged_ports |= BIT(port);
+
 	return 0;
 }
 
@@ -334,6 +332,8 @@ static void a5psw_port_bridge_leave(struct dsa_switch *ds, int port,
 {
 	struct a5psw *a5psw = ds->priv;
 
+	a5psw->bridged_ports &= ~BIT(port);
+
 	a5psw_flooding_set_resolution(a5psw, port, false);
 	a5psw_port_mgmtfwd_set(a5psw, port, true);
 
-- 
2.39.0

