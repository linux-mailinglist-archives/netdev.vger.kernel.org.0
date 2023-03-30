Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A338E6CFE5E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjC3IeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjC3Idt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:33:49 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1120B3;
        Thu, 30 Mar 2023 01:33:46 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 42666C0009;
        Thu, 30 Mar 2023 08:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680165225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WwAhyV1Sj5KBBfVDCAdRTQpNDnZo2GvHv0Rky3dXMiQ=;
        b=FvKfGfSZ6CE043eolJcSg7z6fIgqiQ5Fle3qnqfqGZ8Jy2NG2lvc0m9kRNOiabUtHmpz+I
        qVQO7iL5hQgf5eLue/mh36wbIRDyD5+fSG9qDLr6FOKTkd4jgcjVor+XbxH1M14b2sBo+Z
        E/nbVZ/vi64gxVcGvKXKRKBhyGeQEZNlmHZCvGvPVmwYlPVaCzPC7iFsvNIyOpPtu8LdWU
        T+HCrZiRdahsgfyHNtPy5oPLTNRfh3Eww2CsZFbai2IiqyYxVb3oZicR6Aa1+s6tvd9MXp
        UrwsWF/IP5nAcw14KGSqaa0MIOrxhdXdF9JALgijw/w2dTh8J5psh/VqiYpxWw==
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
Subject: [PATCH net-next 2/2] net: dsa: rzn1-a5psw: disable learning for standalone ports
Date:   Thu, 30 Mar 2023 10:34:08 +0200
Message-Id: <20230330083408.63136-3-clement.leger@bootlin.com>
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

When port are in standalone mode, they should have learning disabled to
avoid adding new entries in the MAC lookup table which might be used by
other bridge ports to forward packets. While adding that, also make sure
learning is enabled for CPU port.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/dsa/rzn1_a5psw.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index bbc1424ed416..3e5062ab0928 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -336,6 +336,14 @@ static void a5psw_flooding_set_resolution(struct a5psw *a5psw, int port,
 		a5psw_reg_writel(a5psw, offsets[i], a5psw->bridged_ports);
 }
 
+static void a5psw_port_set_standalone(struct a5psw *a5psw, int port,
+				      bool standalone)
+{
+	a5psw_port_learning_set(a5psw, port, !standalone, false);
+	a5psw_flooding_set_resolution(a5psw, port, !standalone);
+	a5psw_port_mgmtfwd_set(a5psw, port, standalone);
+}
+
 static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
 				  struct dsa_bridge bridge,
 				  bool *tx_fwd_offload,
@@ -351,8 +359,7 @@ static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
 	}
 
 	a5psw->br_dev = bridge.dev;
-	a5psw_flooding_set_resolution(a5psw, port, true);
-	a5psw_port_mgmtfwd_set(a5psw, port, false);
+	a5psw_port_set_standalone(a5psw, port, false);
 
 	return 0;
 }
@@ -362,8 +369,7 @@ static void a5psw_port_bridge_leave(struct dsa_switch *ds, int port,
 {
 	struct a5psw *a5psw = ds->priv;
 
-	a5psw_flooding_set_resolution(a5psw, port, false);
-	a5psw_port_mgmtfwd_set(a5psw, port, true);
+	a5psw_port_set_standalone(a5psw, port, true);
 
 	/* No more ports bridged */
 	if (a5psw->bridged_ports == BIT(A5PSW_CPU_PORT))
@@ -755,13 +761,15 @@ static int a5psw_setup(struct dsa_switch *ds)
 		if (dsa_port_is_unused(dp))
 			continue;
 
-		/* Enable egress flooding for CPU port */
-		if (dsa_port_is_cpu(dp))
+		/* Enable egress flooding and learning for CPU port */
+		if (dsa_port_is_cpu(dp)) {
 			a5psw_flooding_set_resolution(a5psw, port, true);
+			a5psw_port_learning_set(a5psw, port, true, false);
+		}
 
-		/* Enable management forward only for user ports */
+		/* Enable standalone mode for user ports */
 		if (dsa_port_is_user(dp))
-			a5psw_port_mgmtfwd_set(a5psw, port, true);
+			a5psw_port_set_standalone(a5psw, port, true);
 	}
 
 	return 0;
-- 
2.39.2

