Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F055EA021
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 12:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbiIZKfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 06:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235937AbiIZKdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 06:33:39 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2096.outbound.protection.outlook.com [40.107.114.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081CA4F650;
        Mon, 26 Sep 2022 03:20:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elzycLd0Xf0fRbro/FQnftzzgebeKpQPdA9Wct7E8Rc9bXUMmXukwJW8WulqmYrkrv3Ool5mPGia0yEyCxzBkNQW61NJUfU1S8fzAyzY587JFG92qVi5U/zLF8m/85+A19L823qhyUsxzK0FUcjuRJrjg1eIGXf1ytWw7SWIuLOnSrMQEWAoLXOrKpqu0kCji/zCbrmMXySng8qNb7CtmxMKt2Gsor+pPi8J5LU2KXExHa3T/tKPTANxpvhsEGAYTfkdf19FJ/7UvgUCSELRv1mn9xAqwZnBrVN8oNtaP6tHgAH/NdLAB7Z9KboEz4XsLMvCc5V9nkBNOg4RRme4LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KdK54OflPSocKBmsIGy+NSSOIMkdrjOQ7ys8XUqMxM=;
 b=QjwrX/lppqYp9vNEa7X1QmGkF9LmVXnSQrfesYwGfnWMFZSrf5U+P2wy/yUr0KpKf+LaFK5yD9KnCHbHW55CufgYSAm9Jgr9Lb1OlLi98qtwlZZo1qr8ljM8fxut+OVzkQRDeQB3xIZOK63fWOfcBx7bt9w7lYPZUFx5vzLhQsdLqXQNMSTPTGVLJRXexR/BE4lbKirmtDdBdQoYoeh1wLCLJj2CywAHt4eNyIx3CYQWgpsCSIGyulwlIXeKodQ28V3avUSyulXNFT3zFn8n9ULfv44Q5aclBEiIlMjo0sx5aly1m3m0tJjzxi4Gxwey5c5H6H1rZJNNhIFRU0QjdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KdK54OflPSocKBmsIGy+NSSOIMkdrjOQ7ys8XUqMxM=;
 b=kvHyke/5l0siCvbWnCkoPS1CHG2k17YK+yKnVKsmqWLwtQ+nXFeKtdIaXsdiQ7jVVnF3PN+jpy4eNf7DUQe0hgggWkL1X/1dqygi0ZotOekrgB0X3pBwNlJvBa1JiokNejRW4QdnYeQCuuQ9VaYRuIav3Hg7c3P3Jtq0WXnYn78=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB5909.jpnprd01.prod.outlook.com
 (2603:1096:604:c5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 10:20:24 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 10:20:24 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 4/8] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Thread-Topic: [PATCH v2 4/8] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Thread-Index: AQHYzZbyqNqCKbNV30+Ykc0QZw/71q3rESYAgAYuSTCAAA3MAIAAJx+ggAAEMACAAA9B4A==
Date:   Mon, 26 Sep 2022 10:20:23 +0000
Message-ID: <TYBPR01MB53412E709A8F8B1C061FB26AD8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-5-yoshihiro.shimoda.uh@renesas.com>
 <1aebd827-3ff4-8d13-ca85-acf4d3a82592@linaro.org>
 <TYBPR01MB5341514CD57AB080454749F2D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <d31dc406-3ef2-0625-8f5e-ff6731457427@linaro.org>
 <TYBPR01MB5341B5F49362BCCF3C168D11D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <7dbdb43a-0ffe-58db-5f8a-f3bd62a4feea@linaro.org>
In-Reply-To: <7dbdb43a-0ffe-58db-5f8a-f3bd62a4feea@linaro.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB5909:EE_
x-ms-office365-filtering-correlation-id: 1baa9e3d-c44d-41c6-2ae9-08da9fa8b967
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fowdpx8s2W00qirQgAqpxHZR+ZZGpCkVvSKkJXlGh516Tj4ksDXS2XBcf/si6kUSjc8WguUYO1Kz9BvBmbASCZk2isVosnicebI0nor37+Lyn+fJHcT7BGBOiaQLPQU4+pWZBk2yBZY4Mv7jBFjodhCAzHYKwXBQG37o2G2xWSsN/2LgFAMOTWtkVlqj2UoQimTjwSG+FfPB2s+JHjQPtWMkJ5Hz/i2KpVq+Y58Ii60kPPZHS7CDZcHrDtrrrwDj691u7mfSIsB2g121Q2AylugklDeI8MB+HQ5chK6isplpCWPTgkc6cEFt/FLJLMnXfInOj/TXcUR3F2Sdk+XsdENvI8bZlN2XPzzRimgmahEoxA1+qYLCu0jTqiYFGVqoimlILr3SSBGTbTaruoi5esWb+qALXC/ZXn27urAgqZoYsgeBwu/uOHcdzlr4lU+0CoxbefeuxdGRtjdxnNBHNjDPUnnWC0A1OK5kzu9lidF5iSVsjhfKPFwhy628qXJ7b/um2azTLvrfFeb2UjpxL6RKvOQwWOdhASu2sqth4hkEJb1OIaGj0I+lNHqpmSnXFeZ3J81G6K2mFjRuMfkw6QxFEy6GyjZuWq0lIy0ILZCrPPh+rZGD62B+5ni0Sr5EqaEuFLKlVJ3Bi9zJdvBjhrhEbX2ZmXKCRg2NHgn5aolId5O8fKaqWlju3TKi4qQ6kNRxx/BhXjGHcWLACybqU9lX8sUHaj75sORfESg84djurBEbg4X9fbxBObpPDK1bq17FCIb5FrRIGDP8CzaMfwvZaus1DIJytsGzEFDxuuc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(186003)(921005)(86362001)(38100700002)(38070700005)(122000001)(5660300002)(7416002)(52536014)(8936002)(4744005)(76116006)(66946007)(66476007)(66556008)(66446008)(4326008)(64756008)(8676002)(2906002)(41300700001)(6506007)(71200400001)(7696005)(54906003)(53546011)(9686003)(110136005)(316002)(55016003)(478600001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1pUY0h6bFFmRnF6WktqVUZMZzd0RmlibjlhN2cyTnRuMlV1NXJ2L1pEVU5Y?=
 =?utf-8?B?YU15WnNDSHZHRWsxM3VreTJEMmpKdThQdi9CeklKbFBpZGdsekRlTTdrYXdY?=
 =?utf-8?B?MUpXSmpkazZCeksvN24ya0lUa0dQTzdid2MzTlEyL3dFTFB4RW9MdjZSekNq?=
 =?utf-8?B?dldWVkIvL2FyandWdXdGZUpGcmNIMlVJbi9iWFJuc0ZOU3JJR05KdlZpMjJ3?=
 =?utf-8?B?YXcyVmdpa0Q1VnM5QzhIWVU1c3p1NUt0TFZ5RW5jakV6a1FHeU4rTWZhTmZT?=
 =?utf-8?B?cTNTT2dIZUU5WTdETWxDYllGeS9yTWsyL2ZNSm5HU25ySFpEQ2prTEVnMDAx?=
 =?utf-8?B?aE1tOUVWL0p0SzhzRVRWVmRyQjRuWkhPQzdOclRqRXUyUFdZRTloTC95TWFE?=
 =?utf-8?B?ZXcrMmtmQnlRNVNLY0MvUU9YT2VzMGtTNTJ5V2VTYzFvVW5RYjJNby9saFU0?=
 =?utf-8?B?TG5xV2dycVpvQmNvYmc3V1c3WGoydkFzUG5mejNyRC9xcTN2RjlHdDA5Yyty?=
 =?utf-8?B?MGpVakpLM1JubFovWVY5dXR1c2tOb3ExNzdyWEFNWHJscC9yeFFuclQyUG14?=
 =?utf-8?B?S0lRUHIyclN4SS8yMmgxL3N3cTUvRzR2UUNYSVN0UkRnR3Z4aGsveitKaEtB?=
 =?utf-8?B?U1JsQk1oeVBKdXVmOFl0UkVGU2NYNjI4ak5DMkNuc0ZzQ2FRR1Zia1hySDlJ?=
 =?utf-8?B?SWdqajdvRG5tNktHdG5NVnNxRjNZSkVKNjJtVTBhUVdVS1NndmFHd05Vblhj?=
 =?utf-8?B?SDhxMDE5enNyNW1YMGYzRUgwVkFENjNPc08wNmVWaHVRZml3VXVGOXhwKzBm?=
 =?utf-8?B?aXZxUGNtRUI1Wk55MStmb0ZlQ1JiRjJyVGRNNmpSTFMwZWl1NVZlYWR1VkpN?=
 =?utf-8?B?Mm5uOUtFZXF5dWI4VVkvMlNOSllkRkc5cm5yUzFCSWZ4S04zTGN0dlVRbTd4?=
 =?utf-8?B?aHBWb3Rac2xoODk1YUc0SHNobFJuRVNmU0xaQkJFcGdPSHRxVkJGNy9VbFZT?=
 =?utf-8?B?SzFZUldiYWxpc0hXaXFwazIxUFpyMEpuSFBRbUNYQnUrYjZlTzVZVFMwc3lx?=
 =?utf-8?B?MWtydkV3YW1CZ2t6dHQyNDJDanlOTk9iWmdUcVJyVkRMOWQ1ZkRHOExJY0lE?=
 =?utf-8?B?M3RLQ1ppWU1IVjZvek5qOE5JLzg2Q3hZcnRPOUE1aXVsWkIwaDB3NlkrMG9D?=
 =?utf-8?B?RG9GbHpld2VkcFh5S2NLc2NKSnkyV28vbksybFBtVVZTYUZqS1BMRWVHVjdN?=
 =?utf-8?B?aG9NWWljdDQvTUdwTzBBbUFQbEVmeWR3RTViV2xFNXpVenlwQk1WVTBwc0pP?=
 =?utf-8?B?UXA5TDJkV1dFTEdRYy9oczc4MGdwdExnRVIvSzR1Tmw1QTZXenEzRHdaR3Qx?=
 =?utf-8?B?R1NuVURiK2FYbWFrV1RiY2N3R2ptZ3BnMVdjanVBaE9abWVoL2luRkFaa1FV?=
 =?utf-8?B?RnBkZmE5N0V3N0pERzZmWXAwZTIyazExZmhkRHNEaGdhOTYzMmNqN2N2YUFB?=
 =?utf-8?B?YWpKZXFUNVEvMnhsVWo0OVlZODNaMDVHV0tJSitIdTdGNHZ4SjBWZVBqK3l5?=
 =?utf-8?B?Y2hRVEJ0YlY3UTRTYVFPSmN5SXVld2JWS1BvSWFJTXhqeVBFUDZ3dmxFQTN6?=
 =?utf-8?B?dzdEdmNLZkdldjdFQ1JMK01wdlhqTFhTKzA4aUk3TEswekQ4Z3FZKzJXbGdL?=
 =?utf-8?B?L2VVQkZkaDlkZEg3b0VKOFV1QVBNOXplS2lZeFVpRUlkdGk1QjNibG52UWlR?=
 =?utf-8?B?VWYxV2o4QjhPaVlMM2dZeU9EQXUxQjhWR3MvMDNnN2t5YjJ1UGRHRXB6bXZM?=
 =?utf-8?B?SFBPd2luREVTUFd6SUhBQiswNGx6THFNc2ZVZDkwb3Zmby9vU3ZQcFY2aWp4?=
 =?utf-8?B?ZUVVTTJVRmdhRnJSMy9ndGx1cm02KzQxU1M5SVFXQ2t4QllvMk92LzJ5bVd1?=
 =?utf-8?B?Q1ZEekRLcUV0UkpnR2pUOUJXZThRcVFaam1Bb01hY1U3dElNTU8rSUxJa04z?=
 =?utf-8?B?MmtNRWZKa3d0eGZIV0RCeGc5RmZ0VXQyQU9PMTBwTWxCOUU0Wjk4T1R4cDJq?=
 =?utf-8?B?Mk41QzFDYkRNVnYwWFVaSnMvbGVKdHYrMnFkSUFaYUYwVkl5d0FFVStXZnl2?=
 =?utf-8?B?S0NaOWR4OWV6SlV4dVJ1ekp5UUxZYWU4dmt4cWxYbSszSzJJdnh3TmxqejlH?=
 =?utf-8?B?NmNYMkNYZzNaTkZWZlBFekhBQlpYR3FrcnljKzA3b1hEZlpSeGdQWTBhZTBk?=
 =?utf-8?B?TzZVUzFhZjY1dUZJOWllNjBudnZBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1baa9e3d-c44d-41c6-2ae9-08da9fa8b967
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 10:20:23.9902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iTO8gSXQfK1NAWpbEUiu1nIKWsh4sm6in4h4vB7R9M8QV4Cf90QJBTj6sz2ew2Qt06zf2ZgKN/cC99g0hg5OYDlGIU4kjy67ztWGNMM73fQIUqD58o8MzJ9FiZ5fwyh9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5909
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBLcnp5c3p0b2YgS296bG93c2tpLCBTZW50OiBNb25kYXksIFNlcHRlbWJlciAyNiwg
MjAyMiA2OjI1IFBNDQo+IA0KPiBPbiAyNi8wOS8yMDIyIDExOjE0LCBZb3NoaWhpcm8gU2hpbW9k
YSB3cm90ZToNCj4gDQo+ID4+DQo+ID4+IERvbid0IGRyb3AsIGJ1dCBpbnN0ZWFkIHB1dCBpdCBi
ZWZvcmUgInByb3BlcnRpZXMiIGZvciB0aGlzIG5lc3RlZCBvYmplY3QuDQo+ID4NCj4gPiBPaCwg
SSBnb3QgaXQuIFRoYW5rcyENCj4gPiBJJ2xsIHB1dCB0aGlzIGJlZm9yZSAicHJvcGVydGllczoi
IGxpa2UgYmVsb3c6DQo+ID4gLS0tLS0NCj4gPiAgIGV0aGVybmV0LXBvcnRzOg0KPiA+ICAgICB0
eXBlOiBvYmplY3QNCj4gPg0KPiANCj4gV2l0aG91dCBibGFuayBsaW5lIGhlcmUuDQoNCkkgZ290
IGl0LiBUaGFuayB5b3UgdmVyeSBtdWNoIGZvciB5b3VyIHN1cHBvcnQhDQoNCkJlc3QgcmVnYXJk
cywNCllvc2hpaGlybyBTaGltb2RhDQoNCj4gPiAgICAgYWRkaXRpb25hbFByb3BlcnRpZXM6IGZh
bHNlDQo+ID4+ICAgICBwcm9wZXJ0aWVzOg0KPiANCj4gVGhpcyBpcyBvay4NCj4gDQo+ID4gICAg
ICAgJyNhZGRyZXNzLWNlbGxzJzoNCj4gPiAgICAgICAgIGRlc2NyaXB0aW9uOiBQb3J0IG51bWJl
ciBvZiBFVEhBIChUU05BKS4NCj4gPiAgICAgICAgIGNvbnN0OiAxDQo+ID4NCj4gPiAgICAgICAn
I3NpemUtY2VsbHMnOg0KPiA+ICAgICAgICAgY29uc3Q6IDANCj4gPiAtLS0tLQ0KPiANCj4gQmVz
dCByZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg0K
