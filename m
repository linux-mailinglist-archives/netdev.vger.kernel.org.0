Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD123E0C6B
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 04:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbhHECZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 22:25:02 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:9281
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231855AbhHECZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 22:25:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/CcX6cvFheTlxuwBB4lYQB+xoYtZn3dKkT5oCvednodscSIeV5H6PQDCCogwd5uVMCkp5zpkiT8OA7mIUSzWzyJ+P+J6GaBs9cMsxpLUZ5QUUQGEfNpZZEh+o2aG3YDqu4Pf7u2QIj1A03aunV0wBuCrPV7mDlqeZoIwbQuUdIt5kdojEK4sU6JS1fnsP2PPj/kfayhEv3nwPQBWdBsqOazlYCC3ghAFv7V5WNuYojYq67FFKVJitpZHRK9/k1HLDawG2febPM2aMzQcGqkMUmi9z1H0NDyyMPBFFEL98pqi0OzxZW1SVa6a7zCJOgGrW7VFvyS67HDdF94MZB0UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Ni8OPH5vfg39IvZZ08LG8lScAhuSyiH47ubz3QOMNc=;
 b=dzkbIRkDGBbJnZieSoK2W9X2DpsT6+vhCvSG//HrQLN/LdXn+UF+rT5OqUNfyaU8vsS90wP9uPTbGDW05FklGDHs5/0kcAeLiEUl/m1xXEL0j9RBG50JepR8OJeTxZaGOm1aiDk6qgLkZEVasgFqTUVH7CCDN89cpI0Ou2/gqxo6qQ/bvBoT0tTzJxsHCJmhvXd2C2A9wM4sm4ft2iridT2wczdkGv//NVzvyiHiX5L0bSTb/uqm6amqDCQpsQ7riEcnCCleA1qdoaIhURe6Eww8gjpgOGlqRjgBQs8VMN0iVSyGdK3oL10irkog/+hbNp8kVj9/G4CY+vD8hUM0Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Ni8OPH5vfg39IvZZ08LG8lScAhuSyiH47ubz3QOMNc=;
 b=TSnbMaa3yHz9TiL41/QbdXsZX3WoQTqarSHUoZlS753a69atoE9e1aolf5g5cjFjaAfZpwGHooMJTbXjn9DtkhfMVW1GK8GhS6lTHf4llalsIGaRlx1VDm08+wUvxpIgDX8s6BtpQ5He8ieMAAQzpw1/dKTdeTjKwyNQmNmz8/Q=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3850.eurprd04.prod.outlook.com (2603:10a6:8:3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 5 Aug
 2021 02:24:45 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 02:24:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Pavel Skripkin <paskripkin@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hslester96@gmail.com" <hslester96@gmail.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>
CC:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] net: fec: fix use-after-free in fec_drv_remove
Thread-Topic: [PATCH 1/2] net: fec: fix use-after-free in fec_drv_remove
Thread-Index: AQHXiUivJT92misUbE29I/vbw5qkU6tkL09Q
Date:   Thu, 5 Aug 2021 02:24:44 +0000
Message-ID: <DB8PR04MB67959F69700F5065344B9FE3E6F29@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <cover.1628091954.git.paskripkin@gmail.com>
 <25ad9ae695546c0ce23edb25cb2a67575cbda26b.1628091954.git.paskripkin@gmail.com>
In-Reply-To: <25ad9ae695546c0ce23edb25cb2a67575cbda26b.1628091954.git.paskripkin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89ae9e7d-c95e-49bc-4bdc-08d957b830a1
x-ms-traffictypediagnostic: DB3PR0402MB3850:
x-microsoft-antispam-prvs: <DB3PR0402MB3850DB50FE8B64CAC56620B4E6F29@DB3PR0402MB3850.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vXIJlC8nQS+ceBIp1rDHu/nDqQEPUtzTRFA9VTOLmRilRRXzTvjimREeOWpZVhOYKfikLp/HhEcaUf91UvZa3V4Yck/DuhMpAaDxGLaxCtyv1u4AxDRvvAgGhGdXrXVbjSWcToB/znRCxVVF6slAK21YmhFGCeIuBUN/LJorjgMBPiky1GGqllkKadYU598LWlLQlDTo9cwBWR0AcvlXBDvxExDKm5GpfJOh0/VzVGN9bQRipbpZCllYr5/TXnqRS1zHHspp/ktiSuSLwQMx5OHUczy8/YgbHMDTUkhhzPyqtPYf/S0fCQ+ONaSgIdvX3GwwV7Y5wcTHl8vTZA3M3nJk67V62IK7AM11+FL9SynBd49a6UsQ73oOulXRUgAffeHvzvQ2651chLvP8d2BNWaGSY5RE9b9gqb5hI6p6hLJQICxe93A4hIr5zYRo81AJajOl0M6dX4ykE1WN5q7rKJTVGX9hCPt7mwEgIjNey74naUS86mesVhEC2TMZTyzrl3wJtJdfJZg0hBcX13FC8m6/FLNlL1Tm6RYp3s7N0lRbjqsSrEGCsKPh2oADCmpAnCIHEjEOVkwZ6VGgcCn7TFYxXGzSKxvTiZCZexOTWCTSgjnroA5U8PbWRKeNFaI+9zA9zdo/4j4DlqhPZ+EbgMui6cD8vbO7enV5XK1WVBX43l8no2hZPKd3PVnMhYe0TonRD8zsTcf4dQ3UWZfHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(38070700005)(4326008)(53546011)(5660300002)(6506007)(76116006)(7696005)(4744005)(52536014)(6636002)(8676002)(122000001)(33656002)(71200400001)(38100700002)(83380400001)(186003)(66556008)(66476007)(316002)(54906003)(66446008)(86362001)(64756008)(2906002)(9686003)(55016002)(110136005)(26005)(8936002)(478600001)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?TlZxdWJEbXFxOUFjaTc1aVIvSm00TWpSU3ByZk5mRytEZmdQSCtYaHc2TUlx?=
 =?gb2312?B?OXAzMWFnSzRBV2tNcHJkc2plMHVuMVdWSUlYQjcrZUhrWWFmNUNwSi9Qc1pR?=
 =?gb2312?B?WVE0M1lFcVJIVm5MYVdRR3JBVXc1SzVyNzR3Wm9vQk1lNTVyTWgxMENqd29x?=
 =?gb2312?B?cWRVZDdURHdWVFk2VGp5Rzh4WWhQSEhmV3FYT3AwdEROUlVOREh3elNnRmhw?=
 =?gb2312?B?K3liaVBickt4VnE4MGRTMTE1SzluVHpaVUZ1WmlaTGg5TUxMbTJYNU11bk9V?=
 =?gb2312?B?OGMzdzZteUZSSUthdlRBcDJwOFR1cWgxVnkzSjNHSThwSTN5dWQzc2JFWS81?=
 =?gb2312?B?d3cxVnNGa3hxMmxYd1ROSnBhb3dMZ0dhU1BZdU10VFJ4dSswbDJaQUV4ZmVY?=
 =?gb2312?B?SWhpcnM3U0ZtdDZtcWVCVlRrWm9ITG1EOXRnMzI1WmxHRnYxRVZIQTJUdzNm?=
 =?gb2312?B?NWdmTlJsS1NBZHBZRlB0ZW9DQU9ZdmtUT2NubWoyczJNZUNsVVhzWmozSjdH?=
 =?gb2312?B?bkZ4Z1M0UVRkWUlBQzYzZGhqOUJ6dGtIVkFWUXJNU0NuTnNTU3piNzBOS21m?=
 =?gb2312?B?SDlkZ0RQY3RMelB0WFZyd2ZtTCtkWUtqd1BENSsyemZqNWRVdWprVGRlWDNF?=
 =?gb2312?B?SmIxWGdaSGcxNjIwQzJFQXE4Z1MxUnlsRjNkR25pd1pDblU4ZU5CaTZSQ1k0?=
 =?gb2312?B?bFlqcEo2d25aS2thNmcyV2RqQ1ZBc21UdnkrSEpBYWFINVVjVm5MVWszRGhU?=
 =?gb2312?B?ZndLVXd1VHdidkZxUkVpekxZSFRXNytPZWZyQnVjSTdxaGdJeG1IK2lOYWxn?=
 =?gb2312?B?OGZFdXpOa1pTR1R1TmswUmI2QWI5ZWhaVkRaaXFNVjlYSzVHZnhFTVBFbTcr?=
 =?gb2312?B?Tk9aNkx0YjJzd3VnZlZTQ2ZDenNHU0wrTHJEakRXeGtkOFREdE1aOFBwc1l4?=
 =?gb2312?B?cFVFa0tHc1VtUU5UNWhWVU1vZC9tUVo2OUNUUHFxR2wxRnlXK2FSWjE3VVRx?=
 =?gb2312?B?cjFKb3V6eWhZUDBMQjRTdjNocVFqYmNxTDBSUytPQUQvK09ESkxNZmF6eUJ5?=
 =?gb2312?B?c0Mrb2RQaEZKNk5jYlJYbDI2SnpqcW9yOFVRMlZCOGV2VlB0MkVuZWErZXYz?=
 =?gb2312?B?Zkd3bGVqRGdsRGFEd0NZb3E2TWZ4MHh4ZlZ3RUFLOWpaWFlFQ05OTTVMY0NI?=
 =?gb2312?B?cnF4NjJaaWdSb09HQ3dWU2ZFTHlFUWh0ZWN0anhrY25KZWVadXE1OFZHUmdi?=
 =?gb2312?B?QjNaYlhSYXp1RDQ3QjZvblQ4TlJmdkFSNytTN08xUnArckR5NlFrcjlKZ2M1?=
 =?gb2312?B?dWpxdEJISlVzbHhtTGFNSnRRbG5tbmpTRThVR2djVGlzVU5hM3dsSGduL1Y3?=
 =?gb2312?B?SXRmYWpnM3NXMjRpVy8vN29iWXBXWjYrRTFENWFBVUxDY1FPRkJHaWpmdXdz?=
 =?gb2312?B?VUY2ZzRwRHVwMmxKMlBOSXZEM21uSmsvQnJCMmJCOEFtQ08yVDFpMlhCRlcz?=
 =?gb2312?B?a0dQTnZkREtRQlpqeHNKbUpCckJHM2JacUkvc1dlbVpPbzQyQVZweUk2T3pL?=
 =?gb2312?B?NSsyeGhCL1czQTIzTlo3U0d5RlZ0cExJbk93eVljcXhJcUVuY25OakdXOXFm?=
 =?gb2312?B?cEtqcDVLaGQyNVVieDVPTTBUZmhoUCtiTTM4dG1rckpiK1VEaG8xbjl2N3Vy?=
 =?gb2312?B?bWlyU0hPNVUzWWlRKzgyWlJHZzhSOVZEYU9vbUNMYnJBdkVuUE1zYmJQVnUw?=
 =?gb2312?Q?/QrgjJlVlNFpmVSNsY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ae9e7d-c95e-49bc-4bdc-08d957b830a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 02:24:44.9937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Dxsst+pQHSXn0h2QHfwvKsnWKZd7THE9IwTjeVM0Wj4ROlm8BmaeNbjpxot1HzsCGw3LPUd5zWHK3v8LUVVZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3850
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBhdmVsIFNrcmlwa2luIDxw
YXNrcmlwa2luQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqONTCNMjVIDIzOjUyDQo+IFRvOiBk
YXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IEpvYWtpbSBaaGFuZw0KPiA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+OyBoc2xlc3Rlcjk2QGdtYWlsLmNvbTsgZnVnYW5nLmR1YW5A
bnhwLmNvbQ0KPiBDYzogZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBQYXZlbCBTa3JpcGtpbiA8
cGFza3JpcGtpbkBnbWFpbC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCAxLzJdIG5ldDogZmVjOiBm
aXggdXNlLWFmdGVyLWZyZWUgaW4gZmVjX2Rydl9yZW1vdmUNCj4gDQo+IFNtYXRjaCBzYXlzOg0K
PiAJZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmM6Mzk5NCBmZWNfZHJ2
X3JlbW92ZSgpIGVycm9yOg0KPiBVc2luZyBmZXAgYWZ0ZXIgZnJlZV97bmV0ZGV2LGNhbmRldn0o
bmRldik7DQo+IAlkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYzozOTk1
IGZlY19kcnZfcmVtb3ZlKCkgZXJyb3I6DQo+IFVzaW5nIGZlcCBhZnRlciBmcmVlX3tuZXRkZXYs
Y2FuZGV2fShuZGV2KTsNCj4gDQo+IFNpbmNlIGZlcCBwb2ludGVyIGlzIG5ldGRldiBwcml2YXRl
IGRhdGEsIGFjY2Vzc2luZyBpdCBhZnRlciBmcmVlX25ldGRldigpIGNhbGwgY2FuDQo+IGNhdXNl
IHVzZS1hZnRlci1mcmVlIGJ1Zy4gRml4IGl0IGJ5IG1vdmluZyBmcmVlX25ldGRldigpIGNhbGwg
YXQgdGhlIGVuZCBvZiB0aGUNCj4gZnVuY3Rpb24NCj4gDQo+IFJlcG9ydGVkLWJ5OiBEYW4gQ2Fy
cGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+DQo+IEZpeGVzOiBhMzFlZGE2NWJhMjEg
KCJuZXQ6IGZlYzogZml4IGNsb2NrIGNvdW50IG1pcy1tYXRjaCIpDQo+IFNpZ25lZC1vZmYtYnk6
IFBhdmVsIFNrcmlwa2luIDxwYXNrcmlwa2luQGdtYWlsLmNvbT4NCj4gLS0tDQpUaGFua3MuDQoN
ClJldmlld2VkLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KDQpC
ZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg==
