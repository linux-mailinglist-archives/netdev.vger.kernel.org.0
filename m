Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B6840390B
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 13:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351496AbhIHLog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 07:44:36 -0400
Received: from mail-eopbgr1400134.outbound.protection.outlook.com ([40.107.140.134]:13280
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349176AbhIHLoe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 07:44:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDnMTLVTqsezV4AlEIZeyMJrxUnBj5uRANrYO1mFbDqQEf8+DVkDY84wkt64911QE5YiA7JYK/CVKG45y173Q5mW5YSseAtokdTWiV09GufAKmsePO1N9w2pCJrWvcBbj3fScEWAj0dhzeOUtoP3oRruHWisjVIM5Nr5xKsHJd1SlksoPRuouCQgzH67yXYol+j7cuVVuD9+jYyJL1haHYrQomUqtrRa3bj/3S0CDXw5iBtMw5H0fCfLFKgqgsee1PfJcKUxBLjIdyXrGrYibANFkBHjYC4VJ7PnEgyqa4jqwakuMg9GwtsYpQFieGZ89dFaX8SdMdw8MgHlIR1JTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YfjNVLH7CFBnayGzNwueyrlfxG6dokl9hmUoBsiAlUc=;
 b=lBAyLmiRgh8brcuLhkPCLxLr6Ux1PVj5R57vZZOe95XN4F2NjDYpVagVxvugeTZ9t02ItGuEgxUoMShFXmKS581mJUXWrfIC9qyQsEz4dDfZVPFV7OeewxILMdXjsZjTBzTTZKK3UsMoJ2DjSUVzjKl4uwt0TenOGqrGxHV3a24cI0MfvPFzvV7IWwL2dXzMXXsqPk06opnonKkh8ktc9F15zLlDEoc56bXj2gu5xt9+GT9iZU2i4hbgwE56HSQUcKIlOIMxkK8UQc9HXsC89yfMdmdE4fmKUk5n6PXiwrBXmUQJIxhU1eR4niFjiExz/5gTVCdmwWBpqDJq6qwG8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfjNVLH7CFBnayGzNwueyrlfxG6dokl9hmUoBsiAlUc=;
 b=H9zIah98FNBOp/siBIp18G75wiWLvOeTmGtvkI8QmPblEibgbFf7eJW3MsqBiRt7fmJnsWYm5mdkZaNryXNMssQqq0EngwhlYrbpj86exDKh5+shlLHbF/t4rPViVDP19v3qBwK7c64ZfkTRrFW0KeoT9yHErJ8I2lOtqDv5LvQ=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYCPR01MB6093.jpnprd01.prod.outlook.com (2603:1096:400:61::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Wed, 8 Sep
 2021 11:43:25 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::b10a:f267:d52c:1e5b]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::b10a:f267:d52c:1e5b%3]) with mapi id 15.20.4478.026; Wed, 8 Sep 2021
 11:43:25 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH] net: renesas: sh_eth: Fix freeing wrong tx descriptor
Thread-Topic: [PATCH] net: renesas: sh_eth: Fix freeing wrong tx descriptor
Thread-Index: AQHXo9u81SMMhOXtDE2P4NymXZOfj6uY9cIAgACpn8CAAEWkgIAAH0Sg
Date:   Wed, 8 Sep 2021 11:43:24 +0000
Message-ID: <TY2PR01MB36924BD44CA5B512B96AC2AFD8D49@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210907112940.967985-1-yoshihiro.shimoda.uh@renesas.com>
 <a610ac4b-eeb9-50c2-4b88-0d77d1c83d47@omp.ru>
 <TY2PR01MB36924D8258BD1C8E3287136DD8D49@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <9f3a0195-8218-e73c-eb63-bbd7b6ff9777@omp.ru>
In-Reply-To: <9f3a0195-8218-e73c-eb63-bbd7b6ff9777@omp.ru>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08431b74-9f73-415c-33c9-08d972bdde25
x-ms-traffictypediagnostic: TYCPR01MB6093:
x-microsoft-antispam-prvs: <TYCPR01MB60933F8999A1EC346ECE9C77D8D49@TYCPR01MB6093.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L1pGj1/kLNb1bXFZJ9k6eaCyhHRRbEejwJ9MIxz/tbl7i1dw4sK9KZa/nbcl+MI/qTDVKMr0ULC3CryKB1RysWvbU+36rTyZP13/yqJ5Mxy/IqmdZwpdvV0dMo3dZtQHaGyvsjFksZ1V5wWe8fsUQbORp9MpTpgdzp0Oi+GSU0GnZWMFlmleMvAQ8aaWDm6tRZkiEqK/jfvimxZprtWFmbPukZRJmMeEkmgS4HyreG752K5teN+kq8pHC0wX2INKmotFzWmuRDfoqsHIJNQN+x5Kqw8nrndbE5N2svk0hB6X02tBC413v9uaCzqw5NVBgmEbeOXyW6QNSHs3RAlZMku+HKb3S70pwNIQyF5zXx38A/CilrynsJKvMGwr0RBirQVXGoBUk7/emdWba55T/nb7zxAaralVcogCLQi2qzaWQdb81GIJK5nYhjtODZywR+7FfzZWwmy1ECPZcZH41jEB7b4IaDe9L9xxUbe6DPJP7jUvyLafe11Jth02KKvYn1igmnqe9aznLul0Ip582XVv7bE2h2PuEi+E71m9lQxpy9fM7DaL/1qy1EikXAk4caGiRM2/4RxmzXiE8gUk4frvzBVq+7zUQisxVKi1n5BQut0L+m/q6Rf8+wHpUkEgXXvPRgeAwFFYj97WZRIC5Tm0fLtEmBOn88JneqNQkciouakZKrqn6E7xi2ZdTwSjOW21zhF1lTE5wov+skfASQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(52536014)(9686003)(55016002)(5660300002)(6506007)(54906003)(38100700002)(76116006)(8936002)(8676002)(83380400001)(86362001)(66446008)(64756008)(66476007)(66946007)(66556008)(2906002)(7696005)(4326008)(186003)(71200400001)(478600001)(33656002)(122000001)(316002)(38070700005)(110136005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckFjaEcrbTBtQWRLWCs5d0NjQVduM2tMTWJVYVkxcU1QSi9NTFNwVWFPZi9u?=
 =?utf-8?B?VzAyZ0dOZjRVQkllczRkWlFHZWdHbStNMVB6enlQaUpENEIzUTNSb3hIVnFl?=
 =?utf-8?B?VVNIVVkxQzJVVGZrdlE2aEg4M0swUS90aU1EaVFiN0FoTWFJUGdzdkxmK1cx?=
 =?utf-8?B?Tkt2Z0tna1FHZkdxMWw1Sk1iL0F1M3g1UHRNb3QxbWFwLzh1WW14b0pNNThN?=
 =?utf-8?B?cDdCalVtSnc2K3NMTjRUVjVOY0ZmUTNVZHdZT240OTYydE9uUTZDVDNLTzlr?=
 =?utf-8?B?a1VESElYOXplOXpLV3lzWnRKN3NicmkyWUp5WWVSU2J6T0VwRFE3TExXVDM0?=
 =?utf-8?B?a2ZEZTlIQk1FYksxNmtlSGFveGhJeWE4dEFtUVdhc2FNWWVvTyt1VXllRkxl?=
 =?utf-8?B?T2J5dTFOVmNIOHpNakdLNkxZV3pDUmYrQ0dmVVJMMGFOdUtaSDhDL01sTmxu?=
 =?utf-8?B?TlZydVNSeEdYY2d2TVhiN3VOZlR4Qzh2MCtDYU1Ec0lUY0ZnL0JjOUhmYm1Y?=
 =?utf-8?B?TjBKSnRzcjBpTmQrOUswMWtnb01lNEVVaGlJS0tLakg5RCs0cUZ1TEw5NWZQ?=
 =?utf-8?B?Z1FTK251SHlWaWlKYnFYUm14UzFYUnlKMjc0Z2hVMDVVcno0S0VMM1pTdldq?=
 =?utf-8?B?cGRjS1drOUpQR2R3QjdsWlR3VnoxN2ZWdEVwUFZsMHQ0eHhBVmNhb3kxTXpG?=
 =?utf-8?B?ZUtDMjFIK1ZJRHAvQzlOcTUza255V2F2S1R4aURURmF2b09xZndRa3R0R2Nw?=
 =?utf-8?B?TS93QytUWFdUaWFuOTFXRUFwWjhnT1h4RFVRUzZVMk50UjFGdEFzVkQrdGhi?=
 =?utf-8?B?NTFtQm90N0QrTDN1bjk2M2svUFJlQUJDYVNQYzlHaWZ0bmEvdllMWDQ0MTl4?=
 =?utf-8?B?eGEvRnpRYTYyZ3pZR21wRDJSSnVzUVR0YTB4U2JyVkpUaGNaSUFhMUVmSVdw?=
 =?utf-8?B?ZG1jd2NsNmhxQk4xZ2w3VG1BWm1YNmVSb2Z1Ukp0MXkyb1lNKzdGMFV1Y0hS?=
 =?utf-8?B?T0tGSXVXTktLSHlBNEU5TjYzeVpjbXVPTTIzRHcxSXdpUUppam5GL3J1MHJh?=
 =?utf-8?B?SFV3eUNubGwrcER5dEJMOFdWVkVrSm5KSXo5OFRnNW8wRnN6SGc1ci9FdGlk?=
 =?utf-8?B?cFZZcXM0cnNXZlF2dnYwQWsrZXowdnMyK08zYTlnR0NacVhkbklvNUVtRVk5?=
 =?utf-8?B?Mk1nL0lQWHV4WjZmRGozWTlKQlBFU3YyZzZHZVdQMFZJczQ1a3RIK2J6M1dt?=
 =?utf-8?B?cFRTV2Y1Sk5nLzQvQ1FGTHZwYW5IWUI3N1pJTzViVWRXOEpkKzZnYjA0TE9K?=
 =?utf-8?B?K1ZscmFnVG9objNKc0dXMDlHRy9NTFNyZ05sakZvUklNQ1QwempBKzhXSlJB?=
 =?utf-8?B?RHJ1M3FqN2d2Wkhqb1M2eUNiRERNOWZSeHB0NWJCaWNUdnpTdlhYTXdsSEZw?=
 =?utf-8?B?NmFacU5zS0FKaFhIUi81MVlNenhHTUtQYVRrUzhhOE9jUDJTeDJBREo1b3Rz?=
 =?utf-8?B?M3RTUkJtcTNKb2k2UjdOa0dGMURaVzg5Nis1OXpIbHFPcjYveU1FMi9yQUJn?=
 =?utf-8?B?MHowNUhpQVNkRTlDY1ZDaTFEdUdHZjZDWFRNNzVWM24xNGNaa0pLWjE2SjNj?=
 =?utf-8?B?cG9obFZMTTl5MHVoVEFnMko5dUFiYnlrUFhVUFpBNTlDMnRwL1R2bWF4RElW?=
 =?utf-8?B?ZTlyS0NrM0ZkcEswZVBIRnlwdHJ4aXBVb05VL2tYWkROdlFGajRIUXA3bkcx?=
 =?utf-8?B?VlVCNWZ3S2xJeFFTS3JPQWdjWEdFYTAxYVYyckRnZk9kbi9wR0RBTlNjS1hL?=
 =?utf-8?Q?IyJH+zVKKAlr0mwmsc20kzWRs1WaHNcfSlxkM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08431b74-9f73-415c-33c9-08d972bdde25
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 11:43:24.9821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SZea4N1feOQaxMM7fqSY8nfEQiXhESOS2vsI7tsAzcbjrAwSsJ+O9gVpkrckF2viiTCTGOmeLfECpWjwQZFqR4T5thgi9pggjwQ45bPkQ51FBrkv4eKGXligLp63g+XZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IEZyb206IFNlcmdleSBTaHR5bHlvdiwgU2VudDogV2VkbmVzZGF5LCBT
ZXB0ZW1iZXIgOCwgMjAyMSA2OjQ2IFBNDQo+IA0KPiBPbiAwOC4wOS4yMDIxIDg6NDUsIFlvc2hp
aGlybyBTaGltb2RhIHdyb3RlOg0KPiANCj4gPj4+IFRoZSBjdXJfdHggY291bnRlciBtdXN0IGJl
IGluY3JlbWVudGVkIGFmdGVyIFRBQ1QgYml0IG9mDQo+ID4+PiB0eGRlc2MtPnN0YXR1cyB3YXMg
c2V0LiBIb3dldmVyLCBhIENQVSBpcyBwb3NzaWJsZSB0byByZW9yZGVyDQo+ID4+PiBpbnN0cnVj
dGlvbnMgYW5kL29yIG1lbW9yeSBhY2Nlc3NlcyBiZXR3ZWVuIGN1cl90eCBhbmQNCj4gPj4+IHR4
ZGVzYy0+c3RhdHVzLiBBbmQgdGhlbiwgaWYgVFggaW50ZXJydXB0IGhhcHBlbmVkIGF0IHN1Y2gg
YQ0KPiA+Pj4gdGltaW5nLCB0aGUgc2hfZXRoX3R4X2ZyZWUoKSBtYXkgZnJlZSB0aGUgZGVzY3Jp
cHRvciB3cm9uZ2x5Lg0KPiA+Pj4gU28sIGFkZCB3bWIoKSBiZWZvcmUgY3VyX3R4KysuDQo+ID4+
DQo+ID4+ICAgICBOb3QgZG1hX3dtYigpPyA6LSkNCj4gPg0KPiA+IE9uIGFybXY4LCBkbWFfd21i
KCkgaXMgRE1CIE9TSFNULCBhbmQgd21iKCkgaXMgRFNCIFNULg0KPiA+IElJVUMsIERNQiBPU0hT
VCBpcyBub3QgYWZmZWN0ZWQgdGhlIG9yZGVyaW5nIG9mIGluc3RydWN0aW9ucy4NCj4gPiBTbywg
d2UgaGF2ZSB0byB1c2Ugd21iKCkuDQo+IA0KPiAgICAgSSBzaG91bGQgcmVhbGx5IHJlYWQgdXAg
dGhlIEFSTSBtYW51YWxzIG9uIHRoZSBiYXJyaWVyIGluc3RydWN0aW9ucy4uLiA6LSkNCg0KOikN
Cg0KPiA+Pj4gT3RoZXJ3aXNlIE5FVERFViBXQVRDSERPRyB0aW1lb3V0IGlzIHBvc3NpYmxlIHRv
IGhhcHBlbi4NCj4gPj4+DQo+ID4+PiBGaXhlczogODZhNzRmZjIxYTdhICgibmV0OiBzaF9ldGg6
IGFkZCBzdXBwb3J0IGZvciBSZW5lc2FzIFN1cGVySCBFdGhlcm5ldCIpDQo+ID4+PiBTaWduZWQt
b2ZmLWJ5OiBZb3NoaWhpcm8gU2hpbW9kYSA8eW9zaGloaXJvLnNoaW1vZGEudWhAcmVuZXNhcy5j
b20+DQo+ID4+DQo+ID4+IFJldmlld2VkLWJ5OiBTZXJnZXkgU2h0eWx5b3YgPHMuc2h0eWx5b3ZA
b21wLnJ1Pg0KPiA+DQo+ID4gVGhhbmsgeW91IGZvciB5b3VyIHJldmlldyENCj4gDQo+ICAgICBP
dXQgb2YgY3VyaW9zaXR5OiBoYXZlIHlvdSByZWFsbHkgZXhwZXJpZW5jZWQgdGhlIGJ1ZyBvciBm
b3VuZCBpdCBieQ0KPiByZXZpZXc/DQoNCk91ciB0ZWFtIGhhcyByZWFsbHkgZXhwZXJpZW5jZWQg
dGhlIGJ1ZyB3aGVuIGlwZXJmMyBydW5zIG9uIGJvdGggc2lkZShzZXJ2ZXIgYW5kIGNsaWVudCks
DQphbmQgdGhpcyBwYXRjaCBjb3VsZCBmaXggdGhlIGlzc3VlLg0KDQpCZXN0IHJlZ2FyZHMsDQpZ
b3NoaWhpcm8gU2hpbW9kYQ0KDQo+ID4gQmVzdCByZWdhcmRzLA0KPiA+IFlvc2hpaGlybyBTaGlt
b2RhDQo+IA0KPiBNQlIsIFNlcmdleQ0K
