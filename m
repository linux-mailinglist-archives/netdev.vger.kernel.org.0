Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6752C118134
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfLJHQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:16:04 -0500
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:7745
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727310AbfLJHQE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 02:16:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZy8VkD9CpKL2SQwBjtSWDtsDf0st6MRtovdCMyoN39rZdqHrOzWSOm64J0FbTlXzIhn8KVUXEjWWAso+vPgI6Sqpafjc6tzbeiEQt/YGpYbASAz9TheIXZ192oUeD3yQLf5O+u4/NM1xRqFBqXMWboAyKwHwsFyV/k3Clf6Z4bWXMVbF3szoWnOPVUS3GB61nksqKYLL5/wz9Ew8IWTRjn09v9AuT4u5G4OGy61RADjVVnZLS2SktOM8jO+tLdevpW3+2rxvVeGZU9ABsM3UYDh8gs6tjqgyC3ZkCyHGLeGxTyXzHJbPXtvwoaLLuCbzVaexuU/nuClLYSovioIOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hCsKBTeJFpRYrdI5bnGhLN6ZDzIecpys/r2IbDeSfHM=;
 b=Q2uY4lJ0O6QoOchOyPVy0RM63VsCqzqSMHL7U8Z7xtXiBMWp3nWnTiFp8HlxxBKfB533k4Ki0ySCnga89IU7OGCtV+YZPrAaxiFAz98KFGGPKTq5V1x6/NpV4Yn54ZeDyCxC3nuPKAtM3v2tbH/rDlqyVwjBiBX5eLIQGYbdQMsJZO/HeqsguBB0ZRY4swteiEpLEuoPkMJXZc1eIvbBQOqgYuaOXu25T3qNxlt7IkKyM+wGMRxuD61gxrAL+PjvuWYCapmjOMrtQGglyfjKbXLzBTDaPjbfL/pAsuGD+UjVNDCLICK8dH0x+IgUg3/gbLZkNqEb/uVWP9P/luv6xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hCsKBTeJFpRYrdI5bnGhLN6ZDzIecpys/r2IbDeSfHM=;
 b=Eadb6yTQse9P9VWStBBNntawucOnZHPMLA+qHXch+97B8ZBFabsjR3mNqcumYsvxJSWYD0L3ctMdyhXWX8Ie7aqmxmJLLAQO0GkM7fEaBcLMQdKuWkOS1SL61p5BuFFy2vMV8zL4usDJgJLdALSoi3xQHLfkYNGyLBHfR5W469s=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5340.eurprd04.prod.outlook.com (52.135.131.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 07:16:01 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 07:16:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 2/2] can: flexcan: disable clocks during stop mode
Thread-Topic: [PATCH 2/2] can: flexcan: disable clocks during stop mode
Thread-Index: AQHVrymtB+TSUJwNhE6xk7ucZQ3eCw==
Date:   Tue, 10 Dec 2019 07:16:00 +0000
Message-ID: <20191210071252.26165-2-qiangqing.zhang@nxp.com>
References: <20191210071252.26165-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191210071252.26165-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0119.apcprd02.prod.outlook.com
 (2603:1096:4:92::35) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 517aaf1a-5019-4704-aed6-08d77d40cf5d
x-ms-traffictypediagnostic: DB7PR04MB5340:|DB7PR04MB5340:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5340283A5D25F3817351FFDCE65B0@DB7PR04MB5340.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(189003)(199004)(5660300002)(8936002)(6512007)(186003)(81166006)(81156014)(2906002)(8676002)(71200400001)(26005)(54906003)(52116002)(316002)(71190400001)(4326008)(305945005)(86362001)(66446008)(66556008)(66476007)(478600001)(110136005)(64756008)(66946007)(6486002)(36756003)(6506007)(2616005)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5340;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ftuM5RPWNzJ4tqHOiBF/ShB4EaofBg+pDyBRmMapti5TireXIfDLy+eTnTf5WUDLxSD9KzP7u17+Lrc+K1mPx+3glO9AjIH5szCOtsetmQQib83oNPujmh3A0Y+BvlhcG+QPIKTQf1J4QWXOhsitd+Up6F7hacgJ2nslZv2XLDYeX6YEUVq4Mq+wFjN1ZK8YhSAuAcYu+RG+hZrlSZl2ZVdDIuUc2307gSHp0uwGXuhTZV4h/g2GlXFJWUY6tqhXuJnRnK5N3rFdSv33rT8Z04eX/G9E7x0WAmXUAYbMPdJzcXprrcFspDne8ZY5Z6kzJiAfz9bUKG+jrfUPq83fVnEGWyPge6GDd5mjJgbs9uWlNTp5/AnT7M5uL6HXybKcKMH8TmXEtL4ylfTyZJ34MUFWiKF3N4xCXNVp2J98371n1ptYHfVk+VtXtaltY3eD
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 517aaf1a-5019-4704-aed6-08d77d40cf5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 07:16:00.9495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 07Fmnbz74u3L/83Yl4PPXfsKkuAYMGmSW2xTkH7zvN5uvRZYh639I6+ZRzBaYipIiMBXMsZr/rZS0r2RCB3Zdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5340
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable clocks during CAN in stop mode.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 6c1ccf9f6c08..d767f85c80d3 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1786,10 +1786,16 @@ static int __maybe_unused flexcan_noirq_suspend(str=
uct device *device)
 {
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
+	int err;
=20
-	if (netif_running(dev) && device_may_wakeup(device))
+	if (netif_running(dev) && device_may_wakeup(device)) {
 		flexcan_enable_wakeup_irq(priv, true);
=20
+		err =3D pm_runtime_force_suspend(device);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
=20
@@ -1800,7 +1806,12 @@ static int __maybe_unused flexcan_noirq_resume(struc=
t device *device)
 	int err;
=20
 	if (netif_running(dev) && device_may_wakeup(device)) {
+		err =3D pm_runtime_force_resume(device);
+		if (err)
+			return err;
+
 		flexcan_enable_wakeup_irq(priv, false);
+
 		err =3D flexcan_exit_stop_mode(priv);
 		if (err)
 			return err;
--=20
2.17.1

