Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6334E7DCD
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbiCYVhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiCYVhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:37:05 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7024D240;
        Fri, 25 Mar 2022 14:35:28 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E4167223F6;
        Fri, 25 Mar 2022 22:35:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648244127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c+IHVZ2wDiBsBATZdF0ZEbYHHJLaJMi9OlfJjiVvU+c=;
        b=UWUS3cDhZ5byMLen9kWjBe53/FNH0m9x+5iM8NOIo3CEG1Us5KSxUgHChlsdgTxTBqKBX+
        V5n7iprNTPUTHJtLQOJ8Sq8Oo39cfQ1ZYAr/vCeJdWo/3rxNw2kYDDE/WjXx6Bu8vM2GbQ
        DDYWOp5a3VGj8LjwZf6YtbJrWFn1fMQ=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 4/8] net: phy: add error handling for __phy_{read,write}_mmd
Date:   Fri, 25 Mar 2022 22:35:14 +0100
Message-Id: <20220325213518.2668832-5-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325213518.2668832-1-michael@walle.cc>
References: <20220325213518.2668832-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that __phy_mmd_indirect() returns an error code, check it and
additionally check the error code of the last read or write access.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/phy-core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index dd9b6b64757d..2a300c58d1e5 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -493,8 +493,11 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
 	} else {
 		struct mii_bus *bus = phydev->mdio.bus;
 		int phy_addr = phydev->mdio.addr;
+		int ret;
 
-		__phy_mmd_indirect(bus, phy_addr, devad, regnum);
+		ret = __phy_mmd_indirect(bus, phy_addr, devad, regnum);
+		if (ret)
+			return ret;
 
 		/* Read the content of the MMD's selected register */
 		val = __mdiobus_read(bus, phy_addr, MII_MMD_DATA);
@@ -550,12 +553,12 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 		struct mii_bus *bus = phydev->mdio.bus;
 		int phy_addr = phydev->mdio.addr;
 
-		__phy_mmd_indirect(bus, phy_addr, devad, regnum);
+		ret = __phy_mmd_indirect(bus, phy_addr, devad, regnum);
+		if (ret)
+			return ret;
 
 		/* Write the data into MMD's selected register */
-		__mdiobus_write(bus, phy_addr, MII_MMD_DATA, val);
-
-		ret = 0;
+		ret = __mdiobus_write(bus, phy_addr, MII_MMD_DATA, val);
 	}
 	return ret;
 }
-- 
2.30.2

