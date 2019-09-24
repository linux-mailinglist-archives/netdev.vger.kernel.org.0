Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D745ABD209
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441780AbfIXSqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:46:19 -0400
Received: from mail-eopbgr150119.outbound.protection.outlook.com ([40.107.15.119]:15758
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438841AbfIXSqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 14:46:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xr58hEOA3hcqcqyQzu01N7GiwuN1KtdZ73ohYor7HkExLWqC0qNupeOZ7xMhKszNlIz80gOAlN6zFaIwM/e4JuJMucvjP+YSKSQn1NKUaK4zcWrd1BE0f7x27/5XLL5QGsItRW45wRQK9QWgcIYu8USjHX0dN7J04TyRvuo7dTQIjz5SYHKjNkT9Ztlip5JIk11l34B/WY7HZpDVlF9toYP0jyXtdvAOf4+NgorAOSvuBg1UjB7s+0MmTgITygPorg3IE3/CTZSrA/NtL8S1vUwrOdC0ILGGMA8FPDWVcAVu+nuBa1VZRlVxhV1covBGHSSW+STgWGt+wJqgLQTblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32A7pqEDEpriMYXunNW4JBMuRUTi1WeK4aZszaTdwTg=;
 b=KmYRm79XoFcgoNdabm2hoenmtEMK4qE5fgDELm9l2+oP5YHV458tEAMFoZS/WAH+1ddWT1Wg+qovg1THsW9MqtbHsPcgSB1Y0EfkiJ/lnvBHti9S1L6u8yWKRdmE/k6wISrilg5Zjd31XrPWfopAIYdoAN/BqK+80lWxXrJXd9oa+QRXbeWa/vpgoCS93wxvXO5ftIYoOPY99NblIV7uIuf+WP12CzZB1DRHcuH3sTm0hBGqsSimd1Z0Kwu8Sz8BmYbVtCRKoTapEOtGIy+RyIF10+r4k4IhmqfyX2aukdMHFzuLBUx867msntV5Rqn7+RtkYWfyPYdX0F9H3+XjqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32A7pqEDEpriMYXunNW4JBMuRUTi1WeK4aZszaTdwTg=;
 b=L4aLh9zlEeKdCymdxSL1rhjqPaO2TPTpihEvlv71e6/lH4VzCzR9SeQZdtHX0u2Fp3q16H7Bj65KLh+VXFT9Rg6tfyM36mAQcppBagLcU4O2z2ww2oIK7eABROjQBMW8XPV4bog8Od1GDNqOW5DGbKfRq0T8DveK8xm7BzHigW0=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2847.eurprd07.prod.outlook.com (10.173.70.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Tue, 24 Sep 2019 18:46:03 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.013; Tue, 24 Sep 2019
 18:46:03 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] can: ti_hecc: properly report state changes
Thread-Topic: [PATCH 6/7] can: ti_hecc: properly report state changes
Thread-Index: AQHVcwhRQgRPuUbjUUCuWVJXGpb8wA==
Date:   Tue, 24 Sep 2019 18:46:03 +0000
Message-ID: <20190924184437.10607-7-jhofstee@victronenergy.com>
References: <20190924184437.10607-1-jhofstee@victronenergy.com>
In-Reply-To: <20190924184437.10607-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:1c01:3bc5:4e00:c415:8ca2:43df:451e]
x-clientproxiedby: AM0PR01CA0137.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::42) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3a99525-6286-42f2-6008-08d7411f7391
x-ms-traffictypediagnostic: VI1PR0701MB2847:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB28471E2A989540DAF0E52BD5C0840@VI1PR0701MB2847.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:53;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(39850400004)(346002)(136003)(396003)(189003)(199004)(81156014)(86362001)(2906002)(2351001)(14454004)(305945005)(478600001)(8676002)(2501003)(36756003)(7736002)(6116002)(25786009)(8936002)(50226002)(81166006)(46003)(76176011)(11346002)(66476007)(6506007)(6916009)(446003)(102836004)(186003)(2616005)(1076003)(6486002)(66946007)(64756008)(486006)(476003)(66556008)(66446008)(5660300002)(54906003)(71200400001)(71190400001)(14444005)(5640700003)(6436002)(52116002)(386003)(4326008)(256004)(316002)(99286004)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2847;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MGlGi9/d2vlSi9oCtrJSTskQZj7xn7AMuwcoJhJvKN80qt/yCcv2Pxl1MPRXaoSX4IqfhALEOui3M1SHUwm1EEN6Av/D79PBF7k6Zw3dpcmYJH49bT27f6+EpdajgHGy7e78VBZPrJB5g9eueLlg13l/wan9l8aL4V0c40pjaGkk+rYwOdEiU9hVqKcuInuxnWKyTYSDCegZfaFl0ACecqyFsEv5z4K/qiuEefN2D9VU2kn0RFDifQbd9hqQlcsordwnYSRi9g2vjE8JQbzwPP/5sCHOqc0wokYD5V4F9ZLsCqQXpehOLL1QtMFZSdIRLzRjEz8KOKssTol1rc+gWpR0uOZryeKenJOJ7Ri5lY5rkFiOd4y2DZo8SG11Az9KgJm9pULIa4D6715MEPExqUCp38KGHQVbPu+tn2RKgR8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a99525-6286-42f2-6008-08d7411f7391
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 18:46:03.7262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tsi20SdldCvaVPjzbXjw/rkLup54J0IHf61kGhHQ3YAHwTLsyrJVsbRvAIj5X1Yk648sbUxseA9eVhI8r0z5DKcpxsxDxwfsAeEP1ra/RAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2847
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HECC_CANES register handles the flags specially, it only updates
the flags after a one is written to them. Since the interrupt for
frame errors is not enabled an old error can hence been seen when a
state interrupt arrives. For example if the device is not connected
to the CAN-bus the error warning interrupt will have HECC_CANES
indicating there is no ack. The error passive interrupt thereafter
will have HECC_CANES flagging that there is a warning level. And if
thereafter there is a message successfully send HECC_CANES points to
an error passive event, while in reality it became error warning
again. In summary, the state is not always reported correctly.

So handle the state changes and frame errors separately. The state
changes are now based on the interrupt flags and handled directly
when they occur. The reporting of the frame errors is still done as
before, as a side effect of another interrupt.

note: the hecc_clear_bit will do a read, modify, write. So it will
not only clear the bit, but also reset all other bits being set as
a side affect, hence it is replaced with only clearing the flags.

note: The HECC_CANMC_CCR is no longer cleared in the state change
interrupt, it is completely unrelated.

And use net_ratelimit to make checkpatch happy.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/ti_hecc.c | 156 ++++++++++++++++++++------------------
 1 file changed, 82 insertions(+), 74 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 4206ad5cb666..6098725bfdea 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -149,6 +149,8 @@ MODULE_VERSION(HECC_MODULE_VERSION);
 #define HECC_BUS_ERROR		(HECC_CANES_FE | HECC_CANES_BE |\
 				HECC_CANES_CRCE | HECC_CANES_SE |\
 				HECC_CANES_ACKE)
+#define HECC_CANES_FLAGS	(HECC_BUS_ERROR | HECC_CANES_BO |\
+				HECC_CANES_EP | HECC_CANES_EW)
=20
 #define HECC_CANMCF_RTR		BIT(4)	/* Remote transmit request */
=20
@@ -578,91 +580,63 @@ static int ti_hecc_error(struct net_device *ndev, int=
 int_status,
 	struct sk_buff *skb;
 	u32 timestamp;
=20
-	/* propagate the error condition to the can stack */
-	skb =3D alloc_can_err_skb(ndev, &cf);
-	if (!skb) {
-		if (printk_ratelimit())
-			netdev_err(priv->ndev,
-				   "%s: alloc_can_err_skb() failed\n",
-				   __func__);
-		return -ENOMEM;
-	}
-
-	if (int_status & HECC_CANGIF_WLIF) { /* warning level int */
-		if ((int_status & HECC_CANGIF_BOIF) =3D=3D 0) {
-			priv->can.state =3D CAN_STATE_ERROR_WARNING;
-			++priv->can.can_stats.error_warning;
-			cf->can_id |=3D CAN_ERR_CRTL;
-			if (hecc_read(priv, HECC_CANTEC) > 96)
-				cf->data[1] |=3D CAN_ERR_CRTL_TX_WARNING;
-			if (hecc_read(priv, HECC_CANREC) > 96)
-				cf->data[1] |=3D CAN_ERR_CRTL_RX_WARNING;
-		}
-		hecc_set_bit(priv, HECC_CANES, HECC_CANES_EW);
-		netdev_dbg(priv->ndev, "Error Warning interrupt\n");
-		hecc_clear_bit(priv, HECC_CANMC, HECC_CANMC_CCR);
-	}
-
-	if (int_status & HECC_CANGIF_EPIF) { /* error passive int */
-		if ((int_status & HECC_CANGIF_BOIF) =3D=3D 0) {
-			priv->can.state =3D CAN_STATE_ERROR_PASSIVE;
-			++priv->can.can_stats.error_passive;
-			cf->can_id |=3D CAN_ERR_CRTL;
-			if (hecc_read(priv, HECC_CANTEC) > 127)
-				cf->data[1] |=3D CAN_ERR_CRTL_TX_PASSIVE;
-			if (hecc_read(priv, HECC_CANREC) > 127)
-				cf->data[1] |=3D CAN_ERR_CRTL_RX_PASSIVE;
+	if (err_status & HECC_BUS_ERROR) {
+		/* propagate the error condition to the can stack */
+		skb =3D alloc_can_err_skb(ndev, &cf);
+		if (!skb) {
+			if (net_ratelimit())
+				netdev_err(priv->ndev,
+					   "%s: alloc_can_err_skb() failed\n",
+					   __func__);
+			return -ENOMEM;
 		}
-		hecc_set_bit(priv, HECC_CANES, HECC_CANES_EP);
-		netdev_dbg(priv->ndev, "Error passive interrupt\n");
-		hecc_clear_bit(priv, HECC_CANMC, HECC_CANMC_CCR);
-	}
-
-	/* Need to check busoff condition in error status register too to
-	 * ensure warning interrupts don't hog the system
-	 */
-	if ((int_status & HECC_CANGIF_BOIF) || (err_status & HECC_CANES_BO)) {
-		priv->can.state =3D CAN_STATE_BUS_OFF;
-		cf->can_id |=3D CAN_ERR_BUSOFF;
-		hecc_set_bit(priv, HECC_CANES, HECC_CANES_BO);
-		hecc_clear_bit(priv, HECC_CANMC, HECC_CANMC_CCR);
-		/* Disable all interrupts in bus-off to avoid int hog */
-		hecc_write(priv, HECC_CANGIM, 0);
-		++priv->can.can_stats.bus_off;
-		can_bus_off(ndev);
-	}
=20
-	if (err_status & HECC_BUS_ERROR) {
 		++priv->can.can_stats.bus_error;
 		cf->can_id |=3D CAN_ERR_BUSERROR | CAN_ERR_PROT;
-		if (err_status & HECC_CANES_FE) {
-			hecc_set_bit(priv, HECC_CANES, HECC_CANES_FE);
+		if (err_status & HECC_CANES_FE)
 			cf->data[2] |=3D CAN_ERR_PROT_FORM;
-		}
-		if (err_status & HECC_CANES_BE) {
-			hecc_set_bit(priv, HECC_CANES, HECC_CANES_BE);
+		if (err_status & HECC_CANES_BE)
 			cf->data[2] |=3D CAN_ERR_PROT_BIT;
-		}
-		if (err_status & HECC_CANES_SE) {
-			hecc_set_bit(priv, HECC_CANES, HECC_CANES_SE);
+		if (err_status & HECC_CANES_SE)
 			cf->data[2] |=3D CAN_ERR_PROT_STUFF;
-		}
-		if (err_status & HECC_CANES_CRCE) {
-			hecc_set_bit(priv, HECC_CANES, HECC_CANES_CRCE);
+		if (err_status & HECC_CANES_CRCE)
 			cf->data[3] =3D CAN_ERR_PROT_LOC_CRC_SEQ;
-		}
-		if (err_status & HECC_CANES_ACKE) {
-			hecc_set_bit(priv, HECC_CANES, HECC_CANES_ACKE);
+		if (err_status & HECC_CANES_ACKE)
 			cf->data[3] =3D CAN_ERR_PROT_LOC_ACK;
-		}
+
+		timestamp =3D hecc_read(priv, HECC_CANLNT);
+		can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
 	}
=20
-	timestamp =3D hecc_read(priv, HECC_CANLNT);
-	can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	hecc_write(priv, HECC_CANES, HECC_CANES_FLAGS);
=20
 	return 0;
 }
=20
+static void change_state(struct ti_hecc_priv *priv, enum can_state rx_stat=
e,
+			 enum can_state tx_state)
+{
+	struct can_frame *cf;
+	struct sk_buff *skb;
+	u32 timestamp;
+
+	skb =3D alloc_can_err_skb(priv->ndev, &cf);
+	if (unlikely(!skb)) {
+		priv->can.state =3D max(tx_state, rx_state);
+		return;
+	}
+
+	can_change_state(priv->ndev, cf, tx_state, rx_state);
+
+	if (max(tx_state, rx_state) !=3D CAN_STATE_BUS_OFF) {
+		cf->data[6] =3D hecc_read(priv, HECC_CANTEC);
+		cf->data[7] =3D hecc_read(priv, HECC_CANREC);
+	}
+
+	timestamp =3D hecc_read(priv, HECC_CANLNT);
+	can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+}
+
 static irqreturn_t ti_hecc_interrupt(int irq, void *dev_id)
 {
 	struct net_device *ndev =3D (struct net_device *)dev_id;
@@ -670,6 +644,7 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev=
_id)
 	struct net_device_stats *stats =3D &ndev->stats;
 	u32 mbxno, mbx_mask, int_status, err_status, stamp;
 	unsigned long flags, rx_pending;
+	u32 handled =3D 0;
=20
 	int_status =3D hecc_read(priv,
 			       priv->use_hecc1int ?
@@ -679,10 +654,43 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *d=
ev_id)
 		return IRQ_NONE;
=20
 	err_status =3D hecc_read(priv, HECC_CANES);
-	if (err_status & (HECC_BUS_ERROR | HECC_CANES_BO |
-			  HECC_CANES_EP | HECC_CANES_EW))
+	if (unlikely(err_status & HECC_CANES_FLAGS))
 		ti_hecc_error(ndev, int_status, err_status);
=20
+	if (unlikely(int_status & HECC_CANGIM_DEF_MASK)) {
+		enum can_state rx_state, tx_state;
+		u32 rec =3D hecc_read(priv, HECC_CANREC);
+		u32 tec =3D hecc_read(priv, HECC_CANTEC);
+
+		if (int_status & HECC_CANGIF_WLIF) {
+			handled |=3D HECC_CANGIF_WLIF;
+			rx_state =3D rec >=3D tec ? CAN_STATE_ERROR_WARNING : 0;
+			tx_state =3D rec <=3D tec ? CAN_STATE_ERROR_WARNING : 0;
+			netdev_dbg(priv->ndev, "Error Warning interrupt\n");
+			change_state(priv, rx_state, tx_state);
+		}
+
+		if (int_status & HECC_CANGIF_EPIF) {
+			handled |=3D HECC_CANGIF_EPIF;
+			rx_state =3D rec >=3D tec ? CAN_STATE_ERROR_PASSIVE : 0;
+			tx_state =3D rec <=3D tec ? CAN_STATE_ERROR_PASSIVE : 0;
+			netdev_dbg(priv->ndev, "Error passive interrupt\n");
+			change_state(priv, rx_state, tx_state);
+		}
+
+		if (int_status & HECC_CANGIF_BOIF) {
+			handled |=3D HECC_CANGIF_BOIF;
+			rx_state =3D CAN_STATE_BUS_OFF;
+			tx_state =3D CAN_STATE_BUS_OFF;
+			netdev_dbg(priv->ndev, "Bus off interrupt\n");
+
+			/* Disable all interrupts */
+			hecc_write(priv, HECC_CANGIM, 0);
+			can_bus_off(ndev);
+			change_state(priv, rx_state, tx_state);
+		}
+	}
+
 	if (int_status & HECC_CANGIF_GMIF) {
 		while (priv->tx_tail - priv->tx_head > 0) {
 			mbxno =3D get_tx_tail_mb(priv);
@@ -718,10 +726,10 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *d=
ev_id)
=20
 	/* clear all interrupt conditions - read back to avoid spurious ints */
 	if (priv->use_hecc1int) {
-		hecc_write(priv, HECC_CANGIF1, HECC_SET_REG);
+		hecc_write(priv, HECC_CANGIF1, handled);
 		int_status =3D hecc_read(priv, HECC_CANGIF1);
 	} else {
-		hecc_write(priv, HECC_CANGIF0, HECC_SET_REG);
+		hecc_write(priv, HECC_CANGIF0, handled);
 		int_status =3D hecc_read(priv, HECC_CANGIF0);
 	}
=20
--=20
2.17.1

