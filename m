Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED371E046F
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 03:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbgEYBgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 21:36:24 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:47854
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388054AbgEYBgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 21:36:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiX7rs9PqF9KglRAWToYPyhf7pE4ZdfljLzXZ0MpDJ6k6npqqXtIbf3/XD+6EAyfWsDm0cnnWll3UG2Hhec9/QIpPDpuhY1+PyHPQznyU6K/cNE+kQIop6/OzcSyInO3k9MlQhD7zU4A7SgSpQL7AMXiI+oc/BFi+raq7eVjbWAXMmvMw4m01lpGFSIAt8HoUIcLic7SaL5y8831iXGUPag2R2TtsL5IFxHUIrfyR2oukJOwVyiSRRuqY3pC4+rJOCDyyyQq1OrM9XEnk8i9e65veytfn8633qa15LkegVuJGAs0Xuh28ieYYEIOAXcdOcwmHAKJHlS+XynIx2arPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWB8xeDp0zWETM/9zU5P1VQL49/4BX9QTeqZaKyKh5o=;
 b=kppLtSwdwfDO0ATYEaXYCBarWPambnxgXumJpi9eyuSJ3tWWY8cbN6387c26iK4OolHA6S/uDyt5bGGMEQW84jozvn3ga2/UEJHfrNSbnZuLaOG2gR0gd92CSjW7JdzFwk/0l+RMtYkzBtZn31M+mfL1NyprAjvailnCIIx9Apfbd+EDluA5gPx9Yg6Y5D8OAcy/PWnCkJ/mfTsOyy2pQCNokE/rgPIqzOpKmHOrtSNvG312kDIgJNvRVfDSSIr2iWW8nEOaEhxWj3STAR33cbGdjLKOyiOgSbpgltwuncSeTveYBwn91K4+sVEoc7XhnAeyDXRgDZEMUnLVFMdbJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWB8xeDp0zWETM/9zU5P1VQL49/4BX9QTeqZaKyKh5o=;
 b=sd09yhOsIiC84XFSgoBMUvKurY3YWE429aU9Li6HxehrANMb5rZPfqomtja9pdJ4GvTR1NYsNcoVPJX4ayu4Adcguvf4lem381u18ByL0prM5RUlKOoXLZzbYlFhAoZrkfFeSg8PbxBIxX6H1fUtVGACTKnEdmcersUaKtYKO40=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6875.eurprd04.prod.outlook.com (2603:10a6:10:11f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Mon, 25 May
 2020 01:36:19 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7564:54a2:a35e:1066]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7564:54a2:a35e:1066%9]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 01:36:19 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, "kjlu@umn.edu" <kjlu@umn.edu>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] can: flexcan: Fix runtime PM imbalance on error
Thread-Topic: [PATCH] can: flexcan: Fix runtime PM imbalance on error
Thread-Index: AQHWMB2MYA5dCmRv5E6bmmiK8TDkyKi4B0Gg
Date:   Mon, 25 May 2020 01:36:18 +0000
Message-ID: <DB8PR04MB679570CD8E04A213435330FFE6B30@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200522094340.18059-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20200522094340.18059-1-dinghao.liu@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2ff962ad-3508-492d-90e5-08d8004c0603
x-ms-traffictypediagnostic: DB8PR04MB6875:
x-microsoft-antispam-prvs: <DB8PR04MB6875D0AA708342C394B7C21CE6B30@DB8PR04MB6875.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F7a7zwkrOVovD82nwcaASFW9YYD8eCZwCBnmlRjZcny/AaXbb2DFXP3n6+KdpiE2oiMy+ZpACe9hzJJfM8CFtzLCEuloRfP7TBaBP7weTxSUhnUK7sYEmCX4QriJKU3XdfP+4EBDJBCVZKWkUnmlASjx0GKzdrwKjL+LefApeRfXfSMIBLeLK/J0aljfxz3YHM7rK1JMtMVsA/XqONWJtCBIMcF0UjMkm0AcDCS5UfpgZTW9i1CussCLO0+YKNEzicAWFECIh65LNZ0msI2ZOvEuNE3wD2bqX4DFGAMxYAuPr1hZprhxzBMFsQn9wGQgTWGAFfQ7hJaxmfLENsVa3MEgDKZ9AQylAW/MlXgR56ZhlEKhDzQskDavSY6y4KZVCiAb9LRGVmYpLojHXUI7og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(4326008)(55016002)(33656002)(316002)(8676002)(8936002)(110136005)(9686003)(2906002)(66946007)(86362001)(52536014)(966005)(5660300002)(186003)(26005)(64756008)(76116006)(66476007)(54906003)(66446008)(66556008)(53546011)(478600001)(71200400001)(7696005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: AcvVg6V9G+ccpCW6gVWkgEzM8JxumpZVaRS9gTP2EG0U8NJWiYENUX+kVjx5bX0wCbMosysrBKE//9xfBiippupSbn/vKZkzE1VKLptwQATfSn1XxW730OoUA3242AdDfGB64ngqo22XczheZ1UV8p5RJmr6qFqDpgItoUNUdQzG/giIfsywmvu8TFGQVto99AgnGOSaCA98OgHvofybAoansDImrQa6lmEenU1/YqjBTKYeh8ZYZ1DwaPkEx02wrHnlywmOnGk2jed3YneWpnEDdK/Z08LeV21HQkML3YZy+NhxvYhSTfwXF0VjsUbF34AOijtv/tHx6JpA9hA5yK3+t7cAUb2JzX//k7StWIQ/Xe2xT7UZRwd4rpkrZfyCroErRpBxFXBN8UWBty0hbFnU0vcYVNN3IcYO8JFBpa4s62rJ0AUyKWw/s09dJQsvvsjM3RxodcE9bev3iZ5rgja1fRGiY0kRpK0WmAdaS1Q=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff962ad-3508-492d-90e5-08d8004c0603
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 01:36:18.9932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: umDhSrdo1fnSPb/dRphpnWcfZV4vUdsCJnVpYViJ4hPd2ErxYJNiLikRlW2S+l/NO/Bhk7OipXuEudv0AURvUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6875
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LWNhbi1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNhbi1vd25lckB2Z2VyLmtlcm5lbC5vcmc+DQo+IE9uIEJl
aGFsZiBPZiBEaW5naGFvIExpdQ0KPiBTZW50OiAyMDIwxOo11MIyMsjVIDE3OjQ0DQo+IFRvOiBk
aW5naGFvLmxpdUB6anUuZWR1LmNuOyBramx1QHVtbi5lZHUNCj4gQ2M6IFdvbGZnYW5nIEdyYW5k
ZWdnZXIgPHdnQGdyYW5kZWdnZXIuY29tPjsgTWFyYyBLbGVpbmUtQnVkZGUNCj4gPG1rbEBwZW5n
dXRyb25peC5kZT47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3Vi
DQo+IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBsaW51eC1jYW5Admdlci5rZXJuZWwub3Jn
Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQo+IFN1YmplY3Q6IFtQQVRDSF0gY2FuOiBmbGV4Y2FuOiBGaXggcnVudGltZSBQTSBpbWJhbGFu
Y2Ugb24gZXJyb3INCj4gDQo+IFdoZW4gcmVnaXN0ZXJfZmxleGNhbmRldigpIHJldHVybnMgYW4g
ZXJyb3IgY29kZSwgYSBwYWlyaW5nIHJ1bnRpbWUgUE0NCj4gdXNhZ2UgY291bnRlciBkZWNyZW1l
bnQgaXMgbmVlZGVkIHRvIGtlZXAgdGhlIGNvdW50ZXIgYmFsYW5jZWQuDQo+IA0KPiBBbHNvLCBj
YWxsIHBtX3J1bnRpbWVfZGlzYWJsZSgpIHdoZW4gcmVnaXN0ZXJfZmxleGNhbmRldigpIHJldHVy
bnMgYW4gZXJyb3INCj4gY29kZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IERpbmdoYW8gTGl1IDxk
aW5naGFvLmxpdUB6anUuZWR1LmNuPg0KDQpBIHBhdGNoIGhhcyBhbHJlYWR5IGJlZW4gc2VudCBv
dXQgdG8gZml4IHRoaXMgaXNzdWU6DQpodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51
eC1jYW4vbXNnMDMwNTIuaHRtbA0KDQpSZXZpZXdlZC1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fp
bmcuemhhbmdAbnhwLmNvbT4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IC0tLQ0K
PiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyB8IDIgKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4vZmxleGNh
bi5jIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyBpbmRleA0KPiA5NGQxMGVjOTU0YTAuLmVh
MTkzNDI2ZTVhZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiAr
KysgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+IEBAIC0xNjY2LDYgKzE2NjYsOCBAQCBz
dGF0aWMgaW50IGZsZXhjYW5fcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPiAqcGRldikN
Cj4gIAlyZXR1cm4gMDsNCj4gDQo+ICAgZmFpbGVkX3JlZ2lzdGVyOg0KPiArCXBtX3J1bnRpbWVf
cHV0X25vaWRsZSgmcGRldi0+ZGV2KTsNCj4gKwlwbV9ydW50aW1lX2Rpc2FibGUoJnBkZXYtPmRl
dik7DQo+ICAJZnJlZV9jYW5kZXYoZGV2KTsNCj4gIAlyZXR1cm4gZXJyOw0KPiAgfQ0KPiAtLQ0K
PiAyLjE3LjENCg0K
