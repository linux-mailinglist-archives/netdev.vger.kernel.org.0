Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5AF0273E7
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbfEWBVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:21:01 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:16354
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729698AbfEWBU6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRWYz6R6X6M1iGdQ6RL2Yl52XqqofgwS6//GVP654zU=;
 b=C43ZIDoNNxHLgg9W95EGBu3VB2ksNM894j7SXc9HTekATMujT8Z8aF0rxHBaHbisLZR2NAYsh0UMjuMSdSqQCCrplQE0jIjR85wHQIFIeH9S0WUFgY1LS7jMIURyAnoSuIHa9WpQzM51Tv0l7VcYVoIwItFKWYAuiKNo/ZONmVk=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:20:43 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 01:20:43 +0000
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
Subject: [RFC PATCH net-next 8/9] net: dsa: Use PHYLINK for the CPU/DSA ports
Thread-Topic: [RFC PATCH net-next 8/9] net: dsa: Use PHYLINK for the CPU/DSA
 ports
Thread-Index: AQHVEQW9dR5vtmHsY06KY7+uMrFNCg==
Date:   Thu, 23 May 2019 01:20:42 +0000
Message-ID: <20190523011958.14944-9-ioana.ciornei@nxp.com>
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
x-ms-office365-filtering-correlation-id: 8bb6fe00-0355-401e-6208-08d6df1cdfb5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB36778467273B2072F1E1F752E0010@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(25786009)(6512007)(316002)(2201001)(26005)(186003)(86362001)(2501003)(1076003)(36756003)(71200400001)(256004)(71190400001)(5660300002)(4326008)(66066001)(6486002)(14444005)(5024004)(6436002)(3846002)(7736002)(305945005)(71446004)(99286004)(52116002)(50226002)(81156014)(8676002)(81166006)(8936002)(54906003)(110136005)(2906002)(6116002)(478600001)(68736007)(102836004)(76176011)(53936002)(486006)(2616005)(66446008)(6506007)(386003)(66946007)(73956011)(66556008)(44832011)(14454004)(476003)(11346002)(66476007)(64756008)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KGajA+7HqnKMIN3AGThBwJM5VQjG+rcy77keKrNxCcbVR1w+M4lnD2EZQ+HHzBcfCNFhVkh4RyAnaT/UmPYaOXMUmW6ZXWfrA0KmOLRdzkPuOdH3daF2n1gGNK30ni80uDkxTeUMtmhSq/beIjOqVZVHm42RWe4hIxdtyuc8uJO7I6PkE5ot62ipKD0NI33tw5by4HjmbGjqd+7mRLy6aYMenwPQv0Xc0jBG/n6bcM1OK8HEC+bGv54ydyizKmQjDJIwxzn3CU9/+26dFx+y/DhIdTm3EW5e55QRMxWmuuMEiOCPd4Kzcmq+y7oi4DesJpMSpRuTiRmErAoN7XLytLc6NwyEe1OJRIOmMnTJgfNdi4BVbjqlLyl8yhSVHIpxunPuIegDuFz3gcxs7gqYc9AH64S6XT/e9s6xtxOZhf4=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <50F9FF48CDF9A04C912CE1D55353072D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb6fe00-0355-401e-6208-08d6df1cdfb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:20:42.7690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This completely removes the usage of PHYLIB from DSA, namely for the
aforementioned switch ports which used to drive a software PHY manually
using genphy operations.

For these ports, the newly introduced phylink_create_raw API must be
used, and the callbacks are received through a notifier block registered
per dsa_port, but otherwise the implementation is fairly
straightforward, and the handling of the regular vs raw PHYLINK
instances is common from the perspective of the driver.

What changes for drivers:

The .adjust_link callback is no longer called for the fixed-link CPU/DSA
ports and drivers must migrate to standard PHYLINK operations (e.g.
.phylink_mac_config).  The reason why we can't do anything for them is
because PHYLINK does not wrap the fixed link state behind a phydev
object, so we cannot wrap .phylink_mac_config into .adjust_link unless
we fabricate a phy_device structure.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 include/net/dsa.h |   3 +
 net/dsa/port.c    | 137 +++++++++++++++++++++-------------------------
 2 files changed, 64 insertions(+), 76 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 685294817712..87616ff00919 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -212,6 +212,9 @@ struct dsa_port {
 	 * Original copy of the master netdev net_device_ops
 	 */
 	const struct net_device_ops *orig_ndo_ops;
+
+	/* Listener for phylink events on ports with no netdev */
+	struct notifier_block	nb;
 };
=20
 struct dsa_switch {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d0f955e8b731..31bd07dd42db 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -13,6 +13,7 @@
 #include <linux/if_bridge.h>
 #include <linux/notifier.h>
 #include <linux/of_mdio.h>
+#include <linux/phylink.h>
 #include <linux/of_net.h>
=20
 #include "dsa_priv.h"
@@ -511,104 +512,88 @@ void dsa_port_phylink_fixed_state(struct dsa_port *d=
p,
 {
 	struct dsa_switch *ds =3D dp->ds;
=20
-	/* No need to check that this operation is valid, the callback would
-	 * not be called if it was not.
+	/* We need to check that the callback exists because phylink raw will
+	 * send PHYLINK_GET_FIXED_STATE events without an explicit register.
 	 */
-	ds->ops->phylink_fixed_state(ds, dp->index, state);
+	if (ds->ops->phylink_fixed_state)
+		ds->ops->phylink_fixed_state(ds, dp->index, state);
 }
 EXPORT_SYMBOL(dsa_port_phylink_fixed_state);
=20
-static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
-{
-	struct dsa_switch *ds =3D dp->ds;
-	struct phy_device *phydev;
-	int port =3D dp->index;
-	int err =3D 0;
-
-	phydev =3D dsa_port_get_phy_device(dp);
-	if (!phydev)
-		return 0;
-
-	if (IS_ERR(phydev))
-		return PTR_ERR(phydev);
-
-	if (enable) {
-		err =3D genphy_config_init(phydev);
-		if (err < 0)
-			goto err_put_dev;
-
-		err =3D genphy_resume(phydev);
-		if (err < 0)
-			goto err_put_dev;
-
-		err =3D genphy_read_status(phydev);
-		if (err < 0)
-			goto err_put_dev;
-	} else {
-		err =3D genphy_suspend(phydev);
-		if (err < 0)
-			goto err_put_dev;
+static int dsa_cpu_port_event(struct notifier_block *nb,
+			      unsigned long event, void *ptr)
+{
+	struct phylink_notifier_info *info =3D ptr;
+	struct dsa_port *dp =3D container_of(nb, struct dsa_port, nb);
+
+	switch (event) {
+	case PHYLINK_VALIDATE:
+		dsa_port_phylink_validate(dp, info->supported, info->state);
+		break;
+	case PHYLINK_MAC_AN_RESTART:
+		dsa_port_phylink_mac_an_restart(dp);
+		break;
+	case PHYLINK_MAC_CONFIG:
+		dsa_port_phylink_mac_config(dp, info->link_an_mode,
+					    info->state);
+		break;
+	case PHYLINK_MAC_LINK_DOWN:
+		dsa_port_phylink_mac_link_down(dp, info->link_an_mode,
+					       info->interface, info->phydev);
+		break;
+	case PHYLINK_MAC_LINK_UP:
+		dsa_port_phylink_mac_link_up(dp, info->link_an_mode,
+					     info->interface, info->phydev);
+		break;
+	case PHYLINK_GET_FIXED_STATE:
+		dsa_port_phylink_fixed_state(dp, info->state);
+		break;
+	default:
+		return NOTIFY_OK;
 	}
=20
-	if (ds->ops->adjust_link)
-		ds->ops->adjust_link(ds, port, phydev);
-
-	dev_dbg(ds->dev, "enabled port's phy: %s", phydev_name(phydev));
-
-err_put_dev:
-	put_device(&phydev->mdio.dev);
-	return err;
+	return NOTIFY_DONE;
 }
=20
-static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
+int dsa_port_link_register_of(struct dsa_port *dp)
 {
-	struct device_node *dn =3D dp->dn;
-	struct dsa_switch *ds =3D dp->ds;
-	struct phy_device *phydev;
-	int port =3D dp->index;
-	int mode;
-	int err;
+	struct device_node *port_dn =3D dp->dn;
+	int mode, err;
=20
-	err =3D of_phy_register_fixed_link(dn);
-	if (err) {
-		dev_err(ds->dev,
-			"failed to register the fixed PHY of port %d\n",
-			port);
-		return err;
-	}
-
-	phydev =3D of_phy_find_device(dn);
-
-	mode =3D of_get_phy_mode(dn);
+	mode =3D of_get_phy_mode(port_dn);
 	if (mode < 0)
 		mode =3D PHY_INTERFACE_MODE_NA;
-	phydev->interface =3D mode;
=20
-	genphy_config_init(phydev);
-	genphy_read_status(phydev);
+	dp->nb.notifier_call =3D dsa_cpu_port_event;
+	dp->pl =3D phylink_create_raw(&dp->nb, of_fwnode_handle(port_dn), mode);
+	if (IS_ERR(dp->pl)) {
+		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
+		return PTR_ERR(dp->pl);
+	}
=20
-	if (ds->ops->adjust_link)
-		ds->ops->adjust_link(ds, port, phydev);
+	err =3D phylink_of_phy_connect(dp->pl, port_dn, 0);
+	if (err) {
+		pr_err("could not attach to PHY: %d\n", err);
+		goto err_phy_connect;
+	}
=20
-	put_device(&phydev->mdio.dev);
+	rtnl_lock();
+	phylink_start(dp->pl);
+	rtnl_unlock();
=20
 	return 0;
-}
=20
-int dsa_port_link_register_of(struct dsa_port *dp)
-{
-	if (of_phy_is_fixed_link(dp->dn))
-		return dsa_port_fixed_link_register_of(dp);
-	else
-		return dsa_port_setup_phy_of(dp, true);
+err_phy_connect:
+	phylink_destroy(dp->pl);
+	return err;
 }
=20
 void dsa_port_link_unregister_of(struct dsa_port *dp)
 {
-	if (of_phy_is_fixed_link(dp->dn))
-		of_phy_deregister_fixed_link(dp->dn);
-	else
-		dsa_port_setup_phy_of(dp, false);
+	rtnl_lock();
+	phylink_disconnect_phy(dp->pl);
+	rtnl_unlock();
+	phylink_destroy(dp->pl);
 }
=20
 int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data)
--=20
2.21.0

