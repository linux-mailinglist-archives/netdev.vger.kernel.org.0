Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CF81182F1
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLJJAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:00:14 -0500
Received: from mail-eopbgr50076.outbound.protection.outlook.com ([40.107.5.76]:50837
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726932AbfLJJAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 04:00:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUFi2fjs7Z96FdZejklzpQ6fmEnWklM6y+T9q9W0Jz6+FZKR0maGbpywXlWVJBTH3qtwAdWNg+jTKlYJkC+Z3zeK9cHge0+TNgt84YGZPBPkL6NhDSDoEDJXNIPnmquKQ55AVtg3tlAovbze06c8tTelWIKavUV60z24ja1Rtd4AeFkmsCTQcoRrdt+3Om/7Ma3LRlTjSlK1/cSN9WhXWX0L3MhB9MhDOBWFLovRLmUPN9lmu+5kUNXjyRCd7E83bt+0lU3U98zftgqWYx2nkcKrMtWQbU4ze8p54OQeAQ/FrXpayvBzjyetpyRuTUVGcMbCuU3HLp6NX0SH00kwuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWotqm44KA7MN3VTR2K4RfqTRVL81whr2JH03pLjq/A=;
 b=NByTsM8vrBwHSrVAtYsp0fv2Sj9QvLGjEGB1CNPaEAGKAMMpcWUod42UfROJ9xKPl3LGN0m7PIRyspQUSC2SpZNft0zzWqsNvX7McUPDNdkGe7ESJ0I3FuZ84RMqfbbMI/PzOGr24OioennELF18lJyKqj6t9GKm/6vE8tkYPumf0Uy5oQAMsBpDJ9pw5AIyv7u+Yt+hmQ0b70UUpTfJFPd/zF7WRw5wz6JppkZ8U1tlRjD8GdkRMlr9fX4380W6fDD8PYrrMXGItRGRrDTIlrSocJxxi4UUju8711LTnJIoz+P2CkXFnB2b4YiNCOGVPicy2AcX/6qKzsmAwUeAXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWotqm44KA7MN3VTR2K4RfqTRVL81whr2JH03pLjq/A=;
 b=C4ka8ZrhNy2adt98POcm4fg6c32AYR0AbYLuy+PUr3FCYc1CbcLvPwRnzLXRHsTSWTG9YV6dZCM42uzoLwLk+7sX82ic5E7qExr9fQWpIUymGYe2Bb+0Tm0WWnUxEKzjOxMp4NS2q1idqXOduRQbgY+RAQfzQVNlnbK2VjU6WT4=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4889.eurprd04.prod.outlook.com (20.176.234.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 09:00:10 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 09:00:10 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V2 1/2] can: flexcan: disable runtime PM if register
 flexcandev failed
Thread-Topic: [PATCH V2 1/2] can: flexcan: disable runtime PM if register
 flexcandev failed
Thread-Index: AQHVrzg6EKh7HkIWdEajMXWfT23TGw==
Date:   Tue, 10 Dec 2019 09:00:10 +0000
Message-ID: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0118.apcprd02.prod.outlook.com
 (2603:1096:4:92::34) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 90eed7b6-07be-4f3f-3fe4-08d77d4f5c5a
x-ms-traffictypediagnostic: DB7PR04MB4889:|DB7PR04MB4889:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4889FC97F87C0978EE9A3D15E65B0@DB7PR04MB4889.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:392;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(199004)(189003)(54534003)(478600001)(86362001)(186003)(2616005)(2906002)(26005)(54906003)(6506007)(52116002)(8936002)(8676002)(71200400001)(71190400001)(5660300002)(110136005)(4744005)(4326008)(6512007)(81156014)(81166006)(1076003)(305945005)(66446008)(66946007)(64756008)(36756003)(6486002)(316002)(66556008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4889;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6F3qe1QX6jf4v8XZMq7Dx/AHPZcM2EfC1UyudC53d2ik3uldyRXutdWMLdqy3ix0g0SgvU1r7vutkaXDOJaqYAjFw4y8i+AbUh30FWiet50FCEfM30LIFea6SddKFKUozwaZLs7h1+d7HA4lL+lTCJKXmek2AvpGoWHC0JI5o2cG+mh5W3V4ktd51vA7VacuWmr1otI0g1vhCHbIi1FEzTYMHdaljn7l32fGf0MNA07aUAPtGnLBsmFs1ayFhuRqwT7sBPXA8JsWcqAMqjtyEzWK9OO8fJCdUBcm/3ZhJPNYADqWdkb47LNd2P6wK6CSPJZl3H9G8bUzi/EPpVn32QYyrjipytMrn4+j81rsStbHj0y6NpAxhekJu+nphRgsigY3+P8J/AMhxbutZ4dNb1jtm3UxvOcSv21mwgsg0sP0OzVmLYk2JseO3N89d5gd8Va8yiUO4rfgNv4BAgxvlsrBZZBdbe3XzC99YOP9oP3IHeBNeDxvYiBGtn+OSTMJ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90eed7b6-07be-4f3f-3fe4-08d77d4f5c5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 09:00:10.5109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c/HaU+8RWLAeXUvigBLFus9ZNFiIEmQv9vXmKfC2qv+l1IBmjDfLVUNM2vXjHUdDR8ZGmgifV+HXpn+rKqaAVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4889
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Had better disable runtime PM if register flexcandev failed.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
------
ChangeLog:
	V1->V2: *no change.
---
 drivers/net/can/flexcan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 3a754355ebe6..6c1ccf9f6c08 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1681,6 +1681,8 @@ static int flexcan_probe(struct platform_device *pdev=
)
 	return 0;
=20
  failed_register:
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	free_candev(dev);
 	return err;
 }
--=20
2.17.1

