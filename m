Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1390260B6B9
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiJXTIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiJXTIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:08:30 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on20716.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::716])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF70329CAB;
        Mon, 24 Oct 2022 10:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdKd16mWorGiDTpU4jE6HSDSGloipJsIuo27ZhB/MrLgGc+4Af+C7j0jb+zU7dTtw/GLLb2s3TsdPnNo/GwWb9CqED9+GanfQbJdZHQ9gB8F3STUI9iNVi3FzHcC5MqUWVBMZRLfgiuz6UvYtTj0a2ct/9nw1bOb2Bib4hal72Jtnz27r5MnfG/qmX7tUCImsmHUYmRpGxJ7ewv9geS7uD10GjvVGq+kurad0ENatc4sGPbizPqNbSoI8Cja0dBlQORatJKJnvGh+gXemjS8w7zlnl4qVZt8yr7AYIOevY/Dtph2JF55TuZQpc4dfAratl+ruaALbfDnpmj/7vbaJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4gX4Xzkr7mbteIhahmD9/C9SGR5wIUs5Ab4WDSmVPE=;
 b=PxIvW7rD0Sy5YCyKRzr3kxtaTT91S576iUmQqYyQ5SHSCifpDqSi3mdf/I7ptWPezFKuDqNzAfiyjuSIe/a2CiAKyZPem7I10J3Pug2T5rNT8JDdFeZAETdDPVNMXApVu2p5MVS2IaGzVa83MD10QSERD/4tJvLgBcmSbhGLAPtBqOXMUgFx47dd6iq60ADgBUGx6XS5rAuxvkBDKznm0Bkjxbp1GKMvS5yTSnsCobBVlXQ898fr2VpJ1ORITpq4F+syX9y5TH39u9Fiq8hXX5rNjuzmFeAO6tMsN5x3FLqKI8l6WmxPIvyqiPt6jpeUUOB/BEDfQYIScW0CSuRpyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4gX4Xzkr7mbteIhahmD9/C9SGR5wIUs5Ab4WDSmVPE=;
 b=cPkxC97J4BheuQiD/sfFS3VYdiKooRpvVh3Jxp/IzhB48cYvjkcvitecIrkV3RpUanchRma7/QEbeJZDx/kR+uX7+VR13kB13HT8BCk1mMrIcBENoEGnEsWdsCt91/ReQ5lQFIbd9QlqgOTGh6rNaCGe7xhmJOtuk23y6wYruvI=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB8495.jpnprd01.prod.outlook.com (2603:1096:400:173::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Mon, 24 Oct
 2022 17:46:11 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Mon, 24 Oct 2022
 17:46:05 +0000
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
Subject: RE: [PATCH 6/6] can: rcar_canfd: Add has_gerfl_eef to struct
 rcar_canfd_hw_info
Thread-Topic: [PATCH 6/6] can: rcar_canfd: Add has_gerfl_eef to struct
 rcar_canfd_hw_info
Thread-Index: AQHY5gXl7pCMlngFIEKI2bQeSzUzv64dplSAgAAo/iA=
Date:   Mon, 24 Oct 2022 17:46:05 +0000
Message-ID: <OS0PR01MB592206905C515C449EAC5EA9862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com>
 <20221022104357.1276740-7-biju.das.jz@bp.renesas.com>
 <CAMuHMdV8MmTMMPnCGgXbZZ-gb4CVduAUBBG3BdAecBrc3J7RLQ@mail.gmail.com>
In-Reply-To: <CAMuHMdV8MmTMMPnCGgXbZZ-gb4CVduAUBBG3BdAecBrc3J7RLQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYWPR01MB8495:EE_
x-ms-office365-filtering-correlation-id: 2245b41e-92de-4e33-30d0-08dab5e7a028
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vdKNwxqj6IBawX1CeNqzvFOtF8IaTO8hVflI/ULecEj282Ze+UnxPWHVmIMMRAIG2UA+cCr2fw3NIPrL5usB/rzkuxL8fd03K2c9QV7ofNAZK9jb0gb4pBfu/es5QGKf1fEw759cnVa/P/qcU93b0eqKaA2k2SjaRO0gVZn07zAfyx3b5YJBAn7u06kpqmfoD/sgs3t3VbV1PfN+U11gfnKdTqZjXVPGgqROQvCnKxvXD7jHBwvOp152yyAiGYMGQPF6swWu/Ke7sSE+sG9ZWlHadpdODKHF6eifIEP4mmM+biBLNMDULaH+vrbhMrHaUPftdj3ZFGsEkQKcY4u/q+TfBwF4JDy+JrlL9Z4Ev1gh5h/jynPDT8VacJpPNXABePqCz3xzsJTwSk73KrUzDGzlDaGDDGEA4KQuFBHK+GWW/yyVgiZkQX1ViBjVXYy3dLk3hP+yy7NBM7UvwPCS/X6yaperDO/R0e7L5AZRjmmU0IVqH7VRAfkeqdha474KYHYsJMh6AExdq3j5bgK9dXVAANqtSlqkwE5VXCt74CButxyoEbD2AeK38YXgiy+HzGEjktDgzqr3naO3YfnMsqZKntUGiiQC/tOU7GAH3A6+tD3gxnXWgj+AHiMoDl+CTjm37K19vuvWCYzGFivGArrLOPEe7UxF6mCNxYY1novltkaspETlCInIOJVc8fRq2YSmAiHySVjbxTN2OJ2YOv1Ht9JC5Aa1J+Al/SS01i1Jo44BPA7RxYti0ZRoukIh3fS50LjORfUOHtZv4U77xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199015)(38100700002)(122000001)(478600001)(38070700005)(6916009)(316002)(55016003)(54906003)(9686003)(26005)(4326008)(76116006)(66446008)(8676002)(86362001)(186003)(41300700001)(71200400001)(83380400001)(53546011)(2906002)(5660300002)(52536014)(8936002)(33656002)(66556008)(66946007)(7416002)(64756008)(66476007)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blc0bVl0eTRQOUZHcWoydTIySUUvRVh5K0g2ZWZLbDFPNzl0NDFwUkptSVlZ?=
 =?utf-8?B?azBDTHp4VDNKd2dFbjE4N0tobmk1c1kvcTNXK1ZXUThqc3o3ZHA4Nkw2SlQx?=
 =?utf-8?B?WWNNTlNIS2tQRVZuYlNRb3A4QzZJYlJjRjVMeENsSXFZa2hvM0w5eEdlTnl3?=
 =?utf-8?B?M1RMSHNjVldzN0pWYkRycU1SdU9HV3Z0Nkh1ajh5TmRZNldMdy9oT09SdjBU?=
 =?utf-8?B?RGc5SDBhd1FtVUZ0ek0yV2VvZCtpQTFLQlVCcW05bEFnWnFETEFYYU53MU1n?=
 =?utf-8?B?VDN2eG1BNWxScnFTMDVkWkk4SjFSRmlHaHJXenR4b3Y2ajFhY1V2ek1LazRK?=
 =?utf-8?B?RVJGVWRhTU4wZVdkck8rUGh2ckNEVW8zd3pqUmZ0alhVM01oN0lEaXk1T01y?=
 =?utf-8?B?dUF4NWxBUzkyQ0wzcE5RUXJxK0R3dEk1dFE3NFdFaTIxMWw2VHU3R1B3bGtx?=
 =?utf-8?B?YUk3L1czTHFocE1XUy92c0hwNXR4dTNTSXFmUHVtbWU2L250ZlZmYWdtOHZE?=
 =?utf-8?B?bmRlZWk1dUVJWk5ybjdaQ0dJNFNNVnZZbm02em03bTdlNVhoMkxVbVlxYkw3?=
 =?utf-8?B?d2tnSDZCbjB0dGVNRzI3dkRUZzkxMC9xVitITmRNbitBaHJtWmxXbTlydTFR?=
 =?utf-8?B?Z0VKcGh5aDVTTTJ0UDZWZmZhRHdVTERkRWZEN0ZrbjRCRVcvKzJscmQ0TmNU?=
 =?utf-8?B?WmJCT00yK2JRNytCS1NyWnBYeGhLYnVRSXFMMTFvOHZUaURKWHBpb3U4SDhF?=
 =?utf-8?B?NEZ6UTJPbjZqVlc4ZzFYZSs0MFcwQWx0TXYrTDErMHB4QTNHTmRUWm8yN2I2?=
 =?utf-8?B?Yjd4TEFicGRvMzI4MmpNR2NqRGd4dnR5TVJPUFNIZmM0dCtrZ2VZeGJYYkFS?=
 =?utf-8?B?SndZQmY5VktOYzV6aTRXMG9aeDBCbFQwc1RCTURJcnA2K3hNMldTWVc5YVk5?=
 =?utf-8?B?eGVqbnMyc3ZIMW9jb3ZUcXZFU2Y1ZVIyZDZxYmtSUkRYNlRrR2x0RjRYRzVP?=
 =?utf-8?B?dExmaTYzSGlhdXBDRzhaT21OMXhFVlVNYm51L3hJSzVIdUlNVWR6a1NCM3NM?=
 =?utf-8?B?ckMvV2RmYU4yUVY3cGwwR1hobkRIWnpzMEY3eGJjbVF3SUdXdHdVRXEvN2tr?=
 =?utf-8?B?ci9LYzYzVTdNUm5yN1l3UUFiT210c2dQYVBaT0c0VTRPbkUwSHFERlo3a0x0?=
 =?utf-8?B?NGk3NXJlQ3NhbzFTSDROa2NyTkJXS0VyVUJkMXduNFA4cnBaNlRJWkZuTmZS?=
 =?utf-8?B?OHdsaDJDNmVJTE4yYWp3K2djSVBJcEVuSStMZ2trMmh1UEZNdEt0ckdubmlS?=
 =?utf-8?B?NVdKUDhKSmtXcldySE9TVks0L2plQ2FPSEJTeThybXdxMW5XNjhINzhPUTVj?=
 =?utf-8?B?ci9SYjRXTmVKYUdRKzNFUG5hQVRuM2ZnU0FYMGUrano5Mmlxbm0zdkQwNzdW?=
 =?utf-8?B?NVpJZ0xUM3hKc3B1dDRpY0JmYjVOU1ZxK3U5YU4wcUZzcXZoS1hpYWpzaUV4?=
 =?utf-8?B?UUNjenJFSkVmOTRERFFMaVlLdHhwUzBISkhWcCtjUmE1ZFV3dFJPZEFUTDMv?=
 =?utf-8?B?UlFUZURScDVpL2NGNzREbWNrbnZUNnpZTEUxY0pLV3JGbjdLUmFaKzJ3NDlD?=
 =?utf-8?B?a215Q211NmU2UmJNSnlFVW1FMDlmSkhUVW5aVFBpME16T1VKUFliNURydHh1?=
 =?utf-8?B?ZFBUWThHZi9XdG9DcDIwRGVydXRveFl0ekcwUFoxbE5hNG1QWjdBYllTWUtH?=
 =?utf-8?B?d3VZY1ZDU28wMU42eUl6K2RSTFN0eHJvSnlacjRwVjdWWlJDMDFiMUJSUEJa?=
 =?utf-8?B?VVlrUlJUcDhIUlljMlprVTBsL2t5VURCbkRpdUxXSjNBZ3BzOHFSeDQxQjN3?=
 =?utf-8?B?ZE5iaDl1Ym0xcHh6NXcyaTdzS3hZV2g3Yy9JWGVrcGlTczRIbnoraHlvRkU0?=
 =?utf-8?B?WFlqZStVNVhnOTQ5QmN2aGVGZEhVWW41ZGF3UnlUZjcxNjRXU3VKbzF6aG5G?=
 =?utf-8?B?bm9RNngxdnlnUTJFOW4wNEdOVGc1dWNyZnJRU2d0elplQkpMN2lHMThrNmR3?=
 =?utf-8?B?N3JOMExyMDFUSm9YS3NMSFRHMlJBS3NPZEdxS2RrTzdhWE5YeUk5Qk45REdG?=
 =?utf-8?B?MExZcU54bWR6MWJZcDQxZmFRSmpmVFU4UnVSaFJtbjVtckV3bk1qazZQMTlL?=
 =?utf-8?B?M0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2245b41e-92de-4e33-30d0-08dab5e7a028
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 17:46:05.4938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LaxCTveuD9Ul+9bDmurw50MNuce+QXcs0QTtUdFHc1bHyJpD93+XfoNp2j5GZlJNamGgUtgMMt/k/XYidJghzTcovh0/BnnIypfhGbglTXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8495
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggNi82XSBjYW46IHJjYXJfY2FuZmQ6IEFkZCBoYXNfZ2VyZmxfZWVmIHRvIHN0cnVjdA0K
PiByY2FyX2NhbmZkX2h3X2luZm8NCj4gDQo+IEhpIEJpanUsDQo+IA0KPiBPbiBTYXQsIE9jdCAy
MiwgMjAyMiBhdCAxOjAzIFBNIEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4N
Cj4gd3JvdGU6DQo+ID4gUi1DYXIgaGFzIEVDQyBlcnJvciBmbGFncyBpbiBnbG9iYWwgZXJyb3Ig
aW50ZXJydXB0cyB3aGVyZWFzIGl0IGlzDQo+IG5vdA0KPiA+IGF2YWlsYWJsZSBvbiBSWi9HMkwu
DQo+ID4NCj4gPiBBZGQgaGFzX2dlcmZsX2VlZiB0byBzdHJ1Y3QgcmNhcl9jYW5mZF9od19pbmZv
IHNvIHRoYXQgcmNhcl9jYW5mZF8NCj4gPiBnbG9iYWxfZXJyb3IoKSB3aWxsIHByb2Nlc3MgRUND
IGVycm9ycyBvbmx5IGZvciBSLUNhci4NCj4gPg0KPiA+IHdoaWxzdCwgdGhpcyBwYXRjaCBmaXhl
cyB0aGUgYmVsb3cgY2hlY2twYXRjaCB3YXJuaW5ncw0KPiA+ICAgQ0hFQ0s6IFVubmVjZXNzYXJ5
IHBhcmVudGhlc2VzIGFyb3VuZCAnY2ggPT0gMCcNCj4gPiAgIENIRUNLOiBVbm5lY2Vzc2FyeSBw
YXJlbnRoZXNlcyBhcm91bmQgJ2NoID09IDEnDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1
IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+IA0KPiBUaGFua3MgZm9yIHlvdXIg
cGF0Y2ghDQo+IA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJfY2FuZmQuYw0K
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJfY2FuZmQuYw0KPiA+IEBAIC01MjMs
NiArNTIzLDcgQEAgc3RydWN0IHJjYXJfY2FuZmRfaHdfaW5mbyB7DQo+ID4gICAgICAgICB1bnNp
Z25lZCBtdWx0aV9nbG9iYWxfaXJxczoxOyAgIC8qIEhhcyBtdWx0aXBsZSBnbG9iYWwgaXJxcw0K
PiAqLw0KPiA+ICAgICAgICAgdW5zaWduZWQgY2xrX3Bvc3RkaXY6MTsgICAgICAgICAvKiBIYXMg
Q0FOIGNsayBwb3N0IGRpdmlkZXINCj4gKi8NCj4gPiAgICAgICAgIHVuc2lnbmVkIG11bHRpX2No
YW5uZWxfaXJxczoxOyAgLyogSGFzIG11bHRpcGxlIGNoYW5uZWwgaXJxcw0KPiA+ICovDQo+ID4g
KyAgICAgICB1bnNpZ25lZCBoYXNfZ2VyZmxfZWVmOjE7ICAgICAgIC8qIEhhcyBFQ0MgRXJyb3Ig
RmxhZyAgKi8NCj4gDQo+IERvIHlvdSByZWFsbHkgbmVlZCB0aGlzIGZsYWc/IEFjY29yZGluZyB0
byB0aGUgUlovRzJMIGRvY3MsIHRoZQ0KPiBjb3JyZXNwb25kaW5nIHJlZ2lzdGVyIGJpdHMgYXJl
IGFsd2F5cyByZWFkIGFzIHplcm8uDQoNClRoZXNlIGFyZSByZXNlcnZlZCBiaXRzIHdpdGggMCB2
YWx1ZSwgQnV0IGl0IGlzIG5vdCBkb2N1bWVudGVkIGFzIEVDQyBFcnJvciBmbGFnIGZvciBSWi9H
MkwuDQpTbyBqdXN0IHdhbnQgdG8gYmUgY2xlYXIgaXQgaXMgYSBodyBmZWF0dXJlIHRoYXQgbm90
IHN1cHBvcnRlZCBmb3IgUlovRzJMLiAgDQoNCj4gDQo+ID4gIH07DQo+ID4NCj4gPiAgLyogQ2hh
bm5lbCBwcml2IGRhdGEgKi8NCj4gDQo+ID4gQEAgLTk0NywxNyArOTUwLDE4IEBAIHN0YXRpYyB2
b2lkIHJjYXJfY2FuZmRfZ2xvYmFsX2Vycm9yKHN0cnVjdA0KPiA+IG5ldF9kZXZpY2UgKm5kZXYp
ICB7DQo+ID4gICAgICAgICBzdHJ1Y3QgcmNhcl9jYW5mZF9jaGFubmVsICpwcml2ID0gbmV0ZGV2
X3ByaXYobmRldik7DQo+ID4gICAgICAgICBzdHJ1Y3QgcmNhcl9jYW5mZF9nbG9iYWwgKmdwcml2
ID0gcHJpdi0+Z3ByaXY7DQo+ID4gKyAgICAgICBjb25zdCBzdHJ1Y3QgcmNhcl9jYW5mZF9od19p
bmZvICppbmZvID0gZ3ByaXYtPmluZm87DQo+ID4gICAgICAgICBzdHJ1Y3QgbmV0X2RldmljZV9z
dGF0cyAqc3RhdHMgPSAmbmRldi0+c3RhdHM7DQo+ID4gICAgICAgICB1MzIgY2ggPSBwcml2LT5j
aGFubmVsOw0KPiA+ICAgICAgICAgdTMyIGdlcmZsLCBzdHM7DQo+ID4gICAgICAgICB1MzIgcmlk
eCA9IGNoICsgUkNBTkZEX1JGRklGT19JRFg7DQo+ID4NCj4gPiAgICAgICAgIGdlcmZsID0gcmNh
cl9jYW5mZF9yZWFkKHByaXYtPmJhc2UsIFJDQU5GRF9HRVJGTCk7DQo+ID4gLSAgICAgICBpZiAo
KGdlcmZsICYgUkNBTkZEX0dFUkZMX0VFRjApICYmIChjaCA9PSAwKSkgew0KPiA+ICsgICAgICAg
aWYgKGluZm8tPmhhc19nZXJmbF9lZWYgJiYgKGdlcmZsICYgUkNBTkZEX0dFUkZMX0VFRjApICYm
IGNoDQo+ID4gKyA9PSAwKSB7DQo+ID4gICAgICAgICAgICAgICAgIG5ldGRldl9kYmcobmRldiwg
IkNoMDogRUNDIEVycm9yIGZsYWdcbiIpOw0KPiA+ICAgICAgICAgICAgICAgICBzdGF0cy0+dHhf
ZHJvcHBlZCsrOw0KPiA+ICAgICAgICAgfQ0KPiA+IC0gICAgICAgaWYgKChnZXJmbCAmIFJDQU5G
RF9HRVJGTF9FRUYxKSAmJiAoY2ggPT0gMSkpIHsNCj4gPiArICAgICAgIGlmIChpbmZvLT5oYXNf
Z2VyZmxfZWVmICYmIChnZXJmbCAmIFJDQU5GRF9HRVJGTF9FRUYxKSAmJiBjaA0KPiA+ICsgPT0g
MSkgew0KPiA+ICAgICAgICAgICAgICAgICBuZXRkZXZfZGJnKG5kZXYsICJDaDE6IEVDQyBFcnJv
ciBmbGFnXG4iKTsNCj4gPiAgICAgICAgICAgICAgICAgc3RhdHMtPnR4X2Ryb3BwZWQrKzsNCj4g
PiAgICAgICAgIH0NCj4gDQo+IEp1c3Qgd3JhcCBib3RoIGNoZWNrcyBpbnNpZGUgYSBzaW5nbGUg
ImlmIChncHJpdi0+aW5mby0+aGFzX2dlcmZsKSB7DQo+IC4uLiB9Ij8NCj4gDQoNCk9LLCBjaGVl
cnMsDQpCaWp1DQo=
