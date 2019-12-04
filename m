Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A22112A4B
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfLDLgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:36:21 -0500
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:18334
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727472AbfLDLgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 06:36:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nX1K1o7w9DU70F02CIi6mQvdF+34oy6FlM+AxijBP5VBAZEseTeqz8aRCLKLbQcFJyC8/EonItW34ZuhiKqCqoiAuftrIFfdodnX6KmerHl4pPG8kEk9sBm4LmJMOVnnbBEVhjIB2/BDXTkbSBfMe8ubdMwKiLLTseePVZeh/+78QAG5A/svTMcuIEsG1CCHY1KSn+X5zuNw5y6ckFPLTKx4vZJusxz23tvFRlKsyfemj8Dil2SQFyDaU54x/fyEbQ9pSSEro7VvAONrMwlMqc5jmMSjjjVa7uu/+vsHLM6WnUMCzryCvvZCJb+SH7uggaI+M3UEqeft8VP3tqGOBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pF5EW+MA3BefhEoB1eQy5ag6U01utGe8iZ9I11DOmnc=;
 b=B6JVOgH4OCVBh5cBzi/Cb7s1lQBWcbsph8yeHAxXcteVR/CBlrM/+rPcXeKHCNxbsXOUlCvOQWJSteArRqbLnbivkWUv6zjoPuegwMLbOgPWVXovLN+ziFzQ0J4wQBHQtxghLoCIrJYtKT2kICsXA6kqBRsfQLb2J74hOOq7HPavRDbOEj3bb4JnEHRJkWwRYOO4jSpnMa8pk7pLWyKyP3PJsz3nKvG9HNmXAnMdVAhL04NisHKEGSFoZAMaLgvrADyol4WW4LPXeSuFfVmL2C7dB0g4h0sfzdqaOvKxAH9SBksppfkiboisr7KVFx5u14Jar2zFS2DShaZzH6YPVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pF5EW+MA3BefhEoB1eQy5ag6U01utGe8iZ9I11DOmnc=;
 b=kr0n302SSdfTQU3hAMqD+o3QT7t+Ens+NAQOteh7f88RqlkTexZEgbG4u7DavklmIWsu6zhMlK4mSPAK61E1rONUuZkq0iSrXk13i4zDlNzKtG6rEUq59UMFRezAdWyrtd4gLlwN2E3aLoa31ECt58L4pcj/3qCQqHV2BjPJqdw=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5017.eurprd04.prod.outlook.com (20.176.234.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 4 Dec 2019 11:36:17 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 11:36:17 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 5/6] can: flexcan: propagate error value of
 flexcan_chip_stop()
Thread-Topic: [PATCH V3 5/6] can: flexcan: propagate error value of
 flexcan_chip_stop()
Thread-Index: AQHVqpcKMrFQuw9VE0mnDnGsvcW7vg==
Date:   Wed, 4 Dec 2019 11:36:17 +0000
Message-ID: <20191204113249.3381-6-qiangqing.zhang@nxp.com>
References: <20191204113249.3381-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191204113249.3381-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:54::14) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5ff98fcf-f7af-422d-71e4-08d778ae2cd9
x-ms-traffictypediagnostic: DB7PR04MB5017:|DB7PR04MB5017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5017AC48D3636EACFF05FFCBE65D0@DB7PR04MB5017.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(199004)(189003)(54534003)(3846002)(316002)(36756003)(6512007)(305945005)(2201001)(6486002)(6436002)(2906002)(7736002)(76176011)(52116002)(14444005)(71190400001)(71200400001)(110136005)(6116002)(478600001)(14454004)(81166006)(99286004)(6506007)(102836004)(26005)(25786009)(1076003)(186003)(2501003)(81156014)(2616005)(8936002)(11346002)(5660300002)(8676002)(50226002)(64756008)(4326008)(66446008)(66946007)(66556008)(66476007)(86362001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5017;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Vw1N01cX7myUbrQHbADSUfdIMZ2/ZHhsa4BhPz2jtE1BYYQE+Ckt0JYIpMP9CL2ibv1ycDJ+Z/+S6F+9LN/rfdF8EnUD2RVTdN8YryvolSICnxU+kcjxH40BeQnuVauKLMLRiUIAGGpcPCsxyJggjqUSlc9TQLQDwf71p0uZRckpygqD9f8dtzZlonBktzbnZ6uxDNejgZOIjowneMMYaO7j6ClbBVsMxF7usOhRRWLVJ6z0Q65FU+bZnKgGQNMBfZfI8R+kW4EEsV+NzSvLCkHwZU9n3G8EEXL9+QMMPaIJvwgqV02nyQV/OWsKcbzbXV7OdIuUKf5c4E4O9lPwN3caGm7yFYXdptUeptMVli9enUqo5iAUUTJ6DYnY3msRmuJ0OmuLqY5vT/jcNiimx2O1NPxvJ4HUV2OqtCFy2ItGmAQbM+JO/Ln+7JqJCL3e+bS0P08Z1v4EZgQtCEUS5o/Riq1WZ82AQo0Nwo6kiRJUqW5AF/g3Vtt5vMKW/qo
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ff98fcf-f7af-422d-71e4-08d778ae2cd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 11:36:17.2092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /WjSHPrfrz7A7aOE3UcICLiyLncNQ/k2RVFrMqpE+tZdLfbb90AGtasML941Ujrjg4Ccsfq2emMuQskV5jK16w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Propagate error value of flexcan_chip_stop(), since this could be called
from flexcan_suspend() in some SoCs which support LPSR mode.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
------
ChangeLog:
	V3: * new add.
---
 drivers/net/can/flexcan.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 19602b77907f..c5e4b6928dee 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1263,14 +1263,19 @@ static int flexcan_chip_start(struct net_device *de=
v)
  *
  * this functions is entered with clocks enabled
  */
-static void flexcan_chip_stop(struct net_device *dev)
+static int flexcan_chip_stop(struct net_device *dev)
 {
 	struct flexcan_priv *priv =3D netdev_priv(dev);
 	struct flexcan_regs __iomem *regs =3D priv->regs;
+	int err;
=20
 	/* freeze + disable module */
-	flexcan_chip_freeze(priv);
-	flexcan_chip_disable(priv);
+	err =3D flexcan_chip_freeze(priv);
+	if (err)
+		return err;
+	err =3D flexcan_chip_disable(priv);
+	if (err)
+		goto out_chip_unfreeze;
=20
 	/* Disable all interrupts */
 	priv->write(0, &regs->imask2);
@@ -1278,8 +1283,19 @@ static void flexcan_chip_stop(struct net_device *dev=
)
 	priv->write(priv->reg_ctrl_default & ~FLEXCAN_CTRL_ERR_ALL,
 		    &regs->ctrl);
=20
-	flexcan_transceiver_disable(priv);
+	err =3D flexcan_transceiver_disable(priv);
+	if (err)
+		goto out_chip_enable;
+
 	priv->can.state =3D CAN_STATE_STOPPED;
+
+	return 0;
+
+out_chip_enable:
+	flexcan_chip_enable(priv);
+out_chip_unfreeze:
+	flexcan_chip_unfreeze(priv);
+	return err;
 }
=20
 static int flexcan_open(struct net_device *dev)
--=20
2.17.1

