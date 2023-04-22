Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF956EB8F1
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 13:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjDVLuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 07:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjDVLt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 07:49:59 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9775272D;
        Sat, 22 Apr 2023 04:49:36 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pqBkE-00086c-2R;
        Sat, 22 Apr 2023 13:49:34 +0200
Date:   Sat, 22 Apr 2023 12:49:30 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Chen Minqiang <ptpt52@gmail.com>, Chukun Pan <amadeus@jmu.edu.cn>,
        Yevhen Kolomeiko <jarvis2709@gmail.com>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [RFC PATCH net-next 7/8] net: phy: realtek: check validity of 10GbE
 link-partner advertisement
Message-ID: <0c3e0e665945ecc5f248438f3231ed48f92764df.1682163424.git.daniel@makrotopia.org>
References: <cover.1682163424.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1682163424.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only use link-partner advertisement bits for 10GbE modes if they are
actually valid. Check LOCALOK and REMOTEOK bits and clear 10GbE modes
unless both of them are set.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/phy/realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 078f45447ddad..de73049037891 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -706,6 +706,10 @@ static int rtl822x_read_status(struct phy_device *phydev)
 		if (lpadv < 0)
 			return lpadv;
 
+		if (!(lpadv & MDIO_AN_10GBT_STAT_REMOK) ||
+		    !(lpadv & MDIO_AN_10GBT_STAT_LOCOK))
+			lpadv = 0;
+
 		mii_10gbt_stat_mod_linkmode_lpa_t(phydev->lp_advertising, lpadv);
 	}
 
-- 
2.40.0

