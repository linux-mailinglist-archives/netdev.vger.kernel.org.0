Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A30D0956
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfJIINJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:13:09 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:33604
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbfJIINJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 04:13:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ie+gXpu59pc5RI1PZTCcRpIgSEEQdcRV5PBh+pQSPInqhDnJ4gQBN+9stEtnzHucLed0Jeb5rvXCzr2RvF4cxmzzGxS4OXzgNSzYVHPoQtlceCfptNlcgvhBeRSiAduqLVfWx0llvrqjaLDoazlxnkuW+1yQlxmg1MafSLzF8MpWyDZWddteEXHHEtxFSSeSOf5blTWF0Z9qAaey4D3jy11/GISEyBp6nbvVsLWFHwomM/v9TNh1J0iTmzmCcx9bbn13LZpkGZAr2TLu6MjQVrxSaYXqGhl2hvD2GawOXl7QKOOjq4mcdmUKWiQZD4yLcGmW1fPGXbk7AQD+CCcNZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dE81pV3R3Gu9X4sjJO2GPXoUbqXxePTPB+Mttz3jfk=;
 b=V1asElSHcln0ck2t6rmfXLa1nfa9XmMutFVYqxEeSq7P1rYoZYLSmaBiUu7geX4N/Nk67jZR2yzDrqxGXcGBboj+mhxfrmG2Jr8+ZY4L03cZvysNNLKDfeJR3446k+Gz6w8QBeDio48iQzKGseJ1kfRP3e4l6WmJvhI6D1ctm7KA1hWi4B7Llta8iEwHBrJtUnyYXQWBMeb9ADWsZ4X38tg0ZHbot61yqL7+y9MWZvuGu+uKr2/fdbxkA0LQJ8J9jF5g7M6xlZsBsg7rFMzTorAhSneo6g23L14pomHB40Sh8jTZbL1tAJzJUuTtsiYSIUokYFM4sEwabLG/4V/pKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dE81pV3R3Gu9X4sjJO2GPXoUbqXxePTPB+Mttz3jfk=;
 b=WtkfkF17INAId/dgsfBttGo0kWhk8FIpjFPvNVpxTAoXCL0YHyMY0NhmAnkNDI512/Bf99Ah3ZZIpYNEEvgddg4//SpLdgrBOj2/zO5+qq1WXC8oVxa5XX1ApTCekTZtJ9QF6Cp1p7K6ERiEe3qOikMep8KQW8Qst/NYJZMnunE=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5081.eurprd04.prod.outlook.com (20.176.236.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 08:13:04 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679%3]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 08:13:04 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V4 1/2] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH V4 1/2] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVfnlfcicpFKT7vkKHRAXdf1SEkw==
Date:   Wed, 9 Oct 2019 08:13:04 +0000
Message-ID: <20191009080956.29128-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR06CA0108.apcprd06.prod.outlook.com
 (2603:1096:3:14::34) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c24905fd-8835-4d40-0668-08d74c908230
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DB7PR04MB5081:|DB7PR04MB5081:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB50814EA4645954CB9DF02F02E6950@DB7PR04MB5081.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(199004)(189003)(54534003)(54906003)(36756003)(6512007)(6116002)(66476007)(6486002)(26005)(7736002)(2906002)(66556008)(64756008)(66446008)(3846002)(186003)(81156014)(81166006)(99286004)(14444005)(50226002)(5024004)(2501003)(256004)(110136005)(2616005)(476003)(478600001)(486006)(8676002)(66946007)(6436002)(25786009)(305945005)(71200400001)(71190400001)(1076003)(316002)(102836004)(386003)(66066001)(5660300002)(6506007)(4326008)(14454004)(8936002)(86362001)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5081;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R/gXN3bJo8+9fvRUMZYnz6aKpB32ouyb1NS2xBxjWaw+SnmyVtPOeS4CbgmwF3gQVm+5bVYaBfkaV/2mkbdnoT/pPqybU3snezdYCY6IXFO1N2v/KbqPiXOtZsdUmoJmj6cLkh0YJkOzn8E8pavqWRTVeRoPwBU0b66LElSX1EZlyL2BjpvdGGmb3z2YhcxilPgtgxu8ryauFo6aRLbmyLHEMz4QAQpv3185S10uRXazxg9J1XYg3XSxcu5hTcp4nxUsQoSN7ma+vSvTnxNDS47iTSOBz3gE6l3o3+Xr27jmjtUcsIAUo5128Wf9JN39e82C/tn/LJWze+GCIFz5Iy7QBGy2QoTnsce12AaWJbw0BofFGpAzj5lQt+zIG5h6iLSxC919M5pLyyqyry57SfLfXwzxO584z6z7i7q33lA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c24905fd-8835-4d40-0668-08d74c908230
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 08:13:04.5178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SI3HyCBemQp2Cpy0fTwPXvab7OJYAS2LEZS3hc6zwStSDD6KDSTB8oN9CGlP1s6r0LM0cTejrJLL820v9uOnkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5081
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
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

Changelog:
V1->V2:
	* add Reported-by tag.
	* rebase on patch: can:flexcan:fix stop mode acknowledgment.
V2->V3:
	* rebase on linux-can/testing.
	* change into patch set.
V3->V4:
	* add Tested-by tag.
---
 drivers/net/can/flexcan.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 1cd5179cb876..24cc386c4bce 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -286,6 +286,7 @@ struct flexcan_priv {
 	const struct flexcan_devtype_data *devtype_data;
 	struct regulator *reg_xceiver;
 	struct flexcan_stop_mode stm;
+	bool in_stop_mode;
=20
 	/* Read and Write APIs */
 	u32 (*read)(void __iomem *addr);
@@ -1670,6 +1671,8 @@ static int __maybe_unused flexcan_suspend(struct devi=
ce *device)
 			err =3D flexcan_enter_stop_mode(priv);
 			if (err)
 				return err;
+
+			priv->in_stop_mode =3D true;
 		} else {
 			err =3D flexcan_chip_disable(priv);
 			if (err)
@@ -1696,6 +1699,15 @@ static int __maybe_unused flexcan_resume(struct devi=
ce *device)
 		netif_device_attach(dev);
 		netif_start_queue(dev);
 		if (device_may_wakeup(device)) {
+			if (priv->in_stop_mode) {
+				flexcan_enable_wakeup_irq(priv, false);
+				err =3D flexcan_exit_stop_mode(priv);
+				if (err)
+					return err;
+
+				priv->in_stop_mode =3D false;
+			}
+
 			disable_irq_wake(dev->irq);
 		} else {
 			err =3D pm_runtime_force_resume(device);
@@ -1732,6 +1744,11 @@ static int __maybe_unused flexcan_noirq_suspend(stru=
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
@@ -1744,11 +1761,17 @@ static int __maybe_unused flexcan_noirq_resume(stru=
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

