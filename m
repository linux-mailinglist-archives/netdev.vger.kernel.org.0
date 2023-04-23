Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27046EC189
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 20:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjDWSDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 14:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDWSDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 14:03:49 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C93410E5;
        Sun, 23 Apr 2023 11:03:48 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pqe3p-0003GQ-1l;
        Sun, 23 Apr 2023 20:03:41 +0200
Date:   Sun, 23 Apr 2023 19:01:55 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chen Minqiang <ptpt52@gmail.com>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        Yevhen Kolomeiko <jarvis2709@gmail.com>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [RFC PATCH net-next 5/8] net: phy: realtek: use phy_read_paged
 instead of open coding
Message-ID: <ZEVyk71pBcQZ_NH_@makrotopia.org>
References: <cover.1682163424.git.daniel@makrotopia.org>
 <85eb0791bd614ccfdeccdc6fe39be55e602c521c.1682163424.git.daniel@makrotopia.org>
 <d7eaf73b-282a-df7d-d9a5-530e431701a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7eaf73b-282a-df7d-d9a5-530e431701a1@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 05:11:57PM +0200, Heiner Kallweit wrote:
> On 22.04.2023 13:48, Daniel Golle wrote:
> > Instead of open coding a paged read, use the phy_read_paged function
> > in rtlgen_supports_2_5gbps.
> > 
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> >  drivers/net/phy/realtek.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > index f97b5e49fae58..62fb965b6d338 100644
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -735,9 +735,7 @@ static bool rtlgen_supports_2_5gbps(struct phy_device *phydev)
> >  {
> >  	int val;
> >  
> > -	phy_write(phydev, RTL821x_PAGE_SELECT, 0xa61);
> > -	val = phy_read(phydev, 0x13);
> > -	phy_write(phydev, RTL821x_PAGE_SELECT, 0);
> > +	val = phy_read_paged(phydev, 0xa61, 0x13);
> >  
> >  	return val >= 0 && val & RTL_SUPPORTS_2500FULL;
> >  }
> 
> I remember I had a reason to open-code it, it took me some minutes
> to recall it.
> phy_read_paged() calls __phy_read_page() that relies on phydev->drv
> being set. phydev->drv is set in phy_probe(). And probing is done
> after matching. __phy_read_paged() should have given you a warning.
> Did you test this patch? If yes and you didn't get the warning,
> then apparently I miss something.
>

Yes, you are right, this change was a bit too naive and causes a
NULL pointer dereference e.g. for the r8169 driver which also uses
the RealTek Ethernet PHY driver.
My main concern and original motivation was the lack of mutex protection
for the paged read operation. I suggest to rather make this change
instead:

From 4dd2cc9b91ecb25f278a2c55e07e6455e9000e6b Mon Sep 17 00:00:00 2001
From: Daniel Golle <daniel@makrotopia.org>
Date: Sun, 23 Apr 2023 18:47:45 +0100
Subject: [PATCH] net: phy: realtek: make sure paged read is protected by mutex

As we cannot rely on phy_read_paged function before the PHY is
identified, the paged read in rtlgen_supports_2_5gbps needs to be open
coded as it is being called by the match_phy_device function, ie. before
.read_page and .write_page have been populated.

Make sure it is also protected by the MDIO bus mutex and use
rtl821x_write_page instead of 3 individually locked MDIO bus operations.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/phy/realtek.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index f97b5e49fae5..c27ec4e99fc2 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -735,9 +735,11 @@ static bool rtlgen_supports_2_5gbps(struct phy_device *phydev)
 {
 	int val;
 
-	phy_write(phydev, RTL821x_PAGE_SELECT, 0xa61);
-	val = phy_read(phydev, 0x13);
-	phy_write(phydev, RTL821x_PAGE_SELECT, 0);
+	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	rtl821x_write_page(phydev, 0xa61);
+	val = __phy_read(phydev, 0x13);
+	rtl821x_write_page(phydev, 0);
+	mutex_unlock(&phydev->mdio.bus->mdio_lock);
 
 	return val >= 0 && val & RTL_SUPPORTS_2500FULL;
 }
-- 
2.40.0

