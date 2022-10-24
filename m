Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E72B60B711
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiJXTQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiJXTPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:15:35 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on20705.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::705])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43866C90E8;
        Mon, 24 Oct 2022 10:53:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lV5/VxRIcen3y6aMkD8jlHPo05WW58TAJoloFb3d32180uPFkH8hS/9k+bo+O55Yfs1EJotnZWxhRG9oPUVMlri9in0OkUaCLzW5UQzpgdSgGEH6IwIVUpoIjw+mGk0MXJx15UYbrqTTaCjEYtIOT8M0YfWntAWihXYvqn2ctTEbYmgE5lYcokL4wEs1OiOkT3ggHViYu1uCoNYqzurqfOper+SSn+zHeTZjO7W1PwDGrYxpTz5weVGuQFgKcYiZSG1TtIlBOCvdKG60Krw2DivHjaN9vYtF7KoubxxV8rL33tnmn2jarpkuxrA1h4vWQDxjSxxzBL3bSd1wYQBIZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b8W6WkWuEos2mq2WCJNNreScJfrin5/6m4W6xjAP6Tw=;
 b=hZl++4a/FS9qsNwKevIFK54bTaT+ZlPqdhabKF4N1WeTE7KiW757b1+KaHxtVff2s/wJk/x5qKnm99vt7aikmPTexRhuwUSjEcZ0tZ7+J6wljw2NhGevVkPZBl+xHD927FVCMujqEuYUuaZW5rybOr/nmQbGLqSPP1cFUI4rRtgWfwGJlXH6tvoSRMn9fmnFs44IEreHg3/al1BIM+G63RxK5ay8+0HsDdVJRfGLvfHvcgHkBH0qUvxSvFxdS10zUe31RpPyolm1WrXEMySDus2UAM9h0tidJM4ZiEIAq/kLfwywOpAaezm6yOYDbSNvImxske9WHCi4aGQV2CEkhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8W6WkWuEos2mq2WCJNNreScJfrin5/6m4W6xjAP6Tw=;
 b=EQ9/5nbscWmdkPergqqRqMOUPWBbkXIr4+iapgPPkKIgmTVc7p/3rfP767g7h4oUdknM6sZSorTMVzh6jPZXOO6EkBkm81XwnoETasEPDgyaB5RbahesJiNPZG1udbVtvbJagka9tRqvvZqxEfVPuerP3k97ALXW7V4PrDhQevg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB9940.jpnprd01.prod.outlook.com (2603:1096:400:1d6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Mon, 24 Oct
 2022 17:19:45 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Mon, 24 Oct 2022
 17:19:45 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
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
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 3/6] can: rcar_canfd: Add multi_global_irqs to struct
 rcar_canfd_hw_info
Thread-Topic: [PATCH 3/6] can: rcar_canfd: Add multi_global_irqs to struct
 rcar_canfd_hw_info
Thread-Index: AQHY5gXarUvbGZpYMUS/fHtE1K83YK4domGAgAAqxhA=
Date:   Mon, 24 Oct 2022 17:19:45 +0000
Message-ID: <OS0PR01MB59225D99286C9CDAB20B25F7862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com>
 <20221022104357.1276740-4-biju.das.jz@bp.renesas.com>
 <CAMuHMdVeVSdk1-gZ9Fv+kPSJ2q8hyjBArjKpqtfRyXjuTmMFsQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVeVSdk1-gZ9Fv+kPSJ2q8hyjBArjKpqtfRyXjuTmMFsQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYCPR01MB9940:EE_
x-ms-office365-filtering-correlation-id: e365f1ec-36eb-43bb-8d53-08dab5e3f246
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OFfq5Ry/E4/8xbqQTIUoOLFDU5XoXBB4NGL4TaxvcamQgXqWCFPwDdzFI/QjE8JSHxLEZN6g40jD3OqvjVp30rHfRiUVpXMysnAuS4eJ3c3P2hCbficfNnyfq/2YBx6j1y4B1G1OXXzMCwTcsVsLn7PkBT3+Bd7YoPoLNcqIyrMpgn0y0Kd3WPgTW/iHutyRvX5xyUT8iutCpYs2dPt+atHeYxdLg7VS4A8387KKN09Iyw7K+/TwdT+z9qI69xCsXq2JFsZe52CCL2/Jgx2zheGAx8EDfSR+83gjiJc5U/FR6tnUZc+iyWNIoR30b+mmWV0Wzx4iZQiLi63Fy5EzqqTNIVq2iB6rWQrt10cyqcJ9QUzm8/bTeI7OcM1SELES7RSnVKWgaROZu8PlE8Xz8kDTL49WzuCcnMkYsQwnoNDgVVBTo78YxnAYCPpHA+BZS8Bq8pxfhtFjg+99erhyRMHcIsiNqm/6Q9Wk8bU/ww2sdeox9RKJ7ygBGuRP7eTadxLdQ+esNlS4UDs3RAQwfUd145wJkI9amK5JJSRm9OwUDPC3BuqAEjOU9lXeyZNu03D30priTwiGOx0NWFBEwydcCpyki8DC2jrvJFkqaKGjckGPHOWSc6dmYqXeSnd4rjkb3lS8n7KFeOQA/ECxjk44h6E+c0CUuDBE4TvWzTsBXdwTT3m2sSD/npLgVosu9Rcr4cPPT7xpfpqJS/FBilYIjK769q0GbYNcwvxLc8rtuUIOO/2w1SNRik5a7ewb8S0a0WGNpLzvGeMGw5AmuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(38070700005)(83380400001)(33656002)(86362001)(38100700002)(122000001)(8936002)(52536014)(5660300002)(7416002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(41300700001)(8676002)(4326008)(2906002)(53546011)(7696005)(6506007)(26005)(186003)(9686003)(54906003)(6916009)(316002)(478600001)(55016003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2JweUQ2U25lOStjSkV5ajlRWHE1MjhzVHg2enhiSVpwRWNIZ0dEMmJWSzdT?=
 =?utf-8?B?NW9ZbXg4OEduMmdzRi9hMHowUTZSZkgvMTBSY01vU0o2aGZJNk9XUGxzY3Nm?=
 =?utf-8?B?NHZURzJuaE5SQjhsdk5Sbk9MdmdQRXR2bXdVL3Y3dXMwQUJQeGlHSi9CSzAz?=
 =?utf-8?B?cVVudHlwc1lvdGdrTFhuMXBHNVdMa1M5ZXZzZDJRMEcvYVBnMUdQajkxdlNC?=
 =?utf-8?B?ZGw0TWdpa3BEZEE4clZCdW15OUFjZ2JVV29mQWJLQno4ZUN5dHc3T3RZbGhH?=
 =?utf-8?B?MzlNeUc0cXEzdGhDUktmZE9xeWJ2VVlyUkhORUlRTU1YblQxS3ZWQWRJanc3?=
 =?utf-8?B?d0pUYmJydnp1cXFMb1A2bmtqb2c3WXhKRTR2N1BvUGpSdHpWem1TdStDWTVs?=
 =?utf-8?B?U1g1QXhET014YlNlN3hhbjVzNEJRamVLL2VkUWxsZEZPUFVPZ0c3clJ2OXp4?=
 =?utf-8?B?WWZ4ZHI4em1LejRIdHdydFMxSHE4dUt1b0FQbkw3VzhLaFBNNWxqWUtYWTFu?=
 =?utf-8?B?b0NxUlp1T2J6OVprRWxIZ3JqQ1lVbDVndk1hSHZCekx3dXhoOE9UUG0rRXdJ?=
 =?utf-8?B?RUp2VHp6VFlmdis0dE1HM3Rhb1AzZVppeVlkcGNRU1RWSDYyMWptTkptWnE0?=
 =?utf-8?B?YXJrWitpZ2tzbGpVamg4TUpwYnJKRDhueGxNdGR1L3pISzQ1VGZFU1h4d0tZ?=
 =?utf-8?B?R0ZpV0ZtRlFzRUNDQzh0SHpKcGJ3Y2doeGpjK2JlTGk3eDk0b09Jd3NzbW9h?=
 =?utf-8?B?OVRmRVNWY0RsZm9ObUhhYmgyb0l4RjlFUkxaQXpqc2FIaFg4M0Z0akVvcVJj?=
 =?utf-8?B?OUpid2dPeER2cW4rVENPMnZMWFgzeldPV1NxUDM4SmtwTEozUGFrdUQxZXFW?=
 =?utf-8?B?elB0QmRlaWtsOGVxdlRURGVFckNJOGh4L0RQR0loVnV4M1dJODc2MnN2RDFp?=
 =?utf-8?B?NnQ4Zkl6b3QwNlkxbUJRTjdBNmRYcTM2M3BjQXdJMGJXNjJUdHo3dmx5TFpP?=
 =?utf-8?B?N2FEYndJZFJIQ0orM3Q2VWxJOG4wbVVzeWtvaUhZQ0U0d1dJZEM4TXhLVHNE?=
 =?utf-8?B?V0FLYWdXcnFQa05oMDBJMjJBM0RBVisrdHJLdkdWVS9HZjFxdndJNFhaVzN6?=
 =?utf-8?B?QnlnTzdTNlphZmZLcHJ5M0x2aEo3OXlTU3VVd0Q2RU95WlRPZDkycFZHeElt?=
 =?utf-8?B?LzZOelZSR2ZqOWtJTnVzdlI3V1NVTFpBd3JUQ1hxM3ZmTkJMRy9sdnZCV1RM?=
 =?utf-8?B?ME9QaEpRVStXUFBWbUtNdjJYdW5zVGthcXdTQTIrdEdRdXQrZWFvZGM4SndG?=
 =?utf-8?B?WjhBRlgxU0F0QmZWdythUEVLS0JuQmhRTS8rQlk1dDJuek93dHYzbzhPdlJv?=
 =?utf-8?B?WXBqY2dhbVB3NUVZZVhDOGNIcmQ3TVhpNTN6d3l4VkZZVXJOVkcwM0dLeE1F?=
 =?utf-8?B?TklFczVUWnpFSjBWZG1tZkdXNnB0b1g4L1ZoZmZ6WVhabWtkMEtJZC95U2tq?=
 =?utf-8?B?YXZtcWk2ekZJZytFQ3hCRmptSzZ2dnBucEhhblBjUXFKWVcycWVhN05SZlAy?=
 =?utf-8?B?QU1CMVlIQlVzOUJhTmI4eEhxazB6VnJ3aGlSK2pFYkkvSGZ6MUpLcVdiRlVu?=
 =?utf-8?B?cm5jbVVTRXljWHdKODRRWjN6dXhSMHdXTi9lNDdZV21NOVhvRWFrUDJiRGsz?=
 =?utf-8?B?aHVMMDJObDhpT08rYWduZHY2UVRRZkpjRWNhRjJPVEdEYy9JazdjWDFoL1Bv?=
 =?utf-8?B?RmpzenNTM3E3ekRsM1dXOW9PQWtxYkpSMkxwQ0lyem9uZUZ5SzhsLzYxY0N4?=
 =?utf-8?B?Mkt2b0pOejBDcVFtYThXYzNGMHpEUFIxQWVxZlNhZ0RpaDBOd2x5WUQ5VVBu?=
 =?utf-8?B?RXk5SStPdTZlVkZXM3lGaWlsOEp5dXFTRWhnNzl6WWxMZlM4Si8wVzhkeC9B?=
 =?utf-8?B?WHZONk5JeWhxako5VCs3MGIyYTZZNGhBYkVoUHVpVzZSWFYycDI1VHNUS1lK?=
 =?utf-8?B?dnk3STlnelpkVzB5eU94MUxWQ3h6OFRxM0JyQkQ3QXJiVElZajNWbVNuOXpT?=
 =?utf-8?B?U1RPbEhFeWZJaVY3KzR2Q2xnRm5FdncxNmVDMUZzRStMVFZuMHY1N0hWT29a?=
 =?utf-8?B?cktHdDNLZy9YSkJkbjRGeFZta3h2bDhSa1FBT1ExbkFlMlpYVW85cGZhbmwv?=
 =?utf-8?B?aWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e365f1ec-36eb-43bb-8d53-08dab5e3f246
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 17:19:45.2792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yAUAXOM4dvujJ368dv4YwOazpH4fyopw2fL2TiBav7FgViXD/gdP2lVqpjIyyKPrKbRpVbnQd7slUPD7+UAIcUnfaGbDAMrvIaeXLr7K0Dk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9940
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggMy82XSBjYW46IHJjYXJfY2FuZmQ6IEFkZCBtdWx0aV9nbG9iYWxfaXJxcyB0bw0KPiBz
dHJ1Y3QgcmNhcl9jYW5mZF9od19pbmZvDQo+IA0KPiBIaSBCaWp1LA0KPiANCj4gT24gU2F0LCBP
Y3QgMjIsIDIwMjIgYXQgMTowMyBQTSBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5j
b20+DQo+IHdyb3RlOg0KPiA+IFJaL0cyTCBoYXMgc2VwYXJhdGUgSVJRIGxpbmVzIGZvciByZWNl
aXZlIEZJRk8gYW5kIGdsb2JhbCBlcnJvcg0KPiA+IGludGVycnVwdCB3aGVyZWFzIFItQ2FyIGhh
cyBjb21iaW5lZCBJUlEgbGluZS4NCj4gPg0KPiA+IEFkZCBtdWx0aV9nbG9iYWxfaXJxcyB0byBz
dHJ1Y3QgcmNhcl9jYW5mZF9od19pbmZvIHRvIHNlbGVjdCB0aGUNCj4gPiBkcml2ZXIgdG8gY2hv
b3NlIGJldHdlZW4gY29tYmluZWQgYW5kIHNlcGFyYXRlIGlycSByZWdpc3RyYXRpb24gZm9yDQo+
ID4gZ2xvYmFsIGludGVycnVwdHMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8
YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+IA0KPiBUaGFua3MgZm9yIHlvdXIgcGF0Y2gh
DQo+IA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJfY2FuZmQuYw0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJfY2FuZmQuYw0KPiA+IEBAIC01MjYsNiArNTI2
LDggQEAgc3RydWN0IHJjYXJfY2FuZmRfZ2xvYmFsOyAgc3RydWN0DQo+ID4gcmNhcl9jYW5mZF9o
d19pbmZvIHsNCj4gPiAgICAgICAgIGVudW0gcmNhbmZkX2NoaXBfaWQgY2hpcF9pZDsNCj4gPiAg
ICAgICAgIHUzMiBtYXhfY2hhbm5lbHM7DQo+ID4gKyAgICAgICAvKiBoYXJkd2FyZSBmZWF0dXJl
cyAqLw0KPiA+ICsgICAgICAgdW5zaWduZWQgbXVsdGlfZ2xvYmFsX2lycXM6MTsgICAvKiBIYXMg
bXVsdGlwbGUgZ2xvYmFsIGlycXMNCj4gKi8NCj4gDQo+IEknbSBub3Qgc3VyZSB0aGlzIGlzIHRo
ZSBiZXN0IG5hbWUgZm9yIHRoaXMgZmxhZyAoZXNwZWNpYWxseQ0KPiBjb25zaWRlcmluZyB0aGUg
b3RoZXIgZmxhZyBiZWluZyBhZGRlZCBpbiBbNS82XSkuLi4NCg0KT0suDQoNCj4gDQo+ID4gIH07
DQo+ID4NCj4gPiAgLyogQ2hhbm5lbCBwcml2IGRhdGEgKi8NCj4gPiBAQCAtNjAzLDYgKzYwNSw3
IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcmNhcl9jYW5mZF9od19pbmZvDQo+ID4gcmNhcl9nZW4z
X2h3X2luZm8gPSB7ICBzdGF0aWMgY29uc3Qgc3RydWN0IHJjYXJfY2FuZmRfaHdfaW5mbw0KPiBy
emcybF9od19pbmZvID0gew0KPiA+ICAgICAgICAgLmNoaXBfaWQgPSBSRU5FU0FTX1JaRzJMLA0K
PiA+ICAgICAgICAgLm1heF9jaGFubmVscyA9IDIsDQo+ID4gKyAgICAgICAubXVsdGlfZ2xvYmFs
X2lycXMgPSAxLA0KPiA+ICB9Ow0KPiA+DQo+ID4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcmNhcl9j
YW5mZF9od19pbmZvIHI4YTc3OWEwX2h3X2luZm8gPSB7IEBADQo+ID4gLTE4NzQsNyArMTg3Nyw3
IEBAIHN0YXRpYyBpbnQgcmNhcl9jYW5mZF9wcm9iZShzdHJ1Y3QNCj4gcGxhdGZvcm1fZGV2aWNl
ICpwZGV2KQ0KPiA+ICAgICAgICAgICAgICAgICBvZl9ub2RlX3B1dChvZl9jaGlsZCk7DQo+ID4g
ICAgICAgICB9DQo+ID4NCj4gPiAtICAgICAgIGlmIChpbmZvLT5jaGlwX2lkICE9IFJFTkVTQVNf
UlpHMkwpIHsNCj4gPiArICAgICAgIGlmICghaW5mby0+bXVsdGlfZ2xvYmFsX2lycXMpIHsNCj4g
PiAgICAgICAgICAgICAgICAgY2hfaXJxID0gcGxhdGZvcm1fZ2V0X2lycV9ieW5hbWVfb3B0aW9u
YWwocGRldiwNCj4gImNoX2ludCIpOw0KPiA+ICAgICAgICAgICAgICAgICBpZiAoY2hfaXJxIDwg
MCkgew0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIC8qIEZvciBiYWNrd2FyZCBjb21wYXRp
YmlsaXR5IGdldCBpcnEgYnkNCj4gaW5kZXgNCj4gPiAqLyBAQCAtMTk1Nyw3ICsxOTYwLDcgQEAg
c3RhdGljIGludCByY2FyX2NhbmZkX3Byb2JlKHN0cnVjdA0KPiBwbGF0Zm9ybV9kZXZpY2UgKnBk
ZXYpDQo+ID4gICAgICAgICBncHJpdi0+YmFzZSA9IGFkZHI7DQo+ID4NCj4gPiAgICAgICAgIC8q
IFJlcXVlc3QgSVJRIHRoYXQncyBjb21tb24gZm9yIGJvdGggY2hhbm5lbHMgKi8NCj4gPiAtICAg
ICAgIGlmIChpbmZvLT5jaGlwX2lkICE9IFJFTkVTQVNfUlpHMkwpIHsNCj4gPiArICAgICAgIGlm
ICghaW5mby0+bXVsdGlfZ2xvYmFsX2lycXMpIHsNCj4gDQo+IEFsbCBjaGVja3MgZm9yIHRoaXMg
ZmxhZyBhcmUgbmVnYXRpdmUgY2hlY2tzLiAgV2hhdCBhYm91dCBpbnZlcnRpbmcNCj4gdGhlIG1l
YW5pbmcgb2YgdGhlIGZsYWcsIHNvIHRoZXNlIGNhbiBiZWNvbWUgcG9zaXRpdmUgY2hlY2tzPw0K
DQpPSywgd2lsbCBjaGFuZ2UgaXQgdG8gc2hhcmVkX2dsb2JhbF9pcnFzIGFzIGl0IGlzIHNoYXJl
ZCBiZXR3ZWVuDQpHbG9iYWwgcmVjZWl2ZSBhbmQgZXJyb3IgaW50ZXJydXB0cy4NCg0KQ2hlZXJz
LA0KQmlqdQ0KDQo+IA0KPiA+ICAgICAgICAgICAgICAgICBlcnIgPSBkZXZtX3JlcXVlc3RfaXJx
KCZwZGV2LT5kZXYsIGNoX2lycSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICByY2FyX2NhbmZkX2NoYW5uZWxfaW50ZXJydXB0LA0KPiAwLA0KPiA+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJjYW5mZC5jaF9pbnQiLCBncHJpdik7DQo+
IA0KPiBBcyB0aGUgcGF0Y2ggaXRzZWxmIGlzIGNvcnJlY3Q6DQo+IFJldmlld2VkLWJ5OiBHZWVy
dCBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNAZ2xpZGVyLmJlPg0KPiANCj4gR3J7b2V0amUs
ZWV0aW5nfXMsDQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAgICBHZWVydA0KPiANCj4gLS0N
Cj4gR2VlcnQgVXl0dGVyaG9ldmVuIC0tIFRoZXJlJ3MgbG90cyBvZiBMaW51eCBiZXlvbmQgaWEz
MiAtLQ0KPiBnZWVydEBsaW51eC1tNjhrLm9yZw0KPiANCj4gSW4gcGVyc29uYWwgY29udmVyc2F0
aW9ucyB3aXRoIHRlY2huaWNhbCBwZW9wbGUsIEkgY2FsbCBteXNlbGYgYQ0KPiBoYWNrZXIuIEJ1
dCB3aGVuIEknbSB0YWxraW5nIHRvIGpvdXJuYWxpc3RzIEkganVzdCBzYXkgInByb2dyYW1tZXIi
IG9yDQo+IHNvbWV0aGluZyBsaWtlIHRoYXQuDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgLS0gTGludXMgVG9ydmFsZHMNCg==
