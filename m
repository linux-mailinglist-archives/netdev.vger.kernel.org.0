Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A214F8AF0
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbiDGWw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbiDGWwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:52:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366A65D5E5
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 15:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dnsyPuqUCUJQqXaCYxGO9hAQ0PQIThoStTD+cfT/Sfk=; b=XluCgE1TKQMV0v8RnPFVkYL0SA
        o6TT9ohPsXeosbCf+MuQBrMsmiQ6o3csfgE8ARBLflSfv4MDh3IiPqX5aTfHBqnwThCvp4haGA8pm
        0jgdsHR3eqtEnk32a/BbZaHdyCG3HbCd5NkGvv98Vh6476TTRyfct9JvnY6/g+M5AAdc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncaxk-00EjHp-1a; Fri, 08 Apr 2022 00:50:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v0 RFC RFT net-next 5/5] net: pcs: pcs-xpcs: Convert to mdiobus_c45_read
Date:   Fri,  8 Apr 2022 00:50:23 +0200
Message-Id: <20220407225023.3510609-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407225023.3510609-1-andrew@lunn.ch>
References: <20220407225023.3510609-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop using the helpers to construct a special mdio address which
indicates C45. Instead use the C45 accessors, which will call the
busses C45 specific read/write API.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/pcs/pcs-xpcs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 61418d4dc0cd..4cfd05c15aee 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -175,20 +175,18 @@ static bool __xpcs_linkmode_supported(const struct xpcs_compat *compat,
 
 int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg)
 {
-	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 	struct mii_bus *bus = xpcs->mdiodev->bus;
 	int addr = xpcs->mdiodev->addr;
 
-	return mdiobus_read(bus, addr, reg_addr);
+	return mdiobus_c45_read(bus, addr, dev, reg);
 }
 
 int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
 {
-	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 	struct mii_bus *bus = xpcs->mdiodev->bus;
 	int addr = xpcs->mdiodev->addr;
 
-	return mdiobus_write(bus, addr, reg_addr, val);
+	return mdiobus_c45_write(bus, addr, dev, reg, val);
 }
 
 static int xpcs_read_vendor(struct dw_xpcs *xpcs, int dev, u32 reg)
-- 
2.35.1

