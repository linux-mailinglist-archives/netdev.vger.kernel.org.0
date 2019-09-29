Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A8AC13F1
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 10:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfI2IcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 04:32:13 -0400
Received: from mail-eopbgr40082.outbound.protection.outlook.com ([40.107.4.82]:39566
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728534AbfI2IcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Sep 2019 04:32:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCThQFPqnPDcdhtoTGY77umj88JXpQ/psERJy4jWNn07ow1pJHwAiYXmUoFSuNW/xcigWQBj5l4YeFLHEXlGde3Bi6UKll83cR9LVfeX4LaRXm08TWhoySoLY0ab0ho6gYWFSYxh2L26bGltVdz4008de6s0rZ/M7qgJWiG48gVppT48MZT3/MQNU9Mc/OkZtz4a8UDR0e2L2hrjknLVZm7CM/xecCKSo3i1mOiduYxu2+SkPEzrhMjmEyMsbRLVPyvCfhYIwHlz59YKVaWsCytF06xufoyhnyaQMetwhDaYOM5n0OSh3mJuodT11EFp4NLLPy/aVWPK+SBzlJs9tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYem4RTc+eilK6F0KQ15VUaK80oNHofbUpusgnLEBv4=;
 b=Ky/Z1L5JpphelUzbqOXy8YKUZNWlAJcfs/36J4jern85ZZ/WtbBfXdoxJAB1lKuDVpj+p3Fo+PhXUPeWbsNS0nhkLdZvyfI6cO7GIwaIrsCnD83brWg/589NLZSoudQhTRB5B9yOYJED5pRPlBiL9a/O0cHjI6t9mx4Ym+L25jiY/29NkJVgNLYL7N1nFwgl8V8eG0YtluFefaJ7tXFpgxShMVprlaqAWgSnYcvquMVizVi2ol4rCy3L2h8sMo2WqZu41vdustht0qwGoCjxgJ8ftwcpAoxhiGbdW6vEWcw7cbtSnQSwawaf24NLLscn4MDzyNNvmL2kDf27hW5ANQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYem4RTc+eilK6F0KQ15VUaK80oNHofbUpusgnLEBv4=;
 b=hJVBI4oLl2RAZAOWBxRjG5dO3gedZIgyB3hfYjkAIuWKuyqYTtb0e5dNiCdCs1COMjg/yytQMj7AozHFP5RQcD8qAlEjXN+ZwMkNxVWj2ueSgC9HYDQq7oAJaQNoNF48Zplfp4MqLk9WRrSUooCdNa+uYMU6lojdLjaE0dqEK+o=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4889.eurprd04.prod.outlook.com (20.176.234.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Sun, 29 Sep 2019 08:32:09 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1872:ad0f:4271:ad61]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1872:ad0f:4271:ad61%6]) with mapi id 15.20.2284.028; Sun, 29 Sep 2019
 08:32:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH] can: flexcan: use devm_platform_ioremap_resource() to
 simplify code
Thread-Topic: [PATCH] can: flexcan: use devm_platform_ioremap_resource() to
 simplify code
Thread-Index: AQHVdqBiRC4zmV56FkeU7Oqk/q2FUg==
Date:   Sun, 29 Sep 2019 08:32:09 +0000
Message-ID: <20190929082854.11952-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR06CA0124.apcprd06.prod.outlook.com
 (2603:1096:1:1d::26) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba19475d-3c0c-4ba7-9ba1-08d744b78471
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DB7PR04MB4889:|DB7PR04MB4889:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4889AD7D21E8D9814953E544E6830@DB7PR04MB4889.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-forefront-prvs: 017589626D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(189003)(199004)(110136005)(8936002)(66556008)(66946007)(6486002)(3846002)(8676002)(5660300002)(99286004)(64756008)(2501003)(81166006)(54906003)(66476007)(86362001)(71200400001)(81156014)(66446008)(2906002)(66066001)(316002)(6512007)(71190400001)(6436002)(6116002)(50226002)(2616005)(52116002)(256004)(486006)(4326008)(305945005)(25786009)(102836004)(7736002)(36756003)(1076003)(476003)(6506007)(26005)(186003)(386003)(14454004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4889;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SVVDvRmThRbt7lIDUToHbnMGrjp+IQXPKgoViVgof5B4YvMq9R39cZoT3PwHj9D34ghsb9xLlFqcEo/apv1/A25aLxsPIOAJh6KEAIXI/uhod1f23+oUH0vmALhec2pE0/K50WlHrjlDDXeRm7A3coM5JnITn4WtNgR/RsUOkTWWi14eCyM8rlDPEPauLOiUjba/wAqwpgUIg8A6ygRc7aNq+VZn1mnaSdECigXDx8IJjUch+iNgldkI83WtvCUV1aHo9uQBDJujJXnQ4n8rkBUJzSRjvZV7ME1myREh1U0CKERwulvXs4RmckTYtp5U1Q8N6pBGw57XJOMGEgLzGR9sfKbYuOVmo4EI0N5tf/LBA4Gc2WF9kSlWsYszvk74mn/VXMcpg2zjKKosIAqhdeerh6zaw8hftc9zw4aM8so=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba19475d-3c0c-4ba7-9ba1-08d744b78471
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2019 08:32:09.2693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +rnt0TwX8kvF1ggXYqe4QF38P9k29CYYL8IpUieTIFluxznXbgsqYS+wX4jNWlFUrlAUiXrqeZAs/4ccn44Tew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4889
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new helper devm_platform_ioremap_resource() which wraps the
platform_get_resource() and devm_ioremap_resource() together to simplify
the code.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index b3edaf6a5a61..3cfa6037f03c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1507,7 +1507,6 @@ static int flexcan_probe(struct platform_device *pdev=
)
 	struct net_device *dev;
 	struct flexcan_priv *priv;
 	struct regulator *reg_xceiver;
-	struct resource *mem;
 	struct clk *clk_ipg =3D NULL, *clk_per =3D NULL;
 	struct flexcan_regs __iomem *regs;
 	int err, irq;
@@ -1538,12 +1537,11 @@ static int flexcan_probe(struct platform_device *pd=
ev)
 		clock_freq =3D clk_get_rate(clk_per);
 	}
=20
-	mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq =3D platform_get_irq(pdev, 0);
 	if (irq <=3D 0)
 		return -ENODEV;
=20
-	regs =3D devm_ioremap_resource(&pdev->dev, mem);
+	regs =3D devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
=20
--=20
2.17.1

