Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8178FDA1
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfHPIUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:20:43 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:58119
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726575AbfHPIUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:20:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7VN6bNmkOxPU4QvwccDhEWPQh+tJMFZonjkSuwHZaj4QKNZctX89i1SiTZhIwcoALfS5H1ttZzBCBtxlxQHKGD25JozzYtPJtlyd3YVk3a7iE6hwkhSi50B+XREOcxjwEr/4wmBwQNSxiy6AU/BHoY/yiRGDfYl+N/hEmWz0WhPESIGmva35ciZj94UZ0tcN2GARdSC85qWqcqrH8mOTBiPMwiB5gJWNQ67T8Kr5c2IhaT0XreSDAJQ2EgVUMhax4/rqKWlaB1I5Mgya7XPGMs+v33M1NLL6MGRJlljLYKy1XIaMZXODdmjy0xVtdB6tAcBWs2omq2y3/DeLH0uWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hahgNNew1V4N2U9romiu7ruvap26xr/jDafMkCx/2co=;
 b=nPdIjJ88l8caJ1mq9fwEeIh7Hhy+6bhYdAXcCTTML4+9YrxMv/c1Y9aInH0lrIrG8OmAxcPBuvn8mOzgEntS84afGocq4nhvFwPb6AvYuU5Y3nw/aJHY6s74vs44vMX8sdgPFyT02teH+AUQGmzd5q0JzmAh6Axn1C39yFF70xVDD5PVrhf9qnFTlvfoTMzlT99gn2sZ2dcIpAbjr2NnEd1voOJQOUrHvU9v0090uyf6z0pTzeOr2ZkOh4kILB2r+5bgUPeGVaAPFiw9b1zKA04spxgSqaxySEl2wxbBqh0zJb2mWhNozCTf3IAxZyhdiF08HZC+HPy6M0yDjNC83g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hahgNNew1V4N2U9romiu7ruvap26xr/jDafMkCx/2co=;
 b=hqiXgTFZhWPSsRAme6HvZKmZwfm5IpCtUwmA5whe6AZYBuX5QBsGpUpCFxQP724+wwmQ3EmoVC5kh7M1J2YrkbGgrd+G1XC0AchbppbZYFcamua+7pT0A1RpVAwHFisu5DGF38d0z912RolhozhTCMvN+B8Hk09QOwqZv7gWvLQ=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5419.eurprd04.prod.outlook.com (20.178.104.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Fri, 16 Aug 2019 08:20:39 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f%4]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 08:20:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH REPOST 0/2] can: flexcan: fix PM and wakeup issue
Thread-Topic: [PATCH REPOST 0/2] can: flexcan: fix PM and wakeup issue
Thread-Index: AQHVVAt8AdRkXbIHl0KPDqlhDaA0Bw==
Date:   Fri, 16 Aug 2019 08:20:38 +0000
Message-ID: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR0401CA0004.apcprd04.prod.outlook.com
 (2603:1096:3:1::14) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a29dcd4d-57b8-4b2e-f042-08d722229ec8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB5419;
x-ms-traffictypediagnostic: DB7PR04MB5419:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5419C78D9356C38018B4F917E6AF0@DB7PR04MB5419.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(39840400004)(136003)(199004)(189003)(5660300002)(478600001)(6512007)(110136005)(4326008)(25786009)(54906003)(81166006)(2906002)(81156014)(53936002)(8676002)(316002)(1076003)(558084003)(186003)(3846002)(99286004)(66946007)(14454004)(26005)(86362001)(2501003)(52116002)(6436002)(476003)(50226002)(6486002)(2616005)(386003)(66556008)(66066001)(256004)(6506007)(486006)(36756003)(66476007)(6116002)(71190400001)(71200400001)(305945005)(102836004)(64756008)(66446008)(8936002)(2201001)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5419;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9JCfxjv7bpA1vz6QHGI8dn5iF66vH4uMqFFfGoEtFG0sKq55hdf7hjdJ2yYDJjgjyS6fIEnc9IGNpJjLnkhMv67vUoufhNUhOvHfnntI42spwRo800tKKPENGVJeCmIzyeOJm3oqNjaJuFSafo3SgHT1uwVDGU4VwbDhBKtEyuisvRJHJUxQSd7NWMdTpy1oMVY/+k69fjU0zwzbf1Uww7rbdCMYF8J6JRb2z4wc9lrDR33Mg0M31qsWYG4AXJ1E+Sch7VmKFJFnS7juTPZgQQB32YJtSsUmZXqB6whZcdRbaUwVm/Nz+oPWFItvz2nd6pE6OaStaJ1jDSwdI/RkvhGnHG8oOm7BfkA8rs7RArMNYyZAo13BPhuaNUxB4xPXDHyMol8FJQBTPHID9Syadoec585fjnKuOrUP29WRqmI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a29dcd4d-57b8-4b2e-f042-08d722229ec8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 08:20:38.8393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UxhG3r5N7RmxLNHzduSuLpjtUadGXSQKL/pxyONYzB9rnP9UaJKztT0IQKPWmb6GD8hYiTsaRMhAlFiTZ+w0LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5419
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set intends to fix Flecan PM and wakeup issue.

Joakim Zhang (2):
  can: flexcan: fix deadlock when using self wakeup
  can: flexcan: add LPSR mode support for i.MX7D

 drivers/net/can/flexcan.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--=20
2.17.1

