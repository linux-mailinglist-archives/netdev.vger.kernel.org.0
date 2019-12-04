Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69754112A42
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfLDLgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:36:11 -0500
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:18334
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727472AbfLDLgK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 06:36:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKJYgexbCob+0YIPg/Zw76CQpbfSjOqC+kPOGUMQjVLR7iZpkaxgKi1suRFkAF+sbuE7HRJT+GIyhePj/GilL44Zt5ipeFmkbzuL72vXfv8XzOje1HnKXPK9bMfFPlRVD+HK1yXAQLzDuiydKIxWqNIvRLPMsZwynprc9HMJGW0A9y/KsuKeMuYOkk6S+JIWFK9sN0t9hj5oe1vM0nHd4XTvPN7ZHxjvJ85B0d/p2EX2xnn9LrLqzQJh0CZjP9MCVVtZQxpIK9QN8cMCH19h4jkG+2F61lm0vL97Ogl8Xzak4I3Ce3dgVJYwI1VcNArJUDwP4+g7TxW31U1KVqxBWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIDqyzvAHYJshpec/3W8eFMZH9gPnN9yHqy84Z8doQ0=;
 b=Hl3k0bXdirlM8HHMIEqQ+5w7utC45yeHQjgZrOj3agbHo4MA5z+dFkBFtEonI5l016o4VVXALJVO07efpP9KMPnEA+BaIFKndAYUIhcw3xB1prsVKbcX2ZX9ytzBiW6QAAaX9yJwP9jv79LNdaAIv2tNK3sqKNM1CUHWA4Z8eWWq/IRF6/hdA+E31f58G0iyUSUxDvfYTuJhcMYgyfRYaRqhBCabqPf/tN/tT9CGMqINLPMxlYIZKNoKuJGAqsDHV9diFNHHhO2uwregZ1Kl8LQxGwaUmbqSWrR3o3KoyDkc1w/dghwhXNEeeZrtIuIGeytfmzYB+ykQFITAA+b51Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIDqyzvAHYJshpec/3W8eFMZH9gPnN9yHqy84Z8doQ0=;
 b=I+6TpkHd0vLfuWTjCuqInz9hprU384oYJO1c5u9OaRStyns0Zpx5smm7vvPNq1w4NuTYwecqFE9EoiDMuAg62rdSRFc7BL1eqDjFRfJTiTV51uTrcvw7eso+WvWPMHg44RQjlRm6GCLtOkNfF7Yu6doetWQVfJhzsAJJxs67fBc=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5017.eurprd04.prod.outlook.com (20.176.234.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 4 Dec 2019 11:36:06 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 11:36:06 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 1/6] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH V3 1/6] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVqpcEJjZ5iRmVok+AlRWKu7CINQ==
Date:   Wed, 4 Dec 2019 11:36:06 +0000
Message-ID: <20191204113249.3381-2-qiangqing.zhang@nxp.com>
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
x-ms-office365-filtering-correlation-id: a653847b-0bde-439e-b28e-08d778ae2682
x-ms-traffictypediagnostic: DB7PR04MB5017:|DB7PR04MB5017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5017BD58B8AE0E92AB8E40C6E65D0@DB7PR04MB5017.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(199004)(189003)(54534003)(3846002)(316002)(36756003)(6512007)(305945005)(2201001)(6486002)(6436002)(2906002)(7736002)(76176011)(52116002)(14444005)(71190400001)(71200400001)(110136005)(6116002)(478600001)(14454004)(81166006)(99286004)(6506007)(102836004)(26005)(25786009)(1076003)(186003)(2501003)(81156014)(2616005)(8936002)(11346002)(5660300002)(8676002)(50226002)(64756008)(4326008)(66446008)(66946007)(66556008)(66476007)(86362001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5017;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yb3LP3L7VvWJlhW210ry0UC8nJM/62GCfjVPqcXXPxdtLKyf06Kej7NrvjUIwYW+HFbprt9EciKU4LbMvkttkgEi6EL+t+VmxItdF807xtCo6NL1zaBKUe9cQjYmldNqWYNtEBL1362v380YUJoJhYYeF6sYKp0aEty1qO8adp/emB/FMqSV1i8pgn9DAIfQsqmsmkTCIrm4FudOwBk4ln7oV68UbdIO1UKK3XF7xMpImKF4uqKN0nWWKKHc/zwOUWL/rNNf9aGK5u1fjKYUEYFbC+m0fk8aHB4gaDdTTy0N8bCv+Yb5T4c/nHKwk9hkoydU9RAVGMJipnyYno19s99HQk9P148ceQYPLiirruxd+KqrUQZmrGVrzwGlJwYFHXQXmNH3WjkWEwbg1fNsMmIWWODJoQ7/2wDQaITXx4wPvFV6m6aP7WgYUK65fnUgSiA1dOT84PU2VMg5a+mSl+0Kljv2pFA8pJqNvPwzZTWZB5KeuNCxWZTFTqafsNoL
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a653847b-0bde-439e-b28e-08d778ae2682
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 11:36:06.4105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j5s1LmEdsXneJtKuotEYMOJds5SA0OEitRTaoi9huLWo8H1i01ynlTc1D2e6hOCGtcXsSg3/9cXYZmOhcvI0YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

When suspending, when there is still can traffic on the interfaces the
flexcan immediately wakes the platform again. As it should :-). But it
throws this error msg:
[ 3169.378661] PM: noirq suspend of devices failed

On the way down to suspend the interface that throws the error message does
call flexcan_suspend but fails to call flexcan_noirq_suspend. That means
flexcan_enter_stop_mode is called, but on the way out of suspend the driver
only calls flexcan_resume and skips flexcan_noirq_resume, thus it doesn't
call flexcan_exit_stop_mode. This leaves the flexcan in stop mode, and with
the current driver it can't recover from this even with a soft reboot, it
requires a hard reboot.

This patch can fix deadlock when using self wakeup, it happenes to be
able to fix another issue that frames out-of-order in first IRQ handler
run after wakeup.

In wakeup case, after system resume, frames received out-of-order in
first IRQ handler, the problem is wakeup latency from frame reception to
IRQ handler is much bigger than the counter overflow. This means it's
impossible to sort the CAN frames by timestamp. The reason is that controll=
er
exits stop mode during noirq resume, then it can receive the frame immediat=
ely.
If noirq reusme stage consumes much time, it will extend interrupt response
time. So exit stop mode during resume stage instead of noirq resume can
fix this issue.

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
------
ChangeLog:
	V1->V2: *no change.

	V2->V3: *split wakeup interrupt ack into another patch.
---
 drivers/net/can/flexcan.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 2efa06119f68..99aae90c1cdd 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1722,6 +1722,9 @@ static int __maybe_unused flexcan_resume(struct devic=
e *device)
 		netif_start_queue(dev);
 		if (device_may_wakeup(device)) {
 			disable_irq_wake(dev->irq);
+			err =3D flexcan_exit_stop_mode(priv);
+			if (err)
+				return err;
 		} else {
 			err =3D pm_runtime_force_resume(device);
 			if (err)
@@ -1767,14 +1770,9 @@ static int __maybe_unused flexcan_noirq_resume(struc=
t device *device)
 {
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
-	int err;
=20
-	if (netif_running(dev) && device_may_wakeup(device)) {
+	if (netif_running(dev) && device_may_wakeup(device))
 		flexcan_enable_wakeup_irq(priv, false);
-		err =3D flexcan_exit_stop_mode(priv);
-		if (err)
-			return err;
-	}
=20
 	return 0;
 }
--=20
2.17.1

