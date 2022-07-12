Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3B6571AC3
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbiGLNEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiGLND4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:03:56 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2129.outbound.protection.outlook.com [40.107.114.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA09833A32;
        Tue, 12 Jul 2022 06:03:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOG46FY42Y+rNw6WKOfPyZ+NysIOx4rU+Zcnoci5gQ/3vTY0kOr2Yt8VwgJQnLvxB7+MD1I9L/cfkFKHukFyjLvwVl5hZpPKspzTOKUFHyl3x5FE+G/FpmJPmwrUR7p8GFxWy5mseDd0698QjFwl8HrQC6nMnxq7AF1g7xRjWTQ79q5T3oYOyqV6CJa4jjIhSYnzXU9kf9IcwmI65uhSnV4ZtUHrl/1rpDG4D5JT1qrKaeEFXj00ZgaVIL/pPLpQMRmGPFc9N46wrGXbaJTiF0kd/2B40nXadjfAtX5DlEhCDZCxdsPAs4RQs4fhjtjYz7UJ86LWo6Yjzii79yRPSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jv2D4knCKYIv+LYx1zt47yRodQPgIUPQKY1Q8/uDsys=;
 b=AVsbKJqSto290vBu7PjDrIWeBhg4jNZETTkGDI8Tp7GaZha1F0EMq451111gxQFzc+uBg9artjR0xbeuVhnSanxMxnYlQ9PbiDGkv8xp0++D1wqKHLPktZxEXDNbSffMZCj7Ei5Dia5pRDod6+Vhv/YQOgdJfMXlJvNbB04Xa/OXj5B03NXbyOkx+3HZ03Ax1eyqPnGlDpYrLu8Ie07i/I8+7QMW3UYdjvRiaiEysY0LmllJ8IOL+QiMfhedzTt2Gl6XcNlOPOCkpWHd2gPKgBuTfYRMCv++uhf8+NU0CKJ8eDzo3kQGpoHRWcsyez9xJgk2/fhC0X5TpTV0M0FkBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jv2D4knCKYIv+LYx1zt47yRodQPgIUPQKY1Q8/uDsys=;
 b=KyhzWQxEM3Q1B9wDqoH8mmm8LlvMBgiG4nP1Y28GDWy7TxLQVQGxqpzuYIrlb9U0F5qxd20QG9i2DkGJTgCLSPGj3AXVUG3tNHu1nHjMGMlaWqTCVFl4k3+pRLfDr5grbS2latuLyLwFMOVnuarCEAZHwe/WkLe2nkg6ZspKVE0=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYAPR01MB5120.jpnprd01.prod.outlook.com (2603:1096:404:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.17; Tue, 12 Jul
 2022 13:03:50 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%8]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 13:03:49 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v4 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Thread-Topic: [PATCH v4 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Thread-Index: AQHYlFOvG7fj/afWrUacI2C3d23LRK16tOyAgAABMVA=
Date:   Tue, 12 Jul 2022 13:03:49 +0000
Message-ID: <OS0PR01MB5922495C78A7B77874940D2386869@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220710115248.190280-1-biju.das.jz@bp.renesas.com>
 <20220710115248.190280-7-biju.das.jz@bp.renesas.com>
 <20220712125623.cjjqvyqdv3jyzinh@pengutronix.de>
In-Reply-To: <20220712125623.cjjqvyqdv3jyzinh@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87768539-79d1-450d-3d5b-08da6406f6cf
x-ms-traffictypediagnostic: TYAPR01MB5120:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LEEjyYNTyOZ+ffqivekP+78jtYtKdlfizgYzOylQjHz1AX7IW83BQFg/JubU51XqUuaW9CqgMAbl3YDDymuBxiigK15j78lRAz8DEoz5XoKcJpGs1NdZtlCA5q+tPNZm9+cBBFAaeu4A1Rr8X+7fKbB8SXnIHcmUuOvEKv+Njpm/ZhimQCBpcGmpLm+Anzgx4m99lYHCH5W+wa6nreQ7YaABqYo5fj7WmuM+ufNbTq7EpdDKIZYz/Qpoyq8HmG8S4WyxWEw0vBfTYK/PdowNEWruAAViCkBg0KUPzz1JSylVBhZVnIdD4Eyrp021hsikFHZzw1zn6xJ9GXQwKZ9Tt+Pb7XAAAQtDWFmVBwYPqvs6v75GCE79zP+T5dIrQgkQUxHX0a/QPMhov+u73dCK58xJnIrSgVg6vJLzuJcg8Ce0vJ+RmGG/8WL83MzjAawVB3gh9R2aJp0O8voqbDEtpYmM+Ry2GYsisYjqBn14kjSX+1pHPFQXBuqNBl1bYt64vmGU/lErwgAyjnimFz8z1x7LT+UgE6wxsHLkuN+zLsDKpksifnDz3prZHasnpOaD32m7TDTDOffTSpXc0wZ5ZScvDaB2ilV8l0VR7toBfiBmdShMNb28BpD3pdHhvpn+vGK5/ZAFtiGXalvufEGaM1LyqMgX/z/coRMY0J5aZZq3ttbc/DJVBIRHgjtYfLql0hZAAdk2zXGbAiZbhxlU++ZAEpMv8s5D6mpOxJuj8GjBnF9iHDaDXROHtQNOwwqfbmWKLOstNei8NPIDLe45x7U+EdjsDbOEKBXDfB28K2Ff8v9/BiMnFFLBgDAHfJlA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(38100700002)(122000001)(4326008)(52536014)(64756008)(8676002)(66476007)(66556008)(8936002)(66446008)(76116006)(5660300002)(7416002)(66946007)(83380400001)(38070700005)(316002)(53546011)(26005)(86362001)(6506007)(7696005)(33656002)(478600001)(71200400001)(186003)(55016003)(2906002)(54906003)(41300700001)(9686003)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEhxSTI2ZitLblZvQk51ZHo4Z3QvQnZ3VGV3Szc4QTlaYVZ5NldJNDVqNVdz?=
 =?utf-8?B?RFNCajZwZVJWUStURytkVmRhT2JKZlFHVVBIcU1vQytIYXRWVncrbzdLeUo5?=
 =?utf-8?B?MUpUcmkvS3VIQVF5RU1nNWdsdHJFcVdyUTkxbzZKMnhsNEN3UDAzamg2WElz?=
 =?utf-8?B?OXZwaUdyUXVuU2hXMlRjRkdVRVQ1SDFEYmJzOGhkN2Qyd1hkazA2OUkwSEtG?=
 =?utf-8?B?OVp2cGhKRWhuRFFPc0hJZmdRdFZ3eklmTFhSU3BUa2pjaU14QW5xM2t4Z29D?=
 =?utf-8?B?dXdZeUowR1lReWhNam0zd3hvUXVNK1lYbDRteHV0bnF1ak80a1NnWnJoRGRt?=
 =?utf-8?B?U2pHUUVvNjVNc3AwZjdvdEZ0bHBrUUVwSnVicjBacEtubWZYWi85L2ErYklM?=
 =?utf-8?B?N3NUdmVlN3FmOUxJWW45ZlJJaGxMNC9hOFoyZk45bFZCRkNXa24yS0Z4RzRV?=
 =?utf-8?B?MEtKd1c2WkMyZExQbWRxaE1uOFhUNUZxS1FFcUVFUGFCb2gvdFM2aUFTTjlR?=
 =?utf-8?B?b2R4MDlIZDV6Qk5RU2VvV0NaVUVhc1B1dG5vTEZXSm9nQithcmVFRWlPTXlY?=
 =?utf-8?B?TlRLd25LSVJBb1gxTmNYUGtHamRLL2F3dlVnRjkraURHUDJ2WDRXTDl5MEFN?=
 =?utf-8?B?NHF6aGF2cTRFa0NjYTNPbWdnRWczZWh6QmRUQjdvdjc0OGdMYmNrZ0EwaXgx?=
 =?utf-8?B?SG82WnlFWnYyazNqdkpJT2N2MGdYVjUxRjZpZGRYamFEaUpxZklIOHMrb3M0?=
 =?utf-8?B?eXpXY0xJb3lqYzBmQ3BCOTYyQ3pYVWVLYVhvYUVraFNKRU5oMFhWZnVUemR5?=
 =?utf-8?B?d0drNHdPWEV0OWhvVlBTTmZKR3hlUVhNSkdCb3IzRXZVWUlUWVZkaFBhRDI1?=
 =?utf-8?B?V3Rmd3ZlVkVSS2dKQllBenJRbUk1dGJzZkZIRk83WkR3U3N2NnZmVEZnVnQ4?=
 =?utf-8?B?UUU0U3NUM2dReVBjOWFJZmdTU3VMTkIwdVVwTzFHdFZVYmp5NUtUUkNrc0c2?=
 =?utf-8?B?YVJVcExSOXVwNTMra1J6Nml2enZaTTAvMEJxN3RzL3cwSXVHTVVkZTNKbC9C?=
 =?utf-8?B?SHp4UjhBaGJGUVUxVGhqWlJmVzBmRFB0ak56S3VnbXJhbkpVS3dGZzdYUXlI?=
 =?utf-8?B?T0EyMkordkJ4RlNWNnBoUW04WHJpZ0JmbGdFbXk3UlMrMFR0UWtOQlVFRWRT?=
 =?utf-8?B?dmRYcXROK3orRk1UWlpQd1RwREpOQ0FVNXRJbEk1N0J4MWZ6eUtpb1NDbytC?=
 =?utf-8?B?SVhSQWxkTHJuczBRQUQ4QlI4SCtwMTRQeEZLYmg2cDkraDNLeHBtWjJpMys4?=
 =?utf-8?B?clg1ajZLVENYMk9YSGcrMkh1OGRLd1Y3dnVuektkckVONEM2a3JIUlJiaGpl?=
 =?utf-8?B?eis0ei9UTlYwbHFPYWFHaWpRWVBBcDhBMDdZaUdtTERHUzRVSng4VGc1NDU0?=
 =?utf-8?B?aDRnZUJTaUJ6QWc1MTBEQTZFRFhnMW5DN0MybXBSYStFZHRLNUM5b0QzVEhu?=
 =?utf-8?B?MVhqRVMva3pqUUxRUWwrenBLd004MmxkVEN0MmRXYXZMbVF5VDZLZEw4c3Jl?=
 =?utf-8?B?anJuOHdhVWlDTFowRE8zY3dLb3EybjNER2NWeEtLbFpCcE04Ry9uTnRYVzg4?=
 =?utf-8?B?MUZQMGJJRWVmdjZEU0I2QXBwQnFSdFl5SVdiQ1Y3b28rZCtuU0Vwc3hhMWRl?=
 =?utf-8?B?L2FjbVhGWjg4Rm0xTzZWVXpTdk93VmIvUlRrTkpKOEVMa0wvb2RBakZBL0pr?=
 =?utf-8?B?a0F1S053Wks3WU9VYTFRMTBJa0c5cHdGUXB2Z0xoeGozaWM1bFJlam13Z0Qw?=
 =?utf-8?B?VDNHalRaZng0WnkzNFE4QVZLT2NPcTNsakd0RnYvNUZLWVdSYTdoZGg2ZDVy?=
 =?utf-8?B?ZCtNblJBd24zYVNKWkFBVzcrU3JZTktwVWZOTUJyNXhKOVlrTXNGbkcvcWg0?=
 =?utf-8?B?U3FTbVd5ZXhteGRQNW5DYjZTZElsanNzQlNWb2c4dE80bXhRMG80TThlUjVh?=
 =?utf-8?B?eEN6eFI5YzhhT3M1MS9VMmtWcDBxN3NLMjNNeEtuWmoyZXhocm1zMjhaYWRv?=
 =?utf-8?B?OFkzWGJMSUtEcmdiaDBNOWNjNTFiaGNZblBMc09EK1htZUttYWVkdGdIZk03?=
 =?utf-8?B?aE90TlNzY24xRG1rUkdOYzhPZXVCTmhHbVBMb0hJbnBWM291bTVtV0JjTzMx?=
 =?utf-8?B?dEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87768539-79d1-450d-3d5b-08da6406f6cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 13:03:49.9236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: twL7tEvGDVVUpzjrQh5Cc1hCQNcHu2IsTnSBjsnI1Vy3M8fXv3Ht8lLg+vnTwvc33qvgLkduWWvTPXA/KacTrRi+x3bFxozDx3RLuv07Ubs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5120
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
QVRDSCB2NCA2LzZdIGNhbjogc2phMTAwMDogQWRkIHN1cHBvcnQgZm9yIFJaL04xIFNKQTEwMDAN
Cj4gQ0FOIENvbnRyb2xsZXINCj4gDQo+IE9uIDEwLjA3LjIwMjIgMTI6NTI6NDgsIEJpanUgRGFz
IHdyb3RlOg0KPiA+IFRoZSBTSkExMDAwIENBTiBjb250cm9sbGVyIG9uIFJaL04xIFNvQyBoYXMg
bm8gY2xvY2sgZGl2aWRlciByZWdpc3Rlcg0KPiA+IChDRFIpIHN1cHBvcnQgY29tcGFyZWQgdG8g
b3RoZXJzLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBhZGRzIHN1cHBvcnQgZm9yIFJaL04xIFNKQTEw
MDAgQ0FOIENvbnRyb2xsZXIsIGJ5IGFkZGluZw0KPiA+IFNvQyBzcGVjaWZpYyBjb21wYXRpYmxl
IHRvIGhhbmRsZSB0aGlzIGRpZmZlcmVuY2UgYXMgd2VsbCBhcyB1c2luZyBjbGsNCj4gPiBmcmFt
ZXdvcmsgdG8gcmV0cmlldmUgdGhlIENBTiBjbG9jayBmcmVxdWVuY3kuDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gLS0t
DQo+ID4gdjMtPnY0Og0KPiA+ICAqIFVwZGF0ZWQgY29tbWl0IGRlc2NyaXB0aW9uLg0KPiA+ICAq
IFVwZGF0ZWQgY2xvY2sgaGFuZGxpbmcgYXMgcGVyIGJpbmRpbmdzLg0KPiA+IHYyLT52MzoNCj4g
PiAgKiBObyBjaGFuZ2UuDQo+ID4gdjEtPnYyOg0KPiA+ICAqIFVwZGF0ZWQgY29tbWl0IGRlc2Ny
aXB0aW9uIGFzIFNKQTEwMDBfTk9fSFdfTE9PUEJBQ0tfUVVJUksgaXMNCj4gPiByZW1vdmVkDQo+
ID4gICogQWRkZWQgZXJyb3IgaGFuZGxpbmcgb24gY2xrIGVycm9yIHBhdGgNCj4gPiAgKiBTdGFy
dGVkIHVzaW5nICJkZXZtX2Nsa19nZXRfb3B0aW9uYWxfZW5hYmxlZCIgZm9yIGNsayBnZXQscHJl
cGFyZQ0KPiBhbmQgZW5hYmxlLg0KPiANCj4gRHVlIHRvIHRoZSB1c2Ugb2YgdGhlIGRldm1fY2xr
X2dldF9vcHRpb25hbF9lbmFibGVkKCksIHRoaXMgcGF0Y2ggaGFzIHRvDQo+IHdhaXQgdW50aWwg
ZGV2bV9jbGtfZ2V0X29wdGlvbmFsX2VuYWJsZWQoKSBoaXRzIG5ldC1uZXh0L21hc3Rlciwgd2hp
Y2gNCj4gd2lsbCBiZSBwcm9iYWJseSBmb3IgdGhlIHY1LjIxIG1lcmdlIHdpbmRvdy4NCg0KT0ss
IHdpbGwgd2FpdCBmb3IgNS4yMSBtZXJnZSB3aW5kb3csIGFzIHRoaXMgZHJpdmVyIGlzIHRoZSBm
aXJzdCB1c2VyIGZvciB0aGlzDQpBUEkuDQoNCkNoZWVycywNCkJpanUNCg==
