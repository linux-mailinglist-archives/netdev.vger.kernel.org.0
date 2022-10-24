Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898E560B989
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbiJXUOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbiJXUOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:14:03 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2098.outbound.protection.outlook.com [40.107.113.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B636CD37;
        Mon, 24 Oct 2022 11:32:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVa3oOlXZLAwc9J4wq8cS2ImH3hldOhmfXeltyQ0LGy+AamehdvFPW48Igh4eIsi/85OijR/K+Mp1fTj8Rn5k3OcfnUFJfYPkVD1dRlwHLbGPoZB1hqxuUu1en1dfalGMLfCFT99AIuQGyx9haF/xcjFrd376k28TXsima49tYV2magztMfga06bwniv92ZzXd/s0YyzwB1eHL9wvkUSFEskiXyNQFws8mmvFzP7jdsQn5Cvtydxrwa+j9bDlQkiQ9J2M0B/Syt7dBJA1vXb1eyOAmKK27wCxIS95L8GlLrTrYGuFl1aiP/LRe18m3BAhwK5zyDt8g45G7ByDDxvYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZQXkKscQl9/J2lhWJ9G91O+q8W7kc1c96DvFHGj7Uo=;
 b=GKnRlMA+Kzfu0XkCvijOXAYZC73mGWQsBfZUZQZe1U156HoG0zCKGcvfx+MxFA+VaIOnChaRfc6BP8Al4ZnvFvHmlq9x6Ol59Pm5bXDXghRbuADh7piMEmBM+jbtvqi9JYSZ3id6xnDClpHa78iwdZXXgTg89KtEgjCa36itkLItr9y4mdTB0eRD1qoQ/KPhdGjog12fDU6vrV+v2ZNYNNzpMazbHyJXWRaYvXlHh558ytOQhxhrrTdFkUkfp+ghKfwHV/NkyjEOWr4BDE5tVrsHwh/Y/L4RoD0FrefmPcK1phvY+FXDJghkiRAEiH6N3vClLoTawRoP+XSd8UpGmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZQXkKscQl9/J2lhWJ9G91O+q8W7kc1c96DvFHGj7Uo=;
 b=UHc6VD3Id7CXWHrhDBuVcQMFXHQNCoBBcxObkz7G88qrPtvmPQArpzBAAlGUhlMfCxeuNbDcd6IJBLYiCHgA7HfmVIQCnmKL/X2J2jatXYS8YIBz2ry2PCS9rFkLVj8oCa2Sb+doJazvS3dggarmVGPNvwVTtFfF8UWY7uvvtLU=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB10107.jpnprd01.prod.outlook.com (2603:1096:604:1e1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 18:31:28 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Mon, 24 Oct 2022
 18:31:27 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo receive
Thread-Topic: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo
 receive
Thread-Index: AQHY5fEK6d4STYQGnkuaJSprEex4Pq4dsSYAgAAEjACAAA32EIAAF1IAgAAF9rA=
Date:   Mon, 24 Oct 2022 18:31:27 +0000
Message-ID: <OS0PR01MB59224B2AE8F84B961D2A061C862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
 <20221022081503.1051257-2-biju.das.jz@bp.renesas.com>
 <20221024153726.72avg6xbgzwyboms@pengutronix.de>
 <20221024155342.bz2opygr62253646@pengutronix.de>
 <OS0PR01MB5922B66F44AEF91CDCED8374862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <20221024180708.5zfti5whtpfowk5c@pengutronix.de>
In-Reply-To: <20221024180708.5zfti5whtpfowk5c@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB10107:EE_
x-ms-office365-filtering-correlation-id: 6d5a93d8-0520-49e9-3d4c-08dab5edf6c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cX7HLKHU6EppC2EjlfIjnBUW0ENeY6vMXN0aZhOSWnN2qEn05NoPuGruXt/1sMNvF1y2GJm6nT6KPKiKJ6SJIk8nDFxGo8b3rzXPtpUDbkjJWoEgakogYTgDQflUk+egwCSMLfB8Nz7I8NpLPGP7JdG21/pNxoqFWbxzzMqEYfQALaptreXtS4leIlQYKJHVKPbmDsM6d6lYxAJ2ucW3AK14hHnR42u4gjnM/qD5RL2a5tSW9CQPl5kimD65CJ9TUUvbZoXIh2MDlLpWp2ZzmI7ERsL0ANJHy5za/W7MloThA/aDb9w4TQ/v7Q2YZz2yfPlm36XadaYKeqGd1Cc3wlk64NLa4DHLi4EVvrmbNw3TT2e0DHgLcF3KIw91sbNHj1nF4+DX+k1g9m8yWKABJ+GKty8k1aeU/HZ4YVFFVWRHO1pCeXfRXu68fI/SGa84v0QRwNIfNp/SAFtn8m3SgKKw68WMjzZSna3AfpKAND0jCREs7HYgr/si4kWDZ9XoQWxUJirYKUAaL31OEE5GpOUQIw8fb+g6OMc2BSK2G4D1OtQ9v65/2Fnni+5EEuqlviAmPD2Ig7yKN2dUXwXWnewfZVpOTsRKMA8erfG8EWPpY7EQ3UwXfSfrHsQzckCvG7r5p1L+rlcSXbHybNHxrdFz2P2E3GOu+Y/oGbgtffOeAqflZk7KrNucr6RsUTx9NkVaTtPZtDn0MhE6xSHl2QFRACaTSr6t3b40EnFBsf/1Rb/xTbCfsiVM2a9dnSV5f89SvLipFtPPwoMMEXs+Nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199015)(71200400001)(86362001)(83380400001)(478600001)(64756008)(76116006)(53546011)(66946007)(66446008)(66556008)(54906003)(8676002)(4326008)(6506007)(7696005)(9686003)(52536014)(26005)(7416002)(41300700001)(8936002)(5660300002)(6916009)(66476007)(38100700002)(122000001)(33656002)(55016003)(2906002)(186003)(38070700005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkxDSXQzMmJhQUE3TXJnR0JRRFpDdFBHWmpBNWRwMEZ5dDJ4TGpvVlB1dTUy?=
 =?utf-8?B?YUFrSjU0bEZOQU9hYkQzOTlUL2hnd1psMUZMejh1OGFEQlFZb2kwTHRsMEI1?=
 =?utf-8?B?TDloM2dkZ01xNW45RzgwWFVyZ3Q5OGlRNXBkZlhyT0d5S0NacEtBRFhJUmIr?=
 =?utf-8?B?ZkdhNUxtdHdRS0R0TGVVc0lWTi9hSTQ5Sm5yODVoT3l5UHJKMjVsVDhUdTQy?=
 =?utf-8?B?L25wVndDZmNHbXhMNlB0SDJEVVFKaGJMaXZPVUNkYzZDRVEwSkJLNEFXK251?=
 =?utf-8?B?UWV6Z28wNlhQdWxmUTZqMW9vZmtnWTk3c3RwWUVlbk5qcEVQQTNDQkdvaXd2?=
 =?utf-8?B?WUhXeWJRQ0Z2dnoxS0hFVlJkRzV1MFlOU2F1OG5YUldubjczZVNMUVIxeHRY?=
 =?utf-8?B?bDdpOTFXZDg3Mi9Ra3FjVm9SUUxHbCtBZ0FnWHQ5WHUzZmo5M0xibThTT3dM?=
 =?utf-8?B?b29tV2NKaUYydGJtUjVIZ1hqNnhQRUxvSFRHOTN2RVBqa2lNd0o2dXdzM2lG?=
 =?utf-8?B?YklBNGtiZzc4dlBnSC9MUEhoYnJzZ1VoMXJmRFVZbEdHZldXVWk5VXJYdlRX?=
 =?utf-8?B?cWM2bFNEM0FhTzNGMGNueTRBYlpBbFE2SUkwK2lUYlVNaWNUSXc5VVBsRElF?=
 =?utf-8?B?dzhqL21TcTdGZHBLVldqZmwvcEZsejIrTkZQVDRzMjRTakFReXJ0WHpFN0Rh?=
 =?utf-8?B?Y1lrL1ZaQWJOUGFON21nNng0eGg3TUlvUU1vRE5IWVRVYnhlZEJIRmI4VGdN?=
 =?utf-8?B?YzFZVXU5YWptRGFkb3p2cUo4ZHFhaFJEcFFFaGRjZXJRMjFCelJHaUlGRERJ?=
 =?utf-8?B?MWs1ZGpXSytwaXE4QVcyOWk2YnpRRlgvZklFUkxMVDVzZWtiZC8rb1Z3Y3g2?=
 =?utf-8?B?Q0diWGJRdU10OXBNN0JmN3I4b1NWUnM1U0pEWkVUL21telV4ZUNZblFkNERS?=
 =?utf-8?B?cktBMDVCVUtSYTR3NUNFSDRzMXR3ZmtnUmxhS3BNdkpjQ2Q4ei9CckZZN1hC?=
 =?utf-8?B?TEp6a3dLVlZGK0l1SnUxYmNKK3p3YjZQSWoxS1d4N2svcHV5WFVwVjJxclNB?=
 =?utf-8?B?WGtqamxFbklmdGNONExLNXNYQjgwLzY1UWQxVW8vMTZVbk44TDh0OExjTkxo?=
 =?utf-8?B?RGwwclYyQi9JNEJLeGkwT0x6R2dpRDNNTndYT1ZyRXN0TU1tU1kyK2M5bG15?=
 =?utf-8?B?MnhwMk5PRHVpSFFBeFhpN0FNSnNvdEU2ZjlSS2pneWp6R1RFcGpzN0lGZGVo?=
 =?utf-8?B?YzVpVHNKazZIK216T3ZaWTRnbi9ZUzdqMEhoM29wdHZqSGd2OUdDcVh4MElp?=
 =?utf-8?B?SXhBOGE4K25EZDZSdE5wTlhRN1hGdGk4ck5iYjlyT1pFd292aWV3TDlNdVF6?=
 =?utf-8?B?MGYxZnkrWEVPSjZEOXFBTGUzR3NuM2Y1bWxWYzZ1bU9PRnFPcllCUFNrcGE5?=
 =?utf-8?B?NXhlYXVNNkkzZFBXaGJ1UFVidCtnR2g2eVFMSEdxY0dQRUc4aVNTZk85RTNG?=
 =?utf-8?B?UWh5ZCtXTnJHK2w2NTNxTnZjbTZ0UTgyWjI1WTBZUkc5V1oxL3haNVpkTlh6?=
 =?utf-8?B?ZTNuQVlsYm9kVlFCcE0ycmJCeFRWTUdSaXY2K0l6TFdjVnBYNm52TXFaVHBQ?=
 =?utf-8?B?MFl1aSs4RjI1L1AwSjR2cXlPdlVyclpQd2FpNU1EK3g4RG1keHl4SVJVM29Q?=
 =?utf-8?B?cVpwVWd5K2FHTkV5aFFpTXcvR25kaCtVVEdjNnVlZGI4RXFXUHJnKzg0RDQy?=
 =?utf-8?B?SHZPclFsbkk2bVVwL0NMbVJGbmluTjR4VWFNWFlYRm52TTVXaTNqYjJNdVha?=
 =?utf-8?B?L0I2ZG1qVVNhYUJIY0ZEcnFYNWlaRUZST3UrODRidmovQllFbjJJeS9SeUJw?=
 =?utf-8?B?Skc1ZzJEaTN0UmJHb2x6MWkyb1BjNU1PTmdRQndlSUdFMDdjc2dNcDJNQXlm?=
 =?utf-8?B?M05OaEl5U0dtTTVKakZYamFnT1Y3QnVwT1VQU2U5bHJISjhxVHZUVFJLSmRo?=
 =?utf-8?B?K0EyTEZXVGs2cStWcnArVE9zakhmM2tzdzNYU21pTFo4OWRyK1E1K2R4Tlh2?=
 =?utf-8?B?c2JhbERnNzlXSTZhaXFybzJSVk9aK0tUOENPSHFyVnZOTDkwSnJ3ejU0UHpr?=
 =?utf-8?B?SEVud3R6OTJCWDlDTWZ1U0dqSmFUNmNibFpQcHZYZ1Fqd1llQUJUYzBYSXg3?=
 =?utf-8?B?WEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5a93d8-0520-49e9-3d4c-08dab5edf6c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 18:31:27.8097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FkUl+JpjFt+JVWGy08yMq/2aY4AyO6kQ6ZOEfgkxWUd1WENFNocw+dJ8W4+X0GnsOW/XRjMtf3mYzJVNZBPyvUC5MAwivsX8ph9raSzR3Vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB10107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEvM10gY2FuOiByY2FyX2NhbmZkOiBG
aXggSVJRIHN0b3JtIG9uIGdsb2JhbCBmaWZvDQo+IHJlY2VpdmUNCj4gDQo+IE9uIDI0LjEwLjIw
MjIgMTY6NTU6NTYsIEJpanUgRGFzIHdyb3RlOg0KPiA+IEhpIE1hcmMsDQo+ID4gPiBTdWJqZWN0
OiBSZTogW1BBVENIIDEvM10gY2FuOiByY2FyX2NhbmZkOiBGaXggSVJRIHN0b3JtIG9uIGdsb2Jh
bA0KPiA+ID4gZmlmbyByZWNlaXZlDQo+ID4gPg0KPiA+ID4gT24gMjQuMTAuMjAyMiAxNzozNzoz
NSwgTWFyYyBLbGVpbmUtQnVkZGUgd3JvdGU6DQo+ID4gPiA+IE9uIDIyLjEwLjIwMjIgMDk6MTU6
MDEsIEJpanUgRGFzIHdyb3RlOg0KPiA+ID4gPiA+IFdlIGFyZSBzZWVpbmcgSVJRIHN0b3JtIG9u
IGdsb2JhbCByZWNlaXZlIElSUSBsaW5lIHVuZGVyIGhlYXZ5DQo+ID4gPiA+ID4gQ0FOIGJ1cyBs
b2FkIGNvbmRpdGlvbnMgd2l0aCBib3RoIENBTiBjaGFubmVscyBhcmUgZW5hYmxlZC4NCj4gPiA+
ID4gPg0KPiA+ID4gPiA+IENvbmRpdGlvbnM6DQo+ID4gPiA+ID4gICBUaGUgZ2xvYmFsIHJlY2Vp
dmUgSVJRIGxpbmUgaXMgc2hhcmVkIGJldHdlZW4gY2FuMCBhbmQgY2FuMSwNCj4gPiA+IGVpdGhl
cg0KPiA+ID4gPiA+ICAgb2YgdGhlIGNoYW5uZWxzIGNhbiB0cmlnZ2VyIGludGVycnVwdCB3aGls
ZSB0aGUgb3RoZXINCj4gY2hhbm5lbA0KPiA+ID4gaXJxDQo+ID4gPiA+ID4gICBsaW5lIGlzIGRp
c2FibGVkKHJmaWUpLg0KPiA+ID4gPiA+ICAgV2hlbiBnbG9iYWwgcmVjZWl2ZSBJUlEgaW50ZXJy
dXB0IG9jY3Vycywgd2UgbWFzayB0aGUNCj4gPiA+ID4gPiBpbnRlcnJ1cHQNCj4gPiA+IGluDQo+
ID4gPiA+ID4gICBpcnFoYW5kbGVyLiBDbGVhcmluZyBhbmQgdW5tYXNraW5nIG9mIHRoZSBpbnRl
cnJ1cHQgaXMNCj4gPiA+ID4gPiBoYXBwZW5pbmcNCj4gPiA+IGluDQo+ID4gPiA+ID4gICByeF9w
b2xsKCkuIFRoZXJlIGlzIGEgcmFjZSBjb25kaXRpb24gd2hlcmUgcnhfcG9sbCB1bm1hc2sNCj4g
dGhlDQo+ID4gPiA+ID4gICBpbnRlcnJ1cHQsIGJ1dCB0aGUgbmV4dCBpcnEgaGFuZGxlciBkb2Vz
IG5vdCBtYXNrIHRoZSBpcnENCj4gZHVlIHRvDQo+ID4gPiA+ID4gICBOQVBJRl9TVEFURV9NSVNT
RUQgZmxhZy4NCj4gPiA+ID4NCj4gPiA+ID4gV2h5IGRvZXMgdGhpcyBoYXBwZW4/IElzIGl0IGEg
cHJvYmxlbSB0aGF0IHlvdSBjYWxsDQo+ID4gPiA+IHJjYXJfY2FuZmRfaGFuZGxlX2dsb2JhbF9y
ZWNlaXZlKCkgZm9yIGEgY2hhbm5lbCB0aGF0IGhhcyB0aGUNCj4gSVJRcw0KPiA+ID4gPiBhY3R1
YWxseSBkaXNhYmxlZCBpbiBoYXJkd2FyZT8NCj4gPiA+DQo+ID4gPiBDYW4geW91IGNoZWNrIGlm
IHRoZSBJUlEgaXMgYWN0aXZlIF9hbmRfIGVuYWJsZWQgYmVmb3JlIGhhbmRsaW5nDQo+IHRoZQ0K
PiA+ID4gSVJRIG9uIGEgcGFydGljdWxhciBjaGFubmVsPw0KPiA+DQo+ID4gWW91IG1lYW4gSVJR
IGhhbmRsZXIgb3IgcnhfcG9sbCgpPz8NCj4gDQo+IEkgbWVhbiB0aGUgSVJRIGhhbmRsZXIuDQo+
IA0KPiBDb25zaWRlciB0aGUgSVJRIGZvciBjaGFubmVsMCBpcyBkaXNhYmxlZCBidXQgYWN0aXZl
IGFuZCB0aGUgSVJRIGZvcg0KPiBjaGFubmVsMSBpcyBlbmFibGVkIGFuZCBhY3RpdmUuIFRoZQ0K
PiByY2FyX2NhbmZkX2dsb2JhbF9yZWNlaXZlX2ZpZm9faW50ZXJydXB0KCkgd2lsbCBpdGVyYXRl
IG92ZXIgYm90aA0KPiBjaGFubmVscywgYW5kIHJjYXJfY2FuZmRfaGFuZGxlX2dsb2JhbF9yZWNl
aXZlKCkgd2lsbCBzZXJ2ZSB0aGUNCj4gY2hhbm5lbDAgSVJRLCBldmVuIGlmIHRoZSBJUlEgaXMg
X25vdF8gZW5hYmxlZC4gU28gSSBzdWdnZXN0ZWQgdG8gb25seQ0KPiBoYW5kbGUgYSBjaGFubmVs
J3MgUlggSVJRIGlmIHRoYXQgSVJRIGlzIGFjdHVhbGx5IGVuYWJsZWQuDQo+IA0KPiBBc3N1bWlu
ZyAiY2MgJiBSQ0FORkRfUkZDQ19SRkkiIGNoZWNrcyBpZiBJUlEgaXMgZW5hYmxlZDoNCg0KDQo+
IA0KPiBpbmRleCA1Njc2MjBkMjE1ZjguLmVhODI4YzFiZDNhMSAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvY2FuL3JjYXIvcmNhcl9jYW5mZC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi9y
Y2FyL3JjYXJfY2FuZmQuYw0KPiBAQCAtMTE1NywxMSArMTE1NywxMyBAQCBzdGF0aWMgdm9pZA0K
PiByY2FyX2NhbmZkX2hhbmRsZV9nbG9iYWxfcmVjZWl2ZShzdHJ1Y3QgcmNhcl9jYW5mZF9nbG9i
YWwgKmdwcml2LCB1Mw0KPiB7DQo+ICAgICAgICAgc3RydWN0IHJjYXJfY2FuZmRfY2hhbm5lbCAq
cHJpdiA9IGdwcml2LT5jaFtjaF07DQo+ICAgICAgICAgdTMyIHJpZHggPSBjaCArIFJDQU5GRF9S
RkZJRk9fSURYOw0KPiAtICAgICAgIHUzMiBzdHM7DQo+ICsgICAgICAgdTMyIHN0cywgY2M7DQo+
IA0KPiAgICAgICAgIC8qIEhhbmRsZSBSeCBpbnRlcnJ1cHRzICovDQo+ICAgICAgICAgc3RzID0g
cmNhcl9jYW5mZF9yZWFkKHByaXYtPmJhc2UsIFJDQU5GRF9SRlNUUyhncHJpdiwgcmlkeCkpOw0K
PiAtICAgICAgIGlmIChsaWtlbHkoc3RzICYgUkNBTkZEX1JGU1RTX1JGSUYpKSB7DQo+ICsgICAg
ICAgY2MgPSByY2FyX2NhbmZkX3JlYWQocHJpdi0+YmFzZSwgUkNBTkZEX1JGQ0MoZ3ByaXYsIHJp
ZHgpKTsNCj4gKyAgICAgICBpZiAobGlrZWx5KHN0cyAmIFJDQU5GRF9SRlNUU19SRklGICYmDQo+
ICsgICAgICAgICAgICAgICAgICBjYyAmIFJDQU5GRF9SRkNDX1JGSUUpKSB7DQo+ICAgICAgICAg
ICAgICAgICBpZiAobmFwaV9zY2hlZHVsZV9wcmVwKCZwcml2LT5uYXBpKSkgew0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICAvKiBEaXNhYmxlIFJ4IEZJRk8gaW50ZXJydXB0cyAqLw0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICByY2FyX2NhbmZkX2NsZWFyX2JpdChwcml2LT5iYXNlLA0KPiAN
Cj4gUGxlYXNlIGNoZWNrIGlmIHRoYXQgZml4ZXMgeW91ciBpc3N1ZS4NCg0KTG9va3MgbGlrZSB5
b3VyIHNvbHV0aW9uIGFsc28gd2lsbCB3b3JrLg0KDQpUb21vcnJvdyB3aWxsIGNoZWNrIGFuZCBw
cm92aWRlIHlvdSBmZWVkYmFjay4NCg0KPiANCj4gPiBJUlEgaGFuZGxlciBjaGVjayB0aGUgc3Rh
dHVzIGFuZCBkaXNhYmxlKG1hc2spIHRoZSBJUlEgbGluZS4NCj4gPiByeF9wb2xsKCkgY2xlYXJz
IHRoZSBzdGF0dXMgYW5kIGVuYWJsZSh1bm1hc2spIHRoZSBJUlEgbGluZS4NCj4gPg0KPiA+IFN0
YXR1cyBmbGFnIGlzIHNldCBieSBIVyB3aGlsZSBsaW5lIGlzIGluIGRpc2FibGVkL2VuYWJsZWQg
c3RhdGUuDQo+ID4NCj4gPiBDaGFubmVsMCBhbmQgY2hhbm5lbDEgaGFzIDIgSVJRIGxpbmVzIHdp
dGhpbiB0aGUgSVAgd2hpY2ggaXMgb3JlZA0KPiA+IHRvZ2V0aGVyIHRvIHByb3ZpZGUgZ2xvYmFs
IHJlY2VpdmUgaW50ZXJydXB0KHNoYXJlZCBsaW5lKS4NCj4gDQo+ID4gPiBBIG1vcmUgY2xlYXJl
ciBhcHByb2FjaCB3b3VsZCBiZSB0byBnZXQgcmlkIG9mIHRoZSBnbG9iYWwNCj4gaW50ZXJydXB0
DQo+ID4gPiBoYW5kbGVycyBhdCBhbGwuIElmIHRoZSBoYXJkd2FyZSBvbmx5IGdpdmVuIDEgSVJR
IGxpbmUgZm9yIG1vcmUNCj4gdGhhbg0KPiA+ID4gMSBjaGFubmVsLCB0aGUgZHJpdmVyIHdvdWxk
IHJlZ2lzdGVyIGFuIElSUSBoYW5kbGVyIGZvciBlYWNoDQo+IGNoYW5uZWwNCj4gPiA+ICh3aXRo
IHRoZSBzaGFyZWQgYXR0cmlidXRlKS4gVGhlIElSUSBoYW5kbGVyIG11c3QgY2hlY2ssIGlmIHRo
ZQ0KPiBJUlENCj4gPiA+IGlzDQo+ICAgICAgICAgICAgICAgICAgICAgIF5eXl5eXl5eXg0KPiBU
aGF0IHNob3VsZCBiZSAiZmxhZyIuDQpPSy4NCg0KPiANCj4gPiA+IHBlbmRpbmcgYW5kIGVuYWJs
ZWQuIElmIG5vdCByZXR1cm4gSVJRX05PTkUsIG90aGVyd2lzZSBoYW5kbGUgYW5kDQo+ID4gPiBy
ZXR1cm4gSVJRX0hBTkRMRUQuDQo+ID4NCj4gPiBUaGF0IGludm9sdmVzIHJlc3RydWN0dXJpbmcg
dGhlIElSUSBoYW5kbGVyIGFsdG9nZXRoZXIuDQo+IA0KPiBBQ0sNCj4gDQo+ID4gUlovRzJMIGhh
cyBzaGFyZWQgbGluZSBmb3IgcnggZmlmb3Mge2NoMCBhbmQgY2gxfSAtPiAyIElSUSByb3V0aW5l
DQo+ID4gd2l0aCBzaGFyZWQgYXR0cmlidXRlcy4NCj4gDQo+IEl0J3MgdGhlIHNhbWUgSVJRIGhh
bmRsZXIgKG9yIElSUSByb3V0aW5lKSwgYnV0IGNhbGxlZCAxeCBmb3IgZWFjaA0KPiBjaGFubmVs
LCBzbyAyeCBpbiB0b3RhbC4gVGhlIFNIQVJFRCBpcyBhY3R1YWxseSBhIElSUSBmbGFnIGluIHRo
ZSA0dGgNCj4gYXJndW1lbnQgaW4gdGhlIGRldm1fcmVxdWVzdF9pcnEoKSBmdW5jdGlvbi4NCj4g
DQo+IHwgZGV2bV9yZXF1ZXN0X2lycSguLi4sIC4uLiwgLi4uLCBJUlFGX1NIQVJFRCwgLi4uLCAu
Li4pOw0KPiANCj4gPiBSLUNhciBTb0NzIGhhcyBzaGFyZWQgbGluZSBmb3IgcnggZmlmb3Mge2No
MCBhbmQgY2gxfSBhbmQgZXJyb3INCj4gPiBpbnRlcnJ1cHRzLT4zIElSUSByb3V0aW5lcyB3aXRo
IHNoYXJlZCBhdHRyaWJ1dGVzLg0KPiANCj4gPiBSLUNhclYzVSBTb0NzIGhhcyBzaGFyZWQgbGlu
ZSBmb3IgcnggZmlmb3Mge2NoMCB0byBjaDh9IGFuZCBlcnJvcg0KPiA+IGludGVycnVwdHMtPjkg
SVJRIHJvdXRpbmVzIHdpdGggc2hhcmVkIGF0dHJpYnV0ZXMuDQo+IA0KPiBJIHRoaW5rIHlvdSBn
b3QgdGhlIHBvaW50LCBJIGp1c3Qgd2FudGVkIHRvIHBvaW50IG91dCB0aGUgdXN1YWwgd2F5DQo+
IHRoZXkgYXJlIGNhbGxlZC4NCj4gDQo+ID4gWWVzLCBJIGNhbiBzZW5kIGZvbGxvdyB1cCBwYXRj
aGVzIGZvciBtaWdyYXRpbmcgdG8gc2hhcmVkIGludGVycnVwdA0KPiA+IGhhbmRsZXJzIGFzIGVu
aGFuY2VtZW50LiBQbGVhc2UgbGV0IG1lIGtub3cuDQo+IA0KPiBQbGVhc2UgY2hlY2sgaWYgbXkg
cGF0Y2ggc25pcHBldCBmcm9tIGFib3ZlIHdvcmtzLiBUbyBmaXggdGhlIElSUQ0KPiBzdG9ybSBw
cm9ibGVtIEknZCBsaWtlIHRvIGhhdmUgYSBzaW1wbGUgYW5kIHNob3J0IHNvbHV0aW9uIHRoYXQg
Y2FuIGdvDQo+IGludG8gc3RhYmxlIGJlZm9yZSByZXN0cnVjdHVyaW5nIHRoZSBJUlEgaGFuZGxl
cnMuDQoNCk9LLCBUb21vcnJvdyB3aWxsIHByb3ZpZGUgeW91IHRoZSBmZWVkYmFjay4NCg0KQ2hl
ZXJzLA0KQmlqdQ0K
