Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9238FDA4
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfHPIUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:20:46 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:64417
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726575AbfHPIUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:20:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0NSGdCRI1KNV6MrqA2PnycTl7osuAzXxbkQAFosmHE4kHU9EjypVzr9FWGIy079aVy2hiNEG5MC4psNA2qnCV9oRo5upykilfP+LUAIbTKSXuwddLsq3i2my1qzo1TbIM6jCfCBj6iYCkcNivZHRFGI6U7eXVZ99udX4hQcrx2WSCJnsG0Mk52nfmLtylAJO//rR2sRGXN/LqVTIhwGglZwu5keM1K5DK4H0mUrge2nlXbxfyIlId8TZKcaTgoQcCWELBEacoweNl6ju+8THtSXNq3svFspdZU70VePKIbKxEVqZjlbUKJeg7x6kmLFSlUDNcsfT0reH+ckgbZkyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9HuMiq6xawKA3fG8w4OuGQ7rvPOsNH9uadTNL9R38A=;
 b=CV2NM+lRc+f6QauNE19wDJrCacBQer3K8+WDEXLVm5lldO8X+jAbkfJy+y7+7YD5hdYL4lCXwQXqQXzr1PWRz24YNRg8efbBknpFIBH56oeeOjXmf055yUKVhlVEZlnhCRCgjNQrolxjtJ6gAmVDa84x/bepkvoRYfN0RSVKQPuTJr8gaNRMr3w7xh9yf2ZmkTIs6ceqqSWgLPojf455mFGctlEvOFepEJ2oTSbNH8Ed9Ykd84+FzZU4PGw2T4rn9ABt3lFb8UUqp34xBWk4xZdQECiFG6tFL4UdA3NfPgLwZBSGxGDdSxZisaAPJtYudP6tU92z50KLDkvwwkmR8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9HuMiq6xawKA3fG8w4OuGQ7rvPOsNH9uadTNL9R38A=;
 b=MUllGdH+GdAM0IHLAJTEA7f6m1Q8w5sjJ+1EQ6kh77g+TWaa9164j/V4dqGe3QG1kRW55LJ7GQUhSFcSAweQjxCL5NBNS6wMrm8P3Cmc8CpxJdY3WPyflzTBmN2f87iOg/mcRs6jXx6hvfidnQgAMpVTwjAuC2mEbmp7xjxGfi0=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5419.eurprd04.prod.outlook.com (20.178.104.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Fri, 16 Aug 2019 08:20:42 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f%4]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 08:20:42 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self
 wakeup
Thread-Index: AQHVVAt+uezYlHzMP0yJKoK3YxkiSw==
Date:   Fri, 16 Aug 2019 08:20:41 +0000
Message-ID: <20190816081749.19300-2-qiangqing.zhang@nxp.com>
References: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR0401CA0004.apcprd04.prod.outlook.com
 (2603:1096:3:1::14) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0910c42-ff7f-44c2-16d3-08d72222a0bf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB5419;
x-ms-traffictypediagnostic: DB7PR04MB5419:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5419C5C3FD3A7BB75983ADB7E6AF0@DB7PR04MB5419.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(39840400004)(136003)(54534003)(199004)(189003)(5660300002)(478600001)(6512007)(110136005)(4326008)(25786009)(54906003)(81166006)(76176011)(2906002)(81156014)(53936002)(8676002)(316002)(1076003)(186003)(3846002)(99286004)(11346002)(66946007)(14454004)(26005)(86362001)(2501003)(52116002)(6436002)(476003)(50226002)(6486002)(2616005)(386003)(446003)(66556008)(66066001)(256004)(5024004)(6506007)(14444005)(486006)(36756003)(66476007)(6116002)(71190400001)(71200400001)(305945005)(102836004)(64756008)(66446008)(8936002)(2201001)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5419;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tIlWyI62I62AY1/r9C5JUJZsf8kmI7fmN0mXWEVkjFJiY25v05FqajWKvMqQ2HOh56TdCqPLi/sMSGVKEMoDlvbhSk3AYn5URVxD37l1GeuzRJeTjwFKdYycA6LTWOFqnTtQSanTgWtKYzFiWy/h6EZPhM5ZgAiuNba092pKu6Cczcq04/lRpGQ6dtE3SHvCcQYg2XWxxSAex1u5bkppqUtX4cQBe+dQEDEiWIsNHYcl+DhbI1Ghwbc/1DLTbowlOX7dGuv+zQDFeZG9vQJRevWQpvStQCrEA4dV/Y2PrU6YxRBMCQ8DFf5tVY/VhZTrQEkkErVvZQN/WAUiVcd4SqKKd+Fk933RkK2srpRr/aGkKnaMaTtDSUTrHTE6SlLXdM6Nuu+eU/m2nHlgNYNVR8ZNEyKtoiAAz/YIySzlbDM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0910c42-ff7f-44c2-16d3-08d72222a0bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 08:20:41.9433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UduRH0YkLIJ/0dQm/KbX7pai6a5sxtJjsiaFaalrLgGJw9HlrXLLx8F7j9O3EYGEFFS/AtZJro7O6/ti0jtBbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5419
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
V2->V3:
	* move into a patch set.
---
 drivers/net/can/flexcan.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 56fa98d7aa90..de2bf71b335b 100644
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
@@ -1636,6 +1637,8 @@ static int __maybe_unused flexcan_suspend(struct devi=
ce *device)
 			err =3D flexcan_enter_stop_mode(priv);
 			if (err)
 				return err;
+
+			priv->in_stop_mode =3D true;
 		} else {
 			err =3D flexcan_chip_disable(priv);
 			if (err)
@@ -1660,6 +1663,15 @@ static int __maybe_unused flexcan_resume(struct devi=
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
@@ -1675,6 +1687,11 @@ static int __maybe_unused flexcan_noirq_suspend(stru=
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
@@ -1687,11 +1704,17 @@ static int __maybe_unused flexcan_noirq_resume(stru=
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

