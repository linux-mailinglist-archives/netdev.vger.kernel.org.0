Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2314A6B9BAD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjCNQfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCNQer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:34:47 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4065B414;
        Tue, 14 Mar 2023 09:34:31 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 31ED3100013;
        Tue, 14 Mar 2023 16:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678811669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eGYKzuFmpRY1YTOUdj3DCQXT7u9J0lqvKoXvHWMd1So=;
        b=BF/ORxZT5tDRVa1ahD8A4qRcYnLwhr6J+CcX2RHFnEYYHyBFUV+EbVELphVni05XqadlCT
        yMzD8Wem7NcrHJ3PghDfQC0pQdUeRatKfBZXVrkqzkOBNDPxCUUn5C7zGnxHgqGsRm15h3
        97g7JVN+I8Z1iL8dNlKxvtnuTe6VsihMSx+WXgBgUd3vnNEv7Bhsy8Uglh2lL0unXUYS7C
        4LdA9jhLEF0FsDVddG5BDO1JV/TFpXpt5HsaPnd0MKG54uzEDsq0vg/3hTGGdvFPjF/Chj
        IW+j65sHB1ZyiemqaD1V8QXbaFJvuXEU1QUdYTfigSS4rNPIy01zye1u624jWA==
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
Subject: [PATCH RESEND net-next v4 1/3] net: dsa: rzn1-a5psw: use a5psw_reg_rmw() to modify flooding resolution
Date:   Tue, 14 Mar 2023 17:36:49 +0100
Message-Id: <20230314163651.242259-2-clement.leger@bootlin.com>
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

