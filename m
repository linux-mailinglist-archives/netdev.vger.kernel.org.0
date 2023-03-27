Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DACD6CAB59
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjC0RDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjC0RCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D70E421C
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/22iWqTIYLeLggxzZvKCNuSbfp99a4dJbsfnGzymmLk=; b=k//MiLs7alVnsVepYiI0beva16
        YZmZl2zgbjSOfyDa7/WYIjGtLnf6MSSLDeF2O/rWAUibnpLcfu+7xxelt92Wu0fSlQsEZaPcUUfxW
        YDppcZUqqKJ/u79e9z+2m4fpSsXgix/lprVnjpYbTDTp+PMQNANxEoYCruJ8MYr5n8Jk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEV-008XsG-4y; Mon, 27 Mar 2023 19:02:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 14/23] net: dsa: mt7530: Swap to using phydev->eee_active
Date:   Mon, 27 Mar 2023 19:01:52 +0200
Message-Id: <20230327170201.2036708-15-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327170201.2036708-1-andrew@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than calling phy_init_eee() retrieve the same information from
within the phydev structure.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6c89026ec966..40b86999f543 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2754,7 +2754,7 @@ static void mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			mcr |= PMCR_RX_FC_EN;
 	}
 
-	if (mode == MLO_AN_PHY && phydev && phy_init_eee(phydev, false) >= 0) {
+	if (mode == MLO_AN_PHY && phydev && phydev->eee_active) {
 		switch (speed) {
 		case SPEED_1000:
 			mcr |= PMCR_FORCE_EEE1G;
-- 
2.39.2

