Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D7D112A44
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfLDLgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:36:13 -0500
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:18334
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727445AbfLDLgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 06:36:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2u2KZ9afFTBP3k+0VEEm2VCvBT9q1Ge0wrz+1fG14TsKFI8UeWpRequeryZpA2d7+1Zgn7AVopRQa667j59s6JMcE9nBSIsTIwKNHHFee7gvpQP1OAiz+LGDw7oytqyvX98aBir+5sQhSO+vqeSXQDg5d/fdKpUxZWw8//4SOQIGZatWAobLOfOfgj6DPDxP8J1RP3V5XojSojq+Uvo2gDx9DsXT1SKdhvL91RC6WS6LGTQAaxErDt9K8KPez8ma7zs+z5jo+AEfAFOO5AAKGtTyM+KtbSx6Dhc4BjJ0iNUh8ZXlq10yPylg1emaPGsnSHtiP0s1YaGe5jIHemIxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4UXzmpMbENryqTOlPJTFIsvOycKxgQxAMqKQHOlzf8=;
 b=JvsyiQV2aQbw0gubKrextop8JxTVmpIurfUszApAeqfA6ae1i6C9FC/hUbw0d+Txf2x/0sjZreb5NUZnWMkfTPleKwmVdQzNLX/Pj5T2xU4PnkDBaFT/2qNBv8q2D9/Sip6xEqzThzFOpHAq54ISP8B7gJHwTyb1fWRhB4NaAjHdpbw2YNQZ3p9bvBHAOmbfQzMa//98K4WrxDvkolh6IZxg9mpL7z/urFhMXqZgzF2Q9Cf6OPkCFN0+4RZbH2DoPPQuUlt+GHGEyv0A20r0wUKPWt9Jk5HvNI+kWUVqF1c/T5le4ZAvdPhSbLWrC7dWneIErxCaXXliKv82kdCItQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4UXzmpMbENryqTOlPJTFIsvOycKxgQxAMqKQHOlzf8=;
 b=EGuGIiASF5r/afK/Veza2qYORDFVCvxWUVYr7pKsaqrHhgLuFH0hgWzSLG4UiY18mxXbm+M/19zgYH2hKcmyHj8bKDFXS88nZjARPrgf9SNb7ykdCNObNf4WSce1snw8f4kZMPHnsTW3jAQ+psYXoGfQ/g4HQaKxVePOYfkjdvc=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5017.eurprd04.prod.outlook.com (20.176.234.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 4 Dec 2019 11:36:09 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 11:36:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 2/6] can: flexcan: Ack wakeup interrupt separately
Thread-Topic: [PATCH V3 2/6] can: flexcan: Ack wakeup interrupt separately
Thread-Index: AQHVqpcF0DoGMD4Cpkma842/mS1cuA==
Date:   Wed, 4 Dec 2019 11:36:08 +0000
Message-ID: <20191204113249.3381-3-qiangqing.zhang@nxp.com>
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
x-ms-office365-filtering-correlation-id: 355cffb8-0060-4edc-7058-08d778ae27fc
x-ms-traffictypediagnostic: DB7PR04MB5017:|DB7PR04MB5017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5017F805DD4BE9AE5550E275E65D0@DB7PR04MB5017.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(199004)(189003)(54534003)(3846002)(316002)(36756003)(6512007)(305945005)(2201001)(6486002)(6436002)(2906002)(7736002)(76176011)(52116002)(71190400001)(71200400001)(110136005)(6116002)(478600001)(14454004)(81166006)(99286004)(6506007)(102836004)(26005)(25786009)(1076003)(186003)(2501003)(81156014)(2616005)(8936002)(11346002)(5660300002)(8676002)(50226002)(64756008)(4326008)(66446008)(66946007)(66556008)(66476007)(86362001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5017;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +q96c+N98rq3r8ndYnlrPETRFxfESX52I0KTG2W24PEe24oat2ZP/+I9nRoSaK43zCqxxdUzW4vz6W5MRfzXfFitIpp5Rxp5ZjfZ6lkGX2R6FHdV8nsFqmXxu7C7nPpfY7ClOZ9YYHCnad5482l9Q/vcGvfXDQp0u2OfINNaPxQmYBVxeKOHwS4waMShvoygl/lUuiyRzEDOypEYPxsxBcIjE52C4lLb+DO8DK5ogu9zse6K8c/nvEdiMm40Mytl+u2GBPk0pmlEtOPrR7ge65lRZmnrjHRXUwV0hefCvy0AXf7z96MkdS9LCfjWO0HqV4gRbvFSbokY7jqYOg2MQUeR+LsfG5L+4D2WdGNj2rb8BTkQkDX8m9FgEn37rzRNPdV3xMlvJJ0gfIDHcvUud8NMFjRamH7oXdLtHksJlQiqJy/5Mf+NPsntpELoypuqBVmn70LXy7lEBmaKwUu3LlEaH8gSB4ZxQsT0I7r8s8ADOTfv+/CnmDorEW6ScNJJ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 355cffb8-0060-4edc-7058-08d778ae27fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 11:36:08.9610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OjofrJSPq0po0UrlNPHgMM+5k/XUp6yh2bt3Nmu/P/UdQuulOqKdgTjKTpkvdRGwjf+Mu/Ou+SrLMK7rmkmOWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As FLEXCAN_ESR_ALL_INT is for all bus errors and state change IRQ
sources, and FLEXCAN_ESR_WAK_INT does not belong to these. So add
wakeup interrupt ack separately to existing ack of the interrupts.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
------
ChangeLog:
	V3: *split from the patch
	     can: flexcan: fix deadlock when using self wakeup
---
 drivers/net/can/flexcan.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 99aae90c1cdd..1b33936790b4 100644
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
@@ -960,10 +959,10 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
=20
 	reg_esr =3D priv->read(&regs->esr);
=20
-	/* ACK all bus error and state change IRQ sources */
-	if (reg_esr & FLEXCAN_ESR_ALL_INT) {
+	/* ACK all bus error, state change and wake IRQ sources */
+	if (reg_esr & (FLEXCAN_ESR_ALL_INT | FLEXCAN_ESR_WAK_INT)) {
 		handled =3D IRQ_HANDLED;
-		priv->write(reg_esr & FLEXCAN_ESR_ALL_INT, &regs->esr);
+		priv->write(reg_esr & (FLEXCAN_ESR_ALL_INT | FLEXCAN_ESR_WAK_INT), &regs=
->esr);
 	}
=20
 	/* state change interrupt or broken error state quirk fix is enabled */
--=20
2.17.1

