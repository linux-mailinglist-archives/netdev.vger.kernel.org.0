Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E6B52D791
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240972AbiESPch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbiESPcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:32:35 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7795D5D1;
        Thu, 19 May 2022 08:32:33 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BA994FF806;
        Thu, 19 May 2022 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652974352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c4V1uXX41ZnZQAb1eTaJsSm2ERttNLSUtAfNccyflg8=;
        b=igjUleMM2n2rK8XQiJxv2a4cisd7PykBdg1whhtx5+AtUAl6tL7PRPiYlgZF9ZK/3xBtO0
        8Vh38gwNiGPlvX00rB8sMC4/3shf9edxEGmHibzA84gznwM+j9S5FvW/K2176n6/pzxEmF
        LdenHjHDMIvygp5kUtacQ9aHYO10CdMcTZjxq9NUSDMUX1ZqAeLe+FpLk6kM9hQJ+9/G6d
        KJ2fxCqE5vs7qvj3V7A3xL8s6YPDLNPEbeMssgU/Ymku8hVEQDPhyHn1BnoPH2ikYftyeN
        JdZeFgnLC7/kuWc2tu/ZbGlD1kkuCMnow1hXd+vYY3I7zdfWS1QrT1enJYu7vg==
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
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v5 01/13] net: dsa: allow port_bridge_join() to override extack message
Date:   Thu, 19 May 2022 17:30:55 +0200
Message-Id: <20220519153107.696864-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220519153107.696864-1-clement.leger@bootlin.com>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
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
---
 net/dsa/slave.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 801a5d445833..291197859cea 100644
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
2.36.0

