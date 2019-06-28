Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68FA25A778
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfF1XSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:18:38 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28738
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726817AbfF1XSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 19:18:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=XIxDGF7NqbgKAyQNwB7Jcz1TGEHT5OCtC2Wl+WgVn4X3tGydEs+7wq88YyHuqXj5K/X36c6Y1pcSDDdCbKD6ECjjnvV2+jpPm6AHBPGKpJ65CjnrWdHHbUg2tC4KLjKsM0uD5RxaoMGk3iTThYPkrEJrl0NsfUs6YtmThrbfwAQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+FWFff/1qsw+Bv8jdoMHB2y02erSdVP3AA+ZBW2vOA=;
 b=gPjUx9dQGRoQ84FkNw4yp20hh9Xc8PU+vJUyFmfvagtgQqC6CrGqL+9G9Cb29DjvjRpl119wP7ryUdbA961SM33kDRuFlTYWwN6AtBrfajzdfcNCZ0LEOkk7HcIB2K3oB11cpiRWbWrSc13MKX40d4gzU0FtOFc06EougQpt2QA=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+FWFff/1qsw+Bv8jdoMHB2y02erSdVP3AA+ZBW2vOA=;
 b=ce835KkHcXp6OEAUASqY+503C8V5BAwb8gjRSSkUSUtSHbOXOAzSW52tbEmS283+UlqV8PaODx80BwV/I7GXqSQiuMboxEs9RlTxME6DDO7XhputaM7IUa5hwZOq0ilGLF8bJiGmwyyX7h6yXKtBK1wTmNnAhh/1LUOCll+FUL0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 23:18:22 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 23:18:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/10] net/mlx5e: Move to HW checksumming advertising
Thread-Topic: [net-next 03/10] net/mlx5e: Move to HW checksumming advertising
Thread-Index: AQHVLgfHeiIPxV0avUShSdoYypsdCA==
Date:   Fri, 28 Jun 2019 23:18:22 +0000
Message-ID: <20190628231759.16374-4-saeedm@mellanox.com>
References: <20190628231759.16374-1-saeedm@mellanox.com>
In-Reply-To: <20190628231759.16374-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0057.prod.exchangelabs.com (2603:10b6:a03:94::34)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f17ae99-fc8e-4853-5729-08d6fc1ee9f8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-microsoft-antispam-prvs: <DB6PR0501MB2198D596D2C4C5D937BBDF2DBEFC0@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(136003)(346002)(366004)(189003)(199004)(6512007)(186003)(71190400001)(81166006)(6916009)(478600001)(71200400001)(81156014)(476003)(3846002)(6506007)(53936002)(66946007)(66556008)(66446008)(64756008)(66476007)(25786009)(8676002)(54906003)(6486002)(486006)(446003)(73956011)(305945005)(66066001)(99286004)(4326008)(11346002)(1076003)(86362001)(7736002)(5660300002)(107886003)(52116002)(26005)(6116002)(36756003)(76176011)(2616005)(386003)(14454004)(6436002)(2906002)(8936002)(102836004)(256004)(50226002)(316002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BiFyXgIa40Zp6pslKZR/K9omj/QSwQvpgkdCUzsLOApNmw5nO+ygmjOC/rbFwsI/ab1Ty+Jb+r9yFq4tlvEFuhXmjayC7rwjW+WftAKkj04++0GcqbCx9dXQTfQCoYpz4fssQ2Qhyv0Oxtq/5p2tMKb6dAdDBxC56Ki4OtbOXo1j/vO+cJqNrjXokogl05d3qt3SiyezSU0v2xfE3esTA+97K88GqCw5qCV1vwpVZvsL52rDbWDlpzQD5kPFzXcMzF2GDtqDKtkzrIItrCDas81hNvSQWq5iy6tq7Z5NM4NNpKXuN/a0NG6HfUumqSxBPsevwqxsvFrcUe/9lFvdozvpOOy7WF7mSjMvO/wk2xIdfo3vrjCoaUi4Z03RJC0RdlpOZGJ0CTQ6uipp+i+Otaib3utaKi4Z9omB3/joEX8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f17ae99-fc8e-4853-5729-08d6fc1ee9f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 23:18:22.7041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQXJpZWwgTGV2a292aWNoIDxsYXJpZWxAbWVsbGFub3guY29tPg0KDQpUaGlzIHBhdGNo
IGNoYW5nZXMgdGhlIHdheSB0aGUgZHJpdmVyIGFkdmVydGlzZXMgaXRzIGNoZWNrc3VtIG9mZmxv
YWQNCmNhcGFiaWxpdGllcyB3aXRoaW4gdGhlIG5ldCBkZXZpY2UgZmVhdHVyZXMgYml0IG1hc2su
DQoNCkluc3RlYWQgb2YgYWR2ZXJ0aXNpbmcgcHJvdG9jb2wgc3BlY2lmaWMgY2hlY2tzdW1taW5n
IGNhcGFiaWxpdGllcw0Kd2hpY2ggYXJlIGxpbWl0ZWQgdG9kYXkgdG8gSVB2NCBhbmQgSVB2Niwg
d2UgbW92ZSB0byByZXBvcmluZw0KZ2VuZXJpYyBIVyBjaGVja3N1bW1pbmcgY2FwYWJpbGl0aWVz
Lg0KDQpUaGlzIHdpbGwgYWxsb3cgdGhlIG5ldHdvcmsgc3RhY2sgdG8gbGV0IG1seDUgZGV2aWNl
IG9mZmxvYWQgY2hlY2tzdW0NCmZvciBjYXNlcyB3aGVyZSB0aGUgSVAgaGVhZGVyIGlzIGVuY2Fw
c3VsYXRlZCB3aXRoaW4gYW5vdGhlciBwcm90b2NvbA0KYW5kIHRoZSBza2ItPnByb3RvY29sIGRv
ZXNuJ3QgaW5kaWNhdGUgb25lIG9mIHRoZSBJUCB2ZXJzaW9ucyBwcm90b2NvbCwNCnNwZWNpZmlj
YWxseSBpbiB0aGUgY2FzZSBvZiBNUExTIGxhYmVsIGVuY2Fwc3VsYXRpbmcgdGhlIElQIGhlYWRl
ciBhbmQNCnRoZSBza2ItPnByb3RvY29sIGluZGljaWF0ZXMgTVBMUyBldGhlcnR5cGUgcmF0aGVy
IHRoYW4gSVAuDQoNCk1vdmluZyB0aGUgSFdfQ1NVTSByZXBvcnRpbmcgaXMgcmVxdWlyZWQgaW4g
dGhlIGJhc2ljIG5ldCBkZXZpY2UgaHcNCmZlYXR1cmVzIG1hc2sgYW5kIGFsc28gaW4gdGhlIGV4
dGVuc2lvbnMgKHZsYW4gYW5kIGVuY3Bhc3VsYXRpb24NCmZlYXR1cmVzKSBzaW5jZSB0aGUgZXh0
ZW5zaW9ucyBhcmUgYWx3YXlzIG11bHRpcGxpZWQgYnkgdGhlIGJhc2ljDQpmZWF0dXJlcyBzZXQg
ZHVyaW5nIHRoZSBwYWNrZXQncyB0cmF2ZXJzYWwgdGhyb3VnaCB0aGUgc3RhY2sncyB0eCBmbG93
Lg0KDQpTaWduZWQtb2ZmLWJ5OiBBcmllbCBMZXZrb3ZpY2ggPGxhcmllbEBtZWxsYW5veC5jb20+
DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0t
LQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgfCA2
ICsrLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0p
DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW5fbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21h
aW4uYw0KaW5kZXggNDc4OTczNWI4YzdmLi44OTk1Y2RkNGQyNGMgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQorKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQpAQCAtNDYxNyw4
ICs0NjE3LDcgQEAgc3RhdGljIHZvaWQgbWx4NWVfYnVpbGRfbmljX25ldGRldihzdHJ1Y3QgbmV0
X2RldmljZSAqbmV0ZGV2KQ0KIAluZXRkZXYtPmV0aHRvb2xfb3BzCSAgPSAmbWx4NWVfZXRodG9v
bF9vcHM7DQogDQogCW5ldGRldi0+dmxhbl9mZWF0dXJlcyAgICB8PSBORVRJRl9GX1NHOw0KLQlu
ZXRkZXYtPnZsYW5fZmVhdHVyZXMgICAgfD0gTkVUSUZfRl9JUF9DU1VNOw0KLQluZXRkZXYtPnZs
YW5fZmVhdHVyZXMgICAgfD0gTkVUSUZfRl9JUFY2X0NTVU07DQorCW5ldGRldi0+dmxhbl9mZWF0
dXJlcyAgICB8PSBORVRJRl9GX0hXX0NTVU07DQogCW5ldGRldi0+dmxhbl9mZWF0dXJlcyAgICB8
PSBORVRJRl9GX0dSTzsNCiAJbmV0ZGV2LT52bGFuX2ZlYXR1cmVzICAgIHw9IE5FVElGX0ZfVFNP
Ow0KIAluZXRkZXYtPnZsYW5fZmVhdHVyZXMgICAgfD0gTkVUSUZfRl9UU082Ow0KQEAgLTQ2NDAs
OCArNDYzOSw3IEBAIHN0YXRpYyB2b2lkIG1seDVlX2J1aWxkX25pY19uZXRkZXYoc3RydWN0IG5l
dF9kZXZpY2UgKm5ldGRldikNCiANCiAJaWYgKG1seDVfdnhsYW5fYWxsb3dlZChtZGV2LT52eGxh
bikgfHwgbWx4NV9nZW5ldmVfdHhfYWxsb3dlZChtZGV2KSB8fA0KIAkgICAgTUxYNV9DQVBfRVRI
KG1kZXYsIHR1bm5lbF9zdGF0ZWxlc3NfZ3JlKSkgew0KLQkJbmV0ZGV2LT5od19lbmNfZmVhdHVy
ZXMgfD0gTkVUSUZfRl9JUF9DU1VNOw0KLQkJbmV0ZGV2LT5od19lbmNfZmVhdHVyZXMgfD0gTkVU
SUZfRl9JUFY2X0NTVU07DQorCQluZXRkZXYtPmh3X2VuY19mZWF0dXJlcyB8PSBORVRJRl9GX0hX
X0NTVU07DQogCQluZXRkZXYtPmh3X2VuY19mZWF0dXJlcyB8PSBORVRJRl9GX1RTTzsNCiAJCW5l
dGRldi0+aHdfZW5jX2ZlYXR1cmVzIHw9IE5FVElGX0ZfVFNPNjsNCiAJCW5ldGRldi0+aHdfZW5j
X2ZlYXR1cmVzIHw9IE5FVElGX0ZfR1NPX1BBUlRJQUw7DQotLSANCjIuMjEuMA0KDQo=
