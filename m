Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69F8112A48
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfLDLgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:36:18 -0500
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:18334
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727445AbfLDLgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 06:36:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8l7an6V3PcZ0z2XeNFEqO9JuJtAipTLyFhyM1T1IilMkG1/OcCyIIJZAAy34wzw1n9SKXgZQVf48FPme2ufJLTSS3Ng4G0V3P77sKc5YeUP+FdKg/MEIfyuTrOyi1EEP9THT3YqDHGeT9fFsOuJAk2wbSteoJVZQeIFwixZ2dF+Z8jR3jaO6D3bDaD0LKDUV6BNTR8FMNvK1NSmSOyFgvsaH2ChYQLNxedy+5tgbjTf0+Po0y1JXg3yMbk806GzQ0Om4ojr0z801/5ZFaOTXUXqC0o1ei8XrlLk3YcpKiUxy91Ymxx2dCef3tnv2PceV4oVS+CvBRSWPIkHFvKi3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7ISVul/o9CR4dR5H+9o+prKC73Vd99rn1OnqYASlLw=;
 b=gM5mTN1ra4dYE0NHR0apOvSqJtKBRilVRm0xCAf5kqZiIxYAKcY6NaJ+uN6f707oSt/wQiFtWPqGU6UyYOBUvp3G5QtueU70YPkL0GKN4HE0PnAWhoI4visOR97uzCMAUlBq3N6qLwFtxUCIkkT017kdy2MLTIb5nR7fvDtcAijadZzXsgVtd0VM1Vj9VTM6NfLBsVFf4P52Ye4VDdXD/OFMAPwypo2yfjhz3MR7yd7j8+U4bMqF6WwB/8reliEt3fjolwUx+vUFkAMMMGh4aoiDQPSWT/oxg3wIj2vZNGBQAxaaZh+7DcwyX+IhNHx+ERTUYReAFzqt6Uw0lFkAiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7ISVul/o9CR4dR5H+9o+prKC73Vd99rn1OnqYASlLw=;
 b=lgnJd0Cdgv2fudWZBHtmn6NGQUt+5/kXK8BLuGGOEGTOfgokWodWaGnbt1Pm6I/F/YW6Y3EVrxt1fMrGx4bahCs0aBco4wTB/gLwmTg2o7wlx3o54/a3TbnP44NlPIalyCJFzSDaSeTkHZ/3H5c40dnCNkicr3iMVFnXkuGo9tk=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5017.eurprd04.prod.outlook.com (20.176.234.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 4 Dec 2019 11:36:14 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 11:36:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 4/6] can: flexcan: change the way of stop mode
 acknowledgment
Thread-Topic: [PATCH V3 4/6] can: flexcan: change the way of stop mode
 acknowledgment
Thread-Index: AQHVqpcIngbCJ2t1fEG3I5GEii2gNw==
Date:   Wed, 4 Dec 2019 11:36:14 +0000
Message-ID: <20191204113249.3381-5-qiangqing.zhang@nxp.com>
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
x-ms-office365-filtering-correlation-id: ef47086d-e0eb-456a-3762-08d778ae2b14
x-ms-traffictypediagnostic: DB7PR04MB5017:|DB7PR04MB5017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5017148E1864FE81B7C8F4AFE65D0@DB7PR04MB5017.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(199004)(189003)(54534003)(3846002)(316002)(36756003)(6512007)(305945005)(2201001)(6486002)(6436002)(2906002)(7736002)(76176011)(52116002)(14444005)(71190400001)(71200400001)(110136005)(6116002)(478600001)(14454004)(81166006)(99286004)(6506007)(102836004)(26005)(25786009)(1076003)(186003)(2501003)(81156014)(2616005)(8936002)(11346002)(5660300002)(8676002)(50226002)(64756008)(4326008)(66446008)(66946007)(66556008)(66476007)(86362001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5017;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hcq4iYmO8rJM4XwYovMZSe0SUZsPNkDD+QISHP0dn22jYKyFlhqQ3e4PQgZnwrKmJ4zcMZPMef3Rl8ffVyLvY4C1hvBmcZaaBUYrtnZvkRrjUbggIWw4FKNuK9TFdA0lAAT+2n+YrIh7igmc4s86hsHS7zLsyjdAY+TWxR26YFFVKjAh+sIZE6xchvoi9fcGhC69uhGLwhW2oy6VDU0Ayn90SYmHlQy3vTBtINWflLYb3Pr2xkFx/sQJuwmU0ipWHN0JY/b6dpuhJ8VA6ruw5yEpgjj3Y7CYVKKpU7/SKmyUJoJAJaDDyaJ3e5QCwMDKRPwv5VrR3KHFTgrpKdg8CbPQAbyWyv582lE/9jZZ96Gq01BieSnYtZvtAKIpZuHPDnOoh4W2aRqoPZG9cEUnB7ctu90tkqkKPkR18ifbDw/DIEDKZRqwV8B1Xh0ixc0M5xRffw4gVjcTYG9r9XgTspb/tQe2vX2QnwoNwVNypwS9Eovc62tReNXIRSCfTfWv
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef47086d-e0eb-456a-3762-08d778ae2b14
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 11:36:14.5668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6T2G74nEhcsnXyFy5xMBenK1jcfuqHFzQzqo/hnUfNyDXsbAwyqgTfY8GvEH1klLjS9WIN5raRUFlDhYBorsFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop mode is entered when Stop mode is requested at chip level and
MCR[LPM_ACK] is asserted by the FlexCAN.

Double check with IP owner, should poll MCR[LPM_ACK] for stop mode
acknowledgment, not the acknowledgment from chip level which is used
to gate flexcan clocks.

Fixes: 5f186c257fa4 (can: flexcan: fix stop mode acknowledgment)
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
-----
ChangeLog:
	V1->V2: * no change.

	V2->V3: * spilt the patch.
---
 drivers/net/can/flexcan.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 6c4f1bab7042..19602b77907f 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -434,7 +434,6 @@ static void flexcan_enable_wakeup_irq(struct flexcan_pr=
iv *priv, bool enable)
 static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	unsigned int ackval;
 	u32 reg_mcr;
=20
 	reg_mcr =3D priv->read(&regs->mcr);
@@ -445,36 +444,24 @@ static inline int flexcan_enter_stop_mode(struct flex=
can_priv *priv)
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
=20
-	/* get stop acknowledgment */
-	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
-				     ackval, ackval & (1 << priv->stm.ack_bit),
-				     0, FLEXCAN_TIMEOUT_US))
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_low_power_enter_ack(priv);
 }
=20
 static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	unsigned int ackval;
 	u32 reg_mcr;
=20
 	/* remove stop request */
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 0);
=20
-	/* get stop acknowledgment */
-	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
-				     ackval, !(ackval & (1 << priv->stm.ack_bit)),
-				     0, FLEXCAN_TIMEOUT_US))
-		return -ETIMEDOUT;
=20
 	reg_mcr =3D priv->read(&regs->mcr);
 	reg_mcr &=3D ~FLEXCAN_MCR_SLF_WAK;
 	priv->write(reg_mcr, &regs->mcr);
=20
-	return 0;
+	return flexcan_low_power_exit_ack(priv);
 }
=20
 static inline void flexcan_error_irq_enable(const struct flexcan_priv *pri=
v)
--=20
2.17.1

