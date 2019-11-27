Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B6810AA6F
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfK0F4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:56:51 -0500
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:58850
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726092AbfK0F4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 00:56:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dA0PnZhT0KbKCPJv/GOCFPREjnSYT5w9AwxEWlglf5skruGR7leBSl8bJG3jep5tRnLgyEAHqVcu7kKNogQcNqtWPeLyGhawiHSAlgnN2RNjO0Szh9ofCfndVbGpIE1kcBuM2azX2dZD8hTsa7cPTUFdQU7d+Gf6JPSjQ5v8agWsyELju2NCibsxGVgNsJYisbL26Z98/+e2kQNyuc69Q9RluDmYN8P4IwVTi0AYDw6AuBZOmWZiPA7hnBEQM20VBfI66SCwFnktzfH/hUUUqDD/bdNnz72GnOkTqFZSdtuHcTdUlWQj5j2r+G3Gg0QnM/YHoLT3gFSQI4U8dOZK1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHsJCwqcu9hmiODUA51jX69Ub7oY6XfhYMvofqmBDck=;
 b=N1kHl3XMqRCX7vO3YVrSEG74xWTXpRL7kLz7HKDsbviDl6ijozQbNNl1orH+WFTw4FGyVNxwp6Ocd/ch2WNnL0ausR4izbFMhWazxwsD96PqRmZ7Az8eSPVPoADo1OYVLlA27E11+Be6kpG6/YHIcNjSyD3nRWmpwGbGszFzMjvPd2/Ql7TXl08GU7pN3OhqKZh66eV8SzpE1zRSfoxs8SoagcSbChFMsKxduUY2iVbNsYdBCz48lkC36DsPBwyuAcRUNTNvgy11mxyj1l3jfounqR0BmIgRNHesb5VGVl75oEafXZ1MHA8EMigpECJyW1JCaPHFC54i3Y8/O3ra0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHsJCwqcu9hmiODUA51jX69Ub7oY6XfhYMvofqmBDck=;
 b=IO5+RMB1rAoCZBz5jevxsjSOH48bbm+sA/1a333VKrLCNJESd3qE5SlN9RRvC8zoggdIMj8WAyqgqe5NpA6qiURVs0koYQ3A0PyN2uNNTqCsl2e42DmpQLA9B9Ec9FXbCM2M2x762ux8BODsRsLJzvDT9LyLyv8eNn84B9g5qdU=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4409.eurprd04.prod.outlook.com (52.135.137.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.17; Wed, 27 Nov 2019 05:56:45 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 05:56:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V2 1/4] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH V2 1/4] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVpOdz4P6zsP3HCk29mcugpy847Q==
Date:   Wed, 27 Nov 2019 05:56:45 +0000
Message-ID: <20191127055334.1476-2-qiangqing.zhang@nxp.com>
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
x-ms-office365-filtering-correlation-id: bd4ea9a9-0b40-4cc8-1ab5-08d772fe956e
x-ms-traffictypediagnostic: DB7PR04MB4409:|DB7PR04MB4409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4409DC64FBADE7EE8DE09B31E6440@DB7PR04MB4409.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(54534003)(199004)(189003)(26005)(36756003)(110136005)(316002)(386003)(2906002)(66066001)(25786009)(446003)(50226002)(8676002)(2616005)(81156014)(8936002)(11346002)(2501003)(66476007)(64756008)(66556008)(66446008)(99286004)(14454004)(256004)(14444005)(7736002)(52116002)(76176011)(1076003)(4326008)(66946007)(102836004)(2201001)(3846002)(478600001)(86362001)(5660300002)(81166006)(305945005)(6436002)(6116002)(71200400001)(71190400001)(186003)(54906003)(6506007)(6486002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4409;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mv+od0IybI80vK0GcpDbLkHNVL5GkpF2hIRAaCrK0YaIZgrdhflrR0xjtvk1qHprIRJHSmkLwHNYFTv9InQaMsrPUWdOlmjPwt8kQcTTYWMnbQOkvhXu9g4SBnPvNVsv3tRQK3AL2VzYJ4FTLfmiQHhcr/pcHwFWWm/HG6TjAoJP246Zs6p4taECXe93ddOhko0YkZtnQ3a515tsFPh+nKFKT1RCXmr7mcCx4xIabo7TIPO2J3y4LKwN+iQObYshNYT7VZ2dAEMhyhRksb7ABsppkJQpIJiOp315Jxi8ZPrXCoG+iH394kMb/Tto5RkfzLI+bbQ4FM3GmiKYJPlFxfhBWrjieuugSpZqvj4AmBY562aFVYfF0OZjlpJr0R2NOPg1XREcXQMX5G0KSJNRX7xiJC8Wxxp9+DapqhFs+tSiRDsQsRYUYobS46oqf0Zi
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4ea9a9-0b40-4cc8-1ab5-08d772fe956e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 05:56:45.2254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /lmSf+FdtdVibgS4r9l8suUqvShFATqo1m6xC9znXVTO7cVxBOY1puWUWMs1XGQpqMNw6FSVyBoRzSLE48FEkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4409
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
call flexcan_suspend but fails to call flexcan_noirq_suspend. That means th=
e
flexcan_enter_stop_mode is called, but on the way out of suspend the driver
only calls flexcan_resume and skips flexcan_noirq_resume, thus it doesn't c=
all
flexcan_exit_stop_mode. This leaves the flexcan in stop mode, and with the
current driver it can't recover from this even with a soft reboot, it requi=
res
a hard reboot.

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
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
------
ChangeLog:
	V1->V2: no change.
---
 drivers/net/can/flexcan.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 2efa06119f68..2297663cacb2 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -134,8 +134,7 @@
 	(FLEXCAN_ESR_ERR_BUS | FLEXCAN_ESR_ERR_STATE)
 #define FLEXCAN_ESR_ALL_INT \
 	(FLEXCAN_ESR_TWRN_INT | FLEXCAN_ESR_RWRN_INT | \
-	 FLEXCAN_ESR_BOFF_INT | FLEXCAN_ESR_ERR_INT | \
-	 FLEXCAN_ESR_WAK_INT)
+	 FLEXCAN_ESR_BOFF_INT | FLEXCAN_ESR_ERR_INT)
=20
 /* FLEXCAN interrupt flag register (IFLAG) bits */
 /* Errata ERR005829 step7: Reserve first valid MB */
@@ -960,6 +959,12 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
=20
 	reg_esr =3D priv->read(&regs->esr);
=20
+	/* ACK wakeup interrupt */
+	if (reg_esr & FLEXCAN_ESR_WAK_INT) {
+		handled =3D IRQ_HANDLED;
+		priv->write(reg_esr & FLEXCAN_ESR_WAK_INT, &regs->esr);
+	}
+
 	/* ACK all bus error and state change IRQ sources */
 	if (reg_esr & FLEXCAN_ESR_ALL_INT) {
 		handled =3D IRQ_HANDLED;
@@ -1722,6 +1727,9 @@ static int __maybe_unused flexcan_resume(struct devic=
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
@@ -1767,14 +1775,9 @@ static int __maybe_unused flexcan_noirq_resume(struc=
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

