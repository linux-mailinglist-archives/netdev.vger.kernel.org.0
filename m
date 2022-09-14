Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25245B8EFE
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 20:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiINSlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 14:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiINSlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 14:41:08 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2123.outbound.protection.outlook.com [40.107.113.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6432F85FDA;
        Wed, 14 Sep 2022 11:41:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTYF0I1pSSSBCX+Fwc9zT9SOmROlzdb6MJ8HT5VWMOius3WIMxZi7D9uqihnTGAqhJM46X07hvP+mGM7zMkgiBpHsrDnDU5TtnWEPxQmovjGjdazCmPatZgjMF23+vEjVi55Po5exE59oJpp3pxGsrz70AHB4MywELyKaPe2nUCRzGc6Ouumd6p7QMGiAKOUEXaFOzN93JNikTQzLFXmPbUcnPpSqcxhITVUAPYuomd1hgtswdRzcz8ZGLLKz2JDobQbMlZA+QE4pvM/zslZwJqiN/WMlihX7BvH2H3/KQDAIQz3NrXsJ9r/MTOrNw5QOGMNuL0jICJpj76WrX1zpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89tAxTaM4NNN43Oy0qVPGcIk8Dd2QnU3Koqwx/itPZU=;
 b=GVHoilbcdbxInD1YQBlcuQKAeRx1d3eLSTcyNLcXDQJpSIbu9k23e05dXecSH20qfjmZRwCErAERGgvfArZczJDLt9cEsgXOkYwK7JNV0H2+ODhZ9+rCO/tuz4PonnAtO0KsfB2Qva6+y+3NWosBorhsbyBCY71/mPC3xh5oqDYQ/moZUMnWpXBALldVrLfmOuAh65BhO3/wrR6NVsg3LepGAsrVIgMTVZXGM29HuSvV5X9sNGVFwIjl/JP+kVAJosaxm+mhw/GSihyXjiet6Zqeo5G64c3vrxEaQqFU1jXlLOjS5m2ug+7fgtJ2ffSIjNeZGmbuORn44y/+VrUjLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89tAxTaM4NNN43Oy0qVPGcIk8Dd2QnU3Koqwx/itPZU=;
 b=DRZLQ6rmYHrPO8PsdraXBmyjBqJjrYBm6vpZ0npRBQruKpe3WLuaqAcQ8WjYDwfG0xhZHLqahnB7qvnNLSpawuplNSQUyn3o7GfWPHQvNrIqWon6Kuy38JPaSeQH+bv8FZtOxHfOzcjpwbgDFkymSjGnsJrF+Bh62Aby2b7XXIw=
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com (2603:1096:400:47::11)
 by OS3PR01MB9818.jpnprd01.prod.outlook.com (2603:1096:604:1ec::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Wed, 14 Sep
 2022 18:41:02 +0000
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::7c12:d63c:a151:92bc]) by TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::7c12:d63c:a151:92bc%9]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 18:41:02 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next v4] ravb: Add RZ/G2L MII interface support
Thread-Topic: [PATCH net-next v4] ravb: Add RZ/G2L MII interface support
Thread-Index: AQHYyGLp+lPWoGgGDki9ZqfyxZaYWK3fPZAAgAAAo6A=
Date:   Wed, 14 Sep 2022 18:41:01 +0000
Message-ID: <TYCPR01MB593395FC951FA72263DF71C586469@TYCPR01MB5933.jpnprd01.prod.outlook.com>
References: <20220914175327.236988-1-biju.das.jz@bp.renesas.com>
 <3efbb0f1-5dc9-4493-c4e1-92ca7a1f9489@omp.ru>
In-Reply-To: <3efbb0f1-5dc9-4493-c4e1-92ca7a1f9489@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB5933:EE_|OS3PR01MB9818:EE_
x-ms-office365-filtering-correlation-id: 1f8746fc-a864-4961-bd27-08da9680ac7b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qTs+iHM+GQJGA3tk/J0rilYaU2XOQ7pGkb65dQToAxYlDCeVHH1XP6cJl311bW0phZVTk/her/axN8YGxw9cmKY5jANp+JxMOQDBGGgRV29a5LuZRuQ4Vj6ZInVDJjn6pPi2XcqR1gQuiMsg3FRmwo6hjr/hwAsahm9ruYu83N6SFQKIXXRNDmG7U2aTUt22zy45lKyN1Fa8qN1MeuM33wjKPjHqSd8K+BdfIOioZfgTN3m0+nKQUnAaYk5YF3lMIP+h4QJ0q6tSXHQ06AQUY7qfbfEUx884nPAgRH/L3v/7px6K4mm5QuAi3tbv6K4beJsPeh0teisM3mdoxXIIIZOwexIoS5b+U8PFurwY6wuypRSW9SbhR7hkd/9Kl3DSllVRiHcBx8/eBBGhAzcD843QuUQTtePhl/NoZIAHoKKxfGl3snJChN3R+EZet3uFXMH5L3InuKZqG6e/wjNG+N1HoBC0tRNUdOz5QDMM957F4Eou1oArAjcjAIoJCfsm+8cNY65QbrgnDu1zok+cryiOw/jcACBqcb0ciVEvxB4bfdg5O+qf0G+wg114Lhazjg05WxMHGlv+QB3t6mREjRhBJBYKVVlKUKrVSAwAoBXOoBoJCudJdAXinq09Sju+HjHr4v4INN/YameUMRewodeq7gUEmWh90s9JbZF5YuCKu0Jo7Z6C05XmXG+S7nA/VuxrGl8eEig2acLchBoYrjtlGT6y1TQw0fsLUc2ukKUkqwXCKDbNDcTVHRjR6Ih0HJx6aQNyyFtYIQXWPMPKtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB5933.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(122000001)(52536014)(41300700001)(86362001)(478600001)(71200400001)(33656002)(66446008)(55016003)(6506007)(107886003)(38070700005)(8936002)(9686003)(110136005)(316002)(76116006)(4326008)(66476007)(8676002)(2906002)(7696005)(54906003)(66556008)(5660300002)(38100700002)(66946007)(64756008)(186003)(53546011)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVhKdkJ6WUVMT1l3azZudktTVmNDOEpveVdUVFNLRjBXa0V1clZ3YVFBNmNj?=
 =?utf-8?B?dEx3b2w1djFBL3pWekVEamhtRVZxUW1FSVlkVk52Z1VObW8wOTNKK0d3NDZK?=
 =?utf-8?B?VGVvQXVBYWlTaFRMM1VDZVJqTThPdHdsY1p5NzNPTkFJbVEvRitabjBZRmNn?=
 =?utf-8?B?T2dONjA1VHJjT0o1aDkxK0lQZkFpMGNwRnhhaytmejdrT0lPcjJYR3Y3b1FI?=
 =?utf-8?B?S0pCTk9yVFlJT3BlTnk5WWNOcXh6OW42eXpvRG9rL0RrN0w1OVdXenk3T1RK?=
 =?utf-8?B?Z1JUNGlwaHJJaXZJNVVNRUgrQXg0NlMyNDA3SmVLWGJ3RFNXWXZBUk9Qd2lH?=
 =?utf-8?B?bXFOTjMxRkFYR3pBR0svM0NCVjVLNGxOQXVyaWxwczhiYTg3a1loK1BTYWt6?=
 =?utf-8?B?d256dW4xNVRBdTA4aTBvYmNRSHh1bmNqSzZQamVtZWRvWHZIRjZaa0tKZ0Zu?=
 =?utf-8?B?aEpPTHBGQ0V5ak5PNkMyTkNCTVRQVVA2VDBwQnFoSERnRWRKVlF6a21wUWwv?=
 =?utf-8?B?Z0l4ZDlOWmI1YWNNYlNUem9pdG9NaGxPbjA5STk5cHhMaE9SNk5SMWhySWhm?=
 =?utf-8?B?WmU4VnhjLzUzcU4wR25OVEQzbldJSEEvY0lvUURiWmdxWEFoalVJVlQrWElG?=
 =?utf-8?B?WDRjeGNNOUlaVk9NZzlLblM2TmJUNVZpd29hTjZ2OVpWZzVJeHRQMHBTTHZr?=
 =?utf-8?B?ZUF1UjBMTEdFUEQ4Y2NFVXRIVW12bUZOeFRBNnFqcFBWb1JsU0U2Y1pvc1lC?=
 =?utf-8?B?aWJyTVZJYTdXdFlyaUc3WkJhUEtZdU9IcHU0L1poRDVaOEVwSzBFVjJ3cktl?=
 =?utf-8?B?bCs2WDNVbmdPN1k4YWlyMDFpc0lRNmtFK0F1N01zSitUOG14VHUxbHNBNmVs?=
 =?utf-8?B?alhNYmNBTEoza2xFcFhWS0piemFUaGlpTEo0SFZVakhLVEdMMUlSOUI2S0dz?=
 =?utf-8?B?OUNOZjVjYTJ4MDRZZDZJNHZLbEtKWm0vU25mdUNqZTNEL0Q5RCtXM0FhUmtt?=
 =?utf-8?B?RkE4c2daM0RnYTBjb05GcE02VTZsTGZDSWNydnF5bFFXWWtyMzRSdVNQbkRn?=
 =?utf-8?B?ZnZ4U2xKWnJ3cjd6UGR0dVk4RVJ4ZnY2T1gzcWg0TUI4ZU1YWE5nYWxCbWZ2?=
 =?utf-8?B?NnJjR2h5QUhlWXNEajdLb0NlY0hSTitUaHBVL2ZQWm1MZi83b29iZXFqUlNO?=
 =?utf-8?B?Q3FJQlFjMDBhNGxobFBpeWEwUWNPUDVzTWYwdjQ2Wm0zNEtodktVMExYR0Nq?=
 =?utf-8?B?NmFPOWZpUFV0NXk0N1lxUHRlRWs1QnFXOUt3My9lcUMvN3crUExySWF0cWhG?=
 =?utf-8?B?VzA0TTBrY3ZJSGpCUkZXOU9UT3poa2xmTDRJL25HekozdE83RzRiYjZZaEJX?=
 =?utf-8?B?bWJ0SFVZVEh4TjVTMEd3eVlDR2RZYkhjNkhiK1lHb1hNdFJLaHBvdTJVeVdJ?=
 =?utf-8?B?bVZ3TjBQRmxQZnk1QlJ3amhmZkxJcG05K3Q2Wm5DTUVXR2ltQ2hGQWVwYWpF?=
 =?utf-8?B?Szh2Q044U2Z1YktCZ0JNWHVXZzJkMk82a2pyREh1WVR6Zk5WOFVCSUwzU2hV?=
 =?utf-8?B?Nmk3VzBjMnJwWmdLY1JLekxvRWNCT1psVjh0ak0ya3cxZ3ErQlUzZXRmd0c0?=
 =?utf-8?B?clovNFF5cmpNNi8xV2JqdStYd2J1eTNreHlZM2dIV3FDSSthSnM5WEVQcU81?=
 =?utf-8?B?d21xRDNUSUpISFlIeXR4TGdvRTBwUG40OWNiWUFrenN6TXhtbCtTMHMrMGNZ?=
 =?utf-8?B?SWxnSk5DQmk3RUpMYThSVjlCL0RXRDZtSTdmbVlTZHZkZVNhSjR4Y2gwM3NS?=
 =?utf-8?B?Qmh0SllPYldLUGVuNjNNZ1MrdFJjRW5hdXgweFVEa3hORlIrTkJOd2xPWnZF?=
 =?utf-8?B?SkhwV1ZuaUVieHRlZXJ4RnVnd2pzVm5WNHYvbEJlREFtd2g5MW5WSlJZZEhl?=
 =?utf-8?B?QVZ6MUtzcXVvbDFIQWN6Vnc4cTlCSi9UYm5OeTA2QXZxS2VQRUZRUmlwM2E2?=
 =?utf-8?B?cmVMcmtaMDErUkh2V2pSV1R6emNCKzhvdkduSkFhNVY1WHRJeUJ5a1FnL0ox?=
 =?utf-8?B?c3hyT1JHMVVrenBaNWVUZWRQYjJLWTVFRVBPOFZBQTFOekdpdjRpVW9KR0wv?=
 =?utf-8?B?QkpGV0doNy90ZGxiYlJDcjZEdTAxS0xkUnk4b0cvZFExb1Y5WkVxWXJld3lE?=
 =?utf-8?B?ZGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB5933.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f8746fc-a864-4961-bd27-08da9680ac7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 18:41:01.9491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hBfIy1UV9HSAkuKg0SdSopMB4I0JnlAk1ZrBuO9X2ZxQ8pQ1SKTftZP0MM+h2G9JH1lsXh7ctoDU79c9JW+9R/AMqJ0RZfahF4Z6BBJUXB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9818
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjRdIHJhdmI6IEFk
ZCBSWi9HMkwgTUlJIGludGVyZmFjZSBzdXBwb3J0DQo+IA0KPiBPbiA5LzE0LzIyIDg6NTMgUE0s
IEJpanUgRGFzIHdyb3RlOg0KPiANCj4gPiBFTUFDIElQIGZvdW5kIG9uIFJaL0cyTCBHYiBldGhl
cm5ldCBzdXBwb3J0cyBNSUkgaW50ZXJmYWNlLg0KPiA+IFRoaXMgcGF0Y2ggYWRkcyBzdXBwb3J0
IGZvciBzZWxlY3RpbmcgTUlJIGludGVyZmFjZSBtb2RlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IC0tLQ0KPiA+IHYz
LT52NDoNCj4gPiAgKiBEcm9wcGVkIENYUjM1X0hBTEZDWUNfQ0xLU1cxMDAwIG1hY3JvDQo+IA0K
PiAgICBJdCdzIG5vdCBtYWNyby4uLg0KPiANCj4gPiAgKiBBZGRlZCBDWFIzNV9IQUxGQ1lDX0NM
S1NXLCBDWFIzNV9TRUxfWE1JSSBhbmQgQ1hSMzVfU0VMX1hNSUlfUkdNSUkNCj4gPiAgICBtYWNy
b3MuDQo+IA0KPiAgICBOZWl0aGVyIGFyZSB0aGVzZS4uLg0KPiANCj4gPiB2Mi0+djM6DQo+ID4g
ICogRG9jdW1lbnRlZCBDWFIzNV9IQUxGQ1lDX0NMS1NXMTAwMCBhbmQgQ1hSMzVfU0VMX1hNSUlf
TUlJIG1hY3Jvcy4NCj4gPiB2MS0+djI6DQo+ID4gICogRml4ZWQgc3BhY2VzLT5UYWIgYXJvdW5k
IENYUjM1IGRlc2NyaXB0aW9uLg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmIuaCAgICAgIHwgOCArKysrKysrKw0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgOCArKysrKysrLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQs
IDE1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBpbmRleCBiOTgwYmNlNzYzZDMuLmI0NDVkYTBmYTU3
OCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0K
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+IFsuLi5dDQo+
ID4gQEAgLTk2NSw2ICs5NjYsMTMgQEAgZW51bSBDWFIzMV9CSVQgew0KPiA+ICAJQ1hSMzFfU0VM
X0xJTksxCT0gMHgwMDAwMDAwOCwNCj4gPiAgfTsNCj4gPg0KPiA+ICtlbnVtIENYUjM1X0JJVCB7
DQo+ID4gKwlDWFIzNV9IQUxGQ1lDX0NMS1NXCT0gMHhmZmZmMDAwMCwNCj4gDQo+ICAgIFNob3Vs
ZCBjb21lIGxhc3QuLi4NCg0KT2ssIHdpbGwgZG8uIElmIGV2ZXJ5b25lIG9rIHdpdGggaXQuDQoN
Cj4gDQo+IFsuLi5dDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9t
YWluLmMNCj4gPiBpbmRleCBiMzU3YWM0YzU2YzUuLjQyMWM4ZmYxY2UxZiAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IEBAIC01NDAsNyAr
NTQwLDEzIEBAIHN0YXRpYyB2b2lkIHJhdmJfZW1hY19pbml0X2diZXRoKHN0cnVjdCBuZXRfZGV2
aWNlDQo+ICpuZGV2KQ0KPiA+ICAJLyogRS1NQUMgaW50ZXJydXB0IGVuYWJsZSByZWdpc3RlciAq
Lw0KPiA+ICAJcmF2Yl93cml0ZShuZGV2LCBFQ1NJUFJfSUNESVAsIEVDU0lQUik7DQo+ID4NCj4g
PiAtCXJhdmJfbW9kaWZ5KG5kZXYsIENYUjMxLCBDWFIzMV9TRUxfTElOSzAgfCBDWFIzMV9TRUxf
TElOSzEsDQo+IENYUjMxX1NFTF9MSU5LMCk7DQo+ID4gKwlpZiAocHJpdi0+cGh5X2ludGVyZmFj
ZSA9PSBQSFlfSU5URVJGQUNFX01PREVfTUlJKSB7DQo+ID4gKwkJcmF2Yl9tb2RpZnkobmRldiwg
Q1hSMzEsIENYUjMxX1NFTF9MSU5LMCB8IENYUjMxX1NFTF9MSU5LMSwNCj4gMCk7DQo+ID4gKwkJ
cmF2Yl93cml0ZShuZGV2LCAoMTAwMCA8PCAxNikgfCBDWFIzNV9TRUxfWE1JSV9NSUksIENYUjM1
KTsNCj4gPiArCX0gZWxzZSB7DQo+ID4gKwkJcmF2Yl9tb2RpZnkobmRldiwgQ1hSMzEsIENYUjMx
X1NFTF9MSU5LMCB8IENYUjMxX1NFTF9MSU5LMSwNCj4gPiArCQkJICAgIENYUjMxX1NFTF9MSU5L
MCk7DQo+IA0KPiAgICBIbS4uLiBBY2NvcmRpbmcgdG8gdGhlIFJaL0cyTEMgbWFudWFsLCB3ZSBz
dGlsbCBoYXZlIHRvIHNldA0KPiBDU1IzNS5IQUxGQ1lDX0NMS1NXIHRvDQo+IDEwMDAgZXZlbiBm
b3IgUkdNSUkuLi4gV2UgcHJvYmFibHkgbmVlZCBzb21ldGhpbmcgbW9yZSBzb3BoaXN0aWNhdGVk
IGhlcmUsDQo+IGxpa2UgYSBmbGFnIGluIHRoZSAqc3RydWN0KiByYXZiX2h3X2luZm8uLi4NCg0K
U3RyaWN0bHkgbm90IHJlcXVpcmVkLCBhcyBpdCBpcyBiYXNlZCBvbiBJbi1iYW5kIFN0YXR1cy4g
DQoNCkl0IGlzIG9uZSBvZiB0byBkbydzIGluIG15IGJhY2tsb2cgdG8gYWRkIA0KWE1JSSBzZWxl
Y3Rpb24gZm9yIFBIWSB3aGljaCBkb2VzIG5vdCBzdXBwb3J0IEluLWJhbmQgU3RhdHVzLg0KDQoN
CkNoZWVycywNCkJpanUgDQo=
