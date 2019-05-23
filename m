Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1B8273E1
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfEWBUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:20:48 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:16354
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbfEWBUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:20:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtrS7ZaWGF3HSzSz1MTGpRIeGSJU8vBOmHJ6j+BHJJU=;
 b=OI553NKkYKvixLDJWhQ5fwS4NFx2iibPwXQtc0T9QaYHtTmsYFDBl9rxo9RHCVhzuGlHJpd8xE2p33LY1b9U4enZg+SC7t1ZiEG620Jb3RZOMO3evmC/m99z28mH4YDE58BMgJnFd+oqztaaigxENa7Lsw1MTee3Ip2yO4E0AQA=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:20:38 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 01:20:38 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC PATCH net-next 2/9] net: phy: Guard against the presence of a
 netdev
Thread-Topic: [RFC PATCH net-next 2/9] net: phy: Guard against the presence of
 a netdev
Thread-Index: AQHVEQW66VSOZj2NTUKIRdrxG/7Xxw==
Date:   Thu, 23 May 2019 01:20:38 +0000
Message-ID: <20190523011958.14944-3-ioana.ciornei@nxp.com>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
In-Reply-To: <20190523011958.14944-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P18901CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::19) To VI1PR0402MB2800.eurprd04.prod.outlook.com
 (2603:10a6:800:b8::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [5.12.225.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b7071d8-e702-4c11-9a79-08d6df1cdd0a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB36775A66AF5D141A3656B5FDE0010@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(25786009)(6512007)(316002)(2201001)(26005)(186003)(86362001)(2501003)(1076003)(36756003)(71200400001)(256004)(71190400001)(5660300002)(4326008)(66066001)(6486002)(14444005)(5024004)(6436002)(3846002)(7736002)(305945005)(71446004)(99286004)(52116002)(50226002)(81156014)(8676002)(81166006)(8936002)(54906003)(110136005)(2906002)(6116002)(478600001)(68736007)(102836004)(76176011)(53936002)(486006)(2616005)(66446008)(6506007)(386003)(66946007)(73956011)(66556008)(44832011)(14454004)(476003)(11346002)(66476007)(64756008)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qIY4kxEHZMA6xNvW+d/e9czURj+8RM7jBTdNMX4N69nxxbydwIobVBM3MQBZJORrbE14DxZNkVw8lbpbDoeZURzYNXQMbzweZjbnVnJ9O7dKOQryNFrtn5tPd5/K074OSPhrrNfbylXbFsTOt2Bge1vKIHMUJ9oWFkD+WKjZdxIkAnMn/dbrREafDx4QWRspYLvYZEHB2a8rEDmoUY2hQZOFOQpFfos/SDr1YinGLixYtGmOVXj/L9exg8Y7B9yq3Z7A1YL0sLLo7KL/oq8QSmPB9mMTHzpvMt8RpDoMvTX6NNh2KJQbNKx4uyWmuipt/3veLu7JuiEt+pp6CnaG9UhAnHqQDWneMP8IQFJayHON0Hm01qlrQIcYqFFI6+GSRmCEYhZ/5McpOCsnkUyeFdRYv6YcqUEuncugZK6IEaE=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <1355E22E72533F46A2600ED7F6A88924@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7071d8-e702-4c11-9a79-08d6df1cdd0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:20:38.3644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A prerequisite for PHYLIB to work in the absence of a struct net_device
is to not access pointers to it.

Changes are needed in the following areas:

 - Printing: In some places netdev_err was replaced with phydev_err.

 - Incrementing reference count to the parent MDIO bus driver: If there
   is no net device, then the reference count should definitely be
   incremented since there is no chance that it was an Ethernet driver
   who registered the MDIO bus.

 - Sysfs links are not created in case there is no attached_dev.

 - No netif_carrier_off is done if there is no attached_dev.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/phy/phy_device.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5cb01b9db7b5..25cc7c33f8dd 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1138,6 +1138,9 @@ static void phy_sysfs_create_links(struct phy_device =
*phydev)
 	struct net_device *dev =3D phydev->attached_dev;
 	int err;
=20
+	if (!dev)
+		return;
+
 	err =3D sysfs_create_link(&phydev->mdio.dev.kobj, &dev->dev.kobj,
 				"attached_dev");
 	if (err)
@@ -1176,9 +1179,9 @@ static void phy_sysfs_create_links(struct phy_device =
*phydev)
 int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 		      u32 flags, phy_interface_t interface)
 {
-	struct module *ndev_owner =3D dev->dev.parent->driver->owner;
 	struct mii_bus *bus =3D phydev->mdio.bus;
 	struct device *d =3D &phydev->mdio.dev;
+	struct module *ndev_owner =3D NULL;
 	bool using_genphy =3D false;
 	int err;
=20
@@ -1187,8 +1190,10 @@ int phy_attach_direct(struct net_device *dev, struct=
 phy_device *phydev,
 	 * our own module->refcnt here, otherwise we would not be able to
 	 * unload later on.
 	 */
+	if (dev)
+		ndev_owner =3D dev->dev.parent->driver->owner;
 	if (ndev_owner !=3D bus->owner && !try_module_get(bus->owner)) {
-		dev_err(&dev->dev, "failed to get the bus module\n");
+		phydev_err(phydev, "failed to get the bus module\n");
 		return -EIO;
 	}
=20
@@ -1207,7 +1212,7 @@ int phy_attach_direct(struct net_device *dev, struct =
phy_device *phydev,
 	}
=20
 	if (!try_module_get(d->driver->owner)) {
-		dev_err(&dev->dev, "failed to get the device driver module\n");
+		phydev_err(phydev, "failed to get the device driver module\n");
 		err =3D -EIO;
 		goto error_put_device;
 	}
@@ -1228,8 +1233,10 @@ int phy_attach_direct(struct net_device *dev, struct=
 phy_device *phydev,
 	}
=20
 	phydev->phy_link_change =3D phy_link_change;
-	phydev->attached_dev =3D dev;
-	dev->phydev =3D phydev;
+	if (dev) {
+		phydev->attached_dev =3D dev;
+		dev->phydev =3D phydev;
+	}
=20
 	/* Some Ethernet drivers try to connect to a PHY device before
 	 * calling register_netdevice() -> netdev_register_kobject() and
@@ -1252,7 +1259,8 @@ int phy_attach_direct(struct net_device *dev, struct =
phy_device *phydev,
 	/* Initial carrier state is off as the phy is about to be
 	 * (re)initialized.
 	 */
-	netif_carrier_off(phydev->attached_dev);
+	if (dev)
+		netif_carrier_off(phydev->attached_dev);
=20
 	/* Do initial configuration here, now that
 	 * we have certain key parameters
@@ -1358,16 +1366,19 @@ EXPORT_SYMBOL_GPL(phy_driver_is_genphy_10g);
 void phy_detach(struct phy_device *phydev)
 {
 	struct net_device *dev =3D phydev->attached_dev;
-	struct module *ndev_owner =3D dev->dev.parent->driver->owner;
+	struct module *ndev_owner =3D NULL;
 	struct mii_bus *bus;
=20
 	if (phydev->sysfs_links) {
-		sysfs_remove_link(&dev->dev.kobj, "phydev");
+		if (dev)
+			sysfs_remove_link(&dev->dev.kobj, "phydev");
 		sysfs_remove_link(&phydev->mdio.dev.kobj, "attached_dev");
 	}
 	phy_suspend(phydev);
-	phydev->attached_dev->phydev =3D NULL;
-	phydev->attached_dev =3D NULL;
+	if (dev) {
+		phydev->attached_dev->phydev =3D NULL;
+		phydev->attached_dev =3D NULL;
+	}
 	phydev->phylink =3D NULL;
=20
 	phy_led_triggers_unregister(phydev);
@@ -1390,6 +1401,8 @@ void phy_detach(struct phy_device *phydev)
 	bus =3D phydev->mdio.bus;
=20
 	put_device(&phydev->mdio.dev);
+	if (dev)
+		ndev_owner =3D dev->dev.parent->driver->owner;
 	if (ndev_owner !=3D bus->owner)
 		module_put(bus->owner);
=20
--=20
2.21.0

