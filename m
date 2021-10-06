Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55641423857
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbhJFGwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:52:49 -0400
Received: from mail-eopbgr1400127.outbound.protection.outlook.com ([40.107.140.127]:57395
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229956AbhJFGws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 02:52:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9iq5H39JBo3WJ/OqPtNlijHPbPQ45S0W7GEkSL/6sdBHjR69AhN6cgeNT/J0NQAwuI1rVOZIikgaZizJYE0YD9I7F+aP0UkYktncpOCfz5nvKhinUI2MNIB9ZDwFx3RYf3YLkZKgkaJpe7+6Fug31VyqyRUA6XuGwRSRLBW48I8PSkmUiY39BLA72UYsMsQr+lw8xHS6dbsBGl3eMINIDvOIS86RGWqAgj/80Gv7fFKRG/ZoFbNc7Pal1RiLJJoRR+MckL6EQdBJGJJLVNFzJu1z7nqOJbO7YtB1hmYpjJJ4nrmEaVih0kkf2liQ66HouCdfbPjBGDCI2SuDtOy5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qUZfYN+kypHPQ59j35MC6q8n3eHPrhrk4xSb08UIus=;
 b=hFcTxLCuKJOE/Naf/kVFso1RleQbNBehwtvb2/uqbuY5VXeilSPAW8ABxF/RORMgvmGCqTZiz19bJMOqSdUnNVm9xEAZp8qk1ZAgA9yinCV5nXibd3OFWUY/eEYdt0X8XZqimiVHVsDmRhVob6e3OEEsBw19jKP/6MwxYLGCO05xhoiRIn7yRRxWO112atS5OTDQKnfpZMS29QaThQsQNdDR29Zkjd3jh5mLG+UmfhOQmtTsuRv8Cs0WhWbTE5YWlEuA1aXdFadpXR32baROu0/EqY/z/zmJ7KgiHV5hTHQryZqR6QJamI4i/WdevZ5BCPPhoJ+pRio1eFn71Hv4vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qUZfYN+kypHPQ59j35MC6q8n3eHPrhrk4xSb08UIus=;
 b=Ycefx/R9LZmhMG5X8xPzlnBvk5770gM7kf4hLO4UjT+nWd7NEWE1RkSUIiQ+mmkTvhVdM1LnM/L0csYSCUKxFfS9z5W3mXp954KO5QHbCvw8vR6rus2MCZJUidSqKUttzDDXhkgP1RRzqDX15O3nSS7GwXBf8Tz7EjBSni82xD8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB4324.jpnprd01.prod.outlook.com (2603:1096:604:67::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Wed, 6 Oct
 2021 06:50:54 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.018; Wed, 6 Oct 2021
 06:50:52 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [RFC 04/12] ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
Thread-Topic: [RFC 04/12] ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
Thread-Index: AQHXudkgN5hONPRpaEebOthoVCZ0P6vExtQAgADBuyA=
Date:   Wed, 6 Oct 2021 06:50:52 +0000
Message-ID: <OS0PR01MB5922EAEB96F1822C1B835E2886B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-5-biju.das.jz@bp.renesas.com>
 <207bfde9-2b34-a582-408c-1def6ceec031@omp.ru>
In-Reply-To: <207bfde9-2b34-a582-408c-1def6ceec031@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 293a9eb2-509b-4249-bc09-08d98895a3c5
x-ms-traffictypediagnostic: OSAPR01MB4324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB4324C7D110624004F3F9221C86B09@OSAPR01MB4324.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bHOnCilQ7VH7is6QIkqA2ZhjYoSUFI+uV3GhinZaBKHYByitW9Qy+vleVsnP5fi292g9olghGxtnMFYjxXF6P6e95SeVXKxFlwZwcigUgiW9bK2D+wENPN+nut3gQDBC8nOsac/GvfaFuCCFVWZvgUbAfq9wQxdrbV83a77Ci2xrcrFYNQ6p3fqdhAj/bGrU2nPNsC4LI1VenvGpIUbs/pVMi/Q7pv+TZZd5eOecCALf15zLtXOtNiNfphdqxR5Y2VSQi4pxeqsDnMrXxul/roX1xHISDy7Mv+pxHMdxBLwKRtwzJ4BDkJV7vZgDxh4saC0F6ZQ+IxyVw66KCauw4lntfov4zfqWeeLYmOTz8ZyyGgdil1cThHg4tuiUXaIV8/rOQi7XXJ49MWBncTXUkOmOJWU3jfqpSS6S5sSYQtiVs3uT1+deDriAwke8eBF7Ucarpt1S8uTwh82XMNr0d7askXIBIoiBAt2BD7/cmU1+RawmMSj9ZB6ObX+Q1mtJ66xtVt8Gxxyzf6FR1ZPO09vuGYwJoxGnrn6SrB2t6JM7Ta2DdvDuC2oxaQolrJ9HFALabJ4s6lj5CsPiWruQ4vTL8XUiLFdaBWRJ3CPP4G+7kUPZqoexH/coxO3My7O0TXQsQ3szA9HN6vJHQ2Fj0j02x3XAVP4kVsUqR6E2ZJsSLXkC40yB4tiHepAgtmUz6LILe9CsnuHhH4sVtyVLbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(8676002)(8936002)(110136005)(86362001)(186003)(7696005)(52536014)(54906003)(316002)(33656002)(38070700005)(5660300002)(53546011)(66476007)(122000001)(26005)(4326008)(7416002)(66946007)(66446008)(55016002)(64756008)(38100700002)(71200400001)(2906002)(83380400001)(6506007)(107886003)(9686003)(66556008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0NpT2tEdVJaTi9nbElZdktxMGpzL2tweHgyMFBNOGt4N3c2b25md3RBd3Ni?=
 =?utf-8?B?TFRCbm1CazZwUjFjRitXSHN5aEUwL3VIbnhzTE1OeTlQTWMxMTdnTEtWMlFU?=
 =?utf-8?B?SUUrOWJ3MWIxL04xamtEdG5ZQjJWdkQ2REF6MW1EbTNGQ2EyTC9rUnhJZzdI?=
 =?utf-8?B?dlFnZUJ4TWh5dEl3TXNIanFhN0o2bFhza1J3QmJ6cE1PTmFVbllJdzhPUGJF?=
 =?utf-8?B?TlplTHdRcVFxZGJVak1ZUXVUaUVSbTgzWncxRFIvTWdxbUlISHBtb0g1Q3hy?=
 =?utf-8?B?V1IxT09OL3R6Z3NRRnpiZWNBa0NnREFVaG5rNEJ5YzJZc3RDOWZVbHNOTVFQ?=
 =?utf-8?B?RmdLeS9YSUdYZVdUZG02VjhNUDRiYnAzempqUHg3VTFjTERHc1M0VFc1RFkz?=
 =?utf-8?B?aWVnTmtDcXFvY3IwOVpxOGZvZFo0TmswZWl6QldjcmZva1BlYlNHamJNNjRo?=
 =?utf-8?B?dmVya0QrUG5YREwwZlp6amMzRm9VVlNXYmxOaUZ2bHR2YThGZW91cEV6alRG?=
 =?utf-8?B?VFV3dTlnaDMrbW92TlVndjVPc2xWSkwxTmZ4cnNrVzRLOVE5aC9rTDFiZTRO?=
 =?utf-8?B?bFQwNDlrT3JwVHJIc0pFMXZPYWhYVWc3cE9BeXVlWXlnNStUSWhFWis1N2Zw?=
 =?utf-8?B?aTVJb1RwZkNwc1BNVGprR3h1SkpIVFdxdUFiSlNSTnJoanFBTE9wYlB5empL?=
 =?utf-8?B?b2ZIaS9ldHV2MDBZL2tTeDNnZ3FzdXE1ZG54cUMrV1MwNXF2L3RuSkNoVVph?=
 =?utf-8?B?dzdaNE0xU0ZCWlZVM1J0RjRqdGtqUit6RGtJN1JCSm9rRWxpUDlEVEtTZ0kx?=
 =?utf-8?B?S2VaRWpULzVldC81VUQ0cjdpR2ZKRmNVSjNpTm5pT2VkK3QvNEtXTU1SdXZD?=
 =?utf-8?B?eWFyaUY0dEU0a3MzUVpXRlM3ekxSMDdmUDN6NzhyOENhSHc2OWovdFZXVVQ4?=
 =?utf-8?B?bURkWFQrT3RveUIwOHJWOG5PdWJGNGRFWFJDL1JGaDlpc1dtNGVkanNHajRZ?=
 =?utf-8?B?VVUxbENSejE5VDJDdU9WbHpkZnRTS2ZqeWhjYUlPUDZTSkNqNUtJUDhKT3Za?=
 =?utf-8?B?NVM5cEw0MXZla0EyV0h4WEI4NkFmeGtGSVpSMVFqQTlRbisveVhpTm1lMjhQ?=
 =?utf-8?B?L09mbHEvNkE2cVVIRy9aaWJQV3p3cjdnOGZEWXZQdVpnVHFHTVd4UVNmVWV1?=
 =?utf-8?B?UUJQekkvQ0V5L3lXRTV0OVpvU2o5eTV1dkNBbXFCN1RlcUl6dk1qb2NFQXZv?=
 =?utf-8?B?eXorOU9nL0RGb1RLdkZONTc1MEIvZXIzMWRkM2Z0KzBGWnJaZFZUa3NhVXYv?=
 =?utf-8?B?WGRITk5RZ0lJdzFxcWpVZVgrWldYQmRQRmdURkhHTTBzSjcxelhPQ1R0REdy?=
 =?utf-8?B?SS83bmFJT1lYZEZ6eDZOeUlGWG01VitEWnBLeWFibDJMd3ZZODZ4QjI0T0lC?=
 =?utf-8?B?cjFpaTZkZ2M2MC9WRzRQcVpsNDFOeUhTUFplM1FtSkIxbk9MRkppTlBuZzl2?=
 =?utf-8?B?TVRKZ3NKNHFJdHRUa0tIcTZDMy91cVFtSFoyTCtEQzFSQUljd3hmOWlDWCtQ?=
 =?utf-8?B?SWxqZ1FETkU2VjZKd1FBRnJQYVFtQUJMRnMvdHJDcWo4RlNFZkFZRWdTT1Vy?=
 =?utf-8?B?OTJYaHFGYUozMkJubVVBbnR0TkI4alMreWxtRXZMYkkyYzNxVjF6Wk9vcER2?=
 =?utf-8?B?Wnl2ZWt4VXlRNGdzTlIvL29BWHVTbWR0Z00xdDkvVWZUdkZJOXRUbnJSNVV0?=
 =?utf-8?Q?AkHlMQa1wJFvxSEH8A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 293a9eb2-509b-4249-bc09-08d98895a3c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 06:50:52.6097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e12afQ8qS+gId3x9pr/3DrgcGNR3W66GgGWoSr8+bn/DfdHYJSvWthT+IWHCw2a9b/5yNqHVN51WBPuUE6ESIFavfXmOytUsRj2dEPcGWdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4324
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDIDA0LzEyXSByYXZiOiBGaWxsdXAgcmF2
Yl9hbGxvY19yeF9kZXNjX2diZXRoKCkgc3R1Yg0KPiANCj4gT24gMTAvNS8yMSAyOjA2IFBNLCBC
aWp1IERhcyB3cm90ZToNCj4gDQo+ID4gRmlsbHVwIHJhdmJfYWxsb2NfcnhfZGVzY19nYmV0aCgp
IGZ1bmN0aW9uIHRvIHN1cHBvcnQgUlovRzJMLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBhbHNvIHJl
bmFtZXMgcmF2Yl9hbGxvY19yeF9kZXNjIHRvIHJhdmJfYWxsb2NfcnhfZGVzY19yY2FyDQo+ID4g
dG8gYmUgY29uc2lzdGVudCB3aXRoIHRoZSBuYW1pbmcgY29udmVudGlvbiB1c2VkIGluIHNoX2V0
aCBkcml2ZXIuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpA
YnAucmVuZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXIgPHByYWJoYWth
ci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gWy4uLl0NCj4gDQo+IFJldmlld2Vk
LWJ5OiBTZXJnZXkgU2h0eWx5b3YgPHMuc2h0eWx5b3ZAb21wLnJ1Pg0KPiANCj4gWy4uLl0NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0K
PiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGluZGV4
IDM3ZjUwYzA0MTExNC4uMzFkZTRlNTQ0NTI1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+IFsuLi5dDQo+ID4gLXN0YXRpYyB2b2lkICpyYXZi
X2FsbG9jX3J4X2Rlc2Moc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKQ0KPiA+ICtzdGF0
aWMgdm9pZCAqcmF2Yl9hbGxvY19yeF9kZXNjX3JjYXIoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYs
IGludCBxKQ0KPiA+ICB7DQo+ID4gIAlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2
X3ByaXYobmRldik7DQo+ID4gIAl1bnNpZ25lZCBpbnQgcmluZ19zaXplOw0KPiA+IEBAIC0xMDg1
LDE2ICsxMDkyLDI1IEBAIHN0YXRpYyBpbnQgcmF2Yl9wb2xsKHN0cnVjdCBuYXBpX3N0cnVjdCAq
bmFwaSwNCj4gaW50IGJ1ZGdldCkNCj4gPiAgCXN0cnVjdCBuZXRfZGV2aWNlICpuZGV2ID0gbmFw
aS0+ZGV2Ow0KPiA+ICAJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5k
ZXYpOw0KPiA+ICAJY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbyAqaW5mbyA9IHByaXYtPmluZm87
DQo+ID4gKwlib29sIGdwdHAgPSBpbmZvLT5ncHRwIHx8IGluZm8tPmNjY19nYWM7DQo+ID4gKwlz
dHJ1Y3QgcmF2Yl9yeF9kZXNjICpkZXNjOw0KPiA+ICAJdW5zaWduZWQgbG9uZyBmbGFnczsNCj4g
PiAgCWludCBxID0gbmFwaSAtIHByaXYtPm5hcGk7DQo+ID4gIAlpbnQgbWFzayA9IEJJVChxKTsN
Cj4gPiAgCWludCBxdW90YSA9IGJ1ZGdldDsNCj4gPiArCXVuc2lnbmVkIGludCBlbnRyeTsNCj4g
Pg0KPiA+ICsJaWYgKCFncHRwKSB7DQo+ID4gKwkJZW50cnkgPSBwcml2LT5jdXJfcnhbcV0gJSBw
cml2LT5udW1fcnhfcmluZ1txXTsNCj4gPiArCQlkZXNjID0gJnByaXYtPmdiZXRoX3J4X3Jpbmdb
ZW50cnldOw0KPiA+ICsJfQ0KPiA+ICAJLyogUHJvY2Vzc2luZyBSWCBEZXNjcmlwdG9yIFJpbmcg
Ki8NCj4gPiAgCS8qIENsZWFyIFJYIGludGVycnVwdCAqLw0KPiA+ICAJcmF2Yl93cml0ZShuZGV2
LCB+KG1hc2sgfCBSSVMwX1JFU0VSVkVEKSwgUklTMCk7DQo+ID4gLQlpZiAocmF2Yl9yeChuZGV2
LCAmcXVvdGEsIHEpKQ0KPiA+IC0JCWdvdG8gb3V0Ow0KPiA+ICsJaWYgKGdwdHAgfHwgZGVzYy0+
ZGllX2R0ICE9IERUX0ZFTVBUWSkgew0KPiA+ICsJCWlmIChyYXZiX3J4KG5kZXYsICZxdW90YSwg
cSkpDQo+ID4gKwkJCWdvdG8gb3V0Ow0KPiA+ICsJfQ0KPiANCj4gICAgTm90IHN1cmUgSSB1bmRl
cnN0YW5kIHRoaXMgbmV3IGxvZ2ljIGFyb3VuZCB0aGUgcmF2Yl9yeCgpIGNhbGwsIGNhcmUgdG8N
Cj4gZXhwbGFpbj8NCg0KVGhlIGNvZGUgaXMgc2ltcGxlLg0KDQpJZiAoZ3B0cCB8fCAgLS0+IG1l
YW5zIG5vbiBncHRwIGNhc2UgdGhhdCBpcyBHYmV0aGVybmV0DQpkaWVfZHQgLS0+IERlc2NyaXB0
b3IgdGh5cGUNCg0KU28gYmFzaWNhbGx5IHRoZSBuZXcgbG9naWMgaXMgLCBvbiBHYmV0aGVybmV0
IGNhc2UsIGlmIGRlc2NyaXB0b3IgaXMgbm90IGVtcHR5LCB0aGVuIHByb2Nlc3MgcnguDQoNClJl
Z2FyZHMsDQpCaWp1DQo=
