Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E09EE96A3
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 07:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfJ3GqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 02:46:02 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:55276
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726747AbfJ3GqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 02:46:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jp8bs5GLCgWjwvwxxS3gEpfw7cQJoJM831iEBozgoJ4rqc2KEKV4W+5Q37TzTFx06Qd0Hi3t5Jjjc0JmcctmCS6EIojee+JhqYRn4fTpybqsX27mVLaoqWZkLo6vp2dVIYqiMd7HIkJt0XLue2bn9CKPndi3RHuV4MJzVY57T+3avS5KhiTxcGNFvXP0hGf3itwDGcsdxRP2QE006nXUxZJK8lYCfw3Q9LJrLkS5RTIYKvgXI4G5j/XIpdobpHQ2J8VLjSM5/YZWs3q0QL5hwHiq0qVRSDCkKSNxqRRG7j6xaRCyJb9ifKcM3yjsAJaJpbMTr6PsVNO01Ul+caN7FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCDDUKHSoPw51mAe0Y1E6tcnhnOTkZ407mjEcwlkz+U=;
 b=EFClJ7kIpC6AyV7vTXknthFMtsBBYlJb3GXfo8McMHDdhi1mBC+USyykz0nBvSmGpfup/BdUpYzLkg7s8KUBoW5NSWPSoDexhhsH9vfMOvuBB+mHuAFLaGo5wVLkt6DUGW/9L21dKztbl5at/IxzzgEBHFnNt2/HV5B/5PNwTzYq45GLPkibSlrPN9eKZ3myN0JkQyCCSzG8+DgFpDPCvuC0ZApHNEeMjAIyXHTxeoqLmUnOiE3qC28X7EMb1gl+PHXXhRXQ8cY/QtTpT3o8As5iSSR6msbRt7YY/jN1pWj8CBDHtRUWXmFfy/DqhVaJ02tETc6RNM9tCY2fPt6lxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCDDUKHSoPw51mAe0Y1E6tcnhnOTkZ407mjEcwlkz+U=;
 b=J/UTFEE5lTAlOHYlGWqhit8LjQQKcpM64Wjfx5mfpDIzmydlD++iU5bNdsPLRRt0K5Jj/oFSZvSq0syUAv5IgntEKc9Mj4Ku4NZzI6PqG65m5J1lu5QsFk/35T5NfBfQeAiWmeePa9+0MQv6KruM59dX81pyiu3pBlUS44vnx3Q=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4666.eurprd04.prod.outlook.com (52.135.133.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Wed, 30 Oct 2019 06:45:58 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679%3]) with mapi id 15.20.2367.031; Wed, 30 Oct 2019
 06:45:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH] can: flexcan: Add check for transceiver maximum bitrate
 limitation
Thread-Topic: [PATCH] can: flexcan: Add check for transceiver maximum bitrate
 limitation
Thread-Index: AQHVju2v/arcQG72yUGRXsfLqk+ASQ==
Date:   Wed, 30 Oct 2019 06:45:57 +0000
Message-ID: <20191030064245.12923-2-qiangqing.zhang@nxp.com>
References: <20191030064245.12923-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191030064245.12923-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:3:18::30) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ddac7bb1-9956-4acf-ed74-08d75d04d1bc
x-ms-traffictypediagnostic: DB7PR04MB4666:|DB7PR04MB4666:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4666A942CC51F6A7BA1CF3EEE6600@DB7PR04MB4666.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(189003)(199004)(81166006)(2501003)(486006)(99286004)(8676002)(86362001)(66446008)(2616005)(66556008)(11346002)(5660300002)(476003)(7736002)(66476007)(50226002)(64756008)(81156014)(4326008)(305945005)(4744005)(66946007)(6506007)(26005)(386003)(25786009)(256004)(316002)(36756003)(102836004)(66066001)(6512007)(186003)(3846002)(54906003)(446003)(6436002)(1076003)(71190400001)(6486002)(110136005)(14454004)(2906002)(478600001)(52116002)(8936002)(71200400001)(6116002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4666;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iL4xwou7vtHBII8KAp0Emn8/j4NZ8kLELqeVUc660/9W+hXaTyDXT6FX/sQvzBlopFVwZCKuQwIvMtyORyuWrlYa4QwVFmgBbj3E6A0nuXw25K+b1u5IJSapZ5jwlmEjxcq+S/r6Y2XWMvM3ONhI0rs+6375T71Jg6dkdcVfQn1yrXYuGeYYWsdt72+8m7kGyG7PO+v9qz6bD6gis+bltvoJSW1MHZorH3pAOFseo2nRb82bHfEeSDK/x/J4EdNWO07lbC4c2KZIc7a4qg/2DPDRzzAkbWOw0kKZfRgIVT7mycAYzyVDCMn4nCQI9D2ytL3p9dBQbw/zJOwXZUrFlghy3o9fKv8Ixih9Ks+D3QHutDEd+lnSNNoKxVQ/CR9oGViGgIw60QNRuNYBF78jJv2XUUk+R6mwsCXq2NIblzrtfEGm3uMS3QRF+nYGgR4E
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddac7bb1-9956-4acf-ed74-08d75d04d1bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 06:45:57.9914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wcoOG9/lrNcNalz7oFeJfZfoSvlLmpH53gnLN5Z3yjWw+vnuajkokgvLoE/kUkXQ4/Fe3zqyrSbxsyLrR5CpUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CAN FD can transmit up to 8Mbps, but some transceivers only can support
5Mbps, so add check in driver.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index c5d53edb17ad..ee2d57b5a382 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1626,6 +1626,7 @@ static int flexcan_probe(struct platform_device *pdev=
)
 		goto failed_register;
 	}
=20
+	of_can_transceiver(dev);
 	devm_can_led_init(dev);
=20
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE) {
--=20
2.17.1

