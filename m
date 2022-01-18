Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A47E492FE4
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349507AbiARVEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:04:47 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:40875 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245732AbiARVEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:04:47 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IBtejv031641;
        Tue, 18 Jan 2022 16:04:25 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2057.outbound.protection.outlook.com [104.47.60.57])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnbdu0r62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:04:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDbXG0zCmmugQC80FACjvNbjVB7fWOU+eCAAr17Wh5UWxQlvPTzbNLhYrn6lB5Zv85OARHmyBhKGrKBgQQgtZpnbFfGMGp+3WeJ3sEJcDSXC2gzG+qHUazdv6Z0obJ2KvHPmteES0+Ytk/Ul+Ug6HjUAdRfrqfQILUcK/+B6eHoz69c0bSzmi2hL21rr0+YIdDPbDnzKEYnFaHHj5ORo/aC8Ym2WdjmMkq6EAcQQh8eTbmEZBYnEruFjBFZ6aoraxmfDXDafjfyuVwzrqY4DGRMW8rfpcmiTsAW6ODExjC9rQcArtdau08OP1h4vjuV5gTk4lgllC+OGsRUTRpBXyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnrYnSO2c3E0GQDzE3lSoZ9+Qykvkxoq97yZC1nyrSA=;
 b=B6tIPznu2YIKawJ2ttLLpRSvlYW0fIOnkzx1bhnqe9Yy0pYu7axzGWK6Zu7n2IinbtjYMzhLI00WQ4NFt5Kwt973V+CEYabp7310vS+F3MngG6g+68K3FLNASVhiCetoW/UK6YCyxy2JYX0vjgv2iRKuJD+mBKMc5fhZYgEF49LTMHCj7436YgW3h90WQkL8/mrrKiT35ODEgWcoUIoaMNcwW1ySEVbaA67XPpb27yY/Xim+KYYPO5+qdqaqThG99KcF0zsNl5cfR4VrzI54uL4H7Nryn9eUJ4pFIqyTgbbC0rDQSdJ3GoaDV/xJk58XksZ94/ndTd0Dyhsd1SEAZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnrYnSO2c3E0GQDzE3lSoZ9+Qykvkxoq97yZC1nyrSA=;
 b=PMLC17kGMtL4UrCRxu7WgR49K+goJEB3lfYGIOdBeHSjb4zASNBHIWcijj78LgJ5fOgfQYNqbQgRh1NKl/pRPfGJSuN1jPNqarkozdU9MbyEsKJ6YKHmwdMF57yN/Pdqkdwr9CJwI9s3BqPni/Sw1cpuULmVIgUtKrPiY0sBv6E=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB4550.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:41::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 21:04:23 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:04:23 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ariane.keller@tik.ee.ethz.ch" <ariane.keller@tik.ee.ethz.ch>
Subject: Re: [PATCH net v2 0/9] Xilinx axienet fixes
Thread-Topic: [PATCH net v2 0/9] Xilinx axienet fixes
Thread-Index: AQHYB9sgUWF+MmvI00+a3NTtxrZpe6xpSPIAgAAEH4CAAAEogA==
Date:   Tue, 18 Jan 2022 21:04:23 +0000
Message-ID: <233168d4cd7aef88d4da17570bc2f87da10337c1.camel@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
         <5a5b1c7d58b81b2a6ab738650964ea7a1c2cf99b.camel@calian.com>
         <20220118130015.3118e0de@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118130015.3118e0de@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a2f96ff-117f-4aab-34af-08d9dac61ae5
x-ms-traffictypediagnostic: YT1PR01MB4550:EE_
x-microsoft-antispam-prvs: <YT1PR01MB4550E742BB212313BC8D22D6EC589@YT1PR01MB4550.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3OuGZef831SthAI0Yo+RRPzBZZKmGGP8die3HDKFa1AHDTwOkhNg7u2RZxFzehpEl+/OmpWEZP5RnRKVYa0RNWaH7Ok32wI7DoUi2pVob/TsZyUH9rR4eb54E8Lt9osrLeVlEuVMT5t5DKyEUt+zIAbNfWxVBlcRMYSaFyYtTtd8NF6AR+6znYZO80Ob92a55spcMbBKNLGuSGo5qOxbDApxXcNsCRKVt6m6WITYPLeeDynRF8YNoYCF7Imme3Vage1NRHzzhXWzdjXBu2e9G2WqK3mPv84QUqqv+M+6b3owxoaf5SEfE/NTG0Mm7leJxEqvV+0G/KQYSyXcxWNJsn91hm/63XpmmU0SH5OhPH6jUPsTj9mytj6rEWPUmya3ruOuvbywkeo7HVn8mqzffH6+ZTCoxZQ3sU0ktE9ayOxq+56XGTXgy7JvoV0gKKkBE38ono0Vrr19gRh7qNV+lpLXOcC3J6SiTZZjGSlLwUr+y8wEJGnr2fiOZFoK/wH4TO8K5ixFoJ0EugV/RWCJt7njN+gVUMACieH0jQoEET4SvWKKWPI4vDmybHCh3G51mPl95/WWIN0WaLszITV06exOnF3oY+yzKjRPYxBXrbf1t/CJs65Mm0r3ar60aLWAJiwOan8Iw5xZe3InerVK3RRUbgUNNnU304/3snQkblpYGzN7v+3swNhC8Y+bXCqsoqRIvQvQk929qDVlgZlkiM12Qj2glMJ5AYTcUid1Z3sgvzxDMo68Ea9mM5Wu7N1Y/4wzfe+ubkafdJlzHbyGI65+DabPl8HjkwS/r+l+yhe0V8Rs6Tvy8ZE8xHOBagEgqxcE5cdroA6s1JyzOOQW60gKf8MJde99q8MJoYteWOQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(15974865002)(6506007)(6512007)(36756003)(5660300002)(8676002)(6486002)(38100700002)(508600001)(2616005)(44832011)(54906003)(83380400001)(76116006)(4326008)(122000001)(26005)(64756008)(66556008)(8936002)(66446008)(66476007)(6916009)(86362001)(316002)(71200400001)(2906002)(186003)(38070700005)(91956017)(66946007)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHZYV0hOVU9rUGN1dHROVTQrZGZqT2lhM3lrbDFNSUFSTkw3a1hMdG92amtt?=
 =?utf-8?B?anhlalBTOEU4NHkwb2hFRm1BOGRZOStuZnBYajJtdGZOTHErc0FtY1Y5VWJ0?=
 =?utf-8?B?VmE4dWlKTVk2aUtreGk0WDZDRUg2YXFrN0s1OHJuZk0zdE1hcTFCU25odUVL?=
 =?utf-8?B?SHNHUTRoT29nRkU0ODFudmNlZVVMaDBzb05aYWlEOVhGcGFrZzlvdzV1eXFz?=
 =?utf-8?B?Z2FSak8zbldFWWh3SG4yV0FqdFlhY0FBeUt1MmJjMnVPeldjeTlMb1JNdzI1?=
 =?utf-8?B?VzFPZVJEQXhRMnVYeEgvZnZMZGlFOXdFN2ExNnBUZWUwb1BON0krYk5idWxr?=
 =?utf-8?B?Z1U4VGxRMG5BN2RqYTNaVU81dURzc3pYRWFleWx2dFZMRFFDZzZTUUFuL214?=
 =?utf-8?B?d0dCUDRSZ1dYUXZRVE9OUTBjRTh0S1dJYW43VW5jNkRRMFBDYzVQbGlhQzN0?=
 =?utf-8?B?UkhleDhEZ0FuY2ZFQ2hudTFPNTV4enV0WThBTGVQaERIZTJ4eGNKaGxWaHFG?=
 =?utf-8?B?elp0RndMWnhya2haV2lROFdJTW10RVlKQmhvSnZzcFpRSTlnQXNya2lrbjlD?=
 =?utf-8?B?RmdtOGlGZGkwcURYVmh4b1lNbFdZc0pOWFdUa1lTdWlWdWwvcURGaXpzQkNo?=
 =?utf-8?B?L0xzb01PYm4wVVhucHZFR3ExekJlZXdsdytQSWs2VXFIdFZrQUV2M2FFTmpB?=
 =?utf-8?B?TGJ3WEtUYTZDR2k2UWJKd1VmZUlNWUJBUkdzZFlEUlNYeHZUMlRxMjBKSGQr?=
 =?utf-8?B?cW9lMklvM2hVeHdDcks1QUt6QnpZTUxBUkZiaTU2MzhKZElkaWFNQnE3djEw?=
 =?utf-8?B?WHJDWWhROWE0aTNVY0s3RURTazFvVnFYa2VmTm1mT3REUERQUENlS2ZsSjlG?=
 =?utf-8?B?QTJ5V0RxcGFxTXkwVmNaMTVEb2svbW9xSzdaU05EQjZucXZNZUZRTnU2MDhj?=
 =?utf-8?B?UERmWjNOd0lId2J4WTl0emVES1k2bkxWbmdaOHhibG4zS2RIaE10VDUwaGZX?=
 =?utf-8?B?Ym5TQXZxV2tZTjE1aDd3QythSjB0em5PNkNDWUpRQjVLZ2VWTkVOUTZPUzhr?=
 =?utf-8?B?bm9zM00vdDdsV3Q2SW5mR1ExMXVKR2lKb3MxbUdpZEsrZktlNTZhQXdnTzA5?=
 =?utf-8?B?NnRwU2pPejdMV0EvTjR4UVVYZzlTemV1L0dwalc4blJmZWtQd2g1eko0L1BL?=
 =?utf-8?B?YUNZK29oaGRnQXN4eXlSTzdCbEtoeHNUaDVIc0VQSFFpczhRZUsxWkE0NkpL?=
 =?utf-8?B?Y21nVWp1TGxXWGVWMnF4eUdwRTlnaGR0a2xPWkQvT1hlbTR1eEhvT0lOZHNJ?=
 =?utf-8?B?L1FhdC9lYnFYQlp5QzVod0JQcmJKRzM2c0orSTAyeW5ncFBNU0tiRkpFejI2?=
 =?utf-8?B?c2xFcE53WWJJb05jWit4c2l6Qi9zYnVaUWw2cCtONHZOMGFZbEFtb3ZlNktO?=
 =?utf-8?B?RlFDQm5LeUVPUTY0cTdHVHI0K0VPM2V2TlVHZ2hhZ1IwTzBQUVNkdk9QOEJT?=
 =?utf-8?B?SzNTMk1SdmZFcWFYSFlrZXJJMjhmTXlERUM3MEJqT2orU0c1aGg0R3NtS2tZ?=
 =?utf-8?B?U1JHQm00cHFoZXMwS0UwN0h0NzE4ZFRWSkxSbnVOS1RwQjJWZGxLV3d5citM?=
 =?utf-8?B?TEMyZ0VvLy8xSVpjTm9TenhXbDB2Y2s3SW1VTERkOGYyWDVZQzFYM01QOThR?=
 =?utf-8?B?RGFRWjdRdStTUURUSVNhMkRVN2VWcXVnUnFLRDU0anZDcUZ0OHNNZFJITWZq?=
 =?utf-8?B?dEMyK1h1aG5qNFRGVkVPWDlzWVFHTHEwTkFsd0dIcXpnc0NvbG50dHlncTUy?=
 =?utf-8?B?RGNTVld6UkxvcUliSWlDNEZERGpTZnlEMmhyK29NSDUyb1l6Z1prcG1mWllU?=
 =?utf-8?B?aUQwYXNpdXJlNlpMTTNaNTJDM1FFQy81ZCs3ZFdiQWVvcndPbHhDeURVWWVn?=
 =?utf-8?B?SmhXbThFNjhORTdtV3B5ekVwM2VlZHg5WHFsT2tXdENoNHRoRnZPY2FJcXNE?=
 =?utf-8?B?aWxHa3daTVdFVURzK3E3K2xtcU8vYkY5TUIyWDBMWmVUQUd0ajl0WEg4VmFs?=
 =?utf-8?B?TExRUkE0QTNDbnBmMGJFeU5FcWQvYm5mcEcyMGJpbzVneVlkU0xhRGc2aFlT?=
 =?utf-8?B?OEU4cmp0M2xEd29EY2txYjdwY3dKWkRMeFNaUzdjSk4zU1BrdnU3WmRNSGJK?=
 =?utf-8?B?bk12aW5HYmpETkRVVlF6cEJvRy9yMWRnNkZ5bGZEb1ZQa2hWeklUREZJSURL?=
 =?utf-8?Q?+biLd+JiDjDzmPa/NUnAfzGl90IyclzYWgyH5LQCM0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F8864F020BAF24296635551C2C89D50@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2f96ff-117f-4aab-34af-08d9dac61ae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 21:04:23.8279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YqSmfYqojxtQH6GJ+Vtv5urGcKx7DUKTc3W3Z5KJ+BgMDZoxQjYvKQoNkJJBssTNpTtqFkg+9F3yGmx/0ScoWj+sZLS16QRGNQjHfKcr+BY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB4550
X-Proofpoint-ORIG-GUID: gpe5ReuEossDgNY3PexZAcZTQLJ0fc5F
X-Proofpoint-GUID: gpe5ReuEossDgNY3PexZAcZTQLJ0fc5F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTAxLTE4IGF0IDEzOjAwIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAxOCBKYW4gMjAyMiAyMDo0NTozMSArMDAwMCBSb2JlcnQgSGFuY29jayB3cm90
ZToNCj4gPiBPbiBXZWQsIDIwMjItMDEtMTIgYXQgMTE6MzYgLTA2MDAsIFJvYmVydCBIYW5jb2Nr
IHdyb3RlOg0KPiA+ID4gVmFyaW91cyBmaXhlcyBmb3IgdGhlIFhpbGlueCBBWEkgRXRoZXJuZXQg
ZHJpdmVyLg0KPiA+ID4gDQo+ID4gPiBDaGFuZ2VkIHNpbmNlIHYxOg0KPiA+ID4gLWNvcnJlY3Rl
ZCBhIEZpeGVzIHRhZyB0byBwb2ludCB0byBtYWlubGluZSBjb21taXQNCj4gPiA+IC1zcGxpdCB1
cCByZXNldCBjaGFuZ2VzIGludG8gMyBwYXRjaGVzDQo+ID4gPiAtYWRkZWQgcmF0ZWxpbWl0IG9u
IG5ldGRldl93YXJuIGluIFRYIGJ1c3kgY2FzZQ0KPiA+ID4gDQo+ID4gPiBSb2JlcnQgSGFuY29j
ayAoOSk6DQo+ID4gPiAgIG5ldDogYXhpZW5ldDogaW5jcmVhc2UgcmVzZXQgdGltZW91dA0KPiA+
ID4gICBuZXQ6IGF4aWVuZXQ6IFdhaXQgZm9yIFBoeVJzdENtcGx0IGFmdGVyIGNvcmUgcmVzZXQN
Cj4gPiA+ICAgbmV0OiBheGllbmV0OiByZXNldCBjb3JlIG9uIGluaXRpYWxpemF0aW9uIHByaW9y
IHRvIE1ESU8gYWNjZXNzDQo+ID4gPiAgIG5ldDogYXhpZW5ldDogYWRkIG1pc3NpbmcgbWVtb3J5
IGJhcnJpZXJzDQo+ID4gPiAgIG5ldDogYXhpZW5ldDogbGltaXQgbWluaW11bSBUWCByaW5nIHNp
emUNCj4gPiA+ICAgbmV0OiBheGllbmV0OiBGaXggVFggcmluZyBzbG90IGF2YWlsYWJsZSBjaGVj
aw0KPiA+ID4gICBuZXQ6IGF4aWVuZXQ6IGZpeCBudW1iZXIgb2YgVFggcmluZyBzbG90cyBmb3Ig
YXZhaWxhYmxlIGNoZWNrDQo+ID4gPiAgIG5ldDogYXhpZW5ldDogZml4IGZvciBUWCBidXN5IGhh
bmRsaW5nDQo+ID4gPiAgIG5ldDogYXhpZW5ldDogaW5jcmVhc2UgZGVmYXVsdCBUWCByaW5nIHNp
emUgdG8gMTI4DQo+ID4gDQo+ID4gQW55IG90aGVyIGNvbW1lbnRzL3Jldmlld3Mgb24gdGhpcyBw
YXRjaCBzZXQ/IEl0J3MgbWFya2VkIGFzIENoYW5nZXMNCj4gPiBSZXF1ZXN0ZWQNCj4gPiBpbiBQ
YXRjaHdvcmssIGJ1dCBJIGRvbid0IHRoaW5rIEkgc2F3IGFueSBkaXNjdXNzaW9ucyB0aGF0IGVu
ZGVkIHVwIHdpdGgNCj4gPiBhbnkNCj4gPiBjaGFuZ2VzIGJlaW5nIGFza2VkIGZvcj8NCj4gDQo+
IFBlcmhhcHMgaXQgd2FzIGRvbmUgaW4gYW50aWNpcGF0aW9uIHRvIGZvbGxvdyB1cCB0byBSYWRo
ZXkncyBvcg0KPiBBbmRyZXcncyBxdWVzdGlvbiBidXQgc2VlbXMgbGlrZSB5b3UgYW5zd2VyZWQg
dGhvc2UuIE9yIG1heWJlIGJlY2F1c2UNCj4gb2YgdGhlIG1pc3NpbmcgQ0Mgb24gb2YgaGFuY29j
a0BzZWRzeXN0ZW1zLmNhIG9uIHBhdGNoIDU/DQoNClRoYXQncyBhY3R1YWxseSBteSBvbGQgZW1h
aWwgYWRkcmVzcyAoYmVmb3JlIHRoZSByZW5hbWluZyBmcm9tIFNFRCBTeXN0ZW1zIHRvDQpDYWxp
YW4gQVQpLiBJIHRoaW5rIGdldF9tYWludGFpbmVyLnBsIHBpY2tzIHRoYXQgdXAgYXMgSSBoYWQg
c29tZSBwYXN0IGNvbW1pdHMNCnRvIHRoZSBkcml2ZXIgd2l0aCB0aGF0IGVtYWlsLg0KDQo+IE5v
dCBzdXJlLg0KPiANCj4gQ291bGQgeW91IGZvbGQgc29tZSBvZiB0aGUgZXhwbGFuYXRpb25zIGlu
dG8gY29tbWl0IG1lc3NhZ2VzLCBhZGQNCj4gQW5kcmV3J3MgQWNrcyBhbmQgcG9zdCBhIHYzPyAN
Cj4gDQo+IFdlIGNvdWxkIHByb2JhYmx5IGFwcGx5IGFzIGlzIGJ1dCBzaW5jZSBpdCB3YXMgbWFy
a2VkIGFzIENoYW5nZXMNCj4gUmVxdWVzdGVkIEkgY2FuJ3QgYmUgc3VyZSBzb21lb25lIGhhc24n
dCBzdG9wcGVkIHJldmlld2luZyBpbg0KPiBhbnRpY2lwYXRpb24gb2YgdjMuDQoNCkNhbiBkby4N
Cg0KPiANCj4gVGhhbmtzIQ0KLS0gDQpSb2JlcnQgSGFuY29jaw0KU2VuaW9yIEhhcmR3YXJlIERl
c2lnbmVyLCBDYWxpYW4gQWR2YW5jZWQgVGVjaG5vbG9naWVzDQp3d3cuY2FsaWFuLmNvbQ0K
