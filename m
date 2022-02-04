Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD76E4A9399
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 06:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241248AbiBDF3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 00:29:23 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:58988 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiBDF3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 00:29:23 -0500
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 312308030867;
        Fri,  4 Feb 2022 08:29:20 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru 312308030867
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1643952561;
        bh=W1y8IgscUyS5mr3BXUf7B2HI0tpLjvtZOLBXU1GAwkA=;
        h=From:To:CC:Subject:Date:From;
        b=ImXGmw4CzlrDKAw/n4UoiR7hytq1QmSAqIge/VnnfLHY01xTRhgZrNeSdW1/swgGQ
         IV8OlE+0Ew+zqJnVZPhzKPHfhgM+s0LZC/9Hmfjf2+aFJTflw4HKbwaP1ewOHqyVNQ
         9Hqv3AbUdQm5MHMhvVc2RYvi2YglxjsugRw5N9xo=
Received: from MAIL.baikal.int (192.168.51.25) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 4 Feb 2022 08:29:11 +0300
Received: from MAIL.baikal.int ([::1]) by MAIL.baikal.int ([::1]) with mapi id
 15.00.1395.000; Fri, 4 Feb 2022 08:29:11 +0300
From:   <Pavel.Parkhomenko@baikalelectronics.ru>
To:     <michael@stapelberg.de>, <afleming@gmail.com>,
        <f.fainelli@gmail.com>, <andrew@lunn.ch>
CC:     <Alexey.Malahov@baikalelectronics.ru>,
        <Sergey.Semin@baikalelectronics.ru>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: phy: marvell: Fix RGMII Tx/Rx delays setting in
 88e1121-compatible PHYs
Thread-Topic: [PATCH] net: phy: marvell: Fix RGMII Tx/Rx delays setting in
 88e1121-compatible PHYs
Thread-Index: AQHYGYgjpwnysZLJNUG22PH4uN5jng==
Date:   Fri, 4 Feb 2022 05:29:11 +0000
Message-ID: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="koi8-r"
Content-ID: <FBC999718B824D4C9AA76B71AE2B5782@baikalelectronics.ru>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is mandatory for a software to issue a reset upon modifying RGMII
Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
Specific Control register 2 (page 2, register 21) otherwise the changes
won't be perceived by the PHY (the same is applicable for a lot of other
registers). Not setting the RGMII delays on the platforms that imply
it's being done on the PHY side will consequently cause the traffic loss.
We discovered that the denoted soft-reset is missing in the
m88e1121_config_aneg() method for the case if the RGMII delays are
modified but the MDIx polarity isn't changed or the auto-negotiation is
left enabled, thus causing the traffic loss on our platform with Marvell
Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
method.

Fixes: d6ab93364734 ("net: phy: marvell: Avoid unnecessary soft reset")
Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Reviewed-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
 drivers/net/phy/marvell.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4fcfca4e1702..a4f685927a64 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -551,9 +551,9 @@ static int m88e1121_config_aneg_rgmii_delays(struct
phy_device *phydev)
 	else
 		mscr =3D 0;
=20
-	return phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
-				MII_88E1121_PHY_MSCR_REG,
-				MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
+	return phy_modify_paged_changed(phydev, MII_MARVELL_MSCR_PAGE,
+					MII_88E1121_PHY_MSCR_REG,
+					MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
 }
=20
 static int m88e1121_config_aneg(struct phy_device *phydev)
@@ -567,11 +567,13 @@ static int m88e1121_config_aneg(struct phy_device *ph=
ydev)
 			return err;
 	}
=20
+	changed =3D err;
+
 	err =3D marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
=20
-	changed =3D err;
+	changed |=3D err;
=20
 	err =3D genphy_config_aneg(phydev);
 	if (err < 0)
--=20
2.34.1


