Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED8979EED
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 04:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbfG3Cvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 22:51:36 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:4231
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731382AbfG3Cvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 22:51:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqHUqMn6DKH2rN7JP/knjG5J5vKt3AHEifR7D3Uz97Yc6Aspq6blkvQhREndsip+ajKWOYz+oZDZjoP31f9JaFsfpuEWhPAkBwtSa+Gx8mVPMmJl6ZASYuOpurnyft1UomtSQ5lBrnqXyFLiti85t6xa0biMloCDxu/kKrsVr/1sROQYImOj6Nu82tcONdRn08Pg/bKiqlV4Lc3k9/BsggbMju23lpQ5MGjl70ES+m5gmJUyBBYtmiZlwEdBq8VDk6/TmKELoJQ/vgCPaikKDWIu+aCm0LGuclveRZ+rv3saPz38qLu19cSEFf4/nIdk6kMCSSBWJtVJYDR85FsJNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EuUS8vSYz9AEn3QxEUQ6xu1QBGPdZc1zIu0wrgDo0Vg=;
 b=E77s7KVZdw6khVONJT+3+zxmPxD4rugIcdmb8dA5DYnN6zV5Dq5R4GjYBUkXzCFkHSnwqlgG+GpGhJBuJwAVWn7HAscpQBnQtS9VPljpetk454j99jC5/rSsHG0KqIZtOZLRRWPOV6XlfDO+a3wh2D64SnD2bOQdbwAl4n2ykCwc4JpHdrt7HqW/2Iy+zMeb8HG6SwYR8savPXPr1oZ45Gyqy6AkVnnwJOWAYQHpFwkYyIUfoKYpxNjo6jRyDBPKA8vf0XZH77/UzdDjYwnmWFxVBbWdZ/ZnmOsortLuaktQEVInZyscfyiXWpBfP4szEDti46N7ySxtLOiF0TRhFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EuUS8vSYz9AEn3QxEUQ6xu1QBGPdZc1zIu0wrgDo0Vg=;
 b=Ooadfo2azKpL0L2fhPAR+IVraCqPjH16vYYAN6R2Eo1XEIbNF5MFmCn0mVeTLuj+V7MvJtnH69wHONc8qN4eOM4Ju67TF1/jLTz3GzAuKm3PwFoISf3vsxkntFjCUDDzZTsNg83Vc0t86Ev1aY068vz6mUje7PlOj5S+1rd2R3I=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5450.eurprd04.prod.outlook.com (20.178.105.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 30 Jul 2019 02:51:30 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 02:51:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V2] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH V2] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVRoGwsLQOjsyzvkSdF4oGtikKDg==
Date:   Tue, 30 Jul 2019 02:51:30 +0000
Message-ID: <20190730024834.31182-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR06CA0210.apcprd06.prod.outlook.com
 (2603:1096:4:68::18) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 533a2171-45fd-493b-eb6b-08d71498d2ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5450;
x-ms-traffictypediagnostic: DB7PR04MB5450:
x-microsoft-antispam-prvs: <DB7PR04MB5450A55C843FDA1BA5FA3BE3E6DC0@DB7PR04MB5450.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(199004)(189003)(54534003)(5024004)(14444005)(256004)(66446008)(6512007)(50226002)(64756008)(81166006)(81156014)(8676002)(66946007)(66556008)(66476007)(316002)(110136005)(54906003)(5660300002)(8936002)(14454004)(53936002)(71200400001)(478600001)(305945005)(2906002)(86362001)(1076003)(25786009)(7736002)(71190400001)(4326008)(386003)(26005)(66066001)(6486002)(3846002)(6506007)(486006)(2616005)(476003)(68736007)(102836004)(186003)(99286004)(2201001)(52116002)(36756003)(2501003)(6116002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5450;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vJzYic87quyS6A1ySudui5INhcuUN8wiB6Ntx4xesUzGu3N+aLu3WQ9YgUVQkiYYWmb3Qq4L4QWgRvGEGiewECL32EVLCYuBEk8LLiaUonVYcCh1Ljjd7dpIIwqRkRrO4XQ++DdJqqH+qEljagvT2vzsZ98Bjytipv03EIbw4jUWf98ztvkgSATHZuYT/hEbj6fgpkVgm3eKYQffDARMQR2OAxK06ySEiwX0h/7obmqz0ZnlIzVy52QB1vmmUIPi6MjnEhO0gr1Rs7Z9kQW1Lz2E9vb7TUW++9UT2tGepHL9kvFAW8KeasXUX/CFyOM3WD4CKOtR9F9h0eiqr48Fozdlr6V65U8ifkY6T9w/EKg0zt4rX9Ky5EnrtmVoLF5UlaJbaPUBWlc5mUZvx/AybNDwGIwZ8peb7GPtGo8lDqo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 533a2171-45fd-493b-eb6b-08d71498d2ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 02:51:30.0715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reproted by Sean Nyekjaer below:
When suspending, when there is still can traffic on the interfaces the
flexcan immediately wakes the platform again. As it should :-). But it
throws this error msg:
[ 3169.378661] PM: noirq suspend of devices failed

On the way down to suspend the interface that throws the error message does
call flexcan_suspend but fails to call flexcan_noirq_suspend. That means th=
e
flexcan_enter_stop_mode is called, but on the way out of suspend the driver
only calls flexcan_resume and skips flexcan_noirq_resume, thus it doesn't c=
all
flexcan_exit_stop_mode. This leaves the flexcan in stop mode, and with the
current driver it can't recover from this even with a soft reboot, it requi=
res
a hard reboot.

The best way to exit stop mode is in Wake Up interrupt context, and then
suspend() and resume() functions can be symmetric. However, stop mode
request and ack will be controlled by SCU(System Control Unit) firmware(man=
age
clock,power,stop mode, etc. by Cortex-M4 core) in coming i.MX8(QM/QXP). And=
 SCU
firmware interface can't be available in interrupt context.

For compatibillity, the wake up mechanism can't be symmetric, so we need
in_stop_mode hack.

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Reported-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

Changelog:
V1->V2:
	* add Reported-by tag.
	* rebase on patch: can:flexcan:fix stop mode acknowledgment.
---
 drivers/net/can/flexcan.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index fcec8bcb53d6..1dbec868d3ea 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -282,6 +282,7 @@ struct flexcan_priv {
 	const struct flexcan_devtype_data *devtype_data;
 	struct regulator *reg_xceiver;
 	struct flexcan_stop_mode stm;
+	bool in_stop_mode;
=20
 	/* Read and Write APIs */
 	u32 (*read)(void __iomem *addr);
@@ -1635,6 +1636,8 @@ static int __maybe_unused flexcan_suspend(struct devi=
ce *device)
 			err =3D flexcan_enter_stop_mode(priv);
 			if (err)
 				return err;
+
+			priv->in_stop_mode =3D true;
 		} else {
 			err =3D flexcan_chip_disable(priv);
 			if (err)
@@ -1659,6 +1662,15 @@ static int __maybe_unused flexcan_resume(struct devi=
ce *device)
 		netif_device_attach(dev);
 		netif_start_queue(dev);
 		if (device_may_wakeup(device)) {
+			if (priv->in_stop_mode) {
+				flexcan_enable_wakeup_irq(priv, false);
+				err =3D flexcan_exit_stop_mode(priv);
+				if (err)
+					return  err;
+
+				priv->in_stop_mode =3D false;
+			}
+
 			disable_irq_wake(dev->irq);
 		} else {
 			err =3D flexcan_chip_enable(priv);
@@ -1674,6 +1686,11 @@ static int __maybe_unused flexcan_noirq_suspend(stru=
ct device *device)
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
=20
+	/* Need to enable wakeup interrupt in noirq suspend stage. Otherwise,
+	 * it will trigger continuously wakeup interrupt if the wakeup event
+	 * comes before noirq suspend stage, and simultaneously it has enter
+	 * the stop mode.
+	 */
 	if (netif_running(dev) && device_may_wakeup(device))
 		flexcan_enable_wakeup_irq(priv, true);
=20
@@ -1686,11 +1703,17 @@ static int __maybe_unused flexcan_noirq_resume(stru=
ct device *device)
 	struct flexcan_priv *priv =3D netdev_priv(dev);
 	int err;
=20
+	/* Need to exit stop mode in noirq resume stage. Otherwise, it will
+	 * trigger continuously wakeup interrupt if the wakeup event comes,
+	 * and simultaneously it has still in stop mode.
+	 */
 	if (netif_running(dev) && device_may_wakeup(device)) {
 		flexcan_enable_wakeup_irq(priv, false);
 		err =3D flexcan_exit_stop_mode(priv);
 		if (err)
 			return err;
+
+		priv->in_stop_mode =3D false;
 	}
=20
 	return 0;
--=20
2.17.1

