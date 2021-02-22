Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26753222A8
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 00:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhBVX3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 18:29:07 -0500
Received: from mail-eopbgr690110.outbound.protection.outlook.com ([40.107.69.110]:26342
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229996AbhBVX3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 18:29:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jn45I+sHAU1DSlbXLN2t+MGay+WkFf+IsIJ/5RUwqW0G6vdMF4eeWEDPOSsTAj6BUbeiSwhXkOECidnm8Jl8+e82clw2GdA+d/6/xoqRFoT+fSqoPEF2dhexy+vtF7NeKTnEfEpy7ZE4LB+xDuP+GPUtoo+WyOJv93nbCcwgQpDQP4OUvzvp4RTTSYup9X8PC5dRqUzpgtTgGxiYCbW7ewyN5ve7346bBnfOBkQMzvWSg8wp802zQfEnVacIv0Jiu4d92qSvY/bshU2B8A2fr1GBZHzSEUrrYrPFLQDXrRQvXfh/BCHpgLdBI+OaNAIP6SYmDTFy/wFTugnm8r/8og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxWJ9+cJVZawXrRSuXRgArG46xfIeBmrTNKUPefZCDY=;
 b=ddmPx1LPzQP3rUdsn1h/v9yHbXaNJLqD5kGlcbjVCR9efPqrfVGbpTuuECIc5Dx/AXGPKCEd1PWhGAjuqIfNrPqlLThE166haBi2ZBT2j5DKJejfLZM9+KmTOwc4aJK3N1Ez6ugB5oBJsRHDfDTvyMEXek/3AkNhRHlVkbBxZnMM/kd5Zwfl6OBIw32V58wBhTjTESC7YAG2FtdRGhspjHJgJZOslsYkLdRa+N/gFg9ShP/HTac+7GLzVb2TBPgVA3xr/Hzj+VluGB6uENWDQdt7IsJexLexEy+ERSzgAil9s0wtATy+FLXc+EUd3Is9RubB3umiv2g7gex+IA1G9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxWJ9+cJVZawXrRSuXRgArG46xfIeBmrTNKUPefZCDY=;
 b=CkY4MGn/Vpph2C1YE+IRA5SLE1e5baW4Y7kRh3zpBrwC1mCndfSWb8aUajnjhfdMYgpRg4mxIlCL8r/8T81vYdhFT48erQPh9alWKB/Z8Wf7l/Hb2CtknOGhhPszwNBpKuI6qPsjVqQiD3/B8cUmgPwV//hIY7hIHvEsAEGj57A=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB1894.namprd22.prod.outlook.com (2603:10b6:610:8f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Mon, 22 Feb
 2021 23:28:23 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::4030:a132:aaff:aaa9]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::4030:a132:aaff:aaa9%8]) with mapi id 15.20.3868.033; Mon, 22 Feb 2021
 23:28:23 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Data race on dev->mtu betwen __dev_set_mtu() and rawv6_send_hdrinc()
Thread-Topic: Data race on dev->mtu betwen __dev_set_mtu() and
 rawv6_send_hdrinc()
Thread-Index: AQHXCXJpLY7dYFruDUGhouewtX2XBA==
Date:   Mon, 22 Feb 2021 23:28:23 +0000
Message-ID: <6D39040C-4C5E-4CF1-8594-221F0BB38E3E@purdue.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90c64dd0-f2aa-48ad-06b4-08d8d7898c55
x-ms-traffictypediagnostic: CH2PR22MB1894:
x-microsoft-antispam-prvs: <CH2PR22MB18942BE5537620AFFCB5A51DDF819@CH2PR22MB1894.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1zi0W3gZ8eNa5R/puxnJKqlkHjrewITz8tG5pkN6gTVzUIcoEBpsOP98RS0EZ70IRsSjFbViIgMg2Z/Z22G9fj6eXhvUjJmYxreRMVCENmQJjL0wLFiWB0cmDlesBRDIvrX5hdXounpr0JP0k3mq6YMkcgNpf5/6TwFita+BGu1V+0aetpU1fX0V1DE44r/pRQdG1FKwso8l1CHlmqtqSepR7XpssX2ixHPkyvuNczsjLV/pIi9QW8xY1sJcjfThl1BBlVL54xCJ6iOnoG72xWZe8feT8yiLxIM1SwZf8XXSn7J1Re54sdObj4tY1l/UiCGBnKuGks7VqySni91cZiLKBV50/ASBeNIsBQQ6hcGfMxvKKfMbIx9gj/L8MUv1yiinqN4uE1r1QFIk//kllSjJhccc56Z4mRqVTZpt7JVD/oQp6Lcso9wVfkauA/QlhRRYdp3v10O1FqDfUjdPP59bqTvGc8JksbBbK8uOCtimHOPYB5UYaQUfGZQueRLiu47ekwGHgBDcba7jKGzWErLrtFp0v8/jVs0d2eyA02MtdBOuLIIuHNRIWCvefmxcIqSlF7mNKRk7kDLwsY6F4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(136003)(39860400002)(36756003)(786003)(2616005)(71200400001)(83380400001)(33656002)(66946007)(66556008)(316002)(64756008)(86362001)(66476007)(66446008)(6512007)(76116006)(8676002)(8936002)(5660300002)(26005)(110136005)(6506007)(4326008)(478600001)(75432002)(4744005)(2906002)(6486002)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a0tqNXh5WGdWdDg4MnpMMHdoVUtpWU9SdHhwUXRHSTlnNi8xeFpaNEgwMnhi?=
 =?utf-8?B?ZlczbjZIeXFVcitmb01LUXg0QnhEd1BuUnlXWGlSdXJlaG1mNW03SnhMN0Ex?=
 =?utf-8?B?L3phREdzOE9KTFpMNGNPeGc0aHFDRTZpSkVHTGJCTG1udlBBUkthS0xIU3Y2?=
 =?utf-8?B?MC9FSkxWRXBIdTl6bzNHc2g5VHFzZDVxUXM1b0tBYTFUWko0eXdadGo1ZE54?=
 =?utf-8?B?Zy9IdmpIbndBdW5wWkhKNGs0dzF1OE5ic0VQWWlmSWkreFBWaWNJRXVYdHdo?=
 =?utf-8?B?bEhNdW5Pam1La0NLZlN5UzNDeGFVdWNydWNvKzgxTWwzNUMxMWRKZTVncXVn?=
 =?utf-8?B?NVVTMXVyalN5dGFkSThjc1FqQUxNdE0wVURDT0hMQmxSMjdpZXFOWU1qbFl5?=
 =?utf-8?B?YVgzUExIdExKQVUwNUZXclRwRCtmUFZRa2NhaW1hUkw1OGt4UFpGMG5UVkcy?=
 =?utf-8?B?TkVwYlIvNCthUmdmb2Y0VDNhSEpyQlBLZE5EaDdESUdDVHVGVngvQTJrWGxw?=
 =?utf-8?B?MXBwWHE0a3NZQThkRlR3MlFsTzBsK0V4QnRSaUNnTkJYaVpGeWtRMVFXVVpJ?=
 =?utf-8?B?VGsrMzdFVTJRRFVhSjBTaTdMWXJyN3BVeTV5U1Z2TmhCZTBqazA2NkVEM2Ir?=
 =?utf-8?B?U3ROU0NjUXY0eTFWWlpYdlFhYWhMdnNDUXVScm1HUFhPWFQybVhpL1BvK05T?=
 =?utf-8?B?c2xieFB1MGFvSEd1WGJZbTVJeE9yeXN3ZjIzRlk3clpIS3VYTTlLV1hqR3Qx?=
 =?utf-8?B?K2ZnOXhkdzNkSjlaVDNmTHlZZE1mN3A4VEg5QTlzaTJoNllyWGIydE1LMTlV?=
 =?utf-8?B?ZVlDVGhYdW5MdXIyQVo2ajZhK3ZjWjNKOVlOaXhiUElia1ZSLzJKcU9TQk9x?=
 =?utf-8?B?RG92bko4SWtVekdvOG9NUUxUNUh6V2Jwek1WMHh4SVk2Ni9QbjdYZ3g0Wmcw?=
 =?utf-8?B?c2RackEwcUVpalo4VHZneFFqQnVkMmliV3hCVlR2ZGRsUUExeE1OaCthR2FH?=
 =?utf-8?B?WVlrRGpBL1pkNk1tYTZPVVh5cDRuR1htdjIwdkFJQ2hHcW9VbmUwb0NUVy81?=
 =?utf-8?B?Ti9XR2lhWkh1cnlyZFJ2RUF4Y2VDRHJ5Q29QL3AzdmFoZ1R2MnlDYVBvWWcx?=
 =?utf-8?B?dnIxYVp0S2FVZU5YZGJTZmtVZ0w5cEhReFNkNUE5RVpXendoM0JpQzRKbzFk?=
 =?utf-8?B?Q0pKY0RmaHVTQ1JHUVdmMGFFbytlRUhXWkdMdDNPMU8vditMaW5Vb0xBVTRR?=
 =?utf-8?B?TVl4VWRvM2V5ZktIY0pOS3dIOXk0bWxHMnVxSHBmU2JlREZveDdIaUhabGVq?=
 =?utf-8?B?TWZtSkN1STRlbmdySVh3dXJldHhFN0ZnS1BWV01Fckd5Z0d4TXZDcjNZM1dy?=
 =?utf-8?B?andNWGNHWEFpLzBjVk9IbHpSbmZiTEtsNmtabXRONGZCanVSamw1RHZ4anRi?=
 =?utf-8?B?QTJvbGw0YjV4blY3eThHZ2hBQnAzUko1M240VlRnTGhKbEVQUzlvcWZBM05W?=
 =?utf-8?B?cm83ckxtZ3Q1ZGhvY1F5Rkh3TGJYWFI0M29kbDFna09xaTlvMy9MQ2lYbHF2?=
 =?utf-8?B?ZFVnbG01SC9SUWQyNUk1SEhYOHhCUnZQSDR0YmFjT0NDNFNLOGV6K1A5bjFz?=
 =?utf-8?B?YmVlMVhjOGlSdEpVUFhJZmtlWGNReGR4NEh2bEpEZ2tqRGpzRS9NK24rVXlX?=
 =?utf-8?B?d05CQmdhNTZxOHcyU3dIbDk3QVcwZTVRSGViNWh5U2NBYnE0bnBCUElXaHZ5?=
 =?utf-8?Q?f78x10QTNtR0OiQiqoh5rQtRDKR4yrYYEkjgvOP?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <66FDD11C751D144091701A0EA986E5EB@namprd22.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c64dd0-f2aa-48ad-06b4-08d8d7898c55
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2021 23:28:23.6932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ZM3GIBrB+OqNCs3lWvdux2yuZ26HNN6Redet7SgeiR7TGV9zZn0oMlYMFZtXstTf9QDmg8ra2rn5CNE607DRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB1894
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCldlIGZvdW5kIGEgZGF0YSByYWNlIG9uIGRldi0+bXR1IGJldHdlZW4gZnVuY3Rp
b24gX19kZXZfc2V0X210dSgpIGFuZCByYXd2Nl9zZW5kX2hkcmluYygpLiBJdCBoYXBwZW5zIHdp
dGggdGhlIGZvbGxvd2luZyBpbnRlcmxlYXZpbmcuIA0KDQp3cml0ZXI6IF9fZGV2X3NldF9tdHUo
KQkJCQkJCQkJCQlyZWFkZXI6IHJhd3Y2X3NlbmRfaGRyaW5jKCkNCgkJCQkJCQkJCQkJCQkJaWYg
KGxlbmd0aCA+IHJ0LT5kc3QuZGV2LT5tdHUpIHsNCglXUklURV9PTkNFKGRldi0+bXR1LCBuZXdf
bXR1KTsNCgkJCQkJCQkJCQkJCQkJCWlwdjZfbG9jYWxfZXJyb3Ioc2ssIEVNU0dTSVpFLCBmbDYs
IHJ0LT5kc3QuZGV2LT5tdHUpOw0KDQpJZiB0aGUgd3JpdGVyIGhhcHBlbnMgdG8gY2hhbmdlIGRl
di0+bXR1IHRvIGEgdmFsdWUgdGhhdCBpcyBiaWdnZXIgdGhhbiB0aGUgdmFyaWFibGUg4oCYbGVu
Z3Ro4oCZLCB0aGVuIGlwdjZfbG9jYWxfZXJyb3Igd2lsbCByZWFkIGEgdmFsdWUgdGhhdCBkb2Vz
buKAmXQgc2F0aXNmeSB0aGlzIGNvbmRpdGlvbmFsIHN0YXRlbWVudC4gV2hpbGUgdGhlcmUgaXMg
bm8gbmVlZCB0byB1c2UgbG9jayB0byBwcm90ZWN0IHRoZSByZWFkLCBpdCBpcyBwcm9iYWJseSBi
ZXR0ZXIgdG8gb25seSByZWFkIGRldi0+bXR1IG9uY2UgaW4gcmF3djZfc2VuZF9oZHJpbmMoKS4N
Cg0KDQpUaGFua3MsDQpTaXNodWFpDQoNCg==
