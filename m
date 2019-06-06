Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1196371C8
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfFFKcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 06:32:02 -0400
Received: from mail-eopbgr820042.outbound.protection.outlook.com ([40.107.82.42]:39648
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725784AbfFFKcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 06:32:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector1-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k90fH4tT/rspS3VycF7Hdz/P34PrfcFszmHWA/n+rIY=;
 b=Y6gG9teBGEQIQQJ44vi+oigqCFtnJwsykgGCC8qzXzxrn4MTI0kSsv0yv3JjgBWf2ZRwCHRdCsF86uWmVz/M0iRxHAhBH4x48KjQZISJfG1tdnxdcXXu8Ig7c/3iyZVh/nt8Ypl+YBgBYcQwmakWzoEEw6J0Zrk45025YWx+I6Y=
Received: from BYAPR03MB4773.namprd03.prod.outlook.com (20.179.92.152) by
 BYAPR03MB3704.namprd03.prod.outlook.com (52.135.214.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 10:31:56 +0000
Received: from BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::e484:f15c:c415:5ff9]) by BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::e484:f15c:c415:5ff9%7]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 10:31:56 +0000
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next] net: stmmac: move reset gpio parse & request to
 stmmac_mdio_register
Thread-Topic: [PATCH v2 net-next] net: stmmac: move reset gpio parse & request
 to stmmac_mdio_register
Thread-Index: AQHVHFMQuNgfdhfJWEqSSLEPrwpORw==
Date:   Thu, 6 Jun 2019 10:31:56 +0000
Message-ID: <20190606182244.422e187f@xhacker.debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [124.74.246.114]
x-clientproxiedby: HK2P15301CA0003.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::13) To BYAPR03MB4773.namprd03.prod.outlook.com
 (2603:10b6:a03:134::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jisheng.Zhang@synaptics.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b15c4e5-e960-48d5-5376-08d6ea6a32d3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR03MB3704;
x-ms-traffictypediagnostic: BYAPR03MB3704:
x-microsoft-antispam-prvs: <BYAPR03MB370449C37FAF0C3E1CE4F90FED170@BYAPR03MB3704.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(366004)(39860400002)(376002)(136003)(199004)(189003)(99286004)(52116002)(73956011)(7736002)(66556008)(110136005)(66446008)(3846002)(6116002)(102836004)(305945005)(316002)(14454004)(66476007)(66946007)(476003)(386003)(1076003)(2906002)(478600001)(6506007)(54906003)(6436002)(4326008)(6486002)(9686003)(6512007)(256004)(14444005)(72206003)(53936002)(71190400001)(71200400001)(25786009)(64756008)(8936002)(86362001)(50226002)(5660300002)(26005)(81166006)(81156014)(186003)(68736007)(8676002)(66066001)(486006)(39210200001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB3704;H:BYAPR03MB4773.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: synaptics.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RU9OFmpN+CtOVfLZitzCJHphcEdiX9bBdajA3xgpyRNclyE3rfQfUxcbJkR/KECkqeTh0sSbtmJZnytWAelmUwJupSDtZs73HG+kVkBANWfhUgTDCcUwBmGTi7apjBoFxlW4Ib1P7w1qX1LWhKDLQIr1T/KS6/g7McKNSBc+eULLRdAWVi5m62JPx3d865T7jP0Jw/DBOQ6VQGr5NEGOV9EKLLV5mRUkht7VPiNH9TH6MCf/c1Sj+HG+dGK/wgxGrCwaHrO/vhoDcmzIwPLoCo2yoZQLIeb9FvWUZcYuD8a5r3ByWOOfORYuwc61ptP48UpcC2xuuCwkSlfnYOyUU0CvCkfMeUjF1kU+1tZd8c3sNGyhzhuUAahSl/XGd8iQbSu7JCEhdkBqWWgxf1i30PaxBGeNTU0WWM9+SbQth9E=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3C1CF0562F09EC4F833E395484A62B31@namprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b15c4e5-e960-48d5-5376-08d6ea6a32d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 10:31:56.3754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jiszha@synaptics.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3704
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the reset gpio dt parse and request to stmmac_mdio_register(),
thus makes the mdio code straightforward.

This patch also replace stack var mdio_bus_data with data to simplify
the code.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
Since v1:
 - rebase on the latest net-next tree

 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 58 ++++++++-----------
 1 file changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_mdio.c
index 093a223fe408..7d1562ec1149 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -250,28 +250,7 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 	struct stmmac_mdio_bus_data *data =3D priv->plat->mdio_bus_data;
=20
 #ifdef CONFIG_OF
-	if (priv->device->of_node) {
-		if (data->reset_gpio < 0) {
-			struct device_node *np =3D priv->device->of_node;
-
-			if (!np)
-				return 0;
-
-			data->reset_gpio =3D of_get_named_gpio(np,
-						"snps,reset-gpio", 0);
-			if (data->reset_gpio < 0)
-				return 0;
-
-			data->active_low =3D of_property_read_bool(np,
-						"snps,reset-active-low");
-			of_property_read_u32_array(np,
-				"snps,reset-delays-us", data->delays, 3);
-
-			if (devm_gpio_request(priv->device, data->reset_gpio,
-					      "mdio-reset"))
-				return 0;
-		}
-
+	if (gpio_is_valid(data->reset_gpio)) {
 		gpio_direction_output(data->reset_gpio,
 				      data->active_low ? 1 : 0);
 		if (data->delays[0])
@@ -313,24 +292,38 @@ int stmmac_mdio_register(struct net_device *ndev)
 	int err =3D 0;
 	struct mii_bus *new_bus;
 	struct stmmac_priv *priv =3D netdev_priv(ndev);
-	struct stmmac_mdio_bus_data *mdio_bus_data =3D priv->plat->mdio_bus_data;
+	struct stmmac_mdio_bus_data *data =3D priv->plat->mdio_bus_data;
 	struct device_node *mdio_node =3D priv->plat->mdio_node;
 	struct device *dev =3D ndev->dev.parent;
 	int addr, found, max_addr;
=20
-	if (!mdio_bus_data)
+	if (!data)
 		return 0;
=20
 	new_bus =3D mdiobus_alloc();
 	if (!new_bus)
 		return -ENOMEM;
=20
-	if (mdio_bus_data->irqs)
-		memcpy(new_bus->irq, mdio_bus_data->irqs, sizeof(new_bus->irq));
+	if (data->irqs)
+		memcpy(new_bus->irq, data->irqs, sizeof(new_bus->irq));
=20
 #ifdef CONFIG_OF
-	if (priv->device->of_node)
-		mdio_bus_data->reset_gpio =3D -1;
+	if (priv->device->of_node) {
+		struct device_node *np =3D priv->device->of_node;
+
+		data->reset_gpio =3D of_get_named_gpio(np, "snps,reset-gpio", 0);
+		if (gpio_is_valid(data->reset_gpio)) {
+			data->active_low =3D of_property_read_bool(np,
+						"snps,reset-active-low");
+			of_property_read_u32_array(np,
+				"snps,reset-delays-us", data->delays, 3);
+
+			devm_gpio_request(priv->device, data->reset_gpio,
+					  "mdio-reset");
+		}
+	} else {
+		data->reset_gpio =3D -1;
+	}
 #endif
=20
 	new_bus->name =3D "stmmac";
@@ -356,7 +349,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		 new_bus->name, priv->plat->bus_id);
 	new_bus->priv =3D ndev;
-	new_bus->phy_mask =3D mdio_bus_data->phy_mask;
+	new_bus->phy_mask =3D data->phy_mask;
 	new_bus->parent =3D priv->device;
=20
 	err =3D of_mdiobus_register(new_bus, mdio_node);
@@ -379,10 +372,9 @@ int stmmac_mdio_register(struct net_device *ndev)
 		 * If an IRQ was provided to be assigned after
 		 * the bus probe, do it here.
 		 */
-		if (!mdio_bus_data->irqs &&
-		    (mdio_bus_data->probed_phy_irq > 0)) {
-			new_bus->irq[addr] =3D mdio_bus_data->probed_phy_irq;
-			phydev->irq =3D mdio_bus_data->probed_phy_irq;
+		if (!data->irqs && (data->probed_phy_irq > 0)) {
+			new_bus->irq[addr] =3D data->probed_phy_irq;
+			phydev->irq =3D data->probed_phy_irq;
 		}
=20
 		/*
--=20
2.20.1

