Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646F4524A0D
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 12:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352506AbiELKNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 06:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352439AbiELKNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 06:13:02 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2130.outbound.protection.outlook.com [40.107.114.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BBF63BDA;
        Thu, 12 May 2022 03:12:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXPvej//cuRF26u9Oq6NdZa7WRBaWcx7WotbHtqTZo5dhNUr3ZNGToE5j5QeK73PdApBWOn3ZvltiqtWsbj1ffGDgGb7aBYqnXlgKvQBs3hTWZzKa34/isq7gfq8BWn9iI+tNfFOuSa/TY5tBT4U0hK5JavjA1pmDOf8edYS62KBRiI89qNBAoHQtkDGyMApp/TQVekT21Gkkxfu2RQ2PxBpjEtrZZgBOg4Aww2SjkFHkO9g4ZMb6cXjXvXVqnunaKT8bVwjJn+ljCrzKDl0ZReQTDpKWc4VwnjF+XPCPQm+1MMfLC4e5VZTrG+Eq4wdmT6njGr79s+ZdIyZFS7jPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rx41qJl5qQA30N2dT4Kc6R+V7DUEFaIU9OgLFw3JGio=;
 b=HD5ByTEmRnFA0WUMDxMHYyk3kBD0+zxWf/8iL3secO4/4oES2bMTw3Is4btK/2E5/UqYwOXwaRrE31NyE42w8fM7Id+jQ/JHEx6bIKlLP34XOE0GQaFoto5axppK6yWLrsLZFlRsMO7SKOApO4swZE+6R0o/6qmvTFv+jq4VGh/A9Fgwaqwyzw/o/C2pzSeBi80uUO9LLzV701yRDUw0xhJ2Bz21Wq7huNAmK1W5SMm/IOUXQSLL8oPrj9UM2yJNPaRUOYbLa4HsjQGFw4JAkn+H8cvNnSQ52Z036qYR0755vUgdNfKwlnFbS6Ut2vwGPH/9cxzEPP91N5Mkfxxd8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rx41qJl5qQA30N2dT4Kc6R+V7DUEFaIU9OgLFw3JGio=;
 b=nJgSm6N7iaEyh19DeV+bdpwYMVEgcXtbtUrwP708w9JsNqXtOTrJh3ZadpxEWFLPY4wDmMvlKqeLFAQ7jI2XNBxIRVLHew5+t/pO0VDcJeDvr/XizytUfeiwrPvYuOl634wvgbhbVGmSFOeWPfIFpQvb81QHvHVJKKPJwgGtJA0=
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com (2603:1096:400:de::11)
 by OSAPR01MB3539.jpnprd01.prod.outlook.com (2603:1096:604:32::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 10:12:55 +0000
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244]) by TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244%7]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 10:12:55 +0000
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 4/5] ravb: Use separate clock for gPTP
Thread-Topic: [PATCH v3 4/5] ravb: Use separate clock for gPTP
Thread-Index: AQHYZEz3ughT5qEPnkWlFfod3/yXN60a0+YAgAA09jA=
Date:   Thu, 12 May 2022 10:12:55 +0000
Message-ID: <TYYPR01MB70863C4D33FDB4C840085323F5CB9@TYYPR01MB7086.jpnprd01.prod.outlook.com>
References: <20220510090336.14272-1-phil.edworthy@renesas.com>
         <20220510090336.14272-5-phil.edworthy@renesas.com>
 <041789819aa163907ef27fed537dfca16d293f4d.camel@redhat.com>
In-Reply-To: <041789819aa163907ef27fed537dfca16d293f4d.camel@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1cb09cd-ac85-4629-f629-08da33fffb71
x-ms-traffictypediagnostic: OSAPR01MB3539:EE_
x-microsoft-antispam-prvs: <OSAPR01MB353918DB01E63EC678B15D98F5CB9@OSAPR01MB3539.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B3bg55IM9fIFTNAnLWP9+jYapfJim54nVowcHGkafH727Ol4pWef++liCpvZuzGRfgbfztbhAi+0MgfmtTkpPwIUHOnCX8jy23jwWPCLxd4X+ZUJtkGqwGOhv/xB158U+ERgPiG5XPmu90QGFJ9zAvQo6UDmdK/g0oIKz6bzSRmkVvjWXMclADoOwSTnk+CjGMC1fRGgSLjW93Qz6iqlW8FsyBLJG7NtVtxD22r/t56h3pWjwN+SALu//+64B6KxmFFUMRVOQb8SVtdijE4S6PuKsFEVSWIrAvJtCRSmV63FKiUkX5JQ49Y9Z/OUNIxW7rx2xESlIQI+DYXgBqk4A1xSayKeNjhHWCL9rc0QTo1lcWxs/qAECmFyMQ6/JxPJVW6BGtwykj+Rse2OWxhEGpelMAXnG0QTY8OorGqeCTKe05u0jxeWgg9dVTfRnGsrjchCCsHUhUmgx9p/FUy9mIgkTu8p6aUnX+pNUWJIETNHu2sckplfjF139GoRrWjZag43TPMTzjbKdVQNR0ZlU2TsLABbapQx4Y5lVpZr1K0YCnzmIwItw3bDXdge9iA1GIdzrvvHUpmrrtlmWmV0k2WyaWQ6lePbFrMlUlyxLxd4qITKlvqE1WEyKwjchmCUT4XQwJxsx+g3opmi+TejxE4ykku/PzV+EwVypc0izFn1K3WSkbkWhHC6zb/JjF4cSamtqDebuPljr8MbYPa+Kg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYYPR01MB7086.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(55016003)(6506007)(7696005)(54906003)(316002)(44832011)(33656002)(110136005)(5660300002)(9686003)(86362001)(26005)(52536014)(508600001)(8936002)(186003)(38070700005)(4326008)(2906002)(8676002)(76116006)(38100700002)(66446008)(64756008)(122000001)(83380400001)(66476007)(71200400001)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDJ3S1dMMUtwZzYrZmEvZzIyVHE4UUszOTBQRWp4cWVkNjN3d0o1ZHNlbDNo?=
 =?utf-8?B?S210bDdFWmNuNUNPdkpWN1g3S0RveEVXTFhyMjMvdFBweTVMWmdFNnhOUHVY?=
 =?utf-8?B?ckVWSHdqQktraU9ZOHhFQ1BzRFY4bnNzTTFrUmhpVWttMS9kbTJrQ2NqYVc2?=
 =?utf-8?B?Tm1sbGNqRVNtc0NqNmxJRE1HODF0WE1IRmh5Q25ZVjZCc0RxRUxvZEFVdFMy?=
 =?utf-8?B?M1ozTkp0N3dkSTNTV2lSOGg2cnJRZ09Gc2RMUUZnSXVhUzFkK1AyUks5aHRi?=
 =?utf-8?B?Rm9ReXI5M0drL0wvZFdNYitNT0drdDkwaFVOL1lYa2E1alA1WllsaWdXMTNX?=
 =?utf-8?B?SlJIWmhFRmJsZ3FNM2VXWmwyUVdrSVhLQUVGdWROU2pBSWk4WjQ2SkREZHRQ?=
 =?utf-8?B?YmJ0SkhlTEJQV21TV0twclErNFlTQ3A2VnlHeFdFazltN1EvVGxTUExPVkFO?=
 =?utf-8?B?M1lWYWx2dFRQUDE5bkEwbHVLODIyaHFYVzRRVWcxMGVUU2xtb0wzM2svY0FM?=
 =?utf-8?B?dk5TUE1HVU8wWnRjdFNaek9oTGtNQzZxeFk1MTQ4Lzg2NnppM1BNMDN1bG5i?=
 =?utf-8?B?K1FRY09uQTJtZEhYZlo5eXZLcGZTVXZRUUhUdXV6T0ZqaHVEK1hTYUtKaEp5?=
 =?utf-8?B?QXp0QzVBNkpYdmhYaGlMKzZvbFJGRWJVUmdNODd1S2xmNFNQT3dPU3Z5ZVov?=
 =?utf-8?B?ZTdHREN6OVJaVFpPV1RCUzRLRkFkaVVJOVhqQWtKOTBKL2cxeXF3SUFuVEdr?=
 =?utf-8?B?VTBZWFZ2WERzYWE3ckU1TkQ4bzRCRzh6MldxemNuV1lMeDA2S25MRDRsY0ZP?=
 =?utf-8?B?cytYR00ydktJZ2s4OFROSGZWN0J0NitYM2FHMTJVUk0vKzlhTkdaVTJHQ1Iz?=
 =?utf-8?B?NFgzMjVHajB3V0dZS3VqckVNbHRqd2FwNkd1cFZiOE1abGpHdFNDaElHWk1z?=
 =?utf-8?B?Wm5Bb3ROOHBSZVY5N0FzT2cvUFRqV2l3eVlUemtORlY5R1NhUDJDNDN1R3Fl?=
 =?utf-8?B?VW5zMEhYUjY1Q3hRZGl5UkxzdGFFcTBmNnFtL3pnT0RkbTVmODcydWxrSTBE?=
 =?utf-8?B?cTQ2TjhKaVZnZFhkMjhvU056L3RabDVmMGFMaVgrREZ4Ni9KV2ZVa09qQU0v?=
 =?utf-8?B?WUplaUlUT3NpSUU3SHlJbzVDNlZIMXIyNlhNTUMzcmplVk1BcDZLdHhtazNV?=
 =?utf-8?B?OEpFbFU4WTVPSzJPVjhBVElLcVFnNkR4N0N6WWk0ZGhvRHdyQVN3c2tCSEVS?=
 =?utf-8?B?VEc0MDhUSklMNCtCVnNtYlpkaVVqSllGVE9rZVFuZ0JWU3UvNlVvVWpQSUtZ?=
 =?utf-8?B?aHoxUjNYdENvNzdQdWNTdHNrY29JZHRyT0JIVG5pejVrUkVTVzQ5SVBmT0Ur?=
 =?utf-8?B?TVQ4dTV6RE9RUFh5RVF1VnpGT1NVQWdZTUo4cWEyMlRSbjc2WGFBdEZqUm1l?=
 =?utf-8?B?VEpYQVBqbDV4VmNVNUVhckpLakJ6Wm8xOUlBdkUvSGZ1TWZ1cTNidVZOVGNu?=
 =?utf-8?B?ZHVVSGtEMzIyOUp1TFErYlVCYmVRWC9tRmdkYUYxQzJiS201WDFac1hWS3NN?=
 =?utf-8?B?TE5xWmJXR0h2R2ExMURuVzA4VnVYY2sxb0Jibk43dWFiaWpjWVVpVlFIZjNG?=
 =?utf-8?B?OExqVUhLRFh4U2VYNlh4TzNtMnNtT3JHakhneFdzcHZ5dFBFenYyZ00xQVAv?=
 =?utf-8?B?dTYwZGF6MjNpTWtMZ1JDWTJZU296NVNFWGR6aUpHVVhWRnFXbk4vOVRTT2lI?=
 =?utf-8?B?VEVLU2swMGtMUlZhbnlSSUVPTFA5TmZvdzkzclpKeW81cTNmWnNESzc5ZUZp?=
 =?utf-8?B?K1NSNENTYklqamU1ZEZ1d3RSS3JPUHQrWTN0VU5zMVdkeUg5a0ZWMWwxSTRx?=
 =?utf-8?B?aGo5TU9XREhoSVVBQzdrNVcxOWhvY3JrWTFjZEpLODB3WmovdzB6RkF1elAw?=
 =?utf-8?B?RngvdkNBaE4zT3JMNXVuQ21FdDduZVVTaWFSRExrcjNHNDFDK0gwdThrQktS?=
 =?utf-8?B?aVJCQ0g1eWtlTXNJWU0yV0xoNEpRdUVTOUhhN2twcU9EbE5nTlIrMkdqNkE0?=
 =?utf-8?B?WW4xQnhYZE1CTm1BMVlaa3JUQjJLKzJFSDZHUEJvbEl5YUQ0UDdET0loVWNY?=
 =?utf-8?B?andZaWt0Tngzb0dBOXlwV0FvdWFsQ1BKUlgzSk9FODE1SGR1QUQ2UFFnNDB4?=
 =?utf-8?B?aU5aUHB3S1VQNnQ0d055ekVlcXVTVHVTc3hwY2REdmZNUk5uQm15VGpZS2xW?=
 =?utf-8?B?TEtlbmdZWDJrOGlZM3FSR0IxMS95KzZXL0JNWjl5WjJuT2ZHbnhGQ3dZRVhO?=
 =?utf-8?B?cGxZd05wd3c3dkRjY0FQREtQWFowQmE4UlhKSW42NHFLSytXVHk5b0V5bzBv?=
 =?utf-8?Q?Wf9Xowdi9O05oyx4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYYPR01MB7086.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1cb09cd-ac85-4629-f629-08da33fffb71
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 10:12:55.3948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uL7rXLG1gcGon0R427PLiWjZe5QnJ+IbF4lHZu4Xvz3fEiGziUYEbG0/rI37gOs1w1XuLt7R/ksNEZJy30gZPI8QZRSIFGl94bSmTn3JytQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3539
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCk9uIDEyIE1heSAyMDIyIDA4OjAzIFBhb2xvIEFiZW5pIHdyb3RlOg0KPiBP
biBUdWUsIDIwMjItMDUtMTAgYXQgMTA6MDMgKzAxMDAsIFBoaWwgRWR3b3J0aHkgd3JvdGU6DQo+
ID4gUlovVjJNIGhhcyBhIHNlcGFyYXRlIGdQVFAgcmVmZXJlbmNlIGNsb2NrIHRoYXQgaXMgdXNl
ZCB3aGVuIHRoZQ0KPiA+IEFWQi1ETUFDIE1vZGUgUmVnaXN0ZXIgKENDQykgZ1BUUCBDbG9jayBT
ZWxlY3QgKENTRUwpIGJpdHMgYXJlIHNldCB0bw0KPiA+ICIwMTogSGlnaC1zcGVlZCBwZXJpcGhl
cmFsIGJ1cyBjbG9jayIuDQo+ID4gVGhlcmVmb3JlLCBhZGQgYSBmZWF0dXJlIHRoYXQgYWxsb3dz
IHRoaXMgY2xvY2sgdG8gYmUgdXNlZCBmb3IgZ1BUUC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IFBoaWwgRWR3b3J0aHkgPHBoaWwuZWR3b3J0aHlAcmVuZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQt
Ynk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1i
eTogU2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9tcC5ydT4NCj4gPiAtLS0NCj4gPiB2MzoN
Cj4gPiAgLSBObyBjaGFuZ2UNCj4gPiB2MjoNCj4gPiAgLSBBZGRlZCBSZXZpZXdlZC1ieSB0YWdz
DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAg
fCAgMiArKw0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwg
MTUgKysrKysrKysrKysrKystDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmIuaA0KPiA+IGluZGV4IGU1MDVlODA4ODQ0NS4uYjk4MGJjZTc2M2QzIDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBAQCAtMTAzMSw2ICsxMDMxLDcgQEAg
c3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4gIAl1bnNpZ25lZCBlcnJfbWdtdF9pcnFzOjE7CS8q
IExpbmUxIChFcnIpIGFuZCBMaW5lMiAoTWdtdCkgaXJxcw0KPiBhcmUgc2VwYXJhdGUgKi8NCj4g
PiAgCXVuc2lnbmVkIGdwdHA6MTsJCS8qIEFWQi1ETUFDIGhhcyBnUFRQIHN1cHBvcnQgKi8NCj4g
PiAgCXVuc2lnbmVkIGNjY19nYWM6MTsJCS8qIEFWQi1ETUFDIGhhcyBnUFRQIHN1cHBvcnQgYWN0
aXZlIGluDQo+IGNvbmZpZyBtb2RlICovDQo+ID4gKwl1bnNpZ25lZCBncHRwX3JlZl9jbGs6MTsJ
LyogZ1BUUCBoYXMgc2VwYXJhdGUgcmVmZXJlbmNlIGNsb2NrDQo+ICovDQo+ID4gIAl1bnNpZ25l
ZCBuY19xdWV1ZXM6MTsJCS8qIEFWQi1ETUFDIGhhcyBSWCBhbmQgVFggTkMgcXVldWVzICovDQo+
ID4gIAl1bnNpZ25lZCBtYWdpY19wa3Q6MTsJCS8qIEUtTUFDIHN1cHBvcnRzIG1hZ2ljIHBhY2tl
dA0KPiBkZXRlY3Rpb24gKi8NCj4gPiAgCXVuc2lnbmVkIGhhbGZfZHVwbGV4OjE7CQkvKiBFLU1B
QyBzdXBwb3J0cyBoYWxmIGR1cGxleCBtb2RlICovDQo+ID4gQEAgLTEwNDIsNiArMTA0Myw3IEBA
IHN0cnVjdCByYXZiX3ByaXZhdGUgew0KPiA+ICAJdm9pZCBfX2lvbWVtICphZGRyOw0KPiA+ICAJ
c3RydWN0IGNsayAqY2xrOw0KPiA+ICAJc3RydWN0IGNsayAqcmVmY2xrOw0KPiA+ICsJc3RydWN0
IGNsayAqZ3B0cF9jbGs7DQo+ID4gIAlzdHJ1Y3QgbWRpb2JiX2N0cmwgbWRpb2JiOw0KPiA+ICAJ
dTMyIG51bV9yeF9yaW5nW05VTV9SWF9RVUVVRV07DQo+ID4gIAl1MzIgbnVtX3R4X3JpbmdbTlVN
X1RYX1FVRVVFXTsNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21h
aW4uYw0KPiA+IGluZGV4IDhjY2M4MTdiOGI1ZC4uZWY2OTY3NzMxMjYzIDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gQEAgLTI0OTUsMTEg
KzI0OTUsMTUgQEAgTU9EVUxFX0RFVklDRV9UQUJMRShvZiwgcmF2Yl9tYXRjaF90YWJsZSk7DQo+
ID4gc3RhdGljIGludCByYXZiX3NldF9ndGkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpICB7DQo+
ID4gIAlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4g
Kwljb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvICppbmZvID0gcHJpdi0+aW5mbzsNCj4gPiAgCXN0
cnVjdCBkZXZpY2UgKmRldiA9IG5kZXYtPmRldi5wYXJlbnQ7DQo+ID4gIAl1bnNpZ25lZCBsb25n
IHJhdGU7DQo+ID4gIAl1aW50NjRfdCBpbmM7DQo+ID4NCj4gPiAtCXJhdGUgPSBjbGtfZ2V0X3Jh
dGUocHJpdi0+Y2xrKTsNCj4gPiArCWlmIChpbmZvLT5ncHRwX3JlZl9jbGspDQo+ID4gKwkJcmF0
ZSA9IGNsa19nZXRfcmF0ZShwcml2LT5ncHRwX2Nsayk7DQo+ID4gKwllbHNlDQo+ID4gKwkJcmF0
ZSA9IGNsa19nZXRfcmF0ZShwcml2LT5jbGspOw0KPiA+ICAJaWYgKCFyYXRlKQ0KPiA+ICAJCXJl
dHVybiAtRUlOVkFMOw0KPiA+DQo+ID4gQEAgLTI3MjEsNiArMjcyNSwxNSBAQCBzdGF0aWMgaW50
IHJhdmJfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPiAqcGRldikNCj4gPiAgCX0NCj4g
PiAgCWNsa19wcmVwYXJlX2VuYWJsZShwcml2LT5yZWZjbGspOw0KPiA+DQo+ID4gKwlpZiAoaW5m
by0+Z3B0cF9yZWZfY2xrKSB7DQo+ID4gKwkJcHJpdi0+Z3B0cF9jbGsgPSBkZXZtX2Nsa19nZXQo
JnBkZXYtPmRldiwgImdwdHAiKTsNCj4gPiArCQlpZiAoSVNfRVJSKHByaXYtPmdwdHBfY2xrKSkg
ew0KPiA+ICsJCQllcnJvciA9IFBUUl9FUlIocHJpdi0+Z3B0cF9jbGspOw0KPiA+ICsJCQlnb3Rv
IG91dF9yZWxlYXNlOw0KPiA+ICsJCX0NCj4gPiArCQljbGtfcHJlcGFyZV9lbmFibGUocHJpdi0+
Z3B0cF9jbGspOw0KPiA+ICsJfQ0KPiA+ICsNCj4gDQo+IEkgZ3Vlc3MgeW91IG5lZWQgdG8gYSBj
b25kaXRpb25hbA0KPiANCj4gCWNsa19kaXNhYmxlX3VucHJlcGFyZShpbmZvLT5ncHRwX3JlZl9j
bGspDQo+IA0KPiBpbiB0aGUgZXJyb3IgcGF0aD8gQW5kIGV2ZW4gaW4gcmF2Yl9yZW1vdmUoKT8N
Ck9vcHMsIGhvdyBkaWQgSSBtaXNzIHRoYXQ/DQoNClRoYW5rcw0KUGhpbA0KDQo+ID4gIAluZGV2
LT5tYXhfbXR1ID0gaW5mby0+cnhfbWF4X2J1Zl9zaXplIC0gKEVUSF9ITEVOICsgVkxBTl9ITEVO
ICsNCj4gRVRIX0ZDU19MRU4pOw0KPiA+ICAJbmRldi0+bWluX210dSA9IEVUSF9NSU5fTVRVOw0K
PiA+DQoNCg==
