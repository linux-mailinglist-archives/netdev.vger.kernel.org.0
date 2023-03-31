Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2136D29E4
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjCaVTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCaVTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:19:35 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2080.outbound.protection.outlook.com [40.107.20.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2F420C2B
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:19:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ko7tdbXFLRtjiDvqPhTlqi3/Uk+ENh8eR/wxD0c/uxQO3LZXhnEmhyEBKU0lN/eMRG1jF81+FNOI7XLXIe61xZtQU1ZUNKNFIDj/uj2GTiyGxnQp2tfd1TUXjoHkWb/kpgV5LxVKW30cGP1Qf1BHg7W6Akvt2ARuRKsZPbNyz6MdMFoC9msP+LQQIrmeMXzEpghs4IFS5c4S6cVDKE7e65ojzjQ/hrX9tLG5RCd7ZsT8G1wx3PWR+oq+kwCHeIXrcEGE57e7AcWH7hZ03ww7QjSzQHlXYS88MhP5xZjYEmMl1oIOT/3v3VCtIKUZ8C7gUd/+hdj0oP6EU8NPAFQcog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nd4CsoqIl3oIo9w/U7uHhT1M3IwG8L10IvmKjjsz+pg=;
 b=aSFq0i+q8iYpKkZmNXHexdfOpRToFkEWXl2bAYWhTviI5keAS6Ks+Gyp9lFzhd+6gseV6BUd1uTpKwRcRRdSrmVDBQcYDkYpeRseuY5ygkEhAr4hovoqXtaiFgC9y/QEE/BhHh6Q+mlCbaPYmqsy1IwuMIaV3nfzEeui5BSBdHht0yabb6gJCdKqRFgzOfE+kpcq6+t3XfzxjexSeTOnHu9an0hxdmjOH5gJv6Vv4GHhMs6FJ4EUmMG0ni03HPqPCCTlCp12jteVNIaxmu27QAu5kEblSW828ukVm0ZEjG13jVKLhu+pZd71MIX2XxNMHFSuPsVn7UtXJ5iOJNaAEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nd4CsoqIl3oIo9w/U7uHhT1M3IwG8L10IvmKjjsz+pg=;
 b=bgqXDt36QEkDzi49wQXimut5KETfJgq9gaiFGTSpF2qpmG1X+n9MNdgZkY4dZ+Y+jqSw9rguLBGOJiCSx6VKBQUSYAlQGKDj/moMtWYvAWETjWBsq3OTOGDZpUAeLojcU8L5GNFbLHQKW50u+ssFD9umXjPvSlPmYXF29McetVo=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DB9PR04MB9992.eurprd04.prod.outlook.com (2603:10a6:10:4c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Fri, 31 Mar
 2023 21:19:31 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%3]) with mapi id 15.20.6254.023; Fri, 31 Mar 2023
 21:19:28 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v3 2/2] net: stmmac: dwmac-imx: use platform
 specific reset for imx93 SoCs
Thread-Topic: [EXT] Re: [PATCH v3 2/2] net: stmmac: dwmac-imx: use platform
 specific reset for imx93 SoCs
Thread-Index: AQHZZBOFHp9Z13mFVUqLL8rfSdvIea8VYX4AgAADJsA=
Date:   Fri, 31 Mar 2023 21:19:28 +0000
Message-ID: <PAXPR04MB918535411DF9ED8408EFE9CB898F9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20230331205759.92309-1-shenwei.wang@nxp.com>
 <20230331205759.92309-2-shenwei.wang@nxp.com>
 <CAOMZO5BwVWCMyiFG+HbjxeSvo+8x+1JtSmLmLmXWrWrsg6Cc7A@mail.gmail.com>
In-Reply-To: <CAOMZO5BwVWCMyiFG+HbjxeSvo+8x+1JtSmLmLmXWrWrsg6Cc7A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|DB9PR04MB9992:EE_
x-ms-office365-filtering-correlation-id: dea4aa1d-4a70-429f-6f0b-08db322d9c96
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D8xCNrYqq8ksryTT6rSmmxrKhmNAc9DQox4QDdhPBrzQz1roNQy2u/JtBekW/l31zIsb8oTinJjKRRbCIEGk8odKDnOw4GV1SZnz7bdgskxCTIPq0tzGxzK6PMJWFSAc1Z8PklHc+ha8f0uVdYJ272vBbRGTH4SWjEjLFPAgbhmU1MgVzp35epXR7N4vwYkYxTAbygYpdu+2diRjAVIi0MmzSQw3iTkBJ2p5qPEzj75aWcUkFujoc/hRWYwogmGjL+af/AI+hcog4QKyryYOYtcAkLj0CYmB3QMNcVw4d3kBdXN+w5AoZMhzmFl8sb8UbTSxfw02/eoeQyi/MtyqYmLptvNn0TtQ2rIQ4NQf5n895keomGiCxYrBvCacWL4kzEAmFih5mhTnDQTHGjsAc7gyNuMKjoCtYaY1m/xsyQaSdzkw1/+7rK9evBVykLScA3jsIIphaXU9eN+zY5ESMjGWmkfqrqUNketmawUN23vO/66N6yeX05vA9HAp2MvxfXFB9KS2i6rRwasGDmD0Z2n8dccOpZeXqT6OMtm0BcgCSIPbWjC+QLQNTM7D8Lg/Ihlx3BbwG9fId9wb6oe+KdY3mJmpRrAUVSJ7GEDDJLPOyYhi4hutIfiusg5IE+VT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(6029001)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(44832011)(76116006)(316002)(55236004)(53546011)(9686003)(6506007)(54906003)(33656002)(38100700002)(4326008)(122000001)(66476007)(66446008)(64756008)(26005)(8676002)(6916009)(66556008)(66946007)(186003)(478600001)(2906002)(38070700005)(7416002)(83380400001)(41300700001)(5660300002)(86362001)(71200400001)(55016003)(7696005)(52536014)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDNya0pvZzRFZjU5RFBWL3JGTlp5b1h4WUNlNlJ2ditFRWdKdGxaVXcwOFNG?=
 =?utf-8?B?Q2p1ZmhQWE8vbjFFWU9NMEoxeVhKWUVnVTVXMDV0UUhma0s5S085S21oSlla?=
 =?utf-8?B?VGwvQlRReFdaYzRabk5PZnoyUXJaYzkxbVVBSHBxekwzRUVmSldjU09jZTN2?=
 =?utf-8?B?amNZNDhQU2xna1FWN0VNa0M4Um96ZzNZbXFvTGMwQkpzejhGM1dKbHQwNi9U?=
 =?utf-8?B?Z3htQ1ljMUdSWHFsMUxFalBpTVRjQ0szaUtUcG5sc29UMnNDTkZPR3pwVHJi?=
 =?utf-8?B?Q2FwMk10SVBxZlRjQkQ3WGZ3QTd6b3JHYnVacE83Z2hsRjVVN2oxYUo3UUxl?=
 =?utf-8?B?OVY3NEtaaE9MN25vYUZndSt0UjE2TEFJOFJsS1J4SlFkZkxTNjlaWmozNkZl?=
 =?utf-8?B?R0pRNVI4R3Jna0hoN2R0RTdvazJwUTFmQmxpN293K29YV3IwcElXVC9hcURP?=
 =?utf-8?B?amVDZnlwREdtQlIzMUI3SHE4NGtBMFR6ZVN4bjg2WGs3WVFiKzBNZ1M2UHU5?=
 =?utf-8?B?WDk5M2V5Tm50cUhiUkl1aXFnd0ZIRklVTXJ5THJyMnVCcDZkV2FOeTE1TW1R?=
 =?utf-8?B?RjZCWjVONGVrd2htR050K2VJM2RLSDFjZzcvQ2dXVVYreHI5dDNrWTNMc3Rq?=
 =?utf-8?B?ckF1V1pxZVIvSFBETXdlVVlpUzB3Qyt6Ykx5QnR4RzY5dUJQNjZjdVYzblRi?=
 =?utf-8?B?MXBhRHBIKzMwbHltQ0drYWVBVVRwaW5sZmtTM09jTzRwZmlGWmZtRlFLcHNj?=
 =?utf-8?B?Y25hK3FpaEFXUy9STHFqNFpoSHRGQ3ljWGl0SkFZVFMwV3VWNnFUK1VSR2Jo?=
 =?utf-8?B?ZHJHMWQvNmRzMWY1ZTFmb20zeWllc29qNk4yVVErSTRTQUE4aHdMVE1KRUs5?=
 =?utf-8?B?clVacFJMUDRtSjdKTHBQRFArME1pYnNNbVFUbUp4Vm1ZZlVLUThhdW9zRzJt?=
 =?utf-8?B?UitIRUdFS216MkEwZ1QreVl1YmQ4bDNzaWVUL3greWV2dTBSak9hZXFiYXdx?=
 =?utf-8?B?MzVURGRGbFl6Tm5Ja1lvNWxnQkZmbERxakFCN2RiOExOOWY5MXpUKzIvTHFh?=
 =?utf-8?B?dHltMkJyWHVlY2hxN2JVQm4xTXpJSWFQYW9jN2pyeEZXZlVhM0VRcmxBSCtV?=
 =?utf-8?B?bG1PaGFJRjlldm9kck9aUWhmSklZRXdZZ1JMWUtUQ3hadExmbkYyRWlOVVBO?=
 =?utf-8?B?NG1xQnczS3RISFJTTGJmcnBOZDFvUzcrOWdvNk52NnVOckhjQ24zUHBOellv?=
 =?utf-8?B?OG9FTE9lcmpoc1d0UzFVVVZXY05yUTRKUUNZc21TdHpMR2c2bllUZm9EeEVH?=
 =?utf-8?B?MWIvV1JLWWdYK2dtQVUvWFVnQkNwOUxMVUR1ZFk5eTc0cTA3WkltejMwNHlP?=
 =?utf-8?B?NHphQ1ZUT0laOWJmS0xrSzdySDIraHFCVWUyUHhDMXRtNjYyREdGSFk5emhF?=
 =?utf-8?B?YkZtaXhsYmdhaDhVbWd0NTlyRktxdEFteUg0cVVhVnkrL1NIcGdWQnU0V0wx?=
 =?utf-8?B?aVZBTWpMV1lrU0gwNktoYXRsNjZudUZ6R2JrOGxQT3R4MFV0WHEwYTVkS29z?=
 =?utf-8?B?Q1VJSnp2WXBhYU1DdDRtakd6NGdBWTFLTzBwZ3AwSjRoSWw1bG1tQmN2Y3Q0?=
 =?utf-8?B?SlBxZUNNdTlUN21SK0U1SVU3bDdlSDhiZzk1bDN3NlFMTStZanhYQ1A0anl6?=
 =?utf-8?B?NGZQVFE0ZVZyL3ptdUFDQ0Jaa2FvdWszTnNlWlJUb1VhbE0wcUdIUXh3Mm5y?=
 =?utf-8?B?ZG0ydmQ3aWJQQm5WUGZ1WUVtdS9jVHJSbVZPbnFLc1dsd1Z6NTNzcitJOGlG?=
 =?utf-8?B?NVNHR2E4bDN2bHptSE5PaDh5VEVkYmZ3blUxT2ZxNmFTcHVveW42cGtmMG00?=
 =?utf-8?B?Zktva1RQN0ZjdmFsblM3RkxvNTRscVY2ZncrUkIzTnFXMEM5ajRQK0VVUjVz?=
 =?utf-8?B?aU9VcTZGN0lXcFVvS1NjNG8rQUlETkp4R3lweGRwanY1TGNhb25rZjNsVmxR?=
 =?utf-8?B?dEYwSUZneU9MOWVMY0IySTdMVUszYTNxSDY4dzRiUGhTMXNiTXNDZmZscllW?=
 =?utf-8?B?OTJWaWlPRHRCY0lPd0pzMmlwUkdrY1M1SnB5VFQ2YVpDTmJtMHEvR1d2L2RT?=
 =?utf-8?Q?22/8T0kqj3H5A51NB3Mp+2G1r?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dea4aa1d-4a70-429f-6f0b-08db322d9c96
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 21:19:28.4827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RkwWjeS3reC8kMJPmfhz7jvaWuylUdCNjPOFu1UDbDT/cXXity04AkPqDz0VRjBH+5fL84aSMsNh5k409iGmBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9992
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmFiaW8gRXN0ZXZhbSA8
ZmVzdGV2YW1AZ21haWwuY29tPg0KPiBTZW50OiBGcmlkYXksIE1hcmNoIDMxLCAyMDIzIDQ6MDgg
UE0NCj4gVG86IFNoZW53ZWkgV2FuZyA8c2hlbndlaS53YW5nQG54cC5jb20+DQo+IENjOiBEYXZp
ZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBFcmljIER1bWF6ZXQNCj4gPGVkdW1h
emV0QGdvb2dsZS5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8g
QWJlbmkNCj4gPHBhYmVuaUByZWRoYXQuY29tPjsgTWF4aW1lIENvcXVlbGluIDxtY29xdWVsaW4u
c3RtMzJAZ21haWwuY29tPjsNCj4gU2hhd24gR3VvIDxzaGF3bmd1b0BrZXJuZWwub3JnPjsgU2Fz
Y2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRlPjsNCj4gR2l1c2VwcGUgQ2F2YWxsYXJv
IDxwZXBwZS5jYXZhbGxhcm9Ac3QuY29tPjsgQWxleGFuZHJlIFRvcmd1ZQ0KPiA8YWxleGFuZHJl
LnRvcmd1ZUBmb3NzLnN0LmNvbT47IEpvc2UgQWJyZXUgPGpvYWJyZXVAc3lub3BzeXMuY29tPjsN
Cj4gUGVuZ3V0cm9uaXggS2VybmVsIFRlYW0gPGtlcm5lbEBwZW5ndXRyb25peC5kZT47IGRsLWxp
bnV4LWlteCA8bGludXgtDQo+IGlteEBueHAuY29tPjsgV29uZyBWZWUgS2hlZSA8dmVla2hlZUBh
cHBsZS5jb20+OyBUYW4gVGVlIE1pbg0KPiA8dGVlLm1pbi50YW5AbGludXguaW50ZWwuY29tPjsg
UmV2YW50aCBLdW1hciBVcHBhbGEgPHJ1cHBhbGFAbnZpZGlhLmNvbT47DQo+IEpvbiBIdW50ZXIg
PGpvbmF0aGFuaEBudmlkaWEuY29tPjsgQW5kcmV5IEtvbm92YWxvdg0KPiA8YW5kcmV5Lmtvbm92
YWxvdkBsaW5hcm8ub3JnPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtc3RtMzJAc3Qt
bWQtDQo+IG1haWxtYW4uc3Rvcm1yZXBseS5jb207IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5m
cmFkZWFkLm9yZzsNCj4gaW14QGxpc3RzLmxpbnV4LmRldg0KPiBTdWJqZWN0OiBbRVhUXSBSZTog
W1BBVENIIHYzIDIvMl0gbmV0OiBzdG1tYWM6IGR3bWFjLWlteDogdXNlIHBsYXRmb3JtDQo+IHNw
ZWNpZmljIHJlc2V0IGZvciBpbXg5MyBTb0NzDQo+IA0KPiBDYXV0aW9uOiBFWFQgRW1haWwNCj4g
DQo+IEhpIFNoZW53ZWksDQo+IA0KPiBPbiBGcmksIE1hciAzMSwgMjAyMyBhdCA1OjU44oCvUE0g
U2hlbndlaSBXYW5nIDxzaGVud2VpLndhbmdAbnhwLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBU
aGUgcGF0Y2ggYWRkcmVzc2VzIGFuIGlzc3VlIHdpdGggdGhlIHJlc2V0IGxvZ2ljIG9uIHRoZSBp
Lk1YOTMgU29DLA0KPiA+IHdoaWNoIHJlcXVpcmVzIGNvbmZpZ3VyYXRpb24gb2YgdGhlIGNvcnJl
Y3QgaW50ZXJmYWNlIHNwZWVkIHVuZGVyIFJNSUkNCj4gPiBtb2RlIHRvIGNvbXBsZXRlIHRoZSBy
ZXNldC4gVGhlIHBhdGNoIGltcGxlbWVudHMgYSBmaXhfc29jX3Jlc2V0DQo+ID4gZnVuY3Rpb24g
YW5kIHVzZXMgaXQgc3BlY2lmaWNhbGx5IGZvciB0aGUgaS5NWDkzIFNvQ3MuDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBTaGVud2VpIFdhbmcgPHNoZW53ZWkud2FuZ0BueHAuY29tPg0KPiA+IC0t
LQ0KPiA+ICAuLi4vbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLWlteC5jICAgfCAy
OSArKysrKysrKysrKysrKysrKystDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyOCBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtaW14LmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLWlteC5jDQo+ID4gaW5kZXggYWM4NTgwZjUwMWUyLi4z
ZGZkMTM4NDA1MzUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNy
by9zdG1tYWMvZHdtYWMtaW14LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1p
Y3JvL3N0bW1hYy9kd21hYy1pbXguYw0KPiA+IEBAIC0xOSw5ICsxOSw5IEBADQo+ID4gICNpbmNs
dWRlIDxsaW51eC9wbV93YWtlaXJxLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9yZWdtYXAuaD4N
Cj4gPiAgI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4NCj4gPiAtI2luY2x1ZGUgPGxpbnV4L3N0bW1h
Yy5oPg0KPiA+DQo+ID4gICNpbmNsdWRlICJzdG1tYWNfcGxhdGZvcm0uaCINCj4gPiArI2luY2x1
ZGUgImNvbW1vbi5oIg0KPiANCj4gVGhlc2UgY2hhbmdlcyBpbiB0aGUgaGVhZGVyIHNlZW0gdG8g
YmUgdW5yZWxhdGVkLg0KPiANCg0KWW91IGFyZSByaWdodC4gV2lsbCBmaXhlZC4NCg0KVGhhbmtz
LA0KU2hlbndlaQ0KDQo+IEFwYXJ0IGZyb20gdGhhdDoNCj4gDQo+IFJldmlld2VkLWJ5OiBGYWJp
byBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+DQo=
