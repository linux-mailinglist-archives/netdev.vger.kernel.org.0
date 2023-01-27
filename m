Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0945367E22D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjA0KuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbjA0Ktw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:49:52 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2117.outbound.protection.outlook.com [40.107.113.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE63A68AE2;
        Fri, 27 Jan 2023 02:49:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1vO1RykrMxPkJGR4VkCc8bhccaHFeFDkMiGvFGshMg28hmtlicjVzcIK7S/3sgF4HT6UFKtPhpKmefUJJwE/pVc4aiO17eimOwB8q+FNF7dlhKqugnaOPyOH8Oe7amyyaKC7yQyJdXNECUwH6dd4SjAVbwzdR9VVXvMhJibm7YdHCLZvriTuYCFcRK0ZIL4xk9iLVt5MA1HzeM7WCApqHaekvLEACGxTkcZ0+dWxm0GgJaKW+CbgUnchucaUR4JDhAnfnEEVaQ5xRh3K/YxnpuRFDDLQGc+mYR7vWUzKhtIW3Xs1RvIfi0Pk9PxJkbVzZznlTQrfHGQgbmXM1xdCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7fsLj203qBG6e9asYLgmxG5uAvIqZvX1AIBrJ+5WHw=;
 b=c19NchDHn5X77BNERCuCUVMJ/lywDHJBGMHbmDJiNYesgP0hmGEunnKKCRmiV8I5UdBOs1+6CNydXwtFdz8gGpFtjZuPHsidKMAvj8VUBQ42nKxMwkmMkz+dIPe6H1pCboBT2mkCytfLaN7JES+GyoKJopMCU7m2D2T1VXBrdvCVsLJthsgV4a3P7OXVaYmiH994uM0VivOpExuPZzkF5YwSXOdxmipkYw7cZ0Ox8xAAnFt4v5I42uJJ/q/mXt4Iulq8skGumJjW1XRXtTd19CZJrnqwToe55wAHmabZHgnxSH17ytIqJrj+7HFB0Hx+7iBficzNG8EW7Q+Ejp4jDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7fsLj203qBG6e9asYLgmxG5uAvIqZvX1AIBrJ+5WHw=;
 b=g3254hBmQNTlPtqCsKVzVS9SDnG4jc9NMAaKjc23tgnvlBkCefeXh8qw+KRLWiSjhd3WZoLTtX24Py7b/zINhqNfzRguOHe6EodRlp0zfFo+eTQ7OSs3lgnCxnQ7sWzKnMDY+P5Vq6oH+89taFxQ8srtXK6h2CXOoy5SgihA1QU=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB6086.jpnprd01.prod.outlook.com
 (2603:1096:604:d1::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 10:49:48 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%9]) with mapi id 15.20.6043.025; Fri, 27 Jan 2023
 10:49:45 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/4] net: ethernet: renesas: rswitch: Simplify
 struct phy * handling
Thread-Topic: [PATCH net-next v3 2/4] net: ethernet: renesas: rswitch:
 Simplify struct phy * handling
Thread-Index: AQHZMfFtw1DOuFLdXkS3pQIN+qxRQa6x8ICAgAAcg1A=
Date:   Fri, 27 Jan 2023 10:49:45 +0000
Message-ID: <TYBPR01MB5341B6EE4C61215612936370D8CC9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230127014812.1656340-1-yoshihiro.shimoda.uh@renesas.com>
 <20230127014812.1656340-3-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdXGNWZ6NQxFKKJ-aWKO6YG=dD+jeJynDyK9XZNRx=hgJA@mail.gmail.com>
In-Reply-To: <CAMuHMdXGNWZ6NQxFKKJ-aWKO6YG=dD+jeJynDyK9XZNRx=hgJA@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB6086:EE_
x-ms-office365-filtering-correlation-id: 145f270c-08f0-47ae-cbe0-08db00543456
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kKmH2RuTRah8ZuCWv3+eIlhHtvBfWgxmdshoGaKsCKWFBQiSXkBq340t3iAvyzp5wm9yv/vB4wuXtW/vWMGGiGwhYNlDVpNHfIXQy5UPPvrpyrvWmfTPUHm9Y1DDOAqodpPtn37KXqlldD3Qed0uJ9N38ihPTcFkR9Kn3pQ9xsIHmXQBK2484h92nWJwVL7vGX9N+WQBLS5Ptmd811CQ68Dt5XaPHIGgGrjzGD1IbBQIZ25HM4YCSnomiajvvgqehR250UtALAzDE4G4H97/IoymNlmvblceXLcsbkuB2D3njz0JFmaCYTjXLbisiojjQ8ZtIlgKCKFxfj+/W2v6x0w+XjfnpyCJUeB9444r39mu9/o80K+ylRKrFsHvdE/sOicsCyc8tb292VpgI5Z5EpYRTJdD2BMuYJXUXTEs3FAbj60S6MJpP2tkW3FV8LTGitOicmOQRqPi6wUqp1DmFfmE0NTWCXn+jl0ILTvZ8H+XE2kuLd2nvC2LjQR/YmPoVGXDb3UuxBAIVaOrrxVe1KeofUPoRzaYnclmHiI1NwoXN9tPNL8QwR4aZAnO2JSHMaUjsob65omOqBbDBEKvkPgPGHk2K5EmomEYr6oTaegiyXv7LXWtA5Zb4jd6L5ZPDNKkyzV4lpTAPTmGfHmwEtgGvVRpMV7Gx/YUXO1dxlATYs6ECMvr4dN5xPFmV7t9Sww4tnYlfLEnojAZX8jbyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199018)(9686003)(33656002)(478600001)(53546011)(186003)(38070700005)(26005)(54906003)(122000001)(38100700002)(8936002)(55016003)(41300700001)(316002)(71200400001)(52536014)(5660300002)(2906002)(7416002)(7696005)(4326008)(8676002)(66556008)(86362001)(66446008)(76116006)(66946007)(64756008)(66476007)(6916009)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGZYdDlqMFBNWDZyMmVtV0xaeUxzZkVkOEVaMVBkTkxQeDVIMmI5aUt1eTNt?=
 =?utf-8?B?MWhEVktpZ2EvNjdrNXVWTnVQQzY3MnNFd1ZOa20rTzYvU2Y0MnFjVnRhWDhU?=
 =?utf-8?B?OGhsQjVKdkJMajhkMUcvbzRXdXp4UnRpMU1lS0tTQmQ1Yk84ZkVIWkdtZERH?=
 =?utf-8?B?K05QRnFaajZ2NHYvdnc0OTdPN3BlZjNvc0NWSm56VlhkRDBOWEZKWmdiTmtE?=
 =?utf-8?B?M1RjRE5Xd0NmMGF4RjA0eUdCbW5SR2ZLeUpUWDRMUEQ1c1I1SkU3MXp4TTBt?=
 =?utf-8?B?N3VOd0NhYUh0MkIvdUl0cWZRUnRsUFY0NklKRWFUV2dxbmY3aWZkakZVazdK?=
 =?utf-8?B?V2FPbmhBR0FRRVhoL0VJRWpFQTZXWDNKVGtObG1KRThJc2YyQm53bzdDUUNQ?=
 =?utf-8?B?RVVpcnpTQmh0QUdzZDlobGZNZVpmZ1dHbVpVa0ljeExhdWdHTWNmQktyNUdu?=
 =?utf-8?B?R3dKZDJ4Vjl6WEZFdVljODdEaHRrMWlkdlhwWURiLzZoM2tCQ2p5YkE0ejNo?=
 =?utf-8?B?a05YcG5hYUhnNC9ldGNnMCt4WUpKM0lnbmtoa0xoVGtPVHkyeFBDdVNpNDky?=
 =?utf-8?B?ZWRQQnRUOS9LN280SHVYZ0lrSVpnUExac3VrUk9JUjRoQ0svQjYzSFd3a3RH?=
 =?utf-8?B?SmZhd0pLUkdXczZ2T0J3Vmt6SlZpeDVmczA5YnU2SHBaT1RkOFFoMmx6aXNL?=
 =?utf-8?B?ejVxUmlnWE5PK1RZd3pTU2duaU1ZdHJNR1FNNUl3Z0JYcHhieHJrNDdJZ1p2?=
 =?utf-8?B?Mzd3WFhQckNYbHNCSGdyN1V5RTVDWTgvSUlKT2tLTmxNTkhHWmVtVlZCM1lO?=
 =?utf-8?B?c3RqS1ZGZUtMaGNLdjAxajVLcXYxZVljdzZmS0RKclNNZCtJajJrTmZsOUFq?=
 =?utf-8?B?UzJvbmJuVW9Dem41V0pGRWJ2YUlBWU5IM1JrSkd2dWhEK1c2S1FjMWlXcWJu?=
 =?utf-8?B?SHk3VGMvTjN6NVVKazNITm54WlpZOTZJL1ovNjdiTkU2ZVMyMG50RENkTjZO?=
 =?utf-8?B?UWhFU2RzWDFSUDNBZ3NDY2JmdTNHVTRuc1BQa0h0RHdDbzZzcWRuVVBhWGUw?=
 =?utf-8?B?NXY3b2NHL2htZTVYTXk1T2t6engvZit6M2QyTU43dmtpSTMyTy9lTGo2MXV4?=
 =?utf-8?B?LzBKVjBra1oyQy8yUzdxL3FCSWRaQ0RjR3dSa3VpdXdmZloxWS9vYXhiOUhn?=
 =?utf-8?B?YUVNdXVHVVBmeUVveThSc01GYVpQQ1ZBSFhUOVk0czFydDRNMVEzcTJqMmlR?=
 =?utf-8?B?Z3hNSXYxek1GcmZSU0JjQ3FnV1lPYkZreDk4VDAwZUxpOGN0djFHNmNrZ3Zw?=
 =?utf-8?B?V3gzV2ZQNVJDS2plRGdEdzl1NGt5TnB1RmhrM0pVbFB1dXpvYkhraXRZYXJI?=
 =?utf-8?B?Z2ROUUZrYkp5WithcWZtdkVYb0s4RTM5VjFZOFlCTXQ1NFZGa3ZKNWpBemJI?=
 =?utf-8?B?QVM5U2orN3c2WXdONUl0MDJ5SmtwTXViNWFRVHFUZTFVQ0xaWUFNQXB1MGNC?=
 =?utf-8?B?SnR3Ym85S0k0NnNXN1UyUkZvNU0yUFB6Z01lNUx2OU4zVHFGZ3lFZGdOZnh6?=
 =?utf-8?B?clVSS0IxRVJWalFacW9QRWQwR1NpWVF5Szg3OEZMTUFZZ05mSU5taENmY2Vq?=
 =?utf-8?B?bEdzTTJPSDA5Nlh0QVhUNE1NbmhpVUVpM0ZJMVA3MGY3TUgyQ2ZKK0ZPWVNL?=
 =?utf-8?B?d3FtVTc2aFdjTTRBZmJsWHNOS2lqeE5SVk1XUGJraWlOdEdaVVRkM3NYdWFy?=
 =?utf-8?B?RUZHcVp2Yk5YakZNZGhKT1A2ZkkvRTJadzkySWY5RWxQcDU1azNCTEk4aTYr?=
 =?utf-8?B?K2lrOW5QdW9YL1JwOGRQRFE4cHIwYWNSQXhHdU4vcE9wRmNVajJCT3RBMkdS?=
 =?utf-8?B?Q3dCVVA3ZDg1dXhqN2JEUERjeWp4Yk5wWFNNdmtaUDhwVGZpLzFKSmF6QkVp?=
 =?utf-8?B?c0NndlpTdGdReFlCUHJUUzJxZnRUaHZHMTZ5dEF3emdpeWk4d0cwOVpOa2FV?=
 =?utf-8?B?aUFuaVYxQzhPNm5PK2FZSnRvWDBYdmNzQUxyWmVYSFpMdHkzRkZsaVNLcUFi?=
 =?utf-8?B?d1Bodks3bkNXR2JLS0FncnRTMStLemRSMGp4T2pMdyt4cXJLMFNndUg0ejV3?=
 =?utf-8?B?WlBIS3FCYm01dE1DcUEwR0NmV0h3TnVRTGgxMm9XY3l4L3JwbEs5MjNUQmFN?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 145f270c-08f0-47ae-cbe0-08db00543456
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2023 10:49:45.7632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sXjZLK3joF8fM0vDcTKrrIzZNTKzDpSfomO8Mkvc9UxZag1PXzdsYGGN/qd3xkLNHs4b3FK/h4VAdmzUQnigkUXNZdXew2NsND4VlLKJqeV4VadivSxPmg1QMmBfBQlq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6086
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogRnJpZGF5
LCBKYW51YXJ5IDI3LCAyMDIzIDU6MzUgUE0NCj4gDQo+IEhpIFNoaW1vZGEtc2FuLA0KPiANCj4g
T24gRnJpLCBKYW4gMjcsIDIwMjMgYXQgMjo0OSBBTSBZb3NoaWhpcm8gU2hpbW9kYQ0KPiA8eW9z
aGloaXJvLnNoaW1vZGEudWhAcmVuZXNhcy5jb20+IHdyb3RlOg0KPiA+IFNpbXBsaWZ5IHN0cnVj
dCBwaHkgKnNlcmRlcyBoYW5kbGluZyBieSBrZWVwaW5nIHRoZSB2YWxpYWJsZSBpbg0KPiA+IHRo
ZSBzdHJ1Y3QgcnN3aXRjaF9kZXZpY2UuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZb3NoaWhp
cm8gU2hpbW9kYSA8eW9zaGloaXJvLnNoaW1vZGEudWhAcmVuZXNhcy5jb20+DQo+IA0KPiBUaGFu
a3MgZm9yIHlvdXIgcGF0Y2ghDQoNClRoYW5rIHlvdSBmb3IgeW91ciByZXZpZXchDQoNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jzd2l0Y2guYw0KPiA+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcnN3aXRjaC5jDQo+ID4gQEAgLTEyMjIsNDkgKzEy
MjIsNDAgQEAgc3RhdGljIHZvaWQgcnN3aXRjaF9waHlsaW5rX2RlaW5pdChzdHJ1Y3QgcnN3aXRj
aF9kZXZpY2UgKnJkZXYpDQo+ID4gICAgICAgICBwaHlsaW5rX2Rlc3Ryb3kocmRldi0+cGh5bGlu
ayk7DQo+ID4gIH0NCj4gPg0KPiA+IC1zdGF0aWMgaW50IHJzd2l0Y2hfc2VyZGVzX3NldF9wYXJh
bXMoc3RydWN0IHJzd2l0Y2hfZGV2aWNlICpyZGV2KQ0KPiA+ICtzdGF0aWMgaW50IHJzd2l0Y2hf
c2VyZGVzX3BoeV9nZXQoc3RydWN0IHJzd2l0Y2hfZGV2aWNlICpyZGV2KQ0KPiA+ICB7DQo+ID4g
ICAgICAgICBzdHJ1Y3QgZGV2aWNlX25vZGUgKnBvcnQgPSByc3dpdGNoX2dldF9wb3J0X25vZGUo
cmRldik7DQo+ID4gICAgICAgICBzdHJ1Y3QgcGh5ICpzZXJkZXM7DQo+ID4gLSAgICAgICBpbnQg
ZXJyOw0KPiA+DQo+ID4gICAgICAgICBzZXJkZXMgPSBkZXZtX29mX3BoeV9nZXQoJnJkZXYtPnBy
aXYtPnBkZXYtPmRldiwgcG9ydCwgTlVMTCk7DQo+ID4gICAgICAgICBvZl9ub2RlX3B1dChwb3J0
KTsNCj4gPiAgICAgICAgIGlmIChJU19FUlIoc2VyZGVzKSkNCj4gPiAgICAgICAgICAgICAgICAg
cmV0dXJuIFBUUl9FUlIoc2VyZGVzKTsNCj4gDQo+IFlvdSBtYXkgYXMgd2VsbCBqdXN0IHJldHVy
biBzZXJkZXMuLi4NCj4gDQo+ID4gKyAgICAgICByZGV2LT5zZXJkZXMgPSBzZXJkZXM7DQo+IA0K
PiAuLi4gYW5kIG1vdmUgdGhlIGFib3ZlIGFzc2lnbm1lbnQgaW50byB0aGUgY2FsbGVyLg0KPiBU
aGF0IHdvdWxkIHNhdmUgb25lIGlmICguLi4pIGNoZWNrLg0KPiANCj4gQWZ0ZXIgdGhhdCwgbm90
IG11Y2ggaXMgbGVmdCBpbiB0aGlzIGZ1bmN0aW9uLCBzbyBJJ20gd29uZGVyaW5nIGlmIGl0DQo+
IGNhbiBqdXN0IGJlIGlubGluZWQgYXQgdGhlIHNpbmdsZSBjYWxsc2l0ZT8NCg0KSSB0aGluayBz
by4gVGhhbmsgeW91IGZvciB5b3VyIHN1Z2dlc3Rpb24hDQoNCj4gQlRXLCB0aGVyZSBzZWVtIHRv
IGJlIHNldmVyYWwgY2FsbHMgdG8gcnN3aXRjaF9nZXRfcG9ydF9ub2RlKCksIHdoaWNoDQo+IGNh
bGxzIGludG8gRFQgdHJlZSB0cmF2ZXJzYWwsIHNvIHlvdSBtYXkgd2FudCB0byBjYWxsIGl0IG9u
Y2UsIGFuZCBzdG9yZQ0KPiBhIHBvaW50ZXIgdG8gdGhlIHBvcnQgZGV2aWNlIG5vZGUsIHRvby4g
IFRoZW4gcnN3aXRjaF9zZXJkZXNfcGh5X2dldCgpDQo+IGJlY29tZXMgYSBjYW5kaWRhdGUgZm9y
IG1hbnVhbCBpbmxpbmluZyBmb3Igc3VyZS4NCg0KSSB1bmRlcnN0b29kIGl0LiBJJ2xsIG1vZGlm
eSBpdCBvbiB2NCBwYXRjaC4NCg0KPiA+ICsNCj4gPiArICAgICAgIHJldHVybiAwOw0KPiA+ICt9
DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IHJzd2l0Y2hfc2VyZGVzX3NldF9wYXJhbXMoc3RydWN0
IHJzd2l0Y2hfZGV2aWNlICpyZGV2KQ0KPiA+ICt7DQo+ID4gKyAgICAgICBpbnQgZXJyOw0KPiA+
DQo+ID4gLSAgICAgICBlcnIgPSBwaHlfc2V0X21vZGVfZXh0KHNlcmRlcywgUEhZX01PREVfRVRI
RVJORVQsDQo+ID4gKyAgICAgICBlcnIgPSBwaHlfc2V0X21vZGVfZXh0KHJkZXYtPnNlcmRlcywg
UEhZX01PREVfRVRIRVJORVQsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJk
ZXYtPmV0aGEtPnBoeV9pbnRlcmZhY2UpOw0KPiA+ICAgICAgICAgaWYgKGVyciA8IDApDQo+ID4g
ICAgICAgICAgICAgICAgIHJldHVybiBlcnI7DQo+ID4NCj4gPiAtICAgICAgIHJldHVybiBwaHlf
c2V0X3NwZWVkKHNlcmRlcywgcmRldi0+ZXRoYS0+c3BlZWQpOw0KPiA+ICsgICAgICAgcmV0dXJu
IHBoeV9zZXRfc3BlZWQocmRldi0+c2VyZGVzLCByZGV2LT5ldGhhLT5zcGVlZCk7DQo+ID4gIH0N
Cj4gPg0KPiA+ICBzdGF0aWMgaW50IHJzd2l0Y2hfc2VyZGVzX2luaXQoc3RydWN0IHJzd2l0Y2hf
ZGV2aWNlICpyZGV2KQ0KPiA+ICB7DQo+ID4gLSAgICAgICBzdHJ1Y3QgZGV2aWNlX25vZGUgKnBv
cnQgPSByc3dpdGNoX2dldF9wb3J0X25vZGUocmRldik7DQo+ID4gLSAgICAgICBzdHJ1Y3QgcGh5
ICpzZXJkZXM7DQo+ID4gLQ0KPiA+IC0gICAgICAgc2VyZGVzID0gZGV2bV9vZl9waHlfZ2V0KCZy
ZGV2LT5wcml2LT5wZGV2LT5kZXYsIHBvcnQsIE5VTEwpOw0KPiA+IC0gICAgICAgb2Zfbm9kZV9w
dXQocG9ydCk7DQo+ID4gLSAgICAgICBpZiAoSVNfRVJSKHNlcmRlcykpDQo+ID4gLSAgICAgICAg
ICAgICAgIHJldHVybiBQVFJfRVJSKHNlcmRlcyk7DQo+ID4gLQ0KPiA+IC0gICAgICAgcmV0dXJu
IHBoeV9pbml0KHNlcmRlcyk7DQo+ID4gKyAgICAgICByZXR1cm4gcGh5X2luaXQocmRldi0+c2Vy
ZGVzKTsNCj4gPiAgfQ0KPiANCj4gQXMgdGhpcyBpcyBub3cgYSBvbmUtbGluZSBmdW5jdGlvbiwg
anVzdCBjYWxsIHBoeV9pbml0KCkgaW4gYWxsDQo+IGNhbGxlcnMgaW5zdGVhZD8NCg0KSSB0aGlu
ayBzby4NCg0KPiA+DQo+ID4gIHN0YXRpYyBpbnQgcnN3aXRjaF9zZXJkZXNfZGVpbml0KHN0cnVj
dCByc3dpdGNoX2RldmljZSAqcmRldikNCj4gPiAgew0KPiA+IC0gICAgICAgc3RydWN0IGRldmlj
ZV9ub2RlICpwb3J0ID0gcnN3aXRjaF9nZXRfcG9ydF9ub2RlKHJkZXYpOw0KPiA+IC0gICAgICAg
c3RydWN0IHBoeSAqc2VyZGVzOw0KPiA+IC0NCj4gPiAtICAgICAgIHNlcmRlcyA9IGRldm1fb2Zf
cGh5X2dldCgmcmRldi0+cHJpdi0+cGRldi0+ZGV2LCBwb3J0LCBOVUxMKTsNCj4gPiAtICAgICAg
IG9mX25vZGVfcHV0KHBvcnQpOw0KPiA+IC0gICAgICAgaWYgKElTX0VSUihzZXJkZXMpKQ0KPiA+
IC0gICAgICAgICAgICAgICByZXR1cm4gUFRSX0VSUihzZXJkZXMpOw0KPiA+IC0NCj4gPiAtICAg
ICAgIHJldHVybiBwaHlfZXhpdChzZXJkZXMpOw0KPiA+ICsgICAgICAgcmV0dXJuIHBoeV9leGl0
KHJkZXYtPnNlcmRlcyk7DQo+ID4gIH0NCj4gDQo+IEp1c3QgY2FsbCBwaHlfZXhpdCgpIGluIGFs
bCBjYWxsZXJzIGluc3RlYWQ/DQoNCkkgZ290IGl0LiBJJ2xsIGZpeCBpdC4NCg0KQmVzdCByZWdh
cmRzLA0KWW9zaGloaXJvIFNoaW1vZGENCg0K
