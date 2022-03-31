Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CA44ED6D5
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiCaJ3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiCaJ27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:28:59 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712DF1FD2DB;
        Thu, 31 Mar 2022 02:27:12 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1E212E001A;
        Thu, 31 Mar 2022 09:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SuDs+4vm0hGLpYE7vR9fD1uE2I+kfm+ItNZWNP+AIFM=;
        b=gTqBYSYJcAzspdtKr8G33BSeqHeP89ljEdumg34xI3dyDS/qQgncWyrtKse+NryWWbk4XP
        uZ6e06HwirwjZneoE53cdfKsbyjzDMsWDTMlygdWVQsQEgm6Do+D/8L1fpn/YMJepwL67D
        EK3dauZWeZF//HBkccGzm3+FDPCl5NYefIUWfrf2r3kZuGzuqPAxHYN/Lrg/4p4hQxv6ip
        H6xsfyvD5RIDh0wue+6ZHD4Wx9IW0uRWfV5POqPttzAQyn7glEpE9PkdQH0YMMFaRWGXxX
        pGaVPRRNfenJ8ceTxizNOmj3/m6HBi3Ui410Y5uAxNAd4i63qfav415sL0+5ww==
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
Subject: [RFC PATCH net-next v2 08/11] net: mdio: fwnode: allow phy device registration with non OF nodes
Date:   Thu, 31 Mar 2022 11:25:30 +0200
Message-Id: <20220331092533.348626-9-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331092533.348626-1-clement.leger@bootlin.com>
References: <20220331092533.348626-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using a software node, we also want to call
fwnode_mdiobus_phy_device_register() which support all nodes type.
Remove the is_of_node() check to allow that.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/fwnode_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 26aeb248e3b9..3aa599890e29 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -127,7 +127,7 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 			fwnode_handle_put(phy->mdio.dev.fwnode);
 			return rc;
 		}
-	} else if (is_of_node(child)) {
+	} else {
 		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
 		if (rc) {
 			unregister_mii_timestamper(mii_ts);
-- 
2.34.1

