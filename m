Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2256F59F5FB
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiHXJMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbiHXJMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:12:41 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2131.outbound.protection.outlook.com [40.107.113.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74894598D;
        Wed, 24 Aug 2022 02:12:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7z7YIRaGwNOG47yyUSODukXryIdQLKj+QgfgoiII+/XJylQV0Zw0ArTJVBsKtKf6bR4cGy3hrIGmlxQNU9Cvzidkg2a78Hp/MA16K1+LAFP0hT0KnL0iHeubYfR8qDkLQKgieVvdyW7r47jJENy+njhVpb4qt0Kki7OI4S+uxCjG/KOmSlLoz19/JU0q0zKvIc3K2mecX27aA5RhITYCuupNwtg6Ankn2D58OoiAXtuKYYJfF5inwESmqvXmIqj56qPxM8/7bPhj0POtuzt9oM/oduPddwyIj5WRPpNvtEXjcH70cLvgmjbxsZNSfPgt3nt0BwE990fqGVGxXYVmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1RbODiurbs4rox+wF3Pwuh7t7LIPsmPem33JgjpKQA=;
 b=gLb2T8FqCq1Ju8yBcoOP1A7WEu3ZpmV3YBgHbUrOR4TeVgMiyQ4GzMCMUVbfOPh5Qcq4iPtZCxnpOeu0MaT67K9FPM5U6WUSBrS9jldd1/w2cwSNKHSeJCDRsEWJUNE97Ws/oC+ZH4yql8cZ8P2K5QG5yPvqDtHmU8wQQlLEO78cNWfmNCXaf2vsT5TIX1DtGfmwRvutL/sLsJBmF+ptMkggnKg1ExzP08pJH8mucAJZtPkCUvLw+1HgBcXznjmKdEwg+V8fSjPwCGpLgaCJPRzU8VmTwEeUkKYSh3saGeS9AQ8f3vvjGjSOUVFh1GvKsZqURuh8IssxYXDTwCpssw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1RbODiurbs4rox+wF3Pwuh7t7LIPsmPem33JgjpKQA=;
 b=k8i0iqpqoIFauRktSKB7MsD52rKbFhzxVqiMGD5uRUFyUWAScdW77V3cZ1lP5/STPZy/kvgt5gwvHcL2LN1kKX5ncxjE/3Jeq+4fEKwUaK+Xu4lZ13MvdYqO/Z0AXHlfr6Qz5F3r5/t4yHF9+cZqyf0jMm4Hcn4bNns7i0900OI=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYAPR01MB5548.jpnprd01.prod.outlook.com (2603:1096:404:803c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Wed, 24 Aug
 2022 09:12:36 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::14d3:5079:9de1:ceaf]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::14d3:5079:9de1:ceaf%3]) with mapi id 15.20.5546.024; Wed, 24 Aug 2022
 09:12:36 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v4 2/6] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S}
 support
Thread-Topic: [PATCH v4 2/6] dt-bindings: can: nxp,sja1000: Document
 RZ/N1{D,S} support
Thread-Index: AQHYlFOf/pqwB2RpXkGMU+k3lln3yq20o/8AgAlmPoA=
Date:   Wed, 24 Aug 2022 09:12:36 +0000
Message-ID: <OS0PR01MB5922B934EC3D847BBFC6F3BA86739@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220710115248.190280-1-biju.das.jz@bp.renesas.com>
 <20220710115248.190280-3-biju.das.jz@bp.renesas.com>
 <CAMuHMdVvh5n159TLVzosnHyjX3Hxadjky4DjpedSvezPZ=fRLQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVvh5n159TLVzosnHyjX3Hxadjky4DjpedSvezPZ=fRLQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b290c08a-c0f5-4cb7-01ae-08da85b0c92b
x-ms-traffictypediagnostic: TYAPR01MB5548:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yd4EZfg6IVnvHbUOflExjbUkUVdUNm458TC04UDfOWocPVsiHwVSXEJJjtW1GR1PVywuGKMXcT5PSYmPXUN+eyTn04ICeraXsv5UUuW7UbVs7ERk9wAZj/PnHwOxvLd3ZuuH7ZVGBDyIFUJxMQxN6tpfWxhgOVibM1mtIXXhpLp6jGmvauE+kw1IXuMt+kWwFKGX8T2Qphwpu+Kjo854DamU40F3PnB4UyqOfz3TQDowKWQN1rz8k8Er/IBGpOV9oG9vYKd6pMEPbLb8UGxO5r7tZ6YACYMLTJgiZ1qegbw1oI9h+vhz5Gl33YISSgeCM3F7Lv6m13AHyWMFmMaSQ23BVGR2YqU5pyPEW/S1di6NCnfnbekB8zGzMaZp+RwfHva+umZNivJMktKvQocfH8sNAda8/Asm1JOURg7RfwSBxSUCCllU2GJsnfbH0ihxUavQj4VE/a964aorhD1PQ2Bt47XJyH0ydqdfuM/22Uwjchwf0gN0zUjHoI3Qg1T+FxH52+7fdy8F1/mLCj3vcLxuPF2PhPYDr0q2tbkq2a6Lm41WaSUw0S7yuZ9rVO+4VsPxeYvNzkpy+RSvYhBjxfp1MbhccYaIE432yQL3txkX62H3JLci8NIUjYsbC82XTKC9ZLbZzv8UANYVSVPPwDQavxQXMLLF3JDxF3JXvQUExpQFt16RKvkpH7CIt82c4jjlSEBrs7ajCANvzH8wWWrpGC+Y6PX0/zZtFH3WfPZ3AaKPib9XcNUVtwXhxgEvU6FIBlsIaMa51uK2UCdy/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(122000001)(316002)(38070700005)(26005)(9686003)(38100700002)(71200400001)(7416002)(52536014)(5660300002)(478600001)(41300700001)(8936002)(86362001)(53546011)(33656002)(8676002)(64756008)(66446008)(66556008)(66476007)(4326008)(66946007)(7696005)(2906002)(76116006)(6506007)(55016003)(186003)(83380400001)(6916009)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aW9Cd2lTSFRYbXRwajFOTzhUVmdKSnc1VS9zMnJlUzVNMjFxajdkRVpGb3lt?=
 =?utf-8?B?YzRKWHNCSVN5ZUNsUnNCclg3NjdTVkp4YU5Ed2pmTkFXcU1BRnN2MHdhVllT?=
 =?utf-8?B?bTcybXloQTVyOWFsYnp0SXdKWDJrZ1pJN1k0azd2dEVvOHFCc016Rnh2MUw3?=
 =?utf-8?B?b2RNZTEyc0phZ2xpcmVSbWRsV0NCZ2ZIY1ZUL25tRHdqdmd6TlNJcmJ0eFlV?=
 =?utf-8?B?SUh2clRBZHR3UWpEYUNiMTF3VHR3NmorUytobGNEL3YwUWN4V0dqczFHUGFl?=
 =?utf-8?B?S1B2Y3ovREN1bmVId2FZZVorcmU1dXUxbG11aXg4a2lPNXVxNmVCWnhDK2dz?=
 =?utf-8?B?YXNIMlFYZHQ4cXZ5SlptczlZeHpjN25UNFJ5ZTVQU0MrdGFFRGNGUGIvWW1v?=
 =?utf-8?B?eWVCODQxR1BXS25SVXNDS29oWk5yOTFiSEprVDZOWUh6VzM1NE9PamV1Mity?=
 =?utf-8?B?MG1FZGNYRGNMUEI5cmtHMFpodUNjZy9jSG9LekJ0MytOaTVoVTFmcStObFI4?=
 =?utf-8?B?cnFCTnVXNDBrcllqM2ZQL2VXVllGRi9SS0x5TkI4ZkhwUndFcTc3eXdzVWQ3?=
 =?utf-8?B?WW9RV1ppVU1DUFM1VnFOQkF6THBvZFZKa3BlTEF5OWJuRDFIaWdJMkNnenFG?=
 =?utf-8?B?a1B3diticUU0cHUvNGlFcHBNc0FYa2c2VGZKcmdzYkRxU2xkK21SR3VONHFI?=
 =?utf-8?B?a2VKdXFjTXozRVhJN2RlUlpnQXp6VzRibGgrazZrYVJaYy96eTFjWXJzNTZC?=
 =?utf-8?B?RVpmRHp0UEwyWUYzNS9DRldwM3pyZ1E0Y2duRXJOdzFseHEzNTJha3dXZTZ0?=
 =?utf-8?B?SEtDeEhNV3ZNbFZMZ2JReVFuWEh1OVVjYWdoVVBKS21mbmtLUWdmN1ZXUHNh?=
 =?utf-8?B?eU90b3MzTCttcnFlZnplZXhUdVNhNFZ2SFVYZUZSWGhFRVFtalE4VEtKNDg2?=
 =?utf-8?B?RU5mTEVhMXBYTGttaWMrOVRGYzk5R0JJN0J6NS9jTExGSkhrNGJKT2xYR3Q0?=
 =?utf-8?B?Z1BNMWpWaXRPOVZMdWJWUGdGbXFYSTFrSGIzZ2lHaUFVRUdXZW5vWUEwSnln?=
 =?utf-8?B?RytEVEtVSGk0LzgwUmQ3bWdiN1V1MVdnMFFaRXl4cTJ1SWd0dk94WFByeEho?=
 =?utf-8?B?ajhJUkozWitOT3ZET1ZhZlVhR0szcjJad01zWEEvWEFxVWwyR25namRpU0Ix?=
 =?utf-8?B?VnpncHBPMDM1TmhtYTdzcTZob3VwU1dqUnhUMUpyeVUxT2hiSXhQL3k1NjVo?=
 =?utf-8?B?UkxlQWZBNytxZUpVdTE3bTEwYjEyeXNzT0FkaC9DTlRLUGd4UDNnT1F3RS80?=
 =?utf-8?B?S1FPc3NaMDV6MndZcE9xMURmck1hb0lENUdMUktQdmV4R1hlM0UycStsVUpz?=
 =?utf-8?B?QmVvRUFoTzdHNnZnbGxnSDJob3l4dWFXY3lLNmlRSEpBb0hGUnh6c2JGRVF6?=
 =?utf-8?B?cHRrdFJaYTh0U1d0cXMxYU80dGc2NWhNc2owUVZGRlZEakVhYWdVcE0yV2p4?=
 =?utf-8?B?S083WFhUeEw0bkJyc2NWMHdZTktTb2dhMnkrZDlZbjdQN2YvNVJxSFhMeUp0?=
 =?utf-8?B?VWM2RWpNcWEwY3c3c0piQmo0a2dwdGpxNVlkMU9kZ0pZb0kxV3BWWEc0Ti84?=
 =?utf-8?B?akg3SEQ2WGFOKzF4aUVFWHNTYTNMYkVOYm5FMHE2djRHVjU0QzY1TkhZTWpw?=
 =?utf-8?B?U09Da1U3NGk5TE8xUEpONTZ2RFlHd1dzZHlxUVU2QXZ4eDBEYXd4cFljWnpV?=
 =?utf-8?B?K1QycVdpTEs2YU5SQk05N0hGb0Z4ZFJnbnNoQ0N0L1NPM25yUnZOd3FoN3J0?=
 =?utf-8?B?cm1OMk8xUGFXUUdhYXpQZUFwRGFVazk5UlhybGorb0tJanFTYVM0ZzBWRGF0?=
 =?utf-8?B?WnhHTDY5cHlHendwL0x2bkIyZGJuZE82c0YzckpsZFp0NHZxeHhqTURxeDd2?=
 =?utf-8?B?MjE3K1ZLZXVIRWRSOEFLWnhERjFGMFZYaGY2SzMxTGxuY09jelhpUXVZTUpQ?=
 =?utf-8?B?cVZhbHJYMkdGVzhNTnUrak5aeWJjU3MvNnBrTTJaaFh5RTlsSHAvQ0xrR2Yz?=
 =?utf-8?B?cFJxaTV0NVBHelB6V09ybjQ5K1RmYzFobkZaR25BR1dZbjBXb3IyNUpiK0s3?=
 =?utf-8?B?TFVJZ0x0Mm55VzMvbTErcFF5QUN3SlNzekcrdTJTYU5yKzFNZURzMHN2Z29J?=
 =?utf-8?B?aWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b290c08a-c0f5-4cb7-01ae-08da85b0c92b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 09:12:36.1655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nyLicQ77mzdPd08y9iM9LDzW0ymn8PeF/ART8oqpUmcY/qyeHtUsjxa/vZDGiRLyE5WlEJhU6YTgJhYVVXZ8EENy867wKAltjVJ00Fdk0rk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5548
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjQgMi82XSBkdC1iaW5kaW5nczogY2FuOiBueHAsc2phMTAwMDogRG9jdW1lbnQNCj4g
UlovTjF7RCxTfSBzdXBwb3J0DQo+IA0KPiBIaSBCaWp1LA0KPiANCj4gT24gU3VuLCBKdWwgMTAs
IDIwMjIgYXQgMTo1MyBQTSBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+
IHdyb3RlOg0KPiA+IEFkZCBDQU4gYmluZGluZyBkb2N1bWVudGF0aW9uIGZvciBSZW5lc2FzIFJa
L04xIFNvQy4NCj4gPg0KPiA+IFRoZSBTSkExMDAwIENBTiBjb250cm9sbGVyIG9uIFJaL04xIFNv
QyBoYXMgc29tZSBkaWZmZXJlbmNlcyBjb21wYXJlZA0KPiA+IHRvIG90aGVycyBsaWtlIGl0IGhh
cyBubyBjbG9jayBkaXZpZGVyIHJlZ2lzdGVyIChDRFIpIHN1cHBvcnQgYW5kIGl0DQo+ID4gaGFz
IG5vIEhXIGxvb3BiYWNrIChIVyBkb2Vzbid0IHNlZSB0eCBtZXNzYWdlcyBvbiByeCksIHNvIGlu
dHJvZHVjZWQgYQ0KPiA+IG5ldyBjb21wYXRpYmxlICdyZW5lc2FzLHJ6bjEtc2phMTAwMCcgdG8g
aGFuZGxlIHRoZXNlIGRpZmZlcmVuY2VzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBE
YXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiANCj4gVGhhbmtzIGZvciB5b3VyIHBh
dGNoLCB3aGljaCBpcyBub3cgY29tbWl0IDQ1OTFjNzYwYjc5NzU5ODQNCj4gKCJkdC1iaW5kaW5n
czogY2FuOiBueHAsc2phMTAwMDogRG9jdW1lbnQgUlovTjF7RCxTfSBpbiB2Ni4wLXJjMS4NCj4g
DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vbnhw
LHNqYTEwMDAueWFtbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvY2FuL254cCxzamExMDAwLnlhbWwNCj4gPiBAQCAtMTEsOSArMTEsMTUgQEAgbWFpbnRh
aW5lcnM6DQo+ID4NCj4gPiAgcHJvcGVydGllczoNCj4gPiAgICBjb21wYXRpYmxlOg0KPiA+IC0g
ICAgZW51bToNCj4gPiAtICAgICAgLSBueHAsc2phMTAwMA0KPiA+IC0gICAgICAtIHRlY2hub2xv
Z2ljLHNqYTEwMDANCj4gPiArICAgIG9uZU9mOg0KPiA+ICsgICAgICAtIGVudW06DQo+ID4gKyAg
ICAgICAgICAtIG54cCxzamExMDAwDQo+ID4gKyAgICAgICAgICAtIHRlY2hub2xvZ2ljLHNqYTEw
MDANCj4gPiArICAgICAgLSBpdGVtczoNCj4gPiArICAgICAgICAgIC0gZW51bToNCj4gPiArICAg
ICAgICAgICAgICAtIHJlbmVzYXMscjlhMDZnMDMyLXNqYTEwMDAgIyBSWi9OMUQNCj4gPiArICAg
ICAgICAgICAgICAtIHJlbmVzYXMscjlhMDZnMDMzLXNqYTEwMDAgIyBSWi9OMVMNCj4gPiArICAg
ICAgICAgIC0gY29uc3Q6IHJlbmVzYXMscnpuMS1zamExMDAwICMgUlovTjENCj4gPg0KPiA+ICAg
IHJlZzoNCj4gPiAgICAgIG1heEl0ZW1zOiAxDQo+ID4gQEAgLTIxLDYgKzI3LDkgQEAgcHJvcGVy
dGllczoNCj4gPiAgICBpbnRlcnJ1cHRzOg0KPiA+ICAgICAgbWF4SXRlbXM6IDENCj4gPg0KPiA+
ICsgIGNsb2NrczoNCj4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4gKw0KPiANCj4gUHJvYmFibHkg
eW91IHdhbnQgdG8gYWRkIHRoZSBwb3dlci1kb21haW5zIHByb3BlcnR5LCBhbmQgbWFrZSBpdA0K
PiByZXF1aXJlZCBvbiBSWi9OMS4NCj4gVGhpcyBpcyBub3Qgc3VwZXItY3JpdGljYWwsIGFzIHlv
dXIgZHJpdmVyIHBhdGNoIHVzZXMgZXhwbGljaXQgY2xvY2sNCj4gaGFuZGxpbmcgYW55d2F5Lg0K
DQpPSywgd2lsbCBhZGQgdGhpcyBhbmQgU2VuZCBTb0MvQm9hcmQgZHRzaSBwYXRjaGVzLg0KDQpD
aGVlcnMsDQpCaWp1Lg0KDQo+IA0KPiA+ICAgIHJlZy1pby13aWR0aDoNCj4gPiAgICAgICRyZWY6
IC9zY2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3VpbnQzMg0KPiA+ICAgICAgZGVzY3Jp
cHRpb246IEkvTyByZWdpc3RlciB3aWR0aCAoaW4gYnl0ZXMpIGltcGxlbWVudGVkIGJ5IHRoaXMN
Cj4gPiBkZXZpY2UNCj4gDQo+IA0KPiBHcntvZXRqZSxlZXRpbmd9cywNCj4gDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgIEdlZXJ0DQo+IA0KPiAtLQ0KPiBHZWVydCBVeXR0ZXJob2V2ZW4gLS0g
VGhlcmUncyBsb3RzIG9mIExpbnV4IGJleW9uZCBpYTMyIC0tIGdlZXJ0QGxpbnV4LQ0KPiBtNjhr
Lm9yZw0KPiANCj4gSW4gcGVyc29uYWwgY29udmVyc2F0aW9ucyB3aXRoIHRlY2huaWNhbCBwZW9w
bGUsIEkgY2FsbCBteXNlbGYgYSBoYWNrZXIuDQo+IEJ1dCB3aGVuIEknbSB0YWxraW5nIHRvIGpv
dXJuYWxpc3RzIEkganVzdCBzYXkgInByb2dyYW1tZXIiIG9yIHNvbWV0aGluZw0KPiBsaWtlIHRo
YXQuDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLS0gTGludXMgVG9ydmFsZHMN
Cg==
