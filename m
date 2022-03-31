Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB004ED6CF
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbiCaJ3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiCaJ26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:28:58 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644C71FE54A;
        Thu, 31 Mar 2022 02:27:11 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AC3EAE000F;
        Thu, 31 Mar 2022 09:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BuDSDO88o7atqIGVoL9C6aHASrXbNomtgMOGVQ4YA10=;
        b=mMLR39R09x84Dw/csEYTSKv3YuLZaAyi0yFRHTEWxtBobiMdoNEJ04YeiDEIL4Tutvd39P
        hiRVP6TM0TYZ/N3616CQ2tTSI/4Y/UhtozuuYnuDd0gYQQI6DGsROc6t+WjijCq8a8bmpv
        g4WbtFNVsDWd0Xit8n/pYwozGOWyLMI+kq7dn9Prm2E4IXScwG0ZJVYB0d6Z8gynh/kymV
        6sG5HBxb5rhR1RKEXpQpKK30Qmh8dFlgFeuQYWAbDUf2SdZeRx/pN+OIxJzOQgAhicLYzF
        c1bpd5CRqhuc+XuEVBDfBIjwS14URCZzWe/EAjPyd8ux6W73fXQJVru4xFY4Mg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [RFC PATCH net-next v2 07/11] net: mdio: fwnode: avoid calling of_* functions with non OF nodes
Date:   Thu, 31 Mar 2022 11:25:29 +0200
Message-Id: <20220331092533.348626-8-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331092533.348626-1-clement.leger@bootlin.com>
References: <20220331092533.348626-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this check, of_parse_phandle_with_fixed_args() will be called
with whatever the type of the node. Use !is_of_node() which will work
for all node types supported by the fwnode API (ACPI, software nodes).

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/fwnode_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 319cccd0edeb..26aeb248e3b9 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -23,7 +23,7 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 	struct of_phandle_args arg;
 	int err;
 
-	if (is_acpi_node(fwnode))
+	if (!is_of_node(fwnode))
 		return NULL;
 
 	err = of_parse_phandle_with_fixed_args(to_of_node(fwnode),
-- 
2.34.1

