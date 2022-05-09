Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA39E51F4F7
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbiEIHQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbiEIHFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:05:37 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2113.outbound.protection.outlook.com [40.107.114.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958B9134E22;
        Mon,  9 May 2022 00:01:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Onhn88Y74uUA0KMmrhFJh9Tj7r6aTB36PHldFMrYCou9FwshunyE9Fnz4VpNmAre/W9DYOFT15am3lO+9Al3lFSqtNENjYL2TO6w6PKgE2fRUE+kdCjFSI9Mvp53eTPvpF1G02izVI85MhseMkHzpubvYGrs8XcyQ/f0EKgS5pLAxRuZ9uXWDbDJf7L89Y7hryDmDO5WZ9vXf+vzfuRUnQRzIIDAxvtrBUMPsBWY7lFSpq2PZgb1jS3EYlC4SNrO5qgs9ZFF8pvHYZHuZgqQHmX9ymSjjR2/nrhY/kMfa50ULRE8zaI/dtBwpkinqv9UJcunVoO4uEe641DiDP2b5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPPkvq+3TzUAcjueysNE/lgpN1sw1/sDzXHddHkX030=;
 b=PApmy0FH/ErzdAwxq9okdhPnAOxtFXoa8vid3TMPbpbA9jaOYEHzp997cFlU8eCzQp6mNmu8cIZDcBagNY0ChCnUn1Hx61Gn3zojMJOqrUJKSpBknTkzAs1IIy9dJ8gHwW/o9/oVYa2PhBrxJDuY8b33bBmMvVHReTkwrVDvucxM2R6e7BmEoc6GMI/2J+VqceDFWXQ/WBYnZrV0SZ3B8l95ZedCgEgu34hQzq6UZ3Cq5iHlotdAfzCb9KftCOiKUQICFes9SQH1p20zJFYKbnr2UpdPQKAh5ifpbKtEDPKk+r7dLGb3BVADu2S+1fHaReZ9fOsPyR5iSkRYOIJQ/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPPkvq+3TzUAcjueysNE/lgpN1sw1/sDzXHddHkX030=;
 b=CCRLfmoEFmGXqrbVXNEVPm75ZVheiteEQ3SeGGal1vVcNia9ZLKg0V7y76IhEjG5woZb1EjTXOgy4Lyd8sIg/MyBriC5vh5h4Kx2wdcl09nt1RhwgPw9Eajdl+FaxA4ZdokwZwTha5U56vPywch5Rz2GkOY2eKlN6WDx5UKDy/g=
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com (2603:1096:400:de::11)
 by OS3PR01MB6706.jpnprd01.prod.outlook.com (2603:1096:604:108::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Mon, 9 May
 2022 07:01:42 +0000
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244]) by TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244%7]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 07:01:42 +0000
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 7/9] ravb: Add support for RZ/V2M
Thread-Topic: [PATCH 7/9] ravb: Add support for RZ/V2M
Thread-Index: AQHYX8ctsXeNY+Z8M0uyjNGVJEqKba0QuuiAgAVkUcA=
Date:   Mon, 9 May 2022 07:01:42 +0000
Message-ID: <TYYPR01MB70863AA6B1CC76D2BCE3044BF5C69@TYYPR01MB7086.jpnprd01.prod.outlook.com>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
 <20220504145454.71287-8-phil.edworthy@renesas.com>
 <badc2174-6068-2a21-013b-4899e376e394@omp.ru>
In-Reply-To: <badc2174-6068-2a21-013b-4899e376e394@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68238c6f-4a14-4f46-0639-08da3189c5a5
x-ms-traffictypediagnostic: OS3PR01MB6706:EE_
x-microsoft-antispam-prvs: <OS3PR01MB6706F97361D27F2196B5DB72F5C69@OS3PR01MB6706.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3xb41dqBs88zMDozYoK1KWGnCG2NoUl9tQWAq9iSUk/FerBzagFQVvXmNM1dDDsOiqJumPi6gFIjkT2e9prHBV/d/9MaGwPpSgQOowTJterXFXhswPJ2QRlq5LeAnz8c3eTxcsJ/HaCJ19rYdu/KrUf5cVfMdNorIOwo42XQd+a6c+PoBM36kfMDYfI8NZQ/0iFqpsd5tLUV3aM3HDGy+heiU/nRWfd6USxqkaHYgWlPSUL89NDSNcOhYzK1Pmu+V7nY2uwrP9HzChrje/9kWojn9Nw0NXKcePkWwFIXs19ZzUxWGmUbfqFoPvwMWiLl2byWA6vErITde7YfIAbsFjmr6YuhGxpiuWTrxagLtWNEeNGhg/I8sGHNfvZtp0tIpQV8AvGrBzwmaNN4eTiiyxfmU6DW+EOI44vUUSftBHnXaolnP6Qa2CMl0xCeKCLN1/ivdfAoUu7bHwLe/eWkh37dgxxxrbMBkpapXCKCBk8YrxWcZ/z9zDc7O75mIvj61rkFxmKEQb+R4Z7fxrb7bNEZ+ECrcFOfnVRgO6DuxbAsb3PiwlcM4mmVUB0zyOJc+KdDG5qlUuFhBo8g+NyaGxt2+om2i0tG1sfuCPANcEgxdNrEd+GJSHrI4jmqkQtZDQdaw6duvpdm2CREQCO5oaU9KuTe/5kyfcEq04kF+WcXY0wyutvKGj2iWDxY65tg/DuE9QPIkAPlaqiwDzbuQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYYPR01MB7086.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(53546011)(9686003)(122000001)(186003)(26005)(38070700005)(38100700002)(86362001)(316002)(44832011)(5660300002)(8936002)(71200400001)(52536014)(55016003)(66556008)(66946007)(66476007)(33656002)(66446008)(2906002)(64756008)(110136005)(83380400001)(7696005)(54906003)(76116006)(8676002)(508600001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUszSlhmbjdsM05URGJ5dkh6SmU0YnlBc1BKZHM3VCszOTMvQ3I2MEV5VGtD?=
 =?utf-8?B?N0pUWG9ycERaVkdlYkdjM1E1NXhQYmpLYzVzNk04VWlPU3piY014YkVXUG9m?=
 =?utf-8?B?QS84bDFRd1B4b0lOaUF0bi9iLzBUVUQzeDdESVdrMTJ2NTdWeGlkaVpqcmZJ?=
 =?utf-8?B?QzdTbUx4dmdqQ0h5aFN4bklsLzRiMnRvSHZFeFBEZ0Fibk9PWGZ3amxjYXNu?=
 =?utf-8?B?T0JuY1QwckF5bUNoQzJVWkZnMC93TzBpOTdYRjU4RlBhM1N3ZUxnbVloalVK?=
 =?utf-8?B?bForbjVTVEhUMFhDTFcxcG9yWFhkZm5XcWJ0MjBoUm84Q0xZV2ZHYUFCbGNM?=
 =?utf-8?B?eGpYbjlQZHNxY3kzaVBqd0ZRV2g4ajFBbWJiajRCWWYvRlV5SHZlWEVuRGtB?=
 =?utf-8?B?eWVNaytpUEdHK0hEem1LNklha21HWXI0YVZUbklaT3JEK0xmZDBKbXM4MjRh?=
 =?utf-8?B?bWI4TWswcTZTVDl0M2xwYkNWOWtYQjlCWlYyejB4Skt6S2gzS0dHTGQ5dHh4?=
 =?utf-8?B?M3dPYTdIUjhEOGppbmhGU2lQcEkrQlZycXY0WjgwVEVGQkNlM1dBL3Q4SnQ1?=
 =?utf-8?B?RW9DNFhIcld4ZmRpWnF4eHRMTWlnYmwza2dZd1ZDZ1I4MlNGSzRGSjlseDlm?=
 =?utf-8?B?VFY3UzVGcmxyL0xpV0FPZGlyQWMyZHhFWjVlWFhVcndwRFZ3QXRnSjdwbHJN?=
 =?utf-8?B?UHdnQ1laK2QzV0ovaTUzUVFmT2dLaFJzeFlLZGExalNSVzBWcmhCWE1VK0RD?=
 =?utf-8?B?bmV4ZHc3b1JDd1VobkRGZE5MaXFWQlZxSUFXd1ljUXlFOGxacDhXVEVXb1Fy?=
 =?utf-8?B?clJMY1dTOVRsWFZTbG85dTk4cDQvOUs1dlF4VjJRejJueWFySU95ZG1YMFFy?=
 =?utf-8?B?MndhUDlvckR0VW43cnNzK3hNOVE4RmJBOWF6QTFvT1VxOVVMTmFZT1hYRWVK?=
 =?utf-8?B?c0t6VWg5TGFjMlpvT1pYamVEWE1FZ0xndHgva20wSUgrYWRIVjdGbGRxT2xE?=
 =?utf-8?B?dVNZQmxZV0Y2WkMzeFZxYzNqakxTL2QzSWhhQnhtTjlUak1mQXpTeERJd2pE?=
 =?utf-8?B?RDB0V1ZGZW1haW5ZZFNodEF0MXlubVpXNk9WKzV3eksweFAvS2hwU2hsbUts?=
 =?utf-8?B?bkVYNlltZWtNTEErNGw4VmJQL0sxRHVYZ2xKSXRuVzZpbXlXU29YS2kwOUUw?=
 =?utf-8?B?WXRrN1BxeGxQa2VKSnJYMDBSZElUai9aSU56ekI0Zm0rQ0ppSTVQck51aXRn?=
 =?utf-8?B?Mlhncy83ZGY1NGp0c0k5Q3hsdk81OUlSTVJPYWNzWUtseEVSM3p1ZTgwSmVJ?=
 =?utf-8?B?eXhPWVNvMGFuTDR0dEY1WWRidDU5M1hQTTJwQjRLbFlNenNtdEpOR2U0U3Fr?=
 =?utf-8?B?MmFhYkZHWEtEK09uZ0R6M2JTRDhBOStINWNNRFc4ZFZ6WVAraEVlT1paNSsx?=
 =?utf-8?B?NU4zeDU0eWdOc2xMWG1MTjY5N2JSZ3NSWlRDZU5HMTdhMDZhN1pSRUtDREdT?=
 =?utf-8?B?MkN0NEwzWWhBcHIzR1R0Qlhya0diMlVRYm13SmNqb1ZMcWp3Q0JKajQ0MlNU?=
 =?utf-8?B?bjRIM2VpSXg5WTZiVmtSeGxIY1BadUVxK1lPTzFLS1EwdjBVNkxyL2xjSndl?=
 =?utf-8?B?VEFvanUwUWlWY3U1elVqbXp4a0crdkhHZVh5ZldIc0FrZTJMWFpVejVpWXFr?=
 =?utf-8?B?SkNiSlZ3cFFUb1YwZHIwOVhFTG5LOEtkT0RSMmRzRWhub00vZ0RxNEc4MmY5?=
 =?utf-8?B?U3ZRNk1OR053Q1B4Mzc0T2dxV2pzdVNPODZrWS9ZazBJMFQ3UFN3RytDbGVr?=
 =?utf-8?B?Uk9HQnA4WlZSSEZybjNpRUlwaWdzQ0tqZTlocUsvRUpLcTU5RjNIN2N2Y2c0?=
 =?utf-8?B?bDJic0taMlRRWWh5cGpHTkVZS3I0Q2lVZWR5VVdrRlI4V01oQzdtTWErWEI4?=
 =?utf-8?B?Yk5OWnY4UUh3bzRMbDlBVktlVkNUSWprb2lpM3Yrcmo3eG9UYzRESlZibGNs?=
 =?utf-8?B?citPUFF2WUZQK3RmcEFSSk9Ud2svMk5ieUR3bERkY3JIZzlPcHZmNm5WTlBM?=
 =?utf-8?B?LytqVnEwREsyOStNcXlCbER2NjVwWHlrQzdHVkFYckQ3MVRCczh3aWtRc21E?=
 =?utf-8?B?YlZyVXlydkRlMSt6dC81dy9RUGxoY2FJOXlQajQzY0lXeStGTERvMFZwc2JQ?=
 =?utf-8?B?RWVBbFNid1hIRWVTUXR4OE4rVEhZRFBuTnJVTHRUa2dBcGY3S2czTXhvWllL?=
 =?utf-8?B?TDlCSEtJcUtTTitRbWlrSW1peGhKYTcrWXZ3RE9JVTluU1Y1NW40WkFub0pz?=
 =?utf-8?B?akVBZk5HbGUwV2ZGaGQxcU5EclVITXQ2RnlUUkVqSVZKQkMwY0hLeHVteHY0?=
 =?utf-8?Q?na06xr64tIVNa7Iw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYYPR01MB7086.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68238c6f-4a14-4f46-0639-08da3189c5a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 07:01:42.2084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +LSdJPhmH9K2mxTmOPrS0QSVt05VUoQFYy7B8kYA+5OBFTaqZk4k45s7d2KySPlBWcYrFu/GjTX5U6rB20IlX417m1eglnqaM29ND8SJ4tw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6706
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpPbiAwNSBNYXkgMjAyMiAyMToxOCBTZXJnZXkgU2h0eWx5b3Ygd3JvdGU6
DQo+IE9uIDUvNC8yMiA1OjU0IFBNLCBQaGlsIEVkd29ydGh5IHdyb3RlOg0KPiANCj4gPiBSWi9W
Mk0gRXRoZXJuZXQgaXMgdmVyeSBzaW1pbGFyIHRvIFItQ2FyIEdlbjMgRXRoZXJuZXQtQVZCLCB0
aG91Z2gNCj4gPiBzb21lIHNtYWxsIHBhcnRzIGFyZSB0aGUgc2FtZSBhcyBSLUNhciBHZW4yLg0K
PiANCj4gICAgWW91IG1lYW4gdGhlIGFic2VuY2Ugb2YgdGhlIGludGVycnVwdCBlbmFibGUvZGlz
YWJsZSByZWdpc3RlcnM/DQo+IA0KPiA+IE90aGVyIGRpZmZlcmVuY2VzIGFyZToNCj4gDQo+ICAg
IERpZmZlcmVuY2VzIHRvIGdlbjMsIHlvdSBtZWFuPw0KRGlmZmVyZW5jZXMgdG8gYm90aCBnZW4z
IGFuZCBnZW4yLg0KDQogDQo+ID4gKiBJdCBoYXMgc2VwYXJhdGUgZGF0YSAoREkpLCBlcnJvciAo
TGluZSAxKSBhbmQgbWFuYWdlbWVudCAoTGluZSAyKSBpcnFzDQo+ID4gICByYXRoZXIgdGhhbiBv
bmUgaXJxIGZvciBhbGwgdGhyZWUuDQo+ID4gKiBJbnN0ZWFkIG9mIHVzaW5nIHRoZSBIaWdoLXNw
ZWVkIHBlcmlwaGVyYWwgYnVzIGNsb2NrIGZvciBnUFRQLCBpdCBoYXMNCj4gYQ0KPiA+ICAgc2Vw
YXJhdGUgZ1BUUCByZWZlcmVuY2UgY2xvY2suDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQaGls
IEVkd29ydGh5IDxwaGlsLmVkd29ydGh5QHJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBC
aWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gTm90ZTog
Z1BUUCB3YXMgdGVzdGVkIHVzaW5nIGFuIFJaL1YyTSBFVksgYW5kIGFuIFItQ2FyIE0zTiBTYWx2
YXRvci1YUw0KPiA+IGJvYXJkLCBjb25uZWN0ZWQgd2l0aCBhIFN1bW1pdCBYNDQwIEFWQiBzd2l0
Y2gsIHVzaW5nIHB0cDRsLg0KPiANCj4gICAgT2gsIHRoYXQncyBnb29kISA6LSkNCmJ0dywgeW91
IHNob3VsZCBiZSBhYmxlIHRvIHRlc3QgZ1BUUCB3aXRob3V0IGFuIEFWQiBzd2l0Y2ggaWYgeW91
IGNvbm5lY3QNCnRoZSBib2FyZHMgZGlyZWN0bHkuIEkgaGF2ZW4ndCB0cmllZCBpdCBhcyBJJ20g
dXNpbmcgcm9vdGZzIG92ZXIgTkZTIG9uDQp0aGUgcnovdjJtIGJvYXJkLg0KDQpGb3IgcHRwNGws
IEkgaGFkIHRvIGNyZWF0ZSBhIGNvbmZpZyBmaWxlIHRoYXQgaW5jcmVhc2VzIHR4X3RpbWVzdGFt
cF90aW1lb3V0DQpvbiB0aGUgcnp2Mm0gYm9hcmQ6DQogIGVjaG8gIltnbG9iYWxdIiA+IHB0cC5j
ZmcNCiAgZWNobyAidHhfdGltZXN0YW1wX3RpbWVvdXQgICAgMTAwIiA+PiBwdHAuY2ZnDQpUaGlz
IGluY3JlYXNlcyB0aGUgdGltZW91dCB3YWl0aW5nIGZvciB0aGUgdHggdGltZSBzdGFtcCB0byAx
MDBtcywgd2hpY2ggaXMNCmV4Y2Vzc2l2ZSBhbmQgaXQgd291bGQgbGlrZWx5IHdvcmsgd2l0aCAy
bXMuIFRoZSBkZWZhdWx0IGlzIDFtcy4NCg0KUmNhciBnZW4zIGRpZG7igJl0IG5lZWQgdGhpcyBj
b25maWcgZmlsZSwgYnV0IGl0IGhhcyBhIG1vcmUgcG93ZXJmdWwgcHJvY2Vzc29yLg0KVGhvdWdo
IHdoaWxzdCBmYW1pbGlhcmlzaW5nIG15c2VsZiB3aXRoIHB0cDRsIEkgaGFkIHNvbWUgZGVidWcg
Y29kZSBpbiB0aGUNCmRyaXZlciBhbmQgdGhhdCB3YXMgZW5vdWdoIGZvciByY2FyIHRvIGFsc28g
bmVlZCB0aGlzIGNvbmZpZyBjaGFuZ2UuDQoNClRoZW4ganVzdCBydW4gcHRwNGwgb24gYm90aCBz
aWRlczoNCiAgcHRwNGwgLWkgZXRoMCAtbSAtZiAuL3B0cC5jZmcNCg0KDQo+ID4gLS0tDQo+ID4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCAyNyArKysrKysrKysr
KysrKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKykNCj4g
Pg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFp
bi5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGlu
ZGV4IGRlZDg3Y2I1MTY1MC4uMDNiMTI3ZmFmNTJmIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gQEAgLTI0NjEsNiArMjQ2MSwzMiBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbw0KPiByYXZiX2dlbjJfaHdfaW5mbyA9IHsN
Cj4gPiAgCS5tYWdpY19wa3QgPSAxLA0KPiA+ICB9Ow0KPiA+DQo+ID4gK3N0YXRpYyBjb25zdCBz
dHJ1Y3QgcmF2Yl9od19pbmZvIHJhdmJfcnp2Mm1faHdfaW5mbyA9IHsNCj4gPiArCS5yeF9yaW5n
X2ZyZWUgPSByYXZiX3J4X3JpbmdfZnJlZV9yY2FyLA0KPiA+ICsJLnJ4X3JpbmdfZm9ybWF0ID0g
cmF2Yl9yeF9yaW5nX2Zvcm1hdF9yY2FyLA0KPiA+ICsJLmFsbG9jX3J4X2Rlc2MgPSByYXZiX2Fs
bG9jX3J4X2Rlc2NfcmNhciwNCj4gPiArCS5yZWNlaXZlID0gcmF2Yl9yeF9yY2FyLA0KPiA+ICsJ
LnNldF9yYXRlID0gcmF2Yl9zZXRfcmF0ZV9yY2FyLA0KPiA+ICsJLnNldF9mZWF0dXJlID0gcmF2
Yl9zZXRfZmVhdHVyZXNfcmNhciwNCj4gPiArCS5kbWFjX2luaXQgPSByYXZiX2RtYWNfaW5pdF9y
Y2FyLA0KPiA+ICsJLmVtYWNfaW5pdCA9IHJhdmJfZW1hY19pbml0X3JjYXIsDQo+ID4gKwkuZ3N0
cmluZ3Nfc3RhdHMgPSByYXZiX2dzdHJpbmdzX3N0YXRzLA0KPiA+ICsJLmdzdHJpbmdzX3NpemUg
PSBzaXplb2YocmF2Yl9nc3RyaW5nc19zdGF0cyksDQo+ID4gKwkubmV0X2h3X2ZlYXR1cmVzID0g
TkVUSUZfRl9SWENTVU0sDQo+ID4gKwkubmV0X2ZlYXR1cmVzID0gTkVUSUZfRl9SWENTVU0sDQo+
ID4gKwkuc3RhdHNfbGVuID0gQVJSQVlfU0laRShyYXZiX2dzdHJpbmdzX3N0YXRzKSwNCj4gPiAr
CS5tYXhfcnhfbGVuID0gUlhfQlVGX1NaICsgUkFWQl9BTElHTiAtIDEsDQo+ID4gKwkudGNjcl9t
YXNrID0gVENDUl9UU1JRMCB8IFRDQ1JfVFNSUTEgfCBUQ0NSX1RTUlEyIHwgVENDUl9UU1JRMywN
Cj4gPiArCS5yeF9tYXhfYnVmX3NpemUgPSBTWl8ySywNCj4gDQo+ICAgIFdoYXQgYWJvdXQgLmlu
dGVybmFsX2RlbGF5IGFuZCAudHhfY291bnRlcnM/DQpyei92Mm0gZG9lc24ndCBoYXZlIHRoZSBB
UFNSIHJlZywgc28gLmludGVybmFsX2RlbGF5ID0gMCwgYW5kIGRvZXNuJ3QNCmhhdmUgdGhlIFRS
T0NSIHJlZywgc28gLnR4X2NvdW50ZXJzID0gMA0KDQoNCj4gPiArCS5tdWx0aV9pcnFzID0gMSwN
Cj4gPiArCS5lcnJfbWdtdF9pcnFzID0gMSwNCj4gPiArCS5ncHRwID0gMSwNCj4gDQo+ICAgIE5v
dCAuY2NjX2dhYz8NCk5vcGUsIG5vdCBvbiB0aGlzIGRldmljZS4NCg0KVGhhbmtzDQpQaGlsDQo=
