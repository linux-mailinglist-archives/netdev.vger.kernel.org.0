Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F27605511
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 03:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiJTBdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 21:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiJTBdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 21:33:49 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2071e.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::71e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58391C2F05;
        Wed, 19 Oct 2022 18:33:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wuz1y1IAsyEpGC/ZlIi6JapVP2JJwrCV0c+52wyfyagB7LSrb8WXi9580Lg++KHRFrVeR5VvaEpAPXYjYX9Gi56Z+LbvxgFBVuSA5qvkgIP6Mn/h3oGDhKaKiHx+Vz9FS3UPa2UMOlv6Wq0q0grJe93+AT5pw0gkkKGVMz11kK1NagNd0RSi+5IU/0MaYyNuu0rrnMGDZqTAIJod4vDIbDLl4/UuZkL1EvNrRCgY+6sBU5TIw/8GaAlnEqu01z7JbD2qXKnpI54xGvbTqrgFHJIA8SMgTVR1ZkPb0FRorQZ8GDNjyLRsKS8puDqqvVKZtf2d4Y8/yn95rzkCiOIhXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDp8pWtrNuNNaW3qby1yV/GEWWViU3rQ/q/EK/J2S8w=;
 b=O87GcO+jT1UtRs34bjuOt1a8+r6N0UTntOaWgNEZGuIwjf7uK2mxyKXUJ7adtSKQBYtTC2Y8RJM2uGRX7f1W0fp+HDEsnt0d6rQ2+KqVEeRskf3lQx08v0nxyRb8rSHvzJpEQYU0cHStO4RYyZ4XzVa6ieM+tQlJAHRrRu8Xq74gCFw6c/eT5/2vSANcL5cmQr8FbAcvP7ifQ5E1u3Z8358SJrD/hYf7CGauoX4fLRq7/YXzEtSVrsEGI9/sRtgPnSQbjlRmTE7kAMtNvqQ2VoMRnAf9FKLdG4jLvQzdi0133YeUQ9sJ9DS/rbIM/QiI8WIf4VjB7TFiwIMDTVs/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDp8pWtrNuNNaW3qby1yV/GEWWViU3rQ/q/EK/J2S8w=;
 b=UVEjnJHUbDkbhrNAhEKyUf7ON+bnsgOF94yS1N4gmADHgKoLn7fz5zxml9oEA/xvlL/s/x+W1BYSQRWVYLMV6VV5Sn9RmQDgnsfDGf9Uh4IEzE8mr+f8lkGmFqiRCXc1A52DaV8kUClHFToyiy0BogV4g/5/7e7VsTHc3Cwux9o=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB8889.jpnprd01.prod.outlook.com
 (2603:1096:604:154::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Thu, 20 Oct
 2022 01:31:42 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4%3]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 01:31:41 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v4 1/3] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Thread-Topic: [PATCH v4 1/3] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Thread-Index: AQHY45W91kJumYuJdUOfIvcU+nG1nK4VqAqAgADXXZA=
Date:   Thu, 20 Oct 2022 01:31:41 +0000
Message-ID: <TYBPR01MB53418699D3420682CB8B3F31D82A9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com>
 <20221019083518.933070-2-yoshihiro.shimoda.uh@renesas.com>
 <11d6f585-bd9f-246f-29e0-719f0551e6c9@linaro.org>
In-Reply-To: <11d6f585-bd9f-246f-29e0-719f0551e6c9@linaro.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB8889:EE_
x-ms-office365-filtering-correlation-id: 359d2703-1932-47c9-957a-08dab23ad77c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tl14dKBNOlBAejC1TTafTJ3vkET91oDDXIGNYE27S/z4CF5nQNoo5hpqlfVpbnBy7eUctoLiN1lrk4iOjtojbIF8v0c2Ab6m7Mri/khtYbX7cxJOsh0HgZMElNDa5P9by5Ee3SEtBbMLdSNYS97g1jwoPPAWC1iPXl+nX33mUWgl5an04M1PvP6JwHS5ktyqGE3Wb2BMsN+Nxe7VPfr23f0lPuEECYpxE6Po6tBy4c6wgLoYI8d5EWx8ns0Sz+8sWQQ4CVWSX/NIRATebGOsWmaaC/Pehy8pArUDIA0rmM1bkUzntmlYz+ZfFwwd2K5PKk5s+vqpi3ZiB9gBZka2NQYI2sTLvtjdphX1XwfwH8DQ5b0Mv1g/675PhzhmRUqGh3kC6EBXpe9P2Tm2t8yPevyyEVLR7LO65byCkOtvv4qNov5nDGaSWTdzQ0GSMxGK+LiJ0eliem5Ffe7+/UMOXaxe2GwUSCCRAczrmVOG5NHwAzwYeZHr+5idTealHyriUy1JO5V0ngSl56ySwDzDVckdQHlArNIhzPV0DBs0sOoKVKBWcdeK35qS0JHCOeXQBdxgcj+jrjvpUlXJHV6POtorSVlNUfv0UUpiHeiZ4tFHoTJ/WpC9HFbi+Tdaimx00RKdyMKN6lBuRGDSlt+ok8B1FxlUWNe4dhhX6TdGT1aV6LESOpMRwGx8NCQUHo5K9hF4qX/LJDdA+vcQuvhuGHdwdI6hWeW+I+WR0l34JiQ9LMF5wG4i2QhAz8huyDzu2gZ2rfpkKG1h3Soc2GjcZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(66556008)(66946007)(38070700005)(33656002)(55016003)(86362001)(122000001)(38100700002)(76116006)(64756008)(316002)(8676002)(54906003)(110136005)(7416002)(66446008)(5660300002)(186003)(71200400001)(8936002)(66476007)(478600001)(7696005)(6506007)(4326008)(53546011)(2906002)(52536014)(9686003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTU1aWVDNnNyWmE3RHV0eWwrcVFLSW5PUlBVRjdsQVhQanpMSy9EOXRDUVFw?=
 =?utf-8?B?VHNWWWh3WjNaVHIvR25mK0NaZlpDUnRRelZCdm5tVjNXQXdkazFxTUttUk5s?=
 =?utf-8?B?ZkFUSFQ3Mkl5d2g4cXRTNVhMeG9PYmFoazNTV1gvMisxK3dvMndXVWpncXFo?=
 =?utf-8?B?NFlZYWhJa21ZZE5UMFZOVEEwN2NUeGNCaTRZUldwVE9meEpQZVplNEUybE1F?=
 =?utf-8?B?NklJVEdybGJnZDJaMHZUa2JNYWZBRGx2NjVaMHZJVGVmNGhuWnFEWWliOHA1?=
 =?utf-8?B?L0g4MkdBRk4rUHlrL2hFUDQ2eDgzK2ZMempTL05FbjVXK3dvS0h3Z0gvWGRi?=
 =?utf-8?B?bWlBOWtJdVA3aUd5RnhhOVZFSStPMG8vVGJYcHY0N0dRTDNKNDMxUnF4enY4?=
 =?utf-8?B?elJOS2dpQkpKdnlVZ2c1QmdzRmJxa25FK281YTVqcWpDaXZpQzBLZGZNZHVv?=
 =?utf-8?B?TitYUVlFL3o2NGhHMElqNjlnT2Rsd2EzZ2g0ZEVUeWRCVmQrRHRVUDdMbVla?=
 =?utf-8?B?VXFvYTFxak1Yanl0MHNzNEVMNUZUNmhUNC91RjMvRUdMZFVjaGg5RkpWNjJJ?=
 =?utf-8?B?cHpURXU4c0dtSStmRlp1Rlp6OHZzQXBiSEpFVXJCYVRrNVVkVlNRL2VseVZT?=
 =?utf-8?B?RnkxREs0N0V3TnBtMzIrSHdHVWx6c2NUc0Rrem5YTStTbWY1MHZFTFVRNnBE?=
 =?utf-8?B?Tysxalg0UENiZjdOQ29BUysrVnJPbUZWQXg3TVk1OTJJdGV2ZDBVWmFQMWtm?=
 =?utf-8?B?cWxYZjJBTjRYeFZFWUJ6NGMxaHJBREpqU1d0MUJvMENMc3k2N2xrQ1R4U1dJ?=
 =?utf-8?B?TFFOYXF4bXI0RXl4UTk1eTJ1bHM5cHViUnY5T3F0bERrcGQyNXNsaWQwdGNp?=
 =?utf-8?B?QTdLVFRoMURkV2VVcG5FTEVweVRpT2tQUUJKUndFbW4wdlEyTENsbmlZZGhx?=
 =?utf-8?B?aGdCbkV6VHNnd0ZRS2R2bTA0UTM4NFVqaG5JYW9MaVQwMHdjOGVFblg3ZmR5?=
 =?utf-8?B?bENxdk04Y2pndTA4azBCMUZacjlUdjh3ZDAxbzZKRWMyam1YaGJjY0draVBH?=
 =?utf-8?B?bDFISURrdm40bVdOcS9rU3o5bUJWQzkvWU5OMXJ2OSszdUxra2pueGhRWVJV?=
 =?utf-8?B?QlpyS01tMVZYczFOcVM5ekxsRmFtb0tKWDllU2hlc3E0QzNFdlk3bWlwMFdp?=
 =?utf-8?B?OExXU0MxM1NTMFRWNytsMTEvWmdwdGZ2bG40SXF0akxzV280aFcxYW5wK1dh?=
 =?utf-8?B?NVpncHdjclBXVm9SK2lzNVJkbGlMZUgrWkJmSG5oUi9qaURmV2xPc2hEV2hi?=
 =?utf-8?B?RVFabG5HMnlsTUpMSDczNUJtL0xmb0RTL0lqWGcwMU5YbU1qNDdkOUhLSTZJ?=
 =?utf-8?B?YnV0T3krelpGVy9mNDVLTExvUE1kRDZqWUV1YnJhSlBMQXlMVWdQb0t5ZzFG?=
 =?utf-8?B?ejdYNWZkbzRHc1BhUi93RHdka2ZlVVVSbWgyS0FtdDVIbFRJazhkNDV3YnhB?=
 =?utf-8?B?MTdaanlLajBNWUhpR09hUnZPYXVpaGlYOHc2bGtTayt4Vi82Yys4cnZOdU1z?=
 =?utf-8?B?bmZPdUp5NHFlUGEvTTBvNW4rUlVKWHI4YXBOKzQ4QlRYZjF2SUdiZno4dXFI?=
 =?utf-8?B?Z1dQNWZnVURQNUhOSHhuMTZjR0JEeGZhRVVSU3F4aUtyd2pmOUxlcjFqUk9S?=
 =?utf-8?B?eHh3TUhEMW5BUlkraWl0dGVSYkNwbzVTNmUvZGt2UHJUTHk2UzhkZ0t4U2N4?=
 =?utf-8?B?Y1pjQ29kUDJzbDdJblpSTE0vb3ZCTCtCeHEvMEl6WC9wRSt1RXorMmI1Wkt3?=
 =?utf-8?B?OXQ5SWJiZnVxY2VkYWFDbVp5UTVJLzFra0ZXZ3o1M1dKemJrRitzd1lWWkFj?=
 =?utf-8?B?Y2lrYnppU1NZU0hHem8rdUI5eEhKSjRnZkE5MG5JMnRuQjNxWHZYQjZWbWo1?=
 =?utf-8?B?QlpwdFY1d3JwZEs0MHg4NVZQN3BsRDZZTEwvQnM0d3I0eWNRT2VENzljeUxn?=
 =?utf-8?B?SlZaOU8wejU5NTJaRW9DcVlheFVOK0dXMTBWamtJSDZYcllnNmJHRnlEbnZM?=
 =?utf-8?B?d1N6dUM2WHhkbTgyZTQ1WkFzTVRSYTl1Qk5xekhkb28ybG9FZmN4YjBVb2hr?=
 =?utf-8?B?cEJMdDNzVHdvTHdhNW1ZbVR0bFh4UU8zR1V1eUpteGptaDB1V241QnB1TjVR?=
 =?utf-8?B?cmV4amI3YUNlMWJ5eWxzVTNvdFV4SDEwRVhOYWhsN3l5SCs2TlRTZGh5YytL?=
 =?utf-8?B?UFZMOXhBZXZnWnNpT3JmQWZyNmRnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 359d2703-1932-47c9-957a-08dab23ad77c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 01:31:41.8835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cBM+kjhCyDMu23bUGH07bbW+vFAbd9GpzmQuZHKakiDp2n/G0wOfhwjO5Od0DfSNbt9pMI6I4TKobSUlgxK7wCsRzMt/JRqfxl2vvBQ26c8o8u3ENwMCCJX+vuecPIPz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8889
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3J6eXN6dG9mLA0KDQo+IEZyb206IEtyenlzenRvZiBLb3psb3dza2ksIFNlbnQ6IFdlZG5l
c2RheSwgT2N0b2JlciAxOSwgMjAyMiA5OjM4IFBNDQo+IA0KPiBPbiAxOS8xMC8yMDIyIDA0OjM1
LCBZb3NoaWhpcm8gU2hpbW9kYSB3cm90ZToNCj4gPiBEb2N1bWVudCBSZW5lc2FzIEV0aGVyZW50
IFN3aXRjaCBmb3IgUi1DYXIgUzQtOCAocjhhNzc5ZjApLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogWW9zaGloaXJvIFNoaW1vZGEgPHlvc2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPg0K
PiANCj4gVGhhbmsgeW91IGZvciB5b3VyIHBhdGNoLiBUaGVyZSBpcyBzb21ldGhpbmcgdG8gZGlz
Y3Vzcy9pbXByb3ZlLg0KDQpUaGFuayB5b3UgZm9yIHlvdXIgcmV2aWV3IQ0KDQo+ID4gKyAgZXRo
ZXJuZXQtcG9ydHM6DQo+ID4gKyAgICB0eXBlOiBvYmplY3QNCj4gPiArICAgIGFkZGl0aW9uYWxQ
cm9wZXJ0aWVzOiBmYWxzZQ0KPiA+ICsNCj4gPiArICAgIHByb3BlcnRpZXM6DQo+ID4gKyAgICAg
ICcjYWRkcmVzcy1jZWxscyc6DQo+ID4gKyAgICAgICAgZGVzY3JpcHRpb246IFBvcnQgbnVtYmVy
IG9mIEVUSEEgKFRTTkEpLg0KPiA+ICsgICAgICAgIGNvbnN0OiAxDQo+ID4gKw0KPiA+ICsgICAg
ICAnI3NpemUtY2VsbHMnOg0KPiA+ICsgICAgICAgIGNvbnN0OiAwDQo+ID4gKw0KPiA+ICsgICAg
cGF0dGVyblByb3BlcnRpZXM6DQo+ID4gKyAgICAgICJecG9ydEBbMC05YS1mXSskIjoNCj4gPiAr
ICAgICAgICB0eXBlOiBvYmplY3QNCj4gPiArICAgICAgICAkcmVmOiAvc2NoZW1hcy9uZXQvZXRo
ZXJuZXQtY29udHJvbGxlci55YW1sIw0KPiA+ICsgICAgICAgIHVuZXZhbHVhdGVkUHJvcGVydGll
czogZmFsc2UNCj4gPiArDQo+ID4gKyAgICAgICAgcHJvcGVydGllczoNCj4gPiArICAgICAgICAg
IHJlZzoNCj4gPiArICAgICAgICAgICAgZGVzY3JpcHRpb246DQo+ID4gKyAgICAgICAgICAgICAg
UG9ydCBudW1iZXIgb2YgRVRIQSAoVFNOQSkuDQo+ID4gKw0KPiA+ICsgICAgICAgICAgcGh5LWhh
bmRsZTogdHJ1ZQ0KPiA+ICsNCj4gPiArICAgICAgICAgIHBoeS1tb2RlOiB0cnVlDQo+IA0KPiBX
aHkgZG8geW91IG5lZWQgdGhlc2UgdHdvIHByb3BlcnRpZXMgaGVyZT8gVGhleSBhcmUgcHJvdmlk
ZWQgYnkNCj4gZXRoZXJuZXQtY29udHJvbGxlciwgc28gSSBzdWdnZXN0IHRvIGRyb3AgdGhlbS4N
Cj4gDQo+IEkgYWxyZWFkeSBjb21tZW50ZWQgYWJvdXQgaXQgaW4gdjMuDQoNCkknbSBzb3JyeS4g
SSBtaXN1bmRlcnN0b29kIHlvdSBjb21tZW50cy4gSSB0aG91Z2h0IEkgc2hvdWxkIGRyb3ANCiJk
ZXNjcmlwdGlvbiIgb24gdGhlc2UgcHJvcGVydGllcyBhbmQgImVudW0iIG9uIHRoZSBwaHktbW9k
ZS4NCkknbGwgZHJvcCB0aGVtIG9uIHY1Lg0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hp
bW9kYQ0KDQo+ID4gKw0KPiA+ICsgICAgICAgICAgcGh5czoNCj4gPiArICAgICAgICAgICAgbWF4
SXRlbXM6IDENCj4gPiArICAgICAgICAgICAgZGVzY3JpcHRpb246DQo+ID4gKyAgICAgICAgICAg
ICAgUGhhbmRsZSBvZiBhbiBFdGhlcm5ldCBTRVJERVMuDQo+ID4gKw0KPiA+ICsgICAgICAgICAg
bWRpbzoNCj4gPiArICAgICAgICAgICAgJHJlZjogL3NjaGVtYXMvbmV0L21kaW8ueWFtbCMNCj4g
PiArICAgICAgICAgICAgdW5ldmFsdWF0ZWRQcm9wZXJ0aWVzOiBmYWxzZQ0KPiA+ICsNCj4gPiAr
ICAgICAgICByZXF1aXJlZDoNCj4gPiArICAgICAgICAgIC0gcmVnDQo+ID4gKyAgICAgICAgICAt
IHBoeS1oYW5kbGUNCj4gPiArICAgICAgICAgIC0gcGh5LW1vZGUNCj4gPiArICAgICAgICAgIC0g
cGh5cw0KPiA+ICsgICAgICAgICAgLSBtZGlvDQo+IA0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBL
cnp5c3p0b2YNCg0K
