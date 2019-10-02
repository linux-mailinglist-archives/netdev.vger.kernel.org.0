Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFB6C8C2A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfJBO6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:58:49 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:47201
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726526AbfJBO6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 10:58:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMuBGFj6ATRFJ1OHSMYQiM0diecrML0GrZU4LNZtGOdArQBlSr66UYGiDryHoPrEK3QHJkn+VFRFaqinWiWVKSZYA8sxL1VOnU1XDfYF2kY0HLK3WcG6ato8a4fZmtmzTyPi3xXBYkwphRt9cpDcKeTld5EyXfySKMumVfgduLLLauxXOsVrUaMv71Ia6jtJIyjJH7dmit/+ZooSslMGPsVENtyUyUCPGCa8U0tSqZroaLDOk966jaP5lPwexzN+zV6LTPhKvehnW4zF655HgTtlhqX28fTZWLQrFqPV7vWEYdrJf8KkSPNJwOZw/8ZulyISIFpJ3iAMRXE7u/OgBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXUym/xuwhoDcexefhpoInmz4TGvBFPZI9OONkmc1cY=;
 b=VSNAXTQ/dJzEq3HnQX3MqXEyd+9VxvXTYJMd61h1gGd4cLlIfY8CohRaGr1Ivz3ie4Bo1EaSK6Bq+2bSFSe4FvNjEB1Y30KyUsVWZrkho1F0NnKaqjFFFP31q92EKLT9KmUVXffaPYw++sQItofaxL2u0lSJw5LeBrKyqPg1W7MG22ppMAOmrargPXWUTNUnfcUAYJM8WvUhexFagrgc/NxkTU5xy2MDznIrzGl0WdDA/sH+gFJ8gUHhfFbEXgutcU9cQdILC6OPfi21nvGcfYP4z+zIR+laVihLbmzSNtuRKhvVgnScU8KogR/rG2M5IRIGMjnSe6cWlJGSBRpvSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXUym/xuwhoDcexefhpoInmz4TGvBFPZI9OONkmc1cY=;
 b=MW2q0QINoEoSWFSvVo0bEb/wyim1IJE4WHHssEDsgGFMYqxbNvhHnpQ/iutTdckU5AWNQ4kwXU2uoMY5vrlY2lJVpfOlqRasl/28btZ+z1mat00iYETSamsvXrQ7hsHNY1lhYjaOZMLQz7iiQs8sd20ed6pY5sn++3FLLWIc5Os=
Received: from AM6PR0502MB3768.eurprd05.prod.outlook.com (52.133.18.139) by
 AM6PR0502MB3927.eurprd05.prod.outlook.com (52.133.19.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Wed, 2 Oct 2019 14:58:44 +0000
Received: from AM6PR0502MB3768.eurprd05.prod.outlook.com
 ([fe80::8454:9da8:7be7:be0f]) by AM6PR0502MB3768.eurprd05.prod.outlook.com
 ([fe80::8454:9da8:7be7:be0f%5]) with mapi id 15.20.2305.022; Wed, 2 Oct 2019
 14:58:44 +0000
From:   Alex Vesker <valex@mellanox.com>
To:     Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     Borislav Petkov <bp@alien8.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] mlx5: avoid 64-bit division in
 dr_icm_pool_mr_create()
Thread-Topic: [PATCH net] mlx5: avoid 64-bit division in
 dr_icm_pool_mr_create()
Thread-Index: AQHVeRqzMtt8mDGR6UGVxYBpTTGFrqdHcXwA
Date:   Wed, 2 Oct 2019 14:58:44 +0000
Message-ID: <57dc9ea7-e925-e8e8-af71-35326bb5c673@mellanox.com>
References: <20191002121241.D74DAE04C7@unicorn.suse.cz>
In-Reply-To: <20191002121241.D74DAE04C7@unicorn.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0902CA0021.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::31) To AM6PR0502MB3768.eurprd05.prod.outlook.com
 (2603:10a6:209:5::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=valex@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.138.64.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 298a0d84-18e8-4940-9032-08d74749051d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM6PR0502MB3927:|AM6PR0502MB3927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0502MB3927E1565C3B120297F57221C39C0@AM6PR0502MB3927.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(189003)(199004)(71190400001)(71200400001)(36756003)(8676002)(186003)(6486002)(6436002)(6512007)(8936002)(81156014)(229853002)(6246003)(5660300002)(66066001)(305945005)(86362001)(316002)(76176011)(66556008)(81166006)(14454004)(64756008)(31696002)(25786009)(66946007)(478600001)(66476007)(7736002)(4326008)(54906003)(110136005)(486006)(446003)(14444005)(256004)(6116002)(3846002)(11346002)(2616005)(476003)(31686004)(102836004)(53546011)(2906002)(6506007)(26005)(386003)(52116002)(99286004)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0502MB3927;H:AM6PR0502MB3768.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cSRHjFf2DUtSqL+Nydjye3qF4wQqiSW31VqOX5eTLsN3+PJ4mkwkxH2r76bLGeUOUMnuSh5M2ADZEB65QHxFb2KTx1U3EAIDl4Ol2ZtdH3GQHtEnXPm9ShlteaxCszFgFh4ccdEAJn9EtWhuK9K/BkbIWYPwHluaSDv+MUPD7VMP1WG8jGQ8lMrzbwH9T/8Lc2zJbJwvsWNBLRpUnSWxfg3bIo3g1F/WnaAHLvZUheVXnpCEtPX0DBZflWUQuFCn9LIHS58BU9ajTqWHXgncOZ3VW1AdjvdahbaRvIvmPBtvMbv3bZA74vdnxv/OwNeZBVcqcr3+So3lhux1kWzo+WOhR+xzoXDDGMaZ2NklVEhWfzCkHns8aLvWsWrr75dVD/4iiXLE7cPmq3iHmODWa4vqRgDAkk8RTJwVyCRuOm0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A256E41B2BDC73449F9B185365C9B66D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298a0d84-18e8-4940-9032-08d74749051d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 14:58:44.3910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RhEnm3ZtZ7cuDs6Q5w9/QRBwIednAItCWrqcokkUDFlPEE3kFbf2Dolfma++9ltO83A14tDLQ+uj8KtUlOUgoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3927
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMi8yMDE5IDM6MTIgUE0sIE1pY2hhbCBLdWJlY2VrIHdyb3RlOg0KPiBSZWNlbnRseSBh
ZGRlZCBjb2RlIGludHJvZHVjZXMgNjQtYml0IGRpdmlzaW9uIGluIGRyX2ljbV9wb29sX21yX2Ny
ZWF0ZSgpDQo+IHNvIHRoYXQgYnVpbGQgb24gMzItYml0IGFyY2hpdGVjdHVyZXMgZmFpbHMgd2l0
aA0KPg0KPiAgICBFUlJPUjogIl9fdW1vZGRpMyIgW2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9tbHg1X2NvcmUua29dIHVuZGVmaW5lZCENCj4NCj4gQXMgdGhlIGRpdmlz
b3IgaXMgYWx3YXlzIGEgcG93ZXIgb2YgMiwgd2UgY2FuIHVzZSBiaXR3aXNlIG9wZXJhdGlvbg0K
PiBpbnN0ZWFkLg0KPg0KPiBGaXhlczogMjljZjhmZWJkMTg1ICgibmV0L21seDU6IERSLCBJQ00g
cG9vbCBtZW1vcnkgYWxsb2NhdG9yIikNCj4gUmVwb3J0ZWQtYnk6IEJvcmlzbGF2IFBldGtvdiA8
YnBAYWxpZW44LmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWwgS3ViZWNlayA8bWt1YmVjZWtA
c3VzZS5jej4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL3N0ZWVyaW5nL2RyX2ljbV9wb29sLmMgfCAzICsrLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9zdGVlcmluZy9kcl9pY21fcG9vbC5jIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3N0ZWVyaW5nL2RyX2ljbV9w
b29sLmMNCj4gaW5kZXggOTEzZjFlNWFhYWYyLi5kN2M3NDY3ZTJkNTMgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9zdGVlcmluZy9kcl9pY21f
cG9vbC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9z
dGVlcmluZy9kcl9pY21fcG9vbC5jDQo+IEBAIC0xMzcsNyArMTM3LDggQEAgZHJfaWNtX3Bvb2xf
bXJfY3JlYXRlKHN0cnVjdCBtbHg1ZHJfaWNtX3Bvb2wgKnBvb2wsDQo+ICAgDQo+ICAgCWljbV9t
ci0+aWNtX3N0YXJ0X2FkZHIgPSBpY21fbXItPmRtLmFkZHI7DQo+ICAgDQo+IC0JYWxpZ25fZGlm
ZiA9IGljbV9tci0+aWNtX3N0YXJ0X2FkZHIgJSBhbGlnbl9iYXNlOw0KPiArCS8qIGFsaWduX2Jh
c2UgaXMgYWx3YXlzIGEgcG93ZXIgb2YgMiAqLw0KPiArCWFsaWduX2RpZmYgPSBpY21fbXItPmlj
bV9zdGFydF9hZGRyICYgKGFsaWduX2Jhc2UgLSAxKTsNCj4gICAJaWYgKGFsaWduX2RpZmYpDQo+
ICAgCQlpY21fbXItPnVzZWRfbGVuZ3RoID0gYWxpZ25fYmFzZSAtIGFsaWduX2RpZmY7DQo+ICAg
DQoNCkFsaWduIGRpZmYgaXMgcG93ZXIgb2YgMizCoCBsb29rcyBnb29kIHRvIG1lLg0KVGhhbmtz
IGZvciBmaXhpbmcgaXQgTWljaGFsLg0KDQo=
