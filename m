Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721BDDEC2C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfJUM17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:27:59 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:5347
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbfJUM16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:27:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCYM0BIYfe/FCEhIdfUJeKcB611y2Taoo5pzOSpy9OgVKx1BkqqtOFF0i1zsCWJwhX5PilGgk7qP42W47vcaUyeZrwICanp4Cr7DPCxulI9EKWiomjMbSG9LHoEPB0xIcTzn9Vq5Gkh2d+NhIOCUT/l/qTzHINmuEzLj/wwaathjRF0mA9OIQjlaaJao2rFUJb3/rR7R/bae3iMMd12mIr2hINIe8hsWldx5icARK8u4CDKBt7m6i7nKT2220tgaF5IJ51ya+fP7acEy16TLupqz+H6dn7sYphHGfPtSdSBFE7ExaonyxoO8jYWuobXT4ZS9DJT4qzr7hLRKrMb3zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hf9OiWzYk4HAFkW/PZ2p6jQUOFm1nb3NNG2xTmxnl1o=;
 b=M051KN4nBNGfb8XHNl+AWdLO7ga3cBtSrC6/CiT2mIAW3QTdcxQeKohSUETNrI/RpkgeXhD0nYYLOiQhev+5lNR5LUTv23A5KRRD38Uu2gvsA2He98fZhA02Tvtakxx29Chk36J4HR8cIaN6Rk02O2f55ymOJh3oNdZzOmtjfKoUvArT6TR3aCFpOZ+QlVhEmE177mnAtAcNiaJ3tNQbTurclgEQsxC2JmAspayFvWxKqacTzvE5SRPmDkoV85zcEMTKx9fSESs3xIvETZwmLx2uhrAjDV0UFN9KsIS6xbzrswAjAOxdUR/RGseboygjjImmN9rgqRhR+D5oZ9QkgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hf9OiWzYk4HAFkW/PZ2p6jQUOFm1nb3NNG2xTmxnl1o=;
 b=CEK92Pg/l1gcCOlAiAURMMCuv74rSfQ4LEiihimprL8cLFYvNUYThDcSC/3h4y1GYTEuB0y7Cwqh29NrXOyHcJ13AUmzL7bcBm5uqOg/XlsODavAxR2KEkdfsaXUXUHwvzeMf37jxmdiUyWTng26L4AFICKZS7RQQCk9Oica56o=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5807.eurprd04.prod.outlook.com (20.178.204.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Mon, 21 Oct 2019 12:27:56 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.028; Mon, 21 Oct 2019
 12:27:56 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 2/6] dpaa_eth: defer probing after qbman
Thread-Topic: [PATCH net-next 2/6] dpaa_eth: defer probing after qbman
Thread-Index: AQHViAr3P3dB+bs9xU2X+ylSag7/IA==
Date:   Mon, 21 Oct 2019 12:27:56 +0000
Message-ID: <1571660862-18313-3-git-send-email-madalin.bucur@nxp.com>
References: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
In-Reply-To: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
Reply-To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [89.37.124.34]
x-clientproxiedby: AM7PR02CA0022.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::32) To VI1PR04MB5567.eurprd04.prod.outlook.com
 (2603:10a6:803:d4::21)
x-mailer: git-send-email 2.1.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2af4f3d-9c3f-409f-a560-08d7562219d5
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB5807:|VI1PR04MB5807:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5807C16553618D407AC17253EC690@VI1PR04MB5807.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(199004)(189003)(102836004)(486006)(3846002)(26005)(6486002)(446003)(11346002)(2616005)(476003)(6116002)(2906002)(3450700001)(36756003)(86362001)(25786009)(8676002)(6506007)(386003)(7736002)(186003)(305945005)(99286004)(4326008)(6436002)(52116002)(81166006)(81156014)(76176011)(6512007)(66066001)(14454004)(50226002)(478600001)(54906003)(2501003)(8936002)(316002)(5660300002)(110136005)(66946007)(14444005)(71200400001)(71190400001)(256004)(66556008)(66476007)(64756008)(66446008)(43066004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5807;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LQgbJZ/nuJLbtU10XC0dKqHPFcpKSERHdc6kZS0XHOHxECDJETNcHzsfXBewtO6Ssbt+Jjb2N6Nl8lkEy+yRIy0kbCED3chgChNhaNEJML+nOTBXFYrpVE8fEmHgkW4Gw7z3gF+Lir4aqaQwBtkv15Ta+zRZUjo9ZOwU2cuOQl/sGUguLYFlh5GfWONgO2oMa7VDTyQksIoTRqwJXwFtAO0yCuiEx6HTJLUNrCNQUMznteAky4Hw+K4Iw6tATl2Ifk+VYl4hTma+DvC3X0sxVGZSme7+vUz0xzx58y8xbGZSDo01OOGi2b/I5IiJtjXgKUdCg0bgqD3KMd4dUdD0RNBKvnQqyV4+kgPtnSrCj3JPbDVtAUkbDhnF1fLlByinaSgNEE9HAkSvdqZpjhi65Bsa/2BnYw4iRp3x8GPJJTlNNqwDRu33M59SSlU/0uG1
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D1CA75C52151647A8A89318CA261722@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2af4f3d-9c3f-409f-a560-08d7562219d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 12:27:56.0831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IcogUP5UUDmNMaiPm5NlPPfTR4YJsu7co5Gholce5E8+a8i6KwZhFFgcsvM2Qilcmf8Rt1+XWGpSyMTbIw+Zuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5807
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

If the DPAA 1 Ethernet driver gets probed before the QBMan driver it will
cause a boot crash. Add predictability in the probing order by deferring
the Ethernet driver probe after QBMan and portals by using the recently
introduced QBMan APIs.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 31 ++++++++++++++++++++++=
++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/e=
thernet/freescale/dpaa/dpaa_eth.c
index b4b82b9c5cd6..75eeb2ef409f 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2773,6 +2773,37 @@ static int dpaa_eth_probe(struct platform_device *pd=
ev)
 	int err =3D 0, i, channel;
 	struct device *dev;
=20
+	err =3D bman_is_probed();
+	if (!err)
+		return -EPROBE_DEFER;
+	if (err < 0) {
+		dev_err(&pdev->dev, "failing probe due to bman probe error\n");
+		return -ENODEV;
+	}
+	err =3D qman_is_probed();
+	if (!err)
+		return -EPROBE_DEFER;
+	if (err < 0) {
+		dev_err(&pdev->dev, "failing probe due to qman probe error\n");
+		return -ENODEV;
+	}
+	err =3D bman_portals_probed();
+	if (!err)
+		return -EPROBE_DEFER;
+	if (err < 0) {
+		dev_err(&pdev->dev,
+			"failing probe due to bman portals probe error\n");
+		return -ENODEV;
+	}
+	err =3D qman_portals_probed();
+	if (!err)
+		return -EPROBE_DEFER;
+	if (err < 0) {
+		dev_err(&pdev->dev,
+			"failing probe due to qman portals probe error\n");
+		return -ENODEV;
+	}
+
 	/* device used for DMA mapping */
 	dev =3D pdev->dev.parent;
 	err =3D dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(40));
--=20
2.1.0

