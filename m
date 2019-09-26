Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C107BEDD1
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfIZIus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:50:48 -0400
Received: from mail-eopbgr20127.outbound.protection.outlook.com ([40.107.2.127]:10656
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728138AbfIZIus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 04:50:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8ZU3RJj47/GBAt/LAKWBhV/3+4bhsxCXnwpd8i3vxQJ9W4BpMZ2OmxQAoiHOZ73b/X66NpaZuoLOdalCgc1s8klXTT5WZAU8wqrpg9RTvrDX+hyCB3jM597gQRY/+9b1vzUSzduKZ9OwugGWKn1z4VfGEot47ES1WANHPJejPxgWam0PLkN/mFvx3oTcQMGcLS+3dCU5IEJKDH7Ewj0R2VzzTToVyjfpf4DIONn7HGKZNi0Ylfvc9c2IaolFVuKaUOOv9LlxnsbgSAXzfwS/nA3R+6H0zTUJuz5g8H+/EJ6r5mei/JaH2vea0hsTfwgBvk+eI5PnJURthuMGKq3Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wh1DRqEjNXNICb/zBGQM1NQpGgJADtQntMWrYPblpxQ=;
 b=RHIJwEBnE6ShE3KCr/GsQD4hFfJqZVLRiCkRrhZEVy+WHHSEvY8+WE2Znf4qkC+9MYduAwH7vhh7/6mwpJhUhD9fgBioIEwOvGlheZr2b+IlV3rXrwLr0Pa4WgtbSOlCp1lJ+gK+4sNd66ie2hbiRP9dGQDzMqbJvwNzOXIKvX+x3tUaUG91ba0mFRUCihTGDB10+s6PQ2qHrnQsgd9cND4BKhupNplMJjOXVb9hHhfSmX3ujKc2qHwmwAy+5+aIBw0ZyV6EkiXryepj0ynI9cWoJasC22NNE/sSPbNMMinjhKxUpxmEkwWU+nu/yUmTpLtHISnC/QaBRs87Hy4PZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wh1DRqEjNXNICb/zBGQM1NQpGgJADtQntMWrYPblpxQ=;
 b=Kfkh96+3ecGvRUN805vyAXZF8j8CGxn4GY1nLKVHXXevvq40qT8/5FU2L0+fCi+WUv3CyWlhV0am1OxJyfj1JWp49qtTi7J0lH5guIJdvQnAZ3gcR2jaMbPD1QagDJjn/qoXRqaTCpZHAel//xIUb4wLtgZkNDqEvIgenlF6iyQ=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2144.eurprd07.prod.outlook.com (10.169.137.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Thu, 26 Sep 2019 08:50:44 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 08:50:44 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] can: D_CAN: perform a sofware reset on open
Thread-Topic: [PATCH 1/2] can: D_CAN: perform a sofware reset on open
Thread-Index: AQHVdEd7etT22gKeN0iCyvC9ZUyGFQ==
Date:   Thu, 26 Sep 2019 08:50:44 +0000
Message-ID: <20190926085005.24805-2-jhofstee@victronenergy.com>
References: <20190926085005.24805-1-jhofstee@victronenergy.com>
In-Reply-To: <20190926085005.24805-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [213.126.8.10]
x-clientproxiedby: AM4PR08CA0062.eurprd08.prod.outlook.com
 (2603:10a6:205:2::33) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e07c6081-3544-4443-f74e-08d7425e9e2e
x-ms-traffictypediagnostic: VI1PR0701MB2144:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB21449D49A0C29CE0A916667FC0860@VI1PR0701MB2144.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(396003)(39850400004)(136003)(346002)(199004)(189003)(446003)(50226002)(99286004)(76176011)(8676002)(81166006)(81156014)(52116002)(2906002)(14454004)(966005)(186003)(8936002)(6306002)(478600001)(6512007)(5640700003)(6486002)(6436002)(66066001)(2351001)(102836004)(26005)(25786009)(1076003)(4326008)(2616005)(386003)(6506007)(486006)(86362001)(54906003)(316002)(2501003)(5660300002)(305945005)(11346002)(71200400001)(7736002)(71190400001)(3846002)(66476007)(6916009)(66556008)(64756008)(66446008)(66946007)(476003)(256004)(36756003)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2144;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NOmM9sEkwUXNYibs6KnqDfGYL19FYgNpzNJ2t645VsgCTbHzYQBoA5kr1plKJOWOKz1WSgoFJWudtD+bup5FIlBXf3Bue1AM0ijn8E+IlZDbxIdO0LZYs2r+FF3dzAcSXR6QEnvw9gJw15omrtSey7AVeQIo8/qLf5szGONY+nifMkCfrCQCQJbWNlhD0a2F6kJV32cmrAordph7N4BYBIrApNUI3rCnG6P8E7444WzVh1BeKDvrE8zHedUQ5TkqcFZyeUkzXvtb5k1PfYGq3uIda9InhzuovqAWIUeuRbmy5yJDulPASo0j6vCVgnffKVdLhuore0jcGR4D3BfQRT7EAxXN+GWXvlO4yFvXSnSBMUJMzHf5Edy7zYs+KQmy1lLmMTiaiS5lRY1uaAJNGhEtECne1p1kXyOysBSXNbNDMSgfNz73vwBpR9uiFJxRBnU0T1UtGFpSpEcAT2O93w==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e07c6081-3544-4443-f74e-08d7425e9e2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 08:50:44.6210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tbgXyvqasnh26O0EJcU1k6CEUhQNZF4mVgMfTRl1JY5sJEf9jxG4si3CNLpEhEkCsaRJJ6P+RJ0yhYeGIwZv2hV3pd8MzDAlV5Ho2V0wL1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the C_CAN interface is closed it is put in power down mode, but
does not reset the error counters / state. So reset the D_CAN on open,
so the reported state and the actual state match.

According to [1], the C_CAN module doesn't have the software reset.

[1] http://www.bosch-semiconductors.com/media/ip_modules/pdf_2/c_can_fd8/us=
ers_manual_c_can_fd8_r210_1.pdf

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/c_can/c_can.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 606b7d8ffe13..502a181d02e7 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -52,6 +52,7 @@
 #define CONTROL_EX_PDR		BIT(8)
=20
 /* control register */
+#define CONTROL_SWR		BIT(15)
 #define CONTROL_TEST		BIT(7)
 #define CONTROL_CCE		BIT(6)
 #define CONTROL_DISABLE_AR	BIT(5)
@@ -569,6 +570,26 @@ static void c_can_configure_msg_objects(struct net_dev=
ice *dev)
 				   IF_MCONT_RCV_EOB);
 }
=20
+static int software_reset(struct net_device *dev)
+{
+	struct c_can_priv *priv =3D netdev_priv(dev);
+	int retry =3D 0;
+
+	if (priv->type !=3D BOSCH_D_CAN)
+		return 0;
+
+	priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_SWR | CONTROL_INIT);
+	while (priv->read_reg(priv, C_CAN_CTRL_REG) & CONTROL_SWR) {
+		msleep(20);
+		if (retry++ > 100) {
+			netdev_err(dev, "CCTRL: software reset failed\n");
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Configure C_CAN chip:
  * - enable/disable auto-retransmission
@@ -578,6 +599,11 @@ static void c_can_configure_msg_objects(struct net_dev=
ice *dev)
 static int c_can_chip_config(struct net_device *dev)
 {
 	struct c_can_priv *priv =3D netdev_priv(dev);
+	int err;
+
+	err =3D software_reset(dev);
+	if (err)
+		return err;
=20
 	/* enable automatic retransmission */
 	priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_ENABLE_AR);
--=20
2.17.1

