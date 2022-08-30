Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E46C5A6B3F
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 19:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiH3Rv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 13:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiH3RvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 13:51:08 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2121.outbound.protection.outlook.com [40.107.114.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC654B5E7C;
        Tue, 30 Aug 2022 10:47:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pe/QkxPkAAH7TQlBt1qf225vGIBxO96+aFo0lKbCn/bxS/EZzCDZmjp0KBzvo/r8euVgtLi4Ul0WC4d/Njjbo43EbrhK4OMP2vPcYYTlU1YK0voD+dH8zAvQYUCk/Ec/PHcJ/ULVyOGSgnlcwRRTGJ4sFfzr/uNU2Jdrbx5gPmX+fddqMm2wz2V/dks2Sn1AvU9wSM5lCV1PFKqwwRxhHfzLypgdHftg43VZEloNbPpNxz7s6PysXI8BrzdCCCmf9lXd29rVRt24xCefsT7Pi10VH481W1qcjAplQqpl0io/J59Rh1y3AkUiVtmxUsXVLZNw5Q4eZm9+oebgMmSsNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8GC5PNIC+i/ye9ew/AC1jF2UZifIOvYji4y/p9KX9M=;
 b=LB/GM+nrZUnWrgzWovsUlRtyUSJlyeMcQODjAJYEkqisoow7yIYN2GcMqmec/SR0HsJi+kiykbwbQI7Tb4yUhLtAP3Tt0A1Emk14l8hGrSqP15UJY+/elpKH7IoQOwcvl5pgyu++6/EeYVzwwH48yxR7I3BerWtIiosx43ihQkls9sgio1g8ZUdSkvo2hSRMXnmV9fiywN/RiWDFG77uXGMV/sbdv05ViA1mwlTdlCG+ipPWVHVObjJwJP7edCKf0F6Q6Ull8LtfJueRcQypX22kvx7NquPa6sqDgYp8y5R4TBX2jtMOQ2XoAsDQJilj2Rh1naq9G/ZZRlVqNcK8WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8GC5PNIC+i/ye9ew/AC1jF2UZifIOvYji4y/p9KX9M=;
 b=QfMre/lTdiGia4KV7ovobk6srXjBQuxfdq/pNFvV+mcsapeU8rpo2f9JkPLxaPmCEExJVzkm3B2Lpcx/3WI3drIuqbpAUlbucpKg7jnoymdQ6F2ad+5FdjbS+WJcQNYO6ToahuApYLeRx7rS+oWeppORVd6vQR4HaY80A0zXO5E=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB6527.jpnprd01.prod.outlook.com (2603:1096:400:93::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 17:47:43 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::14d3:5079:9de1:ceaf]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::14d3:5079:9de1:ceaf%4]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 17:47:41 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 1/3] dt-bindings: can: nxp,sja1000: Document RZ/N1
 power-domains support
Thread-Topic: [PATCH v3 1/3] dt-bindings: can: nxp,sja1000: Document RZ/N1
 power-domains support
Thread-Index: AQHYvI/soc4ccXsQ/0GsHSqaKNc0sa3Hs5aAgAABa3A=
Date:   Tue, 30 Aug 2022 17:47:41 +0000
Message-ID: <OS0PR01MB592292E8BE619470F4C621A186799@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220830164518.1381632-1-biju.das.jz@bp.renesas.com>
 <20220830164518.1381632-2-biju.das.jz@bp.renesas.com>
 <23539312-caaa-78f0-cd6c-899a826f9947@linaro.org>
In-Reply-To: <23539312-caaa-78f0-cd6c-899a826f9947@linaro.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1472f8c-a2dd-43c0-9749-08da8aafbcbe
x-ms-traffictypediagnostic: TYCPR01MB6527:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L9K6weiSLGBn0gA16Ukdoyhp7ZtE+WLCbQeJV1oseMkwMbZYiRex6LdlBOBwRQnHWD7ZeukibVPMu7wN0yV4z8+Pn5/Mp/ZS3NfP6RIwEzn1nBoS1KPjB3BnBfgALZrsvB8JPyYBmHSb5IhTS4Umd1J8kPSDKdBung8gvsLnaymGsBxK5c+WltuE+esj3z5yhqBio527B/cCz0xTeCk481HHzKjEiOC5mezjKfcLvA+28Gtc7BMMCTv3DEBor5vBZxGl5agozVrxHfpTQJQH6N4L4RG+roGZsirkWONhanjyrOJPq4jZMKD9DcomVOgPrSeeKOFpebEF6cul9hA86PSHqUJZJSXy+rjBB7orP+LjQ6Ds/kEV5bZGrZAd2zWjvls3BfuANcjWGbZZWacx0JEhLBYmLFHo3miCkED/HnHAlaXxUOJitaDOmF3APXWqfA4G9GGnZ5OVcTNyM5oatk123hby/DVfMIOAjOhRqsf4fnXLhuOVymiicejnmpZmN7XDy/kz6cVXrwZTCoU45SNGi49Y18TpQwbVTuYY/AhO/1zn7vDhbmbhBTrN3SGy4oKtc1Q7Ea2pLt3VfxwvRSvixpznqRem+U/IQUqF2CRI5J5Wh8ftOycQBpax78e94IgK27jvRl2IP6w2ESrPuFUXt6Od9pcv+Dy63HtWIzXtcBdoCK2SYaTqa6v/NZ8njUMJl2qdDjS5BMnjtvsj5dJWsCan6R4bNBIuqAGLtlXeKQLTZpUQwDEgnpXH9hP9FGO6UIxU75TOq3HRkoF+DHjxIqZ0Z4ung6PTUPDi00Tduh33etRA+0WlBkXIy+n2nwIKEiyNj6GwXnMc24gWjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(66946007)(7696005)(8676002)(66446008)(66556008)(66476007)(76116006)(4326008)(64756008)(53546011)(2906002)(83380400001)(9686003)(55016003)(966005)(8936002)(5660300002)(26005)(478600001)(7416002)(41300700001)(33656002)(6506007)(52536014)(71200400001)(316002)(110136005)(38070700005)(122000001)(86362001)(54906003)(186003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cm54K1V6WHkzNFU4a2Nkb1FXV2Evb0U5dWYrOHVLRzFBY1I2bnBmemdxTVNq?=
 =?utf-8?B?cjhaSy81VnFaTlRHbzgwbTVaN1owOGJXMjRzS2JsZFdaVWMxV3M4ZlpTbnlk?=
 =?utf-8?B?MUxqWVo5a25uSXdHVEpRVkZlV3UxdENyV3Rnc1kyY0hyN1R3UXpzYmlOTnJx?=
 =?utf-8?B?SXJSbnlGYllnSlZubTFpYWtpTnpvWG4wQmlUL3NhdkxGMGR4dk9iM3VhWGtC?=
 =?utf-8?B?WlcwNVYzN3hLemUwQlkxd3JvNWhoZThrMUNFcGRLeGxnK3VSTURHMXFNSFVQ?=
 =?utf-8?B?TVp2V1NWQXZ6dXlJSUVmMW1ZUXNxcWF3R3IvUUJLOU1FZGtmbjRRTWowaDlN?=
 =?utf-8?B?dUZOWHFBa3VGdkdvbSszeUdwd3liZnVHOWkwcW04S2Fkcm5VV1JmSmVWYTVT?=
 =?utf-8?B?RHJsV2h0WXpORHpSeFlweTVxSXQvWmVHSlpWSjB2cGQwR2FESDZjTW0yQTJV?=
 =?utf-8?B?S2FLTXh3MlM3UHJ4QmFsTDlNSkRsOXQyZTJCam4vTThJUTZXcTE1RU8vODBm?=
 =?utf-8?B?R2g1Y0RlQlFRdGdKWlAxQWs0VUpESjNPWGU0UENWUjBPckZGeWNONkNyRCtE?=
 =?utf-8?B?VTlTeldkVVp4c1NveDJUWEVvRnZieWtRMkQ5UndUQ3BzdEV0T3EwbDdkM2c4?=
 =?utf-8?B?N0wyMUplc1FNMzY1bDhDYkNVallpb1Fza09pVUZRZ3JTbVR3dE5mNTBhRWFJ?=
 =?utf-8?B?c3ZhZ2lFZDdqWGdhQnY3ODVXRGp0Q3gva0w1eGNNVXo4Zm5lRGpjUFhqdFAv?=
 =?utf-8?B?ZkpCT3doNlhoUi9TMWtydkQzcFYrYW5OTTAzN0gyYVhDK1ZHUzJqbERHdzJ3?=
 =?utf-8?B?Q3JsQWdzVXFxYmliODNOK1FUSFhDRWViQmUwTTl2UEtiejU2UkVQaVBhWWRr?=
 =?utf-8?B?aytLRU9QOXRXTGZqbXdCYjl3UFNSTHpBTGl4cytmL1NUU3d3SzhnYXFpdzE5?=
 =?utf-8?B?YnRHSXVuUHV1MXR2allPYUxvTVpVSU85YXg1QnJTK2dZSHpiVG1zL2g1dFMv?=
 =?utf-8?B?WWlSVnNnWENMWEh2em1Pa2svdDZlSjNMOFRFN0pEWlBtNVNLOGl2TUdvMHht?=
 =?utf-8?B?enZNNVZVVHNvVnhsUWdDYlJFd21WczBnanVieWVySzQ5c052WWhqQkc4SW0r?=
 =?utf-8?B?L1hhSHZnR2pEbnRVKzRGT0VuN01DVW40QzIrb0xnWlVzK0QvZTFkNG56YWE1?=
 =?utf-8?B?L1liVUNVd3ZaVHQ0djF4UWZpaEVJdlFUbGIzVDVnQlFIdUF6S1Zjb1AxY2Jy?=
 =?utf-8?B?RXZiMzV3L3N0YzVLclNFbzRacEN3c1o2SG9pdWRDUzR3ZjR6Y3NHajlrcTdJ?=
 =?utf-8?B?MjFaRWV2Nm8wNjNaK3huSit6UE81Sjc2SFBEUzBSemtGRnlIeS9PanVEUGpz?=
 =?utf-8?B?Mlgyem81WUE4WW0zQ3BhY1RpelhzZWttV1M5N3hyQlcvQ0lieTd6ZFRGUGp1?=
 =?utf-8?B?bXZoMGVIbWE0a2o2UzgwMFc5Mjc0cEZxWFpsMUt5NjdSU0RkYkV2UVk0aUY5?=
 =?utf-8?B?SGIzMDRtclV3ODhOQzZSNVRramJqVEk3TEJlaFcrbnBwRnZ1M01Cd3FvZmhL?=
 =?utf-8?B?eU56WWNYV3ZJZGZVZjMyTzZaMGo3ejdyS3VMeG0ranNuekxSeCtlQm9BY1dV?=
 =?utf-8?B?MG04anFTeVpzSUFqeTBCTEpJZmZjZ2ZSL1ExSjFxM244WnJkbDBtTEk1S0lz?=
 =?utf-8?B?YVUwcUhsZjQvSm1ZWHFNL2FESnRMcktmdjU4dHR0RnhqaEhuaDZjeCtJQlds?=
 =?utf-8?B?SWZicEJHWGd4bGVSUndnWVo2cFkzYm1ZK0czU3dEdHBmZlR5bFVZd0NOZ0g5?=
 =?utf-8?B?K3cvcDIxSzBPcHI5M2Z4Z2VQQWhMdE1wVE9oemc2UkM0aTJjZGVxdURXK1g0?=
 =?utf-8?B?K3lyWXJ6MkpZRncwcW1UYUNNUFNPRHlmRUUzNWY4eFpFbnFuV1d3NXVHc29Q?=
 =?utf-8?B?SXI2RUVrOXl6cmxLNzlsZmdEWks3M3VUaU9jK09Ka25uWmZoSnIrS0ZyQW9a?=
 =?utf-8?B?aE5tdmllcjZXdFpBcHIxU2hMTmtKWEpDYnFzM3NoNFhCTERySlExc0llUHBr?=
 =?utf-8?B?VFpaU0NGRWc0dmJvd1BrK3ZObGZQMGRsclRaQmRIa1U0SkdNY1FBZVpOM2ZK?=
 =?utf-8?B?eUFQU3UrOHJreTZMNVB5Q1dtbW41enp0c0g3OURqUmhERHROUlVBMjJ0WGQy?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1472f8c-a2dd-43c0-9749-08da8aafbcbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 17:47:41.6550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nm/Sk3HYxJn3lqdtBjbPxFS3YDCCnW1E4cvbZd4dLrK255OwfUUl1Eg+zWgrJXT5kKFqkIuPct2e+ncmn4XlWS+SVA3wiQl4sh70ICa/jGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6527
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3J6eXN6dG9mIEtvemxvd3NraSwNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCj4g
U3ViamVjdDogUmU6IFtQQVRDSCB2MyAxLzNdIGR0LWJpbmRpbmdzOiBjYW46IG54cCxzamExMDAw
OiBEb2N1bWVudA0KPiBSWi9OMSBwb3dlci1kb21haW5zIHN1cHBvcnQNCj4gDQo+IE9uIDMwLzA4
LzIwMjIgMTk6NDUsIEJpanUgRGFzIHdyb3RlOg0KPiA+IERvY3VtZW50IFJaL04xIHBvd2VyLWRv
bWFpbnMgc3VwcG9ydC4gQWxzbyB1cGRhdGUgdGhlIGV4YW1wbGUgd2l0aA0KPiA+IHBvd2VyLWRv
bWFpbnMgcHJvcGVydHkuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5k
YXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gdjM6DQo+ID4gICogRG9jdW1lbnRl
ZCBwb3dlci1kb21haW5zIHN1cHBvcnQuDQo+IA0KPiBZb3UgbWFkZSB0aGVtIHJlcXVpcmVkLCBz
byBpdCB3b3VsZCBiZSBuaWNlIHRvIHNlZSByZWFzb24gaW4gc3VjaA0KPiBjaGFuZ2UuIFRoZSBj
b21taXQgbXNnIHNheXMgb25seSB3aGF0IHlvdSBkaWQsIGJ1dCBub3Qgd2h5IHlvdSBkaWQgaXQu
DQoNCkl0IGlzIHNpbXBsZS4gQXMgeW91IHNlZSBmcm9tIFsxXSBhbmQgWzJdIHBvd2VyLWRvbWFp
bnMgYXJlIGVuYWJsZWQgYnkgZGVmYXVsdCBpbiBSWi9OMSBTb0MuDQpTbyB0aGVyZSBpcyBub3Ro
aW5nIHByZXZlbnQgdXMgdG8gZG9jdW1lbnQgdGhpcyBwcm9wZXJ0eSBmb3IgYWxsIElQJ3MgcHJl
c2VudCBpbg0KUlovTjEgU29DLg0KDQpbMV1odHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0L2RyaXZlcnMvY2xrL3Jl
bmVzYXMvcjlhMDZnMDMyLWNsb2Nrcy5jP2g9djYuMC1yYzMmaWQ9YWFkMDNhNjZmOTAyZTE4YmFi
NjEyODcwMjYxYmRlNjQ3ZmRiZGEyYw0KDQpbMl0gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC9kcml2ZXJzL3Nv
Yy9yZW5lc2FzP2g9djYuMC1yYzMmaWQ9MTRmMTFkYTc3OGZmNjQyMTQyZTliZTE4ODE0ODE1NzU0
YzgyZDZjNQ0KDQpDaGVlcnMsDQpCaWp1DQo=
