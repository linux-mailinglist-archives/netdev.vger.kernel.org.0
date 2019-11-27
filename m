Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0688C10AA71
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfK0F4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:56:53 -0500
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:58850
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfK0F4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 00:56:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=feFjjLFMuW1UtBWUOzNCqJr5enbuR2SbDBhy6Yh+elkgh+A83Ug2OR4t6TqkA5Vxbm0AUJAzfo2lU+c0oPHzVDvf99YMIZucMBd0aN0lFLt2xEk4pkt53rjGqN4W3YU4v0bcZOifhZcuhN6GfyAEqv/cG2RdrQEhGIXiUI6+sMSxc0baaibDdTnYkTtBsBjWoUtKrYKd8lAZ5jdYbw7jD6I6Sons24JPGGN6gja+SKdDN1namLuAE3/qJBoAue2yhNGkrlOSIbGdmdxSjyzXroQkGqcKuGjPU8JPJR1GQhTCNtOYjJ36xxcVMionsaoQovJn/DSzAZiZq2v6UnEoGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nUEN8e+VlyozKZZx7C/VE/xSaWP4hQdi5iKQ4l9kqk=;
 b=cV4QPg8TfEeSp02c9lZGS63FGMLj61oyuymvY3z8JX0BWnXuAue4PAkQ4xC2jUw6hT9XJkSfkd/8MhtjbBWDUvtj4DAy/p5fvKWUHyA7HgGSLzVNK34YJ+m6YeHt4qLgHMLnoKmT3tn68wp+B4g6g1QmTQXMV5t9q4DU4iG1spNPjb4E0oHJ19idVEzZyu5s9/fIlET8WzIJKv68wCP7UVTqe2GZ+l2lS2cgV6ByJ7zSlYU/opUWVTzEE6N1qQ3wpjTXbTmdiNuKZA+cd4+0VL1biLaxN9M/z6XmDR07HNsyf0ea7fAAnk9OfxMbyySwRIf1bhSk3ZANUE5RQWTv/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nUEN8e+VlyozKZZx7C/VE/xSaWP4hQdi5iKQ4l9kqk=;
 b=eHZkB8hjSaKUvO3bCGg3UfnqmyeFU4F3DJul5gMc39yhEXxmv5qQ2du0QR5bZ3xnByxw/OWhfGn3Plveqhs6Cc/N1sq5L9Vt/AwEgK39yeHZKVutA5q4KrgS5ManY68cOAyI+QQORRAwawqksuwCqf6EZgK92+Vyx9kRKifFuV4=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4409.eurprd04.prod.outlook.com (52.135.137.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.17; Wed, 27 Nov 2019 05:56:47 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 05:56:47 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe stage
Thread-Topic: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Index: AQHVpOd0/zAyRBOEIkuRK6cuc/m3Pg==
Date:   Wed, 27 Nov 2019 05:56:47 +0000
Message-ID: <20191127055334.1476-3-qiangqing.zhang@nxp.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR03CA0089.apcprd03.prod.outlook.com
 (2603:1096:4:7c::17) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8f8fb5d8-f6a0-440a-399d-08d772fe96f2
x-ms-traffictypediagnostic: DB7PR04MB4409:|DB7PR04MB4409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4409D2C6D3D05EC4F9E5B4E0E6440@DB7PR04MB4409.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(54534003)(199004)(189003)(26005)(36756003)(110136005)(316002)(386003)(2906002)(66066001)(25786009)(446003)(50226002)(8676002)(2616005)(81156014)(8936002)(11346002)(2501003)(66476007)(64756008)(66556008)(66446008)(99286004)(14454004)(256004)(14444005)(7736002)(52116002)(76176011)(1076003)(4326008)(66946007)(102836004)(2201001)(3846002)(478600001)(86362001)(5660300002)(81166006)(305945005)(6436002)(6116002)(71200400001)(71190400001)(186003)(54906003)(6506007)(6486002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4409;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OSKJ5/bE4XQa+y582K9plk9At7pCfAblKTV5edhhywlAXdgJ3vV1n17tB8Wgxb6/snU8Io1MUYJY3jOFO2mNo4Fu7fHW4qsnfUWMVBE68qjfq/nenhoKHsGt+I2t0vYFr127HQ6FCkTDOVM8go+5LY5b6DRN129JbauzPilRKzIBeCwLKCijeRnVZuzGpGHo1I7P3nmW8PgK3acvpi++KT3H2uzcEC709H75mDsn2npX0KrnoyPM6r3pIltBY70UJm31NkhODNtWx7VrhY645EW3di1ZmxAudgueGLx/ByEK1DGVFnpMqvHe2QdkJWtXzYjyO6b311RixTzoKRZevObknrD7xE1R0/8D/DkmEmqGbUmnmFp+heYrOQ0fM0SeslcLvr/c4w818jGC72JhOyzPnJRPuEz9/eyRDGwx7pv7JF4fF0NOm4+JhTkZ+jEm
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8fb5d8-f6a0-440a-399d-08d772fe96f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 05:56:47.7640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aUHb35FE1kodg0nfhz6M43KrNV/zwghLkGAODAzCpzDbVGyZ17QULC7SNCgyyIvGNCz6fiYzfczB7B/1ACnWPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4409
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CAN controller could be stucked in stop mode once it enters stop mode
when suspend, and then it fails to exit stop mode when resume. Only code
reset can get CAN out of stop mode, so add stop mode remove request
during probe stage for other methods(soft reset from chip level,
unbind/bind driver, etc) to let CAN active again. MCR[LPMACK] will be
checked when enable CAN in register_flexcandev().

Suggested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
------
ChangeLog:
	V1->V2: new add.
---
 drivers/net/can/flexcan.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 2297663cacb2..5d5ed28d3005 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -449,6 +449,13 @@ static inline int flexcan_exit_stop_mode(struct flexca=
n_priv *priv)
 	return 0;
 }
=20
+static void flexcan_try_exit_stop_mode(struct flexcan_priv *priv)
+{
+	/* remove stop request */
+	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
+			   1 << priv->stm.req_bit, 0);
+}
+
 static inline void flexcan_error_irq_enable(const struct flexcan_priv *pri=
v)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
@@ -1649,6 +1656,21 @@ static int flexcan_probe(struct platform_device *pde=
v)
 	priv->devtype_data =3D devtype_data;
 	priv->reg_xceiver =3D reg_xceiver;
=20
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE) {
+		err =3D flexcan_setup_stop_mode(pdev);
+		if (err)
+			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
+
+		/* CAN controller could be stucked in stop mode once it enters
+		 * stop mode when suspend, and then it fails to exit stop
+		 * mode when resume. Only code reset can get CAN out of stop
+		 * mode, so add stop mode remove request here for other methods
+		 * (soft reset, bind, etc) to let CAN active again. MCR[LPMACK]
+		 * will be checked when enable CAN in register_flexcandev().
+		 */
+		flexcan_try_exit_stop_mode(priv);
+	}
+
 	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
@@ -1661,12 +1683,6 @@ static int flexcan_probe(struct platform_device *pde=
v)
=20
 	devm_can_led_init(dev);
=20
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE) {
-		err =3D flexcan_setup_stop_mode(pdev);
-		if (err)
-			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
-	}
-
 	return 0;
=20
  failed_register:
--=20
2.17.1

