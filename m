Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63ECE5641FB
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 20:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiGBSHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 14:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiGBSHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 14:07:11 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2106.outbound.protection.outlook.com [40.107.114.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55421DEF9;
        Sat,  2 Jul 2022 11:07:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6jq8CTQywsx290IqX1rHz/hVNcgE46AMMthYCTfX9IZUDt8WJ3xsYrbXVjJa0uoCCBftwjnJLlunshx6p2bfyHQ9owvHAUlQsTyOZH0lBrZGXvu2dBlOJro7OCyquZRvh9+jTNPNNF90yM5la1eiabt+J2TSIp26ox4ShbRQONKXgeMrUI9h0NIiz3LQg35yvdIRXnysw7gTx6gdMJtL3qWuQcb3oXzzGDJ7kIZ19RiYvCTbFlzh+EABAhgvjkODHtOhI4dJU670XFJGywhUg0EbKMNZa5LG7mXDvK9GnDoD92y7frr6wmFi0xe1we+mgUrxYnmfAOswrUfWdr6KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xw3t1aYGrlkXsfsfOftSrNQgdKnRYQerAyyym6dCuxE=;
 b=XxoXN6Cj/EFTLXEQa/8mk8M1o2hcdi3SPA5qZ/f5NO3GTGquLq2j1/C2NLeBKtVEM84WWASm5jUu3P9dPuoX1wMJmSwZCSzDUFCZLBn7O6yOVSDqxm9vEWln00mriTqDTVBdCchxoX4AJaetvY1qz0evQB0jE2pP9YCSNWrvePHW6ZR+lhZS3nKbfKOGa27p6P7HTovqFL5H4m05EW+JIL4+bD79l9mXgOooi7vjUcE+y1CCZ2YgmksNmlJuSvN5AdZBxAMDtS4z1LJiXCy4OmW4HNFFN0vddMYRiIJVMAqLGvVNqd50aZdYHIT9hdLkJbOXlHPODwGY2+vt4OozPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xw3t1aYGrlkXsfsfOftSrNQgdKnRYQerAyyym6dCuxE=;
 b=S6K1K3fMHoqs+Hwj8PaH9P4IPFTwMgLi5BBnioJmcv7Y1lQO6b5KuKH/+I/goMmDmM/l9TIlcdt28WcE3TdKXXLgD3f+eWL4yNzKGsQnHoeOvPbH7BNHs7dJbKfkdEVmnu6YSAFkUxGGlfW9pB5VR3YCKP8noW+7nBc6tAFyezI=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB7702.jpnprd01.prod.outlook.com (2603:1096:400:17b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Sat, 2 Jul
 2022 18:07:03 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.018; Sat, 2 Jul 2022
 18:07:03 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 1/6] dt-bindings: can: sja1000: Convert to json-schema
Thread-Topic: [PATCH 1/6] dt-bindings: can: sja1000: Convert to json-schema
Thread-Index: AQHYjhxDeGHWTgsHQkaJV8mvZfWaKK1rQJyAgAAfYBA=
Date:   Sat, 2 Jul 2022 18:07:03 +0000
Message-ID: <OS0PR01MB5922968C795E830DA75F3CDE86BC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-2-biju.das.jz@bp.renesas.com>
 <20220702161141.cfeemj2hobei2z4k@pengutronix.de>
In-Reply-To: <20220702161141.cfeemj2hobei2z4k@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 174f175c-05aa-4596-31c6-08da5c55aac2
x-ms-traffictypediagnostic: TYCPR01MB7702:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ojyFwf4guvqY+EpWCUGkofutj+STMTZSb2wBAkoRRcpxSK+8WXr61hBcVXQKQG+GD/MI57w4a4WVmJmcDj9uHE7sVg/iIYGvmSSRnujISvUGPKqKtf6FT3Zu6CkOKkBW7eiAm2ZYdzZzja38Wp1s9pKsL1Mnuzsv2VKImyG3Ymc3q1/uQsZeTsX1pJAGPJWuLtDiWCXhHk7EJihXyqAfaGeYSXdY2TF39ddt+eogXD4RRQ3AvTRRLX5Cov/8bs10ZFqTKR78yoEYrVCbQ9VTtbaAJIatslXUfZNRIyPkUDoZnMZ419jeOdSQYgqGwkI/ZX33I/9is8y7mmCaQEqXgBbeu9MdbElJiWS2y/akrw13ceeyl+2azl1qD3DwLSGI2yhyjk+yURb4eV1E09ayHbVo4NbUmos7Ib+knyoYyw5xRF/CMJvhImN1U+AoQaMnqs33419al9QlqjhUExSbwsSCC7kbB0QXsxluNVPEic6k+YKSlnYoh04L9TbgS4wsgmmv5br2P/MazmZgAXY6N4A6Lij76TObCE1+DXWrqm6trN0Fjk4KA6hBWCmL5YP6nbNs5l03VC3P7/VAEVAlw+WGwA82StIR6MIHAE08sedgJ2apaWgLN+yf4+Zo1xMyo4FkGcn4+LoOMboO7vZuMd/7FRYoz18KD2rF7gTAJhjsM2TtT2WBQJ1SfCl4S2hq5vIxYcxHeiZL/HDSNPQ/BiXqUUbNnN0/ZXnj5hKuLGdB9oMy4hLS0ws/qv5y3Mto95Ngits5OBdozrDlYibMz9FB7S8YKRpTI4y1CuD0fdhaF/d6WdTwZttLtNp4WxeLrX/FVScIeOX/bNMhyP93QLXFWdrLTftmWP4Vq1JHkwM2cXj3R8b/r42FxGy0TAdu0EAIOK1afQWQxkaNWyVVgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(122000001)(8676002)(4326008)(53546011)(6506007)(9686003)(7696005)(26005)(2906002)(8936002)(38070700005)(52536014)(66476007)(66556008)(66446008)(64756008)(66946007)(76116006)(5660300002)(7416002)(54906003)(316002)(38100700002)(86362001)(33656002)(71200400001)(6916009)(41300700001)(55016003)(966005)(478600001)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWQ5bThDaC84a2kyaXhZaWFCVFY2Nnk2aytpWmJkSjNIUzlabm13NlZzc005?=
 =?utf-8?B?bzkrYWZxczRvTVRMRGNUeFFjRnRJVk5tdWhlTU9CN2hqcDNRemsvWEk2Vnpp?=
 =?utf-8?B?REkyWDNHRjJlZDZ4anJZZVdubXRXVTJXYUJNanJud0Q1TlF3akpjd0tXODND?=
 =?utf-8?B?MHV0Q2dLc1kvQkNrNmNGT0FtNzVDU3k4K3JSL1UwWUlwblVCM0Z3YmFrNCtN?=
 =?utf-8?B?UFQ2NjlYQnR4aVpHdC9QdUU3SXl4bDF2aGIyVHFhRGV1WnpVbFg0cU9wUFVh?=
 =?utf-8?B?Z1Z5Kyt0NWptUm5JZS8veStHa1pCS2tIZWg5b1B4RlErcGJhZTJXRk1LK2ht?=
 =?utf-8?B?cWgrUGhIZFJuWEN5TWVKK2tVaE1NL2hXc0JTMVJ0UEd5c0RHZ0M4ZS96SmFX?=
 =?utf-8?B?MTlBa3F2eW0vMFN5R1UwR2RPWU5pS0tra0tVVXJ0VnM4czcxRXQ2VXN0L2Za?=
 =?utf-8?B?MnNvOXBxMy83cmFYOE43REljWDFzR3Q0TnZRdnBQWmd6NHRoR2FkTDVpTG5B?=
 =?utf-8?B?UUx2c3JnNlNRUWsxaXBwclVWZStKNEFKTXd6UG44MnQwbi9FT3dhU01ocGFG?=
 =?utf-8?B?Z1NWMDlYMHljRmQ5YkNUaXNSdCt4RlIvcUlMUFFKS0xEdTFQK0VMQ2xmaTl5?=
 =?utf-8?B?N0lLMm50bC9lSTdzcTVsK2JBelZ1emJvWjI5UDIyaXpyRC9hbHpWVU5ucFd3?=
 =?utf-8?B?K0RlVytWWmtQQmMzZTFDcWxjY0hPSWF2TTlFTW1ORHdJZlBwUG5GZ1MwbGFB?=
 =?utf-8?B?RGVLY2hnWEh3TTdrMHQzWnRhMXhsTW5ITFpIVVZLYUtaMDZEanFKaXpBNnFE?=
 =?utf-8?B?R1oybG1rdHJFelArVnAwU3ZhQWxUSzhSQytIWGFlbkI4TGNKMTh0Y1hXNE5x?=
 =?utf-8?B?QjVwd0d0MDgyaElOSWR6YnljWWQybzJIRHRQS3RsbjAwZ2gwYWtQNnRiQkZP?=
 =?utf-8?B?dmtXZ2kzLzMva2F2WXdWL01aWkp4aGl0dW1rOVhFclNpRUk1cEtWNmY5cHJ4?=
 =?utf-8?B?ckNES0ZqaVpMUE95VWlqTEVQUTRObXcxTjJnTzdqK21UZUFYcVVNS0RKUERC?=
 =?utf-8?B?Y2RnNCtPRFVkZjQ1MWEzUWZPakk5dTY3UGpWQUVnaWJ2eDNxSGE1M1UxT3Zt?=
 =?utf-8?B?WkRlS1BJYVRhT1NuQkNheEkwVXhweVAxaFVEbzBzdFBzK2tNbzFiQ1R1NUtx?=
 =?utf-8?B?eURrSC9lY2tBdHZQc2NtSUlWaUtiR1NyM3RWVnJpRXVrczAvMmdxVlZKbGFG?=
 =?utf-8?B?UWNxZkU1VXdWako1aEhNUmhqMVdaOGhoNU5FckRtV0h2K2lwYzhtTmV4cVpn?=
 =?utf-8?B?UGpieHI1K0dIYnJNZzlUREh3MkxmcnBPV1ZYK0F4aTRLeHJabW1qZGdIYVp6?=
 =?utf-8?B?MFR1VGptcDJPNTJ4enhxRzV1MytaRFJwTmNEckIzekRjMjNVOVl1MUd5dWwy?=
 =?utf-8?B?Z3JXWUZpOHhNZEp6VXFtekVzdWNRYTh4aFlJakhwRHcrT3Ayc1psUk1mU0tq?=
 =?utf-8?B?QWNkb0l4WTNEVEdFMFAza3k0cmRWRG1nUEVXam5XZVI0eDRHcm9XRnR5anRp?=
 =?utf-8?B?YWUwc1pTTDQzaDRRZ1BFVDltMWhCZGRBblhRWU03S1A0RGt6ckxrMi9Ba1ps?=
 =?utf-8?B?SkhubzFjcXl3TmhCZ2JKRndJejhRYzQ3eU9pYnJWYUJjaXFDamh2Q1oyRTF1?=
 =?utf-8?B?aHd2RUIvUXp6ZE9LM3lLL2ViMzNwdHJqYmhmWnpIL3N3MHJSZ0JIQmFldmsv?=
 =?utf-8?B?MVdHMHF1KzEwOTlaUHBNWjZYd3NyR0x4cGRkc21YdVBPeSs4Y1BIUGlxbGxa?=
 =?utf-8?B?R3J5TGhNSjVLVE9oTUsweXZ5d3gyRnF4VmZpTzVPbXFoRVJTL0hFb2lyZkNh?=
 =?utf-8?B?TUkycUU4RmJIVDBXbWN0NGRpZk45WmNoanc4ZlFEcG1pK0NGcCsxdUtERVBL?=
 =?utf-8?B?T3J3Qk1FMktrZDlYdHMrajdTMDR3Y1pJajhUbkpudDgwOHA0cmp6R1pRTHdE?=
 =?utf-8?B?bHRUSHRPN2owOFhnb2t1RjJScGs1ZmJQUXhlME5zY0pYT1A3K2FZWTZVT1lX?=
 =?utf-8?B?Unh6V1FNNHBKeEpEbGZNVjV5NjROYWpsQnM4akdOMTFGZGxZVnBTN0dHanFo?=
 =?utf-8?Q?fiSlLXUZKq/j64Qa5aibiaeFE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 174f175c-05aa-4596-31c6-08da5c55aac2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 18:07:03.3019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xuM7hHL57nuv80wPTykMICUPqmQ6dV2rsGsg84hTeE5iimRioVCmTGvFgAfoFTho0TlTjO/meQqgpqf8ghnrsIMi8KCDYx/DgVIY3ihok+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB7702
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCAxLzZdIGR0LWJpbmRpbmdzOiBjYW46IHNqYTEwMDA6IENvbnZlcnQgdG8ganNvbi0NCj4g
c2NoZW1hDQo+IA0KPiBPbiAwMi4wNy4yMDIyIDE1OjAxOjI1LCBCaWp1IERhcyB3cm90ZToNCj4g
PiBDb252ZXJ0IHRoZSBOWFAgU0pBMTAwMCBDQU4gQ29udHJvbGxlciBEZXZpY2UgVHJlZSBiaW5k
aW5nDQo+ID4gZG9jdW1lbnRhdGlvbiB0byBqc29uLXNjaGVtYS4NCj4gPg0KPiA+IFVwZGF0ZSB0
aGUgZXhhbXBsZSB0byBtYXRjaCByZWFsaXR5Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlq
dSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IC0tLQ0KPiA+ICAuLi4vYmlu
ZGluZ3MvbmV0L2Nhbi9ueHAsc2phMTAwMC55YW1sICAgICAgICAgfCAxMDYNCj4gKysrKysrKysr
KysrKysrKysrDQo+ID4gIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vc2phMTAwMC50
eHQgICB8ICA1OCAtLS0tLS0tLS0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTA2IGluc2VydGlv
bnMoKyksIDU4IGRlbGV0aW9ucygtKSAgY3JlYXRlIG1vZGUNCj4gPiAxMDA2NDQgRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vbnhwLHNqYTEwMDAueWFtbA0KPiA+ICBk
ZWxldGUgbW9kZSAxMDA2NDQNCj4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
bmV0L2Nhbi9zamExMDAwLnR4dA0KPiA+DQo+ID4gZGlmZiAtLWdpdA0KPiA+IGEvRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vbnhwLHNqYTEwMDAueWFtbA0KPiA+IGIv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vbnhwLHNqYTEwMDAueWFt
bA0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi45MWQw
ZjFiMjVkMTANCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vbnhwLHNqYTEwMDAueWFtbA0KPiA+IEBAIC0wLDAgKzEs
MTA2IEBADQo+ID4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChHUEwtMi4wLW9ubHkgT1Ig
QlNELTItQ2xhdXNlKSAlWUFNTCAxLjINCj4gPiArLS0tDQo+ID4gKyRpZDogaHR0cDovL2Rldmlj
ZXRyZWUub3JnL3NjaGVtYXMvbmV0L2Nhbi9ueHAsc2phMTAwMC55YW1sIw0KPiA+ICskc2NoZW1h
OiBodHRwOi8vZGV2aWNldHJlZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCMNCj4gPiArDQo+
ID4gK3RpdGxlOiBNZW1vcnkgbWFwcGVkIFNKQTEwMDAgQ0FOIGNvbnRyb2xsZXIgZnJvbSBOWFAg
KGZvcm1lcmx5DQo+ID4gK1BoaWxpcHMpDQo+ID4gKw0KPiA+ICttYWludGFpbmVyczoNCj4gPiAr
ICAtIFdvbGZnYW5nIEdyYW5kZWdnZXIgPHdnQGdyYW5kZWdnZXIuY29tPg0KPiANCj4gUGxlYXNl
IGFkZDoNCj4gDQo+IGFsbE9mOg0KPiAgIC0gJHJlZjogY2FuLWNvbnRyb2xsZXIueWFtbCMNCg0K
SXQgaXMgYWxyZWFkeSB0aGVyZSBhdCBib3R0b20uIFdpbGwgbW92ZSB1cCBhcyB5b3Ugc3VnZ2Vz
dGVkLg0KDQpDaGVlcnMsDQpCaWp1DQoNCg0K
