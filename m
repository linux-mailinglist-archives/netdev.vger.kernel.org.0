Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0EB564202
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 20:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiGBSJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 14:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiGBSJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 14:09:08 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2139.outbound.protection.outlook.com [40.107.114.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575016545;
        Sat,  2 Jul 2022 11:09:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DK6jFfPYlzoW8zgJ7i43ReE88h2NaSeMZldlvEL+qP/AAo72dtc6MB0x/PzGP0WmQH2i9Hd4LrRSPO4/5FLbczKidnWf/eeYNxlvetFP2v3FmsNa/eus1a4b8TvEfocnlk0d5WrgXHMnmDRe4Uz53jUOUGOAr1erZPF9cXqE1MBYtW7qKKdJgWopqjCrwPJ61J2cogIpBZs267uDu9CDvpbxEZ5jnMaoMAbQoLpWBaIcjawmIHjeIZOi8rylQX9Ge1dfFpOMluQOrL7+eMH6jgRSJBsROJoqaPZ20evIm3X0fOixZ2MxTypYZYOR5+1qYcfJRUpEfxYaAfukQsSAGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vL8GDSKwbuTceUakph27y2e0Muit+2osao4Pu+RKLMs=;
 b=A3y6GDcxv0cpc2qkiUrPm5fbXUTHWMzCD7lvuGcHFSgNVEvZhh3KQLZ4jooKz347PDYcCmmj9LsMKseCyORcsXWNEpMETirfdOuVZTtb0k2eIuV2rylq4typf6rJi0xYGWn//xnYIoU3koOD3NGYhZr6+8H82LQk4OlJDWeJ/3dahOAs+eAEyj1uMCr6175kSt8Ieuc95WKS4emvwJ6LJmY8NE8MwFBRrYQKLfYiKNgJ//NLhahiJP+ZsUbGpJIX1vNSTvSkMmKBuMfIdwqp0/CLbU2Pw0iu2z+Zj9p2K8P4CUvVsHPwM5NRiYlEliLngYbfBqWS1Ggv/U/6uS+KKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vL8GDSKwbuTceUakph27y2e0Muit+2osao4Pu+RKLMs=;
 b=LYa3t4N9W4fRf/nTQRWw8P691MXzcsGBWh3BJJWRN8RU4bqR53JI2d0c8EBisx5s48lezK/PAkVM4UXtMR1HHv4nb5DrwYjU1aOocSuTIr0U7BiFM3taKO+Iu6HnZaJx6fYMFBlc5Kww6etmJ4e8CgAad5pblfK6RFoceRt4Ez0=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB3364.jpnprd01.prod.outlook.com (2603:1096:604:53::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Sat, 2 Jul
 2022 18:09:04 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.018; Sat, 2 Jul 2022
 18:09:04 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 3/6] can: sja1000: Add Quirks for RZ/N1 SJA1000 CAN
 controller
Thread-Topic: [PATCH 3/6] can: sja1000: Add Quirks for RZ/N1 SJA1000 CAN
 controller
Thread-Index: AQHYjhxJkDEGx2ebfk6KgFA2HnT7JK1rQdGAgAAfa3A=
Date:   Sat, 2 Jul 2022 18:09:04 +0000
Message-ID: <OS0PR01MB59228884628DFDBD46AC3C6A86BC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-4-biju.das.jz@bp.renesas.com>
 <20220702161601.5bodwpgn4taoeprq@pengutronix.de>
In-Reply-To: <20220702161601.5bodwpgn4taoeprq@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b6aa5cd-58c1-4220-81ef-08da5c55f2cd
x-ms-traffictypediagnostic: OSAPR01MB3364:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3lpDQ2bFSD6cRDFUHB2rKfCSFn+f8pS594IuBP/ffiRH02vHjKMYD/IDA04s0BFGXzEsIG0GjTPoXg0Cb7AfqS2TgRDBjSr6+QwqlU1lGu0o4CRKpup0HEVJ03KpL1Jc3QHGFn8F1OJTOCrgohYYXbUs6KRPMQdq6uQfHv6iwjHm78D05ZxjA4zbw8/GO4stJyCI8riOWXmY6Aj45SrXmLjw25dnWBtzZdmgeQ3xyMruK/g7FEXr+Zaw9ttYEVLrWD2jvtwFFIg73G+HJ7P4Bsz7jXfZCT4PvA9rwpOJfdVOe/rekEUnOuMPNItOTCaHpswhTwBKc1I5ZMXGkvczknSM0+wTVO3LUpcNV3hsuo4tcZpEWXJss45tPHcreVlmTP8tiA1bCTvS9UQnfgSwMETlSInVsNejbnWKNOKsf4gLb3mSEZ1pwHeErvccm+04Gxp6dksHN/AnElAouzWFlWvdtGqMznuutTZX5i3GxBQIj1tucqLUmL7Zc2yk4mjhoS0kRQfRWvQ+xCfiiQtMmiR2DklqwGyz6zwc13N1cBIxH8MXyozQ7OnMZEwvXJ79uhdzaKgYj91+CWz9qad6IFJdMGQvQdIL3PNmgyuFRG3EVxuQzcE3BtK1R0yPp/26YBEFKvVcYaeBTnE0TUJI9jpfzQjMFoSEY6dEOquSbc+YwwTT7rcUoqtdvxnKNGcIuKbKlHTsXOjd+2xZ/YPe5+LE7tOziCWE3Nutnb8eU9dVlDuFnIw2dZQ7dw/xDolqrZEVpmpgFf+VfP+mCcJNI0a7sDVJ8X42hfTdT1GsadKAGCP72kpCokMxxfV2hv/A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(86362001)(33656002)(38070700005)(122000001)(38100700002)(5660300002)(52536014)(478600001)(8936002)(2906002)(41300700001)(7416002)(316002)(6916009)(54906003)(71200400001)(4326008)(8676002)(64756008)(66446008)(66556008)(66946007)(76116006)(66476007)(186003)(55016003)(83380400001)(6506007)(26005)(53546011)(7696005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDFzUk5uU2V2ZG5yakFNVlBaVlFXZ3lKMGZWc3pDRHA2QUxZalc4ZkE4ZC90?=
 =?utf-8?B?ZDlsdzRuZ01qREpESm0zWGlBNkp0S1FyRmFyQnFNNXN2djF6SkNBUzVxSldv?=
 =?utf-8?B?Qm91RUdnZGJLVW9XaDBMNmlpSVdMZGNVY2sxZVJHUmhTaHhvVDlHbGdUMUxi?=
 =?utf-8?B?N0J2UzFxbXJXMEV5VlBLa0UrNWNrWWdmWUtzMWxtR1hMVHRnd01nY2hLVS9m?=
 =?utf-8?B?UC9wU1Zza3lSd3FFNTZVQStEZmgvRUF0R0NqU0hEQXNhVnBzVXozKzF1dFlt?=
 =?utf-8?B?YkxjcjVaSnpjRTJqZGd2d0pQcldadjRIWEtXSTZuUFhMaG1teEk2TXRTelkv?=
 =?utf-8?B?Z2dUR3YydGVYdFNXSHpLM25TSSs2cVg0Q1VXdXIyRVJ4YWdscGl5VGR6dE54?=
 =?utf-8?B?cmdGWUtsWTZTTGUxbWdwVDRFa1Q2R1YvVjFXalEyMWVxZG1GWmRuQW1NK2JT?=
 =?utf-8?B?QjVUY2wvYWg1MlVkUzFoYzFXTG91bHBndmxiNXM5anA2UzhuM1Vlek9XT2k1?=
 =?utf-8?B?K1lJQVB4bDVBMlNzMWlQbHBldE1QVmZ0NnNabkpleTVQdGNxV25ncWJ5VkVC?=
 =?utf-8?B?NUUzOGxyOTFFUE9JZUtHcC9vN0cwUjlnL1hJbFhrYWhlMm93MnJUN0FZRmls?=
 =?utf-8?B?aGhTbkxlaXU1ZDc5OWM5ajZKZ1NMVi9Bd25haGFxNThlQnR0YWU4MVcyNTVE?=
 =?utf-8?B?L2NnbHhITm9SOXVJVG8vL0tBVFRVeC82dFo3VWNjVDkvR1BaOE5YcWpQdFRU?=
 =?utf-8?B?SUtmSmE5cThNK3VCOW1xUDV6ZG02NDNLdWQrVCtwK0lpZGdTWXFnUWcwZ1A4?=
 =?utf-8?B?ZmtIenZHUFNweHdiR0Nqb1dNZ2E1UzF2QzRpK2VHMm9CQTZ6WTlhTE5uZG1Y?=
 =?utf-8?B?WUNyR1FSOXNoaUUrNytxbFp0ZDBpeGtJTUZaL0pZYVJUczh2UGhra201bHBw?=
 =?utf-8?B?ZXJSNW5INUZERmhJWmJkTzdURlpEQlpoemxORFU4TG5FRk91b04xbjZFMkpD?=
 =?utf-8?B?M3hEWVo2VlI0NTJpZ3BLK1B2R2VMeVBISzc5bnlCOHpjZG5UcGtxWFVuQk4v?=
 =?utf-8?B?K0gvZ1Nlc3VKZjQ4TXVxZ05tMGVwcXR3MlpQWFlrdDBLWko5NFFST2RsNlNG?=
 =?utf-8?B?NHRqMklSN2wvU216QVoxelkvOXV0eVdTUC9keFFoSnJoQi8xVjlrOWVlL09l?=
 =?utf-8?B?RWlyYStXYWp5UzMrMjdxZkJuREtwTytPdTBQd3JoVDZZdlBVWERCTGxMQlUy?=
 =?utf-8?B?czNzdm1CWkNGMFNDUTJBMFFZUTZaQnBYeTRUOGhaSGF4SGhaVktwcFpxMXV5?=
 =?utf-8?B?Qmw2MzlCZnV3Mm9vajQxby9TZVM4RWVBcUdrNVMyVTl4bm8wc0phMGZEMGY5?=
 =?utf-8?B?SDduQTJGZ3VzSWhrNE9TcTlVKzF0Rm5YNTFaNEJrdENCSTVwekVWS0gxOUcy?=
 =?utf-8?B?MVVJZVdYMHVIUzZHZEl3SjJCVTlvME5IVkgxZngrVUd6K2RYaC80RW4rb1A1?=
 =?utf-8?B?akVOTURqVDljazVZbEpQZ2V1NmVOY0RjaU8yUFdkSndubktxYlhjWW5mZUoy?=
 =?utf-8?B?UG1MbUgrbkIrMjg2QVM0Mml0T2JYaXR5aFBEZm9jNVZYbFBPUTh5NEtxUVlp?=
 =?utf-8?B?V1U2Ukg4SU8rRGFidUQ5dzRXWUZKZWc1L3NjLy85TjBYdWFpNndLNWpkZ1FZ?=
 =?utf-8?B?bGNFZ0szU2tIOXBEKysxTWZkQVgxb0pGYzgyQ1ZJSENaUFRiY1B3aDl5Wk5r?=
 =?utf-8?B?c1BISHFrT3drait3MVEzeHpuaDN5eGFNVlVTSVJNZzE5LzFneEQ1dmpXQ3lI?=
 =?utf-8?B?d3NVem41cmJqejIvcllteUhFWUhJUXVzNkl1S3NqVGdqOCtPbGg5enArd0o0?=
 =?utf-8?B?RmdURE5mWjVtOHA1bDRBVTNWelgyTUhNa1k1QjRQdFJ0NWpUTnFWUEVXY0Fo?=
 =?utf-8?B?cTJMeVNES0tXQ2k4RnVLRm5UZWw5MGtQTHM0Ukd5R1Z3VEIxcWhLc002cGsv?=
 =?utf-8?B?SW91Uml0T2hyeTlRcm8yK01QMTBkMGpKbVlwQ2JqMkRQVlNVNWgrdXhCeENa?=
 =?utf-8?B?cjRaalg5WUV5WkkrTUE2aEk3VXFkTnZ2OERJZGYveFVRSkZGYWdOVkdLLzBk?=
 =?utf-8?Q?ZvF5T9tXKFOjmYFkPvj6fkIWk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6aa5cd-58c1-4220-81ef-08da5c55f2cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 18:09:04.1564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dFfrj1Fr99oOoRg4tzDQZNH649WwEe5Bsl2JzVEmcN2e4U8a9UABhYV6XbbCPrS8R+PD0ItucItFu+CCFQj/Lxxeiu9GbNeJ6LfEB+YYsc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3364
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
QVRDSCAzLzZdIGNhbjogc2phMTAwMDogQWRkIFF1aXJrcyBmb3IgUlovTjEgU0pBMTAwMCBDQU4N
Cj4gY29udHJvbGxlcg0KPiANCj4gT24gMDIuMDcuMjAyMiAxNTowMToyNywgQmlqdSBEYXMgd3Jv
dGU6DQo+ID4gQ2hhcHRlciA2LjUuMTYgb2YgdGhlIFJaL04xIFBlcmlwaGVyYWwgTWFudWFsIG1l
bnRpb25zIHRoZSBiZWxvdw0KPiA+IGRpZmZlcmVuY2VzIGNvbXBhcmVkIHRvIHRoZSByZWZlcmVu
Y2UgUGhpbGlwcyBTSkExMDAwIGRldmljZS4NCj4gPg0KPiA+IEhhbmRsaW5nIG9mIFRyYW5zbWl0
dGVkIE1lc3NhZ2VzOg0KPiA+ICAqIFRoZSBDQU4gY29udHJvbGxlciBkb2VzIG5vdCBjb3B5IHRy
YW5zbWl0dGVkIG1lc3NhZ2VzIHRvIHRoZQ0KPiByZWNlaXZlDQo+ID4gICAgYnVmZmVyLCB1bmxp
a2UgdGhlIHJlZmVyZW5jZSBkZXZpY2UuDQo+ID4NCj4gPiBDbG9jayBEaXZpZGVyIFJlZ2lzdGVy
Og0KPiA+ICAqIFRoaXMgcmVnaXN0ZXIgaXMgbm90IHN1cHBvcnRlZA0KPiA+DQo+ID4gVGhpcyBw
YXRjaCBhZGRzIGRldmljZSBxdWlya3MgdG8gaGFuZGxlIHRoZXNlIGRpZmZlcmVuY2VzLg0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29t
Pg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9jYW4vc2phMTAwMC9zamExMDAwLmMgfCAxNyAr
KysrKysrKysrKy0tLS0tLQ0KPiA+IGRyaXZlcnMvbmV0L2Nhbi9zamExMDAwL3NqYTEwMDAuaCB8
ICA0ICsrKy0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA3IGRlbGV0
aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9zamExMDAwL3Nq
YTEwMDAuYw0KPiA+IGIvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2phMTAwMC5jDQo+ID4gaW5k
ZXggMmU3NjM4Zjk4Y2YxLi40OWNmNGZjNGQ4OTYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9u
ZXQvY2FuL3NqYTEwMDAvc2phMTAwMC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvY2FuL3NqYTEw
MDAvc2phMTAwMC5jDQo+ID4gQEAgLTE4Myw4ICsxODMsOSBAQCBzdGF0aWMgdm9pZCBjaGlwc2V0
X2luaXQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gPiB7DQo+ID4gIAlzdHJ1Y3Qgc2phMTAw
MF9wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gPg0KPiA+IC0JLyogc2V0IGNsb2Nr
IGRpdmlkZXIgYW5kIG91dHB1dCBjb250cm9sIHJlZ2lzdGVyICovDQo+ID4gLQlwcml2LT53cml0
ZV9yZWcocHJpdiwgU0pBMTAwMF9DRFIsIHByaXYtPmNkciB8IENEUl9QRUxJQ0FOKTsNCj4gPiAr
CWlmICghKHByaXYtPmZsYWdzICYgU0pBMTAwMF9OT19DRFJfUkVHX1FVSVJLKSkNCj4gPiArCQkv
KiBzZXQgY2xvY2sgZGl2aWRlciBhbmQgb3V0cHV0IGNvbnRyb2wgcmVnaXN0ZXIgKi8NCj4gPiAr
CQlwcml2LT53cml0ZV9yZWcocHJpdiwgU0pBMTAwMF9DRFIsIHByaXYtPmNkciB8IENEUl9QRUxJ
Q0FOKTsNCj4gPg0KPiA+ICAJLyogc2V0IGFjY2VwdGFuY2UgZmlsdGVyIChhY2NlcHQgYWxsKSAq
Lw0KPiA+ICAJcHJpdi0+d3JpdGVfcmVnKHByaXYsIFNKQTEwMDBfQUNDQzAsIDB4MDApOyBAQCAt
MjA4LDkgKzIwOSwxMSBAQA0KPiA+IHN0YXRpYyB2b2lkIHNqYTEwMDBfc3RhcnQoc3RydWN0IG5l
dF9kZXZpY2UgKmRldikNCj4gPiAgCWlmIChwcml2LT5jYW4uc3RhdGUgIT0gQ0FOX1NUQVRFX1NU
T1BQRUQpDQo+ID4gIAkJc2V0X3Jlc2V0X21vZGUoZGV2KTsNCj4gPg0KPiA+IC0JLyogSW5pdGlh
bGl6ZSBjaGlwIGlmIHVuaW5pdGlhbGl6ZWQgYXQgdGhpcyBzdGFnZSAqLw0KPiA+IC0JaWYgKCEo
cHJpdi0+cmVhZF9yZWcocHJpdiwgU0pBMTAwMF9DRFIpICYgQ0RSX1BFTElDQU4pKQ0KPiA+IC0J
CWNoaXBzZXRfaW5pdChkZXYpOw0KPiA+ICsJaWYgKCEocHJpdi0+ZmxhZ3MgJiBTSkExMDAwX05P
X0NEUl9SRUdfUVVJUkspKSB7DQo+ID4gKwkJLyogSW5pdGlhbGl6ZSBjaGlwIGlmIHVuaW5pdGlh
bGl6ZWQgYXQgdGhpcyBzdGFnZSAqLw0KPiA+ICsJCWlmICghKHByaXYtPnJlYWRfcmVnKHByaXYs
IFNKQTEwMDBfQ0RSKSAmIENEUl9QRUxJQ0FOKSkNCj4gPiArCQkJY2hpcHNldF9pbml0KGRldik7
DQo+ID4gKwl9DQo+ID4NCj4gPiAgCS8qIENsZWFyIGVycm9yIGNvdW50ZXJzIGFuZCBlcnJvciBj
b2RlIGNhcHR1cmUgKi8NCj4gPiAgCXByaXYtPndyaXRlX3JlZyhwcml2LCBTSkExMDAwX1RYRVJS
LCAweDApOyBAQCAtNjUyLDEyICs2NTUsMTQgQEANCj4gPiBzdGF0aWMgY29uc3Qgc3RydWN0IG5l
dF9kZXZpY2Vfb3BzIHNqYTEwMDBfbmV0ZGV2X29wcyA9IHsNCj4gPg0KPiA+ICBpbnQgcmVnaXN0
ZXJfc2phMTAwMGRldihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KSAgew0KPiA+ICsJc3RydWN0IHNq
YTEwMDBfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQo+ID4gIAlpbnQgcmV0Ow0KPiA+
DQo+ID4gIAlpZiAoIXNqYTEwMDBfcHJvYmVfY2hpcChkZXYpKQ0KPiA+ICAJCXJldHVybiAtRU5P
REVWOw0KPiA+DQo+ID4gLQlkZXYtPmZsYWdzIHw9IElGRl9FQ0hPOwkvKiB3ZSBzdXBwb3J0IGxv
Y2FsIGVjaG8gKi8NCj4gPiArCWlmICghKHByaXYtPmZsYWdzICYgU0pBMTAwMF9OT19IV19MT09Q
QkFDS19RVUlSSykpDQo+ID4gKwkJZGV2LT5mbGFncyB8PSBJRkZfRUNITzsJLyogd2Ugc3VwcG9y
dCBsb2NhbCBlY2hvICovDQo+ID4gIAlkZXYtPm5ldGRldl9vcHMgPSAmc2phMTAwMF9uZXRkZXZf
b3BzOw0KPiA+DQo+ID4gIAlzZXRfcmVzZXRfbW9kZShkZXYpOw0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9jYW4vc2phMTAwMC9zamExMDAwLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2Nhbi9z
amExMDAwL3NqYTEwMDAuaA0KPiA+IGluZGV4IDlkNDYzOThmODE1NC4uZDBiOGNlM2Y3MGVjIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi9zamExMDAwL3NqYTEwMDAuaA0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2Nhbi9zamExMDAwL3NqYTEwMDAuaA0KPiA+IEBAIC0xNDUsNyArMTQ1
LDkgQEANCj4gPiAgLyoNCj4gPiAgICogRmxhZ3MgZm9yIHNqYTEwMDBwcml2LmZsYWdzDQo+ID4g
ICAqLw0KPiA+IC0jZGVmaW5lIFNKQTEwMDBfQ1VTVE9NX0lSUV9IQU5ETEVSIDB4MQ0KPiA+ICsj
ZGVmaW5lIFNKQTEwMDBfQ1VTVE9NX0lSUV9IQU5ETEVSCUJJVCgwKQ0KPiA+ICsjZGVmaW5lIFNK
QTEwMDBfTk9fQ0RSX1JFR19RVUlSSwlCSVQoMSkNCj4gPiArI2RlZmluZSBTSkExMDAwX05PX0hX
X0xPT1BCQUNLX1FVSVJLCUJJVCgyKQ0KPiANCj4gUGxlYXNlIG5hbWUgdGhlc2UgZGVmaW5lcyBT
SkExMDAwX1FVSVJLXyoNCg0KQWdyZWVkLCBXaWxsIGZpeCB0aGlzIGluIFYyLg0KDQpDaGVlcnMs
DQpCaWp1DQo=
