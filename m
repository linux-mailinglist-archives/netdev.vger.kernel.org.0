Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23CC565058
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbiGDJHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233664AbiGDJHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:07:36 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2091.outbound.protection.outlook.com [40.107.113.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C03EB86C;
        Mon,  4 Jul 2022 02:07:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=no/2VsbpUOmhr87YkoBzV34FVLEdH+OSh+6vwfkoMQFjlDSgj0CcVbPSh6gPpXGjStaraDZfmcxbiMCeO+/bsOkxX025/YGSWfR38Fs0AOCcTtlnik3WpCIIcjIR5/1HiKuWdVQZhqSHV2YhZqX1z9lL5JH67Ayv0Xva89kAdnXwKthTcx3bTVSbPoY2g3E2yBwHG4BjcLE3zByHzh7pCFB8yGCOZPEddgOZx0ZsvdqSGOybgI0ZYlk2odUcWwUyE6Yu016a8RYrX1WJOZmNlY6ETJhI3DUS8iqdRGWPNGI7uE7DGoLzuxUQpBMHw1rFDBBThbRh5AiEuqA8ygpArw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFTWVA1hyIyLB31AijeQofJSuCuC/OKJMKiSXgbLsZc=;
 b=WZCLcdGNfau2c2WdqtFZI3sZdStuapGptGw7OWu8elo7KLH7O88v1QZFEBSbV8g3Awse6fYk2vazW/3yCkCzV2khACU418D5te34HSN1xnnbtjF42UXgH+EKoa7RC4Y0dZb/rzanq3bI48bT54qM1P1gPy2Q+hGLi9r76nTS/sQ3KY8xzIohLXPuNr47olghl8lxVvWwoxVjUPnstRBDe79dvcDUSjOUasQnLnaB/Bb8scKtnYuMj5sLoNJMdRtLz3LVWsrSpATdxWAFqZs+viZeIEWXITwyiCwlbFgw7KU4otOpiMUz8JeY7UhurlK98/sJk8QY+s4bhZpQdjKMDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFTWVA1hyIyLB31AijeQofJSuCuC/OKJMKiSXgbLsZc=;
 b=NaGujkDu7oyILzuy1eGi0nd8KqpShYVTJqK2PAynAcw23lFnzAc4ueLW54j0KiAnTBy3ILOKeQiI4cuGMxW6ai0ybVSLdMFH0IiLdEp2aKXfi9p3DELUPoS54FW2TXmb78rmBOsNoevtezUmB3h/Mvrbv3qNi/pdSeq3/2UwIrc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB9608.jpnprd01.prod.outlook.com (2603:1096:400:19b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 09:07:32 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 09:07:32 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 2/6] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S}
 support
Thread-Topic: [PATCH v3 2/6] dt-bindings: can: nxp,sja1000: Document
 RZ/N1{D,S} support
Thread-Index: AQHYj3rIHPLTRXfLGUKasqPYhC0+kq1t5p0AgAAESuA=
Date:   Mon, 4 Jul 2022 09:07:32 +0000
Message-ID: <OS0PR01MB59228BC544D31FB0761D463E86BE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
 <20220704075032.383700-3-biju.das.jz@bp.renesas.com>
 <9124be7e-2512-da31-631f-e74ae8c3175c@linaro.org>
In-Reply-To: <9124be7e-2512-da31-631f-e74ae8c3175c@linaro.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 242eb8db-b764-4748-71c0-08da5d9ca0d8
x-ms-traffictypediagnostic: TYWPR01MB9608:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IZYEW6oe0xWGGI9f0am95U8R34QF4+bfiPYlJt37GDNwHelrPYXCdoU8VPUVQ7bGG31ooK464GqXdtOwGCsRfYBzDKqW3oyqYrOxMUZ/vTYQIlO9VfDPx/85s4a5sQ5u7eqfSR6fWVtYfLPSHM7NPM/81EE3tUPS0FrrnQqmnp33KC6+zRegR4wIoIVSIRfP8wKkLGY6I7pw7LwdcS31BHadfU5TTvJP98cw+cf1RccOfyEauVXZittLifN1v0PPSosMw4VCRPb8M287gzUllvo9EOL3KwfKmY0E9c5zxvcQfTH07uteS76cUPgO4ik0qRs4lYZYHwufLcBjfrQyjv5AHhwQhjZxC2ZYPiRODsb8ZrN7g1C/PYmaPgfz/QnFmDfxGn+Fb/4b5UTh2eld/UDK4yKzQJZs6aHosMdrJoE6R/tuF3FNTF6UnwQUQsliGRsK4V1I10323cjsxohTW6sXWK5lzisEF96wtWQT84CsFdBIJaokURNmdBpbv5TwiuqZZPtJq8RzmL/Elz/CkqJR2wlsurS4bIxrCIyqcbU76ythAstRDFNmHGeGj9mfL0rvNUDhs7wO4f2Rbp7OMescjf46hDf2uaVnUQP525m76TSJdByNkI6Bo+NxDlINuXAEiZpbYfO6OMg/56t1oHnm3QfCvZO7sXLgPWBQ3ZULq2+lKoKr467ogFDlFJrwRgw1bhRsTxDKiZoNwWsQ4DLCzipdM3I9Z2hqw+m5bdwmJtHQ/l4iMQnSSdCJCrxa1Zu6XZcPx/lD8Xf5hUCzc1bO5MLKeqELcnjPwghvraNLNhuaSC1gFmnoNZOt/vOL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(54906003)(52536014)(9686003)(7416002)(7696005)(26005)(53546011)(6506007)(5660300002)(8936002)(86362001)(38070700005)(110136005)(76116006)(66556008)(66446008)(71200400001)(66946007)(4326008)(64756008)(8676002)(66476007)(316002)(41300700001)(122000001)(478600001)(186003)(55016003)(33656002)(2906002)(38100700002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkpjY2JjbVNWd2VFZEhBbjlGMHlvNStYWmNTQndJZTF3U3pVTm1RY3NaeHJD?=
 =?utf-8?B?REdINU5qdzFuTEl4QzNlYzVQRDZKWkRTUEZwMTZqOXhJQ201c1FvRmRjTDhu?=
 =?utf-8?B?Vml0MU9nYWYzL1pRMnlKS2ZhVHNVZDhsenFGdkpCbG1wcDJabjlndngrOVBE?=
 =?utf-8?B?eCtRaXEwWW5yVTFCQTd2VlMrVUpqbmdOQXpRa3NBUU5VNjJEaEVqb3BzdDB3?=
 =?utf-8?B?RWxXb2YwU0JiS1YyVnZGdE1WUmRCNVU1SDBJODQxbk1lSzdGSFJpeUMxcEJp?=
 =?utf-8?B?RUZ1SnZsYmkwUWhNNjJvY0trbEFnQit3OTBxL21jN3BGU1NIdWdESmRXMXBP?=
 =?utf-8?B?eW92amo5UThycFZJVXZlT2lQcG95cE95b0Zha3kwMk1kTDg0TytvMS9vQ3Nx?=
 =?utf-8?B?RTZxaGt0Uk5RWVNXSkNUa3d4YTVaR0NsbmQyYVZtVkdPSVBzc2hpSG0rMTRG?=
 =?utf-8?B?WUJuQ1d4bEpqQ3pHU0xyUHdORHg0OXZNbmZVcWF5Y3QvcTRUWGsxdFZwWm1a?=
 =?utf-8?B?bmNOVkVMN2FUakZuTUVNK0pxczF3UDRkdmQ4d3RjY0czUkgwY0F1dlFQVm54?=
 =?utf-8?B?MlFlT1UxZVhtczA0Vm01VXJWWkQvUmprQ3dhakptOFAybURqYlpxbXJuWjNj?=
 =?utf-8?B?MG1mKzBaaHl4bHVibjNnTzJkQXpOdjlDRHFMQXUxc3VIbFlzUTVPbEl0dVlp?=
 =?utf-8?B?ZWRBRU5vdEM4L3RZOUErQkZrczQ0WkZqazNteVVadWRoZXZQTU1rdzNkR2hr?=
 =?utf-8?B?eUZ4VG9yZG15Z0dVTHA0UDQvbEtmUHNuSnFYeVpOREgwWmVDcUM4Q2RWdFpJ?=
 =?utf-8?B?UlAyemFSaVBKQVRWODJpZWYyV2xGQ1paN1JBcWNDYmhEdmNYS2RHTzRqdERZ?=
 =?utf-8?B?cUpzVkZKK1lRbU9kR2JZTEVlSkgwbisrTXl0NDlCNUFBM3Z1L0I0amkyT1Ft?=
 =?utf-8?B?QlJFUjd2Mm9mdlVFYTNrWTJQSi9VRzhGbWNLSkhlMEpveE9QOU0zSTBzTjJV?=
 =?utf-8?B?NTc0Qm52cjVVY0tva0hRZDVyVXdJaFFoY3N6aTU2eDBpNytKN3ZWUVB0a2gr?=
 =?utf-8?B?SFMzY2lJT1A5SDRrN3FBay9IU2hHV2tPaEJwWFBhSVVER1RmTGNkWTNxSEpz?=
 =?utf-8?B?QmV6OE1kckdCYmkrb2ROS3RiOVVhYTRlZEQwd0VDa2tGeG03R2gvaHhXV0Jk?=
 =?utf-8?B?Nk1zYzZUVXJPdVBpOFBTN1UxT1htM2VrOTBBQWFWQ0ExeGZobEpkdjNiQU16?=
 =?utf-8?B?eFFRaG83RUZPQWRRUkg4L0hndGNBcDVkd1hjTlczOW1UTE52SVVSS0dVQkFY?=
 =?utf-8?B?aEhCVnVURjgvelZrak0yMkZBREV6bWxabm05a1JZVjlON1N6SjFYcTBoWko2?=
 =?utf-8?B?OSsrU25Zbm9LWW9XVnpEWjRNZmZTNWlWcWxlMml3YTRtU3FGL242Z1FQQ0wr?=
 =?utf-8?B?VkdDbExyUWFZRUxCR1pLUHV0elhpZzMzZHJBeWdXb2ovWlFINDRLTHppNWM4?=
 =?utf-8?B?TDgzSis1eUVLY2t5U09OUDBFcEtSd1cvclVadEh0VnhhVnZlcVpWUGRUTFFm?=
 =?utf-8?B?cG5nNDg2bWJZQThNN1A5ZXFrYnNZbW5NZnREVWJsbFk3SkROY1Q0em01RVRJ?=
 =?utf-8?B?Wi9kMHEyMGJlTTBlWk5qcXFnbitidFM4RVlSS2RmVUZTMHNxM1ZVOEVqcWRj?=
 =?utf-8?B?UUtVK2w2RitycTdoR0hWT1RScFZiMUFOM295cFJjMlIwRmNnSk9RVkhUeDFz?=
 =?utf-8?B?bndzNzcybE51MDhvUUVMWURBbWFoTmlzRnR6eXBBelNaOFM0eHFqVVhFRS94?=
 =?utf-8?B?bERKdDJwbzBCUWtOMWxiWUlsUnNyZUVhODFiakYySHlhb0RsdDEvSFpNRWlN?=
 =?utf-8?B?bzB5Y2xOWFp3djEyUGxpc3NMREpoTjBIOGNLeGUweGFjaFBYczFocjFxL1Jm?=
 =?utf-8?B?SmtQQVN3T0FCbGRHeDR2RjJZb1dSUVV2cVFrYlJsaUY4T0xrQ0xlaGdjbEpC?=
 =?utf-8?B?WXdzK1VkSzdDazZjc0I4ci9oV3h6R3Ivb0JIS2NvWGxPMDNpU3hPRUhWd0lX?=
 =?utf-8?B?ZDFmaEZIYW5rSFNWWDBoV0ZxZmZpUklRT29lYitlUWwra2xSdWpIOW9HdDNJ?=
 =?utf-8?B?a2svNVlOdmQ4VDJsMllZRjAzSXU4WllrWmlxMXFQdEdRQWRRRU1SNERxdzlD?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 242eb8db-b764-4748-71c0-08da5d9ca0d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 09:07:32.0542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QneK8BJB5shucJ34SV+tMPRNHoZfHAbLC5CqkWFb6eQbOyTug3JbXEVjJoEruuHmkJ+2UKR+2PhxHDpTsQ02j6SKed12fcrCZ7pDLhhJytU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9608
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3J6eXN6dG9mLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIHYzIDIvNl0gZHQtYmluZGluZ3M6IGNhbjogbnhwLHNqYTEwMDA6IERvY3VtZW50
DQo+IFJaL04xe0QsU30gc3VwcG9ydA0KPiANCj4gT24gMDQvMDcvMjAyMiAwOTo1MCwgQmlqdSBE
YXMgd3JvdGU6DQo+ID4gQWRkIENBTiBiaW5kaW5nIGRvY3VtZW50YXRpb24gZm9yIFJlbmVzYXMg
UlovTjEgU29DLg0KPiA+DQo+ID4gVGhlIFNKQTEwMDAgQ0FOIGNvbnRyb2xsZXIgb24gUlovTjEg
U29DIGhhcyBzb21lIGRpZmZlcmVuY2VzIGNvbXBhcmVkDQo+ID4gdG8gb3RoZXJzIGxpa2UgaXQg
aGFzIG5vIGNsb2NrIGRpdmlkZXIgcmVnaXN0ZXIgKENEUikgc3VwcG9ydCBhbmQgaXQNCj4gPiBo
YXMgbm8gSFcgbG9vcGJhY2sgKEhXIGRvZXNuJ3Qgc2VlIHR4IG1lc3NhZ2VzIG9uIHJ4KSwgc28g
aW50cm9kdWNlZCBhDQo+ID4gbmV3IGNvbXBhdGlibGUgJ3JlbmVzYXMscnpuMS1zamExMDAwJyB0
byBoYW5kbGUgdGhlc2UgZGlmZmVyZW5jZXMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1
IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gdjItPnYzOg0K
PiA+ICAqIEFkZGVkIHJlZy1pby13aWR0aCBpcyByZXF1aXJlZCBwcm9wZXJ0eSBmb3IgcmVuZXNh
cyxyem4xLXNqYTEwMDAuDQo+ID4gdjEtPnYyOg0KPiA+ICAqIFVwZGF0ZWQgY29tbWl0IGRlc2Ny
aXB0aW9uLg0KPiA+ICAqIEFkZGVkIGFuIGV4YW1wbGUgZm9yIFJaL04xRCBTSkExMDAwIHVzYWdl
DQo+ID4gLS0tDQo+ID4gIC4uLi9iaW5kaW5ncy9uZXQvY2FuL254cCxzamExMDAwLnlhbWwgICAg
ICAgICB8IDM1ICsrKysrKysrKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDM1IGlu
c2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQNCj4gPiBhL0RvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9uZXQvY2FuL254cCxzamExMDAwLnlhbWwNCj4gPiBiL0RvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvY2FuL254cCxzamExMDAwLnlhbWwNCj4gPiBp
bmRleCBkMzQwNjAyMjZlNGUuLjE2Nzg2NDc1ZWFlMyAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Nhbi9ueHAsc2phMTAwMC55YW1sDQo+ID4g
KysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vbnhwLHNqYTEw
MDAueWFtbA0KPiA+IEBAIC0xOSw2ICsxOSwxNiBAQCBhbGxPZjoNCj4gPiAgICAgIHRoZW46DQo+
ID4gICAgICAgIHJlcXVpcmVkOg0KPiA+ICAgICAgICAgIC0gcmVnLWlvLXdpZHRoDQo+ID4gKyAg
LSBpZjoNCj4gPiArICAgICAgcHJvcGVydGllczoNCj4gPiArICAgICAgICBjb21wYXRpYmxlOg0K
PiA+ICsgICAgICAgICAgY29udGFpbnM6DQo+ID4gKyAgICAgICAgICAgIGNvbnN0OiByZW5lc2Fz
LHJ6bjEtc2phMTAwMA0KPiA+ICsgICAgdGhlbjoNCj4gPiArICAgICAgcmVxdWlyZWQ6DQo+ID4g
KyAgICAgICAgLSBjbG9ja3MNCj4gPiArICAgICAgICAtIGNsb2NrLW5hbWVzDQo+ID4gKyAgICAg
ICAgLSByZWctaW8td2lkdGgNCj4gPg0KPiA+ICBwcm9wZXJ0aWVzOg0KPiA+ICAgIGNvbXBhdGli
bGU6DQo+ID4gQEAgLTI3LDYgKzM3LDEyIEBAIHByb3BlcnRpZXM6DQo+ID4gICAgICAgICAgY29u
c3Q6IG54cCxzamExMDAwDQo+ID4gICAgICAgIC0gZGVzY3JpcHRpb246IFRlY2hub2xvZ2ljIFN5
c3RlbXMgU0pBMTAwMCBDQU4gQ29udHJvbGxlcg0KPiA+ICAgICAgICAgIGNvbnN0OiB0ZWNobm9s
b2dpYyxzamExMDAwDQo+ID4gKyAgICAgIC0gZGVzY3JpcHRpb246IFJlbmVzYXMgUlovTjEgU0pB
MTAwMCBDQU4gQ29udHJvbGxlcg0KPiA+ICsgICAgICAgIGl0ZW1zOg0KPiA+ICsgICAgICAgICAg
LSBlbnVtOg0KPiA+ICsgICAgICAgICAgICAgIC0gcmVuZXNhcyxyOWEwNmcwMzItc2phMTAwMCAj
IFJaL04xRA0KPiA+ICsgICAgICAgICAgICAgIC0gcmVuZXNhcyxyOWEwNmcwMzMtc2phMTAwMCAj
IFJaL04xUw0KPiA+ICsgICAgICAgICAgLSBjb25zdDogcmVuZXNhcyxyem4xLXNqYTEwMDAgIyBS
Wi9OMQ0KPiANCj4gVGhpcyBleHBsYWlucyB1c2FnZSBvZiBvbmVPZiwgYnV0IHN0aWxsIGVhcmxp
ZXIgZW50cmllcyBzaG91bGQgYmUganVzdCBhbg0KPiBlbnVtLg0KDQpPSy4NCg0KPiANCj4gPg0K
PiA+ICAgIHJlZzoNCj4gPiAgICAgIG1heEl0ZW1zOiAxDQo+ID4gQEAgLTM0LDYgKzUwLDEyIEBA
IHByb3BlcnRpZXM6DQo+ID4gICAgaW50ZXJydXB0czoNCj4gPiAgICAgIG1heEl0ZW1zOiAxDQo+
ID4NCj4gPiArICBjbG9ja3M6DQo+ID4gKyAgICBtYXhJdGVtczogMQ0KPiA+ICsNCj4gPiArICBj
bG9jay1uYW1lczoNCj4gPiArICAgIGNvbnN0OiBjYW5fY2xrDQo+IA0KPiBTa2lwIGVudGlyZSBj
bG9jay1uYW1lcy4gRG9lcyBub3QgYnJpbmcgYW55IGluZm9ybWF0aW9uLCBlc3BlY2lhbGx5IHRo
YXQNCj4gbmFtZSBpcyBvYnZpb3VzLg0KDQpZZXMsIHRydWUgZm9yIHNpbmdsZSBjbG9jaywgY2xv
Y2stbmFtZXMgZG9lc24ndCBtYWtlIGFueSB2YWx1ZS4NCldpbGwgZHJvcCBpdC4NCg0KPiANCj4g
PiArDQo+ID4gICAgcmVnLWlvLXdpZHRoOg0KPiA+ICAgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMu
eWFtbCMvZGVmaW5pdGlvbnMvdWludDMyDQo+ID4gICAgICBkZXNjcmlwdGlvbjogSS9PIHJlZ2lz
dGVyIHdpZHRoIChpbiBieXRlcykgaW1wbGVtZW50ZWQgYnkgdGhpcw0KPiA+IGRldmljZSBAQCAt
MTAxLDMgKzEyMywxNiBAQCBleGFtcGxlczoNCj4gPiAgICAgICAgICAgICAgbnhwLHR4LW91dHB1
dC1jb25maWcgPSA8MHgwNj47DQo+ID4gICAgICAgICAgICAgIG54cCxleHRlcm5hbC1jbG9jay1m
cmVxdWVuY3kgPSA8MjQwMDAwMDA+Ow0KPiA+ICAgICAgfTsNCj4gPiArDQo+ID4gKyAgLSB8DQo+
ID4gKyAgICAjaW5jbHVkZSA8ZHQtYmluZGluZ3MvaW50ZXJydXB0LWNvbnRyb2xsZXIvYXJtLWdp
Yy5oPg0KPiA+ICsgICAgI2luY2x1ZGUgPGR0LWJpbmRpbmdzL2Nsb2NrL3I5YTA2ZzAzMi1zeXNj
dHJsLmg+DQo+ID4gKw0KPiA+ICsgICAgY2FuQDUyMTA0MDAwIHsNCj4gPiArICAgICAgICAgICAg
Y29tcGF0aWJsZSA9DQo+ID4gKyAicmVuZXNhcyxyOWEwNmcwMzItc2phMTAwMCIsInJlbmVzYXMs
cnpuMS1zamExMDAwIjsNCj4gDQo+IE1pc3Npbmcgc3BhY2UgYWZ0ZXIgLA0KT0suDQoNCj4gDQo+
IFdyb25nIGluZGVudGF0aW9uLg0KDQpBcyB5b3Ugc3VnZ2VzdGVkIGluIHRoZSBwcmV2aW91cyBw
YXRjaCwgd2lsbCBtYWtlIDQgc3BhY2VzIGluZGVudGF0aW9uIGZvciBleGFtcGxlcy4NCg0KQ2hl
ZXJzLA0KQmlqdQ0K
