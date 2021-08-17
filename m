Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08D83EF4EB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 23:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhHQV0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 17:26:08 -0400
Received: from mail-vi1eur05on2132.outbound.protection.outlook.com ([40.107.21.132]:14176
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230515AbhHQV0H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 17:26:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i40+KjjVmEaLofUXngWKt6SqdxapuG/A8hkvtsl+3e1Fu6yDNzqLBZQDRypktGz0Gw3lTcxnpWbkGh6dLQKQPotgzq6AYU7Bwfb7x3TtamqyFux4qngGDbBnAp/5vG1OfVpQeP0ykMdrqmyP/Crn6TM8xKSNgkrsAMEmzQPIb2pByfiHZLMuCMFmcnXo4f9ynButpgap9H+EgDd12xmuzAuqJ702lOjsOKaNj+vBr2iXM5U7/iM8iUHG7MeuikelwsMw6ps4xmOoQGtfB6d4G7iwaG5CFsx00++WMG4Mmi6JMhzzO5LrdLGH0xt1a3+KCwQ+Iq2VXtckoxEHvdMF1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xt+LeyZK9XOfO/GsNBpAmAS9H22eaaHh0WECQWf4iVc=;
 b=eW1RLJCXCnPipEQ9QXRn8oQICETRUU0z9W4P500QRKiBupaiLzf78ejx4nTJWRZtwhTYrgM7S9YjIjvQNcrfUdMQiD0duONoeNi7Ng7k//MzyzqL0ikv6E8Z8ixAmNCefO/ppgJi7tURsYIaMs0OYHmbGJ3ssK/hzNadtrO6WiDWXu3mQXg/mfKku7Sfvrzd3h+IO/CsOH6Sbys/+/MT/CKveDJ4KUmSdkL06ljEMkcWWQkInD1rOY9RYh45Ay+7M+b22+NSmGh7MBOC/umTQl+2tFwrwhFmcqEjR2gbOlOZYOYPqFi/Js84KJoQCS9x164NHJxoEAj1JeukMyC9+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xt+LeyZK9XOfO/GsNBpAmAS9H22eaaHh0WECQWf4iVc=;
 b=DimeloluE67R/DHjvU8xI55FdOML9aHBb0hG6IM1myclY4GV+1gXwJejlt7Bybk2Wwab4FsvbOZWLALDosSuE5neMSf6A4lAN2rSMoHthkGlvkhfyztgleXz55xHX6r8Hd3WQhWJuPHz+Pm6RgHv5cDIhJcetaclD5nI497IBic=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2666.eurprd03.prod.outlook.com (2603:10a6:3:ef::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.16; Tue, 17 Aug 2021 21:25:29 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 21:25:28 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Thread-Topic: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Thread-Index: AQHXk3edAldLqW55BEm1kFydkTRTGqt4NdyA
Date:   Tue, 17 Aug 2021 21:25:28 +0000
Message-ID: <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6805aeb2-ea22-4aa5-4f7a-08d961c5892d
x-ms-traffictypediagnostic: HE1PR0302MB2666:
x-microsoft-antispam-prvs: <HE1PR0302MB26665FA7416F5B33963A9A0683FE9@HE1PR0302MB2666.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ufddkd/Vfb8vDjsvv5n+uCp7L/yk9Eqsa2VG/6nNC7J/2MEsUq1oiBN7I2+TSbRHkvbjYZQD80D2SYKcZsqsCtbqWsMClfeHo7JkrLMYh1C3GAgsrSsiRf67lRAI6trOHaiDOY/Z4J3w2wzSOCQbmaKdbNxhTDJakW7x1aOe0U6B55Y1RVz1DhF3Gl734kRU49ZNcu0BfSl7xaw2zXpFbdCkPuqjhn9I+tQBk4150RsWrLET7bW5mMKQC2p7zHhNX6N4pYN1erjVMmJ/OPm0xEZ0E4eiQoi+H+D7bZ6dXtev7RtvEj7/p2WES2jmkYsyDUEsRkijMGh6bs5sB5WFk4i92JYILBJhzZUc0vBJvmxIqKSh/3t7whOhIX6E9CASjiPHyRNN4hnkf8sSPcB4+qEPoJy7IGMeWgftnWhpHf7OxzOc/0NhVnUnd4yfohv6VqxW5ZLz0m4zVocu/0ovtzcx9sWdk9n9ceq/c3AboXtsoGaU2dSt1rPHS7Snn21L6A/FeGpGgIdqzGmU2VCXNa0uVUO7vzSPlNSPSMIotv3v0OSYFDhEQwfqnQfI8nkbYD4ge8e8zF/r7//QzT7XWdeOgHQ1WOamDxa4Q5Phw1rZbRAAOe0W+1J0NI8u0vHZSHBeAhVJ3rH7lrn+ziphK0/+08CfuEyOgjQtO/HtqbCUWr1KENKIk0F98utOK+iYzD4Kh0XxsSFCLTvatc7eguF5nu1hVd2YQNRIX6JXpp3oBCR/q6os5fweHmGUIy1cwiopZE2k35u7d/6+NNockVVbk+Wtdq/lJ3Y6e172eXy0iW2os+O25MJVHI4IQYYN4/owBm/qYcfh8KqM4klcusVy3Fczmbgv4fJzP/9N39A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39840400004)(396003)(376002)(136003)(54906003)(186003)(478600001)(85182001)(5660300002)(8936002)(6506007)(966005)(26005)(38100700002)(8976002)(31696002)(86362001)(53546011)(122000001)(36756003)(2616005)(85202003)(6486002)(31686004)(110136005)(316002)(83380400001)(2906002)(4326008)(66946007)(38070700005)(6512007)(91956017)(76116006)(71200400001)(7416002)(66476007)(66556008)(8676002)(66446008)(64756008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGFHdmh3YlIwV3FaeHJBRFUxdzlnZHNZRVpKVmp1cnRIamJidjQvYTJxa2Nv?=
 =?utf-8?B?SjR4VnlvaTNTYXQ0VzBFMUJ0cFFXalFnU0kzbnozN0hpT3V2MnpyUWU5eGZ0?=
 =?utf-8?B?ZmlGV3RrR2tORmlaMkZMQ25DbjZxbkhjcEhMQjVEMFhuMXFZajRTWjdiWlhV?=
 =?utf-8?B?TWx3Q2hzV0tMWTcwV0NoVm50K3dUY0twOUZzRENFam96c2tyRWo3UGI2bTBm?=
 =?utf-8?B?V3hDSHZTVFMva04zNnB3Z1dTbzdHYzZhQkx0TVpubkVnc1hNeVlqTDJpRkJI?=
 =?utf-8?B?U0lFTWZmWkZuVS9vQjRGaUpJMm41WTNlSHYxbTVLVDl4eUt3SjV2dXRabWF2?=
 =?utf-8?B?cWR1TExmRC91VWZwTC8zRWtpRDlCbFIzRHlrUWlWVmU5WXVyTnoxQy9rTXhH?=
 =?utf-8?B?N2J1TXpMU09COUZDMTlGeGNETktUb1dla3lJMVgwdWxUNUo1SmVUTHBCTUdD?=
 =?utf-8?B?UzRaMlVKRWFtY2JMNVJhVkJJZGc2R25zYUl3eXRzdTBMNWdyZXg0UXFLVDF2?=
 =?utf-8?B?a01MaEFUZjRVVTR3NXUvOHJhcWdHdElCYkRyV1hCODVwNEYvMGhFMUJXR1dh?=
 =?utf-8?B?OVpyT0RxcWdHQTZsU1FLbEhJSFljU0pjcUhIUGZaQzdobmJaOWJ0MlZWN3JI?=
 =?utf-8?B?WDUwNTJUMjk1K1owanlYeFJtck1MdTNMTVZGOE1BcnVOQzFOS2lQR3pWVHVZ?=
 =?utf-8?B?eFl3ajB3Z0VYQnhMWXBQYTdXQVY3TlorZ05OWFRyY2VhVTRScXBDZ2Yvd2xN?=
 =?utf-8?B?WGpWcHZ1cHlmbE9HNzdmTGttVXF3RklVQmVKN3JLeXZsckpBUGtBcUJHWkpk?=
 =?utf-8?B?Vm1HOEd0N3JvMkptTUtaNFMvK1JJcWZzQmdlcmdiclA4elNlRXMzTFdJNElr?=
 =?utf-8?B?cWViTFJXSEZGekpMVTJGUm91dCs3dk04K0VSUnFueHBYTWZOWmo5Z0ZHTTNZ?=
 =?utf-8?B?NE1JTXJDZEEwVUgvV3RDaVlrOTZyL2VSRDVoUWRxWkExcGlGRFVicVE1Q0k2?=
 =?utf-8?B?SU1FSFpRSm9vTTEycVBqSDNOelI3dUpPYVFSUSs2S3o0cHMvWXh6K3FsWXd2?=
 =?utf-8?B?RkpKQnNyaUZMSk4yemJzTG5tQmhzdER5TUJhRGh3cVVtZVNudDFJRXhjRHI4?=
 =?utf-8?B?YVhNczZSaExzN2VGdUFHY24vZzJRRWIwZ1FQbVVsOXlpWFZVMkRVYXVQa2lM?=
 =?utf-8?B?TnBBclFnVDZXZ29xUnAvanBwYjlqWURMY1phK09qN0Q4NlZpRFdTQm00MlpK?=
 =?utf-8?B?bmk2UjhvQkUwMmNBTHJZT1UxUk9YNXV5UVFjeG1ad0ZLbFhPaXd4NXEyMHVm?=
 =?utf-8?B?ck56SmlJVjZBSEZNek9pemZYTG1sVDhUejBpNk85VEZGaUZwb3BDaFAwOVAw?=
 =?utf-8?B?QjFmMk1lMkY4Z3B5KzgzTzEwNG02QVU5V3psUzNid3FIRG1UbWZLT0ptTFdK?=
 =?utf-8?B?T1NLUTlkM3c3ckJIeVFFRVBya2NvTUxIRE9wSjhZQ1o2cWNMQ0l5S3BJRW50?=
 =?utf-8?B?TEpQQmhyMjF0RzhSK2gvb0NlbERSSEtwUkZPZmErSGk4YXF4S09HWWQ1VEF3?=
 =?utf-8?B?NFpGVHN5UmxjcnlBbTBnbHZwMWpVNTlLUVBNQ2U0d0NsVlVOdElxMGF6emVE?=
 =?utf-8?B?SEFCK0UzWmhQQlA1eTc3eEdOaXlXQXAzaTFTVnUrd01wcFhJdkUwRUNkOTBr?=
 =?utf-8?B?U2psaG9LMDErMTJpRXBPMTQ0Vk41b0w3WTl6Z2hyTmlEU25VaDdEeTdwd3Ri?=
 =?utf-8?Q?L276pps+MuYFLTOEHayVLp/vC0hJRtZng3nkDd3?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE2674BF08C14841AAC41B30615CA8B6@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6805aeb2-ea22-4aa5-4f7a-08d961c5892d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 21:25:28.2828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FVCw50ApSOIUL25z7/m7e62oliV4Ev8PlIGw9Rxf7f+XSZy5qNywv8kQECQqYFrPIJGP4gXp4hoYMDmrJTHK8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2666
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIDgvMTcvMjEgNDo1MiBQTSwgVmxhZGltaXIgT2x0ZWFuIHdyb3Rl
Og0KPiBJdCBzZWVtcyB0aGF0IG9mX2ZpbmRfY29tcGF0aWJsZV9ub2RlIGhhcyBhIHdlaXJkIGNh
bGxpbmcgY29udmVudGlvbiBpbg0KPiB3aGljaCBpdCBjYWxscyBvZl9ub2RlX3B1dCgpIG9uIHRo
ZSAiZnJvbSIgbm9kZSBhcmd1bWVudCwgaW5zdGVhZCBvZg0KPiBsZWF2aW5nIHRoYXQgdXAgdG8g
dGhlIGNhbGxlci4gVGhpcyBjb21lcyBmcm9tIHRoZSBmYWN0IHRoYXQNCj4gb2ZfZmluZF9jb21w
YXRpYmxlX25vZGUgd2l0aCBhIG5vbi1OVUxMICJmcm9tIiBhcmd1bWVudCBpdCBvbmx5IHN1cHBv
c2VkDQo+IHRvIGJlIHVzZWQgYXMgdGhlIGl0ZXJhdG9yIGZ1bmN0aW9uIG9mIGZvcl9lYWNoX2Nv
bXBhdGlibGVfbm9kZSgpLiBPRg0KPiBpdGVyYXRvciBmdW5jdGlvbnMgY2FsbCBvZl9ub2RlX2dl
dCBvbiB0aGUgbmV4dCBPRiBub2RlIGFuZCBvZl9ub2RlX3B1dCgpDQo+IG9uIHRoZSBwcmV2aW91
cyBvbmUuDQo+IA0KPiBXaGVuIG9mX2ZpbmRfY29tcGF0aWJsZV9ub2RlIGNhbGxzIG9mX25vZGVf
cHV0LCBpdCBhY3R1YWxseSBuZXZlcg0KPiBleHBlY3RzIHRoZSByZWZjb3VudCB0byBkcm9wIHRv
IHplcm8sIGJlY2F1c2UgdGhlIGNhbGwgaXMgZG9uZSB1bmRlciB0aGUNCj4gYXRvbWljIGRldnRy
ZWVfbG9jayBjb250ZXh0LCBhbmQgd2hlbiB0aGUgcmVmY291bnQgZHJvcHMgdG8gemVybyBpdA0K
PiB0cmlnZ2VycyBhIGtvYmplY3QgYW5kIGEgc3lzZnMgZmlsZSBkZWxldGlvbiwgd2hpY2ggYXNz
dW1lIGJsb2NraW5nDQo+IGNvbnRleHQuDQo+IA0KPiBTbyBhbnkgZHJpdmVyIGNhbGwgdG8gb2Zf
ZmluZF9jb21wYXRpYmxlX25vZGUgaXMgcHJvYmFibHkgYnVnZ3kgYmVjYXVzZQ0KPiBhbiB1bmV4
cGVjdGVkIG9mX25vZGVfcHV0KCkgdGFrZXMgcGxhY2UuDQo+IA0KPiBXaGF0IHNob3VsZCBiZSBk
b25lIGlzIHRvIHVzZSB0aGUgb2ZfZ2V0X2NvbXBhdGlibGVfY2hpbGQoKSBmdW5jdGlvbi4NCg0K
SSBoYXZlIGFuIG9ic2VydmF0aW9uIHRoYXQncyBzbGlnaHRseSBvdXQgb2YgdGhlIHNjb3BlIG9m
IHlvdXIgcGF0Y2gsIA0KYnV0IEknbGwgcG9zdCBoZXJlIG9uIHRoZSBvZmYgY2hhbmNlIHRoYXQg
eW91IGZpbmQgaXQgcmVsZXZhbnQuIA0KQXBvbG9naWVzIGlmIGl0J3Mgb3V0IG9mIHBsYWNlLg0K
DQpEbyB0aGVzZSBpbnRlZ3JhdGVkIE5YUCBQSFlzIHVzZSBhIHNwZWNpZmljIFBIWSBkcml2ZXIs
IG9yIGRvIHRoZXkganVzdCANCnVzZSB0aGUgR2VuZXJpYyBQSFkgZHJpdmVyPyBJZiB0aGUgZm9y
bWVyIGlzIHRoZSBjYXNlLCBkbyB5b3UgZXhwZXJpZW5jZSANCnRoYXQgdGhlIFBIWSBkcml2ZXIg
ZmFpbHMgdG8gZ2V0IHByb2JlZCBkdXJpbmcgbWRpb2J1cyByZWdpc3RyYXRpb24gaWYgDQp0aGUg
a2VybmVsIHVzZXMgZndfZGV2bGluaz1vbj8NCg0KSW4gbXkgY2FzZSBJIGFtIHdyaXRpbmcgYSBu
ZXcgc3ViZHJpdmVyIGZvciByZWFsdGVrLXNtaSwgYSBEU0EgZHJpdmVyIA0Kd2hpY2ggcmVnaXN0
ZXJzIGFuIGludGVybmFsIE1ESU8gYnVzIGFuYWxvZ291c2x5IHRvIHNqYTExMDUsIHdoaWNoIGlz
IA0Kd2h5IEknbSBhc2tpbmcuIEkgbm90aWNlZCBhIGRlZmVycmVkIHByb2JlIG9mIHRoZSBQSFkg
ZHJpdmVyIGJlY2F1c2UgdGhlIA0Kc3VwcGxpZXIgKGV0aGVybmV0LXN3aXRjaCkgaXMgbm90IHJl
YWR5IC0gcHJlc3VtYWJseSBiZWNhdXNlIGFsbCBvZiB0aGlzIA0KaXMgaGFwcGVuaW5nIGluIHRo
ZSBwcm9iZSBvZiB0aGUgc3dpdGNoIGRyaXZlci4gU2VlIGJlbG93Og0KDQpbICAgODMuNjUzMjEz
XSBkZXZpY2VfYWRkOjMyNzA6IGRldmljZTogJ1NNSS0wJzogZGV2aWNlX2FkZA0KWyAgIDgzLjY1
MzkwNV0gZGV2aWNlX3BtX2FkZDoxMzY6IFBNOiBBZGRpbmcgaW5mbyBmb3IgTm8gQnVzOlNNSS0w
DQpbICAgODMuNjU0MDU1XSBkZXZpY2VfYWRkOjMyNzA6IGRldmljZTogDQoncGxhdGZvcm06ZXRo
ZXJuZXQtc3dpdGNoLS1tZGlvX2J1czpTTUktMCc6IGRldmljZV9hZGQNClsgICA4My42NTQyMjRd
IGRldmljZV9saW5rX2FkZDo4NDM6IG1kaW9fYnVzIFNNSS0wOiBMaW5rZWQgYXMgYSBzeW5jIA0K
c3RhdGUgb25seSBjb25zdW1lciB0byBldGhlcm5ldC1zd2l0Y2gNClsgICA4My42NTQyOTFdIGxp
YnBoeTogU01JIHNsYXZlIE1JSTogcHJvYmVkDQouLi4NClsgICA4My42NTk4MDldIGRldmljZV9h
ZGQ6MzI3MDogZGV2aWNlOiAnU01JLTA6MDAnOiBkZXZpY2VfYWRkDQpbICAgODMuNjU5ODgzXSBi
dXNfYWRkX2RldmljZTo0NDc6IGJ1czogJ21kaW9fYnVzJzogYWRkIGRldmljZSBTTUktMDowMA0K
WyAgIDgzLjY1OTk3MF0gZGV2aWNlX3BtX2FkZDoxMzY6IFBNOiBBZGRpbmcgaW5mbyBmb3IgbWRp
b19idXM6U01JLTA6MDANClsgICA4My42NjAxMjJdIGRldmljZV9hZGQ6MzI3MDogZGV2aWNlOiAN
CidwbGF0Zm9ybTpldGhlcm5ldC1zd2l0Y2gtLW1kaW9fYnVzOlNNSS0wOjAwJzogZGV2aWNlX2Fk
ZA0KWyAgIDgzLjY2MDI3NF0gZGV2aWNlc19rc2V0X21vdmVfbGFzdDoyNzAxOiBkZXZpY2VzX2tz
ZXQ6IE1vdmluZyANClNNSS0wOjAwIHRvIGVuZCBvZiBsaXN0DQpbICAgODMuNjYwMjgyXSBkZXZp
Y2VfcG1fbW92ZV9sYXN0OjIwMzogUE06IE1vdmluZyBtZGlvX2J1czpTTUktMDowMCB0byANCmVu
ZCBvZiBsaXN0DQpbICAgODMuNjYwMjkzXSBkZXZpY2VfbGlua19hZGQ6ODU5OiBtZGlvX2J1cyBT
TUktMDowMDogTGlua2VkIGFzIGEgDQpjb25zdW1lciB0byBldGhlcm5ldC1zd2l0Y2gNClsgICA4
My42NjAzNTBdIF9fZHJpdmVyX3Byb2JlX2RldmljZTo3MzY6IGJ1czogJ21kaW9fYnVzJzogDQpf
X2RyaXZlcl9wcm9iZV9kZXZpY2U6IG1hdGNoZWQgZGV2aWNlIFNNSS0wOjAwIHdpdGggZHJpdmVy
IFJUTDgzNjVNQi1WQyANCkdpZ2FiaXQgRXRoZXJuZXQNClsgICA4My42NjAzNjVdIGRldmljZV9s
aW5rc19jaGVja19zdXBwbGllcnM6MTAwMTogbWRpb19idXMgU01JLTA6MDA6IA0KcHJvYmUgZGVm
ZXJyYWwgLSBzdXBwbGllciBldGhlcm5ldC1zd2l0Y2ggbm90IHJlYWR5DQpbICAgODMuNjYwMzc2
XSBkcml2ZXJfZGVmZXJyZWRfcHJvYmVfYWRkOjEzODogbWRpb19idXMgU01JLTA6MDA6IEFkZGVk
IA0KdG8gZGVmZXJyZWQgbGlzdA0KDQpJdCdzIG5vdCBuZWNlc3NhcmlseSBmYXRhbCBiZWNhdXNl
IHBoeV9hdHRhY2hfZGlyZWN0IHdpbGwganVzdCB1c2UgdGhlIA0KR2VuZXJpYyBQSFkgZHJpdmVy
IGFzIGEgZmFsbGJhY2ssIGJ1dCBpdCdzIG9idmlvdXNseSBub3QgdGhlIGludGVuZGVkIA0KYmVo
YXZpb3VyLg0KDQpQZXJoYXBzIHRoaXMgYWZmZWN0cyB5b3VyIGRyaXZlciB0b28/IER1ZSB0byBs
YWNrIG9mIGhhcmR3YXJlIEkgYW0gbm90IA0KaW4gYSBwb3NpdGlvbiB0byB0ZXN0LCBidXQgYSBz
dGF0aWMgY29kZSBhbmFseXNpcyBzdWdnZXN0cyBpdCBtYXkgYmUgaWYgDQp5b3UgYXJlIGV4cGVj
dGluZyBhbnl0aGluZyBidXQgR2VuZXJpYyBQSFkuDQoNCktpbmQgcmVnYXJkcywNCkFsdmluDQoN
Cj4gDQo+IEZpeGVzOiA1YThmMDk3NDhlZTcgKCJuZXQ6IGRzYTogc2phMTEwNTogcmVnaXN0ZXIg
dGhlIE1ESU8gYnVzZXMgZm9yIDEwMGJhc2UtVDEgYW5kIDEwMGJhc2UtVFgiKQ0KPiBMaW5rOiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMTA4MTQwMTAxMzkua3pyeWltbXA0cml6
bHpudEBza2J1Zi8NCj4gU3VnZ2VzdGVkLWJ5OiBGcmFuayBSb3dhbmQgPGZyb3dhbmQubGlzdEBn
bWFpbC5jb20+DQo+IFN1Z2dlc3RlZC1ieTogUm9iIEhlcnJpbmcgPHJvYmgrZHRAa2VybmVsLm9y
Zz4NCj4gU2lnbmVkLW9mZi1ieTogVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5Abnhw
LmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZHNhL3NqYTExMDUvc2phMTEwNV9tZGlvLmMg
fCA2ICsrLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3NqYTExMDUvc2phMTEw
NV9tZGlvLmMgYi9kcml2ZXJzL25ldC9kc2Evc2phMTEwNS9zamExMTA1X21kaW8uYw0KPiBpbmRl
eCAxOWFlYThmYjc2ZjYuLjcwNWQzOTAwZTQzYSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQv
ZHNhL3NqYTExMDUvc2phMTEwNV9tZGlvLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3NqYTEx
MDUvc2phMTEwNV9tZGlvLmMNCj4gQEAgLTI4NCw4ICsyODQsNyBAQCBzdGF0aWMgaW50IHNqYTEx
MDVfbWRpb2J1c19iYXNlX3R4X3JlZ2lzdGVyKHN0cnVjdCBzamExMTA1X3ByaXZhdGUgKnByaXYs
DQo+ICAgCXN0cnVjdCBtaWlfYnVzICpidXM7DQo+ICAgCWludCByYyA9IDA7DQo+ICAgDQo+IC0J
bnAgPSBvZl9maW5kX2NvbXBhdGlibGVfbm9kZShtZGlvX25vZGUsIE5VTEwsDQo+IC0JCQkJICAg
ICAibnhwLHNqYTExMTAtYmFzZS10eC1tZGlvIik7DQo+ICsJbnAgPSBvZl9nZXRfY29tcGF0aWJs
ZV9jaGlsZChtZGlvX25vZGUsICJueHAsc2phMTExMC1iYXNlLXR4LW1kaW8iKTsNCj4gICAJaWYg
KCFucCkNCj4gICAJCXJldHVybiAwOw0KPiAgIA0KPiBAQCAtMzM5LDggKzMzOCw3IEBAIHN0YXRp
YyBpbnQgc2phMTEwNV9tZGlvYnVzX2Jhc2VfdDFfcmVnaXN0ZXIoc3RydWN0IHNqYTExMDVfcHJp
dmF0ZSAqcHJpdiwNCj4gICAJc3RydWN0IG1paV9idXMgKmJ1czsNCj4gICAJaW50IHJjID0gMDsN
Cj4gICANCj4gLQlucCA9IG9mX2ZpbmRfY29tcGF0aWJsZV9ub2RlKG1kaW9fbm9kZSwgTlVMTCwN
Cj4gLQkJCQkgICAgICJueHAsc2phMTExMC1iYXNlLXQxLW1kaW8iKTsNCj4gKwlucCA9IG9mX2dl
dF9jb21wYXRpYmxlX2NoaWxkKG1kaW9fbm9kZSwgIm54cCxzamExMTEwLWJhc2UtdDEtbWRpbyIp
Ow0KPiAgIAlpZiAoIW5wKQ0KPiAgIAkJcmV0dXJuIDA7DQo+ICAgDQo+IA0K
