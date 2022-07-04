Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148235651CB
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 12:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiGDKNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 06:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbiGDKNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 06:13:23 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2099.outbound.protection.outlook.com [40.107.114.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD04F6B;
        Mon,  4 Jul 2022 03:13:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPCFYACWORlDLuvi6IoGGNZSHwSc3kvQjGqHDhF3X9MszxoJ+RuACkIHSLcnJD1qKJBNt0ddcuCy+mrj0nHJ6f1xKI+GaOxqFCxrEJsYe887G2mjkvrBz5ndkRiqjiQGDbwaZxt2U5PoMrFH6NQ/G20YmqK5ThGj8xYdcbUjkN3g5CcflAVXgibJErDKbA95Ni1sfJSJTx2Fc0mgYJNSLYOl38LTKXPS+3Sg2vjwdqxHf9QqVhZJonDGxI2DwThdRxOQRz1vgXPr5Ql9x1RdoeMXYUMP0GB1A6+9eXPn+feInAKpaCJ6seDTrrB0LNG1zxHm19yIjBhN4j4woc8Q6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OahMXwE1CE0n3gJsHdB+6WMPVxvXLwwPq/LpaLNDBVI=;
 b=iu45nWfn5O8tazJixgDL9Ieku6mbR2i8VvKOxV/79NPciX7DN7Fx/9bU0d4aB76qGdUzFxmpExgWLBYKlVlxE39Q6dMZy12xkvQrEzC42eYlwZEi+UfurTkuOlRNBr9OQdOxRCvIKnxQtS1Laz6yiRBw378E+UWvbD87LcK7f/eLvoArX2pR6BtitkM7B/rfQNfPkji2BMd1YiVeP6Zb3LDeO/TDRbOLbwp1vYoazNnQGXNSx+JDFW6XnADbjbmPsI0drogu8blIRzS3+gDOnW+rOuUQgdVXvpFEMTLOMVMSRY2V0z3wS9WW/mAHz1fwf5w1Qr0uxkolnu7N5tC4HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OahMXwE1CE0n3gJsHdB+6WMPVxvXLwwPq/LpaLNDBVI=;
 b=awoLVXzaeCmfzKsFjt79Wdmugz7Ja9h5JAFO8q0IzdKljKMxirdANs2TeaNsi8YHomu/Dr8wPtWT9UlEAfYyAJf0qLCQz+LC3dJvvAPLcmRRr0djESf015ehYEBH2E9stD1x2x0U9uSg7bVUcIXRQB8Vck2YaAqnZ3ALWAE5Y6o=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYAPR01MB2430.jpnprd01.prod.outlook.com (2603:1096:404:85::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 10:13:16 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 10:13:16 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 3/6] can: sja1000: Add Quirk for RZ/N1 SJA1000 CAN
 controller
Thread-Topic: [PATCH v3 3/6] can: sja1000: Add Quirk for RZ/N1 SJA1000 CAN
 controller
Thread-Index: AQHYj3rNvTbRHbqmrU+w0DVEMNqwXq1t+UIAgAAD4cA=
Date:   Mon, 4 Jul 2022 10:13:16 +0000
Message-ID: <OS0PR01MB5922C8CF2FCBE7E6DEF806A486BE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
 <20220704075032.383700-4-biju.das.jz@bp.renesas.com>
 <CAMZ6RqLr=eO_LFRtoDcd0eOr_JyX8eTJwsnqtg_veO_wNBN8Eg@mail.gmail.com>
In-Reply-To: <CAMZ6RqLr=eO_LFRtoDcd0eOr_JyX8eTJwsnqtg_veO_wNBN8Eg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99392df1-5a99-4963-0248-08da5da5cfcf
x-ms-traffictypediagnostic: TYAPR01MB2430:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TGofYVsoVEQAR+HBu/8gQvuVYqYX9lv3XxjRL24dSGSsD08ffbxrKzimimREafxypDR5iORvwiqcLjN4QRHOukXDKvawHd8LJMMh3ETEmrqKnnx4e/hw316Dx1yh5Qp2A6Wn53wMaClMwB2JWgHfQGyqJQAQbEMH8a/mH6KCDiWxaL3oFxtVpEcDVZ2b4eEW8l8BFM578ipscE25zTjyomxFx4ARAJNxawVyqPDne0ur+TyDRab4MsRZpgsQi8LATgE5JRGyY8ECfgFCiQtgi1ckBm3rve/BLD20Q9d7/L7V51I07CJ+qcURiGWVcvqN/KHehbErJ0BROC7VcwjJ+miUcPQHui+PYbqXcd55vaO1FMUbhLNDGK6hFI7z5mABtyPhdQigMcYy5QuWu0IuWAx7pfgH9fgvwGBk1qqrRN5xmArQt/D7ZGB/88eI8DXYFnrBCJOCZque2i0Ke9uRxWPQwiWfbPOOyV8hpvDywE+oIaen+ZYXcofTyIVInTVrOcyJIU0jxh/+7099PA599FsZ1jbnAZ67ExmmMruQ0+cFmAlK18sKPqwZVv/8LRuLgKtfnxC1EX+/nUimPPudO1SO0q7e+w89kcYWhG+nzdXJFXIlc5THFhiSDGPCm/3Fc6pItE+bi7o4Ss1V3LedSpXxD7VIzBZCu/vH9T69Plx+AsbvU6DaSISj8jNn+HYDTUg1T3BL8FRDVEDlHn2wxG2feXeAFe4hveEHfeyPQwikKa/75QtJc78/gX0y5hqycuLF56HuXvVmD7bVxK/E41Pv/TxjKX6hj7nSLPR8XUpVXHjthtYzy8u2r7LVR/sD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(38100700002)(76116006)(66946007)(66556008)(4326008)(54906003)(8676002)(66476007)(66446008)(64756008)(33656002)(55016003)(86362001)(316002)(6916009)(122000001)(71200400001)(38070700005)(26005)(7416002)(2906002)(41300700001)(8936002)(52536014)(478600001)(6506007)(186003)(9686003)(83380400001)(5660300002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmNjbnZGWlh4WEJ1R0RNeDVLNUxlNmUzNVR3MGVjYTlWeFlGRy8xWFVVQzFN?=
 =?utf-8?B?aEV3TTZmL3NucUcrNG1mbTdkOTQ4OStRV3E5ZW5pVDZ0UW1EVlZjZURHK0FD?=
 =?utf-8?B?RytZMmYyUUdmZzFQbTlkenJhcEFVc0VMM2J1SzBxMkxKN2tBd0l3WmE2OVB3?=
 =?utf-8?B?djd2TVZXRjJMZWRFdmw4Qmp3WndpeWNtSzlPVXdNOExIaTBkRTBCR1dPS2FC?=
 =?utf-8?B?a0doanpYUitCMnYveU1WM1R3clIrU1I5OForSnhPdm00cWdOZnFwakJXdGdT?=
 =?utf-8?B?TnZqTmRyc0MyNkp2ZmlHclRPM3huZVNIUXU3US9vNjBDSEhOQ04wdHk5a0Rv?=
 =?utf-8?B?K2ZGM1Y0c05DTTF3VWVaY3VnUnR6V0lSOEZnODlBdVFXRWF5VUJOSElwYUpP?=
 =?utf-8?B?bjhUT2RoenUyMWVObFRZTENLWjFUTWdxLzFVaEVZK2RWYnhhazZwNXVQOHNM?=
 =?utf-8?B?bHhIcHVNa001N1QzRHJvOWtjOExab2dNWGdJdG5IVmFueTU4cUIxdDhmN1Zr?=
 =?utf-8?B?THc3emo0TllHRm1KMXNzelJoQnduTHZNelBKSlk1TytlckhoSmdqRGl4cThM?=
 =?utf-8?B?eXAwNmRVOFJnajUxb0tNcUlDcVUrZzdMWXRvL0U1aE85REhPT2Q2REt3N1kv?=
 =?utf-8?B?VWFHRFh4emliblVOTkowZW5xS1FUZGtYTGNIQ213VDExQ05oeDVDR3FSZlRl?=
 =?utf-8?B?M1JXRlVvdTBpb0lnOVNubnV5M2tnYkQveHRUTm1ENk9IQm5FWkROY21yV0ZU?=
 =?utf-8?B?Y3RGamZkaUdodXpqUS9nTEhGZ3JHbDh6RE1GOUxNQlNiR2ZBOC9KVUV2NVR3?=
 =?utf-8?B?QXFDK0tuWWJVamE5OTdWMzU5Rjc1U1Rnbm5NQVBFMUc1Q29aU3JUdDdXWDVS?=
 =?utf-8?B?OVJndEhYdzBwSFpVKzhZaU1ZalhWZ080OHdxUWxrN2JueWswbk00RWtHMEhP?=
 =?utf-8?B?cWVIc0tXV2hOb3h3VlpkaGFZSW0xdi83Z1U3MUxzNTJ3N0szMERaWWRwbWRB?=
 =?utf-8?B?bldhRlZkS1Z4Z1dXYVN1bmRFWEVxNDRHaXp5VWpvR3RVZFAzSjZUNGhmQ2ZN?=
 =?utf-8?B?SU1QT3NIZVpINzg2dGxlZysxN2tjbGhjS1hqRUtMQ2QyaElZcTZmN0dZSVpL?=
 =?utf-8?B?Yy9rTTA0TXEvczZlSHR6b2I0VzJYaUJSUEpuVkZkcXRad0tCTzA4QjJaUXJj?=
 =?utf-8?B?MHhZTXI4SEdNRlB6V3l5RXNUNWp4NGQ5eElpS3pjNFU4YUxPL0tFbjJ6c21s?=
 =?utf-8?B?RHZSWU9Sd1oyMUtHaHJRRXBkb01hc1V2OHZFY1ErVjRYQjFnekI4S1dXaXV2?=
 =?utf-8?B?elRaWmtRVTZEU0FGOWIzSDVZK2JmUTVkTGg5NzZSaXJVbWdlMGJMeksxM3hV?=
 =?utf-8?B?Y3FzTHZKRG8wOTIxTHN6VkN5VlBodlpCV0g2Sk9GZDd3bjJFb2dqdXlPRUc3?=
 =?utf-8?B?WEhWZHNBQjhyeWxpVTc1QWQvR2RqMXROcXhUUmNXVlhZc3BvYW0xWk9lLzB1?=
 =?utf-8?B?andCQll6U0l5WVZxNFBLSzhMWVFMZ09vc0VaVFNlUUVIK1A4Z09TUXp4ek1U?=
 =?utf-8?B?QjBIbHRkODdUM0dHS1gwMXlVcUxKanNSOVVVaTRraWM1cDZUeEk4T3BsaG9O?=
 =?utf-8?B?UU82RjVxTmVuK3FQYjBWa0IrQTBnSmI5cXMwUnpOd3J2OVVmWkVZVk1DWnpO?=
 =?utf-8?B?TUJ5SVJIRFV5N1d2ZDhlczBoeXVCNmpUeVlrdDI2dXNzMjh2aXk1akNhb1di?=
 =?utf-8?B?c04vWnlqU2h6OHpmU0xub0RUaTkyQmlpWXM2Yk9lVk5ka1NMejVCYmlhOHpE?=
 =?utf-8?B?dThKNGE3cENsM0xNM0NOWXh2bUlLSG5VRXlXL1Z2UTdsZ0phZnNNeVNRbXNK?=
 =?utf-8?B?Smo0NUVrbjVVMXJLWlR0WU5obGc4S3hudEE4dGNMS1ZhVkM2Y2ZMREppMW5G?=
 =?utf-8?B?aUkzVEFOTFBOUkNtdGtaaU1wQiswZEVOOXVoVEkzNzFTTHhpWW9QalFKU0RY?=
 =?utf-8?B?aSs1WU00byswN2VNa0hUWTRmMlBLSk04cmZROWlrbVFYUG5Sc0ViZWFLY09F?=
 =?utf-8?B?TGpwR204eVBVa1JIa24rL3NCMW5tblM4RE5IcjkxaThrbEdib3NCVXBROWVK?=
 =?utf-8?B?bm5WS2pjR3FpTVhzbldXKzhvY3AvWnhTbGdQZW5CbjJtVEt5TVk5ZEdYZVpX?=
 =?utf-8?B?SVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99392df1-5a99-4963-0248-08da5da5cfcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 10:13:16.3315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QQqOv0A0EBUxJwrLj6Nzyj5/dQ76f2c7lsVdlBREpG6GHq5DcCnjxUVokku2mdw9UDdYRWqttocUtGKDjNXYgVgd+tF0hWKQ7lBu5RAPgwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2430
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmluY2VudCwNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCj4gU3ViamVjdDogUmU6
IFtQQVRDSCB2MyAzLzZdIGNhbjogc2phMTAwMDogQWRkIFF1aXJrIGZvciBSWi9OMSBTSkExMDAw
IENBTg0KPiBjb250cm9sbGVyDQo+IA0KPiBIaSBCaWp1LA0KPiANCj4gSSBnYXZlIGEgcXVpY2sg
bG9vayB0byB5b3VyIHNlcmllcy4gTm90aGluZyBvZGQgdG8gbWUsIEkganVzdCBoYXZlIGENCj4g
c2luZ2xlIG5pdHBpY2suDQo+IA0KPiBPbiBNb24uIDQganVpbC4gMjAyMiBhdCAxNjo1MSwgQmlq
dSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiB3cm90ZToNCj4gPiBBcyBwZXIg
Q2hhcHRlciA2LjUuMTYgb2YgdGhlIFJaL04xIFBlcmlwaGVyYWwgTWFudWFsLCBUaGUgU0pBMTAw
MCBDQU4NCj4gPiBjb250cm9sbGVyIGRvZXMgbm90IHN1cHBvcnQgQ2xvY2sgRGl2aWRlciBSZWdp
c3RlciBjb21wYXJlZCB0byB0aGUNCj4gPiByZWZlcmVuY2UgUGhpbGlwcyBTSkExMDAwIGRldmlj
ZS4NCj4gPg0KPiA+IFRoaXMgcGF0Y2ggYWRkcyBhIGRldmljZSBxdWlyayB0byBoYW5kbGUgdGhp
cyBkaWZmZXJlbmNlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFz
Lmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IC0tLQ0KPiA+IHYyLT52MzoNCj4gPiAgKiBObyBDaGFu
Z2UNCj4gPiB2MS0+djI6DQo+ID4gICogVXBkYXRlZCBjb21taXQgZGVzY3JpcHRpb24NCj4gPiAg
KiBSZW1vdmVkIHRoZSBxdWlyayBtYWNybyBTSkExMDAwX05PX0hXX0xPT1BCQUNLX1FVSVJLDQo+
ID4gICogQWRkZWQgcHJlZml4IFNKQTEwMDBfUVVJUktfKiBmb3IgcXVpcmsgbWFjcm8uDQo+ID4g
LS0tDQo+ID4gIGRyaXZlcnMvbmV0L2Nhbi9zamExMDAwL3NqYTEwMDAuYyB8IDEzICsrKysrKysr
LS0tLS0NCj4gPiBkcml2ZXJzL25ldC9jYW4vc2phMTAwMC9zamExMDAwLmggfCAgMyArKy0NCj4g
PiAgMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9zamExMDAwL3NqYTEwMDAuYw0KPiA+
IGIvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2phMTAwMC5jDQo+ID4gaW5kZXggMmU3NjM4Zjk4
Y2YxLi5lOWM1NWY1YWEzYzMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL3NqYTEw
MDAvc2phMTAwMC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2phMTAwMC5j
DQo+ID4gQEAgLTE4Myw4ICsxODMsOSBAQCBzdGF0aWMgdm9pZCBjaGlwc2V0X2luaXQoc3RydWN0
IG5ldF9kZXZpY2UgKmRldikNCj4gPiB7DQo+ID4gICAgICAgICBzdHJ1Y3Qgc2phMTAwMF9wcml2
ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gPg0KPiA+IC0gICAgICAgLyogc2V0IGNsb2Nr
IGRpdmlkZXIgYW5kIG91dHB1dCBjb250cm9sIHJlZ2lzdGVyICovDQo+ID4gLSAgICAgICBwcml2
LT53cml0ZV9yZWcocHJpdiwgU0pBMTAwMF9DRFIsIHByaXYtPmNkciB8IENEUl9QRUxJQ0FOKTsN
Cj4gPiArICAgICAgIGlmICghKHByaXYtPmZsYWdzICYgU0pBMTAwMF9RVUlSS19OT19DRFJfUkVH
KSkNCj4gPiArICAgICAgICAgICAgICAgLyogc2V0IGNsb2NrIGRpdmlkZXIgYW5kIG91dHB1dCBj
b250cm9sIHJlZ2lzdGVyICovDQo+ID4gKyAgICAgICAgICAgICAgIHByaXYtPndyaXRlX3JlZyhw
cml2LCBTSkExMDAwX0NEUiwgcHJpdi0+Y2RyIHwNCj4gPiArIENEUl9QRUxJQ0FOKTsNCj4gPg0K
PiA+ICAgICAgICAgLyogc2V0IGFjY2VwdGFuY2UgZmlsdGVyIChhY2NlcHQgYWxsKSAqLw0KPiA+
ICAgICAgICAgcHJpdi0+d3JpdGVfcmVnKHByaXYsIFNKQTEwMDBfQUNDQzAsIDB4MDApOyBAQCAt
MjA4LDkgKzIwOSwxMQ0KPiA+IEBAIHN0YXRpYyB2b2lkIHNqYTEwMDBfc3RhcnQoc3RydWN0IG5l
dF9kZXZpY2UgKmRldikNCj4gPiAgICAgICAgIGlmIChwcml2LT5jYW4uc3RhdGUgIT0gQ0FOX1NU
QVRFX1NUT1BQRUQpDQo+ID4gICAgICAgICAgICAgICAgIHNldF9yZXNldF9tb2RlKGRldik7DQo+
ID4NCj4gPiAtICAgICAgIC8qIEluaXRpYWxpemUgY2hpcCBpZiB1bmluaXRpYWxpemVkIGF0IHRo
aXMgc3RhZ2UgKi8NCj4gPiAtICAgICAgIGlmICghKHByaXYtPnJlYWRfcmVnKHByaXYsIFNKQTEw
MDBfQ0RSKSAmIENEUl9QRUxJQ0FOKSkNCj4gPiAtICAgICAgICAgICAgICAgY2hpcHNldF9pbml0
KGRldik7DQo+ID4gKyAgICAgICBpZiAoIShwcml2LT5mbGFncyAmIFNKQTEwMDBfUVVJUktfTk9f
Q0RSX1JFRykpIHsNCj4gPiArICAgICAgICAgICAgICAgLyogSW5pdGlhbGl6ZSBjaGlwIGlmIHVu
aW5pdGlhbGl6ZWQgYXQgdGhpcyBzdGFnZSAqLw0KPiA+ICsgICAgICAgICAgICAgICBpZiAoIShw
cml2LT5yZWFkX3JlZyhwcml2LCBTSkExMDAwX0NEUikgJg0KPiA+ICsgQ0RSX1BFTElDQU4pKQ0K
PiANCj4gWW91IGNhbiBjb21iaW5lIHRoZSB0d28gaWYgaW4gb25lOg0KPiANCj4gfCAgICAgICAg
LyogSW5pdGlhbGl6ZSBjaGlwIGlmIHVuaW5pdGlhbGl6ZWQgYXQgdGhpcyBzdGFnZSAqLw0KPiB8
ICAgICAgICBpZiAoIShwcml2LT5mbGFncyAmIFNKQTEwMDBfUVVJUktfTk9fQ0RSX1JFRyB8fA0K
PiB8ICAgICAgICAgICAgICBwcml2LT5yZWFkX3JlZyhwcml2LCBTSkExMDAwX0NEUikgJiBDRFJf
UEVMSUNBTikpDQo+IHwgICAgICAgICAgICAgICAgY2hpcHNldF9pbml0KGRldik7DQo+IA0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgIGNoaXBzZXRfaW5pdChkZXYpOw0KPiA+ICsgICAgICAg
fQ0KDQpPSywgd2lsbCBmaXggdGhpcyBpbiBuZXh0IHZlcnNpb24uDQoNCkNoZWVycywNCkJpanUN
Cg0KPiA+DQo+ID4gICAgICAgICAvKiBDbGVhciBlcnJvciBjb3VudGVycyBhbmQgZXJyb3IgY29k
ZSBjYXB0dXJlICovDQo+ID4gICAgICAgICBwcml2LT53cml0ZV9yZWcocHJpdiwgU0pBMTAwMF9U
WEVSUiwgMHgwKTsgZGlmZiAtLWdpdA0KPiA+IGEvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2ph
MTAwMC5oDQo+ID4gYi9kcml2ZXJzL25ldC9jYW4vc2phMTAwMC9zamExMDAwLmgNCj4gPiBpbmRl
eCA5ZDQ2Mzk4ZjgxNTQuLjdmNzM2ZjFkZjU0NyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25l
dC9jYW4vc2phMTAwMC9zamExMDAwLmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9jYW4vc2phMTAw
MC9zamExMDAwLmgNCj4gPiBAQCAtMTQ1LDcgKzE0NSw4IEBADQo+ID4gIC8qDQo+ID4gICAqIEZs
YWdzIGZvciBzamExMDAwcHJpdi5mbGFncw0KPiA+ICAgKi8NCj4gPiAtI2RlZmluZSBTSkExMDAw
X0NVU1RPTV9JUlFfSEFORExFUiAweDENCj4gPiArI2RlZmluZSBTSkExMDAwX0NVU1RPTV9JUlFf
SEFORExFUiAgICAgQklUKDApDQo+ID4gKyNkZWZpbmUgU0pBMTAwMF9RVUlSS19OT19DRFJfUkVH
ICAgICAgIEJJVCgxKQ0KPiA+DQo+ID4gIC8qDQo+ID4gICAqIFNKQTEwMDAgcHJpdmF0ZSBkYXRh
IHN0cnVjdHVyZQ0K
