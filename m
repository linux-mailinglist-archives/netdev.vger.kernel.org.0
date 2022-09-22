Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB4B5E5D4E
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiIVIUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIVIUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:20:16 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2100.outbound.protection.outlook.com [40.107.113.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264F3422D3;
        Thu, 22 Sep 2022 01:20:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwtqTIpta/BfUDS/ZRQRQSmMSWEDn85sVvJ6DmxFcFjMRjj/yP0Lk0xvDpAWb0Hfmqs3zg2v7ifE2ypCCofr+71UNqMM8djq3K4hkxRV5iZPo6C3EbN/fS+jreuWv4qy0hu+F7I6sae1JlJbf4I2u/uC6Uq274oogZBf+oWvFTg8DXKVqCVl3yTrllBoc1JfwDx0w7wO4sDpzpeq93VdVCwt3Oeqh3s7mNT62N3o5gpkQQJvCrS6e9+4E5obojbzBkM5QjwER5Ykr8YmKKGH2+3A8D5I6tOz4z0La99kIfv1aVznSNy5UppW8w7pQTU5WNNJtJB0pk2GCSwhhVvr7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P18E5XwWG0BkKzp/6VjkPLlbQaW34ergQZUPyLnunWU=;
 b=NuCJXpI/jILrUudf84SsPz3UaxzF+KdFl9ELjY35b70zPL7dqMGZPqWbx2+0dtqXP86hILW2etPmO5sohvUgPyq3+0YEYIPgn4sPx8gZSqD5+kARyeDqsOxLsTQ65kqjIjPlgzFvODBGCZzTLgR9ghktE3QaC/XQ6jhRrqGIxD4+d6L+jlV6Vxlo6VAUAHgiPj42ELTP7WApiltWGaLvVMjj6xpeOGkyesYl2wpsXBHd2hmn+ELmwW/Q6Q37zThnO6NU2jR6S3ij/j1W2uTo4p7xfkgjFMW3A/93lKF8q0gMvlnqlTILKCvS0Sdl9ZYATzMJl5DdpCo0mEJuF4i7CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P18E5XwWG0BkKzp/6VjkPLlbQaW34ergQZUPyLnunWU=;
 b=aEahvilmSsPiKBc3QwO72nvduklq+tvFmiO1khMqWt4Fk4KMJ3d0bxAscGRpy6/3yRxAY/3Q0dVIirRDsIIGWYHTkncNmFif9ZnxyY4wI0YRa1UYknFm2O1wKy0fn9q8rKSZrIwLAmX6/CylArkteQ+N67UGrrJO7q9EpYHV4zo=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB10359.jpnprd01.prod.outlook.com
 (2603:1096:604:1fb::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Thu, 22 Sep
 2022 08:20:11 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 08:20:11 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 2/8] dt-bindings: phy: renesas: Document Renesas
 Ethernet SERDES
Thread-Topic: [PATCH v2 2/8] dt-bindings: phy: renesas: Document Renesas
 Ethernet SERDES
Thread-Index: AQHYzZbyAdB5zxMt9EG9rj3m+K4rGq3rDseAgAAB7gCAAAWmAIAABSWA
Date:   Thu, 22 Sep 2022 08:20:11 +0000
Message-ID: <TYBPR01MB534120E881FFA267A65E8B7CD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-3-yoshihiro.shimoda.uh@renesas.com>
 <9b29ee3f-ed48-9d95-a262-7d9e23a20528@linaro.org>
 <TYBPR01MB534100D42EC0202CA8BEF04CD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <CAMuHMdV=HECSXtLi6BFRVFiYZvjJ_t5RDUY3DckbSB4ozEtOgg@mail.gmail.com>
In-Reply-To: <CAMuHMdV=HECSXtLi6BFRVFiYZvjJ_t5RDUY3DckbSB4ozEtOgg@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB10359:EE_
x-ms-office365-filtering-correlation-id: 608f4dc0-d138-4e79-b3c7-08da9c7344e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kz1r79NFJnl7OhHqjlQJIXyVhrV5mCsgi98IZ8RGjktT3p0uy2K++NDK3Z3rlrFnUkOSTDyHynwVNjOjjFGfyCrHE+FWogoXt07COgyE6jWz6IlETnEeF7i3zjWiQf0/ctiXkOrhUjQitlQoUSVCixN2bLYPIxUvxQhf9BVH9fHTpEdTsdwFqQzcD671lR9qhrXDs6SHKEUt2vZQ8ru6tVeS3bBIir7BEfPxbghbpifRsXWHJ5eYxYuxUEM4FyGGcE8eFlZJ9XEjanmwIXN5YoBFtBOcpzi6CfqtzmxZJOM4W92FQ4+1k8Iiy7unWJpoNmZ8V1C4BI52BYoLud0ydy5KEVmTGlMscne8h8cJoiJ5dMSts0kkoqL/1HLzcXQhes+27AcYXBfWYv3XAOn/T4FPLF6Pfucq2JDmOXBcBH7IdVODucroPfVYuYId7fjGPlNWAcrweoveDYbdUwdXguzEQp3vNxkQVRduG8DSOtoH2Kfd7sIv402wvozPfTlgvc2LTxzvdVD3gPOZf8NNJK7nimyMA062RYMj8cqzyyUy+ZScXrT6/JHxMQvVxNimDVp9G1vFos26vZNcshtk0ZMshM61B4MmU65T6RqCqFAxm7dw6d8g1bAVOe7LoTXd5c+Yex0YEiAxz7f810NA1iHRcuCdHpA/CuTe3E+JfY9FjK393XbyDITJFrRHeoYmi7wSb3/BUO/ypeHusHs5M5n5w5pKlwTQ0LmnDD1JaEo8ZULHWx4fGT7HGScev12oHProCj//R19xdU2xjTqqhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(8676002)(2906002)(316002)(38100700002)(122000001)(8936002)(6506007)(9686003)(26005)(53546011)(7696005)(52536014)(7416002)(55016003)(41300700001)(186003)(478600001)(38070700005)(86362001)(5660300002)(66946007)(64756008)(66556008)(66476007)(54906003)(76116006)(33656002)(71200400001)(4326008)(66446008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzBuQk9BVUFKMWVqU04zV2tTakNzdE9mcXdZY3B3aWlVbnZQRDdzZzV5VXpR?=
 =?utf-8?B?MTh0RFVsWmRpQmdhaFY2b2JKYktuK2d3S2huZFhQdkFvR21hOXJsTjdMTlJ4?=
 =?utf-8?B?QmM0WEhHZTZwVWN1VzkySWY0Z0tRb21CcmRJZ0pQdko0RW0xNlN1SDNLRlZE?=
 =?utf-8?B?Y3h2VS8rSndFOHZMaWw0cTlQdktkT01Lc0pXdklrVVRxU2xnOVVKU1JhNTF3?=
 =?utf-8?B?S0loLytiL3dncXkwd25pckFwR1V2OTJZNUNJOFI4RFpjeHVHVmJYeFh3M2ZO?=
 =?utf-8?B?L0ZDbnUxcklyR0JRL3Fka2tOWTB6MzlCMkQrS3BydHZFVkpVYUZETlFyaEVS?=
 =?utf-8?B?RnJ4eDFMa3krYmc5VmZ0cHhLaWRmYnpIckxaT2FBZGx0OG9KQ0xaVG9mMy9x?=
 =?utf-8?B?b3dYcnNpS24wak43OUhWa293VE1mVGhaSUs0eEcrenNSUDNUcEYvdmpNVUhI?=
 =?utf-8?B?cmN5NkhyMS8rUDhBYkk0RWxhTXR0UnRuRitKWjNRU3NWL2VXaGh1dnh5TlBG?=
 =?utf-8?B?cUZJTlo4T09BWUV0emVYc1VIUHMyRVVzZWloNHdSUjNZRTVVaXd5M2Fyd1lW?=
 =?utf-8?B?THAxZnpJazc1YlBMSExudWZNOFhZYU85V0ZRcGNDcmNjZzZwMjZScHQyVGRG?=
 =?utf-8?B?UjRXMWt6dnNMdm4rRXYxSkVEeUw2dXRtOTAweTQ0TFpDWDhnaTU5alB4MHYr?=
 =?utf-8?B?R09UVXYwaTFrWUZjdFFJZmhMWUFOYnhoTkYzazFsK0R0dDdLSGl2a1RUSUJi?=
 =?utf-8?B?eTZXRlVkYk9MRlJkakVnd2dxMGJuTUFJUVVMRDRDSHRWMGFTWDFqaCs4TDNy?=
 =?utf-8?B?VUlRM1dCVWZLNkE2dUl1bG1rVFVzN0Jod2dTVDlib2U5a1lvdktvaUtYSHlY?=
 =?utf-8?B?UjdpaWZYOHhGQlN0TzFSeENPRWxsT3dRbGNnbFp0bzV0bllEZ0UzU1dwYk1l?=
 =?utf-8?B?VzZ0eitrTHR4UlVUNzJYVFFySjZnazIweFcwMVFpblREVGtTakdIV29SNTFu?=
 =?utf-8?B?OGJyQkloTXpBQXRqbzJmWTQxVDJrWkprcFp5OW5reDlyMG1TaEZPanFpYmFZ?=
 =?utf-8?B?bStQR2lXWXY4bjVFUE8xOUN2VGxSQXVxNG9mS2JMcXQvUFhiNS9CdkwzRDJ5?=
 =?utf-8?B?VjVabFhqazNwb1dwaVliUDhjVUMrdHhJVll5OTRPc3F4SjdXcEZmaFV0blgr?=
 =?utf-8?B?eUdNMVN2U0F6K0lYR1hEUjFyZFIxR2JyM3Jna2xkMm5hQkJZcTBpZmV5ajNk?=
 =?utf-8?B?Vjk1L2krQUNQVmk0VHZQbVpXelhFVmVjNUJWVWdOWllvT0V6WUtnYkxEdTlM?=
 =?utf-8?B?UU9XZ2xIS21sV0lIMEJrT2dsQ3B3UGkvRkt4Mmd5aGJ6bjBFNjNCbldjdkQw?=
 =?utf-8?B?UWYzeitLcHpxK1l6ZHc2cjR5ZkNBcDlFamlWWDJzcGovdUZUcFVveG5jTFFW?=
 =?utf-8?B?aFkva0pMMU5uOS9xSkE0T1ZSTzhPMEZ6bHU2U3VsSjlyUTlTaFN2Y2h3N0Qr?=
 =?utf-8?B?cEtKOGlJZDNjbXVmdDNIOHU4V0N6dlpld3R6OTQ0L2pxVWY3SWZSVWxZU0hh?=
 =?utf-8?B?am45Qy9tVXEvSWRBQnYyUEFvYnRVQmlvOUJVRzNUZHUwdEhjYW1NR0luY3dj?=
 =?utf-8?B?QnpZLzlCcC9wSkVhRWwyTHlzNG14dG8wWUZKajZ5SlVkckdFN0NFbmI0UHNh?=
 =?utf-8?B?ZFJsYVpiWkxSTmpNWkZUb05ZaFJTRWRxYU5pdFpWK25JMzZZRjN6Mmtad2d5?=
 =?utf-8?B?M1h3YTIyT3QyeDFUT1JORGtVak1TWGpmUldMN2R4SCtSZ3BuTnVDVjl3eW8r?=
 =?utf-8?B?aS82T1diUDdod05ZMzBRRWxzbTFzUHIzVjV4NEQxYVFlbnF3WVFpdXcwcVoy?=
 =?utf-8?B?eUpoZjdhbVZvVVFhc3FqM1BYWXQvaVRpcGptZmZVN2IyRkFZa2ZtcThBcGRi?=
 =?utf-8?B?VGxiV0NuaXNaNUMvQ2lwTG02OFB0dHh6ekRqMVUzY3hXV0NqVjNaT01haVV3?=
 =?utf-8?B?bDU4NThCSFJRVHFNR2hQcjQ3Y0VKclkvMFpwU0NTSjliUE5CUFdMajB1bGVq?=
 =?utf-8?B?cGlWblYxNHJQRnhLaEl1bFdwQURFWGZBVFBrclV2SVhsUFl0c3VueVNPZ3No?=
 =?utf-8?B?dmJRNk5uc2NrMDZKck5qdWtRTDZJQlgvSkpUSVRoejZuMTE3OHJGbEJVbmtO?=
 =?utf-8?B?eGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608f4dc0-d138-4e79-b3c7-08da9c7344e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 08:20:11.6864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mr3ol4gEjVX1eU4AXVHoIzHIAziEIXhFI68+l+8L/z4JIBljWUlFvsDTJ1DdBhCs0PpFdCQqlown7OkRFIFu1YgUsAqvOgyBDkb1phLSKxJy5/+WHcipAeAx87oT3q6e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB10359
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogVGh1cnNk
YXksIFNlcHRlbWJlciAyMiwgMjAyMiA0OjU2IFBNDQo+IA0KPiBIaSBTaGltb2RhLXNhbiwNCj4g
DQo+IE9uIFRodSwgU2VwIDIyLCAyMDIyIGF0IDk6MzkgQU0gWW9zaGloaXJvIFNoaW1vZGENCj4g
PHlvc2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPiB3cm90ZToNCj4gPiA+IEZyb206IEty
enlzenRvZiBLb3psb3dza2ksIFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMjIsIDIwMjIgNDoy
OSBQTQ0KPiA+ID4gT24gMjEvMDkvMjAyMiAxMDo0NywgWW9zaGloaXJvIFNoaW1vZGEgd3JvdGU6
DQo+ID4gPiA+IERvY3VtZW50IFJlbmVzYXMgRXRoZXJlbnQgU0VSREVTIGZvciBSLUNhciBTNC04
IChyOGE3NzlmMCkuDQo+ID4gPiA+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFlvc2hpaGlybyBT
aGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT4NCj4gPiA+ID4gLS0tDQo+
ID4gPiA+ICAuLi4vYmluZGluZ3MvcGh5L3JlbmVzYXMsZXRoZXItc2VyZGVzLnlhbWwgICAgfCA1
NCArKysrKysrKysrKysrKysrKysrDQo+ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgNTQgaW5zZXJ0
aW9ucygrKQ0KPiA+ID4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9waHkvcmVuZXNhcyxldGhlci1zZXJkZXMueWFtbA0KPiA+ID4gPg0KPiA+
ID4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3BoeS9y
ZW5lc2FzLGV0aGVyLXNlcmRlcy55YW1sDQo+ID4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9waHkvcmVuZXNhcyxldGhlci1zZXJkZXMueWFtbA0KPiA+ID4gPiBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KPiA+ID4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLjA0ZDY1MDI0NGE2YQ0K
PiA+ID4gPiAtLS0gL2Rldi9udWxsDQo+ID4gPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9waHkvcmVuZXNhcyxldGhlci1zZXJkZXMueWFtbA0KPiA+ID4NCj4gPiA+
IEZpbGVuYW1lIGJhc2VkIG9uIGNvbXBhdGlibGUsIHNvIHJlbmVzYXMscjhhNzc5ZjAtZXRoZXIt
c2VyZGVzLnlhbWwNCj4gPg0KPiA+IEkgZ290IGl0LiBJJ2xsIHJlbmFtZSB0aGUgZmlsZS4NCj4g
DQo+IElzIHRoaXMgc2VyZGVzIHByZXNlbnQgb24gb3RoZXIgUi1DYXIgR2VuNCBTb0NzLCBvciBp
cyBpdCAoc28gZmFyKSBvbmx5DQo+IGZvdW5kIG9uIFItQ2FyIFM0LTg/DQoNClNvIGZhciBpdCdz
IG9ubHkgZm91bmQgb24gUi1DYXIgUzQgc2VyaWVzLg0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhp
cm8gU2hpbW9kYQ0KDQo=
