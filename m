Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A515516C0
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 13:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbiFTLKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 07:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241245AbiFTLJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 07:09:52 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07062B39;
        Mon, 20 Jun 2022 04:09:50 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1E98E240003;
        Mon, 20 Jun 2022 11:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655723389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tExyiPeImu1Nxom9h3UVjRKBgN09NvUrwAIoO3Vi5fo=;
        b=M+9/XAwaoppX9CeOh3j11B3QaCPSuD4yk02CiY7WbgioC9z/M3ODt2OQWqH/En/NohY4CN
        NH8ZojulZUtLP3IXYgqOFbjzFss8wxpc60yGgnPUit0FtclSgOzfQ+DIZyrNR7HsDNQHqs
        5bEbh6bE1iI857N/HOF6yn+dBMQQooFhMrlXiXOH+vfLRosAUvWdvm5L/R37BWEtXAe72Y
        A7nZ6cMdQUODzdMWl6PM2h1svJBazXp5jYDf796GhPximki7RGRThz2JIZbws2EvrYPqFw
        2XAFbubxIhhIeybk8Sw+HQzGt0zyFUqMPkbhE9xQuRmoA+d4IX/U2yPFwykrcw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v8 01/16] net: dsa: allow port_bridge_join() to override extack message
Date:   Mon, 20 Jun 2022 13:08:31 +0200
Message-Id: <20220620110846.374787-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620110846.374787-1-clement.leger@bootlin.com>
References: <20220620110846.374787-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some drivers might report that they are unable to bridge ports by
returning -EOPNOTSUPP, but still wants to override extack message.
In order to do so, in dsa_slave_changeupper(), if port_bridge_join()
returns -EOPNOTSUPP, check if extack message is set and if so, do not
override it.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/slave.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2e1ac638d135..509b98dd9954 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2460,8 +2460,9 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
 			if (err == -EOPNOTSUPP) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Offloading not supported");
+				if (!extack->_msg)
+					NL_SET_ERR_MSG_MOD(extack,
+							   "Offloading not supported");
 				err = 0;
 			}
 			err = notifier_from_errno(err);
-- 
2.36.1

