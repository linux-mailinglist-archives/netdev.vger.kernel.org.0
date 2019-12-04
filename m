Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9178C112A46
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfLDLgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:36:16 -0500
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:18334
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727472AbfLDLgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 06:36:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ky5nueQFSmEPvUaO36Zqt4ouLENCpwODNGr/JKUbQMyXVS+/kFJy78FWsOgDxRWz0xIWM0QrW6ZcJwovUJvEaOJ/yc2wRi7XhSrXiwUS8oCjZmPiaqCglzuDZ2qhyOLdbaotT0TE8gElNnnKxzKl63aA4pfjiHqLxBYVJZU8lBVFClix58HDl/pZ9N+N1/xJhFY3iu1+O0bRDg07UjDb0bePqG5RrY0VzbOklZn+y8YBEdZpokVRhfhQ8BGBifPv4GzxVuds02ZJD29wu4k5zoCym56jwRalDKV3U4PlO3ImAqk60qyICMbwcFWbJAVqplr0SdZC7dxCCXj2ZDBLtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8WLncrLST1ZVAbeRqt86ADbTfNC4iEYBnUTIQo3GWg=;
 b=nnuEhoRlp3SOhsH+fCf4zWjEZEHj4s+ufCECohTCnhGgy9BBAdhaPT5PMI3CfowO+9rX4sOM22EohBniuqHw+b30n1USIJ4tbtj8OpLjc9ALvIjseH6a/s3yPiIgOGi6P5Cq6o0nzuBGRn3h1vaybuzLVPGS7YvbELaXpbFMPFF1qu1w0LJ+34dBX8XRzLKHEw5hHVbB/vQFiWU56+EOb4y/tFX1DjeU14nzeceGDnA8BrgSP8SIOreGYV8F4VIDk9ToZrca/gqGbVb7MVUMmITILJToFmsfugn/eLvM1+TD4zDZmXoz4sswl22pmt0gB7dw1tcjOOncBSE3d10CTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8WLncrLST1ZVAbeRqt86ADbTfNC4iEYBnUTIQo3GWg=;
 b=GRzw4766PuMY27x0UQl+QOVXKNW9h9RxYD6tJ2K1x5LWEO8zxucWUw/wVYVID8YBakuGeCX2DYBqx41rHjxvBQt7JD5WLsmgSAQH8cF8aCODS3T61rHc9LBCDqlk2xZqqd8BUBB0lRvWCaP6zjrNwcv6Hni393nIR1E/yp6ncuY=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5017.eurprd04.prod.outlook.com (20.176.234.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 4 Dec 2019 11:36:11 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 11:36:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 3/6] can: flexcan: add low power enter/exit acknowledgment
 helper
Thread-Topic: [PATCH V3 3/6] can: flexcan: add low power enter/exit
 acknowledgment helper
Thread-Index: AQHVqpcHR75OwF+98USdput3CyLCHA==
Date:   Wed, 4 Dec 2019 11:36:11 +0000
Message-ID: <20191204113249.3381-4-qiangqing.zhang@nxp.com>
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
x-ms-office365-filtering-correlation-id: fdbad507-f5bd-4668-7f5f-08d778ae2986
x-ms-traffictypediagnostic: DB7PR04MB5017:|DB7PR04MB5017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5017BFB413E3C9771220AE35E65D0@DB7PR04MB5017.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(199004)(189003)(54534003)(3846002)(316002)(36756003)(6512007)(305945005)(2201001)(6486002)(6436002)(2906002)(7736002)(76176011)(52116002)(14444005)(71190400001)(71200400001)(110136005)(6116002)(478600001)(14454004)(81166006)(99286004)(6506007)(102836004)(26005)(25786009)(1076003)(186003)(2501003)(81156014)(2616005)(8936002)(11346002)(5660300002)(8676002)(50226002)(64756008)(4326008)(66446008)(66946007)(66556008)(66476007)(86362001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5017;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GNvo0Cyw/4ClshrkYcBCohG61NJv+YRE2vd8upe/akJpynSXGB7lztgmOb7uD7hZE6v75C1Jc7BrXel1Y3iCa2VcLDw2pkgN0JyU32bF5srUdpWSKVI8esWxA4OMKD9pW1LRmCWnPljCa55zV5WQPt++5Akm3txmuTe1m7nZPeBE9vVRFHN7jZF87WYtKwyy2qSOdtJGO1MeXn06Q5ykV/fOAus65CqiXh+KpZqgkIE2w3Yvjs2WAE9WqFGBVykowlHkbirMjlzZCmvIcm2VdXOcQMletAkMEdjkx3G/NnWmgzT+dEb8DHPIwUhmglAohWqHBdCj9Y/7h2ZVDWY2xm8pQSuqQ3UmVy9m4FsAiDxZoIEFzxyZujIlSWmcT1OxaZ2sHg0BJQlTPvDWdtsPQ9R3LMkohH2AtjpbslrZ2lEc1N7SXTJ5vOOr8EEe7aYJwlrnl5uvp0F5rzc9NYDONamC3reAFPSqSHOikQGr1v6TwPNoqj6XdlpHc+Peh2ED
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbad507-f5bd-4668-7f5f-08d778ae2986
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 11:36:11.5755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kaotf48s6qChkoEhztW91yQkQMNRc6pmWrTamU8X3lSsp43cyGukzzBMzD/qCZMgQDZaQlAj4rnCgs7zFA5o0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MCR[LPMACK] this read-only bit indicates that FlexCAN is in a
lower-power mode (Disabled mode, Doze mode, Stop mode), CPU can poll
this bit to know when FlexCAN has actually entered low power mode.
Low power enter/exit acknowledgment helper will reduce code duplication
for disabled mode, doze mode and stop mode.

Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
-----
ChangeLog:
	V3: * split from patch
	      can: flexcan: change the way of stop mode acknowledgment
---
 drivers/net/can/flexcan.c | 46 +++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 1b33936790b4..6c4f1bab7042 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -388,6 +388,34 @@ static struct flexcan_mb __iomem *flexcan_get_mb(const=
 struct flexcan_priv *priv
 		(&priv->regs->mb[bank][priv->mb_size * mb_index]);
 }
=20
+static int flexcan_low_power_enter_ack(struct flexcan_priv *priv)
+{
+	struct flexcan_regs __iomem *regs =3D priv->regs;
+	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
+
+	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		udelay(10);
+
+	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int flexcan_low_power_exit_ack(struct flexcan_priv *priv)
+{
+	struct flexcan_regs __iomem *regs =3D priv->regs;
+	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
+
+	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		udelay(10);
+
+	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
 static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enab=
le)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
@@ -505,39 +533,25 @@ static inline int flexcan_transceiver_disable(const s=
truct flexcan_priv *priv)
 static int flexcan_chip_enable(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
 	u32 reg;
=20
 	reg =3D priv->read(&regs->mcr);
 	reg &=3D ~FLEXCAN_MCR_MDIS;
 	priv->write(reg, &regs->mcr);
=20
-	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		udelay(10);
-
-	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_low_power_exit_ack(priv);
 }
=20
 static int flexcan_chip_disable(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
 	u32 reg;
=20
 	reg =3D priv->read(&regs->mcr);
 	reg |=3D FLEXCAN_MCR_MDIS;
 	priv->write(reg, &regs->mcr);
=20
-	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		udelay(10);
-
-	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_low_power_enter_ack(priv);
 }
=20
 static int flexcan_chip_freeze(struct flexcan_priv *priv)
--=20
2.17.1

