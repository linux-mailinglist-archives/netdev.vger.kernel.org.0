Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4756D66E5
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbjDDPMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjDDPMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:12:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795FD3A9F;
        Tue,  4 Apr 2023 08:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680621143; x=1712157143;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fAHo80eoeE1/9Slu8laxUzZcTV2wD369lITOahzOI48=;
  b=URCVY2opXeWE0TlFXeBr/quFKSi+D5aclscSMwosrOjm2pyLioIAU4sY
   H6KaE4dL4tufOcPiXeRjd86uXAkaHs3CWS6xrEbsDHqGAzceQsvkS7At6
   1P0KEGETjaAcO/l00RD93XHnIv3mfPRnm/w5PQOg6uY8hjixvHroTpjzI
   lMGlGrEWSGsSj8wVBUEhDpseb3s7G1LrnG7pmHSVUNG5YuYoXyrBAATco
   umWs/qz8icx8ZdbyU3tOWeu9qWzsuM63pWkIeEsfoccT3VAH+XYVrF6eX
   nTVA/a6U2/+8OOWxiXFZaqFJSHlmG8MGLKXqbOIvxejifBH7K/Gq7V58W
   w==;
X-IronPort-AV: E=Sophos;i="5.98,318,1673938800"; 
   d="scan'208";a="204948037"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2023 08:12:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 08:12:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 08:12:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMqd8eE2A+gfoa+LAa8TDvpn+0svAkWPoBbI/WzcOv+fc+MT1qekUE8fmhRvkjt2aO2RfHJ9JDiWH3m2JK+s2WmWejnIClI48YDyCdjDih3zOTnt61rhE0SYrUpQlo9WB7xdJnvlPdlkjHEyFlIFL9yvF9HcV1zZof2qIfZTZl0UMBzIwrBaNMpeqcxicXYgunan1vaG1KPHTiLkUD4t1ObNhR7y0to46Kw2TFomgvJiVmmbpjjZ/1ZjlsIL8W3Syfj9WjeVH5VueKhWfInr6Egy/rS7KuBROX1j3GOflfAllDiyv/Tt3A8l5xUp9Mm5PlyWhk3sePWVrrSkR9/ipQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAHo80eoeE1/9Slu8laxUzZcTV2wD369lITOahzOI48=;
 b=UjWEizOySAf4vwjs+BAqw1OuVqRmn63fP/9LB2F0OUKyK4GE5imRo7Sr8+DJKIWWpq3T8qVaZDnrteL0Z+l/5Bb6Bz163RKc6qFp/K2/WNng+JuGHHxJm89OnaNhtp+Biv8T8qudXr/aLdgHCS2Zf6l0LcG3yw+8k/Q0FBIe/tRj4VOCuFXWC8LnCoJZlwxjoGlTATtrJvsJThazLo32jh34+/TPzUIJTpdRKQKuEOVs8uOWhOGzmslw3Enxv1Cpx2dz3GXR2m+hBwSGwuA7Peebp961U1/xhoVGehXxdxPpzzsbxxZndH2fKSRk4+sBzJ7wuahBGAPNoI37RGfGEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAHo80eoeE1/9Slu8laxUzZcTV2wD369lITOahzOI48=;
 b=qFcG/saGVgd89AyxRJ8OxbUHuqU4eN6VjKP0+XraQ1nPXUsfYp0CclrltLcX5TbvQ1MuSC0cNkt7urjDd4Gd+ymNuW5qKLJvpzXUvcAwYbeqXWVvkE7agceZag+RUxn9mFdiXqOh0WBOIM5B6W0PSyXLvEIHM6cVNlojsmnitlU=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 LV2PR11MB5974.namprd11.prod.outlook.com (2603:10b6:408:17e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 15:12:20 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::5fe7:4572:62d7:a88]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::5fe7:4572:62d7:a88%6]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:12:20 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v1 5/7] net: dsa: microchip:
 ksz8_r_sta_mac_table(): Utilize error values from read/write functions
Thread-Topic: [PATCH net-next v1 5/7] net: dsa: microchip:
 ksz8_r_sta_mac_table(): Utilize error values from read/write functions
Thread-Index: AQHZZt8CL2nQURTQiUOH0df2Z9Hat68bQfMA
Date:   Tue, 4 Apr 2023 15:12:20 +0000
Message-ID: <50b2aea917074932684168f730b5c75f02bfd9db.camel@microchip.com>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
         <20230404101842.1382986-6-o.rempel@pengutronix.de>
In-Reply-To: <20230404101842.1382986-6-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|LV2PR11MB5974:EE_
x-ms-office365-filtering-correlation-id: dfb619bf-9492-4b98-c80f-08db351efc99
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HgBrldNzJBZ4sdMnMmioQTFH/uI6dTiNVVAVDNBCCvFxWgmFPTKYzQxpvuK2PYhR5fXnzc4BPbLKyshX90RK9fb56nc/T0Ha7N0+bFVUvmpnoN5qryb1qyd98V1Uix0RKdQoWpaLkbvdDtQ4hjptq5iZ08+49mZr4aS+22hSh9TKhCI/pl36IS2hXV/ammLW365aoIjEig8lJMEgxjqTbPLV1hxzQKMALxmy0D9XVKgW1V/YZpmWjhbAl4mZdN5PbjL721izY+EDVEMinVOEP4CU6GwQvu+wJ7gK5l+d/ZyEwhFQFJX1PCqXCgIowHXVNMy278oQwDQpt0+owywctYv3TuLmFGIKx82a1Q4HKS+xqY0266zhVKRgziBA1yOHmnq6LRWjU5pz9EpHahgyfMaK+P9tyeNdIFZzmTzHi7SuulbspOwDAOdMHWeGNNDsEUBxMx4GH0cA+MXmBjmNSTNds1yOdY32B9u8ntcagtG59Q3d8A6k04cWb9vuWJiqwxqlzjg+geeMnCeGTcUn4KfaUt7nec6ZObTGD2yDCmdXTmB4KNA+BTSB4io3sXzkcu8BNM4vjAmLHHuNCX12mjIE8/uN3RkjP2IIqAHtLIUyENUjc+xrXS84l6ApUxf9UUMVVmqBd1pRtEMBKyRVjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199021)(7416002)(4744005)(6506007)(2616005)(122000001)(38100700002)(6512007)(186003)(38070700005)(86362001)(8676002)(5660300002)(41300700001)(8936002)(110136005)(478600001)(71200400001)(6486002)(316002)(36756003)(64756008)(66946007)(4326008)(91956017)(76116006)(66556008)(66446008)(54906003)(66476007)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEFEc0l6UVROWGE3Y0k1bGFHemxDZUNZdklOMGVzTmFBaVJFbGlaVzRCY0lC?=
 =?utf-8?B?aVQyd1ZqNXZyQmNCcG1ycHlRbW5ydWN3RGdoTFFzWnpFT1pTK3dHMHZYMmZN?=
 =?utf-8?B?UzIwV3pIRlplMUlrVVpVaWRDdGllWUVtTEZDb2ZlSHNtUVFKTVNVQkpORXY3?=
 =?utf-8?B?L0NxMTVPYm9hWU4wRFFvWDBrbUxkeFlrVzE0RFZyS3dZT3lRaFBvOXNSZVBS?=
 =?utf-8?B?WWo4bXc3K3FoOG93aFNwdmdvT2o1MlRPMCtiUmp0N3I0MkdUUHl4eUV1UWFr?=
 =?utf-8?B?S0lNTDF0U1JFSHZITG54Y1FYYzdGMkRTWWdOY0pZUUk3TWcyTzZ4YTlxRXRF?=
 =?utf-8?B?RXZTYlJvUHROallWUjVqYWErY0o5ZzduWElZUHU0eWZsSkN6QzI5KzdLQW96?=
 =?utf-8?B?UmxjOXJIODNPNnhSaytuVnp4alMxNHkyanJhTWQzK2szcm1wR2JLdVBQNlV6?=
 =?utf-8?B?WUtnNEoxQUlISnUzNmpTTnF2NmVVNE42YUFmV3ZPSzhqZlVHZEhUVDhNOVhU?=
 =?utf-8?B?TEM2WUp6T1dGcTlSQUdteFVxVGR2NW13QkUrN0VwbjRNb1dGQk1IN3hHWFNQ?=
 =?utf-8?B?UmI0dFVNTmdqNUNvbUx6SWpUaUp4MnVSSXZOa2p6WnJCMkJiYklQbGdSdTJr?=
 =?utf-8?B?Q1p1NDFJaTdaek50dnlpS2g4clg0TkhkK1h3VHhDVU1oUEtOT0pQSVlBZGFW?=
 =?utf-8?B?UnBNYTBJOFVJREQ5Q3NCV0hvNlVwVStBUk8vUE81Y1FsRkZqS0RkNUc1VGJm?=
 =?utf-8?B?UFRZV1dTdGdCbmU0SWZDa1M3VFhhb2p0TnMza3FvSjBDYmpXcUoxU0t5cGtx?=
 =?utf-8?B?UlVudEEvWTFPUTFsOGVaUmRwQTQrMkpBNGpJRngrWDFPRGxPMUI2Z0J6TS91?=
 =?utf-8?B?NlVHd0hPYXdkd1g0cUxYVzQyTnFZc0pac285YVB6S3VqVWhEckZOaDlVNmta?=
 =?utf-8?B?SFB1R1VLbmNzOGptNVpKN25FVVFRcE4vNTNZak5QNE80R09GM0h5Wk1wSEp3?=
 =?utf-8?B?a3JlakVGUkFLRitrY01vYVNQaEtDQlVPVjVmWUxqU0Rjbll3NHVkeFk2RG9R?=
 =?utf-8?B?MFdaWnFENU1UQXpGOHM0d1hRSVFlMWw1NnF4TVNzYlRacnJ6UVZidEJMclNY?=
 =?utf-8?B?L2VoZVowQ0E2SUdtRm9hSlN5TXY1WjE4bjdKcTFrenU4YUozTDV5bmtndzN3?=
 =?utf-8?B?ZlE3Zjl1VzlUa1h0SUNQeHYxZzBjWGZTOHdmZ2NqUTlaK21aYjVVU3ZEbWow?=
 =?utf-8?B?QUVaSjVrT0RBdURZaTlHZXpLWmdqRTJoTEQzMSt1WVU4eHN2dFAzbE0rZFJv?=
 =?utf-8?B?M2w2Y3NNNS9rRXVnYVd2dDdYUVFxMEp3NWNSZjJDTHVnaHlHQ2xXTGtGZm9T?=
 =?utf-8?B?ak5vWEhuZmJ3QWluT0lObjcwRE5rRUZuajcwaDZiRi9QMEhTVFV5ZENqQ0VC?=
 =?utf-8?B?RUlxdGpveDVvenRGNXJ2UUNXZlpwT3JVT1phTWNjZmtSa0ZRM2I1d0p4M0pl?=
 =?utf-8?B?VWpndUtYVU5sMXBsZkk3cFd5OTVPQkFHYXRnS0g3SWhXOGpqK2E5Z1JFT09S?=
 =?utf-8?B?a0xmTGZhNUV5VDFCRVdMZlJWd2czSGpJOEMxUml0UGZycFVReVZkaFM3Nm9M?=
 =?utf-8?B?N3NKQm16OVRqbnZYMjlDNXV5MEtjNUl3d0dGQlU0TW56K3JMWVRicllGRVlR?=
 =?utf-8?B?c1RTcmhFdHFJS2NMcnhoeXFIRlo0T3QzSFc1KzlaYWZEaGVlY0IwejBQemJj?=
 =?utf-8?B?bmhhWFBBWTI3U0hBNDZSRm9wZWd0ZlJaWjRrNW04bWthWHhSOXRMcVRDUkha?=
 =?utf-8?B?d2RNQTdFWVdibWh0SmUyaVczazd1UjYxNVFoV2ZHRko3NU5oY0NsTTN5STZh?=
 =?utf-8?B?UWVBSGNsOFhJcGlZOTl4QVcwck4vd0xGRWZGSDhMOUxtZ3Y1emxlTTFWYUUr?=
 =?utf-8?B?VkJ5NmxkUkxTaEd3MnJvN1ZNQmlCdmJlSittS0I4NVJ2aXJoVVpQV0JiLytH?=
 =?utf-8?B?dkRydWU1VU5rWkI2clBzSWZhRGZURHRUYStpUHJtc3I5MzFSTTEwTUdHU3hj?=
 =?utf-8?B?a3BWaVJDbmlWNTR5a2s5cG41NDFXUUk3YS9TcW5tVldGOUg1K0MrVUpoeEhJ?=
 =?utf-8?B?cTRNNnp4L3dSS3hBd3FROXJDak5makNmTlVSVjhISmhrWWFRMEZ5NWdlYWtt?=
 =?utf-8?B?cXoxRG9zVXVsRVNNajc3eFNFTFgvUzZLNGZiQWpkSWRTWUtZVVUyZ1ZWRStB?=
 =?utf-8?B?N25QaUVUL0pLSFBML2RxSWFWaHd3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E81F32EAB160FD4D839912981B72B7A9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb619bf-9492-4b98-c80f-08db351efc99
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 15:12:20.5826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qUfw0RTpm2B6sB7lGogBY1nmYuQrkvPKh6aQsTn9D8wn0AutOq10nHV4L7YbQVFELS6BCaTQnCnfr+42H5L/np8sgEQfJ94wMgCCKyPzxZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5974
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gVHVlLCAyMDIzLTA0LTA0IGF0IDEyOjE4ICswMjAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBUYWtlIGFkdmFudGFnZSBvZiB0aGUgcmV0dXJuIHZhbHVlcyBwcm92aWRlZCBieSByZWFk
L3dyaXRlIGZ1bmN0aW9ucw0KPiBpbg0KPiBrc3o4X3Jfc3RhX21hY190YWJsZSgpIHRvIGhhbmRs
ZSBjYXNlcyB3aGVyZSByZWFkL3dyaXRlIG9wZXJhdGlvbnMNCj4gbWF5DQo+IGZhaWwuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+
DQoNCkFja2VkLWJ5OiBBcnVuIFJhbWFkb3NzIDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5jb20+
DQoNCg==
