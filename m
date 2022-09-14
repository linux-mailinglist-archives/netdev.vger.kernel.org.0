Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A661E5B8E3A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiINRgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 13:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiINRgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:36:00 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2120.outbound.protection.outlook.com [40.107.113.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574717B1D4;
        Wed, 14 Sep 2022 10:35:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRJZgbEIKlQdrWdaHVWxu5X3ZbpAMN0DERQcTZqkdFFfqy06HX7wSpZJMSiWalB6FCBNjVE0VBohW1VRIgSmgw5GAHQ+98oGwCnSQUI8Ng0IePriMNNAF+p+o891QJfVKKoCkqY0QwJkgMBfYLQlpW0WIweweEM+AakBKbNZcxINKm1tW0PM6JTKrTswHdO0BSce8aMDr8oYXWlF68Tfv8Yokloj7i38mDXuSlJVAAQ529xhSESDB0Vvbv+MNGqZDTW4KthdmMEpBxONWi2XrPJ5nIUiUPb3ZP9tQmmnhs45Y+eyx07K4YGpVYXYR0FggZ7yZbvL6s3Pc37m2Gc4bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9wOyol8Np3r2DdIJQiZXHV16praw4vFs1UykJ+uQy8=;
 b=GqiG45AcudqZ2kIFXo0Ex6JUywYd2KjaVwyAKQZo0xS76MZgC4Dl3hfOrIz65Tl1Ofjy2F06N62hSBMYuftvHAc4bjIU1M4GTcIDtXS0USbwKIOM8nLxQmpIUsw+qxBPo+lwfJu3IYyos8C2AdoUf3NiO1frmTIWSCHWrrtqqoJf2nDsiRzb70lv5elP0UvjweroB9p+HiNt5f6ImJw8pNX94kdtZdsD7MJkUWfideQngYoQ2AKVK0hrNj8YIfH/n+xJzR9HI5WNpW3ULscDgDMhWObKz66PGY58TkU3q81iNl5My4hMhfMweL9G95NGhEhRgKSW4wOAIldvi5tAbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9wOyol8Np3r2DdIJQiZXHV16praw4vFs1UykJ+uQy8=;
 b=hgVPjprSuwVz9JhqZFAahlONjGLuQl06/C0ENz7HFp6FSi7klq+MG1t5GLjiZ9VoNVEuUOHdqvWQUdmF0gHCHabqh6E9iVAXZGkggOO/UR0VghDQ+lPnUGj+I0T8EUmPivh+OKubKnOcBsEU2mt1iLPslSYphBzd8dVFoEr5cqY=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYVPR01MB10700.jpnprd01.prod.outlook.com (2603:1096:400:2ad::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Wed, 14 Sep
 2022 17:35:56 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c502:8f9f:ec5e:8e3f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c502:8f9f:ec5e:8e3f%3]) with mapi id 15.20.5632.014; Wed, 14 Sep 2022
 17:35:56 +0000
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
Subject: RE: [PATCH net-next v3] ravb: Add RZ/G2L MII interface support
Thread-Topic: [PATCH net-next v3] ravb: Add RZ/G2L MII interface support
Thread-Index: AQHYyAXhcDwFSsslx0u3BQUD3D9PoK3fKQ2AgAAAbaCAAAXnAIAAAITg
Date:   Wed, 14 Sep 2022 17:35:55 +0000
Message-ID: <OS0PR01MB59224746A9C18AB933498AEB86469@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220914064730.1878211-1-biju.das.jz@bp.renesas.com>
 <631f13b7-9cab-68b7-a0b1-368bb591c4d2@omp.ru>
 <OS0PR01MB592297F89124DD62211582AE86469@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <34db8b96-624a-09e5-24e1-9b8be375a6c8@omp.ru>
In-Reply-To: <34db8b96-624a-09e5-24e1-9b8be375a6c8@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYVPR01MB10700:EE_
x-ms-office365-filtering-correlation-id: b7662c5e-878e-497f-9c49-08da96779453
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w98fmm9WdIhU4lQ/NkmH9j7lhbNCoCR1gP0zGpBw+87BNgF9VZTrVDxkR5rHNH47loeWkURmtCCLON7YXDEzPpnZO8cIPmx3NJSjdlWhpQtCLrOVyAgNK0wEQ2wbQqUmRWNqfvgOgGMLs29s57CYi8NPC2ZZP7UlgZOphl//YMVPImKsCQJYG7es/W/FPmvRMdSGbcXleD0MtalHRFY83DkhkUsKguQy/wM2a9YEbrAxHmfieorXs5Ao4nyj1jdKmXp+4WGXy61/6A3QNkZcuIak6NN0hv7aoL6zCGCjqK61BknStClvSRx9AQRpAru8QIrPoGTNv8sGbmtJQ3QmFYVKPo1XZio/zdARQFFx8744TeaMQ4Gku6U14H3kT2zKnvdzZyTMeUbGGhwQOwGjkvFYeGurXv3mPwRAPOiqStYHmZoTFrn/TBCILgRFmUESATKK+rSzdAEe0ORiZk3iNBFyydJQFMFF2ISsviBI0K7WkGZg/lPCPSpPvpvInIDSR6xPpUIT5gV5QjTuohvBaVNhb5+wwPlzy+kCIOSTXm5YIA4xISQf6TgUBda2dKpaiS1DOV5vMO4sLEqbv8aT+K7XpYOrGt0Cpaul7lWgirDuzBbk8wEOogdQU/eahX+orAAtjG+nfFJOSYHbGgiF8bhyI3k+xAxD4vMzpSiBT93LADrFXRn7rKj22+SEorMdefGjrX/bqFEsVIjyvSnZ8Ms4puV7Guk1IVy1jWfwEP9OCiDO1CF8AFHiHavejuVgguysrRrTKnVijsfSr4tW3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(52536014)(8936002)(2906002)(5660300002)(33656002)(86362001)(55016003)(53546011)(7696005)(26005)(9686003)(71200400001)(41300700001)(478600001)(38070700005)(122000001)(76116006)(38100700002)(66946007)(66556008)(66476007)(66446008)(4326008)(8676002)(64756008)(6506007)(186003)(54906003)(110136005)(316002)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGZLd1VhWEhlbkdRMGpWcGFvTGNnNzh0U3RZTi9vU0xUS1lZanRGTTl0NUZk?=
 =?utf-8?B?cGVTbFNXVk1sS1lTTHhuUU5vdTNmL1dzM0twMzZvaTVzS010K1haWmNZL3dy?=
 =?utf-8?B?aDFJSExzdEhCbVBiS1R2SlJHL0RkYmdOVUVSY1hxa2RpdjRXdmgwOExKOXA4?=
 =?utf-8?B?YlJtZUplK25WNzE5dHFKdjRFN05WK3BBRGxqRWFFRkM0UkxtVW82bCtURUwy?=
 =?utf-8?B?bHRPV29MUXM4TkRYU0h3eGlpQXVvZVoyNllWQXNQalZuUFhUckt2N0s0TVY2?=
 =?utf-8?B?bUxzWjRGQXZvU29UQk9JMGExM1J0WkNJZzQrcjdhY0tHdWoxVGZyZmdGc1dh?=
 =?utf-8?B?dHBCL0FlbFV2eDhjWE82QW1HRW1QWHpvU3pXMHhpMUoxU29MNCtxYnhVbmp6?=
 =?utf-8?B?QlB0ZHlhTGVpNlJra2pyUFdER1ZjTGs3aGF4eFNYcCtCS2k5UEhqc0h3RTMx?=
 =?utf-8?B?U3lHOFM3TkkzRkVMTzN1eUNzbE0ydmRCTTVXS2tKTmRsSGV4Y1pubERyUzZi?=
 =?utf-8?B?TjRSdlhkOVZrMjNDenFZZ3p4VDJDdDRoSDRMWFVrWHU5WHMycWVlMnZwRnla?=
 =?utf-8?B?cHo2R2prWjI4aTd4ZVdZTGJZdEtFYm1QczhVR1V0NUNDOE4vL1NRdDgydW1n?=
 =?utf-8?B?TkloODhmUmJxbnJYOHFBK0oybHl6cVdSL1pkUUs1MDZ5bVdJWXFuQ1NiaUZW?=
 =?utf-8?B?ejZNTkIwVnNIdVk5MnBubzVxVFlKNlB5VUo1eFd0alZRMGI0cmdGeHY1OHRY?=
 =?utf-8?B?NXhRd3JiSnZVR1RjVGRKcXBkNWNLQS90OXV2MkQ4R1RjTEVWbmhHdHQrVXhi?=
 =?utf-8?B?QUErSWdkRytnaTJIYkdhczlvdy9ZdEkvaHdDL0cwc0VTejFPdEhqMllvQ2pV?=
 =?utf-8?B?UCtlR3liZzVIaCtXdlVtYVRuUk04elp6Z21iZHBKZHY5UFk1YTRSNjlPbFJu?=
 =?utf-8?B?dy81RkNUeXQ0UTREaE9KUlQ4MEZ4WGdPZVRNMmdwaytKbTh5SkFjU3RxOG5Q?=
 =?utf-8?B?bXY4Qk1iVkJBbDA4RkNKWUVvVENIRjluK3BjaG1ybnhIZVByUHRveXhneG93?=
 =?utf-8?B?KytWdWlOb2hKaUJOVHArdWxyK0labFNhdkxoaHhHRVZvZFM4MHEzYmNaTGQx?=
 =?utf-8?B?bjZXREZPL3hkMnFLcDE1Y3RCbm9TbjFPbE5TUEl4Z3dvUk1WL2M4NFpCYVhM?=
 =?utf-8?B?S2xpVjZMbTBWNndTK3VqRkpxa0hPWmM3Mzd2bllNY0p0YTRQayt4OWNPTmhI?=
 =?utf-8?B?UDlqYjZ1S1c2UWQ0QVVia3ozbDNJOUVKc29SVWg3V1loeFpRVWVWcHB5WWFH?=
 =?utf-8?B?SkcrN0h4a3RKL2F0UXlEOThFV1Y0MURUeldxYUs2UDlPdDBkdnpiaWpOdDNr?=
 =?utf-8?B?MnNVSUl6d0xad3B6dWJUblJMQ2VQTlpIbisrQWQxck5PUkxRY3o1ODVTaWtQ?=
 =?utf-8?B?VFFqNXZEaFpVQUgrSjJDRDR3VzE2UERKOFJGSjBPV3hjUjR6WTBxcGU0M1lS?=
 =?utf-8?B?c1Z6bFhkMWhESFJ4Nk4rejMydGFtcG8rekZIUUJ2SDN5RmNONkl4b1hLU3Jk?=
 =?utf-8?B?bkFUem5pN0d2Wld0TXdyVXAyR1JBRG04RDQzSWZPd2ozdDFWYWpnR0RzMHc0?=
 =?utf-8?B?RXA3R3N6T0hNUHIxY0RRZnROZ3RhR2syQjRldmRrQlZ4U0M4YkVQV2ZGNTZZ?=
 =?utf-8?B?aDdRdG5US1ZlODFXZll2eGhNSTBKaDhSREdnQWlWam05cEdwcXpBQnQ5bjNC?=
 =?utf-8?B?T2hVTUtxUlhTcFJ6MG9odStNbVZhQ0RIMDZPc0E4eE83NXZmK2NhZUt5YitB?=
 =?utf-8?B?R2wxUGdjaDM5WGJXbXlBbFFUREIzNVlzb0crcDI1ZnNJN3J1NUJpZENFK0Jx?=
 =?utf-8?B?M2FzbGF0RTVjbytrUi9GZGxiNVJoOSs4bVEraXlCSHRSL0NjVzB1emtLVXk0?=
 =?utf-8?B?SVZRckZidDQ4eVREUktFUmw0RlVhWEFUU2hFRW1QWjJVOEtXRC92TWdSNzJ4?=
 =?utf-8?B?MU85SEZTRnhRWXFQekRsbFN5T2RQVUtxbHdHa0h3S3hESUZBTmJWVkVXaHlK?=
 =?utf-8?B?VDlkNzNBUkJRMGdoUHY5ak1TQjNhYXdxRkIxbmhXUHY3MXViTk83aWRSbG1C?=
 =?utf-8?B?aTUyVk16c2FPV1RucEhRSUwrU250MlhEWWduYlB3QkFLUFI2anJKYVMwY2hT?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7662c5e-878e-497f-9c49-08da96779453
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 17:35:55.9656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QWMaNCP2/lMnT57ZudztdAjKVeDjO9JW//t9nhmDNg15QCld5wszB4yF3uwoWDPkgKehNBa+3wEJF2vnzPhsOnc4jjtCjO53nTXp8/J1lKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB10700
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjNdIHJhdmI6IEFk
ZCBSWi9HMkwgTUlJIGludGVyZmFjZSBzdXBwb3J0DQo+IA0KPiBPbiA5LzE0LzIyIDg6MjAgUE0s
IEJpanUgRGFzIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4gPj4+IEVNQUMgSVAgZm91bmQgb24gUlov
RzJMIEdiIGV0aGVybmV0IHN1cHBvcnRzIE1JSSBpbnRlcmZhY2UuDQo+ID4+PiBUaGlzIHBhdGNo
IGFkZHMgc3VwcG9ydCBmb3Igc2VsZWN0aW5nIE1JSSBpbnRlcmZhY2UgbW9kZS4NCj4gPj4+DQo+
ID4+PiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+
DQo+ID4+PiAtLS0NCj4gPj4+IHYyLT52MzoNCj4gPj4+ICAqIERvY3VtZW50ZWQgQ1hSMzVfSEFM
RkNZQ19DTEtTVzEwMDAgYW5kIENYUjM1X1NFTF9YTUlJX01JSSBtYWNyb3MuDQo+ID4+DQo+ID4+
ICAgIEkgZGVmaW5pdGVseSBkaWRuJ3QgbWVhbiBpdCBkb25lIHRoaXMgd2F5Li4uDQo+ID4+DQo+
ID4+IFsuLi5dDQo+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiLmgNCj4gPj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4g
Pj4+IGluZGV4IGI5ODBiY2U3NjNkMy4uMDU4YWNlYWM4YzkyIDEwMDY0NA0KPiA+Pj4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPj4+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+IFsuLi5dDQo+ID4+PiBAQCAtOTY1LDYg
Kzk2NiwxMSBAQCBlbnVtIENYUjMxX0JJVCB7DQo+ID4+PiAgCUNYUjMxX1NFTF9MSU5LMQk9IDB4
MDAwMDAwMDgsDQo+ID4+PiAgfTsNCj4gPj4+DQo+ID4+PiArZW51bSBDWFIzNV9CSVQgew0KPiA+
Pj4gKwlDWFIzNV9IQUxGQ1lDX0NMS1NXMTAwMAk9IDB4MDNFODAwMDAsCS8qIDEwMDAgY3ljbGUg
b2YgY2xrX2NoaQ0KPiA+PiAqLw0KPiA+Pg0KPiA+PiAgICBObywgcGxlYXNlIGp1c3QgZGVjbGFy
ZToNCj4gPg0KPiA+DQo+ID4+DQo+ID4+IAlDWFIzNV9IQUxGQ1lDX0NMS1NXCT0gMHhmZmZmMDAw
MCwNCj4gPg0KPiA+IFExKSBXaHkgZG8geW91IHRoaW5rIHdlIHNob3VsZCB1c2UgdGhpcyB2YWx1
ZSBmb3Igc2V0dGluZyBNSUk/DQo+IA0KPiAgICBXaGVyZSBhcmUgeW91IHNlZWluZyBtZSBhc2tp
bmcgZm9yIHRoYXQ/IFRoaXMgaXMganVzdCB0aGUgZmllbGQNCj4gZGVjbGFyYXRpb24sIGNvcnJl
Y3QgYWdhaW5zdCB0aGUgbWFudWFsLi4uIHdlIGNhbiBzYWZlbHkgb21pdCBpdCBhcw0KPiB3ZWxs
Li4uDQoNCk9LIHdpbGwga2VlcCBpdCBhcyBmaWVsZCBkZWNsYXJhdGlvbiBhbmQgdXNlIGFjdHVh
bCB2YWx1ZSBkdXJpbmcgc2V0dGluZy4NCg0KPiANCj4gWy4uLl0NCj4gPj4+ICsJQ1hSMzVfU0VM
X1hNSUlfTUlJCT0gMHgwMDAwMDAwMiwJLyogTUlJIGludGVyZmFjZSBpcyB1c2VkDQo+ID4+ICov
DQo+ID4+DQo+ID4+ICAgIEFsbCB0aGUgb3RoZXIgcmVnaXN0ZXIgKmVudW0qcyBhcmUgZGVjbGFy
ZWQgZnJvbSBMU0IgdG8gTVNCLiBUaGUNCj4gPj4gY29tbWVudCBpcyBwcmV0dHkgc2VsZi1vYnZp
b3VzIGhlcmUsIHBsZWFzZSByZW1vdmUgaXQuIEFuZCBkZWNsYXJlDQo+ID4+IHRoZSB3aG9sZSBm
aWVsZCB0b286DQo+ID4+DQo+ID4+IAlDWFIzNV9TRUxfWE1JSQkJPSAweDAwMDAwMDAzLA0KPiA+
DQo+ID4gVmFsdWVzIDEgYW5kIDMgYXJlIHJlc2VydmVkIHNvIHdlIGNhbm5vdCB1c2UgMy4NCj4g
DQo+ICAgIEFnYWluLCB0aGlzIGlzIHRoZSBmaWxlZCBkZWNsYXJhdGlvbiwgY29ycmVjdCBhZ2Fp
bnN0IHRoZSBtYW51YWwuLi4NCg0KT0suIFdpbGwgYWRkIGl0Lg0KDQo+IA0KPiA+IEkgdGhpbmsg
dGhlIGN1cnJlbnQgcGF0Y2ggaG9sZHMgZ29vZCBhcyBwZXIgdGhlIGhhcmR3YXJlIG1hbnVhbCBm
b3INCj4gPiBzZWxlY3RpbmcgTUlJIGludGVyZmFjZS4NCj4gDQo+ICAgIEl0IGlzIGluY29tcGxl
dGUsIGNvbXBhcmVkIGFnYWluc3QgdGhlIG1hbnVhbC4gQW5kIGRlY2xhcmluZw0KPiBDWFIzNV9I
QUxGQ1lDX0NMS1NXMTAwMCBqdXN0IGxvb2tzIGNvbXBsZXRlbHkgcmlkaWN1bG91cy4gOi0pDQoN
Ck9rLiBBbGwgZ29vZCBub3cuIFdpbGwgc2VuZCA0Lg0KDQpDaGVlcnMsDQpCaWp1DQo=
