Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1182EF519
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 16:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbhAHPr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 10:47:26 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:56915 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbhAHPrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 10:47:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610120845; x=1641656845;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=XOI7VV02G7ptnuV6kT+z9p2Fm7tajWtOqD2dPoXaQfI=;
  b=sWiDekv7af9rQmu7AY4um1eU39mr2i6gXOJmlDNpGvE5Es16wvKLs2j8
   yxV+CgmV8VfrWgTBo63rxLiGMTd7xvHuAZt/bmUgCvVOMZeaUllEIL8xt
   QUqrSNCGlhVjDKv4Si+kI0npMJ0tJBWWE/z/1YgR8QqzNU3ebjIXyFc9D
   YBlLpm63rtyzj4b55TusoZdbgE4lahIpbvEte1CbH8niGOADP1+dhvMAF
   F3G6QB9+mphbkUPEA4HpHO8QKJAj/c5ROCYEAszWQVz2wjoif/Wjf3Gey
   f794w2zVTfdqmSCwD7jSkbcU3UJbdOXzgtTI0yfJ7n/4ExW1yw+V+81ON
   A==;
IronPort-SDR: x+GsfsY9hpmce2LmnnJ5i2tm9yDIrkrik/KxEl3zi4XDcln4GQFx1rBt05OrR0MhUrcspQvjjv
 6/UjZS42Ojuq3ghwsuDbfKrmPxO56Rq4IzVd67IJTUMY1crlrAHeajUgnyWg6Rs4JmsRZaCDZ9
 qUfMVuVZ2xbbuCEXe9Mc9W83Wfr5ZeeUsTwn3BTZ2ZtoPcfO/7Y7vFD58YV+aCiX4cpq43c0Ni
 xAV8gA7y6YimlUvMPG8mmtaJ2XwwF1DvjGMZF8u3ZLkirH2SSRw45IUEDtPzgOmU3VSBWOmdri
 iuA=
X-IronPort-AV: E=Sophos;i="5.79,331,1602572400"; 
   d="scan'208";a="110314330"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jan 2021 08:46:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 8 Jan 2021 08:46:09 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 8 Jan 2021 08:46:05 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH] net: phy: micrel: reconfigure the phy on resume
Date:   Fri, 8 Jan 2021 17:45:54 +0200
Message-ID: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KSZ9131 is used in setups with SAMA7G5. SAMA7G5 supports a special
power saving mode (backup mode) that cuts the power for almost all
parts of the SoC. The rail powering the ethernet PHY is also cut off.
When resuming, in case the PHY has been configured on probe with
slew rate or DLL settings these needs to be restored thus call
driver's config_init() on resume.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/phy/micrel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 3fe552675dd2..52d3a0480158 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1077,7 +1077,7 @@ static int kszphy_resume(struct phy_device *phydev)
 	 */
 	usleep_range(1000, 2000);
 
-	ret = kszphy_config_reset(phydev);
+	ret = phydev->drv->config_init(phydev);
 	if (ret)
 		return ret;
 
-- 
2.7.4

