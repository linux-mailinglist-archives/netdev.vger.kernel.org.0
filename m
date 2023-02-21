Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0712A69DCDE
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbjBUJZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233933AbjBUJZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:25:18 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B08624483;
        Tue, 21 Feb 2023 01:25:01 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 235F4C0013;
        Tue, 21 Feb 2023 09:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676971499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eGYKzuFmpRY1YTOUdj3DCQXT7u9J0lqvKoXvHWMd1So=;
        b=gMUpSYZw7rzrHNlojOK+W05+YcxBuna4BHIRe/OOSoStfcGyvl3OVoVCXwqNyQidARYBpc
        4iKc5GUxs4/Ba+ijC4KlOdUzWh8KsPQ8Yg8J1QmUK3UilM+I+nNfie/tEK2XMjlCKsA85y
        OnMOD3EzysZWa/vBNDlIZAnQfyiOesJzHdf1LfBJc6AO/jZVJUro6a0rFjXJX/+JgpHrTU
        /9uloWbhoPlcXRqVKHgK/fo4EZzM3l3QjPyMWwoAA7RKrP0yZ3qeVMiVdvrSRERHDrEwvK
        AWAt0C44Y0UdwZkOPGCSJQe5Xw7oQ7lFrvWm+MwjcWVSJDG5aWszTilgqguQGg==
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
Subject: [PATCH net-next v4 1/3] net: dsa: rzn1-a5psw: use a5psw_reg_rmw() to modify flooding resolution
Date:   Tue, 21 Feb 2023 10:26:24 +0100
Message-Id: <20230221092626.57019-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230221092626.57019-1-clement.leger@bootlin.com>
References: <20230221092626.57019-1-clement.leger@bootlin.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/rzn1_a5psw.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 919027cf2012..7dcca15e0b11 100644
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
 
@@ -945,6 +945,8 @@ static int a5psw_probe(struct platform_device *pdev)
 	if (IS_ERR(a5psw->base))
 		return PTR_ERR(a5psw->base);
 
+	a5psw->bridged_ports = BIT(A5PSW_CPU_PORT);
+
 	ret = a5psw_pcs_get(a5psw);
 	if (ret)
 		return ret;
-- 
2.39.0

