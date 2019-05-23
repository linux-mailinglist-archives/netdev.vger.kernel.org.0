Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD30F273E9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbfEWBVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:21:11 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:5421
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728352AbfEWBVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:21:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2EdBvi7LxmJ6rD1fEByMsJDH0u0sWhBMOApO8R6ChY=;
 b=bjzjQ21ulZxPQMP1tBMQ3twOQCnl7ZzCZYv+NSaiIREFI+W9lqAPLgcybrajmzvnZ2K4njqKuKLukDh5JSneIO5M/75zffU8QHEP4h9jBgtP2SaQOFghJJZi7/0YFaZdLdtl4aerNeieURTo4X+r3NPBD0p5nDQRpSqJkHLrqn4=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:20:42 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 01:20:42 +0000
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
Subject: [RFC PATCH net-next 7/9] net: dsa: Move the phylink driver calls into
 port.c
Thread-Topic: [RFC PATCH net-next 7/9] net: dsa: Move the phylink driver calls
 into port.c
Thread-Index: AQHVEQW865/ec3v+bkaKV7+otlyqGw==
Date:   Thu, 23 May 2019 01:20:41 +0000
Message-ID: <20190523011958.14944-8-ioana.ciornei@nxp.com>
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
x-ms-office365-filtering-correlation-id: 80b23386-39b5-414b-0a2a-08d6df1cdf29
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB3677F849C3AB7CDCAAF2B9E1E0010@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(25786009)(6512007)(316002)(2201001)(26005)(186003)(86362001)(2501003)(1076003)(36756003)(71200400001)(256004)(71190400001)(5660300002)(4326008)(66066001)(6486002)(14444005)(6436002)(3846002)(7736002)(305945005)(71446004)(99286004)(52116002)(50226002)(81156014)(8676002)(81166006)(8936002)(54906003)(110136005)(2906002)(6116002)(478600001)(68736007)(102836004)(76176011)(53936002)(486006)(2616005)(66446008)(6506007)(386003)(66946007)(73956011)(66556008)(44832011)(14454004)(476003)(11346002)(66476007)(64756008)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ha1FQYhc22uE1UyFzsQ83K+gV3ZJBbJSeWIpfvu7tEjBwDX2keI6nJ1+cs1YwTvjO1e+XmuDlWgQNbGMgcsoQaaZy+aXQRM36z+hfsCcJ4biZZxjDwwL3ZGWkj7LNuHkcixaunYjo/lYAyXmIWZfQUYBfCsXoMLHKyiAIb5gKg5u0t8vWLHwKns8kyW3VZDKz8TeDqs1A+RpJVE/NhJNOcjobUBapfzM/s4+F9/sRBetUDyULckyhNAVT9/wZmWOjpxRfdjufC4aQ2yUgGOowARaNL8JRr6W8V89Vn72WeelX/nmy6Lo3Mm/gAZwJEMArczSW+PoDUYg3WMh0LZW8Oc595klJp2a0elfWq6bU/Na5/qveBcmnw7sZfFWeY/8I22uMvgXJ92fVrWT7Z7rx0U/efMnSnPWUsZ8HqZ41/g=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <5EB9B9F03E807E4F8B1F3328AA3890E3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b23386-39b5-414b-0a2a-08d6df1cdf29
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:20:42.0054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to have a common handling of PHYLINK for the slave and non-user
ports, the DSA core glue logic (between PHYLINK and the driver) must use
an API that does not rely on a struct net_device.

These will also be called by the CPU-port-handling code in a further
patch.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/dsa_priv.h | 19 +++++++++
 net/dsa/port.c     | 96 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c    | 49 ++++-------------------
 3 files changed, 122 insertions(+), 42 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8f1222324646..da70da65bdc5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -161,6 +161,25 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags);
 int dsa_port_vid_del(struct dsa_port *dp, u16 vid);
+void dsa_port_phylink_validate(struct dsa_port *dp,
+			       unsigned long *supported,
+			       struct phylink_link_state *state);
+int dsa_port_phylink_mac_link_state(struct dsa_port *dp,
+				    struct phylink_link_state *state);
+void dsa_port_phylink_mac_config(struct dsa_port *dp,
+				 unsigned int mode,
+				 const struct phylink_link_state *state);
+void dsa_port_phylink_mac_an_restart(struct dsa_port *dp);
+void dsa_port_phylink_mac_link_down(struct dsa_port *dp,
+				    unsigned int mode,
+				    phy_interface_t interface,
+				    struct phy_device *phydev);
+void dsa_port_phylink_mac_link_up(struct dsa_port *dp,
+				  unsigned int mode,
+				  phy_interface_t interface,
+				  struct phy_device *phydev);
+void dsa_port_phylink_fixed_state(struct dsa_port *dp,
+				  struct phylink_link_state *state);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
=20
diff --git a/net/dsa/port.c b/net/dsa/port.c
index ed8ba9daa3ba..d0f955e8b731 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -422,6 +422,102 @@ static struct phy_device *dsa_port_get_phy_device(str=
uct dsa_port *dp)
 	return phydev;
 }
=20
+void dsa_port_phylink_validate(struct dsa_port *dp,
+			       unsigned long *supported,
+			       struct phylink_link_state *state)
+{
+	struct dsa_switch *ds =3D dp->ds;
+
+	if (!ds->ops->phylink_validate)
+		return;
+
+	ds->ops->phylink_validate(ds, dp->index, supported, state);
+}
+EXPORT_SYMBOL(dsa_port_phylink_validate);
+
+int dsa_port_phylink_mac_link_state(struct dsa_port *dp,
+				    struct phylink_link_state *state)
+{
+	struct dsa_switch *ds =3D dp->ds;
+
+	/* Only called for SGMII and 802.3z */
+	if (!ds->ops->phylink_mac_link_state)
+		return -EOPNOTSUPP;
+
+	return ds->ops->phylink_mac_link_state(ds, dp->index, state);
+}
+EXPORT_SYMBOL(dsa_port_phylink_mac_link_state);
+
+void dsa_port_phylink_mac_config(struct dsa_port *dp,
+				 unsigned int mode,
+				 const struct phylink_link_state *state)
+{
+	struct dsa_switch *ds =3D dp->ds;
+
+	if (!ds->ops->phylink_mac_config)
+		return;
+
+	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
+}
+EXPORT_SYMBOL(dsa_port_phylink_mac_config);
+
+void dsa_port_phylink_mac_an_restart(struct dsa_port *dp)
+{
+	struct dsa_switch *ds =3D dp->ds;
+
+	if (!ds->ops->phylink_mac_an_restart)
+		return;
+
+	ds->ops->phylink_mac_an_restart(ds, dp->index);
+}
+EXPORT_SYMBOL(dsa_port_phylink_mac_an_restart);
+
+void dsa_port_phylink_mac_link_down(struct dsa_port *dp,
+				    unsigned int mode,
+				    phy_interface_t interface,
+				    struct phy_device *phydev)
+{
+	struct dsa_switch *ds =3D dp->ds;
+
+	if (!ds->ops->phylink_mac_link_down) {
+		if (ds->ops->adjust_link && phydev)
+			ds->ops->adjust_link(ds, dp->index, phydev);
+		return;
+	}
+
+	ds->ops->phylink_mac_link_down(ds, dp->index, mode, interface);
+}
+EXPORT_SYMBOL(dsa_port_phylink_mac_link_down);
+
+void dsa_port_phylink_mac_link_up(struct dsa_port *dp,
+				  unsigned int mode,
+				  phy_interface_t interface,
+				  struct phy_device *phydev)
+{
+	struct dsa_switch *ds =3D dp->ds;
+
+	if (!ds->ops->phylink_mac_link_up) {
+		if (ds->ops->adjust_link && phydev)
+			ds->ops->adjust_link(ds, dp->index, phydev);
+		return;
+	}
+
+	ds->ops->phylink_mac_link_up(ds, dp->index, mode, interface, phydev);
+}
+EXPORT_SYMBOL(dsa_port_phylink_mac_link_up);
+
+void dsa_port_phylink_fixed_state(struct dsa_port *dp,
+				  struct phylink_link_state *state)
+{
+	struct dsa_switch *ds =3D dp->ds;
+
+	/* No need to check that this operation is valid, the callback would
+	 * not be called if it was not.
+	 */
+	ds->ops->phylink_fixed_state(ds, dp->index, state);
+}
+EXPORT_SYMBOL(dsa_port_phylink_fixed_state);
+
 static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds =3D dp->ds;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9892ca1f6859..308066da8a0f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1169,25 +1169,16 @@ static void dsa_slave_phylink_validate(struct net_d=
evice *dev,
 				       struct phylink_link_state *state)
 {
 	struct dsa_port *dp =3D dsa_slave_to_port(dev);
-	struct dsa_switch *ds =3D dp->ds;
-
-	if (!ds->ops->phylink_validate)
-		return;
=20
-	ds->ops->phylink_validate(ds, dp->index, supported, state);
+	dsa_port_phylink_validate(dp, supported, state);
 }
=20
 static int dsa_slave_phylink_mac_link_state(struct net_device *dev,
 					    struct phylink_link_state *state)
 {
 	struct dsa_port *dp =3D dsa_slave_to_port(dev);
-	struct dsa_switch *ds =3D dp->ds;
-
-	/* Only called for SGMII and 802.3z */
-	if (!ds->ops->phylink_mac_link_state)
-		return -EOPNOTSUPP;
=20
-	return ds->ops->phylink_mac_link_state(ds, dp->index, state);
+	return dsa_port_phylink_mac_link_state(dp, state);
 }
=20
 static void dsa_slave_phylink_mac_config(struct net_device *dev,
@@ -1195,23 +1186,15 @@ static void dsa_slave_phylink_mac_config(struct net=
_device *dev,
 					 const struct phylink_link_state *state)
 {
 	struct dsa_port *dp =3D dsa_slave_to_port(dev);
-	struct dsa_switch *ds =3D dp->ds;
-
-	if (!ds->ops->phylink_mac_config)
-		return;
=20
-	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
+	dsa_port_phylink_mac_config(dp, mode, state);
 }
=20
 static void dsa_slave_phylink_mac_an_restart(struct net_device *dev)
 {
 	struct dsa_port *dp =3D dsa_slave_to_port(dev);
-	struct dsa_switch *ds =3D dp->ds;
-
-	if (!ds->ops->phylink_mac_an_restart)
-		return;
=20
-	ds->ops->phylink_mac_an_restart(ds, dp->index);
+	dsa_port_phylink_mac_an_restart(dp);
 }
=20
 static void dsa_slave_phylink_mac_link_down(struct net_device *dev,
@@ -1219,15 +1202,8 @@ static void dsa_slave_phylink_mac_link_down(struct n=
et_device *dev,
 					    phy_interface_t interface)
 {
 	struct dsa_port *dp =3D dsa_slave_to_port(dev);
-	struct dsa_switch *ds =3D dp->ds;
-
-	if (!ds->ops->phylink_mac_link_down) {
-		if (ds->ops->adjust_link && dev->phydev)
-			ds->ops->adjust_link(ds, dp->index, dev->phydev);
-		return;
-	}
=20
-	ds->ops->phylink_mac_link_down(ds, dp->index, mode, interface);
+	dsa_port_phylink_mac_link_down(dp, mode, interface, dev->phydev);
 }
=20
 static void dsa_slave_phylink_mac_link_up(struct net_device *dev,
@@ -1236,15 +1212,8 @@ static void dsa_slave_phylink_mac_link_up(struct net=
_device *dev,
 					  struct phy_device *phydev)
 {
 	struct dsa_port *dp =3D dsa_slave_to_port(dev);
-	struct dsa_switch *ds =3D dp->ds;
=20
-	if (!ds->ops->phylink_mac_link_up) {
-		if (ds->ops->adjust_link && dev->phydev)
-			ds->ops->adjust_link(ds, dp->index, dev->phydev);
-		return;
-	}
-
-	ds->ops->phylink_mac_link_up(ds, dp->index, mode, interface, phydev);
+	dsa_port_phylink_mac_link_up(dp, mode, interface, phydev);
 }
=20
 static const struct phylink_mac_ops dsa_slave_phylink_mac_ops =3D {
@@ -1268,12 +1237,8 @@ static void dsa_slave_phylink_fixed_state(struct net=
_device *dev,
 					  struct phylink_link_state *state)
 {
 	struct dsa_port *dp =3D dsa_slave_to_port(dev);
-	struct dsa_switch *ds =3D dp->ds;
=20
-	/* No need to check that this operation is valid, the callback would
-	 * not be called if it was not.
-	 */
-	ds->ops->phylink_fixed_state(ds, dp->index, state);
+	dsa_port_phylink_fixed_state(dp, state);
 }
=20
 /* slave device setup ****************************************************=
***/
--=20
2.21.0

