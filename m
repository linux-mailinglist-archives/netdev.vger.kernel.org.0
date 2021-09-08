Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519E84033E2
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 07:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbhIHFqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 01:46:13 -0400
Received: from mail-eopbgr1410108.outbound.protection.outlook.com ([40.107.141.108]:35648
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232277AbhIHFqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 01:46:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsHqSSFl4UE/5HOuv/05aGryyjfUHxXhn4vVwzLOjGdXeCuoW4Es/WVoR/fmrJDacc+A8F6Eajhs8Z9a1WpLX7Yp+wISi+Tf4uA40vh6kyc3JAsiqvrUfVElmMFPU4OSDmEkCz0xGEQWg5yKroWx0Fjk7Jm6+txyrbC2/5otWnhrZDsXMsBFuiD+ztoac7OM1xffew6SvaZcWIME8NuchSUtBWSXSH4FaudX0DhsXsiLbPcfjb6U4GUoMY97HI3W3fxjDj40+aLWiqv5zaiH52BTAy3VbC9BQGpAmUAf6OMbsUjphCglLNmi/QR+Cwz8VdFLo77vOS6ela3cWoZa3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qDlth7Gzva2jdX+bXAraHZZZSVlQU3XugUJ9fZRkbVw=;
 b=C686R2tXJDg7mXMDOflGgliwoom9dhfPceS8G32cLF/kR0U4ssSVBQaRlpyNTSNYD6tgp7Iwa6wavmxS6iN74GT7ZOkxdSHFQz/ay4CpREPcZqbYzfqLpXnedkgwuqzjIgsYgQH5s9rQvzShcZDtjtcFBRr6B6c6pt3T48LYFvxNBdx8Nam9WB0yB7WQmhGUni3qFc1gx+MwcB5jOvuyTpzwapGzpjj9yYelRH34KsQWds3EHH/fdQ1RrGvBTTrlo/KlzhNuIizZJl3LhZYPgKqb6GYcrZOElM+qu9Y6R5QS8u5PY/dWkHyLIgP1+PbkLwF4mUPvQviADJg/CthPBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDlth7Gzva2jdX+bXAraHZZZSVlQU3XugUJ9fZRkbVw=;
 b=qSi/M340rPHYT7t96AkssCE6Q1zOsiSwykYU2lXCIh0O4cf+zqjGWGfjKlNIoKdS26XHphC09nJHoaJdk12tQ4tYsMX1xCGWFU3RvdIUosvl0zokrxb7T0gFFyxFEgIACwjhZfUs5kd7esbdnsrz6YP6ldUg3q3hI/IxFDj13E0=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYCPR01MB6429.jpnprd01.prod.outlook.com (2603:1096:400:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 05:45:01 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::b10a:f267:d52c:1e5b]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::b10a:f267:d52c:1e5b%3]) with mapi id 15.20.4478.026; Wed, 8 Sep 2021
 05:45:01 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH] net: renesas: sh_eth: Fix freeing wrong tx descriptor
Thread-Topic: [PATCH] net: renesas: sh_eth: Fix freeing wrong tx descriptor
Thread-Index: AQHXo9u81SMMhOXtDE2P4NymXZOfj6uY9cIAgACpn8A=
Date:   Wed, 8 Sep 2021 05:45:01 +0000
Message-ID: <TY2PR01MB36924D8258BD1C8E3287136DD8D49@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210907112940.967985-1-yoshihiro.shimoda.uh@renesas.com>
 <a610ac4b-eeb9-50c2-4b88-0d77d1c83d47@omp.ru>
In-Reply-To: <a610ac4b-eeb9-50c2-4b88-0d77d1c83d47@omp.ru>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ed44edb-b841-4deb-2132-08d9728bcce9
x-ms-traffictypediagnostic: TYCPR01MB6429:
x-microsoft-antispam-prvs: <TYCPR01MB642987DEAF45554303232716D8D49@TYCPR01MB6429.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qhzSpfTCeMKpcqhTRzu23IoKcWonsZlLkfy7T6tFSFa7uBTa4TKpOkHvX/bOph2MrF109ZC4sVzxSMKVdYr0L8cBwxr8rs9K25hbvSqumDv0zn0op22bKvIg+WMKy6JAwqpmOPMxTm4sXDGQFtwzuF9k8i1BoXMtfOWigGCc2bz9FyrmJW0RXIuCEDmhMNqw2F3tQrYh+GbFrfgb1ne4riH+Fyp9/wpKRuvNLTcW6Idue3iwJZoZjp8pGKb+TFXSUUr50OUBIqe0E0CvOx+543SE6Vseqwvb+znYlTygOJRyx60k3oEgMq35xRWfZLwujYYjGCyP2ic8EQBWyVRfm95oMvK99AsgU+6MzMPGmpb2Sk/kF1um9zKrN14PneoLfaq2/kg9aTMsy9ggGGeNlxy2vssWX4s5tncvMZDZZ08EQmbCQIWxYzdzS9KtFqGZZvpyeUgAtKXwWGnKOMJ8lpPcAjlcl1D/7vvrn1RIGaIf8cmqDIw1Vb55NHye5LltSMRc8y4E50WgvZ0mQZD9tL1UR1RtPAxTpbVm3hugjviOnxd0OBFO7yp7SEaUBfT1rySUBEVvPa3TTxr7kF4oItcKWgnHFo/9KJvjfDt1jHjKqBFyU9/V7D1r865ypOctPAUJCgejzyhUFFCywMb1B9RByNUxnKaUrTCsjuusTnYG20R84LxHsPIk0NJDwJG/7t1/4PyjAc+6vWD/paJ6eQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(4326008)(86362001)(71200400001)(66946007)(76116006)(5660300002)(478600001)(186003)(38070700005)(83380400001)(66476007)(9686003)(33656002)(55016002)(8936002)(2906002)(8676002)(6506007)(110136005)(7696005)(64756008)(66446008)(38100700002)(54906003)(52536014)(122000001)(4744005)(53546011)(316002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmJQWFBaYTBUZmtxczNPd0pUcTVrUlkvd0Y4enJrUFJoOEJUamJkR1F0NHFR?=
 =?utf-8?B?UXgxaU04VkNvY1RqOHcyTnB6b1AvQU85dlg4WDJMUGlaRUo2Smp1RTZKMllj?=
 =?utf-8?B?NDN4dWNBU2pHUW9kSjZNTTBBMmxJV1A1Z1Y1YzYwQ0FDcXpyL2lBM1drTUNx?=
 =?utf-8?B?VXpvRy9hVTlkMVZ3QXJLV3ZQb09EdzVYeHh3N2dlU2pmcTN5ejg1cUJXVXZj?=
 =?utf-8?B?R1NJMDNzLzVScEhxbndyWURlQU5aZlZIRnZTYllLOEFFRE9zclJHUStrRmJL?=
 =?utf-8?B?aDdkT25KRy9LMW9aT3YyMFZlcVQvZnAvRjBLWVB4SzNpVHpGQzdPWXRCT01E?=
 =?utf-8?B?R3BPeE13ejhzZStFTFZXbFBSbGNNRU54MlJKc3d2R1pURnRWZ2kzaUhBenBj?=
 =?utf-8?B?azkxQ3Y4eUdQSWplYTRGekloNmV0YlNWdkMzYVkvTlYzak8xME5vUnBadFlM?=
 =?utf-8?B?OCtIQlJadkYzd1hBMkl3RUdVMGlnb2JQUHM4SDUyZXBVUUM2RjFOTVY2R0RW?=
 =?utf-8?B?WWYrTnFQTkhXdTV0YjJnU05rM1Q4d3hIVGZqNmFkdGpjZVBjT2NsSVBhei80?=
 =?utf-8?B?ZXB6VC9TVk9EbG1pM0ViTnpHNWdpUGYyMXM5a2hrdUM5Ti9RS2U5RDJISWVK?=
 =?utf-8?B?RzZFbkRhMWZhVVVBUG9LNVVITFBlMFNFb01BTHkwNEtCWXIxVHlnbVFXQlNy?=
 =?utf-8?B?NzdvTXVvNk5SYTlsTnBZVmVsWjFjMDM2NFZOMDYzdE1ZOHVKMFI0WHBUamFl?=
 =?utf-8?B?bEdhaHI4aWg5L3dvbnhuN2prQmZ6d2lYRWJBRE8zK3ZEczhFTEpDOE5YUVhw?=
 =?utf-8?B?OFVhU0N2cVJtUDh4bTlqM1EyVlJJaEdjQUlsSWRYTWJkQlhjakFYM2FQczdC?=
 =?utf-8?B?bitzMnFyZDEyN01FdEdmVW94VDQrU01PVzYraFhpMmFlbXVRK3FKdVI5N1E1?=
 =?utf-8?B?eVYvRFlKVVNwZ3V5enpMM0FwVDR2aEdZSGtFcGxFSUgrUGJjdVRKMWFuUnJ4?=
 =?utf-8?B?SjFnZzErclNsMEYycW05SzdIVmZpb29LWHZBYjIwVUJOVW5aSE9FdXVPYmhS?=
 =?utf-8?B?UEVIV3dMV1IzYUlSb090SFV0TGpybHpMeXI1REx0U1g1Ulk5NXlvZ1V6a1h3?=
 =?utf-8?B?K3BqN01tK2pyeXk1VkpIZDl6MGY4TEY4TjZ5UVFOaUh4RTloWFJHK2hnN2xD?=
 =?utf-8?B?Nm5OblZLZDhCcXpDNDNwUHFyNnVwMExhKzNHVWRHR0x3YW5NWE5kR05WdE9o?=
 =?utf-8?B?VDQxUmt6TVFtakU0Nk1DZW10OWllZm5pSzdDRmNlcXhOcEtiTmhlK1hINzEx?=
 =?utf-8?B?L0thMlVDSzB4ZHQ0VnJQZm0zNWlNV1BHMGdrK3hEaDhZNDZlRGlSU1dxYTZl?=
 =?utf-8?B?K3kxNEplZis4RGYwRzZNdWhGZ0JnbUovUXoweEVnbW5ZZWZIRzdReVVDWXg4?=
 =?utf-8?B?MTA5cFdCd2FGSFF0eGRVdVRUWnI2Z05aNCtPSGk0WXRreDdHUnNWMUl3bUZL?=
 =?utf-8?B?R2JCenY3R1pLQWdFMGVENDlOalV6Z2p4YjFSakxmZFkwLzZoTTdYQ0UxUW15?=
 =?utf-8?B?THhEcnViNjJITG85K205c21ra0dRa1djR2g2cFg5bTR4YWJSUFR0akdOWnRk?=
 =?utf-8?B?Uk5uemtYOFFFbitmSnVXQ0xMSHl5eE9NN1ZmR0N1anRUcEFHK3dEMUZKcTFi?=
 =?utf-8?B?dEN4Sk5FYmROYmQ2VW9ZdzZsMW1VbFBXZ2x4NkdIUlJVai9sMXlZMEwrWWlD?=
 =?utf-8?B?OVptSlhsbzNHeHlPMktiODNwYmpCOHlTZTJIcWdsTVVaSWI2U2tqTnZHR3ZR?=
 =?utf-8?Q?etudihqiBckxUu3Ioaz6XKE2mU+rq7tbFGeOs=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed44edb-b841-4deb-2132-08d9728bcce9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 05:45:01.1747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9NuEAWvehXGRnsyy5QutWIwOYlZPOKnpVVaHgvxy0btKVhJ1dcq94TZx5mpFbrXF19WHsWoCf/aGrlnaFWgjNZ+TM3oWHI4pEeO46rzsP2VlQKGF718xj5dXOUtXhF83
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IEZyb206IFNlcmdleSBTaHR5bHlvdiwgU2VudDogV2VkbmVzZGF5LCBT
ZXB0ZW1iZXIgOCwgMjAyMSA0OjMwIEFNDQo+IA0KPiBPbiA5LzcvMjEgMjoyOSBQTSwgWW9zaGlo
aXJvIFNoaW1vZGEgd3JvdGU6DQo+IA0KPiA+IFRoZSBjdXJfdHggY291bnRlciBtdXN0IGJlIGlu
Y3JlbWVudGVkIGFmdGVyIFRBQ1QgYml0IG9mDQo+ID4gdHhkZXNjLT5zdGF0dXMgd2FzIHNldC4g
SG93ZXZlciwgYSBDUFUgaXMgcG9zc2libGUgdG8gcmVvcmRlcg0KPiA+IGluc3RydWN0aW9ucyBh
bmQvb3IgbWVtb3J5IGFjY2Vzc2VzIGJldHdlZW4gY3VyX3R4IGFuZA0KPiA+IHR4ZGVzYy0+c3Rh
dHVzLiBBbmQgdGhlbiwgaWYgVFggaW50ZXJydXB0IGhhcHBlbmVkIGF0IHN1Y2ggYQ0KPiA+IHRp
bWluZywgdGhlIHNoX2V0aF90eF9mcmVlKCkgbWF5IGZyZWUgdGhlIGRlc2NyaXB0b3Igd3Jvbmds
eS4NCj4gPiBTbywgYWRkIHdtYigpIGJlZm9yZSBjdXJfdHgrKy4NCj4gDQo+ICAgIE5vdCBkbWFf
d21iKCk/IDotKQ0KDQpPbiBhcm12OCwgZG1hX3dtYigpIGlzIERNQiBPU0hTVCwgYW5kIHdtYigp
IGlzIERTQiBTVC4NCklJVUMsIERNQiBPU0hTVCBpcyBub3QgYWZmZWN0ZWQgdGhlIG9yZGVyaW5n
IG9mIGluc3RydWN0aW9ucy4NClNvLCB3ZSBoYXZlIHRvIHVzZSB3bWIoKS4NCg0KPiA+IE90aGVy
d2lzZSBORVRERVYgV0FUQ0hET0cgdGltZW91dCBpcyBwb3NzaWJsZSB0byBoYXBwZW4uDQo+ID4N
Cj4gPiBGaXhlczogODZhNzRmZjIxYTdhICgibmV0OiBzaF9ldGg6IGFkZCBzdXBwb3J0IGZvciBS
ZW5lc2FzIFN1cGVySCBFdGhlcm5ldCIpDQo+ID4gU2lnbmVkLW9mZi1ieTogWW9zaGloaXJvIFNo
aW1vZGEgPHlvc2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPg0KPiANCj4gUmV2aWV3ZWQt
Ynk6IFNlcmdleSBTaHR5bHlvdiA8cy5zaHR5bHlvdkBvbXAucnU+DQoNClRoYW5rIHlvdSBmb3Ig
eW91ciByZXZpZXchDQoNCkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGltb2RhDQoNCg==
