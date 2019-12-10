Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C759A1182F3
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfLJJAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:00:18 -0500
Received: from mail-eopbgr00042.outbound.protection.outlook.com ([40.107.0.42]:2742
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726932AbfLJJAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 04:00:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRbtIKMJ6UiKk7+BGk+skZIqWhvlTiBfAy7WbJvOYW3s61kXmC2XqwLF3+pwA6kIIv8agJ+Ffe9pJfKyrxBs+OAL51FZ9OVT/mvYoXxbEwvYlXKkX4evbtgCpuVqVztRDGViEUe+w36GSqPGXPpVREjSEoIeVwBAKeKagJKS8Oi5SsZuwmOgS3HJ+0Gx8mYja2dx5MchS5MwuoetECKXSxWM9t4JfAnxxF3jmiP/MIzJ/Ed06wOlQ6ovXz104/TTauD2F7+FrY7UYJPPIQHzo5qfNxFc9tUKB41muiISMYJblCSqx+yh4cvJ5PXLE5WsmG5qPM5XRFndFzf0i+9gIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQNc2/yTeHqedg9UqXUhqSygtZ03cRdJPnaypSeQUX0=;
 b=IdpIsgnWC32b/TVHn2Ck43JZncsfm9TMs3ykJHfpUYVzKczw/9ZzTJjjQvbCdCaP+sSTvWPZ033kn3LA8nfhoBA8anQTQoUZIIs48tPNoLTdCEPWmO6boF5fdE3oxFhrn0kPsbFazUMP+EfBz74/3U7vJ8WcbgjPDt1Tya6qRPBr9Rt9O0I9Kpjhe/DpshKf3rXdJYNvbQ+Pg9CJNGRQX+YIH7GLs5pocEIOPLlxpvea197URvIBd1haJF+l7zh+hgNpIlvrkv/FGwoI+ZNCRW9YBBMBvqmkn2tfkAGpLT/fDpHpt0CRfxMXxAwCuw0I/HqPzTpBNwg9DZdvcWZiJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQNc2/yTeHqedg9UqXUhqSygtZ03cRdJPnaypSeQUX0=;
 b=N3uR5zR7qJzQYX2hSmRoIfcytOMiY8RGnt8TAF6p8koxp2eJfAzKy+LtwT3zRvnTTKAWwo5GFn1D9q+4wowxB9UYpHpFpSKMX66BPRnzuIo4I//DeJHfL4Hj6mMPFpoCQr9+APJ+329u6wb+3VQy4355UqbZyyrEUzUkjQ2H67g=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4889.eurprd04.prod.outlook.com (20.176.234.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 09:00:13 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 09:00:13 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V2 2/2] can: flexcan: disable clocks during stop mode
Thread-Topic: [PATCH V2 2/2] can: flexcan: disable clocks during stop mode
Thread-Index: AQHVrzg7wjGsHNj6lEu2jaA7kUCf9w==
Date:   Tue, 10 Dec 2019 09:00:13 +0000
Message-ID: <20191210085721.9853-2-qiangqing.zhang@nxp.com>
References: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0118.apcprd02.prod.outlook.com
 (2603:1096:4:92::34) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 90c5c100-c2e3-4d39-7806-08d77d4f5e3a
x-ms-traffictypediagnostic: DB7PR04MB4889:|DB7PR04MB4889:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB488928CA4E20AA33EB480545E65B0@DB7PR04MB4889.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(199004)(189003)(54534003)(478600001)(86362001)(186003)(2616005)(2906002)(26005)(54906003)(6506007)(52116002)(8936002)(8676002)(71200400001)(71190400001)(5660300002)(110136005)(4326008)(6512007)(81156014)(81166006)(1076003)(305945005)(66446008)(66946007)(64756008)(36756003)(6486002)(316002)(66556008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4889;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4k07wRF4+YOmhdzneZvDTIAzZw1U7oxFUgXBXc3jWBHoiQ5FVvZVWTJmQfzXMn2FznE4y4hEPWs0vMXn2/QHnv4bi63/l7heQ6Zgy1qK/Wr/qbCBrROWa1QRtkWysJpN9/uRbvzx4rtlifemHVRbvftfnaseI2QFjWikVOmyxDydAHIPhop2B3ctPai/sgBh1iAfaAjSEVzcbbp6+kUVo0Zgrwr4jpDns6vzf6m0c96NA1B/uRZPsIrAz+KXd1X1h+Il3JIQFSrcYy7wgow1jrVGApr1A1fcDswuxbNYzVCw+D5J75kax32H4tOe+vbdX+MysYbNN4SZ5Fbkk4tCHafIamn5dLlYxViCV8Ozu47tDUJvhxlj+J0nLapy21+nGAQnPbR0FOGj2qkdjdzn1hbnrbwxTmmJmMjxw7qBUHvj18LpirxMLJ57zl5MLMlFMejenHzAxwzPq7+W3njioJvMdg4PvPrB+xTxN0s4SeFO83I3/1CjEA7KwoWqLUwy
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c5c100-c2e3-4d39-7806-08d77d4f5e3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 09:00:13.5221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HJpKrnkgM2z7n7yOAnbgaZYeQpEdBVbHBIEcxuChrjicu+ois5gP9dGVpc2k6eduaecrZBOhRqPFCv66qfkjTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4889
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable clocks during CAN in stop mode.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
------
ChangeLog:
	V1->V2: * moving the pm_runtime_force_suspend() call for both
	cases "device_may_wakeup()" and "!device_may_wakeup()" into the
	flexcan_noirq_suspend() handler
---
 drivers/net/can/flexcan.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 6c1ccf9f6c08..63b2f47635cf 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1718,10 +1718,6 @@ static int __maybe_unused flexcan_suspend(struct dev=
ice *device)
 			if (err)
 				return err;
=20
-			err =3D pm_runtime_force_suspend(device);
-			if (err)
-				return err;
-
 			err =3D pinctrl_pm_select_sleep_state(device);
 			if (err)
 				return err;
@@ -1751,10 +1747,6 @@ static int __maybe_unused flexcan_resume(struct devi=
ce *device)
 			if (err)
 				return err;
=20
-			err =3D pm_runtime_force_resume(device);
-			if (err)
-				return err;
-
 			err =3D flexcan_chip_start(dev);
 			if (err)
 				return err;
@@ -1786,9 +1778,16 @@ static int __maybe_unused flexcan_noirq_suspend(stru=
ct device *device)
 {
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
+	int err;
=20
-	if (netif_running(dev) && device_may_wakeup(device))
-		flexcan_enable_wakeup_irq(priv, true);
+	if (netif_running(dev)) {
+		if (device_may_wakeup(device))
+			flexcan_enable_wakeup_irq(priv, true);
+
+		err =3D pm_runtime_force_suspend(device);
+		if (err)
+			return err;
+	}
=20
 	return 0;
 }
@@ -1799,11 +1798,18 @@ static int __maybe_unused flexcan_noirq_resume(stru=
ct device *device)
 	struct flexcan_priv *priv =3D netdev_priv(dev);
 	int err;
=20
-	if (netif_running(dev) && device_may_wakeup(device)) {
-		flexcan_enable_wakeup_irq(priv, false);
-		err =3D flexcan_exit_stop_mode(priv);
+	if (netif_running(dev)) {
+		err =3D pm_runtime_force_resume(device);
 		if (err)
 			return err;
+
+		if (device_may_wakeup(device)) {
+			flexcan_enable_wakeup_irq(priv, false);
+
+			err =3D flexcan_exit_stop_mode(priv);
+			if (err)
+				return err;
+		}
 	}
=20
 	return 0;
--=20
2.17.1

