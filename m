Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1924E7CE3
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbiCYTtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiCYTs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:48:28 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7B01606BD;
        Fri, 25 Mar 2022 12:31:47 -0700 (PDT)
Received: from relay6-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::226])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 6ACBCC8C3D;
        Fri, 25 Mar 2022 17:25:37 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A8AD5C000D;
        Fri, 25 Mar 2022 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648229041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s6zz4MlNUuY9SLiRYskNqpLK7uEvG3j4Z0nthKK5Qvs=;
        b=iLhIrkr6/rTclCABfUYcpeQXHaKmBZr4hto3uW0jBNSQlylTD7zrlj58LVk05dtRwid8SI
        cpc3uRzRA8BR0OHQgxEWv9c1NKyGdOE7L7/XX3pN5d3RN6bl2s2bStBXLK7+/Hy+IadJ0I
        su32KHl52iFIaIieCQGq1ruZvhF+TwuxR4p8TYvqJSrNTzyFBiHte14NswpCPQ+QSwuxDG
        bi0dvQi1BIeb0pEUQ08iAmORtZ96GKwl+sxfmJ77J8d0IXf5Q/+bPC0uiWIQ9Cetse3+8I
        lRMRZXc9c9Im70Q0cSj+OGXRiEWF2tSs8/l959Sy4FO6uF+XjKA/a4kEi+BEPQ==
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
Subject: [net-next 3/5] net: mdiobus: fwnode: avoid calling of_* functions with non OF nodes
Date:   Fri, 25 Mar 2022 18:22:32 +0100
Message-Id: <20220325172234.1259667-4-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325172234.1259667-1-clement.leger@bootlin.com>
References: <20220325172234.1259667-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
index f9ec3818041a..7f71c0700c55 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -22,7 +22,7 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 	struct of_phandle_args arg;
 	int err;
 
-	if (is_acpi_node(fwnode))
+	if (!is_of_node(fwnode))
 		return NULL;
 
 	err = of_parse_phandle_with_fixed_args(to_of_node(fwnode),
-- 
2.34.1

