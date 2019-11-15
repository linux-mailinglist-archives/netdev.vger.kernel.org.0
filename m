Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD681FD3DC
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfKOFDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:03:30 -0500
Received: from mail-eopbgr30079.outbound.protection.outlook.com ([40.107.3.79]:7650
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbfKOFD3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 00:03:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YY2MTCtysI5wq9xKUN3Fk36SAk/muWWuH/plNU7vhRUiRViGqknPeAYVslszE43DpZcBqKDTfN8Zm2cP8XMEuZ2DDI6tDTD4uciMefF8066p7VgPlKS3c0YFaTrbgVv1Wk0yrSoOV8zt8ga9P8Oq8e8AsJk0Rv26Gj3S0xtcJqvVzHcVyS7rW/cXgCzApbZhKAJcpeYdLXVPdkeJj8TgzvuwcyGyU9LwKhp1C8j5FUM6X2/ZAoAyblMapuLVTW+lfaYYMKdXY+sw0XBzVp5oku2fycMcsWF5B4RFdD37s3yJAczjzUwuL9VvEsx40BAU2Q8hz4k/ZKhsCxlt+vGQpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEd1Sj3Rd0n6Pp+0IUHTFXYetP0rBPQtuNIalU9l81k=;
 b=OXjEesYIZZtQA65HhrSan0uLOnZv8MsCe9KED5Js0HxO7oo6pUNMuBQ+BpL9KvBWlyIraNvU11MNfTCPn1qEIUerhlJBGWq+G0Oh2L+hzwDLBeOcUTq9nTmbIBPhk/h21tYekco1bCkpeKDhw9WTGRXszpsgYgLXTcWVq5I9AOKpCFzbXCcIxvsGpOXSGEf6iMIrTD5Kr6y/0YElO6gVm0lKX3w9XtPjzxhXWB/bQbH0pwBdBHMFTN7HlqpzzUIFVfyvcVZjZH4SJWLN+JewXF6rBxvDkCSgJB0bmjg59j4xcQxA741NnWmfzXWk6R1VtR3znxJAVJl7MF0f/bIdqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEd1Sj3Rd0n6Pp+0IUHTFXYetP0rBPQtuNIalU9l81k=;
 b=m0SLsGc1wEkRu3PAhoh85bTgQG7yoRBFmtbzFPbNEKvmWPxVHvxzjIT59SKQt938yR7lG4nskTw4Q9H1tJsO61tYmmQJbAsicJmZEq/N8oEhV/P55HxEjs9OlsdvSdub4hLqw0zyDs1sVSwM/p6VvQXPFe8NYDZGFZ0epAYzaU8=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Fri, 15 Nov 2019 05:03:26 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2451.029; Fri, 15 Nov 2019
 05:03:26 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVm3IDm0rriooN3k2DjIsf/kbhcA==
Date:   Fri, 15 Nov 2019 05:03:26 +0000
Message-ID: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR06CA0143.apcprd06.prod.outlook.com
 (2603:1096:1:1f::21) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 028f6dae-a349-42a3-71e3-08d7698925ab
x-ms-traffictypediagnostic: DB7PR04MB4620:|DB7PR04MB4620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB462021E34634F15ECCF8D469E6700@DB7PR04MB4620.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(199004)(189003)(52116002)(316002)(305945005)(110136005)(8936002)(66066001)(478600001)(64756008)(66556008)(71190400001)(66946007)(66476007)(50226002)(256004)(66446008)(8676002)(6506007)(36756003)(3846002)(6116002)(14454004)(102836004)(54906003)(26005)(14444005)(71200400001)(2906002)(81156014)(81166006)(386003)(25786009)(99286004)(7736002)(186003)(2501003)(5660300002)(486006)(1076003)(2201001)(6486002)(86362001)(476003)(2616005)(6512007)(6436002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4620;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lAPGa+bmRJ/UFv8r84MBOkNydTxj88dHbIwuDRgpgaxSmn8rJUAx3Fsih7RfC2EjTw95AByDxSLXf9SrisXiFnp/mW0cYCww5nIex9VrlnCsCoc5XnWAFLkeqsUpLzMJz6MLOaN5iWsK3rWAaEIz3gN6lwPjE139OyUm00kuWqgq/hIdwwlwor+YgkKaTCVdv8zuXugekWcdc2TbOfKCbh4HxxX3P+xrZZ9RuKPgQbly5tLmz4xTZ7p/cPcEkEqzG/vhVAcz5BS6A1CudwFKvkOiC9Itdm2O5f7Q4A0u7U8YvWOn1E4KoY2nZtdkdny/QstxGjeg/SLIs0DUBhjOcfD/wsd5/dpdJVDYYtcyxIW55gD+RdBdAG26w85BoVGWMqhiZHiw5DxnuNQYxR8QIXOkMc/Wt0+zHKmzksXGCv4S5VpFAykTO/s3oSfI2bT1
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028f6dae-a349-42a3-71e3-08d7698925ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 05:03:26.1972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35GphiRYUNl5dmhyQy0KQVxHxe9wbQkqxRp/meWwu7FnFrDYZz9yLz6QtUisoV0D6pGB/uDLuRG0OtOa0ZoVfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4620
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

In wakeup case, after system resume, frames received out-of-order,the
problem is wakeup latency from frame reception to IRQ handler is much
bigger than the counter overflow. This means it's impossible to sort the
CAN frames by timestamp. The reason is that controller exits stop mode
during noirq resume, then it can receive the frame immediately. If
noirq reusme stage consumes much time, it will extend interrupt response
time.

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index a929cdda9ab2..43fd187768f1 100644
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

