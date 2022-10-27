Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C06060F14A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 09:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiJ0HmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 03:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiJ0Hl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 03:41:58 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2111.outbound.protection.outlook.com [40.107.114.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18C715200B;
        Thu, 27 Oct 2022 00:41:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNZQVt5tcrSi44m+ochYiUQPD4ovKxNOIS75sK/tOmVKDPmkl5O7tHBHwN7H1+QN2C033nHdmbq9roTN/5wkNl9qrKoW3LaRQt9z1ObMjyVUTN5KEojponwDw0aZwr/+7uPoIYpmmIYUZSvCQiHO6abr7NvpS5gEpbWe9MdCfhA1IM/qlyfwQr/QHFKxo1C66ncNFYUV1VBtmz1qjmwHvy0u0OGNYn5v4AtUCQf/KWdUeAQXe0dO+K8deYjm8AWMLOyd0Vy6j6L+3vhlrLcAX46jTXPYed2V0oJuYZ/zP8ADrd6hVH8kWVn8f5jE3Uf1nnW23MILp0kb5GUkTf7mhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AT5AVK0WURTaluXdAxyReok7vtRh5BBZCSDhZzqvY/A=;
 b=JkGo08cVjdBhLG6vHOCuy9ZZbOILSPE5kUNZjSLWTDEgErXsQYcR9ceb7rsM998UWq5VL+sPnEtZdYTQOI1Q2jvINSIvRxh/YWTG6wnhwPNqyx3CjPaBGsAyqktQsyvEakWzuf4gXGWI9J1Ev1CZ08U0P5OvkGgldNJ78+FdKGs8vqBENCDwYmV1HvAK5I9q+rt93VqYHa+0uG3r/QB4kkLXEhul+sdsjJ8wA2v54k9+gsYun/GFdggLNEdKGbwVTdfwW9NdjY0lX3PkWYzxWG2o+5Z/Jc1fOnJmQKkswwXQ2FqFg2Z3d88yxNoJveUQjkWxemoIOjTVLl91IoXe+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AT5AVK0WURTaluXdAxyReok7vtRh5BBZCSDhZzqvY/A=;
 b=b1EFHIBprxBJMkSxGRplssnOkRLBQDcfCvnclj3TEcsXxq0Wj1q1Rn5pLS+2fkQnpUfoURl0kd2py9AdSZVuX/vvq3SYKvl4YzPDPDgAE5MUDcLFWde5P2J07R4Q+MFuru7l5sam53ra1WK2EVPVEcXlBxyXiYaJseLTRtAOA20=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYAPR01MB5593.jpnprd01.prod.outlook.com (2603:1096:404:8056::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.25; Thu, 27 Oct
 2022 07:41:54 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 07:41:54 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 2/6] can: rcar_canfd: Add max_channels to struct
 rcar_canfd_hw_info
Thread-Topic: [PATCH v2 2/6] can: rcar_canfd: Add max_channels to struct
 rcar_canfd_hw_info
Thread-Index: AQHY6T1aT5lTcZP0R0CihFexOuNcvK4h1JuAgAAHvKA=
Date:   Thu, 27 Oct 2022 07:41:54 +0000
Message-ID: <OS0PR01MB5922B5238425B1C43C6CA6D886339@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221026131732.1843105-1-biju.das.jz@bp.renesas.com>
 <20221026131732.1843105-3-biju.das.jz@bp.renesas.com>
 <20221027071259.ixueuw5xkptv22x5@pengutronix.de>
In-Reply-To: <20221027071259.ixueuw5xkptv22x5@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYAPR01MB5593:EE_
x-ms-office365-filtering-correlation-id: fc3b57bd-2497-494e-d35a-08dab7eeb80d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3AoiW/0+J3zMVTUlGqXtVuxPpj6agv1yFsq5Swsx/u3zmDIb2/Njd4Z/Nsw3EzPb3I8cg1+B5Wayc34e9Z2v9KvbWBlq+snqxo/ehcdp5aV2JIZ8ECJHQ1GLHQYRqelnuzMq4nIqnQkq6OA/dV+OzMzEla7d6Yhsh8DsUE5oZn7u3mJFhb2+WD/rLP44aS/rM19ctiaGP0brfzTonREMhf7TmmkUr9ftPOIGFiqtQqsZPq4UGoA6nHBwpDT8D16KyawM97wFEcwby4pOWjYYRoYbmZ6EJ1P6UTigXq0tfKXrsyWGHA651A+bDYpFwKtAWrvv+K1otbK13d8fGS79VUBxIS8Sf7yV/bDSo6LYbRmqhWz6LwB5bisVkwtUq5FsZv/8hQmrWATDgIZrIol2gGwMYWF8LDDVNjzzt97GXwHtgAElja2waEJwUwaU56rvneP4Im0YHSPb+iKDKACdHcKvEeJUYdgmBjXcYoCW59XqblWH239Otf+EKzwIrITqp0MuIaQmFyIytJ6p2p6YSnhB5szA39w1nVxOVvAUNZrlFaWb2F4Y5OKNrqMab5HIsDG/b1YWOazISIhM2OkJfQ2Krb60MB323boBuUsVc5IxyB85ic1goQX4z4Zh8ibOArNOuKhGncFbUxxrzsWDgzVo727f4SkQKT7VjcAElySDMYsRCSmyWtUUp4Eiv4EiyagSkYTjHHCf3SL3QpahWttCTOIxf1ASwYSFyx7/euvdFwoaZMLtoFn/XYerwp8ZiJxxS8GVF6gX3+0lY16/CQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199015)(7416002)(38070700005)(186003)(478600001)(71200400001)(316002)(6916009)(54906003)(83380400001)(76116006)(33656002)(66476007)(64756008)(8676002)(4326008)(66946007)(66446008)(66556008)(53546011)(7696005)(6506007)(52536014)(122000001)(8936002)(9686003)(86362001)(2906002)(5660300002)(41300700001)(26005)(55016003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUtENlBDdDZUb09MSmxJSE5iaG5aMDlNN3pFS1UxZ04zLzZpcE1ER0dqcGhw?=
 =?utf-8?B?U3BlbE8vSEg1N0FFTGk0aHlLNWN4VjBCclRNK2VTeVY4SktNSXZaU0VSYWlj?=
 =?utf-8?B?aFBNL2taOHlVVm5ZY0haWGxZeDFRRCtWSnZxanZOd2NsdUFFbExFeEVNMGZB?=
 =?utf-8?B?aU5jU3dJRmkrR2NuYmM0YzhCVzNOenlyQ25iSFdrWkQ2WGROWmw2OUJaMmtB?=
 =?utf-8?B?QUZqdUZhdStXUHJBM25OWCs4dmNkVkZSNmN6eHdMZXVjbDFoQnAvQ3dYaUVQ?=
 =?utf-8?B?ZXBpdHdTWU12UXBlVURrVXExSUFaVDd5STNUV2JLUnRjYXZVM2tmSHdid0tv?=
 =?utf-8?B?RDVsb21udlQrbkpObElRQ2Rvb2JhemhCcnZZVUJSN1ZPV2pkQW11SFBiMXVK?=
 =?utf-8?B?Wk40TzNJS2tJMFNndTYvSENGcHFUZ0xwQk0vbUc3V08vekcza1FQZmlTNncv?=
 =?utf-8?B?dWpXNjFTVkd2cDU4amVvNGgwaVZ0SWY4WDRkYWxIUnRRWGlnYUUzV1JDSi80?=
 =?utf-8?B?dmpQeUNpT2FHKytSdjBOOTZOVUNJeStkQW5yMjY5cTlFNXh4V2R1TVZUTGlD?=
 =?utf-8?B?UG1MazhyRFpWRUFjRlF2eUJEbU5SeG9EdWFaTUVtV3RHUkw1bnphczQrbW5G?=
 =?utf-8?B?dmZ6SUhpdmVhbWJPMVE0amN4Zm9McndBNTZTRTBxRXNSN2dUY0l6eEtGWDBx?=
 =?utf-8?B?eE5xbXdGdnJHa3QrbDArNmlWd08rbUg1aWJ6b3k0TU1LVGJlMUFJbDI3Slhp?=
 =?utf-8?B?QjE3Vmc4anhFVnQ5c3l4VUlFclFXMTJkcHhGL29zdFFqK3dVOXpEazZpVkVu?=
 =?utf-8?B?REZ3aEkwdXVYTjVmVnBLUmxRS1kxNlpFUG9PL0piR2NQMytldHB2aU1FaUFv?=
 =?utf-8?B?Si8vU1VhWnVYTTBrUFZGM2Z0b3RMeUJjTWJhNm9BOWg4UFZuQnJTbXAzRFda?=
 =?utf-8?B?ck1UWEVHcGY0K1ZFZ3R3eWsyTW8wZTFzUmU0cEtjcEI3ejVuTnlXdklQakhj?=
 =?utf-8?B?QWdvdkpaOHFKZG4zS0thVXlNU2t1aExWRTloR1NqVGFKeW0wYS9CRllPaitO?=
 =?utf-8?B?cUFvRmlSVjM4c09yVG1LMjJKV2N6YTdzT0VWM0V3VGkrRS8xV1hmOXRhb1Ru?=
 =?utf-8?B?aDR0b0RPazU1Q2wwdk1ndC9iemNkckhrK1A4V0pKQW45NnA1NEdrbWFQYTRW?=
 =?utf-8?B?MUNZSGptK0xBRzFScytsUjZwNFp2TGFMK09vUkxwdHo2aU40UnpqV0l2YkdF?=
 =?utf-8?B?emMya1hGbmpiUmZQNTFYZU9XM0ZRNmZqTXo2RkVRMFZwUXBtOXpJWEdHdWxi?=
 =?utf-8?B?YzN1VzdHTGFnTURNc1NSWWRYcUhxbXc5djVDUE52M28zcVFSbnp1SHRQL05W?=
 =?utf-8?B?d3dScGNRNFAwbXBqMy9rNzJvVkdsZlJ4d1JIeWhBNm8yeUdrUVdSb0NNWjBL?=
 =?utf-8?B?RFlJTWdBN3lyNEJ2b3VRWVluSS9GTmpXb3pieUpEb3FWUVhnQVhHd0lpRFhl?=
 =?utf-8?B?UWtzWjZtZWlzSGl0bWNDaDk2SmltU1NXRUloNFozdG5ZTytUbzlFVXlvS3VI?=
 =?utf-8?B?RjN0dkV5NXVHMDVMcEpidGFRWUI3eEJidEdENCtuMDBOLzlOSklyNXhTZDlr?=
 =?utf-8?B?cURYNmt1VzlpeGhYVU5QYmt6RFZaRjAyZHFKVGlaSkFZdnNZZWV5REJrV0k4?=
 =?utf-8?B?MzgyaXhRekFSeUhwQ1VXTEg3UkNxbE15OTRudTZLZlhJNUwvNHdjVFM0VXkw?=
 =?utf-8?B?U3o0TmdRR09tbmtyTmVxaFZIcmZqTTk3aTdncjVxWk5MTElNUkE4WEFWTm13?=
 =?utf-8?B?RVc4b29LUWw2Z25LQ25VWmFFbERjOElwR2hhck1FSmJhUlhGVE9EYWxYOHBC?=
 =?utf-8?B?WDBwZUlFV1cyclAyMjNuY3VJVDIxZjBHS1JSek0xalpXbnJmQi9rUVFCSnVT?=
 =?utf-8?B?RUJ0N1BuRWs2TEF5SHVCRk8yUFBwbVkxY280enE3aEJtVVduZVBJTk5kdTQr?=
 =?utf-8?B?cnZVT2oxR09QZGd3SWJlSWRpK2Y0L1pTNTJva1VadnIvcGxmWjV3OVorbVFC?=
 =?utf-8?B?eDFUM1BRK1ZsUVY2bzliZmJzK0oyZ1ZXYmdNeFZDOFBuMytpNEtmMTNHZE1k?=
 =?utf-8?B?SUh1dzJDWnN5NVNvSmZJTGdqd3YvZjhsRzFoaU13QUVFcVZaZHVwajVvT3ZQ?=
 =?utf-8?B?M2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3b57bd-2497-494e-d35a-08dab7eeb80d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 07:41:54.3891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CI/l7qy7bzTgPzKFaAeYlM9ijVUucsmAoWKC9PQzDQVOIDhxz5gETbykZg/IMvUzNrp/WkPpHOrxFoiwMd4YXYqTlGJYYee2+bD9tK/PtIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5593
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2MiAyLzZdIGNhbjogcmNhcl9jYW5mZDogQWRkIG1heF9jaGFubmVscyB0bw0KPiBzdHJ1
Y3QgcmNhcl9jYW5mZF9od19pbmZvDQo+IA0KPiBPbiAyNi4xMC4yMDIyIDE0OjE3OjI4LCBCaWp1
IERhcyB3cm90ZToNCj4gPiBSLUNhciBWM1Ugc3VwcG9ydHMgYSBtYXhpbXVtIG9mIDggY2hhbm5l
bHMgd2hlcmVhcyByZXN0IG9mIHRoZSBTb0NzDQo+ID4gc3VwcG9ydCAyIGNoYW5uZWxzLg0KPiA+
DQo+ID4gQWRkIG1heF9jaGFubmVscyB2YXJpYWJsZSB0byBzdHJ1Y3QgcmNhcl9jYW5mZF9od19p
bmZvIHRvIGhhbmRsZQ0KPiB0aGlzDQo+ID4gZGlmZmVyZW5jZS4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdl
ZC1ieTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT4NCj4gPiAt
LS0NCj4gPiB2MS0+djI6DQo+ID4gICogUmVwbGFjZWQgZGF0YSB0eXBlIG9mIG1heF9jaGFubmVs
cyBmcm9tIHUzMi0+dW5zaWduZWQgaW50Lg0KPiA+ICAqIEFkZGVkIFJiIHRhZyBmcm9tIEdlZXJ0
Lg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9jYW4vcmNhci9yY2FyX2NhbmZkLmMgfCAzMCAr
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tDQo+IC0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAx
NSBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9jYW4vcmNhci9yY2FyX2NhbmZkLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2Nhbi9y
Y2FyL3JjYXJfY2FuZmQuYw0KPiA+IGluZGV4IDU2NjBiZjBjZDc1NS4uMDBlMDZjZDI2NDg3IDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJfY2FuZmQuYw0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJfY2FuZmQuYw0KPiA+IEBAIC01MjUsNiArNTI1
LDcgQEAgc3RydWN0IHJjYXJfY2FuZmRfZ2xvYmFsOw0KPiA+DQo+ID4gIHN0cnVjdCByY2FyX2Nh
bmZkX2h3X2luZm8gew0KPiA+ICAJZW51bSByY2FuZmRfY2hpcF9pZCBjaGlwX2lkOw0KPiA+ICsJ
dW5zaWduZWQgaW50IG1heF9jaGFubmVsczsNCj4gDQo+IFlvdSBjYW4gc2F2ZSBzb21lIGJ5dGVz
IG9mIHlvdSBtYWtlIHRoaXMgYW4gdTggYW5kIHRoZSBwb3N0ZGl2IGluIHRoZQ0KPiBuZXh0IHBh
dGNoLCB0b28uDQoNCk9rLCB3aWxsIGNoYW5nZSBpdCB0byB1OC4NCg0KQ2hlZXJzLA0KQmlqdQ0K
